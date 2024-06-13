/ ******************************************************************* */
/*  Procedures                                                        */
/ ******************************************************************* */
USE `Rental`;
DROP procedure IF EXISTS `AddRentals`;

USE `Rental`;
DROP procedure IF EXISTS `Rental`.`AddRentals`;
;

DELIMITER $$
USE `Rental`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `AddRentals`(
  vRentId varchar(36),
  vRegionName varchar(63),
  vRentName varchar(63),
  vParcelId varchar(36),
  vRentType int,
  vRentPosition varchar(63), 
  vSnapshotId varchar(36),  
  vPriceType int,
  vPrice decimal(15,6),
  vMaxPrim int,
  vPricePerWeekSystem decimal(15,2),
  vLastUpdate varchar(64),
  vSendGroup int, 
  vAccess int,
  vPricePerWeekReal decimal(15,2),
  vItemNumber varchar(8)
  )
BEGIN
   if not exists(Select * from Rental.Rentals as r
	 		where r.RentId = vRentId and r.RentName = vRentName) then
        
	  INSERT INTO Rental.Rentals ( RentId, RegionName, RentName, ParcelId, RentType, RentPosition, SnapshotId, PriceType, Price, MaxPrim,PricePerWeekSystem,LastUpdate,SendGroup,Access,PricePerWeekReal,ItemNumber  ) 
            VALUES ( vRentId, vRegionName, vRentName, vParcelId, vRentType, vRentPosition, vSnapshotId, vPriceType, vPrice, vMaxPrim, vPricePerWeekSystem,vLastUpdate,vSendGroup,vAccess,vPricePerWeekReal,vItemNumber);
      else
      Update Rental.Rentals  r
        set r.RegionName= vRegionName, r.ParcelId = vParcelId, r.RentType = vRentType, r.RentPosition = vRentPosition, r.SnapshotId=vSnapshotId, 
            r.PriceType=vPriceType, r.Price=vPrice, r.MaxPrim=vMaxPrim,r.PricePerWeekSystem=vPricePerWeekSystem,r.LastUpdate=vLastUpdate ,
            r.SendGroup=vSendGroup, r.Access=vAccess, r.PricePerWeekReal=vPricePerWeekReal, r.ItemNumber=vItemNumber
		where  r.RentId = vRentId and r.RentName = vRentName	;
		

   end if;
  
END$$

DELIMITER ;
;


USE `Rental`;
DROP procedure IF EXISTS `AddRentalStats`;

USE `Rental`;
DROP procedure IF EXISTS `Rental`.`AddRentalStats`;
;

DELIMITER $$
USE `Rental`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `AddRentalStats`(
  vRegionName varchar(63),
  vRentName varchar(63),
  vInvoiceRentId varchar(36),
  vInvoice varchar(12),
  vRentType int,
  vPriceType int,
  vPrice decimal (15,6),
  vMaxPrim int,
  vSqm int,
  vPrimTotal int,
  vPrimFree int,
  vPricePerWeekSystem decimal(15,2),
  vRentalTimeStamp datetime,
  vRentalDateStart datetime,
  vRentalDateExpirency datetime,
  vTenantName varchar(255),
  vTenantId varchar(36),
  vRentalAction varchar(12),
  vNbDays decimal(15.4),
  vAmountSystem decimal(15,2),
  vPricePerWeekReal decimal(15,2),
  vAmountReal decimal(15,2),
  vPaymentMethod varchar(10),
  vItemNumber varchar(8)
  )
BEGIN
  declare IdRental VARCHAR(36);
  
  set IdRental = uuid();       
   if not exists(Select * from Rental.RentalStats as r
	 		where r.RegionName = vRegionName and r.RentName = vRentName and r.RentalTimeStamp = vRentalTimeStamp and r.TenantId=vTenantId) then
        
	  INSERT INTO Rental.RentalStats ( IdRental, InvoiceRentId, Invoice, RegionName, RentName, RentType, PriceType, Price, MaxPrim, Sqm, PrimTotal, PrimFree, PricePerWeekSystem,
            RentalTimeStamp, RentalDateStart, RentalDateExpirency, TenantName, TenantId, RentalAction,NbDays, AmountSystem, PricePerWeekReal, AmountReal, PaymentMethod, ItemNumber) 
            VALUES ( IdRental, vInvoiceRentId, vInvoice, vRegionName, vRentName, vRentType, vPriceType, vPrice, vMaxPrim, vSqm, vPrimTotal, vPrimFree, vPricePerWeekSystem,
            vRentalTimeStamp, vRentalDateStart, vRentalDateExpirency, vTenantName, vTenantId, vRentalAction, vNbDays, vAmountSystem,vPricePerWeekReal, vAmountReal, vPaymentMethod,vItemNumber);
			
		

   end if;
  
