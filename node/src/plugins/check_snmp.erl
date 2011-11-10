%%%----------------------------------------------------------------------
%%% File    : check_snmp.erl
%%% Author  : Ery Lee <ery.lee@gmail.com>
%%% Purpose : check snmp agent
%%% Created : 14 Jan 2010
%%% License : http://www.monit.cn
%%%
%%% Copyright (C) 2007-2010, www.monit.cn
%%%----------------------------------------------------------------------
-module(check_snmp).

-export([run/1]).

run(Args) ->
    {value, Host} = dataset:get_value(host, Args),
    {value, Port} = dataset:get_value(port, Args, <<"161">>),
    {value, Version} = dataset:get_value(version, Args, "v2c"),
    {value, Community} = dataset:get_value(community, Args, "public"),
    Cmd = lists:flatten(["snmpget -t 3 -r 2 -v ", Version, " -c ", 
        Community, " ", Host, ":", Port, " 1.3.6.1.2.1.1.1.0"]),
    Output = monit_plugin:check(Cmd),
	case Output of
    "Timeout:" ++ Summary -> 
        {critical, Summary};
    Summary -> 
        {ok, Summary}
    end.
