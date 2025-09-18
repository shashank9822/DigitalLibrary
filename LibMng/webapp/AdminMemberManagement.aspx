<%@ Page Title="" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="AdminMemberManagement.aspx.cs" Inherits="webapp.AdminMemberManagement" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        .card {
            box-shadow: 0 0.15rem 1.75rem 0 rgba(58, 59, 69, 0.15);
            border: none;
            margin-bottom: 1.5rem;
        }

        .card-header {
            background: linear-gradient(45deg, #4e73df, #6f42c1);
            color: white;
            border-bottom: none;
        }

        .input-group {
            margin-bottom: 0.5rem;
        }

        .status-badge {
            font-size: 0.8rem;
            padding: 0.35rem 0.65rem;
        }

        .member-table {
            font-size: 0.9rem;
            width: 100%;
        }

        .member-table th {
            background-color: #4e73df;
            color: white;
            padding: 0.75rem;
        }

        .member-table td {
            padding: 0.6rem;
            vertical-align: middle;
        }

        .member-table tr:nth-child(even) {
            background-color: #f8f9fa;
        }

        .member-table tr:hover {
            background-color: rgba(78, 115, 223, 0.1);
        }

        /* Status colors */
        .status-active {
            background-color: #1cc88a !important;
        }

        .status-pending {
            background-color: #f6c23e !important;
        }

        .status-inactive {
            background-color: #e74a3b !important;
        }

        /* Input group button fixes */
        .input-group-btn .btn {
            border-radius: 0 0.35rem 0.35rem 0 !important;
            margin: 0;
            height: 100%;
            padding: 0.5rem 0.75rem;
        }

        .input-group {
            align-items: stretch;
        }

        .input-group-btn {
            display: flex;
        }

        .input-group-btn .btn {
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .form-control[readonly] {
            background-color: #f8f9fa;
            overflow-y: auto;
            resize: vertical;
        }

        /* Button layout */
        .action-buttons-container {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            gap: 8px;
            margin-top: 1.5rem;
        }

            /* Ensure delete button has enough width for the text */
            .action-buttons-container .btn-danger {
                min-width: 180px; /* Adjust this value as needed */
                white-space: nowrap;
            }

            /* Or make all buttons in the container flexible */
            .action-buttons-container .btn {
                white-space: nowrap;
                flex: 0 1 auto; /* Allow buttons to grow/shrink as needed */
                min-width: 120px; /* Minimum width */
            }

        /* Toast customization */
        .custom-toast {
            z-index: 9999;
        }

        /* Center status badge in grid */
        .status-cell {
            text-align: center;
        }

        /* Responsive adjustments */
        @media (max-width: 768px) {
            .input-group {
                flex-direction: column;
            }

            .input-group .form-control,
            .input-group .btn {
                width: 100%;
                margin-bottom: 0.25rem;
                border-radius: 0.35rem !important;
            }

            .member-table {
                font-size: 0.8rem;
            }
        }
    </style>

    <script type="text/javascript">
        var dataTable;

        // Function to clear all form fields
        function clearFormFields() {
            var textboxes = [
            '<%= TextBox1.ClientID %>', '<%= TextBox2.ClientID %>', '<%= TextBox3.ClientID %>',
            '<%= TextBox4.ClientID %>', '<%= TextBox5.ClientID %>', '<%= TextBox6.ClientID %>',
            '<%= TextBox7.ClientID %>', '<%= TextBox8.ClientID %>', '<%= TextBox9.ClientID %>',
            '<%= TextBox10.ClientID %>'
            ];
            textboxes.forEach(function (id) {
                var el = document.getElementById(id);
                if (el) el.value = '';
            });

            // Clear validation messages
            var validationElements = document.querySelectorAll('.validator-error, .field-validation-error');
            validationElements.forEach(function (el) { el.style.display = 'none'; });
        }

        // Toast notification
        function showToast(message, type) {
            $('.custom-toast').remove();
            var alertClass = 'alert-info';
            switch (type) {
                case 'success': alertClass = 'alert-success'; break;
                case 'error': alertClass = 'alert-danger'; break;
                case 'warning': alertClass = 'alert-warning'; break;
                case 'info': alertClass = 'alert-info'; break;
                default: alertClass = 'alert-primary';
            }
            var toastHtml = `
            <div class="custom-toast position-fixed top-0 end-0 p-3" style="z-index:9999; min-width:300px;">
                <div class="alert ${alertClass} alert-dismissible fade show" role="alert">
                    <i class="fas ${getToastIcon(type)} me-2"></i>
                    ${message}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </div>
        `;
            $('body').append(toastHtml);
            setTimeout(function () { $('.custom-toast').alert('close'); }, 5000);
        }

        function getToastIcon(type) {
            switch (type) {
                case 'success': return 'fa-check-circle';
                case 'error': return 'fa-exclamation-circle';
                case 'warning': return 'fa-exclamation-triangle';
                case 'info': return 'fa-info-circle';
                default: return 'fa-bell';
            }
        }

        // Update grid status
        function updateGridStatus(memberId, newStatus) {
            var gridView = $('#<%=GridView1.ClientID%>');
            gridView.find('tbody tr').each(function () {
                var rowMemberId = $(this).find('td:first').text().trim();
                if (rowMemberId === memberId) {
                    var badge = $(this).find('td:nth-child(3) .badge');
                    badge.removeClass('status-active status-pending status-inactive bg-secondary');
                    switch (newStatus.toLowerCase()) {
                        case 'active': badge.addClass('status-active'); break;
                        case 'pending': badge.addClass('status-pending'); break;
                        case 'inactive': badge.addClass('status-inactive'); break;
                        default: badge.addClass('bg-secondary');
                    }
                    badge.text(newStatus);
                    return false;
                }
            });
        }

        // Initialize DataTable
        function initializeDataTable() {
            var gridView = $('#<%=GridView1.ClientID%>');
            if (gridView.length && gridView.find('tbody tr').length > 0) {
                if (gridView.find('thead').length === 0) {
                    var firstRow = gridView.find('tr:first');
                    if (firstRow.length) $('<thead>').append(firstRow).prependTo(gridView);
                }
                if ($.fn.DataTable.isDataTable(gridView)) {
                    gridView.DataTable().destroy();
                }
                dataTable = gridView.DataTable({
                    responsive: true,
                    pageLength: 10,
                    lengthMenu: [5, 10, 25, 50],
                    ordering: true,
                    searching: true,
                    stateSave: true,
                    stateDuration: -1,
                    autoWidth: false,
                    language: {
                        search: "Search members:",
                        lengthMenu: "Show _MENU_ entries",
                        info: "Showing _START_ to _END_ of _TOTAL_ entries",
                        paginate: { previous: "Previous", next: "Next" }
                    }
                });
            }
        }

        // Run after every postback or page load
        if (typeof (Sys) !== "undefined") {
            Sys.Application.add_load(function () {
                initializeDataTable();
            });
        } else {
            $(document).ready(function () {
                initializeDataTable();
            });
        }

        // Button hover effects
        $(document).ready(function () {
            $('.btn').hover(
                function () { $(this).css({ 'transform': 'translateY(-1px)', 'box-shadow': '0 4px 8px rgba(0,0,0,0.15)' }); },
                function () { $(this).css({ 'transform': 'translateY(0)', 'box-shadow': 'none' }); }
            );

        <% if (Session["ToastMessage"] != null) { %>
            showToast('<%= Session["ToastMessage"].ToString().Replace("'", "\\'") %>', '<%= Session["ToastType"] ?? "info" %>');
            <% Session.Remove("ToastMessage"); Session.Remove("ToastType"); %>
        <% } %>

        <% if (Session["UpdatedMemberId"] != null && Session["UpdatedStatus"] != null) { %>
            updateGridStatus('<%= Session["UpdatedMemberId"] %>', '<%= Session["UpdatedStatus"] %>');
            <% Session.Remove("UpdatedMemberId"); Session.Remove("UpdatedStatus"); %>
        <% } %>

        <% if (Session["ClearForm"] != null && (bool)Session["ClearForm"]) { %>
            clearFormFields();
            <% Session.Remove("ClearForm"); %>
        <% } %>
    });
    </script>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder" runat="server">
    <div class="container-fluid">
        <div class="row justify-content-center">
            <!-- Left Card (Member Details Section) -->
            <div class="col-md-5">
                <div class="card">
                    <div class="card-header py-3">
                        <h5 class="m-0 font-weight-bold text-white"><i class="fas fa-user-cog me-2"></i>Member Management</h5>
                    </div>
                    <div class="card-body">
                        <div class="text-center mb-4">
                            <img width="150px" src="imgs/msearch.png" class="img-fluid" alt="Member search" />
                            <h4 class="mt-3">Member Details</h4>
                            <hr />
                        </div>

                        <!-- Member ID Search -->
                        <div class="row mb-3">
                            <div class="col-12">
                                <label class="form-label fw-bold">Member ID</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fas fa-id-card"></i></span>
                                    <asp:TextBox CssClass="form-control" ID="TextBox1" runat="server" placeholder="Enter Member ID"></asp:TextBox>
                                    <div class="input-group-btn">
                                        <asp:LinkButton CssClass="btn btn-primary" ID="LinkButton5" runat="server" OnClick="LinkButton5_Click" ToolTip="Search Member">
                                            <i class="fas fa-search"></i>
                                        </asp:LinkButton>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Member Info -->
                        <div class="row mb-3">
                            <div class="col-md-12">
                                <label class="form-label fw-bold">Member Name</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fas fa-user"></i></span>
                                    <asp:TextBox CssClass="form-control" ID="TextBox2" runat="server" placeholder="Full Name" ReadOnly="True"></asp:TextBox>
                                </div>
                            </div>
                        </div>

                        <!-- Account Status Management -->
                        <div class="row mb-3">
                            <div class="col-12">
                                <label class="form-label fw-bold">Account Status</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fas fa-user-check"></i></span>
                                    <asp:TextBox CssClass="form-control" ID="TextBox5" runat="server" placeholder="Account Status" ReadOnly="True"></asp:TextBox>
                                    <div class="input-group-btn">
                                        <asp:LinkButton CssClass="btn btn-success" ID="LinkButton2" runat="server" OnClick="LinkButton2_Click" ToolTip="Activate Account">
                                            <i class="fas fa-check-circle"></i>
                                        </asp:LinkButton>
                                        <asp:LinkButton CssClass="btn btn-warning" ID="LinkButton3" runat="server" OnClick="LinkButton3_Click" ToolTip="Pause Account">
                                            <i class="fas fa-pause-circle"></i>
                                        </asp:LinkButton>
                                        <asp:LinkButton CssClass="btn btn-danger" ID="LinkButton4" runat="server" OnClick="LinkButton4_Click" ToolTip="Deactivate Account">
                                            <i class="fas fa-times-circle"></i>
                                        </asp:LinkButton>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Contact Info -->
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label class="form-label">Email</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fas fa-envelope"></i></span>
                                    <asp:TextBox CssClass="form-control" ID="TextBox3" runat="server" placeholder="Email" ReadOnly="True"></asp:TextBox>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Contact No.</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fas fa-phone"></i></span>
                                    <asp:TextBox CssClass="form-control" ID="TextBox4" runat="server" placeholder="Contact No." ReadOnly="True"></asp:TextBox>
                                </div>
                            </div>
                        </div>

                        <!-- Additional Info -->
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label class="form-label">Date of Birth</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fas fa-birthday-cake"></i></span>
                                    <asp:TextBox CssClass="form-control" ID="TextBox6" runat="server" placeholder="DOB" ReadOnly="True"></asp:TextBox>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Pincode</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fas fa-map-pin"></i></span>
                                    <asp:TextBox CssClass="form-control" ID="TextBox9" runat="server" placeholder="Pincode" ReadOnly="True"></asp:TextBox>
                                </div>
                            </div>
                        </div>

                        <!-- Location Info -->
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label class="form-label">State</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fas fa-map-marked-alt"></i></span>
                                    <asp:TextBox CssClass="form-control" ID="TextBox7" runat="server" placeholder="State" ReadOnly="True"></asp:TextBox>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">City</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fas fa-city"></i></span>
                                    <asp:TextBox CssClass="form-control" ID="TextBox8" runat="server" placeholder="City" ReadOnly="True"></asp:TextBox>
                                </div>
                            </div>
                        </div>

                        <!-- Complete Address -->
                        <div class="mb-3">
                            <label class="form-label fw-semibold">Complete Address</label>
                            <div class="input-group">
                                <span class="input-group-text bg-light">
                                    <i class="fas fa-address-card text-secondary"></i>
                                </span>
                                <asp:TextBox
                                    ID="TextBox10"
                                    runat="server"
                                    CssClass="form-control shadow-sm"
                                    placeholder="Complete Address"
                                    TextMode="MultiLine"
                                    ReadOnly="True"
                                    Rows="2"
                                    Style="min-height: 80px; max-height: 200px; overflow-y: auto; resize: none;" />
                            </div>
                        </div>


                        <!-- Action Buttons -->
                        <div class="action-buttons-container">
                            <asp:Button CssClass="btn btn-md btn-danger" ID="Button2" runat="server" Text="Delete Member Permanently"
                                OnClick="Button2_Click" OnClientClick="return confirm('Are you sure you want to permanently delete this member? This action cannot be undone.');" />
                        </div>
                    </div>
                </div>
            </div>

            <!-- Right Card (Member List) -->
            <div class="col-md-7">
                <div class="card">
                    <div class="card-header py-3">
                        <h5 class="m-0 font-weight-bold text-white"><i class="fas fa-users me-2"></i>Member Database</h5>
                    </div>
                    <div class="card-body">
                        <div class="text-center mb-4">
                            <h4>All Members</h4>
                            <span class="badge bg-info">Total Members:
                                <asp:Label ID="lblTotalMembers" runat="server" Text="0" /></span>
                            <hr />
                        </div>

                        <div class="row">
                            <asp:SqlDataSource ID="SqlDataSource1" runat="server"
                                ConnectionString="<%$ ConnectionStrings:LibMngDBConnectionString2 %>"
                                ProviderName="<%$ ConnectionStrings:LibMngDBConnectionString2.ProviderName %>"
                                SelectCommand="SELECT * FROM [user_admin_tbl] ORDER BY full_name"></asp:SqlDataSource>

                            <div class="col-12">
                                <div class="table-responsive">
                                    <asp:GridView CssClass="table table-striped table-hover member-table" ID="GridView1" runat="server"
                                        AutoGenerateColumns="False" DataKeyNames="member_id" DataSourceID="SqlDataSource1" ClientIDMode="Static">
                                        <Columns>
                                            <asp:BoundField DataField="member_id" HeaderText="ID" ReadOnly="True" SortExpression="member_id" ItemStyle-CssClass="fw-bold" />
                                            <asp:BoundField DataField="full_name" HeaderText="Member Name" SortExpression="full_name" />
                                            <asp:TemplateField HeaderText="Status" SortExpression="account_status" ItemStyle-CssClass="status-cell">
                                                <ItemTemplate>
                                                    <span class='badge status-badge <%# GetStatusClass(Eval("account_status").ToString()) %>'>
                                                        <%# Eval("account_status") %>
                                                    </span>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:BoundField DataField="contact_no" HeaderText="Contact" SortExpression="contact_no" />
                                            <asp:BoundField DataField="email" HeaderText="Email" SortExpression="email" />
                                            <asp:BoundField DataField="state" HeaderText="State" SortExpression="state" />
                                            <asp:BoundField DataField="city" HeaderText="City" SortExpression="city" />
                                        </Columns>
                                        <EmptyDataTemplate>
                                            <div class="text-center py-4">
                                                <i class="fas fa-users fa-3x text-muted mb-3"></i>
                                                <h5>No members found</h5>
                                                <p class="text-muted">There are no members in the database.</p>
                                            </div>
                                        </EmptyDataTemplate>
                                    </asp:GridView>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Back to Home Link -->
        <div class="text-center mt-4">
            <a href="Homepage.aspx" class="btn btn-outline-primary">
                <i class="fas fa-arrow-left me-2"></i>Back to Home
            </a>
        </div>
    </div>
</asp:Content>