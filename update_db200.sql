


# use this in case you are upgrading to version Rental system 2.0 and were using database prior to the version, else simply run the install scripts.

ALTER TABLE Rentals CHANGE RenterName TenantName varchar(255);
ALTER TABLE Rentals CHANGE IdRenter TenantId varchar(36);

DROP PROCEDURE IF EXISTS  `Rental`.`AddRental`;

CREATE DEFINER=`root`@`localhost` PROCEDURE `AddRental`(
  RegionName varchar(63),
  RentName varchar(63),
  InvoiceRentId varchar(36),
  RentType int,
  PriceType int,
  Price decimal,
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
  NbDays decimal,
  Amount int
  )
BEGIN
  declare IdRental VARCHAR(36);
  
  set IdRental = uuid();       
   if not exists(Select * from Rental.Rentals as v
	 		where v.RegionName = RegionName and v.RentName = RentName and v.RentalTimeStamp = RentalTimeStamp and v.TenantId=TenantId) then
        
	  INSERT INTO Rental.Rentals ( IdRental, InvoiceRentId, RegionName, RentName, RentType, PriceType, Price, MaxPrim, Sqm, PrimTotal, PrimFree, PricePerWeek,
            RentalTimeStamp, RentalDateStart, RentalDateExpirency, TenantName, TenantId, RentalAction,NbDays, Amount) 
            VALUES ( IdRental, InvoiceRentId, RegionName, RentName, RentType, PriceType, Price, MaxPrim, Sqm, PrimTotal, PrimFree, PricePerWeek,
            RentalTimeStamp, RentalDateStart, RentalDateExpirency, TenantName, TenantId, RentalAction,NbDays, Amount);
			
		

   end if;
  
END