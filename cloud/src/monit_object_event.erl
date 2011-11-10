%%%----------------------------------------------------------------------
%%% File    : monit_object_event.erl
%%% Author  : Ery Lee <ery.lee@gmail.com>
%%% Purpose : management object event
%%% Created : 15 May 2010
%%% License : http://www.monit.cn
%%%
%%% Copyright (C) 2007-2010, www.monit.cn
%%%----------------------------------------------------------------------
-module(monit_object_event).

-author('ery.lee@gmail.com').

-include("elog.hrl").

-include("monit.hrl").

-import(monit_object_type, [class_id/1, class_tab/1, class_name/1]).

-export([start_link/0, 
         attach/2, 
         notify/2, 
         detach/2,
         stop/0]). 

%%object changed event

-behavior(gen_server).

%callback
-export([init/1, 
		 handle_call/3, 
		 handle_cast/2, 
		 handle_info/2, 
		 terminate/2, 
		 code_change/3]).

%%--------------------------------------------------------------------
%% Function: start_link() -> {ok,Pid} | ignore | {error,Error}
%% Description: Starts the server
%%--------------------------------------------------------------------
start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

attach(Hook, Listener) when is_pid(Listener) ->
    gen_server:call(?MODULE, {attach, Hook, Listener}).

notify(Hook, Event) ->
    gen_server:cast(?MODULE, {notify, Hook, Event}).

detach(Hook, Listener) when is_pid(Listener) ->
    gen_server:call(?MODULE, {detach, Hook, Listener}).

stop() ->
	gen_server:call(?MODULE, stop).

%%--------------------------------------------------------------------
%% Function: init(Args) -> {ok, State} |
%%                         {ok, State, Timeout} |
%%                         ignore               |
%%                         {stop, Reason}
%% Description: Initiates the server
%%--------------------------------------------------------------------
init([]) ->
    mysql:delete(object_changed),
    ets:new(object_changed_listener, [bag, protected, named_table]),
    erlang:send_after(60 * 1000, self(), sync_object_changes),
    {ok, state}.

%%--------------------------------------------------------------------
%% Function: %% handle_call(Request, From, State) -> {reply, Reply, State} |
%%                                      {reply, Reply, State, Timeout} |
%%                                      {noreply, State} |
%%                                      {noreply, State, Timeout} |
%%                                      {stop, Reason, Reply, State} |
%%                                      {stop, Reason, State}
%% Description: Handling call messages
%%--------------------------------------------------------------------
handle_call({attach, Hook, Listener}, _From, State) ->
    ets:insert(object_changed_listener, {Hook, Listener}),
    {reply, ok, State};

handle_call({detach, Hook, Listener}, _From, State) ->
    ets:delete_object(object_changed_listener, {Hook, Listener}),
    {reply, ok, State};

handle_call(stop, _From, State) ->
	{stop, normal, ok, State};

handle_call(Req, _From, State) ->
	?ERROR("unexpected requrest: ~p", [Req]),
    {reply, ok, State}.
%%--------------------------------------------------------------------
%% Function: handle_cast(Msg, State) -> {noreply, State} |
%%                                      {noreply, State, Timeout} |
%%                                      {stop, Reason, State}
%% Description: Handling cast messages
%%--------------------------------------------------------------------
handle_cast({notify, Hook, Event}, State) ->
    Listeners = ets:lookup(object_changed_listener, Hook),
    [ Listener ! Event || {_Hook, Listener} <- Listeners ],
    {noreply, State};

handle_cast(Msg, State) ->
    ?ERROR("unexpected msg: ~p", [Msg]),
    {noreply, State}.

%%--------------------------------------------------------------------
%% Function: handle_info(Info, State) -> {noreply, State} |
%%                                       {noreply, State, Timeout} |
%%                                       {stop, Reason, State}
%% Description: Handling all non call/cast messages
%%--------------------------------------------------------------------
handle_info(sync_object_changes, State) ->
	case mysql:select(object_changed) of
    {ok, Changes} ->
        process_changes(Changes);
    {error, Reason} -> 
        ?ERROR("~p", [Reason])
	end,
	erlang:send_after(15 * 1000, self(), sync_object_changes),
    {noreply, State};

handle_info(Info, State) ->
    ?ERROR("unexpected info: ~p", [Info]),
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%--------------------------------------------------------------------
%%% Internal functions
%%--------------------------------------------------------------------
process_changes([]) ->
    ok;

process_changes([Change | T]) ->
    {value, Id} = dataset:get_value(id, Change),
    try process_change(Change) of
    _ -> mysql:delete(object_changed, Id)
    catch
    _:Ex -> ?ERROR("~p~n~p", [Ex, erlang:get_stacktrace()]) 
    end,
    process_changes(T).

process_change(Change) ->
    {value, Oper} = dataset:get_value(oper_type, Change),
    process_change(Oper, Change).

%%add object 
process_change(?OPER_ADD, Change) ->
    {value, Id} = dataset:get_value(object_id, Change),
    {value, ClassId} = dataset:get_value(object_class, Change),
    Class = class_name(ClassId),
    Object = monit_object:load({Class, Id}),
    monit_object:add(Object),
    notify({added, Class}, {added, Class, Object});

%%detete entry 
process_change(?OPER_DELETE, Change) ->
    ?INFO("oper delete: ~p", [Change]),
    {value, Id} = dataset:get_value(object_id, Change),
    {value, ClassId} = dataset:get_value(object_class, Change),
    Class = class_name(ClassId),
    case monit_object:lookup({Class, Id}) of
    {ok, #monit_object{dn = Dn} = _Object} ->
        monit_object:delete({Class, Id}),
        notify({deleted, Class}, {deleted, Class, Dn});
    false ->
        ?ERROR("cannot find object: ~p", [{Class, Id}])
    end;

%%update entry 
process_change(?OPER_UPDATE, Change) ->
    {value, ObjectId} = dataset:get_value(object_id, Change),
    {value, ClassId} = dataset:get_value(object_class, Change),
    Class = class_name(ClassId),
    case monit_object:lookup({Class, ObjectId}) of
    {ok, _Object} ->
        NewObject = monit_object:load({Class, ObjectId}),
        monit_object:update(NewObject),
        notify_subtree_updated(NewObject);
    false ->
        ?ERROR("cannot find object: ~p", [{Class, ObjectId}])
    end;

process_change(Oper, Change) ->
    ?ERROR("unexpected oper ~p on ~p ", [Oper, Change]).

notify_subtree_updated(#monit_object{id = {Class, ObjectId}} = Object) ->
    %?INFO("notify subtree updated: ~p", [{Class, ObjectId}]),
    notify_object_updated(Object),
    Children = mnesia:dirty_index_read(monit_object, 
        {Class, ObjectId}, #monit_object.parent),
    lists:foreach(fun(Child) -> 
        notify_subtree_updated(Child)
    end, Children).

notify_object_updated(#monit_object{class = Class} = Object) ->
    %%Should update children of this object
    notify({updated, Class}, {updated, Class, Object}).

