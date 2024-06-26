CREATE DATABASE  IF NOT EXISTS `Rental` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `Rental`;
-- MySQL dump 10.13  Distrib 8.0.31, for Win64 (x86_64)
--
-- Host: localhost    Database: Rental
-- ------------------------------------------------------
-- Server version	8.0.36-0ubuntu0.22.04.1

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
-- Table structure for table `Rentals`
--

DROP TABLE IF EXISTS `Rentals`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Rentals` (
  `RentId` varchar(36) NOT NULL,
  `RegionName` varchar(63) DEFAULT NULL,
  `RentName` varchar(127) DEFAULT NULL,
  `ItemNumber` varchar(8) DEFAULT NULL,
  `ParcelId` varchar(36) DEFAULT NULL,
  `RentType` int DEFAULT NULL,
  `RentPosition` varchar(45) DEFAULT NULL,
  `SnapshotId` varchar(36) DEFAULT NULL,
  `PriceType` int DEFAULT NULL,
  `Price` decimal(15,4) DEFAULT NULL,
  `MaxPrim` int DEFAULT NULL,
  `LastUpdate` varchar(64) DEFAULT NULL,
  `SendGroup` int DEFAULT NULL,
  `Access` int DEFAULT NULL,
  `PricePerWeekSystem` decimal(15,2) DEFAULT NULL,
  `PricePerWeekReal` decimal(15,2) DEFAULT NULL,
  PRIMARY KEY (`RentId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-06-12 13:30:04


CREATE DATABASE  IF NOT EXISTS `Rental` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `Rental`;
-- MySQL dump 10.13  Distrib 8.0.31, for Win64 (x86_64)
--
-- Host: localhost    Database: Rental
-- ------------------------------------------------------
-- Server version	8.0.36-0ubuntu0.22.04.1

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
-- Table structure for table `RentalStats`
--

DROP TABLE IF EXISTS `RentalStats`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `RentalStats` (
  `IdRental` varchar(36) NOT NULL,
  `InvoiceRentId` varchar(36) DEFAULT NULL,
  `Invoice` varchar(12) DEFAULT NULL,
  `RegionName` varchar(63) DEFAULT NULL,
  `RentName` varchar(63) DEFAULT NULL,
  `ItemNumber` varchar(8) DEFAULT NULL,
  `RentType` int DEFAULT NULL,
  `PriceType` int DEFAULT NULL,
  `Price` decimal(15,4) DEFAULT NULL,
  `MaxPrim` int DEFAULT NULL,
  `Sqm` int DEFAULT NULL,
  `PrimTotal` int DEFAULT NULL,
  `PrimFree` int DEFAULT NULL,
  `RentalTimeStamp` datetime DEFAULT NULL,
  `RentalDateStart` datetime DEFAULT NULL,
  `RentalDateExpirency` datetime DEFAULT NULL,
  `TenantName` varchar(255) DEFAULT NULL,
  `TenantId` varchar(36) DEFAULT NULL,
  `RentalAction` varchar(12) DEFAULT NULL,
  `NbDays` decimal(15,4) DEFAULT NULL,
  `PricePerWeekSystem` decimal(15,2) DEFAULT NULL,
  `PricePerWeekReal` decimal(15,2) DEFAULT NULL,
  `AmountReal` decimal(15,2) DEFAULT NULL,
  `AmountSystem` decimal(15,2) DEFAULT NULL,
  `PaymentMethod` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`IdRental`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Contains all Rental';
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-06-12 13:30:06


