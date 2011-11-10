-- MySQL dump 10.13  Distrib 5.1.37, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: monit
-- ------------------------------------------------------
-- Server version	5.1.37-1ubuntu5.1-log

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
) ENGINE=InnoDB AUTO_INCREMENT=53 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `alert_notifications`
--

DROP TABLE IF EXISTS `alert_notifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `alert_notifications` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `method` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `alert_id` int(11) DEFAULT NULL,
  `alert_name` varchar(100) DEFAULT NULL,
  `alert_severity` int(2) DEFAULT NULL,
  `alert_status` int(2) DEFAULT NULL,
  `alert_last_status` int(2) DEFAULT NULL,
  `alert_summary` varchar(255) DEFAULT NULL,
  `service_id` int(11) DEFAULT NULL,
  `source_id` int(11) DEFAULT NULL,
  `source_type` int(11) DEFAULT NULL,
  `tenant_id` int(11) DEFAULT NULL,
  `status` int(11) DEFAULT '0' COMMENT '0:unsent 1:sent',
  `last_notification` datetime DEFAULT NULL,
  `current_notification_number` int(11) DEFAULT '0',
  `occured_at` datetime DEFAULT NULL,
  `changed_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=29255 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

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
  `ctrl_state` tinyint(2) DEFAULT NULL,
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
) ENGINE=InnoDB AUTO_INCREMENT=7409 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

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
-- Table structure for table `apps`
--

