using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using Contabilidad.Bussines;
using Contabilidad.Entity;

public partial class Report_Pages_Base : MasterPage
{
    public event HandlerEvent PageEvent;
    public string realPath;

    protected void Page_Load(object sender, EventArgs e)
    {
        string end = (Request.ApplicationPath.EndsWith("/")) ? "" : "/";
        string path = Request.ApplicationPath + end;


        realPath = String.Format("http://{0}{1}{2}", Request.Url.Authority, path, "Img/bg_btn.png");
    }

    public bool Check()
    {
        bool value = false;
        
        if (chkExcel.Checked)
            value = true;

        if (chkOpenOficce.Checked)
            value = true;

        return value;
    }
 
}
