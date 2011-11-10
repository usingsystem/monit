-- MySQL dump 10.11
--
-- Host: localhost    Database: monit
-- ------------------------------------------------------
-- Server version	5.0.86

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
-- Table structure for table `views`
--

DROP TABLE IF EXISTS `views`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `views` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(50) default NULL,
  `visible_type` varchar(20) default NULL COMMENT '1:host_type, 2:app_type, 3:s\\nervice_type',
  `visible_id` int(11) default NULL,
  `data_params` varchar(255) default NULL,
  `template` varchar(50) default NULL,
  `dimensionality` int(11) default '3',
  `enable` tinyint(4) default '1',
  `width` varchar(10) default NULL,
  `height` varchar(10) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=123 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `views`
--

LOCK TABLES `views` WRITE;
/*!40000 ALTER TABLE `views` DISABLE KEYS */;
INSERT INTO `views` VALUES (111,'磁盘使用率','report_top',NULL,'service_type=check_disk_df&sort=usage','table',3,1,NULL,NULL,NULL,NULL),(112,'负载','report_top',NULL,'service_type=check_load&sort=load1','table',3,0,NULL,NULL,NULL,NULL),(113,'网络流量','report_top',NULL,'service_type=check_if&sort=load1','table',3,0,NULL,NULL,NULL,NULL),(114,'网络丢包率','report_top',NULL,NULL,'table',3,0,NULL,NULL,NULL,NULL),(115,'内存使用率','report_top',NULL,'service_type=check_mem_free&sort=usage','table',3,1,NULL,NULL,NULL,NULL),(116,'SWAP使用率','report_top',NULL,'service_type=check_swap_free&sort=usage','table',3,1,NULL,NULL,NULL,NULL),(117,'任务数','report_top',NULL,'service_type=check_task_top&sort=total','table',3,1,NULL,NULL,NULL,NULL),(118,'Ping时延','report_top',NULL,'service_type=check_ping&sort=rta','table',3,1,NULL,NULL,NULL,NULL),(119,'CPU使用率变化','service_history',5,NULL,'amline_stacked',3,1,'100%','300',NULL,NULL),(120,'CPU使用','service_current',5,NULL,'google_visualization_gauge',2,1,'270','270',NULL,NULL),(121,'内存使用变化','service_history',7,NULL,'amline_stacked',3,1,'100%','300',NULL,NULL),(122,'内存使用','service_current',7,NULL,'ampie',2,1,'90%','270',NULL,NULL);
/*!40000 ALTER TABLE `views` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2010-03-11  9:30:17
