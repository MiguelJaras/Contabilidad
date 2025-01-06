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


public partial class Contabilidad_Inventario_Reportes_CRViewer : System.Web.UI.Page
{
    protected void Page_Init(object sender, EventArgs e)
    {
        MuestraEnPantalla();
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
        string[] arrParametrosReporte = Request.QueryString["parameters"].Replace("[--]", "®").Split('®');
       
        ReportDocument cr = new ReportDocument();
        cr.Load(Reporte);
        cr.SetDatabaseLogon("vetec", "vetec", "192.168.100.10", DB, true);

        for (Int32 intCount = 0; (intCount <= (arrParametrosReporte.Length - 1)); intCount++)
        {
            cr.SetParameterValue(intCount, arrParametrosReporte[intCount].Replace("[ENTER]", System.Environment.NewLine));
        }
                              
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
                crExportOptionsExcel.ExportFormatType = ExportFormatType.ExcelRecord  ;


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
