%%% http://IP:8135/Win32_PerfRawData_PerfDisk_PhysicalDisk/_Total?select=Name,DiskReadsPerSec,DiskWritesPerSec,TimeStamp_Sys100NS,Frequency_Sys100NS

-module(wmiproxy).

-include("elog.hrl").

-import(lists, [concat/1]).

-import(string, [join/2, tokens/2]).

-export([parse/1, parse2/1]).

-export([fetch/1, fetch/4, fetch/5]).

fetch(URL) ->
    ?INFO("wmiproxy: ~p", [URL]),
    case catch http:request(URL) of
    {ok, {{_, 200, _}, _, Body}} ->
        {ok, Body};
    {ok, {{_, _Status, Reason}, _, _}} ->
        {error, Reason};
    {'EXIT', Reason} ->
        {error, Reason}
    end.

fetch(Host, Port, Class, Attrs) ->
    URL = concat(["http://", Host, ":", Port, "/", Class, 
        "?select=", join(Attrs, ",")]),
    fetch(URL).

fetch(Host, Port, Class, Name, Attrs) ->
    URL = concat(["http://", Host, ":", Port, "/", Class, "/", Name, 
        "?select=", join(Attrs, ",")]),
    fetch(URL).
    
parse(Text) ->
    [Line|_] = tokens(Text, "\r\n"),
    [list_to_tuple(tokens(Token, "=")) 
        || Token <- tokens(Line, ",")].

parse2(Text) ->
    [Line|_] = tokens(Text, "\r\n"),
    [begin 
        [K, V] = tokens(Token, "="),
        {K, list_to_integer(V)}
    end || Token <- tokens(Line, ",")].
