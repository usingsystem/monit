%%%----------------------------------------------------------------------
%%% File    : monit_aggre.erl
%%% Author  : Ery Lee <ery.lee@gmail.com>
%%% Purpose : Metric aggregate
%%% Created : 17 Nov. 2010
%%% License : http://www.monit.cn/license
%%%
%%% Copyright (C) 2007-2010, www.monit.cn
%%%----------------------------------------------------------------------
-module(monit_aggre).

-author('ery.lee@gmail.com').

-include("elog.hrl").

-include("monit.hrl").

-export([start_link/0]).

-export([hourly/1, daily/1]).

-behavior(gen_server).

-export([init/1, 
        handle_call/3, 
        handle_cast/2, 
        handle_info/2, 
        terminate/2, 
        code_change/3]).

-record(state, {}).

%%--------------------------------------------------------------------
%% Function: start_link() -> {ok,Pid} | ignore | {error,Error}
%% Description: Starts the server
%%--------------------------------------------------------------------
start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

%hourly aggregation
hourly({Dn, Hour, Fields}) ->
    gen_server:cast(?MODULE, {hourly, {Dn, Hour, Fields}}).

%daily aggregation
daily({Dn, Date, Fields}) ->
    gen_server:cast(?MODULE, {daily, {Dn, Date, Fields}}).
    
