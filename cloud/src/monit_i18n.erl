%%%----------------------------------------------------------------------
%%% File    : monit_i18n.erl
%%% Author  : Ery Lee <ery.lee@gmail.com>
%%% Purpose : Monit I18N
%%% Created : 03 Apr. 2010
%%% License : http://www.monit.cn/license
%%%
%%% Copyright (C) 2007-2010, www.monit.cn
%%%----------------------------------------------------------------------
-module(monit_i18n).

-author('ery.lee@gmail.com').

-include("elog.hrl").

-include("monit.hrl").

-behavior(gen_server).

-export([start_link/0]).

-export([get_locale/1, 
        get_locale/3,
        get_locale/4]).

-export([init/1,
        handle_call/3, 
        handle_cast/2, 
        handle_info/2, 
        terminate/2, 
        code_change/3]).

-record(state, {country, language}).

%%--------------------------------------------------------------------
%% Function: start_link() -> {ok,Pid} | ignore | {error,Error}
%% Description: Starts the server
%%--------------------------------------------------------------------
start_link() ->
    gen_server:start_link({global, ?MODULE}, ?MODULE, [], []).

get_locale(Res) when is_binary(Res) ->
    gen_server:call({global, ?MODULE}, {get_locale, Res}).

get_locale(Country, Language, Res) when is_atom(Country) 
    and is_atom(Language) and is_binary(Res) ->
    read_locale({Country, Language, Res}, Res).

get_locale(Country, Language, Group, Res) when is_atom(Country) 
    and is_atom(Language) and is_binary(Group) and is_binary(Res) ->
    read_locale({Country, Language, <<Group/binary, ".", Res/binary>>}, Res).

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
    {Country, Language} =
    case application:get_env(locale) of
    {ok, Locale} -> Locale;
    undefined -> {zh, cn}
    end,
    mnesia:create_table(monit_locale, [{ram_copies, [node()]},
         {attributes, record_info(fields, monit_locale)}]),
    {ok, Records} = mysql:select(locales, [country, language, res, string]),
    lists:foreach(fun(R) -> 
        {value, C} = dataset:get_value(country, R),
        {value, L} = dataset:get_value(language, R),
        {value, Res} = dataset:get_value(res, R),
        {value, String} = dataset:get_value(string, R),
        mnesia:dirty_write(#monit_locale{key = {binary_to_atom(C), binary_to_atom(L), Res}, string = String})
    end, Records),
    {ok, #state{country = Country, language = Language}}.
%%--------------------------------------------------------------------
%% Function: %% handle_call(Request, From, State) -> {reply, Reply, State} |
%%                                      {reply, Reply, State, Timeout} |
%%                                      {noreply, State} |
%%                                      {noreply, State, Timeout} |
%%                                      {stop, Reason, Reply, State} |
%%                                      {stop, Reason, State}
%% Description: Handling call messages
%%--------------------------------------------------------------------
handle_call({get_locale, Res}, _From, #state{country = C, language = L} = State) ->
    Reply = read_locale({C, L, Res}, Res), 
    {reply, Reply, State};
    
handle_call(Request, _From, State) ->
    ?ERROR("unexpected request: ~p", [Request]),
    {reply, {error, unsupported_req}, State}.
%%--------------------------------------------------------------------
%% Function: handle_cast(Msg, State) -> {noreply, State} |
%%                                      {noreply, State, Timeout} |
%%                                      {stop, Reason, State}
%% Description: Handling cast messages
%%--------------------------------------------------------------------
handle_cast(_Msg, State) ->
    {noreply, State}.
%%--------------------------------------------------------------------
%% Function: handle_info(Info, State) -> {noreply, State} |
%%                                       {noreply, State, Timeout} |
%%                                       {stop, Reason, State}
%% Description: Handling all non call/cast messages
%%--------------------------------------------------------------------
handle_info(_Info, State) ->
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
read_locale(Key, Res) ->
    case mnesia:dirty_read(monit_locale, Key) of
    [#monit_locale{string = String}] ->
        String;
    [] ->
        ?WARNING("no locale:~p.~p", [Key, Res]),
        Res
    end.

binary_to_atom(B) ->
    list_to_atom(binary_to_list(B)).

