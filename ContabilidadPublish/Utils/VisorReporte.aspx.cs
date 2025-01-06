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
using System.IO;

public partial class VisorReporte : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        //Reportes obj;
        //obj = new Reportes(); 
        ReportDocument RptImpresion;
        RptImpresion = new ReportDocument();

        string strReportSource = AppDomain.CurrentDomain.BaseDirectory + Request.QueryString["report"];
        string[] arrParametrosReporte = Request.QueryString["parameters"].Replace("[--]", "®").Split('®');

        CrystalDecisions.CrystalReports.Engine.ReportDocument objReporte;

        objReporte = new CrystalDecisions.CrystalReports.Engine.ReportDocument();
        objReporte.Load(strReportSource, 0);
        objReporte.SetDatabaseLogon("vetec", "vetec", "192.168.100.10", "VetecMarfilAdmin", true);

        for (Int32 intCount = 0; (intCount <= (arrParametrosReporte.Length - 1)); intCount++)
        {
            objReporte.SetParameterValue(intCount, arrParametrosReporte[intCount].Replace("[ENTER]", System.Environment.NewLine));
        }

        
        
        //string Fname = "C:\\WINDOWS\\Temp\\Contrarecibo.pdf"; 

        Stream st = null;
        st = objReporte.ExportToStream(CrystalDecisions.Shared.ExportFormatType.Excel);
        string friendlyName = "Test";
        friendlyName = "Contrarecibo.xls";

        Response.ClearContent();
        Response.ClearHeaders();
        Response.ContentType = "Application/PDF";
        Response.AddHeader("Content-Disposition", "attachment;filename=" + friendlyName);

        Byte[] buffer = new Byte[st.Length];
        st.Read(buffer, 0, (int)st.Length);
        Response.BinaryWrite(buffer);
        Response.End();


        //crvReporte.Dispose();
        //crvReporte = null;
        //objReporte.Dispose();
        //objReporte = null;
        //obj = null;


        //obj = null;
        RptImpresion = null;
        RptImpresion.Dispose();

    }
}
