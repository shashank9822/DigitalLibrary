using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace webapp
{
    public partial class UserLogin : System.Web.UI.Page
    {
        string strcon = ConfigurationManager.ConnectionStrings["con"].ConnectionString;
        

        protected void Page_Load(object sender, EventArgs e)
        {

        }

        //user login
        protected void Button2_Click(object sender, EventArgs e)
        {
            try
            {
                SqlConnection con = new SqlConnection(strcon);
                if (con.State == System.Data.ConnectionState.Closed)
                {
                    con.Open();
                }
                SqlCommand cmd = new SqlCommand("select * from user_admin_tbl where member_id='" + userid.Text.Trim() + "' " +
                    "AND password='" + password.Value.Trim() + "'", con);

                SqlDataReader dataReader = cmd.ExecuteReader();
                if (dataReader.HasRows)
                {
                    while (dataReader.Read())
                    {
                        Response.Write("<script>alert('Login successful');</script>");
                        Session["username"] = dataReader.GetValue(8).ToString();
                        Session["fullname"] = dataReader.GetValue(0).ToString();
                        Session["role"] = "user";
                        Session["status"] = dataReader.GetValue(10).ToString();
                    }
                    Response.Redirect("Homepage.aspx");
                   
                }
                else
                {
                    Response.Write("<script>alert('Invalid Data');</script>");
                }


            }
            catch (Exception ex)
            {

                throw;
            }
        }

        // user defined function
    }
}