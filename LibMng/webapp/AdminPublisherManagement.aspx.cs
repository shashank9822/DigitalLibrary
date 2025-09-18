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
    public partial class AdminPublisherManagement : System.Web.UI.Page
    {
        string strcon = ConfigurationManager.ConnectionStrings["con"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            GridView1.DataBind();
        }

        // Add clickbutton event
        protected void Button1_Click(object sender, EventArgs e)
        {
            if (checkIfPublisherExist())
            {
                Response.Write("<script>alert('Publisher ID already exists');</script>");
            }
            else
            {
                addNewPublisher();
            }
        }

        // Delete clickbutton event
        protected void Button2_Click(object sender, EventArgs e)
        {
            if (checkIfPublisherExist())
            {
                deletePublisher();
            }
            else
            {
                Response.Write("<script>alert('Publisher ID does not exist');</script>");
            }
        }

        // Update clickbutton event
        protected void Button3_Click(object sender, EventArgs e)
        {
            if (checkIfPublisherExist())
            {
                updatePublisher();
            }
            else
            {
                Response.Write("<script>alert('Publisher ID does not exist');</script>");
            }
        }

        // Go clickbutton event
        protected void LinkButton1_Click(object sender, EventArgs e)
        {
            getPublisherById();
        }

        // Publisher Define Function
        void getPublisherById()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(strcon))
                {
                    if (con.State == ConnectionState.Closed)
                    {
                        con.Open();
                    }

                    SqlCommand cmd = new SqlCommand("SELECT * FROM publisher_admin_tbl WHERE publisher_id = @publisherId", con);
                    cmd.Parameters.AddWithValue("@publisherId", TextBox1.Text.Trim());

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    if (dt.Rows.Count >= 1) // Returns true if user exists
                    {
                        TextBox2.Text = dt.Rows[0][1].ToString();
                    }
                    else
                    {
                        Response.Write("<script>alert('Invalid Publisher ID');</script>");
                    }
                }
            }
            catch (Exception ex)
            {
                Response.Write("<script>alert('" + ex.Message + "');</script>");
            }
        }

        void deletePublisher()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(strcon))
                {
                    if (con.State == ConnectionState.Closed)
                    {
                        con.Open();
                    }

                    SqlCommand cmd = new SqlCommand("DELETE from publisher_admin_tbl WHERE publisher_id='" +
                        TextBox1.Text.Trim() + "'", con);

                    cmd.ExecuteNonQuery();
                    con.Close();
                    Response.Write("<script>alert('Publisher Deleted Successfully');</script>");

                    ClearFields(); // Clear fields after successful operation
                    GridView1.DataBind();
                }
            }
            catch (Exception ex)
            {
                Response.Write("<script>alert('" + ex.Message + "');</script>");
            }
        }

        void updatePublisher()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(strcon))
                {
                    if (con.State == ConnectionState.Closed)
                    {
                        con.Open();
                    }

                    SqlCommand cmd = new SqlCommand("UPDATE publisher_admin_tbl SET" +
                        " publisher_name=@publisher_name WHERE publisher_id='" + TextBox1.Text.Trim() + "'", con);

                    // Parameter assignment
                    cmd.Parameters.AddWithValue("@publisher_name", TextBox2.Text.Trim());

                    cmd.ExecuteNonQuery();
                    con.Close();
                    Response.Write("<script>alert('Publisher Updated Successfully');</script>");

                    ClearFields(); // Clear fields after successful update
                    GridView1.DataBind();
                }
            }
            catch (Exception ex)
            {
                Response.Write("<script>alert('" + ex.Message + "');</script>");
            }
        }

        void addNewPublisher()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(strcon))
                {
                    if (con.State == ConnectionState.Closed)
                    {
                        con.Open();
                    }

                    SqlCommand cmd = new SqlCommand("INSERT INTO publisher_admin_tbl(publisher_id, publisher_name) " +
                                                    "VALUES (@publisher_id, @publisher_name)", con);

                    // Parameter assignment
                    cmd.Parameters.AddWithValue("@publisher_id", TextBox1.Text.Trim());
                    cmd.Parameters.AddWithValue("@publisher_name", TextBox2.Text.Trim());

                    cmd.ExecuteNonQuery();
                    con.Close();
                    Response.Write("<script>alert('Publisher Added Successfully');</script>");

                    ClearFields(); // Clear fields after successful insertion
                    GridView1.DataBind();
                }
            }
            catch (Exception ex)
            {
                Response.Write("<script>alert('" + ex.Message + "');</script>");
            }
        }

        // Clear input fields after successful operation
        private void ClearFields()
        {
            TextBox1.Text = string.Empty;
            TextBox2.Text = string.Empty;
        }

        bool checkIfPublisherExist()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(strcon))
                {
                    if (con.State == ConnectionState.Closed)
                    {
                        con.Open();
                    }

                    SqlCommand cmd = new SqlCommand("SELECT * FROM publisher_admin_tbl WHERE publisher_id = @publisherId", con);
                    cmd.Parameters.AddWithValue("@publisherId", TextBox1.Text.Trim());

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    if (dt.Rows.Count >= 1) // Returns true if publisher exists
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

     
    }

}
