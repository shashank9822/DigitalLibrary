<%@ Page Title="" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="UserProfile.aspx.cs" Inherits="webapp.UserProfile" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        .input-group {
            display: flex;
            align-items: center;
        }

        .toggle-password {
            position: absolute;
            right: 15px;
            top: 50%;
            transform: translateY(-50%);
            font-weight: bold;
            font-size: 1rem;
            color: #007bff;
            padding: 0 10px;
        }

        .form-control {
            padding-right: 60px;
        }

        .grid-header {
            background-color: #343a40 !important;
            color: #fff !important;
            font-weight: bold;
            text-align: center;
        }

        .user-table {
            border-collapse: separate;
            border-spacing: 0;
        }

        .user-table thead th {
            position: sticky;
            top: 0;
            background-color: #4e73df;
            color: white;
            z-index: 10;
            text-align: center;
        }

        .user-table tbody tr {
            transition: background-color 0.3s;
        }

        .user-table tbody tr:hover {
            background-color: rgba(78, 115, 223, 0.05);
        }

        .overdue-row {
            background-color: #dc3545 !important;
            color: #fff !important;
        }
    </style>

    <script type="text/javascript">
        $(document).ready(function () {
            $(".table").prepend($("<thead></thead>").append($(this).find("tr:first"))).dataTable();
        });

        function limitRows(element, maxRows) {
            element.style.height = "auto"; // Reset height to auto
            const lineHeight = parseFloat(getComputedStyle(element).lineHeight);
            const maxVisibleRows = 4;
            const maxHeight = lineHeight * maxVisibleRows;

            element.style.height = element.scrollHeight + "px";

            if (element.scrollHeight > maxHeight) {
                element.style.height = maxHeight + "px";
                element.style.overflowY = "auto";
            }

            const lines = element.value.split('\n');
            if (lines.length > maxRows) {
                element.value = lines.slice(0, maxRows).join('\n');
            }
        }


        function togglePasswordVisibility() {
            const passwordInput = document.getElementById('newpassword');
            const toggleText = document.getElementById('togglePasswordText');

            if (passwordInput.type === 'password') {
                passwordInput.type = 'text';
                toggleText.textContent = 'Hide';
            } else {
                passwordInput.type = 'password';
                toggleText.textContent = 'Show';
            }
        }
    </script>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder" runat="server">

    <div class="container-fluid">
        <div class="row">
            <!-- Left Card -->
            <div class="col-md-4">
                <div class="card">
                    <div class="card-body">
                        <div class="text-center mb-4">
                            <img width="150px" src="imgs/user.png" alt="User Image" />
                            <h3>Your Profile</h3>
                            <span>Account Status</span>
                            <asp:Label class="badge rounded-pill" ID="Label1" runat="server" Text="Your Status"></asp:Label>
                            <hr />
                        </div>

                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label>Fullname</label>
                                <asp:TextBox ID="fullname" runat="server" CssClass="form-control" Placeholder="Fullname"></asp:TextBox>
                            </div>
                            <div class="col-md-6">
                                <label>Date Of Birth</label>
                                <asp:TextBox ID="dob" runat="server" CssClass="form-control" TextMode="Date"></asp:TextBox>
                            </div>
                        </div>

                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label>Email</label>
                                <asp:TextBox ID="email" runat="server" CssClass="form-control" TextMode="Email" Placeholder="Email"></asp:TextBox>
                            </div>
                            <div class="col-md-6">
                                <label>Contact No.</label>
                                <asp:TextBox ID="contact" runat="server" CssClass="form-control" TextMode="Phone" Placeholder="Contact No."></asp:TextBox>
                            </div>
                        </div>

                        <div class="row mb-3">
                            <div class="col-md-4">
                                <label>State</label>
                                <asp:DropDownList ID="state" runat="server" CssClass="form-select">
                                    <asp:ListItem Text="Select a State" Value="" />
                                    <asp:ListItem Value="AP">Andhra Pradesh</asp:ListItem>
                                    <asp:ListItem Value="AR">Arunachal Pradesh</asp:ListItem>
                                    <asp:ListItem Value="AS">Assam</asp:ListItem>
                                    <asp:ListItem Value="BR">Bihar</asp:ListItem>
                                    <asp:ListItem Value="CT">Chhattisgarh</asp:ListItem>
                                    <asp:ListItem Value="GA">Goa</asp:ListItem>
                                    <asp:ListItem Value="GJ">Gujarat</asp:ListItem>
                                    <asp:ListItem Value="HR">Haryana</asp:ListItem>
                                    <asp:ListItem Value="HP">Himachal Pradesh</asp:ListItem>
                                    <asp:ListItem Value="JH">Jharkhand</asp:ListItem>
                                    <asp:ListItem Value="KA">Karnataka</asp:ListItem>
                                    <asp:ListItem Value="KL">Kerala</asp:ListItem>
                                    <asp:ListItem Value="MP">Madhya Pradesh</asp:ListItem>
                                    <asp:ListItem Value="MH">Maharashtra</asp:ListItem>
                                    <asp:ListItem Value="MN">Manipur</asp:ListItem>
                                    <asp:ListItem Value="ML">Meghalaya</asp:ListItem>
                                    <asp:ListItem Value="MZ">Mizoram</asp:ListItem>
                                    <asp:ListItem Value="NL">Nagaland</asp:ListItem>
                                    <asp:ListItem Value="OD">Odisha</asp:ListItem>
                                    <asp:ListItem Value="PB">Punjab</asp:ListItem>
                                    <asp:ListItem Value="RJ">Rajasthan</asp:ListItem>
                                    <asp:ListItem Value="SK">Sikkim</asp:ListItem>
                                    <asp:ListItem Value="TN">Tamil Nadu</asp:ListItem>
                                    <asp:ListItem Value="TG">Telangana</asp:ListItem>
                                    <asp:ListItem Value="TR">Tripura</asp:ListItem>
                                    <asp:ListItem Value="UP">Uttar Pradesh</asp:ListItem>
                                    <asp:ListItem Value="UK">Uttarakhand</asp:ListItem>
                                    <asp:ListItem Value="WB">West Bengal</asp:ListItem>
                                </asp:DropDownList>
                            </div>
                            <div class="col-md-4">
                                <label>City</label>
                                <asp:TextBox ID="city" runat="server" CssClass="form-control" Placeholder="City"></asp:TextBox>
                            </div>
                            <div class="col-md-4">
                                <label>PinCode</label>
                                <asp:TextBox ID="pincode" runat="server" CssClass="form-control" Placeholder="PinCode"></asp:TextBox>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label>Address</label>
                            <asp:TextBox ID="address" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3" Placeholder="Complete Address"></asp:TextBox>
                        </div>

                        <div class="row mb-3">
                            <div class="col-md-4">
                                <label>UserID</label>
                                <asp:TextBox ID="userid" runat="server" CssClass="form-control" ReadOnly="true"></asp:TextBox>
                            </div>

                            <div class="col-md-4">
                                <label>Old Password</label>
                                <asp:TextBox ID="oldpassword" runat="server" CssClass="form-control" ReadOnly="true"></asp:TextBox>
                            </div>

                            <div class="col-md-4">
                                <label>New Password</label>
                                <div class="input-group position-relative">
                                    <asp:TextBox ID="newpassword" runat="server" CssClass="form-control" TextMode="Password" Placeholder="New Password"></asp:TextBox>
                                    <span id="togglePasswordText" onclick="togglePasswordVisibility()" class="toggle-password" style="cursor: pointer;">Show</span>
                                </div>
                            </div>
                        </div>                      

                        <div class="row justify-content-end">
                            <div class="col-auto">
                                <asp:Button CssClass="btn btn-md btn-primary" ID="Button2" runat="server" Text="Update" OnClick="Button2_Click" />
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Right Card -->
            <div class="col-md-8">
                <div class="card">
                    <div class="card-body">
                        <div class="text-center mb-4">
                            <img width="150px" src="imgs/booksimg.jpg" />
                            <h3>UserData Status</h3>
                            <asp:Label class="badge bg-info rounded-pill" ID="Label2" runat="server" Text="User Book Status"></asp:Label>
                            <hr />
                        </div>

                        <div class="row">
                            <div class="col">
                                <asp:GridView CssClass="table table-striped table-bordered user-table" ID="GridView1" runat="server" AutoGenerateColumns="False" OnRowDataBound="GridView1_RowDataBound" HeaderStyle-CssClass="grid-header">
                                    <Columns>
                                        <asp:BoundField DataField="book_id" HeaderText="Book ID" />
                                        <asp:BoundField DataField="book_name" HeaderText="Book Name" />
                                        <asp:BoundField DataField="member_id" HeaderText="Member ID" />
                                        <asp:BoundField DataField="member_name" HeaderText="Member Name" />
                                        <asp:BoundField DataField="issue_date" HeaderText="Issue Date" DataFormatString="{0:yyyy-MM-dd}" />
                                        <asp:BoundField DataField="due_date" HeaderText="Due Date" DataFormatString="{0:yyyy-MM-dd}" />
                                    </Columns>
                                </asp:GridView>
                            </div>
                        </div>

                    </div>
                </div>
            </div>
        </div>

        <div class="text-center mt-3">
            <a href="Homepage.aspx"><< Back to Home</a>
        </div>
    </div>

</asp:Content>
