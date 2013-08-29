CREATE DATABASE  IF NOT EXISTS `ead_eac` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `ead_eac`;
-- MySQL dump 10.13  Distrib 5.5.32, for debian-linux-gnu (x86_64)
--
-- Host: 127.0.0.1    Database: ead_eac
-- ------------------------------------------------------
-- Server version	5.5.32-0ubuntu0.12.04.1

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
-- Table structure for table `eac`
--

DROP TABLE IF EXISTS `eac`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `eac` (
  `eac_id` int(11) NOT NULL AUTO_INCREMENT,
  `eac_xml` mediumtext,
  `published` tinyint(1) DEFAULT '0',
  `ead_file` varchar(200) DEFAULT NULL,
  `updated` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created` datetime NOT NULL,
  PRIMARY KEY (`eac_id`),
  UNIQUE KEY `eac_id` (`eac_id`),
  UNIQUE KEY `ead_file` (`ead_file`),
  KEY `fk_ead_file_idx` (`ead_file`)
) ENGINE=InnoDB AUTO_INCREMENT=65 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPRESSED;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `eac`
--

LOCK TABLES `eac` WRITE;
/*!40000 ALTER TABLE `eac` DISABLE KEYS */;
/*!40000 ALTER TABLE `eac` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ead`
--

DROP TABLE IF EXISTS `ead`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ead` (
  `ead_id` int(11) NOT NULL AUTO_INCREMENT,
  `ead_xml` mediumtext,
  `ead_file` varchar(200) NOT NULL,
  PRIMARY KEY (`ead_id`),
  UNIQUE KEY `ead_file` (`ead_file`)
) ENGINE=InnoDB AUTO_INCREMENT=65 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPRESSED;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ead`
--

LOCK TABLES `ead` WRITE;
/*!40000 ALTER TABLE `ead` DISABLE KEYS */;
/*!40000 ALTER TABLE `ead` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mediawiki`
--

DROP TABLE IF EXISTS `mediawiki`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `mediawiki` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `wiki_text` mediumtext NOT NULL,
  `updated` varchar(45) DEFAULT NULL,
  `created` varchar(45) DEFAULT NULL,
  `eac_id` int(11) NOT NULL,
  `published` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `eac_id_UNIQUE` (`eac_id`),
  KEY `fkeacid_idx` (`eac_id`),
  CONSTRAINT `fkeacid` FOREIGN KEY (`eac_id`) REFERENCES `eac` (`eac_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=50 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mediawiki`
--

LOCK TABLES `mediawiki` WRITE;
/*!40000 ALTER TABLE `mediawiki` DISABLE KEYS */;
/*!40000 ALTER TABLE `mediawiki` ENABLE KEYS */;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `ead_eac`.`eac_BINS`
BEFORE INSERT ON `ead_eac`.`mediawiki`
FOR EACH ROW

	SET NEW.created = NOW(), NEW.updated = NOW() */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Dumping routines for database 'ead_eac'
--
/*!50003 DROP PROCEDURE IF EXISTS `get_wiki` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_wiki`(IN ead_xml_path VARCHAR(200))
    DETERMINISTIC
BEGIN
SELECT eac_id from eac WHERE ead_file LIKE  CONCAT("%",ead_xml_path,"%") INTO @eac_id;
SELECT wiki_text FROM mediawiki WHERE eac_id = @eac_id;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `insert_wiki` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_wiki`(IN wikitext MEDIUMTEXT, IN ead_xml_path VARCHAR(200))
    DETERMINISTIC
BEGIN
SELECT eac_id from eac WHERE ead_file LIKE  CONCAT("%",ead_xml_path,"%") INTO @eac_id;
INSERT INTO ead_eac.mediawiki (wiki_text,eac_id) VALUES (wikitext, @eac_id) 
ON DUPLICATE KEY UPDATE mediawiki.wiki_text = wikitext;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `update_wiki` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `update_wiki`(IN wikitext MEDIUMTEXT, IN ead_xml_path VARCHAR(200))
    DETERMINISTIC
BEGIN
SELECT eac_id from eac WHERE ead_file LIKE  CONCAT("%",ead_xml_path,"%") INTO @eac_id;
UPDATE ead_eac.mediawiki SET wiki_text = wikitext WHERE eac_id = @eac_id;
END ;;
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

-- Dump completed on 2013-08-29 19:53:40
