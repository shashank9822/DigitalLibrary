using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace webapp
{
    public partial class Site1 : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (Session["role"] == null || Convert.ToString(Session["role"]) == "")
                {
                    LinkButton7.Visible = true;  // UserLogin link button
                    LinkButton8.Visible = true;  // UserSignUP link button
                    LinkButton9.Visible = false;  // Logout link button
                    LinkButton10.Visible = false; // Hello user link button

                    LinkButton11.Visible = true;  // AdmminLogin Link Button
                    LinkButton12.Visible = false; // AuthorManagement Link Button
                    LinkButton13.Visible = false; // PublisherManagement Link Button
                    LinkButton14.Visible = false; // BookInventory Link Button
                    LinkButton15.Visible = false; // BookIssue Link Button
                    LinkButton16.Visible = false; // MemberManagement Link Button


                }
                else if (Session["role"].ToString() == "user")
                {
                    LinkButton7.Visible = false;  // UserLogin link button
                    LinkButton8.Visible = false;  // UserSignUP link button
                    LinkButton9.Visible = true;  // Logout link button
                    LinkButton10.Visible = true; // Hello user link button

                    LinkButton10.Text = "Hello : " + Session["username"].ToString();

                    LinkButton11.Visible = true;  // AdmminLogin Link Button
                    LinkButton12.Visible = false; // AuthorManagement Link Button
                    LinkButton13.Visible = false; // PublisherManagement Link Button
                    LinkButton14.Visible = false; // BookInventory Link Button
                    LinkButton15.Visible = false; // BookIssue Link Button
                    LinkButton16.Visible = false; // MemberManagement Link Button
                }

                else if (Session["role"].ToString() == "admin")
                {
                    LinkButton7.Visible = false;  // UserLogin link button
                    LinkButton8.Visible = false;  // UserSignUP link button
                    LinkButton9.Visible = true;  // Logout link button
                    LinkButton10.Visible = true; // Hello user link button
                    LinkButton10.Text = "Hello Admin";

                    LinkButton11.Visible = false;  // AdmminLogin Link Button
                    LinkButton12.Visible = true; // AuthorManagement Link Button
                    LinkButton13.Visible = true; // PublisherManagement Link Button
                    LinkButton14.Visible = true; // BookInventory Link Button
                    LinkButton15.Visible = true; // BookIssue Link Button
                    LinkButton16.Visible = true; // MemberManagement Link Button
                }

            }
            catch (Exception ex)
            {


            }
        }

        protected void LinkButton11_Click(object sender, EventArgs e)
        {
            Response.Redirect("AdminLogin.aspx");
        }

        protected void LinkButton12_Click(object sender, EventArgs e)
        {
            Response.Redirect("AdminAuthorManagement.aspx");
        }

        protected void LinkButton13_Click(object sender, EventArgs e)
        {
            Response.Redirect("AdminPublisherManagement.aspx");
        }

        protected void LinkButton14_Click(object sender, EventArgs e)
        {
            Response.Redirect("AdminBookLibrary.aspx");
        }

        protected void LinkButton15_Click(object sender, EventArgs e)
        {
            Response.Redirect("AdminBookIssue.aspx");
        }

        protected void LinkButton16_Click(object sender, EventArgs e)
        {
            Response.Redirect("AdminMemberManagement.aspx");
        }

        protected void LinkButton10_Click(object sender, EventArgs e)
        {
            Response.Redirect("UserProfile.aspx");
        }

        protected void LinkButton8_Click(object sender, EventArgs e)
        {
            Response.Redirect("UserSignUp.aspx");
        }

        protected void LinkButton7_Click(object sender, EventArgs e)
        {
            Response.Redirect("UserLogin.aspx");
        }

        protected void LinkButton6_Click(object sender, EventArgs e)
        {
            Response.Redirect("ViewBooks.aspx");
        }

        protected void LinkButton9_Click(object sender, EventArgs e)
        {
            Session["username"] = "";
            Session["fullname"] = "";
            Session["role"] = "";
            Session["status"] = "";

            LinkButton7.Visible = true;  // UserLogin link button
            LinkButton8.Visible = true;  // UserSignUP link button
            LinkButton9.Visible = false;  // Logout link button
            LinkButton10.Visible = false; // Hello user link button

            LinkButton11.Visible = true;  // AdmminLogin Link Button
            LinkButton12.Visible = false; // AuthorManagement Link Button
            LinkButton13.Visible = false; // PublisherManagement Link Button
            LinkButton14.Visible = false; // BookInventory Link Button
            LinkButton15.Visible = false; // BookIssue Link Button
            LinkButton16.Visible = false; // MemberManagement Link Button

            Response.Redirect("Homepage.aspx");
        }
    }
}