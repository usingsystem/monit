%%%----------------------------------------------------------------------
%%% File    : monit_node_disco.erl
%%% Author  : Ery Lee <ery.lee@gmail.com>
%%% Purpose : monit disco node
%%% Created : 01 Apr 2010
%%% License : http://www.monit.cn
%%%
%%% Copyright (C) 2007-2010, www.monit.cn
%%%----------------------------------------------------------------------
-module(monit_node_disco).

-author('ery.lee@gmail.com').

-include("elog.hrl").

-import(extbif, [to_list/1]).

%%api
-export([start_link/0]).

-behavior(gen_server).

%%callback
-export([init/1, 
        handle_call/3, 
        handle_cast/2, 
        handle_info/2, 
        terminate/2, 
        code_change/3 ]).

-record(state, {consumer_tag}).

%%--------------------------------------------------------------------
%% Function: start_link() -> {ok,Pid} | ignore | {error,Error}
%% Description: Starts the server
%%--------------------------------------------------------------------
start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init([]) ->
    {ok, _} = amqp:queue(<<"disco">>),
    {ok, Tag} = amqp:consume("disco", self()),
    io:format("monit disco node is starting...[done]~n"),
    {ok, #state{consumer_tag = Tag}}.

handle_call(Req, _From, State) ->
    ?ERROR("unexpected request: ~p", [Req]),
    {reply, ok, State}.

handle_cast({result, Result}, State) ->
    ?INFO("disco result: ~p", [Result]),
    amqp:send(<<"disco-result">>, term_to_binary(Result)),
    {noreply, State}.

handle_info({deliver, <<"disco">>, _Properties, Payload}, State) ->
    case binary_to_term(Payload) of
    {task, Task} ->
        Self = self(),
        spawn(fun() -> 
            Result = discover(Task),
            gen_server:cast(Self, {result, Result})
        end);
    Other ->
        ?WARNING("~p", [Other])
    end,
    {noreply, State};

handle_info(Info, State) ->
	?ERROR("unexpected info received: ~n ~p", [Info]),
    {noreply, State}.

terminate(_Reason, #state{consumer_tag = Tag} = _State) ->
    amqp:cancel(Tag),
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

discover(Task) ->
    {value, TaskId} = dataset:get_value(id, Task),
    {value, Cmd} = dataset:get_value(command, Task),
    {value, Params} = dataset:get_value(params, Task),
    {value, External} = dataset:get_value(external, Task),
    Args = parse_params(Params),
    Result = 
    case boolean(External) of
    true ->
        %TODO: transform string to erlang term
        catch monit_plugin:run(to_list(Cmd), TaskId, Args);
    false ->
        catch apply(list_to_atom(to_list(Cmd)), run, [Args])
    end,
    case Result of
    {'EXIT', Error} ->
        ?ERROR("disco error: ~p ~n~p", [Error, Task]),
        {TaskId, error, "disco error"};
    {error, Summary} ->
        {TaskId, error, Summary}; 
    {error, Summary, _} ->
        {TaskId, error, Summary};
    {ok, Summary, Services} ->
        {TaskId, ok, Summary, Services}
    end.

parse_params(Params0) ->
    Params = string:tokens(to_list(Params0), "&"),
    [begin 
        Idx = string:chr(Param, $=),
        Arg = string:substr(Param, 1, Idx -1),
        Val = string:substr(Param, Idx + 1),
        {list_to_atom(Arg), Val}
     end || Param <- Params].

boolean(0) -> false;

boolean(1) -> true.

