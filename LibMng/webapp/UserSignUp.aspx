<%@ Page Title="" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="UserSignUp.aspx.cs" Inherits="webapp.UserSignUp" %>

<asp:Content ID="Content3" ContentPlaceHolderID="head" runat="server">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet" />

    <style>
        body {
            background: linear-gradient(rgba(15, 32, 39, 0.85), rgba(32, 58, 67, 0.85), rgba(44, 83, 100, 0.85)), url('imgs/library-bg.jpg') no-repeat center center fixed;
            background-size: cover;
        }

        .signup-card {
            background: rgba(255, 255, 255, 0.12);
            backdrop-filter: blur(12px);
            border-radius: 1rem;
            border: 1px solid rgba(255, 255, 255, 0.2);
            box-shadow: 0 8px 25px rgba(0,0,0,0.25);
            padding: 2rem;
            opacity: 0;
            transform: translateY(-30px) scale(0.95);
            animation: fadeSlideIn 0.9s ease forwards;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .signup-card h3 {
            font-weight: 600;
            color: #fff;
        }

        .form-label {
            color: #fff;
            font-weight: 500;
        }

        .form-control {
            border-radius: 0.5rem;
        }

        .btn-md {
            padding: 0.5rem 1.5rem;
            font-size: 0.95rem;
            border-radius: 0.5rem;
        }

        @keyframes fadeSlideIn {
            to {
                opacity: 1;
                transform: translateY(0) scale(1);
            }
        }

        .signup-card:hover {
            transform: scale(1.03);
            box-shadow: 0 12px 30px rgba(0, 0, 0, 0.35);
        }

        /* DOB calendar icon fix */
        input[type="date"] {
            position: relative;
            padding-right: 35px; /* space for icon */
        }

        input[type="date"]::-webkit-calendar-picker-indicator {
            position: absolute;
            right: 10px;
            top: 50%;
            transform: translateY(-50%);
            cursor: pointer;
            opacity: 1;
        }

        /* Remove number arrows */
        input[type=number]::-webkit-inner-spin-button,
        input[type=number]::-webkit-outer-spin-button {
            -webkit-appearance: none;
            margin: 0;
        }

        input[type=number] {
            -moz-appearance: textfield;
        }

        /* Password box extra padding */
        #<%= password.ClientID %> {
            padding-right: 80px;
        }

        .show-password-text {
            display: none;
            cursor: pointer;
            font-size: 0.9rem;
            color: #007bff;
            text-decoration: underline;
            margin-top: 5px;
        }

        /* Hide default eye/clear icons */
        input[type="password"]::-ms-reveal,
        input[type="password"]::-ms-clear {
            display: none;
        }

        input[type="password"]::-webkit-textfield-decoration-container {
            display: none;
        }

        .back-link {
            text-decoration: none;
            color: #007bff;
            font-weight: 500;
            transition: color 0.3s ease;
        }

        .back-link:hover {
            color: #0056b3;
            text-decoration: underline;
        }
    </style>

    <script>
        function togglePasswordVisibility() {
            const passwordInput = document.getElementById('<%= password.ClientID %>');
            const showText = document.getElementById('showPasswordText');

            if (passwordInput.type === 'password') {
                passwordInput.type = 'text';
                showText.innerText = "Hide password";
            } else {
                passwordInput.type = 'password';
                showText.innerText = "Show password";
            }
        }

        function toggleShowPasswordText() {
            const passwordInput = document.getElementById('<%= password.ClientID %>');
            const showText = document.getElementById('showPasswordText');

            if (passwordInput.value.trim().length > 0) {
                showText.style.display = "inline-block";
            } else {
                showText.style.display = "none";
            }
        }

        function adjustHeight(element) {
            element.style.height = 'auto';
            element.style.height = (element.scrollHeight) + 'px';
        }

        document.addEventListener('DOMContentLoaded', function () {
            const validationSummaryContainer = document.getElementById('validationSummaryContainer');

            document.querySelectorAll('.form-control').forEach(function (input) {
                input.addEventListener('input', function () {
                    checkValidation();
                });
            });

            function checkValidation() {
                const errorMessages = document.querySelectorAll('.text-danger');
                let hasError = false;

                errorMessages.forEach(function (error) {
                    if (error.style.display !== 'none') {
                        hasError = true;
                    }
                });

                if (!hasError) {
                    validationSummaryContainer.style.display = 'none';
                } else {
                    validationSummaryContainer.style.display = 'block';
                }
            }

            checkValidation();
        });
    </script>
