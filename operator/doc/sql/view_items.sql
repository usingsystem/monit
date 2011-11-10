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
-- Table structure for table `view_items`
--

DROP TABLE IF EXISTS `view_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `view_items` (
  `id` int(11) NOT NULL auto_increment,
  `view_id` int(11) default NULL,
  `name` varchar(100) default NULL,
  `alias` varchar(100) default NULL,
  `data_type` varchar(10) default 'int',
  `data_unit` varchar(20) default NULL,
  `data_format` varchar(255) default NULL,
  `data_format_params` varchar(255) default NULL,
  `width` varchar(10) default NULL,
  `height` varchar(10) default NULL,
  `fill` varchar(10) default NULL,
  `color` varchar(15) default NULL,
  `hover_color` varchar(15) default NULL,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=48 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `view_items`
--

LOCK TABLES `view_items` WRITE;
/*!40000 ALTER TABLE `view_items` DISABLE KEYS */;
INSERT INTO `view_items` VALUES (1,111,'host_name','主机','string',NULL,'link','content=${host_name}&href=/hosts/${host_id}',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(2,111,'service_name','服务','string',NULL,'link','content=${service_name}&href=/services/${service_id}',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(3,111,'used','已用空间','string','KB',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(4,111,'total','总空间','string','KB',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(5,111,'usage','使用率','float','%',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(6,112,'host_name','主机','string',NULL,'link','content=${host_name}&href=/hosts/${host_id}',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(7,112,'load1','1分钟负载','float','%',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(8,112,'load5','5分钟负载','float','%',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(9,112,'load15','15分钟负载','float','%',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(10,115,'host_name','主机','string',NULL,'link','content=${host_name}&href=/hosts/${host_id}',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(13,115,'buffers','Buffers内存','float','KB',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(14,115,'shared','Shared内存','float','KB',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(15,115,'cached','Cached内存','float','KB',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(16,115,'total','总内存','float','KB',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(17,115,'usage','使用率','float','%',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(19,116,'host_name','主机','string',NULL,'link','content=${host_name}&href=/hosts/${host_id}',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(20,116,'used','已用Swap','float','KB',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(21,116,'total','总Swap','float','KB',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(22,116,'usage','使用率','float','%',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(23,117,'host_name','主机','string',NULL,'link','content=${host_name}&href=/hosts/${host_id}',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(24,117,'running','运行中','int',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(25,117,'sleeping','睡眠中','int',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(26,117,'total','总任务数','int',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(27,118,'host_name','主机','string',NULL,'link','content=${host_name}&href=/hosts/${host_id}',NULL,NULL,NULL,NULL,NULL,NULL,NULL),(28,118,'rtmax','最大响应时间','float','ms',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(29,118,'rta','平均响应时间','float','ms',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(30,118,'rtmin','最小响应时间','float','ms',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(32,119,'parent_key','时间','datetime',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(33,119,'user','用户层执行时间','float','%',NULL,NULL,'2',NULL,'60','#FFCC00',NULL,NULL,NULL),(34,119,'system','内核层执行时间','float','%',NULL,NULL,'2',NULL,'60','#99CC00',NULL,NULL,NULL),(35,119,'iowait','io等待时间','float','%',NULL,NULL,'2',NULL,'60','#3399CC',NULL,NULL,NULL),(37,120,'idle','CPU','float','%',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(38,121,'parent_key','时间','datetime',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(39,121,'used','已用内存','float','KB',NULL,NULL,'2',NULL,'60','#3399CC',NULL,NULL,NULL),(40,121,'free','剩余内存','float','KB',NULL,NULL,'2',NULL,'60','#FF5700',NULL,NULL,NULL),(45,122,'buffers','Buffers内存','float','KB',NULL,NULL,NULL,NULL,NULL,'#FFCC00',NULL,NULL,NULL),(46,122,'cached','Cached内存','float','KB',NULL,NULL,NULL,NULL,NULL,'#99CC00',NULL,NULL,NULL),(47,122,'free','剩余内存','float','KB',NULL,NULL,NULL,NULL,NULL,'#3399CC',NULL,NULL,NULL);
/*!40000 ALTER TABLE `view_items` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2010-03-11  9:30:29
