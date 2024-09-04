using System.Configuration;
using System.Diagnostics;
using Google.Protobuf;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using MySql.Data.MySqlClient;
using MySqlX.XDevAPI.Relational;
using static WebApiCoreRental.RentalUnit;

namespace WebApiCoreRental.Controllers
{
    [ApiController]
    [Route("[controller]")]

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
            string sp = aRent.Post;
            string retData = "";
            try
            {

                string connStr = _configuration.GetSection("ConnectionStrings").GetSection("RentalApi").Value;
               // UtilTrace.AddTrace(_configuration, "RentalAPI", "Start", 1, "", null);

                if (   sp != "AddRentalStats" && sp != "AddRentals" && sp != "EndFullUpdate") 
                     return "";  

                MySqlConnection conn = new MySqlConnection(connStr);
                MySqlCommand cmd = new MySqlCommand(sp, conn);
                cmd.CommandType = System.Data.CommandType.StoredProcedure; 

                if (sp== "AddRentalStats")
                {
                    cmd.Parameters.AddWithValue("@vRegionName", aRent.RegionName);
                    cmd.Parameters.AddWithValue("@vRentName", aRent.RentName);
                    cmd.Parameters.AddWithValue("@vInvoiceRentId", aRent.InvoiceRentId);
                    cmd.Parameters.AddWithValue("@vInvoice", aRent.Invoice);
                    cmd.Parameters.AddWithValue("@vRentType", aRent.RentType);
                    cmd.Parameters.AddWithValue("@vPriceType", aRent.PriceType);
                    cmd.Parameters.AddWithValue("@vPrice", aRent.Price);
                    cmd.Parameters.AddWithValue("@vMaxPrim", aRent.MaxPrim);
                    cmd.Parameters.AddWithValue("@vSqm", aRent.Sqm);
                    cmd.Parameters.AddWithValue("@vPrimTotal", aRent.PrimTotal);
                    cmd.Parameters.AddWithValue("@vPrimFree", aRent.PrimFree);
                    cmd.Parameters.AddWithValue("@vPricePerWeekSystem", aRent.PricePerWeekSystem);
                    cmd.Parameters.AddWithValue("@vRentalTimeStamp", aRent.RentalTimeStamp);
                    cmd.Parameters.AddWithValue("@vRentalDateStart", aRent.RentalDateStart);
                    cmd.Parameters.AddWithValue("@vRentalDateExpirency", aRent.RentalDateExpirency);
                    cmd.Parameters.AddWithValue("@vTenantName", aRent.TenantName);
                    cmd.Parameters.AddWithValue("@vTenantId", aRent.TenantId);
                    cmd.Parameters.AddWithValue("@vRentalAction", aRent.RentalAction);
                    cmd.Parameters.AddWithValue("@vNbDays", aRent.NbDays);
                    cmd.Parameters.AddWithValue("@vAmountSystem", aRent.AmountSystem);
                    cmd.Parameters.AddWithValue("@vPricePerWeekReal", aRent.PricePerWeekReal);
                    cmd.Parameters.AddWithValue("@vAmountReal", aRent.AmountReal);
                    cmd.Parameters.AddWithValue("@vPaymentMethod", aRent.PaymentMethod);
                    cmd.Parameters.AddWithValue("@vItemNumber", aRent.ItemNumber);
                    retData = "Added Stats  " + aRent.RentName;
                }
                if (sp== "AddRentals")
                {
                    cmd.Parameters.AddWithValue("@vRentId", aRent.RentId);
                    cmd.Parameters.AddWithValue("@vRegionName", aRent.RegionName);
                    cmd.Parameters.AddWithValue("@vRentName", aRent.RentName);
                    cmd.Parameters.AddWithValue("@vParcelId", aRent.ParcelId);
                    cmd.Parameters.AddWithValue("@vRentType", aRent.RentType);
                    cmd.Parameters.AddWithValue("@vRentPosition", aRent.RentPosition);
                    cmd.Parameters.AddWithValue("@vSnapshotId", aRent.SnapshotId);
                    cmd.Parameters.AddWithValue("@vPriceType", aRent.PriceType);
                    cmd.Parameters.AddWithValue("@vPrice", aRent.Price);
                    cmd.Parameters.AddWithValue("@vMaxPrim", aRent.MaxPrim);
                    cmd.Parameters.AddWithValue("@vPricePerWeekSystem", aRent.PricePerWeekSystem);
                    cmd.Parameters.AddWithValue("@vLastUpdate", aRent.LastUpdate);
                    cmd.Parameters.AddWithValue("@vSendGroup", aRent.SendGroup);
                    cmd.Parameters.AddWithValue("@vAccess", aRent.Access);
                    cmd.Parameters.AddWithValue("@vPricePerWeekReal", aRent.PricePerWeekReal);
                    cmd.Parameters.AddWithValue("@vItemNumber", aRent.ItemNumber);
                    retData = "Added Rentals " + aRent.RentName;
                }
                if (sp == "EndFullUpdate")
                {
                    cmd.Parameters.AddWithValue("@vRegionName", aRent.RegionName);
                    cmd.Parameters.AddWithValue("@vLastUpdate", aRent.LastUpdate);
                }
                trace += "\n4";
                conn.Open();

                rows = cmd.ExecuteNonQuery();
                conn.Close();
            }
            catch (Exception ex)
            {
                return string.Format("Exception = " + ex.Message + " \n" + trace + "\n" + ex.ToString(), rows);

            }

            return retData;
        }

     /*   [HttpPost(Name = "AddRent")]
        // POST: api/RM
        //   [ResponseType(typeof(string))]
        public string AddRent(RentalUnit.Rental aRent)
        {
            int rows = -1;
            string trace = "";
            try
            {

                string connStr = _configuration.GetSection("ConnectionStrings").GetSection("RentalApi").Value;

                MySqlConnection conn = new MySqlConnection(connStr);
                MySqlCommand cmd = new MySqlCommand("AddRent", conn);
                cmd.CommandType = System.Data.CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@RentId", aRent.RentId);
                cmd.Parameters.AddWithValue("@RegionName", aRent.RegionName);
                cmd.Parameters.AddWithValue("@RentName", aRent.RentName);
                cmd.Parameters.AddWithValue("@ParcelId", aRent.ParcelId);
                cmd.Parameters.AddWithValue("@RentType", aRent.RentType);
                cmd.Parameters.AddWithValue("@RentPosition", aRent.RentPosition);
                cmd.Parameters.AddWithValue("@SnapshotId", aRent.SnapshotId);
                cmd.Parameters.AddWithValue("@PriceType", aRent.PriceType);
                cmd.Parameters.AddWithValue("@Price", aRent.Price);
                cmd.Parameters.AddWithValue("@MaxPrim", aRent.MaxPrim);
                cmd.Parameters.AddWithValue("@PricePerWeek", aRent.PricePerWeek);
                cmd.Parameters.AddWithValue("@UpdateFlag", aRent.UpdateFlag);

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

        [HttpPost(Name = "EndUpdateRent")]
        // POST: api/RM
        //   [ResponseType(typeof(string))]
        public string EndUpdate(RentalUnit.Rental aEndUpdateRent)
        {
            int rows = -1;
            string trace = "";
            try
            {

                string connStr = _configuration.GetSection("ConnectionStrings").GetSection("RentalApi").Value;

                MySqlConnection conn = new MySqlConnection(connStr);
                MySqlCommand cmd = new MySqlCommand("EndUpdateRent", conn);
                cmd.CommandType = System.Data.CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@UpdateFlag", aEndUpdateRent.UpdateFlag);

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
       */
    }

   

}