END$$

DELIMITER ;
;







USE `Rental`;
DROP procedure IF EXISTS `EndFullUpdate`;

USE `Rental`;
DROP procedure IF EXISTS `Rental`.`EndFullUpdate`;
;

DELIMITER $$
USE `Rental`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `EndFullUpdate`(
  vRegionName varchar(63),
  vLastUpdate varchar(64)
  )
BEGIN
 delete  r
   from Rental.Rentals  r
	where r.RegionName = vRegionName and r.LastUpdate < vLastUpdate;
		
  
END$$

DELIMITER ;
;




/ ******************************************************************* */
/*  VIEWS                                                              */
/ ******************************************************************* */

USE `Rental`;
CREATE 
     OR REPLACE ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `Rental`.`Stats_Details` AS
    SELECT 
        `r`.`RegionName` AS `RegionName`,
        `r`.`RentName` AS `RentName`,
        `r`.`ItemNumber` AS `ItemNumber`,
        `r`.`Invoice` AS `Invoice`,
        `r`.`PaymentMethod` AS `PaymentMethod`,
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
        `r`.`PricePerWeekSystem` AS `PricePerWeekSystem`,
        `r`.`PricePerWeekReal` AS `PricePerWeekReal`,
        `r`.`AmountSystem` AS `AmountSystem`,
        `r`.`AmountReal` AS `AmountReal`,
        `r`.`Sqm` AS `Sqm`,
        `r`.`PrimTotal` AS `PrimTotal`,
        `r`.`PrimFree` AS `PrimFree`,
        `r`.`RentalTimeStamp` AS `RentalTimeStamp`,
        `r`.`RentalDateStart` AS `RentalDateStart`,
        `r`.`RentalDateExpirency` AS `RentalDateExpirency`,
        `r`.`TenantName` AS `TenantName`,
        `r`.`TenantId` AS `TenantId`,
        `r`.`RentalAction` AS `RentalAction`,
        `r`.`NbDays` AS `NbDays`
    FROM
        `Rental`.`RentalStats` `r`
    ORDER BY `r`.`RentalTimeStamp` DESC;






USE `Rental`;
CREATE 
     OR REPLACE ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `Rental`.`Stats_RentedDetails` AS
    SELECT 
        `rsd`.`RegionName` AS `RegionName`, 
        `rsd`.`RentName` AS `RentName`,
        `rsd`.`TenantName` AS `TenantName`,
        `rsd`.`TenantId` AS `TenantId`,
        `rsd`.`RentalAction` AS `LastAction`,
        `rsd`.`NbDays` AS `RentedDays`,
        `rsd`.`AmountSystem` AS `AmountPaidSystem`,
        `rsd`.`AmountReal` AS `AmountPaidReal`,
        `rsd`.`PaymentMethod` AS `PaymentMethod`,
        `rsd`.`RentalDateExpirency` AS `RentalDateExpirency`,
        `rsd`.`PricePerWeekSystem` AS `PricePaidPerWeekSystem`,
        `rsd`.`PricePerWeekReal` AS `PricePaidPerWeekReal`,
        `rsd`.`RentalTimeStamp` AS `RentalTimeStamp`,
        (TO_DAYS(`rsd`.`RentalDateExpirency`) - TO_DAYS(NOW())) AS `RemainingDays`
    FROM
        (`Rental`.`Stats_Last` `rentaldet`
        JOIN `Rental`.`RentalStats` `rsd` ON (((`rsd`.`RegionName` = `Rental`.`rentaldet`.`RegionName`)
            AND (`rsd`.`RentName` = `Rental`.`rentaldet`.`RentName`)
            AND (`rsd`.`RentalTimeStamp` = `Rental`.`rentaldet`.`LastRental`))))
    WHERE
        (`rsd`.`RentalAction` <> 'Cancel')
    ORDER BY `rsd`.`RegionName` , `rsd`.`RentName` , `rsd`.`RentalTimeStamp` DESC;


