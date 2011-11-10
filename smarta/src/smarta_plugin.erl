%%----------------------------------------------------------------------
%%% File    : smarta_plugin.erl
%%% Author  : ery.lee@gmail.com
%%% Purpose : execute plugin cmd
%%% Created : 13 Jan 2010 
%%% License : http://www.monit.cn/
%%%
%%% Copyright (C) 2007-2010, www.monit.cn
%%%----------------------------------------------------------------------
-module(smarta_plugin).

-include("elog.hrl").

-import(extbif, [to_list/1]).

-behaviour(gen_server).

-export([run/3]).

-export([start_link/1, stop/0]).

%% gen_server callbacks
-export([init/1, 
		 handle_call/3, 
		 handle_cast/2, 
		 handle_info/2, 
		 code_change/3, 
		 terminate/2]).

-record(running_cmd, {ref, pid, from, uuid, cmd}).

-record(state, {pool_size, plugin_home, waiting_queue}).

start_link(Opts) ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [Opts], []).

stop() ->
	gen_server:cast(?MODULE, stop).

run(Cmd, Uuid, Args) ->
    gen_server:call(?MODULE, {run, Cmd, Uuid, Args}, 30000).

%%%-------------------------------------------------------------------
%%% Callback functions from gen_server
%%%-------------------------------------------------------------------
%%--------------------------------------------------------------------
%% Function: init(Args) -> {ok, State} |
%%                         {ok, State, Timeout} |
%%                         ignore               |
%%                         {stop, Reason}
%% Description: Initiates the server
%%--------------------------------------------------------------------
init([Opts]) ->
    process_flag(trap_exit, true),
    {value, PoolSize} = dataset:get_value(pool_size, Opts, 40),
    {value, PluginHome} = dataset:get_value(home, Opts),
    mnesia:create_table(running_cmd,
        [{ram_copies, [node()]}, {index, [pid]},
         {attributes, record_info(fields, running_cmd)}]),
    mnesia:add_table_copy(running_cmd, node(), ram_copies),
	{ok, #state{pool_size = PoolSize, plugin_home = PluginHome, 
                   waiting_queue = queue:new()}}.

%%--------------------------------------------------------------------
%% Func: handle_call/3
%% Returns: {reply, Reply, State}          |
%%          {reply, Reply, State, Timeout} |
%%          {noreply, State}               |
%%          {noreply, State, Timeout}      |
%%          {stop, Reason, Reply, State}   | (terminate/2 is called)
%%          {stop, Reason, State}            (terminate/2 is called)
%%--------------------------------------------------------------------
handle_call({run, Cmd, Uuid, Args}, From, State) ->
    NewState = run_cmd(From, Cmd, Uuid, Args, State),
    {noreply, NewState};

handle_call(Req, _From, State) ->
    ?ERROR("unexpected request: ~p", [Req]),
    {reply, {error, unexpected_req}, State}.

%%--------------------------------------------------------------------
%% Func: handle_cast/2
%% Returns: {noreply, State}          |
%%          {noreply, State, Timeout} |
%%          {stop, Reason, State}            (terminate/2 is called)
%%--------------------------------------------------------------------
handle_cast(stop, S) ->
    {stop, normal, S};

handle_cast(Msg, State) ->
    ?ERROR("unexpected message: ~p", [Msg]),
    {noreply, State}.
    
