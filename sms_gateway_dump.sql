-- MariaDB dump 10.19-11.8.6-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: sms_gateway
-- ------------------------------------------------------
-- Server version	11.8.6-MariaDB-6 from Debian

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*M!100616 SET @OLD_NOTE_VERBOSITY=@@NOTE_VERBOSITY, NOTE_VERBOSITY=0 */;

--
-- Table structure for table `_prisma_migrations`
--

DROP TABLE IF EXISTS `_prisma_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `_prisma_migrations` (
  `id` varchar(36) NOT NULL,
  `checksum` varchar(64) NOT NULL,
  `finished_at` datetime(3) DEFAULT NULL,
  `migration_name` varchar(255) NOT NULL,
  `logs` text DEFAULT NULL,
  `rolled_back_at` datetime(3) DEFAULT NULL,
  `started_at` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `applied_steps_count` int(10) unsigned NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `_prisma_migrations`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `_prisma_migrations` WRITE;
/*!40000 ALTER TABLE `_prisma_migrations` DISABLE KEYS */;
/*!40000 ALTER TABLE `_prisma_migrations` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `api_key_capabilities`
--

DROP TABLE IF EXISTS `api_key_capabilities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `api_key_capabilities` (
  `id` char(36) NOT NULL,
  `name` varchar(100) NOT NULL,
  `module` varchar(100) NOT NULL,
  `description` varchar(255) NOT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `api_key_capabilities_name_key` (`name`),
  KEY `api_key_capabilities_module_idx` (`module`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `api_key_capabilities`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `api_key_capabilities` WRITE;
/*!40000 ALTER TABLE `api_key_capabilities` DISABLE KEYS */;
INSERT INTO `api_key_capabilities` VALUES
('50bb995c-103a-4340-96c2-5252edfca0e0','messages.create','messages','Send SMS messages.','2026-09-10 11:07:28.326','2026-09-18 23:10:02.709'),
('993d2e2d-419a-44bd-8911-7f74b566125c','messages.read','messages','View messages.','2026-09-10 11:07:28.335','2026-09-18 23:10:02.716'),
('e1744171-860f-4513-abd3-1ee26583c2e2','messages.status.read','messages','View message delivery status.','2026-09-10 11:07:28.340','2026-09-18 23:10:02.719');
/*!40000 ALTER TABLE `api_key_capabilities` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `api_key_capability_assignments`
--

DROP TABLE IF EXISTS `api_key_capability_assignments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `api_key_capability_assignments` (
  `apiKeyId` char(36) NOT NULL,
  `capabilityId` char(36) NOT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  PRIMARY KEY (`apiKeyId`,`capabilityId`),
  KEY `api_key_capability_assignments_capabilityId_idx` (`capabilityId`),
  CONSTRAINT `api_key_capability_assignments_apiKeyId_fkey` FOREIGN KEY (`apiKeyId`) REFERENCES `api_keys` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `api_key_capability_assignments_capabilityId_fkey` FOREIGN KEY (`capabilityId`) REFERENCES `api_key_capabilities` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `api_key_capability_assignments`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `api_key_capability_assignments` WRITE;
/*!40000 ALTER TABLE `api_key_capability_assignments` DISABLE KEYS */;
INSERT INTO `api_key_capability_assignments` VALUES
('1f518793-632e-453b-a6cc-c96a4e044f77','50bb995c-103a-4340-96c2-5252edfca0e0','2026-09-10 11:09:53.531');
/*!40000 ALTER TABLE `api_key_capability_assignments` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `api_keys`
--

DROP TABLE IF EXISTS `api_keys`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `api_keys` (
  `id` char(36) NOT NULL,
  `publicId` varchar(20) NOT NULL,
  `clientId` char(36) NOT NULL,
  `name` varchar(100) NOT NULL,
  `prefix` varchar(20) NOT NULL,
  `status` enum('ACTIVE','REVOKED','EXPIRED') NOT NULL DEFAULT 'ACTIVE',
  `lastUsedAt` datetime(3) DEFAULT NULL,
  `expiresAt` datetime(3) DEFAULT NULL,
  `revokedAt` datetime(3) DEFAULT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL,
  `secretHash` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `api_keys_publicId_key` (`publicId`),
  UNIQUE KEY `api_keys_prefix_key` (`prefix`),
  KEY `api_keys_clientId_idx` (`clientId`),
  KEY `api_keys_status_idx` (`status`),
  KEY `api_keys_expiresAt_idx` (`expiresAt`),
  CONSTRAINT `api_keys_clientId_fkey` FOREIGN KEY (`clientId`) REFERENCES `clients` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `api_keys`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `api_keys` WRITE;
/*!40000 ALTER TABLE `api_keys` DISABLE KEYS */;
INSERT INTO `api_keys` VALUES
('1f518793-632e-453b-a6cc-c96a4e044f77','tcPF1RF5ihIqEQ','e4dc889e-dfb6-40e0-b388-d83762ebdd1c','SMPP_SERVER_02','db4b8d34b3c58418','ACTIVE','2026-09-12 18:04:23.389','2026-09-25 23:59:59.999',NULL,'2026-09-10 11:09:53.529','2026-09-12 18:04:23.390','450e891a3f93cd3f4595d4f3abf1edf6d17bead91057a7c37b703c4613ab1310'),
('59e0a7e1-82a1-48da-851d-0e99414b52ca','XfAma-w693YBvQ','9a8672a0-9bb4-425d-b30d-db7595b0eb22','test','e409bcb20d21371d','ACTIVE',NULL,'2026-09-05 23:59:59.999',NULL,'2026-09-03 22:27:04.787','2026-09-03 22:27:04.787','85d7b457cbf618d9462d24439ff765197b83ea4f088e89b3e46870692c9df05e'),
('7c76a2e8-ae9d-40bb-b9e2-7c019e2e7b97','oiWfSdUoihMo3w','e4dc889e-dfb6-40e0-b388-d83762ebdd1c','SMPP_SERVER','adca5f7e71832559','REVOKED','2026-09-10 10:58:20.434','2026-09-25 23:59:59.999','2026-09-10 11:01:40.177','2026-09-10 10:27:13.595','2026-09-10 11:01:40.178','2366974b1e22a9698cacb2bbc77b92d6f90901bac658f599c6250b71c260a9ee'),
('818119a8-36f7-47c0-849f-90f540c69083','QOP8U2mBb85n3A','e4dc889e-dfb6-40e0-b388-d83762ebdd1c','SMPP_SERVER_01','9de00fe32a75a683','REVOKED','2026-09-10 11:05:13.068','2026-09-25 23:59:59.999','2026-09-10 11:06:07.616','2026-09-10 11:01:59.562','2026-09-10 11:06:07.617','800916f4617e720a632ea2620a3fd0e00b8f296f07dad540729fb8ceb67a2e68'),
('8e7fd822-b22b-45db-91bf-8e357cd0c7ab','ACME-ACMETELECOM','9a8672a0-9bb4-425d-b30d-db7595b0eb22','Acme API key','ACME','REVOKED',NULL,NULL,'2026-09-03 22:09:34.858','2026-08-07 08:49:57.864','2026-09-03 22:09:34.859','<CHANGE_ME>'),
('a8f4818c-f1a3-44ab-8223-c2b186a67718','DEMO-DEMOCLIENT','67c9b53f-b74e-43d0-859f-5349b5b9d0c7','Demo API key','DEMO','ACTIVE',NULL,NULL,NULL,'2026-08-07 08:49:57.864','2026-08-07 08:50:14.108','<CHANGE_ME>'),
('c37c90ed-c0b0-4224-b5b2-c14ff440e8ae','OD1hfiM3UH5S9w','9a8672a0-9bb4-425d-b30d-db7595b0eb22','test_key','cd11eb19bd77efa0','ACTIVE',NULL,'2026-10-07 23:59:59.999',NULL,'2026-09-07 18:57:16.673','2026-09-07 18:57:16.673','18c5c2a6bcada959e5c8ba831d6ff4c511e0648cba7417e4ef599487afe47532'),
('dde937ef-b72d-4e75-b6bb-0060ea51a907','Ucd4h4L2MTgB3Q','9a8672a0-9bb4-425d-b30d-db7595b0eb22','test2','7c62b2ce189c4f25','REVOKED',NULL,'2026-09-05 23:59:59.999','2026-09-03 22:55:00.191','2026-09-03 22:30:15.050','2026-09-03 22:55:00.192','a57b3200d3dbcaf621ba1e2829d568cf778599c05727b7b2075c0edaeb303499');
/*!40000 ALTER TABLE `api_keys` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `audit_logs`
--

DROP TABLE IF EXISTS `audit_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `audit_logs` (
  `id` char(36) NOT NULL,
  `clientId` char(36) DEFAULT NULL,
  `userId` char(36) DEFAULT NULL,
  `entityType` varchar(100) NOT NULL,
  `entityId` char(36) NOT NULL,
  `action` varchar(100) NOT NULL,
  `oldValues` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`oldValues`)),
  `newValues` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`newValues`)),
  `ipAddress` varchar(45) DEFAULT NULL,
  `userAgent` varchar(512) DEFAULT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  PRIMARY KEY (`id`),
  KEY `audit_logs_clientId_idx` (`clientId`),
  KEY `audit_logs_userId_idx` (`userId`),
  KEY `audit_logs_entityType_entityId_idx` (`entityType`,`entityId`),
  KEY `audit_logs_action_idx` (`action`),
  KEY `audit_logs_createdAt_idx` (`createdAt`),
  CONSTRAINT `audit_logs_clientId_fkey` FOREIGN KEY (`clientId`) REFERENCES `clients` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `audit_logs_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `audit_logs`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `audit_logs` WRITE;
/*!40000 ALTER TABLE `audit_logs` DISABLE KEYS */;
/*!40000 ALTER TABLE `audit_logs` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `authentication_events`
--

DROP TABLE IF EXISTS `authentication_events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `authentication_events` (
  `id` char(36) NOT NULL,
  `userId` char(36) DEFAULT NULL,
  `clientId` char(36) DEFAULT NULL,
  `type` enum('LOGIN_SUCCESS','LOGIN_FAILED','LOGOUT','SESSION_REVOKED','API_KEY_CREATED','API_KEY_REVOKED','API_KEY_ROTATED','PASSWORD_CHANGED','REFRESH_TOKEN_ROTATED','MFA_CHALLENGE_CREATED','MFA_VERIFIED','REFRESH_TOKEN_ISSUED','REFRESH_TOKEN_REVOKED','LOGOUT_ALL') NOT NULL,
  `ipAddress` varchar(45) DEFAULT NULL,
  `userAgent` varchar(512) DEFAULT NULL,
  `failureReason` varchar(255) DEFAULT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `authenticationMethod` enum('PASSWORD','API_KEY','REFRESH_TOKEN','SESSION','SMPP','SYSTEM') NOT NULL,
  `sessionId` varchar(191) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `authentication_events_userId_idx` (`userId`),
  KEY `authentication_events_clientId_idx` (`clientId`),
  KEY `authentication_events_type_idx` (`type`),
  KEY `authentication_events_createdAt_idx` (`createdAt`),
  CONSTRAINT `authentication_events_clientId_fkey` FOREIGN KEY (`clientId`) REFERENCES `clients` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `authentication_events_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `authentication_events`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `authentication_events` WRITE;
/*!40000 ALTER TABLE `authentication_events` DISABLE KEYS */;
INSERT INTO `authentication_events` VALUES
('028decb4-e550-4f8a-863c-3e512c3af4a0','00000000-0000-0000-0000-000000000015','67c9b53f-b74e-43d0-859f-5349b5b9d0c7','LOGIN_SUCCESS','::1','Mozilla/5.0 (X11; Linux x86_64; rv:140.0) Gecko/20100101 Firefox/140.0',NULL,'2026-09-18 23:31:55.424','PASSWORD','071e2140-f613-4041-a98c-309c7ee75c90'),
('05fe3aa4-aaad-4a1c-b5ca-1ca0b4cc6176','00000000-0000-0000-0000-000000000015','67c9b53f-b74e-43d0-859f-5349b5b9d0c7','REFRESH_TOKEN_ISSUED','::1','Mozilla/5.0 (X11; Linux x86_64; rv:140.0) Gecko/20100101 Firefox/140.0',NULL,'2026-09-17 13:31:11.188','PASSWORD','aa76221f-d670-4778-ade2-cbca7f872470'),
('0d374737-53c5-45dd-976e-500a7689d841','00000000-0000-0000-0000-000000000015','67c9b53f-b74e-43d0-859f-5349b5b9d0c7','REFRESH_TOKEN_ISSUED','::1','Mozilla/5.0 (X11; Linux x86_64; rv:140.0) Gecko/20100101 Firefox/140.0',NULL,'2026-09-17 14:44:10.777','PASSWORD','7d524ee2-7b8c-4e07-b582-96687b8b08c3'),
('0de6c9ab-0ed3-4b1b-b064-ccbedc97e08b','00000000-0000-0000-0000-000000000015','67c9b53f-b74e-43d0-859f-5349b5b9d0c7','SESSION_REVOKED','::1','Mozilla/5.0 (X11; Linux x86_64; rv:140.0) Gecko/20100101 Firefox/140.0',NULL,'2026-09-18 00:13:20.787','PASSWORD','b0904aff-1e50-4a6f-b052-11b81812e4ac'),
('0ebd5882-9f1a-49ae-8ea8-1737097b149a','00000000-0000-0000-0000-000000000015','67c9b53f-b74e-43d0-859f-5349b5b9d0c7','SESSION_REVOKED','::1','Mozilla/5.0 (X11; Linux x86_64; rv:140.0) Gecko/20100101 Firefox/140.0',NULL,'2026-09-18 00:13:20.791','PASSWORD','b0904aff-1e50-4a6f-b052-11b81812e4ac'),
('102c57bf-25ea-4949-9475-40be31c881be','00000000-0000-0000-0000-000000000015','67c9b53f-b74e-43d0-859f-5349b5b9d0c7','REFRESH_TOKEN_ROTATED','::1','node',NULL,'2026-09-18 22:57:55.111','REFRESH_TOKEN','1c99d980-0f72-4a53-82db-af941738fa4d'),
('1115dcbd-0ffa-464f-aeb3-98754da4025e','00000000-0000-0000-0000-000000000015','67c9b53f-b74e-43d0-859f-5349b5b9d0c7','REFRESH_TOKEN_ROTATED','::1','node',NULL,'2026-09-17 17:17:30.359','REFRESH_TOKEN','7d524ee2-7b8c-4e07-b582-96687b8b08c3'),
('118caa75-cb94-4ea2-a5ea-c9cbdd2a6d13','00000000-0000-0000-0000-000000000015','67c9b53f-b74e-43d0-859f-5349b5b9d0c7','REFRESH_TOKEN_ISSUED','::1','Mozilla/5.0 (X11; Linux x86_64; rv:140.0) Gecko/20100101 Firefox/140.0',NULL,'2026-09-17 13:46:18.659','PASSWORD','783a9d74-7a1f-4746-8781-8354e046d120'),
('12d9944e-542c-4d62-9fe2-66c404decacc','00000000-0000-0000-0000-000000000015','67c9b53f-b74e-43d0-859f-5349b5b9d0c7','REFRESH_TOKEN_ISSUED','::1','Mozilla/5.0 (X11; Linux x86_64; rv:140.0) Gecko/20100101 Firefox/140.0',NULL,'2026-09-17 13:56:00.448','PASSWORD','3780424d-cb03-495f-8f7f-7c98730ca305'),
('140c6ab0-cc00-4ccb-add1-4ce7491ed701','00000000-0000-0000-0000-000000000015','67c9b53f-b74e-43d0-859f-5349b5b9d0c7','SESSION_REVOKED','::1','Mozilla/5.0 (X11; Linux x86_64; rv:140.0) Gecko/20100101 Firefox/140.0',NULL,'2026-09-17 14:43:27.216','PASSWORD','6625001e-4196-4c1e-b761-0de98affc2c7'),
('1b63adaa-1ba5-4b76-b798-1eebc837e599','00000000-0000-0000-0000-000000000015','67c9b53f-b74e-43d0-859f-5349b5b9d0c7','REFRESH_TOKEN_ISSUED','::1','Mozilla/5.0 (X11; Linux x86_64; rv:140.0) Gecko/20100101 Firefox/140.0',NULL,'2026-09-17 00:44:27.805','PASSWORD','8b15e190-9661-4066-b868-09f1323eae35'),
('1d3230a6-f680-4aae-a51c-5e761e0c64b6','00000000-0000-0000-0000-000000000015','67c9b53f-b74e-43d0-859f-5349b5b9d0c7','SESSION_REVOKED','::1','Mozilla/5.0 (X11; Linux x86_64; rv:140.0) Gecko/20100101 Firefox/140.0',NULL,'2026-09-17 13:45:57.781','PASSWORD','aa76221f-d670-4778-ade2-cbca7f872470'),
('26c0b6a7-2114-4c6c-b6c2-464dcec61596','00000000-0000-0000-0000-000000000015','67c9b53f-b74e-43d0-859f-5349b5b9d0c7','REFRESH_TOKEN_ISSUED','::1','Mozilla/5.0 (X11; Linux x86_64; rv:140.0) Gecko/20100101 Firefox/140.0',NULL,'2026-09-16 23:41:20.403','PASSWORD','d0f6bc8d-f4dd-4cca-b8ca-727c47d54414'),
('2ae79cb3-1bd3-4ee8-8e2d-08d140ad04c9','00000000-0000-0000-0000-000000000015','67c9b53f-b74e-43d0-859f-5349b5b9d0c7','SESSION_REVOKED','::1','Mozilla/5.0 (X11; Linux x86_64; rv:140.0) Gecko/20100101 Firefox/140.0',NULL,'2026-09-17 14:43:27.219','PASSWORD','6625001e-4196-4c1e-b761-0de98affc2c7'),
('2f2a7299-119a-4127-8968-3eb9003e59fa','00000000-0000-0000-0000-000000000015','67c9b53f-b74e-43d0-859f-5349b5b9d0c7','LOGIN_SUCCESS','::1','Mozilla/5.0 (X11; Linux x86_64; rv:140.0) Gecko/20100101 Firefox/140.0',NULL,'2026-09-16 22:40:18.069','PASSWORD','e9be05c8-1f84-4f75-ba06-921dcbc75062'),
('32be0746-1248-4ade-b517-c804d7697ed9','00000000-0000-0000-0000-000000000015','67c9b53f-b74e-43d0-859f-5349b5b9d0c7','LOGIN_SUCCESS','::1','Mozilla/5.0 (X11; Linux x86_64; rv:140.0) Gecko/20100101 Firefox/140.0',NULL,'2026-09-17 00:44:27.812','PASSWORD','8b15e190-9661-4066-b868-09f1323eae35'),
('354268d2-2956-4a5d-863c-25e900e82216','00000000-0000-0000-0000-000000000015','67c9b53f-b74e-43d0-859f-5349b5b9d0c7','REFRESH_TOKEN_ISSUED','::1','Mozilla/5.0 (X11; Linux x86_64; rv:140.0) Gecko/20100101 Firefox/140.0',NULL,'2026-09-16 23:10:44.429','PASSWORD','eb5df8c2-04e2-4cf9-a569-e87211a6b0c5'),
('3571e0bc-0cba-425e-a13e-3b838b4b38af','00000000-0000-0000-0000-000000000015','67c9b53f-b74e-43d0-859f-5349b5b9d0c7','REFRESH_TOKEN_ISSUED','::1','Mozilla/5.0 (X11; Linux x86_64; rv:140.0) Gecko/20100101 Firefox/140.0',NULL,'2026-09-16 10:47:04.044','PASSWORD','975cbe68-b16e-4827-8836-107e24e6f980'),
('399b1eff-9a3e-4720-866b-f48b9b37ca87','00000000-0000-0000-0000-000000000015','67c9b53f-b74e-43d0-859f-5349b5b9d0c7','LOGIN_SUCCESS','::1','Mozilla/5.0 (X11; Linux x86_64; rv:140.0) Gecko/20100101 Firefox/140.0',NULL,'2026-09-17 13:31:11.194','PASSWORD','aa76221f-d670-4778-ade2-cbca7f872470'),
('42c65c52-31d4-4db2-8d4f-eb6a8525652f','00000000-0000-0000-0000-000000000015','67c9b53f-b74e-43d0-859f-5349b5b9d0c7','REFRESH_TOKEN_ISSUED','::1','Mozilla/5.0 (X11; Linux x86_64; rv:140.0) Gecko/20100101 Firefox/140.0',NULL,'2026-09-16 10:15:37.553','PASSWORD','fc5c12a3-33bf-439e-9d1a-4a60dacf6c18'),
('5338424c-3526-4a9e-bace-dc9598981507','00000000-0000-0000-0000-000000000015','67c9b53f-b74e-43d0-859f-5349b5b9d0c7','LOGIN_SUCCESS','::1','Mozilla/5.0 (X11; Linux x86_64; rv:140.0) Gecko/20100101 Firefox/140.0',NULL,'2026-09-17 14:33:16.789','PASSWORD','6625001e-4196-4c1e-b761-0de98affc2c7'),
('6976541e-2f82-4967-9537-b1f6fce49b89','00000000-0000-0000-0000-000000000015','67c9b53f-b74e-43d0-859f-5349b5b9d0c7','LOGIN_SUCCESS','::1','Mozilla/5.0 (X11; Linux x86_64; rv:140.0) Gecko/20100101 Firefox/140.0',NULL,'2026-09-18 00:13:36.163','PASSWORD','a404faed-be98-4750-9ae0-7b686416a888'),
('76b4c6ec-aaf6-40a0-b20a-fc45fa248540','00000000-0000-0000-0000-000000000015','67c9b53f-b74e-43d0-859f-5349b5b9d0c7','LOGIN_SUCCESS','::1','Mozilla/5.0 (X11; Linux x86_64; rv:140.0) Gecko/20100101 Firefox/140.0',NULL,'2026-09-18 00:10:06.108','PASSWORD','b0904aff-1e50-4a6f-b052-11b81812e4ac'),
('77653b33-c927-4192-b525-a5866aa2ff11','00000000-0000-0000-0000-000000000015','67c9b53f-b74e-43d0-859f-5349b5b9d0c7','LOGIN_SUCCESS','::1','Mozilla/5.0 (X11; Linux x86_64; rv:140.0) Gecko/20100101 Firefox/140.0',NULL,'2026-09-16 21:26:04.287','PASSWORD','0d3aef38-5293-46af-aaae-637238238d8e'),
('7eba1243-514a-4dc9-82b7-8c3845c91aab','00000000-0000-0000-0000-000000000015','67c9b53f-b74e-43d0-859f-5349b5b9d0c7','REFRESH_TOKEN_ISSUED','::1','Mozilla/5.0 (X11; Linux x86_64; rv:140.0) Gecko/20100101 Firefox/140.0',NULL,'2026-09-18 00:10:06.103','PASSWORD','b0904aff-1e50-4a6f-b052-11b81812e4ac'),
('8480286e-2f79-4be9-8c42-ce0bb8012448','00000000-0000-0000-0000-000000000015','67c9b53f-b74e-43d0-859f-5349b5b9d0c7','REFRESH_TOKEN_ISSUED','::1','Mozilla/5.0 (X11; Linux x86_64; rv:140.0) Gecko/20100101 Firefox/140.0',NULL,'2026-09-18 23:31:55.419','PASSWORD','071e2140-f613-4041-a98c-309c7ee75c90'),
('898f3a3e-a2e4-4195-8f62-0d6e915510d1','00000000-0000-0000-0000-000000000015','67c9b53f-b74e-43d0-859f-5349b5b9d0c7','REFRESH_TOKEN_ISSUED','::1','Mozilla/5.0 (X11; Linux x86_64; rv:140.0) Gecko/20100101 Firefox/140.0',NULL,'2026-09-16 22:40:18.064','PASSWORD','e9be05c8-1f84-4f75-ba06-921dcbc75062'),
('8bb53ac0-61d8-45c5-adbd-afb5fe9bb43e','00000000-0000-0000-0000-000000000015','67c9b53f-b74e-43d0-859f-5349b5b9d0c7','REFRESH_TOKEN_ROTATED','::ffff:127.0.0.1','Mozilla/5.0 (X11; Linux x86_64; rv:140.0) Gecko/20100101 Firefox/140.0',NULL,'2026-09-17 13:59:38.413','REFRESH_TOKEN','3780424d-cb03-495f-8f7f-7c98730ca305'),
('909e8d20-f891-4407-8168-19ac58dbac51','00000000-0000-0000-0000-000000000015','67c9b53f-b74e-43d0-859f-5349b5b9d0c7','LOGIN_SUCCESS','::1','Mozilla/5.0 (X11; Linux x86_64; rv:140.0) Gecko/20100101 Firefox/140.0',NULL,'2026-09-16 23:41:20.406','PASSWORD','d0f6bc8d-f4dd-4cca-b8ca-727c47d54414'),
('93daeb7c-1446-4b2f-aba9-5551243fb4a7','00000000-0000-0000-0000-000000000015','67c9b53f-b74e-43d0-859f-5349b5b9d0c7','REFRESH_TOKEN_ROTATED','::ffff:127.0.0.1','Mozilla/5.0 (X11; Linux x86_64; rv:140.0) Gecko/20100101 Firefox/140.0',NULL,'2026-09-17 13:57:41.608','REFRESH_TOKEN','3780424d-cb03-495f-8f7f-7c98730ca305'),
('9569a9c2-530d-43a5-8ca4-ab47c7ca1288','00000000-0000-0000-0000-000000000015','67c9b53f-b74e-43d0-859f-5349b5b9d0c7','LOGIN_SUCCESS','::1','Mozilla/5.0 (X11; Linux x86_64; rv:140.0) Gecko/20100101 Firefox/140.0',NULL,'2026-09-16 10:15:37.557','PASSWORD','fc5c12a3-33bf-439e-9d1a-4a60dacf6c18'),
('9833ca94-e801-4010-859d-6b718b92be3a','00000000-0000-0000-0000-000000000015','67c9b53f-b74e-43d0-859f-5349b5b9d0c7','REFRESH_TOKEN_ISSUED','::1','Mozilla/5.0 (X11; Linux x86_64; rv:140.0) Gecko/20100101 Firefox/140.0',NULL,'2026-09-16 13:27:00.909','PASSWORD','3337b98d-706e-45d1-b403-8d0a8b69951c'),
('a4f773e0-8319-461c-a691-ff50820b4916','00000000-0000-0000-0000-000000000015','67c9b53f-b74e-43d0-859f-5349b5b9d0c7','REFRESH_TOKEN_ISSUED','::1','Mozilla/5.0 (X11; Linux x86_64; rv:140.0) Gecko/20100101 Firefox/140.0',NULL,'2026-09-16 20:51:22.827','PASSWORD','c75040c5-c1e6-4f61-9d18-1333d0bbdc44'),
('a6206735-2637-40bb-8dfc-bd872740e7ff','00000000-0000-0000-0000-000000000015','67c9b53f-b74e-43d0-859f-5349b5b9d0c7','SESSION_REVOKED','::1','Mozilla/5.0 (X11; Linux x86_64; rv:140.0) Gecko/20100101 Firefox/140.0',NULL,'2026-09-17 13:45:57.778','PASSWORD','aa76221f-d670-4778-ade2-cbca7f872470'),
('acf5f5b0-13c3-4168-b0f1-1c0bfb6e2769','00000000-0000-0000-0000-000000000015','67c9b53f-b74e-43d0-859f-5349b5b9d0c7','LOGIN_SUCCESS','::1','Mozilla/5.0 (X11; Linux x86_64; rv:140.0) Gecko/20100101 Firefox/140.0',NULL,'2026-09-17 13:46:18.661','PASSWORD','783a9d74-7a1f-4746-8781-8354e046d120'),
('b4dfc0f4-8e9b-4cc0-ae08-11ccb85c31a1','00000000-0000-0000-0000-000000000015','67c9b53f-b74e-43d0-859f-5349b5b9d0c7','LOGIN_SUCCESS','::1','Mozilla/5.0 (X11; Linux x86_64; rv:140.0) Gecko/20100101 Firefox/140.0',NULL,'2026-09-16 10:47:04.050','PASSWORD','975cbe68-b16e-4827-8836-107e24e6f980'),
('bac433a9-5042-4440-a346-fd1c17d3a57b','00000000-0000-0000-0000-000000000015','67c9b53f-b74e-43d0-859f-5349b5b9d0c7','REFRESH_TOKEN_ISSUED','::1','Mozilla/5.0 (X11; Linux x86_64; rv:140.0) Gecko/20100101 Firefox/140.0',NULL,'2026-09-18 00:13:36.159','PASSWORD','a404faed-be98-4750-9ae0-7b686416a888'),
('bcd7cb19-fd79-4c56-a1d3-4ba13d63e1da','00000000-0000-0000-0000-000000000015','67c9b53f-b74e-43d0-859f-5349b5b9d0c7','REFRESH_TOKEN_ROTATED','::1','node',NULL,'2026-09-18 00:45:34.678','REFRESH_TOKEN','a404faed-be98-4750-9ae0-7b686416a888'),
('c35513ab-76ac-434f-9081-accc1fa3f5b8','00000000-0000-0000-0000-000000000015','67c9b53f-b74e-43d0-859f-5349b5b9d0c7','LOGIN_SUCCESS','::1','Mozilla/5.0 (X11; Linux x86_64; rv:140.0) Gecko/20100101 Firefox/140.0',NULL,'2026-09-18 01:25:06.447','PASSWORD','1c99d980-0f72-4a53-82db-af941738fa4d'),
('c43481be-5e57-4f2f-b83b-ccb5b957a7ad','00000000-0000-0000-0000-000000000015','67c9b53f-b74e-43d0-859f-5349b5b9d0c7','LOGIN_SUCCESS','::1','Mozilla/5.0 (X11; Linux x86_64; rv:140.0) Gecko/20100101 Firefox/140.0',NULL,'2026-09-16 20:51:22.831','PASSWORD','c75040c5-c1e6-4f61-9d18-1333d0bbdc44'),
('c83c94de-0901-4074-aedf-5070973556fc','00000000-0000-0000-0000-000000000015','67c9b53f-b74e-43d0-859f-5349b5b9d0c7','REFRESH_TOKEN_ISSUED','::1','Mozilla/5.0 (X11; Linux x86_64; rv:140.0) Gecko/20100101 Firefox/140.0',NULL,'2026-09-18 01:25:06.443','PASSWORD','1c99d980-0f72-4a53-82db-af941738fa4d'),
('df4c4dbf-d888-4b28-b2ae-eea8e276ad8e','00000000-0000-0000-0000-000000000015','67c9b53f-b74e-43d0-859f-5349b5b9d0c7','LOGIN_SUCCESS','::1','Mozilla/5.0 (X11; Linux x86_64; rv:140.0) Gecko/20100101 Firefox/140.0',NULL,'2026-09-17 13:56:00.451','PASSWORD','3780424d-cb03-495f-8f7f-7c98730ca305'),
('e07d07c8-838e-4c63-848b-654b64843fd4','00000000-0000-0000-0000-000000000015','67c9b53f-b74e-43d0-859f-5349b5b9d0c7','REFRESH_TOKEN_ISSUED','::1','Mozilla/5.0 (X11; Linux x86_64; rv:140.0) Gecko/20100101 Firefox/140.0',NULL,'2026-09-16 21:26:04.281','PASSWORD','0d3aef38-5293-46af-aaae-637238238d8e'),
('e750f3ca-21eb-4216-9323-7f797609ffc4','00000000-0000-0000-0000-000000000015','67c9b53f-b74e-43d0-859f-5349b5b9d0c7','REFRESH_TOKEN_ROTATED','::1','node',NULL,'2026-09-17 13:25:18.349','REFRESH_TOKEN','8b15e190-9661-4066-b868-09f1323eae35'),
('ef06443a-9e86-4cfe-8c4c-d27ab97728a3','00000000-0000-0000-0000-000000000015','67c9b53f-b74e-43d0-859f-5349b5b9d0c7','REFRESH_TOKEN_ISSUED','::1','Mozilla/5.0 (X11; Linux x86_64; rv:140.0) Gecko/20100101 Firefox/140.0',NULL,'2026-09-17 14:33:16.787','PASSWORD','6625001e-4196-4c1e-b761-0de98affc2c7'),
('f331da25-1c45-48bc-b286-28bc4744f952','00000000-0000-0000-0000-000000000015','67c9b53f-b74e-43d0-859f-5349b5b9d0c7','LOGIN_SUCCESS','::1','Mozilla/5.0 (X11; Linux x86_64; rv:140.0) Gecko/20100101 Firefox/140.0',NULL,'2026-09-17 14:44:10.781','PASSWORD','7d524ee2-7b8c-4e07-b582-96687b8b08c3'),
('f3ab31b2-3d56-4c01-9f94-2c1c622f8f78','00000000-0000-0000-0000-000000000015','67c9b53f-b74e-43d0-859f-5349b5b9d0c7','LOGIN_SUCCESS','::1','Mozilla/5.0 (X11; Linux x86_64; rv:140.0) Gecko/20100101 Firefox/140.0',NULL,'2026-09-16 23:10:44.433','PASSWORD','eb5df8c2-04e2-4cf9-a569-e87211a6b0c5'),
('f3e9cd9e-b668-4b33-88ad-068e5c3dd483','00000000-0000-0000-0000-000000000015','67c9b53f-b74e-43d0-859f-5349b5b9d0c7','LOGIN_SUCCESS','::1','Mozilla/5.0 (X11; Linux x86_64; rv:140.0) Gecko/20100101 Firefox/140.0',NULL,'2026-09-16 13:27:00.915','PASSWORD','3337b98d-706e-45d1-b403-8d0a8b69951c');
/*!40000 ALTER TABLE `authentication_events` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `clients`
--

DROP TABLE IF EXISTS `clients`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `clients` (
  `id` char(36) NOT NULL,
  `publicId` varchar(20) NOT NULL,
  `companyName` varchar(255) NOT NULL,
  `displayName` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `phone` varchar(30) DEFAULT NULL,
  `status` enum('ACTIVE','SUSPENDED','DISABLED') NOT NULL DEFAULT 'ACTIVE',
  `rateLimitPerSecond` int(11) NOT NULL DEFAULT 20,
  `timezone` varchar(64) NOT NULL DEFAULT 'Europe/London',
  `metadata` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`metadata`)),
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `clients_publicId_key` (`publicId`),
  UNIQUE KEY `clients_email_key` (`email`),
  KEY `clients_status_idx` (`status`),
  KEY `clients_createdAt_idx` (`createdAt`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clients`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `clients` WRITE;
/*!40000 ALTER TABLE `clients` DISABLE KEYS */;
INSERT INTO `clients` VALUES
('67c9b53f-b74e-43d0-859f-5349b5b9d0c7','DEMOCLIENT','Demo Client','Demo Client','hello@democlient.example','+254700000002','ACTIVE',20,'UTC',NULL,'2026-08-07 08:46:43.516','2026-08-07 08:50:13.901');
/*!40000 ALTER TABLE `clients` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `connectors`
--

DROP TABLE IF EXISTS `connectors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `connectors` (
  `id` char(36) NOT NULL,
  `publicId` varchar(20) NOT NULL,
  `name` varchar(100) NOT NULL,
  `code` varchar(50) NOT NULL,
  `provider` varchar(100) NOT NULL,
  `transport` enum('SMPP','HTTP') NOT NULL,
  `status` enum('ACTIVE','SUSPENDED','DISABLED') NOT NULL DEFAULT 'ACTIVE',
  `configuration` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`configuration`)),
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `connectors_publicId_key` (`publicId`),
  UNIQUE KEY `connectors_code_key` (`code`),
  KEY `connectors_provider_idx` (`provider`),
  KEY `connectors_transport_idx` (`transport`),
  KEY `connectors_status_idx` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `connectors`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `connectors` WRITE;
/*!40000 ALTER TABLE `connectors` DISABLE KEYS */;
INSERT INTO `connectors` VALUES
('2ac8f7a9-a4eb-4dc4-a0a3-dc40e80e1689','56Telkom','56Telkom','56telkom','56telkom','SMPP','ACTIVE','{\"host\":\"94.237.89.242\",\"port\":2775,\"systemId\":\"56telkom\",\"password\":\"aawjkyfb\"}','2026-09-10 16:32:46.841','2026-09-13 18:53:13.981'),
('3d4e6305-d596-4958-a9e2-4a79edea899b','CLICK_MOBILE','Click Mobile','click-mobile','click-mobile','HTTP','ACTIVE','{\"baseUrl\":\"http://206.225.81.36:8989\",\"sendPath\":\"/api/messaging/sendsms\",\"method\":\"POST\",\"authentication\":{\"type\":\"BEARER\",\"token\":\"eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiI2NjIiLCJvaWQiOjY2MiwidWlkIjoiZGIzNWZmMjYtMGJlNC00NGJiLWI3OWQtZmZhNWIzNTI2ZDE0IiwiYXBpZCI6NTQwLCJpYXQiOjE3NzczMDAzMDIsImV4cCI6MjExNzMwMDMwMn0.KXqgBfeOGyatYsMr1mhS2CRkF7MI8RDdpjmEb0XuLuUh2SJsvC4M_jPmSlKNMpGzlaRH8aWw4htzTdwiiAIaqw\"},\"connectTimeout\":10000,\"requestTimeout\":30000,\"reconnectDelay\":1000,\"maxReconnectDelay\":30000,\"headers\":{\"Content-Type\":\"application/json\"},\"providerConfiguration\":{}}','2026-09-14 09:59:52.264','2026-09-14 09:59:52.264'),
('8c66b125-53c3-402b-851e-cb09c8c4699e','AFRICASTALKING_CAMER','Africa\'s Talking Cameroon','africastalking-cameroon','africastalking-cameroon','HTTP','ACTIVE','{\"baseUrl\":\"https://api.africastalking.com\",\"sendPath\":\"/version1/messaging/bulk\",\"method\":\"POST\",\"authentication\":{\"type\":\"API_KEY\",\"header\":\"apiKey\",\"value\":\"atsk_75a8e754d3787c9585f7834f428a11c62a1aeac168a88d18774292188d0e1e0e9d1b58c6\"},\"connectTimeout\":10000,\"requestTimeout\":30000,\"reconnectDelay\":1000,\"maxReconnectDelay\":30000,\"headers\":{\"Accept\":\"application/json\",\"Content-Type\":\"application/json\"},\"providerConfiguration\":{\"username\":\"camebulk\"}}','2026-09-14 09:46:53.159','2026-09-14 09:46:53.159'),
('9f1c984f-9e8e-11f1-a1a3-84144d0a7d3c','CON-AIRTEL-MW','Airtel Malawi','airtel-malawi','Airtel Malawi','SMPP','DISABLED','{\"host\": \"127.0.0.1\", \"port\": 2775, \"systemId\": \"test\", \"password\": \"test\", \"systemType\": \"\", \"connectionTimeout\": 10000, \"enquireLinkInterval\": 30000, \"requestTimeout\": 30000, \"reconnectDelay\": 5000, \"maxReconnectDelay\": 30000}','2026-08-23 03:04:41.000','2026-09-12 16:22:09.239'),
('9f1c9946-9e8e-11f1-a1a3-84144d0a7d3c','CON-TNM-MW','TNM Malawi','tnm-malawi','TNM Malawi','SMPP','DISABLED','{\"host\": \"127.0.0.1\", \"port\": 2775, \"systemId\": \"test\", \"password\": \"test\", \"systemType\": \"\", \"connectionTimeout\": 10000, \"enquireLinkInterval\": 30000, \"requestTimeout\": 30000, \"reconnectDelay\": 5000, \"maxReconnectDelay\": 30000}','2026-08-23 03:04:41.000','2026-09-12 16:22:20.066'),
('9f1c99a7-9e8e-11f1-a1a3-84144d0a7d3c','CON-ONFON','Onfone','onfone','onfone','HTTP','ACTIVE','{\"baseUrl\":\"https://api.onfonmedia.co.ke\",\"sendPath\":\"/v1/sms/SendBulkSMS\",\"method\":\"POST\",\"authentication\":{\"type\":\"API_KEY\",\"header\":\"AccessKey\",\"value\":\"E9n0J6NtMb06E8BpfzBJUNFap0ofX9lJ\"},\"connectTimeout\":10000,\"requestTimeout\":30000,\"reconnectDelay\":1000,\"maxReconnectDelay\":30000,\"headers\":{\"Content-Type\":\"application/json\"},\"providerConfiguration\":{\"ApiKey\":\"adc0n3ct\",\"ClientId\":\"adcconnect\"}}','2026-08-23 03:04:41.000','2026-09-16 23:44:48.844'),
('9f1c99e5-9e8e-11f1-a1a3-84144d0a7d3c','CON-AT','Africa\'s Talking Ghana','africastalking-ghana','africastalking-ghana','HTTP','ACTIVE','{\"baseUrl\":\"https://api.africastalking.com\",\"sendPath\":\"/version1/messaging/bulk\",\"method\":\"POST\",\"authentication\":{\"type\":\"API_KEY\",\"header\":\"apiKey\",\"value\":\"atsk_774845c6e1de7bd2a876a59970af8e513cba75ba041469788b5ad3360d7fb443cfed6a33\"},\"connectTimeout\":10000,\"requestTimeout\":30000,\"reconnectDelay\":1000,\"maxReconnectDelay\":30000,\"headers\":{\"Accept\":\"application/json\",\"Content-Type\":\"application/json\"},\"providerConfiguration\":{\"username\":\"ghanasmsroot\"}}','2026-08-23 03:04:41.000','2026-09-14 09:43:50.925'),
('aecc114f-8f58-4002-84d0-159995fc9c97','ROUTE_SMS','Route SMS','ROUTE_SMS','route-mobile','HTTP','ACTIVE','{\"baseUrl\":\"http://api.rmlconnect.net\",\"sendPath\":\"/bulksms/bulksms?username={USER}&password={PASS}&type={type}&dlr={dlr}&destination={DEST}&source={SOUR}&message={MSG}\",\"method\":\"GET\",\"authentication\":{\"type\":\"NONE\"},\"connectTimeout\":5000,\"requestTimeout\":30000,\"reconnectDelay\":1000,\"maxReconnectDelay\":30000,\"headers\":{\"Accept\":\"text/plain\"},\"username\":\"Africadcl\",\"password\":\"TSkoMk1C\",\"type\":\"0\",\"dlr\":\"1\"}','2026-09-13 09:45:29.564','2026-09-13 10:21:48.446'),
('c4d0d250-65cf-4638-87f3-0005a4ee4e19','AFRICASTALKING_KENYA','Africa\'s Talking Kenya','africastalking-kenya','africastalking-kenya','HTTP','ACTIVE','{\"baseUrl\":\"https://api.africastalking.com\",\"sendPath\":\"/version1/messaging/bulk\",\"method\":\"POST\",\"authentication\":{\"type\":\"API_KEY\",\"header\":\"apiKey\",\"value\":\"atsk_d196f0a6c3c43c3bca4306695562554c151341463075900e723e77ed3566e535a1b485fc\"},\"connectTimeout\":10000,\"requestTimeout\":30000,\"reconnectDelay\":1000,\"maxReconnectDelay\":30000,\"headers\":{\"Accept\":\"application/json\",\"Content-Type\":\"application/json\"},\"providerConfiguration\":{\"username\":\"kenyasbulk\"}}','2026-09-14 09:48:31.561','2026-09-14 09:48:31.561');
/*!40000 ALTER TABLE `connectors` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `countries`
--

DROP TABLE IF EXISTS `countries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `countries` (
  `id` char(36) NOT NULL,
  `code` char(2) NOT NULL,
  `name` varchar(100) NOT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `countries_code_key` (`code`),
  UNIQUE KEY `countries_name_key` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `countries`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `countries` WRITE;
/*!40000 ALTER TABLE `countries` DISABLE KEYS */;
INSERT INTO `countries` VALUES
('e569ccc3-b32e-11f1-a478-84144d0a7d3c','AW','Aruba','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e569ce86-b32e-11f1-a478-84144d0a7d3c','AF','Afghanistan','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e569cef5-b32e-11f1-a478-84144d0a7d3c','AO','Angola','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e569cf16-b32e-11f1-a478-84144d0a7d3c','AI','Anguilla','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e569d497-b32e-11f1-a478-84144d0a7d3c','AX','Åland Islands','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e569eab6-b32e-11f1-a478-84144d0a7d3c','AL','Albania','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e569eafa-b32e-11f1-a478-84144d0a7d3c','AD','Andorra','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e569eb20-b32e-11f1-a478-84144d0a7d3c','AE','United Arab Emirates','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e569eb72-b32e-11f1-a478-84144d0a7d3c','AR','Argentina','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e569ebfd-b32e-11f1-a478-84144d0a7d3c','AM','Armenia','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e569ec24-b32e-11f1-a478-84144d0a7d3c','AS','American Samoa','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e569ec41-b32e-11f1-a478-84144d0a7d3c','AQ','Antarctica','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e569ec5f-b32e-11f1-a478-84144d0a7d3c','TF','French Southern Territories','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e569ec7e-b32e-11f1-a478-84144d0a7d3c','AG','Antigua and Barbuda','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e569ec9e-b32e-11f1-a478-84144d0a7d3c','AU','Australia','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e569ecba-b32e-11f1-a478-84144d0a7d3c','AT','Austria','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e569ecd7-b32e-11f1-a478-84144d0a7d3c','AZ','Azerbaijan','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e569ecf5-b32e-11f1-a478-84144d0a7d3c','BI','Burundi','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e569ed12-b32e-11f1-a478-84144d0a7d3c','BE','Belgium','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e569ed30-b32e-11f1-a478-84144d0a7d3c','BJ','Benin','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e569ed4d-b32e-11f1-a478-84144d0a7d3c','BQ','Bonaire, Sint Eustatius and Saba','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e569ed6b-b32e-11f1-a478-84144d0a7d3c','BF','Burkina Faso','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e569ed87-b32e-11f1-a478-84144d0a7d3c','BD','Bangladesh','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e569eda3-b32e-11f1-a478-84144d0a7d3c','BG','Bulgaria','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e569edbe-b32e-11f1-a478-84144d0a7d3c','BH','Bahrain','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e569ede2-b32e-11f1-a478-84144d0a7d3c','BS','Bahamas','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e569ee01-b32e-11f1-a478-84144d0a7d3c','BA','Bosnia and Herzegovina','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e569ee1d-b32e-11f1-a478-84144d0a7d3c','BL','Saint Barthélemy','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e569ee3a-b32e-11f1-a478-84144d0a7d3c','BY','Belarus','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e569ee57-b32e-11f1-a478-84144d0a7d3c','BZ','Belize','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e569ee75-b32e-11f1-a478-84144d0a7d3c','BM','Bermuda','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e569ee92-b32e-11f1-a478-84144d0a7d3c','BO','Bolivia, Plurinational State of','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e569eeaf-b32e-11f1-a478-84144d0a7d3c','BR','Brazil','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e569eeca-b32e-11f1-a478-84144d0a7d3c','BB','Barbados','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e569eee6-b32e-11f1-a478-84144d0a7d3c','BN','Brunei Darussalam','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e569f6a5-b32e-11f1-a478-84144d0a7d3c','BT','Bhutan','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e569f6e2-b32e-11f1-a478-84144d0a7d3c','BV','Bouvet Island','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e569f719-b32e-11f1-a478-84144d0a7d3c','BW','Botswana','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e569f73a-b32e-11f1-a478-84144d0a7d3c','CF','Central African Republic','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e569f75a-b32e-11f1-a478-84144d0a7d3c','CA','Canada','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e569f782-b32e-11f1-a478-84144d0a7d3c','CC','Cocos (Keeling) Islands','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e569f7a5-b32e-11f1-a478-84144d0a7d3c','CH','Switzerland','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e569f7f2-b32e-11f1-a478-84144d0a7d3c','CL','Chile','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e569f815-b32e-11f1-a478-84144d0a7d3c','CN','China','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e569f837-b32e-11f1-a478-84144d0a7d3c','CI','Côte d\'Ivoire','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a14c2-b32e-11f1-a478-84144d0a7d3c','CM','Cameroon','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a1535-b32e-11f1-a478-84144d0a7d3c','CD','Congo, The Democratic Republic of the','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a1c52-b32e-11f1-a478-84144d0a7d3c','CG','Congo','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a1cc3-b32e-11f1-a478-84144d0a7d3c','CK','Cook Islands','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a1cee-b32e-11f1-a478-84144d0a7d3c','CO','Colombia','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a1d11-b32e-11f1-a478-84144d0a7d3c','KM','Comoros','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a1d45-b32e-11f1-a478-84144d0a7d3c','CV','Cabo Verde','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a1d69-b32e-11f1-a478-84144d0a7d3c','CR','Costa Rica','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a1d8e-b32e-11f1-a478-84144d0a7d3c','CU','Cuba','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a1dc5-b32e-11f1-a478-84144d0a7d3c','CW','Curaçao','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a1de9-b32e-11f1-a478-84144d0a7d3c','CX','Christmas Island','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a1e0d-b32e-11f1-a478-84144d0a7d3c','KY','Cayman Islands','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a1e39-b32e-11f1-a478-84144d0a7d3c','CY','Cyprus','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a1e5a-b32e-11f1-a478-84144d0a7d3c','CZ','Czechia','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a1e7b-b32e-11f1-a478-84144d0a7d3c','DE','Germany','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a1e9f-b32e-11f1-a478-84144d0a7d3c','DJ','Djibouti','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a1ec2-b32e-11f1-a478-84144d0a7d3c','DM','Dominica','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a1ee1-b32e-11f1-a478-84144d0a7d3c','DK','Denmark','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a1f02-b32e-11f1-a478-84144d0a7d3c','DO','Dominican Republic','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a1f26-b32e-11f1-a478-84144d0a7d3c','DZ','Algeria','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a2344-b32e-11f1-a478-84144d0a7d3c','EC','Ecuador','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a23ae-b32e-11f1-a478-84144d0a7d3c','EG','Egypt','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a23d5-b32e-11f1-a478-84144d0a7d3c','ER','Eritrea','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a23f6-b32e-11f1-a478-84144d0a7d3c','EH','Western Sahara','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a2419-b32e-11f1-a478-84144d0a7d3c','ES','Spain','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a243a-b32e-11f1-a478-84144d0a7d3c','EE','Estonia','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a245d-b32e-11f1-a478-84144d0a7d3c','ET','Ethiopia','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a2491-b32e-11f1-a478-84144d0a7d3c','FI','Finland','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a24b4-b32e-11f1-a478-84144d0a7d3c','FJ','Fiji','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a24d5-b32e-11f1-a478-84144d0a7d3c','FK','Falkland Islands (Malvinas)','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a24f8-b32e-11f1-a478-84144d0a7d3c','FR','France','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a2516-b32e-11f1-a478-84144d0a7d3c','FO','Faroe Islands','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a2537-b32e-11f1-a478-84144d0a7d3c','FM','Micronesia, Federated States of','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a2559-b32e-11f1-a478-84144d0a7d3c','GA','Gabon','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a2579-b32e-11f1-a478-84144d0a7d3c','GB','United Kingdom','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a2c8b-b32e-11f1-a478-84144d0a7d3c','GE','Georgia','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a2cfa-b32e-11f1-a478-84144d0a7d3c','GG','Guernsey','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a2d23-b32e-11f1-a478-84144d0a7d3c','GH','Ghana','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a2d42-b32e-11f1-a478-84144d0a7d3c','GI','Gibraltar','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a2d61-b32e-11f1-a478-84144d0a7d3c','GN','Guinea','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a2d81-b32e-11f1-a478-84144d0a7d3c','GP','Guadeloupe','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a2da1-b32e-11f1-a478-84144d0a7d3c','GM','Gambia','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a2dc2-b32e-11f1-a478-84144d0a7d3c','GW','Guinea-Bissau','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a34a7-b32e-11f1-a478-84144d0a7d3c','GQ','Equatorial Guinea','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a3512-b32e-11f1-a478-84144d0a7d3c','GR','Greece','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a353a-b32e-11f1-a478-84144d0a7d3c','GD','Grenada','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a355e-b32e-11f1-a478-84144d0a7d3c','GL','Greenland','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a3585-b32e-11f1-a478-84144d0a7d3c','GT','Guatemala','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a35a7-b32e-11f1-a478-84144d0a7d3c','GF','French Guiana','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a35c9-b32e-11f1-a478-84144d0a7d3c','GU','Guam','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a35e9-b32e-11f1-a478-84144d0a7d3c','GY','Guyana','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a360b-b32e-11f1-a478-84144d0a7d3c','HK','Hong Kong','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a362e-b32e-11f1-a478-84144d0a7d3c','HM','Heard Island and McDonald Islands','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a3651-b32e-11f1-a478-84144d0a7d3c','HN','Honduras','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a3672-b32e-11f1-a478-84144d0a7d3c','HR','Croatia','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a3692-b32e-11f1-a478-84144d0a7d3c','HT','Haiti','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a36b0-b32e-11f1-a478-84144d0a7d3c','HU','Hungary','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a36d0-b32e-11f1-a478-84144d0a7d3c','ID','Indonesia','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a3be5-b32e-11f1-a478-84144d0a7d3c','IM','Isle of Man','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a3c0c-b32e-11f1-a478-84144d0a7d3c','IN','India','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a3c2a-b32e-11f1-a478-84144d0a7d3c','IO','British Indian Ocean Territory','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a3c4a-b32e-11f1-a478-84144d0a7d3c','IE','Ireland','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a3c6c-b32e-11f1-a478-84144d0a7d3c','IR','Iran, Islamic Republic of','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a3c8d-b32e-11f1-a478-84144d0a7d3c','IQ','Iraq','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a3cad-b32e-11f1-a478-84144d0a7d3c','IS','Iceland','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a3cce-b32e-11f1-a478-84144d0a7d3c','IL','Israel','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a3cef-b32e-11f1-a478-84144d0a7d3c','IT','Italy','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a3d11-b32e-11f1-a478-84144d0a7d3c','JM','Jamaica','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a3d31-b32e-11f1-a478-84144d0a7d3c','JE','Jersey','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a3d52-b32e-11f1-a478-84144d0a7d3c','JO','Jordan','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a3d71-b32e-11f1-a478-84144d0a7d3c','JP','Japan','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a3d93-b32e-11f1-a478-84144d0a7d3c','KZ','Kazakhstan','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a3db4-b32e-11f1-a478-84144d0a7d3c','KE','Kenya','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a3dd4-b32e-11f1-a478-84144d0a7d3c','KG','Kyrgyzstan','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a3df5-b32e-11f1-a478-84144d0a7d3c','KH','Cambodia','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a3e16-b32e-11f1-a478-84144d0a7d3c','KI','Kiribati','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a3e37-b32e-11f1-a478-84144d0a7d3c','KN','Saint Kitts and Nevis','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a3e5a-b32e-11f1-a478-84144d0a7d3c','KR','Korea, Republic of','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a3e7a-b32e-11f1-a478-84144d0a7d3c','KW','Kuwait','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a3e9c-b32e-11f1-a478-84144d0a7d3c','LA','Lao People\'s Democratic Republic','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a3ebd-b32e-11f1-a478-84144d0a7d3c','LB','Lebanon','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a3edd-b32e-11f1-a478-84144d0a7d3c','LR','Liberia','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a3efe-b32e-11f1-a478-84144d0a7d3c','LY','Libya','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a3f1f-b32e-11f1-a478-84144d0a7d3c','LC','Saint Lucia','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a3f41-b32e-11f1-a478-84144d0a7d3c','LI','Liechtenstein','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a3f62-b32e-11f1-a478-84144d0a7d3c','LK','Sri Lanka','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a3f82-b32e-11f1-a478-84144d0a7d3c','LS','Lesotho','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a3fa5-b32e-11f1-a478-84144d0a7d3c','LT','Lithuania','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a3fc5-b32e-11f1-a478-84144d0a7d3c','LU','Luxembourg','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a3fe5-b32e-11f1-a478-84144d0a7d3c','LV','Latvia','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a4006-b32e-11f1-a478-84144d0a7d3c','MO','Macao','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a4028-b32e-11f1-a478-84144d0a7d3c','MF','Saint Martin (French part)','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a404a-b32e-11f1-a478-84144d0a7d3c','MA','Morocco','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a406b-b32e-11f1-a478-84144d0a7d3c','MC','Monaco','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a408a-b32e-11f1-a478-84144d0a7d3c','MD','Moldova, Republic of','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a40ab-b32e-11f1-a478-84144d0a7d3c','MG','Madagascar','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a40cb-b32e-11f1-a478-84144d0a7d3c','MV','Maldives','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a40ec-b32e-11f1-a478-84144d0a7d3c','MX','Mexico','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a410c-b32e-11f1-a478-84144d0a7d3c','MH','Marshall Islands','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a412d-b32e-11f1-a478-84144d0a7d3c','MK','North Macedonia','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a414d-b32e-11f1-a478-84144d0a7d3c','ML','Mali','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a416d-b32e-11f1-a478-84144d0a7d3c','MT','Malta','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a418d-b32e-11f1-a478-84144d0a7d3c','MM','Myanmar','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a41ae-b32e-11f1-a478-84144d0a7d3c','ME','Montenegro','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a41ce-b32e-11f1-a478-84144d0a7d3c','MN','Mongolia','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a41ef-b32e-11f1-a478-84144d0a7d3c','MP','Northern Mariana Islands','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a4211-b32e-11f1-a478-84144d0a7d3c','MZ','Mozambique','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a4233-b32e-11f1-a478-84144d0a7d3c','MR','Mauritania','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a4253-b32e-11f1-a478-84144d0a7d3c','MS','Montserrat','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a4274-b32e-11f1-a478-84144d0a7d3c','MQ','Martinique','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a4294-b32e-11f1-a478-84144d0a7d3c','MU','Mauritius','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a42b4-b32e-11f1-a478-84144d0a7d3c','MW','Malawi','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a42d4-b32e-11f1-a478-84144d0a7d3c','MY','Malaysia','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a42f6-b32e-11f1-a478-84144d0a7d3c','YT','Mayotte','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a4319-b32e-11f1-a478-84144d0a7d3c','NA','Namibia','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a433b-b32e-11f1-a478-84144d0a7d3c','NC','New Caledonia','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a435c-b32e-11f1-a478-84144d0a7d3c','NE','Niger','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a437c-b32e-11f1-a478-84144d0a7d3c','NF','Norfolk Island','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a439e-b32e-11f1-a478-84144d0a7d3c','NG','Nigeria','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a43cb-b32e-11f1-a478-84144d0a7d3c','NI','Nicaragua','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a43eb-b32e-11f1-a478-84144d0a7d3c','NU','Niue','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a440a-b32e-11f1-a478-84144d0a7d3c','NL','Netherlands','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a442c-b32e-11f1-a478-84144d0a7d3c','NO','Norway','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a444c-b32e-11f1-a478-84144d0a7d3c','NP','Nepal','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a446c-b32e-11f1-a478-84144d0a7d3c','NR','Nauru','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a448c-b32e-11f1-a478-84144d0a7d3c','NZ','New Zealand','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a44b0-b32e-11f1-a478-84144d0a7d3c','OM','Oman','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a44d1-b32e-11f1-a478-84144d0a7d3c','PK','Pakistan','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a44f3-b32e-11f1-a478-84144d0a7d3c','PA','Panama','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a4514-b32e-11f1-a478-84144d0a7d3c','PN','Pitcairn','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a4535-b32e-11f1-a478-84144d0a7d3c','PE','Peru','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a4555-b32e-11f1-a478-84144d0a7d3c','PH','Philippines','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a4576-b32e-11f1-a478-84144d0a7d3c','PW','Palau','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a4596-b32e-11f1-a478-84144d0a7d3c','PG','Papua New Guinea','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a45b7-b32e-11f1-a478-84144d0a7d3c','PL','Poland','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a45d7-b32e-11f1-a478-84144d0a7d3c','PR','Puerto Rico','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a45f7-b32e-11f1-a478-84144d0a7d3c','KP','Korea, Democratic People\'s Republic of','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a697a-b32e-11f1-a478-84144d0a7d3c','PT','Portugal','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a69d8-b32e-11f1-a478-84144d0a7d3c','PY','Paraguay','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a6a00-b32e-11f1-a478-84144d0a7d3c','PS','Palestine, State of','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a6a25-b32e-11f1-a478-84144d0a7d3c','PF','French Polynesia','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a6a49-b32e-11f1-a478-84144d0a7d3c','QA','Qatar','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a6a68-b32e-11f1-a478-84144d0a7d3c','RE','Réunion','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a80ef-b32e-11f1-a478-84144d0a7d3c','RO','Romania','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a815a-b32e-11f1-a478-84144d0a7d3c','RU','Russian Federation','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a8182-b32e-11f1-a478-84144d0a7d3c','RW','Rwanda','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a819f-b32e-11f1-a478-84144d0a7d3c','SA','Saudi Arabia','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a81be-b32e-11f1-a478-84144d0a7d3c','SD','Sudan','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a81da-b32e-11f1-a478-84144d0a7d3c','SN','Senegal','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a81f7-b32e-11f1-a478-84144d0a7d3c','SG','Singapore','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a8216-b32e-11f1-a478-84144d0a7d3c','GS','South Georgia and the South Sandwich Islands','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a8238-b32e-11f1-a478-84144d0a7d3c','SH','Saint Helena, Ascension and Tristan da Cunha','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a8258-b32e-11f1-a478-84144d0a7d3c','SJ','Svalbard and Jan Mayen','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a8277-b32e-11f1-a478-84144d0a7d3c','SB','Solomon Islands','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a8295-b32e-11f1-a478-84144d0a7d3c','SL','Sierra Leone','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a82b3-b32e-11f1-a478-84144d0a7d3c','SV','El Salvador','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a82d3-b32e-11f1-a478-84144d0a7d3c','SM','San Marino','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a82f2-b32e-11f1-a478-84144d0a7d3c','SO','Somalia','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a8312-b32e-11f1-a478-84144d0a7d3c','PM','Saint Pierre and Miquelon','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a8333-b32e-11f1-a478-84144d0a7d3c','RS','Serbia','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a8351-b32e-11f1-a478-84144d0a7d3c','SS','South Sudan','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a8370-b32e-11f1-a478-84144d0a7d3c','ST','Sao Tome and Principe','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a8390-b32e-11f1-a478-84144d0a7d3c','SR','Suriname','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a83b0-b32e-11f1-a478-84144d0a7d3c','SK','Slovakia','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a83cd-b32e-11f1-a478-84144d0a7d3c','SI','Slovenia','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a83ec-b32e-11f1-a478-84144d0a7d3c','SE','Sweden','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a840b-b32e-11f1-a478-84144d0a7d3c','SZ','Eswatini','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a842c-b32e-11f1-a478-84144d0a7d3c','SX','Sint Maarten (Dutch part)','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a844a-b32e-11f1-a478-84144d0a7d3c','SC','Seychelles','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a8468-b32e-11f1-a478-84144d0a7d3c','SY','Syrian Arab Republic','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a8485-b32e-11f1-a478-84144d0a7d3c','TC','Turks and Caicos Islands','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a84a6-b32e-11f1-a478-84144d0a7d3c','TD','Chad','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a84c6-b32e-11f1-a478-84144d0a7d3c','TG','Togo','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a84e5-b32e-11f1-a478-84144d0a7d3c','TH','Thailand','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a8503-b32e-11f1-a478-84144d0a7d3c','TJ','Tajikistan','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a8523-b32e-11f1-a478-84144d0a7d3c','TK','Tokelau','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a8545-b32e-11f1-a478-84144d0a7d3c','TM','Turkmenistan','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a8561-b32e-11f1-a478-84144d0a7d3c','TL','Timor-Leste','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a8580-b32e-11f1-a478-84144d0a7d3c','TO','Tonga','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a859f-b32e-11f1-a478-84144d0a7d3c','TT','Trinidad and Tobago','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a85be-b32e-11f1-a478-84144d0a7d3c','TN','Tunisia','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a85dc-b32e-11f1-a478-84144d0a7d3c','TR','Türkiye','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a8611-b32e-11f1-a478-84144d0a7d3c','TV','Tuvalu','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a8d44-b32e-11f1-a478-84144d0a7d3c','TW','Taiwan, Province of China','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a8daf-b32e-11f1-a478-84144d0a7d3c','TZ','Tanzania, United Republic of','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a8dd7-b32e-11f1-a478-84144d0a7d3c','UG','Uganda','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a8df7-b32e-11f1-a478-84144d0a7d3c','UA','Ukraine','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a8e18-b32e-11f1-a478-84144d0a7d3c','UM','United States Minor Outlying Islands','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a8e3d-b32e-11f1-a478-84144d0a7d3c','UY','Uruguay','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a8e5d-b32e-11f1-a478-84144d0a7d3c','US','United States','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a8e7f-b32e-11f1-a478-84144d0a7d3c','UZ','Uzbekistan','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a8e9e-b32e-11f1-a478-84144d0a7d3c','VA','Holy See (Vatican City State)','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a8ebe-b32e-11f1-a478-84144d0a7d3c','VC','Saint Vincent and the Grenadines','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a8ee2-b32e-11f1-a478-84144d0a7d3c','VE','Venezuela, Bolivarian Republic of','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a8f02-b32e-11f1-a478-84144d0a7d3c','VG','Virgin Islands, British','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a8f1e-b32e-11f1-a478-84144d0a7d3c','VI','Virgin Islands, U.S.','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a931d-b32e-11f1-a478-84144d0a7d3c','VN','Viet Nam','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a9343-b32e-11f1-a478-84144d0a7d3c','VU','Vanuatu','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a9360-b32e-11f1-a478-84144d0a7d3c','WF','Wallis and Futuna','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a937f-b32e-11f1-a478-84144d0a7d3c','WS','Samoa','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a939e-b32e-11f1-a478-84144d0a7d3c','YE','Yemen','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a93bc-b32e-11f1-a478-84144d0a7d3c','ZA','South Africa','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a93dc-b32e-11f1-a478-84144d0a7d3c','ZM','Zambia','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56a93fb-b32e-11f1-a478-84144d0a7d3c','ZW','Zimbabwe','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000');
/*!40000 ALTER TABLE `countries` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `country_calling_codes`
--

DROP TABLE IF EXISTS `country_calling_codes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `country_calling_codes` (
  `id` char(36) NOT NULL,
  `countryId` char(36) NOT NULL,
  `callingCode` varchar(10) NOT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `country_calling_codes_countryId_callingCode_key` (`countryId`,`callingCode`),
  KEY `country_calling_codes_callingCode_idx` (`callingCode`),
  CONSTRAINT `country_calling_codes_countryId_fkey` FOREIGN KEY (`countryId`) REFERENCES `countries` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `country_calling_codes`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `country_calling_codes` WRITE;
/*!40000 ALTER TABLE `country_calling_codes` DISABLE KEYS */;
INSERT INTO `country_calling_codes` VALUES
('e56ad174-b32e-11f1-a478-84144d0a7d3c','e569ccc3-b32e-11f1-a478-84144d0a7d3c','297','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56ad251-b32e-11f1-a478-84144d0a7d3c','e569ce86-b32e-11f1-a478-84144d0a7d3c','93','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56ad2cb-b32e-11f1-a478-84144d0a7d3c','e569cef5-b32e-11f1-a478-84144d0a7d3c','244','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56ad318-b32e-11f1-a478-84144d0a7d3c','e569cf16-b32e-11f1-a478-84144d0a7d3c','1264','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56ad3d8-b32e-11f1-a478-84144d0a7d3c','e569d497-b32e-11f1-a478-84144d0a7d3c','358','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56ad41c-b32e-11f1-a478-84144d0a7d3c','e569eab6-b32e-11f1-a478-84144d0a7d3c','355','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56ad45e-b32e-11f1-a478-84144d0a7d3c','e569eafa-b32e-11f1-a478-84144d0a7d3c','376','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56ad49e-b32e-11f1-a478-84144d0a7d3c','e569eb20-b32e-11f1-a478-84144d0a7d3c','971','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56ad4e2-b32e-11f1-a478-84144d0a7d3c','e569eb72-b32e-11f1-a478-84144d0a7d3c','54','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56ad52b-b32e-11f1-a478-84144d0a7d3c','e569ebfd-b32e-11f1-a478-84144d0a7d3c','374','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56ad56e-b32e-11f1-a478-84144d0a7d3c','e569ec24-b32e-11f1-a478-84144d0a7d3c','1684','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56ad5b8-b32e-11f1-a478-84144d0a7d3c','e569ec5f-b32e-11f1-a478-84144d0a7d3c','','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56adc6a-b32e-11f1-a478-84144d0a7d3c','e569ec7e-b32e-11f1-a478-84144d0a7d3c','1268','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56adcb8-b32e-11f1-a478-84144d0a7d3c','e569ec9e-b32e-11f1-a478-84144d0a7d3c','61','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56adcfc-b32e-11f1-a478-84144d0a7d3c','e569ecba-b32e-11f1-a478-84144d0a7d3c','43','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56add42-b32e-11f1-a478-84144d0a7d3c','e569ecd7-b32e-11f1-a478-84144d0a7d3c','994','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56add86-b32e-11f1-a478-84144d0a7d3c','e569ecf5-b32e-11f1-a478-84144d0a7d3c','257','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56addd7-b32e-11f1-a478-84144d0a7d3c','e569ed12-b32e-11f1-a478-84144d0a7d3c','32','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56ade1a-b32e-11f1-a478-84144d0a7d3c','e569ed30-b32e-11f1-a478-84144d0a7d3c','229','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56ade5d-b32e-11f1-a478-84144d0a7d3c','e569ed4d-b32e-11f1-a478-84144d0a7d3c','599','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56ade9d-b32e-11f1-a478-84144d0a7d3c','e569ed6b-b32e-11f1-a478-84144d0a7d3c','226','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56adedf-b32e-11f1-a478-84144d0a7d3c','e569ed87-b32e-11f1-a478-84144d0a7d3c','880','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56adf20-b32e-11f1-a478-84144d0a7d3c','e569eda3-b32e-11f1-a478-84144d0a7d3c','359','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56adf62-b32e-11f1-a478-84144d0a7d3c','e569edbe-b32e-11f1-a478-84144d0a7d3c','973','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56adfa6-b32e-11f1-a478-84144d0a7d3c','e569ede2-b32e-11f1-a478-84144d0a7d3c','1242','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56adfea-b32e-11f1-a478-84144d0a7d3c','e569ee01-b32e-11f1-a478-84144d0a7d3c','387','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56ae02b-b32e-11f1-a478-84144d0a7d3c','e569ee1d-b32e-11f1-a478-84144d0a7d3c','590','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56ae06c-b32e-11f1-a478-84144d0a7d3c','e569ee3a-b32e-11f1-a478-84144d0a7d3c','375','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56ae0af-b32e-11f1-a478-84144d0a7d3c','e569ee57-b32e-11f1-a478-84144d0a7d3c','501','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56ae0f1-b32e-11f1-a478-84144d0a7d3c','e569ee75-b32e-11f1-a478-84144d0a7d3c','1441','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56ae133-b32e-11f1-a478-84144d0a7d3c','e569ee92-b32e-11f1-a478-84144d0a7d3c','591','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56ae174-b32e-11f1-a478-84144d0a7d3c','e569eeaf-b32e-11f1-a478-84144d0a7d3c','55','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56ae1b5-b32e-11f1-a478-84144d0a7d3c','e569eeca-b32e-11f1-a478-84144d0a7d3c','1246','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56ae1f6-b32e-11f1-a478-84144d0a7d3c','e569eee6-b32e-11f1-a478-84144d0a7d3c','673','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56ae238-b32e-11f1-a478-84144d0a7d3c','e569f6a5-b32e-11f1-a478-84144d0a7d3c','975','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56ae27a-b32e-11f1-a478-84144d0a7d3c','e569f6e2-b32e-11f1-a478-84144d0a7d3c','47','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56ae2ba-b32e-11f1-a478-84144d0a7d3c','e569f719-b32e-11f1-a478-84144d0a7d3c','267','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56ae2fd-b32e-11f1-a478-84144d0a7d3c','e569f73a-b32e-11f1-a478-84144d0a7d3c','236','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56ae33e-b32e-11f1-a478-84144d0a7d3c','e569f75a-b32e-11f1-a478-84144d0a7d3c','1','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56ae383-b32e-11f1-a478-84144d0a7d3c','e569f782-b32e-11f1-a478-84144d0a7d3c','61','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56ae3c8-b32e-11f1-a478-84144d0a7d3c','e569f7a5-b32e-11f1-a478-84144d0a7d3c','41','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56ae40a-b32e-11f1-a478-84144d0a7d3c','e569f7f2-b32e-11f1-a478-84144d0a7d3c','56','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56ae44a-b32e-11f1-a478-84144d0a7d3c','e569f815-b32e-11f1-a478-84144d0a7d3c','86','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56ae48d-b32e-11f1-a478-84144d0a7d3c','e569f837-b32e-11f1-a478-84144d0a7d3c','225','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56ae4cf-b32e-11f1-a478-84144d0a7d3c','e56a14c2-b32e-11f1-a478-84144d0a7d3c','237','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56ae510-b32e-11f1-a478-84144d0a7d3c','e56a1535-b32e-11f1-a478-84144d0a7d3c','243','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56ae551-b32e-11f1-a478-84144d0a7d3c','e56a1c52-b32e-11f1-a478-84144d0a7d3c','242','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56ae592-b32e-11f1-a478-84144d0a7d3c','e56a1cc3-b32e-11f1-a478-84144d0a7d3c','682','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56ae5d3-b32e-11f1-a478-84144d0a7d3c','e56a1cee-b32e-11f1-a478-84144d0a7d3c','57','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56ae615-b32e-11f1-a478-84144d0a7d3c','e56a1d11-b32e-11f1-a478-84144d0a7d3c','269','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56ae657-b32e-11f1-a478-84144d0a7d3c','e56a1d45-b32e-11f1-a478-84144d0a7d3c','238','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56ae69a-b32e-11f1-a478-84144d0a7d3c','e56a1d69-b32e-11f1-a478-84144d0a7d3c','506','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56ae6dc-b32e-11f1-a478-84144d0a7d3c','e56a1d8e-b32e-11f1-a478-84144d0a7d3c','53','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56ae71e-b32e-11f1-a478-84144d0a7d3c','e56a1dc5-b32e-11f1-a478-84144d0a7d3c','599','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56ae760-b32e-11f1-a478-84144d0a7d3c','e56a1de9-b32e-11f1-a478-84144d0a7d3c','61','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56ae7a2-b32e-11f1-a478-84144d0a7d3c','e56a1e0d-b32e-11f1-a478-84144d0a7d3c','1345','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56ae7e8-b32e-11f1-a478-84144d0a7d3c','e56a1e39-b32e-11f1-a478-84144d0a7d3c','357','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56ae829-b32e-11f1-a478-84144d0a7d3c','e56a1e5a-b32e-11f1-a478-84144d0a7d3c','420','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56ae86a-b32e-11f1-a478-84144d0a7d3c','e56a1e7b-b32e-11f1-a478-84144d0a7d3c','49','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56ae8ab-b32e-11f1-a478-84144d0a7d3c','e56a1e9f-b32e-11f1-a478-84144d0a7d3c','253','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56ae8ed-b32e-11f1-a478-84144d0a7d3c','e56a1ec2-b32e-11f1-a478-84144d0a7d3c','1767','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56ae92f-b32e-11f1-a478-84144d0a7d3c','e56a1ee1-b32e-11f1-a478-84144d0a7d3c','45','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56ae96e-b32e-11f1-a478-84144d0a7d3c','e56a1f02-b32e-11f1-a478-84144d0a7d3c','1809','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56ae99e-b32e-11f1-a478-84144d0a7d3c','e56a1f02-b32e-11f1-a478-84144d0a7d3c','1829','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56ae9d4-b32e-11f1-a478-84144d0a7d3c','e56a1f02-b32e-11f1-a478-84144d0a7d3c','1849','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56aea18-b32e-11f1-a478-84144d0a7d3c','e56a1f26-b32e-11f1-a478-84144d0a7d3c','213','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56aea5b-b32e-11f1-a478-84144d0a7d3c','e56a2344-b32e-11f1-a478-84144d0a7d3c','593','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56aea9f-b32e-11f1-a478-84144d0a7d3c','e56a23ae-b32e-11f1-a478-84144d0a7d3c','20','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56aeadf-b32e-11f1-a478-84144d0a7d3c','e56a23d5-b32e-11f1-a478-84144d0a7d3c','291','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56aeb21-b32e-11f1-a478-84144d0a7d3c','e56a23f6-b32e-11f1-a478-84144d0a7d3c','212','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56aeb61-b32e-11f1-a478-84144d0a7d3c','e56a2419-b32e-11f1-a478-84144d0a7d3c','34','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56aeba3-b32e-11f1-a478-84144d0a7d3c','e56a243a-b32e-11f1-a478-84144d0a7d3c','372','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56aebe4-b32e-11f1-a478-84144d0a7d3c','e56a245d-b32e-11f1-a478-84144d0a7d3c','251','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56aec24-b32e-11f1-a478-84144d0a7d3c','e56a2491-b32e-11f1-a478-84144d0a7d3c','358','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56aec65-b32e-11f1-a478-84144d0a7d3c','e56a24b4-b32e-11f1-a478-84144d0a7d3c','679','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56aeca7-b32e-11f1-a478-84144d0a7d3c','e56a24d5-b32e-11f1-a478-84144d0a7d3c','500','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56aece9-b32e-11f1-a478-84144d0a7d3c','e56a24f8-b32e-11f1-a478-84144d0a7d3c','33','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56aed2b-b32e-11f1-a478-84144d0a7d3c','e56a2516-b32e-11f1-a478-84144d0a7d3c','298','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56aed6d-b32e-11f1-a478-84144d0a7d3c','e56a2537-b32e-11f1-a478-84144d0a7d3c','691','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56aedaf-b32e-11f1-a478-84144d0a7d3c','e56a2559-b32e-11f1-a478-84144d0a7d3c','241','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56aedf0-b32e-11f1-a478-84144d0a7d3c','e56a2579-b32e-11f1-a478-84144d0a7d3c','44','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56aee31-b32e-11f1-a478-84144d0a7d3c','e56a2c8b-b32e-11f1-a478-84144d0a7d3c','995','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56aeeac-b32e-11f1-a478-84144d0a7d3c','e56a2cfa-b32e-11f1-a478-84144d0a7d3c','44','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56aef14-b32e-11f1-a478-84144d0a7d3c','e56a2d23-b32e-11f1-a478-84144d0a7d3c','233','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56aef7c-b32e-11f1-a478-84144d0a7d3c','e56a2d42-b32e-11f1-a478-84144d0a7d3c','350','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56aefc8-b32e-11f1-a478-84144d0a7d3c','e56a2d61-b32e-11f1-a478-84144d0a7d3c','224','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56af00a-b32e-11f1-a478-84144d0a7d3c','e56a2d81-b32e-11f1-a478-84144d0a7d3c','590','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56af066-b32e-11f1-a478-84144d0a7d3c','e56a2da1-b32e-11f1-a478-84144d0a7d3c','220','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56af0a8-b32e-11f1-a478-84144d0a7d3c','e56a2dc2-b32e-11f1-a478-84144d0a7d3c','245','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56af0ea-b32e-11f1-a478-84144d0a7d3c','e56a34a7-b32e-11f1-a478-84144d0a7d3c','240','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56af136-b32e-11f1-a478-84144d0a7d3c','e56a3512-b32e-11f1-a478-84144d0a7d3c','30','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56af176-b32e-11f1-a478-84144d0a7d3c','e56a353a-b32e-11f1-a478-84144d0a7d3c','1473','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56af1b9-b32e-11f1-a478-84144d0a7d3c','e56a355e-b32e-11f1-a478-84144d0a7d3c','299','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56af1f6-b32e-11f1-a478-84144d0a7d3c','e56a3585-b32e-11f1-a478-84144d0a7d3c','502','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56af230-b32e-11f1-a478-84144d0a7d3c','e56a35a7-b32e-11f1-a478-84144d0a7d3c','594','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56af26c-b32e-11f1-a478-84144d0a7d3c','e56a35c9-b32e-11f1-a478-84144d0a7d3c','1671','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56af2a9-b32e-11f1-a478-84144d0a7d3c','e56a35e9-b32e-11f1-a478-84144d0a7d3c','592','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56af2e6-b32e-11f1-a478-84144d0a7d3c','e56a360b-b32e-11f1-a478-84144d0a7d3c','852','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56af322-b32e-11f1-a478-84144d0a7d3c','e56a362e-b32e-11f1-a478-84144d0a7d3c','','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56af360-b32e-11f1-a478-84144d0a7d3c','e56a3651-b32e-11f1-a478-84144d0a7d3c','504','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56af39c-b32e-11f1-a478-84144d0a7d3c','e56a3672-b32e-11f1-a478-84144d0a7d3c','385','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56af3d7-b32e-11f1-a478-84144d0a7d3c','e56a3692-b32e-11f1-a478-84144d0a7d3c','509','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56af412-b32e-11f1-a478-84144d0a7d3c','e56a36b0-b32e-11f1-a478-84144d0a7d3c','36','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56af44e-b32e-11f1-a478-84144d0a7d3c','e56a36d0-b32e-11f1-a478-84144d0a7d3c','62','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56af4b4-b32e-11f1-a478-84144d0a7d3c','e56a3be5-b32e-11f1-a478-84144d0a7d3c','44','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56af4f2-b32e-11f1-a478-84144d0a7d3c','e56a3c0c-b32e-11f1-a478-84144d0a7d3c','91','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56af52d-b32e-11f1-a478-84144d0a7d3c','e56a3c2a-b32e-11f1-a478-84144d0a7d3c','246','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56af568-b32e-11f1-a478-84144d0a7d3c','e56a3c4a-b32e-11f1-a478-84144d0a7d3c','353','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56af5a4-b32e-11f1-a478-84144d0a7d3c','e56a3c6c-b32e-11f1-a478-84144d0a7d3c','98','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56af5e0-b32e-11f1-a478-84144d0a7d3c','e56a3c8d-b32e-11f1-a478-84144d0a7d3c','964','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56af61b-b32e-11f1-a478-84144d0a7d3c','e56a3cad-b32e-11f1-a478-84144d0a7d3c','354','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56af657-b32e-11f1-a478-84144d0a7d3c','e56a3cce-b32e-11f1-a478-84144d0a7d3c','972','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56af691-b32e-11f1-a478-84144d0a7d3c','e56a3cef-b32e-11f1-a478-84144d0a7d3c','39','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56af6cd-b32e-11f1-a478-84144d0a7d3c','e56a3d11-b32e-11f1-a478-84144d0a7d3c','1876','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56af6f9-b32e-11f1-a478-84144d0a7d3c','e56a3d11-b32e-11f1-a478-84144d0a7d3c','1658','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56af740-b32e-11f1-a478-84144d0a7d3c','e56a3d31-b32e-11f1-a478-84144d0a7d3c','44','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56af787-b32e-11f1-a478-84144d0a7d3c','e56a3d52-b32e-11f1-a478-84144d0a7d3c','962','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56af7c7-b32e-11f1-a478-84144d0a7d3c','e56a3d71-b32e-11f1-a478-84144d0a7d3c','81','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56af807-b32e-11f1-a478-84144d0a7d3c','e56a3d93-b32e-11f1-a478-84144d0a7d3c','76','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56af838-b32e-11f1-a478-84144d0a7d3c','e56a3d93-b32e-11f1-a478-84144d0a7d3c','77','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56af878-b32e-11f1-a478-84144d0a7d3c','e56a3db4-b32e-11f1-a478-84144d0a7d3c','254','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56af8b4-b32e-11f1-a478-84144d0a7d3c','e56a3dd4-b32e-11f1-a478-84144d0a7d3c','996','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56af8f1-b32e-11f1-a478-84144d0a7d3c','e56a3df5-b32e-11f1-a478-84144d0a7d3c','855','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56af92f-b32e-11f1-a478-84144d0a7d3c','e56a3e16-b32e-11f1-a478-84144d0a7d3c','686','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56af96c-b32e-11f1-a478-84144d0a7d3c','e56a3e37-b32e-11f1-a478-84144d0a7d3c','1869','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56af9aa-b32e-11f1-a478-84144d0a7d3c','e56a3e5a-b32e-11f1-a478-84144d0a7d3c','82','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56af9e6-b32e-11f1-a478-84144d0a7d3c','e56a3e7a-b32e-11f1-a478-84144d0a7d3c','965','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56afa24-b32e-11f1-a478-84144d0a7d3c','e56a3e9c-b32e-11f1-a478-84144d0a7d3c','856','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56afa61-b32e-11f1-a478-84144d0a7d3c','e56a3ebd-b32e-11f1-a478-84144d0a7d3c','961','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56afa9e-b32e-11f1-a478-84144d0a7d3c','e56a3edd-b32e-11f1-a478-84144d0a7d3c','231','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56afad9-b32e-11f1-a478-84144d0a7d3c','e56a3efe-b32e-11f1-a478-84144d0a7d3c','218','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56afb15-b32e-11f1-a478-84144d0a7d3c','e56a3f1f-b32e-11f1-a478-84144d0a7d3c','1758','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56afb51-b32e-11f1-a478-84144d0a7d3c','e56a3f41-b32e-11f1-a478-84144d0a7d3c','423','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56afb8e-b32e-11f1-a478-84144d0a7d3c','e56a3f62-b32e-11f1-a478-84144d0a7d3c','94','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56afbc9-b32e-11f1-a478-84144d0a7d3c','e56a3f82-b32e-11f1-a478-84144d0a7d3c','266','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56afc05-b32e-11f1-a478-84144d0a7d3c','e56a3fa5-b32e-11f1-a478-84144d0a7d3c','370','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56afc41-b32e-11f1-a478-84144d0a7d3c','e56a3fc5-b32e-11f1-a478-84144d0a7d3c','352','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56afc7c-b32e-11f1-a478-84144d0a7d3c','e56a3fe5-b32e-11f1-a478-84144d0a7d3c','371','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56afcba-b32e-11f1-a478-84144d0a7d3c','e56a4006-b32e-11f1-a478-84144d0a7d3c','853','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56b2db5-b32e-11f1-a478-84144d0a7d3c','e56a4028-b32e-11f1-a478-84144d0a7d3c','590','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56b2e22-b32e-11f1-a478-84144d0a7d3c','e56a404a-b32e-11f1-a478-84144d0a7d3c','212','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56b2e7a-b32e-11f1-a478-84144d0a7d3c','e56a406b-b32e-11f1-a478-84144d0a7d3c','377','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56b2ecd-b32e-11f1-a478-84144d0a7d3c','e56a408a-b32e-11f1-a478-84144d0a7d3c','373','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56b2f1a-b32e-11f1-a478-84144d0a7d3c','e56a40ab-b32e-11f1-a478-84144d0a7d3c','261','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56b2f64-b32e-11f1-a478-84144d0a7d3c','e56a40cb-b32e-11f1-a478-84144d0a7d3c','960','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56b2fb0-b32e-11f1-a478-84144d0a7d3c','e56a40ec-b32e-11f1-a478-84144d0a7d3c','52','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56b2ffd-b32e-11f1-a478-84144d0a7d3c','e56a410c-b32e-11f1-a478-84144d0a7d3c','692','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56b3048-b32e-11f1-a478-84144d0a7d3c','e56a412d-b32e-11f1-a478-84144d0a7d3c','389','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56b3090-b32e-11f1-a478-84144d0a7d3c','e56a414d-b32e-11f1-a478-84144d0a7d3c','223','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56b30dc-b32e-11f1-a478-84144d0a7d3c','e56a416d-b32e-11f1-a478-84144d0a7d3c','356','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56b3125-b32e-11f1-a478-84144d0a7d3c','e56a418d-b32e-11f1-a478-84144d0a7d3c','95','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56b316e-b32e-11f1-a478-84144d0a7d3c','e56a41ae-b32e-11f1-a478-84144d0a7d3c','382','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56b31c4-b32e-11f1-a478-84144d0a7d3c','e56a41ce-b32e-11f1-a478-84144d0a7d3c','976','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56b3216-b32e-11f1-a478-84144d0a7d3c','e56a41ef-b32e-11f1-a478-84144d0a7d3c','1670','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56b3261-b32e-11f1-a478-84144d0a7d3c','e56a4211-b32e-11f1-a478-84144d0a7d3c','258','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56b32ac-b32e-11f1-a478-84144d0a7d3c','e56a4233-b32e-11f1-a478-84144d0a7d3c','222','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56b32f6-b32e-11f1-a478-84144d0a7d3c','e56a4253-b32e-11f1-a478-84144d0a7d3c','1664','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56b3340-b32e-11f1-a478-84144d0a7d3c','e56a4274-b32e-11f1-a478-84144d0a7d3c','596','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56b3388-b32e-11f1-a478-84144d0a7d3c','e56a4294-b32e-11f1-a478-84144d0a7d3c','230','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56b33d2-b32e-11f1-a478-84144d0a7d3c','e56a42b4-b32e-11f1-a478-84144d0a7d3c','265','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56b341b-b32e-11f1-a478-84144d0a7d3c','e56a42d4-b32e-11f1-a478-84144d0a7d3c','60','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56b3467-b32e-11f1-a478-84144d0a7d3c','e56a42f6-b32e-11f1-a478-84144d0a7d3c','262','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56b34b3-b32e-11f1-a478-84144d0a7d3c','e56a4319-b32e-11f1-a478-84144d0a7d3c','264','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56b34ff-b32e-11f1-a478-84144d0a7d3c','e56a433b-b32e-11f1-a478-84144d0a7d3c','687','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56b354a-b32e-11f1-a478-84144d0a7d3c','e56a435c-b32e-11f1-a478-84144d0a7d3c','227','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56b35a5-b32e-11f1-a478-84144d0a7d3c','e56a437c-b32e-11f1-a478-84144d0a7d3c','672','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56b35f0-b32e-11f1-a478-84144d0a7d3c','e56a439e-b32e-11f1-a478-84144d0a7d3c','234','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56b363c-b32e-11f1-a478-84144d0a7d3c','e56a43cb-b32e-11f1-a478-84144d0a7d3c','505','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56b3685-b32e-11f1-a478-84144d0a7d3c','e56a43eb-b32e-11f1-a478-84144d0a7d3c','683','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56b36d0-b32e-11f1-a478-84144d0a7d3c','e56a440a-b32e-11f1-a478-84144d0a7d3c','31','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56b371b-b32e-11f1-a478-84144d0a7d3c','e56a442c-b32e-11f1-a478-84144d0a7d3c','47','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56b3765-b32e-11f1-a478-84144d0a7d3c','e56a444c-b32e-11f1-a478-84144d0a7d3c','977','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56b37b4-b32e-11f1-a478-84144d0a7d3c','e56a446c-b32e-11f1-a478-84144d0a7d3c','674','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56b37fe-b32e-11f1-a478-84144d0a7d3c','e56a448c-b32e-11f1-a478-84144d0a7d3c','64','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56b3847-b32e-11f1-a478-84144d0a7d3c','e56a44b0-b32e-11f1-a478-84144d0a7d3c','968','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56b3892-b32e-11f1-a478-84144d0a7d3c','e56a44d1-b32e-11f1-a478-84144d0a7d3c','92','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56b38dc-b32e-11f1-a478-84144d0a7d3c','e56a44f3-b32e-11f1-a478-84144d0a7d3c','507','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56b3927-b32e-11f1-a478-84144d0a7d3c','e56a4514-b32e-11f1-a478-84144d0a7d3c','64','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56b3971-b32e-11f1-a478-84144d0a7d3c','e56a4535-b32e-11f1-a478-84144d0a7d3c','51','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56b39c9-b32e-11f1-a478-84144d0a7d3c','e56a4555-b32e-11f1-a478-84144d0a7d3c','63','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56b3a12-b32e-11f1-a478-84144d0a7d3c','e56a4576-b32e-11f1-a478-84144d0a7d3c','680','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56b3a5d-b32e-11f1-a478-84144d0a7d3c','e56a4596-b32e-11f1-a478-84144d0a7d3c','675','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56b3aa6-b32e-11f1-a478-84144d0a7d3c','e56a45b7-b32e-11f1-a478-84144d0a7d3c','48','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56b3af0-b32e-11f1-a478-84144d0a7d3c','e56a45d7-b32e-11f1-a478-84144d0a7d3c','1787','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56b3b28-b32e-11f1-a478-84144d0a7d3c','e56a45d7-b32e-11f1-a478-84144d0a7d3c','1939','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56b3b76-b32e-11f1-a478-84144d0a7d3c','e56a45f7-b32e-11f1-a478-84144d0a7d3c','850','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56b3bc3-b32e-11f1-a478-84144d0a7d3c','e56a697a-b32e-11f1-a478-84144d0a7d3c','351','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56b3c0c-b32e-11f1-a478-84144d0a7d3c','e56a69d8-b32e-11f1-a478-84144d0a7d3c','595','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56b3c58-b32e-11f1-a478-84144d0a7d3c','e56a6a00-b32e-11f1-a478-84144d0a7d3c','970','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56b3ca1-b32e-11f1-a478-84144d0a7d3c','e56a6a25-b32e-11f1-a478-84144d0a7d3c','689','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56b3ceb-b32e-11f1-a478-84144d0a7d3c','e56a6a49-b32e-11f1-a478-84144d0a7d3c','974','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56b3d38-b32e-11f1-a478-84144d0a7d3c','e56a6a68-b32e-11f1-a478-84144d0a7d3c','262','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56b3d8f-b32e-11f1-a478-84144d0a7d3c','e56a80ef-b32e-11f1-a478-84144d0a7d3c','40','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56b3dda-b32e-11f1-a478-84144d0a7d3c','e56a815a-b32e-11f1-a478-84144d0a7d3c','7','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56b3e3d-b32e-11f1-a478-84144d0a7d3c','e56a8182-b32e-11f1-a478-84144d0a7d3c','250','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56b3e88-b32e-11f1-a478-84144d0a7d3c','e56a819f-b32e-11f1-a478-84144d0a7d3c','966','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56b646d-b32e-11f1-a478-84144d0a7d3c','e56a81be-b32e-11f1-a478-84144d0a7d3c','249','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56b64de-b32e-11f1-a478-84144d0a7d3c','e56a81da-b32e-11f1-a478-84144d0a7d3c','221','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56b6533-b32e-11f1-a478-84144d0a7d3c','e56a81f7-b32e-11f1-a478-84144d0a7d3c','65','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56b6585-b32e-11f1-a478-84144d0a7d3c','e56a8216-b32e-11f1-a478-84144d0a7d3c','500','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56b65d3-b32e-11f1-a478-84144d0a7d3c','e56a8238-b32e-11f1-a478-84144d0a7d3c','290','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56b661f-b32e-11f1-a478-84144d0a7d3c','e56a8258-b32e-11f1-a478-84144d0a7d3c','4779','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56b666c-b32e-11f1-a478-84144d0a7d3c','e56a8277-b32e-11f1-a478-84144d0a7d3c','677','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56b66b9-b32e-11f1-a478-84144d0a7d3c','e56a8295-b32e-11f1-a478-84144d0a7d3c','232','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56b6705-b32e-11f1-a478-84144d0a7d3c','e56a82b3-b32e-11f1-a478-84144d0a7d3c','503','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56b6752-b32e-11f1-a478-84144d0a7d3c','e56a82d3-b32e-11f1-a478-84144d0a7d3c','378','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56b679d-b32e-11f1-a478-84144d0a7d3c','e56a82f2-b32e-11f1-a478-84144d0a7d3c','252','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56b67e9-b32e-11f1-a478-84144d0a7d3c','e56a8312-b32e-11f1-a478-84144d0a7d3c','508','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56b8448-b32e-11f1-a478-84144d0a7d3c','e56a8333-b32e-11f1-a478-84144d0a7d3c','381','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56b84c5-b32e-11f1-a478-84144d0a7d3c','e56a8351-b32e-11f1-a478-84144d0a7d3c','211','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56b853d-b32e-11f1-a478-84144d0a7d3c','e56a8370-b32e-11f1-a478-84144d0a7d3c','239','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56b85a4-b32e-11f1-a478-84144d0a7d3c','e56a8390-b32e-11f1-a478-84144d0a7d3c','597','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56b8610-b32e-11f1-a478-84144d0a7d3c','e56a83b0-b32e-11f1-a478-84144d0a7d3c','421','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56b8672-b32e-11f1-a478-84144d0a7d3c','e56a83cd-b32e-11f1-a478-84144d0a7d3c','386','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56b86da-b32e-11f1-a478-84144d0a7d3c','e56a83ec-b32e-11f1-a478-84144d0a7d3c','46','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56b873e-b32e-11f1-a478-84144d0a7d3c','e56a840b-b32e-11f1-a478-84144d0a7d3c','268','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56b87a6-b32e-11f1-a478-84144d0a7d3c','e56a842c-b32e-11f1-a478-84144d0a7d3c','1721','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56b880e-b32e-11f1-a478-84144d0a7d3c','e56a844a-b32e-11f1-a478-84144d0a7d3c','248','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56b8876-b32e-11f1-a478-84144d0a7d3c','e56a8468-b32e-11f1-a478-84144d0a7d3c','963','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56b88da-b32e-11f1-a478-84144d0a7d3c','e56a8485-b32e-11f1-a478-84144d0a7d3c','1649','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56b893f-b32e-11f1-a478-84144d0a7d3c','e56a84a6-b32e-11f1-a478-84144d0a7d3c','235','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56b89a4-b32e-11f1-a478-84144d0a7d3c','e56a84c6-b32e-11f1-a478-84144d0a7d3c','228','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56b8a08-b32e-11f1-a478-84144d0a7d3c','e56a84e5-b32e-11f1-a478-84144d0a7d3c','66','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56b8a7e-b32e-11f1-a478-84144d0a7d3c','e56a8503-b32e-11f1-a478-84144d0a7d3c','992','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56b8b0d-b32e-11f1-a478-84144d0a7d3c','e56a8523-b32e-11f1-a478-84144d0a7d3c','690','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56b8b71-b32e-11f1-a478-84144d0a7d3c','e56a8545-b32e-11f1-a478-84144d0a7d3c','993','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56b8bd6-b32e-11f1-a478-84144d0a7d3c','e56a8561-b32e-11f1-a478-84144d0a7d3c','670','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56b8c3c-b32e-11f1-a478-84144d0a7d3c','e56a8580-b32e-11f1-a478-84144d0a7d3c','676','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56b8ca0-b32e-11f1-a478-84144d0a7d3c','e56a859f-b32e-11f1-a478-84144d0a7d3c','1868','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56b8d05-b32e-11f1-a478-84144d0a7d3c','e56a85be-b32e-11f1-a478-84144d0a7d3c','216','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56b8d6c-b32e-11f1-a478-84144d0a7d3c','e56a85dc-b32e-11f1-a478-84144d0a7d3c','90','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56b8dd0-b32e-11f1-a478-84144d0a7d3c','e56a8611-b32e-11f1-a478-84144d0a7d3c','688','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56b8e34-b32e-11f1-a478-84144d0a7d3c','e56a8d44-b32e-11f1-a478-84144d0a7d3c','886','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56b8e99-b32e-11f1-a478-84144d0a7d3c','e56a8daf-b32e-11f1-a478-84144d0a7d3c','255','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56b8efd-b32e-11f1-a478-84144d0a7d3c','e56a8dd7-b32e-11f1-a478-84144d0a7d3c','256','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56b8f5f-b32e-11f1-a478-84144d0a7d3c','e56a8df7-b32e-11f1-a478-84144d0a7d3c','380','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56b8fc3-b32e-11f1-a478-84144d0a7d3c','e56a8e18-b32e-11f1-a478-84144d0a7d3c','1','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56b9041-b32e-11f1-a478-84144d0a7d3c','e56a8e3d-b32e-11f1-a478-84144d0a7d3c','598','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56b90a7-b32e-11f1-a478-84144d0a7d3c','e56a8e5d-b32e-11f1-a478-84144d0a7d3c','1','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56b910c-b32e-11f1-a478-84144d0a7d3c','e56a8e7f-b32e-11f1-a478-84144d0a7d3c','998','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56b9174-b32e-11f1-a478-84144d0a7d3c','e56a8e9e-b32e-11f1-a478-84144d0a7d3c','39','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56b91da-b32e-11f1-a478-84144d0a7d3c','e56a8ebe-b32e-11f1-a478-84144d0a7d3c','1784','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56b923f-b32e-11f1-a478-84144d0a7d3c','e56a8ee2-b32e-11f1-a478-84144d0a7d3c','58','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56b92a5-b32e-11f1-a478-84144d0a7d3c','e56a8f02-b32e-11f1-a478-84144d0a7d3c','1284','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56b930b-b32e-11f1-a478-84144d0a7d3c','e56a8f1e-b32e-11f1-a478-84144d0a7d3c','1340','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56b936f-b32e-11f1-a478-84144d0a7d3c','e56a931d-b32e-11f1-a478-84144d0a7d3c','84','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56b93d3-b32e-11f1-a478-84144d0a7d3c','e56a9343-b32e-11f1-a478-84144d0a7d3c','678','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56b9437-b32e-11f1-a478-84144d0a7d3c','e56a9360-b32e-11f1-a478-84144d0a7d3c','681','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56b949a-b32e-11f1-a478-84144d0a7d3c','e56a937f-b32e-11f1-a478-84144d0a7d3c','685','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56b9501-b32e-11f1-a478-84144d0a7d3c','e56a939e-b32e-11f1-a478-84144d0a7d3c','967','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56b9578-b32e-11f1-a478-84144d0a7d3c','e56a93bc-b32e-11f1-a478-84144d0a7d3c','27','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56b95e5-b32e-11f1-a478-84144d0a7d3c','e56a93dc-b32e-11f1-a478-84144d0a7d3c','260','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000'),
('e56b964b-b32e-11f1-a478-84144d0a7d3c','e56a93fb-b32e-11f1-a478-84144d0a7d3c','263','2026-09-18 23:30:39.000','2026-09-18 23:30:39.000');
/*!40000 ALTER TABLE `country_calling_codes` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `float_ledger_entries`
--

DROP TABLE IF EXISTS `float_ledger_entries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `float_ledger_entries` (
  `id` char(36) NOT NULL,
  `publicId` varchar(20) NOT NULL,
  `clientId` char(36) NOT NULL,
  `createdById` char(36) DEFAULT NULL,
  `transactionType` enum('TOPUP','DEBIT','REFUND','ADJUSTMENT') NOT NULL,
  `credits` int(11) NOT NULL,
  `referenceType` enum('MESSAGE','ADMIN','SYSTEM','IMPORT') NOT NULL,
  `referenceId` char(36) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  PRIMARY KEY (`id`),
  UNIQUE KEY `float_ledger_entries_publicId_key` (`publicId`),
  KEY `float_ledger_entries_clientId_idx` (`clientId`),
  KEY `float_ledger_entries_transactionType_idx` (`transactionType`),
  KEY `float_ledger_entries_referenceType_idx` (`referenceType`),
  KEY `float_ledger_entries_referenceId_idx` (`referenceId`),
  KEY `float_ledger_entries_createdById_fkey` (`createdById`),
  CONSTRAINT `float_ledger_entries_clientId_fkey` FOREIGN KEY (`clientId`) REFERENCES `clients` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `float_ledger_entries_createdById_fkey` FOREIGN KEY (`createdById`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `float_ledger_entries`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `float_ledger_entries` WRITE;
/*!40000 ALTER TABLE `float_ledger_entries` DISABLE KEYS */;
INSERT INTO `float_ledger_entries` VALUES
('02286ea2-ac7e-44ff-8169-d96d05ca50ae','bKUKf3ugZrFU1g','67c9b53f-b74e-43d0-859f-5349b5b9d0c7',NULL,'DEBIT',-1,'MESSAGE','62177de6-e209-4c63-a79a-af830109f73b','Message submission: Nciv-yUZmCyO2g','2026-09-16 23:11:00.620'),
('0922d236-35ed-4ad2-9993-6ea3ab017259','Dq8nip235rQNUg','67c9b53f-b74e-43d0-859f-5349b5b9d0c7',NULL,'DEBIT',-1,'MESSAGE','c5427598-4554-47c4-95e9-22005ec7eeb7','Message submission: Vr_z6JH0kOx4FA','2026-09-16 23:48:33.116'),
('2189ea2a-6235-4f28-bea4-33d31e1e09de','1GmA2Dp1t6OBZg','67c9b53f-b74e-43d0-859f-5349b5b9d0c7',NULL,'DEBIT',-1,'MESSAGE','fb999045-6016-4620-a663-c20e22b46fe1','Message submission: brms0_Az3XeNlA','2026-09-16 23:42:49.629'),
('2d55d763-c07f-40f7-80e5-7ebafc2d13ed','-2-OITvfN3Tj-w','67c9b53f-b74e-43d0-859f-5349b5b9d0c7',NULL,'DEBIT',-1,'MESSAGE','d1a9a3a8-c952-4bfa-b7e9-bdd779589eb6','Message submission: OEkVnXP0PBea3g','2026-09-18 23:37:24.727'),
('3b7d1d7b-0a6c-4e89-af22-94c8af9dbf38','jH1QhvkE7yV2AQ','67c9b53f-b74e-43d0-859f-5349b5b9d0c7',NULL,'DEBIT',-1,'MESSAGE','3feb8cb5-9f4b-4d8b-ab51-f2e64be23fc7','Message submission: Vu48foZp80Y8cg','2026-09-16 23:46:02.775'),
('4ed08e3e-1338-46fc-bca9-6f7275f5b79f','-MxU4ZxjxlFnCA','67c9b53f-b74e-43d0-859f-5349b5b9d0c7',NULL,'DEBIT',-1,'MESSAGE','b33d3d4d-26e6-452e-b233-1f8c7e2235e0','Message submission: a3gBE7B5rIqb_A','2026-09-17 00:05:25.349'),
('673d0f56-5d03-437f-a7c9-f8b48797b438','69nX_J3Mj62hZA','67c9b53f-b74e-43d0-859f-5349b5b9d0c7',NULL,'DEBIT',-1,'MESSAGE','b6d267c0-4614-4a3c-8fb3-d0548457f03d','Message submission: dk05JLeeLBI6fw','2026-09-18 23:32:18.073'),
('6c7bdc56-926b-43df-9ff0-1f9d3901c44e','70tOYHgnFl8DOg','67c9b53f-b74e-43d0-859f-5349b5b9d0c7',NULL,'DEBIT',-1,'MESSAGE','826665dc-0435-49b6-85fd-1c7fd866dcbc','Message submission: 6v8N9z3rM9Mr9Q','2026-09-16 23:52:29.278'),
('72e5fa1f-4561-45e2-ace9-1bbc5c04d9a5','hPYlnlO5UV3pdw','67c9b53f-b74e-43d0-859f-5349b5b9d0c7','00000000-0000-0000-0000-000000000015','TOPUP',10,'ADMIN','test-001','testing float','2026-09-16 22:47:26.482'),
('7e55c238-a80f-48aa-8ff0-4484bbd01d67','XlYi00QP5QVPDA','67c9b53f-b74e-43d0-859f-5349b5b9d0c7',NULL,'DEBIT',-1,'MESSAGE','bf259f8c-b417-4d94-829f-71eeab24c4ea','Message submission: XA_CjuxS4Yflbg','2026-09-16 23:19:13.280'),
('9be251a4-df31-4324-b773-2cb43355305e','ZAomZoHxNiO6WA','67c9b53f-b74e-43d0-859f-5349b5b9d0c7',NULL,'DEBIT',-1,'MESSAGE','431c91a9-8563-46d1-8bf5-e2a51cfd4a96','Message submission: KjTWn5ShsZTn0g','2026-09-16 23:24:52.559'),
('a6016f29-a264-49cb-9deb-a55bd3e14870','xPARsZBti9DUtg','67c9b53f-b74e-43d0-859f-5349b5b9d0c7',NULL,'DEBIT',-1,'MESSAGE','30c83bdc-8e7b-4406-91eb-efd1710eaff3','Message submission: EXsji0vaREUTMg','2026-09-17 00:09:11.101'),
('a726c228-df2b-4e20-aa25-d72e10dcd96c','QHvmkeX0zDjP2A','67c9b53f-b74e-43d0-859f-5349b5b9d0c7',NULL,'DEBIT',-1,'MESSAGE','2866c881-b3e2-4865-85c6-3e52d6d10aef','Message submission: nC7oj6A38i-7BQ','2026-09-16 23:29:25.893'),
('b18a91c3-25cb-462f-bda6-d410cafd2b89','WwGMxjL97KjClA','67c9b53f-b74e-43d0-859f-5349b5b9d0c7',NULL,'DEBIT',-1,'MESSAGE','76b08e5f-64c9-419b-8b45-3efed4ce6bc5','Message submission: GyxRN_j1vDhpxg','2026-09-17 00:00:20.544'),
('d06c833d-505e-4f61-9f0e-58474da8109d','h7G6P3gL0mGkag','67c9b53f-b74e-43d0-859f-5349b5b9d0c7',NULL,'DEBIT',-1,'MESSAGE','418bb9a6-f96e-4548-ad93-56c2e4d6f9b4','Message submission: J2XNrp4UKut9nA','2026-09-16 22:52:53.684'),
('db626c56-0615-4292-ad17-4a56b1bf78c7','pJs37na0bN9ZNw','67c9b53f-b74e-43d0-859f-5349b5b9d0c7',NULL,'DEBIT',-1,'MESSAGE','4e514341-eb2d-45de-bd8c-5e555f0400a3','Message submission: cAytFiAq8Bj3wQ','2026-09-16 23:05:25.391'),
('e209019c-4aab-4969-bfa4-cef3e54c3379','2fkp9-unT2dMuQ','67c9b53f-b74e-43d0-859f-5349b5b9d0c7',NULL,'DEBIT',-1,'MESSAGE','df794a62-8457-475c-b052-0b6d653d323b','Message submission: aLTSEgzypjO_yQ','2026-09-16 23:39:35.631'),
('e6711568-1738-47fe-b9c1-b41c7cb3205d','Z73RYl4EZ-Js_w','67c9b53f-b74e-43d0-859f-5349b5b9d0c7',NULL,'DEBIT',-1,'MESSAGE','21647dd6-e21f-40a1-93fb-5fc0aafd3246','Message submission: peUevyBadr6GNA','2026-09-16 22:47:40.667'),
('f0c0b8fe-9748-4e19-bbb9-357936f869ab','V9kBoW3sO9K8Dg','67c9b53f-b74e-43d0-859f-5349b5b9d0c7',NULL,'DEBIT',-1,'MESSAGE','f158e43b-0e2f-4fb7-a127-9502d2dfd2ea','Message submission: y9qs-xU7ipeX5Q','2026-09-16 23:02:22.683'),
('f2480fa6-1939-4bc0-b890-f9dbbcd75a70','QfOHjqVYIMDxzg','67c9b53f-b74e-43d0-859f-5349b5b9d0c7','00000000-0000-0000-0000-000000000015','TOPUP',10000000,'ADMIN','test-001','test float','2026-09-16 23:45:31.426');
/*!40000 ALTER TABLE `float_ledger_entries` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `message_route_attempts`
--

DROP TABLE IF EXISTS `message_route_attempts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `message_route_attempts` (
  `id` char(36) NOT NULL,
  `messageId` char(36) NOT NULL,
  `routeId` char(36) NOT NULL,
  `connectorId` char(36) NOT NULL,
  `attemptNumber` int(11) NOT NULL,
  `priority` int(11) NOT NULL,
  `status` enum('PENDING','DISPATCHED','SUBMITTING','SUBMITTED','FAILED','UNKNOWN') NOT NULL DEFAULT 'PENDING',
  `providerMessageId` varchar(100) DEFAULT NULL,
  `errorCode` varchar(50) DEFAULT NULL,
  `errorMessage` varchar(255) DEFAULT NULL,
  `dispatchedAt` datetime(3) DEFAULT NULL,
  `startedAt` datetime(3) DEFAULT NULL,
  `submittedAt` datetime(3) DEFAULT NULL,
  `failedAt` datetime(3) DEFAULT NULL,
  `completedAt` datetime(3) DEFAULT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `message_route_attempts_messageId_attemptNumber_key` (`messageId`,`attemptNumber`),
  UNIQUE KEY `message_route_attempts_messageId_routeId_key` (`messageId`,`routeId`),
  KEY `message_route_attempts_messageId_idx` (`messageId`),
  KEY `message_route_attempts_routeId_idx` (`routeId`),
  KEY `message_route_attempts_connectorId_idx` (`connectorId`),
  KEY `message_route_attempts_status_idx` (`status`),
  KEY `message_route_attempts_providerMessageId_idx` (`providerMessageId`),
  CONSTRAINT `message_route_attempts_connectorId_fkey` FOREIGN KEY (`connectorId`) REFERENCES `connectors` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `message_route_attempts_messageId_fkey` FOREIGN KEY (`messageId`) REFERENCES `messages` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `message_route_attempts_routeId_fkey` FOREIGN KEY (`routeId`) REFERENCES `routes` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `message_route_attempts`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `message_route_attempts` WRITE;
/*!40000 ALTER TABLE `message_route_attempts` DISABLE KEYS */;
INSERT INTO `message_route_attempts` VALUES
('121737ac-425e-4486-b7ad-d4eb8a8d7d64','2866c881-b3e2-4865-85c6-3e52d6d10aef','48b9c46e-4e0a-4858-9a63-a2d7a82145e5','c4d0d250-65cf-4638-87f3-0005a4ee4e19',1,1,'UNKNOWN',NULL,'AT_MISSING_RECIPIENT','Africa\'s Talking returned a successful response without a recipient result.',NULL,'2026-09-16 23:29:26.868',NULL,NULL,NULL,'2026-09-16 23:29:26.869','2026-09-16 23:29:28.594'),
('1b784d43-5e4a-4a40-b033-ff3926ba6755','df794a62-8457-475c-b052-0b6d653d323b','48b9c46e-4e0a-4858-9a63-a2d7a82145e5','c4d0d250-65cf-4638-87f3-0005a4ee4e19',1,1,'FAILED',NULL,'AT_REQUEST_REJECTED','InvalidSenderId',NULL,'2026-09-16 23:39:36.493',NULL,'2026-09-16 23:39:38.025',NULL,'2026-09-16 23:39:36.494','2026-09-16 23:39:38.026'),
('1f7662cb-f58a-4851-9b8f-648196902d0d','d1a9a3a8-c952-4bfa-b7e9-bdd779589eb6','e67c928a-648a-4fd2-8317-d7d12d4fd4fc','9f1c99a7-9e8e-11f1-a1a3-84144d0a7d3c',1,2,'FAILED',NULL,'ONFON_401','Value filter failed for user [adcconnect] (source_address filter mismatch).',NULL,'2026-09-18 23:37:24.879',NULL,'2026-09-18 23:37:25.675',NULL,'2026-09-18 23:37:24.881','2026-09-18 23:37:25.676'),
('2b656966-f8ec-419d-b3fe-680e0e77f1cb','fb999045-6016-4620-a663-c20e22b46fe1','e67c928a-648a-4fd2-8317-d7d12d4fd4fc','9f1c99a7-9e8e-11f1-a1a3-84144d0a7d3c',1,2,'FAILED',NULL,'HTTP_PROVIDER_NOT_REGISTERED','HTTP provider \'Onfon\' is not registered.',NULL,'2026-09-16 23:42:49.692',NULL,'2026-09-16 23:42:49.717',NULL,'2026-09-16 23:42:49.692','2026-09-16 23:42:49.718'),
('2cd67269-fa16-4da4-9309-1cb3599b7d8c','3feb8cb5-9f4b-4d8b-ab51-f2e64be23fc7','e67c928a-648a-4fd2-8317-d7d12d4fd4fc','9f1c99a7-9e8e-11f1-a1a3-84144d0a7d3c',1,2,'FAILED',NULL,'HTTP_PROVIDER_NOT_REGISTERED','HTTP provider \'onfone\' is not registered.',NULL,'2026-09-16 23:46:02.895',NULL,'2026-09-16 23:46:02.912',NULL,'2026-09-16 23:46:02.896','2026-09-16 23:46:02.913'),
('3095a136-f04e-4224-85e3-d93ee2cbce0e','21647dd6-e21f-40a1-93fb-5fc0aafd3246','48b9c46e-4e0a-4858-9a63-a2d7a82145e5','c4d0d250-65cf-4638-87f3-0005a4ee4e19',1,1,'PENDING',NULL,NULL,NULL,NULL,'2026-09-16 22:48:53.442',NULL,NULL,NULL,'2026-09-16 22:48:53.443','2026-09-16 22:48:53.443'),
('3381de53-c9e0-4f57-86b5-3d5ef0853e42','f158e43b-0e2f-4fb7-a127-9502d2dfd2ea','48b9c46e-4e0a-4858-9a63-a2d7a82145e5','c4d0d250-65cf-4638-87f3-0005a4ee4e19',1,1,'PENDING',NULL,NULL,NULL,NULL,'2026-09-16 23:02:23.211',NULL,NULL,NULL,'2026-09-16 23:02:23.212','2026-09-16 23:02:23.212'),
('362605e0-5fbc-44e3-9452-bd9c46a960c5','62177de6-e209-4c63-a79a-af830109f73b','48b9c46e-4e0a-4858-9a63-a2d7a82145e5','c4d0d250-65cf-4638-87f3-0005a4ee4e19',1,1,'PENDING',NULL,NULL,NULL,NULL,'2026-09-16 23:11:00.719',NULL,NULL,NULL,'2026-09-16 23:11:00.720','2026-09-16 23:11:00.720'),
('389665d1-8cc6-4df0-9fec-0dff022a0b51','4e514341-eb2d-45de-bd8c-5e555f0400a3','48b9c46e-4e0a-4858-9a63-a2d7a82145e5','c4d0d250-65cf-4638-87f3-0005a4ee4e19',1,1,'PENDING',NULL,NULL,NULL,NULL,'2026-09-16 23:05:26.380',NULL,NULL,NULL,'2026-09-16 23:05:26.381','2026-09-16 23:05:26.381'),
('46a7d7ac-830c-4f43-9bc6-07163b37fc86','3feb8cb5-9f4b-4d8b-ab51-f2e64be23fc7','48b9c46e-4e0a-4858-9a63-a2d7a82145e5','c4d0d250-65cf-4638-87f3-0005a4ee4e19',2,3,'FAILED',NULL,'AT_REQUEST_REJECTED','InvalidSenderId',NULL,'2026-09-16 23:46:02.920',NULL,'2026-09-16 23:46:04.629',NULL,'2026-09-16 23:46:02.920','2026-09-16 23:46:04.630'),
('58af0d8b-e144-4592-9cf6-f18197989825','d1a9a3a8-c952-4bfa-b7e9-bdd779589eb6','48b9c46e-4e0a-4858-9a63-a2d7a82145e5','c4d0d250-65cf-4638-87f3-0005a4ee4e19',2,3,'FAILED',NULL,'AT_REQUEST_REJECTED','InvalidSenderId',NULL,'2026-09-18 23:37:25.703',NULL,'2026-09-18 23:37:27.312',NULL,'2026-09-18 23:37:25.704','2026-09-18 23:37:27.313'),
('5ded4632-4292-4161-975e-29f72e18b140','bf259f8c-b417-4d94-829f-71eeab24c4ea','48b9c46e-4e0a-4858-9a63-a2d7a82145e5','c4d0d250-65cf-4638-87f3-0005a4ee4e19',1,1,'FAILED',NULL,'HTTP_400','The request content was malformed:\nObject is missing required member \'phoneNumbers\'',NULL,'2026-09-16 23:19:14.237',NULL,'2026-09-16 23:19:16.027',NULL,'2026-09-16 23:19:14.238','2026-09-16 23:19:16.028'),
('65f56afa-dd5e-464a-94f5-75226dbaf58b','76b08e5f-64c9-419b-8b45-3efed4ce6bc5','e67c928a-648a-4fd2-8317-d7d12d4fd4fc','9f1c99a7-9e8e-11f1-a1a3-84144d0a7d3c',1,2,'UNKNOWN',NULL,'ONFON_MISSING_MESSAGE_ID','Onfon accepted the SMS submission but did not return a MessageId.',NULL,'2026-09-17 00:00:20.794',NULL,NULL,NULL,'2026-09-17 00:00:20.795','2026-09-17 00:00:21.725'),
('6c5f8a13-f16e-47e2-adca-8182f01827d1','418bb9a6-f96e-4548-ad93-56c2e4d6f9b4','48b9c46e-4e0a-4858-9a63-a2d7a82145e5','c4d0d250-65cf-4638-87f3-0005a4ee4e19',1,1,'PENDING',NULL,NULL,NULL,NULL,'2026-09-16 22:52:54.667',NULL,NULL,NULL,'2026-09-16 22:52:54.668','2026-09-16 22:52:54.668'),
('6d782cb1-ebf6-47f4-b1eb-4202e37b0d42','826665dc-0435-49b6-85fd-1c7fd866dcbc','e67c928a-648a-4fd2-8317-d7d12d4fd4fc','9f1c99a7-9e8e-11f1-a1a3-84144d0a7d3c',1,2,'UNKNOWN',NULL,'ONFON_MISSING_MESSAGE_ID','Onfon accepted the submission but did not return a MessageId.',NULL,'2026-09-16 23:52:29.298',NULL,NULL,NULL,'2026-09-16 23:52:29.298','2026-09-16 23:52:30.002'),
('8de20dc0-3b93-48c9-b341-64b916d6e7d5','431c91a9-8563-46d1-8bf5-e2a51cfd4a96','48b9c46e-4e0a-4858-9a63-a2d7a82145e5','c4d0d250-65cf-4638-87f3-0005a4ee4e19',1,1,'UNKNOWN',NULL,'AT_MISSING_RECIPIENT','Africa\'s Talking returned a successful response without a recipient result.',NULL,'2026-09-16 23:24:53.581',NULL,NULL,NULL,'2026-09-16 23:24:53.582','2026-09-16 23:24:55.285'),
('a8a2a0f8-c397-4c40-b5e2-3c5ed8afad61','b6d267c0-4614-4a3c-8fb3-d0548457f03d','48b9c46e-4e0a-4858-9a63-a2d7a82145e5','c4d0d250-65cf-4638-87f3-0005a4ee4e19',2,3,'FAILED',NULL,'AT_REQUEST_REJECTED','InvalidSenderId',NULL,'2026-09-18 23:32:19.422',NULL,'2026-09-18 23:32:21.042',NULL,'2026-09-18 23:32:19.423','2026-09-18 23:32:21.043'),
('b238ab08-73bd-4244-9fcd-1fd3c881e1a0','30c83bdc-8e7b-4406-91eb-efd1710eaff3','e67c928a-648a-4fd2-8317-d7d12d4fd4fc','9f1c99a7-9e8e-11f1-a1a3-84144d0a7d3c',1,2,'FAILED',NULL,'ONFON_401','Value filter failed for user [adcconnect] (source_address filter mismatch).',NULL,'2026-09-17 00:09:11.312',NULL,'2026-09-17 00:09:12.155',NULL,'2026-09-17 00:09:11.313','2026-09-17 00:09:12.156'),
('b36fc5aa-6538-488d-b037-16a928d80c9b','b6d267c0-4614-4a3c-8fb3-d0548457f03d','e67c928a-648a-4fd2-8317-d7d12d4fd4fc','9f1c99a7-9e8e-11f1-a1a3-84144d0a7d3c',1,2,'FAILED',NULL,'ONFON_401','Value filter failed for user [adcconnect] (source_address filter mismatch).',NULL,'2026-09-18 23:32:18.587',NULL,'2026-09-18 23:32:19.398',NULL,'2026-09-18 23:32:18.588','2026-09-18 23:32:19.399'),
('c67558d3-75ba-4f4f-b2c7-a0e15200630d','b33d3d4d-26e6-452e-b233-1f8c7e2235e0','e67c928a-648a-4fd2-8317-d7d12d4fd4fc','9f1c99a7-9e8e-11f1-a1a3-84144d0a7d3c',1,2,'UNKNOWN',NULL,'ONFON_MISSING_MESSAGE_ID','Onfon accepted the SMS submission but did not return a MessageId.',NULL,'2026-09-17 00:05:26.098',NULL,NULL,NULL,'2026-09-17 00:05:26.099','2026-09-17 00:05:26.893'),
('c86748a5-3ee3-41c4-9fa6-479a897fc6de','c5427598-4554-47c4-95e9-22005ec7eeb7','e67c928a-648a-4fd2-8317-d7d12d4fd4fc','9f1c99a7-9e8e-11f1-a1a3-84144d0a7d3c',1,2,'PENDING',NULL,NULL,NULL,NULL,'2026-09-16 23:48:34.052',NULL,NULL,NULL,'2026-09-16 23:48:34.052','2026-09-16 23:48:34.052'),
('d1de8814-d7e8-4486-8591-84101592f0be','30c83bdc-8e7b-4406-91eb-efd1710eaff3','48b9c46e-4e0a-4858-9a63-a2d7a82145e5','c4d0d250-65cf-4638-87f3-0005a4ee4e19',2,3,'FAILED',NULL,'AT_REQUEST_REJECTED','InvalidSenderId',NULL,'2026-09-17 00:09:12.169',NULL,'2026-09-17 00:09:13.761',NULL,'2026-09-17 00:09:12.170','2026-09-17 00:09:13.762'),
('d6935d27-cb65-484f-afaf-ba92311b7bc7','fb999045-6016-4620-a663-c20e22b46fe1','48b9c46e-4e0a-4858-9a63-a2d7a82145e5','c4d0d250-65cf-4638-87f3-0005a4ee4e19',2,3,'FAILED',NULL,'AT_REQUEST_REJECTED','InvalidSenderId',NULL,'2026-09-16 23:42:49.726',NULL,'2026-09-16 23:42:51.282',NULL,'2026-09-16 23:42:49.727','2026-09-16 23:42:51.283');
/*!40000 ALTER TABLE `message_route_attempts` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `message_status_events`
--

DROP TABLE IF EXISTS `message_status_events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `message_status_events` (
  `id` char(36) NOT NULL,
  `messageId` char(36) NOT NULL,
  `attemptId` char(36) DEFAULT NULL,
  `status` enum('QUEUED','ROUTED','SUBMITTED','DELIVERED','FAILED','EXPIRED') NOT NULL,
  `source` varchar(50) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `rawData` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`rawData`)),
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  PRIMARY KEY (`id`),
  KEY `message_status_events_messageId_idx` (`messageId`),
  KEY `message_status_events_attemptId_idx` (`attemptId`),
  KEY `message_status_events_status_idx` (`status`),
  KEY `message_status_events_createdAt_idx` (`createdAt`),
  CONSTRAINT `message_status_events_attemptId_fkey` FOREIGN KEY (`attemptId`) REFERENCES `message_route_attempts` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `message_status_events_messageId_fkey` FOREIGN KEY (`messageId`) REFERENCES `messages` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `message_status_events`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `message_status_events` WRITE;
/*!40000 ALTER TABLE `message_status_events` DISABLE KEYS */;
INSERT INTO `message_status_events` VALUES
('016bc1ba-2dc8-4d35-8ad8-b3d05db24f31','b33d3d4d-26e6-452e-b233-1f8c7e2235e0',NULL,'QUEUED','CONTROL_PLANE','Message accepted and queued.',NULL,'2026-09-17 00:05:25.350'),
('04241153-8641-4252-9ede-75c19632d0d3','d1a9a3a8-c952-4bfa-b7e9-bdd779589eb6','1f7662cb-f58a-4851-9b8f-648196902d0d','FAILED','routing','Value filter failed for user [adcconnect] (source_address filter mismatch).','{\"errorCode\":\"ONFON_401\"}','2026-09-18 23:37:25.675'),
('0d29fa2f-d8bf-499e-a5ad-677c4764c361','3feb8cb5-9f4b-4d8b-ab51-f2e64be23fc7','46a7d7ac-830c-4f43-9bc6-07163b37fc86','ROUTED','routing','Message routed to connector.',NULL,'2026-09-16 23:46:02.920'),
('1716bc9d-dfcc-48a6-9010-d6d9e7c00d2b','826665dc-0435-49b6-85fd-1c7fd866dcbc','6d782cb1-ebf6-47f4-b1eb-4202e37b0d42','ROUTED','routing','Message routed to connector.',NULL,'2026-09-16 23:52:29.298'),
('17c836b2-396d-4a36-a65a-6e3e74215a22','bf259f8c-b417-4d94-829f-71eeab24c4ea','5ded4632-4292-4161-975e-29f72e18b140','FAILED','routing','The request content was malformed:\nObject is missing required member \'phoneNumbers\'','{\"errorCode\":\"HTTP_400\"}','2026-09-16 23:19:16.027'),
('1ca2debb-03f3-4ea5-9bbf-da60045a25fd','d1a9a3a8-c952-4bfa-b7e9-bdd779589eb6',NULL,'QUEUED','CONTROL_PLANE','Message accepted and queued.',NULL,'2026-09-18 23:37:24.728'),
('1f7992c8-3151-44c0-b449-3cf29bff3453','76b08e5f-64c9-419b-8b45-3efed4ce6bc5','65f56afa-dd5e-464a-94f5-75226dbaf58b','ROUTED','routing','Message routed to connector.',NULL,'2026-09-17 00:00:20.794'),
('1fd9489d-6d25-4c02-ba25-8818a2a7aef0','431c91a9-8563-46d1-8bf5-e2a51cfd4a96',NULL,'QUEUED','CONTROL_PLANE','Message accepted and queued.',NULL,'2026-09-16 23:24:52.561'),
('29d5f7b8-1cf4-48fd-9f37-45d5f134f506','f158e43b-0e2f-4fb7-a127-9502d2dfd2ea',NULL,'QUEUED','CONTROL_PLANE','Message accepted and queued.',NULL,'2026-09-16 23:02:22.684'),
('2b421c77-a53f-4008-8529-1a2010110c4a','df794a62-8457-475c-b052-0b6d653d323b','1b784d43-5e4a-4a40-b033-ff3926ba6755','ROUTED','routing','Message routed to connector.',NULL,'2026-09-16 23:39:36.493'),
('2d4735b8-7cf7-4945-8bad-efd80502f7f5','b6d267c0-4614-4a3c-8fb3-d0548457f03d','b36fc5aa-6538-488d-b037-16a928d80c9b','FAILED','routing','Value filter failed for user [adcconnect] (source_address filter mismatch).','{\"errorCode\":\"ONFON_401\"}','2026-09-18 23:32:19.398'),
('327abd7e-6652-4f09-8d8d-0a05fcd546bf','c5427598-4554-47c4-95e9-22005ec7eeb7','c86748a5-3ee3-41c4-9fa6-479a897fc6de','ROUTED','routing','Message routed to connector.',NULL,'2026-09-16 23:48:34.052'),
('35021a28-2cf2-4027-94f5-627b7b42a406','f158e43b-0e2f-4fb7-a127-9502d2dfd2ea','3381de53-c9e0-4f57-86b5-3d5ef0853e42','ROUTED','routing','Message routed to connector.',NULL,'2026-09-16 23:02:23.211'),
('358a2eb0-4c82-4304-b2ae-28ff01210aae','df794a62-8457-475c-b052-0b6d653d323b',NULL,'QUEUED','CONTROL_PLANE','Message accepted and queued.',NULL,'2026-09-16 23:39:35.633'),
('4283494b-f9c2-446f-8596-dea31b4b6f18','30c83bdc-8e7b-4406-91eb-efd1710eaff3','b238ab08-73bd-4244-9fcd-1fd3c881e1a0','FAILED','routing','Value filter failed for user [adcconnect] (source_address filter mismatch).','{\"errorCode\":\"ONFON_401\"}','2026-09-17 00:09:12.155'),
('44c9fc9b-7c41-416e-b83c-e0ccbfbf55ac','d1a9a3a8-c952-4bfa-b7e9-bdd779589eb6','58af0d8b-e144-4592-9cf6-f18197989825','ROUTED','routing','Message routed to connector.',NULL,'2026-09-18 23:37:25.703'),
('459f6e5f-0bd8-4d78-98bc-5c32c84fa6fa','d1a9a3a8-c952-4bfa-b7e9-bdd779589eb6','1f7662cb-f58a-4851-9b8f-648196902d0d','ROUTED','routing','Message routed to connector.',NULL,'2026-09-18 23:37:24.879'),
('46066fe6-3945-4f6d-ac95-30dd1158d8a1','bf259f8c-b417-4d94-829f-71eeab24c4ea',NULL,'QUEUED','CONTROL_PLANE','Message accepted and queued.',NULL,'2026-09-16 23:19:13.282'),
('4833b3f1-655c-4680-b795-0721d63e883c','df794a62-8457-475c-b052-0b6d653d323b',NULL,'FAILED','routing','Message routing failed.',NULL,'2026-09-16 23:39:38.033'),
('48b3fec3-f2fb-4cb8-a9ba-4944ca684af2','c5427598-4554-47c4-95e9-22005ec7eeb7',NULL,'QUEUED','CONTROL_PLANE','Message accepted and queued.',NULL,'2026-09-16 23:48:33.117'),
('4b6ef724-d34c-4542-bcea-9b20614d9314','76b08e5f-64c9-419b-8b45-3efed4ce6bc5',NULL,'QUEUED','CONTROL_PLANE','Message accepted and queued.',NULL,'2026-09-17 00:00:20.545'),
('4be1ac3a-a7c6-4a57-ad05-935e2bd995e3','b33d3d4d-26e6-452e-b233-1f8c7e2235e0','c67558d3-75ba-4f4f-b2c7-a0e15200630d','ROUTED','routing','Message routed to connector.',NULL,'2026-09-17 00:05:26.098'),
('4f7255fb-68aa-4fcd-a7a4-65f68627a744','b6d267c0-4614-4a3c-8fb3-d0548457f03d','a8a2a0f8-c397-4c40-b5e2-3c5ed8afad61','ROUTED','routing','Message routed to connector.',NULL,'2026-09-18 23:32:19.422'),
('4f964e33-443b-4a67-83c9-3be53aa28d6b','d1a9a3a8-c952-4bfa-b7e9-bdd779589eb6',NULL,'FAILED','routing','Message routing failed.',NULL,'2026-09-18 23:37:27.337'),
('526a4317-5ab2-4f3a-8dbd-231890a99e0f','fb999045-6016-4620-a663-c20e22b46fe1','2b656966-f8ec-419d-b3fe-680e0e77f1cb','ROUTED','routing','Message routed to connector.',NULL,'2026-09-16 23:42:49.692'),
('6116ec6a-9304-4852-8023-d89f0520be7c','62177de6-e209-4c63-a79a-af830109f73b',NULL,'QUEUED','CONTROL_PLANE','Message accepted and queued.',NULL,'2026-09-16 23:11:00.622'),
('6f813966-2b2a-4714-a3cd-3e044f2ec85d','30c83bdc-8e7b-4406-91eb-efd1710eaff3','d1de8814-d7e8-4486-8591-84101592f0be','ROUTED','routing','Message routed to connector.',NULL,'2026-09-17 00:09:12.169'),
('72bf8f9e-b2a0-4fcc-8e04-7b962537115b','3feb8cb5-9f4b-4d8b-ab51-f2e64be23fc7','46a7d7ac-830c-4f43-9bc6-07163b37fc86','FAILED','routing','InvalidSenderId','{\"errorCode\":\"AT_REQUEST_REJECTED\"}','2026-09-16 23:46:04.629'),
('73a53a82-2b0b-4ddb-988e-be306b636045','b6d267c0-4614-4a3c-8fb3-d0548457f03d','b36fc5aa-6538-488d-b037-16a928d80c9b','ROUTED','routing','Message routed to connector.',NULL,'2026-09-18 23:32:18.587'),
('795df22a-fd2f-4151-9eac-d8879b432175','bf259f8c-b417-4d94-829f-71eeab24c4ea',NULL,'FAILED','routing','Message routing failed.',NULL,'2026-09-16 23:19:16.040'),
('79a7432f-9086-4dac-8497-ab1e2e724fd7','3feb8cb5-9f4b-4d8b-ab51-f2e64be23fc7','2cd67269-fa16-4da4-9309-1cb3599b7d8c','ROUTED','routing','Message routed to connector.',NULL,'2026-09-16 23:46:02.895'),
('85e718b8-838b-4e2c-b7e9-e41b842b75a1','3feb8cb5-9f4b-4d8b-ab51-f2e64be23fc7',NULL,'FAILED','routing','Message routing failed.',NULL,'2026-09-16 23:46:04.643'),
('86ee3d16-64fd-4e0e-9695-3859d967f508','fb999045-6016-4620-a663-c20e22b46fe1','2b656966-f8ec-419d-b3fe-680e0e77f1cb','FAILED','routing','HTTP provider \'Onfon\' is not registered.','{\"errorCode\":\"HTTP_PROVIDER_NOT_REGISTERED\"}','2026-09-16 23:42:49.717'),
('878ec3ba-9721-40af-966c-78f1c6b62c85','418bb9a6-f96e-4548-ad93-56c2e4d6f9b4',NULL,'QUEUED','CONTROL_PLANE','Message accepted and queued.',NULL,'2026-09-16 22:52:53.685'),
('884faa68-84c6-4403-aef1-946cf1e197c7','3feb8cb5-9f4b-4d8b-ab51-f2e64be23fc7','2cd67269-fa16-4da4-9309-1cb3599b7d8c','FAILED','routing','HTTP provider \'onfone\' is not registered.','{\"errorCode\":\"HTTP_PROVIDER_NOT_REGISTERED\"}','2026-09-16 23:46:02.912'),
('8bb16085-498f-4185-ab7c-a7213e50dcc5','21647dd6-e21f-40a1-93fb-5fc0aafd3246','3095a136-f04e-4224-85e3-d93ee2cbce0e','ROUTED','routing','Message routed to connector.',NULL,'2026-09-16 22:48:53.442'),
('91fa5e94-fecf-4162-99e5-73e6411b0560','30c83bdc-8e7b-4406-91eb-efd1710eaff3','d1de8814-d7e8-4486-8591-84101592f0be','FAILED','routing','InvalidSenderId','{\"errorCode\":\"AT_REQUEST_REJECTED\"}','2026-09-17 00:09:13.761'),
('92249a11-81fc-4f64-aad3-43def2984fd5','fb999045-6016-4620-a663-c20e22b46fe1',NULL,'QUEUED','CONTROL_PLANE','Message accepted and queued.',NULL,'2026-09-16 23:42:49.631'),
('9272e892-ffea-40d0-8e65-c3ce289f6fb6','826665dc-0435-49b6-85fd-1c7fd866dcbc',NULL,'QUEUED','CONTROL_PLANE','Message accepted and queued.',NULL,'2026-09-16 23:52:29.279'),
('94e47c31-369f-4271-9d41-4eabc62cc1cd','d1a9a3a8-c952-4bfa-b7e9-bdd779589eb6','58af0d8b-e144-4592-9cf6-f18197989825','FAILED','routing','InvalidSenderId','{\"errorCode\":\"AT_REQUEST_REJECTED\"}','2026-09-18 23:37:27.312'),
('95732bdd-5866-4732-82e4-03dfd9ffe5a6','fb999045-6016-4620-a663-c20e22b46fe1','d6935d27-cb65-484f-afaf-ba92311b7bc7','FAILED','routing','InvalidSenderId','{\"errorCode\":\"AT_REQUEST_REJECTED\"}','2026-09-16 23:42:51.282'),
('96e0595b-2d60-4503-9b14-b7a09ec36a0c','df794a62-8457-475c-b052-0b6d653d323b','1b784d43-5e4a-4a40-b033-ff3926ba6755','FAILED','routing','InvalidSenderId','{\"errorCode\":\"AT_REQUEST_REJECTED\"}','2026-09-16 23:39:38.025'),
('9aa1f53b-7607-448d-af7e-31e19d40a75c','2866c881-b3e2-4865-85c6-3e52d6d10aef',NULL,'QUEUED','CONTROL_PLANE','Message accepted and queued.',NULL,'2026-09-16 23:29:25.894'),
('ad99f344-2fb9-40b8-b783-ee1ebb89984a','418bb9a6-f96e-4548-ad93-56c2e4d6f9b4','6c5f8a13-f16e-47e2-adca-8182f01827d1','ROUTED','routing','Message routed to connector.',NULL,'2026-09-16 22:52:54.667'),
('b139f04f-7d2b-4d22-a074-81efeb1995a9','3feb8cb5-9f4b-4d8b-ab51-f2e64be23fc7',NULL,'QUEUED','CONTROL_PLANE','Message accepted and queued.',NULL,'2026-09-16 23:46:02.776'),
('b5bb363e-5c9c-4797-aa2b-0adb2f2fe141','4e514341-eb2d-45de-bd8c-5e555f0400a3',NULL,'QUEUED','CONTROL_PLANE','Message accepted and queued.',NULL,'2026-09-16 23:05:25.393'),
('bca68d2b-d3b6-470c-8473-32ee5c40af13','b6d267c0-4614-4a3c-8fb3-d0548457f03d',NULL,'QUEUED','CONTROL_PLANE','Message accepted and queued.',NULL,'2026-09-18 23:32:18.074'),
('be5d2b6a-792b-4462-a06f-a0a4012872f9','b6d267c0-4614-4a3c-8fb3-d0548457f03d',NULL,'FAILED','routing','Message routing failed.',NULL,'2026-09-18 23:32:21.079'),
('c0cef57d-a0c2-408d-a9dc-70d26be28971','21647dd6-e21f-40a1-93fb-5fc0aafd3246',NULL,'QUEUED','CONTROL_PLANE','Message accepted and queued.',NULL,'2026-09-16 22:47:40.668'),
('d5a76f7a-e23e-4d8b-805e-c411ae89e1c3','2866c881-b3e2-4865-85c6-3e52d6d10aef','121737ac-425e-4486-b7ad-d4eb8a8d7d64','ROUTED','routing','Message routed to connector.',NULL,'2026-09-16 23:29:26.868'),
('defb0439-eaad-44aa-b5af-14cf2d45c84d','30c83bdc-8e7b-4406-91eb-efd1710eaff3','b238ab08-73bd-4244-9fcd-1fd3c881e1a0','ROUTED','routing','Message routed to connector.',NULL,'2026-09-17 00:09:11.312'),
('e0e39849-6cdd-4135-bf64-ff7aa5f715a7','30c83bdc-8e7b-4406-91eb-efd1710eaff3',NULL,'FAILED','routing','Message routing failed.',NULL,'2026-09-17 00:09:13.768'),
('e7c8b27a-e984-4384-a01e-aa5e6a7abeb7','fb999045-6016-4620-a663-c20e22b46fe1','d6935d27-cb65-484f-afaf-ba92311b7bc7','ROUTED','routing','Message routed to connector.',NULL,'2026-09-16 23:42:49.726'),
('ebc0ea97-17d8-4211-9d4d-1ba4dde55d0b','4e514341-eb2d-45de-bd8c-5e555f0400a3','389665d1-8cc6-4df0-9fec-0dff022a0b51','ROUTED','routing','Message routed to connector.',NULL,'2026-09-16 23:05:26.380'),
('ee44d4a3-5471-44e1-966b-f03d85070477','bf259f8c-b417-4d94-829f-71eeab24c4ea','5ded4632-4292-4161-975e-29f72e18b140','ROUTED','routing','Message routed to connector.',NULL,'2026-09-16 23:19:14.237'),
('ee763213-496e-4746-852c-adaedaa27cf1','b6d267c0-4614-4a3c-8fb3-d0548457f03d','a8a2a0f8-c397-4c40-b5e2-3c5ed8afad61','FAILED','routing','InvalidSenderId','{\"errorCode\":\"AT_REQUEST_REJECTED\"}','2026-09-18 23:32:21.042'),
('f153eeed-c68f-49e0-bdd5-e5a04723062d','431c91a9-8563-46d1-8bf5-e2a51cfd4a96','8de20dc0-3b93-48c9-b341-64b916d6e7d5','ROUTED','routing','Message routed to connector.',NULL,'2026-09-16 23:24:53.581'),
('f2814c0b-1352-4e3f-8064-5757361390ac','fb999045-6016-4620-a663-c20e22b46fe1',NULL,'FAILED','routing','Message routing failed.',NULL,'2026-09-16 23:42:51.293'),
('fd51ad54-a958-419f-9b08-7fb1714ff8e5','62177de6-e209-4c63-a79a-af830109f73b','362605e0-5fbc-44e3-9452-bd9c46a960c5','ROUTED','routing','Message routed to connector.',NULL,'2026-09-16 23:11:00.719'),
('fe5fbbdd-4d9c-4c6f-a6ee-bb54d49022d6','30c83bdc-8e7b-4406-91eb-efd1710eaff3',NULL,'QUEUED','CONTROL_PLANE','Message accepted and queued.',NULL,'2026-09-17 00:09:11.101');
/*!40000 ALTER TABLE `message_status_events` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `messages`
--

DROP TABLE IF EXISTS `messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `messages` (
  `id` char(36) NOT NULL,
  `publicId` varchar(20) NOT NULL,
  `clientId` char(36) NOT NULL,
  `senderIdId` char(36) DEFAULT NULL,
  `destination` varchar(20) NOT NULL,
  `body` text NOT NULL,
  `encoding` enum('GSM7','UCS2','BINARY') NOT NULL,
  `segmentCount` int(11) NOT NULL,
  `currentStatus` enum('QUEUED','ROUTED','SUBMITTED','DELIVERED','FAILED','EXPIRED') NOT NULL DEFAULT 'QUEUED',
  `submittedAt` datetime(3) DEFAULT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL,
  `currentAttemptNumber` int(11) NOT NULL DEFAULT 0,
  `routingStatus` enum('PENDING','ROUTING','SUBMITTED','FAILED','UNKNOWN') NOT NULL DEFAULT 'PENDING',
  PRIMARY KEY (`id`),
  UNIQUE KEY `messages_publicId_key` (`publicId`),
  KEY `messages_clientId_idx` (`clientId`),
  KEY `messages_destination_idx` (`destination`),
  KEY `messages_currentStatus_idx` (`currentStatus`),
  KEY `messages_submittedAt_idx` (`submittedAt`),
  KEY `messages_senderIdId_fkey` (`senderIdId`),
  KEY `messages_routingStatus_idx` (`routingStatus`),
  CONSTRAINT `messages_clientId_fkey` FOREIGN KEY (`clientId`) REFERENCES `clients` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `messages_senderIdId_fkey` FOREIGN KEY (`senderIdId`) REFERENCES `sender_ids` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `messages`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `messages` WRITE;
/*!40000 ALTER TABLE `messages` DISABLE KEYS */;
INSERT INTO `messages` VALUES
('21647dd6-e21f-40a1-93fb-5fc0aafd3246','peUevyBadr6GNA','67c9b53f-b74e-43d0-859f-5349b5b9d0c7','39ad43d1-cd8f-4598-a9be-2ab92e874795','254115915889','test 001','GSM7',1,'ROUTED','2026-09-16 22:47:40.656','2026-09-16 22:47:40.657','2026-09-16 22:48:53.445',0,'PENDING'),
('2866c881-b3e2-4865-85c6-3e52d6d10aef','nC7oj6A38i-7BQ','67c9b53f-b74e-43d0-859f-5349b5b9d0c7','39ad43d1-cd8f-4598-a9be-2ab92e874795','254115915889','test','GSM7',1,'ROUTED','2026-09-16 23:29:25.884','2026-09-16 23:29:25.886','2026-09-16 23:29:26.872',0,'PENDING'),
('30c83bdc-8e7b-4406-91eb-efd1710eaff3','EXsji0vaREUTMg','67c9b53f-b74e-43d0-859f-5349b5b9d0c7','39ad43d1-cd8f-4598-a9be-2ab92e874795','254115915889','test','GSM7',1,'FAILED','2026-09-17 00:09:11.097','2026-09-17 00:09:11.098','2026-09-17 00:09:13.769',0,'PENDING'),
('3feb8cb5-9f4b-4d8b-ab51-f2e64be23fc7','Vu48foZp80Y8cg','67c9b53f-b74e-43d0-859f-5349b5b9d0c7','39ad43d1-cd8f-4598-a9be-2ab92e874795','254115915889','test onfone','GSM7',1,'FAILED','2026-09-16 23:46:02.770','2026-09-16 23:46:02.771','2026-09-16 23:46:04.644',0,'PENDING'),
('418bb9a6-f96e-4548-ad93-56c2e4d6f9b4','J2XNrp4UKut9nA','67c9b53f-b74e-43d0-859f-5349b5b9d0c7','39ad43d1-cd8f-4598-a9be-2ab92e874795','254115915889','test','GSM7',1,'ROUTED','2026-09-16 22:52:53.676','2026-09-16 22:52:53.677','2026-09-16 22:52:54.670',0,'PENDING'),
('431c91a9-8563-46d1-8bf5-e2a51cfd4a96','KjTWn5ShsZTn0g','67c9b53f-b74e-43d0-859f-5349b5b9d0c7','39ad43d1-cd8f-4598-a9be-2ab92e874795','254115915889','test','GSM7',1,'ROUTED','2026-09-16 23:24:52.552','2026-09-16 23:24:52.553','2026-09-16 23:24:53.587',0,'PENDING'),
('4e514341-eb2d-45de-bd8c-5e555f0400a3','cAytFiAq8Bj3wQ','67c9b53f-b74e-43d0-859f-5349b5b9d0c7','39ad43d1-cd8f-4598-a9be-2ab92e874795','254115915889','testd','GSM7',1,'ROUTED','2026-09-16 23:05:25.380','2026-09-16 23:05:25.381','2026-09-16 23:05:26.383',0,'PENDING'),
('62177de6-e209-4c63-a79a-af830109f73b','Nciv-yUZmCyO2g','67c9b53f-b74e-43d0-859f-5349b5b9d0c7','39ad43d1-cd8f-4598-a9be-2ab92e874795','254115915889','test','GSM7',1,'ROUTED','2026-09-16 23:11:00.612','2026-09-16 23:11:00.613','2026-09-16 23:11:00.723',0,'PENDING'),
('76b08e5f-64c9-419b-8b45-3efed4ce6bc5','GyxRN_j1vDhpxg','67c9b53f-b74e-43d0-859f-5349b5b9d0c7','39ad43d1-cd8f-4598-a9be-2ab92e874795','254115915889','test','GSM7',1,'ROUTED','2026-09-17 00:00:20.537','2026-09-17 00:00:20.537','2026-09-17 00:00:20.797',0,'PENDING'),
('826665dc-0435-49b6-85fd-1c7fd866dcbc','6v8N9z3rM9Mr9Q','67c9b53f-b74e-43d0-859f-5349b5b9d0c7','39ad43d1-cd8f-4598-a9be-2ab92e874795','254115915889','test','GSM7',1,'ROUTED','2026-09-16 23:52:29.272','2026-09-16 23:52:29.273','2026-09-16 23:52:29.300',0,'PENDING'),
('b33d3d4d-26e6-452e-b233-1f8c7e2235e0','a3gBE7B5rIqb_A','67c9b53f-b74e-43d0-859f-5349b5b9d0c7','39ad43d1-cd8f-4598-a9be-2ab92e874795','254115915889','test','GSM7',1,'ROUTED','2026-09-17 00:05:25.345','2026-09-17 00:05:25.345','2026-09-17 00:05:26.102',0,'PENDING'),
('b6d267c0-4614-4a3c-8fb3-d0548457f03d','dk05JLeeLBI6fw','67c9b53f-b74e-43d0-859f-5349b5b9d0c7','39ad43d1-cd8f-4598-a9be-2ab92e874795','254115915889','test','GSM7',1,'FAILED','2026-09-18 23:32:18.063','2026-09-18 23:32:18.065','2026-09-18 23:32:21.080',0,'PENDING'),
('bf259f8c-b417-4d94-829f-71eeab24c4ea','XA_CjuxS4Yflbg','67c9b53f-b74e-43d0-859f-5349b5b9d0c7','39ad43d1-cd8f-4598-a9be-2ab92e874795','254115915889','test','GSM7',1,'FAILED','2026-09-16 23:19:13.270','2026-09-16 23:19:13.271','2026-09-16 23:19:16.041',0,'PENDING'),
('c5427598-4554-47c4-95e9-22005ec7eeb7','Vr_z6JH0kOx4FA','67c9b53f-b74e-43d0-859f-5349b5b9d0c7','39ad43d1-cd8f-4598-a9be-2ab92e874795','254115915889','test onfone','GSM7',1,'ROUTED','2026-09-16 23:48:33.111','2026-09-16 23:48:33.112','2026-09-16 23:48:34.053',0,'PENDING'),
('d1a9a3a8-c952-4bfa-b7e9-bdd779589eb6','OEkVnXP0PBea3g','67c9b53f-b74e-43d0-859f-5349b5b9d0c7','39ad43d1-cd8f-4598-a9be-2ab92e874795','254115915889','test','GSM7',1,'FAILED','2026-09-18 23:37:24.719','2026-09-18 23:37:24.720','2026-09-18 23:37:27.338',0,'PENDING'),
('df794a62-8457-475c-b052-0b6d653d323b','aLTSEgzypjO_yQ','67c9b53f-b74e-43d0-859f-5349b5b9d0c7','39ad43d1-cd8f-4598-a9be-2ab92e874795','254115915889','test','GSM7',1,'FAILED','2026-09-16 23:39:35.620','2026-09-16 23:39:35.621','2026-09-16 23:39:38.034',0,'PENDING'),
('f158e43b-0e2f-4fb7-a127-9502d2dfd2ea','y9qs-xU7ipeX5Q','67c9b53f-b74e-43d0-859f-5349b5b9d0c7','39ad43d1-cd8f-4598-a9be-2ab92e874795','254115915889','test','GSM7',1,'ROUTED','2026-09-16 23:02:22.673','2026-09-16 23:02:22.675','2026-09-16 23:02:23.214',0,'PENDING'),
('fb999045-6016-4620-a663-c20e22b46fe1','brms0_Az3XeNlA','67c9b53f-b74e-43d0-859f-5349b5b9d0c7','39ad43d1-cd8f-4598-a9be-2ab92e874795','254115915889','test onfone','GSM7',1,'FAILED','2026-09-16 23:42:49.623','2026-09-16 23:42:49.624','2026-09-16 23:42:51.294',0,'PENDING');
/*!40000 ALTER TABLE `messages` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `mobile_networks`
--

DROP TABLE IF EXISTS `mobile_networks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `mobile_networks` (
  `id` char(36) NOT NULL,
  `publicId` varchar(20) NOT NULL,
  `name` varchar(100) NOT NULL,
  `code` varchar(50) NOT NULL,
  `status` enum('ACTIVE','DISABLED') NOT NULL DEFAULT 'ACTIVE',
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL,
  `routingRegex` varchar(500) DEFAULT NULL,
  `countryId` char(36) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `mobile_networks_publicId_key` (`publicId`),
  UNIQUE KEY `mobile_networks_code_key` (`code`),
  KEY `mobile_networks_status_idx` (`status`),
  KEY `mobile_networks_countryId_idx` (`countryId`),
  CONSTRAINT `mobile_networks_countryId_fkey` FOREIGN KEY (`countryId`) REFERENCES `countries` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mobile_networks`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `mobile_networks` WRITE;
/*!40000 ALTER TABLE `mobile_networks` DISABLE KEYS */;
INSERT INTO `mobile_networks` VALUES
('0e1cc666-1910-4c31-8051-edc1e986f20d','TESTING','TEST','TESTING','ACTIVE','2026-09-18 23:00:18.417','2026-09-18 23:00:18.417','26599','e56a42b4-b32e-11f1-a478-84144d0a7d3c'),
('9f1af7b6-9e8e-11f1-a1a3-84144d0a7d3c','MNO-AIRTEL-MW','Airtel Malawi','AIRTEL_MW','ACTIVE','2026-08-23 03:04:41.000','2026-09-02 01:06:19.476',NULL,'e56a42b4-b32e-11f1-a478-84144d0a7d3c'),
('9f1afd32-9e8e-11f1-a1a3-84144d0a7d3c','MNO-TNM-MW','TNM Malawi','TNM_MW','ACTIVE','2026-08-23 03:04:41.000','2026-09-18 23:25:22.162','^265(?:88|84)','e56a42b4-b32e-11f1-a478-84144d0a7d3c'),
('d796e89f-d5b5-42bd-be1a-d2606a537740','saf','Safaricom','safaricom','ACTIVE','2026-09-16 22:40:52.137','2026-09-18 23:27:01.655','^25411','e56a3db4-b32e-11f1-a478-84144d0a7d3c');
/*!40000 ALTER TABLE `mobile_networks` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `outbox_events`
--

DROP TABLE IF EXISTS `outbox_events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `outbox_events` (
  `id` char(36) NOT NULL,
  `eventType` varchar(100) NOT NULL,
  `aggregateType` varchar(100) NOT NULL,
  `aggregateId` char(36) NOT NULL,
  `queueName` varchar(100) NOT NULL,
  `payload` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`payload`)),
  `status` enum('PENDING','PROCESSING','PUBLISHED','FAILED') NOT NULL DEFAULT 'PENDING',
  `attempts` int(11) NOT NULL DEFAULT 0,
  `availableAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `publishedAt` datetime(3) DEFAULT NULL,
  `lastError` varchar(1000) DEFAULT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL,
  `processingAt` datetime(3) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `outbox_events_status_availableAt_idx` (`status`,`availableAt`),
  KEY `outbox_events_aggregateType_aggregateId_idx` (`aggregateType`,`aggregateId`),
  KEY `outbox_events_eventType_idx` (`eventType`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `outbox_events`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `outbox_events` WRITE;
/*!40000 ALTER TABLE `outbox_events` DISABLE KEYS */;
INSERT INTO `outbox_events` VALUES
('1016917a-80c5-4aee-bcfa-cbca503f0c70','MESSAGE_STATUS','MESSAGE','21647dd6-e21f-40a1-93fb-5fc0aafd3246','sms.queued','{\"eventId\":\"SX-jf7wvfVIWmw\",\"occurredAt\":\"2026-09-16T22:47:40.669Z\",\"version\":1,\"messageId\":\"21647dd6-e21f-40a1-93fb-5fc0aafd3246\",\"publicId\":\"peUevyBadr6GNA\",\"clientId\":\"67c9b53f-b74e-43d0-859f-5349b5b9d0c7\",\"destination\":\"254115915889\",\"body\":\"test 001\",\"encoding\":\"GSM7\",\"segmentCount\":1,\"status\":\"QUEUED\"}','PUBLISHED',1,'2026-09-16 22:47:40.669',NULL,NULL,'2026-09-16 22:47:40.670','2026-09-16 22:48:53.423','2026-09-16 22:48:53.422'),
('1b40cd57-6392-4802-b7bc-6879c7749fe3','MESSAGE_STATUS','MESSAGE','bf259f8c-b417-4d94-829f-71eeab24c4ea','sms.queued','{\"eventId\":\"P9mmXItI4and4g\",\"occurredAt\":\"2026-09-16T23:19:13.282Z\",\"version\":1,\"messageId\":\"bf259f8c-b417-4d94-829f-71eeab24c4ea\",\"publicId\":\"XA_CjuxS4Yflbg\",\"clientId\":\"67c9b53f-b74e-43d0-859f-5349b5b9d0c7\",\"destination\":\"254115915889\",\"body\":\"test\",\"encoding\":\"GSM7\",\"segmentCount\":1,\"status\":\"QUEUED\"}','PUBLISHED',1,'2026-09-16 23:19:13.282',NULL,NULL,'2026-09-16 23:19:13.283','2026-09-16 23:19:14.223','2026-09-16 23:19:14.222'),
('33c94a63-1e10-4f28-87cc-c27efd10cb89','MESSAGE_STATUS','MESSAGE','826665dc-0435-49b6-85fd-1c7fd866dcbc','sms.queued','{\"eventId\":\"d4ym1Xwn1DJujg\",\"occurredAt\":\"2026-09-16T23:52:29.279Z\",\"version\":1,\"messageId\":\"826665dc-0435-49b6-85fd-1c7fd866dcbc\",\"publicId\":\"6v8N9z3rM9Mr9Q\",\"clientId\":\"67c9b53f-b74e-43d0-859f-5349b5b9d0c7\",\"destination\":\"254115915889\",\"body\":\"test\",\"encoding\":\"GSM7\",\"segmentCount\":1,\"status\":\"QUEUED\"}','PUBLISHED',1,'2026-09-16 23:52:29.279',NULL,NULL,'2026-09-16 23:52:29.280','2026-09-16 23:52:29.290','2026-09-16 23:52:29.289'),
('3af5b938-468a-45b3-b629-5583d4871c58','MESSAGE_STATUS','MESSAGE','2866c881-b3e2-4865-85c6-3e52d6d10aef','sms.queued','{\"eventId\":\"EEuPoLOFcAZ86A\",\"occurredAt\":\"2026-09-16T23:29:25.894Z\",\"version\":1,\"messageId\":\"2866c881-b3e2-4865-85c6-3e52d6d10aef\",\"publicId\":\"nC7oj6A38i-7BQ\",\"clientId\":\"67c9b53f-b74e-43d0-859f-5349b5b9d0c7\",\"destination\":\"254115915889\",\"body\":\"test\",\"encoding\":\"GSM7\",\"segmentCount\":1,\"status\":\"QUEUED\"}','PUBLISHED',1,'2026-09-16 23:29:25.894',NULL,NULL,'2026-09-16 23:29:25.895','2026-09-16 23:29:26.856','2026-09-16 23:29:26.855'),
('476535c6-29e7-44df-a910-68283c8172e8','MESSAGE_STATUS','MESSAGE','62177de6-e209-4c63-a79a-af830109f73b','sms.queued','{\"eventId\":\"nBLtYop-Ipm7Mg\",\"occurredAt\":\"2026-09-16T23:11:00.623Z\",\"version\":1,\"messageId\":\"62177de6-e209-4c63-a79a-af830109f73b\",\"publicId\":\"Nciv-yUZmCyO2g\",\"clientId\":\"67c9b53f-b74e-43d0-859f-5349b5b9d0c7\",\"destination\":\"254115915889\",\"body\":\"test\",\"encoding\":\"GSM7\",\"segmentCount\":1,\"status\":\"QUEUED\"}','PUBLISHED',1,'2026-09-16 23:11:00.623',NULL,NULL,'2026-09-16 23:11:00.624','2026-09-16 23:11:00.712','2026-09-16 23:11:00.711'),
('4de2aa50-e5c3-49e4-b634-228485a5068d','MESSAGE_STATUS','MESSAGE','fb999045-6016-4620-a663-c20e22b46fe1','sms.queued','{\"eventId\":\"s4tIktMFhAwF3g\",\"occurredAt\":\"2026-09-16T23:42:49.632Z\",\"version\":1,\"messageId\":\"fb999045-6016-4620-a663-c20e22b46fe1\",\"publicId\":\"brms0_Az3XeNlA\",\"clientId\":\"67c9b53f-b74e-43d0-859f-5349b5b9d0c7\",\"destination\":\"254115915889\",\"body\":\"test onfone\",\"encoding\":\"GSM7\",\"segmentCount\":1,\"status\":\"QUEUED\"}','PUBLISHED',1,'2026-09-16 23:42:49.632',NULL,NULL,'2026-09-16 23:42:49.634','2026-09-16 23:42:49.687','2026-09-16 23:42:49.687'),
('5640280b-1af6-460e-8a00-6db227f0df56','MESSAGE_STATUS','MESSAGE','d1a9a3a8-c952-4bfa-b7e9-bdd779589eb6','sms.queued','{\"eventId\":\"wfFzHXYWGmnfrw\",\"occurredAt\":\"2026-09-18T23:37:24.729Z\",\"version\":1,\"messageId\":\"d1a9a3a8-c952-4bfa-b7e9-bdd779589eb6\",\"publicId\":\"OEkVnXP0PBea3g\",\"clientId\":\"67c9b53f-b74e-43d0-859f-5349b5b9d0c7\",\"destination\":\"254115915889\",\"body\":\"test\",\"encoding\":\"GSM7\",\"segmentCount\":1,\"status\":\"QUEUED\"}','PUBLISHED',1,'2026-09-18 23:37:24.729',NULL,NULL,'2026-09-18 23:37:24.730','2026-09-18 23:37:24.854','2026-09-18 23:37:24.853'),
('598665e3-a39b-48b2-883c-2114f9ef1438','MESSAGE_STATUS','MESSAGE','4e514341-eb2d-45de-bd8c-5e555f0400a3','sms.queued','{\"eventId\":\"U3v8PD6eKtb0lQ\",\"occurredAt\":\"2026-09-16T23:05:25.393Z\",\"version\":1,\"messageId\":\"4e514341-eb2d-45de-bd8c-5e555f0400a3\",\"publicId\":\"cAytFiAq8Bj3wQ\",\"clientId\":\"67c9b53f-b74e-43d0-859f-5349b5b9d0c7\",\"destination\":\"254115915889\",\"body\":\"testd\",\"encoding\":\"GSM7\",\"segmentCount\":1,\"status\":\"QUEUED\"}','PUBLISHED',1,'2026-09-16 23:05:25.393',NULL,NULL,'2026-09-16 23:05:25.394','2026-09-16 23:05:26.370','2026-09-16 23:05:26.369'),
('73a69940-7030-4c44-84b1-b0504f1751e0','MESSAGE_STATUS','MESSAGE','418bb9a6-f96e-4548-ad93-56c2e4d6f9b4','sms.queued','{\"eventId\":\"OKglnQ4sCnXSJg\",\"occurredAt\":\"2026-09-16T22:52:53.685Z\",\"version\":1,\"messageId\":\"418bb9a6-f96e-4548-ad93-56c2e4d6f9b4\",\"publicId\":\"J2XNrp4UKut9nA\",\"clientId\":\"67c9b53f-b74e-43d0-859f-5349b5b9d0c7\",\"destination\":\"254115915889\",\"body\":\"test\",\"encoding\":\"GSM7\",\"segmentCount\":1,\"status\":\"QUEUED\"}','PUBLISHED',1,'2026-09-16 22:52:53.685',NULL,NULL,'2026-09-16 22:52:53.686','2026-09-16 22:52:54.659','2026-09-16 22:52:54.658'),
('781b6384-e15b-4b55-86c8-646f858eaebe','MESSAGE_STATUS','MESSAGE','c5427598-4554-47c4-95e9-22005ec7eeb7','sms.queued','{\"eventId\":\"h7-G5ig-yDbdEA\",\"occurredAt\":\"2026-09-16T23:48:33.118Z\",\"version\":1,\"messageId\":\"c5427598-4554-47c4-95e9-22005ec7eeb7\",\"publicId\":\"Vr_z6JH0kOx4FA\",\"clientId\":\"67c9b53f-b74e-43d0-859f-5349b5b9d0c7\",\"destination\":\"254115915889\",\"body\":\"test onfone\",\"encoding\":\"GSM7\",\"segmentCount\":1,\"status\":\"QUEUED\"}','PUBLISHED',1,'2026-09-16 23:48:33.118',NULL,NULL,'2026-09-16 23:48:33.118','2026-09-16 23:48:34.047','2026-09-16 23:48:34.046'),
('84ee5687-5d94-4965-b864-c4ed71955a6c','MESSAGE_STATUS','MESSAGE','f158e43b-0e2f-4fb7-a127-9502d2dfd2ea','sms.queued','{\"eventId\":\"OeSeSRuz51W3cA\",\"occurredAt\":\"2026-09-16T23:02:22.686Z\",\"version\":1,\"messageId\":\"f158e43b-0e2f-4fb7-a127-9502d2dfd2ea\",\"publicId\":\"y9qs-xU7ipeX5Q\",\"clientId\":\"67c9b53f-b74e-43d0-859f-5349b5b9d0c7\",\"destination\":\"254115915889\",\"body\":\"test\",\"encoding\":\"GSM7\",\"segmentCount\":1,\"status\":\"QUEUED\"}','PUBLISHED',1,'2026-09-16 23:02:22.686',NULL,NULL,'2026-09-16 23:02:22.687','2026-09-16 23:02:23.194','2026-09-16 23:02:23.193'),
('87f2fd03-976d-472c-8635-8880c8441ae8','MESSAGE_STATUS','MESSAGE','3feb8cb5-9f4b-4d8b-ab51-f2e64be23fc7','sms.queued','{\"eventId\":\"aGwRNqPvZYyLvg\",\"occurredAt\":\"2026-09-16T23:46:02.777Z\",\"version\":1,\"messageId\":\"3feb8cb5-9f4b-4d8b-ab51-f2e64be23fc7\",\"publicId\":\"Vu48foZp80Y8cg\",\"clientId\":\"67c9b53f-b74e-43d0-859f-5349b5b9d0c7\",\"destination\":\"254115915889\",\"body\":\"test onfone\",\"encoding\":\"GSM7\",\"segmentCount\":1,\"status\":\"QUEUED\"}','PUBLISHED',1,'2026-09-16 23:46:02.777',NULL,NULL,'2026-09-16 23:46:02.778','2026-09-16 23:46:02.890','2026-09-16 23:46:02.889'),
('896e847c-483d-4b60-9c83-efe717c9060a','MESSAGE_STATUS','MESSAGE','30c83bdc-8e7b-4406-91eb-efd1710eaff3','sms.queued','{\"eventId\":\"cKw-QcLCsO84Xg\",\"occurredAt\":\"2026-09-17T00:09:11.101Z\",\"version\":1,\"messageId\":\"30c83bdc-8e7b-4406-91eb-efd1710eaff3\",\"publicId\":\"EXsji0vaREUTMg\",\"clientId\":\"67c9b53f-b74e-43d0-859f-5349b5b9d0c7\",\"destination\":\"254115915889\",\"body\":\"test\",\"encoding\":\"GSM7\",\"segmentCount\":1,\"status\":\"QUEUED\"}','PUBLISHED',1,'2026-09-17 00:09:11.101',NULL,NULL,'2026-09-17 00:09:11.102','2026-09-17 00:09:11.309','2026-09-17 00:09:11.309'),
('b86765a0-fa83-43fb-8c5c-069c5f1709a3','MESSAGE_STATUS','MESSAGE','431c91a9-8563-46d1-8bf5-e2a51cfd4a96','sms.queued','{\"eventId\":\"3GyLtPQmv7W8UQ\",\"occurredAt\":\"2026-09-16T23:24:52.563Z\",\"version\":1,\"messageId\":\"431c91a9-8563-46d1-8bf5-e2a51cfd4a96\",\"publicId\":\"KjTWn5ShsZTn0g\",\"clientId\":\"67c9b53f-b74e-43d0-859f-5349b5b9d0c7\",\"destination\":\"254115915889\",\"body\":\"test\",\"encoding\":\"GSM7\",\"segmentCount\":1,\"status\":\"QUEUED\"}','PUBLISHED',1,'2026-09-16 23:24:52.563',NULL,NULL,'2026-09-16 23:24:52.564','2026-09-16 23:24:53.569','2026-09-16 23:24:53.569'),
('c41f9ea5-4430-417a-ab75-02c249723f79','MESSAGE_STATUS','MESSAGE','76b08e5f-64c9-419b-8b45-3efed4ce6bc5','sms.queued','{\"eventId\":\"iPJI6yZzfwV2DA\",\"occurredAt\":\"2026-09-17T00:00:20.545Z\",\"version\":1,\"messageId\":\"76b08e5f-64c9-419b-8b45-3efed4ce6bc5\",\"publicId\":\"GyxRN_j1vDhpxg\",\"clientId\":\"67c9b53f-b74e-43d0-859f-5349b5b9d0c7\",\"destination\":\"254115915889\",\"body\":\"test\",\"encoding\":\"GSM7\",\"segmentCount\":1,\"status\":\"QUEUED\"}','PUBLISHED',1,'2026-09-17 00:00:20.545',NULL,NULL,'2026-09-17 00:00:20.546','2026-09-17 00:00:20.783','2026-09-17 00:00:20.782'),
('f3b23326-58af-49da-91d2-689709053a46','MESSAGE_STATUS','MESSAGE','b33d3d4d-26e6-452e-b233-1f8c7e2235e0','sms.queued','{\"eventId\":\"J3N9MG4q8frDeA\",\"occurredAt\":\"2026-09-17T00:05:25.353Z\",\"version\":1,\"messageId\":\"b33d3d4d-26e6-452e-b233-1f8c7e2235e0\",\"publicId\":\"a3gBE7B5rIqb_A\",\"clientId\":\"67c9b53f-b74e-43d0-859f-5349b5b9d0c7\",\"destination\":\"254115915889\",\"body\":\"test\",\"encoding\":\"GSM7\",\"segmentCount\":1,\"status\":\"QUEUED\"}','PUBLISHED',1,'2026-09-17 00:05:25.353',NULL,NULL,'2026-09-17 00:05:25.354','2026-09-17 00:05:26.089','2026-09-17 00:05:26.088'),
('f9ecb4ed-f710-4f6d-bb58-7629d9bc6393','MESSAGE_STATUS','MESSAGE','df794a62-8457-475c-b052-0b6d653d323b','sms.queued','{\"eventId\":\"Xrz1_IqcBsu8ag\",\"occurredAt\":\"2026-09-16T23:39:35.633Z\",\"version\":1,\"messageId\":\"df794a62-8457-475c-b052-0b6d653d323b\",\"publicId\":\"aLTSEgzypjO_yQ\",\"clientId\":\"67c9b53f-b74e-43d0-859f-5349b5b9d0c7\",\"destination\":\"254115915889\",\"body\":\"test\",\"encoding\":\"GSM7\",\"segmentCount\":1,\"status\":\"QUEUED\"}','PUBLISHED',1,'2026-09-16 23:39:35.633',NULL,NULL,'2026-09-16 23:39:35.634','2026-09-16 23:39:36.489','2026-09-16 23:39:36.488'),
('fce1f9bf-6e67-40f0-a73b-7758cc13bbb8','MESSAGE_STATUS','MESSAGE','b6d267c0-4614-4a3c-8fb3-d0548457f03d','sms.queued','{\"eventId\":\"ept-mJoyKcRk3Q\",\"occurredAt\":\"2026-09-18T23:32:18.075Z\",\"version\":1,\"messageId\":\"b6d267c0-4614-4a3c-8fb3-d0548457f03d\",\"publicId\":\"dk05JLeeLBI6fw\",\"clientId\":\"67c9b53f-b74e-43d0-859f-5349b5b9d0c7\",\"destination\":\"254115915889\",\"body\":\"test\",\"encoding\":\"GSM7\",\"segmentCount\":1,\"status\":\"QUEUED\"}','PUBLISHED',1,'2026-09-18 23:32:18.075',NULL,NULL,'2026-09-18 23:32:18.076','2026-09-18 23:32:18.547','2026-09-18 23:32:18.546');
/*!40000 ALTER TABLE `outbox_events` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `permissions`
--

DROP TABLE IF EXISTS `permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `permissions` (
  `id` char(36) NOT NULL,
  `name` varchar(100) NOT NULL,
  `module` varchar(100) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  PRIMARY KEY (`id`),
  UNIQUE KEY `permissions_name_key` (`name`),
  KEY `permissions_module_idx` (`module`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `permissions`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `permissions` WRITE;
/*!40000 ALTER TABLE `permissions` DISABLE KEYS */;
INSERT INTO `permissions` VALUES
('06ed1b63-c2df-4c6a-97e5-500c891b15c0','mobile_networks.delete','mobile_networks','Delete mobile networks.','2026-09-01 23:29:48.813'),
('0a05765b-c3cd-42e8-8486-4222454af3d5','sender_ids.enable','sender_ids','Enable Sender IDs.','2026-09-01 21:58:38.175'),
('0b51a2f1-d5b7-4e52-8253-d9fad9008ac4','mobile_networks.create','mobile_networks','Create mobile networks.','2026-09-01 23:29:48.808'),
('0bab1679-6567-4c3b-aa96-f585beb1710c','mobile_networks.read','mobile_networks','View mobile networks.','2026-09-01 23:29:48.807'),
('1dc6cbcf-d0b9-4816-88fd-4312d5e27d8a','messages.read','messages','View messages.','2026-08-20 17:50:30.412'),
('1edc31ac-40eb-42c2-a33b-fb273679ca7b','sender_ids.update','sender_ids','Update Sender IDs.','2026-08-20 17:50:30.354'),
('21848631-938e-4eed-82cd-7b1eb8c56e33','float.read','float','View client float balances and ledger entries.','2026-08-20 17:50:30.375'),
('28b80119-19f5-4e25-b968-f2d3f8ab2bb9','smpp_accounts.activate','smpp_accounts','Activate SMPP accounts.','2026-08-20 17:50:30.397'),
('2989cc49-4741-4581-bcdf-9c4c1b1e0aca','users.read','users','View users.','2026-08-12 02:05:50.711'),
('2b20601c-c0ac-4592-8464-f062001b53b6','connectors.suspend','connectors','Suspend connectors.','2026-09-01 23:29:48.831'),
('2fdfabe0-5c5e-42a9-bece-56182c0d70e4','float.refund','float','Refund credits to client float balances.','2026-08-20 17:50:30.383'),
('3781d10a-6a5c-4730-b6cd-de1034217556','clients.activate','clients','Activate clients.','2026-08-20 17:50:30.341'),
('3862eb57-5e16-4263-ae0a-dac7f65c757f','CHECK_HEALTH','all','can check system health','2026-09-08 12:27:01.540'),
('38a0a583-519f-4f9e-a6b8-c96bcca1542b','connectors.create','connectors','Create connectors.','2026-09-01 23:29:48.821'),
('39fbe9ad-2081-46a5-a855-e3f0ab5dc968','float.top_up','float','Top up client float balances.','2026-08-20 17:50:30.377'),
('3a9dd0ae-6a55-4a68-94a6-b948bab81046','routes.create','routes','Create routes.','2026-09-01 23:33:53.468'),
('406f61a0-b763-4bc5-8585-b0ca319ed9a8','connectors.enable','connectors','Enable connectors.','2026-09-01 23:29:48.825'),
('4196a700-295d-4be0-b971-40a2652beb97','reports.export','reports','can exports  reports','2026-09-17 23:28:20.840'),
('41e0b272-4830-45ca-841d-d0d105d2477a','webhooks:create','webhooks','Create webhook endpoints.','2026-08-20 17:50:30.425'),
('44aeedb0-3af8-4b4e-8406-a642c9cb18e3','smpp_accounts.create','smpp_accounts','Create SMPP accounts.','2026-08-20 17:50:30.390'),
('4a2a2825-3013-4d46-b82c-81422f45be17','float.debit','float','Debit credits from client float balances.','2026-08-20 17:50:30.380'),
('4d5d5be7-3d88-44e6-8abd-3f997a21b818','connectors.delete','connectors','Delete connectors.','2026-09-01 23:29:48.824'),
('4e1fa9ee-d91d-45be-bfab-a9558b4c1106','api_keys.create','api_keys','Create API keys.','2026-08-20 17:50:30.371'),
('52718fe4-8349-4a99-b278-1121eb55afe9','sender_ids.delete','sender_ids','Delete Sender IDs.','2026-08-20 17:50:30.356'),
('59547f1b-1989-4bd3-b16f-1f6c90b0102b','webhooks:rotate-secret','webhooks','Rotate webhook signing secrets.','2026-08-20 17:50:30.434'),
('5a73a0ce-b499-46ad-8860-65c1befd9e75','smpp_accounts.read','smpp_accounts','View SMPP accounts.','2026-08-20 17:50:30.388'),
('5baeed1d-2b42-434a-a520-07366302c347','mobile_networks.enable','mobile_networks','Enable mobile networks.','2026-09-01 23:29:48.815'),
('5ea2f2a3-bdb4-4d02-89e1-bebf707b8715','smpp_accounts.update','smpp_accounts','Update SMPP account configuration.','2026-08-20 17:50:30.392'),
('5ee08999-0333-4187-9992-23fa04e65ef5','roles.read','roles','View roles.','2026-08-12 02:05:50.766'),
('5f83dd9c-52f3-4170-b0f5-28a62e36aaf5','webhooks:deliveries:read','webhooks','View webhook delivery history.','2026-08-20 17:50:30.436'),
('5fc6f732-26a7-4f3e-92ad-65ec5323c3b4','permissions.read','permissions','View permissions.','2026-08-12 02:05:50.761'),
('60023863-c3fd-4212-8057-bddfc9a6d80c','mobile_networks.update','mobile_networks','Update mobile networks.','2026-09-01 23:29:48.810'),
('605669ed-810b-434f-be34-042d339218a1','messages.create','messages','Submit messages.','2026-08-20 17:50:30.419'),
('698ddc1c-6e6c-46f8-8830-a0bb1792326e','webhooks:update','webhooks','Update, enable, or disable webhook endpoints.','2026-08-20 17:50:30.427'),
('6d37cd04-a9f0-4e5a-9215-cdf44b0da589','users.lock','users','lock users.','2026-08-30 19:45:21.186'),
('771f29d7-70cc-4502-a4b1-44e2a23ebb35','webhooks:read','webhooks','View webhook endpoints.','2026-08-20 17:50:30.422'),
('7866bf34-df1a-4d61-b04a-75e5a636b19d','roles.create','roles','Create roles.','2026-08-12 02:05:50.768'),
('7afa9b7d-b5de-4177-9d03-b00cb8a8e23b','sender_ids.read','sender_ids','View Sender IDs.','2026-08-20 17:50:30.350'),
('84695858-0618-4e03-8258-41b8142aa763','clients.read','clients','View clients.','2026-08-20 17:50:30.330'),
('87db1c34-f348-4675-aa74-03cade9ebb7b','users.deactivate','users','Deactivate users.','2026-08-12 02:05:50.741'),
('913861f9-c1ee-4c44-b437-d74303459b0f','sender_ids.disable','sender_ids','Disable Sender IDs.','2026-08-20 17:50:30.363'),
('92c66b07-a205-4d3f-ac1d-cc14483bf5d7','PLATFORM_SUPER_ADMIN','all','can access all clients','2026-08-30 22:29:26.411'),
('9569a993-dfad-43ab-9cdb-22febdd27221','smpp_accounts.disable','smpp_accounts','Disable SMPP accounts.','2026-08-20 17:50:30.401'),
('96ba0093-ca55-4224-afdd-1c24d9bae4f9','connectors.disable','connectors','Disable connectors.','2026-09-01 23:29:48.828'),
('97627b07-f552-4733-90cc-00ea3f2a6d79','users.unlock','users','Unlock users.','2026-08-12 02:05:50.748'),
('98c940eb-24bd-4b22-98e2-c83aef10bf20','users.delete','users','Delete users.','2026-08-12 02:05:50.734'),
('98e995ff-8ed1-451d-8adf-39364e411ab7','float.adjust','float','Adjust client float balances.','2026-08-20 17:50:30.385'),
('9bd759dc-0e90-4720-8a69-9e5f69947c7a','routes.update','routes','Update routes.','2026-09-01 23:33:53.470'),
('9f46d013-6193-471e-a7ec-6d6c9689c61b','users.update','users','Update users.','2026-08-12 02:05:50.726'),
('a19d113f-3608-48ea-9f52-8f8ebaab73ff','connectors.read','connectors','View connectors.','2026-09-01 23:29:48.819'),
('ac22b54f-c5bc-4df9-996c-8fb878b5abc6','routes.disable','routes','Disable routes.','2026-09-01 23:33:53.481'),
('ac939883-b5d0-472f-9482-75f01321b6a6','clients.disable','clients','Disable clients.','2026-08-20 17:50:30.346'),
('ac948c5f-c8d8-4c52-bb5e-27343244e129','clients.suspend','clients','Suspend clients.','2026-08-20 17:50:30.343'),
('adc762ee-a697-4eca-94d9-1b1047571a5f','routes.delete','routes','Delete routes.','2026-09-01 23:33:53.472'),
('af7bf8e3-5273-49c5-b246-16a94eb3c14f','clients.delete','clients','Delete clients.','2026-08-20 17:50:30.339'),
('b643b101-29da-4b31-a084-d9e53ea86d61','smpp_accounts.password.update','smpp_accounts','Change SMPP account passwords.','2026-08-20 17:50:30.394'),
('b89f303b-eba6-45be-af49-eb3a91b71587','routes.read','routes','View routes.','2026-09-01 23:33:53.465'),
('b9dd9e3b-4289-4454-98aa-ae1ad473ee8d','users.roles.update','users','Replace a user\'s role assignments.','2026-08-12 02:05:50.757'),
('be9f676d-530a-493f-97ec-f12b2d35a054','api_keys.read','api_keys','View API keys.','2026-08-20 17:50:30.368'),
('c0a6bce4-d8c0-4008-9c97-8fe3811c8f47','connectors.update','connectors','Update connectors.','2026-09-01 23:29:48.822'),
('c14c26e9-73af-459f-a71f-d1bd9bd899fb','sender_ids.approve','sender_ids','Approve Sender IDs.','2026-08-20 17:50:30.358'),
('c24b08c9-2443-4a5c-aac2-cff9c67cedbc','roles.update','roles','Update roles.','2026-08-12 02:05:50.770'),
('cf6645cf-3d14-455a-81ed-9c48dd973456','sender_ids.reject','sender_ids','Reject Sender IDs.','2026-08-20 17:50:30.360'),
('d15c6c9e-9e14-47a3-a6b4-23a69e2f7070','sender_ids.default.update','sender_ids','Change the default Sender ID.','2026-08-20 17:50:30.366'),
('d4208a26-2ff8-4856-aca6-99a956247a51','users.activate','users','Activate users.','2026-08-12 02:05:50.738'),
('d6d7209f-c3d7-42a5-aa96-37b265bf244a','dashboard.read','dashboard','can view  dashboard','2026-09-16 13:13:33.806'),
('d7e83a9d-ab92-48ac-b740-3806973d74ed','roles.delete','roles','Delete roles.','2026-08-12 02:05:50.771'),
('df11cc61-2c3b-42c3-b751-ac6095464572','sender_ids.create','sender_ids','Create Sender IDs.','2026-08-20 17:50:30.352'),
('e24e4377-0532-44b9-85d0-60e47ae9a46c','clients.create','clients','Create clients.','2026-08-20 17:50:30.333'),
('e3e34f82-9780-4259-8b76-18b469664f1a','webhooks:delete','webhooks','Delete webhook endpoints.','2026-08-20 17:50:30.431'),
('e5604522-5848-445e-932b-b41b075a75f2','mobile_networks.disable','mobile_networks','Disable mobile networks.','2026-09-01 23:29:48.817'),
('e9bf5ed4-1bed-49d4-a5bd-fd3463883b18','clients.update','clients','Update clients.','2026-08-20 17:50:30.335'),
('f02774fb-a750-44f7-a1af-857cb835c9fe','reports.read','reports','can read  reports','2026-09-17 23:28:20.837'),
('f2ea03fe-3142-438a-9e2c-fe7f8dc07645','users.create','users','Create users.','2026-08-12 02:05:50.715'),
('f8090fd2-3bd8-410b-9834-a7ce7e93c173','routes.enable','routes','Enable routes.','2026-09-01 23:33:53.474'),
('fb54e1eb-37ee-4885-b45f-19f39d4fdcc2','audit_logs.read','audit_logs','View audit logs.','2026-08-20 17:50:30.406'),
('fd371bd7-2461-4947-9487-51c54494009d','api_keys.revoke','api_keys','Revoke API keys.','2026-08-20 17:50:30.373');
/*!40000 ALTER TABLE `permissions` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `portal_sessions`
--

DROP TABLE IF EXISTS `portal_sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `portal_sessions` (
  `id` char(36) NOT NULL,
  `userId` char(36) NOT NULL,
  `sessionTokenHash` varchar(255) NOT NULL,
  `ipAddress` varchar(45) DEFAULT NULL,
  `userAgent` varchar(512) DEFAULT NULL,
  `lastActivityAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `expiresAt` datetime(3) NOT NULL,
  `revokedAt` datetime(3) DEFAULT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL,
  `authenticatedWithMfa` tinyint(1) NOT NULL DEFAULT 0,
  `trustedDeviceId` char(36) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `portal_sessions_userId_idx` (`userId`),
  KEY `portal_sessions_expiresAt_idx` (`expiresAt`),
  KEY `portal_sessions_lastActivityAt_idx` (`lastActivityAt`),
  KEY `portal_sessions_trustedDeviceId_idx` (`trustedDeviceId`),
  CONSTRAINT `portal_sessions_trustedDeviceId_fkey` FOREIGN KEY (`trustedDeviceId`) REFERENCES `trusted_devices` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `portal_sessions_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `portal_sessions`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `portal_sessions` WRITE;
/*!40000 ALTER TABLE `portal_sessions` DISABLE KEYS */;
INSERT INTO `portal_sessions` VALUES
('071e2140-f613-4041-a98c-309c7ee75c90','00000000-0000-0000-0000-000000000015','83f62e7425c3382caaefe671411fde07228ec4ecf09d20a16912d9a97b7ad2af','::1','Mozilla/5.0 (X11; Linux x86_64; rv:140.0) Gecko/20100101 Firefox/140.0','2026-09-18 23:31:55.408','2026-10-18 23:31:55.408',NULL,'2026-09-18 23:31:55.409','2026-09-18 23:31:55.409',1,NULL),
('0d3aef38-5293-46af-aaae-637238238d8e','00000000-0000-0000-0000-000000000015','0e1e3aa3888631399d8e8d5d2c25a978a10fbed93145f8369b2d1dfd1e979737','::1','Mozilla/5.0 (X11; Linux x86_64; rv:140.0) Gecko/20100101 Firefox/140.0','2026-09-16 21:26:04.267','2026-10-16 21:26:04.267',NULL,'2026-09-16 21:26:04.268','2026-09-16 21:26:04.268',1,NULL),
('1c99d980-0f72-4a53-82db-af941738fa4d','00000000-0000-0000-0000-000000000015','40d8810e415df38da19b0b955e5c59c5c0a36480e0cf9d02a6c1894532545457','::1','Mozilla/5.0 (X11; Linux x86_64; rv:140.0) Gecko/20100101 Firefox/140.0','2026-09-18 22:57:55.101','2026-10-18 22:57:55.101',NULL,'2026-09-18 01:25:06.437','2026-09-18 22:57:55.102',1,NULL),
('3337b98d-706e-45d1-b403-8d0a8b69951c','00000000-0000-0000-0000-000000000015','edd0333e48325cf91b871d162fc3e62910e84a9d7d92fbf9ae3a7d9185f2b8a4','::1','Mozilla/5.0 (X11; Linux x86_64; rv:140.0) Gecko/20100101 Firefox/140.0','2026-09-16 13:27:00.898','2026-10-16 13:27:00.898',NULL,'2026-09-16 13:27:00.900','2026-09-16 13:27:00.900',1,NULL),
('3780424d-cb03-495f-8f7f-7c98730ca305','00000000-0000-0000-0000-000000000015','9dfe6c0bd6f9c6652bd858932a589116d859683924f8f1fe1018af40822e6de5','::1','Mozilla/5.0 (X11; Linux x86_64; rv:140.0) Gecko/20100101 Firefox/140.0','2026-09-17 13:59:38.402','2026-09-17 13:57:00.000',NULL,'2026-09-17 13:56:00.440','2026-09-17 13:59:38.403',1,NULL),
('6625001e-4196-4c1e-b761-0de98affc2c7','00000000-0000-0000-0000-000000000015','0c6379d681077b80469e9b57568497ec1da2e004db0ef79a7f2aa4ae8ff546c0','::1','Mozilla/5.0 (X11; Linux x86_64; rv:140.0) Gecko/20100101 Firefox/140.0','2026-09-17 14:33:16.780','2026-10-17 14:33:16.780','2026-09-17 14:43:27.212','2026-09-17 14:33:16.780','2026-09-17 14:43:27.213',1,NULL),
('783a9d74-7a1f-4746-8781-8354e046d120','00000000-0000-0000-0000-000000000015','1cfef8be056c1bdef6b0b4fd91fd40978bfed97dd9cba0214d1a1420281a67ba','::1','Mozilla/5.0 (X11; Linux x86_64; rv:140.0) Gecko/20100101 Firefox/140.0','2026-09-17 13:46:18.652','2026-09-17 13:47:36.606',NULL,'2026-09-17 13:46:18.653','2026-09-17 13:46:18.653',1,NULL),
('7d524ee2-7b8c-4e07-b582-96687b8b08c3','00000000-0000-0000-0000-000000000015','807d008e2ce8295f04dc5f6742e0385a262cdfdc7c56bdf3ff22de76efbd1b44','::1','Mozilla/5.0 (X11; Linux x86_64; rv:140.0) Gecko/20100101 Firefox/140.0','2026-09-17 17:17:30.343','2026-10-17 17:17:30.343',NULL,'2026-09-17 14:44:10.772','2026-09-17 17:17:30.345',1,NULL),
('8b15e190-9661-4066-b868-09f1323eae35','00000000-0000-0000-0000-000000000015','f165b24611d44f37f3e2052abbd10ab95940ad9c81c7c133536036bf3ee9175e','::1','Mozilla/5.0 (X11; Linux x86_64; rv:140.0) Gecko/20100101 Firefox/140.0','2026-09-17 13:25:18.338','2026-10-17 13:25:18.338','2026-09-17 15:28:21.000','2026-09-17 00:44:27.791','2026-09-17 13:25:18.338',1,NULL),
('975cbe68-b16e-4827-8836-107e24e6f980','00000000-0000-0000-0000-000000000015','3c56e650dd72d414381a2d07a8cb2d3fd560231d48b02d826aa8a86d038970c5','::1','Mozilla/5.0 (X11; Linux x86_64; rv:140.0) Gecko/20100101 Firefox/140.0','2026-09-16 10:47:04.038','2026-10-16 10:47:04.038',NULL,'2026-09-16 10:47:04.039','2026-09-16 10:47:04.039',1,NULL),
('a404faed-be98-4750-9ae0-7b686416a888','00000000-0000-0000-0000-000000000015','c2b0671889131928bdf0e2de3795713a6b68b9377b99fcfc9c31652de5380eef','::1','Mozilla/5.0 (X11; Linux x86_64; rv:140.0) Gecko/20100101 Firefox/140.0','2026-09-18 00:45:34.663','2026-10-18 00:45:34.663',NULL,'2026-09-18 00:13:36.150','2026-09-18 00:45:34.664',1,NULL),
('aa76221f-d670-4778-ade2-cbca7f872470','00000000-0000-0000-0000-000000000015','dc3f22f6072a4cca240af45a96ae0cdcc7afe26fe30d8279b64f3db53af85f97','::1','Mozilla/5.0 (X11; Linux x86_64; rv:140.0) Gecko/20100101 Firefox/140.0','2026-09-17 13:31:11.174','2026-09-17 15:31:58.000','2026-09-17 13:45:57.774','2026-09-17 13:31:11.175','2026-09-17 13:45:57.775',1,NULL),
('b0904aff-1e50-4a6f-b052-11b81812e4ac','00000000-0000-0000-0000-000000000015','4a9ca7f8aadf15fb7bb93623efe7ce5ea1e4c1be190b343aad947c52edd591b5','::1','Mozilla/5.0 (X11; Linux x86_64; rv:140.0) Gecko/20100101 Firefox/140.0','2026-09-18 00:10:06.092','2026-10-18 00:10:06.092','2026-09-18 00:13:20.780','2026-09-18 00:10:06.094','2026-09-18 00:13:20.781',1,NULL),
('c75040c5-c1e6-4f61-9d18-1333d0bbdc44','00000000-0000-0000-0000-000000000015','52f262860dde340b0dd873050aa39129191d6065a0158faec28196e05ac8b239','::1','Mozilla/5.0 (X11; Linux x86_64; rv:140.0) Gecko/20100101 Firefox/140.0','2026-09-16 20:51:22.821','2026-10-16 20:51:22.821',NULL,'2026-09-16 20:51:22.822','2026-09-16 20:51:22.822',1,NULL),
('d0f6bc8d-f4dd-4cca-b8ca-727c47d54414','00000000-0000-0000-0000-000000000015','23c06ccd4384f96d7841a62a52d82c1aa204e8780f97dffe5605c15d748a0c0c','::1','Mozilla/5.0 (X11; Linux x86_64; rv:140.0) Gecko/20100101 Firefox/140.0','2026-09-16 23:41:20.396','2026-10-16 23:41:20.396',NULL,'2026-09-16 23:41:20.397','2026-09-16 23:41:20.397',1,NULL),
('e9be05c8-1f84-4f75-ba06-921dcbc75062','00000000-0000-0000-0000-000000000015','a079aff02993c4014e437d966cd7c28ec7df3557d03d68ecd111d9b96aa3bd62','::1','Mozilla/5.0 (X11; Linux x86_64; rv:140.0) Gecko/20100101 Firefox/140.0','2026-09-16 22:40:18.058','2026-10-16 22:40:18.058',NULL,'2026-09-16 22:40:18.059','2026-09-16 22:40:18.059',1,NULL),
('eb5df8c2-04e2-4cf9-a569-e87211a6b0c5','00000000-0000-0000-0000-000000000015','138910b781f7658357c9dd9241d065ef4196d787d905206a489aca861d141162','::1','Mozilla/5.0 (X11; Linux x86_64; rv:140.0) Gecko/20100101 Firefox/140.0','2026-09-16 23:10:44.417','2026-10-16 23:10:44.417',NULL,'2026-09-16 23:10:44.419','2026-09-16 23:10:44.419',1,NULL),
('fc5c12a3-33bf-439e-9d1a-4a60dacf6c18','00000000-0000-0000-0000-000000000015','b54a276f32c9c224320fc0dce985b0ae206bcd19a967e04e6e604bf1ca00d43d','::1','Mozilla/5.0 (X11; Linux x86_64; rv:140.0) Gecko/20100101 Firefox/140.0','2026-09-16 10:15:37.548','2026-10-16 10:15:37.548',NULL,'2026-09-16 10:15:37.549','2026-09-16 10:15:37.549',1,NULL);
/*!40000 ALTER TABLE `portal_sessions` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `refresh_tokens`
--

DROP TABLE IF EXISTS `refresh_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `refresh_tokens` (
  `id` char(36) NOT NULL,
  `sessionId` char(36) NOT NULL,
  `replacedById` char(36) DEFAULT NULL,
  `tokenHash` varchar(255) NOT NULL,
  `expiresAt` datetime(3) NOT NULL,
  `revokedAt` datetime(3) DEFAULT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  PRIMARY KEY (`id`),
  UNIQUE KEY `refresh_tokens_tokenHash_key` (`tokenHash`),
  KEY `refresh_tokens_sessionId_idx` (`sessionId`),
  KEY `refresh_tokens_expiresAt_idx` (`expiresAt`),
  KEY `refresh_tokens_replacedById_idx` (`replacedById`),
  CONSTRAINT `refresh_tokens_replacedById_fkey` FOREIGN KEY (`replacedById`) REFERENCES `refresh_tokens` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `refresh_tokens_sessionId_fkey` FOREIGN KEY (`sessionId`) REFERENCES `portal_sessions` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `refresh_tokens`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `refresh_tokens` WRITE;
/*!40000 ALTER TABLE `refresh_tokens` DISABLE KEYS */;
INSERT INTO `refresh_tokens` VALUES
('038f5b25-41c3-4163-aa15-22d8642855c5','1c99d980-0f72-4a53-82db-af941738fa4d','0d692f8c-90fe-4a9c-8892-343fbc679ef1','c108fe670e84f49b0f4509703dce40ed202066b25dfdb11af12ab26b5b80a1f4','2026-09-25 01:25:06.439','2026-09-18 22:57:55.108','2026-09-18 01:25:06.441'),
('0d692f8c-90fe-4a9c-8892-343fbc679ef1','1c99d980-0f72-4a53-82db-af941738fa4d',NULL,'c680c4f05c72a104fecb58f0f7061659e2e994e68a883cf756a7207816830ddf','2026-09-25 01:25:06.439',NULL,'2026-09-18 22:57:55.107'),
('101052e8-2b39-4d75-9f17-25a8e9afd576','fc5c12a3-33bf-439e-9d1a-4a60dacf6c18',NULL,'cc452c3309c00d41040e5dc3bcabc66c176bdfb41f31842d255d6df65b9743af','2026-09-23 10:15:37.550',NULL,'2026-09-16 10:15:37.551'),
('1533aee1-9b4c-411b-a0bd-17511aa154d9','3780424d-cb03-495f-8f7f-7c98730ca305',NULL,'5f0c51248561ee2f3b010ec7c96280afbd5c4dfac6260969c6ea5107441eca0c','2026-09-17 13:57:00.000',NULL,'2026-09-17 13:59:38.409'),
('17ebc909-e74c-4c85-b98f-6d2405bba4cb','3337b98d-706e-45d1-b403-8d0a8b69951c',NULL,'1eff9db47b54dcd366c05c7e2267a3c9ceb3a917fd39f0758d38bdd562a01ee9','2026-09-23 13:27:00.903',NULL,'2026-09-16 13:27:00.905'),
('19fcddfb-783f-418e-a086-986d74cc9833','eb5df8c2-04e2-4cf9-a569-e87211a6b0c5',NULL,'bddb30c48e4745c2c9c21bc8d6a1f0d9f3b9d7430201c1714a7c2d11dcac5be9','2026-09-23 23:10:44.423',NULL,'2026-09-16 23:10:44.424'),
('20ca63a3-465e-4e29-a31d-7e236242ceb2','3780424d-cb03-495f-8f7f-7c98730ca305','1533aee1-9b4c-411b-a0bd-17511aa154d9','9bbc1b06bc6fd9d446470e6656ec6c3dea9d2c0cc95d510f8edcfbc8473d9a7a','2026-09-24 13:56:00.443','2026-09-17 13:59:38.410','2026-09-17 13:57:41.602'),
('2282c75c-52dd-4555-a9e1-7044d0e5bee2','e9be05c8-1f84-4f75-ba06-921dcbc75062',NULL,'f833f9753144a1b9f60d7fdb3f2b589c61fec7d915d992c84a0ed7d584499628','2026-09-23 22:40:18.060',NULL,'2026-09-16 22:40:18.061'),
('2a7afa42-5d0f-4517-8532-695c25415add','0d3aef38-5293-46af-aaae-637238238d8e',NULL,'c34902789fa6bf04d662c07ed47adab73835de4700f28288e4cc14a368100aa0','2026-09-23 21:26:04.272',NULL,'2026-09-16 21:26:04.275'),
('75b15708-961e-48ee-9172-7d8af58dff49','8b15e190-9661-4066-b868-09f1323eae35','8965fd4c-30fa-43f6-b3ac-02e5b1908b46','dd24020ccf6711f92e7f181f57aa74ade976b6d38886e09f138dfc7dc52b25ff','2026-09-24 00:44:27.794','2026-09-17 13:25:18.346','2026-09-17 00:44:27.796'),
('782fb028-7943-4a71-be8e-76eb61969978','a404faed-be98-4750-9ae0-7b686416a888','f1819bf3-525f-4c2e-879d-c470ef6d3ab9','95e96b42b80a369aac2d098cfcedd3e46ff83ac600d7e537ad65843527f22df3','2026-09-25 00:13:36.154','2026-09-18 00:45:34.672','2026-09-18 00:13:36.156'),
('7ec80db8-e196-4432-bda7-003e1b40db87','7d524ee2-7b8c-4e07-b582-96687b8b08c3','bf8ad9a8-c93a-4c5d-ad94-014ae619d501','8b61a6b55f53127147fdd65044a74a3d0e0ecdfe30293e9682aec7b0b36c52ac','2026-09-24 14:44:10.774','2026-09-17 17:17:30.355','2026-09-17 14:44:10.775'),
('852ae835-2a84-47f7-b0a9-3fe4a95cce04','783a9d74-7a1f-4746-8781-8354e046d120',NULL,'ae4c9436b743102296442bfe796e8f4c1740753d8bc2f6f331a5ab2f69faf6cc','2026-09-24 13:46:18.655','2026-09-17 13:49:06.664','2026-09-17 13:46:18.657'),
('876f4aa5-5bb6-4ab4-a998-b75f673dfb9f','975cbe68-b16e-4827-8836-107e24e6f980',NULL,'f28a6ccd1b206de60e93c131b399fd50432598062dd6060e8c10cb3929a9d7ef','2026-09-23 10:47:04.041',NULL,'2026-09-16 10:47:04.042'),
('8965fd4c-30fa-43f6-b3ac-02e5b1908b46','8b15e190-9661-4066-b868-09f1323eae35',NULL,'36643f9e64e00ccee435cceea7661f1f03bb89f053e9b992928065b1f5df1244','2026-09-24 13:25:18.342',NULL,'2026-09-17 13:25:18.345'),
('9c912ace-3d22-4f75-a0ad-2b4aa6b20914','d0f6bc8d-f4dd-4cca-b8ca-727c47d54414',NULL,'5683d7d9345e6e9d3dffa910f317d39b64c0b06e9208a868ae23f6036bc65868','2026-09-23 23:41:20.399',NULL,'2026-09-16 23:41:20.400'),
('a751b1de-2518-4f3b-8fab-40a167ac728d','6625001e-4196-4c1e-b761-0de98affc2c7',NULL,'cd2dd6dad3da08c2c8ef30420719ba4c66deb8f09095802036573fd00b8206f7','2026-09-24 14:33:16.783','2026-09-17 14:43:27.214','2026-09-17 14:33:16.784'),
('a9f1edd3-f4d7-4125-83a8-ea2e63c3b184','3780424d-cb03-495f-8f7f-7c98730ca305','20ca63a3-465e-4e29-a31d-7e236242ceb2','b66ec84084341bbce58eb35526815183171d083960376b8a4780e78440a643a1','2026-09-24 13:56:00.443','2026-09-17 13:57:41.604','2026-09-17 13:56:00.444'),
('be73e05f-512a-4b9c-90b7-eb52e11db054','aa76221f-d670-4778-ade2-cbca7f872470',NULL,'8f96dfb4487c2320758c091ab4a56aff048a64c2ed89aae545e9d7dec8e6bcca','2026-09-24 13:31:11.182','2026-09-17 15:33:24.000','2026-09-17 13:31:11.184'),
('bf8ad9a8-c93a-4c5d-ad94-014ae619d501','7d524ee2-7b8c-4e07-b582-96687b8b08c3',NULL,'90787eaa791fe3be3881e319ad0be61233c815a74ecbea547c61f4a780191067','2026-09-24 14:44:10.774',NULL,'2026-09-17 17:17:30.354'),
('c78cc011-2f6f-407c-93d2-1c8395523513','c75040c5-c1e6-4f61-9d18-1333d0bbdc44',NULL,'7984ff206b727f84291c03e06c2f3d6787216a6846237350278aad41f2a054d6','2026-09-23 20:51:22.823',NULL,'2026-09-16 20:51:22.825'),
('c7cd482d-431f-4091-af94-28fe2fc3ed1e','b0904aff-1e50-4a6f-b052-11b81812e4ac',NULL,'16ef912f0f0c88c1c5da74f5c8aa2710215bb69d8f92adecd5f5c448a9bba194','2026-09-25 00:10:06.097','2026-09-18 00:13:20.785','2026-09-18 00:10:06.099'),
('f1819bf3-525f-4c2e-879d-c470ef6d3ab9','a404faed-be98-4750-9ae0-7b686416a888',NULL,'76bb97e3d703e3d6a8664890de36e300c6358b0b49e5b0046079fd685a070718','2026-09-25 00:13:36.154',NULL,'2026-09-18 00:45:34.671'),
('f355fc52-cc29-4140-b5b6-142507084100','071e2140-f613-4041-a98c-309c7ee75c90',NULL,'7d0517e1b6e711b6567ec3bdd963030420598401b75781297333e31a6e7e8c76','2026-09-25 23:31:55.412',NULL,'2026-09-18 23:31:55.415');
/*!40000 ALTER TABLE `refresh_tokens` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `role_permissions`
--

DROP TABLE IF EXISTS `role_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `role_permissions` (
  `roleId` char(36) NOT NULL,
  `permissionId` char(36) NOT NULL,
  `assignedAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  PRIMARY KEY (`roleId`,`permissionId`),
  KEY `role_permissions_permissionId_idx` (`permissionId`),
  CONSTRAINT `role_permissions_permissionId_fkey` FOREIGN KEY (`permissionId`) REFERENCES `permissions` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `role_permissions_roleId_fkey` FOREIGN KEY (`roleId`) REFERENCES `roles` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `role_permissions`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `role_permissions` WRITE;
/*!40000 ALTER TABLE `role_permissions` DISABLE KEYS */;
INSERT INTO `role_permissions` VALUES
('9c2bb08e-0eb7-4fc4-930f-533d3989032f','06ed1b63-c2df-4c6a-97e5-500c891b15c0','2026-09-02 02:27:08.605'),
('9c2bb08e-0eb7-4fc4-930f-533d3989032f','0a05765b-c3cd-42e8-8486-4222454af3d5','2026-09-02 00:06:31.642'),
('9c2bb08e-0eb7-4fc4-930f-533d3989032f','0b51a2f1-d5b7-4e52-8253-d9fad9008ac4','2026-09-02 02:27:08.605'),
('9c2bb08e-0eb7-4fc4-930f-533d3989032f','0bab1679-6567-4c3b-aa96-f585beb1710c','2026-09-02 02:27:08.605'),
('9c2bb08e-0eb7-4fc4-930f-533d3989032f','1dc6cbcf-d0b9-4816-88fd-4312d5e27d8a','2026-08-23 16:03:36.000'),
('9c2bb08e-0eb7-4fc4-930f-533d3989032f','1edc31ac-40eb-42c2-a33b-fb273679ca7b','2026-08-23 16:03:36.000'),
('9c2bb08e-0eb7-4fc4-930f-533d3989032f','21848631-938e-4eed-82cd-7b1eb8c56e33','2026-08-23 16:03:36.000'),
('9c2bb08e-0eb7-4fc4-930f-533d3989032f','28b80119-19f5-4e25-b968-f2d3f8ab2bb9','2026-08-23 16:03:36.000'),
('9c2bb08e-0eb7-4fc4-930f-533d3989032f','2989cc49-4741-4581-bcdf-9c4c1b1e0aca','2026-08-23 16:03:36.000'),
('9c2bb08e-0eb7-4fc4-930f-533d3989032f','2b20601c-c0ac-4592-8464-f062001b53b6','2026-09-02 02:27:08.605'),
('9c2bb08e-0eb7-4fc4-930f-533d3989032f','2fdfabe0-5c5e-42a9-bece-56182c0d70e4','2026-08-23 16:03:36.000'),
('9c2bb08e-0eb7-4fc4-930f-533d3989032f','3781d10a-6a5c-4730-b6cd-de1034217556','2026-08-23 16:03:36.000'),
('9c2bb08e-0eb7-4fc4-930f-533d3989032f','3862eb57-5e16-4263-ae0a-dac7f65c757f','2026-09-08 14:29:13.324'),
('9c2bb08e-0eb7-4fc4-930f-533d3989032f','38a0a583-519f-4f9e-a6b8-c96bcca1542b','2026-09-02 02:27:08.605'),
('9c2bb08e-0eb7-4fc4-930f-533d3989032f','39fbe9ad-2081-46a5-a855-e3f0ab5dc968','2026-08-23 16:03:36.000'),
('9c2bb08e-0eb7-4fc4-930f-533d3989032f','3a9dd0ae-6a55-4a68-94a6-b948bab81046','2026-09-02 02:27:08.605'),
('9c2bb08e-0eb7-4fc4-930f-533d3989032f','406f61a0-b763-4bc5-8585-b0ca319ed9a8','2026-09-02 02:27:08.605'),
('9c2bb08e-0eb7-4fc4-930f-533d3989032f','4196a700-295d-4be0-b971-40a2652beb97','2026-09-18 02:12:44.359'),
('9c2bb08e-0eb7-4fc4-930f-533d3989032f','41e0b272-4830-45ca-841d-d0d105d2477a','2026-08-23 16:03:36.000'),
('9c2bb08e-0eb7-4fc4-930f-533d3989032f','44aeedb0-3af8-4b4e-8406-a642c9cb18e3','2026-08-23 16:03:36.000'),
('9c2bb08e-0eb7-4fc4-930f-533d3989032f','4a2a2825-3013-4d46-b82c-81422f45be17','2026-08-23 16:03:36.000'),
('9c2bb08e-0eb7-4fc4-930f-533d3989032f','4d5d5be7-3d88-44e6-8abd-3f997a21b818','2026-09-02 02:27:08.605'),
('9c2bb08e-0eb7-4fc4-930f-533d3989032f','4e1fa9ee-d91d-45be-bfab-a9558b4c1106','2026-08-23 16:03:36.000'),
('9c2bb08e-0eb7-4fc4-930f-533d3989032f','52718fe4-8349-4a99-b278-1121eb55afe9','2026-08-23 16:03:36.000'),
('9c2bb08e-0eb7-4fc4-930f-533d3989032f','59547f1b-1989-4bd3-b16f-1f6c90b0102b','2026-08-23 16:03:36.000'),
('9c2bb08e-0eb7-4fc4-930f-533d3989032f','5a73a0ce-b499-46ad-8860-65c1befd9e75','2026-08-23 16:03:36.000'),
('9c2bb08e-0eb7-4fc4-930f-533d3989032f','5baeed1d-2b42-434a-a520-07366302c347','2026-09-02 02:27:08.605'),
('9c2bb08e-0eb7-4fc4-930f-533d3989032f','5ea2f2a3-bdb4-4d02-89e1-bebf707b8715','2026-08-23 16:03:36.000'),
('9c2bb08e-0eb7-4fc4-930f-533d3989032f','5ee08999-0333-4187-9992-23fa04e65ef5','2026-08-23 16:03:36.000'),
('9c2bb08e-0eb7-4fc4-930f-533d3989032f','5f83dd9c-52f3-4170-b0f5-28a62e36aaf5','2026-08-23 16:03:36.000'),
('9c2bb08e-0eb7-4fc4-930f-533d3989032f','5fc6f732-26a7-4f3e-92ad-65ec5323c3b4','2026-08-23 16:03:36.000'),
('9c2bb08e-0eb7-4fc4-930f-533d3989032f','60023863-c3fd-4212-8057-bddfc9a6d80c','2026-09-02 02:27:08.605'),
('9c2bb08e-0eb7-4fc4-930f-533d3989032f','605669ed-810b-434f-be34-042d339218a1','2026-08-23 16:03:36.000'),
('9c2bb08e-0eb7-4fc4-930f-533d3989032f','698ddc1c-6e6c-46f8-8830-a0bb1792326e','2026-08-23 16:03:36.000'),
('9c2bb08e-0eb7-4fc4-930f-533d3989032f','6d37cd04-a9f0-4e5a-9215-cdf44b0da589','2026-09-02 02:27:08.605'),
('9c2bb08e-0eb7-4fc4-930f-533d3989032f','771f29d7-70cc-4502-a4b1-44e2a23ebb35','2026-08-23 16:03:36.000'),
('9c2bb08e-0eb7-4fc4-930f-533d3989032f','7866bf34-df1a-4d61-b04a-75e5a636b19d','2026-08-23 16:03:36.000'),
('9c2bb08e-0eb7-4fc4-930f-533d3989032f','7afa9b7d-b5de-4177-9d03-b00cb8a8e23b','2026-08-23 16:03:36.000'),
('9c2bb08e-0eb7-4fc4-930f-533d3989032f','84695858-0618-4e03-8258-41b8142aa763','2026-08-23 16:03:36.000'),
('9c2bb08e-0eb7-4fc4-930f-533d3989032f','87db1c34-f348-4675-aa74-03cade9ebb7b','2026-08-23 16:03:36.000'),
('9c2bb08e-0eb7-4fc4-930f-533d3989032f','913861f9-c1ee-4c44-b437-d74303459b0f','2026-08-23 16:03:36.000'),
('9c2bb08e-0eb7-4fc4-930f-533d3989032f','92c66b07-a205-4d3f-ac1d-cc14483bf5d7','2026-08-31 00:32:53.895'),
('9c2bb08e-0eb7-4fc4-930f-533d3989032f','9569a993-dfad-43ab-9cdb-22febdd27221','2026-08-23 16:03:36.000'),
('9c2bb08e-0eb7-4fc4-930f-533d3989032f','96ba0093-ca55-4224-afdd-1c24d9bae4f9','2026-09-02 02:27:08.605'),
('9c2bb08e-0eb7-4fc4-930f-533d3989032f','97627b07-f552-4733-90cc-00ea3f2a6d79','2026-08-23 16:03:36.000'),
('9c2bb08e-0eb7-4fc4-930f-533d3989032f','98c940eb-24bd-4b22-98e2-c83aef10bf20','2026-08-23 16:03:36.000'),
('9c2bb08e-0eb7-4fc4-930f-533d3989032f','98e995ff-8ed1-451d-8adf-39364e411ab7','2026-08-23 16:03:36.000'),
('9c2bb08e-0eb7-4fc4-930f-533d3989032f','9bd759dc-0e90-4720-8a69-9e5f69947c7a','2026-09-02 02:27:08.605'),
('9c2bb08e-0eb7-4fc4-930f-533d3989032f','9f46d013-6193-471e-a7ec-6d6c9689c61b','2026-08-23 16:03:36.000'),
('9c2bb08e-0eb7-4fc4-930f-533d3989032f','a19d113f-3608-48ea-9f52-8f8ebaab73ff','2026-09-02 02:27:08.605'),
('9c2bb08e-0eb7-4fc4-930f-533d3989032f','ac22b54f-c5bc-4df9-996c-8fb878b5abc6','2026-09-02 02:27:08.605'),
('9c2bb08e-0eb7-4fc4-930f-533d3989032f','ac939883-b5d0-472f-9482-75f01321b6a6','2026-08-23 16:03:36.000'),
('9c2bb08e-0eb7-4fc4-930f-533d3989032f','ac948c5f-c8d8-4c52-bb5e-27343244e129','2026-08-23 16:03:36.000'),
('9c2bb08e-0eb7-4fc4-930f-533d3989032f','adc762ee-a697-4eca-94d9-1b1047571a5f','2026-09-02 02:27:08.605'),
('9c2bb08e-0eb7-4fc4-930f-533d3989032f','af7bf8e3-5273-49c5-b246-16a94eb3c14f','2026-08-23 16:03:36.000'),
('9c2bb08e-0eb7-4fc4-930f-533d3989032f','b643b101-29da-4b31-a084-d9e53ea86d61','2026-08-23 16:03:36.000'),
('9c2bb08e-0eb7-4fc4-930f-533d3989032f','b89f303b-eba6-45be-af49-eb3a91b71587','2026-09-02 02:27:08.605'),
('9c2bb08e-0eb7-4fc4-930f-533d3989032f','b9dd9e3b-4289-4454-98aa-ae1ad473ee8d','2026-08-23 16:03:36.000'),
('9c2bb08e-0eb7-4fc4-930f-533d3989032f','be9f676d-530a-493f-97ec-f12b2d35a054','2026-08-23 16:03:36.000'),
('9c2bb08e-0eb7-4fc4-930f-533d3989032f','c0a6bce4-d8c0-4008-9c97-8fe3811c8f47','2026-09-02 02:27:08.605'),
('9c2bb08e-0eb7-4fc4-930f-533d3989032f','c14c26e9-73af-459f-a71f-d1bd9bd899fb','2026-08-23 16:03:36.000'),
('9c2bb08e-0eb7-4fc4-930f-533d3989032f','c24b08c9-2443-4a5c-aac2-cff9c67cedbc','2026-08-23 16:03:36.000'),
('9c2bb08e-0eb7-4fc4-930f-533d3989032f','cf6645cf-3d14-455a-81ed-9c48dd973456','2026-08-23 16:03:36.000'),
('9c2bb08e-0eb7-4fc4-930f-533d3989032f','d15c6c9e-9e14-47a3-a6b4-23a69e2f7070','2026-08-23 16:03:36.000'),
('9c2bb08e-0eb7-4fc4-930f-533d3989032f','d4208a26-2ff8-4856-aca6-99a956247a51','2026-08-23 16:03:36.000'),
('9c2bb08e-0eb7-4fc4-930f-533d3989032f','d6d7209f-c3d7-42a5-aa96-37b265bf244a','2026-09-16 15:15:43.275'),
('9c2bb08e-0eb7-4fc4-930f-533d3989032f','d7e83a9d-ab92-48ac-b740-3806973d74ed','2026-08-23 16:03:36.000'),
('9c2bb08e-0eb7-4fc4-930f-533d3989032f','df11cc61-2c3b-42c3-b751-ac6095464572','2026-08-23 16:03:36.000'),
('9c2bb08e-0eb7-4fc4-930f-533d3989032f','e24e4377-0532-44b9-85d0-60e47ae9a46c','2026-08-23 16:03:36.000'),
('9c2bb08e-0eb7-4fc4-930f-533d3989032f','e3e34f82-9780-4259-8b76-18b469664f1a','2026-08-23 16:03:36.000'),
('9c2bb08e-0eb7-4fc4-930f-533d3989032f','e5604522-5848-445e-932b-b41b075a75f2','2026-09-02 02:27:08.605'),
('9c2bb08e-0eb7-4fc4-930f-533d3989032f','e9bf5ed4-1bed-49d4-a5bd-fd3463883b18','2026-08-23 16:03:36.000'),
('9c2bb08e-0eb7-4fc4-930f-533d3989032f','f02774fb-a750-44f7-a1af-857cb835c9fe','2026-09-18 02:13:09.089'),
('9c2bb08e-0eb7-4fc4-930f-533d3989032f','f2ea03fe-3142-438a-9e2c-fe7f8dc07645','2026-08-23 16:03:36.000'),
('9c2bb08e-0eb7-4fc4-930f-533d3989032f','f8090fd2-3bd8-410b-9834-a7ce7e93c173','2026-09-02 02:27:08.605'),
('9c2bb08e-0eb7-4fc4-930f-533d3989032f','fb54e1eb-37ee-4885-b45f-19f39d4fdcc2','2026-08-23 16:03:36.000'),
('9c2bb08e-0eb7-4fc4-930f-533d3989032f','fd371bd7-2461-4947-9487-51c54494009d','2026-08-23 16:03:36.000');
/*!40000 ALTER TABLE `role_permissions` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `roles` (
  `id` char(36) NOT NULL,
  `name` varchar(100) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `system` tinyint(1) NOT NULL DEFAULT 1,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `roles_name_key` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` VALUES
('22a4befd-d287-4823-8e2a-8a87b1c91dc8','READ_ONLY','Read Only — view-only access',1,'2026-08-07 08:46:43.327','2026-08-07 08:50:13.773'),
('2fe77ce5-0a62-401b-9373-105f70ca5e04','SUPPORT','Support — view data and assist customers',1,'2026-08-07 08:46:43.327','2026-08-07 08:50:13.772'),
('8d57b2b5-8201-4a58-903b-7d2731b569ac','OPERATOR','Operator — manage messages and sender IDs',1,'2026-08-07 08:46:43.327','2026-08-07 08:50:13.770'),
('9c2bb08e-0eb7-4fc4-930f-533d3989032f','PLATFORM_SUPER_ADMIN','Super Administrator — unrestricted access',1,'2026-08-07 08:46:43.327','2026-08-07 08:50:13.765'),
('dc673efe-652f-4e33-87da-ab4602e1260b','ADMIN','Administrator — manage most resources',1,'2026-08-07 08:46:43.327','2026-09-05 06:53:02.212');
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `routes`
--

DROP TABLE IF EXISTS `routes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `routes` (
  `id` char(36) NOT NULL,
  `publicId` varchar(20) NOT NULL,
  `clientId` char(36) NOT NULL,
  `mobileNetworkId` char(36) NOT NULL,
  `connectorId` char(36) NOT NULL,
  `priority` int(11) NOT NULL,
  `status` enum('ACTIVE','DISABLED') NOT NULL DEFAULT 'ACTIVE',
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `routes_publicId_key` (`publicId`),
  UNIQUE KEY `routes_clientId_mobileNetworkId_priority_key` (`clientId`,`mobileNetworkId`,`priority`),
  KEY `routes_clientId_idx` (`clientId`),
  KEY `routes_mobileNetworkId_idx` (`mobileNetworkId`),
  KEY `routes_connectorId_idx` (`connectorId`),
  KEY `routes_status_idx` (`status`),
  KEY `routes_clientId_mobileNetworkId_status_priority_idx` (`clientId`,`mobileNetworkId`,`status`,`priority`),
  CONSTRAINT `routes_clientId_fkey` FOREIGN KEY (`clientId`) REFERENCES `clients` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `routes_connectorId_fkey` FOREIGN KEY (`connectorId`) REFERENCES `connectors` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `routes_mobileNetworkId_fkey` FOREIGN KEY (`mobileNetworkId`) REFERENCES `mobile_networks` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `routes`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `routes` WRITE;
/*!40000 ALTER TABLE `routes` DISABLE KEYS */;
INSERT INTO `routes` VALUES
('48b9c46e-4e0a-4858-9a63-a2d7a82145e5','TEST-001','67c9b53f-b74e-43d0-859f-5349b5b9d0c7','d796e89f-d5b5-42bd-be1a-d2606a537740','c4d0d250-65cf-4638-87f3-0005a4ee4e19',3,'ACTIVE','2026-09-16 22:41:31.135','2026-09-16 23:42:20.602'),
('e67c928a-648a-4fd2-8317-d7d12d4fd4fc','test-002','67c9b53f-b74e-43d0-859f-5349b5b9d0c7','d796e89f-d5b5-42bd-be1a-d2606a537740','9f1c99a7-9e8e-11f1-a1a3-84144d0a7d3c',2,'ACTIVE','2026-09-16 23:42:07.927','2026-09-16 23:42:07.927');
/*!40000 ALTER TABLE `routes` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `sender_ids`
--

DROP TABLE IF EXISTS `sender_ids`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `sender_ids` (
  `id` char(36) NOT NULL,
  `publicId` varchar(20) NOT NULL,
  `clientId` char(36) NOT NULL,
  `sender` varchar(20) NOT NULL,
  `status` enum('PENDING','APPROVED','REJECTED','DISABLED') NOT NULL DEFAULT 'PENDING',
  `isDefault` tinyint(1) NOT NULL DEFAULT 0,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `sender_ids_publicId_key` (`publicId`),
  UNIQUE KEY `sender_ids_clientId_sender_key` (`clientId`,`sender`),
  KEY `sender_ids_clientId_idx` (`clientId`),
  KEY `sender_ids_status_idx` (`status`),
  CONSTRAINT `sender_ids_clientId_fkey` FOREIGN KEY (`clientId`) REFERENCES `clients` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sender_ids`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `sender_ids` WRITE;
/*!40000 ALTER TABLE `sender_ids` DISABLE KEYS */;
INSERT INTO `sender_ids` VALUES
('39ad43d1-cd8f-4598-a9be-2ab92e874795','test','67c9b53f-b74e-43d0-859f-5349b5b9d0c7','test','APPROVED',0,'2026-09-16 20:59:23.106','2026-09-16 20:59:34.079');
/*!40000 ALTER TABLE `sender_ids` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `smpp_account_ip_allowlist`
--

DROP TABLE IF EXISTS `smpp_account_ip_allowlist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `smpp_account_ip_allowlist` (
  `id` char(36) NOT NULL,
  `smppAccountId` char(36) NOT NULL,
  `ipAddress` varchar(45) NOT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `smpp_account_ip_allowlist_smppAccountId_ipAddress_key` (`smppAccountId`,`ipAddress`),
  KEY `smpp_account_ip_allowlist_smppAccountId_idx` (`smppAccountId`),
  CONSTRAINT `smpp_account_ip_allowlist_smppAccountId_fkey` FOREIGN KEY (`smppAccountId`) REFERENCES `smpp_accounts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `smpp_account_ip_allowlist`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `smpp_account_ip_allowlist` WRITE;
/*!40000 ALTER TABLE `smpp_account_ip_allowlist` DISABLE KEYS */;
/*!40000 ALTER TABLE `smpp_account_ip_allowlist` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `smpp_accounts`
--

DROP TABLE IF EXISTS `smpp_accounts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `smpp_accounts` (
  `id` char(36) NOT NULL,
  `publicId` varchar(20) NOT NULL,
  `clientId` char(36) NOT NULL,
  `systemId` varchar(50) NOT NULL,
  `passwordHash` varchar(255) NOT NULL,
  `status` enum('ACTIVE','DISABLED','SUSPENDED') NOT NULL DEFAULT 'ACTIVE',
  `maxConcurrentBinds` int(11) NOT NULL DEFAULT 1,
  `enquireLinkInterval` int(11) NOT NULL DEFAULT 30,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `smpp_accounts_publicId_key` (`publicId`),
  UNIQUE KEY `smpp_accounts_systemId_key` (`systemId`),
  KEY `smpp_accounts_clientId_idx` (`clientId`),
  KEY `smpp_accounts_status_idx` (`status`),
  CONSTRAINT `smpp_accounts_clientId_fkey` FOREIGN KEY (`clientId`) REFERENCES `clients` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `smpp_accounts`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `smpp_accounts` WRITE;
/*!40000 ALTER TABLE `smpp_accounts` DISABLE KEYS */;
INSERT INTO `smpp_accounts` VALUES
('1c811499-df8e-4713-9628-de2c0e9c2178','demo-smpp','67c9b53f-b74e-43d0-859f-5349b5b9d0c7','DEMO_SMPP','<CHANGE_ME_HASH>','ACTIVE',1,30,'2026-08-07 08:49:57.850','2026-08-07 08:50:14.096'),
('3279c58f-e8c8-4ab0-b930-d676af54acf0','acme-smpp','9a8672a0-9bb4-425d-b30d-db7595b0eb22','ACME_SMPP','<CHANGE_ME_HASH>','ACTIVE',1,30,'2026-08-07 08:49:57.850','2026-08-07 08:50:14.096'),
('e793884f-3c39-493b-be95-45e3175b5bee','2DgQwmkAfQcvwQ','67c9b53f-b74e-43d0-859f-5349b5b9d0c7','test','c2d966c2797ddbd9419250092408622ad936552d530be80bfbfd4ce129b43be3','ACTIVE',10,5,'2026-09-04 14:21:10.689','2026-09-10 10:05:14.334');
/*!40000 ALTER TABLE `smpp_accounts` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `trusted_devices`
--

DROP TABLE IF EXISTS `trusted_devices`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `trusted_devices` (
  `id` char(36) NOT NULL,
  `userId` char(36) NOT NULL,
  `deviceId` varchar(64) NOT NULL,
  `deviceName` varchar(255) DEFAULT NULL,
  `userAgent` varchar(512) DEFAULT NULL,
  `ipAddress` varchar(45) DEFAULT NULL,
  `expiresAt` datetime(3) NOT NULL,
  `lastUsedAt` datetime(3) NOT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `trusted_devices_deviceId_key` (`deviceId`),
  KEY `trusted_devices_userId_idx` (`userId`),
  CONSTRAINT `trusted_devices_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `trusted_devices`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `trusted_devices` WRITE;
/*!40000 ALTER TABLE `trusted_devices` DISABLE KEYS */;
/*!40000 ALTER TABLE `trusted_devices` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `user_roles`
--

DROP TABLE IF EXISTS `user_roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_roles` (
  `userId` char(36) NOT NULL,
  `roleId` char(36) NOT NULL,
  `assignedAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  PRIMARY KEY (`userId`,`roleId`),
  KEY `user_roles_roleId_idx` (`roleId`),
  CONSTRAINT `user_roles_roleId_fkey` FOREIGN KEY (`roleId`) REFERENCES `roles` (`id`) ON UPDATE CASCADE,
  CONSTRAINT `user_roles_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_roles`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `user_roles` WRITE;
/*!40000 ALTER TABLE `user_roles` DISABLE KEYS */;
INSERT INTO `user_roles` VALUES
('00000000-0000-0000-0000-000000000015','9c2bb08e-0eb7-4fc4-930f-533d3989032f','2026-08-07 08:49:57.783');
/*!40000 ALTER TABLE `user_roles` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` char(36) NOT NULL,
  `clientId` char(36) NOT NULL,
  `firstName` varchar(100) NOT NULL,
  `lastName` varchar(100) NOT NULL,
  `username` varchar(100) NOT NULL,
  `email` varchar(255) NOT NULL,
  `passwordHash` varchar(255) NOT NULL,
  `status` enum('ACTIVE','LOCKED','DISABLED') NOT NULL DEFAULT 'ACTIVE',
  `lastLoginAt` datetime(3) DEFAULT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL,
  `emailVerifiedAt` datetime(3) DEFAULT NULL,
  `failedLoginAttempts` int(11) NOT NULL DEFAULT 0,
  `lockedUntil` datetime(3) DEFAULT NULL,
  `mfaEnabled` tinyint(1) NOT NULL DEFAULT 0,
  `phone` varchar(30) DEFAULT NULL,
  `phoneVerifiedAt` datetime(3) DEFAULT NULL,
  `preferredMfaMethod` enum('EMAIL','SMS') DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_username_key` (`username`),
  UNIQUE KEY `users_clientId_email_key` (`clientId`,`email`),
  UNIQUE KEY `users_email_key` (`email`),
  KEY `users_clientId_idx` (`clientId`),
  KEY `users_status_idx` (`status`),
  KEY `users_lastLoginAt_idx` (`lastLoginAt`),
  CONSTRAINT `users_clientId_fkey` FOREIGN KEY (`clientId`) REFERENCES `clients` (`id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES
('00000000-0000-0000-0000-000000000015','67c9b53f-b74e-43d0-859f-5349b5b9d0c7','Jack','Kiplagat','readonly-0015','blessings.bless.nyoni@gmail.com','$argon2id$v=19$m=19456,t=2,p=1$BU6ZhUrDCM1lnXrJLdrBNA$/JG4HujhktFZvMLDaBLhN5LDUTT4MOT29SLux4NoelI','ACTIVE','2026-09-18 23:31:40.308','2026-08-07 08:49:57.739','2026-09-18 23:31:40.310',NULL,0,NULL,1,NULL,NULL,'EMAIL');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `verification_challenges`
--

DROP TABLE IF EXISTS `verification_challenges`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `verification_challenges` (
  `id` char(36) NOT NULL,
  `userId` char(36) NOT NULL,
  `codeHash` varchar(255) NOT NULL,
  `purpose` enum('LOGIN','PASSWORD_RESET','EMAIL_VERIFICATION','PHONE_VERIFICATION') NOT NULL,
  `channel` enum('EMAIL','SMS') NOT NULL,
  `status` enum('PENDING','VERIFIED','EXPIRED','CANCELLED','FAILED') NOT NULL DEFAULT 'PENDING',
  `attempts` int(11) NOT NULL DEFAULT 0,
  `expiresAt` datetime(3) NOT NULL,
  `verifiedAt` datetime(3) DEFAULT NULL,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  PRIMARY KEY (`id`),
  KEY `verification_challenges_userId_idx` (`userId`),
  KEY `verification_challenges_expiresAt_idx` (`expiresAt`),
  KEY `verification_challenges_status_idx` (`status`),
  KEY `verification_challenges_userId_purpose_idx` (`userId`,`purpose`),
  CONSTRAINT `verification_challenges_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `verification_challenges`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `verification_challenges` WRITE;
/*!40000 ALTER TABLE `verification_challenges` DISABLE KEYS */;
INSERT INTO `verification_challenges` VALUES
('153d77c7-9744-45a1-83eb-9cd6f3b21bb0','00000000-0000-0000-0000-000000000015','4b1bde11f0f919ec663cb6faaed273314ab43fe7c4b36530eb9fe6af1682ea49','LOGIN','EMAIL','VERIFIED',0,'2026-09-17 00:54:10.547','2026-09-17 00:44:27.783','2026-09-17 00:44:10.548'),
('41709419-26ae-4201-8823-47dcf4c058f0','00000000-0000-0000-0000-000000000015','ae7c62029627facabb0ab56e0f032a2c4f10851b5d1b557fada4995c0fced724','LOGIN','EMAIL','VERIFIED',0,'2026-09-16 13:36:39.682','2026-09-16 13:27:00.888','2026-09-16 13:26:39.683'),
('4936c0b4-adcc-4669-b9c8-7a609b7b39d4','00000000-0000-0000-0000-000000000015','44da1ab28d43dcecff267140c94ad75a3989bd3bd0d6f404eb886c3e58aeb954','LOGIN','EMAIL','VERIFIED',0,'2026-09-17 14:05:43.014','2026-09-17 13:56:00.433','2026-09-17 13:55:43.015'),
('4cdddd30-1fb0-4dcf-b3de-4c5f02f19644','00000000-0000-0000-0000-000000000015','98d9b07cb7620fecb7d4101bb546cd6f9df9eb1d33289af321e002efe104b0e0','LOGIN','EMAIL','VERIFIED',0,'2026-09-17 14:42:59.855','2026-09-17 14:33:16.777','2026-09-17 14:32:59.856'),
('4d3a1d89-4f8a-485c-9020-7139467667f4','00000000-0000-0000-0000-000000000015','c60f1c221ad3a43836bbd2abe73bd149d4e7062de9928bb32f8a9d85712199ab','LOGIN','EMAIL','VERIFIED',0,'2026-09-16 21:01:01.888','2026-09-16 20:51:22.816','2026-09-16 20:51:01.889'),
('572907b6-0334-449d-b104-8db55333ec57','00000000-0000-0000-0000-000000000015','7c75ebd4057bdbfcc62650622fd2119e5dc7466dc66402b86275004db5163c13','LOGIN','EMAIL','VERIFIED',0,'2026-09-18 23:41:40.315','2026-09-18 23:31:55.400','2026-09-18 23:31:40.317'),
('5cbae126-0451-43e0-bf39-43af1396cf8e','00000000-0000-0000-0000-000000000015','56bdc3f964adaaf5eabc98bd8b2f773d26a2429af413ad5429e914f11d88bd15','LOGIN','EMAIL','VERIFIED',0,'2026-09-16 22:50:03.243','2026-09-16 22:40:18.050','2026-09-16 22:40:03.244'),
('7b7429c7-d891-4d6d-8847-f9d339c4fd37','00000000-0000-0000-0000-000000000015','9f77193bb0944e99485a47958007facc69f1453a07b94f40453c022313e864b1','LOGIN','EMAIL','VERIFIED',0,'2026-09-16 21:35:48.829','2026-09-16 21:26:04.259','2026-09-16 21:25:48.830'),
('b73dce6c-db8b-4ad6-b4c7-d8db5125daf6','00000000-0000-0000-0000-000000000015','2d9ab386b2265df2d0ad2325bbb14e47ddbbb9575317649a83a64061ddfae091','LOGIN','EMAIL','VERIFIED',0,'2026-09-17 14:53:46.060','2026-09-17 14:44:10.768','2026-09-17 14:43:46.061'),
('b7ee0f8d-fb38-490f-a953-6c47b2bc273d','00000000-0000-0000-0000-000000000015','b13dd9019fddea78dfb0634a4a17fd33f8ff31d745d554df54edcf878ca89a75','LOGIN','EMAIL','VERIFIED',0,'2026-09-18 00:23:22.514','2026-09-18 00:13:36.144','2026-09-18 00:13:22.514'),
('bfc82c55-47d1-4d90-9c1f-655f976f4882','00000000-0000-0000-0000-000000000015','96f9673506de2a75a0409b7adda82e0a49ab88944a560243980c2e33555412cf','LOGIN','EMAIL','VERIFIED',0,'2026-09-18 01:34:51.591','2026-09-18 01:25:06.429','2026-09-18 01:24:51.592'),
('c1411be9-95a5-4e62-a0a1-ae2b9a5df6db','00000000-0000-0000-0000-000000000015','28caac4ef26b6a5058637509117462fb07c0e51df8bb4c348178031f230a12c9','LOGIN','EMAIL','VERIFIED',0,'2026-09-16 10:56:28.537','2026-09-16 10:47:04.032','2026-09-16 10:46:28.538'),
('c1c1ce78-0f27-4642-b7ec-3c775d78d25c','00000000-0000-0000-0000-000000000015','cc21bc499245b69f075937668c95458bbd7e0230146d7af1fffdcb508cb449dd','LOGIN','EMAIL','VERIFIED',0,'2026-09-16 23:20:30.185','2026-09-16 23:10:44.413','2026-09-16 23:10:30.186'),
('d112c699-1866-40bc-b87b-ce2e054aed26','00000000-0000-0000-0000-000000000015','5f37b71cc3caee2892d9884b4582ccaeb2288c1d7e0e7e0d607466ef7c696831','LOGIN','EMAIL','VERIFIED',0,'2026-09-18 00:19:52.461','2026-09-18 00:10:06.085','2026-09-18 00:09:52.461'),
('dcccb26c-1b71-43b7-b104-9f9172d2cf9b','00000000-0000-0000-0000-000000000015','e076a11675c8759d902bc0b9075ab9db91556305cac5e6942aa65f111f22c69f','LOGIN','EMAIL','VERIFIED',0,'2026-09-16 10:25:11.978','2026-09-16 10:15:37.544','2026-09-16 10:15:11.978'),
('dd4c1c4f-d349-4c38-8b30-e426f09f933f','00000000-0000-0000-0000-000000000015','37d129581de55d751d6993899d16f7549856359bf559c58583f9b4c07a46ff59','LOGIN','EMAIL','VERIFIED',0,'2026-09-17 13:40:39.240','2026-09-17 13:31:11.167','2026-09-17 13:30:39.241'),
('e0120466-19c7-4d12-8a38-5b105405ae63','00000000-0000-0000-0000-000000000015','76fe316db4b73554b6cc1c10895c494aa13dc9d673a00a469e92821594e147a9','LOGIN','EMAIL','VERIFIED',0,'2026-09-17 13:56:00.345','2026-09-17 13:46:18.647','2026-09-17 13:46:00.346'),
('ea8b90f3-84bb-46d0-a850-788b73b49dd1','00000000-0000-0000-0000-000000000015','0038c7174e641bb77bf294a409f158862f5b7b28ea8ecead396935ef2306f2c0','LOGIN','EMAIL','VERIFIED',0,'2026-09-16 23:50:58.640','2026-09-16 23:41:20.393','2026-09-16 23:40:58.641');
/*!40000 ALTER TABLE `verification_challenges` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `webhook_deliveries`
--

DROP TABLE IF EXISTS `webhook_deliveries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `webhook_deliveries` (
  `id` char(36) NOT NULL,
  `webhookEndpointId` char(36) NOT NULL,
  `messageId` char(36) NOT NULL,
  `attemptNumber` int(11) NOT NULL DEFAULT 1,
  `responseCode` int(11) DEFAULT NULL,
  `responseBody` text DEFAULT NULL,
  `attemptedAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  PRIMARY KEY (`id`),
  KEY `webhook_deliveries_webhookEndpointId_idx` (`webhookEndpointId`),
  KEY `webhook_deliveries_messageId_idx` (`messageId`),
  CONSTRAINT `webhook_deliveries_messageId_fkey` FOREIGN KEY (`messageId`) REFERENCES `messages` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `webhook_deliveries_webhookEndpointId_fkey` FOREIGN KEY (`webhookEndpointId`) REFERENCES `webhook_endpoints` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `webhook_deliveries`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `webhook_deliveries` WRITE;
/*!40000 ALTER TABLE `webhook_deliveries` DISABLE KEYS */;
/*!40000 ALTER TABLE `webhook_deliveries` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `webhook_endpoints`
--

DROP TABLE IF EXISTS `webhook_endpoints`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `webhook_endpoints` (
  `id` char(36) NOT NULL,
  `publicId` varchar(20) NOT NULL,
  `clientId` char(36) NOT NULL,
  `name` varchar(100) NOT NULL,
  `url` varchar(2048) NOT NULL,
  `secret` varchar(255) NOT NULL,
  `enabled` tinyint(1) NOT NULL DEFAULT 1,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `webhook_endpoints_publicId_key` (`publicId`),
  KEY `webhook_endpoints_clientId_idx` (`clientId`),
  KEY `webhook_endpoints_enabled_idx` (`enabled`),
  CONSTRAINT `webhook_endpoints_clientId_fkey` FOREIGN KEY (`clientId`) REFERENCES `clients` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `webhook_endpoints`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `webhook_endpoints` WRITE;
/*!40000 ALTER TABLE `webhook_endpoints` DISABLE KEYS */;
/*!40000 ALTER TABLE `webhook_endpoints` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Dumping events for database 'sms_gateway'
--

--
-- Dumping routines for database 'sms_gateway'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*M!100616 SET NOTE_VERBOSITY=@OLD_NOTE_VERBOSITY */;

-- Dump completed on 2026-09-19  1:53:00
