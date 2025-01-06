using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;


public partial class PageHeader : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        
    }

    public static void SignOut() 
    {

        HttpContext.Current.Session.Abandon();
        FormsAuthentication.SignOut();
        HttpContext.Current.Response.Redirect(FormsAuthentication.LoginUrl);
    }

}
