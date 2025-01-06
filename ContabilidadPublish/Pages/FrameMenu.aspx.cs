using System;
using System.Data;
using System.Collections;
using System.Configuration;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using Contabilidad.Entity;
public partial class PageFrameMenu : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        //ucTemplateMenu.DataSource = GetMenuConfig();
        //ucTemplateMenu.CreateMenu();
    }

    //public static DataTable GetMenuConfig() {
    //    return Contabilidad.DataAccess.dac_catMenu.GetInstance().GetMenuConfig(new Entity_catMenu(SEMSession.GetInstance.IdRol));
    //}

    

}
