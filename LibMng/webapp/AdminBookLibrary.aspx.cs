using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace webapp
{
    public partial class AdminBookLibrary : System.Web.UI.Page
    {
        string strcon = ConfigurationManager.ConnectionStrings["con"].ConnectionString;
        static string global_filepath;
        static int global_actual_stock, global_current_stock, global_issued_books;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                fillAuthorPublisherValues();
                GridView1.DataBind();

                // Initialize hidden fields
                hfImageSource.Value = "~/bookimgs/library.png";
                hfImageType.Value = "file";

                // SET INITIAL BUTTON STATE - ONLY ADD BUTTON VISIBLE
                ShowAddButtonOnly();
            }
            // ✅ Always ensure DataTables sees <thead>
            GridView1.UseAccessibleHeader = true;
            if (GridView1.HeaderRow != null)
            {
                GridView1.HeaderRow.TableSection = TableRowSection.TableHeader;
            }
        }

        //Go button      
        protected void GoButton_Click(object sender, EventArgs e)
        {
            getBookByID();
        }

        //Add button
        protected void Button2_Click(object sender, EventArgs e)
        {
            if (checkIfBookExist())
            {
                Response.Write("<script>alert('Book already exists, Try different Book ID');</script>");
            }
            else
            {
                addNewBook();
            }
        }

        //Update button
        protected void Button1_Click(object sender, EventArgs e)
        {
            updateBook();
        }

        //Delete button
        protected void Button3_Click(object sender, EventArgs e)
        {
            deleteBook();
        }

        //User define Function
        void fillAuthorPublisherValues()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(strcon))
                {
                    if (con.State == ConnectionState.Closed)
                    {
                        con.Open();
                    }

                    SqlCommand cmd = new SqlCommand("SELECT author_name from author_admin_tbl;", con);
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);
                    authorDropdown.DataSource = dt;
                    authorDropdown.DataValueField = "author_name";
                    authorDropdown.DataBind();

                    cmd = new SqlCommand("SELECT publisher_name from publisher_admin_tbl;", con);
                    da = new SqlDataAdapter(cmd);
                    dt = new DataTable();
                    da.Fill(dt);
                    publisherDropdown.DataSource = dt;
                    publisherDropdown.DataValueField = "publisher_name";
                    publisherDropdown.DataBind();
                }
            }
            catch (Exception ex)
            {
                Response.Write("<script>alert('Error: " + ex.Message + "');</script>");
            }
        }

        bool checkIfBookExist()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(strcon))
                {
                    if (con.State == ConnectionState.Closed)
                    {
                        con.Open();
                    }

                    SqlCommand cmd = new SqlCommand("SELECT * FROM book_admin_tbl WHERE book_id = @bookId", con);
                    cmd.Parameters.AddWithValue("@bookId", TextBox1.Text.Trim());

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    return dt.Rows.Count >= 1;
                }
            }
            catch (Exception ex)
            {
                Response.Write("<script>alert('Error: " + ex.Message + "');</script>");
                return false;
            }
        }

        void getBookByID()
        {
            try
            {
                using (SqlConnection con = new SqlConnection(strcon))
                {
                    if (con.State == ConnectionState.Closed)
                    {
                        con.Open();
                    }

                    SqlCommand cmd = new SqlCommand("SELECT * FROM book_admin_tbl WHERE book_id = @bookId", con);
                    cmd.Parameters.AddWithValue("@bookId", TextBox1.Text.Trim());

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    if (dt.Rows.Count >= 1)
                    {
                        DataRow dr = dt.Rows[0];

                        // Set book image - FIXED: Properly handle both URL and file paths
                        string bookImage = dr["book_img_link"].ToString();
                        imgview.ImageUrl = bookImage;
                        hfImageSource.Value = bookImage;

                        // Determine if it's a URL or file path
                        if (bookImage.StartsWith("http://") || bookImage.StartsWith("https://") || bookImage.StartsWith("www."))
                        {
                            hfImageType.Value = "url";
                            // Switch to URL tab and set the URL textbox
                            ScriptManager.RegisterStartupScript(this, this.GetType(), "switchToUrlTab",
                                "$('.option-tab').removeClass('active'); $('[data-option=\"url\"]').addClass('active'); " +
                                "$('.option-content').removeClass('active'); $('#url-option').addClass('active'); " +
                                "$('#" + txtImageUrl.ClientID + "').val('" + bookImage.Replace("'", "\\'") + "'); " +
                                "clearFileInputDisplay();", true);
                        }
                        else
                        {
                            hfImageType.Value = "file";
                            // Switch to File tab and show the file path
                            ScriptManager.RegisterStartupScript(this, this.GetType(), "switchToFileTab",
                                "$('.option-tab').removeClass('active'); $('[data-option=\"file\"]').addClass('active'); " +
                                "$('.option-content').removeClass('active'); $('#file-option').addClass('active'); " +
                                "$('#filePathDisplay').text('Current file: " + bookImage.Replace("'", "\\'") + "'); " +
                                "$('#" + txtImageUrl.ClientID + "').val('');", true);
                        }

                        // Fill other fields
                        TextBox2.Text = dr["book_name"].ToString().Trim();
                        TextBox3.Text = Convert.ToDateTime(dr["publish_date"]).ToString("yyyy-MM-dd").Trim();
                        TextBox7.Text = dr["edition"].ToString();
                        TextBox8.Text = dr["book_cost"].ToString().Trim();
                        TextBox9.Text = dr["no_of_pages"].ToString().Trim();
                        TextBox4.Text = dr["actual_stock"].ToString().Trim();
                        TextBox5.Text = dr["current_stock"].ToString().Trim();
                        TextBox6.Text = (Convert.ToInt32(dr["actual_stock"]) - Convert.ToInt32(dr["current_stock"])).ToString().Trim();
                        desc.Text = dr["book_discription"].ToString();

                        languageDropdown.SelectedValue = dr["language"].ToString();
                        authorDropdown.SelectedValue = dr["author_name"].ToString();
                        publisherDropdown.SelectedValue = dr["publisher_name"].ToString();

                        // Set selected genres
                        genreListBox.ClearSelection();
                        string[] bookGenres = dr["genre"].ToString().Split(',');
                        foreach (string genre in bookGenres)
                        {
                            foreach (ListItem item in genreListBox.Items)
                            {
                                if (item.Text.Trim() == genre.Trim())
                                {
                                    item.Selected = true;
                                    break;
                                }
                            }
                        }

                        global_actual_stock = Convert.ToInt32(dr["actual_stock"]);
                        global_current_stock = Convert.ToInt32(dr["current_stock"]);
                        global_issued_books = global_actual_stock - global_current_stock;
                        global_filepath = dr["book_img_link"].ToString();

                        // SHOW UPDATE AND DELETE BUTTONS, HIDE ADD BUTTON
                        ShowUpdateDeleteButtons();
                    }
                    else
                    {
                        Response.Write("<script>alert('Book not found');</script>");
                        clearForm();
                        // KEEP ADD BUTTON VISIBLE, HIDE UPDATE/DELETE
                        ShowAddButtonOnly();
                    }
                }
            }
            catch (Exception ex)
            {
                Response.Write("<script>alert('Error: " + ex.Message + "');</script>");
            }
        }

        // Helper method to show only Add button
        private void ShowAddButtonOnly()
        {
            Button2.CssClass = "btn btn-md btn-success button-visible";
            Button1.CssClass = "btn btn-md btn-primary button-hidden";
            Button3.CssClass = "btn btn-md btn-danger button-hidden";
        }

        // Helper method to show Update/Delete buttons and hide Add button
        private void ShowUpdateDeleteButtons()
        {
            Button2.CssClass = "btn btn-md btn-success button-hidden";
            Button1.CssClass = "btn btn-md btn-primary button-visible";
            Button3.CssClass = "btn btn-md btn-danger button-visible";
        }

        void addNewBook()
        {
            try
            {
                string genres = "";
                foreach (int i in genreListBox.GetSelectedIndices())
                {
                    genres = genres + genreListBox.Items[i].Text + ",";
                }
                genres = genres.TrimEnd(',');

                string filepath = "~/bookimgs/library.png";

                // Handle both file upload and URL
                if (FileUpload1.HasFile)
                {
                    string filename = Path.GetFileName(FileUpload1.PostedFile.FileName);
                    string fileExtension = Path.GetExtension(filename).ToLower();

                    // Validate image file
                    if (fileExtension == ".jpg" || fileExtension == ".jpeg" || fileExtension == ".png" || fileExtension == ".gif")
                    {
                        FileUpload1.SaveAs(Server.MapPath("~/bookimgs/" + filename));
                        filepath = "~/bookimgs/" + filename;
                    }
                    else
                    {
                        Response.Write("<script>alert('Please upload a valid image file (jpg, jpeg, png, gif)');</script>");
                        return;
                    }
                }
                else if (hfImageType.Value == "url" && !string.IsNullOrEmpty(hfImageSource.Value) && hfImageSource.Value != "~/bookimgs/library.png")
                {
                    // Use URL instead of file
                    filepath = hfImageSource.Value;
                }

                using (SqlConnection con = new SqlConnection(strcon))
                {
                    if (con.State == ConnectionState.Closed)
                    {
                        con.Open();
                    }

                    SqlCommand cmd = new SqlCommand(@"
                        INSERT INTO book_admin_tbl 
                        (book_id, book_name, genre, author_name, publisher_name, publish_date, 
                         language, edition, book_cost, no_of_pages, book_discription, 
                         actual_stock, current_stock, book_img_link)
                        VALUES 
                        (@book_id, @book_name, @genre, @auth_name, @pub_name, @pub_date, 
                         @lang, @edition, @cost, @pages, @desc, 
                         @actual_stock, @current_stock, @img_link)", con);

                    cmd.Parameters.AddWithValue("@book_id", TextBox1.Text.Trim());
                    cmd.Parameters.AddWithValue("@book_name", TextBox2.Text.Trim());
                    cmd.Parameters.AddWithValue("@genre", genres);
                    cmd.Parameters.AddWithValue("@auth_name", authorDropdown.SelectedItem.Value);
                    cmd.Parameters.AddWithValue("@pub_name", publisherDropdown.SelectedItem.Value);
                    cmd.Parameters.AddWithValue("@pub_date", TextBox3.Text.Trim());
                    cmd.Parameters.AddWithValue("@lang", languageDropdown.SelectedItem.Value);
                    cmd.Parameters.AddWithValue("@edition", TextBox7.Text.Trim());
                    cmd.Parameters.AddWithValue("@cost", TextBox8.Text.Trim());
                    cmd.Parameters.AddWithValue("@pages", TextBox9.Text.Trim());
                    cmd.Parameters.AddWithValue("@desc", desc.Text.Trim());
                    cmd.Parameters.AddWithValue("@actual_stock", TextBox4.Text.Trim());
                    cmd.Parameters.AddWithValue("@current_stock", TextBox4.Text.Trim());
                    cmd.Parameters.AddWithValue("@img_link", filepath);

                    cmd.ExecuteNonQuery();
                    con.Close();

                    Response.Write("<script>alert('Book added successfully.');</script>");
                    GridView1.DataBind();
                    clearForm();
                }
            }
            catch (Exception ex)
            {
                Response.Write("<script>alert('Error: " + ex.Message + "');</script>");
            }
        }

        void updateBook()
        {
            if (checkIfBookExist())
            {
                try
                {
                    int actual_stock = Convert.ToInt32(TextBox4.Text.Trim());
                    int current_stock = Convert.ToInt32(TextBox5.Text.Trim());

                    if (global_actual_stock != actual_stock)
                    {
                        if (actual_stock < global_issued_books)
                        {
                            Response.Write("<script>alert('Actual stock value cannot be less than issued books');</script>");
                            return;
                        }
                        current_stock = actual_stock - global_issued_books;
                        TextBox5.Text = current_stock.ToString();
                    }

                    string genres = "";
                    foreach (int i in genreListBox.GetSelectedIndices())
                    {
                        genres = genres + genreListBox.Items[i].Text + ",";
                    }
                    genres = genres.TrimEnd(',');

                    string filepath = global_filepath;

                    // Handle file upload
                    if (FileUpload1.HasFile)
                    {
                        string filename = Path.GetFileName(FileUpload1.PostedFile.FileName);
                        string fileExtension = Path.GetExtension(filename).ToLower();

                        if (fileExtension == ".jpg" || fileExtension == ".jpeg" || fileExtension == ".png" || fileExtension == ".gif")
                        {
                            FileUpload1.SaveAs(Server.MapPath("~/bookimgs/" + filename));
                            filepath = "~/bookimgs/" + filename;
                        }
                        else
                        {
                            Response.Write("<script>alert('Please upload a valid image file');</script>");
                            return;
                        }
                    }
                    // Handle URL update
                    else if (hfImageType.Value == "url" && !string.IsNullOrEmpty(hfImageSource.Value) && hfImageSource.Value != "~/bookimgs/library.png")
                    {
                        filepath = hfImageSource.Value;
                    }

                    using (SqlConnection con = new SqlConnection(strcon))
                    {
                        if (con.State == ConnectionState.Closed)
                        {
                            con.Open();
                        }

                        SqlCommand cmd = new SqlCommand(@"
                            UPDATE book_admin_tbl SET 
                            book_name=@book_name, genre=@genre, author_name=@auth_name, 
                            publisher_name=@pub_name, publish_date=@pub_date, language=@lang, 
                            edition=@edition, book_cost=@cost, no_of_pages=@pages, 
                            book_discription=@desc, actual_stock=@actual_stock, 
                            current_stock=@current_stock, book_img_link=@img_link 
                            WHERE book_id=@book_id", con);

                        cmd.Parameters.AddWithValue("@book_id", TextBox1.Text.Trim());
                        cmd.Parameters.AddWithValue("@book_name", TextBox2.Text.Trim());
                        cmd.Parameters.AddWithValue("@genre", genres);
                        cmd.Parameters.AddWithValue("@auth_name", authorDropdown.SelectedItem.Value);
                        cmd.Parameters.AddWithValue("@pub_name", publisherDropdown.SelectedItem.Value);
                        cmd.Parameters.AddWithValue("@pub_date", TextBox3.Text.Trim());
                        cmd.Parameters.AddWithValue("@lang", languageDropdown.SelectedItem.Value);
                        cmd.Parameters.AddWithValue("@edition", TextBox7.Text.Trim());
                        cmd.Parameters.AddWithValue("@cost", TextBox8.Text.Trim());
                        cmd.Parameters.AddWithValue("@pages", TextBox9.Text.Trim());
                        cmd.Parameters.AddWithValue("@desc", desc.Text.Trim());
                        cmd.Parameters.AddWithValue("@actual_stock", actual_stock);
                        cmd.Parameters.AddWithValue("@current_stock", current_stock);
                        cmd.Parameters.AddWithValue("@img_link", filepath);

                        int rowsAffected = cmd.ExecuteNonQuery();
                        con.Close();

                        if (rowsAffected > 0)
                        {
                            Response.Write("<script>alert('Book updated successfully');</script>");
                            imgview.ImageUrl = filepath;
                            GridView1.DataBind();
                            clearForm();
                        }
                        else
                        {
                            Response.Write("<script>alert('Book not found for update');</script>");
                        }
                    }
                }
                catch (Exception ex)
                {
                    Response.Write("<script>alert('Error updating: " + ex.Message + "');</script>");
                }
            }
            else
            {
                Response.Write("<script>alert('Book does not exist');</script>");
            }
        }

        void deleteBook()
        {
            if (checkIfBookExist())
            {
                try
                {
                    using (SqlConnection con = new SqlConnection(strcon))
                    {
                        if (con.State == ConnectionState.Closed)
                        {
                            con.Open();
                        }
                        SqlCommand cmd = new SqlCommand("DELETE FROM book_admin_tbl WHERE book_id=@book_id", con);
                        cmd.Parameters.AddWithValue("@book_id", TextBox1.Text.Trim());
                        int rowsAffected = cmd.ExecuteNonQuery();
                        con.Close();

                        if (rowsAffected > 0)
                        {
                            Response.Write("<script>alert('Book deleted successfully');</script>");
                            GridView1.DataBind();
                            clearForm();
                        }
                        else
                        {
                            Response.Write("<script>alert('Book not found for deletion');</script>");
                        }
                    }
                }
                catch (Exception ex)
                {
                    Response.Write("<script>alert('Error deleting: " + ex.Message + "');</script>");
                }
            }
            else
            {
                Response.Write("<script>alert('Book does not exist');</script>");
            }
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
            desc.Text = "";
            imgview.ImageUrl = "~/bookimgs/library.png";
            languageDropdown.SelectedIndex = 0;
            authorDropdown.SelectedIndex = 0;
            publisherDropdown.SelectedIndex = 0;
            genreListBox.ClearSelection();
            hfImageSource.Value = "~/bookimgs/library.png";
            hfImageType.Value = "file";
            FileUpload1.Attributes.Clear();

            // Reset UI tabs to default and clear input fields
            ScriptManager.RegisterStartupScript(this, this.GetType(), "resetTabs",
                "$('.option-tab').removeClass('active'); $('[data-option=\"file\"]').addClass('active'); " +
                "$('.option-content').removeClass('active'); $('#file-option').addClass('active'); " +
                "$('#" + txtImageUrl.ClientID + "').val(''); " +
                "clearFileInputDisplay();", true);

            // SHOW ONLY ADD BUTTON AFTER CLEARING FORM
            ShowAddButtonOnly();
        }
    }
}