using CrystalDecisions.CrystalReports.Engine;
using CrystalDecisions.CrystalReports;
using System.Configuration;
using System;
using System.Web;
//using VetecMarfilUI.Utilerias;
using Anthem;

using System.Data;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using CrystalDecisions.Shared;

//  public class Reportes
namespace Contabilidad.Reportes
{
    /// <summary>
    /// Mediante esta clase visualizamos un reporte de Cristal Reports
    /// </summary>

    public class Reportes
    {
        private string _reportSource = string.Empty;
        private string _viewerLocation = string.Empty;
        private string _parametrosReporte = string.Empty;

        public string viewerLocation
        {
            get { return _viewerLocation; }
            set { _viewerLocation = value; }
        }

        public string reportSource
        {
            get { return _reportSource; }
            set { _reportSource = value; }
        }

        public string parametrosReporte
        {
            get { return _parametrosReporte; }
            set { _parametrosReporte = value; }
        }

        public void showAnthem()
        {

            if (_reportSource == string.Empty)
                throw new Exception("No se ha definido el nombre del Reporte.");
            string strBD = "VetecMarfil";

            string strServerName = "http://" + HttpContext.Current.Request.ServerVariables["SERVER_NAME"].ToString() + ":" + HttpContext.Current.Request.ServerVariables["SERVER_PORT"].ToString() + "/Contabilidad/Utils/";

            string strPost = "?reportSource="
                + _reportSource + "&parametrosReporte="
                + _parametrosReporte + "&bd=" + strBD;
            string strScript = ("<SCRIPT language=\'javascript\'>window.open(\'" + strServerName + "VisorReporte.aspx" + strPost + "\',\'\',\'" + "scrollbars=1, resizable=1" + "\');</SCRIPT>");

            Anthem.Manager.RegisterStartupScript(this.GetType(), "showPopup", strScript,true);
        }        

        public void print()
        {
            try
            {
                ReportDocument objReporte;
                string strReportSource = _reportSource;
                string[] arrParametrosReporte = _parametrosReporte.Replace("[--]", "®").Split('®');
                string strBD = "VetecMarfil";

                objReporte = new ReportDocument();
                objReporte.Load(strReportSource);
                objReporte.DataSourceConnections[0].SetConnection(ConfigurationSettings.AppSettings["server"],
                    strBD, ConfigurationSettings.AppSettings["user"], ConfigurationSettings.AppSettings["password"]);
                int intCount;
                for (intCount = 0; (intCount <= (arrParametrosReporte.Length - 1)); intCount++)
                    objReporte.SetParameterValue(intCount, arrParametrosReporte[intCount].Replace("[ENTER]", System.Environment.NewLine));
                objReporte.PrintToPrinter(1, false, 0, 0);
            }
            catch (Exception) { }
        }

        public void ExportaReportes(CrystalDecisions.CrystalReports.Engine.ReportDocument RptListados, string FName)
        {
            //FUNCION PARA EXPORTAR LOS REPORTES HECHOS EN CRYSTAL
            ReportDocument crReportDocument;
            ExportOptions crExportOptions;
            DiskFileDestinationOptions crDiskFileDestinationOptions;

            crReportDocument = RptListados;

            crDiskFileDestinationOptions = new DiskFileDestinationOptions();
            crDiskFileDestinationOptions.DiskFileName = FName;
            crExportOptions = crReportDocument.ExportOptions;
            crExportOptions.DestinationOptions = crDiskFileDestinationOptions;
            crExportOptions.ExportDestinationType = ExportDestinationType.DiskFile;
            crExportOptions.ExportFormatType = ExportFormatType.PortableDocFormat;
            crReportDocument.Export();

            crReportDocument = null;
        }

        public void ExportaReportesWord(CrystalDecisions.CrystalReports.Engine.ReportDocument RptListados, string FName)
        {
            //FUNCION PARA EXPORTAR LOS REPORTES HECHOS EN CRYSTAL
            ReportDocument crReportDocument;
            ExportOptions crExportOptions;
            DiskFileDestinationOptions crDiskFileDestinationOptions;

            crReportDocument = RptListados;

            crDiskFileDestinationOptions = new DiskFileDestinationOptions();
            crDiskFileDestinationOptions.DiskFileName = FName;
            crExportOptions = crReportDocument.ExportOptions;
            crExportOptions.DestinationOptions = crDiskFileDestinationOptions;
            crExportOptions.ExportDestinationType = ExportDestinationType.DiskFile;
            crExportOptions.ExportFormatType = ExportFormatType.WordForWindows;
            crReportDocument.Export();

            crReportDocument = null;
        }

    }
}


