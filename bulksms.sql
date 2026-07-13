-- MySQL dump 10.14  Distrib 5.5.68-MariaDB, for Linux (x86_64)
--
-- Host: 94.237.52.52    Database: bulksms
-- ------------------------------------------------------
-- Server version	5.7.31

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
-- Table structure for table `aauth_groups`
--
CREATE DATABASE IF NOT EXISTS `bulksms` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;

DROP TABLE IF EXISTS `aauth_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `aauth_groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` text NOT NULL,
  `active` int(11) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`),
  KEY `id_index` (`id`),
  KEY `id_2` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `aauth_perm_to_group`
--

DROP TABLE IF EXISTS `aauth_perm_to_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `aauth_perm_to_group` (
  `auth_perm_to_groupID` int(11) NOT NULL AUTO_INCREMENT,
  `permID` int(11) NOT NULL,
  `group_id` int(11) DEFAULT NULL,
  `active` int(11) NOT NULL DEFAULT '1',
  PRIMARY KEY (`auth_perm_to_groupID`),
  UNIQUE KEY `auth_perm_to_groupID` (`auth_perm_to_groupID`),
  KEY `perm_id_group_id_index` (`group_id`),
  KEY `permID` (`permID`),
  KEY `group_id` (`group_id`),
  CONSTRAINT `aauth_perm_to_group_ibfk_1` FOREIGN KEY (`permID`) REFERENCES `aauth_perms` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `aauth_perm_to_group_ibfk_2` FOREIGN KEY (`group_id`) REFERENCES `aauth_groups` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=466 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `aauth_perm_to_user`
--

DROP TABLE IF EXISTS `aauth_perm_to_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `aauth_perm_to_user` (
  `aauth_perm_to_userID` int(11) NOT NULL AUTO_INCREMENT,
  `perm_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `active` int(11) NOT NULL,
  `insertedBy` int(11) NOT NULL DEFAULT '0',
  `dateCreated` datetime NOT NULL DEFAULT '1000-01-01 00:00:00',
  `updatedBy` int(11) NOT NULL DEFAULT '0',
  `dateModified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`aauth_perm_to_userID`),
  UNIQUE KEY `aauth_perm_to_userID` (`aauth_perm_to_userID`),
  KEY `perm_id_user_id_index` (`perm_id`,`user_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `aauth_perm_to_user_ibfk_1` FOREIGN KEY (`perm_id`) REFERENCES `aauth_perms` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `aauth_perm_to_user_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `aauth_users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `aauth_perms`
--

DROP TABLE IF EXISTS `aauth_perms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `aauth_perms` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` text,
  `definition` text,
  `active` int(11) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`),
  KEY `id_index` (`id`),
  KEY `id_2` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=71 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `aauth_user_to_group`
--

DROP TABLE IF EXISTS `aauth_user_to_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `aauth_user_to_group` (
  `aauth_user_to_groupID` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL DEFAULT '0',
  `group_id` int(11) NOT NULL DEFAULT '0',
  `active` int(11) NOT NULL,
  PRIMARY KEY (`aauth_user_to_groupID`),
  KEY `user_id_group_id_index` (`user_id`,`group_id`),
  CONSTRAINT `aauth_user_to_group_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `aauth_users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `aauth_user_variables`
--

DROP TABLE IF EXISTS `aauth_user_variables`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `aauth_user_variables` (
  `auther_user_variableID` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `key` text NOT NULL,
  `value` text,
  PRIMARY KEY (`auther_user_variableID`),
  KEY `user_id_index` (`user_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `aauth_user_variables_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `aauth_users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `aauth_users`
--