DROP TABLE IF EXISTS `apps`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `apps` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
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
  `status` int(2) DEFAULT '2',
  `summary` varchar(200) DEFAULT NULL,
  `last_update` datetime DEFAULT NULL,
  `last_time_up` datetime DEFAULT NULL,
  `last_time_down` datetime DEFAULT NULL,
  `last_time_pending` datetime DEFAULT NULL,
  `last_time_unknown` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `last_notification` datetime DEFAULT NULL,
  `current_notification_number` int(11) DEFAULT '0',
  `notifications_enabled` tinyint(2) DEFAULT '1',
  `first_notification_delay` int(11) DEFAULT '300',
  `notification_interval` int(11) DEFAULT '7200',
  `notification_times` int(11) DEFAULT '1',
  `notify_on_recovery` tinyint(2) DEFAULT '1',
  `notify_on_down` tinyint(2) DEFAULT '1',
  `group_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=49 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
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
		INSERT INTO object_changed 
		(
			object_class,
			object_id,
			agent_id,
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
			new.agent_id,
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
		INSERT INTO object_changed 
		(
			object_class,
			object_id,
			agent_id,
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
			new.agent_id,
			new.uuid,
			1,
			new.discovery_state,
			(select addr from hosts where id = new.host_id),
			old.created_at,
			now()
		);
	elseif (old.host_id <> new.host_id) or (old.name <> new.name) or (old.agent_id <> new.agent_id) or (old.tenant_id <> new.tenant_id) or (old.type_id <> new.type_id) or (old.port <> new.port) or (old.login_name <> new.login_name) or (old.password <> new.password) or (old.status_url <> new.status_url) then
		INSERT INTO object_changed 
		(
			object_class,
			object_id,
			agent_id,
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
			new.agent_id,
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
		INSERT INTO object_changed 
		(
			object_class,
			object_id,
			agent_id,
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
			old.agent_id,
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
-- Table structure for table `bills`
--

DROP TABLE IF EXISTS `bills`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `bills` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tenant_id` int(11) DEFAULT NULL,
  `amount` decimal(9,2) DEFAULT NULL COMMENT '涉及金额',
  `balance` decimal(9,2) DEFAULT NULL,
  `summary` varchar(255) DEFAULT NULL COMMENT '使用描述',
  `begin_date` datetime DEFAULT NULL,
  `end_date` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL COMMENT '产生时间',
  `updated_at` datetime DEFAULT NULL,
  `operator_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13424 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

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
  `uuid` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

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
-- Table structure for table `device_oids`
--

DROP TABLE IF EXISTS `device_oids`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `device_oids` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `oid` varchar(100) DEFAULT NULL,
  `type` varchar(100) DEFAULT NULL,
  `vendor` varchar(100) DEFAULT NULL,
  `category` varchar(100) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `oid_index` (`oid`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `device_types`
--

DROP TABLE IF EXISTS `device_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `device_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  `parent_id` int(11) DEFAULT NULL,
  `level` int(11) DEFAULT NULL COMMENT '1:parent 2:son',
  `creator` int(11) DEFAULT NULL,
  `remark` varchar(100) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `devices`
--

DROP TABLE IF EXISTS `devices`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `devices` (
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
  `status` int(2) NOT NULL DEFAULT '2',
  `summary` varchar(200) DEFAULT NULL,
  `last_time_up` datetime DEFAULT NULL,
  `last_time_down` datetime DEFAULT NULL,
  `last_time_pending` datetime DEFAULT NULL,
  `last_time_unknown` datetime DEFAULT NULL,
  `last_time_unreachable` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `last_notification` datetime DEFAULT NULL,
  `current_notification_number` int(11) DEFAULT '0',
  `notifications_enabled` tinyint(2) DEFAULT '1',
  `first_notification_delay` int(11) DEFAULT '300',
  `notification_interval` int(11) DEFAULT '7200',
  `notification_times` int(11) DEFAULT '1',
  `notify_on_recovery` tinyint(2) DEFAULT '1',
  `notify_on_down` tinyint(2) DEFAULT '1',
  `notify_on_unreachable` tinyint(2) DEFAULT '1',
  `group_id` int(11) DEFAULT NULL,
  `dev_type` varchar(50) DEFAULT NULL,
  `dev_vendor` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=83 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `monit`.`trigger_devices_insert` AFTER INSERT ON monit.devices FOR EACH ROW
BEGIN
	IF (new.addr IS NOT NULL) AND (new.uuid IS NOT NULL)
		THEN 
		INSERT INTO object_changed 
		(
			object_class,
			object_id,
			agent_id,
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
			new.agent_id,
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `monit`.`trigger_devices_update` AFTER UPDATE ON monit.devices FOR EACH ROW
BEGIN
	IF (old.addr is null and new.addr IS NOT NULL) or (old.uuid is null and new.uuid IS NOT NULL)
		THEN 
		INSERT INTO object_changed 
		(
			object_class,
			object_id,
			agent_id,
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
			new.agent_id,
			new.uuid,
			1,
			new.discovery_state,
			new.addr,
			old.created_at,
			now()
		);
	elseif (old.addr <> new.addr) or (old.name <> new.name) or (old.tenant_id <> new.tenant_id) or (old.agent_id <> new.agent_id) or (old.type_id <> new.type_id) or (old.port <> new.port) or (old.snmp_ver <> new.snmp_ver) or (old.community <> new.community) or (old.discovery_state <> new.discovery_state and new.discovery_state = 2) then
		INSERT INTO object_changed 
		(
			object_class,
			object_id,
			agent_id,
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
			new.agent_id,
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `monit`.`trigger_devices_delete` AFTER DELETE ON monit.devices FOR EACH ROW
BEGIN
	IF (old.addr IS NOT NULL) AND (old.uuid IS NOT NULL)
		THEN 
		INSERT INTO object_changed 
		(
			object_class,
			object_id,
			agent_id,
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
			old.agent_id,
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
) ENGINE=InnoDB AUTO_INCREMENT=1080 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `disco_types`
--

DROP TABLE IF EXISTS `disco_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `disco_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `object_class` int(2) DEFAULT '1' COMMENT '1:host_types 2:app_types',
  `object_type` int(11) DEFAULT NULL,
  `method` int(11) DEFAULT NULL,
  `command` varchar(100) DEFAULT NULL,
  `args` varchar(255) DEFAULT NULL,
  `service_type` int(11) DEFAULT NULL,
  `external` int(2) DEFAULT '1',
  `remark` varchar(100) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `groups`
--

DROP TABLE IF EXISTS `groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tenant_id` int(11) DEFAULT NULL,
  `parent_id` int(11) DEFAULT NULL,
  `name_alias` varchar(50) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `descr` varchar(50) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

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
  `status` int(2) DEFAULT '2',
  `summary` varchar(200) DEFAULT NULL,
  `last_time_up` datetime DEFAULT NULL,
  `last_time_down` datetime DEFAULT NULL,
  `last_time_pending` datetime DEFAULT NULL,
  `last_time_unknown` datetime DEFAULT NULL,
  `last_time_unreachable` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `last_notification` datetime DEFAULT NULL,
  `current_notification_number` int(11) DEFAULT '0',
  `notifications_enabled` tinyint(2) DEFAULT '1',
  `first_notification_delay` int(11) DEFAULT '300',
  `notification_interval` int(11) DEFAULT '7200',
  `notification_times` int(11) DEFAULT '1',
  `notify_on_recovery` tinyint(2) DEFAULT '1',
  `notify_on_down` tinyint(2) DEFAULT '1',
  `notify_on_unreachable` tinyint(2) DEFAULT '0',
  `group_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=173 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
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
		INSERT INTO object_changed 
		(
			object_class,
			object_id,
			agent_id,
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
			new.agent_id,
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
		INSERT INTO object_changed 
		(
			object_class,
			object_id,
			agent_id,
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
			new.agent_id,
			new.uuid,
			1,
			new.discovery_state,
			new.addr,
			old.created_at,
			now()
		);
	elseif (old.addr <> new.addr) or (old.name <> new.name) or (old.tenant_id <> new.tenant_id) or (old.agent_id <> new.agent_id) or (old.type_id <> new.type_id) or (old.port <> new.port) or (old.snmp_ver <> new.snmp_ver) or (old.community <> new.community) or (old.discovery_state <> new.discovery_state and new.discovery_state = 2) then
		INSERT INTO object_changed 
		(
			object_class,
			object_id,
			agent_id,
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
			new.agent_id,
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
		INSERT INTO object_changed 
		(
			object_class,
			object_id,
			agent_id,
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
			old.agent_id,
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
-- Table structure for table `idea_comments`
--

DROP TABLE IF EXISTS `idea_comments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `idea_comments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `idea_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `content` blob,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `idea_types`
--

DROP TABLE IF EXISTS `idea_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `idea_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `desc` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `idea_votes`
--

DROP TABLE IF EXISTS `idea_votes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `idea_votes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `idea_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `num` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ideas`
--

DROP TABLE IF EXISTS `ideas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ideas` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `title` varchar(500) DEFAULT NULL,
  `content` blob,
  `status` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

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
) ENGINE=InnoDB AUTO_INCREMENT=144 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `locales`
--

DROP TABLE IF EXISTS `locales`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `locales` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `country` varchar(20) DEFAULT NULL,
  `language` varchar(20) DEFAULT NULL,
  `res` varchar(100) DEFAULT NULL,
  `string` varchar(300) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=160 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

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
  `user_name` varchar(100) DEFAULT NULL,
  `action` varchar(100) DEFAULT NULL,
  `result` varchar(100) DEFAULT NULL,
  `details` varchar(100) DEFAULT NULL,
  `module_name` varchar(10) DEFAULT NULL,
  `terminal_ip` varchar(20) DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3718 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `logm_securities`
--

DROP TABLE IF EXISTS `logm_securities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `logm_securities` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `session` varchar(50) DEFAULT NULL,
  `user` int(11) DEFAULT NULL,
  `user_name` varchar(255) DEFAULT NULL,
  `terminal_ip` varchar(255) DEFAULT NULL,
  `host_name` varchar(255) DEFAULT NULL,
  `security_cause` varchar(255) DEFAULT NULL,
  `details` varchar(255) DEFAULT NULL,
  `affected_user` varchar(255) DEFAULT NULL,
  `security_action` varchar(255) DEFAULT NULL,
  `result` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=292 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `notifications`
--

DROP TABLE IF EXISTS `notifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `notifications` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `method` int(11) DEFAULT NULL COMMENT '0:email 1:phone',
  `address` varchar(255) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `contact` varchar(255) DEFAULT NULL,
  `type_id` int(11) DEFAULT NULL COMMENT '1:alert 2:report',
  `tenant_id` int(11) DEFAULT NULL,
  `status` int(11) DEFAULT '0' COMMENT '0:unsent 1:sent 2:read',
  `title` varchar(100) DEFAULT NULL,
  `summary` varchar(255) DEFAULT NULL,
  `content` blob,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=25015 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `object_changed`
--

DROP TABLE IF EXISTS `object_changed`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `object_changed` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `agent_id` int(11) DEFAULT NULL,
  `object_class` int(2) DEFAULT NULL,
  `object_id` int(11) DEFAULT NULL,
  `uuid` varchar(50) DEFAULT NULL,
  `oper_type` int(2) DEFAULT NULL COMMENT '1: add 2:delete 3:update',
  `discovery_state` int(2) DEFAULT NULL COMMENT '0:undiscovery 1:discoveried 2:rediscovery',
  `addr` varchar(50) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=575 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `operators`
--

DROP TABLE IF EXISTS `operators`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `operators` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `host` varchar(255) NOT NULL COMMENT '域名',
  `title` varchar(255) NOT NULL COMMENT '网站名称',
  `logo_url` varchar(255) DEFAULT NULL COMMENT '登录后顶部LOGO',
  `biglogo_url` varchar(255) DEFAULT NULL,
  `footer` text COMMENT '底部',
  `descr` text COMMENT '描述',
  `telphone` varchar(255) DEFAULT NULL,
  `contact` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `remember_token` varchar(40) DEFAULT NULL,
  `remember_token_expires_at` datetime DEFAULT NULL,
  `crypted_password` varchar(255) DEFAULT NULL,
  `salt` varchar(255) DEFAULT NULL,
  `activated_at` date DEFAULT NULL,
  `activation_code` varchar(255) DEFAULT NULL,
  `company` varchar(100) DEFAULT NULL COMMENT '公司名称',
  `is_support_bank` tinyint(1) DEFAULT '0' COMMENT '是否支持银行支付',
  `bank` varchar(100) DEFAULT NULL COMMENT '开户银行',
  `bank_account_name` varchar(100) DEFAULT NULL COMMENT '开户名称',
  `bank_account` varchar(50) DEFAULT NULL COMMENT '开户帐号',
  `bank_tax_number` varchar(50) DEFAULT NULL COMMENT '税务登记号',
  `bank_payment_number` varchar(50) DEFAULT NULL COMMENT '现代化支付系统行号',
  `is_support_alipay` tinyint(1) DEFAULT '0' COMMENT '是否支持支付宝',
  `alipay_email` varchar(255) DEFAULT NULL COMMENT '支付宝帐号',
  `alipay_partner` varchar(255) DEFAULT NULL COMMENT '支付宝partner',
  `alipay_key` varchar(255) DEFAULT NULL COMMENT '支付宝key',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `page_contact` text COMMENT '联系我们页面内容',
  `page_about` text COMMENT '关于我们页面内容',
  PRIMARY KEY (`id`),
  KEY `index_operators_on_host` (`host`)
) ENGINE=InnoDB AUTO_INCREMENT=123528 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `orders` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tenant_id` int(11) NOT NULL COMMENT '租户id',
  `package_id` int(11) DEFAULT NULL COMMENT '套餐',
  `month_num` int(3) DEFAULT NULL COMMENT '时长(月)',
  `out_trade_no` varchar(50) DEFAULT NULL COMMENT '订单号',
  `total_fee` decimal(9,2) DEFAULT NULL COMMENT '付费金额',
  `body` varchar(255) DEFAULT NULL COMMENT '标题',
  `subject` varchar(500) DEFAULT NULL COMMENT '内容',
  `status` int(2) DEFAULT '0' COMMENT '0:waiting, 1: paid',
  `is_paid` tinyint(1) DEFAULT '0',
  `pay_mode` int(1) DEFAULT NULL COMMENT '支付方式 1:支付宝 2:线下支付',
  `paid_at` datetime DEFAULT NULL COMMENT '支付日期',
  `paid_desc` text COMMENT '支付描述',
  `trade_no` varchar(50) DEFAULT NULL,
  `is_support_alipay` tinyint(1) DEFAULT NULL COMMENT '是否支持支付宝',
  `alipay_notify_params` text COMMENT '支付宝付费通知参数',
  `alipay_return_params` text COMMENT '支付宝返回参数',
  `alipay_url` text COMMENT '支付宝支付连接',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=121301 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `packages`
--

DROP TABLE IF EXISTS `packages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `packages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `operator_id` int(11) DEFAULT NULL,
  `category` int(11) DEFAULT NULL COMMENT '0:free, 1:standard, 2:enterprise',
  `name` varchar(255) DEFAULT NULL,
  `charge` int(9) DEFAULT NULL COMMENT '费用，整数',
  `year_charge` int(9) DEFAULT NULL COMMENT '年付费',
  `year_discount` int(9) DEFAULT '0' COMMENT '年折扣（节省）',
  `year_discount_rate` int(3) DEFAULT NULL,
  `max_hosts` int(11) DEFAULT NULL,
  `max_services` int(11) DEFAULT NULL,
  `min_check_interval` int(11) DEFAULT '300',
  `remark` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1037 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

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
) ENGINE=InnoDB AUTO_INCREMENT=260 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `service_entries`
--

DROP TABLE IF EXISTS `service_entries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `service_entries` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type_id` int(11) DEFAULT NULL COMMENT 'service_type',
  `is_table` tinyint(2) DEFAULT NULL,
  `is_replaced` int(2) DEFAULT '0',
  `name` varchar(50) DEFAULT NULL,
  `storage` int(11) DEFAULT '1',
  `desc` varchar(50) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `service_metrics`
--

DROP TABLE IF EXISTS `service_metrics`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `service_metrics` (
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
) ENGINE=InnoDB AUTO_INCREMENT=187 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

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
  `required` int(2) DEFAULT '0',
  `desc` varchar(100) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=117 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `service_types`
--

DROP TABLE IF EXISTS `service_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `service_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `default_name` varchar(100) DEFAULT NULL,
  `alias` varchar(100) DEFAULT NULL,
  `check_type` int(2) DEFAULT NULL COMMENT '1:passive 2:active',
  `disco_type` int(2) DEFAULT '0' COMMENT '1:snmp 2:ssh 3:local',
  `command` varchar(100) DEFAULT NULL,
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
) ENGINE=InnoDB AUTO_INCREMENT=44 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

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
  `status` int(2) DEFAULT '4',
  `status_type` int(2) DEFAULT '2' COMMENT '1:Transient 2:Permanent',
  `summary` varchar(1000) DEFAULT NULL,
  `metric_data` text,
  `last_time_ok` datetime DEFAULT NULL,
  `last_time_warning` datetime DEFAULT NULL,
  `last_time_critical` datetime DEFAULT NULL,
  `last_time_unknown` datetime DEFAULT NULL,
  `threshold_critical` varchar(200) DEFAULT NULL,
  `threshold_warning` varchar(200) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `last_notification` datetime DEFAULT NULL,
  `current_notification_number` int(11) DEFAULT '0',
  `notifications_enabled` tinyint(2) DEFAULT '1',
  `first_notification_delay` int(11) DEFAULT '300',
  `notification_interval` int(11) DEFAULT '7200',
  `notification_times` int(11) DEFAULT '1',
  `notify_on_recovery` tinyint(2) DEFAULT '1',
  `notify_on_warning` tinyint(2) DEFAULT '0',
  `notify_on_unknown` tinyint(2) DEFAULT '0',
  `notify_on_critical` tinyint(2) DEFAULT '1',
  `flap_detection_enabled` tinyint(2) DEFAULT '1',
  `is_flapping` tinyint(2) DEFAULT '0',
  `flap_low_threshold` int(11) DEFAULT '20',
  `flap_high_threshold` int(11) DEFAULT '30',
  `flap_percent_state_change` int(11) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `i_service_command` (`serviceable_type`,`serviceable_id`,`command`,`params`)
) ENGINE=InnoDB AUTO_INCREMENT=1638 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
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
		INSERT INTO object_changed 
		(
			object_class,
			object_id,
			agent_id,
			uuid,
			oper_type,
			discovery_state,
			addr,
			created_at,
			updated_at
		)
		VALUES (
			0,
			new.id,
			new.agent_id,
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
		INSERT INTO object_changed 
		(
			object_class,
			object_id,
			agent_id,
			uuid,
			oper_type,
			discovery_state,
			addr,
			created_at,
			updated_at
		)
		VALUES (
			0,
			new.id,
			new.agent_id,
			new.uuid,
			1,
			null,
			null,
			old.created_at,
			now()
		);
	elseif (old.serviceable_type <> new.serviceable_type) or (old.serviceable_id <> new.serviceable_id) or (old.name <> new.name) or (old.params <> new.params) or (old.check_interval <> new.check_interval) or (old.threshold_critical <> new.threshold_critical) or (old.threshold_warning <> new.threshold_warning) or (old.max_attempts <> new.max_attempts) or (old.attempt_interval <> new.attempt_interval) or (old.external <> new.external) or (old.tenant_id <> new.tenant_id) or (old.agent_id <> new.agent_id) then
		INSERT INTO object_changed 
		(
			object_class,
			object_id,
			agent_id,
			uuid,
			oper_type,
			discovery_state,
			addr,
			created_at,
			updated_at
		)
		VALUES (
			0,
			new.id,
			new.agent_id,
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
		INSERT INTO object_changed 
		(
			object_class,
			object_id,
			agent_id,
			uuid,
			oper_type,
			discovery_state,
			addr,
			created_at,
			updated_at
		)
		VALUES (
			0,
			old.id,
			old.agent_id,
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
  `agent_id` int(11) DEFAULT NULL,
  `tenant_id` int(11) DEFAULT NULL,
  `discovery_state` int(2) DEFAULT '0' COMMENT '0:undiscovery 1:discoveried 2:rediscovery',
  `last_check` datetime DEFAULT NULL,
  `next_check` datetime DEFAULT NULL,
  `duration` int(11) DEFAULT NULL,
  `status` int(2) DEFAULT '2',
  `summary` varchar(200) DEFAULT NULL,
  `last_update` datetime DEFAULT NULL,
  `last_time_up` datetime DEFAULT NULL,
  `last_time_down` datetime DEFAULT NULL,
  `last_time_pending` datetime DEFAULT NULL,
  `last_time_unknown` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `last_notification` datetime DEFAULT NULL,
  `current_notification_number` int(11) DEFAULT '0',
  `notifications_enabled` tinyint(2) DEFAULT '1',
  `first_notification_delay` int(11) DEFAULT '300',
  `notification_interval` int(11) DEFAULT '7200',
  `notification_times` int(11) DEFAULT '1',
  `notify_on_recovery` tinyint(2) DEFAULT '1',
  `notify_on_down` tinyint(2) DEFAULT '1',
  `group_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=129 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;
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
		INSERT INTO object_changed 
		(
			object_class,
			object_id,
			agent_id,
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
			new.agent_id,
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
		INSERT INTO object_changed 
		(
			object_class,
			object_id,
			agent_id,
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
			new.agent_id,
			new.uuid,
			1,
			new.discovery_state,
			new.url,
			old.created_at,
			now()
		);
	elseif (old.url <> new.url) or (old.name <> new.name) or (old.addr <> new.addr) or (old.port <> new.port) or (old.path <> new.path) or (old.agent_id <> new.agent_id) or (old.tenant_id <> new.tenant_id) then
		INSERT INTO object_changed 
		(
			object_class,
			object_id,
			agent_id,
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
			new.agent_id,
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
		INSERT INTO object_changed 
		(
			object_class,
			object_id,
			agent_id,
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
			old.agent_id,
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
  `operator_id` int(11) DEFAULT '0',
  `balance` decimal(10,2) DEFAULT '0.00' COMMENT '帐户余额',
  `package_id` int(11) DEFAULT NULL,
  `begin_at` date DEFAULT NULL COMMENT '套餐使用开始日期',
  `month_num` int(11) DEFAULT '0' COMMENT '套餐使用月数',
  `end_at` date DEFAULT NULL COMMENT '套餐使用结束日期',
  `expired_at` date DEFAULT NULL COMMENT '使用过期日期',
  `current_month` int(11) DEFAULT '0' COMMENT '当前月数',
  `current_paid_at` date DEFAULT NULL COMMENT '当前月付费日期',
  `next_paid_at` date DEFAULT NULL COMMENT '下月付费日期',
  `status` int(2) DEFAULT '0',
  `is_pay_account` tinyint(1) DEFAULT '0' COMMENT '是否付费帐户',
  `role` int(3) DEFAULT '0' COMMENT '0:普通用户，1:测试用户',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=148 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

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
  `group_id` int(11) DEFAULT NULL,
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
  `weekly` tinyint(1) DEFAULT '1' COMMENT '????',
  `daily` tinyint(1) DEFAULT '1' COMMENT '????',
  `monthly` tinyint(1) DEFAULT '1' COMMENT '????',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=143 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

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
) ENGINE=InnoDB AUTO_INCREMENT=1430 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

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
) ENGINE=InnoDB AUTO_INCREMENT=786 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

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
/*!50106 CREATE EVENT `clear_alerts_event` ON SCHEDULE EVERY 1 DAY STARTS '2010-04-27 11:02:15' ON COMPLETION NOT PRESERVE ENABLE DO CALL clear_alerts() */ ;;
/*!50003 SET time_zone             = @saved_time_zone */ ;;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;;
/*!50003 SET character_set_client  = @saved_cs_client */ ;;
/*!50003 SET character_set_results = @saved_cs_results */ ;;
/*!50003 SET collation_connection  = @saved_col_connection */ ;;
/*!50106 DROP EVENT IF EXISTS `clear_disco_services_event` */;;
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
/*!50106 CREATE EVENT `clear_disco_services_event` ON SCHEDULE EVERY 1 DAY STARTS '2010-04-27 16:22:47' ON COMPLETION NOT PRESERVE ENABLE DO CALL clear_disco_services() */ ;;
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
/*!50106 CREATE EVENT `merge_status_event` ON SCHEDULE EVERY 1 MINUTE STARTS '2010-04-27 11:02:16' ON COMPLETION NOT PRESERVE ENABLE DO CALL merge_status() */ ;;
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
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
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
/*!50003 DROP PROCEDURE IF EXISTS `clear_disco_services` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `clear_disco_services`()
BEGIN
		delete from disco_services where  exists (select 1 from services t1 where t1.serviceable_type=disco_services.serviceable_type and t1.serviceable_id=disco_services.serviceable_id and t1.type_id=disco_services.type_id and t1.params=disco_services.params);
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
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50020 DEFINER=`root`@`localhost`*/ /*!50003 PROCEDURE `create_notifications`()
BEGIN
	/*create services notifications*/
	insert into alert_notifications (last_notification, current_notification_number, method, user_id, alert_id, alert_name, alert_severity, alert_status, alert_last_status, alert_summary, service_id, source_id, source_type, tenant_id, status, occured_at, changed_at, created_at, updated_at)	
		select t2.last_notification last_notification, (t2.current_notification_number+1) current_notification_number, 
			0 method, t3.id user_id, t1.id alert_id, t1.name alert_name, t1.severity, t1.status alert_status, t1.last_status alert_last_status, t1.summary alert_summary, t1.service_id service_id, t1.source_id source_id, t1.source_type source_type, t1.tenant_id tenant_id, 0 status, t1.occured_at occured_at, t1.changed_at changed_at, now() created_at, now() updated_at
			from alerts t1, services t2, users t3 
			where t1.service_id = t2.id and t1.tenant_id = t3.tenant_id and t1.status_type = 2 and t2.notifications_enabled=1
				and (UNIX_TIMESTAMP(t1.last_check) - UNIX_TIMESTAMP(t1.occured_at) >= t2.first_notification_delay) 
				and ( t1.status=IF(t2.notify_on_recovery=1,0, -1) or t1.status=IF(t2.notify_on_warning=1,1, -1) or t1.status=IF(t2.notify_on_critical=1,2, -1) or t1.status=IF(t2.notify_on_unknown=1,3, -1))
				and (t1.status=0 or t2.last_notification is null or (UNIX_TIMESTAMP(t2.last_notification) + t2.notification_interval) < UNIX_TIMESTAMP(now()))
				and (t1.status=0 or t2.notification_times=0 or t2.notification_times > t2.current_notification_number)
				and t2.current_notification_number > IF(t1.status=0,0,-1);


	update alerts t1, services t2, users t3 
		set t2.last_notification = (case when t1.status=0 then null else now() end), t2.current_notification_number = (case when t1.status=0 then 0 else t2.current_notification_number+1 end) 
		where t1.service_id = t2.id and t1.tenant_id = t3.tenant_id and t1.status_type = 2 and t2.notifications_enabled=1
			and (UNIX_TIMESTAMP(t1.last_check) - UNIX_TIMESTAMP(t1.occured_at) >= t2.first_notification_delay) 
			and ( t1.status=IF(t2.notify_on_recovery=1,0, -1) or t1.status=IF(t2.notify_on_warning=1,1, -1) or t1.status=IF(t2.notify_on_critical=1,2, -1) or t1.status=IF(t2.notify_on_unknown=1,3, -1))
			and (t1.status=0 or t2.last_notification is null or (UNIX_TIMESTAMP(t2.last_notification) + t2.notification_interval) < UNIX_TIMESTAMP(now()))
			and (t1.status=0 or t2.notification_times=0 or t2.notification_times > t2.current_notification_number) 
			and t2.current_notification_number > IF(t1.status=0,0,-1);

	/*create hosts notifications*/
	insert into alert_notifications (last_notification, current_notification_number, method, user_id, alert_id, alert_name, alert_severity, alert_status, alert_last_status, alert_summary, service_id, source_id, source_type, tenant_id, status, occured_at, changed_at, created_at, updated_at)	
		select t2.last_notification last_notification, (t2.current_notification_number+1) current_notification_number, 
			0 method, t3.id user_id, t1.id alert_id, t1.name alert_name, t1.severity, t1.status alert_status, t1.last_status alert_last_status, t1.summary alert_summary, t1.service_id service_id, t1.source_id source_id, t1.source_type source_type, t1.tenant_id tenant_id, 0 status, t1.occured_at occured_at, t1.changed_at changed_at, now() created_at, now() updated_at
			from alerts t1, hosts t2, users t3 
			where t1.service_id is null and t1.source_type = 1 and t1.source_id = t2.id and t1.tenant_id = t3.tenant_id and t1.status_type = 2 and t2.notifications_enabled=1
				and (UNIX_TIMESTAMP(t1.last_check) - UNIX_TIMESTAMP(t1.occured_at) >= t2.first_notification_delay) 
				and ( t1.status=IF(t2.notify_on_recovery=1,0, -1) or t1.status=IF(t2.notify_on_down=1,1, -1) or t1.status=IF(t2.notify_on_unreachable=1,3, -1))
				and (t1.status=0 or t2.last_notification is null or (UNIX_TIMESTAMP(t2.last_notification) + t2.notification_interval) < UNIX_TIMESTAMP(now()))
				and (t1.status=0 or t2.notification_times=0 or t2.notification_times > t2.current_notification_number)
				and t2.current_notification_number > IF(t1.status=0,0,-1);


	update alerts t1, hosts t2, users t3 
		set t2.last_notification = (case when t1.status=0 then null else now() end), t2.current_notification_number = (case when t1.status=0 then 0 else t2.current_notification_number+1 end) 
		where t1.service_id is null and t1.source_type = 1 and t1.source_id = t2.id and t1.tenant_id = t3.tenant_id and t1.status_type = 2 and t2.notifications_enabled=1
			and (UNIX_TIMESTAMP(t1.last_check) - UNIX_TIMESTAMP(t1.occured_at) >= t2.first_notification_delay) 
			and ( t1.status=IF(t2.notify_on_recovery=1,0, -1) or t1.status=IF(t2.notify_on_down=1,1, -1) or t1.status=IF(t2.notify_on_unreachable=1,3, -1))
			and (t1.status=0 or t2.last_notification is null or (UNIX_TIMESTAMP(t2.last_notification) + t2.notification_interval) < UNIX_TIMESTAMP(now()))
			and (t1.status=0 or t2.notification_times=0 or t2.notification_times > t2.current_notification_number) 
			and t2.current_notification_number > IF(t1.status=0,0,-1);

	/*create devices notifications*/
	insert into alert_notifications (last_notification, current_notification_number, method, user_id, alert_id, alert_name, alert_severity, alert_status, alert_last_status, alert_summary, service_id, source_id, source_type, tenant_id, status, occured_at, changed_at, created_at, updated_at)	
		select t2.last_notification last_notification, (t2.current_notification_number+1) current_notification_number, 
			0 method, t3.id user_id, t1.id alert_id, t1.name alert_name, t1.severity, t1.status alert_status, t1.last_status alert_last_status, t1.summary alert_summary, t1.service_id service_id, t1.source_id source_id, t1.source_type source_type, t1.tenant_id tenant_id, 0 status, t1.occured_at occured_at, t1.changed_at changed_at, now() created_at, now() updated_at
			from alerts t1, devices t2, users t3 
			where t1.service_id is null and t1.source_type = 4 and t1.source_id = t2.id and t1.tenant_id = t3.tenant_id and t1.status_type = 2 and t2.notifications_enabled=1
				and (UNIX_TIMESTAMP(t1.last_check) - UNIX_TIMESTAMP(t1.occured_at) >= t2.first_notification_delay) 
				and ( t1.status=IF(t2.notify_on_recovery=1,0, -1) or t1.status=IF(t2.notify_on_down=1,1, -1) or t1.status=IF(t2.notify_on_unreachable=1,3, -1))
				and (t1.status=0 or t2.last_notification is null or (UNIX_TIMESTAMP(t2.last_notification) + t2.notification_interval) < UNIX_TIMESTAMP(now()))
				and (t1.status=0 or t2.notification_times=0 or t2.notification_times > t2.current_notification_number)
				and t2.current_notification_number > IF(t1.status=0,0,-1);


	update alerts t1, devices t2, users t3 
		set t2.last_notification = (case when t1.status=0 then null else now() end), t2.current_notification_number = (case when t1.status=0 then 0 else t2.current_notification_number+1 end) 
		where t1.service_id is null and t1.source_type = 4 and t1.source_id = t2.id and t1.tenant_id = t3.tenant_id and t1.status_type = 2 and t2.notifications_enabled=1
			and (UNIX_TIMESTAMP(t1.last_check) - UNIX_TIMESTAMP(t1.occured_at) >= t2.first_notification_delay) 
			and ( t1.status=IF(t2.notify_on_recovery=1,0, -1) or t1.status=IF(t2.notify_on_down=1,1, -1) or t1.status=IF(t2.notify_on_unreachable=1,3, -1))
			and (t1.status=0 or t2.last_notification is null or (UNIX_TIMESTAMP(t2.last_notification) + t2.notification_interval) < UNIX_TIMESTAMP(now()))
			and (t1.status=0 or t2.notification_times=0 or t2.notification_times > t2.current_notification_number) 
			and t2.current_notification_number > IF(t1.status=0,0,-1);

	/*create apps notifications*/
	insert into alert_notifications (last_notification, current_notification_number, method, user_id, alert_id, alert_name, alert_severity, alert_status, alert_last_status, alert_summary, service_id, source_id, source_type, tenant_id, status, occured_at, changed_at, created_at, updated_at)	
		select t2.last_notification last_notification, (t2.current_notification_number+1) current_notification_number, 
			0 method, t3.id user_id, t1.id alert_id, t1.name alert_name, t1.severity, t1.status alert_status, t1.last_status alert_last_status, t1.summary alert_summary, t1.service_id service_id, t1.source_id source_id, t1.source_type source_type, t1.tenant_id tenant_id, 0 status, t1.occured_at occured_at, t1.changed_at changed_at, now() created_at, now() updated_at
			from alerts t1, apps t2, users t3 
			where t1.service_id is null and t1.source_type = 2 and t1.source_id = t2.id and t1.tenant_id = t3.tenant_id and t1.status_type = 2 and t2.notifications_enabled=1
				and (UNIX_TIMESTAMP(t1.last_check) - UNIX_TIMESTAMP(t1.occured_at) >= t2.first_notification_delay) 
				and ( t1.status=IF(t2.notify_on_recovery=1,0, -1) or t1.status=IF(t2.notify_on_down=1,1, -1))
				and (t1.status=0 or t2.last_notification is null or (UNIX_TIMESTAMP(t2.last_notification) + t2.notification_interval) < UNIX_TIMESTAMP(now()))
				and (t1.status=0 or t2.notification_times=0 or t2.notification_times > t2.current_notification_number)
				and t2.current_notification_number > IF(t1.status=0,0,-1);


	update alerts t1, apps t2, users t3 
		set t2.last_notification = (case when t1.status=0 then null else now() end), t2.current_notification_number = (case when t1.status=0 then 0 else t2.current_notification_number+1 end) 
		where t1.service_id is null and t1.source_type = 2 and t1.source_id = t2.id and t1.tenant_id = t3.tenant_id and t1.status_type = 2 and t2.notifications_enabled=1
			and (UNIX_TIMESTAMP(t1.last_check) - UNIX_TIMESTAMP(t1.occured_at) >= t2.first_notification_delay) 
			and ( t1.status=IF(t2.notify_on_recovery=1,0, -1) or t1.status=IF(t2.notify_on_down=1,1, -1))
			and (t1.status=0 or t2.last_notification is null or (UNIX_TIMESTAMP(t2.last_notification) + t2.notification_interval) < UNIX_TIMESTAMP(now()))
			and (t1.status=0 or t2.notification_times=0 or t2.notification_times > t2.current_notification_number) 
			and t2.current_notification_number > IF(t1.status=0,0,-1);
			
	/*create sites notifications*/
	insert into alert_notifications (last_notification, current_notification_number, method, user_id, alert_id, alert_name, alert_severity, alert_status, alert_last_status, alert_summary, service_id, source_id, source_type, tenant_id, status, occured_at, changed_at, created_at, updated_at)	
		select t2.last_notification last_notification, (t2.current_notification_number+1) current_notification_number, 
			0 method, t3.id user_id, t1.id alert_id, t1.name alert_name, t1.severity, t1.status alert_status, t1.last_status alert_last_status, t1.summary alert_summary, t1.service_id service_id, t1.source_id source_id, t1.source_type source_type, t1.tenant_id tenant_id, 0 status, t1.occured_at occured_at, t1.changed_at changed_at, now() created_at, now() updated_at
			from alerts t1, sites t2, users t3 
			where t1.service_id is null and t1.source_type = 3 and t1.source_id = t2.id and t1.tenant_id = t3.tenant_id and t1.status_type = 2 and t2.notifications_enabled=1
				and (UNIX_TIMESTAMP(t1.last_check) - UNIX_TIMESTAMP(t1.occured_at) >= t2.first_notification_delay) 
				and ( t1.status=IF(t2.notify_on_recovery=1,0, -1) or t1.status=IF(t2.notify_on_down=1,1, -1))
				and (t1.status=0 or t2.last_notification is null or (UNIX_TIMESTAMP(t2.last_notification) + t2.notification_interval) < UNIX_TIMESTAMP(now()))
				and (t1.status=0 or t2.notification_times=0 or t2.notification_times > t2.current_notification_number)
				and t2.current_notification_number > IF(t1.status=0,0,-1);


	update alerts t1, sites t2, users t3 
		set t2.last_notification = (case when t1.status=0 then null else now() end), t2.current_notification_number = (case when t1.status=0 then 0 else t2.current_notification_number+1 end) 
		where t1.service_id is null and t1.source_type = 3 and t1.source_id = t2.id and t1.tenant_id = t3.tenant_id and t1.status_type = 2 and t2.notifications_enabled=1
			and (UNIX_TIMESTAMP(t1.last_check) - UNIX_TIMESTAMP(t1.occured_at) >= t2.first_notification_delay) 
			and ( t1.status=IF(t2.notify_on_recovery=1,0, -1) or t1.status=IF(t2.notify_on_down=1,1, -1))
			and (t1.status=0 or t2.last_notification is null or (UNIX_TIMESTAMP(t2.last_notification) + t2.notification_interval) < UNIX_TIMESTAMP(now()))
			and (t1.status=0 or t2.notification_times=0 or t2.notification_times > t2.current_notification_number) 
			and t2.current_notification_number > IF(t1.status=0,0,-1);
			
		
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

	update alerts t1, services t2 set t1.name = t2.name, t1.ctrl_state = t2.ctrl_state,
	t1.source_id = t2.serviceable_id,
	t1.source_type = t2.serviceable_type, t1.tenant_id = t2.tenant_id
	where t1.service_id = t2.id;
	
	/*merge source alert*/
	insert into alerts (source_type, source_id, name, tenant_id, created_at, updated_at)
		select t1.source_type, t1.source_id, t1.name, t1.tenant_id, now(), now()
		from alerts t1
		where not exists (select 1 from alerts a1 where a1.source_type = t1.source_type and a1.source_id = t1.source_id and a1.service_id is null)
		and t1.ctrl_state = 1;
	

	update alerts t1, alerts t2 set t1.summary = t2.summary, t1.status_type = t2.status_type, 
		t1.occur_count = t2.occur_count, t1.last_check = t2.last_check, t1.next_check = t2.next_check, 
		t1.occured_at = t2.occured_at, t1.changed_at = t2.changed_at, t1.severity = t2.severity,
		t1.status = (case when t2.status in (0,1) then 0 when t2.status in (2,3) then 1 when t2.status = 4 then 2 else 0 end),
		t1.last_status = (case when t2.last_status in (0,1) then 0 when t2.last_status in (2,3) then 1 when t2.last_status = 4 then 2 else 0 end)
	where t1.service_id is null and t2.ctrl_state = 1 and t1.source_type = t2.source_type and t1.source_id = t2.source_id;
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
	t1.status = (case when t2.status in (0,1) then 0 when t2.status in (2,3) then 1 when t2.status = 4 then 2 else 0 end),
	t1.summary = t2.summary,t1.updated_at = now(),t1.last_check = t2.last_check,t1.next_check = t2.next_check,
	t1.last_time_up = (case when t2.status in (0,1) then t2.last_check else t1.last_time_up end),
	t1.last_time_down = (case when t2.status in (2,3) then t2.last_check else t1.last_time_down end),
	t1.last_time_pending = (case when t2.status = 4 then t2.last_check else t1.last_time_pending end)
	where t2.serviceable_type = 1 and t2.serviceable_id = t1.id and t2.ctrl_state = 1;
	
	
	update apps t1,services t2 set 
	t1.status = (case when t2.status in (0,1) then 0 when t2.status in (2,3) then 1 when t2.status = 4 then 2 else 0 end),
	t1.summary = t2.summary,t1.updated_at = now(),t1.last_check = t2.last_check,t1.next_check = t2.next_check,
	t1.last_time_up = (case when t2.status in (0,1) then t2.last_check else t1.last_time_up end),
	t1.last_time_down = (case when t2.status in (2,3) then t2.last_check else t1.last_time_down end),
	t1.last_time_pending = (case when t2.status = 4 then t2.last_check else t1.last_time_pending end)
	where t2.serviceable_type = 2 and t2.serviceable_id = t1.id and t2.ctrl_state = 1;

	
	update sites t1,services t2 set 
	t1.status = (case when t2.status in (0,1) then 0 when t2.status in (2,3) then 1 when t2.status = 4 then 2 else 0 end),
	t1.summary = t2.summary,t1.updated_at = now(),t1.last_check = t2.last_check,t1.next_check = t2.next_check,
	t1.last_time_up = (case when t2.status in (0,1) then t2.last_check else t1.last_time_up end),
	t1.last_time_down = (case when t2.status in (2,3) then t2.last_check else t1.last_time_down end),
	t1.last_time_pending = (case when t2.status = 4 then t2.last_check else t1.last_time_pending end)
	where t2.serviceable_type = 3 and t2.serviceable_id = t1.id and t2.ctrl_state = 1;

	update devices t1,services t2 set 
	t1.status = (case when t2.status in (0,1) then 0 when t2.status in (2,3) then 1 when t2.status = 4 then 2 else 0 end),
	t1.summary = t2.summary,t1.updated_at = now(),t1.last_check = t2.last_check,t1.next_check = t2.next_check,
	t1.last_time_up = (case when t2.status in (0,1) then t2.last_check else t1.last_time_up end),
	t1.last_time_down = (case when t2.status in (2,3) then t2.last_check else t1.last_time_down end),
	t1.last_time_pending = (case when t2.status = 4 then t2.last_check else t1.last_time_pending end)
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

-- Dump completed on 2010-07-30 12:01:06
