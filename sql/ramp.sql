-- phpMyAdmin SQL Dump
-- version 3.4.10.1deb1
-- http://www.phpmyadmin.net
--
-- Servidor: localhost
-- Tiempo de generación: 29-08-2013 a las 19:27:58
-- Versión del servidor: 5.5.32
-- Versión de PHP: 5.3.10-1ubuntu3.7

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Base de datos: `ead_eac`
--

DELIMITER $$
--
-- Procedimientos
--
DROP PROCEDURE IF EXISTS `get_wiki`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `get_wiki`(IN ead_xml_path VARCHAR(200))
    DETERMINISTIC
BEGIN
SELECT eac_id from eac WHERE ead_file LIKE  CONCAT("%",ead_xml_path,"%") INTO @eac_id;
SELECT wiki_text FROM mediawiki WHERE eac_id = @eac_id;
END$$

DROP PROCEDURE IF EXISTS `insert_wiki`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insert_wiki`(IN wikitext MEDIUMTEXT, IN ead_xml_path VARCHAR(200))
    DETERMINISTIC
BEGIN
SELECT eac_id from eac WHERE ead_file LIKE  CONCAT("%",ead_xml_path,"%") INTO @eac_id;
INSERT INTO ead_eac.mediawiki (wiki_text,eac_id) VALUES (wikitext, @eac_id) 
ON DUPLICATE KEY UPDATE mediawiki.wiki_text = wikitext;
END$$

DROP PROCEDURE IF EXISTS `update_wiki`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `update_wiki`(IN wikitext MEDIUMTEXT, IN ead_xml_path VARCHAR(200))
    DETERMINISTIC
BEGIN
SELECT eac_id from eac WHERE ead_file LIKE  CONCAT("%",ead_xml_path,"%") INTO @eac_id;
UPDATE ead_eac.mediawiki SET wiki_text = wikitext WHERE eac_id = @eac_id;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `eac`
--

DROP TABLE IF EXISTS `eac`;
CREATE TABLE IF NOT EXISTS `eac` (
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
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 ROW_FORMAT=COMPRESSED AUTO_INCREMENT=65 ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ead`
--

DROP TABLE IF EXISTS `ead`;
CREATE TABLE IF NOT EXISTS `ead` (
  `ead_id` int(11) NOT NULL AUTO_INCREMENT,
  `ead_xml` mediumtext,
  `ead_file` varchar(200) NOT NULL,
  PRIMARY KEY (`ead_id`),
  UNIQUE KEY `ead_file` (`ead_file`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 ROW_FORMAT=COMPRESSED AUTO_INCREMENT=65 ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `mediawiki`
--

DROP TABLE IF EXISTS `mediawiki`;
CREATE TABLE IF NOT EXISTS `mediawiki` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `wiki_text` mediumtext NOT NULL,
  `updated` varchar(45) DEFAULT NULL,
  `created` varchar(45) DEFAULT NULL,
  `eac_id` int(11) NOT NULL,
  `published` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `eac_id_UNIQUE` (`eac_id`),
  KEY `fkeacid_idx` (`eac_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=50 ;

--
-- Disparadores `mediawiki`
--
DROP TRIGGER IF EXISTS `eac_BINS`;
DELIMITER //
CREATE TRIGGER `eac_BINS` BEFORE INSERT ON `mediawiki`
 FOR EACH ROW SET NEW.created = NOW(), NEW.updated = NOW()
//
DELIMITER ;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `mediawiki`
--
ALTER TABLE `mediawiki`
  ADD CONSTRAINT `fkeacid` FOREIGN KEY (`eac_id`) REFERENCES `eac` (`eac_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
