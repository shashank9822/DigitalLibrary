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
    public partial class AsminLogin : System.Web.UI.Page
    {
        string strcon = ConfigurationManager.ConnectionStrings["con"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {

        }

        //login button click e
        protected void LinkButton1_Click(object sender, EventArgs e)
        {
            try
            {
                SqlConnection con = new SqlConnection(strcon);
                if (con.State == System.Data.ConnectionState.Closed)
                {
                    con.Open();
                }
                SqlCommand cmd = new SqlCommand("select * from admin_login_tbl where username='" + adminid.Value.Trim() + "' " +
                    "AND password='" + password.Value.Trim() + "'", con);

                SqlDataReader dataReader = cmd.ExecuteReader();
                if (dataReader.HasRows)
                {
                    while (dataReader.Read())
                    {
                        //Response.Write("<script>alert(' " + dataReader.GetValue(0).ToString() + "');</script>");
                        Session["username"] = dataReader.GetValue(0).ToString();
                        Session["fullname"] = dataReader.GetValue(2).ToString();
                        Session["role"] = "admin";
                        //Session["status"] = dataReader.GetValue(10).ToString();

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

                Response.Write("<script>alert(' "+ex.Message+" ');</script>");
            }
        }
    }
}