DROP TABLE IF EXISTS `aauth_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `aauth_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `role_id` int(11) NOT NULL,
  `clientID` int(11) NOT NULL,
  `password` text NOT NULL,
  `auth_key` varchar(45) NOT NULL,
  `email` text NOT NULL,
  `active` int(11) NOT NULL,
  `last_login` datetime DEFAULT NULL,
  `last_activity` datetime DEFAULT NULL,
  `last_login_attempt` datetime DEFAULT NULL,
  `forgot_exp` text,
  `remember_time` datetime DEFAULT NULL,
  `remember_exp` text,
  `verification_code` text,
  `ip_address` text,
  `login_attempts` int(11) DEFAULT '0',
  `insertedBy` int(11) NOT NULL DEFAULT '0',
  `dateCreated` datetime NOT NULL DEFAULT '1000-01-01 00:00:00',
  `updatedBy` int(11) NOT NULL DEFAULT '0',
  `dateModified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_index` (`id`),
  KEY `client_tb_FK_idx` (`clientID`),
  KEY `role_fk_idx` (`role_id`),
  CONSTRAINT `client_tb_FK` FOREIGN KEY (`clientID`) REFERENCES `clients` (`clientID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `role_fk` FOREIGN KEY (`role_id`) REFERENCES `aauth_groups` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=82 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `clients`
--

DROP TABLE IF EXISTS `clients`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `clients` (
  `clientID` int(11) NOT NULL AUTO_INCREMENT,
  `countryID` int(11) unsigned NOT NULL,
  `clientName` varchar(100) NOT NULL,
  `clientDesc` varchar(255) DEFAULT NULL,
  `clientLogo` varchar(255) DEFAULT NULL,
  `clientCode` varchar(10) NOT NULL,
  `contactPersonName` varchar(100) NOT NULL,
  `telephoneNo` varchar(30) NOT NULL,
  `postalAddress` varchar(100) DEFAULT NULL,
  `physicalAddress` varchar(100) DEFAULT NULL,
  `emailAddress` varchar(200) NOT NULL,
  `active` tinyint(3) unsigned NOT NULL DEFAULT '2',
  `message_max_threshold` bigint(20) NOT NULL,
  `message_min_threshold` bigint(20) NOT NULL,
  `activityHistory` text,
  `defaultCurrencyID` int(11) unsigned DEFAULT NULL,
  `totalConsumers` int(11) unsigned DEFAULT NULL,
  `totalActiveConsumers` int(11) unsigned DEFAULT NULL,
  `totalActiveWalletConsumers` int(11) unsigned DEFAULT NULL,
  `settlementBankBranchID` int(11) unsigned DEFAULT NULL,
  `settlementAccountName` varchar(250) DEFAULT NULL,
  `settlementAccountNumber` varchar(30) DEFAULT NULL,
  `settlementCharge` double(15,2) DEFAULT NULL,
  `insertedBy` int(11) NOT NULL DEFAULT '0',
  `dateCreated` datetime NOT NULL DEFAULT '1000-01-01 00:00:00',
  `updatedBy` int(11) NOT NULL DEFAULT '0',
  `dateModified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`clientID`),
  UNIQUE KEY `clientName_UNIQUE` (`clientName`),
  KEY `fk_clientSystems_countries1_idx` (`countryID`),
  KEY `fk_clients_currency_idx` (`defaultCurrencyID`),
  KEY `fk_clients_brank_branchs_idx` (`settlementBankBranchID`),
  CONSTRAINT `country_tb_fk` FOREIGN KEY (`countryID`) REFERENCES `countries` (`countryID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8 COMMENT='This table stores our clientsâ€™ information. A client is an';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `countries`
--

DROP TABLE IF EXISTS `countries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `countries` (
  `countryID` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `countryName` varchar(30) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `dialCode` int(5) unsigned NOT NULL DEFAULT '0',
  `root_domain` varchar(4) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `abbrv` varchar(4) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `ISO_CODE` varchar(5) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `notes` varchar(200) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `insertedBy` int(10) unsigned NOT NULL DEFAULT '0',
  `dateCreated` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `updatedBy` int(10) unsigned NOT NULL DEFAULT '0',
  `dateModified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`countryID`),
  UNIQUE KEY `countryName` (`countryName`)
) ENGINE=InnoDB AUTO_INCREMENT=249 DEFAULT CHARSET=utf8 COMMENT='This is a lookup table that stores information on countries';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `dlr`
--

DROP TABLE IF EXISTS `dlr`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `dlr` (
  `smsc` varchar(255) NOT NULL,
  `ts` datetime NOT NULL,
  `source` varchar(255) NOT NULL,
  `destination` varchar(255) NOT NULL,
  `service` varchar(255) DEFAULT NULL,
  `url` varchar(255) NOT NULL,
  `mask` int(10) unsigned NOT NULL,
  `status` int(10) unsigned NOT NULL,
  `boxc` varchar(255) DEFAULT NULL,
  `dlr_id` varchar(255) NOT NULL,
  PRIMARY KEY (`dlr_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `failed_jobs`
--

DROP TABLE IF EXISTS `failed_jobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `failed_jobs` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `uuid` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `connection` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `queue` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `exception` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`)
) ENGINE=InnoDB AUTO_INCREMENT=1041 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `go4mobility_logs`
--

