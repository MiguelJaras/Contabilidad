using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Utils_DisplayFile : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            string strFileName = "", strType = "";
            if (Request.QueryString["fileName"] != null)
                strFileName = Request.QueryString["fileName"].ToString();

            if (Request.QueryString["type"] != null)
                strType = Request.QueryString["type"].ToString();

            int intEmpresa = 0;
            string strEmpresa = string.IsNullOrEmpty(Request.QueryString["emp"]) ? "" : Request.QueryString["emp"];

            int.TryParse(strEmpresa, out intEmpresa);

            if (strFileName != "" && strType != "")
                LoadFile(strFileName, strType, intEmpresa);

        }
    }

    protected void LoadFile(string strFileName, string strType, int intEmpresa)
    {

        try
        {
            string strPath = "", strApp = "application/pdf", strFilePath;
            byte[] bytes = null;
            switch (strType.ToLower())
            {
                case "factura":
                    strPath = @"\\Marfil-nas\sem\Contabilidad\Facturas\" + intEmpresa.ToString() + "\\";
                    strFilePath = strPath + strFileName;
                    strApp = "application/pdf";
                    break;
                case "facturaxml":
                    strPath = @"\\Marfil-nas\sem\Contabilidad\Facturas\" + intEmpresa.ToString() + "\\";
                    strFilePath = strPath + strFileName;
                    strApp = "text/html";
                    break;
                case "notacredito":
                    strPath = @"\\Marfil-nas\sem\Contabilidad\Nota de Credito\" + intEmpresa.ToString() + "\\";
                    strFilePath = strPath + strFileName;
                    strApp = "application/pdf";
                    break;
                case "notacreditoxml":
                    strPath = @"\\Marfil-nas\sem\Contabilidad\Nota de Credito\" + intEmpresa.ToString() + "\\";
                    strFilePath = strPath + strFileName;
                    strApp = "application/pdf";
                    break;
                default:
                    return;
            }

            bytes = System.IO.File.ReadAllBytes(strFilePath);
            Response.ClearHeaders();
            Response.Clear();
            Response.AddHeader("Pragma", "no-cache");
            Response.AddHeader("Content-Type", strApp);
            Response.AddHeader("Content-Length", bytes.Length.ToString());
            Response.AddHeader("Content-Disposition", "attachment; filename=" + strFileName);
            Response.BinaryWrite(bytes);


            Response.Flush();
            Response.End();

        }
        catch (Exception ex) { }

    }


}