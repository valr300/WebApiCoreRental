namespace WebApiCoreRental
{
    public class RentalUnit
    {
        public class Rental
        {
            public string RegionName { get; set; } = "";
            public string RentName { get; set; } = "";
            public DateTime RentalTimeStamp { get; set; }
            public DateTime RentalDateExpirency { get; set; }
            public string RenterName { get; set; } = "";
            public string IdRenter { get; set; } = "";
            public string RenterGender { get; set; } = "";
            public string RentalAction { get; set; } = "";
            public string NbDays { get; set; } = "";
            public string Amount { get; set; } = "";

        }
    }
}
