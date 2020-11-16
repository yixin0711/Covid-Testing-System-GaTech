-- MySQL dump 10.13  Distrib 8.0.21, for macos10.15 (x86_64)
--
-- Host: localhost    Database: covidtest_fall2020
-- ------------------------------------------------------
-- Server version	8.0.21

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
-- Table structure for table `ADMINISTRATOR`
--

DROP TABLE IF EXISTS `ADMINISTRATOR`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ADMINISTRATOR` (
  `admin_username` varchar(40) NOT NULL,
  PRIMARY KEY (`admin_username`),
  CONSTRAINT `administrator_ibfk_1` FOREIGN KEY (`admin_username`) REFERENCES `USER` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ADMINISTRATOR`
--

LOCK TABLES `ADMINISTRATOR` WRITE;
/*!40000 ALTER TABLE `ADMINISTRATOR` DISABLE KEYS */;
INSERT INTO `ADMINISTRATOR` (`admin_username`) VALUES ('jlionel666'),('lchen27'),('mmoss7');
/*!40000 ALTER TABLE `ADMINISTRATOR` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `APPOINTMENT`
--

DROP TABLE IF EXISTS `APPOINTMENT`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `APPOINTMENT` (
  `username` varchar(40) DEFAULT NULL,
  `site_name` varchar(40) NOT NULL,
  `appt_date` date NOT NULL,
  `appt_time` time NOT NULL,
  PRIMARY KEY (`site_name`,`appt_date`,`appt_time`),
  KEY `username` (`username`),
  CONSTRAINT `appointment_ibfk_1` FOREIGN KEY (`username`) REFERENCES `STUDENT` (`student_username`),
  CONSTRAINT `appointment_ibfk_2` FOREIGN KEY (`site_name`) REFERENCES `SITE` (`site_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `APPOINTMENT`
--

LOCK TABLES `APPOINTMENT` WRITE;
/*!40000 ALTER TABLE `APPOINTMENT` DISABLE KEYS */;
INSERT INTO `APPOINTMENT` (`username`, `site_name`, `appt_date`, `appt_time`) VALUES (NULL,'Bobby Dodd Stadium','2020-09-16','12:00:00'),(NULL,'Bobby Dodd Stadium','2020-10-01','11:00:00'),(NULL,'Bobby Dodd Stadium','2020-10-07','13:00:00'),(NULL,'Caddell Building','2020-09-16','13:00:00'),(NULL,'Caddell Building','2020-10-02','12:00:00'),(NULL,'Caddell Building','2020-10-07','14:00:00'),(NULL,'CCBOH WIC Clinic','2020-09-16','09:00:00'),(NULL,'CCBOH WIC Clinic','2020-10-01','08:00:00'),(NULL,'CCBOH WIC Clinic','2020-10-06','10:00:00'),(NULL,'Coda Building','2020-09-16','14:00:00'),(NULL,'Coda Building','2020-10-02','13:00:00'),(NULL,'Coda Building','2020-10-07','15:00:00'),(NULL,'Curran St Parking Deck','2020-10-01','08:00:00'),(NULL,'Curran St Parking Deck','2020-10-02','17:00:00'),(NULL,'Curran St Parking Deck','2020-10-07','09:00:00'),(NULL,'Fulton County Board of Health','2020-09-16','08:00:00'),(NULL,'Fulton County Board of Health','2020-10-01','17:00:00'),(NULL,'Fulton County Board of Health','2020-10-06','09:00:00'),(NULL,'GT Catholic Center','2020-09-16','15:00:00'),(NULL,'GT Catholic Center','2020-10-02','14:00:00'),(NULL,'GT Catholic Center','2020-10-07','16:00:00'),(NULL,'GT Connector','2020-10-01','17:00:00'),(NULL,'GT Connector','2020-10-02','16:00:00'),(NULL,'GT Connector','2020-10-07','08:00:00'),(NULL,'Kennesaw State University','2020-09-16','10:00:00'),(NULL,'Kennesaw State University','2020-10-01','09:00:00'),(NULL,'Kennesaw State University','2020-10-06','11:00:00'),(NULL,'North Avenue (Centenial Room)','2020-10-01','09:00:00'),(NULL,'North Avenue (Centenial Room)','2020-10-06','08:00:00'),(NULL,'North Avenue (Centenial Room)','2020-10-07','10:00:00'),(NULL,'Stamps Health Services','2020-09-16','11:00:00'),(NULL,'Stamps Health Services','2020-10-01','10:00:00'),(NULL,'Stamps Health Services','2020-10-06','12:00:00'),(NULL,'West Village','2020-10-02','15:00:00'),(NULL,'West Village','2020-10-07','17:00:00'),('aallman302','West Village','2020-09-04','16:00:00'),('aallman302','West Village','2020-09-16','16:00:00'),('abernard224','Stamps Health Services','2020-09-03','10:00:00'),('abernard224','West Village','2020-09-10','10:00:00'),('amartin365','Coda Building','2020-09-10','17:00:00'),('cbing101','GT Catholic Center','2020-09-01','13:00:00'),('cbing101','GT Catholic Center','2020-09-10','13:00:00'),('dbrown85','CCBOH WIC Clinic','2020-09-03','16:00:00'),('dbrown85','CCBOH WIC Clinic','2020-09-10','16:00:00'),('dkim99','Bobby Dodd Stadium','2020-09-10','17:00:00'),('dkim99','West Village','2020-09-03','17:00:00'),('dphilbin81','Curran St Parking Deck','2020-09-10','12:00:00'),('dphilbin81','West Village','2020-09-03','12:00:00'),('dschrute18','Coda Building','2020-09-10','16:00:00'),('dschrute18','North Avenue (Centenial Room)','2020-09-01','16:00:00'),('dsmith102','Caddell Building','2020-09-10','15:00:00'),('dsmith102','Stamps Health Services','2020-09-03','15:00:00'),('gburdell1','Coda Building','2020-09-03','14:00:00'),('gburdell1','North Avenue (Centenial Room)','2020-09-10','14:00:00'),('hpeterson55','Bobby Dodd Stadium','2020-09-04','11:00:00'),('hpeterson55','Coda Building','2020-09-13','11:00:00'),('jhalpert75','Coda Building','2020-09-10','15:00:00'),('jhalpert75','North Avenue (Centenial Room)','2020-09-01','15:00:00'),('jpark29','GT Catholic Center','2020-09-10','09:00:00'),('jpark29','GT Connector','2020-09-04','09:00:00'),('jtribbiani27','Caddell Building','2020-09-01','10:00:00'),('jtribbiani27','Caddell Building','2020-09-04','10:00:00'),('kkapoor155','GT Catholic Center','2020-09-03','11:00:00'),('kkapoor155','GT Connector','2020-09-10','11:00:00'),('kweston85','Caddell Building','2020-09-16','17:00:00'),('kweston85','West Village','2020-09-04','17:00:00'),('lpiper20','Caddell Building','2020-09-04','12:00:00'),('lpiper20','Stamps Health Services','2020-09-13','12:00:00'),('mbob2','Curran St Parking Deck','2020-09-13','13:00:00'),('mbob2','Stamps Health Services','2020-09-04','13:00:00'),('mgeller3','Fulton County Board of Health','2020-09-01','08:00:00'),('mgeller3','Fulton County Board of Health','2020-09-04','08:00:00'),('mrees785','CCBOH WIC Clinic','2020-09-13','14:00:00'),('mrees785','Kennesaw State University','2020-09-04','14:00:00'),('mscott845','Bobby Dodd Stadium','2020-09-03','09:00:00'),('mscott845','Bobby Dodd Stadium','2020-09-10','09:00:00'),('omartinez13','Curran St Parking Deck','2020-09-03','08:00:00'),('omartinez13','Stamps Health Services','2020-09-10','08:00:00'),('pbeesly61','West Village','2020-09-01','14:00:00'),('pbeesly61','West Village','2020-09-10','14:00:00'),('pbuffay56','Bobby Dodd Stadium','2020-09-10','11:00:00'),('pbuffay56','GT Catholic Center','2020-09-01','11:00:00'),('rgeller9','Bobby Dodd Stadium','2020-09-01','09:00:00'),('rgeller9','Bobby Dodd Stadium','2020-09-04','09:00:00'),('rgreen97','Caddell Building','2020-09-10','12:00:00'),('rgreen97','West Village','2020-09-01','12:00:00'),('sthefirst1','Caddell Building','2020-09-03','13:00:00'),('sthefirst1','Curran St Parking Deck','2020-09-10','13:00:00'),('tlee984','Curran St Parking Deck','2020-09-04','08:00:00'),('tlee984','West Village','2020-09-10','08:00:00'),('vneal101','Curran St Parking Deck','2020-09-04','10:00:00'),('vneal101','Curran St Parking Deck','2020-09-13','10:00:00'),('wbryant23','GT Catholic Center','2020-09-04','15:00:00'),('wbryant23','North Avenue (Centenial Room)','2020-09-16','15:00:00');
/*!40000 ALTER TABLE `APPOINTMENT` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `EMPLOYEE`
--

DROP TABLE IF EXISTS `EMPLOYEE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `EMPLOYEE` (
  `emp_username` varchar(40) NOT NULL,
  `phone_num` varchar(10) NOT NULL,
  PRIMARY KEY (`emp_username`),
  CONSTRAINT `employee_ibfk_1` FOREIGN KEY (`emp_username`) REFERENCES `USER` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `EMPLOYEE`
--

LOCK TABLES `EMPLOYEE` WRITE;
/*!40000 ALTER TABLE `EMPLOYEE` DISABLE KEYS */;
INSERT INTO `EMPLOYEE` (`emp_username`, `phone_num`) VALUES ('akarev16','9876543210'),('cforte58','4708623384'),('dmcstuffins7','1236549878'),('fdavenport49','7068201473'),('hliu88','4782809765'),('jdoe381','1237864230'),('jhilborn97','4043802577'),('jhilborn98','4042201897'),('jrosario34','5926384247'),('jthomas520','7705678943'),('mgrey91','6458769523'),('nshea230','6979064501'),('pwallace51','3788612907'),('sstrange11','6547891234'),('ygao10','7703928765');
/*!40000 ALTER TABLE `EMPLOYEE` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `LABTECH`
--

DROP TABLE IF EXISTS `LABTECH`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `LABTECH` (
  `labtech_username` varchar(40) NOT NULL,
  PRIMARY KEY (`labtech_username`),
  CONSTRAINT `labtech_ibfk_1` FOREIGN KEY (`labtech_username`) REFERENCES `EMPLOYEE` (`emp_username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `LABTECH`
--

LOCK TABLES `LABTECH` WRITE;
/*!40000 ALTER TABLE `LABTECH` DISABLE KEYS */;
INSERT INTO `LABTECH` (`labtech_username`) VALUES ('cforte58'),('fdavenport49'),('hliu88'),('jhilborn97'),('jhilborn98'),('jthomas520'),('ygao10');
/*!40000 ALTER TABLE `LABTECH` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `LOCATION`
--

DROP TABLE IF EXISTS `LOCATION`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `LOCATION` (
  `location_name` varchar(40) NOT NULL,
  PRIMARY KEY (`location_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `LOCATION`
--

LOCK TABLES `LOCATION` WRITE;
/*!40000 ALTER TABLE `LOCATION` DISABLE KEYS */;
INSERT INTO `LOCATION` (`location_name`) VALUES ('East'),('West');
/*!40000 ALTER TABLE `LOCATION` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `POOL`
--

DROP TABLE IF EXISTS `POOL`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `POOL` (
  `pool_id` varchar(10) NOT NULL,
  `pool_status` varchar(20) NOT NULL,
  `process_date` date DEFAULT NULL,
  `processed_by` varchar(40) DEFAULT NULL,
  PRIMARY KEY (`pool_id`),
  KEY `processed_by` (`processed_by`),
  CONSTRAINT `pool_ibfk_1` FOREIGN KEY (`processed_by`) REFERENCES `LABTECH` (`labtech_username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `POOL`
--

LOCK TABLES `POOL` WRITE;
/*!40000 ALTER TABLE `POOL` DISABLE KEYS */;
INSERT INTO `POOL` (`pool_id`, `pool_status`, `process_date`, `processed_by`) VALUES ('1','negative','2020-09-02','jhilborn97'),('10','pending',NULL,NULL),('11','pending',NULL,NULL),('12','pending',NULL,NULL),('13','pending',NULL,NULL),('2','positive','2020-09-04','jhilborn98'),('3','positive','2020-09-06','ygao10'),('4','positive','2020-09-05','jthomas520'),('5','negative','2020-09-07','fdavenport49'),('6','positive','2020-09-05','hliu88'),('7','negative','2020-09-11','cforte58'),('8','positive','2020-09-11','ygao10'),('9','pending',NULL,NULL);
/*!40000 ALTER TABLE `POOL` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SITE`
--

DROP TABLE IF EXISTS `SITE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `SITE` (
  `site_name` varchar(40) NOT NULL,
  `street` varchar(40) NOT NULL,
  `city` varchar(40) NOT NULL,
  `state` char(2) NOT NULL,
  `zip` char(5) NOT NULL,
  `location` varchar(40) NOT NULL,
  PRIMARY KEY (`site_name`),
  KEY `location` (`location`),
  CONSTRAINT `site_ibfk_1` FOREIGN KEY (`location`) REFERENCES `LOCATION` (`location_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SITE`
--

LOCK TABLES `SITE` WRITE;
/*!40000 ALTER TABLE `SITE` DISABLE KEYS */;
INSERT INTO `SITE` (`site_name`, `street`, `city`, `state`, `zip`, `location`) VALUES ('Bobby Dodd Stadium','150 Bobby Dodd Way NW','Atlanta','GA','30332','East'),('Caddell Building','280 Ferst Drive NW','Atlanta','GA','30332','West'),('CCBOH WIC Clinic','1895 Phoenix Blvd','College Park','GA','30339','West'),('Coda Building','760 Spring Street ','Atlanta','GA','30332','East'),('Curran St Parking Deck','564 8th St NW','Atlanta','GA','30318','West'),('Fulton County Board of Health','10 Park Place South SE','Atlanta','GA','30303','East'),('GT Catholic Center','172 4th St NW','Atlanta','GA','30313','East'),('GT Connector','116 Bobby Dodd Way NW','Atlanta','GA','30313','East'),('Kennesaw State University','3305 Busbee Drive NW','Kennesaw','GA','30144','West'),('North Avenue (Centenial Room)','120 North Avenue NW','Atlanta','GA','30313','East'),('Stamps Health Services','740 Ferst Drive','Atlanta','GA','30332','West'),('West Village','532 8th St NW','Atlanta','GA','30318','West');
/*!40000 ALTER TABLE `SITE` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SITETESTER`
--

DROP TABLE IF EXISTS `SITETESTER`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `SITETESTER` (
  `sitetester_username` varchar(20) NOT NULL,
  PRIMARY KEY (`sitetester_username`),
  CONSTRAINT `sitetester_ibfk_1` FOREIGN KEY (`sitetester_username`) REFERENCES `EMPLOYEE` (`emp_username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SITETESTER`
--

LOCK TABLES `SITETESTER` WRITE;
/*!40000 ALTER TABLE `SITETESTER` DISABLE KEYS */;
INSERT INTO `SITETESTER` (`sitetester_username`) VALUES ('akarev16'),('dmcstuffins7'),('jdoe381'),('jrosario34'),('mgrey91'),('nshea230'),('pwallace51'),('sstrange11');
/*!40000 ALTER TABLE `SITETESTER` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `STUDENT`
--

DROP TABLE IF EXISTS `STUDENT`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `STUDENT` (
  `student_username` varchar(40) NOT NULL,
  `housing_type` varchar(20) NOT NULL,
  `location` varchar(40) NOT NULL,
  PRIMARY KEY (`student_username`),
  KEY `location` (`location`),
  CONSTRAINT `student_ibfk_1` FOREIGN KEY (`student_username`) REFERENCES `USER` (`username`),
  CONSTRAINT `student_ibfk_2` FOREIGN KEY (`location`) REFERENCES `LOCATION` (`location_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `STUDENT`
--

LOCK TABLES `STUDENT` WRITE;
/*!40000 ALTER TABLE `STUDENT` DISABLE KEYS */;
INSERT INTO `STUDENT` (`student_username`, `housing_type`, `location`) VALUES ('aallman302','Student Housing','West'),('abernard224','Greek Housing','West'),('amartin365','Greek Housing','East'),('cbing101','Greek Housing','East'),('dbrown85','Off-campus Apartment','East'),('dkim99','Greek Housing','East'),('dphilbin81','Greek Housing','West'),('dschrute18','Student Housing','East'),('dsmith102','Greek Housing','West'),('gburdell1','Student Housing','East'),('hpeterson55','Greek Housing','East'),('jhalpert75','Student Housing','East'),('jpark29','Student Housing','East'),('jtribbiani27','Greek Housing','West'),('kkapoor155','Greek Housing','East'),('kweston85','Greek Housing','West'),('lpiper20','Student Housing','West'),('mbob2','Student Housing','West'),('mgeller3','Off-campus Apartment','East'),('mrees785','Off-campus House','West'),('mscott845','Student Housing','East'),('omartinez13','Student Housing','West'),('pbeesly61','Student Housing','West'),('pbuffay56','Student Housing','East'),('rgeller9','Student Housing','East'),('rgreen97','Student Housing','West'),('sthefirst1','Student Housing','West'),('tlee984','Student Housing','West'),('vneal101','Student Housing','West'),('wbryant23','Greek Housing','East');
/*!40000 ALTER TABLE `STUDENT` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `TEST`
--

DROP TABLE IF EXISTS `TEST`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `TEST` (
  `test_id` varchar(7) NOT NULL,
  `test_status` varchar(10) NOT NULL,
  `pool_id` varchar(10) DEFAULT NULL,
  `appt_site` varchar(40) NOT NULL,
  `appt_date` date NOT NULL,
  `appt_time` time NOT NULL,
  PRIMARY KEY (`test_id`),
  KEY `pool_id` (`pool_id`),
  KEY `appt_site` (`appt_site`,`appt_date`,`appt_time`),
  CONSTRAINT `test_ibfk_1` FOREIGN KEY (`pool_id`) REFERENCES `POOL` (`pool_id`),
  CONSTRAINT `test_ibfk_2` FOREIGN KEY (`appt_site`, `appt_date`, `appt_time`) REFERENCES `APPOINTMENT` (`site_name`, `appt_date`, `appt_time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `TEST`
--

LOCK TABLES `TEST` WRITE;
/*!40000 ALTER TABLE `TEST` DISABLE KEYS */;
INSERT INTO `TEST` (`test_id`, `test_status`, `pool_id`, `appt_site`, `appt_date`, `appt_time`) VALUES ('100001','negative','1','Fulton County Board of Health','2020-09-01','08:00:00'),('100002','negative','1','Bobby Dodd Stadium','2020-09-01','09:00:00'),('100003','negative','1','Caddell Building','2020-09-01','10:00:00'),('100004','negative','1','GT Catholic Center','2020-09-01','11:00:00'),('100005','negative','1','West Village','2020-09-01','12:00:00'),('100006','negative','1','GT Catholic Center','2020-09-01','13:00:00'),('100007','negative','1','West Village','2020-09-01','14:00:00'),('100008','negative','2','North Avenue (Centenial Room)','2020-09-01','15:00:00'),('100009','positive','2','North Avenue (Centenial Room)','2020-09-01','16:00:00'),('100011','negative','2','Curran St Parking Deck','2020-09-03','08:00:00'),('100012','positive','2','Bobby Dodd Stadium','2020-09-03','09:00:00'),('100013','positive','2','Stamps Health Services','2020-09-03','10:00:00'),('100014','negative','2','GT Catholic Center','2020-09-03','11:00:00'),('100015','negative','3','West Village','2020-09-03','12:00:00'),('100016','positive','3','Caddell Building','2020-09-03','13:00:00'),('100017','negative','3','Coda Building','2020-09-03','14:00:00'),('100018','negative','3','Stamps Health Services','2020-09-03','15:00:00'),('100019','positive','3','CCBOH WIC Clinic','2020-09-03','16:00:00'),('100020','negative','4','West Village','2020-09-03','17:00:00'),('100021','negative','4','Curran St Parking Deck','2020-09-04','08:00:00'),('100022','negative','4','GT Connector','2020-09-04','09:00:00'),('100023','negative','4','Curran St Parking Deck','2020-09-04','10:00:00'),('100024','positive','4','Bobby Dodd Stadium','2020-09-04','11:00:00'),('100025','negative','5','Caddell Building','2020-09-04','12:00:00'),('100026','negative','5','Stamps Health Services','2020-09-04','13:00:00'),('100027','negative','5','Kennesaw State University','2020-09-04','14:00:00'),('100028','negative','5','GT Catholic Center','2020-09-04','15:00:00'),('100029','negative','5','West Village','2020-09-04','16:00:00'),('100030','negative','5','West Village','2020-09-04','17:00:00'),('100031','positive','6','Fulton County Board of Health','2020-09-04','08:00:00'),('100032','positive','6','Bobby Dodd Stadium','2020-09-04','09:00:00'),('100033','negative','7','Caddell Building','2020-09-04','10:00:00'),('100034','negative','7','Bobby Dodd Stadium','2020-09-10','11:00:00'),('100035','negative','7','Caddell Building','2020-09-10','12:00:00'),('100036','negative','7','GT Catholic Center','2020-09-10','13:00:00'),('100037','negative','7','West Village','2020-09-10','14:00:00'),('100038','negative','7','Coda Building','2020-09-10','15:00:00'),('100039','negative','8','Coda Building','2020-09-10','16:00:00'),('100040','positive','8','Coda Building','2020-09-10','17:00:00'),('100041','negative','8','Stamps Health Services','2020-09-10','08:00:00'),('100042','pending','9','Bobby Dodd Stadium','2020-09-10','09:00:00'),('100043','pending','9','West Village','2020-09-10','10:00:00'),('100044','pending','9','GT Connector','2020-09-10','11:00:00'),('100045','pending','9','Curran St Parking Deck','2020-09-10','12:00:00'),('100046','pending','9','Curran St Parking Deck','2020-09-10','13:00:00'),('100047','pending','9','North Avenue (Centenial Room)','2020-09-10','14:00:00'),('100048','pending','9','Caddell Building','2020-09-10','15:00:00'),('100049','pending','10','CCBOH WIC Clinic','2020-09-10','16:00:00'),('100050','pending','11','Bobby Dodd Stadium','2020-09-10','17:00:00'),('100051','pending','11','West Village','2020-09-10','08:00:00'),('100052','pending','11','GT Catholic Center','2020-09-10','09:00:00'),('100053','pending','11','Curran St Parking Deck','2020-09-13','10:00:00'),('100054','pending','11','Coda Building','2020-09-13','11:00:00'),('100055','pending','12','Stamps Health Services','2020-09-13','12:00:00'),('100056','pending','12','Curran St Parking Deck','2020-09-13','13:00:00'),('100057','pending','12','CCBOH WIC Clinic','2020-09-13','14:00:00'),('100058','pending','12','North Avenue (Centenial Room)','2020-09-16','15:00:00'),('100059','pending','13','West Village','2020-09-16','16:00:00'),('100060','pending','13','Caddell Building','2020-09-16','17:00:00');
/*!40000 ALTER TABLE `TEST` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `USER`
--

DROP TABLE IF EXISTS `USER`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `USER` (
  `username` varchar(40) NOT NULL,
  `user_password` varchar(40) NOT NULL,
  `email` varchar(40) NOT NULL,
  `fname` varchar(40) NOT NULL,
  `lname` varchar(40) NOT NULL,
  PRIMARY KEY (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `USER`
--

LOCK TABLES `USER` WRITE;
/*!40000 ALTER TABLE `USER` DISABLE KEYS */;
INSERT INTO `USER` (`username`, `user_password`, `email`, `fname`, `lname`) VALUES ('aallman302','ea716d443f74ecc54957c884c0d05612','aallman302@gatech.edu','Aiysha','Allman'),('abernard224','0c75f443030c092d82b67ef876fa4e4e','abernard224@gatech.edu','Andy','Bernard'),('akarev16','1e5c2776cf544e213c3d279c40719643','akarev16@gatech.edu','Alex','Karev'),('amartin365','3b635d4df2c9ece93b97759531d6ed01','amartin365@gatech.edu','Angela','Martin'),('cbing101','58bad6b697dff48f4927941962f23e90','cbing101@gatech.edu','Chandler','Bing'),('cforte58','b25ef06be3b6948c0bc431da46c2c738','cforte58@gatech.edu','Connor','Forte'),('dbrown85','9ab4b766ba920fca672112a4d81464df','dbrown85@gatech.edu','David','Brown'),('dkim99','b30628ea30edfe26e7650e7bd89cc8a1','dkim99@gatech.edu','Dave','Kim'),('dmcstuffins7','8ee736784ce419bd16554ed5677ff35b','dmcstuffins7@gatech.edu','Doc','Mcstuffins'),('dphilbin81','d61af90de34e181dcb619fdc9c9f817d','dphilbin81@gatech.edu','Darryl','Philbin'),('dschrute18','ccf08fd9a560b266470bf8ab97fc7c26','dschrute18@gatech.edu','Dwight','Schrute'),('dsmith102','8ba4260f47598cece4813a294952f7f3','dsmith102@gatech.edu','Dani','Smith'),('fdavenport49','5d69dd95ac183c9643780ed7027d128a','fdavenport49@gatech.edu','Felicia','Devenport'),('gburdell1','48ad74b74844fadd28274afd5c617ccf','gburdell1@gatech.edu','George','Burdell'),('hliu88','87e897e3b54a405da144968b2ca19b45','hliu88@gatech.edu','Hang','Liu'),('hpeterson55','b1a6a20d781fde908b1dd9af34deb8ea','hpeterson55@gatech.edu','Haydn','Peterson'),('jdoe381','c24a542f884e144451f9063b79e7994e','jdoe381@gatech.edu','Jane','Doe'),('jhalpert75','dc2d937cba912f093445d008f0461c83','jhalpert75@gatech.edu','Jim','Halpert'),('jhilborn97','34cc93ece0ba9e3f6f235d4af979b16c','jhilborn97@gatech.edu','Jack','Hilborn'),('jhilborn98','db0edd04aaac4506f7edab03ac855d56','jhilborn98@gatech.edu','Jake','Hilborn'),('jlionel666','7c6a180b36896a0a8c02787eeafb0e4c','jlionel666@gatech.edu','John','Lionel'),('jpark29','831fc3acf61a6ac7f44f73287ece2942','jpark29@gatech.edu','Jerry','Park'),('jrosario34','a63f9709abc75bf8bd8f6e1ba9992573','jrosario34@gatech.edu','Jon','Rosario'),('jthomas520','00cdb7bb942cf6b290ceb97d6aca64a3','jthomas520@gatech.edu','James','Thomas'),('jtribbiani27','568c31f0f2406ab70255a1d83291220f','jtribbiani27@gatech.edu','Joey','Tribbiani'),('kkapoor155','f849618fac31084ff0bafe6f877562e3','kkapoor155@gatech.edu','Kelly','Kapoor'),('kweston85','458c7a67e7b9126ae7a9df4b821ea745','kweston85@gatech.edu','Kyle','Weston'),('lchen27','819b0643d6b89dc9b579fdfc9094f28e','lchen27@gatech.edu','Liang','Chen'),('lpiper20','a5669b4e80cfb179cdd36be6eeada2cd','lpiper20@gatech.edu','Leroy','Piper'),('mbob2','9608e3da7f00ffa26507d1aa9a575197','mbob2@gatech.edu','Mary','Bob'),('mgeller3','e532ae6f28f4c2be70b500d3d34724eb','mgeller3@gatech.edu','Monica','Geller'),('mgrey91','9141fea0574f83e190ab7479d516630d','mgrey91@gatech.edu','Meredith','Grey'),('mmoss7','6cb75f652a9b52798eb6cf2201057c73','mmoss7@gatech.edu','Mark','Moss'),('mrees785','0009fa95022c5c2c1276227121652c60','mrees785@gatech.edu','Marie','Rees'),('mscott845','3dc94727dbba08bdd21d7b318b410600','mscott845@gatech.edu','Michael','Scott'),('nshea230','80b8bdceb474b5127b6aca386bb8ce14','nshea230@gatech.edu','Nicholas','Shea'),('omartinez13','926742e502de7d22686bb1d4a07fe635','omartinez13@gatech.edu','Oscar','Martinez'),('pbeesly61','6982e82c0b21af5526754d83df2d1635','pbeesly61@gatech.edu','Pamela','Beesly'),('pbuffay56','069103d83d40b742a336dee5fb92f4e5','pbuffay56@gatech.edu','Phoebe','Buffay'),('pwallace51','2b40aaa979727c43411c305540bbed50','pwallace51@gatech.edu','Penny','Wallace'),('rgeller9','aee67d9bb569ad1562f7b67cfccbd2ef','rgeller9@gatech.edu','Ross','Geller'),('rgreen97','1f82cdf9195b31244721c6026587fb78','rgreen97@gatech.edu','Rachel','Green'),('sstrange11','ee684912c7e588d03ccb40f17ed080c9','sstrange11@gatech.edu','Stephen','Strange'),('sthefirst1','7aa4106f8d30c77db0517e813ace4a3b','sthefirst1@gatech.edu','Sofia','Thefirst'),('tlee984','be961c906e3b375dced446d4cf0b6856','tlee984@gatech.edu','Tom','Lee'),('vneal101','decb7cb773821f0e6486650c6f062be5','vneal101@gatech.edu','Vinay','Neal'),('wbryant23','6ea84fafdeb8b3857abe9410c7144ccb','wbryant23@gatech.edu','William','Bryant'),('ygao10','218dd27aebeccecae69ad8408d9a36bf','ygao10@gatech.edu','Yuan','Gao');
/*!40000 ALTER TABLE `USER` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `WORKING_AT`
--

DROP TABLE IF EXISTS `WORKING_AT`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `WORKING_AT` (
  `username` varchar(20) NOT NULL,
  `site` varchar(40) NOT NULL,
  PRIMARY KEY (`username`,`site`),
  KEY `site` (`site`),
  CONSTRAINT `working_at_ibfk_1` FOREIGN KEY (`username`) REFERENCES `SITETESTER` (`sitetester_username`),
  CONSTRAINT `working_at_ibfk_2` FOREIGN KEY (`site`) REFERENCES `SITE` (`site_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `WORKING_AT`
--

LOCK TABLES `WORKING_AT` WRITE;
/*!40000 ALTER TABLE `WORKING_AT` DISABLE KEYS */;
INSERT INTO `WORKING_AT` (`username`, `site`) VALUES ('dmcstuffins7','Bobby Dodd Stadium'),('mgrey91','Bobby Dodd Stadium'),('dmcstuffins7','Caddell Building'),('mgrey91','Caddell Building'),('akarev16','CCBOH WIC Clinic'),('jdoe381','CCBOH WIC Clinic'),('dmcstuffins7','Coda Building'),('pwallace51','Coda Building'),('sstrange11','Coda Building'),('jdoe381','Curran St Parking Deck'),('sstrange11','Curran St Parking Deck'),('akarev16','Fulton County Board of Health'),('jdoe381','Fulton County Board of Health'),('dmcstuffins7','GT Catholic Center'),('sstrange11','GT Catholic Center'),('dmcstuffins7','GT Connector'),('sstrange11','GT Connector'),('akarev16','Kennesaw State University'),('mgrey91','Kennesaw State University'),('jdoe381','North Avenue (Centenial Room)'),('sstrange11','North Avenue (Centenial Room)'),('akarev16','Stamps Health Services'),('mgrey91','Stamps Health Services'),('dmcstuffins7','West Village'),('sstrange11','West Village');
/*!40000 ALTER TABLE `WORKING_AT` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'covidtest_fall2020'
--
/*!50003 DROP PROCEDURE IF EXISTS `aggregate_results` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `aggregate_results`(
    IN i_location VARCHAR(50),
    IN i_housing VARCHAR(50),
    IN i_testing_site VARCHAR(50),
    IN i_start_date DATE,
    IN i_end_date DATE)
BEGIN
    DROP TABLE IF EXISTS aggregate_results_result;
    CREATE TABLE aggregate_results_result(
        test_status VARCHAR(40),
        num_of_test INT,
        percentage DECIMAL(6,2)
    );

    INSERT INTO aggregate_results_result
    
    -- Type solution below
    select test_status,
			count(*),
			count(*)*100/ (count(*) OVER())
			from test t
	left join appointment a
			ON t.appt_date = a.appt_date
			AND t.appt_time = a.appt_time
			AND t.appt_site = a.site_name
	left join student
			on username=student_username
	left join pool p
			on t.pool_id=p.pool_id
	where (i_location=location OR i_location IS NULL)
			AND (i_housing=housing_type OR i_housing IS NULL )
			AND (i_testing_site = t.appt_site OR i_testing_site IS NULL)
			AND (CASE WHEN i_end_date IS NOT NULL
				THEN (p.process_date <= i_end_date) 
				ELSE (p.process_date IS NULL OR p.process_date >= i_start_date OR i_start_date IS NULL) END)
		group by test_status;

	
    if ((select count(*) from aggregate_results_result)=1 and (select test_status from aggregate_results_result) = 'negative')
    then insert into aggregate_results_result values ('positive', 0, 0), ('pending',0,0);
	end if;
    
    if ((select count(*) from aggregate_results_result)=1 and (select test_status from aggregate_results_result) = 'positive')
    then insert into aggregate_results_result values ('negative', 0, 0), ('pending',0,0);
    end if;
    
    if ((select count(*) from aggregate_results_result)=1 and (select test_status from aggregate_results_result) = 'pending')
    then insert into aggregate_results_result values ('positive', 0, 0), ('negative',0,0);
	end if;
    
    if (select count(*) from aggregate_results_result)=2
    then insert into aggregate_results_result values('pending',0,0);
    end if;

    -- End of solution
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `assign_tester` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `assign_tester`(
	IN i_tester_username VARCHAR(40),
    IN i_site_name VARCHAR(40)
)
BEGIN
-- Type solution below
	IF EXISTS (SELECT * FROM SITETESTER WHERE sitetester_username = i_tester_username) THEN
    IF EXISTS (SELECT site_name FROM SITE WHERE site_name = i_site_name) THEN
	INSERT INTO WORKING_AT (username, site) VALUES (i_tester_username, i_site_name);
    END IF;
	END IF;
-- End of solution
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `assign_test_to_pool` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `assign_test_to_pool`(
    IN i_pool_id VARCHAR(10),
    IN i_test_id VARCHAR(7)
)
BEGIN
-- Type solution below
	IF
       i_test_id IN (SELECT test_id FROM test) AND i_pool_id IN (SELECT pool_id FROM pool)
    THEN
		SELECT pool_id
		INTO @curr_pool_id
		FROM test
		WHERE test_id = i_test_id;
        
        SELECT COUNT(*)
        INTO @curr_pool_num
        FROM test
        WHERE pool_id = i_pool_id;
        
        IF 
			@curr_pool_id IS NULL AND @curr_pool_num <= 6
        THEN
			UPDATE test
			SET pool_id = i_pool_id
			WHERE test_id = i_test_id;
		END IF;
    END IF;

-- End of solution
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `create_appointment` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `create_appointment`(
	IN i_site_name VARCHAR(40),
    IN i_date DATE,
    IN i_time TIME
)
BEGIN
-- Type solution below
	SELECT EXISTS (SELECT * FROM appointment WHERE site_name = i_site_name AND appt_date = i_date AND appt_time = i_time)
	INTO @curr_exist;
	
    IF 
		@curr_exist = 0
	THEN
		SELECT COUNT(*) * 10
        INTO @limit_appt_num
        FROM working_at
        WHERE site = i_site_name;
        
		SELECT COUNT(*)
        INTO @curr_appt_num
        FROM appointment
        WHERE site_name = i_site_name AND appt_date = i_date;
        
        IF 
			@curr_appt_num < @limit_appt_num
		THEN
			INSERT INTO appointment (username, site_name, appt_date, appt_time) VALUES (NULL, i_site_name, i_date, i_time);
        END IF;
            
    END IF;

-- End of solution
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `create_pool` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `create_pool`(
	IN i_pool_id VARCHAR(10),
    IN i_test_id VARCHAR(7)
)
BEGIN
-- Type solution below
	IF
       i_test_id IN (SELECT test_id FROM test)
    THEN
		SELECT pool_id
		INTO @curr_pool_id
		FROM test
		WHERE test_id = i_test_id;
        IF 
			@curr_pool_id IS NULL
        THEN
			INSERT INTO pool (pool_id, pool_status, process_date, processed_by) VALUES (i_pool_id, 'pending', NULL, NULL);
			UPDATE test
			SET pool_id = i_pool_id
			WHERE test_id = i_test_id;
		END IF;
    END IF;

-- End of solution
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `create_testing_site` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `create_testing_site`(
	IN i_site_name VARCHAR(40),
    IN i_street varchar(40),
    IN i_city varchar(40),
    IN i_state char(2),
    IN i_zip char(5),
    IN i_location varchar(40),
    IN i_first_tester_username varchar(40)
)
BEGIN
-- Type solution below
INSERT INTO SITE (site_name, street, city, state, zip, location) VALUES (i_site_name, i_street, i_city, i_state, i_zip, i_location);
INSERT INTO WORKING_AT (username, site) VALUES (i_first_tester_username, i_site_name);
-- End of solution
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `daily_results` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `daily_results`()
BEGIN
	DROP TABLE IF EXISTS daily_results_result;
    CREATE TABLE daily_results_result(
		process_date date,
        num_tests int,
        pos_tests int,
        pos_percent DECIMAL(6,2));
	INSERT INTO daily_results_result
    -- Type solution below

    SELECT p.process_date, 
	   count(*) AS total,
       count(CASE WHEN test_status = 'positive' THEN 1 END) AS pos_count, 
	   (count(CASE WHEN test_status = 'positive' THEN 1 END)/count(*)) * 100 AS percentage
	FROM TEST AS t 
	LEFT JOIN POOL AS p 
	ON t.pool_id = p.pool_id
	GROUP BY p.process_date
	HAVING p.process_date IS NOT NULL;
    
    -- End of solution
    END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `explore_results` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `explore_results`(
    IN i_test_id VARCHAR(7))
BEGIN
    DROP TABLE IF EXISTS explore_results_result;
    CREATE TABLE explore_results_result(
        test_id VARCHAR(7),
        test_date date,
        timeslot time,
        testing_location VARCHAR(40),
        date_processed date,
        pooled_result VARCHAR(40),
        individual_result VARCHAR(40),
        processed_by VARCHAR(80)
    );
    INSERT INTO explore_results_result

    -- Type solution below

        SELECT * FROM User;

    -- End of solution
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `pool_metadata` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `pool_metadata`(
    IN i_pool_id VARCHAR(10))
BEGIN
    DROP TABLE IF EXISTS pool_metadata_result;
    CREATE TABLE pool_metadata_result(
        pool_id VARCHAR(10),
        date_processed DATE,
        pooled_result VARCHAR(20),
        processed_by VARCHAR(100));

    INSERT INTO pool_metadata_result
-- Type solution below
    SELECT p.pool_id, p.process_date, p.pool_status, LOWER(CONCAT(u.fname, u.lname))
    FROM POOL as p LEFT JOIN USER as u ON p.processed_by = u.username
    WHERE (pool_id = i_pool_id);

-- End of solution
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `process_pool` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `process_pool`(
    IN i_pool_id VARCHAR(10),
    IN i_pool_status VARCHAR(20),
    IN i_process_date DATE,
    IN i_processed_by VARCHAR(40)
)
BEGIN
-- Type solution below

    SELECT pool_status
    INTO @curr_status
    FROM POOL
    WHERE pool_id = i_pool_id;

    IF
        ((@curr_status = 'pending') AND (i_pool_status = 'positive' OR i_pool_status = 'negative'))
    THEN
        UPDATE POOL
        SET pool_status = i_pool_status, process_date = i_process_date, processed_by = i_processed_by
        WHERE pool_id = i_pool_id;
    END IF;


-- End of solution
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `process_test` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `process_test`(
    IN i_test_id VARCHAR(7),
    IN i_test_status VARCHAR(20)
)
BEGIN
-- Type solution below
	IF
       i_test_id IN (SELECT test_id FROM test)
    THEN
        SELECT test_status, pool_id
		INTO @curr_test_status, @curr_pool_id
		FROM test
		WHERE test_id = i_test_id;
        
		SELECT pool_status
		INTO @curr_pool_status
		FROM POOL
		WHERE pool_id = @curr_pool_id;
        
        IF 
			 @curr_test_status = 'pending' AND @curr_pool_status = 'positive' AND i_test_status IN ('negative','positive','pending')
        THEN
			UPDATE test
			SET test_status = i_test_status
			WHERE test_id = i_test_id;
		ELSE 
			IF @curr_test_status  = 'pending' AND @curr_pool_status = 'negative' AND i_test_status = 'negative'
			THEN
				UPDATE test
				SET test_status = i_test_status
				WHERE test_id = i_test_id;
			END IF;
        END IF;
        
    END IF;

-- End of solution
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `register_employee` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `register_employee`(
		IN i_username VARCHAR(40),
        IN i_email VARCHAR(40),
        IN i_fname VARCHAR(40),
        IN i_lname VARCHAR(40),
        IN i_phone VARCHAR(10),
        IN i_labtech BOOLEAN,
        IN i_sitetester BOOLEAN,
        IN i_password VARCHAR(40)
)
BEGIN
-- Type solution below


-- End of solution
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `register_student` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `register_student`(
		IN i_username VARCHAR(40),
        IN i_email VARCHAR(40),
        IN i_fname VARCHAR(40),
        IN i_lname VARCHAR(40),
        IN i_location VARCHAR(40),
        IN i_housing_type VARCHAR(20),
        IN i_password VARCHAR(40)
)
BEGIN

-- Type solution below
INSERT INTO USER (username, user_password, email, fname, lname) VALUES (i_username, MD5(i_password), i_email, i_fname, i_lname);
INSERT INTO STUDENT (student_username, housing_type, location) VALUES (i_username, i_housing_type, i_location);

-- End of solution
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `student_view_results` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `student_view_results`(
    IN i_student_username VARCHAR(50),
	IN i_test_status VARCHAR(50),
	IN i_start_date DATE,
    IN i_end_date DATE
)
BEGIN
	DROP TABLE IF EXISTS student_view_results_result;
    CREATE TABLE student_view_results_result(
        test_id VARCHAR(7),
        timeslot_date date,
        date_processed date,
        pool_status VARCHAR(40),
        test_status VARCHAR(40)
    );
    INSERT INTO student_view_results_result

    -- Type solution below

		SELECT t.test_id, t.appt_date, p.process_date, p.pool_status , t.test_status
        FROM Appointment a
            LEFT JOIN Test t
                ON t.appt_date = a.appt_date
                AND t.appt_time = a.appt_time
                AND t.appt_site = a.site_name
            LEFT JOIN Pool p
                ON t.pool_id = p.pool_id
        WHERE i_student_username = a.username
            AND (i_test_status = t.test_status OR i_test_status IS NULL)
            AND (i_start_date <= t.appt_date OR i_start_date IS NULL)
            AND (i_end_date >= t.appt_date OR i_end_date IS NULL);

    -- End of solution
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `tester_assigned_sites` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `tester_assigned_sites`(
    IN i_tester_username VARCHAR(40))
BEGIN
    DROP TABLE IF EXISTS tester_assigned_sites_result;
    CREATE TABLE tester_assigned_sites_result(
        site_name VARCHAR(40));

    INSERT INTO tester_assigned_sites_result
-- Type solution below
	SELECT site from WORKING_AT
    WHERE (username = i_tester_username);

-- End of solution
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `tests_in_pool` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `tests_in_pool`(
    IN i_pool_id VARCHAR(10))
BEGIN
    DROP TABLE IF EXISTS tests_in_pool_result;
    CREATE TABLE tests_in_pool_result(
        test_id varchar(7),
        date_tested DATE,
        testing_site VARCHAR(40),
        test_result VARCHAR(20));

    INSERT INTO tests_in_pool_result
-- Type solution below
	SELECT test_id, appt_date, appt_site, test_status from TEST
    where (pool_id = i_pool_id);

-- End of solution
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `tests_processed` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `tests_processed`(
    IN i_start_date date,
    IN i_end_date date,
    IN i_test_status VARCHAR(10),
    IN i_lab_tech_username VARCHAR(40))
BEGIN
    DROP TABLE IF EXISTS tests_processed_result;
    CREATE TABLE tests_processed_result(
        test_id VARCHAR(7),
        pool_id VARCHAR(10),
        test_date date,
        process_date date,
        test_status VARCHAR(10) );
    INSERT INTO tests_processed_result
    -- Type solution below

        SELECT * FROM User;

    -- End of solution
    END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `test_sign_up` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `test_sign_up`(
		IN i_username VARCHAR(40),
        IN i_site_name VARCHAR(40),
        IN i_appt_date date,
        IN i_appt_time time,
        IN i_test_id VARCHAR(7)
)
BEGIN
-- Type solution below


-- End of solution
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `test_sign_up_filter` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `test_sign_up_filter`(
    IN i_username VARCHAR(40),
    IN i_testing_site VARCHAR(40),
    IN i_start_date date,
    IN i_end_date date,
    IN i_start_time time,
    IN i_end_time time)
BEGIN
    DROP TABLE IF EXISTS test_sign_up_filter_result;
    CREATE TABLE test_sign_up_filter_result(
        appt_date date,
        appt_time time,
        street VARCHAR (40),
        city VARCHAR(40),
        state VARCHAR(2),
        zip VARCHAR(5),
        site_name VARCHAR(40));
    INSERT INTO test_sign_up_filter_result

    -- Type solution below

    SELECT * FROM User;

    -- End of solution

    END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `unassign_tester` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `unassign_tester`(
	IN i_tester_username VARCHAR(40),
    IN i_site_name VARCHAR(40)
)
BEGIN
-- Type solution below
IF (SELECT COUNT(*) FROM WORKING_AT WHERE site = i_site_name) > 1 THEN
DELETE FROM WORKING_AT
WHERE (username = i_tester_username AND site = i_site_name);
END IF;
-- End of solution
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `view_appointments` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `view_appointments`(
    IN i_site_name VARCHAR(40),
    IN i_begin_appt_date DATE,
    IN i_end_appt_date DATE,
    IN i_begin_appt_time TIME,
    IN i_end_appt_time TIME,
    IN i_is_available INT  -- 0 for "booked only", 1 for "available only", NULL for "all"
)
BEGIN
    DROP TABLE IF EXISTS view_appointments_result;
    CREATE TABLE view_appointments_result(

        appt_date DATE,
        appt_time TIME,
        site_name VARCHAR(40),
        location VARCHAR(40),
        username VARCHAR(40));

    INSERT INTO view_appointments_result
-- Type solution below
	SELECT a.appt_date, a.appt_time, a.site_name, b.location, a.username
	FROM 
	(SELECT appt_date, appt_time, site_name, username
	FROM appointment
	WHERE 
	((i_begin_appt_time IS NOT NULL AND i_end_appt_time IS NOT NULL AND i_begin_appt_time <= i_end_appt_time AND appt_time >= i_begin_appt_time AND appt_time <= i_end_appt_time)
    OR
    (i_begin_appt_time IS NOT NULL AND i_end_appt_time IS NULL AND appt_time >= i_begin_appt_time)
	OR
    (i_begin_appt_time IS NULL AND i_end_appt_time IS NOT NULL AND appt_time <= i_end_appt_time)
	OR
    (i_begin_appt_time IS NULL AND i_end_appt_time IS NULL))
    AND
    ((i_site_name IS NULL)
    OR
    (i_site_name IS NOT NULL AND site_name = i_site_name))
    AND 
    ((username IS NOT NULL AND F = 0) 
    OR (username IS NULL AND F = 1) 
    OR (F IS NULL))
    AND
    ((i_begin_appt_date IS NOT NULL AND i_end_appt_date IS NOT NULL AND i_begin_appt_date <= i_end_appt_date AND appt_date >= i_begin_appt_date AND appt_date <= i_end_appt_date)
    OR
    (i_begin_appt_date IS NOT NULL AND i_end_appt_date IS NULL AND appt_date >= i_begin_appt_date)
    OR
    (i_begin_appt_date IS NULL AND i_end_appt_date IS NOT NULL AND appt_date <= i_end_appt_date)
    OR
	(i_begin_appt_date IS NULL AND i_end_appt_date IS NULL))
    ) a
	LEFT JOIN site b
	ON a.site_name = b.site_name;

-- End of solution
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `view_pools` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `view_pools`(
    IN i_begin_process_date DATE,
    IN i_end_process_date DATE,
    IN i_pool_status VARCHAR(20),
    IN i_processed_by VARCHAR(40)
)
BEGIN
    DROP TABLE IF EXISTS view_pools_result;
    CREATE TABLE view_pools_result(
        pool_id VARCHAR(10),
        test_ids VARCHAR(100),
        date_processed DATE,
        processed_by VARCHAR(40),
        pool_status VARCHAR(20));

    INSERT INTO view_pools_result
-- Type solution below

    SELECT a.pool_id, b.test_ids, a.process_date AS date_processed, a.processed_by, a.pool_status
	FROM pool a
	LEFT JOIN 
	(SELECT pool_id, GROUP_CONCAT(test_id) AS test_ids
	FROM test
	GROUP BY pool_id) b
	ON a.pool_id = b.pool_id
	WHERE pool_status = CASE WHEN i_pool_status IS NULL THEN pool_status
							ELSE i_pool_status END
	AND
    (
    (i_processed_by IS NOT NULL AND processed_by = i_processed_by AND pool_status != 'pending')
    OR
    (i_processed_by IS NULL)
    )
	AND
    (
	(i_begin_process_date IS NOT NULL AND i_end_process_date IS NOT NULL AND process_date >= i_begin_process_date AND process_date <= i_end_process_date AND pool_status != 'pending') 
	OR 
	(i_begin_process_date IS NULL AND i_end_process_date IS NOT NULL AND process_date <= i_end_process_date AND pool_status != 'pending')
	OR
	(i_begin_process_date IS NOT NULL AND i_end_process_date IS NULL AND (process_date >= i_begin_process_date OR process_date IS NULL))
	OR
	(i_begin_process_date IS NULL AND i_end_process_date IS NULL)
    );

-- End of solution
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `view_testers` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `view_testers`()
BEGIN
    DROP TABLE IF EXISTS view_testers_result;
    CREATE TABLE view_testers_result(

        username VARCHAR(40),
        name VARCHAR(80),
        phone_number VARCHAR(10),
        assigned_sites VARCHAR(255));

    INSERT INTO view_testers_result
-- Type solution below

    SELECT x.username, x.name, x.phone_number, y.assigned_sites
	FROM 
	(SELECT c.username, c.phone_number, CONCAT(d.fname, ' ', d.lname) AS name
	FROM
	(SELECT a.sitetester_username AS username, b.phone_num as phone_number
	FROM sitetester a
	LEFT JOIN employee b
	ON a.sitetester_username = b.emp_username) c
	LEFT JOIN user d
	ON c.username = d.username) x
	LEFT JOIN 
	(SELECT username, GROUP_CONCAT(site) AS assigned_sites
	FROM working_at
	GROUP BY username) y
	ON x.username = y.username;

-- End of solution
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

-- Dump completed on 2020-11-16 14:55:58
