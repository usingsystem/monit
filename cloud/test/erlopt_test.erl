-include_lib("eunit/include/eunit.hrl").

% -------------------------------------------------------------------------
% EUnit

eunit_test() -> 
    ok.

short_options_test() ->
    Spec = [
        {"a", "alfa"    , no}, 
        {"b", "bravo"   , no}, 
        {"c", "charlie" , no}, 
        {"d", "delta"   , maybe}, 
        {"e", "echo"    , maybe}, 
        {"f", "foxtrot" , yes}, 
        {"g", "golf"    , yes}
    ],

    Args = ["-a", "-bc", 
        "-cd", "-cdxxx",
        "-e", "-exxx", 
        "-cf", "yyy",
        "-f", "yyy",
        "-cgzzz",
        "-gzzz"],

    [   {opt,{"a",[]}},
        {opt,{"b",[]}},
        {opt,{"c",[]}},
        {opt,{"c",[]}},
        {opt,{"d",[]}},
        {opt,{"c",[]}},
        {opt,{"d","xxx"}},
        {opt,{"e",[]}},
        {opt,{"e","xxx"}},
        {opt,{"c",[]}},
        {opt,{"f","yyy"}},
        {opt,{"f","yyy"}},
        {opt,{"c",[]}},
        {opt,{"g","zzz"}},
        {opt,{"g","zzz"}}] = getopt(Spec, Args).

long_options_test() ->
    Spec = [
        {"a", "alfa"    , no}, 
        {"b", "bravo"   , no}, 
        {"c", "charlie" , no}, 
        {"d", "delta"   , maybe}, 
        {"e", "echo"    , maybe}, 
        {"f", "foxtrot" , yes}, 
        {"g", "golf"    , yes}
    ],

    Args = [
        "--alfa", 
        "--bravo",
        "--charlie",
        "--delta",
        "--delta=xxx",
        "--echo",
        "--echo=",
        "--echo=yyy",
        "--foxtrot=",
        "--foxtrot=zzz"],

    [   {opt,{"alfa",[]}},
        {opt,{"bravo",[]}},
        {opt,{"charlie",[]}},
        {opt,{"delta",[]}},
        {opt,{"delta","xxx"}},
        {opt,{"echo",[]}},
        {opt,{"echo",[]}},
        {opt,{"echo","yyy"}},
        {opt,{"foxtrot",[]}},
        {opt,{"foxtrot","zzz"}}] = getopt(Spec, Args).
   
mixed_options_arguments_test() ->
    Spec = [
        {"a", "alfa"    , no}, 
        {"b", "bravo"   , no}, 
        {"c", "charlie" , no}, 
        {"d", "delta"   , maybe}, 
        {"e", "echo"    , maybe}, 
        {"f", "foxtrot" , yes}, 
        {"g", "golf"    , yes}
    ],

    Args = [
        "-abcdxxx",
        "argument 1",
        "-e", "argument 2",
        "-eyyy",
        "-",
        "argument 3",
        "-f--",
        "-g", "--",
        "-a",
        "--",
        "-argument 4",
        "--argument 5",
        "argument 6"],

    [{opt,{"a",[]}},
        {opt,{"b",[]}},
        {opt,{"c",[]}},
        {opt,{"d","xxx"}},
        {arg,"argument 1"},
        {opt,{"e",[]}},
        {arg,"argument 2"},
        {opt,{"e","yyy"}},
        {arg,"-"},
        {arg,"argument 3"},
        {opt,{"f","--"}},
        {opt,{"g","--"}},
        {opt,{"a",[]}},
        {arg,"-argument 4"},
        {arg,"--argument 5"},
        {arg,"argument 6"}] = getopt(Spec, Args).


