using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace webapp
{
    public partial class ViewBooks : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                GridView1.DataBind();
            }
            // ✅ Always ensure DataTables sees <thead>
            GridView1.UseAccessibleHeader = true;
            if (GridView1.HeaderRow != null)
            {
                GridView1.HeaderRow.TableSection = TableRowSection.TableHeader;
            }
        }
    }
}