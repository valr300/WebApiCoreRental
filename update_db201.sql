
# use this in case you are upgrading to version Rental system 2.01 and were using version 2.0


USE `Rental`;
RENAME table Rentals to RentalStats;
DROP procedure IF EXISTS `Rental`.`AddRental`;
DROP procedure IF EXISTS `Rental`.`AddRentalStats`;
DROP PROCEDURE IF EXISTS `Rental`.`EndFullUpdate`;

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

--DROP TABLE IF EXISTS `Rentals`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Rentals` (
  `RentId` varchar(36) NOT NULL,
  `RegionName` varchar(63) DEFAULT NULL,
  `RentName` varchar(127) DEFAULT NULL,
  `ParcelId` varchar(36) DEFAULT NULL,
  `RentType` int DEFAULT NULL,
  `RentPosition` varchar(45) DEFAULT NULL,
  `SnapshotId` varchar(36) DEFAULT NULL,
  `PriceType` int DEFAULT NULL,
  `Price` decimal(15,4) DEFAULT NULL,
  `MaxPrim` int DEFAULT NULL,
  `PricePerWeek` int DEFAULT NULL,
  `LastUpdate` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`RentId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


---
--- View Rentals_Details
---

CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `Rentals_Details` AS
    SELECT 
        `r`.`RegionName` AS `RegionName`,
        `r`.`RentName` AS `RentName`,
        `l`.`Name` AS `ParcelName`,
        `l`.`Description` AS `ParcelDescription`,
        `l`.`IsGroupOwned` AS `IsGroupOwned`,
        `l`.`Area` AS `Sqm`,
        (CASE
            WHEN (`r`.`RentType` = 0) THEN 'RentGroup'
            WHEN (`r`.`RentType` = 1) THEN 'RentOwner'
        END) AS `RentType`,
        (CASE
            WHEN (`r`.`PriceType` = -(1)) THEN 'Server'
            WHEN (`r`.`PriceType` = 0) THEN '$Sqm'
            WHEN (`r`.`PriceType` = 1) THEN '$Prim'
            WHEN (`r`.`PriceType` = 2) THEN '$Fixed'
        END) AS `PriceType`,
        (CASE
            WHEN (`r`.`Price` = -(1)) THEN 'Server'
            ELSE `r`.`Price`
        END) AS `Price`,
        (CASE
            WHEN (`r`.`MaxPrim` = -(1)) THEN 'Server'
            ELSE `r`.`MaxPrim`
        END) AS `MaxPrim`,
        `r`.`PricePerWeek` AS `PricePerWeek`,
        `r`.`RentPosition` AS `RentPosition`
    FROM
        (`Rentals` `r`
        JOIN `YOURDBSHEMA`.`land` `l` ON ((`l`.`UUID` = `r`.`ParcelId`)))
    ORDER BY `r`.`RegionName` , `r`.`RentName`


    
---
--- View Stats_Details
---


CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `Stats_Details` AS
    SELECT 
        `RentalStats`.`TenantName` AS `TenantName`,
        `RentalStats`.`RentalTimeStamp` AS `RentalTimeStamp`,
        `RentalStats`.`RentalAction` AS `RentalAction`,
        `RentalStats`.`RentalDateStart` AS `RentalDateStart`,
        `RentalStats`.`RentalDateExpirency` AS `RentalDateExpirency`,
        `RentalStats`.`Sqm` AS `Sqm`,
        `RentalStats`.`PrimTotal` AS `PrimTotal`,
        `RentalStats`.`PricePerWeek` AS `PricePerWeek`,
        `RentalStats`.`NbDays` AS `NbDays`,
        `RentalStats`.`Amount` AS `Amount`
    FROM
        `RentalStats`
    ORDER BY `RentalStats`.`RentalTimeStamp` DESC


---
--- View Stats_Last
---


CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `Stats_Last` AS
    SELECT 
        `rsd`.`RegionName` AS `RegionName`,
        `rsd`.`RentName` AS `RentName`,
        MAX(`rsd`.`RentalTimeStamp`) AS `LastRental`
    FROM
        `RentalStats` `rsd`
    WHERE
        (`rsd`.`RentalDateExpirency` >= NOW())
    GROUP BY `rsd`.`RegionName` , `rsd`.`RentName`

---
--- View Stats_RentedDetails
---


CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `Stats_RentedDetails` AS
    SELECT 
        `rsd`.`RegionName` AS `RegionName`,
        `rsd`.`RentName` AS `RentName`,
        `rsd`.`TenantName` AS `TenantName`,
        `rsd`.`TenantId` AS `TenantId`,
        `rsd`.`RentalAction` AS `LastAction`,
        `rsd`.`NbDays` AS `RentedDays`,
        `rsd`.`Amount` AS `AmountTransaction`,
        `rsd`.`RentalDateExpirency` AS `RentalDateExpirency`,
        `rsd`.`PricePerWeek` AS `PricePaidPerWeek`,
        (TO_DAYS(`rsd`.`RentalDateExpirency`) - TO_DAYS(NOW())) AS `RemainingDays`
    FROM
        (`Stats_Last` `rentaldet`
        JOIN `RentalStats` `rsd` ON (((`rsd`.`RegionName` = `rentaldet`.`RegionName`)
            AND (`rsd`.`RentName` = `rentaldet`.`RentName`)
            AND (`rsd`.`RentalTimeStamp` = `rentaldet`.`LastRental`))))
    WHERE
        (`rsd`.`RentalAction` <> 'Cancel')
    ORDER BY `rsd`.`RegionName` , `rsd`.`RentName` , `rsd`.`RentalTimeStamp` DESC
    