%%====================================================================
%% gen_server callbacks
%%====================================================================
%%--------------------------------------------------------------------
%% Function: init(Args) -> {ok, State} |
%%                         {ok, State, Timeout} |
%%                         ignore               |
%%                         {stop, Reason}
%% Description: Initiates the server
%%--------------------------------------------------------------------
init([]) ->
    {ok, #state{}}.

%%--------------------------------------------------------------------
%% Function: %% handle_call(Request, From, State) -> {reply, Reply, State} |
%%                                      {reply, Reply, State, Timeout} |
%%                                      {noreply, State} |
%%                                      {noreply, State, Timeout} |
%%                                      {stop, Reason, Reply, State} |
%%                                      {stop, Reason, State}
%% Description: Handling call messages
%%--------------------------------------------------------------------
handle_call(Req, _From, State) ->
    ?ERROR("bagreq: ~p", [Req]),
    {reply, {error, badreq}, State}.

    

%%--------------------------------------------------------------------
%% Function: handle_cast(Msg, State) -> {noreply, State} |
%%                                      {noreply, State, Timeout} |
%%                                      {stop, Reason, State}
%% Description: Handling cast messages
%%--------------------------------------------------------------------
handle_cast({hourly, {Dn, Hour, Fields0}}, State) ->
    ?INFO("hourly aggr: ~p ~p", [Dn, Hour]),
    Fields = [atom_to_binary(F) || F <- Fields0],
    MetricId = lists:concat([binary_to_list(Dn), ":", Hour]),
    Selector = [{dn, Dn}, {ts, [{'>', Hour-3600}, {'=<', Hour}]}],
    Metrics = emongo:find_all(monit, "metric", Selector, [{fields, Fields}]),
    try do_aggregate(Fields, Metrics) of
    [] ->
        pass;
    HourlyMetric ->
        emongo:insert(monit, "metric.hourly", [{"_id", MetricId}, {dn, Dn}, {ts, Hour} | HourlyMetric]),
        aggregate_daily(Dn, Hour, Metrics),
        monit_last:insert(#monit_last{key = {metric, hourly, Dn}, dn = Dn, data = Hour})
    catch
        _:Err -> ?ERROR("~p:~n~p", [Err, erlang:get_stacktrace()])
    end,
    {noreply, State};

handle_cast({daily, {Dn, Date, Fields0}}, State) ->
    ?INFO("daily aggr: ~p ~p", [Dn, Date]),
    Fields = [atom_to_binary(F) || F <- Fields0],
    MetricId = lists:concat([binary_to_list(Dn), ":", Date]),
    Selector = [{dn, Dn}, {ts, [{'>', Date - 86400}, {'=<', Date}]}],
    Metrics = emongo:find_all(monit, "metric.hourly", Selector, [{fields, Fields}]),
    try do_daily_aggregate(Fields, lists:reverse(Metrics)) of
    [] ->
        pass;
    DailyMetric ->
        ?INFO("daily metric: ~p", [DailyMetric]),
        emongo:insert(monit, <<"metric.daily">>, [{"_id", MetricId}, {dn, Dn}, {ts, Date} | DailyMetric])
    catch
        _:Err -> ?ERROR("~p:~n~p", [Err, erlang:get_stacktrace()])
    end,
    {noreply, State};

handle_cast(Msg, State) ->
    ?ERROR("bagmsg: ~p", [Msg]),
    {noreply, State}.

%%--------------------------------------------------------------------
%% Function: handle_info(Info, State) -> {noreply, State} |
%%                                       {noreply, State, Timeout} |
%%                                       {stop, Reason, State}
%% Description: Handling all non call/cast messages
%%--------------------------------------------------------------------
handle_info(Info, State) ->
    ?ERROR("unexpected info: ~p", [Info]),
    {noreply, State}.

%%--------------------------------------------------------------------
%% Function: terminate(Reason, State) -> void()
%% Description: This function is called by a gen_server when it is about to
%% terminate. It should be the opposite of Module:init/1 and do any necessary
%% cleaning up. When it returns, the gen_server terminates with Reason.
%% The return value is ignored.
%%--------------------------------------------------------------------
terminate(_Reason, _State) ->
    ok.
    
%%--------------------------------------------------------------------
%% Func: code_change(OldVsn, State, Extra) -> {ok, NewState}
%% Description: Convert process state when code is changed
%%--------------------------------------------------------------------
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%--------------------------------------------------------------------
%%% Internal functions
%%--------------------------------------------------------------------
do_aggregate(_, []) ->
    [];
do_aggregate(Fields, Metrics) ->
    do_aggregate(Fields, Metrics, []).

do_aggregate([], _, Acc) ->
    Acc;
do_aggregate([Field|T], Metrics, Acc) ->
    [Last|_] = Values = [begin 
        {value, V} = dataset:get_value(Field, Metric),
        V
    end || Metric <- Metrics],
    Max = lists:max(Values),
    Min = lists:min(Values),
    Sum = lists:sum(Values),
    Count = length(Values),
    Avg = Sum / Count,
    Res = {Field, [{max, Max}, {min, Min}, {avg, Avg}, 
        {last, Last}, {sum, Sum}, {count, Count}]}, 
    do_aggregate(T, Metrics, [Res|Acc]).

do_daily_aggregate(_, []) ->
    [];
do_daily_aggregate(Fields, Metrics) ->
    do_daily_aggregate(Fields, Metrics, []).

do_daily_aggregate([], _, Acc) ->
    Acc;
do_daily_aggregate([Field|T], Metrics, Acc) ->
    Values = [begin 
        {value, V} = dataset:get_value(Field, Metric),
        V
    end || Metric <- Metrics],
    {Max, Min, Sum, AvgSum, Last, Count} = 
        do_daily_aggregate2(Values, {0,-1,0,0,0,0}),
    Avg = AvgSum / length(Values),
    Res = {Field, [{max, Max}, {min, Min}, {avg, Avg}, 
        {last, Last}, {sum, Sum}, {count, Count}]}, 
    do_aggregate(T, Metrics, [Res|Acc]).

do_daily_aggregate2([], Acc) ->
    Acc;

do_daily_aggregate2([V|Values], {MaxAcc,MinAcc,SumAcc,AvgAcc,_LastAcc,CountAcc}) ->
    {value, Min} = dataset:get_value(<<"min">>, V),
    {value, Max} = dataset:get_value(<<"max">>, V),
    {value, Avg} = dataset:get_value(<<"avg">>, V),
    {value, Sum} = dataset:get_value(<<"sum">>, V),
    {value, Last} = dataset:get_value(<<"last">>, V),
    {value, Count} = dataset:get_value(<<"count">>, V),
    MaxAcc1 = max(MaxAcc, Max),
    MinAcc1 =
    if 
    MinAcc == -1 -> Min;
    true -> min(MinAcc, Min)
    end,
    AvgAcc1 = AvgAcc + Avg,
    SumAcc1 = SumAcc + Sum,
    LastAcc1 = Last,
    CountAcc1 = CountAcc + Count,
    do_daily_aggregate2(Values, [MaxAcc1,MinAcc1,SumAcc1,AvgAcc1,LastAcc1,CountAcc1]).

atom_to_binary(A) -> 
    list_to_binary(atom_to_list(A)).

aggregate_daily(Dn, Hour, Metrics) ->
    ?INFO("aggregate_daily: ~p ~p", [Dn, Hour]),
    case check_last(Dn) of
    {ok, LastHour} ->
        LastDate = LastHour div 86400,
        Today = Hour div 86400,
        case Today > LastDate of
        true ->
            Fields = [Name || {Name, _Val} <- Metrics],
            monit_aggre:daily({Dn, Today*86400, Fields});
        false ->
            ok
        end;
    none -> 
        ok
    end.

check_last(Dn) ->
    case monit_last:lookup({metric, hourly, Dn}) of
    false -> 
        case emongo:find_one(monit, "metric.hourly", [{dn, Dn}]) of
        [Record] ->
            case dataset:get_value(<<"ts">>, Record) of
            {value, Ts} -> {ok, Ts};
            false -> none
            end;
        [] -> 
            none;
        {error, _Err} ->
            none
        end;
    {ok, LastTime} -> 
        {ok, LastTime}
    end.


