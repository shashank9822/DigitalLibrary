<%@ Page Title="" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="UserLogin.aspx.cs" Inherits="webapp.UserLogin" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder" runat="server">
    
<div class="container">
    <div class="row">
        <div class="col-md-4 mx-auto">
            <div class="card">
                <div class="card-body">
                    <div class="text-center mb-3">
                        <img width="150px" src="imgs/user.png" alt="User Icon" />
                    </div>

                    <h3 class="text-center">User Register</h3>
                    <hr />

                    <div class="mb-3">
                        <label for="TextBox1" class="form-label">User ID</label>
                        <asp:TextBox CssClass="form-control" ID="userid" runat="server" placeholder="User Id"></asp:TextBox>
                    </div>

                    <div class="mb-3 position-relative">
                        <label for="password">Password</label>
                        <div class="input-group position-relative">
                            <input type="password" class="form-control" runat="server" ID="password" placeholder="Password" />
                            <span id="togglePasswordText" onclick="togglePasswordVisibility()" class="toggle-password" style="cursor: pointer;">Show
        </span>
    </div>
</div>

<script>
    function togglePasswordVisibility() {
        const passwordInput = document.getElementById('password');
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

<style>
    .input-group {
        display: flex;
        align-items: center; /* Vertically centers content */
    }

    .toggle-password {
        position: absolute;
        right: 15px; /* Adjust right position */
        top: 50%; /* Center vertically */
        transform: translateY(-50%); /* Adjust vertical position */
        font-weight: bold;      
        font-size: 1rem;        
        color: #007bff;         
        padding: 0 10px; /* Horizontal padding */
        cursor: pointer;        
    }

    .form-control {
        padding-right: 60px; /* Space for the Show/Hide text */
    }
</style>

                    <div class="row justify-content-end">
                        <div class="col-auto">
                            <asp:Button class="btn btn-success btn-md" ID="Button2" runat="server" Text="Login" OnClick="Button2_Click" />
                        </div>
                        <div class="col-auto">
                            <a href="UserSignUp.aspx" runat="server" class="btn btn-info btn-md">Sign up</a>
                        </div>
                    </div>
                                        
                </div>
            </div>
        </div>
        <div class="text-center mt-3">
            <a href="Homepage.aspx"><< Back to Home</a>
        </div>
    </div>
</div>



</asp:Content>
