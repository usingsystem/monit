%%%----------------------------------------------------------------------
%%% File    : monit_sup.erl
%%% Author  : Ery Lee <ery.lee@gmail.com>
%%% Purpose : monit server supervisor
%%% Created : 12 Jan. 2010
%%% License : http://www.monit.cn/
%%%
%%% Copyright (C) 2007-2010, www.monit.cn
%%%----------------------------------------------------------------------
-module(monit_sup).

-author("ery.lee@gmail.com").

-behavior(supervisor).

-export([start_link/0, init/1]).

start_link() ->
	supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([]) ->
    {ok, AmqpOpts} = application:get_env(amqp),
    Amqp = {amqp, {amqp, start_link, [AmqpOpts]}, 
            permanent, 10, worker, [amqp]},
	{ok, {{one_for_one, 10, 1000}, [Amqp]}}. 

