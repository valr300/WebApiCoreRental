namespace WebApiCoreRental
{
    public class RentalUnit
    {
        public class Rental
        {
            public string Post { get; set; } = "";
            public string RegionName { get; set; } = "";
            public string RentName { get; set; } = "";
            public string ItemNumber { get; set; } = "";
            public string InvoiceRentId { get; set; } = "";
            public string Invoice { get; set; } = "";
            public int RentType { get; set; } = 0;
            public int PriceType { get; set; } = 0;
            public Decimal Price { get; set; } = 0;
            public int MaxPrim { get; set; } = 0;
            public int Sqm { get; set; } = 0;
            public int PrimTotal { get; set; } = 0;
            public int PrimFree { get; set; } = 0;
            public Decimal PricePerWeekSystem { get; set; } = 0;
            public DateTime RentalTimeStamp { get; set; }
            public DateTime RentalDateStart { get; set; }
            public DateTime RentalDateExpirency { get; set; }
            public string TenantName { get; set; } = "";
            public string TenantId { get; set; } = "";
            public string RentalAction { get; set; } = "";
            public Decimal NbDays { get; set; } = 0;
            public Decimal AmountSystem { get; set; } = 0;
            public string RentId { get; set; } = "";
            public string ParcelId { get; set; } = "";
            public string RentPosition { get; set; } = "";
            public string SnapshotId { get; set; } = "";
            public string LastUpdate { get; set; } = "";
            public int SendGroup { get; set; } = 0;
            public int Access { get; set; } = 0;
            public Decimal PricePerWeekReal { get; set; } = 0;
            public Decimal AmountReal { get; set; } = 0;
            public string PaymentMethod { get; set; } = "";

        }

     
    }
}
