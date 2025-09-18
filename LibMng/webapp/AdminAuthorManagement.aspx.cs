using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace webapp
{
    public partial class AdminAuthorManagement : System.Web.UI.Page
    {
        string strcon = ConfigurationManager.ConnectionStrings["con"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            GridView1.DataBind();

            // Check for toast message from previous operation
            if (Session["ToastMessage"] != null)
            {
                // The JavaScript will handle displaying the toast
            }
        }

        // Add clickbutton event
        protected void Button1_Click(object sender, EventArgs e)
        {
            if (checkIfAuthorExist())
            {
                Session["ToastMessage"] = "Author ID already exists!";
                Session["ToastType"] = "error";
            }
            else
            {
                addNewAuthor();
            }
        }

        // Delete clickbutton event
        protected void Button2_Click(object sender, EventArgs e)
        {
            if (checkIfAuthorExist())
            {
                deleteAuthor();
            }
            else
            {
                Session["ToastMessage"] = "Author ID does not exist!";
                Session["ToastType"] = "error";
            }
        }

        // Update clickbutton event
        protected void Button3_Click(object sender, EventArgs e)
        {
            if (checkIfAuthorExist())
            {
                updateAuthor();
            }
            else
            {
                Session["ToastMessage"] = "Author ID does not exist!";
                Session["ToastType"] = "error";
            }
        }

        // Go clickbutton event
        protected void LinkButton1_Click(object sender, EventArgs e)
        {
            getAuthorById();
        }

        // Clear button event
        protected void Button4_Click(object sender, EventArgs e)
        {
            ClearFields();
            Session["ToastMessage"] = "Form cleared!";
            Session["ToastType"] = "info";
        }

        // Refresh button event
        protected void btnRefresh_Click(object sender, EventArgs e)
        {
            GridView1.DataBind();
            Session["ToastMessage"] = "Data refreshed!";
            Session["ToastType"] = "info";
        }

        // Select author from gridview
        protected void lnkSelect_Click(object sender, EventArgs e)
        {
            LinkButton btn = (LinkButton)sender;
            string authorId = btn.CommandArgument;

            // Populate the form with selected author
            TextBox1.Text = authorId;
            getAuthorById(); // This will fetch and populate the author name

            Session["ToastMessage"] = "Author selected!";
            Session["ToastType"] = "info";
        }

        // GridView row data bound event
        protected void GridView1_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            // Add command argument to select buttons
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                LinkButton selectButton = (LinkButton)e.Row.FindControl("lnkSelect");
                if (selectButton != null)
                {
                    // Set the command argument to the author_id
                    DataRowView rowView = (DataRowView)e.Row.DataItem;
                    selectButton.CommandArgument = rowView["author_id"].ToString();
                }
            }
        }

        // Author Define Function
        void getAuthorById()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(strcon))
                {
                    if (con.State == ConnectionState.Closed)
                    {
                        con.Open();
                    }

                    SqlCommand cmd = new SqlCommand("SELECT * FROM author_admin_tbl WHERE author_id = @authorId", con);
                    cmd.Parameters.AddWithValue("@authorId", TextBox1.Text.Trim());

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    if (dt.Rows.Count >= 1) // Returns true if user exists
                    {
                        TextBox2.Text = dt.Rows[0][1].ToString();
                        Session["ToastMessage"] = "Author retrieved successfully!";
                        Session["ToastType"] = "success";
                    }
                    else
                    {
                        Session["ToastMessage"] = "Invalid Author ID!";
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

        void deleteAuthor()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(strcon))
                {
                    if (con.State == ConnectionState.Closed)
                    {
                        con.Open();
                    }

                    SqlCommand cmd = new SqlCommand("DELETE from author_admin_tbl WHERE author_id=@author_id", con);
                    cmd.Parameters.AddWithValue("@author_id", TextBox1.Text.Trim());

                    int rowsAffected = cmd.ExecuteNonQuery();
                    con.Close();

                    if (rowsAffected > 0)
                    {
                        Session["ToastMessage"] = "Author deleted successfully!";
                        Session["ToastType"] = "success";
                        ClearFields();
                        GridView1.DataBind();
                    }
                    else
                    {
                        Session["ToastMessage"] = "Error deleting author!";
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

        void updateAuthor()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(strcon))
                {
                    if (con.State == ConnectionState.Closed)
                    {
                        con.Open();
                    }

                    SqlCommand cmd = new SqlCommand("UPDATE author_admin_tbl SET author_name=@author_name WHERE author_id=@author_id", con);
                    cmd.Parameters.AddWithValue("@author_name", TextBox2.Text.Trim());
                    cmd.Parameters.AddWithValue("@author_id", TextBox1.Text.Trim());

                    int rowsAffected = cmd.ExecuteNonQuery();
                    con.Close();

                    if (rowsAffected > 0)
                    {
                        Session["ToastMessage"] = "Author updated successfully!";
                        Session["ToastType"] = "success";
                        ClearFields();
                        GridView1.DataBind();
                    }
                    else
                    {
                        Session["ToastMessage"] = "Error updating author!";
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

        void addNewAuthor()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(strcon))
                {
                    if (con.State == ConnectionState.Closed)
                    {
                        con.Open();
                    }

                    SqlCommand cmd = new SqlCommand("INSERT INTO author_admin_tbl(author_id, author_name) VALUES (@author_id, @author_name)", con);
                    cmd.Parameters.AddWithValue("@author_id", TextBox1.Text.Trim());
                    cmd.Parameters.AddWithValue("@author_name", TextBox2.Text.Trim());

                    int rowsAffected = cmd.ExecuteNonQuery();
                    con.Close();

                    if (rowsAffected > 0)
                    {
                        Session["ToastMessage"] = "Author added successfully!";
                        Session["ToastType"] = "success";
                        ClearFields();
                        GridView1.DataBind();
                    }
                    else
                    {
                        Session["ToastMessage"] = "Error adding author!";
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

        // Clear input fields after successful added
        private void ClearFields()
        {
            TextBox1.Text = string.Empty;
            TextBox2.Text = string.Empty;
        }

        bool checkIfAuthorExist()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(strcon))
                {
                    if (con.State == ConnectionState.Closed)
                    {
                        con.Open();
                    }

                    SqlCommand cmd = new SqlCommand("SELECT * FROM author_admin_tbl WHERE author_id = @authorId", con);
                    cmd.Parameters.AddWithValue("@authorId", TextBox1.Text.Trim());

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
                Session["ToastMessage"] = "Error: " + ex.Message;
                Session["ToastType"] = "error";
                return false;
            }
        }

        protected void btnClear_Click(object sender, EventArgs e)
        {
            TextBox1.Text = string.Empty;
            TextBox2.Text = string.Empty;           
        }
    }
}