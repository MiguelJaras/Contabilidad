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
using CrystalDecisions.CrystalReports.Engine;
using CrystalDecisions.Shared;
using System.Data.SqlClient;
using System.IO;
using System.Diagnostics;
using Contabilidad.Bussines;
using Contabilidad.Entity;
using System.Text;


public partial class Utils_Txt : System.Web.UI.Page
{
    string Name;
    protected void Page_Load(object sender, EventArgs e)
    {
        bool bSat = false;
        try
        {
            Name = Request.QueryString["name"];
            string qry = Request.QueryString["query"];

            if(Request.QueryString["bSat"] != null)
                bSat = true;

            DataTable dt;
            Contabilidad.Bussines.Menu menu;
            menu = new Contabilidad.Bussines.Menu();

            qry = qry.Replace("-", "'");
            dt = menu.BindGrid(qry).Tables[0];

            Export(dt);
        }
        catch (Exception ex)
        {
            ClientScript.RegisterStartupScript(Page.GetType(), "errTXT", "alert('"+ex.Message+"');", true);
            if(bSat)
                ClientScript.RegisterStartupScript(Page.GetType(), "errClo", "window.close();", true);
        }
    }

    private void Export(DataTable table)
    {
        StringBuilder stringB;
        stringB = new StringBuilder();
       
        HttpContext.Current.Response.Clear();
        HttpContext.Current.Response.ClearContent();
        HttpContext.Current.Response.ClearHeaders();
        HttpContext.Current.Response.Buffer = true;
        HttpContext.Current.Response.ContentType = "text/plain";
        HttpContext.Current.Response.AddHeader("Content-Disposition", "attachment;filename=" + Name + ".txt");
        HttpContext.Current.Response.Charset = "utf-8";
        HttpContext.Current.Response.ContentEncoding = System.Text.Encoding.GetEncoding("windows-1250");



        //Rows
        foreach (DataRow row in table.Rows)        
        {
            stringB.AppendLine(row[0].ToString());            
        }

        HttpContext.Current.Response.Write(stringB.ToString());
        HttpContext.Current.Response.Flush();
        HttpContext.Current.Response.SuppressContent = true;
        HttpContext.Current.Response.End();
    }
   
}
