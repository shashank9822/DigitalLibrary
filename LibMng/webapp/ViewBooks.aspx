<%@ Page Title="" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="ViewBooks.aspx.cs" Inherits="webapp.ViewBooks" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <script type="text/javascript">
        // 🔹 Wrap DataTables init into a reusable function
        function initDataTable() {
            if ($.fn.DataTable.isDataTable('#GridView1')) {
                $('#GridView1').DataTable().destroy(); // clear old instance
            }
            $('#GridView1').DataTable({
                pageLength: 5,
                lengthChange: false,
                searching: true,
                ordering: false,
                paging: true,
                language: {
                    search: "Search by Book ID or any book data:",
                    info: "Showing _START_ to _END_ of _TOTAL_ books",
                    infoEmpty: "No books found",
                    infoFiltered: "(filtered from _MAX_ total books)",
                    paginate: {
                        previous: "Previous",
                        next: "Next"
                    }
                }
            });
        }

        $(document).ready(function () {
            initDataTable();

            // 🔹 Re-initialize after each ASP.NET postback (UpdatePanel or full)
            if (typeof Sys !== 'undefined' && Sys.WebForms.PageRequestManager) {
                Sys.WebForms.PageRequestManager.getInstance().add_endRequest(function () {
                    initDataTable();
                });
            }
        });
    </script>

    <style>
        /* Ensure DataTables elements are visible */
        .dataTables_wrapper .dataTables_paginate {
            margin-top: 15px;
            text-align: center;
        }

            .dataTables_wrapper .dataTables_paginate .paginate_button {
                padding: 5px 10px;
                margin: 0 3px;
                border: 1px solid #dee2e6;
                border-radius: 4px;
                cursor: pointer;
            }

                .dataTables_wrapper .dataTables_paginate .paginate_button.current {
                    background: #4e73df;
                    color: white;
                    border-color: #4e73df;
                }

                .dataTables_wrapper .dataTables_paginate .paginate_button:hover {
                    background: #2e59d9;
                    color: white;
                }

        .dataTables_wrapper .dataTables_filter {
            margin-bottom: 15px;
        }

            .dataTables_wrapper .dataTables_filter input {
                border: 1px solid #d1d3e2;
                border-radius: 4px;
                padding: 5px 10px;
            }

        .dataTables_wrapper .dataTables_info {
            margin-top: 15px;
        }
    </style>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder" runat="server">

    <div class="container-fluid">
        <div class="row justify-content-center">
            <div class="col">
                <div class="card">
                    <div class="card-body">
                        <div class="text-center mb-4">
                            <h3>Book Library List</h3>
                            <span class="badge bg-info rounded-pill" id="Label2" runat="server">Book Library</span>
                            <hr />
                        </div>

                        <div class="row">
                            <asp:SqlDataSource ID="SqlDataSource1" runat="server"
                                ConnectionString="<%$ ConnectionStrings:con %>"
                                SelectCommand="SELECT * FROM [book_admin_tbl]"></asp:SqlDataSource>
                            <div class="col">
                                <asp:GridView CssClass="table table-striped table-bordered"
                                    ID="GridView1" runat="server"
                                    AutoGenerateColumns="False"
                                    DataKeyNames="book_id"
                                    DataSourceID="SqlDataSource1"
                                    HeaderStyle-CssClass="thead-dark"
                                    ClientIDMode="Static"
                                    UseAccessibleHeader="true"
                                    GridLines="None"
                                    ShowHeaderWhenEmpty="true">

                                    <Columns>
                                        <asp:BoundField DataField="book_id" HeaderText="ID" ReadOnly="True" />

                                        <asp:TemplateField HeaderText="BOOK LIBRARY">
                                            <ItemTemplate>
                                                <!-- your card layout stays here, comments are allowed inside -->
                                                <div class="container-fluid">
                                                    <!-- ✅ Safe to use comments here -->
                                                    <div class="row">
                                                        <div class="col-lg-10">
                                                            <div class="row">
                                                                <div class="col-lg-12">
                                                                    <asp:Label ID="Label1" runat="server"
                                                                        Text='<%# Eval("book_name") %>'
                                                                        Font-Bold="True" Font-Size="X-Large"></asp:Label>
                                                                </div>
                                                            </div>
                                                            <div class="row">
                                                                <div class="col-lg-12">
                                                                    Author -
                <asp:Label ID="Label3" runat="server" Font-Bold="True"
                    Text='<%# Eval("author_name") %>'></asp:Label>
                                                                    &nbsp;| Genre -
                <asp:Label ID="Label5" runat="server" Font-Bold="True"
                    Text='<%# Eval("genre") %>'></asp:Label>
                                                                    &nbsp;| Language -
                <asp:Label ID="Label6" runat="server"
                    Text='<%# Eval("language") %>'></asp:Label>
                                                                </div>
                                                            </div>
                                                            <div class="row">
                                                                <div class="col-lg-12">
                                                                    Publisher -
                <asp:Label ID="Label7" runat="server" Font-Bold="True"
                    Text='<%# Eval("publisher_name") %>'></asp:Label>
                                                                    &nbsp;| Publish Date -
                <asp:Label ID="Label8" runat="server" Font-Bold="True"
                    Text='<%# Eval("publish_date") %>'></asp:Label>
                                                                    &nbsp;| Pages -
                <asp:Label ID="Label9" runat="server" Font-Bold="True"
                    Text='<%# Eval("no_of_pages") %>'></asp:Label>
                                                                    &nbsp;| Edition -
                <asp:Label ID="Label10" runat="server" Font-Bold="True"
                    Text='<%# Eval("edition") %>'></asp:Label>
                                                                </div>
                                                            </div>
                                                            <div class="row">
                                                                <div class="col-lg-12">
                                                                    Cost -
                <asp:Label ID="Label11" runat="server" Font-Bold="True"
                    Text='<%# Eval("book_cost") %>'></asp:Label>
                                                                    &nbsp;| Stocks -
                <asp:Label ID="Label12" runat="server" Font-Bold="True"
                    Text='<%# Eval("actual_stock") %>'></asp:Label>
                                                                    &nbsp;| Available -
                <asp:Label ID="Label13" runat="server" Font-Bold="True"
                    Text='<%# Eval("current_stock") %>'></asp:Label>
                                                                </div>
                                                            </div>
                                                            <div class="row">
                                                                <div class="col-lg-12">
                                                                    Description :
                <asp:Label ID="Label14" runat="server" Font-Bold="True"
                    Text='<%# Eval("book_discription") %>'></asp:Label>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div class="col-lg-2">
                                                            <asp:Image CssClass="img-fluid" ID="Image1" runat="server"
                                                                ImageUrl='<%# Eval("book_img_link") %>' />
                                                        </div>
                                                    </div>
                                                </div>
                                            </ItemTemplate>
                                        </asp:TemplateField>

                                        <asp:BoundField DataField="book_name" HeaderText="Book Name" Visible="false" />
                                        <asp:BoundField DataField="author_name" HeaderText="Author" Visible="false" />
                                        <asp:BoundField DataField="genre" HeaderText="Genre" Visible="false" />
                                        <asp:BoundField DataField="language" HeaderText="Language" Visible="false" />
                                        <asp:BoundField DataField="publisher_name" HeaderText="Publisher" Visible="false" />
                                        <asp:BoundField DataField="publish_date" HeaderText="Publish Date" Visible="false" />
                                        <asp:BoundField DataField="no_of_pages" HeaderText="Pages" Visible="false" />
                                        <asp:BoundField DataField="edition" HeaderText="Edition" Visible="false" />
                                        <asp:BoundField DataField="book_cost" HeaderText="Cost" Visible="false" />
                                        <asp:BoundField DataField="actual_stock" HeaderText="Stocks" Visible="false" />
                                        <asp:BoundField DataField="current_stock" HeaderText="Available" Visible="false" />
                                        <asp:BoundField DataField="book_discription" HeaderText="Description" Visible="false" />
                                        <asp:BoundField DataField="book_img_link" HeaderText="Image" Visible="false" />
                                    </Columns>

                                </asp:GridView>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="text-center mt-3">
            <a href="Homepage.aspx">&laquo; Back to Home</a>
        </div>

    </div>

</asp:Content>
