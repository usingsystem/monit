%%%----------------------------------------------------------------------
%%% File    : monit_disco.erl
%%% Author  : Ery Lee <ery.lee@gmail.com>
%%% Purpose : monit disco hub
%%% Created : 01 Apr 2010
%%% License : http://www.monit.cn
%%%
%%% Copyright (C) 2007-2010, www.monit.cn
%%%----------------------------------------------------------------------
-module(monit_disco).

-author('ery.lee@gmail.com').

-include("elog.hrl").

-include("monit.hrl").

-include_lib("exmpp/include/exmpp.hrl").

-include_lib("exmpp/include/exmpp_client.hrl").

-import(extbif, [to_list/1]).

-import(monit_object_type, [class_id/1, class_name/1]).

%%api
-export([start_link/0, dispatch/1]).

-behavior(gen_server).

%%callback
-export([init/1, 
        handle_call/3, 
        handle_cast/2, 
        handle_info/2, 
        terminate/2, 
        code_change/3 ]).

-record(state, {consumer_tag}).

-record(disco_task, {task_id, object_id, attrs}).

-record(disco_type, {id, object_type, command, args, service_type, external}).

%%--------------------------------------------------------------------
%% Function: start_link() -> {ok,Pid} | ignore | {error,Error}
%% Description: Starts the server
%%--------------------------------------------------------------------
start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

dispatch(Task) ->
    gen_server:cast(?MODULE, {dispatch, Task}).

