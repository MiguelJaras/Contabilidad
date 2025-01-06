using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

    public partial class _Default : System.Web.UI.Page
    {
        PagePortal template;
        protected void Page_Load(object sender, EventArgs e)
        {
            template = (PagePortal)this.Master;

            if (!Page.IsPostBack)
            {
                template.ShowDetail(false);
                template.ShowList(false);
                template.ShowFilter(false);                
            }
        }
    }

