%%system
-define(sysDescr, {sysDescr, "1.3.6.1.2.1.1.1.0"}).
-define(sysObjectID, {sysObjectID, "1.3.6.1.2.1.1.2.0"}).
-define(sysUpTime, {sysUpTime, "1.3.6.1.2.1.1.3.0"}).
-define(sysContact, {sysContact, "1.3.6.1.2.1.1.4.0"}).
-define(sysName, {sysName, "1.3.6.1.2.1.1.5.0"}).
-define(sysLocation, {sysLocation, "1.3.6.1.2.1.1.6.0"}).

%%iftable
-define(ifIndex, {ifIndex, "1.3.6.1.2.1.2.2.1.1"}).
-define(ifDescr, {ifDescr, "1.3.6.1.2.1.2.2.1.2"}).
-define(ifType, {ifType, "1.3.6.1.2.1.2.2.1.3"}).
-define(ifMtu, {ifMtu, "1.3.6.1.2.1.2.2.1.4"}).
-define(ifSpeed, {ifSpeed, "1.3.6.1.2.1.2.2.1.5"}).
-define(ifPhysAddress, {ifPhysAddress, "1.3.6.1.2.1.2.2.1.6"}).
-define(ifAdminStatus, {ifAdminStatus, "1.3.6.1.2.1.2.2.1.7"}).
-define(ifOperStatus, {ifOperStatus, "1.3.6.1.2.1.2.2.1.8"}).
-define(ifInOctets, {ifInOctets, "1.3.6.1.2.1.2.2.1.10"}).
-define(ifInUcastPkts, {ifInUcastPkts, "1.3.6.1.2.1.2.2.1.11"}).
-define(ifInNUcastPkts, {ifInNUcastPkts, "1.3.6.1.2.1.2.2.1.12"}).
-define(ifInDiscards, {ifInDiscards, "1.3.6.1.2.1.2.2.1.13"}).
-define(ifInErrors, {ifInErrors, "1.3.6.1.2.1.2.2.1.14"}).
-define(ifInUnknownProtos, {ifInUnknownProtos, "1.3.6.1.2.1.2.2.1.15"}).
-define(ifOutOctets, {ifOutOctets, "1.3.6.1.2.1.2.2.1.16"}).
-define(ifOutUcastPkts, {ifOutUcastPkts, "1.3.6.1.2.1.2.2.1.17"}).
-define(ifOutNUcastPkts, {ifOutNUcastPkts, "1.3.6.1.2.1.2.2.1.18"}).
-define(ifOutDiscards, {ifOutDiscards, "1.3.6.1.2.1.2.2.1.19"}).
-define(ifOutErrors, {ifOutErrors, "1.3.6.1.2.1.2.2.1.20"}).

-define(ifEntry, [?ifIndex, 
        ?ifDescr, 
        ?ifType, 
        ?ifMtu, 
        ?ifSpeed, 
        ?ifPhysAddress, 
        ?ifAdminStatus, 
        ?ifOperStatus, 
        ?ifInOctets, 
        ?ifOutOctets, 
        ?ifInDiscards, 
        ?ifOutDiscards, 
        ?ifInUcastPkts, 
        ?ifInNUcastPkts, 
        ?ifOutUcastPkts, 
        ?ifOutNUcastPkts,  
        ?ifInErrors, 
        ?ifOutErrors,  
        ?ifInUnknownProtos]).

%%ifxtable
-define(ifName, {ifName, "1.3.6.1.2.1.31.1.1.1.1"}).
-define(ifHCInOctets, {ifInOctets, "1.3.6.1.2.1.31.1.1.1.6"}).
-define(ifHCInUcastPkts, {ifInUcastPkts, "1.3.6.1.2.1.31.1.1.1.7"}).
-define(ifHCInMulticastPkts, {ifHCInMulticastPkts, "1.3.6.1.2.1.31.1.1.1.8"}).
-define(ifHCInBroadcastPkts, {ifHCInBroadcastPkts, "1.3.6.1.2.1.31.1.1.1.9"}).
-define(ifHCOutOctets, {ifOutOctets, "1.3.6.1.2.1.31.1.1.1.10"}).
-define(ifHCOutUcastPkts, {ifOutUcastPkts, "1.3.6.1.2.1.31.1.1.1.11"}).
-define(ifHCOutMulticastPkts, {ifHCOutMulticastPkts, "1.3.6.1.2.1.31.1.1.1.12"}).
-define(ifHCOutBroadcastPkts, {ifHCOutBroadcastPkts, "1.3.6.1.2.1.31.1.1.1.13"}).

-define(ifXEntry, [?ifIndex, 
        ?ifDescr, 
        ?ifName,
        ?ifType, 
        ?ifMtu, 
        ?ifSpeed, 
        ?ifPhysAddress, 
        ?ifAdminStatus, 
        ?ifOperStatus, 
        ?ifInDiscards, 
        ?ifOutDiscards, 
        ?ifInNUcastPkts, 
        ?ifOutNUcastPkts,  
        ?ifInErrors, 
        ?ifOutErrors,  
        ?ifInUnknownProtos,
        ?ifHCInOctets, 
        ?ifHCOutOctets,  
        ?ifHCInUcastPkts, 
        ?ifHCOutUcastPkts,  
        ?ifHCInMulticastPkts, 
        ?ifHCOutMulticastPkts,  
        ?ifHCInBroadcastPkts, 
        ?ifHCOutBroadcastPkts]).

-define(ipRouteDest, {routeDest, "1.3.6.1.2.1.4.21.1.1"}).
-define(ipRouteIfIndex, {routeIfIndex, "1.3.6.1.2.1.4.21.1.2"}).
-define(ipRouteMetric1, {routeMetric1, "1.3.6.1.2.1.4.21.1.3"}).
-define(ipRouteMetric2, {routeMetric2, "1.3.6.1.2.1.4.21.1.4"}).
-define(ipRouteMetric3, {routeMetric3, "1.3.6.1.2.1.4.21.1.5"}).
-define(ipRouteMetric4, {routeMetric4, "1.3.6.1.2.1.4.21.1.6"}).
-define(ipRouteNextHop, {routeNextHop, "1.3.6.1.2.1.4.21.1.7"}).
-define(ipRouteType, {routeType, "1.3.6.1.2.1.4.21.1.8"}).
-define(ipRouteProto, {routeProto, "1.3.6.1.2.1.4.21.1.9"}).
-define(ipRouteAge, {routeAge, "1.3.6.1.2.1.4.21.1.10"}).
-define(ipRouteMask, {routeMask, "1.3.6.1.2.1.4.21.1.11"}).
-define(ipRouteMetric5, {routeMetric5, "1.3.6.1.2.1.4.21.1.12"}).
-define(ipRouteInfo, {routeInfo, "1.3.6.1.2.1.4.21.1.13"}).

-define(ipRoute, [?ipRouteDest, 
        ?ipRouteIfIndex, 
        ?ipRouteMetric1,
        ?ipRouteNextHop,
        ?ipRouteType,
        ?ipRouteProto,
        ?ipRouteMask]).
