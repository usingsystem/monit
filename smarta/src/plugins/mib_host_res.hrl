%host OBJECT IDENTIFIER ::= 1.3.6.1.2.1.25 

%hrSystem OBJECT IDENTIFIER ::= { host 1 }

-define(hrSystemUptime, {sysUptime, "1.3.6.1.2.1.25.1.1.0"}).
-define(hrSystemDate, {sysDate, "1.3.6.1.2.1.25.1.2.0"}).
-define(hrSystemNumUsers, {sysNumUsers, "1.3.6.1.2.1.25.1.5.0"}).
-define(hrSystemProcesses, {sysProcesses, "1.3.6.1.2.1.25.1.6.0"}).
-define(hrSystemMaxProcesses, {sysMaxProcesses, "1.3.6.1.2.1.25.1.7.0"}).

%hrStorage OBJECT IDENTIFIER ::= { host 2 }

-define(hrStorageIndex, {index, "1.3.6.1.2.1.25.2.3.1.1"}).
-define(hrStorageType, {type, "1.3.6.1.2.1.25.2.3.1.2"}).
-define(hrStorageDescr, {descr, "1.3.6.1.2.1.25.2.3.1.3"}).
-define(hrStorageUnits, {units, "1.3.6.1.2.1.25.2.3.1.4"}).
-define(hrStorageSize, {size, "1.3.6.1.2.1.25.2.3.1.5"}).
-define(hrStorageUsed, {used, "1.3.6.1.2.1.25.2.3.1.6"}).

-define(hrStorage, [?hrStorageType, 
        ?hrStorageDescr, 
        ?hrStorageUnits, 
        ?hrStorageSize, 
        ?hrStorageUsed]).

%hrDevice OBJECT IDENTIFIER ::= { host 3 }
-define(hrProcessorLoad, {load, "1.3.6.1.2.1.25.3.3.1.2"}).

%hrSWRun OBJECT IDENTIFIER ::= { host 4 }
-define(hrSWRunIndex, {runIndex, "1.3.6.1.2.1.25.4.2.1.1"}).
-define(hrSWRunName, {runName, "1.3.6.1.2.1.25.4.2.1.2"}).
-define(hrSWRunID, {runID, "1.3.6.1.2.1.25.4.2.1.3"}).
-define(hrSWRunPath, {runPath, "1.3.6.1.2.1.25.4.2.1.4"}).
-define(hrSWRunParameters, {runParams, "1.3.6.1.2.1.25.4.2.1.5"}).
-define(hrSWRunType, {runType, "1.3.6.1.2.1.25.4.2.1.6"}).
-define(hrSWRunStatus, {runStatus, "1.3.6.1.2.1.25.4.2.1.7"}).

%hrSWRunPerf OBJECT IDENTIFIER ::= { host 5 }
-define(hrSWRunPerfCPU, {cpu, "1.3.6.1.2.1.25.5.1.1.1"}).
-define(hrSWRunPerfMem, {mem, "1.3.6.1.2.1.25.5.1.1.2"}).

-define(hrSWRun, [?hrSWRunName, 
        ?hrSWRunPath, 
        ?hrSWRunParameters,
        ?hrSWRunPerfCPU,
        ?hrSWRunPerfMem]).

%LanMgr-Mib-II-MIB
-define(svSvcName, {name, "1.3.6.1.4.1.77.1.2.3.1.1"}).
-define(svSvcOperatingState, {operatingState, "1.3.6.1.4.1.77.1.2.3.1.3"}).

-define(svSvc, [?svSvcName, 
        ?svSvcOperatingState]).

