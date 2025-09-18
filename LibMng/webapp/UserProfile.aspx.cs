using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace webapp
{
    public partial class UserProfile : System.Web.UI.Page
    {
        string strcon = ConfigurationManager.ConnectionStrings["con"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["username"] == null || string.IsNullOrEmpty(Session["username"].ToString()))
            {
                Response.Write("<script>alert('Session Expired. Please login again.');</script>");
                Response.Redirect("UserLogin.aspx");
            }

            if (!IsPostBack)
            {
                LoadUserProfile();
                LoadUserBooks();
            }
        }

        protected void Button2_Click(object sender, EventArgs e)
        {
            if (Session["username"] == null || string.IsNullOrEmpty(Session["username"].ToString()))
            {
                Response.Write("<script>alert('Session Expired. Please login again.');</script>");
                Response.Redirect("UserLogin.aspx");
            }
            else
            {
                UpdateUserProfile();
            }
        }

        private void LoadUserProfile()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(strcon))
                {
                    con.Open();
                    using (SqlCommand cmd = new SqlCommand("SELECT * FROM user_admin_tbl WHERE member_id=@member_id", con))
                    {
                        cmd.Parameters.AddWithValue("@member_id", Session["username"].ToString().Trim());
                        SqlDataAdapter da = new SqlDataAdapter(cmd);
                        DataTable dt = new DataTable();
                        da.Fill(dt);

                        if (dt.Rows.Count > 0)
                        {
                            fullname.Text = dt.Rows[0]["full_name"].ToString();
                            dob.Text = Convert.ToDateTime(dt.Rows[0]["dob"]).ToString("yyyy-MM-dd");
                            email.Text = dt.Rows[0]["email"].ToString();
                            contact.Text = dt.Rows[0]["contact_no"].ToString();
                            state.SelectedValue = dt.Rows[0]["state"].ToString();
                            city.Text = dt.Rows[0]["city"].ToString();
                            pincode.Text = dt.Rows[0]["pincode"].ToString();
                            address.Text = dt.Rows[0]["full_address"].ToString();
                            userid.Text = dt.Rows[0]["member_id"].ToString();
                            oldpassword.Text = dt.Rows[0]["password"].ToString();

                            string status = dt.Rows[0]["account_status"].ToString().Trim();
                            Label1.Text = status;

                            switch (status)
                            {
                                case "Active":
                                    Label1.CssClass = "badge bg-success rounded-pill";
                                    break;
                                case "Pending":
                                    Label1.CssClass = "badge bg-warning rounded-pill";
                                    break;
                                case "Inactive":
                                    Label1.CssClass = "badge bg-danger rounded-pill";
                                    break;
                                default:
                                    Label1.CssClass = "badge bg-info rounded-pill";
                                    break;
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                Response.Write("<script>alert('" + ex.Message + "');</script>");
            }
        }

        private void LoadUserBooks()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(strcon))
                {
                    con.Open();
                    using (SqlCommand cmd = new SqlCommand("SELECT * FROM book_issue_tbl WHERE member_id=@member_id", con))
                    {
                        cmd.Parameters.AddWithValue("@member_id", Session["username"].ToString().Trim());
                        SqlDataAdapter da = new SqlDataAdapter(cmd);
                        DataTable dt = new DataTable();
                        da.Fill(dt);

                        GridView1.DataSource = dt;
                        GridView1.DataBind();
                    }
                }
            }
            catch (Exception ex)
            {
                Response.Write("<script>alert('" + ex.Message + "');</script>");
            }
        }

        private void UpdateUserProfile()
        {
            try
            {
                string password = string.IsNullOrEmpty(newpassword.Text.Trim()) ? oldpassword.Text.Trim() : newpassword.Text.Trim();

                using (SqlConnection con = new SqlConnection(strcon))
                {
                    con.Open();
                    using (SqlCommand cmd = new SqlCommand(@"UPDATE user_admin_tbl
                        SET full_name=@full_name,
                            dob=@dob,
                            contact_no=@contact_no,
                            email=@email,
                            state=@state,
                            city=@city,
                            pincode=@pincode,
                            full_address=@full_address,
                            password=@password,
                            account_status=@account_status
                        WHERE member_id=@member_id", con))
                    {
                        cmd.Parameters.AddWithValue("@full_name", fullname.Text.Trim());
                        cmd.Parameters.AddWithValue("@dob", dob.Text.Trim());
                        cmd.Parameters.AddWithValue("@contact_no", contact.Text.Trim());
                        cmd.Parameters.AddWithValue("@email", email.Text.Trim());
                        cmd.Parameters.AddWithValue("@state", state.SelectedItem.Value);
                        cmd.Parameters.AddWithValue("@city", city.Text.Trim());
                        cmd.Parameters.AddWithValue("@pincode", pincode.Text.Trim());
                        cmd.Parameters.AddWithValue("@full_address", address.Text.Trim());
                        cmd.Parameters.AddWithValue("@password", password);
                        cmd.Parameters.AddWithValue("@account_status", "Pending");
                        cmd.Parameters.AddWithValue("@member_id", Session["username"].ToString().Trim());

                        int result = cmd.ExecuteNonQuery();
                        if (result > 0)
                        {
                            Response.Write("<script>alert('Profile updated successfully');</script>");
                            LoadUserProfile();
                            LoadUserBooks();
                        }
                        else
                        {
                            Response.Write("<script>alert('Update failed.');</script>");
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                Response.Write("<script>alert('" + ex.Message + "');</script>");
            }
        }

        protected void GridView1_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                if (DateTime.TryParse(DataBinder.Eval(e.Row.DataItem, "due_date")?.ToString(), out DateTime dueDate))
                {
                    if (DateTime.Today > dueDate)
                    {
                        e.Row.CssClass = "overdue-row";
                    }
                }
            }
        }
    }
}