</asp:Content>

<asp:Content ID="Content4" ContentPlaceHolderID="ContentPlaceHolder" runat="server">
    <div class="container py-5">
        <div class="row justify-content-center">
            <div class="col-lg-4 col-md-6">
                <div class="card signup-card p-4">
                    <div class="card-body">
                        <div class="text-center mb-4">
                            <img width="120" src="imgs/user.png" alt="User Image" class="mb-2" />
                            <h3 class="fw-bold">User SignUp</h3>
                            <hr />
                        </div>

                        <!-- Validation Summary -->
                        <div id="validationSummaryContainer" style="display: none;">
                            <asp:ValidationSummary CssClass="alert alert-danger" runat="server" ShowMessageBox="true" ShowSummary="true" />
                        </div>

                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="fullname">Fullname</label>
                                <asp:TextBox ID="fullname" CssClass="form-control" runat="server" placeholder="Fullname"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvFullname" runat="server" ControlToValidate="fullname"
                                    ErrorMessage="Fullname is required" Display="Dynamic" CssClass="text-danger" ValidationGroup="SignUpValidation" />
                            </div>
                            <div class="col-md-6">
                                <label for="dob">Date Of Birth</label>
                                <asp:TextBox ID="dob" CssClass="form-control" runat="server" TextMode="Date"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvDob" runat="server" ControlToValidate="dob"
                                    ErrorMessage="Date of birth is required" Display="Dynamic" CssClass="text-danger" ValidationGroup="SignUpValidation" />
                            </div>
                        </div>

                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="email">Email</label>
                                <asp:TextBox ID="email" CssClass="form-control" runat="server" placeholder="Email"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="email"
                                    ErrorMessage="Email is required" Display="Dynamic" CssClass="text-danger" ValidationGroup="SignUpValidation" />
                                <asp:RegularExpressionValidator ID="revEmail" runat="server" ControlToValidate="email"
                                    ValidationExpression="\w+@[a-zA-Z_]+?\.[a-zA-Z]{2,3}" ErrorMessage="Invalid email format"
                                    Display="Dynamic" CssClass="text-danger" />
                            </div>
                            <div class="col-md-6">
                                <label for="contact">Contact No.</label>
                                <asp:TextBox ID="contact" CssClass="form-control" runat="server" placeholder="Contact No."></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvContact" runat="server" ControlToValidate="contact"
                                    ErrorMessage="Contact number is required" Display="Dynamic" CssClass="text-danger" ValidationGroup="SignUpValidation" />
                            </div>
                        </div>

                        <div class="row mb-3">
                            <div class="col-md-4">
                                <label for="state">State</label>
                                <asp:DropDownList ID="state" CssClass="form-select" runat="server">
                                    <asp:ListItem Text="Select a State" Value="" Selected="True"></asp:ListItem>
                                    <asp:ListItem Text="Andhra Pradesh" Value="AP"></asp:ListItem>
                                    <asp:ListItem Text="Arunachal Pradesh" Value="AR"></asp:ListItem>
                                    <asp:ListItem Text="Assam" Value="AS"></asp:ListItem>
                                    <asp:ListItem Text="Bihar" Value="BR"></asp:ListItem>
                                    <asp:ListItem Text="Chhattisgarh" Value="CG"></asp:ListItem>
                                    <asp:ListItem Text="Goa" Value="GA"></asp:ListItem>
                                    <asp:ListItem Text="Gujarat" Value="GJ"></asp:ListItem>
                                    <asp:ListItem Text="Haryana" Value="HR"></asp:ListItem>
                                    <asp:ListItem Text="Himachal Pradesh" Value="HP"></asp:ListItem>
                                    <asp:ListItem Text="Jharkhand" Value="JH"></asp:ListItem>
                                    <asp:ListItem Text="Karnataka" Value="KA"></asp:ListItem>
                                    <asp:ListItem Text="Kerala" Value="KL"></asp:ListItem>
                                    <asp:ListItem Text="Madhya Pradesh" Value="MP"></asp:ListItem>
                                    <asp:ListItem Text="Maharashtra" Value="MH"></asp:ListItem>
                                    <asp:ListItem Text="Manipur" Value="MN"></asp:ListItem>
                                    <asp:ListItem Text="Meghalaya" Value="ML"></asp:ListItem>
                                    <asp:ListItem Text="Mizoram" Value="MZ"></asp:ListItem>
                                    <asp:ListItem Text="Nagaland" Value="NL"></asp:ListItem>
                                    <asp:ListItem Text="Odisha" Value="OD"></asp:ListItem>
                                    <asp:ListItem Text="Punjab" Value="PB"></asp:ListItem>
                                    <asp:ListItem Text="Rajasthan" Value="RJ"></asp:ListItem>
                                    <asp:ListItem Text="Sikkim" Value="SK"></asp:ListItem>
                                    <asp:ListItem Text="Tamil Nadu" Value="TN"></asp:ListItem>
                                    <asp:ListItem Text="Telangana" Value="TS"></asp:ListItem>
                                    <asp:ListItem Text="Tripura" Value="TR"></asp:ListItem>
                                    <asp:ListItem Text="Uttar Pradesh" Value="UP"></asp:ListItem>
                                    <asp:ListItem Text="Uttarakhand" Value="UK"></asp:ListItem>
                                    <asp:ListItem Text="West Bengal" Value="WB"></asp:ListItem>
                                </asp:DropDownList>
                                <asp:RequiredFieldValidator ID="rfvState" runat="server" ControlToValidate="state"
                                    InitialValue="" ErrorMessage="State is required" Display="Dynamic" CssClass="text-danger" ValidationGroup="SignUpValidation" />
                            </div>
                            <div class="col-md-4">
                                <label for="city">City</label>
                                <asp:TextBox ID="city" CssClass="form-control" runat="server" placeholder="City"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvCity" runat="server" ControlToValidate="city"
                                    ErrorMessage="City is required" Display="Dynamic" CssClass="text-danger" ValidationGroup="SignUpValidation" />
                            </div>
                            <div class="col-md-4">
                                <label for="pincode">PinCode</label>
                                <asp:TextBox ID="pincode" CssClass="form-control" runat="server" placeholder="PinCode" TextMode="Number" MaxLength="6" oninput="if(this.value.length > 6) this.value = this.value.slice(0,6);"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvPincode" runat="server" ControlToValidate="pincode"
                                    ErrorMessage="PinCode is required" Display="Dynamic" CssClass="text-danger" />
                                <asp:RegularExpressionValidator ID="revPincode" runat="server" ControlToValidate="pincode"
                                    ValidationExpression="^\d{6}$" ErrorMessage="Pincode must be 6 digits"
                                    Display="Dynamic" CssClass="text-danger" />
                            </div>
                        </div>

                        <div class="mb-3">
                            <label for="address">Address</label>
                            <asp:TextBox runat="server" ID="address" rows="1" CssClass="form-control" TextMode="MultiLine"
                                Placeholder="Complete Address"
                                Style="height: auto; max-height: 100px; overflow-y: auto;"
                                oninput="adjustHeight(this)">
                            </asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvAddress" runat="server" ControlToValidate="address"
                                ErrorMessage="Address is required" Display="Dynamic" CssClass="text-danger" ValidationGroup="SignUpValidation" />
                        </div>

                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="memberid">UserID</label>
                                <asp:TextBox ID="memberid" CssClass="form-control" runat="server" placeholder="UserID"></asp:TextBox>
                            </div>
                            <div class="col-md-6">
                                <label for="password">Password</label>
                                <asp:TextBox ID="password" TextMode="Password" CssClass="form-control"
                                    runat="server" placeholder="Password" MaxLength="16" oninput="toggleShowPasswordText()"></asp:TextBox>
                                <span id="showPasswordText" class="show-password-text" onclick="togglePasswordVisibility()">Show password</span>
                                <asp:RequiredFieldValidator ID="rfvPassword" runat="server" ControlToValidate="password"
                                    ErrorMessage="Password is required" Display="Dynamic" CssClass="text-danger" ValidationGroup="SignUpValidation" />
                            </div>
                        </div>

                        <asp:Button ID="Button1" CssClass="btn btn-md btn-primary w-100" runat="server" Text="SignUp" OnClick="Button1_Click" ValidationGroup="SignUpValidation" />
                    </div>
                </div>

                <div class="text-center mt-3">
                    <a class="back-link" href="Homepage.aspx">&lt;&lt; Back to Home</a>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
