<%@ Page Title="" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="AdminPublisherManagement.aspx.cs" Inherits="webapp.AdminPublisherManagement" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
<style>
    /* General Styles */
    .publisher-management-container { padding: 20px 0; }
    .card { box-shadow: 0 0.5rem 1rem rgba(0,0,0,0.15); border-radius: 10px; }
    .card-body { padding: 20px; }
    h3 { font-weight: 700; color: #4e73df; }
    hr { border-top: 2px solid #6f42c1; margin: 10px 0 20px 0; }

    /* Left Card Inputs */
    .form-control { border-radius: 0.35rem; }
    .btn { transition: all 0.2s ease; }
    .btn:hover { transform: translateY(-2px); }

    /* Right Card Table */
    .publisher-table { width: 100%; border-collapse: collapse; }
    .publisher-table th, .publisher-table td { text-align: left; padding: 10px; vertical-align: middle; }
    .publisher-table th { background: linear-gradient(to right, #4e73df, #6f42c1); color: #fff; position: sticky; top: 0; z-index: 10; }
    .publisher-table tbody tr:hover { background-color: rgba(78, 115, 223, 0.05); cursor: pointer; }
    .publisher-table tbody td button { font-size: 0.85rem; }

    /* Scrollable table */
    .table-wrapper { max-height: 500px; overflow-y: auto; margin-bottom: 10px; }

    /* Buttons alignment */
    .action-buttons-container { display: flex; flex-wrap: wrap; justify-content: center; gap: 10px; margin-top: 1rem; }
    .action-buttons-container .btn { flex: 1; min-width: 90px; max-width: 120px; }

    /* Responsive tweaks */
    @media(max-width:992px){
        .col-md-4, .col-md-7 { flex: 0 0 100%; max-width: 100%; }
        .action-buttons-container .btn { flex: 0 0 calc(50% - 10px); max-width: calc(50% - 10px); }
    }
    @media(max-width:576px){
        .action-buttons-container .btn { flex: 0 0 100%; max-width: 100%; }
    }
    #Label2 {
        display: inline-block;
        margin: 0 auto;
        text-align: center;
    }
    .publisher-table td .btn-select {
        display: block;
        margin: 0 auto;
    }
</style>

<script type="text/javascript">
    $(document).ready(function () {
        var gridView = $('#<%=GridView1.ClientID%>');

        // Ensure header is in <thead> for DataTables
        if (gridView.find('thead').length === 0) {
            var firstRow = gridView.find('tr:first');
            if (firstRow.length) {
                $('<thead>').append(firstRow).prependTo(gridView);
            }
        }

        // Initialize DataTable
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
                paginate: { previous: "Previous", next: "Next" }
            },
            columnDefs: [{ targets: -1, orderable: false }] // last column (Select) not sortable
        });

        // Delegated click event for Select button (works with DataTables)
        $('#<%=GridView1.ClientID%>').on('click', '.btn-select', function () {
        var row = $(this).closest('tr');
        var id = row.find('td:eq(0)').text().trim();
        var name = row.find('td:eq(1)').text().trim();
        $('#<%=TextBox1.ClientID%>').val(id);
        $('#<%=TextBox2.ClientID%>').val(name);
        });

        // Button hover animation
        $('.btn').hover(
            function () { $(this).css('transform', 'translateY(-2px)'); },
            function () { $(this).css('transform', 'translateY(0)'); }
        );

    });
</script>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder" runat="server">

<div class="container publisher-management-container">
    <div class="row justify-content-center">
        <!-- Left Card -->
        <div class="col-md-4">
            <div class="card">
                <div class="card-body text-center">
                    <h3>Publisher</h3>
                    <img width="150px" src="imgs/user.png" alt="User Image" class="mb-3"/>
                    <hr />
                    <div class="mb-3">
                        <label>Publisher ID</label>
                        <div class="input-group mb-2">
                            <asp:TextBox CssClass="form-control" ID="TextBox1" runat="server" placeholder="ID"></asp:TextBox>
                            <asp:Button CssClass="btn btn-primary" ID="LinkButton1" runat="server" Text="Go" OnClick="LinkButton1_Click" ValidationGroup="GoValidation" />
                        </div>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="TextBox1" ErrorMessage="Publisher ID is required" CssClass="text-danger" Display="Dynamic" ValidationGroup="GoValidation" />
                    </div>
                    <div class="mb-3">
                        <label>Publisher Name</label>
                        <asp:TextBox CssClass="form-control" ID="TextBox2" runat="server" placeholder="Publisher Name"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="TextBox2" ErrorMessage="Publisher Name is required" CssClass="text-danger" Display="Dynamic" ValidationGroup="CRUDValidation" />
                    </div>
                    <div class="action-buttons-container">
                        <asp:Button CssClass="btn btn-md btn-primary" ID="Button1" runat="server" Text="Add" OnClick="Button1_Click" ValidationGroup="CRUDValidation" />
                        <asp:Button CssClass="btn btn-md btn-danger" ID="Button2" runat="server" Text="Delete" OnClick="Button2_Click" ValidationGroup="CRUDValidation" />
                        <asp:Button CssClass="btn btn-md btn-warning" ID="Button3" runat="server" Text="Update" OnClick="Button3_Click" ValidationGroup="CRUDValidation" />
                    </div>
                    <asp:ValidationSummary ID="ValidationSummary1" runat="server" CssClass="text-danger" ValidationGroup="GoValidation" />
                    <asp:ValidationSummary ID="ValidationSummary2" runat="server" CssClass="text-danger" ValidationGroup="CRUDValidation" />
                </div>
            </div>
        </div>

        <!-- Right Card -->
        <div class="col-md-7">
            <div class="card">
                <div class="card-body">
                    <h3 class="text-center">Publisher Data</h3>
                    <div class="text-center mb-3">
                        <span class="badge bg-info rounded-pill" id="Label2" runat="server">User Book Status</span>
                    </div>
                    <hr />
                    <div class="table-wrapper">
                        <asp:GridView CssClass="publisher-table table table-striped table-bordered" ID="GridView1" runat="server"
                            AutoGenerateColumns="false" DataKeyNames="publisher_id" DataSourceID="SqlDataSource1" ClientIDMode="Static">
                            <Columns>
                                <asp:BoundField DataField="publisher_id" HeaderText="Publisher ID" SortExpression="publisher_id" />
                                <asp:BoundField DataField="publisher_name" HeaderText="Publisher Name" SortExpression="publisher_name" />
                                <asp:TemplateField HeaderText="Action">
                                    <ItemTemplate>
                                        <button type="button" class="btn btn-sm btn-info btn-select">Select</button>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="text-center mt-3">
        <a href="Homepage.aspx"><< Back to Home</a>
    </div>
</div>

<asp:SqlDataSource ID="SqlDataSource1" runat="server"
    ConnectionString="<%$ ConnectionStrings:LibMngDBConnectionString %>"
    ProviderName="<%$ ConnectionStrings:LibMngDBConnectionString.ProviderName %>"
    SelectCommand="SELECT * FROM [publisher_admin_tbl]">
</asp:SqlDataSource>

</asp:Content>