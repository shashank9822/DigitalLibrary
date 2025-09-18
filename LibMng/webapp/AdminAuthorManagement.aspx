<%@ Page Title="" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="AdminAuthorManagement.aspx.cs" Inherits="webapp.AdminAuthorManagement" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        /* Page-specific styles for AdminAuthorManagement.aspx */
        .author-management-container {
            padding: 20px 0;
        }
        
        .author-img {
            width: 120px;
            height: 120px;
            object-fit: cover;
            border: 5px solid #fff;
            box-shadow: 0 0.15rem 1.75rem 0 rgba(58, 59, 69, 0.15);
        }
        
        .action-buttons .btn {
            margin: 0 3px;
        }
        
        .back-link {
            color: #4e73df;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        
        .back-link:hover {
            color: #6f42c1;
            text-decoration: underline;
        }
        
        /* Custom table styles for this page */
        .author-table {
            border-collapse: separate;
            border-spacing: 0;
        }
        
        .author-table thead th {
            position: sticky;
            top: 0;
            background-color: #4e73df;
            color: white;
            z-index: 10;
        }
        
        .author-table tbody tr {
            transition: background-color 0.3s;
        }
        
        .author-table tbody tr:hover {
            background-color: rgba(78, 115, 223, 0.05);
        }
        
        /* Validation summary styles */
        .validation-summary {
            background-color: #f8d7da;
            border: 1px solid #f5c6cb;
            border-radius: 0.35rem;
            padding: 0.75rem 1.25rem;
            margin-top: 1rem;
        }
        
        .validation-summary ul {
            margin-bottom: 0;
            padding-left: 1.5rem;
        }
        
        /* Improved input group styling */
        .input-group {
            margin-bottom: 1rem;
            box-shadow: 0 0.15rem 0.5rem 0 rgba(58, 59, 69, 0.1);
            border-radius: 0.35rem;
        }
        
        .input-group-text {
            background: linear-gradient(to right, #4e73df, #6f42c1);
            color: white;
            border: none;
            border-radius: 0.35rem 0 0 0.35rem !important;
        }
        
        .form-control {
            border: 1px solid #d1d3e2;
            border-left: none;
            padding: 0.75rem 1rem;
        }
        
        .form-control:focus {
            box-shadow: none;
            border-color: #d1d3e2;
        }
        
        .input-group-btn .btn {
            border-radius: 0 0.35rem 0.35rem 0 !important;
            margin: 0;
            height: 100%;
        }
        
        /* Validation styles */
        .validation-error {
            color: #e74a3b;
            font-size: 0.875rem;
            margin-top: 0.25rem;
            display: block;
        }
        
        .duplicate-warning {
            color: #f6c23e;
            font-size: 0.875rem;
            margin-top: 0.25rem;
            display: block;
        }
        
        .is-invalid {
            border-color: #e74a3b !important;
        }
        
        .is-warning {
            border-color: #f6c23e !important;
        }
        
        /* Action button styles */
        .btn-select {
            background-color: #4e73df;
            color: white;
            padding: 0.25rem 0.5rem;
            font-size: 0.75rem;
        }
        
        .btn-select:hover {
            background-color: #2e59d9;
            color: white;
        }
        
        /* Center the select button in grid */
        .author-table td:last-child {
            text-align: center;
        }
        
        /* NEW STYLES FOR BUTTON LAYOUT */
        .action-buttons-container {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            gap: 8px;
            margin-top: 1.5rem;
        }
        
        .action-buttons-container .btn {
            flex: 1;
            min-width: 90px;
            max-width: 120px;
        }
        
        /* Responsive design for this page */
        @media (max-width: 992px) {
            .author-management-container .row {
                flex-direction: column;
            }
            
            .author-management-container .col-md-4,
            .author-management-container .col-md-7 {
                max-width: 100%;
                flex: 0 0 100%;
            }
            
            .author-management-container .col-md-7 {
                margin-top: 1.5rem;
            }
            
            .action-buttons-container {
                display: flex;
                justify-content: center;
                flex-wrap: wrap;
            }
            
            .action-buttons-container .btn {
                margin: 5px;
                flex: 0 0 calc(50% - 10px);
                max-width: calc(50% - 10px);
            }
        }
        
        @media (max-width: 576px) {
            .action-buttons-container .btn {
                flex: 0 0 100%;
                max-width: 100%;
            }
        }
    </style>
    
    <script type="text/javascript">
        // Use jQuery's $ safely in case of conflicts
        jQuery(document).ready(function ($) {
            // Check if GridView exists and has rows
            var gridView = $('#<%=GridView1.ClientID%>');

            if (gridView.length && gridView.find('tr').length > 0) {
                // Ensure the table has proper structure for DataTables
                if (gridView.find('thead').length === 0) {
                    // If no thead exists, create one from the first row
                    var firstRow = gridView.find('tr:first');
                    if (firstRow.length) {
                        $('<thead>').append(firstRow).prependTo(gridView);
                    }
                }

                // Initialize DataTable with options
                gridView.DataTable({
                    responsive: true,
                    pageLength: 10,
                    lengthMenu: [5, 10, 25, 50],
                    ordering: true,
                    searching: true,
                    stateSave: true,
                    language: {
                        search: "Filter:",
                        lengthMenu: "Show _MENU_ entries",
                        info: "Showing _START_ to _END_ of _TOTAL_ entries",
                        paginate: {
                            previous: "Previous",
                            next: "Next"
                        }
                    }
                });
            } else {
                console.warn('GridView not found or has no data');
            }

            // Add some interactivity
            $('.btn').hover(
                function () {
                    $(this).css('transform', 'translateY(-2px)');
                },
                function () {
                    $(this).css('transform', 'translateY(0)');
                }
            );

            // Clear button functionality
            $('#<%=btnClear.ClientID%>').click(function () {
                // Clear textboxes
                $('#<%=TextBox1.ClientID%>').val('');
                $('#<%=TextBox2.ClientID%>').val('');

                // Remove validation classes and messages
                $('.form-control').removeClass('is-invalid is-warning');
                $('.validation-error, .duplicate-warning').hide();

                // Reset the Go button mode
                $('#<%=LinkButton1.ClientID%>').removeAttr('data-mode');

                // Clear validation summaries
                $('#<%=ValidationSummary1.ClientID%>, #<%=ValidationSummary2.ClientID%>').hide();

                return false; // Prevent postback
            });

            // Form validation enhancement
            $('.form-control').focus(function () {
                $(this).removeClass('is-invalid is-warning');
                $(this).parent().css('box-shadow', '0 0 0 0.2rem rgba(78, 115, 223, 0.25)');
            }).blur(function () {
                $(this).parent().css('box-shadow', '0 0.15rem 0.5rem 0 rgba(58, 59, 69, 0.1)');
            });

            // Check for duplicate ID
            function checkDuplicateId(authorId) {
                // This would typically call server-side code
                // For demonstration, we'll simulate with existing data
                var duplicateFound = false;
                $('#<%=GridView1.ClientID%> tbody tr').each(function () {
                    var existingId = $(this).find('td:first').text().trim();
                    if (existingId === authorId) {
                        duplicateFound = true;
                        return false; // break out of loop
                    }
                });
                return duplicateFound;
            }

            // Validate individual field
            function validateField(field, isAddOperation) {
                var fieldId = field.attr('id');
                var value = field.val().trim();

                // Reset validation messages
                $('#' + fieldId + '_error').hide();
                $('#' + fieldId + '_duplicate').hide();
                field.removeClass('is-invalid is-warning');

                // Author ID validation
                if (fieldId === '<%=TextBox1.ClientID%>') {
                    if (value === '') {
                        $('#' + fieldId + '_error').show();
                        field.addClass('is-invalid');
                        return false;
                    } else if (isAddOperation && checkDuplicateId(value)) {
                        $('#' + fieldId + '_duplicate').show();
                        field.addClass('is-warning');
                        return false;
                    }
                }

                // Author Name validation
                if (fieldId === '<%=TextBox2.ClientID%>') {
                    if (value === '') {
                        $('#' + fieldId + '_error').show();
                        field.addClass('is-invalid');
                        return false;
                    }
                }

                return true;
            }

            // Validate form before submission
            function validateForm(operation) {
                var isValid = true;
                var isAddOperation = (operation === 'add');

                // Author ID validation
                var authorId = $('#<%=TextBox1.ClientID%>');
                if (!validateField(authorId, isAddOperation)) {
                    isValid = false;
                }

                // Author Name validation (required for all operations except Go)
                if (operation !== 'go') {
                    var authorName = $('#<%=TextBox2.ClientID%>');
                    if (!validateField(authorName, isAddOperation)) {
                        isValid = false;
                    }
                }
                
                return isValid;
            }
            
            // Set up button click handlers for validation
            $('#<%=LinkButton1.ClientID%>').click(function(e) {
                if (!validateForm('go')) {
                    e.preventDefault();
                    return false;
                }
            });
            
            $('#<%=Button1.ClientID%>').click(function (e) {
                if (!validateForm('add')) {
                    e.preventDefault();
                    return false;
                }
            });
            
            $('#<%=Button2.ClientID%>').click(function (e) {
                if (!validateForm('delete')) {
                    e.preventDefault();
                    return false;
                }
            });
            
            $('#<%=Button3.ClientID%>').click(function (e) {
                if (!validateForm('update')) {
                    e.preventDefault();
                    return false;
                }
            });
            
            // Handle select buttons in the grid
            $(document).on('click', '.select-author', function() {
                var row = $(this).closest('tr');
                var authorId = row.find('td:eq(0)').text().trim();
                var authorName = row.find('td:eq(1)').text().trim();
                
                // Fill the form fields
                $('#<%=TextBox1.ClientID%>').val(authorId);
                $('#<%=TextBox2.ClientID%>').val(authorName);
                
                // Change the Go button to edit mode
                $('#<%=LinkButton1.ClientID%>').attr('data-mode', 'edit');
                
                // Clear any validation messages
                $('.form-control').removeClass('is-invalid is-warning');
                $('.validation-error, .duplicate-warning').hide();
                
                // Scroll to the form
                $('html, body').animate({
                    scrollTop: $('#<%=TextBox1.ClientID%>').offset().top - 100
                }, 500);
            });
        });
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder" runat="server">
    <div class="container author-management-container">
        <div class="row justify-content-center">
            <!-- Left Card -->
            <div class="col-md-4">
                <div class="card">
                    <div class="card-header py-3">
                        <h5 class="m-0 font-weight-bold"><i class="fas fa-user-edit me-2"></i>Author Management</h5>
                    </div>
                    <div class="card-body">
                        <div class="text-center mb-4">
                            <img width="150px" src="imgs/user.png" alt="User Image" class="author-img rounded-circle" />
                            <h4 class="mt-3">Author Profile</h4>
                            <span class="badge bg-info rounded-pill" id="Label2" runat="server">Active</span>
                            <hr />
                        </div>

                        <div class="row mb-3">
                            <div class="col-12">
                                <label class="form-label">Author ID <span class="text-danger">*</span></label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fas fa-id-card"></i></span>
                                    <asp:TextBox CssClass="form-control" ID="TextBox1" runat="server" placeholder="Enter Author ID"></asp:TextBox>
                                    <div class="input-group-btn">
                                        <asp:Button CssClass="btn btn-primary" ID="LinkButton1" runat="server" Text="Go" OnClick="LinkButton1_Click" ValidationGroup="GoValidation" />
                                    </div>
                                </div>
                                <div id="<%=TextBox1.ClientID%>_error" class="validation-error" style="display: none;">
                                    <i class="fas fa-exclamation-circle"></i> Author ID is required
                                </div>
                                <div id="<%=TextBox1.ClientID%>_duplicate" class="duplicate-warning" style="display: none;">
                                    <i class="fas fa-exclamation-triangle"></i> Author ID already exists
                                </div>
                            </div>

                            <div class="col-12 mt-3">
                                <label class="form-label">Author Name <span class="text-danger">*</span></label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fas fa-user"></i></span>
                                    <asp:TextBox CssClass="form-control" ID="TextBox2" runat="server" placeholder="Enter Author Name"></asp:TextBox>
                                </div>
                                <div id="<%=TextBox2.ClientID%>_error" class="validation-error" style="display: none;">
                                    <i class="fas fa-exclamation-circle"></i> Author Name is required
                                </div>
                            </div>
                        </div>

                        <!-- UPDATED BUTTON LAYOUT -->
                        <div class="action-buttons-container">
                            <asp:Button CssClass="btn btn-md btn-primary" ID="Button1" runat="server" Text="Add" OnClick="Button1_Click" ValidationGroup="CRUDValidation" />
                            <asp:Button CssClass="btn btn-md btn-danger" ID="Button2" runat="server" Text="Delete" OnClick="Button2_Click" ValidationGroup="CRUDValidation" />
                            <asp:Button CssClass="btn btn-md btn-warning" ID="Button3" runat="server" Text="Update" OnClick="Button3_Click" ValidationGroup="CRUDValidation" />
                            <asp:Button CssClass="btn btn-md btn-secondary" ID="btnClear" runat="server" Text="Clear" OnClientClick="return false;" />
                        </div>

                        <!-- Validation Summary for Go button -->
                        <asp:ValidationSummary ID="ValidationSummary1" runat="server" CssClass="validation-summary" ValidationGroup="GoValidation" ShowSummary="false" ShowMessageBox="false" />

                        <!-- Validation Summary for Add, Delete, and Update buttons -->
                        <asp:ValidationSummary ID="ValidationSummary2" runat="server" CssClass="validation-summary" ValidationGroup="CRUDValidation" ShowSummary="false" ShowMessageBox="false" />
                    </div>
                </div>
            </div>

            <!-- Right Card -->
            <div class="col-md-7">
                <div class="card">
                    <div class="card-header py-3">
                        <h5 class="m-0 font-weight-bold"><i class="fas fa-table me-2"></i>Author Database</h5>
                    </div>
                    <div class="card-body">
                        <div class="text-center mb-4">
                            <h3>Author Data</h3>
                            <span class="badge bg-info rounded-pill">User Book Status</span>
                            <hr />
                        </div>

                        <div class="row">
                            <asp:SqlDataSource ID="SqlDataSource1" runat="server"
                                ConnectionString="<%$ ConnectionStrings:LibMngDBConnectionString %>"
                                ProviderName="<%$ ConnectionStrings:LibMngDBConnectionString.ProviderName %>"
                                SelectCommand="SELECT * FROM [author_admin_tbl]"></asp:SqlDataSource>
                            <div class="col">
                                <!-- Add ClientIDMode="Static" to make targeting easier -->
                                <asp:GridView CssClass="table table-striped table-bordered author-table" ID="GridView1" runat="server"
                                    AutoGenerateColumns="false" DataKeyNames="author_id" DataSourceID="SqlDataSource1"
                                    HeaderStyle-CssClass="thead-dark" ClientIDMode="Static">
                                    <Columns>
                                        <asp:BoundField DataField="author_id" HeaderText="Author ID" ReadOnly="true" SortExpression="author_id" />
                                        <asp:BoundField DataField="author_name" HeaderText="Author Name" SortExpression="author_name" />
                                        <asp:TemplateField HeaderText="Action" ItemStyle-HorizontalAlign="Center">
                                            <ItemTemplate>
                                                <button type="button" class="btn btn-select select-author" 
                                                    data-id='<%# Eval("author_id") %>' 
                                                    data-name='<%# Eval("author_name") %>'>
                                                    Select
                                                </button>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                    </Columns>
                                </asp:GridView>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="text-center mt-3">
            <a href="Homepage.aspx" class="back-link"><i class="fas fa-arrow-left me-1"></i> Back to Home</a>
        </div>
    </div>
</asp:Content>