handle_info({cmd_out, Ref, Output}, State) ->
    case mnesia:dirty_read(running_cmd, Ref) of
    [#running_cmd{from = From, uuid = Uuid} = RunningCmd] ->
        Result = 
        case catch parse_output(Output) of
        {'EXIT', Reason} -> 
            {error, {'EXIT', Reason}};
        {Status, Summary, Headers, Items} -> 
            Items1 = calc_metrics(Uuid, Headers, Items),
            Summary1 = 
            case dataset:get_value('count-metrics', Headers) of
            {value, Val} -> 
                Counters = string:tokens(Val, ", "),
                replace_counter(Summary, Counters, Items1);
            false ->
                Summary
            end,
            {Status, Summary1, Items1}
        end,
        gen_server:reply(From, Result),
        mnesia:sync_dirty(fun() -> mnesia:delete_object(RunningCmd) end);
    [] ->
        ?WARNING("cannot find running_cmd: ~p", [Ref])
    end,
    {noreply, check_waiting(State)};

handle_info({'EXIT', Pid, Reason}, State) ->
    case mnesia:dirty_index_read(running_cmd, Pid, #running_cmd.pid) of
    [] ->
        ok;
        %?INFO("cmd exit: ~p, ~p", [Pid, Reason]);
    Cmds ->
        lists:foreach(fun(#running_cmd{from = From} = Cmd) -> 
            gen_server:reply(From, {error, {'EXIT', Reason}}),
            mnesia:sync_dirty(fun() -> mnesia:delete_object(Cmd) end)
        end, Cmds)
    end,
    {noreply, check_waiting(State)};

handle_info(Info, State) ->
    ?ERROR("unexpected info: ~p", [Info]),
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_Vsn, State, _Extra) ->
    {ok, State}.

%% ========================================================================
run_cmd(From, Cmd0, Uuid, Args0, #state{pool_size = PoolSize, 
        plugin_home = PluginHome, waiting_queue = Queue} = State) ->
    Size = mnesia:table_info(running_cmd, size),
    if
    Size >= PoolSize -> %%add to waiting queue
        NewQueue = queue:in({From, Cmd0, Uuid, Args0}, Queue),
        Len = queue:len(NewQueue), 
        if 
        Len > 20 -> ?WARNING("plugin waiting queue len: ~p", [Queue]);
        true -> ok
        end,
        State#state{waiting_queue = NewQueue};
    true -> %%spawn and run
        Ref = make_ref(),
        Args = string:join([lists:flatten(["--", atom_to_list(Name), "=", Val]) || {Name, Val} <- Args0], " "),
        Cmd = string:strip(lists:flatten(["cd ", PluginHome, " ; ./", Cmd0, " ", Args])),
        Pid = spawn_link(fun() -> 
                Output = os:cmd(Cmd),
                ?MODULE ! {cmd_out, Ref, string:strip(Output, right, $\n)}
        end),
        mnesia:sync_dirty(fun() -> 
            mnesia:write(#running_cmd{ref = Ref, pid = Pid, from = From, uuid = Uuid, cmd = Cmd})        
        end),
        State
    end.

check_waiting(#state{waiting_queue = Queue} = State) ->
    case queue:out(Queue) of
    {{value, {From, Cmd, Uuid, Args}}, Q2} ->
        run_cmd(From, Cmd, Uuid, Args, State#state{waiting_queue = Q2});
    {empty, _} ->
        State
    end.

parse_output(Output) ->
    {Head, Body} = 
    case re:split(Output, "\n\n") of
    [H] -> 
        {H, <<>>};
    [H,B] -> 
        {H, B};
    [H,B|_T] -> 
        ?WARNING("invalid output: ~p", [Output]),
        {H, B}
    end,
    {Status, Summary, Headers} = parse_head(Head),
    Items = parse_body(binary_to_list(Body)),
    {Status, Summary, Headers, Items}.

parse_head(Head) ->
    [StatusLine | HeadLines] = string:tokens(extbif:to_list(Head), "\r\n"),
    {Status, Summary} = parse_statusline(StatusLine),
    Headers = [begin 
        [Name, Val] = string:tokens(Line, ":"),
        {list_to_atom(Name), string:strip(Val)}
    end || Line <- HeadLines],
    {Status, Summary, Headers}.

parse_statusline("OK - " ++ Summary) ->
    {ok, Summary};

parse_statusline("WARNING - " ++ Summary) ->
    {warning, Summary};

parse_statusline("CRITICAL - " ++ Summary) ->
    {critical, Summary};

parse_statusline("UNKNOWN - " ++ Summary) ->
    {unknown, Summary};

parse_statusline(StatusLine) ->
    {unknown,  StatusLine}.

parse_body(Body) ->
    parse_line(string:tokens(Body, "\r\n"), []).

parse_line([], ItemAcc) ->
    ItemAcc;

parse_line(["metric:" ++ S|T], ItemAcc) ->
    case re:run(S, "([^:.]+): (.+)", [{capture, [1,2], list}]) of
    {match, [N, V]} ->
        Metric = {metric, list_to_atom(N), parse_val(V)},
        parse_line(T, [Metric | ItemAcc]);
    nomatch ->
        ?WARNING("invalid metric line: ~p", [S]),
        parse_line(T, ItemAcc)
    end;

parse_line(["entry:" ++ S|T], ItemAcc) ->
    case re:run(S, "([^:.]+):([^:.]+):(.+)", [{capture, [1,2,3], list}]) of
    {match, [G, N, V]} ->
        parse_line(T, [{entry, list_to_atom(G), N, string:strip(V)}|ItemAcc]);
    nomatch ->
        ?WARNING("invalid entry line: ~p", [S]),
        parse_line(T, ItemAcc)
    end;

parse_line(["service:" ++ S|T], ItemAcc) ->
    case re:run(S, "([^:.]+):([^:.]+): (.+)", [{capture, [1,2,3], list}]) of
    {match, [Cmd, Name, Params]} ->
        parse_line(T, [{service, list_to_atom(Cmd), Name, Params, "ok"}|ItemAcc]);
    nomatch ->
        ?WARNING("invalid service line: ~p", [S]),
        parse_line(T, ItemAcc)
    end;

parse_line([S|T], ItemAcc) ->
    ?WARNING("invalid line: ~p", [S]),
    parse_line(T, ItemAcc).

parse_val(S) ->
    {ok, MP} = re:compile("([0-9]+(?:.[0-9]+)*)([a-zA-Z%\$]*)"),
    {match, [_, M2, M3]} = re:run(S, MP),
    {_Type, Val} = match_val(S, M2),
    _Unit = match_unit(S, M3),
    Val.

match_val(S, {Offset, Len}) ->
    V = string:substr(S, Offset+1, Len),
    case string:chr(V, $.) of
    0 ->
        {"i", list_to_integer(V)};
    _ ->
        {"f", list_to_float(V)}
    end.

match_unit(S, {Offset, Len}) ->
    case Len of
    0 ->
        "";
    _ -> 
        string:substr(S, Offset+1, Len)
    end.

replace_counter(Summary, Counters, Items1) ->
    Metrics = [{atom_to_list(Name), Val} || {metric, Name, Val} <- Items1], 
    Parts = re:split(Summary, ", "), 
    NewParts =
    lists:map(fun(Part) -> 
        case re:run(Part, "(.+) = ([0-9]+(?:.[0-9]+)*)([a-zA-Z%\$]*)", [{capture, [1,2,3], list}]) of
        {match, [N, _V, U]} ->
            case dataset:get_value(N, Metrics) of
            {value, NewV} ->
                lists:concat([N, " = ", to_s(NewV), U]);
            false ->
                case lists:member(N, Counters) of
                true -> lists:concat([N, " = N/A"]);
                false -> to_list(Part)
                end
            end;
        nomatch ->
            to_list(Part)
        end
    end, Parts),
    string:join(NewParts, ", ").

to_s(I) when is_integer(I) ->
    integer_to_list(I);
to_s(F) when is_float(F) ->
    [S] = io_lib:format("~.2f", [F]),
    S.

calc_metrics(Uuid, Headers, Items) ->
    case dataset:get_value('count-metrics', Headers) of
    {value, S} ->
        Counters = [list_to_atom(C) || C <- string:tokens(S, ",")],
        calc_metrics1(Uuid, Counters, Items);
    false ->
        Items
    end.

calc_metrics1(Uuid, Counters, Items) ->
    Timestamp = extbif:timestamp() - 1,
    Metrics = find_metrics(Items, Counters, []),
    case monit_last:get_last(Uuid) of
    {ok, {LastTime, LastMetrics}} -> 
        monit_last:insert_last(Uuid, {Timestamp, Metrics}),
        NewMetrics = calc_metrics2(LastTime, LastMetrics, Timestamp, Metrics),
        merge_metrics(NewMetrics, Items);
    false ->
        monit_last:insert_last(Uuid, {Timestamp, Metrics}),
        []
    end.

merge_metrics([], Items) ->
    Items;

merge_metrics([{N, V} | Metrics], Items) ->
    NewItems = lists:keyreplace(N, 2, Items, {metric, N, V}),
    merge_metrics(Metrics, NewItems).

calc_metrics2(LastTime, LastMetrics, Timestamp, Metrics) ->
    TimeDelta = Timestamp - LastTime,
    lists:map(fun({N, V1}) -> 
        {value, V2} = dataset:get_value(N, Metrics),
        Delta = 
        case (V2 - V1) of
        V when V < 0 -> 0;
        V -> V
        end,
        {N, Delta/TimeDelta}
    end, LastMetrics).
    
find_metrics([], _Counters, Acc) ->
    Acc;

find_metrics([{entry, _, _, _} | Items], Counters, Acc) ->
    find_metrics(Items, Counters, Acc);

find_metrics([{metric, Name, Val} | Items], Counters, Acc) ->
    case lists:member(Name, Counters) of
    true ->
        find_metrics(Items, Counters, [{Name, Val}|Acc]);
    false ->
        find_metrics(Items, Counters, Acc)
    end.
