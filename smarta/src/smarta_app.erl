%%%----------------------------------------------------------------------
%%% File    : smarta_app.erl
%%% Created : 13 Jan 2010
%%% License : http://www.monit.cn
%%%
%%% Copyright (C) 2007-2010, www.monit.cn
%%%----------------------------------------------------------------------
-module(smarta_app).

-author('ery.lee@gmail.com').

-include("elog.hrl").

%boot
-export([start/0, stop/0]).

-behavior(application).

-export([start/2, stop/1]).

start() ->
    [start2(App) || App <- [kernel, stdlib, sasl, crypto, mnesia, exmpp, elog, sesnmp, smarta]].

start2(mnesia) ->
    mnesia:delete_schema([node()]),
    mnesia:create_schema([node()]),
    mnesia:start(),
    mnesia:wait_for_tables(mnesia:system_info(local_tables), infinity);

start2(elog) ->
    %start elog
    {ok, [[LogPath]]} = init:get_argument(log_path),
    {ok, [[LogLevel]]} = init:get_argument(log_level),
    elog:init(list_to_integer(LogLevel), LogPath);

start2(App) ->
    application:start(App).

stop() ->
    [stop2(App) || App <- [smarta, sesnmp, mnesia]]. %, mnesia, exmpp, crypto, sasl

stop2(mnesia) ->
    mnesia:stop();

stop2(App) ->
    application:stop(App).

start(normal, _Args) ->
	{ok, SupPid} = smarta_sup:start_link(),
    {ok, PluginOpts} = application:get_env(plugin),
    {ok, AgentOpts} = application:get_env(agent),
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
	 	[{"smarta agent", smarta, AgentOpts},
         {"smarta plugin", smarta_plugin, PluginOpts},
		 {"smarta last", smarta_last},
		 {"smarta sched", smarta_sched},
		 {"smarta entry", smarta_entry},
		 {"smarta disco", smarta_disco},
		 %{"smarta alert", smarta_alert},
		 {"smarta bot", smarta_bot}
		]),
	{ok, SupPid}.	

stop(_) ->
	ok.

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
