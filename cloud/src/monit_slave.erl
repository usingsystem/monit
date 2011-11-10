%%%----------------------------------------------------------------------
%%% File    : monit_slave.erl
%%% Author  : Ery Lee <ery.lee@gmail.com>
%%% Purpose : Monit slave startup 
%%% Created : 20 May 2010
%%% License : http://www.monit.cn
%%%
%%% Copyright (C) 2007-2010, www.monit.cn
%%%----------------------------------------------------------------------
-module(monit_slave).

-include("elog.hrl").

-include("monit.hrl").

-export([start/0, stop/0]).

-behavior(application).

-export([start/2, stop/1]).

start() ->
    init_elog(),
    [start1(App) || App <- [crypto, mnesia, core, mysql, emongo, monit_slave]].

init_elog() ->
    {ok, [[Sid]]} = init:get_argument(sid),
    {ok, [[LogLevel]]} = init:get_argument(log_level),
    elog:init(list_to_integer(LogLevel), "var/log/slave" ++ Sid ++ ".log").

start1(mnesia) ->
    case mnesia:system_info(extra_db_nodes) of
    [] ->
        mnesia:delete_schema([node()]),
        mnesia:create_schema([node()]);
    _ ->
        ok
    end,
    mnesia:start(),
    mnesia:wait_for_tables(mnesia:system_info(local_tables), infinity);

start1(App) ->
    application:start(App).

stop() ->
    [stop1(App) || App <- [monit_slave, mysql, emongo, core, mnesia, crypto]].

stop1(mnesia) ->
	mnesia:stop();

stop1(App) ->
    application:stop(App).

%%application callbacks
start(normal, _Args) ->
	{ok, SupPid} = monit_slave_sup:start_link(), 
	lists:foreach(
		fun({Name, Thunk}) when is_function(Thunk) -> 
			io:format("~n~s: ~s is starting...", [node(), Name]),
			Thunk(),
			io:format("[done]~n");
		   ({Name, Server}) when is_atom(Server) ->
			io:format("~n~s: ~s is starting...", [node(), Name]),
			start_child(SupPid, Server),
			io:format("[done]~n")
		end,
	 	[{"monit object", monit_object},
         {"monit aggre", monit_aggre},
         {"monit metric", monit_metric},
         {"monit flap", monit_flap},
         {"monit status", monit_status}
		]),
    {ok, SupPid}.

stop(_) ->
	ok.

%%Internal functions
start_child(SupPid, Name) ->
    {ok, _ChiId} = supervisor:start_child(SupPid, worker_spec(Name)).

worker_spec(Name) ->
    {Name, {Name, start_link, []}, 
        permanent, 10, worker, [Name]}.

