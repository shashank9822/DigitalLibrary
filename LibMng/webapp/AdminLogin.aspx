<%@ Page Title="" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="AdminLogin.aspx.cs" Inherits="webapp.AsminLogin" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        /* Full-page background */
        body {
            background: linear-gradient(rgba(15, 32, 39, 0.85), rgba(32, 58, 67, 0.85), rgba(44, 83, 100, 0.85)),
                        url('imgs/library-bg.jpg') no-repeat center center fixed;
            background-size: cover;
        }

        /* Login Card */
        .login-card {
            background: rgba(255, 255, 255, 0.12);
            backdrop-filter: blur(12px);
            border-radius: 1rem;
            border: 1px solid rgba(255, 255, 255, 0.2);
            box-shadow: 0 8px 25px rgba(0,0,0,0.25);

            /* Entrance Animation */
            opacity: 0;
            transform: translateY(-30px) scale(0.95);
            animation: fadeSlideIn 0.9s ease forwards;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        @keyframes fadeSlideIn {
            to {
                opacity: 1;
                transform: translateY(0) scale(1);
            }
        }

        /* Hover Animation */
        .login-card:hover {
            transform: scale(1.03);
            box-shadow: 0 12px 30px rgba(0,0,0,0.35);
        }

        .login-card h3 {
            font-weight: 600;
            color: #fff;
        }
        .login-card img {
            border-radius: 50%;
            box-shadow: 0 4px 15px rgba(0,0,0,0.3);
        }

        /* Inputs */
        label {
            font-weight: 500;
            color: #fff;
        }
        .form-control {
            height: 45px;
            border-radius: 0.5rem;
            background: rgba(255, 255, 255, 0.9);
        }

        /* Toggle Password Icon */
        .toggle-password {
            position: absolute;
            right: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #0d6efd;
            cursor: pointer;
            font-size: 1.1rem;
        }

        /* Login Button */
        .btn-md {
            padding: 0.5rem 1.5rem;
            font-size: 0.95rem;
            border-radius: 0.5rem;
        }

        /* Back link */
        .back-link {
            font-weight: 500;
            color: #fff;
            text-decoration: none;
        }
        .back-link:hover {
            text-decoration: underline;
            color: #0d6efd;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder" runat="server">

<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-lg-4 col-md-6">
            <div class="card login-card p-4">
                <div class="card-body">
                    <!-- Header -->
                    <div class="text-center mb-4">
                        <img src="imgs/adm.png" alt="Admin Icon" width="120" />
                        <h3 class="mt-3"><i class="fas fa-user-shield me-2"></i>Admin Login</h3>
                        <hr class="border-light" />
                    </div>

                    <!-- Admin ID -->
                    <div class="mb-3">
                        <label for="adminid">Admin ID</label>
                        <input type="text" class="form-control" runat="server" id="adminid" placeholder="Enter Admin ID" />
                    </div>

                    <!-- Password -->
                    <div class="mb-4 position-relative">
                        <label for="password">Password</label>
                        <div class="input-group position-relative">
                            <input type="password" class="form-control" id="password" runat="server" placeholder="Enter Password" />
                            <i id="togglePasswordIcon" class="fa-solid fa-eye toggle-password" onclick="togglePasswordVisibility()"></i>
                        </div>
                    </div>

                    <!-- Buttons -->
                    <div class="d-flex justify-content-end">
                        <asp:LinkButton CssClass="btn btn-success btn-md" ID="LinkButton1" runat="server" OnClick="LinkButton1_Click">
                            <i class="fas fa-sign-in-alt me-1"></i> Login
                        </asp:LinkButton>
                    </div>
                </div>
            </div>

            <!-- Back Link -->
            <div class="text-center mt-3">
                <a class="back-link" href="Homepage.aspx"><i class="fas fa-arrow-left me-2"></i>Back to Home</a>
            </div>
        </div>
    </div>
</div>

<!-- Password toggle script -->
<script>
    function togglePasswordVisibility() {
        const passwordInput = document.getElementById('password');
        const toggleIcon = document.getElementById('togglePasswordIcon');
        if (passwordInput.type === 'password') {
            passwordInput.type = 'text';
            toggleIcon.classList.remove('fa-eye');
            toggleIcon.classList.add('fa-eye-slash');
        } else {
            passwordInput.type = 'password';
            toggleIcon.classList.remove('fa-eye-slash');
            toggleIcon.classList.add('fa-eye');
        }
    }
</script>

</asp:Content>
