%%%----------------------------------------------------------------------
%%% File    : monit.erl
%%% Author  : Ery Lee <ery.lee@gmail.com>
%%% Purpose : Monit startup 
%%% Created : 15 Jan 2010
%%% License : http://www.monit.cn
%%%
%%% Copyright (C) 2007-2010, www.monit.cn
%%%----------------------------------------------------------------------
-module(monit).

-include("elog.hrl").

-include("monit.hrl").

-import(extbif, [to_list/1, to_binary/1]).

-export([start/0, 
        run/0, 
        stop/0]).

start() ->
    init_elog(),
    [start(App) || App <- [crypto, mnesia, 
        core, mysql, emongo, monit, slaves]],
    ?PRINT("~nfinished.~n", []).

init_elog() ->
    {ok, [[LogPath]]} = init:get_argument(log_path),
    {ok, [[LogLevel]]} = init:get_argument(log_level),
    elog:init(list_to_integer(LogLevel), LogPath).

start(mnesia) ->
    case mnesia:system_info(extra_db_nodes) of
    [] ->
        mnesia:delete_schema([node()]),
        mnesia:create_schema([node()]);
    _ ->
        ok
    end,
    mnesia:start(),
    mnesia:wait_for_tables(mnesia:system_info(local_tables), infinity);

start(slaves) ->
    io:format("\nstarting slaves ...\n"),
	Slaves = case init:get_argument(slaves) of 
		{ok, [[N]]} -> list_to_integer(N);
		_ -> 2
	end,
	{ok, [PaList]} = init:get_argument(pa),
    Path = string:join(PaList, " "),
	PathArg = "-pa " ++ Path,
	ConfArg = "-config " ++  "etc/monit/slave.config",
	MnesiaArg = "-mnesia extra_db_nodes \['"  ++ atom_to_list(node()) ++ "'\]",
	StartArg = "-s reloader -s monit_slave",
    {ok, [[LogLevel]]} = init:get_argument(log_level),
	lists:foreach(fun(I) -> 
		SlaveName = list_to_atom("monit_slave" ++ integer_to_list(I)),
        io:format("\nstarting ~p\n", [SlaveName]),
		SaslArg = "-boot start_sasl -sasl sasl_error_logger \\{file,\\\"var/log/slave" ++ integer_to_list(I) ++ "_sasl.log\\\"\\}",
        MnesiaDir = "-mnesia dir \\\"var/data/slave" ++ integer_to_list(I) ++ "\\\"",
		Args = string:join(["+P 10000", PathArg, ConfArg, SaslArg, MnesiaDir, MnesiaArg, StartArg, "-sid", integer_to_list(I), "-log_level", LogLevel], " "),
		SlaveNode = pool:start(SlaveName,  Args),
		io:format("\n~p is started.\n", [SlaveNode])
	end, lists:seq(1, Slaves)),
	ok;

start(App) ->
    application:start(App).

run() ->
    %clean flapping status
    mysql:update(services, [{is_flapping, 0}, 
        {flap_percent_state_change, 0}], {is_flapping, 1}),
    %load objects
    [load(Class, Tab) || {Class, Tab} <- [
        {host, hosts}, 
        {device, devices}, 
        {app, apps}, 
        {site, sites}, 
        {service, services}]
    ],
    ok.
    
stop() ->
    [stop(App) || App <- [slaves, monit, sesnmp, 
        mysql, core, exmpp, mnesia, crypto, sasl]].

stop(mnesia) ->
	mnesia:stop();

stop(App) ->
    application:stop(App).

%%internal functions
load(Class, Tab) ->
    load(Class, Tab, 0, 2000).

load(Class, Tab, First, Limit) ->
    Sql = ["select id from ", atom_to_list(Tab), 
           " where id > ", integer_to_list(First), 
           " order by id limit ", integer_to_list(Limit), ";"],
	{ok, Records} = mysql:sql_query(Sql),
    MaxId = 
    lists:foldl(fun(Record, _Acc) -> 
        {value, Id} = dataset:get_value(id, Record),
        Object = monit_object:load({Class, Id}),
        monit_object:add(Object),
        notify(added, Class, Object),
        Id
    end, First, Records),
    case length(Records) < Limit of
    true -> finished;
    false -> load(Class, Tab, MaxId, Limit)
    end.

notify(added, Class, Object) ->
    monit_object_event:notify({added, Class}, {added, Class, Object}).

