ALTER TABLE `Rental`.`Rentals` 
ADD COLUMN `SendGroup` INT NULL AFTER `LastUpdate`,
ADD COLUMN `Access` INT NULL AFTER `SendGroup`;


USE `Rental`;
DROP procedure IF EXISTS `AddRentals`;

USE `Rental`;
DROP procedure IF EXISTS `Rental`.`AddRentals`;
;

DELIMITER $$
USE `Rental`$$
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
  LastUpdate varchar(64),
  SendGroup int,
  Access int
  )
BEGIN
   if not exists(Select * from Rental.Rentals as v
	 		where v.RentId = RentId and v.RentName = RentName) then
        
	  INSERT INTO Rental.Rentals ( RentId, RegionName, RentName, ParcelId, RentType, RentPosition, SnapshotId, PriceType, Price, MaxPrim,PricePerWeek,LastUpdate,SendGroup,Access  ) 
            VALUES ( RentId, RegionName, RentName, ParcelId, RentType, RentPosition, SnapshotId, PriceType, Price, MaxPrim, PricePerWeek,LastUpdate,SendGroup,Access);
      else
      Update Rental.Rentals  v
        set v.RegionName= RegionName, v.ParcelId = ParcelId, v.RentType = RentType, v.RentPosition = RentPosition, v.SnapshotId=SnapshotId, 
            v.PriceType=PriceType, v.Price=Price, v.MaxPrim=MaxPrim,v.PricePerWeek=PricePerWeek,v.LastUpdate=LastUpdate ,
            v.SendGroup=SendGroup, v.Access=Access
		where  v.RentId = RentId and v.RentName = RentName	;
		

   end if;
  
END$$

DELIMITER ;
;


USE `Rental`;
CREATE 
     OR REPLACE ALGORITHM = UNDEFINED 
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
        (Case 
            when (`r`.`Access` = 0) THEN 'NONE'
            when (`r`.`Access` = 1) THEN 'PUBLIC'
            when (`r`.`Access` = 2) THEN 'GROUP'
            else "??"
         END) AS Access,         
        (CASE
            WHEN (`r`.`RentType` = 0) THEN 'RentGroup'
            WHEN (`r`.`RentType` = 1) THEN 'RentOwner'
            else "??"
        END) AS `RentType`,
        (Case 
            when (`r`.`SendGroup` = 0) THEN 'OFF'
            when (`r`.`SendGroup` = 1) THEN 'ON'
            else "??"
         END) as SendGroup,   
        (CASE
            WHEN (`r`.`PriceType` = -(1)) THEN 'Server'
            WHEN (`r`.`PriceType` = 0) THEN '$Sqm'
            WHEN (`r`.`PriceType` = 1) THEN '$Prim'
            WHEN (`r`.`PriceType` = 2) THEN '$Fixed'
            ELSE "??"
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
        JOIN `YOURSCHEMADB`.`land` `l` ON ((`l`.`UUID` = `r`.`ParcelId`)))
    ORDER BY `r`.`RegionName` , `r`.`RentName`;
