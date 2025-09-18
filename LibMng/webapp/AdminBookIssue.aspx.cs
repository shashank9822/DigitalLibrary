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
    public partial class adminbookissue : System.Web.UI.Page
    {
        string strcon = ConfigurationManager.ConnectionStrings["con"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindGridView();
                SetDefaultDates();
            }
        }

        private void SetDefaultDates()
        {
            TextBox5.Text = DateTime.Now.ToString("yyyy-MM-dd");
            TextBox6.Text = DateTime.Now.AddDays(14).ToString("yyyy-MM-dd");
        }

        private void BindGridView()
        {
            GridView1.DataBind();
            UpdateIssueCount();
        }

        protected void GridView1_DataBound(object sender, EventArgs e)
        {
            // Ensure GridView renders proper table structure for DataTables
            if (GridView1.HeaderRow != null)
            {
                GridView1.HeaderRow.TableSection = TableRowSection.TableHeader;
            }

            UpdateIssueCount();
        }

        private void UpdateIssueCount()
        {
            lblTotalIssues.Text = GridView1.Rows.Count.ToString();
        }

        // Go button - Get member and book details
        protected void LinkButton1_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(TextBox1.Text) || string.IsNullOrWhiteSpace(TextBox2.Text))
            {
                ShowMessage("Please enter both Book ID and Member ID", false);
                return;
            }

            GetNames();
        }

        // Issue Button
        protected void Button1_Click(object sender, EventArgs e)
        {
            if (ValidateInputs())
            {
                if (CheckIfBookExists() && CheckIfMemberExists())
                {
                    if (CheckIfIssueEntryExists())
                    {
                        ShowMessage("This member already has this book issued", false);
                    }
                    else
                    {
                        IssueBook();
                    }
                }
                else
                {
                    ShowMessage("Invalid Book ID or Member ID", false);
                }
            }
        }

        // Return Button
        protected void Button2_Click(object sender, EventArgs e)
        {
            if (ValidateInputs())
            {
                if (CheckIfBookExists() && CheckIfMemberExists())
                {
                    if (CheckIfIssueEntryExists())
                    {
                        ReturnBook();
                    }
                    else
                    {
                        ShowMessage("This book is not issued to this member", false);
                    }
                }
                else
                {
                    ShowMessage("Invalid Book ID or Member ID", false);
                }
            }
        }

        // Clear Button
        protected void btnClear_Click(object sender, EventArgs e)
        {
            ClearForm();
            ShowMessage("Form cleared successfully!", true);
        }

        private bool ValidateInputs()
        {
            if (string.IsNullOrWhiteSpace(TextBox1.Text) || string.IsNullOrWhiteSpace(TextBox2.Text))
            {
                ShowMessage("Please enter both Book ID and Member ID", false);
                return false;
            }

            if (string.IsNullOrWhiteSpace(TextBox5.Text) || string.IsNullOrWhiteSpace(TextBox6.Text))
            {
                ShowMessage("Please select both issue and due dates", false);
                return false;
            }

            return true;
        }

        private void IssueBook()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(strcon))
                {
                    con.Open();

                    using (SqlTransaction transaction = con.BeginTransaction())
                    {
                        try
                        {
                            // Insert book issue record
                            SqlCommand cmd = new SqlCommand(
                                "INSERT INTO book_issue_tbl (book_id, book_name, member_id, member_name, issue_date, due_date) " +
                                "VALUES (@book_id, @book_name, @member_id, @member_name, @issue_date, @due_date)",
                                con, transaction);

                            cmd.Parameters.AddWithValue("@book_id", TextBox1.Text.Trim());
                            cmd.Parameters.AddWithValue("@book_name", TextBox4.Text.Trim());
                            cmd.Parameters.AddWithValue("@member_id", TextBox2.Text.Trim());
                            cmd.Parameters.AddWithValue("@member_name", TextBox3.Text.Trim());
                            cmd.Parameters.AddWithValue("@issue_date", TextBox5.Text.Trim());
                            cmd.Parameters.AddWithValue("@due_date", TextBox6.Text.Trim());
                            cmd.ExecuteNonQuery();

                            // Update stock
                            cmd = new SqlCommand(
                                "UPDATE book_admin_tbl SET current_stock = current_stock - 1 WHERE book_id = @book_id AND current_stock > 0",
                                con, transaction);

                            cmd.Parameters.AddWithValue("@book_id", TextBox1.Text.Trim());
                            int rowsAffected = cmd.ExecuteNonQuery();

                            if (rowsAffected == 0)
                            {
                                transaction.Rollback();
                                ShowMessage("Book is out of stock", false);
                                return;
                            }

                            transaction.Commit();
                            ShowMessage("✅ Book issued successfully!", true);
                            ClearForm();
                            BindGridView();
                        }
                        catch (Exception ex)
                        {
                            transaction.Rollback();
                            ShowMessage("Error: " + ex.Message, false);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error: " + ex.Message, false);
            }
        }

        private void ReturnBook()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(strcon))
                {
                    con.Open();

                    using (SqlTransaction transaction = con.BeginTransaction())
                    {
                        try
                        {
                            // Delete issue record
                            SqlCommand cmd = new SqlCommand(
                                "DELETE FROM book_issue_tbl WHERE book_id = @book_id AND member_id = @member_id",
                                con, transaction);

                            cmd.Parameters.AddWithValue("@book_id", TextBox1.Text.Trim());
                            cmd.Parameters.AddWithValue("@member_id", TextBox2.Text.Trim());
                            int rowsDeleted = cmd.ExecuteNonQuery();

                            if (rowsDeleted == 0)
                            {
                                transaction.Rollback();
                                ShowMessage("No issue record found", false);
                                return;
                            }

                            // Update stock
                            cmd = new SqlCommand(
                                "UPDATE book_admin_tbl SET current_stock = current_stock + 1 WHERE book_id = @book_id",
                                con, transaction);

                            cmd.Parameters.AddWithValue("@book_id", TextBox1.Text.Trim());
                            cmd.ExecuteNonQuery();

                            transaction.Commit();
                            ShowMessage("✅ Book returned successfully!", true);
                            ClearForm();
                            BindGridView();
                        }
                        catch (Exception ex)
                        {
                            transaction.Rollback();
                            ShowMessage("Error: " + ex.Message, false);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error: " + ex.Message, false);
            }
        }

        private void ClearForm()
        {
            TextBox1.Text = string.Empty;
            TextBox2.Text = string.Empty;
            TextBox3.Text = string.Empty;
            TextBox4.Text = string.Empty;
            SetDefaultDates();
        }

        private bool CheckIfBookExists()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(strcon))
                {
                    con.Open();
                    SqlCommand cmd = new SqlCommand(
                        "SELECT COUNT(*) FROM book_admin_tbl WHERE book_id = @book_id",
                        con);
                    cmd.Parameters.AddWithValue("@book_id", TextBox1.Text.Trim());
                    return (int)cmd.ExecuteScalar() > 0;
                }
            }
            catch
            {
                return false;
            }
        }

        private bool CheckIfMemberExists()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(strcon))
                {
                    con.Open();
                    SqlCommand cmd = new SqlCommand(
                        "SELECT COUNT(*) FROM user_admin_tbl WHERE member_id = @member_id",
                        con);
                    cmd.Parameters.AddWithValue("@member_id", TextBox2.Text.Trim());
                    return (int)cmd.ExecuteScalar() > 0;
                }
            }
            catch
            {
                return false;
            }
        }

        private bool CheckIfIssueEntryExists()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(strcon))
                {
                    con.Open();
                    SqlCommand cmd = new SqlCommand(
                        "SELECT COUNT(*) FROM book_issue_tbl WHERE member_id = @member_id AND book_id = @book_id",
                        con);
                    cmd.Parameters.AddWithValue("@member_id", TextBox2.Text.Trim());
                    cmd.Parameters.AddWithValue("@book_id", TextBox1.Text.Trim());
                    return (int)cmd.ExecuteScalar() > 0;
                }
            }
            catch
            {
                return false;
            }
        }

        private void GetNames()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(strcon))
                {
                    con.Open();

                    // Get book name
                    SqlCommand cmd = new SqlCommand(
                        "SELECT book_name FROM book_admin_tbl WHERE book_id = @book_id",
                        con);
                    cmd.Parameters.AddWithValue("@book_id", TextBox1.Text.Trim());

                    object result = cmd.ExecuteScalar();
                    if (result != null)
                    {
                        TextBox4.Text = result.ToString();
                    }
                    else
                    {
                        ShowMessage("Book ID not found", false);
                        return;
                    }

                    // Get member name
                    cmd = new SqlCommand(
                        "SELECT full_name FROM user_admin_tbl WHERE member_id = @member_id",
                        con);
                    cmd.Parameters.AddWithValue("@member_id", TextBox2.Text.Trim());

                    result = cmd.ExecuteScalar();
                    if (result != null)
                    {
                        TextBox3.Text = result.ToString();
                    }
                    else
                    {
                        ShowMessage("Member ID not found", false);
                    }
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error: " + ex.Message, false);
            }
        }

        private void ShowMessage(string message, bool isSuccess)
        {
            lblMessage.Text = message;
            lblMessage.CssClass = isSuccess ? "message-label success" : "message-label error";
            lblMessage.Style["display"] = "block";

            // Register script to fade out message
            ScriptManager.RegisterStartupScript(this, this.GetType(), "fadeMessage", "fadeOutMessage();", true);
        }

        protected void GridView1_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            try
            {
                if (e.Row.RowType == DataControlRowType.DataRow)
                {
                    // Check if due date is in the past
                    DateTime dueDate = Convert.ToDateTime(e.Row.Cells[5].Text);
                    if (DateTime.Now > dueDate)
                    {
                        e.Row.CssClass = "overdue-row";
                    }
                }
            }
            catch (Exception ex)
            {
                // Handle date parsing errors gracefully
            }
        }
    }
}