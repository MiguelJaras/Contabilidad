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

public partial class pdf : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        string Fname = "";
        Fname = Session["FileName"].ToString();
        Response.ClearContent();
        Response.ClearHeaders();
        int position = Fname.LastIndexOf(".");
        string sub = Fname.Substring(position + 1);
        if(sub == "doc")
            Response.ContentType = "application/msword";
        else
            Response.ContentType = "application/pdf";
        Response.WriteFile(Fname);
        Response.Flush();       
        Response.Close();

        System.IO.File.Delete(Fname);
    }
}
