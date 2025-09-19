//well main project is inside webapp
// and all aspx and it aspx.cs file is fine .
If someone wanna work on this project here is the best thing to do 
1 : Make asp.net wit master page project manually and inside my LinMng copy Site1.Master and its .cs file code in your file and paste.
2 : Make Webform page with master page for all aspx and name it excatly inside my Repo so its match with master page.
3 : Inside all aspx and its .cs file code need to copy and pasted inside in your all aspx and its .cs file which u created manually.
And Last and most important inside Web.config make sure u edit Sql connection setting and inside your aspx and .cs file so that it works with database.
For that U need to create 6 Tables and link with your code inside your table.
Table 1 :
SELECT TOP (1000) [full_name]
      ,[dob]
      ,[contact_no]
      ,[email]
      ,[state]
      ,[city]
      ,[pincode]
      ,[full_address]
      ,[member_id]
      ,[password]
      ,[account_status]
  FROM [LibMngDB].[dbo].[user_admin_tbl]

Table 2 :
SELECT TOP (1000) [publisher_id]
      ,[publisher_name]
  FROM [LibMngDB].[dbo].[publisher_admin_tbl]

Table 3 :
SELECT TOP (1000) [member_id]
      ,[member_name]
      ,[book_id]
      ,[book_name]
      ,[issue_date]
      ,[due_date]
  FROM [LibMngDB].[dbo].[book_issue_tbl]

Table 4 : 
SELECT TOP (1000) [book_id]
      ,[book_name]
      ,[genre]
      ,[author_name]
      ,[publisher_name]
      ,[publish_date]
      ,[language]
      ,[edition]
      ,[book_cost]
      ,[no_of_pages]
      ,[book_discription]
      ,[actual_stock]
      ,[current_stock]
      ,[book_img_link]
  FROM [LibMngDB].[dbo].[book_admin_tbl]

Table 5 :
SELECT TOP (1000) [author_id]
      ,[author_name]
  FROM [LibMngDB].[dbo].[author_admin_tbl]

Table 6 :
SELECT TOP (1000) [username]
      ,[password]
      ,[full_name]
  FROM [LibMngDB].[dbo].[admin_login_tbl]

Here is all table.
Create all 6 tables and if u wanna ,ake more tables good to go.
And establish the connection settings.
