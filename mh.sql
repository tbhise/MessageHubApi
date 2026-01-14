CREATE DATABASE  IF NOT EXISTS `message_hub` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `message_hub`;
-- MySQL dump 10.13  Distrib 8.0.36, for Win64 (x86_64)
--
-- Host: localhost    Database: message_hub
-- ------------------------------------------------------
-- Server version	8.3.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `contacts`
--

DROP TABLE IF EXISTS `contacts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `contacts` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `phonebook_id` int DEFAULT NULL,
  `phone_number` varchar(20) NOT NULL,
  `full_name` varchar(100) DEFAULT NULL,
  `last_message_at` datetime DEFAULT NULL,
  `source` enum('manual','phonebook','whatsapp') DEFAULT 'manual',
  `isDeleted` tinyint(1) DEFAULT '0',
  `deleted_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `created_by` int DEFAULT NULL,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `updated_by` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `phone_number` (`phone_number`) /*!80000 INVISIBLE */,
  UNIQUE KEY `uq_phonebook_phone` (`phonebook_id`,`phone_number`),
  KEY `Index` (`id`,`full_name`,`phone_number`,`isDeleted`,`created_at`,`phonebook_id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contacts`
--

LOCK TABLES `contacts` WRITE;
/*!40000 ALTER TABLE `contacts` DISABLE KEYS */;
INSERT INTO `contacts` VALUES (1,1,'911234567891','Tusharb',NULL,'phonebook',0,NULL,'2026-01-12 12:31:45',1,'2026-01-12 12:45:53',1),(2,1,'911234567892','Kunalb',NULL,'phonebook',0,NULL,'2026-01-12 12:31:45',1,'2026-01-12 12:45:53',1),(3,1,'911234567893','Saurabhg',NULL,'phonebook',0,NULL,'2026-01-12 12:31:45',1,'2026-01-12 12:45:53',1),(7,3,'911234567811','Tusharb1',NULL,'phonebook',0,NULL,'2026-01-12 14:31:45',1,'2026-01-12 14:43:23',1),(8,3,'911234567812','Kunalb1',NULL,'phonebook',0,NULL,'2026-01-12 14:31:45',1,'2026-01-12 14:43:23',1),(9,3,'911234567813','Saurabhg1',NULL,'phonebook',0,NULL,'2026-01-12 14:31:45',1,'2026-01-12 14:43:23',1);
/*!40000 ALTER TABLE `contacts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `phonebooks`
--

DROP TABLE IF EXISTS `phonebooks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `phonebooks` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `total_contacts` int unsigned NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `created_by` int unsigned DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `updated_by` int unsigned DEFAULT NULL,
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `idx_phonebooks_name` (`name`),
  KEY `idx_phonebooks_created_at` (`created_at`),
  KEY `idx_phonebooks_is_deleted` (`is_deleted`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `phonebooks`
--

LOCK TABLES `phonebooks` WRITE;
/*!40000 ALTER TABLE `phonebooks` DISABLE KEYS */;
INSERT INTO `phonebooks` VALUES (1,'test2','test2',3,'2026-01-12 12:31:44',1,'2026-01-12 12:31:44',1,0),(3,'test 3','test 3',3,'2026-01-12 14:31:44',1,'2026-01-12 14:31:44',1,0);
/*!40000 ALTER TABLE `phonebooks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `template_buttons`
--

DROP TABLE IF EXISTS `template_buttons`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `template_buttons` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `template_id` bigint unsigned NOT NULL,
  `type` enum('PHONE_NUMBER','URL','QUICK_REPLY') NOT NULL,
  `text` varchar(25) NOT NULL,
  `phone_number` varchar(20) DEFAULT NULL,
  `url` varchar(2048) DEFAULT NULL,
  `ui_type` enum('COPY') DEFAULT NULL,
  `copy_value` varchar(255) DEFAULT NULL,
  `position` int NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `template_id` (`template_id`),
  CONSTRAINT `template_buttons_ibfk_1` FOREIGN KEY (`template_id`) REFERENCES `templates` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `template_buttons`
--

LOCK TABLES `template_buttons` WRITE;
/*!40000 ALTER TABLE `template_buttons` DISABLE KEYS */;
INSERT INTO `template_buttons` VALUES (1,1,'PHONE_NUMBER','Call us','+919284581330',NULL,NULL,NULL,0,'2026-01-14 09:48:35'),(2,1,'URL','Visit Us',NULL,'http://tusharb.live.com/',NULL,NULL,1,'2026-01-14 09:48:35'),(3,1,'QUICK_REPLY','Test Quick Reply',NULL,NULL,NULL,NULL,2,'2026-01-14 09:48:35'),(4,1,'QUICK_REPLY','Copy',NULL,NULL,NULL,NULL,3,'2026-01-14 09:48:35');
/*!40000 ALTER TABLE `template_buttons` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `template_meta_logs`
--

DROP TABLE IF EXISTS `template_meta_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `template_meta_logs` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `template_id` bigint unsigned NOT NULL,
  `meta_status` varchar(30) DEFAULT NULL,
  `meta_response` json DEFAULT NULL,
  `error_message` text,
  `synced_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `template_id` (`template_id`),
  CONSTRAINT `template_meta_logs_ibfk_1` FOREIGN KEY (`template_id`) REFERENCES `templates` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `template_meta_logs`
--

LOCK TABLES `template_meta_logs` WRITE;
/*!40000 ALTER TABLE `template_meta_logs` DISABLE KEYS */;
INSERT INTO `template_meta_logs` VALUES (1,1,'PENDING','{\"id\": \"2432722333845593\", \"name\": \"welcome_template\", \"status\": \"PENDING\", \"category\": \"MARKETING\", \"language\": \"en_GB\", \"components\": [{\"text\": \"Hello,\", \"type\": \"HEADER\", \"format\": \"TEXT\"}, {\"text\": \"This is welcome template.\", \"type\": \"BODY\"}, {\"text\": \"Thanks and Regards.\", \"type\": \"FOOTER\"}, {\"type\": \"BUTTONS\", \"buttons\": [{\"text\": \"Call us\", \"type\": \"PHONE_NUMBER\", \"phone_number\": \"+919284581330\"}, {\"url\": \"http://tusharb.live.com/\", \"text\": \"Visit Us\", \"type\": \"URL\"}, {\"text\": \"Test Quick Reply\", \"type\": \"QUICK_REPLY\"}, {\"text\": \"Copy\", \"type\": \"QUICK_REPLY\"}]}], \"parameter_format\": \"POSITIONAL\", \"previous_category\": \"UTILITY\"}',NULL,'2026-01-14 09:48:35'),(2,2,'APPROVED','{\"id\": \"2896829040507753\", \"name\": \"account_update_info\", \"status\": \"APPROVED\", \"category\": \"UTILITY\", \"language\": \"en_US\", \"components\": [{\"text\": \"Your account has been successfully updated. If you did not request this change, please contact our support team.\", \"type\": \"BODY\"}], \"parameter_format\": \"POSITIONAL\"}',NULL,'2026-01-14 09:48:35'),(3,3,'APPROVED','{\"id\": \"857446247265772\", \"name\": \"hello_world\", \"status\": \"APPROVED\", \"category\": \"UTILITY\", \"language\": \"en_US\", \"components\": [{\"text\": \"Hello World\", \"type\": \"HEADER\", \"format\": \"TEXT\"}, {\"text\": \"Welcome and congratulations!! This message demonstrates your ability to send a WhatsApp message notification from the Cloud API, hosted by Meta. Thank you for taking the time to test with us.\", \"type\": \"BODY\"}, {\"text\": \"WhatsApp Business Platform sample message\", \"type\": \"FOOTER\"}], \"parameter_format\": \"POSITIONAL\"}',NULL,'2026-01-14 09:48:35'),(4,7,'PENDING','{\"id\": \"860303133649243\", \"status\": \"PENDING\", \"category\": \"UTILITY\"}',NULL,'2026-01-14 12:27:16');
/*!40000 ALTER TABLE `template_meta_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `templates`
--

DROP TABLE IF EXISTS `templates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `templates` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `meta_template_id` varchar(50) DEFAULT NULL,
  `name` varchar(512) NOT NULL,
  `language` varchar(10) NOT NULL,
  `category` enum('MARKETING','UTILITY','AUTHENTICATION') NOT NULL,
  `previous_category` enum('MARKETING','UTILITY','AUTHENTICATION') DEFAULT NULL,
  `status` enum('DRAFT','PENDING','APPROVED','REJECTED','PAUSED') NOT NULL DEFAULT 'DRAFT',
  `header_type` enum('none','text','image','video','document') DEFAULT 'none',
  `header_text` varchar(60) DEFAULT NULL,
  `body_text` text NOT NULL,
  `footer_text` varchar(60) DEFAULT NULL,
  `header_file_path` varchar(255) DEFAULT NULL,
  `parameter_format` enum('POSITIONAL','NAMED') DEFAULT 'POSITIONAL',
  `created_by` bigint unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_meta_template_id` (`meta_template_id`),
  KEY `idx_status` (`status`),
  KEY `idx_category` (`category`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `templates`
--

LOCK TABLES `templates` WRITE;
/*!40000 ALTER TABLE `templates` DISABLE KEYS */;
INSERT INTO `templates` VALUES (1,'2432722333845593','welcome_template','en_GB','MARKETING','UTILITY','PENDING','text','Hello,','This is welcome template.','Thanks and Regards.',NULL,'POSITIONAL',1,'2026-01-14 09:48:35','2026-01-14 09:48:35'),(2,'2896829040507753','account_update_info','en_US','UTILITY',NULL,'APPROVED','none',NULL,'Your account has been successfully updated. If you did not request this change, please contact our support team.',NULL,NULL,'POSITIONAL',1,'2026-01-14 09:48:35','2026-01-14 09:48:35'),(3,'857446247265772','hello_world','en_US','UTILITY',NULL,'APPROVED','text','Hello World','Welcome and congratulations!! This message demonstrates your ability to send a WhatsApp message notification from the Cloud API, hosted by Meta. Thank you for taking the time to test with us.','WhatsApp Business Platform sample message',NULL,'POSITIONAL',1,'2026-01-14 09:48:35','2026-01-14 09:48:35'),(7,'860303133649243','test_template','hi','UTILITY','UTILITY','PENDING','text','यूटिलिटी टेस्टिंग संदेश','यह एक परीक्षण संदेश है।\r\nकृपया पुष्टि करें कि यूटिलिटी सेवा/सिस्टम सही तरीके से कार्य कर रहा है।\r\nयदि यह संदेश आपको प्राप्त हो गया है, तो परीक्षण सफल माना जाएगा।','धन्यवाद।',NULL,'POSITIONAL',1,'2026-01-14 12:27:14','2026-01-14 12:27:16');
/*!40000 ALTER TABLE `templates` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `Id` int NOT NULL AUTO_INCREMENT,
  `Username` varchar(45) DEFAULT NULL,
  `Password` varchar(255) DEFAULT NULL,
  `Indate` datetime DEFAULT NULL,
  `IsActive` bit(1) DEFAULT NULL,
  PRIMARY KEY (`Id`),
  KEY `index` (`Id`,`Username`,`Password`,`Indate`,`IsActive`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'Tusharb','$2b$10$enk3yc1OdInuj2hB64/AY.D7WUf5BCNK9ONLWNrdFFU55T277dVPG','2026-01-09 16:35:00',_binary '');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'message_hub'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-01-14 18:31:15
