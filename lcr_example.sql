-- MySQL dump 10.13  Distrib 8.0.29, for Linux (x86_64)
--
-- Host: localhost    Database: kamailio
-- ------------------------------------------------------
-- Server version	8.0.29-0ubuntu0.22.04.2

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `lcr_gw`
--

DROP TABLE IF EXISTS `lcr_gw`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `lcr_gw` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `lcr_id` smallint unsigned NOT NULL,
  `gw_name` varchar(128) DEFAULT NULL,
  `ip_addr` varchar(50) DEFAULT NULL,
  `hostname` varchar(64) DEFAULT NULL,
  `port` smallint unsigned DEFAULT NULL,
  `params` varchar(64) DEFAULT NULL,
  `uri_scheme` tinyint unsigned DEFAULT NULL,
  `transport` tinyint unsigned DEFAULT NULL,
  `strip` tinyint unsigned DEFAULT NULL,
  `prefix` varchar(16) DEFAULT NULL,
  `tag` varchar(64) DEFAULT NULL,
  `flags` int unsigned NOT NULL DEFAULT '0',
  `defunct` int unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `lcr_id_idx` (`lcr_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=ascii;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lcr_gw`
--

LOCK TABLES `lcr_gw` WRITE;
/*!40000 ALTER TABLE `lcr_gw` DISABLE KEYS */;
INSERT INTO `lcr_gw` VALUES (1,1,'ISP1','SIP_TERMINATING_LOCATION_IP_TEMPLATE','SIP_TERMINATING_LOCATION_IP_TEMPLATE',5060,NULL,1,1,0,NULL,NULL,1,NULL);
/*!40000 ALTER TABLE `lcr_gw` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lcr_rule`
--

DROP TABLE IF EXISTS `lcr_rule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `lcr_rule` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `lcr_id` smallint unsigned NOT NULL,
  `prefix` varchar(16) DEFAULT NULL,
  `from_uri` varchar(64) DEFAULT NULL,
  `request_uri` varchar(64) DEFAULT NULL,
  `mt_tvalue` varchar(128) DEFAULT NULL,
  `stopper` int unsigned NOT NULL DEFAULT '0',
  `enabled` int unsigned NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `lcr_id_prefix_from_uri_idx` (`lcr_id`,`prefix`,`from_uri`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=ascii;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lcr_rule`
--

LOCK TABLES `lcr_rule` WRITE;
/*!40000 ALTER TABLE `lcr_rule` DISABLE KEYS */;
INSERT INTO `lcr_rule` VALUES (1,1,'1917',NULL,NULL,NULL,0,1),(2,1,'1',NULL,NULL,NULL,0,1);
/*!40000 ALTER TABLE `lcr_rule` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `lcr_rule_target`
--

DROP TABLE IF EXISTS `lcr_rule_target`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `lcr_rule_target` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `lcr_id` smallint unsigned NOT NULL,
  `rule_id` int unsigned NOT NULL,
  `gw_id` int unsigned NOT NULL,
  `priority` tinyint unsigned NOT NULL,
  `weight` int unsigned NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `rule_id_gw_id_idx` (`rule_id`,`gw_id`),
  KEY `lcr_id_idx` (`lcr_id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=ascii;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `lcr_rule_target`
--

LOCK TABLES `lcr_rule_target` WRITE;
/*!40000 ALTER TABLE `lcr_rule_target` DISABLE KEYS */;
INSERT INTO `lcr_rule_target` VALUES (1,1,1,2,3,1),(2,1,1,1,2,1);
/*!40000 ALTER TABLE `lcr_rule_target` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-06-17 16:14:38