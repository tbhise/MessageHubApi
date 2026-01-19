CREATE DATABASE  IF NOT EXISTS `message_hub` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `message_hub`;
-- MySQL dump 10.13  Distrib 8.0.41, for Win64 (x86_64)
--
-- Host: localhost    Database: message_hub
-- ------------------------------------------------------
-- Server version	8.0.41

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
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contacts`
--

LOCK TABLES `contacts` WRITE;
/*!40000 ALTER TABLE `contacts` DISABLE KEYS */;
INSERT INTO `contacts` VALUES (1,1,'911234567891','Tusharb',NULL,'phonebook',0,NULL,'2026-01-12 12:31:45',1,'2026-01-12 12:45:53',1),(2,1,'911234567892','Kunalb',NULL,'phonebook',0,NULL,'2026-01-12 12:31:45',1,'2026-01-12 12:45:53',1),(3,1,'911234567893','Saurabhg',NULL,'phonebook',0,NULL,'2026-01-12 12:31:45',1,'2026-01-12 12:45:53',1),(7,3,'911234567811','Tusharb1',NULL,'phonebook',0,NULL,'2026-01-12 14:31:45',1,'2026-01-12 14:43:23',1),(8,3,'911234567812','Kunalb1',NULL,'phonebook',0,NULL,'2026-01-12 14:31:45',1,'2026-01-12 14:43:23',1),(9,3,'911234567813','Saurabhg1',NULL,'phonebook',0,NULL,'2026-01-12 14:31:45',1,'2026-01-12 14:43:23',1),(13,NULL,'917777777777','Tushar Bhise2',NULL,'manual',0,NULL,'2026-01-15 20:43:58',1,'2026-01-15 20:43:58',1),(14,5,'919293949596','John',NULL,'phonebook',0,NULL,'2026-01-15 21:34:25',1,'2026-01-15 21:34:25',1),(15,5,'919696969393','Tusharb',NULL,'phonebook',0,NULL,'2026-01-15 21:34:25',1,'2026-01-15 21:34:25',1),(16,5,'919284581330','test',NULL,'phonebook',0,NULL,'2026-01-15 21:34:25',1,'2026-01-15 21:34:25',1),(17,5,'917083555377','test2',NULL,'phonebook',0,NULL,'2026-01-15 21:34:25',1,'2026-01-15 21:34:25',1);
/*!40000 ALTER TABLE `contacts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `message_logs`
--

DROP TABLE IF EXISTS `message_logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `message_logs` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `message_id` varchar(100) DEFAULT NULL,
  `mobile` varchar(20) DEFAULT NULL,
  `template_id` int DEFAULT NULL,
  `status` varchar(20) DEFAULT NULL,
  `error_message` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `message_id` (`message_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `message_logs`
--

LOCK TABLES `message_logs` WRITE;
/*!40000 ALTER TABLE `message_logs` DISABLE KEYS */;
/*!40000 ALTER TABLE `message_logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `phonebooks`
--

DROP TABLE IF EXISTS `phonebooks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `phonebooks` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
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
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `phonebooks`
--

LOCK TABLES `phonebooks` WRITE;
/*!40000 ALTER TABLE `phonebooks` DISABLE KEYS */;
INSERT INTO `phonebooks` VALUES (1,'test2','test2',3,'2026-01-12 12:31:44',1,'2026-01-12 12:31:44',1,0),(3,'test 3','test 3',3,'2026-01-12 14:31:44',1,'2026-01-12 14:31:44',1,0),(5,'Test Phonebook','Test Phonebook ',4,'2026-01-15 21:34:25',1,'2026-01-15 21:34:25',1,0);
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
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `template_buttons`
--

LOCK TABLES `template_buttons` WRITE;
/*!40000 ALTER TABLE `template_buttons` DISABLE KEYS */;
INSERT INTO `template_buttons` VALUES (1,8,'URL','Visit order details',NULL,'https://developers.facebook.com/docs/whatsapp/business-management-api/message-templates/utility-templates',NULL,NULL,0,'2026-01-17 06:57:15'),(2,9,'URL','Get free delivery',NULL,'https://developers.facebook.com/docs/whatsapp/business-management-api/message-templates/utility-templates',NULL,NULL,0,'2026-01-17 06:57:15'),(3,11,'URL','Get free delivery',NULL,'https://developers.facebook.com/docs/whatsapp/business-management-api/message-templates/utility-templates',NULL,NULL,0,'2026-01-17 06:57:15');
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
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `template_meta_logs`
--