---
--- View Stats_Rented
---

CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `Stats_Rented` AS
    SELECT 
        `r`.`RegionName` AS `RegionName`,
        `r`.`RentName` AS `RentName`,
        `r`.`ParcelName` AS `ParcelName`,
        `r`.`ParcelDescription` AS `ParcelDescription`,
        `r`.`Sqm` AS `Sqm`,
        `r`.`MaxPrim` AS `MaxPrim`,
        `r`.`PriceType` AS `PriceType`,
        `r`.`Price` AS `Price`,
        `r`.`PricePerWeek` AS `PricePerWeek`,
        `det`.`TenantName` AS `TenantName`,
        `det`.`TenantId` AS `TenantId`,
        `det`.`LastAction` AS `LastAction`,
        `det`.`RentedDays` AS `RentedDays`,
        `det`.`AmountTransaction` AS `LastAmountPaid`,
        `det`.`RentalDateExpirency` AS `RentalDateExpirency`,
        `det`.`RemainingDays` AS `RemainingDays`,
        `det`.`PricePaidPerWeek` AS `PricePaidPerWeek`
    FROM
        (`Rentals_Details` `r`
        JOIN `Stats_RentedDetails` `det` ON (((`det`.`RegionName` = `r`.`RegionName`)
            AND (`det`.`RentName` = `r`.`RentName`))))
            



-- 
--  procedure AddRentals
--


DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `AddRentals`(
  RentId varchar(36),
  RegionName varchar(63),
  RentName varchar(63),
  ParcelId varchar(36),
  RentType int,
  RentPosition varchar(63),
  SnapshotId varchar(36),  
  PriceType int,
  Price decimal(15,6),
  MaxPrim int,
  PricePerWeek int,
  LastUpdate varchar(64)
  )
BEGIN
   if not exists(Select * from Rental.Rentals as v
	 		where v.RentId = RentId and v.RentName = RentName) then
        
	  INSERT INTO Rental.Rentals ( RentId, RegionName, RentName, ParcelId, RentType, RentPosition, SnapshotId, PriceType, Price, MaxPrim,PricePerWeek,LastUpdate  ) 
            VALUES ( RentId, RegionName, RentName, ParcelId, RentType, RentPosition, SnapshotId, PriceType, Price, MaxPrim, PricePerWeek,LastUpdate);
      else
      Update Rental.Rentals  v
        set v.RegionName= RegionName, v.ParcelId = ParcelId, v.RentType = RentType, v.RentPosition = RentPosition, v.SnapshotId=SnapshotId, 
            v.PriceType=PriceType, v.Price=Price, v.MaxPrim=MaxPrim,v.PricePerWeek=PricePerWeek,v.LastUpdate=LastUpdate 
		where  v.RentId = RentId and v.RentName = RentName	;
		

   end if;
  
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `AddRentalStats` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;



-- 
--  procedure AddRentalStats
--


DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `AddRentalStats`(
  RegionName varchar(63),
  RentName varchar(63),
  InvoiceRentId varchar(36),
  RentType int,
  PriceType int,
  Price decimal (15,6),
  MaxPrim int,
  Sqm int,
  PrimTotal int,
  PrimFree int,
  PricePerWeek int,
  RentalTimeStamp datetime,
  RentalDateStart datetime,
  RentalDateExpirency datetime,
  TenantName varchar(255),
  TenantId varchar(36),
  RentalAction varchar(12),
  NbDays decimal(15.4),
  Amount int
  )
BEGIN
  declare IdRental VARCHAR(36);
  
  set IdRental = uuid();       
   if not exists(Select * from Rental.RentalStats as v
	 		where v.RegionName = RegionName and v.RentName = RentName and v.RentalTimeStamp = RentalTimeStamp and v.TenantId=TenantId) then
        
	  INSERT INTO Rental.RentalStats ( IdRental, InvoiceRentId, RegionName, RentName, RentType, PriceType, Price, MaxPrim, Sqm, PrimTotal, PrimFree, PricePerWeek,
            RentalTimeStamp, RentalDateStart, RentalDateExpirency, TenantName, TenantId, RentalAction,NbDays, Amount) 
            VALUES ( IdRental, InvoiceRentId, RegionName, RentName, RentType, PriceType, Price, MaxPrim, Sqm, PrimTotal, PrimFree, PricePerWeek,
            RentalTimeStamp, RentalDateStart, RentalDateExpirency, TenantName, TenantId, RentalAction,NbDays, Amount);
			
		

   end if;
  
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `EndFullUpdate` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;

-- 
--  procedure EndFullUpdate
--


DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `EndFullUpdate`(
  RegionName varchar(63),
  LastUpdate varchar(64)
  )
BEGIN
 delete  v
   from Rental.Rentals  v
	where v.RegionName = RegionName and v.LastUpdate < LastUpdate;
		
  
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

-- Dump completed on 2024-05-19  8:24:22
