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
using Contabilidad.DataAccess;
using Contabilidad.Entity;
using Contabilidad.Bussines;

public partial class Utils_CRViewerNoParameters : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        MuestraEnPantalla();
    }

    private void SetReportConnectionInfo(ReportDocument reportDocument)
    {
        Servidor ser = new Servidor();
        Entity_Servidor obj = new Entity_Servidor();

        obj = ser.Credenciales();

        foreach (CrystalDecisions.CrystalReports.Engine.Table table in reportDocument.Database.Tables)
        {

            table.LogOnInfo.ConnectionInfo.ServerName = obj.StrSQLIP;
            table.LogOnInfo.ConnectionInfo.UserID = obj.StrSQLUser;
            table.LogOnInfo.ConnectionInfo.Password = obj.StrSQLPass;
            table.ApplyLogOnInfo(table.LogOnInfo);
        }

    }

    private void MuestraEnPantalla()
    {
        //NOTA LO QUE TIENE QUE VER CON BASE DE DATOS USTEDES LO PUEDEN CAMBIAR POR SUS RUTINAS DE BASE DE DATOS
        string Reporte = "";
        string DB = "";
        string PathEnviar = "";
        string FName = "";
        string type;

        DB = Request.QueryString["db"];
        Reporte = AppDomain.CurrentDomain.BaseDirectory + Request.QueryString["report"];
        type = Request.QueryString["type"];
      //  string[] arrParametrosReporte = Request.QueryString["parameters"].Replace("[--]", "®").Split('®');

        Servidor ser = new Servidor();
        Entity_Servidor obj = new Entity_Servidor();

        obj = ser.Credenciales();

        ReportDocument cr = new ReportDocument();
        cr.Load(Reporte);
        SetReportConnectionInfo(cr);
        //cr.SetDatabaseLogon(obj.StrSQLUser, obj.StrSQLPass, obj.StrSQLIP, DB, true);

        //for (Int32 intCount = 0; (intCount <= (arrParametrosReporte.Length - 1)); intCount++)
        //{
        //    cr.SetParameterValue(intCount, arrParametrosReporte[intCount].Replace("[ENTER]", System.Environment.NewLine));
        //}

        PathEnviar = "C:\\WINDOWS\\Temp";
        int NumAleatorio;
        Random random = new Random();
        NumAleatorio = random.Next(1000000, 9999999);

        switch (type)
        {
            ////Exportamos a PDF 
            case "pdf":
                FName = PathEnviar + "\\Rep_" + NumAleatorio.ToString() + ".pdf";
                ExportOptions crExportOptions;
                DiskFileDestinationOptions crDiskFileDestinationOptions;
                crDiskFileDestinationOptions = new DiskFileDestinationOptions();
                crDiskFileDestinationOptions.DiskFileName = FName;
                crExportOptions = cr.ExportOptions;
                crExportOptions.DestinationOptions = crDiskFileDestinationOptions;
                crExportOptions.ExportDestinationType = ExportDestinationType.DiskFile;
                crExportOptions.ExportFormatType = ExportFormatType.PortableDocFormat;
                cr.Export();
                Response.ContentType = "application/pdf";

                Response.ClearContent();
                Response.ClearHeaders();
                break;
            ////Exportamos a XLS
            case "xls":
                FName = PathEnviar + "\\Rep_" + NumAleatorio.ToString() + ".xls";
                ExportOptions crExportOptionsExcel;
                DiskFileDestinationOptions crDiskFileDestinationOptionsExcel;
                crDiskFileDestinationOptionsExcel = new DiskFileDestinationOptions();
                crDiskFileDestinationOptionsExcel.DiskFileName = FName;
                crExportOptionsExcel = cr.ExportOptions;
                crExportOptionsExcel.DestinationOptions = crDiskFileDestinationOptionsExcel;
                crExportOptionsExcel.ExportDestinationType = ExportDestinationType.DiskFile;
                crExportOptionsExcel.ExportFormatType = ExportFormatType.Excel;

                //crExportOptionsExcel.ExcelUseConstantColumnWidth = False;
                cr.Export();

                Response.Buffer = true;
                Response.AddHeader("Pragma", "no-cache");
                Response.ContentType = "application/msexcel";
                Response.AddHeader("Content-Disposition", "attachment;filename=" + FName);
                Response.Expires = 0;
                Response.ContentType = "application/msexcel";
                Response.Clear();
                break;

            case "xlsw":
                FName = PathEnviar + "\\Rep_" + NumAleatorio.ToString() + ".xls";
                //ExportOptions crExportOptionsExcel;
                //DiskFileDestinationOptions crDiskFileDestinationOptionsExcel;



                crDiskFileDestinationOptionsExcel = new DiskFileDestinationOptions();
                crDiskFileDestinationOptionsExcel.DiskFileName = FName;
                crExportOptionsExcel = cr.ExportOptions;
                crExportOptionsExcel.DestinationOptions = crDiskFileDestinationOptionsExcel;
                crExportOptionsExcel.ExportDestinationType = ExportDestinationType.DiskFile;
                crExportOptionsExcel.ExportFormatType = ExportFormatType.ExcelRecord;


                //ExcelFormatOptions ex;
                //ex = new ExcelFormatOptions();
                //ex.ExcelUseConstantColumnWidth = false;
                //ex.ExcelConstantColumnWidth = 100;
                //cr.ExportOptions.ExportFormatOptions = ex;


                //Dim objExcelOptions As ExcelFormatOptions = New ExcelFormatOptions;
                // objExcelOptions.ExcelUseConstantColumnWidth = False;
                // rptExcel.ExportOptions.FormatOptions = objExcelOptions ;

                //crExportOptionsExcel.ExcelUseConstantColumnWidth = False;
                cr.Export();

                Response.Buffer = true;
                Response.AddHeader("Pragma", "no-cache");
                Response.ContentType = "application/msexcel";
                Response.AddHeader("Content-Disposition", "attachment;filename=" + FName);
                Response.Expires = 0;
                Response.ContentType = "application/msexcel";
                Response.Clear();

                break;
        }

        cr.Dispose();
        cr = null;
        Response.WriteFile(FName);
        Response.Flush();
        Response.Close();
        //  Lo borro fisicamente pra noe star generando basura
        System.IO.File.Delete(FName);

    }
}