LOCK TABLES `template_meta_logs` WRITE;
/*!40000 ALTER TABLE `template_meta_logs` DISABLE KEYS */;
INSERT INTO `template_meta_logs` VALUES (1,8,'APPROVED','{\"id\": \"2536988313363353\", \"name\": \"jaspers_market_order_confirmation_v1\", \"status\": \"APPROVED\", \"category\": \"UTILITY\", \"language\": \"en_US\", \"components\": [{\"text\": \"Order confirmed\", \"type\": \"HEADER\", \"format\": \"TEXT\"}, {\"text\": \"Hi {{1}},\\n\\nThank you for your purchase! Your order number is {{2}}.\\n\\nWe\'ll start getting your farm fresh groceries ready to ship.\\n\\nEstimated delivery:  {{3}}.\\n\\nWe will let you know when your order ships.\", \"type\": \"BODY\"}, {\"text\": \"developers.facebook.com\", \"type\": \"FOOTER\"}, {\"type\": \"BUTTONS\", \"buttons\": [{\"url\": \"https://developers.facebook.com/docs/whatsapp/business-management-api/message-templates/utility-templates\", \"text\": \"Visit order details\", \"type\": \"URL\"}]}], \"parameter_format\": \"POSITIONAL\"}',NULL,'2026-01-17 06:57:15'),(2,9,'APPROVED','{\"id\": \"1813419192710892\", \"name\": \"jaspers_market_media_carousel_v1\", \"status\": \"APPROVED\", \"category\": \"MARKETING\", \"language\": \"en_US\", \"components\": [{\"text\": \"Our in-house chefs have prepared some delicious and fresh summer recipes.\", \"type\": \"BODY\"}, {\"type\": \"BUTTONS\", \"buttons\": [{\"url\": \"https://developers.facebook.com/docs/whatsapp/business-management-api/message-templates/utility-templates\", \"text\": \"Get free delivery\", \"type\": \"URL\"}]}, {\"type\": \"CAROUSEL\", \"cards\": [{\"components\": [{\"type\": \"HEADER\", \"format\": \"IMAGE\"}, {\"text\": \"Simple and Healthy Sheet Pan Dinner to Feed the Whole Family\", \"type\": \"BODY\"}, {\"type\": \"BUTTONS\", \"buttons\": [{\"url\": \"https://developers.facebook.com/docs/whatsapp/business-management-api/message-templates/media-card-carousel-templates\", \"text\": \"Get this recipe\", \"type\": \"URL\"}]}]}, {\"components\": [{\"type\": \"HEADER\", \"format\": \"IMAGE\"}, {\"text\": \"3 Plant-Powered Salad Bowls to Fuel Your Week\", \"type\": \"BODY\"}, {\"type\": \"BUTTONS\", \"buttons\": [{\"url\": \"https://developers.facebook.com/docs/whatsapp/business-management-api/message-templates/media-card-carousel-templates\", \"text\": \"Get this recipe\", \"type\": \"URL\"}]}]}]}], \"parameter_format\": \"POSITIONAL\"}',NULL,'2026-01-17 06:57:15'),(3,10,'APPROVED','{\"id\": \"1578042076655224\", \"name\": \"jaspers_market_plain_text_v1\", \"status\": \"APPROVED\", \"category\": \"MARKETING\", \"language\": \"en_US\", \"components\": [{\"text\": \"Welcome to Jasper’s Market, your local grocery store providing farm-fresh produce and high-quality goods!\", \"type\": \"BODY\"}], \"parameter_format\": \"POSITIONAL\", \"previous_category\": \"UTILITY\"}',NULL,'2026-01-17 06:57:15'),(4,11,'APPROVED','{\"id\": \"1229416082464429\", \"name\": \"jaspers_market_image_cta_v1\", \"status\": \"APPROVED\", \"category\": \"MARKETING\", \"language\": \"en_US\", \"components\": [{\"type\": \"HEADER\", \"format\": \"IMAGE\"}, {\"text\": \"Free delivery for all online orders with Jasper\'s Market\", \"type\": \"BODY\"}, {\"text\": \"developers.facebook.com\", \"type\": \"FOOTER\"}, {\"type\": \"BUTTONS\", \"buttons\": [{\"url\": \"https://developers.facebook.com/docs/whatsapp/business-management-api/message-templates/utility-templates\", \"text\": \"Get free delivery\", \"type\": \"URL\"}]}], \"parameter_format\": \"POSITIONAL\"}',NULL,'2026-01-17 06:57:15'),(5,12,'APPROVED','{\"id\": \"3008168959375455\", \"name\": \"hello_world\", \"status\": \"APPROVED\", \"category\": \"UTILITY\", \"language\": \"en_US\", \"components\": [{\"text\": \"Hello World\", \"type\": \"HEADER\", \"format\": \"TEXT\"}, {\"text\": \"Welcome and congratulations!! This message demonstrates your ability to send a WhatsApp message notification from the Cloud API, hosted by Meta. Thank you for taking the time to test with us.\", \"type\": \"BODY\"}, {\"text\": \"WhatsApp Business Platform sample message\", \"type\": \"FOOTER\"}], \"parameter_format\": \"POSITIONAL\"}',NULL,'2026-01-17 06:57:15'),(6,22,'PENDING','{\"id\": \"896580506235265\", \"status\": \"PENDING\", \"category\": \"MARKETING\"}',NULL,'2026-01-18 13:45:04');
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
  `components` json NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_meta_template_id` (`meta_template_id`),
  KEY `idx_status` (`status`),
  KEY `idx_category` (`category`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `templates`
--

LOCK TABLES `templates` WRITE;
/*!40000 ALTER TABLE `templates` DISABLE KEYS */;
INSERT INTO `templates` VALUES (8,'2536988313363353','jaspers_market_order_confirmation_v1','en_US','UTILITY',NULL,'APPROVED','text','Order confirmed','Hi {{1}},\n\nThank you for your purchase! Your order number is {{2}}.\n\nWe\'ll start getting your farm fresh groceries ready to ship.\n\nEstimated delivery:  {{3}}.\n\nWe will let you know when your order ships.','developers.facebook.com',NULL,'POSITIONAL',1,'2026-01-17 06:57:15','2026-01-17 06:57:15','null'),(9,'1813419192710892','jaspers_market_media_carousel_v1','en_US','MARKETING',NULL,'APPROVED','none',NULL,'Our in-house chefs have prepared some delicious and fresh summer recipes.',NULL,NULL,'POSITIONAL',1,'2026-01-17 06:57:15','2026-01-17 06:57:15','null'),(10,'1578042076655224','jaspers_market_plain_text_v1','en_US','MARKETING','UTILITY','APPROVED','none',NULL,'Welcome to Jasper’s Market, your local grocery store providing farm-fresh produce and high-quality goods!',NULL,NULL,'POSITIONAL',1,'2026-01-17 06:57:15','2026-01-17 06:57:15','null'),(11,'1229416082464429','jaspers_market_image_cta_v1','en_US','MARKETING',NULL,'APPROVED','image',NULL,'Free delivery for all online orders with Jasper\'s Market','developers.facebook.com',NULL,'POSITIONAL',1,'2026-01-17 06:57:15','2026-01-17 06:57:15','null'),(12,'3008168959375455','hello_world','en_US','UTILITY',NULL,'APPROVED','text','Hello World','Welcome and congratulations!! This message demonstrates your ability to send a WhatsApp message notification from the Cloud API, hosted by Meta. Thank you for taking the time to test with us.','WhatsApp Business Platform sample message',NULL,'POSITIONAL',1,'2026-01-17 06:57:15','2026-01-17 06:57:15','null'),(22,'896580506235265','welcome','en_US','UTILITY','UTILITY','PENDING','text','Hello ','This is welcome template .','Thanks',NULL,'POSITIONAL',1,'2026-01-18 13:44:58','2026-01-18 13:45:04','null');
/*!40000 ALTER TABLE `templates` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_whatsapp_numbers`
--

