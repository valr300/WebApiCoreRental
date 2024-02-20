using Microsoft.AspNetCore.Mvc;
using MySql.Data.MySqlClient;

namespace WebApiCoreRental.Controllers
{
    public class RUController : Controller
    {
        // requires using Microsoft.Extensions.Configuration;
        private readonly IConfiguration _configuration;

        public RUController(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        [HttpPost(Name = "AddRental")]
        // POST: api/RM
        //   [ResponseType(typeof(string))]
        public string AddRental( RentalUnit.Rental aRent)
        {
            int rows = -1;
            string trace = "";
            try
            {

                string connStr = _configuration.GetSection("ConnectionStrings").GetSection("RegionMonitor").Value;


                MySqlConnection conn = new MySqlConnection(connStr);
                MySqlCommand cmd = new MySqlCommand("AddRental", conn);
                cmd.CommandType = System.Data.CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@RegionName", aRent.RegionName);
                cmd.Parameters.AddWithValue("@RentName", aRent.RentName);
                cmd.Parameters.AddWithValue("@RentalTimeStamp", aRent.RentalTimeStamp);
                cmd.Parameters.AddWithValue("@RentalDateExpirency", aRent.RentalDateExpirency);
                cmd.Parameters.AddWithValue("@RenterName", aRent.RenterName);
                cmd.Parameters.AddWithValue("@IdRenter", aRent.IdRenter);
                cmd.Parameters.AddWithValue("@RenterGender", aRent.RenterGender);
                cmd.Parameters.AddWithValue("@RentalAction", aRent.RentalAction);
                cmd.Parameters.AddWithValue("@NbDays", aRent.NbDays);
                cmd.Parameters.AddWithValue("@Amount", aRent.Amount);
                trace += "\n4";
                conn.Open();

                rows = cmd.ExecuteNonQuery();
                conn.Close();
            }
            catch (Exception ex)
            {
                return string.Format("Exception = " + ex.Message + " \n" + trace + "\n" + ex.ToString(), rows);

            }

            return rows.ToString();
        }
    }
}
