%%%----------------------------------------------------------------------
%%% File    : monit_ctl.erl
%%% Author  : Ery Lee <ery.lee@gmail.com>
%%% Purpose : Monit admin control
%%% Created : 15 Jan 2010
%%% License : http://www.monit.cn
%%%
%%% Copyright (C) 2007-2010, www.monit.cn
%%%----------------------------------------------------------------------
-module(monit_ctl).

-author('ery.lee@gmail.com').

-include("elog.hrl").

-include("monit.hrl").

-import(extbif, [to_list/1]).

-export([start/0, init/0, process/1]).  

-define(STATUS_SUCCESS, 0).

-define(STATUS_ERROR,   1).

-define(STATUS_USAGE,   2).

-define(STATUS_BADRPC,  3).

start() ->
    case init:get_plain_arguments() of
	[SNode | Args] ->
	    SNode1 = case string:tokens(SNode, "@") of
		[_Node, _Server] ->
		    SNode;
		_ ->
		    case net_kernel:longnames() of
			 true ->
			     SNode ++ "@" ++ inet_db:gethostname() ++
				      "." ++ inet_db:res_option(domain);
			 false ->
			     SNode ++ "@" ++ inet_db:gethostname();
			 _ ->
			     SNode
		     end
	    end,
	    Node = list_to_atom(SNode1),
	    Status = case rpc:call(Node, ?MODULE, process, [Args]) of
			 {badrpc, Reason} ->
			     ?PRINT("RPC failed on the node ~p: ~p~n",
				       [Node, Reason]),
			     ?STATUS_BADRPC;
			 S ->
			     S
		     end,
	    halt(Status);
	_ ->
	    print_usage(),
	    halt(?STATUS_USAGE)
    end.

init() ->
	ok.

process(["status"]) ->
    {InternalStatus, ProvidedStatus} = init:get_status(),
    ?PRINT("Node ~p is ~p. Status: ~p~n",
              [node(), InternalStatus, ProvidedStatus]),
    case lists:keysearch(monit, 1, application:which_applications()) of
        false ->
            ?PRINT("monit is not running~n", []),
            ?STATUS_ERROR;
        {value,_Version} ->
            ?PRINT("monit is running~n", []),
            ?STATUS_SUCCESS
    end;

process(["run"]) ->
    case monit:run() of
    {error, Error} -> 
        ?PRINT("Error: ~p~n", [Error]),
        ?STATUS_ERROR;
    ok ->
        ?PRINT("Run successfully!~n", []),
        ?STATUS_SUCCESS
    end;

process(["stop"]) ->
	monit:stop(),
    init:stop(),
    ?STATUS_SUCCESS;

process(["restart"]) ->
    init:restart(),
    ?STATUS_SUCCESS;

process(["log_rotation"]) ->
    %% TODO: Use the Reopen log API for logger_h ?
    elog_logger_h:reopen_log(),
    case application:get_env(sasl,sasl_error_logger) of
    {ok, {file, SASLfile}} ->
        error_logger:delete_report_handler(sasl_report_file_h),
        elog_logger_h:rotate_log(SASLfile),
        error_logger:add_report_handler(sasl_report_file_h,
        {SASLfile, get_sasl_error_logger_type()});
    _ -> 
        false
    end,
    ?STATUS_SUCCESS;

process(["mnesia"]) ->
    ?PRINT("~p~n", [mnesia:system_info(all)]),
    ?STATUS_SUCCESS;

process(["mnesia", "info"]) ->
    mnesia:info(),
    ?STATUS_SUCCESS;

process(["mnesia", Arg]) when is_list(Arg) ->
    case catch mnesia:system_info(list_to_atom(Arg)) of
	{'EXIT', Error} -> ?PRINT("Error: ~p~n", [Error]);
	Return -> ?PRINT("~p~n", [Return])
    end,
    ?STATUS_SUCCESS;

process(_) -> 
    print_usage(),
    ?STATUS_ERROR.

print_usage() ->
	CmdDescs = [{"status", "get monit status"},
	 {"stop", "stop monit"},
	 {"restart", "restart monit"},
	 {"log_rotation", "log rotation"},
	 {"mnesia [info]", "show information of Mnesia system"}],
    MaxCmdLen =
	lists:max(lists:map(
		    fun({Cmd, _Desc}) ->
			    length(Cmd)
		    end, CmdDescs)),
    NewLine = io_lib:format("~n", []),
    FmtCmdDescs =
	lists:map(
	  fun({Cmd, Desc}) ->
		  ["  ", Cmd, string:chars($\s, MaxCmdLen - length(Cmd) + 2),
		   Desc, NewLine]
	  end, CmdDescs),
    ?PRINT(
      "Usage: monit_ctl [--node nodename] command [options]~n"
      "~n"
      "Available commands in this monit node:~n"
      ++ FmtCmdDescs ++
      "~n"
      "Examples:~n"
      "  monit_ctl restart~n"
      "  monit_ctl --node monit@host restart~n",
     []).

get_sasl_error_logger_type () ->
    case application:get_env (sasl, errlog_type) of
    {ok, error} -> error;
    {ok, progress} -> progress;
    {ok, all} -> all;
    {ok, Bad} -> exit ({bad_config, {sasl, {errlog_type, Bad}}});
    _ -> all
    end.

