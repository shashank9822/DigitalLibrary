using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace webapp
{
    public partial class UserSignUp : System.Web.UI.Page
    {
        string strcon = ConfigurationManager.ConnectionStrings["con"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {

        }

        // Signup button click event
        protected void Button1_Click(object sender, EventArgs e)
        {
            if (Page.IsValid) // Check for page validation
            {
                if (checkUserExists())
                {
                    Response.Write("<script>alert('User Already Exists with this ID');</script>");
                }
                else
                {
                    signUpNewUser();
                }
            }
        }

        // Check if user already exists
        bool checkUserExists()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(strcon))
                {
                    if (con.State == ConnectionState.Closed)
                    {
                        con.Open();
                    }

                    SqlCommand cmd = new SqlCommand("SELECT * FROM user_admin_tbl WHERE member_id = @memberId", con);
                    cmd.Parameters.AddWithValue("@memberId", memberid.Text.Trim());

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    if (dt.Rows.Count >= 1) // Returns true if user exists
                    {
                        return true;
                    }
                    else
                    {
                        return false;
                    }
                }
                
            }
            catch (Exception ex)
            {
                Response.Write("<script>alert('" + ex.Message + "');</script>");
                return false;
            }
        }

        // Sign up new user
        void signUpNewUser()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(strcon))
                {
                    if (con.State == ConnectionState.Closed)
                    {
                        con.Open();
                    }

                    SqlCommand cmd = new SqlCommand("INSERT INTO user_admin_tbl(full_name, dob, contact_no, email, state, city, pincode, full_address, member_id, password, account_status) " +
                                                      "VALUES (@full_name, @dob, @contact_no, @email, @state, @city, @pincode, @full_address, @member_id, @password, @account_status)", con);

                    // Parameter assignment
                    cmd.Parameters.AddWithValue("@full_name", fullname.Text.Trim());
                    cmd.Parameters.AddWithValue("@dob", dob.Text.Trim());
                    cmd.Parameters.AddWithValue("@contact_no", contact.Text.Trim());
                    cmd.Parameters.AddWithValue("@email", email.Text.Trim());
                    cmd.Parameters.AddWithValue("@state", state.Text);
                    cmd.Parameters.AddWithValue("@city", city.Text.Trim());
                    cmd.Parameters.AddWithValue("@pincode", pincode.Text.Trim());
                    cmd.Parameters.AddWithValue("@full_address", address.Text.Trim());
                    cmd.Parameters.AddWithValue("@member_id", memberid.Text.Trim());
                    cmd.Parameters.AddWithValue("@password", password.Text.Trim());
                    cmd.Parameters.AddWithValue("@account_status", "pending");

                    cmd.ExecuteNonQuery();
                    con.Close();
                    Response.Write("<script>alert('Sign Up Successful. Go to user Login to Login');</script>");

                    ClearFields(); // Clear fields after successful signup
                }
            }
            catch (Exception ex)
            {
                Response.Write("<script>alert('" + ex.Message + "');</script>");
            }
        }

        // Clear input fields after successful signup
        private void ClearFields()
        {
            fullname.Text = string.Empty;
            dob.Text = string.Empty;
            email.Text = string.Empty;
            contact.Text = string.Empty;
            state.SelectedIndex = 0; // Reset to "Select a State"
            city.Text = string.Empty;
            pincode.Text = string.Empty;
            address.Text = string.Empty;
            memberid.Text = string.Empty;
            password.Text = string.Empty;
        }
    }
}