init([]) ->
    %%cache disco types
    mnesia:create_table(disco_type,
        [{ram_copies, [node()]}, {index, [object_type]},
         {attributes, record_info(fields, disco_type)}]),
    cache_disco_types(),
    %%disco tasks
    mnesia:create_table(disco_task,
        [{ram_copies, [node()]}, {index, [object_id]},
         {attributes, record_info(fields, disco_task)}]),
    %%consume amqp
    amqp:queue(<<"disco.request">>),
    amqp:queue(<<"disco.reply">>),
    {ok, Tag} = amqp:consume("disco.reply", self()),
    %%register xmpp callbacks
    %%register object event callbacks
    Hooks = [{added, host}, 
             {updated, host}, 
             {added, device}, 
             {updated, device}],
    [monit_object_event:attach(Hook, self()) || Hook <- Hooks],
    erlang:send_after(120 * 1000, self(), check_redisco),
    {ok, #state{consumer_tag = Tag}}.

handle_call(Req, _From, State) ->
    ?ERROR("unexpected request: ~p", [Req]),
    {reply, ok, State}.

handle_cast({dispatch, #disco_task{object_id = ObjectId, attrs = Task} = TaskObject}, State) ->
    try transform(ObjectId, Task) of
    {ok, NewTask} -> 
        ?INFO("dispatch disco task to node: ~n~p", [NewTask]),
        amqp:send(<<"disco.request">>, term_to_binary({task, NewTask})),
        mnesia:dirty_write(TaskObject)
    catch 
    _:Err ->
        ?ERROR("transform disco task error: ~p", [Err])
    end,
    {noreply, State};

handle_cast(Msg, State) ->
    ?ERROR("unexpected msg: ~p", [Msg]),
    {noreply, State}.

handle_info({Event, _Class, Object}, State) 
    when (Event == added) or (Event == updated) ->
    do_disco(Object),
    {noreply, State};

handle_info({deliver, <<"disco.reply">>, _Properties, Payload}, State) ->
    case binary_to_term(Payload) of
    {TaskId, error, Summary} ->
        process_disco_result({TaskId, error, Summary});
    {TaskId, ok, Summary, Services} ->
        process_disco_result({TaskId, ok, Summary, Services})
    end,
    {noreply, State};

handle_info(check_redisco, State) ->
    {ok, Hosts} = mysql:select(hosts, {discovery_state, 2}),
    {ok, Devices} = mysql:select(devices, {discovery_state, 2}),
    Hosts1 = [{host, Host} || Host <- Hosts],
    Devices1 = [{device, Device} || Device <- Devices],
    lists:foreach(fun({Class, Object}) -> 
        {value, Id} = dataset:get_value(id, Object),
        do_disco(#monit_object{id = {Class, Id}, attrs = Object})
    end, Hosts1 ++ Devices1),
    erlang:send_after(15 * 1000, self(), check_redisco),
    {noreply, State};

handle_info(recache_disco_types, State) ->
    cache_disco_types(),
    {noreply, State};

handle_info(Info, State) ->
	?ERROR("unexpected info got: ~p", [Info]),
    {noreply, State}.

terminate(_Reason, #state{consumer_tag = Tag} = _State) ->
    amqp:cancel(Tag),
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%--------------------------------------------------------------------
%%% Internal functions
%%--------------------------------------------------------------------
cache_disco_types() ->
    {ok, Records} = mysql:select(disco_types),
    lists:foreach(fun(Record) -> 
        {value, Id} = dataset:get_value(id, Record),
        {value, ObjectClass} = dataset:get_value(object_class, Record),
        {value, ObjectType} = dataset:get_value(object_type, Record),
        {value, Command} = dataset:get_value(command, Record),
        {value, Args} = dataset:get_value(args, Record),
        {value, ServiceType} = dataset:get_value(service_type, Record),
        {value, External} = dataset:get_value(external, Record),
        mnesia:dirty_write(#disco_type{id = Id, object_type = {class_name(ObjectClass), ObjectType},
               command = Command, args = Args, service_type = ServiceType, external = External})
    end, Records),
    erlang:send_after(10*60*1000, self(), recache_disco_types).

do_disco(#monit_object{attrs = Mo} = Object) ->
    {value, State} = dataset:get_value(discovery_state, Mo),
    do_disco(State, Object).

do_disco(1, _Object) -> %%discovered
    ignore;

do_disco(_, #monit_object{id={Class, Id}, attrs = Mo} = _Object) ->
    update_disco_state(Class, Id, 3),
    Tasks = create_disco_tasks(Class, Id, Mo),
    [dispatch(Task) || Task <- Tasks].

create_disco_tasks(Class, Id, Mo) ->
    {value, MoType} = dataset:get_value(type_id, Mo),
    {value, TenantId} = dataset:get_value(tenant_id, Mo),
    DiscoTypes = find_disco_types(Class, MoType),
    lists:map(fun(DiscoType) -> 
        TaskId = list_to_binary(uuid:gen()),
        Command = DiscoType#disco_type.command,
        External = DiscoType#disco_type.external,
        ServiceType = DiscoType#disco_type.service_type,
        Params = DiscoType#disco_type.args,
        Attrs = [{id, TaskId},
                 {command, Command}, 
                 {external, External}, 
                 {service_type, ServiceType}, 
                 {params, Params}, 
                 {tenant_id, TenantId}],
        #disco_task{task_id = TaskId,
                    object_id = {Class, Id},
                    attrs = Attrs}
    end, DiscoTypes).

find_disco_types(Class, TypeId) ->
    ParentTypes = monit_object_type:parent_types({Class, TypeId}),
    find_disco_types2([{Class, TypeId} | ParentTypes], []).

find_disco_types2([], Acc) ->
    lists:flatten(Acc);

find_disco_types2([{Class, TypeId} | T], Acc) ->
    Types = mnesia:dirty_index_read(disco_type, {Class, TypeId}, #disco_type.object_type), 
    find_disco_types2(T, [Types | Acc]).

process_disco_result({TaskId, error, _Summary}) ->
    case mnesia:dirty_read(disco_task, TaskId) of
    [#disco_task{object_id = {Class, Id}}] ->
        mnesia:dirty_delete(disco_task, TaskId),
        update_disco_state(Class, Id, 1);
    [] ->
        ?ERROR("cannot find task with id: ~p", [TaskId])
    end;

process_disco_result({TaskId, ok, _Summary, Items}) ->
    %?INFO("~p, ~p, ~p, ~p", [TaskId, ok, Summary, Services]),
    case mnesia:dirty_read(disco_task, TaskId) of
    [#disco_task{object_id = {ObjectClass, ObjectId}, attrs = Task}] ->
        save_entries({ObjectClass, ObjectId}, find_entry(Items)),
        Services = find_service(Items),
        CreatedAt = {datetime, {date(), time()}},
        {value, TenantId} = dataset:get_value(tenant_id, Task),
        {value, ServiceType} = dataset:get_value(service_type, Task),
        lists:foreach(
            fun({service, C, N, P, S}) -> 
                Service1 = [{tenant_id, TenantId}, 
                {type_id, ServiceType}, 
                {created_at, CreatedAt},
                {object_type, class_id(ObjectClass)}, 
                {object_id, ObjectId},
                {command, to_list(C)},
                {name, to_list(N)},
                {params, P},
                {summary, S}],
                Res = mysql:insert(disco_services, Service1),
                ?INFO("~p", [Res])
        end, Services),
        mnesia:dirty_delete(disco_task, TaskId),
        update_disco_state(ObjectClass, ObjectId, 1);
    [] ->
        ?ERROR("cannot find task with id: ~p", [TaskId])
    end.

save_entries(_OID, []) ->
    pass;    
save_entries(OID, Entries) ->
    case monit_object:lookup(OID) of
    {ok, #monit_object{dn = Dn, class = Class}} ->
        ?INFO("save entries: ~p", [OID]),
        if
        Class == device ->
            check_system(Dn, Entries);
        true ->
            pass
        end;
        %monit_entry:insert(object, Dn, Entries);
    false ->
        ?WARNING("cannot find object: ~p", [OID])
    end.

check_system(Dn, Entries) ->
    case find_sysoid(Entries) of
    {ok, OID} ->
        case mysql:select(device_oids, {oid, OID}) of
        {ok, [Record]} ->
            {value, Type} = dataset:get_value(type, Record),
            {value, Vendor} = dataset:get_value(vendor, Record),
            Res = mysql:update(devices, [{dev_oid, OID}, 
                {dev_type, Type}, {dev_vendor, Vendor}], {dn, Dn}),
            ?INFO("~p", [Res]);
        {ok, []} ->
            ?WARNING("cannot find device oid: ~p", [OID]);
        {error, Error} ->
            ?ERROR("mysql error: ~p", [Error])
        end;
    false ->
        ok
    end.

find_sysoid([]) ->
    false;
find_sysoid([{entry, system, "sysObjectID", OID}|_T]) ->
    {ok, OID};
find_sysoid([_|T]) ->
    find_sysoid(T).

find_entry(Items) ->
    find_entry(Items, []).
find_entry([], Acc) ->
    Acc;
find_entry([{entry, G, N, V}|Items], Acc) ->
    find_entry(Items, [{entry, G, N, V}|Acc]);
find_entry([_|Items], Acc) ->
    find_entry(Items, Acc).

find_service(Items) ->
    find_service(Items, []).
find_service([], Acc) ->
    Acc;
find_service([{service, _C, _N, _P, _S} = Service|Items], Acc) ->
    find_service(Items, [Service|Acc]);
find_service([{service, _C, _N, _P, _S, _A} = Service|Items], Acc) ->
    find_service(Items, [Service|Acc]);
find_service([_|Items], Acc) ->
    find_service(Items, Acc).
    
update_disco_state(host, Id, State) ->
    mysql:update(hosts, [{discovery_state, State}], {id, Id});

update_disco_state(device, Id, State) ->
    mysql:update(devices, [{discovery_state, State}], {id, Id}).

transform(ObjectId, Task) ->
    {value, Params} = dataset:get_value(params, Task, undefined),
    NewParams = parse_params(ObjectId, Task, Params),
    {ok, dataset:key_replace(params, Task, {params, NewParams})}.

parse_params(ObjectId, Task, Params0) ->
    Params = to_list(Params0),
    ParamList = 
    lists:map(fun(S) -> 
        Idx = string:chr(S, $=),
        Key = string:substr(S, 1, Idx -1),
        Val = string:substr(S, Idx + 1),
        Val1 = 
        case Val of
        "${" ++ Var ->
            Var1 = string:substr(Var, 1, length(Var) - 1),
            parsevar(ObjectId, Task, Var1);
        _ -> 
            Val
        end,
        {Key, to_list(Val1)}
    end, string:tokens(Params, "&")),
    string:join([Key ++ "=" ++ Val || {Key, Val} <- ParamList], "&").

parsevar(ObjectId, _Task, Var) ->
    {ok, #monit_object{attrs = Mo}} = monit_object:lookup(ObjectId),
    case Var of
    "host." ++ Col ->
        {value, Val} = dataset:get_value(list_to_atom(Col), Mo),
        Val;
    "device." ++ Col ->
        {value, Val} = dataset:get_value(list_to_atom(Col), Mo),
        Val;
    _ -> 
        throw(unsupported_var)
    end.

