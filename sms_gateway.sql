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
('50bb995c-103a-4340-96c2-5252edfca0e0','messages.create','messages','Send SMS messages.','2026-09-10 11:07:28.326','2026-09-14 13:45:55.076'),
('993d2e2d-419a-44bd-8911-7f74b566125c','messages.read','messages','View messages.','2026-09-10 11:07:28.335','2026-09-14 13:45:55.084'),
('e1744171-860f-4513-abd3-1ee26583c2e2','messages.status.read','messages','View message delivery status.','2026-09-10 11:07:28.340','2026-09-14 13:45:55.088');
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
('9f1c99a7-9e8e-11f1-a1a3-84144d0a7d3c','CON-ONFON','Onfon','onfon','Onfon','HTTP','ACTIVE','{\"baseUrl\":\"https://api.onfonmedia.co.ke\",\"sendPath\":\"/v1/sms/SendBulkSMS\",\"method\":\"POST\",\"authentication\":{\"type\":\"API_KEY\",\"header\":\"AccessKey\",\"value\":\"E9n0J6NtMb06E8BpfzBJUNFap0ofX9lJ\"},\"connectTimeout\":10000,\"requestTimeout\":30000,\"reconnectDelay\":1000,\"maxReconnectDelay\":30000,\"headers\":{\"Content-Type\":\"application/json\"},\"providerConfiguration\":{\"ApiKey\":\"adc0n3ct\",\"ClientId\":\"adcconnect\"}}','2026-08-23 03:04:41.000','2026-09-14 11:25:25.866'),
('9f1c99e5-9e8e-11f1-a1a3-84144d0a7d3c','CON-AT','Africa\'s Talking Ghana','africastalking-ghana','africastalking-ghana','HTTP','ACTIVE','{\"baseUrl\":\"https://api.africastalking.com\",\"sendPath\":\"/version1/messaging/bulk\",\"method\":\"POST\",\"authentication\":{\"type\":\"API_KEY\",\"header\":\"apiKey\",\"value\":\"atsk_774845c6e1de7bd2a876a59970af8e513cba75ba041469788b5ad3360d7fb443cfed6a33\"},\"connectTimeout\":10000,\"requestTimeout\":30000,\"reconnectDelay\":1000,\"maxReconnectDelay\":30000,\"headers\":{\"Accept\":\"application/json\",\"Content-Type\":\"application/json\"},\"providerConfiguration\":{\"username\":\"ghanasmsroot\"}}','2026-08-23 03:04:41.000','2026-09-14 09:43:50.925'),
('aecc114f-8f58-4002-84d0-159995fc9c97','ROUTE_SMS','Route SMS','ROUTE_SMS','route-mobile','HTTP','ACTIVE','{\"baseUrl\":\"http://api.rmlconnect.net\",\"sendPath\":\"/bulksms/bulksms?username={USER}&password={PASS}&type={type}&dlr={dlr}&destination={DEST}&source={SOUR}&message={MSG}\",\"method\":\"GET\",\"authentication\":{\"type\":\"NONE\"},\"connectTimeout\":5000,\"requestTimeout\":30000,\"reconnectDelay\":1000,\"maxReconnectDelay\":30000,\"headers\":{\"Accept\":\"text/plain\"},\"username\":\"Africadcl\",\"password\":\"TSkoMk1C\",\"type\":\"0\",\"dlr\":\"1\"}','2026-09-13 09:45:29.564','2026-09-13 10:21:48.446'),
('c4d0d250-65cf-4638-87f3-0005a4ee4e19','AFRICASTALKING_KENYA','Africa\'s Talking Kenya','africastalking-kenya','africastalking-kenya','HTTP','ACTIVE','{\"baseUrl\":\"https://api.africastalking.com\",\"sendPath\":\"/version1/messaging/bulk\",\"method\":\"POST\",\"authentication\":{\"type\":\"API_KEY\",\"header\":\"apiKey\",\"value\":\"atsk_d196f0a6c3c43c3bca4306695562554c151341463075900e723e77ed3566e535a1b485fc\"},\"connectTimeout\":10000,\"requestTimeout\":30000,\"reconnectDelay\":1000,\"maxReconnectDelay\":30000,\"headers\":{\"Accept\":\"application/json\",\"Content-Type\":\"application/json\"},\"providerConfiguration\":{\"username\":\"kenyasbulk\"}}','2026-09-14 09:48:31.561','2026-09-14 09:48:31.561');
/*!40000 ALTER TABLE `connectors` ENABLE KEYS */;
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
/*!40000 ALTER TABLE `messages` ENABLE KEYS */;
UNLOCK TABLES;
COMMIT;
SET AUTOCOMMIT=@OLD_AUTOCOMMIT;

--
-- Table structure for table `mobile_network_prefixes`
--

