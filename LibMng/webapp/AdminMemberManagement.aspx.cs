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
    public partial class AdminMemberManagement : System.Web.UI.Page
    {
        string strcon = ConfigurationManager.ConnectionStrings["con"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                GridView1.DataBind();
                UpdateMemberCount();
            }

            // Check for toast message from previous operation
            if (Session["ToastMessage"] != null)
            {
                // The JavaScript will handle displaying the toast
            }
        }

        //Member ID Go button
        protected void LinkButton5_Click(object sender, EventArgs e)
        {
            getMemberByID();
        }

        //Active Button
        protected void LinkButton2_Click(object sender, EventArgs e)
        {
            UpdateMemberStatusID("Active");
        }

        //Pending Button
        protected void LinkButton3_Click(object sender, EventArgs e)
        {
            UpdateMemberStatusID("Pending");
        }

        //Deactivate Button
        protected void LinkButton4_Click(object sender, EventArgs e)
        {
            UpdateMemberStatusID("Inactive");
        }

        //Delete Button
        protected void Button2_Click(object sender, EventArgs e)
        {
            DeleteMemberByID();
        }

        // User Define Functions

        bool checkIfMemberExist()
        {
            if (string.IsNullOrEmpty(TextBox1.Text.Trim()))
            {
                Session["ToastMessage"] = "Please enter a Member ID!";
                Session["ToastType"] = "error";
                return false;
            }

            try
            {
                using (SqlConnection con = new SqlConnection(strcon))
                {
                    if (con.State == ConnectionState.Closed)
                    {
                        con.Open();
                    }

                    SqlCommand cmd = new SqlCommand("SELECT * FROM user_admin_tbl WHERE member_id = @memberId", con);
                    cmd.Parameters.AddWithValue("@memberId", TextBox1.Text.Trim());

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    if (dt.Rows.Count >= 1)
                    {
                        return true;
                    }
                    else
                    {
                        Session["ToastMessage"] = "Member ID does not exist!";
                        Session["ToastType"] = "error";
                        return false;
                    }
                }
            }
            catch (Exception ex)
            {
                Session["ToastMessage"] = "Error: " + ex.Message;
                Session["ToastType"] = "error";
                return false;
            }
        }

        void DeleteMemberByID()
        {
            if (checkIfMemberExist())
            {
                try
                {
                    using (SqlConnection con = new SqlConnection(strcon))
                    {
                        if (con.State == ConnectionState.Closed)
                        {
                            con.Open();
                        }

                        SqlCommand cmd = new SqlCommand("DELETE FROM user_admin_tbl WHERE member_id = @memberId", con);
                        cmd.Parameters.AddWithValue("@memberId", TextBox1.Text.Trim());

                        int rowsAffected = cmd.ExecuteNonQuery();

                        if (rowsAffected > 0)
                        {
                            Session["ToastMessage"] = "Member deleted successfully!";
                            Session["ToastType"] = "success";
                            clearForm();
                            GridView1.DataBind();
                            UpdateMemberCount();
                        }
                        else
                        {
                            Session["ToastMessage"] = "Error deleting member!";
                            Session["ToastType"] = "error";
                        }
                    }
                }
                catch (Exception ex)
                {
                    Session["ToastMessage"] = "Error: " + ex.Message;
                    Session["ToastType"] = "error";
                }
            }
            // Remove the else block since checkIfMemberExist() now handles the error
        }

        void getMemberByID()
        {
            if (string.IsNullOrEmpty(TextBox1.Text.Trim()))
            {
                Session["ToastMessage"] = "Please enter a Member ID!";
                Session["ToastType"] = "error";
                return;
            }

            try
            {
                using (SqlConnection con = new SqlConnection(strcon))
                {
                    if (con.State == ConnectionState.Closed)
                    {
                        con.Open();
                    }

                    SqlCommand cmd = new SqlCommand("SELECT * FROM user_admin_tbl WHERE member_id = @memberId", con);
                    cmd.Parameters.AddWithValue("@memberId", TextBox1.Text.Trim());

                    SqlDataReader dataReader = cmd.ExecuteReader();
                    if (dataReader.HasRows)
                    {
                        while (dataReader.Read())
                        {
                            TextBox2.Text = dataReader["full_name"].ToString();
                            TextBox5.Text = dataReader["account_status"].ToString();
                            TextBox3.Text = dataReader["email"].ToString();
                            TextBox4.Text = dataReader["contact_no"].ToString();
                            TextBox6.Text = dataReader["dob"].ToString();
                            TextBox7.Text = dataReader["state"].ToString();
                            TextBox8.Text = dataReader["city"].ToString();
                            TextBox9.Text = dataReader["pincode"].ToString();
                            TextBox10.Text = dataReader["full_address"].ToString();
                        }
                        Session["ToastMessage"] = "Member details loaded successfully!";
                        Session["ToastType"] = "success";
                    }
                    else
                    {
                        Session["ToastMessage"] = "Invalid Member ID!";
                        Session["ToastType"] = "error";
                        clearForm(); // Clear the form if member not found
                    }
                }
            }
            catch (Exception ex)
            {
                Session["ToastMessage"] = "Error: " + ex.Message;
                Session["ToastType"] = "error";
            }
        }

        void UpdateMemberStatusID(string status)
        {
            if (checkIfMemberExist())
            {
                try
                {
                    using (SqlConnection con = new SqlConnection(strcon))
                    {
                        if (con.State == ConnectionState.Closed)
                        {
                            con.Open();
                        }

                        SqlCommand cmd = new SqlCommand("UPDATE user_admin_tbl SET account_status = @status WHERE member_id = @memberId", con);
                        cmd.Parameters.AddWithValue("@status", status);
                        cmd.Parameters.AddWithValue("@memberId", TextBox1.Text.Trim());

                        int rowsAffected = cmd.ExecuteNonQuery();

                        if (rowsAffected > 0)
                        {
                            

                            // Store the updated member ID and status for JavaScript to update the grid
                            Session["UpdatedMemberId"] = TextBox1.Text.Trim();
                            Session["UpdatedStatus"] = status;

                            Session["ToastMessage"] = "Member status updated to " + status + "!";
                            Session["ToastType"] = "success";

                            // ✅ Set flag to clear form AFTER grid is updated
                            Session["ClearForm"] = true;
                            GridView1.DataBind(); // Refresh grid to show updated status
                            UpdateMemberCount();
                        }
                        else
                        {
                            Session["ToastMessage"] = "Error updating member status!";
                            Session["ToastType"] = "error";
                        }
                    }
                }
                catch (Exception ex)
                {
                    Session["ToastMessage"] = "Error: " + ex.Message;
                    Session["ToastType"] = "error";
                }
            }
            // Remove the else block since checkIfMemberExist() now handles the error
        }

        void clearForm()
        {
            TextBox1.Text = "";
            TextBox2.Text = "";
            TextBox3.Text = "";
            TextBox4.Text = "";
            TextBox5.Text = "";
            TextBox6.Text = "";
            TextBox7.Text = "";
            TextBox8.Text = "";
            TextBox9.Text = "";
            TextBox10.Text = "";
        }

        void UpdateMemberCount()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(strcon))
                {
                    if (con.State == ConnectionState.Closed)
                    {
                        con.Open();
                    }

                    SqlCommand cmd = new SqlCommand("SELECT COUNT(*) FROM user_admin_tbl", con);
                    int count = (int)cmd.ExecuteScalar();
                    lblTotalMembers.Text = count.ToString();
                }
            }
            catch (Exception ex)
            {
                lblTotalMembers.Text = "0";
                // Silent fail for count update
            }
        }

        // Method for status badge coloring (used in GridView)
        public string GetStatusClass(string status)
        {
            if (string.IsNullOrEmpty(status)) return "bg-secondary";

            switch (status.ToLower())
            {
                case "active": return "status-active";
                case "pending": return "status-pending";
                case "inactive": return "status-inactive";
                case "delete": return "status-inactive";
                default: return "bg-secondary";
            }
        }

        // GridView row data bound event for additional formatting if needed
        protected void GridView1_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                // Center the status cell content
                if (e.Row.Cells.Count > 2) // Make sure status column exists (3rd column)
                {
                    e.Row.Cells[2].HorizontalAlign = HorizontalAlign.Center;
                    e.Row.Cells[2].CssClass = "status-cell";
                }
            }
        }
    }
}