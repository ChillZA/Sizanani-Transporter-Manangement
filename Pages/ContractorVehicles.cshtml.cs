using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.Data.SqlClient;
using System.ComponentModel;

namespace Sizanani_Transporter_Manangement.Pages
{

    public class ContractorVehiclesModel : PageModel
    {
        private readonly IConfiguration _configuration;

        public ContractorVehiclesModel(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        [BindProperty]
        public string contractorId { get; set; }

        public List<SelectListItem> contractors { get; set; }

        public List<Transporter.DisplayVehicle> vehicles { get; set; }

        

        public void OnGet()
        {
            contractors = GetContractors();
        }

        public IActionResult OnPost()
        {
            vehicles = GetVehicles(int.Parse(contractorId));
            return Page();
        }

        public List<SelectListItem> GetContractors()
        {
            var contractorList = new List<SelectListItem>();
            string connString = _configuration.GetConnectionString("sl_conn");
            using (SqlConnection conn = new SqlConnection(connString))
            {
                using (SqlCommand regComm = new SqlCommand("GetContractors", conn))
                {
                    regComm.CommandType = System.Data.CommandType.StoredProcedure;

                    conn.Open();
                        using(SqlDataReader reader = regComm.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            contractorList.Add(new SelectListItem() { Value = reader["id"].ToString(), Text = reader["name"].ToString() });
                        }
                    }                    
                }
            }
            return contractorList;
        }

        public List<Transporter.DisplayVehicle> GetVehicles(int contractorId)
        {
            var contractorList = new List<Transporter.DisplayVehicle>();
            string connString = _configuration.GetConnectionString("sl_conn");
            using (SqlConnection conn = new SqlConnection(connString))
            {
                using (SqlCommand regComm = new SqlCommand("GetContractorVehicles", conn))
                {
                    regComm.CommandType = System.Data.CommandType.StoredProcedure;

                    regComm.Parameters.AddWithValue("@contractor_id", contractorId);

                    conn.Open();
                    using (SqlDataReader reader = regComm.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            contractorList.Add(new Transporter.DisplayVehicle() { TypeName = reader["type_name"].ToString(), Registration_Number = reader["reg_number"].ToString(), Model = reader["model"].ToString(), Weight = Int32.Parse(reader["weight"].ToString()) });
                        }
                    }
                }
            }
            return contractorList;
        }
    }
}