DROP TABLE IF EXISTS `user_whatsapp_numbers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_whatsapp_numbers` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint unsigned NOT NULL,
  `whatsapp_phone_id` bigint unsigned NOT NULL,
  `role` enum('owner','member') DEFAULT 'owner',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_user_phone` (`user_id`,`whatsapp_phone_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_whatsapp_numbers`
--

LOCK TABLES `user_whatsapp_numbers` WRITE;
/*!40000 ALTER TABLE `user_whatsapp_numbers` DISABLE KEYS */;
INSERT INTO `user_whatsapp_numbers` VALUES (1,1,1,'owner','2026-01-17 08:48:13');
/*!40000 ALTER TABLE `user_whatsapp_numbers` ENABLE KEYS */;
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
-- Table structure for table `whatsapp_phone_numbers`
--

DROP TABLE IF EXISTS `whatsapp_phone_numbers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `whatsapp_phone_numbers` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `meta_phone_number_id` bigint unsigned NOT NULL,
  `display_phone_number` varchar(20) NOT NULL,
  `verified_name` varchar(100) DEFAULT NULL,
  `waba_id` bigint unsigned NOT NULL,
  `is_test_number` tinyint(1) DEFAULT '1',
  `status` enum('active','inactive') DEFAULT 'active',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_meta_phone_number` (`meta_phone_number_id`),
  KEY `idx_waba_id` (`waba_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `whatsapp_phone_numbers`
--

LOCK TABLES `whatsapp_phone_numbers` WRITE;
/*!40000 ALTER TABLE `whatsapp_phone_numbers` DISABLE KEYS */;
INSERT INTO `whatsapp_phone_numbers` VALUES (1,955055311022831,'15551701330','Test Number',824236077330788,1,'active','2026-01-17 08:41:59','2026-01-17 08:48:13');
/*!40000 ALTER TABLE `whatsapp_phone_numbers` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-01-19 22:16:44
