%%%----------------------------------------------------------------------
%%% File    : monit_node_app.erl
%%% Author  : Ery Lee <ery.lee@gmail.com>
%%% Purpose : monit node application
%%% Created : 13 Jan 2010
%%% License : http://www.monit.cn
%%%
%%% Copyright (C) 2007-2010, www.monit.cn
%%%----------------------------------------------------------------------
-module(monit_node_app).

-author('ery.lee@gmail.com').

-include("elog.hrl").

-export([start/0, cluster/1, stop/0]).

-behavior(application).

-export([start/2, stop/1]).

start() ->
    application:start(sasl),
    application:start(crypto),
    start_mnesia(),
    init_elog(),
    inets:start(),
    application:start(core),
    application:start(sesnmp),
    application:start(monit_node),
    ?PRINT("~nfinished.~n", []).

start_mnesia() ->
    mnesia:delete_schema([node()]),
    mnesia:create_schema([node()]),
    mnesia:start(),
    mnesia:wait_for_tables(mnesia:system_info(local_tables), infinity).

init_elog() ->
    %start elog
    {ok, [[LogPath]]} = init:get_argument(log_path),
    {ok, [[LogLevel]]} = init:get_argument(log_level),
    elog:init(list_to_integer(LogLevel), LogPath).

stop() ->
    application:stop(monit_node),
    application:stop(sesnmp),
    application:stop(mysql),
    application:stop(core),
    mnesia:stop(),
    application:stop(crypto),
    application:stop(sasl),
    ?PRINT("~nstopped.~n", []).

cluster(Node) ->
    case net_adm:ping(Node) of
    pang -> {error, "cannot connect to node"};
    pong -> {ok, [node() | nodes()]}
    end.

start(normal, _Args) ->
	{ok, SupPid} = monit_node_sup:start_link(),
    {ok, PluginOpts} = application:get_env(plugin),
	lists:foreach(
		fun({Name, Thunk}) when is_function(Thunk) -> 
			io:format("~n~s: ~s is starting...", [node(), Name]),
			Thunk(),
			io:format("[done]~n");
		   ({Name, Server}) when is_atom(Server) ->
			io:format("~n~s: ~s is starting...", [node(), Name]),
			start_child(SupPid, Server),
			io:format("[done]~n");
           ({Name, Server, Opts}) when is_atom(Server) ->
			io:format("~n~s: ~s is starting...", [node(), Name]),
			start_child(SupPid, Server, Opts),
			io:format("[done]~n")
		end,
	 	[{"monit plugin", monit_plugin, PluginOpts},
         {"monit last", monit_last},
		 {"monit sched", monit_sched},
         {"monit disco node", monit_node_disco},
         {"monit node", monit_node}
		]),
	{ok, SupPid}.	

%%Internal functions
start_child(SupPid, Name) ->
    {ok, _ChiId} = supervisor:start_child(SupPid, worker_spec(Name)).
start_child(SupPid, Name, Opts) ->
    {ok, _ChiId} = supervisor:start_child(SupPid, worker_spec(Name, Opts)).

worker_spec(Name) ->
    {Name, {Name, start_link, []}, 
        permanent, 10, worker, [Name]}.
worker_spec(Name, Opts) ->
    {Name, {Name, start_link, [Opts]}, 
        permanent, 10, worker, [Name]}.

stop(_) ->
	ok.

