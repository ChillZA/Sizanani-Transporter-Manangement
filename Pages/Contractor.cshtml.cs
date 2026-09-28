using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.Data.SqlClient;

namespace Sizanani_Transporter_Manangement.Pages
{

    public class ContractorModel : PageModel
    {
        private readonly IConfiguration _configuration;

        public ContractorModel(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        [BindProperty]
        public Transporter.Contractor Contractor { get; set; }

        public void OnGet()
        {
        }

        public IActionResult OnPost()
        {
            if (!ModelState.IsValid)
            {
                return Page();
            }

            if(RegisterContractor(Contractor.Name, Contractor.Email, Contractor.Phone) == 0)
            {

                return RedirectToPage("/Index");
            }
            else
            {
                return Page();
            }
        }

        public int RegisterContractor(string name, string email, string phone)
        {   
            string connString = _configuration.GetConnectionString("sl_conn");
            using (SqlConnection conn = new SqlConnection(connString))
            {
                using (SqlCommand regComm = new SqlCommand("RegisterContractor", conn))
                {
                    regComm.CommandType = System.Data.CommandType.StoredProcedure;

                    regComm.Parameters.AddWithValue("@name", name);
                    regComm.Parameters.AddWithValue("@email", email);
                    regComm.Parameters.AddWithValue("@phone", phone);

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