DROP TABLE IF EXISTS `mobile_network_prefixes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `mobile_network_prefixes` (
  `id` char(36) NOT NULL,
  `mobileNetworkId` char(36) NOT NULL,
  `prefix` varchar(20) NOT NULL,
  `countryCode` char(2) NOT NULL,
  `enabled` tinyint(1) NOT NULL DEFAULT 1,
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `mobile_network_prefixes_countryCode_prefix_key` (`countryCode`,`prefix`),
  KEY `mobile_network_prefixes_mobileNetworkId_idx` (`mobileNetworkId`),
  KEY `mobile_network_prefixes_prefix_idx` (`prefix`),
  KEY `mobile_network_prefixes_enabled_idx` (`enabled`),
  CONSTRAINT `mobile_network_prefixes_mobileNetworkId_fkey` FOREIGN KEY (`mobileNetworkId`) REFERENCES `mobile_networks` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mobile_network_prefixes`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `mobile_network_prefixes` WRITE;
/*!40000 ALTER TABLE `mobile_network_prefixes` DISABLE KEYS */;
/*!40000 ALTER TABLE `mobile_network_prefixes` ENABLE KEYS */;
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
  `countryCode` char(2) NOT NULL,
  `status` enum('ACTIVE','DISABLED') NOT NULL DEFAULT 'ACTIVE',
  `createdAt` datetime(3) NOT NULL DEFAULT current_timestamp(3),
  `updatedAt` datetime(3) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `mobile_networks_publicId_key` (`publicId`),
  UNIQUE KEY `mobile_networks_code_key` (`code`),
  KEY `mobile_networks_countryCode_idx` (`countryCode`),
  KEY `mobile_networks_status_idx` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mobile_networks`
--

SET @OLD_AUTOCOMMIT=@@AUTOCOMMIT, @@AUTOCOMMIT=0;
LOCK TABLES `mobile_networks` WRITE;
/*!40000 ALTER TABLE `mobile_networks` DISABLE KEYS */;
INSERT INTO `mobile_networks` VALUES
('9f1af7b6-9e8e-11f1-a1a3-84144d0a7d3c','MNO-AIRTEL-MW','Airtel Malawi','AIRTEL_MW','MW','ACTIVE','2026-08-23 03:04:41.000','2026-09-02 01:06:19.476'),
('9f1afd32-9e8e-11f1-a1a3-84144d0a7d3c','MNO-TNM-MW','TNM Malawi','TNM_MW','MW','ACTIVE','2026-08-23 03:04:41.000','2026-08-23 03:04:41.000');
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
('d7e83a9d-ab92-48ac-b740-3806973d74ed','roles.delete','roles','Delete roles.','2026-08-12 02:05:50.771'),
('df11cc61-2c3b-42c3-b751-ac6095464572','sender_ids.create','sender_ids','Create Sender IDs.','2026-08-20 17:50:30.352'),
('e24e4377-0532-44b9-85d0-60e47ae9a46c','clients.create','clients','Create clients.','2026-08-20 17:50:30.333'),
('e3e34f82-9780-4259-8b76-18b469664f1a','webhooks:delete','webhooks','Delete webhook endpoints.','2026-08-20 17:50:30.431'),
('e5604522-5848-445e-932b-b41b075a75f2','mobile_networks.disable','mobile_networks','Disable mobile networks.','2026-09-01 23:29:48.817'),
('e9bf5ed4-1bed-49d4-a5bd-fd3463883b18','clients.update','clients','Update clients.','2026-08-20 17:50:30.335'),
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
('9c2bb08e-0eb7-4fc4-930f-533d3989032f','d7e83a9d-ab92-48ac-b740-3806973d74ed','2026-08-23 16:03:36.000'),
('9c2bb08e-0eb7-4fc4-930f-533d3989032f','df11cc61-2c3b-42c3-b751-ac6095464572','2026-08-23 16:03:36.000'),
('9c2bb08e-0eb7-4fc4-930f-533d3989032f','e24e4377-0532-44b9-85d0-60e47ae9a46c','2026-08-23 16:03:36.000'),
('9c2bb08e-0eb7-4fc4-930f-533d3989032f','e3e34f82-9780-4259-8b76-18b469664f1a','2026-08-23 16:03:36.000'),
('9c2bb08e-0eb7-4fc4-930f-533d3989032f','e5604522-5848-445e-932b-b41b075a75f2','2026-09-02 02:27:08.605'),
('9c2bb08e-0eb7-4fc4-930f-533d3989032f','e9bf5ed4-1bed-49d4-a5bd-fd3463883b18','2026-08-23 16:03:36.000'),
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
('00000000-0000-0000-0000-000000000015','67c9b53f-b74e-43d0-859f-5349b5b9d0c7','Jack','Kiplagat','readonly-0015','blessings.bless.nyoni@gmail.com','$argon2id$v=19$m=19456,t=2,p=1$BU6ZhUrDCM1lnXrJLdrBNA$/JG4HujhktFZvMLDaBLhN5LDUTT4MOT29SLux4NoelI','ACTIVE','2026-09-14 11:22:42.484','2026-08-07 08:49:57.739','2026-09-14 11:22:42.485',NULL,0,NULL,1,NULL,NULL,'EMAIL');
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
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*M!100616 SET NOTE_VERBOSITY=@OLD_NOTE_VERBOSITY */;

-- Dump completed on 2026-09-14 15:59:16
