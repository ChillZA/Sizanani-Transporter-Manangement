using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.Data.SqlClient;

namespace Sizanani_Transporter_Manangement.Pages
{
    public class VehicleModel : PageModel
    {
        private readonly IConfiguration _configuration;

        public VehicleModel(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        [BindProperty]
        public Transporter.Vehicle Vehicle { get; set; }

        public List<SelectListItem> vehicleTypes = new List<SelectListItem>
        {
            new SelectListItem {Value = "1", Text = "Truck"},
            new SelectListItem {Value = "2", Text = "Trailer"}
        };

        public void OnGet()
        {
        }

        public IActionResult OnPost()
        {
            if (!ModelState.IsValid)
            {
                return Page();
            }

            if (RegisterVehicle(Vehicle.TypeId, Vehicle.Registration_Number, Vehicle.Model, Vehicle.Weight) == 0)
            {
                return RedirectToPage("/Index");
            }
            else
            {
                return Page();
            }
        }

        public int RegisterVehicle(string type, string regNum, string model, int weight)
        {
            int vehicleType = Int32.Parse(type);
            
            string connString = _configuration.GetConnectionString("sl_conn");
            using (SqlConnection conn = new SqlConnection(connString))
            {
                using (SqlCommand regComm = new SqlCommand("RegisterVehicle", conn))
                {
                    regComm.CommandType = System.Data.CommandType.StoredProcedure;

                    regComm.Parameters.AddWithValue("@type_id", vehicleType);
                    regComm.Parameters.AddWithValue("@reg_nr", regNum);
                    regComm.Parameters.AddWithValue("@model", model);
                    regComm.Parameters.AddWithValue("@weight", weight);

                    conn.Open();
                    try
                    {
                        regComm.ExecuteNonQuery();
                    }
                    catch (Exception ex)
                    {
                        return 1;
                    }
                }
            }
            return 0;
        }
    }
}