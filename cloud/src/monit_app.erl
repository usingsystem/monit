%%%----------------------------------------------------------------------
%%% File    : monit_app.erl
%%% Author  : Ery Lee <ery.lee@gmail.com>
%%% Purpose : monit application
%%% Created : 13 Jan 2010
%%% License : http://www.monit.cn
%%%
%%% Copyright (C) 2007-2010, www.monit.cn
%%%----------------------------------------------------------------------
-module(monit_app).

-author('ery.lee@gmail.com').

-behavior(application).

-export([start/2, stop/1]).

start(normal, _Args) ->
	{ok, SupPid} = monit_sup:start_link(),
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
	 	[{"monit object", monit_object},
         {"monit object type", monit_object_type},
         {"monit object event", monit_object_event},
         {"monit node hub", monit_node_hub},
         {"monit last", monit_last},
		 {"monit i18n", monit_i18n},
		 {"monit disco", monit_disco}
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

