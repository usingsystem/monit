%%load
-define(laNames, {names,  "1.3.6.1.4.1.2021.10.1.2"}).   
-define(laLoad, {load, "1.3.6.1.4.1.2021.10.1.3"}).  
-define(laConfig, {config, "1.3.6.1.4.1.2021.10.1.4"}).  

%%memory
-define(memTotal, {total, "1.3.6.1.4.1.2021.4.5.0"}).
-define(memAvail, {free, "1.3.6.1.4.1.2021.4.6.0"}).
-define(memShared, {shared, "1.3.6.1.4.1.2021.4.13.0"}).
-define(memBuffer, {buffers, "1.3.6.1.4.1.2021.4.14.0"}).
-define(memCached, {cached, "1.3.6.1.4.1.2021.4.15.0"}).

-define(memOids, [?memTotal, 
        ?memAvail, 
%        ?memShared, 
        ?memBuffer, 
        ?memCached]).

%%swap
-define(swapTotal, {total, "1.3.6.1.4.1.2021.4.3.0"}).
-define(swapFree, {free, "1.3.6.1.4.1.2021.4.4.0"}).

-define(swapOids, [?swapTotal, ?swapFree]).
