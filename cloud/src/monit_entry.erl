%%%--------------------------------------------------
%%% File    : monit_entry.erl
%%% Author  : Ery Lee <ery.lee@gmail.com>
%%% Purpose : handle entries of service and object
%%% Created : 15 Jan 2010
%%% License : http://www.monit.cn
%%%
%%% Copyright (C) 2007-2010, www.monit.cn
%%%----------------------------------------------------------------------
-module(monit_entry).

-author('ery.lee@gmail.com').

-include("elog.hrl").

-include("monit.hrl").

-import(extbif, [to_list/1]).

-behavior(gen_server).

-export([start_link/0, insert/2, insert/3]).

-export([init/1, 
        handle_call/3, 
        handle_cast/2, 
        handle_info/2, 
        terminate/2, 
        code_change/3]).

-record(state, {cassandra, entry_cf}).

-record(service_entry, {uid, name, storage}).

%%--------------------------------------------------------------------
%% Function: start_link() -> {ok,Pid} | ignore | {error,Error}
%% Description: Starts the server
%%--------------------------------------------------------------------
start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

insert(Uuid, Entries) ->
    gen_server:cast(?MODULE, {insert, Uuid, Entries}).

insert(object, Uuid, Entries) ->
    gen_server:cast(?MODULE, {insert, object, Uuid, Entries}).

%%====================================================================
%% gen_server callbacks
%%====================================================================
%%--------------------------------------------------------------------
%% Function: init(Args) -> {ok, State} |
%%                         {ok, State, Timeout} |
%%                         ignore               |
%%                         {stop, Reason}
%% Description: Initiates the server
%%--------------------------------------------------------------------
init([]) ->
    {ok, Cassandra} = cassandra:start_link("Monit"),
    EntryCF = cassandra_cf:new(Cassandra, {super, "Entry"}),
    mnesia:create_table(service_entry, [{ram_copies, [node()]}, 
        {attributes, record_info(fields, service_entry)}]),
    mnesia:add_table_copy(service_entry, node(), ram_copies),
    load_entry_types(),
    erlang:send_after(300*1000, self(), reload_entry_types),
    {ok, #state{cassandra = Cassandra, entry_cf = EntryCF}}.

load_entry_types() ->
    {ok, Records} = mysql:select(service_entries),
    lists:foreach(fun(Record) -> 
        {value, Name} = dataset:get_value(name, Record),
        {value, TypeId} = dataset:get_value(type_id, Record),
        {value, Storage} = dataset:get_value(storage, Record),
        Uid = {TypeId, list_to_atom(binary_to_list(Name))},
        mnesia:dirty_write(#service_entry{uid = Uid, name = Name, storage = Storage})
    end, Records).

%%--------------------------------------------------------------------
%% Function: %% handle_call(Request, From, State) -> {reply, Reply, State} |
%%                                      {reply, Reply, State, Timeout} |
%%                                      {noreply, State} |
%%                                      {noreply, State, Timeout} |
%%                                      {stop, Reason, Reply, State} |
%%                                      {stop, Reason, State}
%% Description: Handling call messages
%%--------------------------------------------------------------------
handle_call(Request, _From, State) ->
    ?ERROR("unexpected request: ~p", [Request]),
    {reply, {error, unexpected_request}, State}.

%%--------------------------------------------------------------------
%% Function: handle_cast(Msg, State) -> {noreply, State} |
%%                                      {noreply, State, Timeout} |
%%                                      {stop, Reason, State}
%% Description: Handling cast messages
%%--------------------------------------------------------------------
handle_cast({insert, Uuid, Entries}, #state{entry_cf = EntryCF} = State) ->
    case monit_object:lookup(Uuid) of
    {ok, #monit_object{parent = ParentId, attrs = Service}} ->
        {value, TypeId} = dataset:get_value(type_id, Service),
        {ok, #monit_object{uuid = ObjectUuid}} = monit_object:lookup(ParentId),
        lists:foreach(fun({entry, G, N, V}) -> 
            EntryCF:insert(Uuid, extbif:to_list(G), [{extbif:to_list(N), V}]),
            case mnesia:dirty_read(service_entry, {TypeId, G}) of
            [#service_entry{storage = Storage}] ->
                if
                Storage == 2 -> 
                    EntryCF:insert(ObjectUuid, extbif:to_list(G), [{extbif:to_list(N), V}]);
                true ->
                    ignore
                end;
            [] -> 
                ?WARNING("service_entry not found: ~p", [{TypeId, G}])
            end
        end, Entries);
    false ->     
        ?WARNING("service not found: ~p", [Uuid])
    end,
    {noreply, State};


handle_cast({insert, object, Uuid, Entries}, #state{entry_cf = CF} = State) ->
    ?INFO("insert object entries: ~p, ~n~p", [Uuid, Entries]),
    [CF:insert(Uuid, to_list(G), [{to_list(N), V}]) || {entry, G, N, V} <- Entries],
    {noreply, State};

handle_cast(Msg, State) ->
    ?ERROR("unexpected Msg: ~p", [Msg]),
    {noreply, State}.

%%--------------------------------------------------------------------
%% Function: handle_info(Info, State) -> {noreply, State} |
%%                                       {noreply, State, Timeout} |
%%                                       {stop, Reason, State}
%% Description: Handling all non call/cast messages
%%--------------------------------------------------------------------
handle_info(reload_entry_types, State) ->
    load_entry_types(),
    erlang:send_after(300*1000, self(), reload_entry_types),
    {noreply, State};

handle_info({'EXIT', Cassandra, _Reason}, #state{cassandra = Cassandra} = State) ->
    {ok, NewCass} = cassandra:start_link("Monit"),
    EntryCF = cassandra_cf:new(NewCass, "Entry"),
    {noreply, State#state{cassandra = NewCass, entry_cf = EntryCF}};

handle_info(Info, State) ->
    ?ERROR("unexpected info: ~p", [Info]),
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