USE `Rental`;
CREATE 
     OR REPLACE ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `Rental`.`Rentals_Details` AS
    SELECT 
        `r`.`RegionName` AS `RegionName`,
        `r`.`RentName` AS `RentName`,
        `r`.`ItemNumber` AS `ItemNumber`,
        `l`.`Name` AS `ParcelName`,
        `l`.`Description` AS `ParcelDescription`,
        `l`.`IsGroupOwned` AS `IsGroupOwned`,
        `l`.`Area` AS `Sqm`,
        (CASE
            WHEN (`r`.`Access` = 0) THEN 'NONE'
            WHEN (`r`.`Access` = 1) THEN 'PUBLIC'
            WHEN (`r`.`Access` = 2) THEN 'GROUP'
            ELSE '??'
        END) AS `Access`,
        (CASE
            WHEN (`r`.`RentType` = 0) THEN 'RentGroup'
            WHEN (`r`.`RentType` = 1) THEN 'RentOwner'
            ELSE '??'
        END) AS `RentType`,
        (CASE
            WHEN (`r`.`SendGroup` = 0) THEN 'OFF'
            WHEN (`r`.`SendGroup` = 1) THEN 'ON'
            ELSE '??'
        END) AS `SendGroup`,
        (CASE
            WHEN (`r`.`PriceType` = -(1)) THEN 'Server'
            WHEN (`r`.`PriceType` = 0) THEN '$Sqm'
            WHEN (`r`.`PriceType` = 1) THEN '$Prim'
            WHEN (`r`.`PriceType` = 2) THEN '$Fixed'
            ELSE '??'
        END) AS `PriceType`,
        (CASE
            WHEN (`r`.`Price` = -(1)) THEN 'Server'
            ELSE `r`.`Price`
        END) AS `Price`,
        (CASE
            WHEN (`r`.`MaxPrim` = -(1)) THEN 'Server'
            ELSE `r`.`MaxPrim`
        END) AS `MaxPrim`,
        `r`.`PricePerWeekSystem` AS `PricePerWeekSystem`,
        `r`.`PricePerWeekReal` AS `PricePerWeekReal`,
        IFNULL(`Rental`.`rd`.`RemainingDays`, 0) AS `RemainingDays`,
        `r`.`RentPosition` AS `RentPosition`
    FROM
        ((`Rental`.`Rentals` `r`
        JOIN `YOURSHEMADB`.`land` `l` ON ((`l`.`UUID` = `r`.`ParcelId`)))
        LEFT JOIN `Rental`.`Stats_RentedDetails` `rd` ON (((`Rental`.`rd`.`RegionName` = `r`.`RegionName`)
            AND (`Rental`.`rd`.`RentName` = `r`.`RentName`))))
    ORDER BY `r`.`RegionName` , `r`.`RentName`;





USE `Rental`;
CREATE 
     OR REPLACE ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `Rental`.`Stats_Rented` AS 
    SELECT 
        `Rental`.`r`.`RegionName` AS `RegionName`,
        `Rental`.`r`.`RentName` AS `RentName`,
        `Rental`.`r`.`ParcelName` AS `ParcelName`,
        `Rental`.`r`.`ParcelDescription` AS `ParcelDescription`,
        `Rental`.`r`.`Sqm` AS `Sqm`,
        `Rental`.`r`.`MaxPrim` AS `MaxPrim`,
        `Rental`.`r`.`PriceType` AS `PriceType`,
        `Rental`.`r`.`Price` AS `Price`,
        `Rental`.`r`.`PricePerWeekSystem` AS `PricePerWeekSystem`,
        `Rental`.`r`.`PricePerWeekReal` AS `PricePerWeekReal`,
        `Rental`.`det`.`TenantName` AS `TenantName`,
        `Rental`.`det`.`TenantId` AS `TenantId`,
        `Rental`.`det`.`LastAction` AS `LastAction`,
        `Rental`.`det`.`RentalTimeStamp` AS `LastDate`,
        `Rental`.`det`.`RentedDays` AS `RentedDays`,
        `Rental`.`det`.`AmountPaidSystem` AS `LastAmountSystem`,
        `Rental`.`det`.`AmountPaidReal` AS `LastAmountReal`,
        `Rental`.`det`.`RentalDateExpirency` AS `RentalDateExpirency`,
        `Rental`.`det`.`RemainingDays` AS `RemainingDays`,
        `Rental`.`det`.`PaymentMethod` AS `PaymentMethod`,
        `Rental`.`det`.`PricePaidPerWeekSystem` AS `PricePaidPerWeekSystem`,
        `Rental`.`det`.`PricePaidPerWeekReal` AS `PricePaidPerWeekReal`
    FROM
        (`Rental`.`Rentals_Details` `r`
        JOIN `Rental`.`Stats_RentedDetails` `det` ON (((`Rental`.`det`.`RegionName` = `Rental`.`r`.`RegionName`)
            AND (`Rental`.`det`.`RentName` = `Rental`.`r`.`RentName`))));


USE `Rental`;
CREATE 
     OR REPLACE ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `Rental`.`Stats_Last` AS
    SELECT  
        `rsd`.`RegionName` AS `RegionName`,
        `rsd`.`RentName` AS `RentName`,
        MAX(`rsd`.`RentalTimeStamp`) AS `LastRental`
    FROM
        `Rental`.`RentalStats` `rsd`
    WHERE
        (`rsd`.`RentalDateExpirency` >= NOW())
    GROUP BY `rsd`.`RegionName` , `rsd`.`RentName`;
