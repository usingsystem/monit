%%disk io
-define(diskIOIndex, {index, "1.3.6.1.4.1.2021.13.15.1.1.1"}).
-define(diskIODevice, {device, "1.3.6.1.4.1.2021.13.15.1.1.2"}).
-define(diskIONRead, {rbytes,"1.3.6.1.4.1.2021.13.15.1.1.3"}).
-define(diskIONWritten, {wbytes, "1.3.6.1.4.1.2021.13.15.1.1.4"}).
-define(diskIOReads, {reads, "1.3.6.1.4.1.2021.13.15.1.1.5"}).
-define(diskIOWrites, {writes, "1.3.6.1.4.1.2021.13.15.1.1.6"}).

-define(diskIO, [?diskIODevice, 
        ?diskIONRead, 
        ?diskIONWritten, 
        ?diskIOReads, 
        ?diskIOWrites]).
