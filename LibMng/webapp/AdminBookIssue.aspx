<%@ Page Title="" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="AdminBookIssue.aspx.cs" Inherits="webapp.adminbookissue" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        /* AdminAuthorManagement color scheme and styles */
        .book-issue-container {
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
        
        /* Custom table styles */
        .book-table {
            border-collapse: separate;
            border-spacing: 0;
            width: 100% !important;
            table-layout: auto;
        }
        
        .book-table thead th {
            position: sticky;
            top: 0;
            background-color: #4e73df;
            color: white;
            z-index: 10;
            padding: 12px 8px;
            white-space: nowrap;
        }
        
        .book-table tbody td {
            padding: 10px 8px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            max-width: 200px;
        }
        
        .book-table tbody tr {
            transition: background-color 0.3s;
        }
        
        .book-table tbody tr:hover {
            background-color: rgba(78, 115, 223, 0.05);
        }
        
        /* Validation styles */
        .validation-error {
            color: #e74a3b;
            font-size: 0.875rem;
            margin-top: 0.25rem;
            display: block;
        }
        
        .is-invalid {
            border-color: #e74a3b !important;
        }
        
        /* Input group styling */
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
            min-width: 45px;
            justify-content: center;
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
        
        /* Message styles */
        .message-label {
            font-weight: bold;
            padding: 8px 12px;
            border-radius: 5px;
            display: inline-block;
            margin-bottom: 1rem;
        }
        
        .success {
            color: #155724;
            background-color: #d4edda;
            border: 1px solid #c3e6cb;
        }
        
        .error {
            color: #721c24;
            background-color: #f8d7da;
            border: 1px solid #f5c6cb;
        }
        
        /* Overdue book styling */
        .overdue-row {
            background-color: #f8d7da !important;
            color: #721c24;
        }
        
        /* Action button styles */
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
        
        /* Grid container for better spacing */
        .grid-container {
            overflow-x: auto;
            width: 100%;
        }
        
        /* Ensure single line in gridview */
        .grid-view-single-line td {
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            max-width: 200px;
        }
        
        /* Responsive design */
        @media (max-width: 992px) {
            .book-issue-container .row {
                flex-direction: column;
            }
            
            .book-issue-container .col-lg-4,
            .book-issue-container .col-lg-8 {
                max-width: 100%;
                flex: 0 0 100%;
            }
            
            .book-issue-container .col-lg-8 {
                margin-top: 1.5rem;
            }
            
            .book-table thead th,
            .book-table tbody td {
                padding: 8px 6px;
                font-size: 0.9rem;
            }
        }
        
        @media (max-width: 768px) {
            .book-table thead th,
            .book-table tbody td {
                padding: 6px 4px;
                font-size: 0.85rem;
            }
            
            .input-group-text {
                min-width: 40px;
                padding: 0.5rem;
            }
        }
    </style>

    <script type="text/javascript">
        function initializeDataTable() {
            var gridView = $('#<%=GridView1.ClientID%>');
            
            // Destroy existing DataTable if it exists
            if ($.fn.DataTable.isDataTable(gridView)) {
                gridView.DataTable().destroy();
                gridView.css('width', ''); // Reset width
            }

            // Fix GridView structure for DataTables
            if (gridView.find('thead').length === 0) {
                var headerRow = gridView.find('tr:first');
                if (headerRow.length) {
                    $('<thead>').append(headerRow.clone()).prependTo(gridView);
                    headerRow.remove();
                }
            }

            // Initialize DataTable with adjusted column widths
            gridView.DataTable({
                responsive: true,
                pageLength: 5,
                lengthMenu: [5, 10, 25, 50],
                ordering: true,
                searching: true,
                stateSave: true,
                autoWidth: false,
                scrollX: true,
                columnDefs: [
                    { width: "120px", targets: 0 }, // Member ID
                    { width: "150px", targets: 1 }, // Member Name
                    { width: "120px", targets: 2 }, // Book ID
                    { width: "200px", targets: 3 }, // Book Name
                    { width: "120px", targets: 4 }, // Issue Date
                    { width: "120px", targets: 5 }  // Due Date
                ],
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
        }

        function fadeOutMessage() {
            var msg = document.getElementById('<%= lblMessage.ClientID %>');
            if (msg && msg.innerText.trim() !== "") {
                setTimeout(function () {
                    msg.style.transition = "opacity 1s ease";
                    msg.style.opacity = "0";
                }, 3000);
            }
        }

        // Clear form fields function
        function clearFormFields() {
            $('#<%=TextBox1.ClientID%>').val('');
            $('#<%=TextBox2.ClientID%>').val('');
            $('#<%=TextBox3.ClientID%>').val('');
            $('#<%=TextBox4.ClientID%>').val('');
            
            // Set dates to empty and then to defaults
            $('#<%=TextBox5.ClientID%>').val('');
            $('#<%=TextBox6.ClientID%>').val('');
            
            // After a brief delay, set default dates
            setTimeout(function() {
                var today = new Date().toISOString().split('T')[0];
                var dueDate = new Date();
                dueDate.setDate(dueDate.getDate() + 14);
                
                $('#<%=TextBox5.ClientID%>').val(today);
                $('#<%=TextBox6.ClientID%>').val(dueDate.toISOString().split('T')[0]);
            }, 100);
        }

        // Initialize on document ready
        jQuery(document).ready(function ($) {
            fadeOutMessage();
            initializeDataTable();

            // Set default dates
            var today = new Date().toISOString().split('T')[0];
            var dueDate = new Date();
            dueDate.setDate(dueDate.getDate() + 14);
            
            $('#<%=TextBox5.ClientID%>').val(today);
            $('#<%=TextBox6.ClientID%>').val(dueDate.toISOString().split('T')[0]);

            // Clear button click handler
            $('#<%=btnClear.ClientID%>').click(function() {
                clearFormFields();
                return false; // Prevent postback for client-side clearing
            });
        });

        // Handle UpdatePanel postbacks
        var prm = Sys.WebForms.PageRequestManager.getInstance();
        prm.add_endRequest(function () {
            fadeOutMessage();
            initializeDataTable();
        });
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder" runat="server">

<asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>

<div class="container book-issue-container">
    <div class="row justify-content-center g-4">
        
        <!-- Left Card - Book Issue Form -->
        <div class="col-lg-4 col-md-6">
            <div class="card">
                <div class="card-header py-3">
                    <h5 class="m-0 font-weight-bold"><i class="fas fa-book-open me-2"></i>Book Issue Management</h5>
                </div>
                <div class="card-body">
                    <div class="text-center mb-4">
                        <!-- Fixed image path -->
                        <img width="150px" src="/imgs/book-issue.png" alt="Book Issue" class="author-img rounded-circle" 
                             onerror="this.src='data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMTUwIiBoZWlnaHQ9IjE1MCIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj48cmVjdCB3aWR0aD0iMTUwIiBoZWlnaHQ9IjE1MCIgZmlsbD0iI2U5ZWNlZiIgcng9Ijc1Ii8+PGcgZmlsbD0iIzRlNzNkZiI+PGNpcmNsZSBjeD0iNzUiIGN5PSI2MCIgcj0iMTUiLz48cGF0aCBkPSJNNDUgMTIwIEM0NSA5MCAxMDUgOTAgMTA1IDEyMCBDMTA1IDEzNSA5NSAxNTAgNzUgMTUwIEM1NSAxNTAgNDUgMTM1IDQ1IDEyMCBaIi8+PC9nPjwvc3ZnPg=='" />
                        <h4 class="mt-3">Book Issue</h4>
                        <span class="badge bg-info rounded-pill">Active System</span>
                        <hr />
                    </div>

                    <!-- Row 1: Member ID & Book ID -->
                    <div class="row mb-3">
                        <div class="col-12">
                            <label class="form-label">Member ID <span class="text-danger">*</span></label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="fas fa-user"></i></span>
                                <asp:TextBox CssClass="form-control" ID="TextBox2" runat="server" placeholder="Enter Member ID"></asp:TextBox>
                            </div>
                        </div>
                    </div>

                    <div class="row mb-3">
                        <div class="col-12">
                            <label class="form-label">Book ID <span class="text-danger">*</span></label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="fas fa-book"></i></span>
                                <asp:TextBox CssClass="form-control" ID="TextBox1" runat="server" placeholder="Enter Book ID"></asp:TextBox>
                                <div class="input-group-btn">
                                    <asp:Button CssClass="btn btn-primary" ID="LinkButton1" runat="server" Text="Go" OnClick="LinkButton1_Click" />
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Row 2: Member Name & Book Name -->
                    <div class="row mb-3">
                        <div class="col-12">
                            <label class="form-label">Member Name</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="fas fa-user-tag"></i></span>
                                <asp:TextBox CssClass="form-control" ID="TextBox3" runat="server" ReadOnly="True" placeholder="Member Name"></asp:TextBox>
                            </div>
                        </div>
                    </div>

                    <div class="row mb-3">
                        <div class="col-12">
                            <label class="form-label">Book Name</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="fas fa-bookmark"></i></span>
                                <asp:TextBox CssClass="form-control" ID="TextBox4" runat="server" ReadOnly="True" placeholder="Book Name"></asp:TextBox>
                            </div>
                        </div>
                    </div>

                    <!-- Row 3: Issue Date & Due Date -->
                    <div class="row mb-3">
                        <div class="col-12">
                            <label class="form-label">Issue Date</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="fas fa-calendar-plus"></i></span>
                                <asp:TextBox CssClass="form-control" ID="TextBox5" runat="server" TextMode="Date" placeholder="Issue Date"></asp:TextBox>
                            </div>
                        </div>
                    </div>

                    <div class="row mb-4">
                        <div class="col-12">
                            <label class="form-label">Due Date</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="fas fa-calendar-check"></i></span>
                                <asp:TextBox CssClass="form-control" ID="TextBox6" runat="server" TextMode="Date" placeholder="Due Date"></asp:TextBox>
                            </div>
                        </div>
                    </div>

                    <!-- Message Label -->
                    <asp:Label ID="lblMessage" runat="server" CssClass="message-label"></asp:Label>

                    <!-- Action Buttons -->
                    <div class="action-buttons-container">
                        <asp:Button CssClass="btn btn-md btn-primary" ID="Button1" runat="server" Text="Issue" OnClick="Button1_Click" />
                        <asp:Button CssClass="btn btn-md btn-danger" ID="Button2" runat="server" Text="Return" OnClick="Button2_Click" />
                        <asp:Button CssClass="btn btn-md btn-secondary" ID="btnClear" runat="server" Text="Clear" OnClick="btnClear_Click" />
                    </div>
                </div>
            </div>
        </div>

        <!-- Right Card - Issued Books List (Wider column) -->
        <div class="col-lg-8 col-md-6">
            <div class="card">
                <div class="card-header py-3">
                    <h5 class="m-0 font-weight-bold"><i class="fas fa-table me-2"></i>Issued Books Database</h5>
                </div>
                <div class="card-body">
                    <div class="text-center mb-4">
                        <h3>Issued Books Data</h3>
                        <span class="badge bg-info rounded-pill">Total Issues: <asp:Label ID="lblTotalIssues" runat="server" Text="0"></asp:Label></span>
                        <hr />
                    </div>

                    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                        <ContentTemplate>
                            <asp:SqlDataSource ID="SqlDataSource1" runat="server" 
                                ConnectionString='<%$ ConnectionStrings:LibMngDBConnectionString %>' 
                                SelectCommand="SELECT member_id, member_name, book_id, book_name, issue_date, due_date FROM book_issue_tbl ORDER BY issue_date DESC">
                            </asp:SqlDataSource>
                            
                            <div class="grid-container">
                                <asp:GridView
                                    ID="GridView1"
                                    runat="server"
                                    CssClass="table table-striped table-bordered book-table grid-view-single-line"
                                    AutoGenerateColumns="False"
                                    DataSourceID="SqlDataSource1"
                                    DataKeyNames="book_id,member_id"
                                    ShowHeader="true"
                                    GridLines="None"
                                    OnDataBound="GridView1_DataBound"
                                    EmptyDataText="No books issued yet"
                                    UseAccessibleHeader="true"
                                    OnRowDataBound="GridView1_RowDataBound"
                                    ClientIDMode="Static">
                                    <Columns>
                                        <asp:BoundField DataField="member_id" HeaderText="Member ID" />
                                        <asp:BoundField DataField="member_name" HeaderText="Member Name" />
                                        <asp:BoundField DataField="book_id" HeaderText="Book ID" />
                                        <asp:BoundField DataField="book_name" HeaderText="Book Name" />
                                        <asp:BoundField DataField="issue_date" HeaderText="Issue Date" DataFormatString="{0:MMM dd, yyyy}" HtmlEncode="false" />
                                        <asp:BoundField DataField="due_date" HeaderText="Due Date" DataFormatString="{0:MMM dd, yyyy}" HtmlEncode="false" />
                                    </Columns>
                                    <EmptyDataTemplate>
                                        <div class="text-center py-4">
                                            <i class="fas fa-book-open fa-3x text-muted mb-3"></i>
                                            <p class="text-muted">No books have been issued yet</p>
                                        </div>
                                    </EmptyDataTemplate>
                                </asp:GridView>
                            </div>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </div>
            </div>
        </div>
    </div>

    <!-- Back Link -->
    <div class="text-center mt-3">
        <a href="Homepage.aspx" class="back-link"><i class="fas fa-arrow-left me-1"></i> Back to Home</a>
    </div>
</div>

</asp:Content>