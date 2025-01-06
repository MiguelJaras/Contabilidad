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
using System.Data.SqlClient;
using System.IO;
using System.Diagnostics;
using System.Drawing.Printing;
using System.Drawing;
using Contabilidad.Bussines;
using CrystalDecisions.CrystalReports.Engine;
using CrystalDecisions.Shared;

public partial class Utils_PDFF : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        string Fname = "", strEmpresa = "", pathServer = "";
        Fname = Request.QueryString["FileName"];
        strEmpresa = Request.QueryString["empresa"];
        if (strEmpresa == "3")
            pathServer = "\\\\Marfil-nas\\sem\\Contabilidad\\Facturas"; //"\\\\EFISCALES\\Compacw\\Empresas\\MAPLE URBANIZADORA,\\XML_SDK";
        else if (strEmpresa == "4")
            pathServer = "\\\\Marfil-nas\\sem\\Contabilidad\\Facturas\\4"; //"\\\\EFISCALES\\Compacw\\Empresas\\RGE PROPIEDADES, S.A\\XML_SDK";

        pathServer = pathServer + "\\" + Fname;
        MemoryStream ms = new MemoryStream(File.ReadAllBytes(pathServer));

        Anthem.Manager.Register(this);
        Context.Response.Buffer = false;
        FileStream inStr = null;
        byte[] buffer = new byte[1024];

        long byteCount; inStr = File.OpenRead(pathServer);
        int tipo = Fname.IndexOf("xml");
        if (tipo > 0)
        {
            while ((byteCount = inStr.Read(buffer, 0, buffer.Length)) > 0)
            {
                if (Context.Response.IsClientConnected)
                {
                    Response.ContentType = "application/xml";//"text/xml; encoding='utf-8'";//"application/xml";
                    Context.Response.OutputStream.Write(buffer, 0, buffer.Length);
                    Context.Response.Flush();
                }
            }
        }
        else
        {

            while ((byteCount = inStr.Read(buffer, 0, buffer.Length)) > 0)
            {
                if (Context.Response.IsClientConnected)
                {
                    Response.ContentType = "application/pdf";
                    Context.Response.OutputStream.Write(buffer, 0, buffer.Length);
                    Context.Response.Flush();
                }
            }
        }
    }
}