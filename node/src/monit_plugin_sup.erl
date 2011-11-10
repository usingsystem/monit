%%%----------------------------------------------------------------------
%%% File    : monit_plugin_sup.erl
%%% Author  : Ery Lee <ery.lee@gmail.com>
%%% Purpose : plugin cluster supervisor.
%%% Created : 27 Jan. 2010
%%% License : http://www.monit.cn
%%%
%%% Copyright (C) 2007-2010, www.opengoss.com 
%%%----------------------------------------------------------------------
-module(monit_plugin_sup).

-include("elog.hrl").

-behaviour(supervisor).

%% --------------------------------------------------------------------
%% External exports
%% --------------------------------------------------------------------
-export([start_link/1]).

%% --------------------------------------------------------------------
%% Internal exports
%% --------------------------------------------------------------------
-export([init/1]).

%% ====================================================================
%% External functions
%% ====================================================================
start_link(Opts) ->
  supervisor:start_link({local, ?MODULE}, ?MODULE, Opts).


%% ====================================================================
%% Server functions
%% ====================================================================
%% --------------------------------------------------------------------
%% Func: init/1
%% Returns: {ok,  {SupFlags,  [ChildSpec]}} |
%%          ignore                          |
%%          {error, Reason}
%% --------------------------------------------------------------------
init(Opts) -> 
    {value, PoolSize} = dataset:get_value(pool_size, Opts, 8),
    { 
      ok, {{one_for_one, 10, 1000 },
      [ begin
          Id = list_to_atom("monit_plugin" ++ integer_to_list(I)), 
          {Id, {monit_plugin, start_link, [Id, Opts]}, permanent, brutal_kill, worker, [monit_plugin]}
        end
        || I <- lists:seq(1, PoolSize)]
      }
    }.


