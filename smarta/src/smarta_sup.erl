%%%----------------------------------------------------------------------
%%% File    : smarta_sup.erl
%%% Author  : Ery Lee <ery.lee@gmail.com>
%%% Purpose : smart agent supervisor
%%% Created : 12 Jan. 2010
%%% License : http://www.monit.cn/
%%%
%%% Copyright (C) 2007-2010, www.monit.cn
%%%----------------------------------------------------------------------
-module(smarta_sup).

-author("ery.lee@gmail.com").

-behavior(supervisor).

-export([start_link/0, init/1]).

start_link() ->
	supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([]) ->
	{ok, {{one_for_one, 10, 100}, []}}. 