DROP TABLE IF EXISTS `go4mobility_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `go4mobility_logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `momId` text,
  `recDate` text,
  `msisdn` text,
  `shortCode` text,
  `alias` text,
  `text` text,
  `date_received` datetime DEFAULT CURRENT_TIMESTAMP,
  `status` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=496112 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `jobs`
--

DROP TABLE IF EXISTS `jobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `jobs` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `queue` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `attempts` tinyint(3) unsigned NOT NULL,
  `reserved_at` int(10) unsigned DEFAULT NULL,
  `available_at` int(10) unsigned NOT NULL,
  `created_at` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `jobs_queue_index` (`queue`)
) ENGINE=InnoDB AUTO_INCREMENT=632003 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `message_floats`
--

DROP TABLE IF EXISTS `message_floats`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `message_floats` (
  `floatAccountID` int(11) NOT NULL AUTO_INCREMENT,
  `clientID` int(11) NOT NULL,
  `Balance` bigint(20) NOT NULL,
  `prebalance` bigint(20) DEFAULT NULL,
  `defaultSourceAddress` text NOT NULL,
  `dateCreated` datetime NOT NULL DEFAULT '1000-01-01 00:00:00',
  `dateModified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `createdBy` int(11) NOT NULL DEFAULT '0',
  `updatedBy` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`floatAccountID`),
  KEY `payerclient_fk_idx` (`clientID`),
  CONSTRAINT `client_key` FOREIGN KEY (`clientID`) REFERENCES `clients` (`clientID`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=42 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `message_templates`
--

DROP TABLE IF EXISTS `message_templates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `message_templates` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `clientID` int(11) NOT NULL,
  `name` text,
  `template` text NOT NULL,
  `sms_source_address` text,
  `upload_file_location` text,
  `processed_file_location` text,
  `dialCode` int(11) DEFAULT NULL,
  `status` int(11) NOT NULL DEFAULT '0',
  `type` int(11) DEFAULT '1',
  `insertedBy` int(11) NOT NULL DEFAULT '0',
  `dateCreated` datetime NOT NULL DEFAULT '1000-01-01 00:00:00',
  `updatedBy` int(11) NOT NULL DEFAULT '0',
  `dateModified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=966 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `messages`
--

DROP TABLE IF EXISTS `messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `messages` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `clientID` int(11) NOT NULL,
  `templateID` int(11) NOT NULL,
  `sourceAddress` varchar(30) NOT NULL,
  `destinationAddress` varchar(18) DEFAULT NULL,
  `message` text NOT NULL,
  `message_length` int(11) DEFAULT NULL,
  `no_of_units` int(11) DEFAULT NULL,
  `countryCode` int(11) DEFAULT NULL,
  `batchID` varchar(255) DEFAULT NULL,
  `sms_source_id` varchar(255) DEFAULT NULL,
  `sms_mno_id` varchar(255) DEFAULT NULL,
  `overalStatus` int(11) NOT NULL DEFAULT '0',
  `statusHistory` text COMMENT 'This column maintains the history status of the bulk. should contain the folowing {appID,status,date}',
  `statusDescription` text,
  `gatewayStatus` text,
  `delivery_status` varchar(255) DEFAULT NULL,
  `gatewayResponseMessage` text,
  `retry` tinyint(1) DEFAULT '0',
  `no_of_retry` int(11) DEFAULT NULL,
  `lastSend` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `firstSend` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `nextsend` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `numberOfSends` int(10) unsigned NOT NULL DEFAULT '0',
  `dateCreated` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `dateModified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `updatedBy` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `numberofsends` (`numberOfSends`),
  KEY `nextSend` (`nextsend`),
  KEY `overalStatus` (`overalStatus`),
  KEY `dateCreated_idx` (`dateCreated`),
  KEY `dateCreated_channelResponses_idx` (`dateCreated`,`id`),
  KEY `client_fk_idx` (`clientID`),
  KEY `template_fk_idx` (`templateID`),
  CONSTRAINT `client_fk` FOREIGN KEY (`clientID`) REFERENCES `clients` (`clientID`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `template_fk` FOREIGN KEY (`templateID`) REFERENCES `message_templates` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=3065943 DEFAULT CHARSET=utf8 COMMENT='channelResponses stores responses to be sent out to users by';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `messages_test`
--

DROP TABLE IF EXISTS `messages_test`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `messages_test` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `clientID` int(11) NOT NULL,
  `templateID` int(11) NOT NULL,
  `sourceAddress` varchar(30) NOT NULL,
  `destinationAddress` varchar(255) NOT NULL,
  `message` text NOT NULL,
  `message_length` int(11) DEFAULT NULL,
  `no_of_units` int(11) DEFAULT NULL,
  `overalStatus` int(11) NOT NULL DEFAULT '0',
  `statusHistory` text COMMENT 'This column maintains the history status of the bulk. should contain the folowing {appID,status,date}',
  `statusDescription` text,
  `gatewayStatus` text,
  `gatewayResponseMessage` text,
  `retry` tinyint(1) DEFAULT '0',
  `lastSend` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `firstSend` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `nextsend` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `numberOfSends` int(10) unsigned NOT NULL DEFAULT '0',
  `dateCreated` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `dateModified` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `updatedBy` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `numberofsends` (`numberOfSends`),
  KEY `nextSend` (`nextsend`),
  KEY `overalStatus` (`overalStatus`),
  KEY `dateCreated_idx` (`dateCreated`),
  KEY `dateCreated_channelResponses_idx` (`dateCreated`,`id`),
  KEY `client_fk_idx` (`clientID`),
  KEY `template_fk_idx` (`templateID`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8 COMMENT='channelResponses stores responses to be sent out to users by';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sessions`
--

DROP TABLE IF EXISTS `sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sessions` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` bigint(20) unsigned DEFAULT NULL,
  `ip_address` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_agent` text COLLATE utf8mb4_unicode_ci,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_activity` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `smppclients`
--

DROP TABLE IF EXISTS `smppclients`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `smppclients` (
  `smppClientId` int(11) NOT NULL AUTO_INCREMENT,
  `systemId` varchar(100) NOT NULL,
  `password` varchar(255) DEFAULT NULL,
  `userId` int(11) DEFAULT NULL,
  `clientId` int(11) DEFAULT NULL,
  `serverIp` varchar(100) DEFAULT NULL,
  `port` int(30) DEFAULT NULL,
  `whiteListedIp` varchar(200) DEFAULT NULL,
  `active` tinyint(3) unsigned NOT NULL DEFAULT '1',
  `createdBy` int(11) NOT NULL DEFAULT '0',
  `createdAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedBy` int(11) NOT NULL DEFAULT '0',
  `updatedAt` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`smppClientId`),
  UNIQUE KEY `clientName_UNIQUE` (`systemId`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COMMENT='This table stores our clientsâ€™ information. A client is an';
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-07-13 10:37:09
