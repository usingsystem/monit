-module(wmi_test).

-include("elog.hrl").

-export([run/1]).

run(Host) ->
    check_cpu_wmi:run([{uuid, "cpu"}, {host, Host}]),
    sleep(20),
    Res = check_cpu_wmi:run([{uuid, "cpu"}, {host, Host}]),
    ?INFO("~p", [Res]),
    check_cpuq_wmi:run([{uuid, "cpuq"}, {host, Host}]),
    sleep(20),
    Res1 = check_cpuq_wmi:run([{uuid, "cpuq"}, {host, Host}]),
    ?INFO("~p", [Res1]),
    sleep(2),
    check_diskbusy_wmi:run([{uuid, "diskbusy"}, {host, Host}]),
    sleep(20),
    Res2 = check_diskbusy_wmi:run([{uuid, "diskbusy"}, {host, Host}]),
    ?INFO("~p", [Res2]),
    sleep(2),
    check_diskio_wmi:run([{uuid, "diskio"}, {host, Host}]),
    sleep(30),
    Res3 = check_diskio_wmi:run([{uuid, "diskio"}, {host, Host}]),
    ?INFO("~p", [Res3]),
    sleep(2),
    check_diskq_wmi:run([{uuid, "diskq"}, {host, Host}]),
    sleep(20),
    Res4 = check_diskq_wmi:run([{uuid, "diskq"}, {host, Host}]),
    ?INFO("~p", [Res4]),
    sleep(2),
    Res5 = check_mem_wmi:run([{uuid, "mem"}, {host, Host}]),
    ?INFO("~p", [Res5]),
    sleep(2),
    check_mempage_wmi:run([{uuid, "mempage"}, {host, Host}]),
    sleep(20),
    Res6 = check_mempage_wmi:run([{uuid, "mempage"}, {host, Host}]),
    ?INFO("~p", [Res6]),
    sleep(2),
    Res7 = check_task_wmi:run([{uuid, "task"}, {host, Host}]),
    ?INFO("~p", [Res7]),
    sleep(2),
    Res8 = check_uptime_wmi:run([{uuid, "uptime"}, {host, Host}]),
    ?INFO("~p", [Res8]),
    io:format("finished").

sleep(Secs) ->
    timer:sleep(Secs * 1000).

