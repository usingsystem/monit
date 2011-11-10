-- MySQL dump 10.13  Distrib 5.1.37, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: monit
-- ------------------------------------------------------
-- Server version	5.1.37-1ubuntu5.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `agents`
--

DROP TABLE IF EXISTS `agents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `agents` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(50) DEFAULT NULL,
  `password` varchar(40) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `tenant_id` int(11) DEFAULT NULL,
  `host_id` int(11) DEFAULT NULL,
  `presence` varchar(40) DEFAULT 'unavailable' COMMENT 'available, unavailable, busy',
  `summary` varchar(100) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `agents`
--

LOCK TABLES `agents` WRITE;
/*!40000 ALTER TABLE `agents` DISABLE KEYS */;
INSERT INTO `agents` VALUES (11,'agent11.chenjx','7cda0c0a-3315-11df-af48-0026b9388a6f','agent11.chenjx',27,37,'unavailable',NULL,'2010-03-19 13:08:42','2010-03-19 13:08:42'),(12,'agent12.root','517a0aca-43c2-11df-a64b-6cf0494e0fad','agent12.root',1,15,'available',NULL,'2010-04-09 18:26:11','2010-04-16 16:01:17'),(14,'agent14.yufw','02bedbb6-46d5-11df-a64b-6cf0494e0fad','agent14.yufw',31,49,'unavailable',NULL,'2010-04-13 16:17:33','2010-04-13 16:17:33'),(15,'agent15.yufw','a970d16c-46da-11df-a64b-6cf0494e0fad','agent15.yufw',31,58,'unavailable',NULL,'2010-04-13 16:58:00','2010-04-13 16:58:00'),(16,'agent16.root','e7b014d6-476d-11df-a64b-6cf0494e0fad','agent16.root',1,63,'unavailable',NULL,'2010-04-14 10:32:00','2010-04-16 11:00:05'),(18,'agent18.root','f9bfc27e-47dc-11df-a64b-6cf0494e0fad','agent18.root',1,65,'unavailable',NULL,'2010-04-14 23:47:05','2010-04-14 23:47:05');
/*!40000 ALTER TABLE `agents` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `alerts`
--

DROP TABLE IF EXISTS `alerts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `alerts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL COMMENT 'service name',
  `service_id` int(11) DEFAULT NULL,
  `source_id` int(11) DEFAULT NULL COMMENT 'host or application',
  `source_type` int(2) DEFAULT NULL COMMENT '1:host 2:app 3:site',
  `tenant_id` int(11) DEFAULT NULL,
  `severity` int(2) DEFAULT '0',
  `status` int(2) DEFAULT '0',
  `status_type` int(2) DEFAULT NULL,
  `last_status` int(2) DEFAULT '0',
  `summary` varchar(200) DEFAULT NULL,
  `occur_count` int(11) DEFAULT NULL,
  `last_check` datetime DEFAULT NULL,
  `next_check` datetime DEFAULT NULL,
  `occured_at` datetime DEFAULT NULL,
  `changed_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `i_alerts_service_id` (`service_id`)
) ENGINE=InnoDB AUTO_INCREMENT=73 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `alerts`
--

LOCK TABLES `alerts` WRITE;
/*!40000 ALTER TABLE `alerts` DISABLE KEYS */;
INSERT INTO `alerts` VALUES (1,'sit0',103,45,1,1,1,1,2,0,'sit0 is down.',810,'2010-04-19 15:31:23','2010-04-19 15:36:23','2010-04-16 20:06:19','2010-04-16 20:06:19','2010-04-16 20:06:34','2010-04-19 15:32:13'),(2,'eth2',247,56,1,33,1,1,2,0,'eth2 is down.',810,'2010-04-19 15:31:34','2010-04-19 15:36:34','2010-04-16 20:06:24','2010-04-16 20:06:24','2010-04-16 20:06:34','2010-04-19 15:32:13'),(4,'eth3',102,45,1,1,1,1,2,0,'eth3 is down.',810,'2010-04-19 15:31:41','2010-04-19 15:36:41','2010-04-16 20:06:39','2010-04-16 20:06:39','2010-04-16 20:07:36','2010-04-19 15:32:13'),(5,'eth3',248,56,1,33,1,1,2,0,'eth3 is down.',810,'2010-04-19 15:31:46','2010-04-19 15:36:46','2010-04-16 20:06:39','2010-04-16 20:06:39','2010-04-16 20:07:36','2010-04-19 15:32:13'),(6,'eth2',245,52,1,33,1,1,2,0,'eth2 is down.',810,'2010-04-19 15:31:48','2010-04-19 15:36:48','2010-04-16 20:06:42','2010-04-16 20:06:42','2010-04-16 20:07:36','2010-04-19 15:32:13'),(7,'系统负载 - SNMP',178,59,1,31,3,3,2,0,'snmp failure!',810,'2010-04-19 15:31:45','2010-04-19 15:36:45','2010-04-16 20:06:38','2010-04-16 20:06:38','2010-04-16 20:07:36','2010-04-19 15:32:13'),(8,'eth0',218,62,1,29,1,1,2,0,'eth0 is down.',810,'2010-04-19 15:31:54','2010-04-19 15:36:54','2010-04-16 20:06:52','2010-04-16 20:06:52','2010-04-16 20:07:36','2010-04-19 15:32:13'),(9,'sit0',200,56,1,33,1,1,2,0,'sit0 is down.',810,'2010-04-19 15:32:08','2010-04-19 15:37:08','2010-04-16 20:07:04','2010-04-16 20:07:04','2010-04-16 20:07:36','2010-04-19 15:32:13'),(10,'eth1',219,62,1,29,1,1,2,0,'eth1 is down.',809,'2010-04-19 15:27:19','2010-04-19 15:32:19','2010-04-16 20:07:05','2010-04-16 20:07:05','2010-04-16 20:07:36','2010-04-19 15:28:13'),(11,'Ping',74,24,1,1,2,2,2,0,'Packet loss = 100%',809,'2010-04-19 15:27:28','2010-04-19 15:32:28','2010-04-16 20:07:20','2010-04-16 20:07:20','2010-04-16 20:07:36','2010-04-19 15:28:13'),(19,'eth3',243,52,1,33,1,1,2,0,'eth3 is down.',809,'2010-04-19 15:28:03','2010-04-19 15:33:03','2010-04-16 20:07:59','2010-04-16 20:07:59','2010-04-16 20:08:13','2010-04-19 15:28:13'),(20,'内存监测 - SNMP',157,56,1,33,0,0,2,1,'memory usage: 96%',11,'2010-04-19 14:44:07','2010-04-19 14:54:07','2010-04-19 13:03:07','2010-04-19 14:44:07','2010-04-16 20:08:13','2010-04-19 14:44:13'),(21,'Nginx状态监测',88,9,2,19,3,3,2,0,'/bin/sh: /opt/monit/plugins/check_nginx_status.py: not found',809,'2010-04-19 15:28:10','2010-04-19 15:33:10','2010-04-16 20:08:02','2010-04-16 20:08:02','2010-04-16 20:08:13','2010-04-19 15:28:13'),(22,'sit0',190,58,1,31,1,1,2,0,'sit0 is down.',809,'2010-04-19 15:28:18','2010-04-19 15:33:18','2010-04-16 20:08:09','2010-04-16 20:08:09','2010-04-16 20:08:13','2010-04-19 15:30:13'),(23,'磁盘监测 - ',73,18,1,1,3,3,2,0,'snmp error.',809,'2010-04-19 15:28:07','2010-04-19 15:33:07','2010-04-16 20:08:03','2010-04-16 20:08:03','2010-04-16 20:08:13','2010-04-19 15:30:13'),(26,'eth3',118,47,1,1,1,1,2,0,'eth3 is down.',809,'2010-04-19 15:28:23','2010-04-19 15:33:23','2010-04-16 20:08:20','2010-04-16 20:08:20','2010-04-16 20:10:13','2010-04-19 15:30:13'),(27,'sit0',284,53,1,33,1,1,2,0,'sit0 is down.',809,'2010-04-19 15:28:34','2010-04-19 15:33:34','2010-04-16 20:08:27','2010-04-16 20:08:27','2010-04-16 20:10:13','2010-04-19 15:30:13'),(28,'Ping',43,18,1,1,2,2,2,0,'Packet loss = 100%',809,'2010-04-19 15:28:51','2010-04-19 15:33:51','2010-04-16 20:08:46','2010-04-16 20:08:46','2010-04-16 20:10:13','2010-04-19 15:30:13'),(29,'sit0',217,55,1,33,1,1,2,0,'sit0 is down.',809,'2010-04-19 15:29:01','2010-04-19 15:34:01','2010-04-16 20:09:00','2010-04-16 20:09:00','2010-04-16 20:10:13','2010-04-19 15:30:13'),(30,'eth2',182,58,1,31,1,1,2,0,'eth2 is down.',809,'2010-04-19 15:29:11','2010-04-19 15:34:11','2010-04-16 20:09:05','2010-04-16 20:09:05','2010-04-16 20:10:13','2010-04-19 15:30:13'),(31,'接口流量 - eth2',71,20,1,1,1,1,2,3,'eth2 is down.',809,'2010-04-19 15:29:19','2010-04-19 15:34:19','2010-04-16 20:09:16','2010-04-19 04:14:18','2010-04-16 20:10:13','2010-04-19 15:30:13'),(32,'sit0',222,62,1,29,1,1,2,0,'sit0 is down.',809,'2010-04-19 15:29:39','2010-04-19 15:34:39','2010-04-16 20:09:36','2010-04-16 20:09:36','2010-04-16 20:10:13','2010-04-19 15:30:13'),(33,'eth1',244,52,1,33,1,1,2,0,'eth1 is down.',808,'2010-04-19 15:30:15','2010-04-19 15:35:15','2010-04-16 20:10:06','2010-04-16 20:10:06','2010-04-16 20:10:13','2010-04-19 15:32:13'),(41,'Disk - /opt',197,56,1,33,1,1,2,0,'Usage of /opt: 68%',809,'2010-04-19 15:30:22','2010-04-19 15:35:22','2010-04-16 20:10:15','2010-04-16 20:10:15','2010-04-16 20:12:13','2010-04-19 15:32:13'),(42,'sit0',179,51,1,29,1,1,2,0,'sit0 is down.',809,'2010-04-19 15:30:26','2010-04-19 15:35:26','2010-04-16 20:10:22','2010-04-16 20:10:22','2010-04-16 20:12:13','2010-04-19 15:32:13'),(43,'Disk - /',199,56,1,33,1,1,2,0,'Usage of /: 60%',809,'2010-04-19 15:30:32','2010-04-19 15:35:32','2010-04-16 20:10:22','2010-04-16 20:10:22','2010-04-16 20:12:13','2010-04-19 15:32:13'),(44,'sit0',211,52,1,33,1,1,2,0,'sit0 is down.',809,'2010-04-19 15:30:35','2010-04-19 15:35:35','2010-04-16 20:10:31','2010-04-16 20:10:31','2010-04-16 20:12:13','2010-04-19 15:32:13'),(45,'sit0',298,54,1,33,1,1,2,0,'sit0 is down.',809,'2010-04-19 15:30:37','2010-04-19 15:35:37','2010-04-16 20:10:31','2010-04-16 20:10:31','2010-04-16 20:12:13','2010-04-19 15:32:13'),(46,'HTTP监测',87,31,1,19,2,2,2,0,'timed out',809,'2010-04-19 15:30:37','2010-04-19 15:35:37','2010-04-16 20:10:32','2010-04-16 20:10:32','2010-04-16 20:12:13','2010-04-19 15:32:13'),(47,'eth2',138,24,1,1,1,1,2,0,'eth2 is down.',809,'2010-04-19 15:30:47','2010-04-19 15:35:47','2010-04-16 20:10:41','2010-04-16 20:10:41','2010-04-16 20:12:13','2010-04-19 15:32:13'),(48,'sit0',305,50,1,33,1,1,2,0,'sit0 is down.',809,'2010-04-19 15:31:14','2010-04-19 15:36:14','2010-04-16 20:11:08','2010-04-16 20:11:08','2010-04-16 20:12:13','2010-04-19 15:32:13'),(56,'内存监测 - SNMP',166,54,1,33,1,1,2,0,'memory usage: 98%',404,'2010-04-19 15:23:06','2010-04-19 15:33:06','2010-04-16 20:13:03','2010-04-16 20:13:03','2010-04-16 20:14:13','2010-04-19 15:24:13'),(58,'端口扫描',310,15,1,1,3,3,2,0,'Warning: Hostname localhost resolves to 2 IPs. Using 127.0.0.1.\nOK - scan ports successfully. \nPort	State	Service\n22/tcp   open          ssh\n25/tcp   open          smtp\n80/tcp   open          http\n139',134,'2010-04-19 15:04:03','2010-04-19 15:34:03','2010-04-16 20:34:03','2010-04-16 20:34:03','2010-04-16 20:34:13','2010-04-19 15:04:13'),(59,'PING监测',128,47,1,1,0,0,1,1,'Packet loss = 0%, RTA = 92.655ms',2,'2010-04-18 22:46:11','2010-04-18 22:46:41','2010-04-18 22:45:41','2010-04-18 22:46:11','2010-04-16 21:06:13','2010-04-18 22:48:13'),(60,'内存监测 - SNMP',147,49,1,31,1,1,2,0,'memory usage: 97%',652,'2010-04-19 15:29:15','2010-04-19 15:34:15','2010-04-17 09:13:13','2010-04-17 09:13:13','2010-04-16 23:38:13','2010-04-19 15:30:13'),(62,'内存监测 - SNMP',162,52,1,33,0,0,2,1,'memory usage: 97%',3,'2010-04-19 08:53:02','2010-04-19 09:03:02','2010-04-19 08:42:02','2010-04-19 08:53:02','2010-04-17 04:24:13','2010-04-19 08:54:13'),(64,'内存监测',75,24,1,1,1,1,2,0,'memory usage: 99%',107,'2010-04-19 15:29:29','2010-04-19 15:34:29','2010-04-19 06:43:28','2010-04-19 06:43:28','2010-04-17 16:34:13','2010-04-19 15:30:13'),(65,'PING监测',176,57,1,10,0,0,2,2,'Packet loss = 0%, RTA = 53.099ms',2,'2010-04-17 17:08:36','2010-04-17 17:18:36','2010-04-17 17:07:06','2010-04-17 17:08:36','2010-04-17 17:08:13','2010-04-17 17:10:13'),(66,'PING监测',167,55,1,33,0,0,2,1,'Packet loss = 0%, RTA = 22.005ms',2,'2010-04-17 20:42:31','2010-04-17 20:52:31','2010-04-17 20:41:31','2010-04-17 20:42:31','2010-04-17 20:42:13','2010-04-17 20:44:13'),(67,'PING监测',113,45,1,1,0,0,2,1,'Packet loss = 0%, RTA = 45.706ms',2,'2010-04-17 21:41:01','2010-04-17 21:46:01','2010-04-17 21:35:01','2010-04-17 21:41:01','2010-04-17 21:36:13','2010-04-17 21:42:13'),(68,'PING监测',165,54,1,33,0,0,2,1,'Packet loss = 0%, RTA = 14.835ms',3,'2010-04-19 15:30:18','2010-04-19 15:40:18','2010-04-19 15:18:18','2010-04-19 15:30:18','2010-04-18 14:56:13','2010-04-19 15:32:13'),(69,'PING监测',163,53,1,33,0,0,2,1,'Packet loss = 0%, RTA = 15.190ms',2,'2010-04-18 22:54:28','2010-04-18 23:04:28','2010-04-18 22:53:28','2010-04-18 22:54:28','2010-04-18 22:54:13','2010-04-18 22:56:13'),(70,'Memory',60,20,1,1,0,0,2,3,'memory usage: 95%',2,'2010-04-19 04:10:18','2010-04-19 04:15:18','2010-04-19 04:09:18','2010-04-19 04:10:18','2010-04-19 04:10:13','2010-04-19 04:12:13'),(71,'磁盘IO - cciss/c0d0p3',65,20,1,1,0,0,2,3,'cciss/c0d0p3: reads=0.00KB/s, writes=0.00KB/s',2,'2010-04-19 04:10:18','2010-04-19 04:15:18','2010-04-19 04:09:18','2010-04-19 04:10:18','2010-04-19 04:10:13','2010-04-19 04:12:13');
/*!40000 ALTER TABLE `alerts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `app_types`
--

DROP TABLE IF EXISTS `app_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `app_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `parent_id` int(11) DEFAULT NULL COMMENT '1:parent 2:son',
  `level` int(11) DEFAULT NULL,
  `creator` int(11) DEFAULT NULL,
  `remark` varchar(100) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `app_types`
--

LOCK TABLES `app_types` WRITE;
/*!40000 ALTER TABLE `app_types` DISABLE KEYS */;
INSERT INTO `app_types` VALUES (1,'/app',NULL,1,NULL,'应用',NULL,NULL),(2,'/app/db',1,1,NULL,'数据库分类','2010-01-14 03:06:27','2010-01-14 03:06:27'),(3,'/app/web',1,1,NULL,'web应用分类',NULL,NULL),(4,'/app/web/lighttpd',3,2,NULL,'监控Lighttpd运行时并发连接数、吞吐率（请求数/秒），以及更多的详细性能报表和分析报告。',NULL,NULL),(5,'/app/web/nginx',3,2,NULL,'监控Nginx运行时并发连接数、吞吐率（请求数/秒）、持久连接利用率，以及更多的详细性能报表和分析报告。',NULL,NULL),(6,'/app/db/mysql',2,2,NULL,'监控MySQL运行时的各项性能数据，包括查询吞吐率、查询缓存、索引缓存、并发连接、流量以及表锁定等性能报表和分析报告。',NULL,NULL),(7,'/app/web/apache',3,2,NULL,'监控Apache运行时并发连接数、吞吐率（请求数/秒），以及更多的详细性能报表和分析报告。',NULL,NULL);
/*!40000 ALTER TABLE `app_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `apps`
--

DROP TABLE IF EXISTS `apps`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `apps` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  `tag` varchar(50) DEFAULT NULL,
  `uuid` varchar(50) DEFAULT 'uuid()',
  `host_id` int(11) DEFAULT NULL,
  `tenant_id` int(11) DEFAULT NULL,
  `agent_id` int(11) DEFAULT NULL,
  `type_id` int(11) DEFAULT NULL,
  `port` int(11) DEFAULT NULL,
  `login_name` varchar(50) DEFAULT NULL,
  `sid` varchar(50) DEFAULT NULL,
  `password` varchar(50) DEFAULT NULL,
  `status_url` varchar(50) DEFAULT NULL,
  `discovery_state` int(2) DEFAULT '0' COMMENT '0:undiscovery 1:discoveried 2:rediscovery',
  `last_check` datetime DEFAULT NULL,
  `next_check` datetime DEFAULT NULL,
  `duration` int(11) DEFAULT NULL,
  `status` int(2) DEFAULT '0',
  `summary` varchar(200) DEFAULT NULL,
  `last_update` datetime DEFAULT NULL,
  `last_time_up` datetime DEFAULT NULL,
  `last_time_down` datetime DEFAULT NULL,
  `last_time_pending` datetime DEFAULT NULL,
  `last_time_unknown` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `apps`
--

LOCK TABLES `apps` WRITE;
/*!40000 ALTER TABLE `apps` DISABLE KEYS */;
INSERT INTO `apps` VALUES (7,'MySQL',NULL,'8553d614-0a51-11df-8e4e-0026b9388a6f',15,1,NULL,6,3306,'root',NULL,'public',NULL,0,'2010-04-19 15:30:33','2010-04-19 15:35:33',NULL,0,'received=120,sent=89',NULL,'2010-04-19 15:30:33',NULL,'2010-04-12 21:03:50','2010-04-12 23:33:32','2010-01-26 16:05:40','2010-04-19 15:32:13'),(9,'sun',NULL,'9fac0dba-e6d9-11de-9b56-0026b9388a6f',31,19,NULL,5,NULL,NULL,NULL,NULL,'',0,'2010-04-19 15:28:10','2010-04-19 15:33:10',NULL,2,'/bin/sh: /opt/monit/plugins/check_nginx_status.py: not found',NULL,NULL,NULL,NULL,'2010-04-19 15:28:10','2009-12-12 12:48:42','2010-04-19 15:32:13'),(10,'sun',NULL,'b116a36c-e6d9-11de-9b56-0026b9388a6f',31,19,NULL,4,NULL,NULL,NULL,NULL,'',0,NULL,NULL,NULL,3,NULL,NULL,NULL,NULL,NULL,NULL,'2009-12-12 12:49:12','2009-12-12 12:49:12');
/*!40000 ALTER TABLE `apps` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `monit`.`trigger_apps_insert` AFTER INSERT ON monit.apps FOR EACH ROW
BEGIN
    IF (new.host_id IS NOT NULL) AND (new.uuid IS NOT NULL)
   THEN 
      INSERT INTO task_changed 
            (
                target_type,
                target_id,
                uuid,
								oper_type,
								discovery_state,
								addr,
								created_at,
								updated_at
            )
      VALUES (
                2,
								new.id,
								new.uuid,
								1,
								new.discovery_state,
								(select addr from hosts where id = new.host_id),
								now(),
								now()
             );
   END IF;   
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `monit`.`trigger_apps_update` AFTER UPDATE ON monit.apps FOR EACH ROW
BEGIN
    IF (old.host_id is null and new.host_id IS NOT NULL) or (old.uuid is null and new.uuid IS NOT NULL)
   THEN 
      INSERT INTO task_changed 
            (
                target_type,
                target_id,
                uuid,
								oper_type,
								discovery_state,
								addr,
								created_at,
								updated_at
            )
      VALUES (
                2,
								new.id,
								new.uuid,
								1,
								new.discovery_state,
								(select addr from hosts where id = new.host_id),
								old.created_at,
								now()
             );
   elseif (old.host_id <> new.host_id) or (old.uuid <> new.uuid) then
      INSERT INTO task_changed 
            (
                target_type,
                target_id,
                uuid,
								oper_type,
								discovery_state,
								addr,
								created_at,
								updated_at
            )
      VALUES (
                2,
								new.id,
								new.uuid,
								3,
								new.discovery_state,
								(select addr from hosts where id = new.host_id),
								old.created_at,
								now()
             );
   END IF;   
    
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `monit`.`trigger_apps_delete` AFTER DELETE ON monit.apps FOR EACH ROW
BEGIN
    IF (old.host_id IS NOT NULL) AND (old.uuid IS NOT NULL)
   THEN 
      INSERT INTO task_changed 
            (
                target_type,
                target_id,
                uuid,
                                                                oper_type,
                                                                discovery_state,
                                                                addr,
                                                                created_at,
                                                                updated_at
            )
      VALUES (
                2,
                                                                old.id,
                                                                old.uuid,
                                                                2,
                                                                old.discovery_state,
                                                                (select addr from hosts where id = old.host_id),
                                                                old.created_at,
                                                                now()
             );
     
   END IF;   
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `business`
--

DROP TABLE IF EXISTS `business`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `business` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  `tenant_id` int(11) DEFAULT NULL,
  `parent_id` int(11) DEFAULT NULL,
  `remark` varchar(100) DEFAULT NULL,
  `last_check` datetime DEFAULT NULL,
  `next_check` datetime DEFAULT NULL,
  `duration` int(11) DEFAULT NULL,
  `avail_status` int(2) DEFAULT NULL,
  `summary` varchar(200) DEFAULT NULL,
  `last_time_ok` datetime DEFAULT NULL,
  `last_time_warning` datetime DEFAULT NULL,
  `last_time_critical` datetime DEFAULT NULL,
  `last_time_unknown` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `business`
--

LOCK TABLES `business` WRITE;
/*!40000 ALTER TABLE `business` DISABLE KEYS */;
/*!40000 ALTER TABLE `business` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `business_services`
--

DROP TABLE IF EXISTS `business_services`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `business_services` (
  `business_id` int(11) DEFAULT NULL,
  `service_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `business_services`
--

LOCK TABLES `business_services` WRITE;
/*!40000 ALTER TABLE `business_services` DISABLE KEYS */;
/*!40000 ALTER TABLE `business_services` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `checked_status`
--

DROP TABLE IF EXISTS `checked_status`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `checked_status` (
  `service_id` int(11) DEFAULT NULL,
  `uuid` varchar(50) DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  `summary` varchar(200) DEFAULT NULL,
  `last_check` bigint(20) NOT NULL,
  `next_check` bigint(20) NOT NULL,
  `status_type` int(2) DEFAULT NULL COMMENT '1:Transient 2:Permanent',
  `duration` int(11) DEFAULT NULL,
  `latency` int(11) DEFAULT NULL,
  `current_attempts` int(11) DEFAULT NULL,
  `oper_tag` int(2) DEFAULT NULL COMMENT 'used when deal with data',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  UNIQUE KEY `i_checked_status_service_id` (`service_id`),
  KEY `i_checked_status_uuid` (`uuid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `checked_status`
--

LOCK TABLES `checked_status` WRITE;
/*!40000 ALTER TABLE `checked_status` DISABLE KEYS */;
INSERT INTO `checked_status` VALUES (146,'297629ee-46d5-11df-a64b-6cf0494e0fad',0,'Cpu(s):  0.5%us,  0.2%sy,  0.0%ni, 99.3%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st',1271662335,1271662635,2,0,0,1,NULL,'2010-04-19 15:32:15','2010-04-19 15:32:15'),(59,'437c8fe2-0fd8-11df-b134-0026b9388a6f',0,'load average: 1.62, 2.89, 3.19',1271662335,1271662635,2,0,0,1,NULL,'2010-04-19 15:32:15','2010-04-19 15:32:15'),(219,'7cbf30c4-46de-11df-a64b-6cf0494e0fad',1,'eth1 is down.',1271662339,1271662639,2,1,0,1,NULL,'2010-04-19 15:32:20','2010-04-19 15:32:20'),(215,'73ef87ce-46dd-11df-a64b-6cf0494e0fad',0,'Usage of /opt: 30%',1271662344,1271662644,2,0,0,1,NULL,'2010-04-19 15:32:24','2010-04-19 15:32:24'),(227,'84ff361c-46de-11df-a64b-6cf0494e0fad',0,'dm-1: reads=0.00KB/s, writes=0.00KB/s',1271662349,1271662649,2,0,0,1,NULL,'2010-04-19 15:32:29','2010-04-19 15:32:29'),(52,'f93c3982-0fd7-11df-b134-0026b9388a6f',0,'eth0 is up.',1271662350,1271662650,2,1,0,1,NULL,'2010-04-19 15:32:31','2010-04-19 15:32:31'),(205,'52a5491e-46dd-11df-a64b-6cf0494e0fad',0,'Usage of /opt: 0%',1271662351,1271662651,2,0,0,1,NULL,'2010-04-19 15:32:31','2010-04-19 15:32:31'),(143,'574ca270-464f-11df-a64b-6cf0494e0fad',0,'dm-0: reads=0.00KB/s, writes=189.58KB/s',1271662351,1271662651,2,0,0,1,NULL,'2010-04-19 15:32:31','2010-04-19 15:32:31'),(74,'da7eb5da-1156-11df-b134-0026b9388a6f',2,'Packet loss = 100%',1271662348,1271662648,2,5,0,1,NULL,'2010-04-19 15:32:33','2010-04-19 15:32:33'),(177,'61ef0930-46da-11df-a64b-6cf0494e0fad',0,'load average: 1.41, 1.04, 1.01',1271662353,1271662653,2,0,0,1,NULL,'2010-04-19 15:32:33','2010-04-19 15:32:33'),(167,'e525eede-46d7-11df-a64b-6cf0494e0fad',0,'Packet loss = 0%, RTA = 22.850ms',1271662351,1271662951,2,3,0,1,NULL,'2010-04-19 15:32:34','2010-04-19 15:32:34'),(196,'14f4255e-46dd-11df-a64b-6cf0494e0fad',0,'sda: reads=0.71KB/s, writes=181.25KB/s',1271662354,1271662654,2,0,0,1,NULL,'2010-04-19 15:32:34','2010-04-19 15:32:34'),(61,'5515e3de-0fd8-11df-b134-0026b9388a6f',0,'Swap usage: 6%',1271662354,1271662654,2,0,0,1,NULL,'2010-04-19 15:32:34','2010-04-19 15:32:34'),(287,'8a8c360a-479e-11df-a64b-6cf0494e0fad',0,'sda1: reads=0.00KB/s, writes=12.45KB/s',1271662355,1271662655,2,0,0,1,NULL,'2010-04-19 15:32:35','2010-04-19 15:32:35'),(238,'3c963dec-46ea-11df-a64b-6cf0494e0fad',0,'sdd1: reads=0.00KB/s, writes=0.00KB/s',1271662356,1271662656,2,0,0,1,NULL,'2010-04-19 15:32:36','2010-04-19 15:32:36'),(300,'dfdeb8f2-479f-11df-a64b-6cf0494e0fad',0,'sda1: reads=0.00KB/s, writes=4.44KB/s',1271662364,1271662664,2,0,0,1,NULL,'2010-04-19 15:32:44','2010-04-19 15:32:44'),(242,'444713b8-46ea-11df-a64b-6cf0494e0fad',0,'sda5: reads=0.00KB/s, writes=0.64KB/s',1271662365,1271662665,2,0,0,1,NULL,'2010-04-19 15:32:45','2010-04-19 15:32:45'),(148,'a180c4f8-46d5-11df-a64b-6cf0494e0fad',0,'Packet loss = 0%, RTA = 53.094ms',1271662362,1271662662,2,3,0,1,NULL,'2010-04-19 15:32:45','2010-04-19 15:32:45'),(92,'6477d17e-3bd5-11df-af48-0026b9388a6f',0,'Packet loss = 0%, RTA = 0.021ms',1271662364,1271662664,2,3,0,1,NULL,'2010-04-19 15:32:47','2010-04-19 15:32:47'),(135,'423ea080-464b-11df-a64b-6cf0494e0fad',0,'1.090 seconds response time. www.opengoss.com returns 222.73.68.35',1271662367,1271662667,2,1,0,1,NULL,'2010-04-19 15:32:48','2010-04-19 15:32:48'),(152,'a3651476-46d6-11df-a64b-6cf0494e0fad',0,'Packet loss = 0%, RTA = 13.904ms',1271662366,1271662966,2,3,0,1,NULL,'2010-04-19 15:32:49','2010-04-19 15:32:49'),(139,'508bb336-464f-11df-a64b-6cf0494e0fad',0,'Usage of /: 9%',1271662369,1271662669,2,1,0,1,NULL,'2010-04-19 15:32:50','2010-04-19 15:32:50'),(203,'4fb3bd8a-46dd-11df-a64b-6cf0494e0fad',0,'sda1: reads=0.00KB/s, writes=3.58KB/s',1271662371,1271662671,2,0,0,1,NULL,'2010-04-19 15:32:51','2010-04-19 15:32:51'),(123,'bc61d4f8-4647-11df-a64b-6cf0494e0fad',0,'Usage of /: 5%',1271662374,1271662674,2,0,0,1,NULL,'2010-04-19 15:32:54','2010-04-19 15:32:54');
/*!40000 ALTER TABLE `checked_status` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `disco_services`
--

DROP TABLE IF EXISTS `disco_services`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `disco_services` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  `serviceable_type` int(11) DEFAULT NULL COMMENT '1:host 2:app 3:site',
  `serviceable_id` int(11) DEFAULT NULL,
  `tenant_id` int(11) DEFAULT NULL,
  `agent_id` int(11) DEFAULT NULL,
  `type_id` int(11) DEFAULT NULL,
  `params` varchar(200) DEFAULT NULL,
  `command` varchar(100) DEFAULT NULL,
  `summary` varchar(200) DEFAULT NULL,
  `desc` varchar(200) DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `service_command_params` (`serviceable_type`,`serviceable_id`,`command`,`params`)
) ENGINE=InnoDB AUTO_INCREMENT=344 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `disco_services`
--

LOCK TABLES `disco_services` WRITE;
/*!40000 ALTER TABLE `disco_services` DISABLE KEYS */;
INSERT INTO `disco_services` VALUES (303,'eth1',1,53,33,NULL,6,'host=${host.addr}&community=${host.community}&ifindex=3','check_if',NULL,NULL,NULL,'2010-04-14 16:19:23'),(304,'eth2',1,53,33,NULL,6,'host=${host.addr}&community=${host.community}&ifindex=4','check_if',NULL,NULL,NULL,'2010-04-14 16:19:23'),(305,'eth3',1,53,33,NULL,6,'host=${host.addr}&community=${host.community}&ifindex=5','check_if',NULL,NULL,NULL,'2010-04-14 16:19:23'),(312,'DiskIO - sda2',1,53,33,NULL,12,'host=${host.addr}&community=${host.community}&index=19','check_diskio_ucd',NULL,NULL,NULL,'2010-04-14 16:19:24'),(313,'DiskIO - sda3',1,53,33,NULL,12,'host=${host.addr}&community=${host.community}&index=20','check_diskio_ucd',NULL,NULL,NULL,'2010-04-14 16:19:24'),(314,'DiskIO - sda4',1,53,33,NULL,12,'host=${host.addr}&community=${host.community}&index=21','check_diskio_ucd',NULL,NULL,NULL,'2010-04-14 16:19:24'),(315,'DiskIO - sda5',1,53,33,NULL,12,'host=${host.addr}&community=${host.community}&index=22','check_diskio_ucd',NULL,NULL,NULL,'2010-04-14 16:19:24'),(317,'eth1',1,54,33,NULL,6,'host=${host.addr}&community=${host.community}&ifindex=3','check_if',NULL,NULL,NULL,'2010-04-14 16:25:23'),(318,'eth2',1,54,33,NULL,6,'host=${host.addr}&community=${host.community}&ifindex=4','check_if',NULL,NULL,NULL,'2010-04-14 16:25:23'),(319,'eth3',1,54,33,NULL,6,'host=${host.addr}&community=${host.community}&ifindex=5','check_if',NULL,NULL,NULL,'2010-04-14 16:25:23'),(326,'DiskIO - sda2',1,54,33,NULL,12,'host=${host.addr}&community=${host.community}&index=19','check_diskio_ucd',NULL,NULL,NULL,'2010-04-14 16:25:24'),(327,'DiskIO - sda3',1,54,33,NULL,12,'host=${host.addr}&community=${host.community}&index=20','check_diskio_ucd',NULL,NULL,NULL,'2010-04-14 16:25:24'),(328,'DiskIO - sda4',1,54,33,NULL,12,'host=${host.addr}&community=${host.community}&index=21','check_diskio_ucd',NULL,NULL,NULL,'2010-04-14 16:25:24'),(329,'DiskIO - sda5',1,54,33,NULL,12,'host=${host.addr}&community=${host.community}&index=22','check_diskio_ucd',NULL,NULL,NULL,'2010-04-14 16:25:24'),(331,'eth1',1,50,33,NULL,6,'host=${host.addr}&community=${host.community}&ifindex=3','check_if',NULL,NULL,NULL,'2010-04-14 16:27:23'),(332,'eth2',1,50,33,NULL,6,'host=${host.addr}&community=${host.community}&ifindex=4','check_if',NULL,NULL,NULL,'2010-04-14 16:27:23'),(333,'eth3',1,50,33,NULL,6,'host=${host.addr}&community=${host.community}&ifindex=5','check_if',NULL,NULL,NULL,'2010-04-14 16:27:23'),(340,'DiskIO - sda2',1,50,33,NULL,12,'host=${host.addr}&community=${host.community}&index=19','check_diskio_ucd',NULL,NULL,NULL,'2010-04-14 16:27:23'),(341,'DiskIO - sda3',1,50,33,NULL,12,'host=${host.addr}&community=${host.community}&index=20','check_diskio_ucd',NULL,NULL,NULL,'2010-04-14 16:27:23'),(342,'DiskIO - sda4',1,50,33,NULL,12,'host=${host.addr}&community=${host.community}&index=21','check_diskio_ucd',NULL,NULL,NULL,'2010-04-14 16:27:23'),(343,'DiskIO - sda5',1,50,33,NULL,12,'host=${host.addr}&community=${host.community}&index=22','check_diskio_ucd',NULL,NULL,NULL,'2010-04-14 16:27:23');
/*!40000 ALTER TABLE `disco_services` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `disco_types`
--

DROP TABLE IF EXISTS `disco_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `disco_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `object_type` int(2) DEFAULT '1' COMMENT '1:host_types 2:app_types',
  `object_type_id` int(11) DEFAULT NULL,
  `method` int(11) DEFAULT NULL,
  `command` varchar(100) DEFAULT NULL,
  `args` varchar(255) DEFAULT NULL,
  `service_type_id` int(11) DEFAULT NULL,
  `external` int(2) DEFAULT '1',
  `remark` varchar(100) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `disco_types`
--

LOCK TABLES `disco_types` WRITE;
/*!40000 ALTER TABLE `disco_types` DISABLE KEYS */;
INSERT INTO `disco_types` VALUES (25,'接口发现－SNMP',1,2,1,'disco_if','host=${host.addr}&community=${host.community}',6,0,'通过SNMP发现服务器接口，并监测接口流量','0000-00-00 00:00:00',NULL),(26,'磁盘IO发现 - SNMP',1,2,1,'disco_diskio_ucd','host=${host.addr}&community=${host.community}',12,0,'通过SNMP发现磁盘，并监测磁盘容量','0000-00-00 00:00:00',NULL),(27,'磁盘发现－SNMP',1,2,1,'disco_disk_hr','host=${host.addr}&community=${host.community}',11,0,'通过SNMP发现磁盘列表，并监测磁盘容量','0000-00-00 00:00:00',NULL),(30,'Windows CPU负载发现－SNMP',1,5,1,'disco_cpu_hr','host=${host.addr}&community=${host.community}',26,0,'通过SNMP发现磁盘列表，并监测磁盘容量','0000-00-00 00:00:00',NULL),(31,'Windows 进程总数发现－SNMP',1,5,1,'disco_task_hr','host=${host.addr}&community=${host.community}',29,0,'通过SNMP发现磁盘列表，并监测磁盘容量','0000-00-00 00:00:00',NULL),(32,'Windows磁盘发现－SNMP',1,5,1,'disco_disk_hr','host=${host.addr}&community=${host.community}',11,0,'通过SNMP发现磁盘列表，并监测磁盘容量','0000-00-00 00:00:00',NULL),(33,'Window 物理内存发现- SNMP',1,5,1,'disco_mem_hr','host=${host.addr}&community=${host.community}',27,0,'通过SNMP发现磁盘列表，并监测磁盘容量','0000-00-00 00:00:00',NULL),(34,'Window 虚拟内存发现- SNMP',1,5,1,'disco_virmem_hr','host=${host.addr}&community=${host.community}',28,0,'通过SNMP发现磁盘列表，并监测磁盘容量','0000-00-00 00:00:00',NULL),(35,'Window 进程发现- SNMP',1,5,1,'disco_process_hr','host=${host.addr}&community=${host.community}',30,0,'通过SNMP发现磁盘列表，并监测磁盘容量','0000-00-00 00:00:00',NULL);
/*!40000 ALTER TABLE `disco_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `host_types`
--

DROP TABLE IF EXISTS `host_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `host_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  `parent_id` int(11) DEFAULT NULL,
  `level` int(11) DEFAULT NULL COMMENT '1:parent 2:son',
  `creator` int(11) DEFAULT NULL,
  `remark` varchar(100) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `host_types`
--

LOCK TABLES `host_types` WRITE;
/*!40000 ALTER TABLE `host_types` DISABLE KEYS */;
INSERT INTO `host_types` VALUES (1,'/host',NULL,1,NULL,'All system','2010-01-14 03:06:27','2010-01-14 03:06:27'),(2,'/host/Linux',1,2,NULL,'Linux introduction','2010-01-14 03:06:27','2010-01-14 03:06:27'),(4,'/host/Unix',1,2,NULL,'Unix introduction','2010-01-14 03:06:27','2010-01-14 03:06:27'),(5,'/host/Windows',1,2,NULL,'Windows introduction','2010-01-14 03:06:27','2010-01-14 03:06:27'),(6,'/host/Unix/AIX',4,2,NULL,'AIX introduction','2010-01-14 03:06:27','2010-01-14 03:06:27'),(7,'/host/Unix/Solaris',4,2,NULL,'Solaris introduction','2010-01-14 03:06:27','2010-01-14 03:06:27'),(8,'/host/Linux/RedHat',2,2,NULL,'RedHat introduction','2010-01-14 03:06:27','2010-01-14 03:06:27'),(9,'/host/Linux/CentOS',2,2,NULL,'CentOS introduction','2010-01-14 03:06:27','2010-01-14 03:06:27'),(10,'/host/Linux/Debian',2,2,NULL,'Debian introduction','2010-01-14 03:06:27','2010-01-14 03:06:27'),(11,'/host/Linux/Ubuntu',2,2,NULL,'Ubuntu introduction','2010-01-14 03:06:27','2010-02-02 03:38:24'),(12,'/host/Linux/Gentoo',2,2,NULL,'Gentoo introduction','2010-01-14 03:06:27','2010-01-14 03:06:27'),(13,'/host/Unix/FreeBSD',4,2,NULL,'FreeBSD introduction','2010-01-14 03:06:27','2010-01-14 03:06:27'),(14,'/host/Unix/OpenBSD',4,2,NULL,'OpenBSD introduction','2010-01-14 03:06:27','2010-01-14 03:06:27'),(15,'/host/Unix/MacOSX',4,2,NULL,'Mac OS X',NULL,NULL);
/*!40000 ALTER TABLE `host_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hosts`
--

DROP TABLE IF EXISTS `hosts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hosts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  `tag` varchar(50) DEFAULT NULL,
  `model` varchar(50) DEFAULT NULL,
  `mac` varchar(20) DEFAULT NULL,
  `os_desc` varchar(50) DEFAULT NULL,
  `addr` varchar(50) NOT NULL,
  `uuid` varchar(50) DEFAULT NULL,
  `tenant_id` int(11) DEFAULT NULL,
  `agent_id` int(11) DEFAULT NULL,
  `is_support_remote` int(2) DEFAULT NULL COMMENT '0:false 1:true',
  `is_support_snmp` int(2) DEFAULT NULL COMMENT '0:false 1:true',
  `is_support_ssh` int(2) DEFAULT NULL COMMENT '0:false 1:true',
  `type_id` int(11) DEFAULT NULL,
  `port` int(11) DEFAULT NULL,
  `snmp_ver` varchar(20) DEFAULT NULL,
  `community` varchar(20) DEFAULT NULL,
  `discovery_state` int(2) DEFAULT '0' COMMENT '0:undiscovery 1:discoveried 2:rediscovery',
  `last_check` datetime DEFAULT NULL,
  `next_check` datetime DEFAULT NULL,
  `duration` int(11) DEFAULT NULL,
  `status` int(2) DEFAULT '0',
  `summary` varchar(200) DEFAULT NULL,
  `last_time_up` datetime DEFAULT NULL,
  `last_time_down` datetime DEFAULT NULL,
  `last_time_pending` datetime DEFAULT NULL,
  `last_time_unknown` datetime DEFAULT NULL,
  `last_time_unreachable` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=69 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hosts`
--

LOCK TABLES `hosts` WRITE;
/*!40000 ALTER TABLE `hosts` DISABLE KEYS */;
INSERT INTO `hosts` VALUES (15,'Monit服务器',NULL,NULL,NULL,NULL,'localhost','d7a4278a-0a28-11df-8e4e-0026b9388a6f',1,NULL,2,NULL,NULL,11,161,'v2c','public',0,'2010-04-19 15:31:59','2010-04-19 15:36:59',NULL,0,'Packet loss = 0%, RTA = 0.027ms','2010-04-19 15:31:59',NULL,NULL,NULL,NULL,'2010-01-26 00:39:41','2010-04-19 15:32:13'),(18,'云南 - WLAN - WEB服务器',NULL,NULL,NULL,NULL,'222.221.17.12','dd0c7432-0a52-11df-8e4e-0026b9388a6f',1,NULL,2,NULL,NULL,9,161,'v2c','public',0,'2010-04-19 14:51:21','2010-04-19 14:56:21',NULL,0,'302 Moved Temporarily, 98 bytes in 0.118 seconds','2010-04-19 14:51:21','2010-04-15 16:26:35',NULL,'2010-02-22 09:33:54',NULL,'2010-01-26 16:15:01','2010-04-19 15:32:13'),(20,'重庆 - WLAN - WEB服务器',NULL,NULL,NULL,NULL,'222.177.4.98','e01c6f6a-0fd4-11df-b134-0026b9388a6f',1,NULL,1,1,NULL,8,161,'v2c','public',0,'2010-04-19 15:29:26','2010-04-19 15:34:26',NULL,0,'Packet loss = 0%, RTA = 64.325ms','2010-04-19 15:29:26','2010-04-13 03:11:04',NULL,NULL,NULL,'2010-02-02 04:22:45','2010-04-19 15:32:13'),(24,'重庆 - WLAN - 采集1',NULL,NULL,NULL,NULL,'222.177.4.99','a68ad074-1156-11df-b134-0026b9388a6f',1,NULL,2,NULL,NULL,2,161,'v2c','public',1,'2010-04-19 15:30:59','2010-04-19 15:35:59',NULL,0,'sysUptime = 639744729, sysDescr = Linux localhost.localdomain 2.6.18-53.el5 #1 SMP Wed Oct 10 16:34:19 EDT 2007 x86_64, sysOid = 1.3.6.1.4.1.8072.3.2.10','2010-04-19 15:30:59',NULL,NULL,'2010-04-13 04:47:37',NULL,'2010-02-04 14:30:22','2010-04-19 15:32:13'),(29,'宁夏 - WLAN - WEB服务器',NULL,NULL,NULL,NULL,'119.60.9.67','1df5b80c-22b1-11df-88b1-0026b9388a6f',1,NULL,1,1,NULL,9,161,'v2c','public',0,'2010-04-19 15:30:42','2010-04-19 15:35:42',NULL,0,'Packet loss = 0%, RTA = 43.739ms','2010-04-19 15:30:42','2010-04-06 11:41:22',NULL,'2010-04-04 23:17:28',NULL,'2010-02-26 16:29:58','2010-04-19 15:32:13'),(31,' July',NULL,NULL,NULL,NULL,'192.168.1.78','813fc9a8-e6d8-11de-9b56-0026b9388a6f',19,NULL,1,1,NULL,4,161,'v2c','public',0,NULL,NULL,NULL,4,NULL,NULL,NULL,NULL,NULL,NULL,'2009-12-12 12:40:42','2009-12-12 12:40:42'),(33,'sun',NULL,NULL,NULL,NULL,'192.168.1.37','b7b1204a-e6d8-11de-9b56-0026b9388a6f',19,NULL,1,1,NULL,6,161,'v2c','public',0,NULL,NULL,NULL,4,NULL,NULL,NULL,NULL,NULL,NULL,'2009-12-12 12:42:13','2009-12-12 12:42:13'),(37,'测试主机',NULL,NULL,NULL,NULL,'192.168.1.3','4a20888e-3315-11df-af48-0026b9388a6f',27,NULL,NULL,1,NULL,2,161,'v2c','public',0,NULL,NULL,NULL,4,NULL,NULL,NULL,NULL,NULL,NULL,'2010-03-19 13:07:17','2010-03-19 13:08:29'),(45,'宁夏 - EPON - 采集服务器',NULL,NULL,NULL,NULL,'111.113.57.60','8fa86c44-4640-11df-a64b-6cf0494e0fad',1,NULL,NULL,1,NULL,2,161,'v2c','public',0,'2010-04-19 15:31:09','2010-04-19 15:36:09',NULL,0,'Packet loss = 0%, RTA = 43.062ms','2010-04-19 15:31:09','2010-04-15 16:49:35','2010-04-12 22:37:29',NULL,NULL,'2010-04-12 22:34:54','2010-04-19 15:32:13'),(47,'宁夏 - EPON - WEB服务器',NULL,NULL,NULL,NULL,'111.113.57.59','8a3298f0-4647-11df-a64b-6cf0494e0fad',1,NULL,NULL,1,NULL,2,161,'v2c','public',0,'2010-04-19 15:31:44','2010-04-19 15:36:44',NULL,0,'Packet loss = 0%, RTA = 43.927ms','2010-04-19 15:31:44','2010-04-15 16:50:08','2010-04-12 23:27:05',NULL,NULL,'2010-04-12 23:24:51','2010-04-19 15:32:13'),(48,'宁夏WLAN网管服务器WEB服务器',NULL,NULL,NULL,NULL,'119.60.9.67','5294dcd0-46d0-11df-a64b-6cf0494e0fad',30,NULL,NULL,1,NULL,2,161,'v2c','public',1,'2010-04-19 15:28:00','2010-04-19 15:33:00',NULL,0,'Packet loss = 0%, RTA = 43.747ms','2010-04-19 15:28:00',NULL,'2010-04-14 16:20:47',NULL,NULL,'2010-04-13 15:43:59','2010-04-19 15:32:13'),(49,'222.177.4.98',NULL,NULL,NULL,NULL,'222.177.4.98','a6174cae-46d4-11df-a64b-6cf0494e0fad',31,NULL,NULL,1,NULL,8,161,'v2c','public',0,'2010-04-19 15:29:15','2010-04-19 15:34:15',NULL,0,'memory usage: 97%','2010-04-19 15:29:15',NULL,'2010-04-13 16:21:23',NULL,NULL,'2010-04-13 16:14:57','2010-04-19 15:32:13'),(50,'WLAN_WEB',NULL,NULL,NULL,NULL,'202.109.128.29','1496f8d2-46d5-11df-a64b-6cf0494e0fad',33,NULL,NULL,1,NULL,2,161,'v2c','public',1,'2010-04-19 15:22:46','2010-04-19 15:32:46',NULL,0,'Packet loss = 0%, RTA = 13.977ms','2010-04-19 15:22:46',NULL,'2010-04-13 16:29:12',NULL,NULL,'2010-04-13 16:18:03','2010-04-19 15:32:13'),(51,'昆明采集',NULL,NULL,NULL,NULL,'112.112.7.54','1e639f96-46d5-11df-a64b-6cf0494e0fad',29,NULL,NULL,1,NULL,2,161,'v2c','public',1,'2010-04-19 15:27:42','2010-04-19 15:32:42',NULL,0,'Packet loss = 0%, RTA = 53.096ms','2010-04-19 15:27:42',NULL,'2010-04-13 16:21:59',NULL,NULL,'2010-04-13 16:18:19','2010-04-19 15:32:13'),(52,'WLAN_SERVER',NULL,NULL,NULL,NULL,'202.109.128.30','82bb6ed8-46d5-11df-a64b-6cf0494e0fad',33,NULL,NULL,1,NULL,2,161,'v2c','public',1,'2010-04-19 15:26:24','2010-04-19 15:36:24',NULL,0,'Packet loss = 0%, RTA = 21.715ms','2010-04-19 15:26:24',NULL,'2010-04-13 16:35:12',NULL,NULL,'2010-04-13 16:21:07','2010-04-19 15:32:13'),(53,'WLAN_NODE1',NULL,NULL,NULL,NULL,'202.109.128.31','9f8d6aca-46d5-11df-a64b-6cf0494e0fad',33,NULL,NULL,1,NULL,2,161,'v2c','public',1,'2010-04-19 15:24:31','2010-04-19 15:34:31',NULL,0,'Packet loss = 0%, RTA = 14.272ms','2010-04-19 15:24:31',NULL,'2010-04-13 16:36:56',NULL,NULL,'2010-04-13 16:21:56','2010-04-19 15:32:13'),(54,'WLAN_NODE2',NULL,NULL,NULL,NULL,'202.109.128.32','ac8851b8-46d5-11df-a64b-6cf0494e0fad',33,NULL,NULL,1,NULL,2,161,'v2c','public',1,'2010-04-19 15:30:18','2010-04-19 15:40:18',NULL,0,'Packet loss = 0%, RTA = 14.835ms','2010-04-19 15:30:18',NULL,'2010-04-13 16:37:34',NULL,NULL,'2010-04-13 16:22:18','2010-04-19 15:32:13'),(55,'WLAN_ORACLE_BP',NULL,NULL,NULL,NULL,'202.109.128.33','d5abb72e-46d5-11df-a64b-6cf0494e0fad',33,NULL,NULL,1,NULL,2,161,'v2c','public',1,'2010-04-19 15:22:31','2010-04-19 15:32:31',NULL,0,'Packet loss = 0%, RTA = 21.304ms','2010-04-19 15:22:31',NULL,'2010-04-13 16:38:12',NULL,NULL,'2010-04-13 16:23:27','2010-04-19 15:32:13'),(56,'WLAN_ORACLE',NULL,NULL,NULL,NULL,'202.109.128.27','e489faee-46d5-11df-a64b-6cf0494e0fad',33,NULL,NULL,1,NULL,2,161,'v2c','public',1,'2010-04-19 15:24:09','2010-04-19 15:34:09',NULL,0,'Packet loss = 0%, RTA = 14.041ms','2010-04-19 15:24:09',NULL,'2010-04-13 16:28:02',NULL,NULL,'2010-04-13 16:23:52','2010-04-19 15:32:13'),(57,'湖南WEB服务器',NULL,NULL,NULL,NULL,'124.232.136.140','e830b67a-46d9-11df-a64b-6cf0494e0fad',10,NULL,NULL,1,NULL,9,161,'v2c','public',0,'2010-04-19 15:28:41','2010-04-19 15:38:41',NULL,0,'Packet loss = 0%, RTA = 27.380ms','2010-04-19 15:28:41','2010-04-17 17:07:06','2010-04-13 16:53:21',NULL,NULL,'2010-04-13 16:52:36','2010-04-19 15:32:13'),(58,'从采集',NULL,NULL,NULL,NULL,'222.177.4.99','2bef67b2-46da-11df-a64b-6cf0494e0fad',31,NULL,NULL,1,NULL,2,161,'v2c','public',0,NULL,NULL,NULL,4,NULL,NULL,NULL,NULL,NULL,NULL,'2010-04-13 16:54:29','2010-04-13 16:54:40'),(59,'Oracle服务器',NULL,NULL,NULL,NULL,'136.5.69.141','a0a8760c-46da-11df-a64b-6cf0494e0fad',31,NULL,NULL,1,NULL,2,161,'v2c','public',0,NULL,NULL,NULL,4,NULL,NULL,NULL,NULL,NULL,NULL,'2010-04-13 16:57:45','2010-04-13 16:58:41'),(60,'磁阵',NULL,NULL,NULL,NULL,'136.5.69.143','12a68ba4-46db-11df-a64b-6cf0494e0fad',31,15,NULL,0,NULL,2,161,'v2c','public',0,NULL,NULL,NULL,4,NULL,NULL,NULL,NULL,NULL,NULL,'2010-04-13 17:00:56','2010-04-13 17:00:56'),(61,'WEB',NULL,NULL,NULL,NULL,'222.221.17.12','48c4f64e-46db-11df-a64b-6cf0494e0fad',29,NULL,NULL,1,NULL,2,161,'v2c','public',1,NULL,NULL,NULL,4,NULL,NULL,NULL,NULL,NULL,NULL,'2010-04-13 17:02:27','2010-04-13 17:03:19'),(62,'丽江',NULL,NULL,NULL,NULL,'218.63.168.253','742fbc80-46de-11df-a64b-6cf0494e0fad',29,NULL,NULL,1,NULL,2,161,'v2c','public',0,NULL,NULL,NULL,4,NULL,NULL,NULL,NULL,NULL,NULL,'2010-04-13 17:25:09','2010-04-13 17:25:14'),(63,'公司内网 - 192.168.1.31',NULL,NULL,NULL,NULL,'192.168.1.31','deb18bee-476d-11df-a64b-6cf0494e0fad',1,16,NULL,1,NULL,2,161,'v2c','public',1,'2010-04-16 08:44:25','2010-04-16 08:49:25',NULL,0,'Packet loss = 0%, RTA = 0.041ms','2010-04-16 08:44:25',NULL,'2010-04-14 10:42:17',NULL,NULL,'2010-04-14 10:31:45','2010-04-19 15:32:13'),(64,'公司内网 - 192.168.1.20 -Win',NULL,NULL,NULL,NULL,'192.168.1.20','d2fcd37e-476f-11df-a64b-6cf0494e0fad',1,16,NULL,1,NULL,5,161,'v2c','public',1,'2010-04-16 08:44:15','2010-04-16 08:49:15',NULL,0,'Packet loss = 0%, RTA = 0.219ms','2010-04-16 08:44:15','2010-04-15 14:04:30','2010-04-14 11:06:25',NULL,NULL,'2010-04-14 10:45:45','2010-04-19 15:32:13'),(65,'吉林 - WLAN - WEB服务器',NULL,NULL,NULL,NULL,'123.173.124.5','e2a69cc0-47dc-11df-a64b-6cf0494e0fad',1,NULL,NULL,1,NULL,9,161,'v2c','public',0,'2010-04-19 15:30:54','2010-04-19 15:35:54',NULL,0,'Packet loss = 0%, RTA = 54.816ms','2010-04-19 15:30:54',NULL,'2010-04-14 23:46:40',NULL,NULL,'2010-04-14 23:46:26','2010-04-19 15:32:13'),(66,'吉林 - WLAN - 主采集',NULL,NULL,NULL,NULL,'192.168.0.10','c323130a-47dd-11df-a64b-6cf0494e0fad',1,18,NULL,1,NULL,9,161,'v2c','public',0,NULL,NULL,NULL,4,NULL,NULL,NULL,NULL,NULL,NULL,'2010-04-14 23:52:43','2010-04-19 15:32:13'),(67,'吉林 - WLAN - 采集13',NULL,NULL,NULL,NULL,'192.168.1.13','def2c8f0-47dd-11df-a64b-6cf0494e0fad',1,18,NULL,1,NULL,9,161,'v2c','public',0,NULL,NULL,NULL,4,NULL,NULL,NULL,NULL,NULL,NULL,'2010-04-14 23:53:29','2010-04-19 15:32:13'),(68,'吉林 - WLAN - 采集14',NULL,NULL,NULL,NULL,'192.168.1.14','f1477f00-47dd-11df-a64b-6cf0494e0fad',1,18,NULL,1,NULL,9,161,'v2c','public',0,NULL,NULL,NULL,4,NULL,NULL,NULL,NULL,NULL,NULL,'2010-04-14 23:54:00','2010-04-19 15:32:13');
/*!40000 ALTER TABLE `hosts` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `monit`.`trigger_hosts_insert` AFTER INSERT ON monit.hosts FOR EACH ROW
BEGIN
    IF (new.addr IS NOT NULL) AND (new.uuid IS NOT NULL)
   THEN 
      INSERT INTO task_changed 
            (
                target_type,
                target_id,
                uuid,
								oper_type,
								discovery_state,
								addr,
								created_at,
								updated_at
            )
      VALUES (
                1,
								new.id,
								new.uuid,
								1,
								new.discovery_state,
								new.addr,
								now(),
								now()
             );
   END IF;   
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `monit`.`trigger_hosts_update` AFTER UPDATE ON monit.hosts FOR EACH ROW
BEGIN
    IF (old.addr is null and new.addr IS NOT NULL) or (old.uuid is null and new.uuid IS NOT NULL)
   THEN 
      INSERT INTO task_changed 
            (
                target_type,
                target_id,
                uuid,
								oper_type,
								discovery_state,
								addr,
								created_at,
								updated_at
            )
      VALUES (
                1,
								new.id,
								new.uuid,
								1,
								new.discovery_state,
								new.addr,
								old.created_at,
								now()
             );
   elseif (old.addr <> new.addr) or (old.uuid <> new.uuid) then
      INSERT INTO task_changed 
            (
                target_type,
                target_id,
                uuid,
								oper_type,
								discovery_state,
								addr,
								created_at,
								updated_at
            )
      VALUES (
                1,
								new.id,
								new.uuid,
								3,
								new.discovery_state,
								new.addr,
								old.created_at,
								now()
             );
   END IF;   
    
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `monit`.`trigger_hosts_delete` AFTER DELETE ON monit.hosts FOR EACH ROW
BEGIN
    IF (old.addr IS NOT NULL) AND (old.uuid IS NOT NULL)
   THEN 
      INSERT INTO task_changed 
            (
                target_type,
                target_id,
                uuid,
								oper_type,
								discovery_state,
								addr,
								created_at,
								updated_at
            )
      VALUES (
                1,
								old.id,
								old.uuid,
								2,
								old.discovery_state,
								old.addr,
								old.created_at,
								now()
             );
   END IF;   
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `invite_codes`
--

DROP TABLE IF EXISTS `invite_codes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `invite_codes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` varchar(255) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `user_name` varchar(255) DEFAULT NULL,
  `status` tinyint(2) DEFAULT '0',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `invite_codes`
--

LOCK TABLES `invite_codes` WRITE;
/*!40000 ALTER TABLE `invite_codes` DISABLE KEYS */;
INSERT INTO `invite_codes` VALUES (11,'6f2a829eba377adb37d1ea837e0eaa591fd60727',25,'solo',1,'2010-04-08 16:12:08','2010-04-13 15:42:30'),(12,'edfe9893942a4d09748be41b0516afd54a7703e0',NULL,NULL,0,'2010-04-08 16:12:09','2010-04-08 16:12:09'),(13,'c97fc55037ba14d8df59c00ed515a8a1f3a46858',NULL,NULL,0,'2010-04-08 16:12:09','2010-04-08 16:12:09'),(14,'452f68b9464732439284ad818d749ba49af86d90',26,'yufw',1,'2010-04-08 16:12:09','2010-04-13 16:09:41'),(15,'37bc00423732c5bf19a0eb0cf853ef9eed1e5a08',27,'sx_monit',1,'2010-04-08 16:12:09','2010-04-13 16:13:29'),(16,'b620d048eb2efa98796b2ca8f0234c1431bd679d',28,'jx_wlan',1,'2010-04-08 16:12:09','2010-04-13 16:14:25'),(17,'86d24a51f77427cb665ea60b96feafdf74202794',NULL,NULL,0,'2010-04-08 16:12:09','2010-04-08 16:12:09'),(18,'5c450d3cb776f833ead6a6c7746a7c9f65c58a0b',NULL,NULL,0,'2010-04-08 16:12:09','2010-04-08 16:12:09'),(19,'3ca14ed39e22c3643bb927e77eb2e8a0b5465cdb',NULL,NULL,0,'2010-04-08 16:12:09','2010-04-08 16:12:09'),(20,'32e241f58cfa2f5f8f1b62c20c64eee0ec94f06d',NULL,NULL,0,'2010-04-08 16:12:09','2010-04-08 16:12:09');
/*!40000 ALTER TABLE `invite_codes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `logm_operations`
--

DROP TABLE IF EXISTS `logm_operations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `logm_operations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sessions` varchar(50) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `user_name` int(50) DEFAULT NULL,
  `action` varchar(100) DEFAULT NULL,
  `result` varchar(100) DEFAULT NULL,
  `details` varchar(100) DEFAULT NULL,
  `module_name` varchar(10) DEFAULT NULL,
  `terminal_ip` varchar(20) DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `logm_operations`
--

LOCK TABLES `logm_operations` WRITE;
/*!40000 ALTER TABLE `logm_operations` DISABLE KEYS */;
/*!40000 ALTER TABLE `logm_operations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `metric_types`
--

DROP TABLE IF EXISTS `metric_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `metric_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type_id` int(11) DEFAULT NULL COMMENT 'service_type',
  `name` varchar(50) DEFAULT NULL,
  `metric_type` varchar(50) DEFAULT NULL,
  `unit` varchar(20) DEFAULT NULL,
  `calc` varchar(50) DEFAULT NULL COMMENT 'counter/derive/gauge',
  `desc` varchar(50) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `group` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=155 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `metric_types`
--

LOCK TABLES `metric_types` WRITE;
/*!40000 ALTER TABLE `metric_types` DISABLE KEYS */;
INSERT INTO `metric_types` VALUES (1,3,'avail','float','GB','gauge','可用磁盘空间',NULL,NULL,'disk'),(2,3,'total','float','GB','gauge','总共磁盘空间',NULL,NULL,'disk'),(3,3,'used','float','GB','gauge','已用磁盘空间',NULL,NULL,'disk'),(4,3,'usage','float','%','gauge','磁盘使用率(%)',NULL,NULL,'disk'),(5,4,'load1','float','%','gauge','1分钟负载',NULL,NULL,'load'),(6,4,'load5','float','%','gauge','5分钟负载',NULL,NULL,'load'),(7,4,'load15','float','%','gauge','15分钟负载',NULL,NULL,'load'),(8,5,'user','float','%','gauge','用户层执行时间',NULL,NULL,'cpu'),(9,5,'system','float','%','gauge','内核层执行时间',NULL,NULL,'cpu'),(10,5,'idle','float','%','gauge','空闲时间',NULL,NULL,'cpu'),(11,5,'nice','float','%','gauge','nice时间',NULL,NULL,'cpu'),(12,5,'iowait','float','%','gauge','io等待时间',NULL,NULL,'cpu'),(13,5,'stolen','float','%','gauge','linux专有',NULL,NULL,'cpu'),(14,5,'usage','float','%','gauge','CPU使用率(%)',NULL,NULL,'cpu'),(15,6,'inoctets','float','Mbps','gauge','网络接收字节数',NULL,NULL,'netif'),(16,6,'outoctets','float','Mbps','gauge','网络发送字节数',NULL,NULL,'netif'),(17,6,'inpkts','integer','/s','gauge','网络接收报文数',NULL,NULL,'netif'),(18,6,'outpkts','integer','/s','gauge','网络发送报文数',NULL,NULL,'netif'),(19,6,'inucastpkts','integer','/s','gauge','网络接收单播包数',NULL,NULL,'netif'),(20,6,'outucastpkts','integer','/s','gauge','网络发送单播包数',NULL,NULL,'netif'),(21,6,'innucastpkts','integer','/s','gauge','网络接收非单播包数',NULL,NULL,'netif'),(22,6,'outnucastpkts','integer','/s','gauge','网络发送非单播包数',NULL,NULL,'netif'),(23,6,'inmcastpkts','integer','/s','gauge','网络接收多播包数',NULL,NULL,'netif'),(24,6,'outmcastpkts','integer','/s','gauge','网络发送多播包数',NULL,NULL,'netif'),(25,6,'inbcastpkts','integer','/s','gauge','网络接收广播包数',NULL,NULL,'netif'),(26,6,'outbcastpkts','integer','/s','gauge','网络发送广播包数',NULL,NULL,'netif'),(27,6,'inerrors','integer','/s','gauge','网络接收错误包数',NULL,NULL,'netif'),(28,6,'outerrors','integer','/s','gauge','网络发送错误包数',NULL,NULL,'netif'),(29,6,'indiscards','integer','/s','gauge','网络接收丢包数',NULL,NULL,'netif'),(30,6,'outdiscards','integer','/s','gauge','网络发送丢包数',NULL,NULL,'netif'),(31,7,'total','float','GB','gauge','总共内存',NULL,NULL,'mem'),(32,7,'used','float','GB','gauge','已用内存',NULL,NULL,'mem'),(33,7,'free','float','GB','gauge','可用内存',NULL,NULL,'mem'),(34,7,'buffers','float','GB','gauge','Buffer内存',NULL,NULL,'mem'),(35,7,'cached','float','GB','gauge','Cached内存',NULL,NULL,'mem'),(36,7,'shared','float','GB','gauge','Shared内存',NULL,NULL,'mem'),(37,7,'usage','float','%','gauge','内存使用率(%)',NULL,NULL,'mem'),(38,8,'total','float','GB','gauge','总交换分区',NULL,NULL,'swap'),(39,8,'used','float','GB','gauge','已用Swap',NULL,NULL,'swap'),(40,8,'free','float','GB','gauge','可用swap',NULL,NULL,'swap'),(41,8,'cached','float','GB','gauge','缓存的swap',NULL,NULL,'swap'),(42,8,'usage','float','%','gauge','Swap使用率(%)',NULL,NULL,'swap'),(43,10,'total','int',NULL,'gauge','总任务数',NULL,NULL,'task'),(44,10,'running','int',NULL,'gauge','运行任务数',NULL,NULL,'task'),(45,10,'sleeping','int',NULL,'gauge','休眠任务数',NULL,NULL,'task'),(46,10,'stopped','int',NULL,'gauge','停止进程数',NULL,NULL,'task'),(47,10,'zombie','int',NULL,'gauge','zombie任务数',NULL,NULL,'task'),(48,1,'pl','float','%','gauge','Ping丢包率',NULL,NULL,'ping'),(49,1,'rta','float','ms','gauge','平均Ping时延',NULL,NULL,'ping'),(50,2,'time','float','ms','gauge','平均HTTP响应时间',NULL,NULL,'http'),(51,9,'time','float','ms','gauge','平均TCP响应时间',NULL,NULL,'tcp'),(52,13,'load1','float','%','gauge','1分钟负载',NULL,NULL,'load'),(53,13,'load5','float','%','gauge','5分钟负载',NULL,NULL,'load'),(54,13,'load15','float','%','gauge','15分钟负载',NULL,NULL,'load'),(55,11,'avail','float','GB','gauge','可用磁盘空间',NULL,NULL,'disk'),(56,11,'total','float','GB','gauge','总共磁盘空间',NULL,NULL,'disk'),(57,11,'used','float','GB','gauge','已用磁盘空间',NULL,NULL,'disk'),(58,11,'usage','float','%','gauge','磁盘使用率(%)',NULL,NULL,'disk'),(59,14,'total','float','GB','gauge','总共内存',NULL,NULL,'mem'),(60,14,'used','float','GB','gauge','已用内存',NULL,NULL,'mem'),(61,14,'free','float','GB','gauge','可用内存',NULL,NULL,'mem'),(62,14,'buffer','float','GB','gauge','Buffer内存',NULL,NULL,'mem'),(63,14,'cached','float','GB','gauge','Cached内存',NULL,NULL,'mem'),(64,14,'shared','float','GB','gauge','Shared内存',NULL,NULL,'mem'),(65,14,'usage','float','%','gauge','内存使用率(%)',NULL,NULL,'mem'),(66,15,'total','float','GB','gauge','总交换分区',NULL,NULL,'swap'),(67,15,'used','float','GB','gauge','已用Swap',NULL,NULL,'swap'),(68,15,'free','float','GB','gauge','可用swap',NULL,NULL,'swap'),(69,15,'cached','float','GB','gauge','缓存的swap',NULL,NULL,'swap'),(70,15,'usage','float','%','gauge','Swap使用率(%)',NULL,NULL,'swap'),(71,23,'pl','float','%','gauge','PING丢包率',NULL,NULL,'ping'),(72,12,'rbytes','int',NULL,'gauge','磁盘读取字节数',NULL,NULL,'diskio'),(73,12,'wbytes','int',NULL,'gauge','磁盘写入字节数',NULL,NULL,'diskio'),(74,12,'reads','int',NULL,'gauge','磁盘读取次数',NULL,NULL,'diskio'),(76,12,'writes','int',NULL,'gauge','磁盘写入次数',NULL,NULL,'diskio'),(77,1,'rtmax','float','ms','gauge','最大Ping时延',NULL,NULL,'ping'),(78,1,'rtmin','float','ms','gauge','最小Ping时延',NULL,NULL,'ping'),(79,2,'length','int','bytes','gauge','HTTP报文大小',NULL,NULL,'http'),(80,6,'inunknown','integer','/s','gauge','网络接收单播包数',NULL,NULL,'netif'),(81,23,'rta','float','ms','gauge','平均Ping时延',NULL,NULL,'ping'),(82,23,'rtmax','float','ms','gauge','最大Ping时延',NULL,NULL,'ping'),(83,23,'rtmin','float','ms','gauge','最小Ping时延',NULL,NULL,'ping'),(84,26,'load','float','%','gauge','CPU负载',NULL,NULL,'win.cpu'),(85,27,'usage','float','%','gauge','物理内存占用',NULL,NULL,'win.mem'),(86,27,'total','int','GB','gauge','物理内存总量',NULL,NULL,'win.mem'),(87,27,'avail','int','GB','gauge','可用物理内存',NULL,NULL,'win.mem'),(88,27,'used','int','GB','gauge','已用物理内存',NULL,NULL,'win.mem'),(89,28,'usage','float','%','gauge','物理内存占用',NULL,NULL,'win.virmem'),(90,28,'total','int','GB','gauge','物理内存总量',NULL,NULL,'win.virmem'),(91,28,'avail','int','GB','gauge','可用物理内存',NULL,NULL,'win.virmem'),(92,28,'used','int','GB','gauge','已用物理内存',NULL,NULL,'win.virmem'),(93,29,'total','int','','gauge','总进程数',NULL,NULL,'win.task'),(94,30,'cpu','int','','gauge','CPU',NULL,NULL,'win.process'),(95,30,'mem','int','','gauge','内存',NULL,NULL,'win.process'),(96,25,'time','float','ms','gauge','查询时间',NULL,NULL,'dns'),(97,19,'received','int','','counter','接收字节',NULL,NULL,'mysql'),(98,19,'sent','int','','counter','发送字节',NULL,NULL,'mysql'),(99,20,'cached','int','','gauge','缓存线程',NULL,NULL,'mysql.threads'),(100,20,'connected','int','','gauge','连接线程',NULL,NULL,'mysql.threads'),(101,20,'created','int','','gauge','创建线程',NULL,NULL,'mysql.threads'),(102,20,'running','int','','gauge','运行线程',NULL,NULL,'mysql.threads'),(103,24,'time','float','ms','gauge','平均HTTP响应时间',NULL,NULL,'http'),(104,24,'length','int','bytes','gauge','HTTP报文大小',NULL,NULL,'http'),(105,21,'buffer_pool_pages_data','int','','gauge','buffer pool pages data',NULL,NULL,'mysql.innodb'),(106,21,'buffer_pool_pages_dirty','int','','gauge','buffer pool pages dirty',NULL,NULL,'mysql.innodb'),(107,21,'buffer_pool_pages_flushed','int','','gauge','buffer pool pages flushed',NULL,NULL,'mysql.innodb'),(108,21,'buffer_pool_pages_free','int','','gauge','buffer pool pages free',NULL,NULL,'mysql.innodb'),(109,21,'buffer_pool_pages_misc','int','','gauge','buffer pool pages misc',NULL,NULL,'mysql.innodb'),(110,21,'buffer_pool_pages_total','int','','gauge','buffer pool pages total',NULL,NULL,'mysql.innodb'),(111,21,'buffer_pool_read_ahead_rnd','int','','gauge','buffer pool read ahead rnd',NULL,NULL,'mysql.innodb'),(112,21,'buffer_pool_read_ahead_seq','int','','gauge','buffer pool read ahead seq',NULL,NULL,'mysql.innodb'),(113,21,'buffer_pool_read_requests','int','','gauge','buffer pool read requests',NULL,NULL,'mysql.innodb'),(114,21,'buffer_pool_reads','int','','gauge','buffer pool reads',NULL,NULL,'mysql.innodb'),(115,21,'buffer_pool_wait_free','int','','gauge','buffer pool wait free',NULL,NULL,'mysql.innodb'),(116,21,'buffer_pool_write_requests','int','','gauge','buffer pool write requests',NULL,NULL,'mysql.innodb'),(117,21,'data_fsyncs','int','','gauge','data fsyncs',NULL,NULL,'mysql.innodb'),(118,21,'data_pending_fsyncs','int','','gauge','data pending fsyncs',NULL,NULL,'mysql.innodb'),(119,21,'data_pending_reads','int','','gauge','data pending reads',NULL,NULL,'mysql.innodb'),(120,21,'data_pending_writes','int','','gauge','data pending writes',NULL,NULL,'mysql.innodb'),(121,21,'data_read','int','','gauge','data read',NULL,NULL,'mysql.innodb'),(122,21,'data_reads','int','','gauge','data reads',NULL,NULL,'mysql.innodb'),(123,21,'data_writes','int','','gauge','data writes',NULL,NULL,'mysql.innodb'),(124,21,'data_written','int','','gauge','data written',NULL,NULL,'mysql.innodb'),(125,21,'dblwr_pages_written','int','','gauge','dblwr pages written',NULL,NULL,'mysql.innodb'),(126,21,'dblwr_writes','int','','gauge','dblwr writes',NULL,NULL,'mysql.innodb'),(127,21,'log_waits','int','','gauge','log waits',NULL,NULL,'mysql.innodb'),(128,21,'log_write_requests','int','','gauge','log write requests',NULL,NULL,'mysql.innodb'),(129,21,'log_writes','int','','gauge','log writes',NULL,NULL,'mysql.innodb'),(130,21,'os_log_fsyncs','int','','gauge','os log fsyncs',NULL,NULL,'mysql.innodb'),(131,21,'os_log_pending_fsyncs','int','','gauge','os log pending fsyncs',NULL,NULL,'mysql.innodb'),(132,21,'os_log_pending_writes','int','','gauge','os log pending writes',NULL,NULL,'mysql.innodb'),(133,21,'os_log_written','int','','gauge','os log written',NULL,NULL,'mysql.innodb'),(134,21,'page_size','int','','gauge','page size',NULL,NULL,'mysql.innodb'),(135,21,'pages_created','int','','gauge','pages created',NULL,NULL,'mysql.innodb'),(136,21,'pages_read','int','','gauge','pages read',NULL,NULL,'mysql.innodb'),(137,21,'pages_written','int','','gauge','pages written',NULL,NULL,'mysql.innodb'),(138,21,'row_lock_current_waits','int','','gauge','row lock current waits',NULL,NULL,'mysql.innodb'),(139,21,'row_lock_time','int','','gauge','row lock time',NULL,NULL,'mysql.innodb'),(140,21,'row_lock_time_avg','int','','gauge','row lock time avg',NULL,NULL,'mysql.innodb'),(141,21,'row_lock_time_max','int','','gauge','row lock time max',NULL,NULL,'mysql.innodb'),(142,21,'row_lock_waits','int','','gauge','row lock waits',NULL,NULL,'mysql.innodb'),(143,21,'rows_deleted','int','','gauge','rows deleted',NULL,NULL,'mysql.innodb'),(144,21,'rows_inserted','int','','gauge','rows inserted',NULL,NULL,'mysql.innodb'),(145,21,'rows_read','int','','gauge','rows read',NULL,NULL,'mysql.innodb'),(146,21,'rows_updated','int','','gauge','rows updated',NULL,NULL,'mysql.innodb'),(147,31,'pl','float','%','gauge','Ping丢包率',NULL,NULL,'ping'),(148,31,'rta','float','ms','gauge','平均Ping时延',NULL,NULL,'ping'),(149,31,'rtmax','float','ms','gauge','最大Ping时延',NULL,NULL,'ping'),(150,31,'rtmin','float','ms','gauge','最小Ping时延',NULL,NULL,'ping'),(151,6,'inusage','float','%','gauge','网络接收带宽占用',NULL,NULL,'netif'),(152,6,'outusage','float','%','gauge','网络发送带宽占用',NULL,NULL,'netif'),(153,6,'inband','float','Mbps','gauge','网络接收最大带宽',NULL,NULL,'netif'),(154,6,'outband','float','Mbps','gauge','网络发送最大带宽',NULL,NULL,'netif');
/*!40000 ALTER TABLE `metric_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `networks`
--

DROP TABLE IF EXISTS `networks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `networks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  `tag` varchar(50) DEFAULT NULL,
  `model` varchar(50) DEFAULT NULL,
  `mac` varchar(20) DEFAULT NULL,
  `os_desc` varchar(50) DEFAULT NULL,
  `addr` varchar(50) NOT NULL,
  `uuid` varchar(50) DEFAULT NULL,
  `tenant_id` int(11) DEFAULT NULL,
  `agent_id` int(11) DEFAULT NULL,
  `is_support_snmp` int(2) DEFAULT NULL COMMENT '0:false 1:true',
  `type_id` int(11) DEFAULT NULL,
  `port` int(11) DEFAULT NULL,
  `snmp_ver` varchar(20) DEFAULT NULL,
  `community` varchar(20) DEFAULT NULL,
  `discovery_state` int(2) DEFAULT '0' COMMENT '0:undiscovery 1:discoveried 2:rediscovery',
  `last_check` datetime DEFAULT NULL,
  `next_check` datetime DEFAULT NULL,
  `duration` int(11) DEFAULT NULL,
  `status` int(2) NOT NULL DEFAULT '0',
  `summary` varchar(200) DEFAULT NULL,
  `last_time_up` datetime DEFAULT NULL,
  `last_time_down` datetime DEFAULT NULL,
  `last_time_pending` datetime DEFAULT NULL,
  `last_time_unknown` datetime DEFAULT NULL,
  `last_time_unreachable` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=69 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `networks`
--

LOCK TABLES `networks` WRITE;
/*!40000 ALTER TABLE `networks` DISABLE KEYS */;
/*!40000 ALTER TABLE `networks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notifications`
--

DROP TABLE IF EXISTS `notifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `notifications` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `method` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `alert_id` int(11) DEFAULT NULL,
  `alert_name` varchar(100) DEFAULT NULL,
  `alert_severity` int(2) DEFAULT NULL,
  `alert_summary` varchar(255) DEFAULT NULL,
  `service_id` int(11) DEFAULT NULL,
  `source_id` int(11) DEFAULT NULL,
  `source_type` int(11) DEFAULT NULL,
  `tenant_id` int(11) DEFAULT NULL,
  `status` int(11) DEFAULT '0' COMMENT '0:unsent 1:sent 2:read',
  `occured_at` datetime DEFAULT NULL,
  `title` varchar(100) DEFAULT NULL,
  `summary` varchar(255) DEFAULT NULL,
  `content` blob,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=292 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notifications`
--

LOCK TABLES `notifications` WRITE;
/*!40000 ALTER TABLE `notifications` DISABLE KEYS */;
INSERT INTO `notifications` VALUES (1,0,1,1,'sit0',1,'sit0 is down.',103,45,1,1,0,'2010-04-16 20:06:19',NULL,NULL,NULL,'2010-04-16 20:14:13','2010-04-16 20:14:13'),(2,0,1,4,'eth3',1,'eth3 is down.',102,45,1,1,0,'2010-04-16 20:06:39',NULL,NULL,NULL,'2010-04-16 20:14:13','2010-04-16 20:14:13'),(3,0,1,26,'eth3',1,'eth3 is down.',118,47,1,1,0,'2010-04-16 20:08:20',NULL,NULL,NULL,'2010-04-16 20:14:13','2010-04-16 20:14:13'),(4,0,1,31,'接口流量 - eth2',1,'eth2 is down.',71,20,1,1,0,'2010-04-16 20:09:16',NULL,NULL,NULL,'2010-04-16 20:14:13','2010-04-16 20:14:13'),(5,0,1,47,'eth2',1,'eth2 is down.',138,24,1,1,0,'2010-04-16 20:10:41',NULL,NULL,NULL,'2010-04-16 20:14:13','2010-04-16 20:14:13'),(6,0,1,11,'Ping',2,'Packet loss = 100%',74,24,1,1,0,'2010-04-16 20:07:20',NULL,NULL,NULL,'2010-04-16 20:14:13','2010-04-16 20:14:13'),(7,0,1,28,'Ping',2,'Packet loss = 100%',43,18,1,1,0,'2010-04-16 20:08:46',NULL,NULL,NULL,'2010-04-16 20:14:13','2010-04-16 20:14:13'),(8,0,1,23,'磁盘监测 - ',3,'snmp error.',73,18,1,1,0,'2010-04-16 20:08:03',NULL,NULL,NULL,'2010-04-16 20:14:13','2010-04-16 20:14:13'),(9,1,1,11,'Ping',2,'Packet loss = 100%',74,24,1,1,1,'2010-04-16 20:07:20','重庆 - WLAN - 采集1 / Ping 故障','重庆 - WLAN - 采集1 / Ping 于 04-16 20:07 故障。\n详细：http://t.monit.cn/services/74\n\n','<p>\n<a href=\"http://t.monit.cn/hosts/24\">重庆 - WLAN - 采集1</a> / <a href=\"http://t.monit.cn/services/74\">Ping</a> 于 04-16 20:07 故障\n</p>\n<p>\n\n查看详细：<a href=\"http://t.monit.cn/services/74\">http://t.monit.cn/services/74</a>\n</p>\n<p>\n\n通知设置：<a href=\"http://t.monit.cn/account/notify\">http://t.monit.cn/account/notify</a>\n</p>\n\n<p>&nbsp;</p>\n<p>\n<font color=\"gray\">--Monit</font>\n<br />\n<br />\n\n<a href=\"http://t.monit.cn/\">http://t.monit.cn/</a>\n</p>\n\n','2010-04-16 20:14:13','2010-04-16 20:25:21'),(10,1,1,28,'Ping',2,'Packet loss = 100%',43,18,1,1,1,'2010-04-16 20:08:46','云南 - WLAN - WEB服务器 / Ping 故障','云南 - WLAN - WEB服务器 / Ping 于 04-16 20:08 故障。\n详细：http://t.monit.cn/services/43\n\n','<p>\n<a href=\"http://t.monit.cn/hosts/18\">云南 - WLAN - WEB服务器</a> / <a href=\"http://t.monit.cn/services/43\">Ping</a> 于 04-16 20:08 故障\n</p>\n<p>\n\n查看详细：<a href=\"http://t.monit.cn/services/43\">http://t.monit.cn/services/43</a>\n</p>\n<p>\n\n通知设置：<a href=\"http://t.monit.cn/account/notify\">http://t.monit.cn/account/notify</a>\n</p>\n\n<p>&nbsp;</p>\n<p>\n<font color=\"gray\">--Monit</font>\n<br />\n<br />\n\n<a href=\"http://t.monit.cn/\">http://t.monit.cn/</a>\n</p>\n\n','2010-04-16 20:14:13','2010-04-16 20:25:21'),(11,0,26,22,'sit0',1,'sit0 is down.',190,58,1,31,0,'2010-04-16 20:08:09',NULL,NULL,NULL,'2010-04-16 20:14:13','2010-04-16 20:14:13'),(12,0,26,30,'eth2',1,'eth2 is down.',182,58,1,31,0,'2010-04-16 20:09:05',NULL,NULL,NULL,'2010-04-16 20:14:13','2010-04-16 20:14:13'),(13,0,26,7,'系统负载 - SNMP',3,'snmp failure!',178,59,1,31,0,'2010-04-16 20:06:38',NULL,NULL,NULL,'2010-04-16 20:14:13','2010-04-16 20:14:13'),(14,0,28,2,'eth2',1,'eth2 is down.',247,56,1,33,0,'2010-04-16 20:06:24',NULL,NULL,NULL,'2010-04-16 20:14:13','2010-04-16 20:14:13'),(15,0,28,5,'eth3',1,'eth3 is down.',248,56,1,33,0,'2010-04-16 20:06:39',NULL,NULL,NULL,'2010-04-16 20:14:13','2010-04-16 20:14:13'),(16,0,28,6,'eth2',1,'eth2 is down.',245,52,1,33,0,'2010-04-16 20:06:42',NULL,NULL,NULL,'2010-04-16 20:14:13','2010-04-16 20:14:13'),(17,0,28,9,'sit0',1,'sit0 is down.',200,56,1,33,0,'2010-04-16 20:07:04',NULL,NULL,NULL,'2010-04-16 20:14:13','2010-04-16 20:14:13'),(18,0,28,19,'eth3',1,'eth3 is down.',243,52,1,33,0,'2010-04-16 20:07:59',NULL,NULL,NULL,'2010-04-16 20:14:13','2010-04-16 20:14:13'),(19,0,28,20,'内存监测 - SNMP',1,'memory usage: 98%',157,56,1,33,0,'2010-04-16 20:08:01',NULL,NULL,NULL,'2010-04-16 20:14:13','2010-04-16 20:14:13'),(20,0,28,27,'sit0',1,'sit0 is down.',284,53,1,33,0,'2010-04-16 20:08:27',NULL,NULL,NULL,'2010-04-16 20:14:13','2010-04-16 20:14:13'),(21,0,28,29,'sit0',1,'sit0 is down.',217,55,1,33,0,'2010-04-16 20:09:00',NULL,NULL,NULL,'2010-04-16 20:14:13','2010-04-16 20:14:13'),(22,0,28,33,'eth1',1,'eth1 is down.',244,52,1,33,0,'2010-04-16 20:10:06',NULL,NULL,NULL,'2010-04-16 20:14:13','2010-04-16 20:14:13'),(23,0,28,41,'Disk - /opt',1,'Usage of /opt: 67%',197,56,1,33,0,'2010-04-16 20:10:15',NULL,NULL,NULL,'2010-04-16 20:14:13','2010-04-16 20:14:13'),(24,0,28,43,'Disk - /',1,'Usage of /: 60%',199,56,1,33,0,'2010-04-16 20:10:22',NULL,NULL,NULL,'2010-04-16 20:14:13','2010-04-16 20:14:13'),(25,0,28,44,'sit0',1,'sit0 is down.',211,52,1,33,0,'2010-04-16 20:10:31',NULL,NULL,NULL,'2010-04-16 20:14:13','2010-04-16 20:14:13'),(26,0,28,45,'sit0',1,'sit0 is down.',298,54,1,33,0,'2010-04-16 20:10:31',NULL,NULL,NULL,'2010-04-16 20:14:13','2010-04-16 20:14:13'),(27,0,28,48,'sit0',1,'sit0 is down.',305,50,1,33,0,'2010-04-16 20:11:08',NULL,NULL,NULL,'2010-04-16 20:14:13','2010-04-16 20:14:13'),(28,0,28,56,'内存监测 - SNMP',1,'memory usage: 98%',166,54,1,33,0,'2010-04-16 20:13:03',NULL,NULL,NULL,'2010-04-16 20:14:13','2010-04-16 20:14:13'),(29,0,24,8,'eth0',1,'eth0 is down.',218,62,1,29,0,'2010-04-16 20:06:52',NULL,NULL,NULL,'2010-04-16 20:14:13','2010-04-16 20:14:13'),(30,0,24,10,'eth1',1,'eth1 is down.',219,62,1,29,0,'2010-04-16 20:07:05',NULL,NULL,NULL,'2010-04-16 20:14:13','2010-04-16 20:14:13'),(31,0,24,32,'sit0',1,'sit0 is down.',222,62,1,29,0,'2010-04-16 20:09:36',NULL,NULL,NULL,'2010-04-16 20:14:13','2010-04-16 20:14:13'),(32,0,24,42,'sit0',1,'sit0 is down.',179,51,1,29,0,'2010-04-16 20:10:22',NULL,NULL,NULL,'2010-04-16 20:14:13','2010-04-16 20:14:13'),(33,1,24,8,'eth0',1,'eth0 is down.',218,62,1,29,1,'2010-04-16 20:06:52','丽江 / eth0 警告','丽江 / eth0 于 04-16 20:06 警告。\n详细：http://t.monit.cn/services/218\n\n','<p>\n<a href=\"http://t.monit.cn/hosts/62\">丽江</a> / <a href=\"http://t.monit.cn/services/218\">eth0</a> 于 04-16 20:06 警告\n</p>\n<p>\n\n查看详细：<a href=\"http://t.monit.cn/services/218\">http://t.monit.cn/services/218</a>\n</p>\n<p>\n\n通知设置：<a href=\"http://t.monit.cn/account/notify\">http://t.monit.cn/account/notify</a>\n</p>\n\n<p>&nbsp;</p>\n<p>\n<font color=\"gray\">--Monit</font>\n<br />\n<br />\n\n<a href=\"http://t.monit.cn/\">http://t.monit.cn/</a>\n</p>\n\n','2010-04-16 20:14:13','2010-04-16 20:25:21'),(34,1,24,10,'eth1',1,'eth1 is down.',219,62,1,29,1,'2010-04-16 20:07:05','丽江 / eth1 警告','丽江 / eth1 于 04-16 20:07 警告。\n详细：http://t.monit.cn/services/219\n\n','<p>\n<a href=\"http://t.monit.cn/hosts/62\">丽江</a> / <a href=\"http://t.monit.cn/services/219\">eth1</a> 于 04-16 20:07 警告\n</p>\n<p>\n\n查看详细：<a href=\"http://t.monit.cn/services/219\">http://t.monit.cn/services/219</a>\n</p>\n<p>\n\n通知设置：<a href=\"http://t.monit.cn/account/notify\">http://t.monit.cn/account/notify</a>\n</p>\n\n<p>&nbsp;</p>\n<p>\n<font color=\"gray\">--Monit</font>\n<br />\n<br />\n\n<a href=\"http://t.monit.cn/\">http://t.monit.cn/</a>\n</p>\n\n','2010-04-16 20:14:13','2010-04-16 20:25:21'),(35,1,24,32,'sit0',1,'sit0 is down.',222,62,1,29,1,'2010-04-16 20:09:36','丽江 / sit0 警告','丽江 / sit0 于 04-16 20:09 警告。\n详细：http://t.monit.cn/services/222\n\n','<p>\n<a href=\"http://t.monit.cn/hosts/62\">丽江</a> / <a href=\"http://t.monit.cn/services/222\">sit0</a> 于 04-16 20:09 警告\n</p>\n<p>\n\n查看详细：<a href=\"http://t.monit.cn/services/222\">http://t.monit.cn/services/222</a>\n</p>\n<p>\n\n通知设置：<a href=\"http://t.monit.cn/account/notify\">http://t.monit.cn/account/notify</a>\n</p>\n\n<p>&nbsp;</p>\n<p>\n<font color=\"gray\">--Monit</font>\n<br />\n<br />\n\n<a href=\"http://t.monit.cn/\">http://t.monit.cn/</a>\n</p>\n\n','2010-04-16 20:14:13','2010-04-16 20:25:21'),(36,1,24,42,'sit0',1,'sit0 is down.',179,51,1,29,1,'2010-04-16 20:10:22','昆明采集 / sit0 警告','昆明采集 / sit0 于 04-16 20:10 警告。\n详细：http://t.monit.cn/services/179\n\n','<p>\n<a href=\"http://t.monit.cn/hosts/51\">昆明采集</a> / <a href=\"http://t.monit.cn/services/179\">sit0</a> 于 04-16 20:10 警告\n</p>\n<p>\n\n查看详细：<a href=\"http://t.monit.cn/services/179\">http://t.monit.cn/services/179</a>\n</p>\n<p>\n\n通知设置：<a href=\"http://t.monit.cn/account/notify\">http://t.monit.cn/account/notify</a>\n</p>\n\n<p>&nbsp;</p>\n<p>\n<font color=\"gray\">--Monit</font>\n<br />\n<br />\n\n<a href=\"http://t.monit.cn/\">http://t.monit.cn/</a>\n</p>\n\n','2010-04-16 20:14:13','2010-04-16 20:25:21'),(64,0,28,57,'PING监测',1,'Packet loss = 25%, RTA = 14.710ms',151,56,1,33,0,'2010-04-16 20:23:03',NULL,NULL,NULL,'2010-04-16 20:24:13','2010-04-16 20:24:13'),(65,0,1,58,'端口扫描',3,'Warning: Hostname localhost resolves to 2 IPs. Using 127.0.0.1.\nOK - scan ports successfully. \nPort	State	Service\n22/tcp   open          ssh\n25/tcp   open          smtp\n80/tcp   open          http\n139',310,15,1,1,0,'2010-04-16 20:34:03',NULL,NULL,NULL,'2010-04-16 20:34:13','2010-04-16 20:34:13'),(66,0,28,57,'PING监测',0,'Packet loss = 0%, RTA = 13.797ms',151,56,1,33,0,'2010-04-16 20:34:04',NULL,NULL,NULL,'2010-04-16 20:34:13','2010-04-16 20:34:13'),(68,0,1,59,'PING监测',1,'Packet loss = 25%, RTA = 100.678ms',128,47,1,1,0,'2010-04-16 21:05:35',NULL,NULL,NULL,'2010-04-16 21:06:13','2010-04-16 21:06:13'),(69,0,1,59,'PING监测',0,'Packet loss = 0%, RTA = 103.514ms',128,47,1,1,0,'2010-04-16 21:06:35',NULL,NULL,NULL,'2010-04-16 21:08:13','2010-04-16 21:08:13'),(70,1,1,59,'PING监测',0,'Packet loss = 0%, RTA = 103.514ms',128,47,1,1,1,'2010-04-16 21:06:35','宁夏 - EPON - WEB服务器 / PING监测 恢复正常','宁夏 - EPON - WEB服务器 / PING监测 于 04-16 21:06 恢复正常。\n详细：http://t.monit.cn/services/128\n\n','<p>\n<a href=\"http://t.monit.cn/hosts/47\">宁夏 - EPON - WEB服务器</a> / <a href=\"http://t.monit.cn/services/128\">PING监测</a> 于 04-16 21:06 恢复正常\n</p>\n<p>\n\n查看详细：<a href=\"http://t.monit.cn/services/128\">http://t.monit.cn/services/128</a>\n</p>\n<p>\n\n通知设置：<a href=\"http://t.monit.cn/account/notify\">http://t.monit.cn/account/notify</a>\n</p>\n\n<p>&nbsp;</p>\n<p>\n<font color=\"gray\">--Monit</font>\n<br />\n<br />\n\n<a href=\"http://t.monit.cn/\">http://t.monit.cn/</a>\n</p>\n\n','2010-04-16 21:08:13','2010-04-16 21:10:03'),(72,0,1,59,'PING监测',1,'Packet loss = 25%, RTA = 99.562ms',128,47,1,1,0,'2010-04-16 21:11:35',NULL,NULL,NULL,'2010-04-16 21:12:13','2010-04-16 21:12:13'),(73,0,1,59,'PING监测',0,'Packet loss = 0%, RTA = 111.800ms',128,47,1,1,0,'2010-04-16 21:12:35',NULL,NULL,NULL,'2010-04-16 21:14:13','2010-04-16 21:14:13'),(74,1,1,59,'PING监测',0,'Packet loss = 0%, RTA = 111.800ms',128,47,1,1,1,'2010-04-16 21:12:35','宁夏 - EPON - WEB服务器 / PING监测 恢复正常','宁夏 - EPON - WEB服务器 / PING监测 于 04-16 21:12 恢复正常。\n详细：http://t.monit.cn/services/128\n\n','<p>\n<a href=\"http://t.monit.cn/hosts/47\">宁夏 - EPON - WEB服务器</a> / <a href=\"http://t.monit.cn/services/128\">PING监测</a> 于 04-16 21:12 恢复正常\n</p>\n<p>\n\n查看详细：<a href=\"http://t.monit.cn/services/128\">http://t.monit.cn/services/128</a>\n</p>\n<p>\n\n通知设置：<a href=\"http://t.monit.cn/account/notify\">http://t.monit.cn/account/notify</a>\n</p>\n\n<p>&nbsp;</p>\n<p>\n<font color=\"gray\">--Monit</font>\n<br />\n<br />\n\n<a href=\"http://t.monit.cn/\">http://t.monit.cn/</a>\n</p>\n\n','2010-04-16 21:14:13','2010-04-16 21:16:02'),(76,0,1,59,'PING监测',1,'Packet loss = 50%, RTA = 92.370ms',128,47,1,1,0,'2010-04-16 21:38:05',NULL,NULL,NULL,'2010-04-16 21:38:13','2010-04-16 21:38:13'),(77,0,1,59,'PING监测',0,'Packet loss = 0%, RTA = 92.903ms',128,47,1,1,0,'2010-04-16 21:38:35',NULL,NULL,NULL,'2010-04-16 21:40:13','2010-04-16 21:40:13'),(78,1,1,59,'PING监测',0,'Packet loss = 0%, RTA = 92.903ms',128,47,1,1,1,'2010-04-16 21:38:35','宁夏 - EPON - WEB服务器 / PING监测 恢复正常','宁夏 - EPON - WEB服务器 / PING监测 于 04-16 21:38 恢复正常。\n详细：http://t.monit.cn/services/128\n\n','<p>\n<a href=\"http://t.monit.cn/hosts/47\">宁夏 - EPON - WEB服务器</a> / <a href=\"http://t.monit.cn/services/128\">PING监测</a> 于 04-16 21:38 恢复正常\n</p>\n<p>\n\n查看详细：<a href=\"http://t.monit.cn/services/128\">http://t.monit.cn/services/128</a>\n</p>\n<p>\n\n通知设置：<a href=\"http://t.monit.cn/account/notify\">http://t.monit.cn/account/notify</a>\n</p>\n\n<p>&nbsp;</p>\n<p>\n<font color=\"gray\">--Monit</font>\n<br />\n<br />\n\n<a href=\"http://t.monit.cn/\">http://t.monit.cn/</a>\n</p>\n\n','2010-04-16 21:40:13','2010-04-16 21:42:03'),(80,0,1,59,'PING监测',1,'Packet loss = 25%, RTA = 92.253ms',128,47,1,1,0,'2010-04-16 22:39:05',NULL,NULL,NULL,'2010-04-16 22:40:13','2010-04-16 22:40:13'),(81,0,1,59,'PING监测',0,'Packet loss = 0%, RTA = 94.446ms',128,47,1,1,0,'2010-04-16 22:45:05',NULL,NULL,NULL,'2010-04-16 22:46:13','2010-04-16 22:46:13'),(82,1,1,59,'PING监测',0,'Packet loss = 0%, RTA = 94.446ms',128,47,1,1,1,'2010-04-16 22:45:05','宁夏 - EPON - WEB服务器 / PING监测 恢复正常','宁夏 - EPON - WEB服务器 / PING监测 于 04-16 22:45 恢复正常。\n详细：http://t.monit.cn/services/128\n\n','<p>\n<a href=\"http://t.monit.cn/hosts/47\">宁夏 - EPON - WEB服务器</a> / <a href=\"http://t.monit.cn/services/128\">PING监测</a> 于 04-16 22:45 恢复正常\n</p>\n<p>\n\n查看详细：<a href=\"http://t.monit.cn/services/128\">http://t.monit.cn/services/128</a>\n</p>\n<p>\n\n通知设置：<a href=\"http://t.monit.cn/account/notify\">http://t.monit.cn/account/notify</a>\n</p>\n\n<p>&nbsp;</p>\n<p>\n<font color=\"gray\">--Monit</font>\n<br />\n<br />\n\n<a href=\"http://t.monit.cn/\">http://t.monit.cn/</a>\n</p>\n\n','2010-04-16 22:46:13','2010-04-16 22:48:02'),(84,0,26,60,'内存监测 - SNMP',1,'memory usage: 90%',147,49,1,31,0,'2010-04-16 23:37:12',NULL,NULL,NULL,'2010-04-16 23:38:13','2010-04-16 23:38:13'),(85,0,26,60,'内存监测 - SNMP',0,'memory usage: 87%',147,49,1,31,0,'2010-04-16 23:53:12',NULL,NULL,NULL,'2010-04-16 23:54:13','2010-04-16 23:54:13'),(86,1,26,60,'内存监测 - SNMP',0,'memory usage: 87%',147,49,1,31,1,'2010-04-16 23:53:12','222.177.4.98 / 内存监测 - SNMP 恢复正常','222.177.4.98 / 内存监测 - SNMP 于 04-16 23:53 恢复正常。\n详细：http://t.monit.cn/services/147\n\n','<p>\n<a href=\"http://t.monit.cn/hosts/49\">222.177.4.98</a> / <a href=\"http://t.monit.cn/services/147\">内存监测 - SNMP</a> 于 04-16 23:53 恢复正常\n</p>\n<p>\n\n查看详细：<a href=\"http://t.monit.cn/services/147\">http://t.monit.cn/services/147</a>\n</p>\n<p>\n\n通知设置：<a href=\"http://t.monit.cn/account/notify\">http://t.monit.cn/account/notify</a>\n</p>\n\n<p>&nbsp;</p>\n<p>\n<font color=\"gray\">--Monit</font>\n<br />\n<br />\n\n<a href=\"http://t.monit.cn/\">http://t.monit.cn/</a>\n</p>\n\n','2010-04-16 23:54:13','2010-04-16 23:56:03'),(88,0,26,60,'内存监测 - SNMP',1,'memory usage: 90%',147,49,1,31,0,'2010-04-17 00:33:12',NULL,NULL,NULL,'2010-04-17 00:34:13','2010-04-17 00:34:13'),(89,0,26,60,'内存监测 - SNMP',0,'memory usage: 88%',147,49,1,31,0,'2010-04-17 00:54:12',NULL,NULL,NULL,'2010-04-17 00:54:13','2010-04-17 00:54:13'),(90,1,26,60,'内存监测 - SNMP',0,'memory usage: 88%',147,49,1,31,1,'2010-04-17 00:54:12','222.177.4.98 / 内存监测 - SNMP 恢复正常','222.177.4.98 / 内存监测 - SNMP 于 04-17 00:54 恢复正常。\n详细：http://t.monit.cn/services/147\n\n','<p>\n<a href=\"http://t.monit.cn/hosts/49\">222.177.4.98</a> / <a href=\"http://t.monit.cn/services/147\">内存监测 - SNMP</a> 于 04-17 00:54 恢复正常\n</p>\n<p>\n\n查看详细：<a href=\"http://t.monit.cn/services/147\">http://t.monit.cn/services/147</a>\n</p>\n<p>\n\n通知设置：<a href=\"http://t.monit.cn/account/notify\">http://t.monit.cn/account/notify</a>\n</p>\n\n<p>&nbsp;</p>\n<p>\n<font color=\"gray\">--Monit</font>\n<br />\n<br />\n\n<a href=\"http://t.monit.cn/\">http://t.monit.cn/</a>\n</p>\n\n','2010-04-17 00:54:13','2010-04-17 00:56:02'),(92,0,26,60,'内存监测 - SNMP',1,'memory usage: 91%',147,49,1,31,0,'2010-04-17 01:29:12',NULL,NULL,NULL,'2010-04-17 01:30:13','2010-04-17 01:30:13'),(93,0,26,60,'内存监测 - SNMP',0,'memory usage: 88%',147,49,1,31,0,'2010-04-17 01:55:12',NULL,NULL,NULL,'2010-04-17 01:56:13','2010-04-17 01:56:13'),(94,1,26,60,'内存监测 - SNMP',0,'memory usage: 88%',147,49,1,31,1,'2010-04-17 01:55:12','222.177.4.98 / 内存监测 - SNMP 恢复正常','222.177.4.98 / 内存监测 - SNMP 于 04-17 01:55 恢复正常。\n详细：http://t.monit.cn/services/147\n\n','<p>\n<a href=\"http://t.monit.cn/hosts/49\">222.177.4.98</a> / <a href=\"http://t.monit.cn/services/147\">内存监测 - SNMP</a> 于 04-17 01:55 恢复正常\n</p>\n<p>\n\n查看详细：<a href=\"http://t.monit.cn/services/147\">http://t.monit.cn/services/147</a>\n</p>\n<p>\n\n通知设置：<a href=\"http://t.monit.cn/account/notify\">http://t.monit.cn/account/notify</a>\n</p>\n\n<p>&nbsp;</p>\n<p>\n<font color=\"gray\">--Monit</font>\n<br />\n<br />\n\n<a href=\"http://t.monit.cn/\">http://t.monit.cn/</a>\n</p>\n\n','2010-04-17 01:56:13','2010-04-17 01:58:02'),(96,0,25,61,'PING监测',1,'Packet loss = 25%, RTA = 144.912ms',291,48,1,30,0,'2010-04-17 02:21:53',NULL,NULL,NULL,'2010-04-17 02:22:13','2010-04-17 02:22:13'),(97,0,25,61,'PING监测',0,'Packet loss = 0%, RTA = 143.641ms',291,48,1,30,0,'2010-04-17 02:22:23',NULL,NULL,NULL,'2010-04-17 02:24:13','2010-04-17 02:24:13'),(98,1,25,61,'PING监测',0,'Packet loss = 0%, RTA = 143.641ms',291,48,1,30,1,'2010-04-17 02:22:23','宁夏WLAN网管服务器WEB服务器 / PING监测 恢复正常','宁夏WLAN网管服务器WEB服务器 / PING监测 于 04-17 02:22 恢复正常。\n详细：http://t.monit.cn/services/291\n\n','<p>\n<a href=\"http://t.monit.cn/hosts/48\">宁夏WLAN网管服务器WEB服务器</a> / <a href=\"http://t.monit.cn/services/291\">PING监测</a> 于 04-17 02:22 恢复正常\n</p>\n<p>\n\n查看详细：<a href=\"http://t.monit.cn/services/291\">http://t.monit.cn/services/291</a>\n</p>\n<p>\n\n通知设置：<a href=\"http://t.monit.cn/account/notify\">http://t.monit.cn/account/notify</a>\n</p>\n\n<p>&nbsp;</p>\n<p>\n<font color=\"gray\">--Monit</font>\n<br />\n<br />\n\n<a href=\"http://t.monit.cn/\">http://t.monit.cn/</a>\n</p>\n\n','2010-04-17 02:24:13','2010-04-17 02:26:02'),(100,0,26,60,'内存监测 - SNMP',1,'memory usage: 92%',147,49,1,31,0,'2010-04-17 02:30:12',NULL,NULL,NULL,'2010-04-17 02:30:13','2010-04-17 02:30:13'),(101,0,26,60,'内存监测 - SNMP',0,'memory usage: 89%',147,49,1,31,0,'2010-04-17 02:51:12',NULL,NULL,NULL,'2010-04-17 02:52:13','2010-04-17 02:52:13'),(102,1,26,60,'内存监测 - SNMP',0,'memory usage: 89%',147,49,1,31,1,'2010-04-17 02:51:12','222.177.4.98 / 内存监测 - SNMP 恢复正常','222.177.4.98 / 内存监测 - SNMP 于 04-17 02:51 恢复正常。\n详细：http://t.monit.cn/services/147\n\n','<p>\n<a href=\"http://t.monit.cn/hosts/49\">222.177.4.98</a> / <a href=\"http://t.monit.cn/services/147\">内存监测 - SNMP</a> 于 04-17 02:51 恢复正常\n</p>\n<p>\n\n查看详细：<a href=\"http://t.monit.cn/services/147\">http://t.monit.cn/services/147</a>\n</p>\n<p>\n\n通知设置：<a href=\"http://t.monit.cn/account/notify\">http://t.monit.cn/account/notify</a>\n</p>\n\n<p>&nbsp;</p>\n<p>\n<font color=\"gray\">--Monit</font>\n<br />\n<br />\n\n<a href=\"http://t.monit.cn/\">http://t.monit.cn/</a>\n</p>\n\n','2010-04-17 02:52:13','2010-04-17 02:54:02'),(104,0,26,60,'内存监测 - SNMP',1,'memory usage: 91%',147,49,1,31,0,'2010-04-17 03:31:12',NULL,NULL,NULL,'2010-04-17 03:32:13','2010-04-17 03:32:13'),(105,0,26,60,'内存监测 - SNMP',0,'memory usage: 89%',147,49,1,31,0,'2010-04-17 03:52:12',NULL,NULL,NULL,'2010-04-17 03:52:13','2010-04-17 03:52:13'),(106,1,26,60,'内存监测 - SNMP',0,'memory usage: 89%',147,49,1,31,1,'2010-04-17 03:52:12','222.177.4.98 / 内存监测 - SNMP 恢复正常','222.177.4.98 / 内存监测 - SNMP 于 04-17 03:52 恢复正常。\n详细：http://t.monit.cn/services/147\n\n','<p>\n<a href=\"http://t.monit.cn/hosts/49\">222.177.4.98</a> / <a href=\"http://t.monit.cn/services/147\">内存监测 - SNMP</a> 于 04-17 03:52 恢复正常\n</p>\n<p>\n\n查看详细：<a href=\"http://t.monit.cn/services/147\">http://t.monit.cn/services/147</a>\n</p>\n<p>\n\n通知设置：<a href=\"http://t.monit.cn/account/notify\">http://t.monit.cn/account/notify</a>\n</p>\n\n<p>&nbsp;</p>\n<p>\n<font color=\"gray\">--Monit</font>\n<br />\n<br />\n\n<a href=\"http://t.monit.cn/\">http://t.monit.cn/</a>\n</p>\n\n','2010-04-17 03:52:13','2010-04-17 03:54:02'),(108,0,28,62,'内存监测 - SNMP',1,'memory usage: 99%',162,52,1,33,0,'2010-04-17 04:23:29',NULL,NULL,NULL,'2010-04-17 04:24:13','2010-04-17 04:24:13'),(109,0,26,60,'内存监测 - SNMP',1,'memory usage: 90%',147,49,1,31,0,'2010-04-17 04:32:13',NULL,NULL,NULL,'2010-04-17 04:32:13','2010-04-17 04:32:13'),(110,0,28,62,'内存监测 - SNMP',0,'memory usage: 97%',162,52,1,33,0,'2010-04-17 04:34:29',NULL,NULL,NULL,'2010-04-17 04:36:13','2010-04-17 04:36:13'),(111,0,28,62,'内存监测 - SNMP',1,'memory usage: 98%',162,52,1,33,0,'2010-04-17 04:44:29',NULL,NULL,NULL,'2010-04-17 04:46:13','2010-04-17 04:46:13'),(112,0,26,60,'内存监测 - SNMP',0,'memory usage: 88%',147,49,1,31,0,'2010-04-17 04:53:13',NULL,NULL,NULL,'2010-04-17 04:54:13','2010-04-17 04:54:13'),(113,1,26,60,'内存监测 - SNMP',0,'memory usage: 88%',147,49,1,31,1,'2010-04-17 04:53:13','222.177.4.98 / 内存监测 - SNMP 恢复正常','222.177.4.98 / 内存监测 - SNMP 于 04-17 04:53 恢复正常。\n详细：http://t.monit.cn/services/147\n\n','<p>\n<a href=\"http://t.monit.cn/hosts/49\">222.177.4.98</a> / <a href=\"http://t.monit.cn/services/147\">内存监测 - SNMP</a> 于 04-17 04:53 恢复正常\n</p>\n<p>\n\n查看详细：<a href=\"http://t.monit.cn/services/147\">http://t.monit.cn/services/147</a>\n</p>\n<p>\n\n通知设置：<a href=\"http://t.monit.cn/account/notify\">http://t.monit.cn/account/notify</a>\n</p>\n\n<p>&nbsp;</p>\n<p>\n<font color=\"gray\">--Monit</font>\n<br />\n<br />\n\n<a href=\"http://t.monit.cn/\">http://t.monit.cn/</a>\n</p>\n\n','2010-04-17 04:54:13','2010-04-17 04:56:02'),(115,0,28,62,'内存监测 - SNMP',0,'memory usage: 87%',162,52,1,33,0,'2010-04-17 05:05:29',NULL,NULL,NULL,'2010-04-17 05:06:13','2010-04-17 05:06:13'),(116,0,26,60,'内存监测 - SNMP',1,'memory usage: 91%',147,49,1,31,0,'2010-04-17 05:33:13',NULL,NULL,NULL,'2010-04-17 05:34:13','2010-04-17 05:34:13'),(117,0,28,62,'内存监测 - SNMP',1,'memory usage: 99%',162,52,1,33,0,'2010-04-17 05:45:29',NULL,NULL,NULL,'2010-04-17 05:46:13','2010-04-17 05:46:13'),(118,0,28,62,'内存监测 - SNMP',0,'memory usage: 97%',162,52,1,33,0,'2010-04-17 05:46:30',NULL,NULL,NULL,'2010-04-17 05:48:13','2010-04-17 05:48:13'),(119,0,26,60,'内存监测 - SNMP',0,'memory usage: 88%',147,49,1,31,0,'2010-04-17 05:54:13',NULL,NULL,NULL,'2010-04-17 05:56:13','2010-04-17 05:56:13'),(120,1,26,60,'内存监测 - SNMP',0,'memory usage: 88%',147,49,1,31,1,'2010-04-17 05:54:13','222.177.4.98 / 内存监测 - SNMP 恢复正常','222.177.4.98 / 内存监测 - SNMP 于 04-17 05:54 恢复正常。\n详细：http://t.monit.cn/services/147\n\n','<p>\n<a href=\"http://t.monit.cn/hosts/49\">222.177.4.98</a> / <a href=\"http://t.monit.cn/services/147\">内存监测 - SNMP</a> 于 04-17 05:54 恢复正常\n</p>\n<p>\n\n查看详细：<a href=\"http://t.monit.cn/services/147\">http://t.monit.cn/services/147</a>\n</p>\n<p>\n\n通知设置：<a href=\"http://t.monit.cn/account/notify\">http://t.monit.cn/account/notify</a>\n</p>\n\n<p>&nbsp;</p>\n<p>\n<font color=\"gray\">--Monit</font>\n<br />\n<br />\n\n<a href=\"http://t.monit.cn/\">http://t.monit.cn/</a>\n</p>\n\n','2010-04-17 05:56:13','2010-04-17 05:58:03'),(122,0,28,62,'内存监测 - SNMP',1,'memory usage: 98%',162,52,1,33,0,'2010-04-17 05:57:00',NULL,NULL,NULL,'2010-04-17 05:58:13','2010-04-17 05:58:13'),(123,0,28,62,'内存监测 - SNMP',0,'memory usage: 87%',162,52,1,33,0,'2010-04-17 06:08:00',NULL,NULL,NULL,'2010-04-17 06:08:13','2010-04-17 06:08:13'),(124,0,26,60,'内存监测 - SNMP',1,'memory usage: 92%',147,49,1,31,0,'2010-04-17 06:29:13',NULL,NULL,NULL,'2010-04-17 06:30:13','2010-04-17 06:30:13'),(125,0,28,62,'内存监测 - SNMP',1,'memory usage: 98%',162,52,1,33,0,'2010-04-17 06:38:00',NULL,NULL,NULL,'2010-04-17 06:38:13','2010-04-17 06:38:13'),(126,0,28,62,'内存监测 - SNMP',0,'memory usage: 97%',162,52,1,33,0,'2010-04-17 06:49:00',NULL,NULL,NULL,'2010-04-17 06:50:13','2010-04-17 06:50:13'),(127,0,26,60,'内存监测 - SNMP',0,'memory usage: 88%',147,49,1,31,0,'2010-04-17 06:55:13',NULL,NULL,NULL,'2010-04-17 06:56:13','2010-04-17 06:56:13'),(128,1,26,60,'内存监测 - SNMP',0,'memory usage: 88%',147,49,1,31,1,'2010-04-17 06:55:13','222.177.4.98 / 内存监测 - SNMP 恢复正常','222.177.4.98 / 内存监测 - SNMP 于 04-17 06:55 恢复正常。\n详细：http://t.monit.cn/services/147\n\n','<p>\n<a href=\"http://t.monit.cn/hosts/49\">222.177.4.98</a> / <a href=\"http://t.monit.cn/services/147\">内存监测 - SNMP</a> 于 04-17 06:55 恢复正常\n</p>\n<p>\n\n查看详细：<a href=\"http://t.monit.cn/services/147\">http://t.monit.cn/services/147</a>\n</p>\n<p>\n\n通知设置：<a href=\"http://t.monit.cn/account/notify\">http://t.monit.cn/account/notify</a>\n</p>\n\n<p>&nbsp;</p>\n<p>\n<font color=\"gray\">--Monit</font>\n<br />\n<br />\n\n<a href=\"http://t.monit.cn/\">http://t.monit.cn/</a>\n</p>\n\n','2010-04-17 06:56:13','2010-04-17 06:58:03'),(130,0,26,60,'内存监测 - SNMP',1,'memory usage: 90%',147,49,1,31,0,'2010-04-17 07:15:13',NULL,NULL,NULL,'2010-04-17 07:16:13','2010-04-17 07:16:13'),(131,0,26,60,'内存监测 - SNMP',0,'memory usage: 88%',147,49,1,31,0,'2010-04-17 07:16:13',NULL,NULL,NULL,'2010-04-17 07:18:13','2010-04-17 07:18:13'),(132,1,26,60,'内存监测 - SNMP',0,'memory usage: 88%',147,49,1,31,1,'2010-04-17 07:16:13','222.177.4.98 / 内存监测 - SNMP 恢复正常','222.177.4.98 / 内存监测 - SNMP 于 04-17 07:16 恢复正常。\n详细：http://t.monit.cn/services/147\n\n','<p>\n<a href=\"http://t.monit.cn/hosts/49\">222.177.4.98</a> / <a href=\"http://t.monit.cn/services/147\">内存监测 - SNMP</a> 于 04-17 07:16 恢复正常\n</p>\n<p>\n\n查看详细：<a href=\"http://t.monit.cn/services/147\">http://t.monit.cn/services/147</a>\n</p>\n<p>\n\n通知设置：<a href=\"http://t.monit.cn/account/notify\">http://t.monit.cn/account/notify</a>\n</p>\n\n<p>&nbsp;</p>\n<p>\n<font color=\"gray\">--Monit</font>\n<br />\n<br />\n\n<a href=\"http://t.monit.cn/\">http://t.monit.cn/</a>\n</p>\n\n','2010-04-17 07:18:13','2010-04-17 07:20:03'),(134,0,26,60,'内存监测 - SNMP',1,'memory usage: 91%',147,49,1,31,0,'2010-04-17 07:31:13',NULL,NULL,NULL,'2010-04-17 07:32:13','2010-04-17 07:32:13'),(135,0,26,60,'内存监测 - SNMP',0,'memory usage: 89%',147,49,1,31,0,'2010-04-17 07:52:13',NULL,NULL,NULL,'2010-04-17 07:54:13','2010-04-17 07:54:13'),(136,1,26,60,'内存监测 - SNMP',0,'memory usage: 89%',147,49,1,31,1,'2010-04-17 07:52:13','222.177.4.98 / 内存监测 - SNMP 恢复正常','222.177.4.98 / 内存监测 - SNMP 于 04-17 07:52 恢复正常。\n详细：http://t.monit.cn/services/147\n\n','<p>\n<a href=\"http://t.monit.cn/hosts/49\">222.177.4.98</a> / <a href=\"http://t.monit.cn/services/147\">内存监测 - SNMP</a> 于 04-17 07:52 恢复正常\n</p>\n<p>\n\n查看详细：<a href=\"http://t.monit.cn/services/147\">http://t.monit.cn/services/147</a>\n</p>\n<p>\n\n通知设置：<a href=\"http://t.monit.cn/account/notify\">http://t.monit.cn/account/notify</a>\n</p>\n\n<p>&nbsp;</p>\n<p>\n<font color=\"gray\">--Monit</font>\n<br />\n<br />\n\n<a href=\"http://t.monit.cn/\">http://t.monit.cn/</a>\n</p>\n\n','2010-04-17 07:54:13','2010-04-17 07:56:02'),(138,0,28,62,'内存监测 - SNMP',1,'memory usage: 98%',162,52,1,33,0,'2010-04-17 08:29:00',NULL,NULL,NULL,'2010-04-17 08:30:13','2010-04-17 08:30:13'),(139,0,26,60,'内存监测 - SNMP',1,'memory usage: 92%',147,49,1,31,0,'2010-04-17 08:32:13',NULL,NULL,NULL,'2010-04-17 08:34:13','2010-04-17 08:34:13'),(140,0,28,62,'内存监测 - SNMP',0,'memory usage: 97%',162,52,1,33,0,'2010-04-17 08:50:00',NULL,NULL,NULL,'2010-04-17 08:50:13','2010-04-17 08:50:13'),(141,0,28,62,'内存监测 - SNMP',1,'memory usage: 98%',162,52,1,33,0,'2010-04-17 09:00:00',NULL,NULL,NULL,'2010-04-17 09:00:13','2010-04-17 09:00:13'),(142,0,26,60,'内存监测 - SNMP',0,'memory usage: 89%',147,49,1,31,0,'2010-04-17 09:08:13',NULL,NULL,NULL,'2010-04-17 09:08:13','2010-04-17 09:08:13'),(143,1,26,60,'内存监测 - SNMP',0,'memory usage: 89%',147,49,1,31,1,'2010-04-17 09:08:13','222.177.4.98 / 内存监测 - SNMP 恢复正常','222.177.4.98 / 内存监测 - SNMP 于 04-17 09:08 恢复正常。\n详细：http://t.monit.cn/services/147\n\n','<p>\n<a href=\"http://t.monit.cn/hosts/49\">222.177.4.98</a> / <a href=\"http://t.monit.cn/services/147\">内存监测 - SNMP</a> 于 04-17 09:08 恢复正常\n</p>\n<p>\n\n查看详细：<a href=\"http://t.monit.cn/services/147\">http://t.monit.cn/services/147</a>\n</p>\n<p>\n\n通知设置：<a href=\"http://t.monit.cn/account/notify\">http://t.monit.cn/account/notify</a>\n</p>\n\n<p>&nbsp;</p>\n<p>\n<font color=\"gray\">--Monit</font>\n<br />\n<br />\n\n<a href=\"http://t.monit.cn/\">http://t.monit.cn/</a>\n</p>\n\n','2010-04-17 09:08:13','2010-04-17 09:10:02'),(145,0,26,60,'内存监测 - SNMP',1,'memory usage: 90%',147,49,1,31,0,'2010-04-17 09:13:13',NULL,NULL,NULL,'2010-04-17 09:14:13','2010-04-17 09:14:13'),(146,0,28,62,'内存监测 - SNMP',0,'memory usage: 89%',162,52,1,33,0,'2010-04-17 09:21:01',NULL,NULL,NULL,'2010-04-17 09:22:13','2010-04-17 09:22:13'),(147,0,28,62,'内存监测 - SNMP',1,'memory usage: 98%',162,52,1,33,0,'2010-04-17 09:31:01',NULL,NULL,NULL,'2010-04-17 09:32:13','2010-04-17 09:32:13'),(148,0,28,62,'内存监测 - SNMP',0,'memory usage: 96%',162,52,1,33,0,'2010-04-17 09:32:31',NULL,NULL,NULL,'2010-04-17 09:34:13','2010-04-17 09:34:13'),(149,0,28,63,'PING监测',1,'Packet loss = 25%, RTA = 115.249ms',163,53,1,33,0,'2010-04-17 12:52:27',NULL,NULL,NULL,'2010-04-17 12:54:13','2010-04-17 12:54:13'),(150,0,28,63,'PING监测',0,'Packet loss = 0%, RTA = 21.130ms',163,53,1,33,0,'2010-04-17 13:03:27',NULL,NULL,NULL,'2010-04-17 13:04:13','2010-04-17 13:04:13'),(151,0,1,64,'内存监测',1,'memory usage: 98%',75,24,1,1,0,'2010-04-17 16:32:25',NULL,NULL,NULL,'2010-04-17 16:34:13','2010-04-17 16:34:13'),(152,0,1,64,'内存监测',0,'memory usage: 97%',75,24,1,1,0,'2010-04-17 16:38:55',NULL,NULL,NULL,'2010-04-17 16:40:13','2010-04-17 16:40:13'),(153,1,1,64,'内存监测',0,'memory usage: 97%',75,24,1,1,1,'2010-04-17 16:38:55','重庆 - WLAN - 采集1 / 内存监测 恢复正常','重庆 - WLAN - 采集1 / 内存监测 于 04-17 16:38 恢复正常。\n详细：http://t.monit.cn/services/75\n\n','<p>\n<a href=\"http://t.monit.cn/hosts/24\">重庆 - WLAN - 采集1</a> / <a href=\"http://t.monit.cn/services/75\">内存监测</a> 于 04-17 16:38 恢复正常\n</p>\n<p>\n\n查看详细：<a href=\"http://t.monit.cn/services/75\">http://t.monit.cn/services/75</a>\n</p>\n<p>\n\n通知设置：<a href=\"http://t.monit.cn/account/notify\">http://t.monit.cn/account/notify</a>\n</p>\n\n<p>&nbsp;</p>\n<p>\n<font color=\"gray\">--Monit</font>\n<br />\n<br />\n\n<a href=\"http://t.monit.cn/\">http://t.monit.cn/</a>\n</p>\n\n','2010-04-17 16:40:13','2010-04-17 16:42:02'),(155,0,1,64,'内存监测',1,'memory usage: 98%',75,24,1,1,0,'2010-04-17 16:43:55',NULL,NULL,NULL,'2010-04-17 16:44:13','2010-04-17 16:44:13'),(156,0,1,59,'PING监测',1,'Packet loss = 25%, RTA = 92.672ms',128,47,1,1,0,'2010-04-17 16:45:09',NULL,NULL,NULL,'2010-04-17 16:46:13','2010-04-17 16:46:13'),(157,0,1,59,'PING监测',0,'Packet loss = 0%, RTA = 92.482ms',128,47,1,1,0,'2010-04-17 16:52:09',NULL,NULL,NULL,'2010-04-17 16:52:13','2010-04-17 16:52:13'),(158,1,1,59,'PING监测',0,'Packet loss = 0%, RTA = 92.482ms',128,47,1,1,1,'2010-04-17 16:52:09','宁夏 - EPON - WEB服务器 / PING监测 恢复正常','宁夏 - EPON - WEB服务器 / PING监测 于 04-17 16:52 恢复正常。\n详细：http://t.monit.cn/services/128\n\n','<p>\n<a href=\"http://t.monit.cn/hosts/47\">宁夏 - EPON - WEB服务器</a> / <a href=\"http://t.monit.cn/services/128\">PING监测</a> 于 04-17 16:52 恢复正常\n</p>\n<p>\n\n查看详细：<a href=\"http://t.monit.cn/services/128\">http://t.monit.cn/services/128</a>\n</p>\n<p>\n\n通知设置：<a href=\"http://t.monit.cn/account/notify\">http://t.monit.cn/account/notify</a>\n</p>\n\n<p>&nbsp;</p>\n<p>\n<font color=\"gray\">--Monit</font>\n<br />\n<br />\n\n<a href=\"http://t.monit.cn/\">http://t.monit.cn/</a>\n</p>\n\n','2010-04-17 16:52:13','2010-04-17 16:54:03'),(160,0,1,59,'PING监测',1,'Packet loss = 25%, RTA = 92.688ms',128,47,1,1,0,'2010-04-17 17:02:09',NULL,NULL,NULL,'2010-04-17 17:04:13','2010-04-17 17:04:13'),(161,0,1,59,'PING监测',0,'Packet loss = 0%, RTA = 92.665ms',128,47,1,1,0,'2010-04-17 17:08:09',NULL,NULL,NULL,'2010-04-17 17:08:13','2010-04-17 17:08:13'),(162,1,1,59,'PING监测',0,'Packet loss = 0%, RTA = 92.665ms',128,47,1,1,1,'2010-04-17 17:08:09','宁夏 - EPON - WEB服务器 / PING监测 恢复正常','宁夏 - EPON - WEB服务器 / PING监测 于 04-17 17:08 恢复正常。\n详细：http://t.monit.cn/services/128\n\n','<p>\n<a href=\"http://t.monit.cn/hosts/47\">宁夏 - EPON - WEB服务器</a> / <a href=\"http://t.monit.cn/services/128\">PING监测</a> 于 04-17 17:08 恢复正常\n</p>\n<p>\n\n查看详细：<a href=\"http://t.monit.cn/services/128\">http://t.monit.cn/services/128</a>\n</p>\n<p>\n\n通知设置：<a href=\"http://t.monit.cn/account/notify\">http://t.monit.cn/account/notify</a>\n</p>\n\n<p>&nbsp;</p>\n<p>\n<font color=\"gray\">--Monit</font>\n<br />\n<br />\n\n<a href=\"http://t.monit.cn/\">http://t.monit.cn/</a>\n</p>\n\n','2010-04-17 17:08:13','2010-04-17 17:10:03'),(163,0,8,65,'PING监测',2,'Packet loss = 100%',176,57,1,10,0,'2010-04-17 17:07:06',NULL,NULL,NULL,'2010-04-17 17:08:13','2010-04-17 17:08:13'),(164,1,8,65,'PING监测',2,'Packet loss = 100%',176,57,1,10,1,'2010-04-17 17:07:06','湖南WEB服务器 / PING监测 故障','湖南WEB服务器 / PING监测 于 04-17 17:07 故障。\n详细：http://t.monit.cn/services/176\n\n','<p>\n<a href=\"http://t.monit.cn/hosts/57\">湖南WEB服务器</a> / <a href=\"http://t.monit.cn/services/176\">PING监测</a> 于 04-17 17:07 故障\n</p>\n<p>\n\n查看详细：<a href=\"http://t.monit.cn/services/176\">http://t.monit.cn/services/176</a>\n</p>\n<p>\n\n通知设置：<a href=\"http://t.monit.cn/account/notify\">http://t.monit.cn/account/notify</a>\n</p>\n\n<p>&nbsp;</p>\n<p>\n<font color=\"gray\">--Monit</font>\n<br />\n<br />\n\n<a href=\"http://t.monit.cn/\">http://t.monit.cn/</a>\n</p>\n\n','2010-04-17 17:08:13','2010-04-17 17:10:03'),(168,0,8,65,'PING监测',0,'Packet loss = 0%, RTA = 53.099ms',176,57,1,10,0,'2010-04-17 17:08:36',NULL,NULL,NULL,'2010-04-17 17:10:13','2010-04-17 17:10:13'),(169,1,8,65,'PING监测',0,'Packet loss = 0%, RTA = 53.099ms',176,57,1,10,1,'2010-04-17 17:08:36','湖南WEB服务器 / PING监测 恢复正常','湖南WEB服务器 / PING监测 于 04-17 17:08 恢复正常。\n详细：http://t.monit.cn/services/176\n\n','<p>\n<a href=\"http://t.monit.cn/hosts/57\">湖南WEB服务器</a> / <a href=\"http://t.monit.cn/services/176\">PING监测</a> 于 04-17 17:08 恢复正常\n</p>\n<p>\n\n查看详细：<a href=\"http://t.monit.cn/services/176\">http://t.monit.cn/services/176</a>\n</p>\n<p>\n\n通知设置：<a href=\"http://t.monit.cn/account/notify\">http://t.monit.cn/account/notify</a>\n</p>\n\n<p>&nbsp;</p>\n<p>\n<font color=\"gray\">--Monit</font>\n<br />\n<br />\n\n<a href=\"http://t.monit.cn/\">http://t.monit.cn/</a>\n</p>\n\n','2010-04-17 17:10:13','2010-04-17 17:12:02'),(171,0,1,59,'PING监测',1,'Packet loss = 25%, RTA = 92.504ms',128,47,1,1,0,'2010-04-17 18:58:09',NULL,NULL,NULL,'2010-04-17 19:00:13','2010-04-17 19:00:13'),(172,0,1,59,'PING监测',0,'Packet loss = 0%, RTA = 92.652ms',128,47,1,1,0,'2010-04-17 19:04:09',NULL,NULL,NULL,'2010-04-17 19:04:13','2010-04-17 19:04:13'),(173,1,1,59,'PING监测',0,'Packet loss = 0%, RTA = 92.652ms',128,47,1,1,1,'2010-04-17 19:04:09','宁夏 - EPON - WEB服务器 / PING监测 恢复正常','宁夏 - EPON - WEB服务器 / PING监测 于 04-17 19:04 恢复正常。\n详细：http://t.monit.cn/services/128\n\n','<p>\n<a href=\"http://t.monit.cn/hosts/47\">宁夏 - EPON - WEB服务器</a> / <a href=\"http://t.monit.cn/services/128\">PING监测</a> 于 04-17 19:04 恢复正常\n</p>\n<p>\n\n查看详细：<a href=\"http://t.monit.cn/services/128\">http://t.monit.cn/services/128</a>\n</p>\n<p>\n\n通知设置：<a href=\"http://t.monit.cn/account/notify\">http://t.monit.cn/account/notify</a>\n</p>\n\n<p>&nbsp;</p>\n<p>\n<font color=\"gray\">--Monit</font>\n<br />\n<br />\n\n<a href=\"http://t.monit.cn/\">http://t.monit.cn/</a>\n</p>\n\n','2010-04-17 19:04:13','2010-04-17 19:06:02'),(175,0,1,59,'PING监测',1,'Packet loss = 25%, RTA = 92.505ms',128,47,1,1,0,'2010-04-17 19:44:09',NULL,NULL,NULL,'2010-04-17 19:46:13','2010-04-17 19:46:13'),(176,0,1,59,'PING监测',0,'Packet loss = 0%, RTA = 92.614ms',128,47,1,1,0,'2010-04-17 19:50:09',NULL,NULL,NULL,'2010-04-17 19:50:13','2010-04-17 19:50:13'),(177,1,1,59,'PING监测',0,'Packet loss = 0%, RTA = 92.614ms',128,47,1,1,1,'2010-04-17 19:50:09','宁夏 - EPON - WEB服务器 / PING监测 恢复正常','宁夏 - EPON - WEB服务器 / PING监测 于 04-17 19:50 恢复正常。\n详细：http://t.monit.cn/services/128\n\n','<p>\n<a href=\"http://t.monit.cn/hosts/47\">宁夏 - EPON - WEB服务器</a> / <a href=\"http://t.monit.cn/services/128\">PING监测</a> 于 04-17 19:50 恢复正常\n</p>\n<p>\n\n查看详细：<a href=\"http://t.monit.cn/services/128\">http://t.monit.cn/services/128</a>\n</p>\n<p>\n\n通知设置：<a href=\"http://t.monit.cn/account/notify\">http://t.monit.cn/account/notify</a>\n</p>\n\n<p>&nbsp;</p>\n<p>\n<font color=\"gray\">--Monit</font>\n<br />\n<br />\n\n<a href=\"http://t.monit.cn/\">http://t.monit.cn/</a>\n</p>\n\n','2010-04-17 19:50:13','2010-04-17 19:52:02'),(179,0,28,20,'内存监测 - SNMP',0,'memory usage: 96%',157,56,1,33,0,'2010-04-17 19:58:05',NULL,NULL,NULL,'2010-04-17 19:58:13','2010-04-17 19:58:13'),(180,0,1,59,'PING监测',1,'Packet loss = 25%, RTA = 92.678ms',128,47,1,1,0,'2010-04-17 20:30:09',NULL,NULL,NULL,'2010-04-17 20:30:13','2010-04-17 20:30:13'),(181,0,28,66,'PING监测',1,'Packet loss = 25%, RTA = 21.913ms',167,55,1,33,0,'2010-04-17 20:41:31',NULL,NULL,NULL,'2010-04-17 20:42:13','2010-04-17 20:42:13'),(182,0,28,66,'PING监测',0,'Packet loss = 0%, RTA = 22.005ms',167,55,1,33,0,'2010-04-17 20:42:31',NULL,NULL,NULL,'2010-04-17 20:44:13','2010-04-17 20:44:13'),(183,0,1,59,'PING监测',0,'Packet loss = 0%, RTA = 92.737ms',128,47,1,1,0,'2010-04-17 20:46:09',NULL,NULL,NULL,'2010-04-17 20:46:13','2010-04-17 20:46:13'),(184,1,1,59,'PING监测',0,'Packet loss = 0%, RTA = 92.737ms',128,47,1,1,1,'2010-04-17 20:46:09','宁夏 - EPON - WEB服务器 / PING监测 恢复正常','宁夏 - EPON - WEB服务器 / PING监测 于 04-17 20:46 恢复正常。\n详细：http://t.monit.cn/services/128\n\n','<p>\n<a href=\"http://t.monit.cn/hosts/47\">宁夏 - EPON - WEB服务器</a> / <a href=\"http://t.monit.cn/services/128\">PING监测</a> 于 04-17 20:46 恢复正常\n</p>\n<p>\n\n查看详细：<a href=\"http://t.monit.cn/services/128\">http://t.monit.cn/services/128</a>\n</p>\n<p>\n\n通知设置：<a href=\"http://t.monit.cn/account/notify\">http://t.monit.cn/account/notify</a>\n</p>\n\n<p>&nbsp;</p>\n<p>\n<font color=\"gray\">--Monit</font>\n<br />\n<br />\n\n<a href=\"http://t.monit.cn/\">http://t.monit.cn/</a>\n</p>\n\n','2010-04-17 20:46:13','2010-04-17 20:48:02'),(186,0,1,59,'PING监测',1,'Packet loss = 25%, RTA = 107.115ms',128,47,1,1,0,'2010-04-17 21:16:10',NULL,NULL,NULL,'2010-04-17 21:18:13','2010-04-17 21:18:13'),(187,0,1,59,'PING监测',0,'Packet loss = 0%, RTA = 117.892ms',128,47,1,1,0,'2010-04-17 21:22:10',NULL,NULL,NULL,'2010-04-17 21:24:13','2010-04-17 21:24:13'),(188,1,1,59,'PING监测',0,'Packet loss = 0%, RTA = 117.892ms',128,47,1,1,1,'2010-04-17 21:22:10','宁夏 - EPON - WEB服务器 / PING监测 恢复正常','宁夏 - EPON - WEB服务器 / PING监测 于 04-17 21:22 恢复正常。\n详细：http://t.monit.cn/services/128\n\n','<p>\n<a href=\"http://t.monit.cn/hosts/47\">宁夏 - EPON - WEB服务器</a> / <a href=\"http://t.monit.cn/services/128\">PING监测</a> 于 04-17 21:22 恢复正常\n</p>\n<p>\n\n查看详细：<a href=\"http://t.monit.cn/services/128\">http://t.monit.cn/services/128</a>\n</p>\n<p>\n\n通知设置：<a href=\"http://t.monit.cn/account/notify\">http://t.monit.cn/account/notify</a>\n</p>\n\n<p>&nbsp;</p>\n<p>\n<font color=\"gray\">--Monit</font>\n<br />\n<br />\n\n<a href=\"http://t.monit.cn/\">http://t.monit.cn/</a>\n</p>\n\n','2010-04-17 21:24:13','2010-04-17 21:26:02'),(190,0,1,59,'PING监测',1,'Packet loss = 25%, RTA = 108.001ms',128,47,1,1,0,'2010-04-17 21:32:10',NULL,NULL,NULL,'2010-04-17 21:34:13','2010-04-17 21:34:13'),(191,0,1,67,'PING监测',1,'Packet loss = 25%, RTA = 46.138ms',113,45,1,1,0,'2010-04-17 21:35:01',NULL,NULL,NULL,'2010-04-17 21:36:13','2010-04-17 21:36:13'),(192,0,1,67,'PING监测',0,'Packet loss = 0%, RTA = 45.706ms',113,45,1,1,0,'2010-04-17 21:41:01',NULL,NULL,NULL,'2010-04-17 21:42:13','2010-04-17 21:42:13'),(193,1,1,67,'PING监测',0,'Packet loss = 0%, RTA = 45.706ms',113,45,1,1,1,'2010-04-17 21:41:01','宁夏 - EPON - 采集服务器 / PING监测 恢复正常','宁夏 - EPON - 采集服务器 / PING监测 于 04-17 21:41 恢复正常。\n详细：http://t.monit.cn/services/113\n\n','<p>\n<a href=\"http://t.monit.cn/hosts/45\">宁夏 - EPON - 采集服务器</a> / <a href=\"http://t.monit.cn/services/113\">PING监测</a> 于 04-17 21:41 恢复正常\n</p>\n<p>\n\n查看详细：<a href=\"http://t.monit.cn/services/113\">http://t.monit.cn/services/113</a>\n</p>\n<p>\n\n通知设置：<a href=\"http://t.monit.cn/account/notify\">http://t.monit.cn/account/notify</a>\n</p>\n\n<p>&nbsp;</p>\n<p>\n<font color=\"gray\">--Monit</font>\n<br />\n<br />\n\n<a href=\"http://t.monit.cn/\">http://t.monit.cn/</a>\n</p>\n\n','2010-04-17 21:42:13','2010-04-17 21:44:02'),(195,0,1,59,'PING监测',0,'Packet loss = 0%, RTA = 94.017ms',128,47,1,1,0,'2010-04-17 21:44:10',NULL,NULL,NULL,'2010-04-17 21:46:13','2010-04-17 21:46:13'),(196,1,1,59,'PING监测',0,'Packet loss = 0%, RTA = 94.017ms',128,47,1,1,1,'2010-04-17 21:44:10','宁夏 - EPON - WEB服务器 / PING监测 恢复正常','宁夏 - EPON - WEB服务器 / PING监测 于 04-17 21:44 恢复正常。\n详细：http://t.monit.cn/services/128\n\n','<p>\n<a href=\"http://t.monit.cn/hosts/47\">宁夏 - EPON - WEB服务器</a> / <a href=\"http://t.monit.cn/services/128\">PING监测</a> 于 04-17 21:44 恢复正常\n</p>\n<p>\n\n查看详细：<a href=\"http://t.monit.cn/services/128\">http://t.monit.cn/services/128</a>\n</p>\n<p>\n\n通知设置：<a href=\"http://t.monit.cn/account/notify\">http://t.monit.cn/account/notify</a>\n</p>\n\n<p>&nbsp;</p>\n<p>\n<font color=\"gray\">--Monit</font>\n<br />\n<br />\n\n<a href=\"http://t.monit.cn/\">http://t.monit.cn/</a>\n</p>\n\n','2010-04-17 21:46:13','2010-04-17 21:48:02'),(198,0,1,59,'PING监测',1,'Packet loss = 25%, RTA = 92.855ms',128,47,1,1,0,'2010-04-17 21:54:10',NULL,NULL,NULL,'2010-04-17 21:56:13','2010-04-17 21:56:13'),(199,0,1,59,'PING监测',0,'Packet loss = 0%, RTA = 92.766ms',128,47,1,1,0,'2010-04-17 22:00:10',NULL,NULL,NULL,'2010-04-17 22:00:13','2010-04-17 22:00:13'),(200,1,1,59,'PING监测',0,'Packet loss = 0%, RTA = 92.766ms',128,47,1,1,1,'2010-04-17 22:00:10','宁夏 - EPON - WEB服务器 / PING监测 恢复正常','宁夏 - EPON - WEB服务器 / PING监测 于 04-17 22:00 恢复正常。\n详细：http://t.monit.cn/services/128\n\n','<p>\n<a href=\"http://t.monit.cn/hosts/47\">宁夏 - EPON - WEB服务器</a> / <a href=\"http://t.monit.cn/services/128\">PING监测</a> 于 04-17 22:00 恢复正常\n</p>\n<p>\n\n查看详细：<a href=\"http://t.monit.cn/services/128\">http://t.monit.cn/services/128</a>\n</p>\n<p>\n\n通知设置：<a href=\"http://t.monit.cn/account/notify\">http://t.monit.cn/account/notify</a>\n</p>\n\n<p>&nbsp;</p>\n<p>\n<font color=\"gray\">--Monit</font>\n<br />\n<br />\n\n<a href=\"http://t.monit.cn/\">http://t.monit.cn/</a>\n</p>\n\n','2010-04-17 22:00:13','2010-04-17 22:02:02'),(202,0,1,59,'PING监测',1,'Packet loss = 25%, RTA = 92.792ms',128,47,1,1,0,'2010-04-17 22:05:10',NULL,NULL,NULL,'2010-04-17 22:06:13','2010-04-17 22:06:13'),(203,0,1,59,'PING监测',0,'Packet loss = 0%, RTA = 92.613ms',128,47,1,1,0,'2010-04-17 22:06:10',NULL,NULL,NULL,'2010-04-17 22:08:13','2010-04-17 22:08:13'),(204,1,1,59,'PING监测',0,'Packet loss = 0%, RTA = 92.613ms',128,47,1,1,1,'2010-04-17 22:06:10','宁夏 - EPON - WEB服务器 / PING监测 恢复正常','宁夏 - EPON - WEB服务器 / PING监测 于 04-17 22:06 恢复正常。\n详细：http://t.monit.cn/services/128\n\n','<p>\n<a href=\"http://t.monit.cn/hosts/47\">宁夏 - EPON - WEB服务器</a> / <a href=\"http://t.monit.cn/services/128\">PING监测</a> 于 04-17 22:06 恢复正常\n</p>\n<p>\n\n查看详细：<a href=\"http://t.monit.cn/services/128\">http://t.monit.cn/services/128</a>\n</p>\n<p>\n\n通知设置：<a href=\"http://t.monit.cn/account/notify\">http://t.monit.cn/account/notify</a>\n</p>\n\n<p>&nbsp;</p>\n<p>\n<font color=\"gray\">--Monit</font>\n<br />\n<br />\n\n<a href=\"http://t.monit.cn/\">http://t.monit.cn/</a>\n</p>\n\n','2010-04-17 22:08:13','2010-04-17 22:10:02'),(205,0,28,20,'内存监测 - SNMP',1,'memory usage: 99%',157,56,1,33,0,'2010-04-17 22:08:05',NULL,NULL,NULL,'2010-04-17 22:08:13','2010-04-17 22:08:13'),(206,0,1,59,'PING监测',1,'Packet loss = 25%, RTA = 93.387ms',128,47,1,1,0,'2010-04-17 22:21:10',NULL,NULL,NULL,'2010-04-17 22:22:13','2010-04-17 22:22:13'),(207,0,1,59,'PING监测',0,'Packet loss = 0%, RTA = 93.199ms',128,47,1,1,0,'2010-04-17 22:22:10',NULL,NULL,NULL,'2010-04-17 22:24:13','2010-04-17 22:24:13'),(208,1,1,59,'PING监测',0,'Packet loss = 0%, RTA = 93.199ms',128,47,1,1,1,'2010-04-17 22:22:10','宁夏 - EPON - WEB服务器 / PING监测 恢复正常','宁夏 - EPON - WEB服务器 / PING监测 于 04-17 22:22 恢复正常。\n详细：http://t.monit.cn/services/128\n\n','<p>\n<a href=\"http://t.monit.cn/hosts/47\">宁夏 - EPON - WEB服务器</a> / <a href=\"http://t.monit.cn/services/128\">PING监测</a> 于 04-17 22:22 恢复正常\n</p>\n<p>\n\n查看详细：<a href=\"http://t.monit.cn/services/128\">http://t.monit.cn/services/128</a>\n</p>\n<p>\n\n通知设置：<a href=\"http://t.monit.cn/account/notify\">http://t.monit.cn/account/notify</a>\n</p>\n\n<p>&nbsp;</p>\n<p>\n<font color=\"gray\">--Monit</font>\n<br />\n<br />\n\n<a href=\"http://t.monit.cn/\">http://t.monit.cn/</a>\n</p>\n\n','2010-04-17 22:24:13','2010-04-17 22:26:03'),(210,0,1,64,'内存监测',0,'memory usage: 92%',75,24,1,1,0,'2010-04-18 03:59:55',NULL,NULL,NULL,'2010-04-18 04:00:13','2010-04-18 04:00:13'),(211,0,28,62,'内存监测 - SNMP',1,'memory usage: 98%',162,52,1,33,0,'2010-04-18 04:42:31',NULL,NULL,NULL,'2010-04-18 04:44:13','2010-04-18 04:44:13'),(212,0,28,62,'内存监测 - SNMP',0,'memory usage: 97%',162,52,1,33,0,'2010-04-18 04:53:31',NULL,NULL,NULL,'2010-04-18 04:54:13','2010-04-18 04:54:13'),(213,0,28,62,'内存监测 - SNMP',1,'memory usage: 98%',162,52,1,33,0,'2010-04-18 08:03:31',NULL,NULL,NULL,'2010-04-18 08:04:13','2010-04-18 08:04:13'),(214,0,28,62,'内存监测 - SNMP',0,'memory usage: 89%',162,52,1,33,0,'2010-04-18 08:14:31',NULL,NULL,NULL,'2010-04-18 08:16:13','2010-04-18 08:16:13'),(215,0,28,62,'内存监测 - SNMP',1,'memory usage: 98%',162,52,1,33,0,'2010-04-18 08:24:31',NULL,NULL,NULL,'2010-04-18 08:26:13','2010-04-18 08:26:13'),(216,0,28,62,'内存监测 - SNMP',0,'memory usage: 97%',162,52,1,33,0,'2010-04-18 08:35:31',NULL,NULL,NULL,'2010-04-18 08:36:13','2010-04-18 08:36:13'),(217,0,28,62,'内存监测 - SNMP',1,'memory usage: 98%',162,52,1,33,0,'2010-04-18 08:45:31',NULL,NULL,NULL,'2010-04-18 08:46:13','2010-04-18 08:46:13'),(218,0,28,62,'内存监测 - SNMP',0,'memory usage: 97%',162,52,1,33,0,'2010-04-18 08:46:31',NULL,NULL,NULL,'2010-04-18 08:48:13','2010-04-18 08:48:13'),(219,0,28,20,'内存监测 - SNMP',0,'memory usage: 97%',157,56,1,33,0,'2010-04-18 09:09:06',NULL,NULL,NULL,'2010-04-18 09:10:13','2010-04-18 09:10:13'),(220,0,28,20,'内存监测 - SNMP',1,'memory usage: 98%',157,56,1,33,0,'2010-04-18 09:29:06',NULL,NULL,NULL,'2010-04-18 09:30:13','2010-04-18 09:30:13'),(221,0,1,59,'PING监测',1,'Packet loss = 25%, RTA = 92.463ms',128,47,1,1,0,'2010-04-18 13:47:11',NULL,NULL,NULL,'2010-04-18 13:48:13','2010-04-18 13:48:13'),(222,0,1,59,'PING监测',0,'Packet loss = 0%, RTA = 92.421ms',128,47,1,1,0,'2010-04-18 13:48:11',NULL,NULL,NULL,'2010-04-18 13:50:13','2010-04-18 13:50:13'),(223,0,28,20,'内存监测 - SNMP',0,'memory usage: 97%',157,56,1,33,0,'2010-04-18 14:50:06',NULL,NULL,NULL,'2010-04-18 14:50:13','2010-04-18 14:50:13'),(224,0,28,68,'PING监测',1,'Packet loss = 25%, RTA = 16.001ms',165,54,1,33,0,'2010-04-18 14:54:17',NULL,NULL,NULL,'2010-04-18 14:56:13','2010-04-18 14:56:13'),(225,0,28,68,'PING监测',0,'Packet loss = 0%, RTA = 13.391ms',165,54,1,33,0,'2010-04-18 15:05:17',NULL,NULL,NULL,'2010-04-18 15:06:13','2010-04-18 15:06:13'),(226,0,28,20,'内存监测 - SNMP',1,'memory usage: 98%',157,56,1,33,0,'2010-04-18 15:10:06',NULL,NULL,NULL,'2010-04-18 15:10:13','2010-04-18 15:10:13'),(227,0,1,59,'PING监测',1,'Packet loss = 25%, RTA = 92.677ms',128,47,1,1,0,'2010-04-18 15:53:11',NULL,NULL,NULL,'2010-04-18 15:54:13','2010-04-18 15:54:13'),(228,0,1,59,'PING监测',0,'Packet loss = 0%, RTA = 92.567ms',128,47,1,1,0,'2010-04-18 15:54:11',NULL,NULL,NULL,'2010-04-18 15:56:13','2010-04-18 15:56:13'),(229,0,28,68,'PING监测',1,'Packet loss = 25%, RTA = 119.129ms',165,54,1,33,0,'2010-04-18 16:05:17',NULL,NULL,NULL,'2010-04-18 16:06:13','2010-04-18 16:06:13'),(230,0,28,68,'PING监测',0,'Packet loss = 0%, RTA = 15.845ms',165,54,1,33,0,'2010-04-18 16:06:17',NULL,NULL,NULL,'2010-04-18 16:08:13','2010-04-18 16:08:13'),(231,0,1,59,'PING监测',1,'Packet loss = 25%, RTA = 92.596ms',128,47,1,1,0,'2010-04-18 16:29:11',NULL,NULL,NULL,'2010-04-18 16:30:13','2010-04-18 16:30:13'),(232,0,1,59,'PING监测',0,'Packet loss = 0%, RTA = 92.546ms',128,47,1,1,0,'2010-04-18 16:30:11',NULL,NULL,NULL,'2010-04-18 16:32:13','2010-04-18 16:32:13'),(233,0,1,59,'PING监测',1,'Packet loss = 25%, RTA = 92.670ms',128,47,1,1,0,'2010-04-18 17:50:11',NULL,NULL,NULL,'2010-04-18 17:52:13','2010-04-18 17:52:13'),(234,0,1,59,'PING监测',0,'Packet loss = 0%, RTA = 92.498ms',128,47,1,1,0,'2010-04-18 17:56:11',NULL,NULL,NULL,'2010-04-18 17:58:13','2010-04-18 17:58:13'),(235,0,28,68,'PING监测',1,'Packet loss = 25%, RTA = 13.465ms',165,54,1,33,0,'2010-04-18 19:16:17',NULL,NULL,NULL,'2010-04-18 19:18:13','2010-04-18 19:18:13'),(236,0,28,68,'PING监测',0,'Packet loss = 0%, RTA = 13.428ms',165,54,1,33,0,'2010-04-18 19:27:17',NULL,NULL,NULL,'2010-04-18 19:28:13','2010-04-18 19:28:13'),(237,0,1,59,'PING监测',1,'Packet loss = 25%, RTA = 92.464ms',128,47,1,1,0,'2010-04-18 20:21:11',NULL,NULL,NULL,'2010-04-18 20:22:13','2010-04-18 20:22:13'),(238,0,1,59,'PING监测',0,'Packet loss = 0%, RTA = 92.822ms',128,47,1,1,0,'2010-04-18 20:22:11',NULL,NULL,NULL,'2010-04-18 20:24:13','2010-04-18 20:24:13'),(239,0,1,59,'PING监测',1,'Packet loss = 25%, RTA = 92.820ms',128,47,1,1,0,'2010-04-18 20:37:11',NULL,NULL,NULL,'2010-04-18 20:38:13','2010-04-18 20:38:13'),(240,0,1,59,'PING监测',0,'Packet loss = 0%, RTA = 92.588ms',128,47,1,1,0,'2010-04-18 20:38:11',NULL,NULL,NULL,'2010-04-18 20:40:13','2010-04-18 20:40:13'),(241,0,1,59,'PING监测',1,'Packet loss = 25%, RTA = 92.828ms',128,47,1,1,0,'2010-04-18 20:43:11',NULL,NULL,NULL,'2010-04-18 20:44:13','2010-04-18 20:44:13'),(242,0,1,59,'PING监测',0,'Packet loss = 0%, RTA = 92.424ms',128,47,1,1,0,'2010-04-18 20:44:11',NULL,NULL,NULL,'2010-04-18 20:46:13','2010-04-18 20:46:13'),(243,0,1,59,'PING监测',1,'Packet loss = 50%, RTA = 92.443ms',128,47,1,1,0,'2010-04-18 20:54:11',NULL,NULL,NULL,'2010-04-18 20:56:13','2010-04-18 20:56:13'),(244,0,1,59,'PING监测',0,'Packet loss = 0%, RTA = 92.472ms',128,47,1,1,0,'2010-04-18 21:00:11',NULL,NULL,NULL,'2010-04-18 21:02:13','2010-04-18 21:02:13'),(245,0,1,59,'PING监测',1,'Packet loss = 25%, RTA = 92.566ms',128,47,1,1,0,'2010-04-18 21:15:11',NULL,NULL,NULL,'2010-04-18 21:16:13','2010-04-18 21:16:13'),(246,0,1,59,'PING监测',0,'Packet loss = 0%, RTA = 92.504ms',128,47,1,1,0,'2010-04-18 21:16:11',NULL,NULL,NULL,'2010-04-18 21:18:13','2010-04-18 21:18:13'),(247,0,28,68,'PING监测',1,'Packet loss = 25%, RTA = 115.431ms',165,54,1,33,0,'2010-04-18 21:47:17',NULL,NULL,NULL,'2010-04-18 21:48:13','2010-04-18 21:48:13'),(248,0,28,68,'PING监测',0,'Packet loss = 0%, RTA = 17.719ms',165,54,1,33,0,'2010-04-18 21:48:17',NULL,NULL,NULL,'2010-04-18 21:50:13','2010-04-18 21:50:13'),(249,0,1,59,'PING监测',1,'Packet loss = 25%, RTA = 92.581ms',128,47,1,1,0,'2010-04-18 21:51:11',NULL,NULL,NULL,'2010-04-18 21:52:13','2010-04-18 21:52:13'),(250,0,1,59,'PING监测',0,'Packet loss = 0%, RTA = 92.594ms',128,47,1,1,0,'2010-04-18 21:58:11',NULL,NULL,NULL,'2010-04-18 22:00:13','2010-04-18 22:00:13'),(251,0,1,59,'PING监测',1,'Packet loss = 25%, RTA = 92.841ms',128,47,1,1,0,'2010-04-18 22:08:11',NULL,NULL,NULL,'2010-04-18 22:10:13','2010-04-18 22:10:13'),(252,0,1,59,'PING监测',0,'Packet loss = 0%, RTA = 92.809ms',128,47,1,1,0,'2010-04-18 22:14:41',NULL,NULL,NULL,'2010-04-18 22:16:13','2010-04-18 22:16:13'),(253,0,1,59,'PING监测',1,'Packet loss = 25%, RTA = 92.660ms',128,47,1,1,0,'2010-04-18 22:29:41',NULL,NULL,NULL,'2010-04-18 22:30:13','2010-04-18 22:30:13'),(254,0,1,59,'PING监测',0,'Packet loss = 0%, RTA = 92.612ms',128,47,1,1,0,'2010-04-18 22:30:11',NULL,NULL,NULL,'2010-04-18 22:32:13','2010-04-18 22:32:13'),(255,0,1,59,'PING监测',1,'Packet loss = 25%, RTA = 92.606ms',128,47,1,1,0,'2010-04-18 22:45:41',NULL,NULL,NULL,'2010-04-18 22:46:13','2010-04-18 22:46:13'),(256,0,1,59,'PING监测',0,'Packet loss = 0%, RTA = 92.655ms',128,47,1,1,0,'2010-04-18 22:46:11',NULL,NULL,NULL,'2010-04-18 22:48:13','2010-04-18 22:48:13'),(257,0,28,69,'PING监测',1,'Packet loss = 25%, RTA = 14.727ms',163,53,1,33,0,'2010-04-18 22:53:28',NULL,NULL,NULL,'2010-04-18 22:54:13','2010-04-18 22:54:13'),(258,0,28,69,'PING监测',0,'Packet loss = 0%, RTA = 15.190ms',163,53,1,33,0,'2010-04-18 22:54:28',NULL,NULL,NULL,'2010-04-18 22:56:13','2010-04-18 22:56:13'),(259,0,1,31,'接口流量 - eth2',3,'snmp error.',71,20,1,1,0,'2010-04-19 04:09:18',NULL,NULL,NULL,'2010-04-19 04:10:13','2010-04-19 04:10:13'),(260,0,1,70,'Memory',3,'snmp failure!',60,20,1,1,0,'2010-04-19 04:09:18',NULL,NULL,NULL,'2010-04-19 04:10:13','2010-04-19 04:10:13'),(261,0,1,71,'磁盘IO - cciss/c0d0p3',3,'snmp error.',65,20,1,1,0,'2010-04-19 04:09:18',NULL,NULL,NULL,'2010-04-19 04:10:13','2010-04-19 04:10:13'),(262,0,1,70,'Memory',0,'memory usage: 95%',60,20,1,1,0,'2010-04-19 04:10:18',NULL,NULL,NULL,'2010-04-19 04:12:13','2010-04-19 04:12:13'),(263,0,1,71,'磁盘IO - cciss/c0d0p3',0,'cciss/c0d0p3: reads=0.00KB/s, writes=0.00KB/s',65,20,1,1,0,'2010-04-19 04:10:18',NULL,NULL,NULL,'2010-04-19 04:12:13','2010-04-19 04:12:13'),(265,0,1,31,'接口流量 - eth2',1,'eth2 is down.',71,20,1,1,0,'2010-04-19 04:14:18',NULL,NULL,NULL,'2010-04-19 04:16:13','2010-04-19 04:16:13'),(266,0,28,62,'内存监测 - SNMP',1,'memory usage: 99%',162,52,1,33,0,'2010-04-19 04:27:02',NULL,NULL,NULL,'2010-04-19 04:28:13','2010-04-19 04:28:13'),(267,0,28,62,'内存监测 - SNMP',0,'memory usage: 97%',162,52,1,33,0,'2010-04-19 04:38:02',NULL,NULL,NULL,'2010-04-19 04:38:13','2010-04-19 04:38:13'),(268,0,28,62,'内存监测 - SNMP',1,'memory usage: 98%',162,52,1,33,0,'2010-04-19 04:58:02',NULL,NULL,NULL,'2010-04-19 04:58:13','2010-04-19 04:58:13'),(269,0,28,62,'内存监测 - SNMP',0,'memory usage: 85%',162,52,1,33,0,'2010-04-19 05:09:02',NULL,NULL,NULL,'2010-04-19 05:10:13','2010-04-19 05:10:13'),(270,0,1,64,'内存监测',1,'memory usage: 98%',75,24,1,1,0,'2010-04-19 05:54:58',NULL,NULL,NULL,'2010-04-19 05:56:13','2010-04-19 05:56:13'),(271,0,28,62,'内存监测 - SNMP',1,'memory usage: 98%',162,52,1,33,0,'2010-04-19 05:59:02',NULL,NULL,NULL,'2010-04-19 06:00:13','2010-04-19 06:00:13'),(272,0,1,64,'内存监测',0,'memory usage: 97%',75,24,1,1,0,'2010-04-19 06:00:58',NULL,NULL,NULL,'2010-04-19 06:02:13','2010-04-19 06:02:13'),(273,0,28,62,'内存监测 - SNMP',0,'memory usage: 86%',162,52,1,33,0,'2010-04-19 06:10:02',NULL,NULL,NULL,'2010-04-19 06:10:13','2010-04-19 06:10:13'),(274,0,1,64,'内存监测',1,'memory usage: 98%',75,24,1,1,0,'2010-04-19 06:10:58',NULL,NULL,NULL,'2010-04-19 06:12:13','2010-04-19 06:12:13'),(275,0,1,64,'内存监测',0,'memory usage: 97%',75,24,1,1,0,'2010-04-19 06:38:28',NULL,NULL,NULL,'2010-04-19 06:40:13','2010-04-19 06:40:13'),(276,0,1,64,'内存监测',1,'memory usage: 98%',75,24,1,1,0,'2010-04-19 06:43:28',NULL,NULL,NULL,'2010-04-19 06:44:13','2010-04-19 06:44:13'),(277,0,28,62,'内存监测 - SNMP',1,'memory usage: 98%',162,52,1,33,0,'2010-04-19 07:00:02',NULL,NULL,NULL,'2010-04-19 07:00:13','2010-04-19 07:00:13'),(278,0,28,62,'内存监测 - SNMP',0,'memory usage: 86%',162,52,1,33,0,'2010-04-19 07:11:02',NULL,NULL,NULL,'2010-04-19 07:12:13','2010-04-19 07:12:13'),(279,0,28,62,'内存监测 - SNMP',1,'memory usage: 98%',162,52,1,33,0,'2010-04-19 07:31:02',NULL,NULL,NULL,'2010-04-19 07:32:13','2010-04-19 07:32:13'),(280,0,28,62,'内存监测 - SNMP',0,'memory usage: 97%',162,52,1,33,0,'2010-04-19 07:42:02',NULL,NULL,NULL,'2010-04-19 07:42:13','2010-04-19 07:42:13'),(281,0,28,20,'内存监测 - SNMP',0,'memory usage: 96%',157,56,1,33,0,'2010-04-19 08:21:07',NULL,NULL,NULL,'2010-04-19 08:22:13','2010-04-19 08:22:13'),(282,0,28,62,'内存监测 - SNMP',1,'memory usage: 98%',162,52,1,33,0,'2010-04-19 08:42:02',NULL,NULL,NULL,'2010-04-19 08:42:13','2010-04-19 08:42:13'),(283,0,28,62,'内存监测 - SNMP',0,'memory usage: 97%',162,52,1,33,0,'2010-04-19 08:53:02',NULL,NULL,NULL,'2010-04-19 08:54:13','2010-04-19 08:54:13'),(284,0,28,20,'内存监测 - SNMP',1,'memory usage: 98%',157,56,1,33,0,'2010-04-19 09:21:07',NULL,NULL,NULL,'2010-04-19 09:22:13','2010-04-19 09:22:13'),(285,0,28,20,'内存监测 - SNMP',0,'memory usage: 96%',157,56,1,33,0,'2010-04-19 09:42:07',NULL,NULL,NULL,'2010-04-19 09:42:13','2010-04-19 09:42:13'),(286,0,28,20,'内存监测 - SNMP',1,'memory usage: 98%',157,56,1,33,0,'2010-04-19 09:52:07',NULL,NULL,NULL,'2010-04-19 09:52:13','2010-04-19 09:52:13'),(287,0,28,20,'内存监测 - SNMP',0,'memory usage: 97%',157,56,1,33,0,'2010-04-19 11:43:07',NULL,NULL,NULL,'2010-04-19 11:44:13','2010-04-19 11:44:13'),(288,0,28,20,'内存监测 - SNMP',1,'memory usage: 98%',157,56,1,33,0,'2010-04-19 13:03:07',NULL,NULL,NULL,'2010-04-19 13:04:13','2010-04-19 13:04:13'),(289,0,28,20,'内存监测 - SNMP',0,'memory usage: 96%',157,56,1,33,0,'2010-04-19 14:44:07',NULL,NULL,NULL,'2010-04-19 14:44:13','2010-04-19 14:44:13'),(290,0,28,68,'PING监测',1,'Packet loss = 25%, RTA = 115.334ms',165,54,1,33,0,'2010-04-19 15:18:18',NULL,NULL,NULL,'2010-04-19 15:20:13','2010-04-19 15:20:13'),(291,0,28,68,'PING监测',0,'Packet loss = 0%, RTA = 14.835ms',165,54,1,33,0,'2010-04-19 15:30:18',NULL,NULL,NULL,'2010-04-19 15:32:13','2010-04-19 15:32:13');
/*!40000 ALTER TABLE `notifications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notify_rules`
--

DROP TABLE IF EXISTS `notify_rules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `notify_rules` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `tenant_id` int(11) DEFAULT NULL,
  `method` int(11) DEFAULT NULL COMMENT '0:web 1:mobile 2:email',
  `source_id` int(11) DEFAULT NULL,
  `source_type` int(3) DEFAULT NULL COMMENT '0:service 1:host 2:app 3:site',
  `alert_severity` int(2) DEFAULT NULL,
  `alert_period` int(11) DEFAULT NULL,
  `alert_createtime` datetime DEFAULT NULL,
  `max_notifies` int(11) DEFAULT '0',
  `creator` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=293 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notify_rules`
--

LOCK TABLES `notify_rules` WRITE;
/*!40000 ALTER TABLE `notify_rules` DISABLE KEYS */;
INSERT INTO `notify_rules` VALUES (86,'web_service_ok',1,1,0,NULL,0,0,NULL,NULL,NULL,NULL,'2010-04-02 10:31:58','2010-04-02 10:31:58'),(87,'web_service_warning',1,1,0,NULL,0,1,NULL,NULL,NULL,NULL,'2010-04-02 10:31:58','2010-04-02 10:31:58'),(88,'web_service_critical',1,1,0,NULL,0,2,NULL,NULL,NULL,NULL,'2010-04-02 10:31:58','2010-04-02 10:31:58'),(89,'web_service_unknown',1,1,0,NULL,0,3,NULL,NULL,NULL,NULL,'2010-04-02 10:31:58','2010-04-02 10:31:58'),(90,'web_host_ok',1,1,0,NULL,1,0,NULL,NULL,NULL,NULL,'2010-04-02 10:31:58','2010-04-02 10:31:58'),(91,'web_host_warning',1,1,0,NULL,1,1,NULL,NULL,NULL,NULL,'2010-04-02 10:31:58','2010-04-02 10:31:58'),(92,'web_host_critical',1,1,0,NULL,1,2,NULL,NULL,NULL,NULL,'2010-04-02 10:31:58','2010-04-02 10:31:58'),(93,'web_host_unknown',1,1,0,NULL,1,3,NULL,NULL,NULL,NULL,'2010-04-02 10:31:58','2010-04-02 10:31:58'),(94,'web_app_ok',1,1,0,NULL,2,0,NULL,NULL,NULL,NULL,'2010-04-02 10:31:58','2010-04-02 10:31:58'),(95,'web_app_warning',1,1,0,NULL,2,1,NULL,NULL,NULL,NULL,'2010-04-02 10:31:58','2010-04-02 10:31:58'),(96,'web_app_critical',1,1,0,NULL,2,2,NULL,NULL,NULL,NULL,'2010-04-02 10:31:58','2010-04-02 10:31:58'),(97,'web_app_unknown',1,1,0,NULL,2,3,NULL,NULL,NULL,NULL,'2010-04-02 10:31:58','2010-04-02 10:31:58'),(98,'web_site_ok',1,1,0,NULL,3,0,NULL,NULL,NULL,NULL,'2010-04-02 10:31:58','2010-04-02 10:31:58'),(99,'web_site_warning',1,1,0,NULL,3,1,NULL,NULL,NULL,NULL,'2010-04-02 10:31:58','2010-04-02 10:31:58'),(100,'web_site_critical',1,1,0,NULL,3,2,NULL,NULL,NULL,NULL,'2010-04-02 10:31:58','2010-04-02 10:31:58'),(101,'web_site_unknown',1,1,0,NULL,3,3,NULL,NULL,NULL,NULL,'2010-04-02 10:31:58','2010-04-02 10:31:58'),(110,'web_service_ok',25,30,0,NULL,0,0,NULL,NULL,NULL,NULL,'2010-04-13 15:42:30','2010-04-13 15:42:30'),(111,'web_service_warning',25,30,0,NULL,0,1,NULL,NULL,NULL,NULL,'2010-04-13 15:42:30','2010-04-13 15:42:30'),(112,'web_service_critical',25,30,0,NULL,0,2,NULL,NULL,NULL,NULL,'2010-04-13 15:42:30','2010-04-13 15:42:30'),(113,'web_service_unknown',25,30,0,NULL,0,3,NULL,NULL,NULL,NULL,'2010-04-13 15:42:30','2010-04-13 15:42:30'),(114,'web_host_ok',25,30,0,NULL,1,0,NULL,NULL,NULL,NULL,'2010-04-13 15:42:30','2010-04-13 15:42:30'),(115,'web_host_warning',25,30,0,NULL,1,1,NULL,NULL,NULL,NULL,'2010-04-13 15:42:30','2010-04-13 15:42:30'),(116,'web_host_critical',25,30,0,NULL,1,2,NULL,NULL,NULL,NULL,'2010-04-13 15:42:30','2010-04-13 15:42:30'),(117,'web_host_unknown',25,30,0,NULL,1,3,NULL,NULL,NULL,NULL,'2010-04-13 15:42:30','2010-04-13 15:42:30'),(118,'web_app_ok',25,30,0,NULL,2,0,NULL,NULL,NULL,NULL,'2010-04-13 15:42:30','2010-04-13 15:42:30'),(119,'web_app_warning',25,30,0,NULL,2,1,NULL,NULL,NULL,NULL,'2010-04-13 15:42:30','2010-04-13 15:42:30'),(120,'web_app_critical',25,30,0,NULL,2,2,NULL,NULL,NULL,NULL,'2010-04-13 15:42:30','2010-04-13 15:42:30'),(121,'web_app_unknown',25,30,0,NULL,2,3,NULL,NULL,NULL,NULL,'2010-04-13 15:42:30','2010-04-13 15:42:30'),(122,'web_site_ok',25,30,0,NULL,3,0,NULL,NULL,NULL,NULL,'2010-04-13 15:42:30','2010-04-13 15:42:30'),(123,'web_site_warning',25,30,0,NULL,3,1,NULL,NULL,NULL,NULL,'2010-04-13 15:42:30','2010-04-13 15:42:30'),(124,'web_site_critical',25,30,0,NULL,3,2,NULL,NULL,NULL,NULL,'2010-04-13 15:42:30','2010-04-13 15:42:30'),(125,'web_site_unknown',25,30,0,NULL,3,3,NULL,NULL,NULL,NULL,'2010-04-13 15:42:30','2010-04-13 15:42:30'),(126,'email_service_ok',25,30,1,NULL,0,0,NULL,NULL,NULL,NULL,'2010-04-13 15:42:30','2010-04-13 15:42:30'),(127,'email_service_critical',25,30,1,NULL,0,2,NULL,NULL,NULL,NULL,'2010-04-13 15:42:30','2010-04-13 15:42:30'),(128,'email_host_ok',25,30,1,NULL,1,0,NULL,NULL,NULL,NULL,'2010-04-13 15:42:30','2010-04-13 15:42:30'),(129,'email_host_critical',25,30,1,NULL,1,2,NULL,NULL,NULL,NULL,'2010-04-13 15:42:30','2010-04-13 15:42:30'),(130,'email_app_ok',25,30,1,NULL,2,0,NULL,NULL,NULL,NULL,'2010-04-13 15:42:30','2010-04-13 15:42:30'),(131,'email_app_critical',25,30,1,NULL,2,2,NULL,NULL,NULL,NULL,'2010-04-13 15:42:30','2010-04-13 15:42:30'),(132,'email_site_ok',25,30,1,NULL,3,0,NULL,NULL,NULL,NULL,'2010-04-13 15:42:30','2010-04-13 15:42:30'),(133,'email_site_critical',25,30,1,NULL,3,2,NULL,NULL,NULL,NULL,'2010-04-13 15:42:30','2010-04-13 15:42:30'),(134,'web_service_ok',26,31,0,NULL,0,0,NULL,NULL,NULL,NULL,'2010-04-13 16:09:41','2010-04-13 16:09:41'),(135,'web_service_warning',26,31,0,NULL,0,1,NULL,NULL,NULL,NULL,'2010-04-13 16:09:41','2010-04-13 16:09:41'),(136,'web_service_critical',26,31,0,NULL,0,2,NULL,NULL,NULL,NULL,'2010-04-13 16:09:41','2010-04-13 16:09:41'),(137,'web_service_unknown',26,31,0,NULL,0,3,NULL,NULL,NULL,NULL,'2010-04-13 16:09:41','2010-04-13 16:09:41'),(138,'web_host_ok',26,31,0,NULL,1,0,NULL,NULL,NULL,NULL,'2010-04-13 16:09:41','2010-04-13 16:09:41'),(139,'web_host_warning',26,31,0,NULL,1,1,NULL,NULL,NULL,NULL,'2010-04-13 16:09:41','2010-04-13 16:09:41'),(140,'web_host_critical',26,31,0,NULL,1,2,NULL,NULL,NULL,NULL,'2010-04-13 16:09:41','2010-04-13 16:09:41'),(141,'web_host_unknown',26,31,0,NULL,1,3,NULL,NULL,NULL,NULL,'2010-04-13 16:09:41','2010-04-13 16:09:41'),(142,'web_app_ok',26,31,0,NULL,2,0,NULL,NULL,NULL,NULL,'2010-04-13 16:09:41','2010-04-13 16:09:41'),(143,'web_app_warning',26,31,0,NULL,2,1,NULL,NULL,NULL,NULL,'2010-04-13 16:09:41','2010-04-13 16:09:41'),(144,'web_app_critical',26,31,0,NULL,2,2,NULL,NULL,NULL,NULL,'2010-04-13 16:09:41','2010-04-13 16:09:41'),(145,'web_app_unknown',26,31,0,NULL,2,3,NULL,NULL,NULL,NULL,'2010-04-13 16:09:41','2010-04-13 16:09:41'),(146,'web_site_ok',26,31,0,NULL,3,0,NULL,NULL,NULL,NULL,'2010-04-13 16:09:41','2010-04-13 16:09:41'),(147,'web_site_warning',26,31,0,NULL,3,1,NULL,NULL,NULL,NULL,'2010-04-13 16:09:41','2010-04-13 16:09:41'),(148,'web_site_critical',26,31,0,NULL,3,2,NULL,NULL,NULL,NULL,'2010-04-13 16:09:41','2010-04-13 16:09:41'),(149,'web_site_unknown',26,31,0,NULL,3,3,NULL,NULL,NULL,NULL,'2010-04-13 16:09:41','2010-04-13 16:09:41'),(150,'email_service_ok',26,31,1,NULL,0,0,NULL,NULL,NULL,NULL,'2010-04-13 16:09:41','2010-04-13 16:09:41'),(151,'email_service_critical',26,31,1,NULL,0,2,NULL,NULL,NULL,NULL,'2010-04-13 16:09:41','2010-04-13 16:09:41'),(152,'email_host_ok',26,31,1,NULL,1,0,NULL,NULL,NULL,NULL,'2010-04-13 16:09:41','2010-04-13 16:09:41'),(153,'email_host_critical',26,31,1,NULL,1,2,NULL,NULL,NULL,NULL,'2010-04-13 16:09:41','2010-04-13 16:09:41'),(154,'email_app_ok',26,31,1,NULL,2,0,NULL,NULL,NULL,NULL,'2010-04-13 16:09:41','2010-04-13 16:09:41'),(155,'email_app_critical',26,31,1,NULL,2,2,NULL,NULL,NULL,NULL,'2010-04-13 16:09:41','2010-04-13 16:09:41'),(156,'email_site_ok',26,31,1,NULL,3,0,NULL,NULL,NULL,NULL,'2010-04-13 16:09:41','2010-04-13 16:09:41'),(157,'email_site_critical',26,31,1,NULL,3,2,NULL,NULL,NULL,NULL,'2010-04-13 16:09:41','2010-04-13 16:09:41'),(158,'web_service_ok',27,32,0,NULL,0,0,NULL,NULL,NULL,NULL,'2010-04-13 16:13:29','2010-04-13 16:13:29'),(159,'web_service_warning',27,32,0,NULL,0,1,NULL,NULL,NULL,NULL,'2010-04-13 16:13:29','2010-04-13 16:13:29'),(160,'web_service_critical',27,32,0,NULL,0,2,NULL,NULL,NULL,NULL,'2010-04-13 16:13:29','2010-04-13 16:13:29'),(161,'web_service_unknown',27,32,0,NULL,0,3,NULL,NULL,NULL,NULL,'2010-04-13 16:13:29','2010-04-13 16:13:29'),(162,'web_host_ok',27,32,0,NULL,1,0,NULL,NULL,NULL,NULL,'2010-04-13 16:13:29','2010-04-13 16:13:29'),(163,'web_host_warning',27,32,0,NULL,1,1,NULL,NULL,NULL,NULL,'2010-04-13 16:13:29','2010-04-13 16:13:29'),(164,'web_host_critical',27,32,0,NULL,1,2,NULL,NULL,NULL,NULL,'2010-04-13 16:13:29','2010-04-13 16:13:29'),(165,'web_host_unknown',27,32,0,NULL,1,3,NULL,NULL,NULL,NULL,'2010-04-13 16:13:29','2010-04-13 16:13:29'),(166,'web_app_ok',27,32,0,NULL,2,0,NULL,NULL,NULL,NULL,'2010-04-13 16:13:29','2010-04-13 16:13:29'),(167,'web_app_warning',27,32,0,NULL,2,1,NULL,NULL,NULL,NULL,'2010-04-13 16:13:29','2010-04-13 16:13:29'),(168,'web_app_critical',27,32,0,NULL,2,2,NULL,NULL,NULL,NULL,'2010-04-13 16:13:29','2010-04-13 16:13:29'),(169,'web_app_unknown',27,32,0,NULL,2,3,NULL,NULL,NULL,NULL,'2010-04-13 16:13:29','2010-04-13 16:13:29'),(170,'web_site_ok',27,32,0,NULL,3,0,NULL,NULL,NULL,NULL,'2010-04-13 16:13:29','2010-04-13 16:13:29'),(171,'web_site_warning',27,32,0,NULL,3,1,NULL,NULL,NULL,NULL,'2010-04-13 16:13:29','2010-04-13 16:13:29'),(172,'web_site_critical',27,32,0,NULL,3,2,NULL,NULL,NULL,NULL,'2010-04-13 16:13:29','2010-04-13 16:13:29'),(173,'web_site_unknown',27,32,0,NULL,3,3,NULL,NULL,NULL,NULL,'2010-04-13 16:13:29','2010-04-13 16:13:29'),(174,'email_service_ok',27,32,1,NULL,0,0,NULL,NULL,NULL,NULL,'2010-04-13 16:13:29','2010-04-13 16:13:29'),(175,'email_service_critical',27,32,1,NULL,0,2,NULL,NULL,NULL,NULL,'2010-04-13 16:13:29','2010-04-13 16:13:29'),(176,'email_host_ok',27,32,1,NULL,1,0,NULL,NULL,NULL,NULL,'2010-04-13 16:13:29','2010-04-13 16:13:29'),(177,'email_host_critical',27,32,1,NULL,1,2,NULL,NULL,NULL,NULL,'2010-04-13 16:13:29','2010-04-13 16:13:29'),(178,'email_app_ok',27,32,1,NULL,2,0,NULL,NULL,NULL,NULL,'2010-04-13 16:13:29','2010-04-13 16:13:29'),(179,'email_app_critical',27,32,1,NULL,2,2,NULL,NULL,NULL,NULL,'2010-04-13 16:13:29','2010-04-13 16:13:29'),(180,'email_site_ok',27,32,1,NULL,3,0,NULL,NULL,NULL,NULL,'2010-04-13 16:13:29','2010-04-13 16:13:29'),(181,'email_site_critical',27,32,1,NULL,3,2,NULL,NULL,NULL,NULL,'2010-04-13 16:13:29','2010-04-13 16:13:29'),(182,'web_service_ok',28,33,0,NULL,0,0,NULL,NULL,NULL,NULL,'2010-04-13 16:14:25','2010-04-13 16:14:25'),(183,'web_service_warning',28,33,0,NULL,0,1,NULL,NULL,NULL,NULL,'2010-04-13 16:14:25','2010-04-13 16:14:25'),(184,'web_service_critical',28,33,0,NULL,0,2,NULL,NULL,NULL,NULL,'2010-04-13 16:14:25','2010-04-13 16:14:25'),(185,'web_service_unknown',28,33,0,NULL,0,3,NULL,NULL,NULL,NULL,'2010-04-13 16:14:25','2010-04-13 16:14:25'),(186,'web_host_ok',28,33,0,NULL,1,0,NULL,NULL,NULL,NULL,'2010-04-13 16:14:25','2010-04-13 16:14:25'),(187,'web_host_warning',28,33,0,NULL,1,1,NULL,NULL,NULL,NULL,'2010-04-13 16:14:25','2010-04-13 16:14:25'),(188,'web_host_critical',28,33,0,NULL,1,2,NULL,NULL,NULL,NULL,'2010-04-13 16:14:25','2010-04-13 16:14:25'),(189,'web_host_unknown',28,33,0,NULL,1,3,NULL,NULL,NULL,NULL,'2010-04-13 16:14:25','2010-04-13 16:14:25'),(190,'web_app_ok',28,33,0,NULL,2,0,NULL,NULL,NULL,NULL,'2010-04-13 16:14:25','2010-04-13 16:14:25'),(191,'web_app_warning',28,33,0,NULL,2,1,NULL,NULL,NULL,NULL,'2010-04-13 16:14:25','2010-04-13 16:14:25'),(192,'web_app_critical',28,33,0,NULL,2,2,NULL,NULL,NULL,NULL,'2010-04-13 16:14:25','2010-04-13 16:14:25'),(193,'web_app_unknown',28,33,0,NULL,2,3,NULL,NULL,NULL,NULL,'2010-04-13 16:14:25','2010-04-13 16:14:25'),(194,'web_site_ok',28,33,0,NULL,3,0,NULL,NULL,NULL,NULL,'2010-04-13 16:14:25','2010-04-13 16:14:25'),(195,'web_site_warning',28,33,0,NULL,3,1,NULL,NULL,NULL,NULL,'2010-04-13 16:14:25','2010-04-13 16:14:25'),(196,'web_site_critical',28,33,0,NULL,3,2,NULL,NULL,NULL,NULL,'2010-04-13 16:14:25','2010-04-13 16:14:25'),(197,'web_site_unknown',28,33,0,NULL,3,3,NULL,NULL,NULL,NULL,'2010-04-13 16:14:25','2010-04-13 16:14:25'),(222,'web_service_ok',24,29,0,NULL,0,0,NULL,NULL,NULL,NULL,'2010-04-14 11:02:24','2010-04-14 11:02:24'),(223,'web_service_warning',24,29,0,NULL,0,1,NULL,NULL,NULL,NULL,'2010-04-14 11:02:24','2010-04-14 11:02:24'),(224,'web_service_critical',24,29,0,NULL,0,2,NULL,NULL,NULL,NULL,'2010-04-14 11:02:24','2010-04-14 11:02:24'),(225,'web_service_unknown',24,29,0,NULL,0,3,NULL,NULL,NULL,NULL,'2010-04-14 11:02:24','2010-04-14 11:02:24'),(226,'web_host_ok',24,29,0,NULL,1,0,NULL,NULL,NULL,NULL,'2010-04-14 11:02:24','2010-04-14 11:02:24'),(227,'web_host_warning',24,29,0,NULL,1,1,NULL,NULL,NULL,NULL,'2010-04-14 11:02:24','2010-04-14 11:02:24'),(228,'web_host_critical',24,29,0,NULL,1,2,NULL,NULL,NULL,NULL,'2010-04-14 11:02:24','2010-04-14 11:02:24'),(229,'web_host_unknown',24,29,0,NULL,1,3,NULL,NULL,NULL,NULL,'2010-04-14 11:02:24','2010-04-14 11:02:24'),(230,'web_app_ok',24,29,0,NULL,2,0,NULL,NULL,NULL,NULL,'2010-04-14 11:02:24','2010-04-14 11:02:24'),(231,'web_app_warning',24,29,0,NULL,2,1,NULL,NULL,NULL,NULL,'2010-04-14 11:02:24','2010-04-14 11:02:24'),(232,'web_app_critical',24,29,0,NULL,2,2,NULL,NULL,NULL,NULL,'2010-04-14 11:02:24','2010-04-14 11:02:24'),(233,'web_app_unknown',24,29,0,NULL,2,3,NULL,NULL,NULL,NULL,'2010-04-14 11:02:24','2010-04-14 11:02:24'),(234,'web_site_ok',24,29,0,NULL,3,0,NULL,NULL,NULL,NULL,'2010-04-14 11:02:24','2010-04-14 11:02:24'),(235,'web_site_warning',24,29,0,NULL,3,1,NULL,NULL,NULL,NULL,'2010-04-14 11:02:24','2010-04-14 11:02:24'),(236,'web_site_critical',24,29,0,NULL,3,2,NULL,NULL,NULL,NULL,'2010-04-14 11:02:24','2010-04-14 11:02:24'),(237,'web_site_unknown',24,29,0,NULL,3,3,NULL,NULL,NULL,NULL,'2010-04-14 11:02:24','2010-04-14 11:02:24'),(246,'email_service_ok',24,29,1,NULL,0,0,NULL,NULL,NULL,NULL,'2010-04-14 11:03:59','2010-04-14 11:03:59'),(247,'email_service_warning',24,29,1,NULL,0,1,NULL,NULL,NULL,NULL,'2010-04-14 11:03:59','2010-04-14 11:03:59'),(248,'email_service_critical',24,29,1,NULL,0,2,NULL,NULL,NULL,NULL,'2010-04-14 11:03:59','2010-04-14 11:03:59'),(249,'email_service_unknown',24,29,1,NULL,0,3,NULL,NULL,NULL,NULL,'2010-04-14 11:03:59','2010-04-14 11:03:59'),(250,'email_host_ok',24,29,1,NULL,1,0,NULL,NULL,NULL,NULL,'2010-04-14 11:03:59','2010-04-14 11:03:59'),(251,'email_host_warning',24,29,1,NULL,1,1,NULL,NULL,NULL,NULL,'2010-04-14 11:03:59','2010-04-14 11:03:59'),(252,'email_host_critical',24,29,1,NULL,1,2,NULL,NULL,NULL,NULL,'2010-04-14 11:03:59','2010-04-14 11:03:59'),(253,'email_host_unknown',24,29,1,NULL,1,3,NULL,NULL,NULL,NULL,'2010-04-14 11:03:59','2010-04-14 11:03:59'),(254,'email_app_ok',24,29,1,NULL,2,0,NULL,NULL,NULL,NULL,'2010-04-14 11:03:59','2010-04-14 11:03:59'),(255,'email_app_warning',24,29,1,NULL,2,1,NULL,NULL,NULL,NULL,'2010-04-14 11:03:59','2010-04-14 11:03:59'),(256,'email_app_critical',24,29,1,NULL,2,2,NULL,NULL,NULL,NULL,'2010-04-14 11:03:59','2010-04-14 11:03:59'),(257,'email_app_unknown',24,29,1,NULL,2,3,NULL,NULL,NULL,NULL,'2010-04-14 11:03:59','2010-04-14 11:03:59'),(258,'email_site_ok',24,29,1,NULL,3,0,NULL,NULL,NULL,NULL,'2010-04-14 11:03:59','2010-04-14 11:03:59'),(259,'email_site_warning',24,29,1,NULL,3,1,NULL,NULL,NULL,NULL,'2010-04-14 11:03:59','2010-04-14 11:03:59'),(260,'email_site_critical',24,29,1,NULL,3,2,NULL,NULL,NULL,NULL,'2010-04-14 11:03:59','2010-04-14 11:03:59'),(261,'email_site_unknown',24,29,1,NULL,3,3,NULL,NULL,NULL,NULL,'2010-04-14 11:03:59','2010-04-14 11:03:59'),(262,'web_service_ok',8,10,0,NULL,0,0,NULL,NULL,NULL,NULL,'2010-04-14 11:23:15','2010-04-14 11:23:15'),(263,'web_service_warning',8,10,0,NULL,0,1,NULL,NULL,NULL,NULL,'2010-04-14 11:23:15','2010-04-14 11:23:15'),(264,'web_service_critical',8,10,0,NULL,0,2,NULL,NULL,NULL,NULL,'2010-04-14 11:23:15','2010-04-14 11:23:15'),(265,'web_service_unknown',8,10,0,NULL,0,3,NULL,NULL,NULL,NULL,'2010-04-14 11:23:15','2010-04-14 11:23:15'),(266,'web_host_ok',8,10,0,NULL,1,0,NULL,NULL,NULL,NULL,'2010-04-14 11:23:15','2010-04-14 11:23:15'),(267,'web_host_warning',8,10,0,NULL,1,1,NULL,NULL,NULL,NULL,'2010-04-14 11:23:15','2010-04-14 11:23:15'),(268,'web_host_critical',8,10,0,NULL,1,2,NULL,NULL,NULL,NULL,'2010-04-14 11:23:15','2010-04-14 11:23:15'),(269,'web_host_unknown',8,10,0,NULL,1,3,NULL,NULL,NULL,NULL,'2010-04-14 11:23:15','2010-04-14 11:23:15'),(270,'web_app_ok',8,10,0,NULL,2,0,NULL,NULL,NULL,NULL,'2010-04-14 11:23:15','2010-04-14 11:23:15'),(271,'web_app_warning',8,10,0,NULL,2,1,NULL,NULL,NULL,NULL,'2010-04-14 11:23:15','2010-04-14 11:23:15'),(272,'web_app_critical',8,10,0,NULL,2,2,NULL,NULL,NULL,NULL,'2010-04-14 11:23:15','2010-04-14 11:23:15'),(273,'web_app_unknown',8,10,0,NULL,2,3,NULL,NULL,NULL,NULL,'2010-04-14 11:23:15','2010-04-14 11:23:15'),(274,'web_site_ok',8,10,0,NULL,3,0,NULL,NULL,NULL,NULL,'2010-04-14 11:23:15','2010-04-14 11:23:15'),(275,'web_site_warning',8,10,0,NULL,3,1,NULL,NULL,NULL,NULL,'2010-04-14 11:23:15','2010-04-14 11:23:15'),(276,'web_site_critical',8,10,0,NULL,3,2,NULL,NULL,NULL,NULL,'2010-04-14 11:23:15','2010-04-14 11:23:15'),(277,'web_site_unknown',8,10,0,NULL,3,3,NULL,NULL,NULL,NULL,'2010-04-14 11:23:15','2010-04-14 11:23:15'),(278,'email_service_ok',8,10,1,NULL,0,0,NULL,NULL,NULL,NULL,'2010-04-14 11:23:15','2010-04-14 11:23:15'),(279,'email_service_critical',8,10,1,NULL,0,2,NULL,NULL,NULL,NULL,'2010-04-14 11:23:15','2010-04-14 11:23:15'),(280,'email_host_ok',8,10,1,NULL,1,0,NULL,NULL,NULL,NULL,'2010-04-14 11:23:15','2010-04-14 11:23:15'),(281,'email_host_critical',8,10,1,NULL,1,2,NULL,NULL,NULL,NULL,'2010-04-14 11:23:15','2010-04-14 11:23:15'),(282,'email_app_ok',8,10,1,NULL,2,0,NULL,NULL,NULL,NULL,'2010-04-14 11:23:15','2010-04-14 11:23:15'),(283,'email_app_critical',8,10,1,NULL,2,2,NULL,NULL,NULL,NULL,'2010-04-14 11:23:15','2010-04-14 11:23:15'),(284,'email_site_ok',8,10,1,NULL,3,0,NULL,NULL,NULL,NULL,'2010-04-14 11:23:15','2010-04-14 11:23:15'),(285,'email_site_critical',8,10,1,NULL,3,2,NULL,NULL,NULL,NULL,'2010-04-14 11:23:15','2010-04-14 11:23:15'),(286,'email_service_critical',1,1,1,NULL,0,2,NULL,NULL,NULL,NULL,'2010-04-17 22:30:23','2010-04-17 22:30:23'),(287,'email_host_ok',1,1,1,NULL,1,0,NULL,NULL,NULL,NULL,'2010-04-17 22:30:23','2010-04-17 22:30:23'),(288,'email_host_critical',1,1,1,NULL,1,2,NULL,NULL,NULL,NULL,'2010-04-17 22:30:23','2010-04-17 22:30:23'),(289,'email_app_ok',1,1,1,NULL,2,0,NULL,NULL,NULL,NULL,'2010-04-17 22:30:23','2010-04-17 22:30:23'),(290,'email_app_critical',1,1,1,NULL,2,2,NULL,NULL,NULL,NULL,'2010-04-17 22:30:23','2010-04-17 22:30:23'),(291,'email_site_ok',1,1,1,NULL,3,0,NULL,NULL,NULL,NULL,'2010-04-17 22:30:23','2010-04-17 22:30:23'),(292,'email_site_critical',1,1,1,NULL,3,2,NULL,NULL,NULL,NULL,'2010-04-17 22:30:23','2010-04-17 22:30:23');
/*!40000 ALTER TABLE `notify_rules` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `preferences`
--

DROP TABLE IF EXISTS `preferences`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `preferences` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `owner_id` int(11) NOT NULL,
  `owner_type` varchar(255) NOT NULL,
  `group_id` int(11) DEFAULT NULL,
  `group_type` varchar(255) DEFAULT NULL,
  `value` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_preferences_on_owner_and_name_and_preference` (`owner_id`,`owner_type`,`name`,`group_id`,`group_type`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `preferences`
--

LOCK TABLES `preferences` WRITE;
/*!40000 ALTER TABLE `preferences` DISABLE KEYS */;
INSERT INTO `preferences` VALUES (1,'host_support_remote',1,'User',NULL,NULL,'1','2010-02-25 17:29:27','2010-02-26 16:29:58'),(2,'host_support_snmp',1,'User',NULL,NULL,'1','2010-02-25 17:29:27','2010-02-26 16:29:58');
/*!40000 ALTER TABLE `preferences` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roster_version`
--

DROP TABLE IF EXISTS `roster_version`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `roster_version` (
  `username` varchar(250) NOT NULL,
  `version` text NOT NULL,
  PRIMARY KEY (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roster_version`
--

LOCK TABLES `roster_version` WRITE;
/*!40000 ALTER TABLE `roster_version` DISABLE KEYS */;
/*!40000 ALTER TABLE `roster_version` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rostergroups`
--

DROP TABLE IF EXISTS `rostergroups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rostergroups` (
  `username` varchar(250) NOT NULL,
  `jid` varchar(250) NOT NULL,
  `grp` text NOT NULL,
  KEY `pk_rosterg_user_jid` (`username`(75),`jid`(75))
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rostergroups`
--

LOCK TABLES `rostergroups` WRITE;
/*!40000 ALTER TABLE `rostergroups` DISABLE KEYS */;
INSERT INTO `rostergroups` VALUES ('wifioss.hunan','admin@monit.cn','好友'),('wifioss.jiangxi','admin@monit.cn','好友'),('wifioss.ningxia','admin@monit.cn','好友'),('wifioss.yunnan','bot@bot.monit.cn','好友'),('admin','bot@bot.monit.cn','WLAN'),('wifioss.yunnan','root@monit.cn','好友'),('root','bot@bot.monit.cn','好友');
/*!40000 ALTER TABLE `rostergroups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rosterusers`
--

DROP TABLE IF EXISTS `rosterusers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rosterusers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(250) NOT NULL,
  `jid` varchar(250) NOT NULL,
  `nick` text NOT NULL,
  `subscription` char(1) NOT NULL,
  `ask` char(1) NOT NULL,
  `askmessage` text NOT NULL,
  `server` char(1) NOT NULL,
  `subscribe` text NOT NULL,
  `type` text,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `i_rosteru_user_jid` (`username`(75),`jid`(75)),
  KEY `i_rosteru_username` (`username`),
  KEY `i_rosteru_jid` (`jid`)
) ENGINE=InnoDB AUTO_INCREMENT=47 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rosterusers`
--

LOCK TABLES `rosterusers` WRITE;
/*!40000 ALTER TABLE `rosterusers` DISABLE KEYS */;
INSERT INTO `rosterusers` VALUES (1,'wifioss.hunan','admin@monit.cn','','B','N','','N','','item','2010-02-18 14:06:43'),(2,'wifioss.jiangxi','admin@monit.cn','','B','N','','N','','item','2010-02-18 14:07:03'),(3,'wifioss.ningxia','admin@monit.cn','','B','N','','N','','item','2010-02-18 14:07:03'),(5,'admin','bot@bot.monit.cn','monit bot','B','N','','N','','item','2010-02-20 03:00:28'),(7,'root','bot@bot.monit.cn','Monit','B','N','','N','','item','2010-02-20 06:30:47'),(9,'','bot@bot.monit.cn','','B','N','','N','',NULL,'2010-03-15 03:08:17'),(10,'test2','bot@bot.monit.cn','','B','N','','N','',NULL,'2010-03-15 03:30:26'),(13,'chenjx.opengoss','bot@bot.monit.cn','','B','N','','N','',NULL,'2010-03-18 08:07:40'),(14,'chenjx','bot@bot.monit.cn','','B','N','','N','',NULL,'2010-03-19 03:43:04'),(15,'agent11.chenjx','cloud.monit.cn','','B','N','','N','',NULL,'2010-03-19 05:08:42'),(16,'agent11.chenjx','chenjx@monit.cn','','B','N','','N','',NULL,'2010-03-19 05:08:42'),(17,'vvsvv','bot@bot.monit.cn','','B','N','','N','',NULL,'2010-03-23 01:22:52'),(18,'zhangwh','bot@bot.monit.cn','','B','N','','N','',NULL,'2010-03-23 04:06:42'),(19,'agent12.root','cloud.monit.cn','','B','N','','N','',NULL,'2010-04-09 10:26:11'),(20,'agent12.root','root@monit.cn','','B','N','','N','',NULL,'2010-04-09 10:26:11'),(21,'root','agent12.root@agent.monit.cn','','B','N','','N','',NULL,'2010-04-09 10:26:11'),(22,'solo','bot@bot.monit.cn','','B','N','','N','',NULL,'2010-04-13 07:42:30'),(26,'yufw','bot@bot.monit.cn','','B','N','','N','',NULL,'2010-04-13 08:09:41'),(27,'sx_monit','bot@bot.monit.cn','','B','N','','N','',NULL,'2010-04-13 08:13:29'),(28,'jx_wlan','bot@bot.monit.cn','','B','N','','N','',NULL,'2010-04-13 08:14:25'),(29,'agent14.yufw','s@cloud.monit.cn','','B','N','','N','',NULL,'2010-04-13 08:17:33'),(30,'agent14.yufw','yufw@monit.cn','','B','N','','N','',NULL,'2010-04-13 08:17:33'),(31,'yufw','agent14.yufw@agent.monit.cn','','B','N','','N','',NULL,'2010-04-13 08:17:33'),(32,'agent15.yufw','s@cloud.monit.cn','','B','N','','N','',NULL,'2010-04-13 08:58:00'),(33,'agent15.yufw','yufw@monit.cn','','B','N','','N','',NULL,'2010-04-13 08:58:00'),(34,'yufw','agent15.yufw@agent.monit.cn','','B','N','','N','',NULL,'2010-04-13 08:58:00'),(35,'agent16.root','s@cloud.monit.cn','','B','N','','N','',NULL,'2010-04-14 02:32:00'),(36,'agent16.root','root@monit.cn','','B','N','','N','',NULL,'2010-04-14 02:32:00'),(37,'root','agent16.root@agent.monit.cn','','B','N','','N','',NULL,'2010-04-14 02:32:00'),(41,'agent18.root','s@cloud.monit.cn','','B','N','','N','',NULL,'2010-04-14 15:47:05'),(42,'agent18.root','root@monit.cn','','B','N','','N','',NULL,'2010-04-14 15:47:05'),(43,'root','agent18.root@agent.monit.cn','','B','N','','N','',NULL,'2010-04-14 15:47:05');
/*!40000 ALTER TABLE `rosterusers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `service_params`
--

DROP TABLE IF EXISTS `service_params`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `service_params` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type_id` int(2) DEFAULT NULL COMMENT 'belong to service_types',
  `name` varchar(100) DEFAULT NULL,
  `alias` varchar(100) DEFAULT NULL,
  `default_value` varchar(100) DEFAULT NULL,
  `param_type` int(2) DEFAULT NULL COMMENT '1:value 2:variable',
  `unit` varchar(20) DEFAULT NULL,
  `desc` varchar(100) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=76 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `service_params`
--

LOCK TABLES `service_params` WRITE;
/*!40000 ALTER TABLE `service_params` DISABLE KEYS */;
INSERT INTO `service_params` VALUES (7,1,'host','主机','${host.addr}',2,'string',NULL,'2010-02-02 02:11:13','2010-02-02 02:11:13'),(8,2,'host','主机','${host.addr}',2,'string',NULL,'2010-02-02 02:12:09','2010-02-02 02:12:09'),(9,2,'port','HTTP端口','80',1,'int',NULL,'2010-02-02 02:12:24','2010-02-02 02:12:24'),(10,3,'path','磁盘路径','/',1,'string',NULL,'2010-02-02 02:12:54','2010-02-02 02:12:54'),(11,6,'host','主机','${host.addr}',2,'string',NULL,'2010-02-02 02:15:14','2010-02-02 02:15:14'),(12,6,'community','SNMP团体名','${host.community}',2,'string',NULL,'2010-02-02 02:15:40','2010-02-02 02:15:40'),(13,6,'ifindex','接口索引','1',1,'int',NULL,'2010-02-02 02:16:07','2010-02-02 02:16:07'),(14,9,'host','主机','${host.addr}',2,'string',NULL,'2010-02-02 02:16:48','2010-02-02 02:16:48'),(15,9,'port','TCP端口','8080',1,'int',NULL,'2010-02-02 02:17:04','2010-02-02 02:17:04'),(16,11,'host','主机','${host.addr}',2,'string',NULL,'2010-02-02 02:17:59','2010-02-02 02:17:59'),(17,11,'community','SNMP团体名','${host.community}',2,'string',NULL,'2010-02-02 02:18:32','2010-02-02 02:18:32'),(18,11,'index','磁盘索引','1',1,'int',NULL,'2010-02-02 02:18:57','2010-02-02 02:18:57'),(19,12,'host','主机','${host.addr}',2,'string',NULL,'2010-02-02 02:20:04','2010-02-02 02:20:04'),(20,12,'community','SNMP团体名','${host.community}',2,'string',NULL,'2010-02-02 02:20:25','2010-02-02 02:20:25'),(21,12,'index','磁盘IO索引','1',1,'int',NULL,'2010-02-02 02:21:01','2010-02-02 02:21:01'),(22,13,'host','主机','${host.addr}',2,'string',NULL,'2010-02-02 02:23:21','2010-02-02 02:23:21'),(23,13,'community','SNMP团体名','${host.community}',2,'string',NULL,'2010-02-02 02:23:47','2010-02-02 02:23:47'),(24,14,'host','主机','${host.addr}',2,'string',NULL,'2010-02-02 02:23:21','2010-02-02 02:23:21'),(25,14,'community','SNMP团体名','${host.community}',2,'string',NULL,'2010-02-02 02:24:08','2010-02-02 02:24:08'),(26,15,'host','主机','${host.addr}',2,'string',NULL,'2010-02-02 02:27:25','2010-02-02 02:27:25'),(27,15,'community','SNMP团体名','${host.community}',2,'string',NULL,'2010-02-02 02:27:57','2010-02-02 02:27:57'),(28,16,'url','状态页面地址','http://',1,'string',NULL,'2010-02-02 02:29:09','2010-02-02 02:29:09'),(29,17,'url','状态页面地址','http://',1,'string',NULL,'2010-02-02 02:29:30','2010-02-02 02:29:30'),(30,18,'url','状态页面地址','http://',1,'string',NULL,'2010-02-02 02:30:20','2010-02-02 02:30:20'),(31,19,'username','用户名','${app.login_name}',2,'string',NULL,'2010-02-02 02:30:47','2010-02-02 02:30:47'),(32,19,'host','主机','${host.addr}',2,'string',NULL,'2010-02-02 02:31:49','2010-02-02 02:31:49'),(33,19,'port','数据库端口','${app.port}',2,'string',NULL,'2010-02-02 02:32:17','2010-02-02 02:32:17'),(34,19,'password','密码','${app.password}',2,'string',NULL,'2010-02-02 02:32:49','2010-02-02 02:32:49'),(35,19,'database','数据库','mysql',1,'string',NULL,'2010-02-02 02:33:22','2010-02-02 02:33:22'),(40,22,'host','主机','${host.addr}',2,'string',NULL,'2010-02-02 02:20:04','2010-02-02 02:20:04'),(41,22,'community','SNMP团体名','${host.community}',2,'string',NULL,'2010-02-02 02:23:47','2010-02-02 02:23:47'),(42,2,'url','URL','/',1,'string',NULL,'2010-02-02 02:12:24','2010-02-02 02:12:24'),(43,23,'host','主机','${site.addr}',2,'string',NULL,'2010-03-30 14:55:08','2010-03-30 14:55:08'),(44,24,'host','主机','${site.addr}',2,'string',NULL,'2010-02-02 02:12:09','2010-02-02 02:12:09'),(45,24,'port','HTTP端口','${site.port}',2,'int',NULL,'2010-02-02 02:12:24','2010-02-02 02:12:24'),(46,24,'url','url路径','/',1,'string',NULL,'2010-03-30 14:58:35','2010-03-30 14:58:35'),(47,25,'name','域名','${site.addr}',2,'string',NULL,'2010-03-30 14:58:35','2010-03-30 14:58:35'),(48,25,'addr','IP地址','',1,'string','多个IP地址，逗号分隔','2010-03-30 14:58:35','2010-03-30 14:58:35'),(49,26,'host','主机','${host.addr}',2,'string',NULL,'2010-02-02 02:20:04','2010-02-02 02:20:04'),(50,26,'community','SNMP团体名','${host.community}',2,'string',NULL,'2010-02-02 02:23:47','2010-02-02 02:23:47'),(51,26,'index','CPU索引','',1,'int',NULL,'2010-02-02 02:21:01','2010-02-02 02:21:01'),(52,27,'host','主机','${host.addr}',2,'string',NULL,'2010-02-02 02:20:04','2010-02-02 02:20:04'),(53,27,'community','SNMP团体名','${host.community}',2,'string',NULL,'2010-02-02 02:23:47','2010-02-02 02:23:47'),(54,27,'index','物理内存索引','',1,'int',NULL,'2010-02-02 02:21:01','2010-02-02 02:21:01'),(55,28,'host','主机','${host.addr}',2,'string',NULL,'2010-02-02 02:20:04','2010-02-02 02:20:04'),(56,28,'community','SNMP团体名','${host.community}',2,'string',NULL,'2010-02-02 02:23:47','2010-02-02 02:23:47'),(57,28,'index','物理内存索引','',1,'int',NULL,'2010-02-02 02:21:01','2010-02-02 02:21:01'),(58,29,'host','主机','${host.addr}',2,'string',NULL,'2010-02-02 02:20:04','2010-02-02 02:20:04'),(59,29,'community','SNMP团体名','${host.community}',2,'string',NULL,'2010-02-02 02:23:47','2010-02-02 02:23:47'),(60,30,'host','主机','${host.addr}',2,'string',NULL,'2010-02-02 02:20:04','2010-02-02 02:20:04'),(61,30,'host','主机','${host.addr}',2,'string',NULL,'2010-02-02 02:20:04','2010-02-02 02:20:04'),(62,30,'index','进程 索引','',1,'int',NULL,'2010-02-02 02:21:01','2010-02-02 02:21:01'),(63,20,'username','用户名','${app.login_name}',2,'string',NULL,'2010-02-02 02:30:47','2010-02-02 02:30:47'),(64,20,'host','主机','${host.addr}',2,'string',NULL,'2010-02-02 02:31:49','2010-02-02 02:31:49'),(65,20,'port','数据库端口','${app.port}',2,'string',NULL,'2010-02-02 02:32:17','2010-02-02 02:32:17'),(66,20,'password','密码','${app.password}',2,'string',NULL,'2010-02-02 02:32:49','2010-02-02 02:32:49'),(67,20,'database','数据库','mysql',1,'string',NULL,'2010-02-02 02:33:22','2010-02-02 02:33:22'),(69,21,'username','用户名','${app.login_name}',2,'string',NULL,'2010-02-02 02:30:47','2010-02-02 02:30:47'),(70,21,'host','主机','${host.addr}',2,'string',NULL,'2010-02-02 02:31:49','2010-02-02 02:31:49'),(71,21,'port','数据库端口','${app.port}',2,'string',NULL,'2010-02-02 02:32:17','2010-02-02 02:32:17'),(72,21,'password','密码','${app.password}',2,'string',NULL,'2010-02-02 02:32:49','2010-02-02 02:32:49'),(73,21,'database','数据库','mysql',1,'string',NULL,'2010-02-02 02:33:22','2010-02-02 02:33:22'),(74,31,'host','主机','${host.addr}',2,'string',NULL,'2010-02-02 02:11:13','2010-02-02 02:11:13'),(75,32,'host','主机','${host.addr}',2,'string',NULL,'2010-02-02 02:11:13','2010-02-02 02:11:13');
/*!40000 ALTER TABLE `service_params` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `service_types`
--

DROP TABLE IF EXISTS `service_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `service_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `alias` varchar(100) DEFAULT NULL,
  `check_type` int(2) DEFAULT NULL COMMENT '1:passive 2:active',
  `disco_type` int(2) DEFAULT '0' COMMENT '1:snmp 2:ssh 3:local',
  `command` varchar(100) DEFAULT NULL,
  `command_type` varchar(100) DEFAULT NULL,
  `multi_services` int(2) DEFAULT '0',
  `ctrl_state` int(2) DEFAULT '0' COMMENT '0:false 1:true',
  `external` int(2) DEFAULT '1',
  `check_interval` int(11) DEFAULT NULL COMMENT 'second',
  `metric_id` int(11) DEFAULT NULL,
  `serviceable_type` int(11) DEFAULT NULL COMMENT '1:host_types 2:app_types',
  `serviceable_id` int(11) DEFAULT NULL COMMENT 'belong to app_types',
  `threshold_warning` varchar(200) DEFAULT NULL,
  `threshold_critical` varchar(200) DEFAULT NULL,
  `disco_auto` int(2) DEFAULT '0' COMMENT '0:false 1:true',
  `creator` int(11) DEFAULT NULL,
  `remark` varchar(100) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=33 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `service_types`
--

LOCK TABLES `service_types` WRITE;
/*!40000 ALTER TABLE `service_types` DISABLE KEYS */;
INSERT INTO `service_types` VALUES (1,'PING','PING监测',NULL,0,'check_ping','check_ping',0,1,1,300,NULL,1,2,'>= pl 50','>= pl 100',NULL,NULL,'PING双向时延','2010-01-14 03:06:27','2010-01-14 03:06:27'),(2,'HTTP','HTTP监测',NULL,0,'check_http','check_http',0,0,1,300,NULL,1,1,NULL,NULL,NULL,NULL,'HTTP响应时间','2010-01-14 03:06:27','2010-01-14 03:06:27'),(3,'磁盘容量','磁盘监测 - Shell',NULL,3,'check_disk_df','check_disk_df',1,0,1,300,NULL,1,2,NULL,NULL,NULL,NULL,'磁盘可用率','2010-01-14 03:06:27','2010-01-14 03:06:27'),(4,'系统负载','负载监测 - Shell',NULL,3,'check_load','check_load',0,0,1,300,NULL,1,2,'| (&(>= load1 20) (<= load1 50) )(>= load5 15) (>= load15 10)','| (&(>= load1 30) (<= load1 50) )(>= load5 15) (>= load15 10)',NULL,NULL,'主机负载','2010-01-14 03:06:27','2010-01-14 03:06:27'),(5,'CPU占用','CPU监测 - Shell',NULL,3,'check_cpu_top','check_cpu_top',0,0,1,300,NULL,1,2,'','',NULL,NULL,'主机CPU使用','2010-01-14 03:06:27','2010-02-02 09:49:18'),(6,'网络接口','接口监测 - SNMP',NULL,1,'check_if','check_if',0,0,0,300,NULL,1,2,'| (> inoctets 2) (> outoctets 2)','| (> inoctets 10) (> outoctets 10)',NULL,NULL,'接口流量','2010-01-14 03:06:27','2010-01-14 03:06:27'),(7,'内存占用','内存监测 - Shell',NULL,3,'check_mem_free','check_mem_free',0,0,1,300,NULL,1,2,NULL,NULL,NULL,NULL,'主机可用内存',NULL,NULL),(8,'SWAP占用','Swap监测 - Shell',NULL,3,'check_swap_free','check_swap_free',0,0,1,300,NULL,1,2,'','',NULL,NULL,'主机可用SWAP',NULL,'2010-02-01 15:51:26'),(9,'TCP','TCP监测',NULL,0,'check_tcp','check_tcp',1,0,1,300,NULL,1,2,'> time 500','> time 1000',NULL,NULL,'TCP响应时间','2010-01-14 03:06:27','2010-01-14 03:06:27'),(10,'任务总数','Linux任务总数 - Shell',NULL,3,'check_task_top','check_task_top',0,0,1,300,NULL,1,2,'','',NULL,NULL,'进程总数','2010-01-14 03:06:27','2010-02-02 09:49:33'),(11,'磁盘容量','磁盘监测 - SNMP',NULL,1,'check_disk_hr','check_disk_hr',0,0,0,300,NULL,1,2,'>= usage 60','>= usage 80',NULL,NULL,NULL,'2010-02-02 01:42:31','2010-02-02 01:42:31'),(12,'磁盘IO','磁盘IO监测 - SNMP',NULL,1,'check_diskio_ucd','check_diskio_ucd',0,0,0,300,NULL,1,2,'','',NULL,NULL,NULL,'2010-02-02 01:43:15','2010-02-02 01:43:15'),(13,'系统负载','系统负载 - SNMP',NULL,1,'check_load_ucd','check_load_ucd',0,0,0,300,NULL,1,2,'| (>= load1 10) (>= load5 10) (>= load15 10)','| (>= load1 50) (>= load5 50) (>= load15 50)',NULL,NULL,NULL,'2010-02-02 01:44:43','2010-02-02 01:44:43'),(14,'内存监测','内存监测 - SNMP',NULL,1,'check_mem_ucd','check_mem_ucd',0,0,0,300,NULL,1,2,'>= usage 98','',NULL,NULL,NULL,'2010-02-02 01:45:42','2010-02-02 01:45:42'),(15,'SWAP监测','SWAP监测 - SNMP',NULL,1,'check_swap_ucd','check_swap_ucd',0,0,0,300,NULL,1,2,'>= usage 20','',NULL,NULL,NULL,'2010-02-02 01:46:53','2010-02-02 01:46:53'),(16,'Apache状态','Apache状态监测 ',NULL,0,'check_apache_status','check_apache_status',0,1,1,300,NULL,2,7,'','',NULL,NULL,NULL,'2010-02-02 01:46:53','2010-02-02 01:46:53'),(17,'Lighttpd状态监测','Lighttpd状态监测',NULL,0,'check_lighttpd_status','check_lighttpd_status',0,1,1,300,NULL,2,4,'','',NULL,NULL,NULL,'2010-02-02 01:46:53','2010-02-02 01:46:53'),(18,'Nginx状态监测','Nginx状态监测',NULL,0,'check_nginx_status','check_nginx_status',0,1,1,300,NULL,2,5,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(19,'MySQL吞吐量监测','MySQL吞吐量监测',NULL,0,'check_mysql_bytes','check_mysql_bytes',0,0,1,300,NULL,2,6,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(20,'MySQL线程监测','MySQL线程监测',NULL,0,'check_mysql_threads','check_mysql_threads',0,0,1,300,NULL,2,6,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(21,'MySQL Innodb监测','MySQL Innodb监测',NULL,0,'check_mysql_innodb','check_mysql_innodb',0,0,1,300,NULL,2,6,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(22,'启动时间','启动时间监测 - SNMP',NULL,1,'check_uptime','check_uptime',0,1,0,300,NULL,1,2,'','',NULL,NULL,'主机启动时间','2010-02-02 01:42:31','2010-02-02 01:42:31'),(23,'PING','PING',NULL,0,'check_ping','check_ping',0,0,1,300,NULL,3,NULL,'>= pl 50','>= pl 100',0,NULL,NULL,NULL,NULL),(24,'HTTP','HTTP',NULL,0,'check_http','check_http',0,1,1,300,NULL,3,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL),(25,'DNS','DNS监测',NULL,0,'check_dns','check_dns',1,0,1,300,NULL,3,NULL,'> time 500','> time 2000',0,NULL,NULL,'2010-04-06 01:42:31',NULL),(26,'CPU负载','Window CPU负载 - SNMP',NULL,1,'check_cpu_hr','check_cpu_hr',1,0,0,300,NULL,1,5,'> load 30','> load 60',0,NULL,'Window CPU负载监测','2010-04-06 01:42:31',NULL),(27,'物理内存监测','Window 物理内存占用 - SNMP',NULL,1,'check_mem_hr','check_mem_hr',1,0,0,300,NULL,1,5,'> usage 80','> usage 90',0,NULL,'Window 物理内存占用监测','2010-04-06 01:42:31',NULL),(28,'虚拟内存监测','Window 虚拟内存占用 - SNMP',NULL,1,'check_virmem_hr','check_virmem_hr',0,0,0,300,NULL,1,5,'> usage 60','> usage 80',0,NULL,'Window 虚拟内存占用监测','2010-04-06 01:42:31',NULL),(29,'进程总数监测','Window 进程总数监测 - SNMP',NULL,1,'check_task_hr','check_task_hr',0,0,0,300,NULL,1,5,'> total 100','> total 200',0,NULL,'Window 进程数量监测','2010-04-06 01:42:31',NULL),(30,'进程监测','Window 进程监测 - SNMP',NULL,1,'check_process_hr','check_process_hr',1,0,0,300,NULL,1,5,'','',0,NULL,'Window 进程状态监测','2010-04-06 01:42:31',NULL),(31,'PING','PING监测',NULL,0,'check_ping','check_ping',0,1,1,300,NULL,1,5,'>= pl 50','>= pl 100',NULL,NULL,'PING双向时延','2010-01-14 03:06:27','2010-01-14 03:06:27'),(32,'端口扫描','端口扫描',NULL,0,'scan_nmap','scan_namp',0,0,1,3600,NULL,1,1,'','',NULL,NULL,'主机端口安全扫描','2010-01-14 03:06:27','2010-01-14 03:06:27');
/*!40000 ALTER TABLE `service_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `services`
--

DROP TABLE IF EXISTS `services`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `services` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  `uuid` varchar(50) DEFAULT NULL,
  `serviceable_type` int(11) DEFAULT NULL COMMENT '1:host 2:app',
  `serviceable_id` int(11) DEFAULT NULL,
  `ctrl_state` int(2) DEFAULT '0' COMMENT '0:false 1:true',
  `external` int(2) DEFAULT '1',
  `tenant_id` int(11) DEFAULT NULL,
  `agent_id` int(11) DEFAULT NULL,
  `type_id` int(11) DEFAULT NULL,
  `command` varchar(100) DEFAULT NULL,
  `command_type` varchar(100) DEFAULT NULL,
  `params` varchar(200) DEFAULT NULL,
  `check_interval` int(11) DEFAULT NULL COMMENT 'second',
  `desc` varchar(200) DEFAULT NULL,
  `is_collect` int(2) DEFAULT '1' COMMENT '0:false 1:true',
  `last_check` datetime DEFAULT NULL,
  `next_check` datetime DEFAULT NULL,
  `max_attempts` int(11) DEFAULT '3',
  `attempt_interval` int(11) DEFAULT '30' COMMENT 'second',
  `current_attempts` int(11) DEFAULT NULL,
  `latency` int(11) DEFAULT NULL,
  `duration` int(11) DEFAULT NULL,
  `status` int(2) DEFAULT '0',
  `status_type` int(2) DEFAULT '2' COMMENT '1:Transient 2:Permanent',
  `summary` varchar(1000) DEFAULT NULL,
  `last_time_ok` datetime DEFAULT NULL,
  `last_time_warning` datetime DEFAULT NULL,
  `last_time_critical` datetime DEFAULT NULL,
  `last_time_unknown` datetime DEFAULT NULL,
  `threshold_critical` varchar(200) DEFAULT NULL,
  `threshold_warning` varchar(200) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `i_service_command` (`serviceable_id`,`command_type`,`params`)
) ENGINE=InnoDB AUTO_INCREMENT=312 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `services`
--

LOCK TABLES `services` WRITE;
/*!40000 ALTER TABLE `services` DISABLE KEYS */;
INSERT INTO `services` VALUES (32,'Ping','f97cc56a-0a28-11df-8e4e-0026b9388a6f',1,15,1,1,1,NULL,1,'check_ping','check_ping','host=localhost',300,NULL,1,'2010-04-19 15:31:59','2010-04-19 15:36:59',3,30,NULL,NULL,NULL,0,2,'Packet loss = 0%, RTA = 0.027ms','2010-04-19 15:31:59',NULL,NULL,'2010-02-03 13:26:34','>= pl 100','>= pl 50','2010-01-26 00:40:38','2010-04-19 15:32:13'),(33,'HTTP - 9000','187b2506-0a29-11df-8e4e-0026b9388a6f',1,15,0,1,1,NULL,2,'check_http','check_http','host=${host.addr}&port=80&url=/',300,NULL,1,'2010-04-19 15:28:45','2010-04-19 15:33:45',3,30,NULL,NULL,NULL,0,2,'200 OK, 151 bytes in 0.001 seconds','2010-04-19 15:28:45','2010-04-07 21:21:50','2010-04-08 00:53:23','2010-02-22 09:35:12','> time 100','> time 50','2010-01-26 00:41:30','2010-04-19 15:30:13'),(34,'磁盘占用 - /','325a5bea-0a29-11df-8e4e-0026b9388a6f',1,15,0,1,1,NULL,3,'check_disk_df','check_disk_df','path=/',300,NULL,1,'2010-04-19 15:30:11','2010-04-19 15:35:11',3,30,NULL,NULL,NULL,0,2,'Disk \'/\' usage = 1%','2010-04-19 15:30:11',NULL,'2010-02-09 15:02:55','2010-02-23 16:06:36','>= usage 80','>= usage 60','2010-01-26 00:42:13','2010-04-19 15:30:13'),(35,'系统负载','5780bd10-0a29-11df-8e4e-0026b9388a6f',1,15,0,1,1,NULL,4,'check_load','check_load','',300,NULL,1,'2010-04-19 15:31:19','2010-04-19 15:36:19',3,30,NULL,NULL,NULL,0,2,'load average: 0.15%, 0.01%, 0.06%','2010-04-19 15:31:19',NULL,NULL,NULL,'| (>= load1 20) (>= load5 15) (>= load15 10)','>= load1 10','2010-01-26 00:43:15','2010-04-19 15:32:13'),(36,'CPU','607f0944-0a29-11df-8e4e-0026b9388a6f',1,15,0,1,1,NULL,5,'check_cpu_top','check_cpu_top','',300,NULL,1,'2010-04-19 15:29:02','2010-04-19 15:34:02',3,30,NULL,NULL,NULL,0,2,'Cpu(s):  0.5%us,  0.2%sy,  0.0%ni, 99.3%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st','2010-04-19 15:29:02',NULL,NULL,'2010-02-23 16:08:53','','','2010-01-26 00:43:30','2010-04-19 15:30:13'),(37,'Memory','702f2446-0a29-11df-8e4e-0026b9388a6f',1,15,0,1,1,NULL,7,'check_mem_free','check_mem_free','',300,NULL,1,'2010-04-19 15:28:05','2010-04-19 15:33:05',3,30,NULL,NULL,NULL,0,2,'memory usage = 0%','2010-04-19 15:28:05',NULL,NULL,'2010-02-23 16:08:53','','','2010-01-26 00:43:57','2010-04-19 15:28:13'),(38,'Swap','7eb65002-0a29-11df-8e4e-0026b9388a6f',1,15,0,1,1,NULL,8,'check_swap_free','check_swap_free','',300,NULL,1,'2010-04-19 15:29:32','2010-04-19 15:34:32',3,30,NULL,NULL,NULL,0,2,'swap usage = 0%','2010-04-19 15:29:32',NULL,NULL,'2010-02-23 16:08:34','>= usage 50','>= usage 20','2010-01-26 00:44:21','2010-04-19 15:30:13'),(39,'TCP - XMPP - 5222','95f8963a-0a29-11df-8e4e-0026b9388a6f',1,15,0,1,1,NULL,9,'check_tcp','check_tcp','host=${host.addr}&port=5222',300,NULL,1,'2010-04-19 15:31:10','2010-04-19 15:36:10',3,30,NULL,NULL,NULL,0,2,'0.000 seconds response time on port 5222','2010-04-19 15:31:10',NULL,'2010-04-09 17:03:33','2010-02-09 15:03:54','>= time 1000','>= time 100','2010-01-26 00:45:00','2010-04-19 15:32:13'),(40,'任务数','a4721682-0a29-11df-8e4e-0026b9388a6f',1,15,0,1,1,NULL,10,'check_task_top','check_task_top','',300,NULL,1,'2010-04-19 15:29:49','2010-04-19 15:34:49',3,30,NULL,NULL,NULL,0,2,'Tasks: 184 total,   2 running, 182 sleeping,   0 stopped,   0 zombie','2010-04-19 15:29:49',NULL,NULL,NULL,'>= total 500','>= total 300','2010-01-26 00:45:24','2010-04-19 15:30:13'),(43,'Ping','0e338f50-0a53-11df-8e4e-0026b9388a6f',1,18,0,1,1,NULL,1,'check_ping','check_ping','host=222.221.17.12',300,NULL,1,'2010-04-19 15:28:51','2010-04-19 15:33:51',3,30,NULL,NULL,NULL,2,2,'Packet loss = 100%',NULL,NULL,'2010-04-19 15:28:51','2010-02-03 13:26:49','>= pl 100','>= pl 80','2010-01-26 16:16:24','2010-04-19 15:30:13'),(47,'Ping','1a7d899a-0fd6-11df-b134-0026b9388a6f',1,20,1,1,1,NULL,1,'check_ping','check_ping','host=${host.addr}',300,NULL,1,'2010-04-19 15:29:26','2010-04-19 15:34:26',3,30,NULL,NULL,NULL,0,2,'Packet loss = 0%, RTA = 64.325ms','2010-04-19 15:29:26','2010-04-15 19:23:06','2010-04-13 03:11:04','2010-02-03 13:29:36','>= pl 100','>= pl 50','2010-02-02 16:37:35','2010-04-19 15:30:13'),(48,'HTTP - 80','99fae57c-0fd7-11df-b134-0026b9388a6f',1,20,0,1,1,NULL,2,'check_http','check_http','host=${host.addr}&port=80&url=/',300,NULL,1,'2010-04-19 15:32:13','2010-04-19 15:37:13',3,30,NULL,NULL,NULL,0,2,'302 Moved Temporarily, 97 bytes in 0.143 seconds','2010-04-19 15:32:13',NULL,'2010-04-13 01:52:48','2010-02-22 09:36:28',NULL,NULL,'2010-02-02 04:42:16','2010-04-19 15:32:13'),(52,'接口流量 - eth0','f93c3982-0fd7-11df-b134-0026b9388a6f',1,20,0,0,1,NULL,6,'check_if','check_if','host=${host.addr}&ifindex=2&community=${host.community}',300,NULL,1,'2010-04-19 15:27:30','2010-04-19 15:32:30',3,30,NULL,NULL,NULL,0,2,'eth0 is up.','2010-04-19 15:27:30',NULL,NULL,NULL,NULL,NULL,'2010-02-02 04:44:56','2010-04-19 15:28:13'),(55,'TCP - 8080','1cd8f4ac-0fd8-11df-b134-0026b9388a6f',1,20,0,1,1,NULL,9,'check_tcp','check_tcp','host=${host.addr}&port=8080',300,NULL,1,'2010-04-19 15:29:59','2010-04-19 15:34:59',3,30,NULL,NULL,NULL,0,2,'0.063 seconds response time on port 8080','2010-04-19 15:29:59','2010-04-07 07:14:40','2010-04-14 20:55:11','2010-02-03 14:29:15','> time 1000','> time 500','2010-02-02 04:45:55','2010-04-19 15:30:13'),(59,'系统负载','437c8fe2-0fd8-11df-b134-0026b9388a6f',1,20,0,0,1,NULL,13,'check_load_ucd','check_load_ucd','community=${host.community}&host=${host.addr}',300,NULL,1,'2010-04-19 15:27:15','2010-04-19 15:32:15',3,30,NULL,NULL,NULL,0,2,'load average: 4.29, 3.62, 3.39','2010-04-19 15:27:15','2010-04-15 08:13:58',NULL,'2010-04-15 08:09:07','| (>= load1 50) (>= load5 50) (>= load15 50)','| (>= load1 10) (>= load5 10) (>= load15 10)','2010-02-02 04:47:00','2010-04-19 15:28:13'),(60,'Memory','4d014a62-0fd8-11df-b134-0026b9388a6f',1,20,0,0,1,NULL,14,'check_mem_ucd','check_mem_ucd','host=${host.addr}&community=${host.community}',300,NULL,1,'2010-04-19 15:30:19','2010-04-19 15:35:19',3,30,NULL,NULL,NULL,0,2,'memory usage: 98%','2010-04-19 15:30:19','2010-02-03 17:38:45',NULL,'2010-04-19 04:09:18',NULL,'>= usage 100','2010-02-02 04:47:16','2010-04-19 15:32:13'),(61,'Swap','5515e3de-0fd8-11df-b134-0026b9388a6f',1,20,0,0,1,NULL,15,'check_swap_ucd','check_swap_ucd','host=${host.addr}&community=${host.community}',300,NULL,1,'2010-04-19 15:27:34','2010-04-19 15:32:34',3,30,NULL,NULL,NULL,0,2,'Swap usage: 6%','2010-04-19 15:27:34','2010-04-15 04:06:54',NULL,'2010-04-16 00:09:22',NULL,'>= usage 20','2010-02-02 04:47:30','2010-04-19 15:28:13'),(62,'磁盘IO -  cciss/c0d0','9898a05e-108e-11df-b134-0026b9388a6f',1,20,0,0,1,NULL,12,'check_diskio_ucd','check_diskio_ucd','host=${host.addr}&community=${host.community}&index=17',300,NULL,1,'2010-04-19 15:28:43','2010-04-19 15:33:43',3,30,NULL,NULL,NULL,0,2,'cciss/c0d0: reads=11.80KB/s, writes=888.38KB/s','2010-04-19 15:28:43',NULL,NULL,'2010-04-06 14:24:24',NULL,NULL,'2010-02-03 14:38:16','2010-04-19 15:30:13'),(63,'磁盘IO -  cciss/c0d0p1','a1e3dbf6-108e-11df-b134-0026b9388a6f',1,20,0,0,1,NULL,12,'check_diskio_ucd','check_diskio_ucd','host=${host.addr}&community=${host.community}&index=18',300,NULL,1,'2010-04-19 15:28:38','2010-04-19 15:33:38',3,30,NULL,NULL,NULL,0,2,'cciss/c0d0p1: reads=0.08KB/s, writes=48.97KB/s','2010-04-19 15:28:38',NULL,NULL,'2010-04-14 04:07:13',NULL,NULL,'2010-02-03 14:38:32','2010-04-19 15:30:13'),(64,'磁盘IO -  c cciss/c0d0p2','aa7b3296-108e-11df-b134-0026b9388a6f',1,20,0,0,1,NULL,12,'check_diskio_ucd','check_diskio_ucd','host=${host.addr}&community=${host.community}&index=19',300,NULL,1,'2010-04-19 15:31:31','2010-04-19 15:36:31',3,30,NULL,NULL,NULL,0,2,'cciss/c0d0p2: reads=0.00KB/s, writes=22.27KB/s','2010-04-19 15:31:31',NULL,NULL,'2010-04-13 03:13:12',NULL,NULL,'2010-02-03 14:38:46','2010-04-19 15:32:13'),(65,'磁盘IO - cciss/c0d0p3','b3980aac-108e-11df-b134-0026b9388a6f',1,20,0,0,1,NULL,12,'check_diskio_ucd','check_diskio_ucd','host=${host.addr}&community=${host.community}&index=20',300,NULL,1,'2010-04-19 15:30:19','2010-04-19 15:35:19',3,30,NULL,NULL,NULL,0,2,'cciss/c0d0p3: reads=0.11KB/s, writes=0.00KB/s','2010-04-19 15:30:19',NULL,NULL,'2010-04-19 04:09:18',NULL,NULL,'2010-02-03 14:39:02','2010-04-19 15:32:13'),(66,'磁盘IO - cciss/c0d0p4','bbc40a0a-108e-11df-b134-0026b9388a6f',1,20,0,0,1,NULL,12,'check_diskio_ucd','check_diskio_ucd','host=${host.addr}&community=${host.community}&index=21',300,NULL,1,'2010-04-19 15:28:54','2010-04-19 15:33:54',3,30,NULL,NULL,NULL,0,2,'cciss/c0d0p4: reads=0.00KB/s, writes=0.00KB/s','2010-04-19 15:28:54',NULL,NULL,'2010-04-06 14:23:55',NULL,NULL,'2010-02-03 14:39:15','2010-04-19 15:30:13'),(67,'磁盘IO - cciss/c0d0p5','c58fa602-108e-11df-b134-0026b9388a6f',1,20,0,0,1,NULL,12,'check_diskio_ucd','check_diskio_ucd','host=${host.addr}&community=${host.community}&index=22',300,NULL,1,'2010-04-19 15:28:39','2010-04-19 15:33:39',3,30,NULL,NULL,NULL,0,2,'cciss/c0d0p5: reads=11.62KB/s, writes=807.81KB/s','2010-04-19 15:28:39',NULL,NULL,'2010-04-15 04:06:47',NULL,NULL,'2010-02-03 14:39:32','2010-04-19 15:30:13'),(68,'磁盘容量 - /','2399e23a-108f-11df-b134-0026b9388a6f',1,20,0,0,1,NULL,11,'check_disk_hr','check_disk_hr','host=${host.addr}&community=${host.community}&index=4',300,NULL,1,'2010-04-19 15:28:05','2010-04-19 15:33:05',3,30,NULL,NULL,NULL,0,2,'Usage of /: 36%','2010-04-19 15:28:05',NULL,NULL,'2010-04-06 15:10:16','>= usage 80','>= usage 60','2010-02-03 14:42:10','2010-04-19 15:28:13'),(70,'接口流量 - eth1','4fc92ab8-1090-11df-b134-0026b9388a6f',1,20,0,0,1,NULL,6,'check_if','check_if','host=${host.addr}&ifindex=3&community=${host.community}',300,NULL,1,'2010-04-19 15:31:50','2010-04-19 15:36:50',3,30,NULL,NULL,NULL,0,2,'eth1 is up.','2010-04-19 15:31:50',NULL,NULL,NULL,NULL,NULL,'2010-02-03 14:50:33','2010-04-19 15:32:13'),(71,'接口流量 - eth2','58bd0b62-1090-11df-b134-0026b9388a6f',1,20,0,0,1,NULL,6,'check_if','check_if','host=${host.addr}&ifindex=4&community=${host.community}',300,NULL,1,'2010-04-19 15:29:19','2010-04-19 15:34:19',3,30,NULL,NULL,NULL,1,2,'eth2 is down.',NULL,'2010-04-19 15:29:19',NULL,'2010-04-19 04:09:18',NULL,NULL,'2010-02-03 14:50:48','2010-04-19 15:30:13'),(72,'HTTP监测','9affeeba-109d-11df-b134-0026b9388a6f',1,18,1,1,1,NULL,2,'check_http','check_http','host=${host.addr}&port=80&url=/',300,NULL,1,'2010-04-19 14:51:21','2010-04-19 14:56:21',3,30,NULL,NULL,NULL,0,2,'302 Moved Temporarily, 98 bytes in 0.118 seconds','2010-04-19 14:51:21',NULL,'2010-04-15 16:26:35','2010-02-22 09:33:54',NULL,NULL,'2010-02-03 16:25:43','2010-04-19 14:52:13'),(73,'磁盘监测 - ','c8bb824c-109d-11df-b134-0026b9388a6f',1,18,0,0,1,NULL,11,'check_disk_hr','check_disk_hr','host=${host.addr}&index=1&community=${host.community}',300,NULL,1,'2010-04-19 15:28:07','2010-04-19 15:33:07',3,30,NULL,NULL,NULL,3,2,'snmp error.',NULL,NULL,NULL,'2010-04-19 15:28:07','>= usage 80','>= usage 60','2010-02-03 16:27:00','2010-04-19 15:30:13'),(74,'Ping','da7eb5da-1156-11df-b134-0026b9388a6f',1,24,0,1,1,NULL,1,'check_ping','check_ping','host=${host.addr}',300,NULL,1,'2010-04-19 15:27:28','2010-04-19 15:32:28',3,30,NULL,NULL,NULL,2,2,'Packet loss = 100%',NULL,NULL,'2010-04-19 15:27:28','2010-04-04 23:25:47','>= pl 100','>= pl 50','2010-02-04 14:31:49','2010-04-19 15:28:13'),(75,'内存监测','1ff25d90-1168-11df-b134-0026b9388a6f',1,24,0,0,1,NULL,14,'check_mem_ucd','check_mem_ucd','community=${host.community}&host=${host.addr}',300,NULL,1,'2010-04-19 15:29:29','2010-04-19 15:34:29',3,30,NULL,NULL,NULL,1,2,'memory usage: 99%','2010-04-19 06:38:28','2010-04-19 15:29:29',NULL,'2010-04-13 03:13:11',NULL,'>= usage 98','2010-02-04 16:35:27','2010-04-19 15:30:13'),(76,'系统负载 - SNMP','82565798-116d-11df-b134-0026b9388a6f',1,24,0,0,1,NULL,13,'check_load_ucd','check_load_ucd','community=${host.community}&host=${host.addr}',300,NULL,1,'2010-04-19 15:31:41','2010-04-19 15:36:41',3,30,NULL,NULL,NULL,0,2,'load average: 0.78, 0.91, 0.97','2010-04-19 15:31:41',NULL,NULL,'2010-04-13 03:12:20','| (>= load1 50) (>= load5 50) (>= load15 50)','| (>= load1 10) (>= load5 10) (>= load15 10)','2010-02-04 17:14:00','2010-04-19 15:32:13'),(77,'启动时间','eb152e44-1172-11df-b134-0026b9388a6f',1,24,1,0,1,NULL,22,'check_uptime','check_uptime','host=${host.addr}&community=${host.community}',300,NULL,1,'2010-04-19 15:30:59','2010-04-19 15:35:59',3,30,NULL,NULL,NULL,0,2,'sysUptime = 639744729, sysDescr = Linux localhost.localdomain 2.6.18-53.el5 #1 SMP Wed Oct 10 16:34:19 EDT 2007 x86_64, sysOid = 1.3.6.1.4.1.8072.3.2.10','2010-04-19 15:30:59',NULL,NULL,'2010-04-13 04:47:37',NULL,NULL,'2010-02-04 17:52:43','2010-04-19 15:32:13'),(85,'PING监测','d699714c-276f-11df-8879-0026b9388a6f',1,29,1,1,1,NULL,1,'check_ping',NULL,'host=${host.addr}',300,NULL,1,'2010-04-19 15:30:42','2010-04-19 15:35:42',3,30,NULL,NULL,NULL,0,2,'Packet loss = 0%, RTA = 43.739ms','2010-04-19 15:30:42','2010-04-07 22:39:27','2010-04-06 11:41:22','2010-04-04 23:17:28','>= pl 100','>= pl 50','2010-03-04 01:25:21','2010-04-19 15:32:13'),(87,'HTTP监测','879b52d6-e6d8-11de-9b56-0026b9388a6f',1,31,0,1,19,NULL,2,'check_http',NULL,'host=${host.addr}&port=80&url=/',300,NULL,1,'2010-04-19 15:30:37','2010-04-19 15:35:37',3,30,NULL,NULL,NULL,2,2,'timed out',NULL,NULL,'2010-04-19 15:30:37',NULL,NULL,NULL,'2009-12-12 12:40:53','2010-04-19 15:32:13'),(88,'Nginx状态监测','2836ce34-e6dc-11de-9b56-0026b9388a6f',2,9,1,1,19,NULL,18,'check_nginx_status.py',NULL,'url=http://',300,NULL,1,'2010-04-19 15:28:10','2010-04-19 15:33:10',3,30,NULL,NULL,NULL,3,2,'/bin/sh: /opt/monit/plugins/check_nginx_status.py: not found',NULL,NULL,NULL,'2010-04-19 15:28:10',NULL,NULL,'2009-12-12 13:06:50','2010-04-19 15:28:13'),(92,'PING','6477d17e-3bd5-11df-af48-0026b9388a6f',3,8,0,1,1,NULL,23,'check_ping','check_ping','host=${site.addr}',300,NULL,1,'2010-04-19 15:27:44','2010-04-19 15:32:44',3,30,NULL,NULL,NULL,0,2,'Packet loss = 0%, RTA = 0.020ms','2010-04-19 15:27:44','2010-04-07 23:32:35','2010-04-06 11:26:45','2010-04-07 06:03:00','>= pl 100','>= pl 50','2010-03-30 16:23:46','2010-04-19 15:28:13'),(95,'MySQL吞吐量监测','d69351ee-4633-11df-a64b-6cf0494e0fad',2,7,1,1,1,NULL,19,'check_mysql_bytes','check_mysql_bytes','database=monit&host=${host.addr}&password=${app.password}&port=${app.port}&username=${app.login_name}',300,NULL,1,'2010-04-19 15:30:33','2010-04-19 15:35:33',3,30,NULL,NULL,NULL,0,2,'received=120,sent=89','2010-04-19 15:30:33',NULL,NULL,'2010-04-12 23:33:32',NULL,NULL,'2010-04-12 21:03:50','2010-04-19 15:32:13'),(99,'eth0','be37a3e0-4640-11df-a64b-6cf0494e0fad',1,45,0,0,1,NULL,6,'check_if','check_if','host=${host.addr}&community=${host.community}&ifindex=2',300,NULL,1,'2010-04-19 15:31:35','2010-04-19 15:36:35',3,30,NULL,NULL,NULL,0,2,'eth0 is up.','2010-04-19 15:31:35',NULL,NULL,NULL,NULL,NULL,'2010-04-12 22:36:12','2010-04-19 15:32:13'),(100,'eth1','bfa76792-4640-11df-a64b-6cf0494e0fad',1,45,0,0,1,NULL,6,'check_if','check_if','host=${host.addr}&community=${host.community}&ifindex=3',300,NULL,1,'2010-04-19 15:31:34','2010-04-19 15:36:34',3,30,NULL,NULL,NULL,0,2,'eth1 is up.','2010-04-19 15:31:34',NULL,NULL,NULL,NULL,NULL,'2010-04-12 22:36:15','2010-04-19 15:32:13'),(101,'eth2','c06ff888-4640-11df-a64b-6cf0494e0fad',1,45,0,0,1,NULL,6,'check_if','check_if','host=${host.addr}&community=${host.community}&ifindex=4',300,NULL,1,'2010-04-19 15:31:41','2010-04-19 15:36:41',3,30,NULL,NULL,NULL,0,2,'eth2 is up.','2010-04-19 15:31:41',NULL,NULL,NULL,NULL,NULL,'2010-04-12 22:36:16','2010-04-19 15:32:13'),(102,'eth3','cb04907e-4640-11df-a64b-6cf0494e0fad',1,45,0,0,1,NULL,6,'check_if','check_if','host=${host.addr}&community=${host.community}&ifindex=5',300,NULL,1,'2010-04-19 15:31:41','2010-04-19 15:36:41',3,30,NULL,NULL,NULL,1,2,'eth3 is down.',NULL,'2010-04-19 15:31:41',NULL,NULL,NULL,NULL,'2010-04-12 22:36:34','2010-04-19 15:32:13'),(103,'sit0','cc4b6764-4640-11df-a64b-6cf0494e0fad',1,45,0,0,1,NULL,6,'check_if','check_if','host=${host.addr}&community=${host.community}&ifindex=6',300,NULL,1,'2010-04-19 15:31:23','2010-04-19 15:36:23',3,30,NULL,NULL,NULL,1,2,'sit0 is down.',NULL,'2010-04-19 15:31:23',NULL,NULL,NULL,NULL,'2010-04-12 22:36:36','2010-04-19 15:32:13'),(104,'DiskIO - sda','ce46a74a-4640-11df-a64b-6cf0494e0fad',1,45,0,0,1,NULL,12,'check_diskio_ucd','check_diskio_ucd','host=${host.addr}&community=${host.community}&index=17',300,NULL,1,'2010-04-19 15:29:22','2010-04-19 15:34:22',3,30,NULL,NULL,NULL,0,2,'sda: reads=0.00KB/s, writes=21.90KB/s','2010-04-19 15:29:22',NULL,NULL,'2010-04-16 15:16:37',NULL,NULL,'2010-04-12 22:36:39','2010-04-19 15:30:13'),(105,'DiskIO - sda2','d44e6204-4640-11df-a64b-6cf0494e0fad',1,45,0,0,1,NULL,12,'check_diskio_ucd','check_diskio_ucd','host=${host.addr}&community=${host.community}&index=19',300,NULL,1,'2010-04-19 15:29:33','2010-04-19 15:34:33',3,30,NULL,NULL,NULL,0,2,'sda2: reads=0.00KB/s, writes=1.88KB/s','2010-04-19 15:29:33',NULL,NULL,'2010-04-16 15:17:21',NULL,NULL,'2010-04-12 22:36:49','2010-04-19 15:30:13'),(106,'Disk - /','d5b7b906-4640-11df-a64b-6cf0494e0fad',1,45,0,0,1,NULL,11,'check_disk_hr','check_disk_hr','host=${host.addr}&community=${host.community}&index=4',300,NULL,1,'2010-04-19 15:28:26','2010-04-19 15:33:26',3,30,NULL,NULL,NULL,0,2,'Usage of /: 3%','2010-04-19 15:28:26',NULL,NULL,'2010-04-16 15:16:14','>= usage 80','>= usage 60','2010-04-12 22:36:52','2010-04-19 15:30:13'),(107,'Disk - /usr','d74911e8-4640-11df-a64b-6cf0494e0fad',1,45,0,0,1,NULL,11,'check_disk_hr','check_disk_hr','host=${host.addr}&community=${host.community}&index=6',300,NULL,1,'2010-04-19 15:29:52','2010-04-19 15:34:52',3,30,NULL,NULL,NULL,0,2,'Usage of /usr: 27%','2010-04-19 15:29:52',NULL,NULL,'2010-04-16 15:16:40','>= usage 80','>= usage 60','2010-04-12 22:36:54','2010-04-19 15:30:13'),(108,'Disk - /opt','d94831cc-4640-11df-a64b-6cf0494e0fad',1,45,0,0,1,NULL,11,'check_disk_hr','check_disk_hr','host=${host.addr}&community=${host.community}&index=5',300,NULL,1,'2010-04-19 15:30:55','2010-04-19 15:35:55',3,30,NULL,NULL,NULL,0,2,'Usage of /opt: 2%','2010-04-19 15:30:55',NULL,NULL,'2010-04-16 15:14:13','>= usage 80','>= usage 60','2010-04-12 22:36:58','2010-04-19 15:32:13'),(109,'DiskIO - sda5','dba38dcc-4640-11df-a64b-6cf0494e0fad',1,45,0,0,1,NULL,12,'check_diskio_ucd','check_diskio_ucd','host=${host.addr}&community=${host.community}&index=22',300,NULL,1,'2010-04-19 15:31:02','2010-04-19 15:36:02',3,30,NULL,NULL,NULL,0,2,'sda5: reads=0.00KB/s, writes=18.15KB/s','2010-04-19 15:31:02',NULL,NULL,'2010-04-16 15:14:18',NULL,NULL,'2010-04-12 22:37:02','2010-04-19 15:32:13'),(110,'DiskIO - sda1','dccdd068-4640-11df-a64b-6cf0494e0fad',1,45,0,0,1,NULL,12,'check_diskio_ucd','check_diskio_ucd','host=${host.addr}&community=${host.community}&index=18',300,NULL,1,'2010-04-19 15:30:30','2010-04-19 15:35:30',3,30,NULL,NULL,NULL,0,2,'sda1: reads=0.00KB/s, writes=4.81KB/s','2010-04-19 15:30:30',NULL,NULL,'2010-04-16 15:17:20',NULL,NULL,'2010-04-12 22:37:04','2010-04-19 15:32:13'),(111,'DiskIO - sda3','de1b09cc-4640-11df-a64b-6cf0494e0fad',1,45,0,0,1,NULL,12,'check_diskio_ucd','check_diskio_ucd','host=${host.addr}&community=${host.community}&index=20',300,NULL,1,'2010-04-19 15:29:25','2010-04-19 15:34:25',3,30,NULL,NULL,NULL,0,2,'sda3: reads=0.00KB/s, writes=0.00KB/s','2010-04-19 15:29:25',NULL,NULL,'2010-04-16 15:16:13',NULL,NULL,'2010-04-12 22:37:06','2010-04-19 15:30:13'),(112,'DiskIO - sda4','df3a930e-4640-11df-a64b-6cf0494e0fad',1,45,0,0,1,NULL,12,'check_diskio_ucd','check_diskio_ucd','host=${host.addr}&community=${host.community}&index=21',300,NULL,1,'2010-04-19 15:28:00','2010-04-19 15:33:00',3,30,NULL,NULL,NULL,0,2,'sda4: reads=0.00KB/s, writes=0.00KB/s','2010-04-19 15:28:00',NULL,NULL,'2010-04-16 15:14:49',NULL,NULL,'2010-04-12 22:37:08','2010-04-19 15:28:13'),(113,'PING监测','ebdc76b8-4640-11df-a64b-6cf0494e0fad',1,45,1,1,1,NULL,1,'check_ping','check_ping','host=${host.addr}',300,NULL,1,'2010-04-19 15:31:09','2010-04-19 15:36:09',3,30,NULL,NULL,NULL,0,2,'Packet loss = 0%, RTA = 43.062ms','2010-04-19 15:31:09','2010-04-17 21:35:01','2010-04-15 16:49:35',NULL,'>= pl 100','>= pl 50','2010-04-12 22:37:29','2010-04-19 15:32:13'),(115,'eth0','af06acca-4647-11df-a64b-6cf0494e0fad',1,47,0,0,1,NULL,6,'check_if','check_if','host=${host.addr}&community=${host.community}&ifindex=2',300,NULL,1,'2010-04-19 15:28:27','2010-04-19 15:33:27',3,30,NULL,NULL,NULL,0,2,'eth0 is up.','2010-04-19 15:28:27',NULL,NULL,NULL,NULL,NULL,'2010-04-12 23:25:53','2010-04-19 15:30:13'),(116,'eth1','b0fdfa24-4647-11df-a64b-6cf0494e0fad',1,47,0,0,1,NULL,6,'check_if','check_if','host=${host.addr}&community=${host.community}&ifindex=3',300,NULL,1,'2010-04-19 15:30:24','2010-04-19 15:35:24',3,30,NULL,NULL,NULL,0,2,'eth1 is up.','2010-04-19 15:30:24',NULL,NULL,NULL,NULL,NULL,'2010-04-12 23:25:57','2010-04-19 15:32:13'),(117,'eth2','b2dc5fd4-4647-11df-a64b-6cf0494e0fad',1,47,0,0,1,NULL,6,'check_if','check_if','host=${host.addr}&community=${host.community}&ifindex=4',300,NULL,1,'2010-04-19 15:31:49','2010-04-19 15:36:49',3,30,NULL,NULL,NULL,0,2,'eth2 is up.','2010-04-19 15:31:49',NULL,NULL,NULL,NULL,NULL,'2010-04-12 23:26:00','2010-04-19 15:32:13'),(118,'eth3','b4663d70-4647-11df-a64b-6cf0494e0fad',1,47,0,0,1,NULL,6,'check_if','check_if','host=${host.addr}&community=${host.community}&ifindex=5',300,NULL,1,'2010-04-19 15:28:23','2010-04-19 15:33:23',3,30,NULL,NULL,NULL,1,2,'eth3 is down.',NULL,'2010-04-19 15:28:23',NULL,NULL,NULL,NULL,'2010-04-12 23:26:02','2010-04-19 15:30:13'),(119,'DiskIO - sda','b74eeb9a-4647-11df-a64b-6cf0494e0fad',1,47,0,0,1,NULL,12,'check_diskio_ucd','check_diskio_ucd','host=${host.addr}&community=${host.community}&index=17',300,NULL,1,'2010-04-19 15:29:29','2010-04-19 15:34:29',3,30,NULL,NULL,NULL,0,2,'sda: reads=0.00KB/s, writes=54.80KB/s','2010-04-19 15:29:29',NULL,NULL,'2010-04-16 15:16:18',NULL,NULL,'2010-04-12 23:26:07','2010-04-19 15:30:13'),(120,'DiskIO - sda1','b86b0b44-4647-11df-a64b-6cf0494e0fad',1,47,0,0,1,NULL,12,'check_diskio_ucd','check_diskio_ucd','host=${host.addr}&community=${host.community}&index=18',300,NULL,1,'2010-04-19 15:29:48','2010-04-19 15:34:48',3,30,NULL,NULL,NULL,0,2,'sda1: reads=0.00KB/s, writes=7.33KB/s','2010-04-19 15:29:48',NULL,NULL,'2010-04-16 15:16:40',NULL,NULL,'2010-04-12 23:26:09','2010-04-19 15:30:13'),(121,'DiskIO - sda2','ba15909a-4647-11df-a64b-6cf0494e0fad',1,47,0,0,1,NULL,12,'check_diskio_ucd','check_diskio_ucd','host=${host.addr}&community=${host.community}&index=19',300,NULL,1,'2010-04-19 15:29:45','2010-04-19 15:34:45',3,30,NULL,NULL,NULL,0,2,'sda2: reads=0.00KB/s, writes=40.26KB/s','2010-04-19 15:29:45',NULL,NULL,'2010-04-16 15:16:34',NULL,NULL,'2010-04-12 23:26:12','2010-04-19 15:30:13'),(122,'DiskIO - sda3','bb3e9c1e-4647-11df-a64b-6cf0494e0fad',1,47,0,0,1,NULL,12,'check_diskio_ucd','check_diskio_ucd','host=${host.addr}&community=${host.community}&index=20',300,NULL,1,'2010-04-19 15:31:51','2010-04-19 15:36:51',3,30,NULL,NULL,NULL,0,2,'sda3: reads=0.00KB/s, writes=0.00KB/s','2010-04-19 15:31:51',NULL,NULL,'2010-04-16 15:14:41',NULL,NULL,'2010-04-12 23:26:14','2010-04-19 15:32:13'),(123,'Disk - /','bc61d4f8-4647-11df-a64b-6cf0494e0fad',1,47,0,0,1,NULL,11,'check_disk_hr','check_disk_hr','host=${host.addr}&community=${host.community}&index=4',300,NULL,1,'2010-04-19 15:27:54','2010-04-19 15:32:54',3,30,NULL,NULL,NULL,0,2,'Usage of /: 5%','2010-04-19 15:27:54',NULL,NULL,'2010-04-16 15:14:41','>= usage 80','>= usage 60','2010-04-12 23:26:16','2010-04-19 15:28:13'),(124,'Disk - /opt','bdd9ad6a-4647-11df-a64b-6cf0494e0fad',1,47,0,0,1,NULL,11,'check_disk_hr','check_disk_hr','host=${host.addr}&community=${host.community}&index=5',300,NULL,1,'2010-04-19 15:29:31','2010-04-19 15:34:31',3,30,NULL,NULL,NULL,0,2,'Usage of /opt: 0%','2010-04-19 15:29:31',NULL,NULL,'2010-04-16 15:16:21','>= usage 80','>= usage 60','2010-04-12 23:26:18','2010-04-19 15:30:13'),(125,'Disk - /usr','beec53ec-4647-11df-a64b-6cf0494e0fad',1,47,0,0,1,NULL,11,'check_disk_hr','check_disk_hr','host=${host.addr}&community=${host.community}&index=6',300,NULL,1,'2010-04-19 15:31:37','2010-04-19 15:36:37',3,30,NULL,NULL,NULL,0,2,'Usage of /usr: 27%','2010-04-19 15:31:37',NULL,NULL,'2010-04-16 15:14:21','>= usage 80','>= usage 60','2010-04-12 23:26:20','2010-04-19 15:32:13'),(126,'DiskIO - sda4','c01ae9ae-4647-11df-a64b-6cf0494e0fad',1,47,0,0,1,NULL,12,'check_diskio_ucd','check_diskio_ucd','host=${host.addr}&community=${host.community}&index=21',300,NULL,1,'2010-04-19 15:31:08','2010-04-19 15:36:08',3,30,NULL,NULL,NULL,0,2,'sda4: reads=0.00KB/s, writes=0.00KB/s','2010-04-19 15:31:08',NULL,NULL,'2010-04-16 15:14:32',NULL,NULL,'2010-04-12 23:26:22','2010-04-19 15:32:13'),(127,'DiskIO - sda5','c14e0716-4647-11df-a64b-6cf0494e0fad',1,47,0,0,1,NULL,12,'check_diskio_ucd','check_diskio_ucd','host=${host.addr}&community=${host.community}&index=22',300,NULL,1,'2010-04-19 15:30:35','2010-04-19 15:35:35',3,30,NULL,NULL,NULL,0,2,'sda5: reads=0.00KB/s, writes=2.33KB/s','2010-04-19 15:30:35',NULL,NULL,'2010-04-16 15:17:24',NULL,NULL,'2010-04-12 23:26:24','2010-04-19 15:32:13'),(128,'PING监测','d9e30fe2-4647-11df-a64b-6cf0494e0fad',1,47,1,1,1,NULL,1,'check_ping','check_ping','host=${host.addr}',300,NULL,1,'2010-04-19 15:31:44','2010-04-19 15:36:44',3,30,NULL,NULL,NULL,0,2,'Packet loss = 0%, RTA = 43.927ms','2010-04-19 15:31:44','2010-04-18 22:45:41','2010-04-15 16:50:08',NULL,'>= pl 100','>= pl 50','2010-04-12 23:27:05','2010-04-19 15:32:13'),(129,'系统负载 - SNMP','e1124e04-4647-11df-a64b-6cf0494e0fad',1,47,0,0,1,NULL,13,'check_load_ucd','check_load_ucd','community=${host.community}&host=${host.addr}',300,NULL,1,'2010-04-19 15:28:35','2010-04-19 15:33:35',3,30,NULL,NULL,NULL,0,2,'load average: 0.25, 0.14, 0.05','2010-04-19 15:28:35','2010-04-13 17:54:26',NULL,'2010-04-16 15:16:27','| (>= load1 50) (>= load5 50) (>= load15 50)','| (>= load1 10) (>= load5 10) (>= load15 10)','2010-04-12 23:27:17','2010-04-19 15:30:13'),(130,'内存监测 - SNMP','ea44c204-4647-11df-a64b-6cf0494e0fad',1,47,0,0,1,NULL,14,'check_mem_ucd','check_mem_ucd','community=${host.community}&host=${host.addr}',300,NULL,1,'2010-04-19 15:28:52','2010-04-19 15:33:52',3,30,NULL,NULL,NULL,0,2,'memory usage: 56%','2010-04-19 15:28:52',NULL,NULL,'2010-04-16 15:16:38',NULL,'>= usage 95','2010-04-12 23:27:33','2010-04-19 15:30:13'),(131,'SWAP监测 - SNMP','f4277a8c-4647-11df-a64b-6cf0494e0fad',1,47,0,0,1,NULL,15,'check_swap_ucd','check_swap_ucd','community=${host.community}&host=${host.addr}',300,NULL,1,'2010-04-19 15:31:37','2010-04-19 15:36:37',3,30,NULL,NULL,NULL,0,2,'Swap usage: 0%','2010-04-19 15:31:37',NULL,NULL,'2010-04-16 15:14:24',NULL,'>= usage 20','2010-04-12 23:27:49','2010-04-19 15:32:13'),(132,'MySQL线程监测','fd77f24e-464a-11df-a64b-6cf0494e0fad',2,7,0,1,1,NULL,20,'check_mysql_threads','check_mysql_threads','database=mysql&host=${host.addr}&password=${app.password}&port=${app.port}&username=${app.login_name}',300,NULL,1,'2010-04-19 15:29:32','2010-04-19 15:34:32',3,30,NULL,NULL,NULL,0,2,'cached=3,connected=11,created=19,running=2','2010-04-19 15:29:32',NULL,NULL,NULL,NULL,NULL,'2010-04-12 23:49:33','2010-04-19 15:30:13'),(133,'MySQL Innodb监测','022749ca-464b-11df-a64b-6cf0494e0fad',2,7,0,1,1,NULL,21,'check_mysql_innodb','check_mysql_innodb','database=mysql&host=${host.addr}&password=${app.password}&port=${app.port}&username=${app.login_name}',300,NULL,1,'2010-04-19 15:31:16','2010-04-19 15:36:16',3,30,NULL,NULL,NULL,0,2,'buffer_pool_pages_data=162,buffer_pool_pages_dirty=0,buffer_pool_pages_flushed=108638,buffer_pool_pages_free=348,buffer_pool_pages_misc=2,buffer_pool_pages_total=512,buffer_pool_read_ahead_rnd=4,buffe','2010-04-19 15:31:16',NULL,NULL,'2010-04-13 00:19:31',NULL,NULL,'2010-04-12 23:49:41','2010-04-19 15:32:13'),(135,'DNS监测','423ea080-464b-11df-a64b-6cf0494e0fad',3,8,0,1,1,NULL,25,'check_dns','check_dns','addr=222.73.68.35&name=${site.addr}',300,NULL,1,'2010-04-19 15:27:47','2010-04-19 15:32:47',3,30,NULL,NULL,NULL,0,2,'0.052 seconds response time. www.opengoss.com returns 222.73.68.35','2010-04-19 15:27:47',NULL,'2010-04-14 16:56:36',NULL,NULL,NULL,'2010-04-12 23:51:29','2010-04-19 15:28:13'),(136,'eth0','38b134e6-464c-11df-a64b-6cf0494e0fad',1,24,0,0,1,NULL,6,'check_if','check_if','host=${host.addr}&community=${host.community}&ifindex=2',300,NULL,1,'2010-04-19 15:31:15','2010-04-19 15:36:15',3,30,NULL,NULL,NULL,0,2,'eth0 is up.','2010-04-19 15:31:15',NULL,NULL,NULL,NULL,NULL,'2010-04-12 23:58:22','2010-04-19 15:32:13'),(137,'HTTP','210bcfc0-464e-11df-a64b-6cf0494e0fad',3,8,1,1,1,NULL,24,'check_http','check_http','host=${site.addr}&port=${site.port}&url=/',300,NULL,1,'2010-04-19 15:31:11','2010-04-19 15:36:11',3,30,NULL,NULL,NULL,0,2,'200 OK, 5452 bytes in 0.282 seconds','2010-04-19 15:31:11',NULL,NULL,NULL,NULL,NULL,'2010-04-13 00:12:02','2010-04-19 15:32:13'),(138,'eth2','4e75802c-464f-11df-a64b-6cf0494e0fad',1,24,0,0,1,NULL,6,'check_if','check_if','host=${host.addr}&community=${host.community}&ifindex=4',300,NULL,1,'2010-04-19 15:30:47','2010-04-19 15:35:47',3,30,NULL,NULL,NULL,1,2,'eth2 is down.',NULL,'2010-04-19 15:30:47',NULL,NULL,NULL,NULL,'2010-04-13 00:20:27','2010-04-19 15:32:13'),(139,'Disk - /','508bb336-464f-11df-a64b-6cf0494e0fad',1,24,0,0,1,NULL,11,'check_disk_hr','check_disk_hr','host=${host.addr}&community=${host.community}&index=4',300,NULL,1,'2010-04-19 15:27:49','2010-04-19 15:32:49',3,30,NULL,NULL,NULL,0,2,'Usage of /: 9%','2010-04-19 15:27:49',NULL,NULL,'2010-04-13 03:13:29','>= usage 80','>= usage 60','2010-04-13 00:20:31','2010-04-19 15:28:13'),(140,'DiskIO - cciss/c0d0','5309f938-464f-11df-a64b-6cf0494e0fad',1,24,0,0,1,NULL,12,'check_diskio_ucd','check_diskio_ucd','host=${host.addr}&community=${host.community}&index=17',300,NULL,1,'2010-04-19 15:28:09','2010-04-19 15:33:09',3,30,NULL,NULL,NULL,0,2,'cciss/c0d0: reads=0.00KB/s, writes=187.81KB/s','2010-04-19 15:28:09',NULL,NULL,NULL,NULL,NULL,'2010-04-13 00:20:35','2010-04-19 15:28:13'),(141,'DiskIO - cciss/c0d0p1','53b9d39e-464f-11df-a64b-6cf0494e0fad',1,24,0,0,1,NULL,12,'check_diskio_ucd','check_diskio_ucd','host=${host.addr}&community=${host.community}&index=18',300,NULL,1,'2010-04-19 15:30:16','2010-04-19 15:35:16',3,30,NULL,NULL,NULL,0,2,'cciss/c0d0p1: reads=0.00KB/s, writes=0.00KB/s','2010-04-19 15:30:16',NULL,NULL,'2010-04-13 03:10:57',NULL,NULL,'2010-04-13 00:20:36','2010-04-19 15:32:13'),(142,'DiskIO - cciss/c0d0p2','54808638-464f-11df-a64b-6cf0494e0fad',1,24,0,0,1,NULL,12,'check_diskio_ucd','check_diskio_ucd','host=${host.addr}&community=${host.community}&index=19',300,NULL,1,'2010-04-19 15:29:24','2010-04-19 15:34:24',3,30,NULL,NULL,NULL,0,2,'cciss/c0d0p2: reads=0.00KB/s, writes=187.32KB/s','2010-04-19 15:29:24',NULL,NULL,NULL,NULL,NULL,'2010-04-13 00:20:37','2010-04-19 15:30:13'),(143,'DiskIO - dm-0','574ca270-464f-11df-a64b-6cf0494e0fad',1,24,0,0,1,NULL,12,'check_diskio_ucd','check_diskio_ucd','host=${host.addr}&community=${host.community}&index=20',300,NULL,1,'2010-04-19 15:27:31','2010-04-19 15:32:31',3,30,NULL,NULL,NULL,0,2,'dm-0: reads=0.00KB/s, writes=189.97KB/s','2010-04-19 15:27:31',NULL,NULL,'2010-04-13 03:13:14',NULL,NULL,'2010-04-13 00:20:42','2010-04-19 15:28:13'),(144,'DiskIO - dm-1','580da0ba-464f-11df-a64b-6cf0494e0fad',1,24,0,0,1,NULL,12,'check_diskio_ucd','check_diskio_ucd','host=${host.addr}&community=${host.community}&index=21',300,NULL,1,'2010-04-19 15:32:02','2010-04-19 15:37:02',3,30,NULL,NULL,NULL,0,2,'dm-1: reads=0.00KB/s, writes=0.00KB/s','2010-04-19 15:32:02',NULL,NULL,'2010-04-13 03:12:38',NULL,NULL,'2010-04-13 00:20:43','2010-04-19 15:32:13'),(146,'CPU监测 - Shell','297629ee-46d5-11df-a64b-6cf0494e0fad',1,49,0,1,31,NULL,5,'check_cpu_top','check_cpu_top','',300,NULL,1,'2010-04-19 15:27:15','2010-04-19 15:32:15',3,30,NULL,NULL,NULL,0,2,'Cpu(s):  0.5%us,  0.2%sy,  0.0%ni, 99.3%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st','2010-04-19 15:27:15',NULL,NULL,NULL,NULL,NULL,'2010-04-13 16:18:38','2010-04-19 15:28:13'),(147,'内存监测 - SNMP','8be21f84-46d5-11df-a64b-6cf0494e0fad',1,49,1,0,31,NULL,14,'check_mem_ucd','check_mem_ucd','community=${host.community}&host=${host.addr}',300,NULL,1,'2010-04-19 15:29:15','2010-04-19 15:34:15',3,30,NULL,NULL,NULL,1,2,'memory usage: 97%','2010-04-17 09:08:13','2010-04-19 15:29:15',NULL,NULL,NULL,'>= usage 90','2010-04-13 16:21:23','2010-04-19 15:30:13'),(148,'PING监测','a180c4f8-46d5-11df-a64b-6cf0494e0fad',1,51,1,1,29,NULL,1,'check_ping','check_ping','host=${host.addr}',300,NULL,1,'2010-04-19 15:27:42','2010-04-19 15:32:42',3,30,NULL,NULL,NULL,0,2,'Packet loss = 0%, RTA = 53.096ms','2010-04-19 15:27:42',NULL,NULL,NULL,'>= pl 100','>= pl 50','2010-04-13 16:21:59','2010-04-19 15:28:13'),(149,'磁盘IO监测 - SNMP','b979b95c-46d5-11df-a64b-6cf0494e0fad',1,51,0,0,29,NULL,12,'check_diskio_ucd','check_diskio_ucd','community=${host.community}&host=${host.addr}&index=1',300,NULL,1,'2010-04-19 15:31:04','2010-04-19 15:36:04',3,30,NULL,NULL,NULL,0,2,'ram0: reads=0.00KB/s, writes=0.00KB/s','2010-04-19 15:31:04',NULL,NULL,NULL,NULL,NULL,'2010-04-13 16:22:39','2010-04-19 15:32:13'),(150,'系统负载 - SNMP','c6975126-46d5-11df-a64b-6cf0494e0fad',1,51,0,0,29,NULL,13,'check_load_ucd','check_load_ucd','community=${host.community}&host=${host.addr}',300,NULL,1,'2010-04-19 15:30:19','2010-04-19 15:35:19',3,30,NULL,NULL,NULL,0,2,'load average: 1.47, 1.56, 1.66','2010-04-19 15:30:19',NULL,NULL,NULL,'| (>= load1 50) (>= load5 50) (>= load15 50)','| (>= load1 10) (>= load5 10) (>= load15 10)','2010-04-13 16:23:01','2010-04-19 15:32:13'),(151,'PING监测','7a0ae6e6-46d6-11df-a64b-6cf0494e0fad',1,56,1,1,33,NULL,1,'check_ping','check_ping','host=${host.addr}',600,NULL,1,'2010-04-19 15:24:09','2010-04-19 15:34:09',3,30,NULL,NULL,NULL,0,2,'Packet loss = 0%, RTA = 14.041ms','2010-04-19 15:24:09','2010-04-16 20:23:03',NULL,NULL,'>= pl 100','>= pl 50','2010-04-13 16:28:02','2010-04-19 15:24:13'),(152,'PING监测','a3651476-46d6-11df-a64b-6cf0494e0fad',1,50,1,1,33,NULL,1,'check_ping','check_ping','host=${host.addr}',600,NULL,1,'2010-04-19 15:22:46','2010-04-19 15:32:46',3,30,NULL,NULL,NULL,0,2,'Packet loss = 0%, RTA = 13.977ms','2010-04-19 15:22:46','2010-04-13 19:01:03',NULL,NULL,'>= pl 100','>= pl 50','2010-04-13 16:29:12','2010-04-19 15:24:13'),(153,'系统负载 - SNMP','e0f28e4a-46d6-11df-a64b-6cf0494e0fad',1,50,0,0,33,NULL,13,'check_load_ucd','check_load_ucd','community=${host.community}&host=${host.addr}',600,NULL,1,'2010-04-19 15:23:48','2010-04-19 15:33:48',3,30,NULL,NULL,NULL,0,2,'load average: 0.30, 0.53, 0.51','2010-04-19 15:23:48',NULL,NULL,'2010-04-14 16:22:02','| (>= load1 50) (>= load5 50) (>= load15 50)','| (>= load1 10) (>= load5 10) (>= load15 10)','2010-04-13 16:30:55','2010-04-19 15:24:13'),(154,'内存监测 - SNMP','fa139536-46d6-11df-a64b-6cf0494e0fad',1,50,0,0,33,NULL,14,'check_mem_ucd','check_mem_ucd','community=${host.community}&host=${host.addr}',600,NULL,1,'2010-04-19 15:31:30','2010-04-19 15:41:30',3,30,NULL,NULL,NULL,0,2,'memory usage: 93%','2010-04-19 15:31:30','2010-04-15 17:21:07',NULL,'2010-04-14 16:19:53',NULL,'>= usage 98','2010-04-13 16:31:37','2010-04-19 15:32:13'),(155,'启动时间监测 - SNMP','39610642-46d7-11df-a64b-6cf0494e0fad',1,51,0,0,29,NULL,22,'check_uptime','check_uptime','community=${host.community}&host=${host.addr}',300,NULL,1,'2010-04-19 15:29:35','2010-04-19 15:34:35',3,30,NULL,NULL,NULL,0,2,'sysUptime = 52389366, sysDescr = Linux localhost.kundian 2.6.18-128.4.1.el5 #1 SMP Tue Aug 4 20:19:25 EDT 2009 x86_64, sysOid = 1.3.6.1.4.1.8072.3.2.10','2010-04-19 15:29:35',NULL,NULL,NULL,NULL,NULL,'2010-04-13 16:33:23','2010-04-19 15:30:13'),(156,'系统负载 - SNMP','515f2aa8-46d7-11df-a64b-6cf0494e0fad',1,56,0,0,33,NULL,13,'check_load_ucd','check_load_ucd','community=${host.community}&host=${host.addr}',600,NULL,1,'2010-04-19 15:26:13','2010-04-19 15:36:13',3,30,NULL,NULL,NULL,0,2,'load average: 0.01, 0.08, 0.09','2010-04-19 15:26:13',NULL,NULL,NULL,'| (>= load1 50) (>= load5 50) (>= load15 50)','| (>= load1 10) (>= load5 10) (>= load15 10)','2010-04-13 16:34:04','2010-04-19 15:26:13'),(157,'内存监测 - SNMP','5cb8ac6c-46d7-11df-a64b-6cf0494e0fad',1,56,0,0,33,NULL,14,'check_mem_ucd','check_mem_ucd','community=${host.community}&host=${host.addr}',600,NULL,1,'2010-04-19 15:24:07','2010-04-19 15:34:07',3,30,NULL,NULL,NULL,0,2,'memory usage: 96%','2010-04-19 15:24:07','2010-04-19 14:34:07',NULL,NULL,NULL,'>= usage 98','2010-04-13 16:34:23','2010-04-19 15:24:13'),(158,'磁盘监测 - SNMP','6469c6da-46d7-11df-a64b-6cf0494e0fad',1,56,0,0,33,NULL,11,'check_disk_hr','check_disk_hr','community=${host.community}&host=${host.addr}&index=1',600,NULL,1,'2010-04-19 15:23:01','2010-04-19 15:33:01',3,30,NULL,NULL,NULL,0,2,'Usage of Memory Buffers: 1%','2010-04-19 15:23:01',NULL,NULL,NULL,'>= usage 80','>= usage 60','2010-04-13 16:34:36','2010-04-19 15:24:13'),(159,'PING监测','79e8e428-46d7-11df-a64b-6cf0494e0fad',1,52,1,1,33,NULL,1,'check_ping','check_ping','host=${host.addr}',600,NULL,1,'2010-04-19 15:26:24','2010-04-19 15:36:24',3,30,NULL,NULL,NULL,0,2,'Packet loss = 0%, RTA = 21.715ms','2010-04-19 15:26:24','2010-04-15 18:49:08',NULL,NULL,'>= pl 100','>= pl 50','2010-04-13 16:35:12','2010-04-19 15:28:13'),(160,'磁盘监测 - SNMP','9768eb24-46d7-11df-a64b-6cf0494e0fad',1,52,0,0,33,NULL,11,'check_disk_hr','check_disk_hr','community=${host.community}&host=${host.addr}&index=1',600,NULL,1,'2010-04-19 15:23:08','2010-04-19 15:33:08',3,30,NULL,NULL,NULL,0,2,'Usage of Memory Buffers: 8%','2010-04-19 15:23:08',NULL,NULL,NULL,'>= usage 80','>= usage 60','2010-04-13 16:36:01','2010-04-19 15:24:13'),(161,'系统负载 - SNMP','9f510f24-46d7-11df-a64b-6cf0494e0fad',1,52,0,0,33,NULL,13,'check_load_ucd','check_load_ucd','community=${host.community}&host=${host.addr}',600,NULL,1,'2010-04-19 15:24:24','2010-04-19 15:34:24',3,30,NULL,NULL,NULL,0,2,'load average: 0.52, 0.77, 0.91','2010-04-19 15:24:24',NULL,NULL,NULL,'| (>= load1 50) (>= load5 50) (>= load15 50)','| (>= load1 10) (>= load5 10) (>= load15 10)','2010-04-13 16:36:14','2010-04-19 15:26:13'),(162,'内存监测 - SNMP','a52cf728-46d7-11df-a64b-6cf0494e0fad',1,52,0,0,33,NULL,14,'check_mem_ucd','check_mem_ucd','community=${host.community}&host=${host.addr}',600,NULL,1,'2010-04-19 15:23:03','2010-04-19 15:33:03',3,30,NULL,NULL,NULL,0,2,'memory usage: 93%','2010-04-19 15:23:03','2010-04-19 08:42:32',NULL,NULL,NULL,'>= usage 98','2010-04-13 16:36:24','2010-04-19 15:24:13'),(163,'PING监测','b82927a2-46d7-11df-a64b-6cf0494e0fad',1,53,1,1,33,NULL,1,'check_ping','check_ping','host=${host.addr}',600,NULL,1,'2010-04-19 15:24:31','2010-04-19 15:34:31',3,30,NULL,NULL,NULL,0,2,'Packet loss = 0%, RTA = 14.272ms','2010-04-19 15:24:31','2010-04-18 22:53:28',NULL,NULL,'>= pl 100','>= pl 50','2010-04-13 16:36:56','2010-04-19 15:26:13'),(164,'系统负载 - SNMP','c068c7c4-46d7-11df-a64b-6cf0494e0fad',1,53,0,0,33,NULL,13,'check_load_ucd','check_load_ucd','community=${host.community}&host=${host.addr}',600,NULL,1,'2010-04-19 15:32:04','2010-04-19 15:42:04',3,30,NULL,NULL,NULL,0,2,'load average: 0.58, 0.43, 0.38','2010-04-19 15:32:04',NULL,NULL,'2010-04-14 16:10:22','| (>= load1 50) (>= load5 50) (>= load15 50)','| (>= load1 10) (>= load5 10) (>= load15 10)','2010-04-13 16:37:10','2010-04-19 15:32:13'),(165,'PING监测','ce8a87ca-46d7-11df-a64b-6cf0494e0fad',1,54,1,1,33,NULL,1,'check_ping','check_ping','host=${host.addr}',600,NULL,1,'2010-04-19 15:30:18','2010-04-19 15:40:18',3,30,NULL,NULL,NULL,0,2,'Packet loss = 0%, RTA = 14.835ms','2010-04-19 15:30:18','2010-04-19 15:29:18',NULL,NULL,'>= pl 100','>= pl 50','2010-04-13 16:37:34','2010-04-19 15:32:13'),(166,'内存监测 - SNMP','d483c718-46d7-11df-a64b-6cf0494e0fad',1,54,0,0,33,NULL,14,'check_mem_ucd','check_mem_ucd','community=${host.community}&host=${host.addr}',600,NULL,1,'2010-04-19 15:23:06','2010-04-19 15:33:06',3,30,NULL,NULL,NULL,1,2,'memory usage: 98%',NULL,'2010-04-19 15:23:06',NULL,'2010-04-14 16:21:27',NULL,'>= usage 80','2010-04-13 16:37:44','2010-04-19 15:24:13'),(167,'PING监测','e525eede-46d7-11df-a64b-6cf0494e0fad',1,55,1,1,33,NULL,1,'check_ping','check_ping','host=${host.addr}',600,NULL,1,'2010-04-19 15:22:31','2010-04-19 15:32:31',3,30,NULL,NULL,NULL,0,2,'Packet loss = 0%, RTA = 21.304ms','2010-04-19 15:22:31','2010-04-17 20:41:31',NULL,NULL,'>= pl 100','>= pl 50','2010-04-13 16:38:12','2010-04-19 15:24:13'),(168,'eth0','aa6d5032-46d9-11df-a64b-6cf0494e0fad',1,51,0,0,29,NULL,6,'check_if','check_if','host=${host.addr}&community=${host.community}&ifindex=2',300,NULL,1,'2010-04-19 15:30:46','2010-04-19 15:35:46',3,30,NULL,NULL,NULL,0,2,'eth0 is up.','2010-04-19 15:30:46',NULL,NULL,NULL,NULL,NULL,'2010-04-13 16:50:52','2010-04-19 15:32:13'),(169,'eth1','ac1223a4-46d9-11df-a64b-6cf0494e0fad',1,51,0,0,29,NULL,6,'check_if','check_if','host=${host.addr}&community=${host.community}&ifindex=3',300,NULL,1,'2010-04-19 15:29:26','2010-04-19 15:34:26',3,30,NULL,NULL,NULL,0,2,'eth1 is up.','2010-04-19 15:29:26',NULL,NULL,NULL,NULL,NULL,'2010-04-13 16:50:55','2010-04-19 15:30:13'),(170,'Disk - /','ad4c4ccc-46d9-11df-a64b-6cf0494e0fad',1,51,0,0,29,NULL,11,'check_disk_hr','check_disk_hr','host=${host.addr}&community=${host.community}&index=4',300,NULL,1,'2010-04-19 15:29:45','2010-04-19 15:34:45',3,30,NULL,NULL,NULL,0,2,'Usage of /: 5%','2010-04-19 15:29:45',NULL,NULL,NULL,'>= usage 80','>= usage 60','2010-04-13 16:50:57','2010-04-19 15:30:13'),(171,'DiskIO - cciss/c0d0','afe05c9e-46d9-11df-a64b-6cf0494e0fad',1,51,0,0,29,NULL,12,'check_diskio_ucd','check_diskio_ucd','host=${host.addr}&community=${host.community}&index=17',300,NULL,1,'2010-04-19 15:29:36','2010-04-19 15:34:36',3,30,NULL,NULL,NULL,0,2,'cciss/c0d0: reads=0.00KB/s, writes=30.08KB/s','2010-04-19 15:29:36',NULL,NULL,NULL,NULL,NULL,'2010-04-13 16:51:01','2010-04-19 15:30:13'),(172,'DiskIO - cciss/c0d0p1','b11896a8-46d9-11df-a64b-6cf0494e0fad',1,51,0,0,29,NULL,12,'check_diskio_ucd','check_diskio_ucd','host=${host.addr}&community=${host.community}&index=18',300,NULL,1,'2010-04-19 15:30:07','2010-04-19 15:35:07',3,30,NULL,NULL,NULL,0,2,'cciss/c0d0p1: reads=0.00KB/s, writes=0.00KB/s','2010-04-19 15:30:07',NULL,NULL,NULL,NULL,NULL,'2010-04-13 16:51:03','2010-04-19 15:30:13'),(173,'DiskIO - cciss/c0d0p2','b23bab10-46d9-11df-a64b-6cf0494e0fad',1,51,0,0,29,NULL,12,'check_diskio_ucd','check_diskio_ucd','host=${host.addr}&community=${host.community}&index=19',300,NULL,1,'2010-04-19 15:30:48','2010-04-19 15:35:48',3,30,NULL,NULL,NULL,0,2,'cciss/c0d0p2: reads=0.00KB/s, writes=30.98KB/s','2010-04-19 15:30:48',NULL,NULL,NULL,NULL,NULL,'2010-04-13 16:51:05','2010-04-19 15:32:13'),(174,'DiskIO - dm-0','b3a37fdc-46d9-11df-a64b-6cf0494e0fad',1,51,0,0,29,NULL,12,'check_diskio_ucd','check_diskio_ucd','host=${host.addr}&community=${host.community}&index=20',300,NULL,1,'2010-04-19 15:30:12','2010-04-19 15:35:12',3,30,NULL,NULL,NULL,0,2,'dm-0: reads=0.00KB/s, writes=30.34KB/s','2010-04-19 15:30:12',NULL,NULL,NULL,NULL,NULL,'2010-04-13 16:51:08','2010-04-19 15:30:13'),(175,'DiskIO - dm-1','b535eab0-46d9-11df-a64b-6cf0494e0fad',1,51,0,0,29,NULL,12,'check_diskio_ucd','check_diskio_ucd','host=${host.addr}&community=${host.community}&index=21',300,NULL,1,'2010-04-19 15:31:14','2010-04-19 15:36:14',3,30,NULL,NULL,NULL,0,2,'dm-1: reads=0.00KB/s, writes=0.00KB/s','2010-04-19 15:31:14',NULL,NULL,NULL,NULL,NULL,'2010-04-13 16:51:10','2010-04-19 15:32:13'),(176,'PING监测','035684fc-46da-11df-a64b-6cf0494e0fad',1,57,1,1,10,NULL,1,'check_ping','check_ping','host=${host.addr}',600,NULL,1,'2010-04-19 15:28:41','2010-04-19 15:38:41',3,30,NULL,NULL,NULL,0,2,'Packet loss = 0%, RTA = 27.380ms','2010-04-19 15:28:41','2010-04-16 17:06:10','2010-04-17 17:07:06',NULL,'>= pl 60','>= pl 20','2010-04-13 16:53:21','2010-04-19 15:30:13'),(177,'系统负载 - SNMP','61ef0930-46da-11df-a64b-6cf0494e0fad',1,58,0,0,31,NULL,13,'check_load_ucd','check_load_ucd','community=${host.community}&host=${host.addr}',300,NULL,1,'2010-04-19 15:27:33','2010-04-19 15:32:33',3,30,NULL,NULL,NULL,0,2,'load average: 1.47, 1.14, 1.05','2010-04-19 15:27:33',NULL,NULL,NULL,'| (>= load1 50) (>= load5 50) (>= load15 50)','| (>= load1 10) (>= load5 10) (>= load15 10)','2010-04-13 16:56:00','2010-04-19 15:28:13'),(178,'系统负载 - SNMP','cbe9f6ce-46da-11df-a64b-6cf0494e0fad',1,59,0,0,31,NULL,13,'check_load_ucd','check_load_ucd','community=${host.community}&host=${host.addr}',300,NULL,1,'2010-04-19 15:31:45','2010-04-19 15:36:45',3,30,NULL,NULL,NULL,3,2,'snmp failure!',NULL,NULL,NULL,'2010-04-19 15:31:45','| (>= load1 50) (>= load5 50) (>= load15 50)','| (>= load1 10) (>= load5 10) (>= load15 10)','2010-04-13 16:58:58','2010-04-19 15:32:13'),(179,'sit0','ceceb2f8-46da-11df-a64b-6cf0494e0fad',1,51,0,0,29,NULL,6,'check_if','check_if','host=${host.addr}&community=${host.community}&ifindex=4',300,NULL,1,'2010-04-19 15:30:26','2010-04-19 15:35:26',3,30,NULL,NULL,NULL,1,2,'sit0 is down.',NULL,'2010-04-19 15:30:26',NULL,NULL,NULL,NULL,'2010-04-13 16:59:03','2010-04-19 15:32:13'),(180,'Disk - /boot','d2f0bd40-46da-11df-a64b-6cf0494e0fad',1,51,0,0,29,NULL,11,'check_disk_hr','check_disk_hr','host=${host.addr}&community=${host.community}&index=5',300,NULL,1,'2010-04-19 15:29:11','2010-04-19 15:34:11',3,30,NULL,NULL,NULL,0,2,'Usage of /boot: 19%','2010-04-19 15:29:11',NULL,NULL,NULL,'>= usage 80','>= usage 60','2010-04-13 16:59:10','2010-04-19 15:30:13'),(181,'eth0','691c1a58-46db-11df-a64b-6cf0494e0fad',1,58,0,0,31,NULL,6,'check_if','check_if','host=${host.addr}&community=${host.community}&ifindex=2',300,NULL,1,'2010-04-19 15:28:02','2010-04-19 15:33:02',3,30,NULL,NULL,NULL,0,2,'eth0 is up.','2010-04-19 15:28:02',NULL,NULL,NULL,NULL,NULL,'2010-04-13 17:03:21','2010-04-19 15:28:13'),(182,'eth2','6abe64a6-46db-11df-a64b-6cf0494e0fad',1,58,0,0,31,NULL,6,'check_if','check_if','host=${host.addr}&community=${host.community}&ifindex=4',300,NULL,1,'2010-04-19 15:29:11','2010-04-19 15:34:11',3,30,NULL,NULL,NULL,1,2,'eth2 is down.',NULL,'2010-04-19 15:29:11',NULL,NULL,NULL,NULL,'2010-04-13 17:03:24','2010-04-19 15:30:13'),(183,'Disk - /','6beed8c4-46db-11df-a64b-6cf0494e0fad',1,58,0,0,31,NULL,11,'check_disk_hr','check_disk_hr','host=${host.addr}&community=${host.community}&index=4',300,NULL,1,'2010-04-19 15:28:35','2010-04-19 15:33:35',3,30,NULL,NULL,NULL,0,2,'Usage of /: 9%','2010-04-19 15:28:35',NULL,NULL,NULL,'>= usage 80','>= usage 60','2010-04-13 17:03:26','2010-04-19 15:30:13'),(184,'DiskIO - cciss/c0d0','6d5107c8-46db-11df-a64b-6cf0494e0fad',1,58,0,0,31,NULL,12,'check_diskio_ucd','check_diskio_ucd','host=${host.addr}&community=${host.community}&index=17',300,NULL,1,'2010-04-19 15:29:40','2010-04-19 15:34:40',3,30,NULL,NULL,NULL,0,2,'cciss/c0d0: reads=0.00KB/s, writes=186.52KB/s','2010-04-19 15:29:40',NULL,NULL,NULL,NULL,NULL,'2010-04-13 17:03:29','2010-04-19 15:30:13'),(185,'DiskIO - cciss/c0d0p1','6e85f27a-46db-11df-a64b-6cf0494e0fad',1,58,0,0,31,NULL,12,'check_diskio_ucd','check_diskio_ucd','host=${host.addr}&community=${host.community}&index=18',300,NULL,1,'2010-04-19 15:29:35','2010-04-19 15:34:35',3,30,NULL,NULL,NULL,0,2,'cciss/c0d0p1: reads=0.00KB/s, writes=0.00KB/s','2010-04-19 15:29:35',NULL,NULL,NULL,NULL,NULL,'2010-04-13 17:03:31','2010-04-19 15:30:13'),(186,'DiskIO - cciss/c0d0p2','6fdf30fa-46db-11df-a64b-6cf0494e0fad',1,58,0,0,31,NULL,12,'check_diskio_ucd','check_diskio_ucd','host=${host.addr}&community=${host.community}&index=19',300,NULL,1,'2010-04-19 15:30:30','2010-04-19 15:35:30',3,30,NULL,NULL,NULL,0,2,'cciss/c0d0p2: reads=0.00KB/s, writes=187.88KB/s','2010-04-19 15:30:30',NULL,NULL,NULL,NULL,NULL,'2010-04-13 17:03:33','2010-04-19 15:32:13'),(187,'DiskIO - dm-0','70dc8bc4-46db-11df-a64b-6cf0494e0fad',1,58,0,0,31,NULL,12,'check_diskio_ucd','check_diskio_ucd','host=${host.addr}&community=${host.community}&index=20',300,NULL,1,'2010-04-19 15:29:15','2010-04-19 15:34:15',3,30,NULL,NULL,NULL,0,2,'dm-0: reads=0.00KB/s, writes=187.79KB/s','2010-04-19 15:29:15',NULL,NULL,NULL,NULL,NULL,'2010-04-13 17:03:34','2010-04-19 15:30:13'),(188,'DiskIO - dm-1','71c82a20-46db-11df-a64b-6cf0494e0fad',1,58,0,0,31,NULL,12,'check_diskio_ucd','check_diskio_ucd','host=${host.addr}&community=${host.community}&index=21',300,NULL,1,'2010-04-19 15:31:49','2010-04-19 15:36:49',3,30,NULL,NULL,NULL,0,2,'dm-1: reads=0.00KB/s, writes=0.00KB/s','2010-04-19 15:31:49',NULL,NULL,NULL,NULL,NULL,'2010-04-13 17:03:36','2010-04-19 15:32:13'),(189,'Disk - /boot','72dc38b6-46db-11df-a64b-6cf0494e0fad',1,58,0,0,31,NULL,11,'check_disk_hr','check_disk_hr','host=${host.addr}&community=${host.community}&index=6',300,NULL,1,'2010-04-19 15:28:25','2010-04-19 15:33:25',3,30,NULL,NULL,NULL,0,2,'Usage of /boot: 11%','2010-04-19 15:28:25',NULL,NULL,'2010-04-16 14:05:11','>= usage 80','>= usage 60','2010-04-13 17:03:38','2010-04-19 15:30:13'),(190,'sit0','739d2ecc-46db-11df-a64b-6cf0494e0fad',1,58,0,0,31,NULL,6,'check_if','check_if','host=${host.addr}&community=${host.community}&ifindex=5',300,NULL,1,'2010-04-19 15:28:18','2010-04-19 15:33:18',3,30,NULL,NULL,NULL,1,2,'sit0 is down.',NULL,'2010-04-19 15:28:18',NULL,NULL,NULL,NULL,'2010-04-13 17:03:39','2010-04-19 15:30:13'),(191,'eth1','74ae692a-46db-11df-a64b-6cf0494e0fad',1,58,0,0,31,NULL,6,'check_if','check_if','host=${host.addr}&community=${host.community}&ifindex=3',300,NULL,1,'2010-04-19 15:30:48','2010-04-19 15:35:48',3,30,NULL,NULL,NULL,0,2,'eth1 is up.','2010-04-19 15:30:48',NULL,NULL,NULL,NULL,NULL,'2010-04-13 17:03:41','2010-04-19 15:32:13'),(192,'接口监测 - SNMP','9edf939a-46db-11df-a64b-6cf0494e0fad',1,50,0,0,33,NULL,6,'check_if','check_if','community=${host.community}&host=${host.addr}&ifindex=1',600,NULL,1,'2010-04-19 15:23:01','2010-04-19 15:33:01',3,30,NULL,NULL,NULL,0,2,'lo is up.','2010-04-19 15:23:01',NULL,NULL,NULL,NULL,NULL,'2010-04-13 17:04:52','2010-04-19 15:24:13'),(193,'磁盘监测 - SNMP','ac6302cc-46db-11df-a64b-6cf0494e0fad',1,50,0,0,33,NULL,11,'check_disk_hr','check_disk_hr','community=${host.community}&host=${host.addr}&index=1',600,NULL,1,'2010-04-19 15:25:50','2010-04-19 15:35:50',3,30,NULL,NULL,NULL,0,2,'Usage of Memory Buffers: 34%','2010-04-19 15:25:50',NULL,NULL,'2010-04-14 16:24:11','>= usage 80','>= usage 60','2010-04-13 17:05:14','2010-04-19 15:26:13'),(194,'磁盘IO监测 - SNMP','b62fea22-46db-11df-a64b-6cf0494e0fad',1,50,0,0,33,NULL,12,'check_diskio_ucd','check_diskio_ucd','community=${host.community}&host=${host.addr}&index=1',600,NULL,1,'2010-04-19 15:23:06','2010-04-19 15:33:06',3,30,NULL,NULL,NULL,0,2,'ram0: reads=0.00KB/s, writes=0.00KB/s','2010-04-19 15:23:06',NULL,NULL,'2010-04-14 16:21:26',NULL,NULL,'2010-04-13 17:05:31','2010-04-19 15:24:13'),(195,'eth0','c97ed36c-46dc-11df-a64b-6cf0494e0fad',1,56,0,0,33,NULL,6,'check_if','check_if','host=${host.addr}&community=${host.community}&ifindex=2',300,NULL,1,'2010-04-19 15:29:16','2010-04-19 15:34:16',3,30,NULL,NULL,NULL,0,2,'eth0 is up.','2010-04-19 15:29:16',NULL,NULL,NULL,NULL,NULL,'2010-04-13 17:13:13','2010-04-19 15:30:13'),(196,'DiskIO - sda','14f4255e-46dd-11df-a64b-6cf0494e0fad',1,56,0,0,33,NULL,12,'check_diskio_ucd','check_diskio_ucd','host=${host.addr}&community=${host.community}&index=17',300,NULL,1,'2010-04-19 15:27:34','2010-04-19 15:32:34',3,30,NULL,NULL,NULL,0,2,'sda: reads=88.06KB/s, writes=25.04KB/s','2010-04-19 15:27:34',NULL,NULL,NULL,NULL,NULL,'2010-04-13 17:15:19','2010-04-19 15:28:13'),(197,'Disk - /opt','30f56c22-46dd-11df-a64b-6cf0494e0fad',1,56,0,0,33,NULL,11,'check_disk_hr','check_disk_hr','host=${host.addr}&community=${host.community}&index=5',300,NULL,1,'2010-04-19 15:30:22','2010-04-19 15:35:22',3,30,NULL,NULL,NULL,1,2,'Usage of /opt: 68%',NULL,'2010-04-19 15:30:22',NULL,NULL,'>= usage 80','>= usage 60','2010-04-13 17:16:06','2010-04-19 15:32:13'),(198,'Disk - /hpAJ800A','3389d716-46dd-11df-a64b-6cf0494e0fad',1,56,0,0,33,NULL,11,'check_disk_hr','check_disk_hr','host=${host.addr}&community=${host.community}&index=7',300,NULL,1,'2010-04-19 15:31:02','2010-04-19 15:36:02',3,30,NULL,NULL,NULL,0,2,'Usage of /hpAJ800A: 1%','2010-04-19 15:31:02',NULL,NULL,NULL,'>= usage 80','>= usage 60','2010-04-13 17:16:11','2010-04-19 15:32:13'),(199,'Disk - /','3625eca8-46dd-11df-a64b-6cf0494e0fad',1,56,0,0,33,NULL,11,'check_disk_hr','check_disk_hr','host=${host.addr}&community=${host.community}&index=4',300,NULL,1,'2010-04-19 15:30:32','2010-04-19 15:35:32',3,30,NULL,NULL,NULL,1,2,'Usage of /: 60%',NULL,'2010-04-19 15:30:32',NULL,NULL,'>= usage 80','>= usage 60','2010-04-13 17:16:15','2010-04-19 15:32:13'),(200,'sit0','3d99d954-46dd-11df-a64b-6cf0494e0fad',1,56,0,0,33,NULL,6,'check_if','check_if','host=${host.addr}&community=${host.community}&ifindex=6',300,NULL,1,'2010-04-19 15:32:08','2010-04-19 15:37:08',3,30,NULL,NULL,NULL,1,2,'sit0 is down.',NULL,'2010-04-19 15:32:08',NULL,NULL,NULL,NULL,'2010-04-13 17:16:27','2010-04-19 15:32:13'),(201,'eth0','4a87a72c-46dd-11df-a64b-6cf0494e0fad',1,55,0,0,33,NULL,6,'check_if','check_if','host=${host.addr}&community=${host.community}&ifindex=2',300,NULL,1,'2010-04-19 15:28:07','2010-04-19 15:33:07',3,30,NULL,NULL,NULL,0,2,'eth0 is up.','2010-04-19 15:28:07',NULL,NULL,NULL,NULL,NULL,'2010-04-13 17:16:49','2010-04-19 15:28:13'),(202,'DiskIO - sda','4cbb799c-46dd-11df-a64b-6cf0494e0fad',1,55,0,0,33,NULL,12,'check_diskio_ucd','check_diskio_ucd','host=${host.addr}&community=${host.community}&index=17',300,NULL,1,'2010-04-19 15:29:06','2010-04-19 15:34:06',3,30,NULL,NULL,NULL,0,2,'sda: reads=0.00KB/s, writes=2.38KB/s','2010-04-19 15:29:06',NULL,NULL,NULL,NULL,NULL,'2010-04-13 17:16:53','2010-04-19 15:30:13'),(203,'DiskIO - sda1','4fb3bd8a-46dd-11df-a64b-6cf0494e0fad',1,55,0,0,33,NULL,12,'check_diskio_ucd','check_diskio_ucd','host=${host.addr}&community=${host.community}&index=18',300,NULL,1,'2010-04-19 15:27:51','2010-04-19 15:32:51',3,30,NULL,NULL,NULL,0,2,'sda1: reads=0.00KB/s, writes=2.03KB/s','2010-04-19 15:27:51',NULL,NULL,NULL,NULL,NULL,'2010-04-13 17:16:58','2010-04-19 15:28:13'),(204,'Disk - /','512232be-46dd-11df-a64b-6cf0494e0fad',1,55,0,0,33,NULL,11,'check_disk_hr','check_disk_hr','host=${host.addr}&community=${host.community}&index=4',300,NULL,1,'2010-04-19 15:30:54','2010-04-19 15:35:54',3,30,NULL,NULL,NULL,0,2,'Usage of /: 9%','2010-04-19 15:30:54',NULL,NULL,NULL,'>= usage 80','>= usage 60','2010-04-13 17:17:00','2010-04-19 15:32:13'),(205,'Disk - /opt','52a5491e-46dd-11df-a64b-6cf0494e0fad',1,55,0,0,33,NULL,11,'check_disk_hr','check_disk_hr','host=${host.addr}&community=${host.community}&index=5',300,NULL,1,'2010-04-19 15:27:31','2010-04-19 15:32:31',3,30,NULL,NULL,NULL,0,2,'Usage of /opt: 0%','2010-04-19 15:27:31',NULL,NULL,NULL,'>= usage 80','>= usage 60','2010-04-13 17:17:03','2010-04-19 15:28:13'),(206,'Disk - /usr','53ee9924-46dd-11df-a64b-6cf0494e0fad',1,55,0,0,33,NULL,11,'check_disk_hr','check_disk_hr','host=${host.addr}&community=${host.community}&index=6',300,NULL,1,'2010-04-19 15:31:04','2010-04-19 15:36:04',3,30,NULL,NULL,NULL,0,2,'Usage of /usr: 29%','2010-04-19 15:31:04',NULL,NULL,NULL,'>= usage 80','>= usage 60','2010-04-13 17:17:05','2010-04-19 15:32:13'),(207,'DiskIO - sda1','5851caf4-46dd-11df-a64b-6cf0494e0fad',1,56,0,0,33,NULL,12,'check_diskio_ucd','check_diskio_ucd','host=${host.addr}&community=${host.community}&index=18',300,NULL,1,'2010-04-19 15:32:05','2010-04-19 15:37:05',3,30,NULL,NULL,NULL,0,2,'sda1: reads=0.03KB/s, writes=160.95KB/s','2010-04-19 15:32:05',NULL,NULL,NULL,NULL,NULL,'2010-04-13 17:17:12','2010-04-19 15:32:13'),(208,'DiskIO - sdd','5aa816aa-46dd-11df-a64b-6cf0494e0fad',1,56,0,0,33,NULL,12,'check_diskio_ucd','check_diskio_ucd','host=${host.addr}&community=${host.community}&index=25',300,NULL,1,'2010-04-19 15:29:53','2010-04-19 15:34:53',3,30,NULL,NULL,NULL,0,2,'sdd: reads=0.00KB/s, writes=0.00KB/s','2010-04-19 15:29:53',NULL,NULL,NULL,NULL,NULL,'2010-04-13 17:17:16','2010-04-19 15:30:13'),(209,'Disk - /usr','5c49c508-46dd-11df-a64b-6cf0494e0fad',1,56,0,0,33,NULL,11,'check_disk_hr','check_disk_hr','host=${host.addr}&community=${host.community}&index=6',300,NULL,1,'2010-04-19 15:30:44','2010-04-19 15:35:44',3,30,NULL,NULL,NULL,0,2,'Usage of /usr: 29%','2010-04-19 15:30:44',NULL,NULL,NULL,'>= usage 80','>= usage 60','2010-04-13 17:17:19','2010-04-19 15:32:13'),(210,'eth0','6cb0f628-46dd-11df-a64b-6cf0494e0fad',1,52,0,0,33,NULL,6,'check_if','check_if','host=${host.addr}&community=${host.community}&ifindex=2',300,NULL,1,'2010-04-19 15:29:37','2010-04-19 15:34:37',3,30,NULL,NULL,NULL,0,2,'eth0 is up.','2010-04-19 15:29:37',NULL,NULL,NULL,NULL,NULL,'2010-04-13 17:17:46','2010-04-19 15:30:13'),(211,'sit0','6e3e4f40-46dd-11df-a64b-6cf0494e0fad',1,52,0,0,33,NULL,6,'check_if','check_if','host=${host.addr}&community=${host.community}&ifindex=6',300,NULL,1,'2010-04-19 15:30:35','2010-04-19 15:35:35',3,30,NULL,NULL,NULL,1,2,'sit0 is down.',NULL,'2010-04-19 15:30:35',NULL,NULL,NULL,NULL,'2010-04-13 17:17:49','2010-04-19 15:32:13'),(212,'DiskIO - sda','6fa31ac8-46dd-11df-a64b-6cf0494e0fad',1,52,0,0,33,NULL,12,'check_diskio_ucd','check_diskio_ucd','host=${host.addr}&community=${host.community}&index=17',300,NULL,1,'2010-04-19 15:31:59','2010-04-19 15:36:59',3,30,NULL,NULL,NULL,0,2,'sda: reads=8.52KB/s, writes=633.95KB/s','2010-04-19 15:31:59',NULL,NULL,NULL,NULL,NULL,'2010-04-13 17:17:51','2010-04-19 15:32:13'),(213,'DiskIO - sda1','712592cc-46dd-11df-a64b-6cf0494e0fad',1,52,0,0,33,NULL,12,'check_diskio_ucd','check_diskio_ucd','host=${host.addr}&community=${host.community}&index=18',300,NULL,1,'2010-04-19 15:30:50','2010-04-19 15:35:50',3,30,NULL,NULL,NULL,0,2,'sda1: reads=0.08KB/s, writes=4.60KB/s','2010-04-19 15:30:50',NULL,NULL,NULL,NULL,NULL,'2010-04-13 17:17:54','2010-04-19 15:32:13'),(214,'Disk - /','72bca530-46dd-11df-a64b-6cf0494e0fad',1,52,0,0,33,NULL,11,'check_disk_hr','check_disk_hr','host=${host.addr}&community=${host.community}&index=4',300,NULL,1,'2010-04-19 15:30:17','2010-04-19 15:35:17',3,30,NULL,NULL,NULL,0,2,'Usage of /: 17%','2010-04-19 15:30:17',NULL,NULL,NULL,'>= usage 80','>= usage 60','2010-04-13 17:17:57','2010-04-19 15:32:13'),(215,'Disk - /opt','73ef87ce-46dd-11df-a64b-6cf0494e0fad',1,52,0,0,33,NULL,11,'check_disk_hr','check_disk_hr','host=${host.addr}&community=${host.community}&index=5',300,NULL,1,'2010-04-19 15:27:24','2010-04-19 15:32:24',3,30,NULL,NULL,NULL,0,2,'Usage of /opt: 30%','2010-04-19 15:27:24',NULL,NULL,NULL,'>= usage 80','>= usage 60','2010-04-13 17:17:59','2010-04-19 15:28:13'),(216,'Disk - /usr','752f522c-46dd-11df-a64b-6cf0494e0fad',1,52,0,0,33,NULL,11,'check_disk_hr','check_disk_hr','host=${host.addr}&community=${host.community}&index=6',300,NULL,1,'2010-04-19 15:31:55','2010-04-19 15:36:55',3,30,NULL,NULL,NULL,0,2,'Usage of /usr: 36%','2010-04-19 15:31:55',NULL,NULL,NULL,'>= usage 80','>= usage 60','2010-04-13 17:18:01','2010-04-19 15:32:13'),(217,'sit0','ecab3ae6-46dd-11df-a64b-6cf0494e0fad',1,55,0,0,33,NULL,6,'check_if','check_if','host=${host.addr}&community=${host.community}&ifindex=6',300,NULL,1,'2010-04-19 15:29:01','2010-04-19 15:34:01',3,30,NULL,NULL,NULL,1,2,'sit0 is down.',NULL,'2010-04-19 15:29:01',NULL,NULL,NULL,NULL,'2010-04-13 17:21:21','2010-04-19 15:30:13'),(218,'eth0','7b2c5890-46de-11df-a64b-6cf0494e0fad',1,62,0,0,29,NULL,6,'check_if','check_if','host=${host.addr}&community=${host.community}&ifindex=2',300,NULL,1,'2010-04-19 15:31:54','2010-04-19 15:36:54',3,30,NULL,NULL,NULL,1,2,'eth0 is down.',NULL,'2010-04-19 15:31:54',NULL,NULL,NULL,NULL,'2010-04-13 17:25:20','2010-04-19 15:32:13'),(219,'eth1','7cbf30c4-46de-11df-a64b-6cf0494e0fad',1,62,0,0,29,NULL,6,'check_if','check_if','host=${host.addr}&community=${host.community}&ifindex=3',300,NULL,1,'2010-04-19 15:27:19','2010-04-19 15:32:19',3,30,NULL,NULL,NULL,1,2,'eth1 is down.',NULL,'2010-04-19 15:27:19',NULL,NULL,NULL,NULL,'2010-04-13 17:25:23','2010-04-19 15:28:13'),(220,'eth2','7db990b4-46de-11df-a64b-6cf0494e0fad',1,62,0,0,29,NULL,6,'check_if','check_if','host=${host.addr}&community=${host.community}&ifindex=4',300,NULL,1,'2010-04-19 15:30:59','2010-04-19 15:35:59',3,30,NULL,NULL,NULL,0,2,'eth2 is up.','2010-04-19 15:30:59',NULL,NULL,NULL,NULL,NULL,'2010-04-13 17:25:25','2010-04-19 15:32:13'),(221,'eth3','7ef91544-46de-11df-a64b-6cf0494e0fad',1,62,0,0,29,NULL,6,'check_if','check_if','host=${host.addr}&community=${host.community}&ifindex=5',300,NULL,1,'2010-04-19 15:28:10','2010-04-19 15:33:10',3,30,NULL,NULL,NULL,0,2,'eth3 is up.','2010-04-19 15:28:10',NULL,NULL,NULL,NULL,NULL,'2010-04-13 17:25:27','2010-04-19 15:28:13'),(222,'sit0','7fdaf932-46de-11df-a64b-6cf0494e0fad',1,62,0,0,29,NULL,6,'check_if','check_if','host=${host.addr}&community=${host.community}&ifindex=6',300,NULL,1,'2010-04-19 15:29:39','2010-04-19 15:34:39',3,30,NULL,NULL,NULL,1,2,'sit0 is down.',NULL,'2010-04-19 15:29:39',NULL,NULL,NULL,NULL,'2010-04-13 17:25:28','2010-04-19 15:30:13'),(223,'DiskIO - cciss/c0d0','80ce1838-46de-11df-a64b-6cf0494e0fad',1,62,0,0,29,NULL,12,'check_diskio_ucd','check_diskio_ucd','host=${host.addr}&community=${host.community}&index=17',300,NULL,1,'2010-04-19 15:29:50','2010-04-19 15:34:50',3,30,NULL,NULL,NULL,0,2,'cciss/c0d0: reads=0.00KB/s, writes=21.52KB/s','2010-04-19 15:29:50',NULL,NULL,NULL,NULL,NULL,'2010-04-13 17:25:30','2010-04-19 15:30:13'),(224,'DiskIO - cciss/c0d0p1','81a79fcc-46de-11df-a64b-6cf0494e0fad',1,62,0,0,29,NULL,12,'check_diskio_ucd','check_diskio_ucd','host=${host.addr}&community=${host.community}&index=18',300,NULL,1,'2010-04-19 15:29:22','2010-04-19 15:34:22',3,30,NULL,NULL,NULL,0,2,'cciss/c0d0p1: reads=0.00KB/s, writes=0.00KB/s','2010-04-19 15:29:22',NULL,NULL,NULL,NULL,NULL,'2010-04-13 17:25:31','2010-04-19 15:30:13'),(225,'DiskIO - cciss/c0d0p2','82a41234-46de-11df-a64b-6cf0494e0fad',1,62,0,0,29,NULL,12,'check_diskio_ucd','check_diskio_ucd','host=${host.addr}&community=${host.community}&index=19',300,NULL,1,'2010-04-19 15:29:14','2010-04-19 15:34:14',3,30,NULL,NULL,NULL,0,2,'cciss/c0d0p2: reads=0.00KB/s, writes=21.50KB/s','2010-04-19 15:29:14',NULL,NULL,NULL,NULL,NULL,'2010-04-13 17:25:33','2010-04-19 15:30:13'),(226,'DiskIO - dm-0','83e98dd6-46de-11df-a64b-6cf0494e0fad',1,62,0,0,29,NULL,12,'check_diskio_ucd','check_diskio_ucd','host=${host.addr}&community=${host.community}&index=20',300,NULL,1,'2010-04-19 15:31:50','2010-04-19 15:36:50',3,30,NULL,NULL,NULL,0,2,'dm-0: reads=0.00KB/s, writes=22.21KB/s','2010-04-19 15:31:50',NULL,NULL,'2010-04-16 00:03:41',NULL,NULL,'2010-04-13 17:25:35','2010-04-19 15:32:13'),(227,'DiskIO - dm-1','84ff361c-46de-11df-a64b-6cf0494e0fad',1,62,0,0,29,NULL,12,'check_diskio_ucd','check_diskio_ucd','host=${host.addr}&community=${host.community}&index=21',300,NULL,1,'2010-04-19 15:27:29','2010-04-19 15:32:29',3,30,NULL,NULL,NULL,0,2,'dm-1: reads=0.00KB/s, writes=0.00KB/s','2010-04-19 15:27:29',NULL,NULL,NULL,NULL,NULL,'2010-04-13 17:25:37','2010-04-19 15:28:13'),(228,'Disk - /','85d739c2-46de-11df-a64b-6cf0494e0fad',1,62,0,0,29,NULL,11,'check_disk_hr','check_disk_hr','host=${host.addr}&community=${host.community}&index=4',300,NULL,1,'2010-04-19 15:29:22','2010-04-19 15:34:22',3,30,NULL,NULL,NULL,0,2,'Usage of /: 13%','2010-04-19 15:29:22',NULL,NULL,NULL,'>= usage 80','>= usage 60','2010-04-13 17:25:38','2010-04-19 15:30:13'),(229,'Disk - /boot','869cac02-46de-11df-a64b-6cf0494e0fad',1,62,0,0,29,NULL,11,'check_disk_hr','check_disk_hr','host=${host.addr}&community=${host.community}&index=5',300,NULL,1,'2010-04-19 15:31:51','2010-04-19 15:36:51',3,30,NULL,NULL,NULL,0,2,'Usage of /boot: 12%','2010-04-19 15:31:51',NULL,NULL,'2010-04-16 00:03:31','>= usage 80','>= usage 60','2010-04-13 17:25:39','2010-04-19 15:32:13'),(230,'DiskIO - sda2','db8baa68-46e0-11df-a64b-6cf0494e0fad',1,52,0,0,33,NULL,12,'check_diskio_ucd','check_diskio_ucd','host=${host.addr}&community=${host.community}&index=19',300,NULL,1,'2010-04-19 15:30:00','2010-04-19 15:35:00',3,30,NULL,NULL,NULL,0,2,'sda2: reads=0.00KB/s, writes=0.33KB/s','2010-04-19 15:30:00',NULL,NULL,NULL,NULL,NULL,'2010-04-13 17:42:21','2010-04-19 15:30:13'),(231,'DiskIO - sda3','32ab709a-46ea-11df-a64b-6cf0494e0fad',1,52,0,0,33,NULL,12,'check_diskio_ucd','check_diskio_ucd','host=${host.addr}&community=${host.community}&index=20',300,NULL,1,'2010-04-19 15:31:55','2010-04-19 15:36:55',3,30,NULL,NULL,NULL,0,2,'sda3: reads=0.00KB/s, writes=0.00KB/s','2010-04-19 15:31:55',NULL,NULL,NULL,NULL,NULL,'2010-04-13 18:49:13','2010-04-19 15:32:13'),(232,'DiskIO - sda5','345b7fd4-46ea-11df-a64b-6cf0494e0fad',1,52,0,0,33,NULL,12,'check_diskio_ucd','check_diskio_ucd','host=${host.addr}&community=${host.community}&index=22',300,NULL,1,'2010-04-19 15:29:18','2010-04-19 15:34:18',3,30,NULL,NULL,NULL,0,2,'sda5: reads=9.78KB/s, writes=585.54KB/s','2010-04-19 15:29:18',NULL,NULL,NULL,NULL,NULL,'2010-04-13 18:49:15','2010-04-19 15:30:13'),(233,'DiskIO - sda4','35de357c-46ea-11df-a64b-6cf0494e0fad',1,52,0,0,33,NULL,12,'check_diskio_ucd','check_diskio_ucd','host=${host.addr}&community=${host.community}&index=21',300,NULL,1,'2010-04-19 15:28:21','2010-04-19 15:33:21',3,30,NULL,NULL,NULL,0,2,'sda4: reads=0.00KB/s, writes=0.00KB/s','2010-04-19 15:28:21',NULL,NULL,NULL,NULL,NULL,'2010-04-13 18:49:18','2010-04-19 15:30:13'),(234,'DiskIO - sda2','36eb34a6-46ea-11df-a64b-6cf0494e0fad',1,56,0,0,33,NULL,12,'check_diskio_ucd','check_diskio_ucd','host=${host.addr}&community=${host.community}&index=19',300,NULL,1,'2010-04-19 15:28:41','2010-04-19 15:33:41',3,30,NULL,NULL,NULL,0,2,'sda2: reads=0.00KB/s, writes=0.05KB/s','2010-04-19 15:28:41',NULL,NULL,NULL,NULL,NULL,'2010-04-13 18:49:20','2010-04-19 15:30:13'),(235,'DiskIO - sda3','383f5544-46ea-11df-a64b-6cf0494e0fad',1,56,0,0,33,NULL,12,'check_diskio_ucd','check_diskio_ucd','host=${host.addr}&community=${host.community}&index=20',300,NULL,1,'2010-04-19 15:31:42','2010-04-19 15:36:42',3,30,NULL,NULL,NULL,0,2,'sda3: reads=0.22KB/s, writes=0.00KB/s','2010-04-19 15:31:42',NULL,NULL,NULL,NULL,NULL,'2010-04-13 18:49:22','2010-04-19 15:32:13'),(236,'DiskIO - sda4','3a3034c2-46ea-11df-a64b-6cf0494e0fad',1,56,0,0,33,NULL,12,'check_diskio_ucd','check_diskio_ucd','host=${host.addr}&community=${host.community}&index=21',300,NULL,1,'2010-04-19 15:28:51','2010-04-19 15:33:51',3,30,NULL,NULL,NULL,0,2,'sda4: reads=0.00KB/s, writes=0.00KB/s','2010-04-19 15:28:51',NULL,NULL,NULL,NULL,NULL,'2010-04-13 18:49:25','2010-04-19 15:30:13'),(237,'DiskIO - sda5','3b6f13ee-46ea-11df-a64b-6cf0494e0fad',1,56,0,0,33,NULL,12,'check_diskio_ucd','check_diskio_ucd','host=${host.addr}&community=${host.community}&index=22',300,NULL,1,'2010-04-19 15:30:35','2010-04-19 15:35:35',3,30,NULL,NULL,NULL,0,2,'sda5: reads=0.00KB/s, writes=2.29KB/s','2010-04-19 15:30:35',NULL,NULL,NULL,NULL,NULL,'2010-04-13 18:49:27','2010-04-19 15:32:13'),(238,'DiskIO - sdd1','3c963dec-46ea-11df-a64b-6cf0494e0fad',1,56,0,0,33,NULL,12,'check_diskio_ucd','check_diskio_ucd','host=${host.addr}&community=${host.community}&index=26',300,NULL,1,'2010-04-19 15:27:36','2010-04-19 15:32:36',3,30,NULL,NULL,NULL,0,2,'sdd1: reads=0.00KB/s, writes=0.00KB/s','2010-04-19 15:27:36',NULL,NULL,NULL,NULL,NULL,'2010-04-13 18:49:29','2010-04-19 15:28:13'),(239,'DiskIO - sda2','3ef0edbc-46ea-11df-a64b-6cf0494e0fad',1,55,0,0,33,NULL,12,'check_diskio_ucd','check_diskio_ucd','host=${host.addr}&community=${host.community}&index=19',300,NULL,1,'2010-04-19 15:30:55','2010-04-19 15:35:55',3,30,NULL,NULL,NULL,0,2,'sda2: reads=0.00KB/s, writes=0.00KB/s','2010-04-19 15:30:55',NULL,NULL,NULL,NULL,NULL,'2010-04-13 18:49:33','2010-04-19 15:32:13'),(240,'DiskIO - sda3','3fe3d0a4-46ea-11df-a64b-6cf0494e0fad',1,55,0,0,33,NULL,12,'check_diskio_ucd','check_diskio_ucd','host=${host.addr}&community=${host.community}&index=20',300,NULL,1,'2010-04-19 15:28:31','2010-04-19 15:33:31',3,30,NULL,NULL,NULL,0,2,'sda3: reads=0.00KB/s, writes=0.00KB/s','2010-04-19 15:28:31',NULL,NULL,NULL,NULL,NULL,'2010-04-13 18:49:35','2010-04-19 15:30:13'),(241,'DiskIO - sda4','40c700c2-46ea-11df-a64b-6cf0494e0fad',1,55,0,0,33,NULL,12,'check_diskio_ucd','check_diskio_ucd','host=${host.addr}&community=${host.community}&index=21',300,NULL,1,'2010-04-19 15:31:01','2010-04-19 15:36:01',3,30,NULL,NULL,NULL,0,2,'sda4: reads=0.00KB/s, writes=0.00KB/s','2010-04-19 15:31:01',NULL,NULL,NULL,NULL,NULL,'2010-04-13 18:49:36','2010-04-19 15:32:13'),(242,'DiskIO - sda5','444713b8-46ea-11df-a64b-6cf0494e0fad',1,55,0,0,33,NULL,12,'check_diskio_ucd','check_diskio_ucd','host=${host.addr}&community=${host.community}&index=22',300,NULL,1,'2010-04-19 15:27:45','2010-04-19 15:32:45',3,30,NULL,NULL,NULL,0,2,'sda5: reads=0.00KB/s, writes=0.70KB/s','2010-04-19 15:27:45',NULL,NULL,NULL,NULL,NULL,'2010-04-13 18:49:42','2010-04-19 15:28:13'),(243,'eth3','1f25c2ae-476d-11df-a64b-6cf0494e0fad',1,52,0,0,33,NULL,6,'check_if','check_if','host=${host.addr}&community=${host.community}&ifindex=5',300,NULL,1,'2010-04-19 15:28:03','2010-04-19 15:33:03',3,30,NULL,NULL,NULL,1,2,'eth3 is down.',NULL,'2010-04-19 15:28:03',NULL,NULL,NULL,NULL,'2010-04-14 10:26:24','2010-04-19 15:28:13'),(244,'eth1','213cd71c-476d-11df-a64b-6cf0494e0fad',1,52,0,0,33,NULL,6,'check_if','check_if','host=${host.addr}&community=${host.community}&ifindex=3',300,NULL,1,'2010-04-19 15:30:15','2010-04-19 15:35:15',3,30,NULL,NULL,NULL,1,2,'eth1 is down.',NULL,'2010-04-19 15:30:15',NULL,NULL,NULL,NULL,'2010-04-14 10:26:27','2010-04-19 15:32:13'),(245,'eth2','225ca780-476d-11df-a64b-6cf0494e0fad',1,52,0,0,33,NULL,6,'check_if','check_if','host=${host.addr}&community=${host.community}&ifindex=4',300,NULL,1,'2010-04-19 15:31:48','2010-04-19 15:36:48',3,30,NULL,NULL,NULL,1,2,'eth2 is down.',NULL,'2010-04-19 15:31:48',NULL,NULL,NULL,NULL,'2010-04-14 10:26:29','2010-04-19 15:32:13'),(246,'eth1','4e704de0-476d-11df-a64b-6cf0494e0fad',1,56,0,0,33,NULL,6,'check_if','check_if','host=${host.addr}&community=${host.community}&ifindex=3',300,NULL,1,'2010-04-19 15:28:19','2010-04-19 15:33:19',3,30,NULL,NULL,NULL,0,2,'eth1 is up.','2010-04-19 15:28:19',NULL,NULL,NULL,NULL,NULL,'2010-04-14 10:27:43','2010-04-19 15:30:13'),(247,'eth2','4f11c0f8-476d-11df-a64b-6cf0494e0fad',1,56,0,0,33,NULL,6,'check_if','check_if','host=${host.addr}&community=${host.community}&ifindex=4',300,NULL,1,'2010-04-19 15:31:34','2010-04-19 15:36:34',3,30,NULL,NULL,NULL,1,2,'eth2 is down.',NULL,'2010-04-19 15:31:34',NULL,NULL,NULL,NULL,'2010-04-14 10:27:44','2010-04-19 15:32:13'),(248,'eth3','4f8bfe04-476d-11df-a64b-6cf0494e0fad',1,56,0,0,33,NULL,6,'check_if','check_if','host=${host.addr}&community=${host.community}&ifindex=5',300,NULL,1,'2010-04-19 15:31:46','2010-04-19 15:36:46',3,30,NULL,NULL,NULL,1,2,'eth3 is down.',NULL,'2010-04-19 15:31:46',NULL,NULL,NULL,NULL,'2010-04-14 10:27:45','2010-04-19 15:32:13'),(249,'磁盘监测 - Shell','3c049c22-476f-11df-a64b-6cf0494e0fad',1,63,0,1,1,16,3,'check_disk_df','check_disk_df','path=/',300,NULL,1,'2010-04-16 08:47:19','2010-04-16 08:52:19',3,30,NULL,NULL,NULL,0,2,'Disk \'/\' usage = 59%','2010-04-16 08:47:55',NULL,NULL,NULL,NULL,NULL,'2010-04-14 10:41:31','2010-04-16 08:47:55'),(250,'CPU监测 - Shell','4bdc3aec-476f-11df-a64b-6cf0494e0fad',1,63,0,1,1,16,5,'check_cpu_top','check_cpu_top','',300,NULL,1,'2010-04-16 08:47:15','2010-04-16 08:52:15',3,30,NULL,NULL,NULL,0,2,'Cpu(s):  1.8%us,  2.3%sy,  0.0%ni, 95.0%id,  0.8%wa,  0.0%hi,  0.1%si,  0.0%st','2010-04-16 08:47:51',NULL,NULL,NULL,NULL,NULL,'2010-04-14 10:41:58','2010-04-16 08:47:51'),(251,'负载监测 - Shell','51bce92a-476f-11df-a64b-6cf0494e0fad',1,63,0,1,1,16,4,'check_load','check_load','',300,NULL,1,'2010-04-16 08:44:48','2010-04-16 08:49:48',3,30,NULL,NULL,NULL,0,2,'load average: 0.42%, 0.44%, 0.45%','2010-04-16 08:45:24',NULL,NULL,NULL,'| (& (>= load1 30) (<= load1 50)) (>= load5 15) (>= load15 10)','| (& (>= load1 20) (<= load1 50)) (>= load5 15) (>= load15 10)','2010-04-14 10:42:08','2010-04-16 08:45:24'),(252,'PING监测','576806ca-476f-11df-a64b-6cf0494e0fad',1,63,1,1,1,16,1,'check_ping','check_ping','host=${host.addr}',300,NULL,1,'2010-04-16 08:44:25','2010-04-16 08:49:25',3,30,NULL,NULL,NULL,0,2,'Packet loss = 0%, RTA = 0.041ms','2010-04-16 08:45:04',NULL,NULL,NULL,'>= pl 100','>= pl 50','2010-04-14 10:42:17','2010-04-16 08:45:04'),(253,'Swap监测 - Shell','617727ea-476f-11df-a64b-6cf0494e0fad',1,63,0,1,1,16,8,'check_swap_free','check_swap_free','',300,NULL,1,'2010-04-16 08:47:13','2010-04-16 08:52:13',3,30,NULL,NULL,NULL,0,2,'swap usage = 0%','2010-04-16 08:47:49',NULL,NULL,NULL,NULL,NULL,'2010-04-14 10:42:34','2010-04-16 08:47:49'),(255,'PING监测','b67ad0f4-4772-11df-a64b-6cf0494e0fad',1,64,1,1,1,16,31,'check_ping','check_ping','host=${host.addr}',300,NULL,1,'2010-04-16 08:44:15','2010-04-16 08:49:15',3,30,NULL,NULL,NULL,0,2,'Packet loss = 0%, RTA = 0.219ms','2010-04-16 08:44:54',NULL,'2010-04-15 14:04:30',NULL,NULL,NULL,'2010-04-14 11:06:25','2010-04-16 08:44:54'),(256,'eth0','d3fee7b8-4773-11df-a64b-6cf0494e0fad',1,63,0,0,1,16,6,'check_if','check_if','host=${host.addr}&community=${host.community}&ifindex=2',300,NULL,1,'2010-04-16 08:48:15','2010-04-16 08:53:15',3,30,NULL,NULL,NULL,0,2,'eth0 is up.','2010-04-16 08:48:50',NULL,NULL,NULL,NULL,NULL,'2010-04-14 11:14:24','2010-04-16 08:48:50'),(257,'eth1','038455e0-4774-11df-a64b-6cf0494e0fad',1,63,0,0,1,16,6,'check_if','check_if','host=${host.addr}&community=${host.community}&ifindex=3',300,NULL,1,'2010-04-16 08:48:23','2010-04-16 08:53:23',3,30,NULL,NULL,NULL,1,2,'Admin Status = DOWN, Oper Status = DOWN',NULL,'2010-04-16 08:48:59',NULL,NULL,NULL,NULL,'2010-04-14 11:15:44','2010-04-16 08:48:59'),(258,'eth2','04e549bc-4774-11df-a64b-6cf0494e0fad',1,63,0,0,1,16,6,'check_if','check_if','host=${host.addr}&community=${host.community}&ifindex=4',300,NULL,1,'2010-04-16 08:48:25','2010-04-16 08:53:25',3,30,NULL,NULL,NULL,1,2,'Admin Status = DOWN, Oper Status = DOWN',NULL,'2010-04-16 08:49:01',NULL,NULL,NULL,NULL,'2010-04-14 11:15:46','2010-04-16 08:49:01'),(260,'vmnet8','09a9a894-4774-11df-a64b-6cf0494e0fad',1,63,0,0,1,16,6,'check_if','check_if','host=${host.addr}&community=${host.community}&ifindex=92',300,NULL,1,'2010-04-16 08:48:05','2010-04-16 08:53:05',3,30,NULL,NULL,NULL,0,2,'vmnet8 is up.','2010-04-16 08:48:41',NULL,NULL,NULL,NULL,NULL,'2010-04-14 11:15:54','2010-04-16 08:48:41'),(261,'sit0','0ab14940-4774-11df-a64b-6cf0494e0fad',1,63,0,0,1,16,6,'check_if','check_if','host=${host.addr}&community=${host.community}&ifindex=6',300,NULL,1,'2010-04-16 08:45:56','2010-04-16 08:50:56',3,30,NULL,NULL,NULL,1,2,'Admin Status = DOWN, Oper Status = DOWN',NULL,'2010-04-16 08:46:31',NULL,NULL,NULL,NULL,'2010-04-14 11:15:56','2010-04-16 08:46:31'),(262,'DiskIO - sda','1789aa36-4774-11df-a64b-6cf0494e0fad',1,63,0,0,1,16,12,'check_diskio_ucd','check_diskio_ucd','host=${host.addr}&community=${host.community}&index=17',300,NULL,1,'2010-04-16 08:46:09','2010-04-16 08:51:09',3,30,NULL,NULL,NULL,0,2,'sda: reads=6421126, writes=136386558','2010-04-16 08:46:45',NULL,NULL,NULL,NULL,NULL,'2010-04-14 11:16:18','2010-04-16 08:46:45'),(263,'DiskIO - sda1','18e9ad72-4774-11df-a64b-6cf0494e0fad',1,63,0,0,1,16,12,'check_diskio_ucd','check_diskio_ucd','host=${host.addr}&community=${host.community}&index=18',300,NULL,1,'2010-04-16 08:45:05','2010-04-16 08:50:05',3,30,NULL,NULL,NULL,0,2,'sda1: reads=5841357, writes=136273901','2010-04-16 08:45:41',NULL,NULL,NULL,NULL,NULL,'2010-04-14 11:16:20','2010-04-16 08:45:41'),(264,'DiskIO - sda2','1a15e56c-4774-11df-a64b-6cf0494e0fad',1,63,0,0,1,16,12,'check_diskio_ucd','check_diskio_ucd','host=${host.addr}&community=${host.community}&index=19',300,NULL,1,'2010-04-16 08:46:30','2010-04-16 08:51:30',3,30,NULL,NULL,NULL,0,2,'sda2: reads=210547, writes=37976','2010-04-16 08:47:05',NULL,NULL,NULL,NULL,NULL,'2010-04-14 11:16:22','2010-04-16 08:47:05'),(265,'DiskIO - sda3','1b3e27b0-4774-11df-a64b-6cf0494e0fad',1,63,0,0,1,16,12,'check_diskio_ucd','check_diskio_ucd','host=${host.addr}&community=${host.community}&index=20',300,NULL,1,'2010-04-16 08:47:31','2010-04-16 08:52:31',3,30,NULL,NULL,NULL,0,2,'sda3: reads=369170, writes=74681','2010-04-16 08:48:06',NULL,NULL,NULL,NULL,NULL,'2010-04-14 11:16:24','2010-04-16 08:48:06'),(266,'DiskIO - sdb','1c4afcf0-4774-11df-a64b-6cf0494e0fad',1,63,0,0,1,16,12,'check_diskio_ucd','check_diskio_ucd','host=${host.addr}&community=${host.community}&index=21',300,NULL,1,'2010-04-16 08:47:35','2010-04-16 08:52:35',3,30,NULL,NULL,NULL,0,2,'sdb: reads=890864, writes=13366765','2010-04-16 08:48:10',NULL,NULL,NULL,NULL,NULL,'2010-04-14 11:16:26','2010-04-16 08:48:10'),(267,'DiskIO - sdb1','1ef6d7ee-4774-11df-a64b-6cf0494e0fad',1,63,0,0,1,16,12,'check_diskio_ucd','check_diskio_ucd','host=${host.addr}&community=${host.community}&index=22',300,NULL,1,'2010-04-16 08:47:05','2010-04-16 08:52:05',3,30,NULL,NULL,NULL,0,2,'sdb1: reads=889293, writes=13365917','2010-04-16 08:47:41',NULL,NULL,NULL,NULL,NULL,'2010-04-14 11:16:30','2010-04-16 08:47:41'),(268,'DiskIO - sdb2','2009a6e8-4774-11df-a64b-6cf0494e0fad',1,63,0,0,1,16,12,'check_diskio_ucd','check_diskio_ucd','host=${host.addr}&community=${host.community}&index=23',300,NULL,1,'2010-04-16 08:46:04','2010-04-16 08:51:04',3,30,NULL,NULL,NULL,0,2,'sdb2: reads=280, writes=12','2010-04-16 08:46:40',NULL,NULL,NULL,NULL,NULL,'2010-04-14 11:16:32','2010-04-16 08:46:40'),(269,'Disk - /opt/stg1','220e6d70-4774-11df-a64b-6cf0494e0fad',1,63,0,0,1,16,11,'check_disk_hr','check_disk_hr','host=${host.addr}&community=${host.community}&index=6',300,NULL,1,'2010-04-16 08:44:35','2010-04-16 08:49:35',3,30,NULL,NULL,NULL,0,2,'Usage of /opt/stg1: 31%','2010-04-16 08:45:11',NULL,NULL,NULL,'>= usage 80','>= usage 60','2010-04-14 11:16:35','2010-04-16 08:45:11'),(270,'Disk - /home','2360b638-4774-11df-a64b-6cf0494e0fad',1,63,0,0,1,16,11,'check_disk_hr','check_disk_hr','host=${host.addr}&community=${host.community}&index=5',300,NULL,1,'2010-04-16 08:46:46','2010-04-16 08:51:46',3,30,NULL,NULL,NULL,0,2,'Usage of /home: 46%','2010-04-16 08:47:21',NULL,NULL,NULL,'>= usage 80','>= usage 60','2010-04-14 11:16:37','2010-04-16 08:47:21'),(271,'Disk - /','24920372-4774-11df-a64b-6cf0494e0fad',1,63,0,0,1,16,11,'check_disk_hr','check_disk_hr','host=${host.addr}&community=${host.community}&index=4',300,NULL,1,'2010-04-16 08:45:08','2010-04-16 08:50:08',3,30,NULL,NULL,NULL,0,2,'Usage of /: 55%','2010-04-16 08:45:43',NULL,NULL,NULL,'>= usage 80','>= usage 60','2010-04-14 11:16:39','2010-04-16 08:45:43'),(272,'DiskIO - sdb3','26626fb6-4774-11df-a64b-6cf0494e0fad',1,63,0,0,1,16,12,'check_diskio_ucd','check_diskio_ucd','host=${host.addr}&community=${host.community}&index=24',300,NULL,1,'2010-04-16 08:47:06','2010-04-16 08:52:06',3,30,NULL,NULL,NULL,0,2,'sdb3: reads=928, writes=836','2010-04-16 08:47:42',NULL,NULL,NULL,NULL,NULL,'2010-04-14 11:16:43','2010-04-16 08:47:42'),(273,'Disk - /opt/stg2','29ddb7ae-4774-11df-a64b-6cf0494e0fad',1,63,0,0,1,16,11,'check_disk_hr','check_disk_hr','host=${host.addr}&community=${host.community}&index=7',300,NULL,1,'2010-04-16 08:48:30','2010-04-16 08:53:30',3,30,NULL,NULL,NULL,0,2,'Usage of /opt/stg2: 2%','2010-04-16 08:49:05',NULL,NULL,NULL,'>= usage 80','>= usage 60','2010-04-14 11:16:48','2010-04-16 08:49:05'),(274,'Disk - /opt/stg3','2a709150-4774-11df-a64b-6cf0494e0fad',1,63,0,0,1,16,11,'check_disk_hr','check_disk_hr','host=${host.addr}&community=${host.community}&index=8',300,NULL,1,'2010-04-16 08:45:05','2010-04-16 08:50:05',3,30,NULL,NULL,NULL,0,2,'Usage of /opt/stg3: 12%','2010-04-16 08:45:41',NULL,NULL,NULL,'>= usage 80','>= usage 60','2010-04-14 11:16:49','2010-04-16 08:45:41'),(275,'进程总数监测','79f71cdc-4777-11df-a64b-6cf0494e0fad',1,64,0,0,1,16,29,'check_task_hr','check_task_hr','host=${host.addr}&community=${host.community}',300,NULL,1,'2010-04-16 08:46:07','2010-04-16 08:51:07',3,30,NULL,NULL,NULL,0,2,'Total Processes: 40','2010-04-16 08:46:43',NULL,NULL,'2010-04-14 18:21:42','> total 200','> total 100','2010-04-14 11:40:31','2010-04-16 08:46:43'),(276,'CPU - 2','7b09108a-4777-11df-a64b-6cf0494e0fad',1,64,0,0,1,16,26,'check_cpu_hr','check_cpu_hr','host=${host.addr}&community=${host.community}&index=2',300,NULL,1,'2010-04-16 08:47:33','2010-04-16 08:52:33',3,30,NULL,NULL,NULL,1,2,'CPU Load: 35%','2010-04-16 08:32:08','2010-04-16 08:48:09','2010-04-16 06:39:08','2010-04-15 14:05:21','> load 60','> load 30','2010-04-14 11:40:33','2010-04-16 08:48:09'),(277,'Physical Memory','7bc5aa42-4777-11df-a64b-6cf0494e0fad',1,64,0,0,1,16,27,'check_mem_hr','check_mem_hr','host=${host.addr}&community=${host.community}&index=5',300,NULL,1,'2010-04-16 08:46:21','2010-04-16 08:51:21',3,30,NULL,NULL,NULL,1,2,'Physical Memory usage: 85%','2010-04-16 08:25:56','2010-04-16 08:46:56','2010-04-15 11:54:48','2010-04-15 14:06:40','> usage 90','> usage 80','2010-04-14 11:40:34','2010-04-16 08:46:56'),(278,'Virtual Memory','1e49ddaa-4779-11df-a64b-6cf0494e0fad',1,64,0,0,1,16,28,'check_virmem_hr','check_virmem_hr','community=${host.community}&host=${host.addr}&index=4',300,NULL,1,'2010-04-16 08:48:31','2010-04-16 08:53:31',3,30,NULL,NULL,NULL,2,2,'Virtual Memory Usage: 87%',NULL,NULL,'2010-04-16 08:49:10','2010-04-15 14:04:49','> usage 90','> usage 60','2010-04-14 11:52:16','2010-04-16 15:29:30'),(279,'Disk - F:','b26f0a30-477b-11df-a64b-6cf0494e0fad',1,64,0,0,1,16,11,'check_disk_hr','check_disk_hr','community=${host.community}&host=${host.addr}&index=3',1800,NULL,1,'2010-04-16 08:20:28','2010-04-16 08:50:28',3,30,NULL,NULL,NULL,0,2,'Usage of F:\\ Label:F  Serial Number 40bd5347: 7%','2010-04-16 08:21:04',NULL,NULL,'2010-04-15 14:06:16','>= usage 80','>= usage 60','2010-04-14 12:10:44','2010-04-16 08:21:04'),(280,'Disk - C:','b43078a4-477b-11df-a64b-6cf0494e0fad',1,64,0,0,1,16,11,'check_disk_hr','check_disk_hr','host=${host.addr}&community=${host.community}&index=1',300,NULL,1,'2010-04-16 08:46:09','2010-04-16 08:51:09',3,30,NULL,NULL,NULL,0,2,'Usage of C:\\ Label:C  Serial Number 1c0a6472: 45%','2010-04-16 08:46:45',NULL,NULL,'2010-04-14 18:21:43','>= usage 80','>= usage 60','2010-04-14 12:10:47','2010-04-16 08:46:45'),(281,'磁盘监测 - SNMP','ab27b950-4782-11df-a64b-6cf0494e0fad',1,57,0,0,10,NULL,11,'check_disk_hr','check_disk_hr','community=${host.community}&host=${host.addr}&index=1',1800,NULL,1,'2010-04-19 15:03:30','2010-04-19 15:33:30',3,30,NULL,NULL,NULL,0,2,'Usage of Memory Buffers: 8%','2010-04-19 15:03:30',NULL,NULL,'2010-04-16 11:30:25','>= usage 86','>= usage 60','2010-04-14 13:00:38','2010-04-19 15:04:13'),(282,'磁盘IO监测 - SNMP','0c892f76-4783-11df-a64b-6cf0494e0fad',1,57,0,0,10,NULL,12,'check_diskio_ucd','check_diskio_ucd','community=${host.community}&host=${host.addr}&index=1',1800,NULL,1,'2010-04-19 15:05:56','2010-04-19 15:35:56',3,30,NULL,NULL,NULL,0,2,'ram0: reads=0.00KB/s, writes=0.00KB/s','2010-04-19 15:05:56',NULL,NULL,'2010-04-15 17:44:18',NULL,NULL,'2010-04-14 13:03:22','2010-04-19 15:06:13'),(283,'Disk - D:','51905b5c-4784-11df-a64b-6cf0494e0fad',1,64,0,0,1,16,11,'check_disk_hr','check_disk_hr','host=${host.addr}&community=${host.community}&index=2',300,NULL,1,'2010-04-16 08:44:10','2010-04-16 08:49:10',3,30,NULL,NULL,NULL,0,2,'Usage of D:\\ Label:D  Serial Number f4eb54d6: 14%','2010-04-16 08:44:46',NULL,NULL,'2010-04-15 14:04:29','>= usage 80','>= usage 60','2010-04-14 13:12:27','2010-04-16 08:44:46'),(284,'sit0','852d8056-479e-11df-a64b-6cf0494e0fad',1,53,0,0,33,NULL,6,'check_if','check_if','host=${host.addr}&community=${host.community}&ifindex=6',300,NULL,1,'2010-04-19 15:28:34','2010-04-19 15:33:34',3,30,NULL,NULL,NULL,1,2,'sit0 is down.',NULL,'2010-04-19 15:28:34',NULL,NULL,NULL,NULL,'2010-04-14 16:20:00','2010-04-19 15:30:13'),(285,'eth0','875e0cec-479e-11df-a64b-6cf0494e0fad',1,53,0,0,33,NULL,6,'check_if','check_if','host=${host.addr}&community=${host.community}&ifindex=2',300,NULL,1,'2010-04-19 15:30:24','2010-04-19 15:35:24',3,30,NULL,NULL,NULL,0,2,'eth0 is up.','2010-04-19 15:30:24',NULL,NULL,NULL,NULL,NULL,'2010-04-14 16:20:04','2010-04-19 15:32:13'),(286,'DiskIO - sda','88ca0f2c-479e-11df-a64b-6cf0494e0fad',1,53,0,0,33,NULL,12,'check_diskio_ucd','check_diskio_ucd','host=${host.addr}&community=${host.community}&index=17',300,NULL,1,'2010-04-19 15:31:41','2010-04-19 15:36:41',3,30,NULL,NULL,NULL,0,2,'sda: reads=0.00KB/s, writes=51.20KB/s','2010-04-19 15:31:41',NULL,NULL,NULL,NULL,NULL,'2010-04-14 16:20:06','2010-04-19 15:32:13'),(287,'DiskIO - sda1','8a8c360a-479e-11df-a64b-6cf0494e0fad',1,53,0,0,33,NULL,12,'check_diskio_ucd','check_diskio_ucd','host=${host.addr}&community=${host.community}&index=18',300,NULL,1,'2010-04-19 15:27:35','2010-04-19 15:32:35',3,30,NULL,NULL,NULL,0,2,'sda1: reads=0.00KB/s, writes=12.17KB/s','2010-04-19 15:27:35',NULL,NULL,NULL,NULL,NULL,'2010-04-14 16:20:09','2010-04-19 15:28:13'),(288,'Disk - /','8c103968-479e-11df-a64b-6cf0494e0fad',1,53,0,0,33,NULL,11,'check_disk_hr','check_disk_hr','host=${host.addr}&community=${host.community}&index=4',300,NULL,1,'2010-04-19 15:29:21','2010-04-19 15:34:21',3,30,NULL,NULL,NULL,0,2,'Usage of /: 9%','2010-04-19 15:29:21',NULL,NULL,NULL,'>= usage 80','>= usage 60','2010-04-14 16:20:12','2010-04-19 15:30:13'),(289,'Disk - /opt','8d5a2ea0-479e-11df-a64b-6cf0494e0fad',1,53,0,0,33,NULL,11,'check_disk_hr','check_disk_hr','host=${host.addr}&community=${host.community}&index=5',300,NULL,1,'2010-04-19 15:31:16','2010-04-19 15:36:16',3,30,NULL,NULL,NULL,0,2,'Usage of /opt: 4%','2010-04-19 15:31:16',NULL,NULL,NULL,'>= usage 80','>= usage 60','2010-04-14 16:20:14','2010-04-19 15:32:13'),(290,'Disk - /usr','8f931e0c-479e-11df-a64b-6cf0494e0fad',1,53,0,0,33,NULL,11,'check_disk_hr','check_disk_hr','host=${host.addr}&community=${host.community}&index=6',300,NULL,1,'2010-04-19 15:28:53','2010-04-19 15:33:53',3,30,NULL,NULL,NULL,0,2,'Usage of /usr: 30%','2010-04-19 15:28:53',NULL,NULL,NULL,'>= usage 80','>= usage 60','2010-04-14 16:20:18','2010-04-19 15:30:13'),(291,'PING监测','a1330e7e-479e-11df-a64b-6cf0494e0fad',1,48,1,1,30,NULL,1,'check_ping','check_ping','host=${host.addr}',300,NULL,1,'2010-04-19 15:28:00','2010-04-19 15:33:00',3,30,NULL,NULL,NULL,0,2,'Packet loss = 0%, RTA = 43.747ms','2010-04-19 15:28:00','2010-04-17 02:21:53',NULL,NULL,'>= pl 100','>= pl 50','2010-04-14 16:20:47','2010-04-19 15:28:13'),(292,'DiskIO - sda','7d2082a4-479f-11df-a64b-6cf0494e0fad',1,54,0,0,33,NULL,12,'check_diskio_ucd','check_diskio_ucd','host=${host.addr}&community=${host.community}&index=17',300,NULL,1,'2010-04-19 15:32:00','2010-04-19 15:37:00',3,30,NULL,NULL,NULL,0,2,'sda: reads=0.00KB/s, writes=55.05KB/s','2010-04-19 15:32:00',NULL,NULL,NULL,NULL,NULL,'2010-04-14 16:26:56','2010-04-19 15:32:13'),(293,'DiskIO - sda1','7e3933ca-479f-11df-a64b-6cf0494e0fad',1,54,0,0,33,NULL,12,'check_diskio_ucd','check_diskio_ucd','host=${host.addr}&community=${host.community}&index=18',300,NULL,1,'2010-04-19 15:28:04','2010-04-19 15:33:04',3,30,NULL,NULL,NULL,0,2,'sda1: reads=0.00KB/s, writes=12.12KB/s','2010-04-19 15:28:04',NULL,NULL,NULL,NULL,NULL,'2010-04-14 16:26:58','2010-04-19 15:28:13'),(294,'Disk - /','7f9f5c80-479f-11df-a64b-6cf0494e0fad',1,54,0,0,33,NULL,11,'check_disk_hr','check_disk_hr','host=${host.addr}&community=${host.community}&index=4',300,NULL,1,'2010-04-19 15:30:14','2010-04-19 15:35:14',3,30,NULL,NULL,NULL,0,2,'Usage of /: 7%','2010-04-19 15:30:14',NULL,NULL,NULL,'>= usage 80','>= usage 60','2010-04-14 16:27:01','2010-04-19 15:32:13'),(295,'Disk - /opt','81a82a48-479f-11df-a64b-6cf0494e0fad',1,54,0,0,33,NULL,11,'check_disk_hr','check_disk_hr','host=${host.addr}&community=${host.community}&index=5',300,NULL,1,'2010-04-19 15:30:22','2010-04-19 15:35:22',3,30,NULL,NULL,NULL,0,2,'Usage of /opt: 5%','2010-04-19 15:30:22',NULL,NULL,NULL,'>= usage 80','>= usage 60','2010-04-14 16:27:04','2010-04-19 15:32:13'),(296,'Disk - /usr','83037fc8-479f-11df-a64b-6cf0494e0fad',1,54,0,0,33,NULL,11,'check_disk_hr','check_disk_hr','host=${host.addr}&community=${host.community}&index=6',300,NULL,1,'2010-04-19 15:29:28','2010-04-19 15:34:28',3,30,NULL,NULL,NULL,0,2,'Usage of /usr: 30%','2010-04-19 15:29:28',NULL,NULL,NULL,'>= usage 80','>= usage 60','2010-04-14 16:27:06','2010-04-19 15:30:13'),(297,'eth0','846843bc-479f-11df-a64b-6cf0494e0fad',1,54,0,0,33,NULL,6,'check_if','check_if','host=${host.addr}&community=${host.community}&ifindex=2',300,NULL,1,'2010-04-19 15:28:12','2010-04-19 15:33:12',3,30,NULL,NULL,NULL,0,2,'eth0 is up.','2010-04-19 15:28:12',NULL,NULL,NULL,NULL,NULL,'2010-04-14 16:27:09','2010-04-19 15:28:13'),(298,'sit0','85ca8616-479f-11df-a64b-6cf0494e0fad',1,54,0,0,33,NULL,6,'check_if','check_if','host=${host.addr}&community=${host.community}&ifindex=6',300,NULL,1,'2010-04-19 15:30:37','2010-04-19 15:35:37',3,30,NULL,NULL,NULL,1,2,'sit0 is down.',NULL,'2010-04-19 15:30:37',NULL,NULL,NULL,NULL,'2010-04-14 16:27:11','2010-04-19 15:32:13'),(299,'DiskIO - sda','debefeaa-479f-11df-a64b-6cf0494e0fad',1,50,0,0,33,NULL,12,'check_diskio_ucd','check_diskio_ucd','host=${host.addr}&community=${host.community}&index=17',300,NULL,1,'2010-04-19 15:28:13','2010-04-19 15:33:13',3,30,NULL,NULL,NULL,0,2,'sda: reads=0.01KB/s, writes=259.56KB/s','2010-04-19 15:28:13',NULL,NULL,NULL,NULL,NULL,'2010-04-14 16:29:40','2010-04-19 15:28:13'),(300,'DiskIO - sda1','dfdeb8f2-479f-11df-a64b-6cf0494e0fad',1,50,0,0,33,NULL,12,'check_diskio_ucd','check_diskio_ucd','host=${host.addr}&community=${host.community}&index=18',300,NULL,1,'2010-04-19 15:27:44','2010-04-19 15:32:44',3,30,NULL,NULL,NULL,0,2,'sda1: reads=0.00KB/s, writes=4.83KB/s','2010-04-19 15:27:44',NULL,NULL,NULL,NULL,NULL,'2010-04-14 16:29:42','2010-04-19 15:28:13'),(301,'Disk - /','e1514574-479f-11df-a64b-6cf0494e0fad',1,50,0,0,33,NULL,11,'check_disk_hr','check_disk_hr','host=${host.addr}&community=${host.community}&index=4',300,NULL,1,'2010-04-19 15:29:23','2010-04-19 15:34:23',3,30,NULL,NULL,NULL,0,2,'Usage of /: 12%','2010-04-19 15:29:23',NULL,NULL,NULL,'>= usage 80','>= usage 60','2010-04-14 16:29:44','2010-04-19 15:30:13'),(302,'Disk - /opt','e2f9fe20-479f-11df-a64b-6cf0494e0fad',1,50,0,0,33,NULL,11,'check_disk_hr','check_disk_hr','host=${host.addr}&community=${host.community}&index=5',300,NULL,1,'2010-04-19 15:28:13','2010-04-19 15:33:13',3,30,NULL,NULL,NULL,0,2,'Usage of /opt: 5%','2010-04-19 15:28:13',NULL,NULL,NULL,'>= usage 80','>= usage 60','2010-04-14 16:29:47','2010-04-19 15:30:13'),(303,'Disk - /usr','e45a8bd6-479f-11df-a64b-6cf0494e0fad',1,50,0,0,33,NULL,11,'check_disk_hr','check_disk_hr','host=${host.addr}&community=${host.community}&index=6',300,NULL,1,'2010-04-19 15:30:54','2010-04-19 15:35:54',3,30,NULL,NULL,NULL,0,2,'Usage of /usr: 35%','2010-04-19 15:30:54',NULL,NULL,NULL,'>= usage 80','>= usage 60','2010-04-14 16:29:50','2010-04-19 15:32:13'),(304,'eth0','e59cf592-479f-11df-a64b-6cf0494e0fad',1,50,0,0,33,NULL,6,'check_if','check_if','host=${host.addr}&community=${host.community}&ifindex=2',300,NULL,1,'2010-04-19 15:29:43','2010-04-19 15:34:43',3,30,NULL,NULL,NULL,0,2,'eth0 is up.','2010-04-19 15:29:43',NULL,NULL,NULL,NULL,NULL,'2010-04-14 16:29:52','2010-04-19 15:30:13'),(305,'sit0','e6d0da14-479f-11df-a64b-6cf0494e0fad',1,50,0,0,33,NULL,6,'check_if','check_if','host=${host.addr}&community=${host.community}&ifindex=6',300,NULL,1,'2010-04-19 15:31:14','2010-04-19 15:36:14',3,30,NULL,NULL,NULL,1,2,'sit0 is down.',NULL,'2010-04-19 15:31:14',NULL,NULL,NULL,NULL,'2010-04-14 16:29:54','2010-04-19 15:32:13'),(306,'PING监测','eb385c0c-47dc-11df-a64b-6cf0494e0fad',1,65,1,1,1,NULL,1,'check_ping','check_ping','host=${host.addr}',300,NULL,1,'2010-04-19 15:30:54','2010-04-19 15:35:54',3,30,NULL,NULL,NULL,0,2,'Packet loss = 0%, RTA = 54.816ms','2010-04-19 15:30:54',NULL,NULL,NULL,'>= pl 500','>= pl 100','2010-04-14 23:46:40','2010-04-19 15:32:13'),(307,'PING监测','caa3c9a8-47dd-11df-a64b-6cf0494e0fad',1,66,1,1,1,18,1,'check_ping','check_ping','host=${host.addr}',300,NULL,1,NULL,NULL,3,30,NULL,NULL,NULL,4,2,NULL,NULL,NULL,NULL,NULL,'>= pl 100','>= pl 50','2010-04-14 23:52:55','2010-04-14 23:52:55'),(308,'PING监测','e2551f66-47dd-11df-a64b-6cf0494e0fad',1,67,1,1,1,18,1,'check_ping','check_ping','host=${host.addr}',300,NULL,1,NULL,NULL,3,30,NULL,NULL,NULL,4,2,NULL,NULL,NULL,NULL,NULL,'>= pl 100','>= pl 50','2010-04-14 23:53:35','2010-04-14 23:53:35'),(309,'PING监测','f811c2aa-47dd-11df-a64b-6cf0494e0fad',1,68,1,1,1,18,1,'check_ping','check_ping','host=${host.addr}',300,NULL,1,NULL,NULL,3,30,NULL,NULL,NULL,4,2,NULL,NULL,NULL,NULL,NULL,'>= pl 100','>= pl 50','2010-04-14 23:54:11','2010-04-14 23:54:11'),(310,'端口扫描','3273f91a-4854-11df-a64b-6cf0494e0fad',1,15,0,1,1,NULL,32,'scan_nmap','scan_namp','host=${host.addr}',1800,NULL,1,'2010-04-19 15:04:03','2010-04-19 15:34:03',3,30,NULL,NULL,NULL,3,2,'Warning: Hostname localhost resolves to 2 IPs. Using 127.0.0.1.\nOK - scan ports successfully. \nPort	State	Service\n22/tcp   open          ssh\n25/tcp   open          smtp\n80/tcp   open          http\n139',NULL,NULL,NULL,'2010-04-19 15:04:03',NULL,NULL,'2010-04-15 14:00:30','2010-04-19 15:04:13'),(311,'端口扫描','3beab8de-4855-11df-a64b-6cf0494e0fad',1,20,0,1,1,NULL,32,'scan_nmap','scan_namp','host=${host.addr}',1800,NULL,1,'2010-04-19 15:31:46','2010-04-19 16:01:46',3,30,NULL,NULL,NULL,0,2,'scan ports successfully. \nPort	State	Service\n22/tcp   open   ssh\n80/tcp   open   http\n3306/tcp open   mysql\n8000/tcp open   http-alt\n8080/tcp open   http-proxy\n162/udp  closed snmptrap\n5000/udp closed','2010-04-19 15:31:46',NULL,NULL,'2010-04-15 15:04:47',NULL,NULL,'2010-04-15 14:07:55','2010-04-19 15:32:13');
/*!40000 ALTER TABLE `services` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `monit`.`trigger_services_insert` AFTER INSERT ON monit.services FOR EACH ROW
BEGIN
    IF (new.serviceable_type IS NOT NULL) AND (new.serviceable_id IS NOT NULL) AND (new.uuid IS NOT NULL)
   THEN 
      INSERT INTO task_changed 
            (
                target_type,
                target_id,
                uuid,
								oper_type,
								discovery_state,
								addr,
								created_at,
								updated_at
            )
      VALUES (
                3,
								new.id,
								new.uuid,
								1,
								null,
								null,
								now(),
								now()
             );
   END IF;   
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `monit`.`trigger_services_update` AFTER UPDATE ON monit.services FOR EACH ROW
BEGIN
    IF (old.serviceable_id is null and new.serviceable_id IS NOT NULL) or (old.uuid is null and new.uuid IS NOT NULL)
   THEN 
      INSERT INTO task_changed 
            (
                target_type,
                target_id,
                uuid,
								oper_type,
								discovery_state,
								addr,
								created_at,
								updated_at
            )
      VALUES (
                3,
								new.id,
								new.uuid,
								1,
								null,
								null,
								old.created_at,
								now()
             );
   elseif (old.serviceable_id <> new.serviceable_id) or (old.uuid <> new.uuid) then
      INSERT INTO task_changed 
            (
                target_type,
                target_id,
                uuid,
								oper_type,
								discovery_state,
								addr,
								created_at,
								updated_at
            )
      VALUES (
                3,
								new.id,
								new.uuid,
								3,
								null,
								null,
								old.created_at,
								now()
             );
   END IF;   
    
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `monit`.`trigger_services_delete` AFTER DELETE ON monit.services FOR EACH ROW
BEGIN
    IF (old.serviceable_id IS NOT NULL) AND (old.uuid IS NOT NULL)
   THEN 
      INSERT INTO task_changed 
            (
                target_type,
                target_id,
                uuid,
								oper_type,
								discovery_state,
								addr,
								created_at,
								updated_at
            )
      VALUES (
                3,
								old.id,
								old.uuid,
								2,
								null,
								null,
								old.created_at,
								now()
             );
   END IF;   
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `sites`
--

DROP TABLE IF EXISTS `sites`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sites` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  `url` varchar(255) DEFAULT NULL,
  `addr` varchar(255) DEFAULT NULL,
  `port` int(11) DEFAULT '80',
  `path` varchar(200) DEFAULT NULL,
  `uuid` varchar(50) DEFAULT 'uuid()',
  `tenant_id` int(11) DEFAULT NULL,
  `discovery_state` int(2) DEFAULT '0' COMMENT '0:undiscovery 1:discoveried 2:rediscovery',
  `last_check` datetime DEFAULT NULL,
  `next_check` datetime DEFAULT NULL,
  `duration` int(11) DEFAULT NULL,
  `status` int(2) DEFAULT '0',
  `summary` varchar(200) DEFAULT NULL,
  `last_update` datetime DEFAULT NULL,
  `last_time_up` datetime DEFAULT NULL,
  `last_time_down` datetime DEFAULT NULL,
  `last_time_pending` datetime DEFAULT NULL,
  `last_time_unknown` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sites`
--

LOCK TABLES `sites` WRITE;
/*!40000 ALTER TABLE `sites` DISABLE KEYS */;
INSERT INTO `sites` VALUES (8,'opengoss','http://www.opengoss.com','www.opengoss.com',80,'/','2b65069a-3bd5-11df-af48-0026b9388a6f',1,0,'2010-04-19 15:31:11','2010-04-19 15:36:11',NULL,0,'200 OK, 5452 bytes in 0.282 seconds',NULL,'2010-04-19 15:31:11',NULL,'2010-04-13 00:12:02','2010-04-13 00:05:23','2010-03-30 16:22:11','2010-04-19 15:32:13');
/*!40000 ALTER TABLE `sites` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `monit`.`trigger_sites_insert` AFTER INSERT ON monit.sites FOR EACH ROW
BEGIN
    IF (new.url IS NOT NULL) AND (new.uuid IS NOT NULL)
   THEN 
      INSERT INTO task_changed 
            (
                target_type,
                target_id,
                uuid,
								oper_type,
								discovery_state,
								addr,
								created_at,
								updated_at
            )
      VALUES (
                4,
								new.id,
								new.uuid,
								1,
								new.discovery_state,
								new.url,
								now(),
								now()
             );
   END IF;   
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `monit`.`trigger_sites_update` AFTER UPDATE ON monit.sites FOR EACH ROW
BEGIN
    IF (old.url is null and new.url IS NOT NULL) or (old.uuid is null and new.uuid IS NOT NULL)
   THEN 
      INSERT INTO task_changed 
            (
                target_type,
                target_id,
                uuid,
								oper_type,
								discovery_state,
								addr,
								created_at,
								updated_at
            )
      VALUES (
                4,
								new.id,
								new.uuid,
								1,
								new.discovery_state,
								new.url,
								old.created_at,
								now()
             );
   elseif (old.url <> new.url) or (old.uuid <> new.uuid) then
      INSERT INTO task_changed 
            (
                target_type,
                target_id,
                uuid,
								oper_type,
								discovery_state,
								addr,
								created_at,
								updated_at
            )
      VALUES (
                4,
								new.id,
								new.uuid,
								3,
								new.discovery_state,
								new.url,
								old.created_at,
								now()
             );
   END IF;   
    
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `monit`.`trigger_sites_delete` AFTER DELETE ON monit.sites FOR EACH ROW
BEGIN
    IF (old.url IS NOT NULL) AND (old.uuid IS NOT NULL)
   THEN 
      INSERT INTO task_changed 
            (
                target_type,
                target_id,
                uuid,
								oper_type,
								discovery_state,
								addr,
								created_at,
								updated_at
            )
      VALUES (
                4,
								old.id,
								old.uuid,
								2,
								old.discovery_state,
								old.url,
								old.created_at,
								now()
             );
   END IF;   
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `task_changed`
--

DROP TABLE IF EXISTS `task_changed`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `task_changed` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `agent_id` int(11) DEFAULT NULL,
  `target_type` int(2) DEFAULT NULL COMMENT '1:host 2:app 3:service',
  `target_id` int(11) DEFAULT NULL,
  `uuid` varchar(50) DEFAULT NULL,
  `oper_type` int(2) DEFAULT NULL COMMENT '1: add 2:delete 3:update',
  `discovery_state` int(2) DEFAULT NULL COMMENT '0:undiscovery 1:discoveried 2:rediscovery',
  `addr` varchar(50) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=263 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `task_changed`
--

LOCK TABLES `task_changed` WRITE;
/*!40000 ALTER TABLE `task_changed` DISABLE KEYS */;
/*!40000 ALTER TABLE `task_changed` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tenants`
--

DROP TABLE IF EXISTS `tenants`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tenants` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  `company` varchar(50) DEFAULT NULL,
  `email` varchar(50) DEFAULT NULL,
  `mobile` varchar(20) DEFAULT NULL,
  `expired` int(2) DEFAULT NULL COMMENT '0:false 1:true',
  `db_host` varchar(40) DEFAULT NULL,
  `db_name` varchar(40) DEFAULT NULL,
  `port` int(11) DEFAULT NULL,
  `username` varchar(40) DEFAULT NULL,
  `password` varchar(40) DEFAULT NULL,
  `pay_date` datetime DEFAULT NULL,
  `avail_date` datetime DEFAULT NULL,
  `remark` varchar(100) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tenants`
--

LOCK TABLES `tenants` WRITE;
/*!40000 ALTER TABLE `tenants` DISABLE KEYS */;
INSERT INTO `tenants` VALUES (1,'root',NULL,NULL,NULL,NULL,'192.168.1.31','monit',3306,'root','cHVibGlj\n',NULL,NULL,NULL,'2010-01-12 06:32:20','2010-01-12 06:32:20'),(4,'wangyh',NULL,NULL,NULL,NULL,'192.168.1.31','monit',3306,'root','cHVibGlj',NULL,NULL,NULL,'2010-01-11 09:52:01','2010-01-11 09:52:01'),(5,'chibj',NULL,NULL,NULL,NULL,'192.168.1.31','monit',3306,'root','cHVibGlj',NULL,NULL,NULL,'2010-01-11 09:57:10','2010-01-11 09:57:10'),(8,'test',NULL,NULL,NULL,NULL,'192.168.1.31','monit',3306,'root','cHVibGlj\n',NULL,NULL,NULL,'2010-01-13 07:18:39','2010-01-13 07:18:39'),(9,'chibinjie',NULL,NULL,NULL,NULL,'127.0.0.1','monit',3306,'root','cHVibGlj\n',NULL,NULL,NULL,'2010-01-25 13:30:08','2010-01-25 13:30:08'),(10,'hunan',NULL,NULL,NULL,NULL,'127.0.0.1','monit',3306,'root','cHVibGlj\n',NULL,NULL,NULL,'2010-02-03 15:06:19','2010-02-03 15:06:19'),(18,'test1',NULL,NULL,NULL,NULL,'127.0.0.1','monit',3306,'root','cHVibGlj\n',NULL,NULL,NULL,'2010-02-23 15:33:11','2010-02-23 15:33:11'),(20,'erylee',NULL,NULL,NULL,NULL,'127.0.0.1','monit',3306,'root','cHVibGlj\n',NULL,NULL,NULL,'2010-03-12 15:20:05','2010-03-12 15:20:05'),(22,'public',NULL,NULL,NULL,NULL,'127.0.0.1','monit',3306,'root','cHVibGlj\n',NULL,NULL,NULL,'2010-03-15 11:08:17','2010-03-15 11:08:17'),(25,'test2',NULL,NULL,NULL,NULL,'127.0.0.1','monit',3306,'root','cHVibGlj\n',NULL,NULL,NULL,'2010-03-15 11:30:25','2010-03-15 11:30:25'),(26,'chenjx.opengoss',NULL,NULL,NULL,NULL,'127.0.0.1','monit',3306,'root','cHVibGlj\n',NULL,NULL,NULL,'2010-03-18 16:07:40','2010-03-18 16:07:40'),(27,'chenjx',NULL,NULL,NULL,NULL,'127.0.0.1','monit',3306,'root','cHVibGlj\n',NULL,NULL,NULL,'2010-03-19 11:43:04','2010-03-19 11:43:04'),(28,'vvsvv',NULL,NULL,NULL,NULL,'127.0.0.1','monit',3306,'root','cHVibGlj\n',NULL,NULL,NULL,'2010-03-23 09:22:52','2010-03-23 09:22:52'),(29,'zhangwh',NULL,NULL,NULL,NULL,'127.0.0.1','monit',3306,'root','cHVibGlj\n',NULL,NULL,NULL,'2010-03-23 12:06:42','2010-03-23 12:06:42'),(30,'Solo',NULL,NULL,NULL,NULL,'127.0.0.1','monit',3306,'root','cHVibGlj\n',NULL,NULL,NULL,'2010-04-13 15:42:30','2010-04-13 15:42:30'),(31,'yufw',NULL,NULL,NULL,NULL,'127.0.0.1','monit',3306,'root','cHVibGlj\n',NULL,NULL,NULL,'2010-04-13 16:09:41','2010-04-13 16:09:41'),(32,'sx_monit',NULL,NULL,NULL,NULL,'127.0.0.1','monit',3306,'root','cHVibGlj\n',NULL,NULL,NULL,'2010-04-13 16:13:29','2010-04-13 16:13:29'),(33,'jx_wlan',NULL,NULL,NULL,NULL,'127.0.0.1','monit',3306,'root','cHVibGlj\n',NULL,NULL,NULL,'2010-04-13 16:14:25','2010-04-13 16:14:25');
/*!40000 ALTER TABLE `tenants` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `login` varchar(50) DEFAULT NULL,
  `username` varchar(50) DEFAULT NULL,
  `work_number` varchar(50) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `birthday` date DEFAULT NULL,
  `remember_token` varchar(40) DEFAULT NULL,
  `crypted_password` varchar(40) DEFAULT NULL,
  `password` varchar(40) DEFAULT NULL,
  `old_password` varchar(50) DEFAULT NULL,
  `remember_token_expires_at` datetime DEFAULT NULL,
  `salt` varchar(40) DEFAULT NULL,
  `role_id` int(11) DEFAULT NULL,
  `tenant_id` int(11) DEFAULT NULL,
  `company` varchar(50) DEFAULT NULL,
  `department` varchar(50) DEFAULT NULL,
  `job` varchar(50) DEFAULT NULL,
  `phone` varchar(50) DEFAULT NULL,
  `mobile` varchar(50) DEFAULT NULL,
  `email` varchar(50) DEFAULT NULL,
  `description` varchar(50) DEFAULT NULL,
  `creator` int(11) DEFAULT NULL,
  `state` int(2) DEFAULT '1' COMMENT '0:invalid 1:valid',
  `activation_code` varchar(40) DEFAULT NULL,
  `reset_password_code` varchar(40) DEFAULT NULL,
  `activated_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'root','root',NULL,'admin',NULL,NULL,'2ad7e000ddc2f882c69b18c641d046690bfaf63e','public',NULL,NULL,'d6e78ae21a11fb52f79d9b16a0de38dcf012fb06',NULL,1,'','','','82938273','3838','zhangzd.opengoss@gmail.com,ery.lee@gmail.com',NULL,NULL,NULL,NULL,NULL,'2010-02-22 09:08:25','2010-01-12 06:32:20','2010-04-14 16:45:54'),(2,'wangyh','hello1',NULL,'wangyonghe','2010-01-12',NULL,'aeb5317c4a29397cbb29f9922ce6af3cd666e424','public',NULL,NULL,'961480a47aa2516fad40e783e57611d8179264cd',NULL,4,NULL,NULL,NULL,NULL,NULL,'wangyh.opengoss@gmail.com',NULL,NULL,NULL,NULL,NULL,NULL,'2010-01-11 09:52:01','2010-01-11 09:52:01'),(3,'chibj','chibj',NULL,'chibinjie1','1986-11-24',NULL,'8498349bad88a14d80a959761c7313b2c8812640','public',NULL,NULL,'6b755355b7d755d328a12364f07c52d153146edd',NULL,5,'1s','1s','1s','1s','13486186393','chibj.opengoss@gmail.com',NULL,NULL,NULL,NULL,'0e26f39bd3ce753fe704a87d6d714631736bf9f7',NULL,'2010-01-11 09:57:10','2010-03-31 21:51:21'),(6,'test','test',NULL,'test','1972-03-03',NULL,'48ea187cbdb9b29bbaff04b4e6db97549c109fae','public',NULL,NULL,'0f820ffbef2c60bf8296c38765429d17b44e7f3f',NULL,8,'','','','','','z@gmail.com',NULL,NULL,NULL,NULL,NULL,'2010-02-22 09:10:33','2010-01-13 07:18:39','2010-02-22 17:10:33'),(7,'chibinjie','chibinjie',NULL,'chibingjie',NULL,NULL,'2f0054e8ec525bb1b95bfb50a0e3f6353c76ce67','public',NULL,NULL,'965b2e6cbf7cb7b77a88b7f602f2e992d2e40a11',NULL,9,NULL,NULL,NULL,NULL,NULL,'chibinjie11@gmail.com',NULL,NULL,NULL,NULL,NULL,NULL,'2010-01-25 13:30:08','2010-01-25 13:30:08'),(8,'hunan','hunan',NULL,'hunan',NULL,NULL,'6d4beeba45a82a3199ae1d69b7348e8539b337b6','public',NULL,NULL,'c9479d7ccefb42f05e8f330c49214d5cfc58983e',NULL,10,NULL,NULL,NULL,NULL,NULL,'fengzf.opengoss@gmail.com',NULL,NULL,NULL,NULL,NULL,NULL,'2010-02-03 15:06:19','2010-04-13 16:06:43'),(9,'admin','admin',NULL,'admin','1963-05-07',NULL,'2ad7e000ddc2f882c69b18c641d046690bfaf63e','public',NULL,NULL,'d6e78ae21a11fb52f79d9b16a0de38dcf012fb06',NULL,1,'','','','82938273','3838','root@opengoss.com',NULL,NULL,NULL,NULL,NULL,NULL,'2010-01-12 06:32:20','2010-04-15 17:00:54'),(15,'erylee','erylee',NULL,NULL,NULL,NULL,'5a5a61e8a956808a7db1ddecc751b4b229221d0c','public',NULL,NULL,'83bafebd77ba3e572fbb76d72c6bf9ea2014a57a',NULL,20,NULL,NULL,NULL,NULL,NULL,'ery.lee@gmail.com',NULL,NULL,1,NULL,NULL,'2010-03-12 07:20:05','2010-03-12 15:20:05','2010-03-12 15:20:05'),(17,'public','public',NULL,NULL,NULL,NULL,'cf7b6154a5a2b0fe8837206ab0947eadb1e4b25f','public',NULL,NULL,'6a341581f2219eda3e9075cffb22191e5a4ac9cf',NULL,22,NULL,NULL,NULL,NULL,NULL,'zzdhidden@gmail.com',NULL,NULL,1,NULL,NULL,'2010-03-15 03:08:17','2010-03-15 11:08:17','2010-03-15 11:08:17'),(20,'test2','test2',NULL,NULL,NULL,NULL,'9243e036aa9f102ee194c08c23444ca80bc7933a','public',NULL,NULL,'5fb4e6130040ba0f67ece3d6cad44e742b8e0a71',NULL,25,NULL,NULL,NULL,NULL,NULL,'werni@dnwi.com',NULL,NULL,1,NULL,NULL,'2010-03-15 03:30:25','2010-03-15 11:30:25','2010-03-15 11:30:25'),(21,'chenjx.opengoss','chenjx.opengoss',NULL,NULL,NULL,NULL,'e9954259640ef873fe87f228f2eebd944823d8ed','123456',NULL,NULL,'21a3d6e6e16260789cc96a2f06250c2e64c07a2e',NULL,26,NULL,NULL,NULL,NULL,NULL,'chenjx.opengoss@gmail.com',NULL,NULL,1,NULL,NULL,'2010-03-18 08:07:40','2010-03-18 16:07:40','2010-03-18 16:07:40'),(22,'chenjx','chenjx',NULL,NULL,NULL,NULL,'5aa4fe484ce82dc72ba2f43ca937ee2029b51966','123456',NULL,NULL,'85306addd2625999d31260952c3ba9387a78fec2',NULL,27,NULL,NULL,NULL,NULL,NULL,'cx198529119@126.com',NULL,NULL,1,NULL,NULL,'2010-03-19 03:43:04','2010-03-19 11:43:04','2010-03-19 11:43:04'),(23,'vvsvv','vvsvv',NULL,NULL,NULL,NULL,'a7c2ca8b264bebbcfa505977e38b48bd5756c61c','997862ice',NULL,NULL,'1fd0f8abfc3b892c16c7abbfbe80f764aada573f',NULL,28,NULL,NULL,NULL,NULL,NULL,'admin@vvsvv.com',NULL,NULL,1,NULL,NULL,'2010-03-23 01:22:52','2010-03-23 09:22:52','2010-03-23 09:22:52'),(24,'zhangwh','zhangwh',NULL,'',NULL,'66ef0503b1c761152cea2f31f5152736c49c88e0','df01b1b9a710f74e94eb45dcf79ceb03bfa38e76','1985912',NULL,'2010-04-28 10:47:45','bc423c40a7eb58d2a5db71eaaf7e6c2ba085b0a9',NULL,29,'',NULL,NULL,NULL,'','zhangwh@opengoss.com',NULL,NULL,1,NULL,NULL,'2010-03-23 04:06:42','2010-03-23 12:06:42','2010-04-17 15:44:12'),(25,'solo','solo',NULL,'徐璨',NULL,NULL,'80d1ef6c1ccf6f5cb3ee5c9a3ce349b231709980','sunshine',NULL,NULL,'059c7fd74734923604d8a96988d7fe0207203fe2',NULL,30,'杭州华思',NULL,NULL,NULL,'18909511417','xucan.opengoss@gmail.com',NULL,NULL,1,NULL,NULL,'2010-04-13 07:42:30','2010-04-13 15:42:30','2010-04-13 15:51:35'),(26,'yufw','yufw',NULL,'尉法文',NULL,NULL,'9f21d5d51b02d94b721ff9cd5aab812cd32d0bcd','chongqing',NULL,NULL,'3d7620c96e6867b4999871a0ae6c8a26484998d9',NULL,31,'',NULL,NULL,NULL,'','yufw.opengoss@gmail.com',NULL,NULL,1,NULL,NULL,'2010-04-13 08:09:41','2010-04-13 16:09:41','2010-04-13 17:01:51'),(27,'sx_monit','sx_monit',NULL,NULL,NULL,NULL,'53d22f3119fdbcf10c4f8f87b682d3106a64440f','sxmonit_r00t',NULL,NULL,'41b3fe81337249a30f93672ba6bd01786e6b47c9',NULL,32,NULL,NULL,NULL,NULL,NULL,'dingkh.opengoss@gmail.com',NULL,NULL,1,NULL,NULL,'2010-04-13 08:13:29','2010-04-13 16:13:29','2010-04-13 16:13:29'),(28,'jx_wlan','jx_wlan',NULL,NULL,NULL,NULL,'ec80c6932a4ea1f0c3f46ef8cf6502fe435df90a','lbnzmm',NULL,NULL,'31ed18bd80a7f594d1a034bfdd6a7c421c41e2b6',NULL,33,NULL,NULL,NULL,NULL,NULL,'liubn.opengoss@gmail.com',NULL,NULL,1,NULL,NULL,'2010-04-13 08:14:25','2010-04-13 16:14:25','2010-04-13 16:14:25');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `view_items`
--

DROP TABLE IF EXISTS `view_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `view_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `view_id` int(11) DEFAULT NULL,
  `name` varchar(100) DEFAULT NULL,
  `alias` varchar(100) DEFAULT NULL,
  `data_type` varchar(10) DEFAULT 'int',
  `data_unit` varchar(20) DEFAULT NULL,
  `data_format` varchar(255) DEFAULT NULL,
  `data_format_params` varchar(255) DEFAULT NULL,
  `width` varchar(10) DEFAULT NULL,
  `height` varchar(10) DEFAULT NULL,
  `fill` varchar(10) DEFAULT NULL,
  `color` varchar(15) DEFAULT NULL,
  `hover_color` varchar(15) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=127 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `view_items`
--

LOCK TABLES `view_items` WRITE;
/*!40000 ALTER TABLE `view_items` DISABLE KEYS */;
INSERT INTO `view_items` VALUES (1,111,'host_name','主机','string',NULL,'link','href=/hosts/${host_id}',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(2,111,'service_name','服务','string',NULL,'link','href=/services/${service_id}',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(3,111,'used','已用空间','string','GB','kb_to_gb',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(4,111,'total','总空间','string','GB','kb_to_gb',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(5,111,'usage','使用率','float','%',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(6,112,'host_name','主机','string',NULL,'link','href=/hosts/${host_id}',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(7,112,'load1','1分钟负载','float','%',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(8,112,'load5','5分钟负载','float','%',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(9,112,'load15','15分钟负载','float','%',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(10,115,'host_name','主机','string',NULL,'link','href=/hosts/${host_id}',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(13,115,'buffers','Buffers内存','float','MB','byte_to_mb',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(14,115,'shared','Shared内存','float','MB','byte_to_mb',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(15,115,'cached','Cached内存','float','MB','byte_to_mb',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(16,115,'total','总内存','float','MB','byte_to_mb',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(17,115,'usage','使用率','float','%',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(19,116,'host_name','主机','string',NULL,'link','href=/hosts/${host_id}',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(20,116,'used','已用Swap','float','MB','byte_to_mb',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(21,116,'total','总Swap','float','MB','byte_to_mb',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(22,116,'usage','使用率','float','%',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(23,117,'host_name','主机','string',NULL,'link','href=/hosts/${host_id}',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(24,117,'running','运行中','int',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(25,117,'sleeping','睡眠中','int',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(26,117,'total','总任务数','int',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(27,118,'host_name','主机','string',NULL,'link','href=/hosts/${host_id}',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(28,118,'rtmax','最大响应时间','float','ms',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(29,118,'rta','平均响应时间','float','ms',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(30,118,'rtmin','最小响应时间','float','ms',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(32,119,'parent_key','时间','datetime',NULL,'time',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(33,119,'user','(user)用户层执行时间','float','%',NULL,NULL,'2',NULL,'60','#FFCC00',NULL,NULL,NULL),(34,119,'system','(system)内核层执行时间','float','%',NULL,NULL,'2',NULL,'60','#99CC00',NULL,NULL,NULL),(35,119,'iowait','(iowait)io等待时间','float','%',NULL,NULL,'2',NULL,'60','#3399CC',NULL,NULL,NULL),(36,119,'nice','(nice)nice时间','float','%',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(38,120,'usage','CPU','float','%',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(40,121,'parent_key','时间','datetime',NULL,'time',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(41,121,'appused','应用程序内存','float','MB','byte_to_mb',NULL,'2',NULL,'60','#3399CC',NULL,NULL,NULL),(42,121,'buffers','Buffers内存','float','MB','byte_to_mb',NULL,'2',NULL,'60','#99CC00',NULL,NULL,NULL),(43,121,'cached','Cached内存','float','MB','byte_to_mb',NULL,'2',NULL,'60','#FFCC00',NULL,NULL,NULL),(44,121,'free','剩余内存','float','MB','byte_to_mb',NULL,'2',NULL,'60','#008000',NULL,NULL,NULL),(46,122,'appused','应用程序内存','float','MB','byte_to_mb',NULL,NULL,NULL,NULL,'#3399CC',NULL,NULL,NULL),(47,122,'buffers','Buffers内存','float','MB','byte_to_mb',NULL,NULL,NULL,NULL,'#99CC00',NULL,NULL,NULL),(48,122,'cached','Cached内存','float','MB','byte_to_mb',NULL,NULL,NULL,NULL,'#FFCC00',NULL,NULL,NULL),(49,122,'free','剩余内存','float','MB','byte_to_mb',NULL,NULL,NULL,NULL,'#008000',NULL,NULL,NULL),(52,123,'parent_key','时间','datetime',NULL,'time',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(53,123,'running','运行任务数','int',NULL,NULL,NULL,NULL,NULL,'60','#3399CC',NULL,NULL,NULL),(54,123,'sleeping','休眠任务数','int',NULL,NULL,NULL,NULL,NULL,'60','#EACC00',NULL,NULL,NULL),(55,124,'parent_key','时间','datetime',NULL,'time',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(56,124,'load1','1分钟负载','float','%',NULL,NULL,NULL,NULL,'60','#EACC00',NULL,NULL,NULL),(57,124,'load5','5分钟负载','float','%',NULL,NULL,NULL,NULL,'60','#99CC00',NULL,NULL,NULL),(58,124,'load15','15分钟负载','float','%',NULL,NULL,'2',NULL,NULL,'#CC6633',NULL,NULL,NULL),(59,125,'parent_key','时间','datetime',NULL,'time',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(60,125,'used','已用磁盘空间','float','GB','byte_to_gb',NULL,NULL,NULL,'60','#3399CC',NULL,NULL,NULL),(61,125,'avail','可用磁盘空间','float','GB','byte_to_gb',NULL,NULL,NULL,'60','#EACC00',NULL,NULL,NULL),(62,126,'parent_key','时间','datetime',NULL,'time',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(63,126,'used','已用Swap','float','MB','byte_to_mb',NULL,NULL,NULL,'60','#3399CC',NULL,NULL,NULL),(64,126,'free','可用swap','float','MB','byte_to_mb',NULL,NULL,NULL,'60','#EACC00',NULL,NULL,NULL),(65,127,'parent_key','时间','datetime',NULL,'time',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(66,127,'rtmin','最小响应时间','float','ms',NULL,NULL,'2',NULL,NULL,'#EACC00',NULL,NULL,NULL),(67,127,'rta','最大响应时间','float','ms',NULL,NULL,'3',NULL,NULL,'#99CC00',NULL,NULL,NULL),(68,127,'rtmax','最小响应时间','float','ms',NULL,NULL,'2',NULL,NULL,'#CC6633',NULL,NULL,NULL),(69,128,'parent_key','时间','datetime',NULL,'time',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(70,128,'time','响应时间','float','ms',NULL,NULL,'2',NULL,'30','#99CC00',NULL,NULL,NULL),(75,129,'parent_key','时间','datetime',NULL,'time',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(76,129,'time','响应时间','float','ms',NULL,NULL,'2',NULL,'30','#99CC00',NULL,NULL,NULL),(80,130,'parent_key','时间','datetime',NULL,'time',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(81,130,'inoctets','接收字节数','int','bits',NULL,NULL,NULL,NULL,'60','#EACC00',NULL,NULL,NULL),(82,130,'outoctets','发送字节数','int','bits',NULL,NULL,'3',NULL,NULL,'#3399CC',NULL,NULL,NULL),(84,131,'parent_key','时间','datetime',NULL,'time',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(85,131,'inucastpkts','网络接收单播包数','int',NULL,NULL,NULL,NULL,NULL,'60','#EACC00',NULL,NULL,NULL),(86,131,'outucastpkts','网络发送单播包数','int',NULL,NULL,NULL,'3',NULL,NULL,'#3399CC',NULL,NULL,NULL),(89,133,'parent_key','时间','datetime',NULL,'time',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(90,133,'rbytes','磁盘读取速率','float','KB/s','byte_to_kb',NULL,NULL,NULL,'60','#EACC00',NULL,NULL,NULL),(91,133,'wbytes','磁盘写入速率','float','KB/s','byte_to_kb',NULL,'2',NULL,NULL,'#3399CC',NULL,NULL,NULL),(92,137,'parent_key','时间','datetime',NULL,'time',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(93,137,'rtmin','最小响应时间','float','ms',NULL,NULL,'2',NULL,NULL,'#EACC00',NULL,NULL,NULL),(94,137,'rta','最大响应时间','float','ms',NULL,NULL,'3',NULL,NULL,'#99CC00',NULL,NULL,NULL),(95,137,'rtmax','最小响应时间','float','ms',NULL,NULL,'2',NULL,NULL,'#CC6633',NULL,NULL,NULL),(96,132,'parent_key','时间','datetime',NULL,'time',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(97,132,'used','已用磁盘空间','float','GB','byte_to_gb',NULL,NULL,NULL,'60','#3399CC',NULL,NULL,NULL),(98,132,'avail','可用磁盘空间','float','GB','byte_to_gb',NULL,NULL,NULL,'60','#EACC00',NULL,NULL,NULL),(99,134,'parent_key','时间','datetime',NULL,'time',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(100,134,'load1','1分钟负载','float','%',NULL,NULL,NULL,NULL,'60','#EACC00',NULL,NULL,NULL),(101,134,'load5','5分钟负载','float','%',NULL,NULL,NULL,NULL,'60','#99CC00',NULL,NULL,NULL),(102,134,'load15','15分钟负载','float','%',NULL,NULL,'2',NULL,NULL,'#CC6633',NULL,NULL,NULL),(103,135,'parent_key','时间','datetime',NULL,'time',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(104,135,'appused','应用程序内存','float','MB','byte_to_mb',NULL,'2',NULL,'60','#3399CC',NULL,NULL,NULL),(105,135,'buffers','Buffers内存','float','MB','byte_to_mb',NULL,'2',NULL,'60','#99CC00',NULL,NULL,NULL),(106,135,'cached','Cached内存','float','MB','byte_to_mb',NULL,'2',NULL,'60','#FFCC00',NULL,NULL,NULL),(107,135,'free','剩余内存','float','MB','byte_to_mb',NULL,'2',NULL,'60','#008000',NULL,NULL,NULL),(108,136,'parent_key','时间','datetime',NULL,'time',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(109,136,'used','已用Swap','float','MB','byte_to_mb',NULL,NULL,NULL,'60','#3399CC',NULL,NULL,NULL),(110,136,'free','可用swap','float','MB','byte_to_mb',NULL,NULL,NULL,'60','#EACC00',NULL,NULL,NULL),(111,138,'parent_key','时间','datetime',NULL,'time',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(112,138,'time','响应时间','float','ms',NULL,NULL,'2',NULL,'30','#99CC00',NULL,NULL,NULL),(113,139,'parent_key','时间','datetime',NULL,'time',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(114,139,'time','响应时间','float','ms',NULL,NULL,'2',NULL,'30','#99CC00',NULL,NULL,NULL),(115,140,'parent_key','时间','datetime',NULL,'time',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(116,140,'load','系统负载','float','%',NULL,NULL,NULL,NULL,'60','#EACC00',NULL,NULL,NULL),(117,141,'parent_key','时间','datetime',NULL,'time',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(118,141,'used','已用内存','float','MB','byte_to_mb',NULL,NULL,NULL,'60','#3399CC',NULL,NULL,NULL),(119,141,'avail','可用内存','float','MB','byte_to_mb',NULL,NULL,NULL,'60','#EACC00',NULL,NULL,NULL),(120,142,'parent_key','时间','datetime',NULL,'time',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(121,142,'used','已用内存','float','MB','byte_to_mb',NULL,NULL,NULL,'60','#3399CC',NULL,NULL,NULL),(122,142,'avail','可用内存','float','MB','byte_to_mb',NULL,NULL,NULL,'60','#EACC00',NULL,NULL,NULL),(124,143,'parent_key','时间','datetime',NULL,'time',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(126,143,'total','运行任务数','int',NULL,NULL,NULL,NULL,NULL,'60','#EACC00',NULL,NULL,NULL);
/*!40000 ALTER TABLE `view_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `views`
--

DROP TABLE IF EXISTS `views`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `views` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  `visible_type` varchar(20) DEFAULT NULL COMMENT '1:host_type, 2:app_type, 3:s\\nervice_type',
  `visible_id` int(11) DEFAULT NULL,
  `data_params` varchar(255) DEFAULT NULL,
  `template` varchar(50) DEFAULT NULL,
  `dimensionality` int(11) DEFAULT '3',
  `enable` tinyint(4) DEFAULT '1',
  `width` varchar(10) DEFAULT NULL,
  `height` varchar(10) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=144 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `views`
--

LOCK TABLES `views` WRITE;
/*!40000 ALTER TABLE `views` DISABLE KEYS */;
INSERT INTO `views` VALUES (111,'磁盘使用率','report_top',NULL,'service_type=check_disk_df&sort=usage','table',3,1,NULL,NULL,NULL,NULL),(112,'负载','report_top',NULL,'service_type=check_load&sort=load1','table',3,0,NULL,NULL,NULL,NULL),(113,'网络流量','report_top',NULL,'service_type=check_if&sort=load1','table',3,0,NULL,NULL,NULL,NULL),(114,'网络丢包率','report_top',NULL,NULL,'table',3,0,NULL,NULL,NULL,NULL),(115,'内存使用率','report_top',NULL,'service_type=check_mem_free&sort=usage','table',3,1,NULL,NULL,NULL,NULL),(116,'SWAP使用率','report_top',NULL,'service_type=check_swap_free&sort=usage','table',3,1,NULL,NULL,NULL,NULL),(117,'任务数','report_top',NULL,'service_type=check_task_top&sort=total','table',3,1,NULL,NULL,NULL,NULL),(118,'Ping时延','report_top',NULL,'service_type=check_ping&sort=rta','table',3,1,NULL,NULL,NULL,NULL),(119,'CPU使用率变化','service_history',5,NULL,'amline_stacked',3,1,'100%','300',NULL,NULL),(120,'CPU使用','service_current',5,NULL,'google_visualization_gauge',2,1,'270','270',NULL,NULL),(121,'内存使用变化','service_history',7,NULL,'amline_stacked',3,1,'100%','300',NULL,NULL),(122,'内存使用','service_current',7,NULL,'ampie',2,1,'90%','270',NULL,NULL),(123,'任务数','service_history',10,NULL,'amline_stacked',3,1,'100%','300',NULL,NULL),(124,'系统负载','service_history',4,NULL,'amline',3,1,'100%','300',NULL,NULL),(125,'磁盘容量','service_history',3,NULL,'amline_stacked',3,1,'100%','300',NULL,NULL),(126,'Swap','service_history',8,NULL,'amline_stacked',3,1,'100%','300',NULL,NULL),(127,'PING响应时间','service_history',1,NULL,'amline',3,1,'100%','300',NULL,NULL),(128,'TCP响应时间','service_history',9,NULL,'amline',3,1,'100%','300',NULL,NULL),(129,'HTTP响应时间','service_history',2,NULL,'amline',3,1,'100%','300',NULL,NULL),(130,'接口流量','service_history',6,NULL,'amline',3,1,'100%','300',NULL,NULL),(131,'网络单播包数','service_history',6,NULL,'amline',3,1,'100%','300',NULL,NULL),(132,'磁盘容量','service_history',11,NULL,'amline_stacked',3,1,'100%','300',NULL,NULL),(133,'磁盘I/O','service_history',12,NULL,'amline',3,1,'100%','300',NULL,NULL),(134,'系统负载','service_history',13,NULL,'amline',3,1,'100%','300',NULL,NULL),(135,'内存使用变化','service_history',14,NULL,'amline_stacked',3,1,'100%','300',NULL,NULL),(136,'Swap','service_history',15,NULL,'amline_stacked',3,1,'100%','300',NULL,NULL),(137,'PING响应时间','service_history',23,NULL,'amline',3,1,'100%','300',NULL,NULL),(138,'HTTP响应时间','service_history',24,NULL,'amline',3,1,'100%','300',NULL,NULL),(139,'DNS检测','service_history',25,NULL,'amline',3,1,'100%','300',NULL,NULL),(140,'系统负载','service_history',26,NULL,'amline',3,1,'100%','300',NULL,NULL),(141,'物理内存监测','service_history',27,NULL,'amline_stacked',3,1,'100%','300',NULL,NULL),(142,'物理内存监测','service_history',28,NULL,'amline_stacked',3,1,'100%','300',NULL,NULL),(143,'进程总数监测','service_history',29,NULL,'amline_stacked',3,1,'100%','300',NULL,NULL);
/*!40000 ALTER TABLE `views` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'monit'
--
/*!50106 SET @save_time_zone= @@TIME_ZONE */ ;
/*!50106 DROP EVENT IF EXISTS `clear_alerts_event` */;
DELIMITER ;;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;;
/*!50003 SET character_set_client  = utf8 */ ;;
/*!50003 SET character_set_results = utf8 */ ;;
/*!50003 SET collation_connection  = utf8_general_ci */ ;;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;;
/*!50003 SET sql_mode              = '' */ ;;
/*!50003 SET @saved_time_zone      = @@time_zone */ ;;
/*!50003 SET time_zone             = 'SYSTEM' */ ;;
/*!50106 CREATE EVENT `clear_alerts_event` ON SCHEDULE EVERY 1 DAY STARTS '2010-04-09 16:15:48' ON COMPLETION PRESERVE ENABLE DO CALL clear_alerts() */ ;;
/*!50003 SET time_zone             = @saved_time_zone */ ;;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;;
/*!50003 SET character_set_client  = @saved_cs_client */ ;;
/*!50003 SET character_set_results = @saved_cs_results */ ;;
/*!50003 SET collation_connection  = @saved_col_connection */ ;;
/*!50106 DROP EVENT IF EXISTS `merge_status_event` */;;
DELIMITER ;;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;;
/*!50003 SET character_set_client  = utf8 */ ;;
/*!50003 SET character_set_results = utf8 */ ;;
/*!50003 SET collation_connection  = utf8_general_ci */ ;;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;;
/*!50003 SET sql_mode              = '' */ ;;
/*!50003 SET @saved_time_zone      = @@time_zone */ ;;
/*!50003 SET time_zone             = 'SYSTEM' */ ;;
/*!50106 CREATE EVENT `merge_status_event` ON SCHEDULE EVERY 2 MINUTE STARTS '2010-04-09 16:52:13' ON COMPLETION PRESERVE ENABLE DO CALL merge_status() */ ;;
/*!50003 SET time_zone             = @saved_time_zone */ ;;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;;
/*!50003 SET character_set_client  = @saved_cs_client */ ;;
/*!50003 SET character_set_results = @saved_cs_results */ ;;
/*!50003 SET collation_connection  = @saved_col_connection */ ;;
DELIMITER ;
/*!50106 SET TIME_ZONE= @save_time_zone */ ;

--
-- Dumping routines for database 'monit'
--
/*!50003 DROP PROCEDURE IF EXISTS `clear_alerts` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `clear_alerts`()
BEGIN
		delete from alerts where changed_at < now() - interval 1 day and severity = 0;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `create_notifications` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `create_notifications`()
BEGIN
	insert into notifications (method, user_id, alert_id, alert_name, alert_severity, alert_summary, service_id, source_id, source_type, tenant_id, status, occured_at, created_at, updated_at)
		select t2.method, t2.user_id, t1.id alert_id, t1.name alert_name, t1.severity alert_severity, t1.summary alert_summary, t1.service_id, t1.source_id, t1.source_type, t1.tenant_id, 0 status, t1.changed_at, now() created_at, now() update_at from alerts t1 
			inner join notify_rules t2 on t1.tenant_id = t2.tenant_id and t1.severity = t2.alert_severity and t2.source_type = (case when t1.service_id is null then t1.source_type else 0 end) 
			left join notifications t3 on t1.id = t3.alert_id and t1.changed_at = t3.occured_at and t2.user_id = t3.user_id and t2.method = t3.method
		where t3.id is null;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `merge_alerts` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `merge_alerts`()
BEGIN
	insert into alerts (service_id, created_at, updated_at)
	select t1.service_id, now(), now()
	from checked_status t1
	where not exists (select 1 from alerts a1 where a1.service_id = t1.service_id)
	and t1.status <> 0;

	update alerts t1, checked_status t2 set 
	t1.severity = t2.status, t1.status = t2.status, t1.status_type = t2.status_type, t1.summary = t2.summary, 
	t1.last_check = from_unixtime(t2.last_check), t1.next_check = from_unixtime(t2.next_check), t1.updated_at = now(),
	t1.last_status = case when t2.status <> t1.status then t1.status else t1.last_status end,
	t1.changed_at = case when t2.status <> t1.status then from_unixtime(t2.last_check) else t1.changed_at end,
	t1.occured_at = case when t1.status = 0 then from_unixtime(t2.last_check) else t1.occured_at end,
	t1.occur_count = case when t1.status = 0 then 1 else t1.occur_count+1 end
	where t1.service_id = t2.service_id and (t1.status <> 0 or t2.status <> 0);

	update alerts t1, services t2 set t1.name = t2.name,
	t1.source_id = t2.serviceable_id,
	t1.source_type = t2.serviceable_type, t1.tenant_id = t2.tenant_id
	where t1.service_id = t2.id;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `merge_status` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `merge_status`()
BEGIN
	
	call merge_alerts();
	update services t1, checked_status t2 set 
	t1.status = t2.status, t1.summary = t2.summary,
	t1.last_check = from_unixtime(t2.last_check), t1.next_check = from_unixtime(t2.next_check), t1.updated_at = now(), 
	t1.last_time_ok = (case when t2.status = 0 then from_unixtime(t2.last_check) else t1.last_time_ok end),
	t1.last_time_warning = (case when t2.status = 1 then from_unixtime(t2.last_check) else t1.last_time_warning end),
	t1.last_time_critical = (case when t2.status = 2 then from_unixtime(t2.last_check) else t1.last_time_critical end),
	t1.last_time_unknown = (case when t2.status = 3 then from_unixtime(t2.last_check) else t1.last_time_unknown end)
	where t1.id = t2.service_id
	and exists (select 1 from checked_status a1 where a1.service_id = t1.id);
	
		
	truncate table checked_status;
	
	update hosts t1,services t2 set 
	t1.status = (case when t2.status in (0,1) then 0 when t2.status = 2 then 1 when t2.status = 3 then 2 when t2.status = 4 then 4 else 0 end),
	t1.summary = t2.summary,t1.updated_at = now(),t1.last_check = t2.last_check,t1.next_check = t2.next_check,
	t1.last_time_up = (case when t2.status in (0,1) then t2.last_check else t1.last_time_up end),
	t1.last_time_down = (case when t2.status = 2 then t2.last_check else t1.last_time_down end),
	t1.last_time_pending = (case when t2.status = 4 then t2.last_check else t1.last_time_pending end),
	t1.last_time_unknown = (case when t2.status = 3 then t2.last_check else t1.last_time_unknown end)
	where t2.serviceable_type = 1 and t2.serviceable_id = t1.id and t2.ctrl_state = 1;
	
	
	update apps t1,services t2 set 
	t1.status = (case when t2.status in (0,1) then 0 when t2.status = 2 then 1 when t2.status = 3 then 2 when t2.status = 4 then 3 else 0 end),
	t1.summary = t2.summary,t1.updated_at = now(),t1.last_check = t2.last_check,t1.next_check = t2.next_check,
	t1.last_time_up = (case when t2.status in (0,1) then t2.last_check else t1.last_time_up end),
	t1.last_time_down = (case when t2.status = 2 then t2.last_check else t1.last_time_down end),
	t1.last_time_pending = (case when t2.status = 4 then t2.last_check else t1.last_time_pending end),
	t1.last_time_unknown = (case when t2.status = 3 then t2.last_check else t1.last_time_unknown end)
	where t2.serviceable_type = 2 and t2.serviceable_id = t1.id and t2.ctrl_state = 1;

	
	update sites t1,services t2 set 
	t1.status = (case when t2.status in (0,1) then 0 when t2.status = 2 then 1 when t2.status = 3 then 3 when t2.status = 4 then 2 else 3 end),
	t1.summary = t2.summary,t1.updated_at = now(),t1.last_check = t2.last_check,t1.next_check = t2.next_check,
	t1.last_time_up = (case when t2.status in (0,1) then t2.last_check else t1.last_time_up end),
	t1.last_time_down = (case when t2.status = 2 then t2.last_check else t1.last_time_down end),
	t1.last_time_pending = (case when t2.status = 4 then t2.last_check else t1.last_time_pending end),
	t1.last_time_unknown = (case when t2.status = 3 then t2.last_check else t1.last_time_unknown end)
	where t2.serviceable_type = 3 and t2.serviceable_id = t1.id and t2.ctrl_state = 1;

	update networks t1,services t2 set 
	t1.status = (case when t2.status in (0,1) then 0 when t2.status = 2 then 1 when t2.status = 3 then 2 when t2.status = 4 then 4 else 0 end),
	t1.summary = t2.summary,t1.updated_at = now(),t1.last_check = t2.last_check,t1.next_check = t2.next_check,
	t1.last_time_up = (case when t2.status in (0,1) then t2.last_check else t1.last_time_up end),
	t1.last_time_down = (case when t2.status = 2 then t2.last_check else t1.last_time_down end),
	t1.last_time_pending = (case when t2.status = 4 then t2.last_check else t1.last_time_pending end),
	t1.last_time_unknown = (case when t2.status = 3 then t2.last_check else t1.last_time_unknown end)
	where t2.serviceable_type = 4 and t2.serviceable_id = t1.id and t2.ctrl_state = 1;	
	call create_notifications();
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2010-04-19 15:32:55
