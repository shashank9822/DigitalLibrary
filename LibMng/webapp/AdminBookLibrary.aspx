<%@ Page Title="" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="AdminBookLibrary.aspx.cs" Inherits="webapp.AdminBookLibrary" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <script type="text/javascript"> 
        // 🔹 Wrap DataTables init into a reusable function
        function initDataTable() {
            if ($.fn.DataTable.isDataTable('#GridView1')) {
                $('#GridView1').DataTable().destroy(); // clear old instance
            }
            $('#GridView1').DataTable({
                pageLength: 3,
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

        // ... rest of your existing JavaScript functions ...
        function readURL(input) {
            if (input.files && input.files[0]) {
                var reader = new FileReader();

                reader.onload = function (e) {
                    var imgElement = document.getElementById('<%= imgview.ClientID %>');
                if (imgElement) {
                    imgElement.src = e.target.result;
                }

                document.getElementById('<%= hfImageSource.ClientID %>').value = e.target.result;
                document.getElementById('<%= hfImageType.ClientID %>').value = 'file';

                    console.log('File uploaded:', e.target.result);
                };
                reader.readAsDataURL(input.files[0]);
            }
        }

    function useImageUrl() {
            const urlInput = document.getElementById('<%= txtImageUrl.ClientID %>');
        const url = urlInput.value.trim();

        if (url) {
            var imgElement = document.getElementById('<%= imgview.ClientID %>');
            if (imgElement) {
                imgElement.src = url;
            }

            document.getElementById('<%= hfImageSource.ClientID %>').value = url;
            document.getElementById('<%= hfImageType.ClientID %>').value = 'url';

            console.log('URL set:', url);

            addToUrlHistory(url);

            urlInput.value = '';
        } else {
            alert('Please enter an image URL.');
        }
        return false;
    }

    function useThisUrl(url) {
        var imgElement = document.getElementById('<%= imgview.ClientID %>');
        if (imgElement) {
            imgElement.src = url;
        }

        document.getElementById('<%= hfImageSource.ClientID %>').value = url;
        document.getElementById('<%= hfImageType.ClientID %>').value = 'url';

        console.log('URL from history:', url);

        document.querySelectorAll('.option-tab').forEach(t => {
            t.classList.remove('active');
            if (t.getAttribute('data-option') === 'url') {
                t.classList.add('active');
            }
        });

        document.querySelectorAll('.option-content').forEach(content => {
            content.classList.remove('active');
            if (content.id === 'url-option') {
                content.classList.add('active');
            }
        });

        document.getElementById('<%= txtImageUrl.ClientID %>').value = url;
    }

    function addToUrlHistory(url) {
      const urlList = document.getElementById('urlList');
      const urlItem = document.createElement('div');
      urlItem.className = 'url-item';
      urlItem.innerHTML = `
        <div class="url-text">${url}</div>
        <div class="url-actions">
            <button class="url-action-btn" title="Use this URL" onclick="useThisUrl('${url.replace(/'/g, "\\'")}')">
                 <i class="fas fa-check"></i>
            </button>
        </div>
      `;
      urlList.insertBefore(urlItem, urlList.firstChild);
    }

    function setFileInputValue(filePath) {
        document.getElementById('filePathDisplay').innerText = 'Current file: ' + filePath;
    }

        function clearFileInputDisplay() {
            document.getElementById('filePathDisplay').innerText = '';
        }

        document.addEventListener('DOMContentLoaded', function () {
            document.querySelectorAll('.option-tab').forEach(tab => {
                tab.addEventListener('click', function () {
                    document.querySelectorAll('.option-tab').forEach(t => {
                        t.classList.remove('active');
                    });
                    this.classList.add('active');

                    document.querySelectorAll('.option-content').forEach(content => {
                        content.classList.remove('active');
                    });

                    const option = this.getAttribute('data-option');
                    document.getElementById(`${option}-option`).classList.add('active');
                });
            });
        });    
  </script>


    <style>
        .img-wrapper {
            height: 150px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 15px auto;
        }
        /* Add this to your existing style section */
        .button-hidden {
            display: none;
        }

        .button-visible {
            display: inline-block;
        }

        #<%= imgview.ClientID %> {
            height: 150px;
            width: auto;
            max-width: 100%;
            object-fit: contain;
        }

        .upload-options {
            display: flex;
            gap: 10px;
            margin-bottom: 15px;
        }

        .option-tab {
            padding: 8px 15px;
            border-radius: 5px;
            background: #e9ecef;
            cursor: pointer;
            transition: all 0.3s;
            font-size: 14px;
        }

            .option-tab.active {
                background: #3498db;
                color: white;
            }

        .option-content {
            display: none;
        }

            .option-content.active {
                display: block;
            }

        .url-input-group {
            display: flex;
            gap: 10px;
        }

            .url-input-group input {
                flex: 1;
            }

        .url-history {
            margin-top: 15px;
            padding: 15px;
            border: 1px solid #dee2e6;
            border-radius: 8px;
            background: #f8f9fa;
        }

        .url-item {
            display: flex;
            justify-content: space-between;
            padding: 8px;
            border-bottom: 1px solid #e9ecef;
            font-size: 14px;
        }

            .url-item:last-child {
                border-bottom: none;
            }

        .url-text {
            flex: 1;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
            margin-right: 10px;
        }

        .url-actions {
            display: flex;
            gap: 5px;
        }

        .url-action-btn {
            background: none;
            border: none;
            cursor: pointer;
            color: #6c757d;
            transition: all 0.3s;
            font-size: 13px;
        }

            .url-action-btn:hover {
                color: #3498db;
            }

        .file-path-display {
            margin-top: 10px;
            padding: 8px;
            background: #f8f9fa;
            border: 1px solid #dee2e6;
            border-radius: 4px;
            font-size: 14px;
            color: #495057;
        }

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
            <!-- Left Card -->
            <div class="col-md-5">
                <div class="card">
                    <div class="card-body">
                        <div class="text-center mb-4">
                            <h3>Book Issue</h3>
                            <div class="img-wrapper">
                                <asp:Image ID="imgview" CssClass="img-fluid" Height="160px" runat="server" ImageUrl="~/bookimgs/library.png" alt="Book Cover Preview" />
                            </div>
                            <hr />

                            <asp:HiddenField ID="hfImageSource" runat="server" Value="~/bookimgs/library.png" />
                            <asp:HiddenField ID="hfImageType" runat="server" Value="file" />
                        </div>

                        <div class="upload-options">
                            <div class="option-tab active" data-option="file">
                                <i class="fas fa-upload me-1"></i>Upload File
                            </div>
                            <div class="option-tab" data-option="url">
                                <i class="fas fa-link me-1"></i>Use URL
                            </div>
                        </div>

                        <div class="option-content active" id="file-option">
                            <div class="row">
                                <div class="col">
                                    <asp:FileUpload onchange="readURL(this);" CssClass="form-control" ID="FileUpload1" runat="server" />
                                    <div id="filePathDisplay" class="file-path-display"></div>
                                </div>
                            </div>
                        </div>

                        <div class="option-content" id="url-option">
                            <div class="url-input-group">
                                <asp:TextBox CssClass="form-control" ID="txtImageUrl" runat="server" placeholder="Enter image URL"></asp:TextBox>
                                <asp:Button CssClass="btn btn-primary" ID="btnUseUrl" runat="server" Text="Use URL" OnClientClick="useImageUrl(); return false;" />
                            </div>
                            <div class="instructions">
                                <small class="text-muted">Enter a direct URL to an image file</small>
                            </div>

                            <div class="url-history">
                                <h6><i class="fas fa-history me-1"></i>Recent Image URLs</h6>
                                <div id="urlList">
                                    <div class="url-item">
                                        <div class="url-text">https://example.com/books/book1.jpg</div>
                                        <div class="url-actions">
                                            <button class="url-action-btn" title="Use this URL" onclick="useThisUrl('https://example.com/books/book1.jpg')">
                                                <i class="fas fa-check"></i>
                                            </button>
                                        </div>
                                    </div>
                                    <div class="url-item">
                                        <div class="url-text">https://example.com/books/book2.png</div>
                                        <div class="url-actions">
                                            <button class="url-action-btn" title="Use this URL" onclick="useThisUrl('https://example.com/books/book2.png')">
                                                <i class="fas fa-check"></i>
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Member Info -->
                        <div class="row mb-3 mt-4">
                            <div class="col-md-3">
                                <label>Book ID</label>
                                <div class="input-group">
                                    <asp:TextBox CssClass="form-control" ID="TextBox1" runat="server" placeholder="Book ID"></asp:TextBox>
                                    <asp:Button CssClass="btn btn-block btn-primary" ID="GoButton" runat="server" Text="Go" OnClick="GoButton_Click" />
                                </div>
                            </div>
                            <div class="col-md-9">
                                <label>Book Names</label>
                                <asp:TextBox CssClass="form-control" ID="TextBox2" runat="server" placeholder="Book Name"></asp:TextBox>
                            </div>
                        </div>


                        <!-- Contact Info -->
                        <div class="row mb-3">
                            <div class="col-md-4">
                                <!-- Language Dropdown -->
                                <label for="languageDropdown" class="form-label">Language</label>
                                <asp:DropDownList ID="languageDropdown" runat="server" CssClass="form-select">
                                    <asp:ListItem Text="Hindi" Value="Hindi"></asp:ListItem>
                                    <asp:ListItem Text="Sanskrit" Value="Sanskrit"></asp:ListItem>
                                    <asp:ListItem Text="Telgue" Value="Telgue"></asp:ListItem>
                                    <asp:ListItem Text="Tamil" Value="Tamil"></asp:ListItem>
                                </asp:DropDownList>

                                <!-- Publisher Dropdown -->
                                <label for="publisherDropdown" class="form-label">Publisher</label>
                                <asp:DropDownList ID="publisherDropdown" runat="server" CssClass="form-select">
                                    <asp:ListItem Text="Publisher 1" Value="Publisher 1"></asp:ListItem>
                                    <asp:ListItem Text="Publisher 2" Value="Publisher 2"></asp:ListItem>
                                </asp:DropDownList>
                            </div>

                            <div class="col-md-4">
                                <!-- Author Dropdown -->
                                <label for="authorDropdown" class="form-label">Author</label>
                                <asp:DropDownList ID="authorDropdown" runat="server" CssClass="form-select">
                                    <asp:ListItem Text="A 1" Value="A 1"></asp:ListItem>
                                    <asp:ListItem Text="A 2" Value="A 2"></asp:ListItem>
                                </asp:DropDownList>

                                <!-- Publish Date -->
                                <label for="TextBox3" class="form-label">Publish Date</label>
                                <asp:TextBox CssClass="form-control" ID="TextBox3" runat="server" TextMode="Date"></asp:TextBox>
                            </div>

                            <div class="col-md-4">
                                <label for="genreListBox" class="form-label">Genre</label>
                                <asp:ListBox ID="genreListBox" runat="server" CssClass="form-select" SelectionMode="Multiple">
                                    <asp:ListItem Text="Action" Value="Action"></asp:ListItem>
                                    <asp:ListItem Text="Adventure" Value="Adventure"></asp:ListItem>
                                    <asp:ListItem Text="Comedy" Value="Comedy"></asp:ListItem>
                                    <asp:ListItem Text="Drama" Value="Drama"></asp:ListItem>
                                    <asp:ListItem Text="Fantasy" Value="Fantasy"></asp:ListItem>
                                    <asp:ListItem Text="Horror" Value="Horror"></asp:ListItem>
                                    <asp:ListItem Text="Mystery" Value="Mystery"></asp:ListItem>
                                    <asp:ListItem Text="Romance" Value="Romance"></asp:ListItem>
                                    <asp:ListItem Text="Sci-Fi" Value="Sci-Fi"></asp:ListItem>
                                    <asp:ListItem Text="Thriller" Value="Thriller"></asp:ListItem>
                                    <asp:ListItem Text="Documentary" Value="Documentary"></asp:ListItem>
                                    <asp:ListItem Text="Biography" Value="Biography"></asp:ListItem>
                                    <asp:ListItem Text="Musical" Value="Musical"></asp:ListItem>
                                </asp:ListBox>
                            </div>

                        </div>

                        <!-- Address Info -->
                        <div class="row mb-3">
                            <div class="col-md-4">
                                <label>Edition</label>
                                <asp:TextBox CssClass="form-control" ID="TextBox7" runat="server" placeholder="Edition"></asp:TextBox>
                            </div>
                            <div class="col-md-4">
                                <label>Book Cost(per unit)</label>
                                <asp:TextBox CssClass="form-control" ID="TextBox8" runat="server" placeholder="Unit/Cost" TextMode="Number"></asp:TextBox>
                            </div>
                            <div class="col-md-4">
                                <label>Pages</label>
                                <asp:TextBox CssClass="form-control" ID="TextBox9" runat="server" placeholder="PinCode" TextMode="Number"></asp:TextBox>
                            </div>
                        </div>

                        <!-- Complete Address -->
                        <div class="row mb-3">
                            <div class="col-md-4">
                                <label>Actual Stock</label>
                                <asp:TextBox CssClass="form-control" ID="TextBox4" runat="server" placeholder="Edition" TextMode="Number"></asp:TextBox>
                            </div>
                            <div class="col-md-4">
                                <label>Current Stock</label>
                                <asp:TextBox CssClass="form-control" ID="TextBox5" runat="server" TextMode="Number" ReadOnly="True"></asp:TextBox>
                            </div>
                            <div class="col-md-4">
                                <label>Issue Books</label>
                                <asp:TextBox CssClass="form-control" ID="TextBox6" runat="server" TextMode="Number" ReadOnly="True"></asp:TextBox>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label>Book Description</label>
                            <asp:TextBox
                                CssClass="form-control"
                                ID="desc"
                                runat="server"
                                TextMode="MultiLine"
                                Rows="3"
                                Style="height: auto; max-height: 100px; overflow-y: auto;" />
                        </div>
                        <!-- Update the button section -->
                        <div class="row justify-content-end">
                            <div class="col-auto">
                                <asp:Button CssClass="btn btn-md btn-success button-visible" ID="Button2" runat="server" Text="Add" OnClick="Button2_Click" />
                                <asp:Button CssClass="btn btn-md btn-primary button-hidden" ID="Button1" runat="server" Text="Update" OnClick="Button1_Click" />
                                <asp:Button CssClass="btn btn-md btn-danger button-hidden" ID="Button3" runat="server" Text="Delete" OnClick="Button3_Click" />
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Right Card -->
            <div class="col-md-7">
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

        <!-- Back to Home Link -->
        <div class="text-center mt-3">
            <a href="Homepage.aspx"><< Back to Home</a>
        </div>
    </div>

</asp:Content>
