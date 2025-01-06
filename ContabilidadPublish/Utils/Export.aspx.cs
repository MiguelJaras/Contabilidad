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

public partial class Utils_Export : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        ExportPDF();
    }

    void ExportPDF()
    {
        string type = Request.QueryString["type"];
        string titulo = Request.QueryString["Titulos"];

        string fileName = HttpContext.Current.Server.MapPath("~/Temp/") + titulo + "_" + System.IO.Path.GetRandomFileName().Replace(".", "") + "." + type;

        ExportAPP(type, fileName);

        if (File.Exists(fileName))
        {
            DownloadFile(fileName, true);
        }
    }

    void ExportAPP(string ext, string fileName)
    {

        using (Process process = new Process())
        {
            string Reporte = "";
            string DB = "";
            //string type;

            DB = Request.QueryString["db"];
            Reporte = AppDomain.CurrentDomain.BaseDirectory + Request.QueryString["report"];

            string parametros = Request.QueryString["parameters"].ToString();

            StreamReader outputReader = null;
            StreamReader errorReader = null; 

            try
            {
                string Exe = HttpContext.Current.Server.MapPath("~/Bin/") + "ExportApp.exe";
                string pathWebConfig = HttpContext.Current.Server.MapPath("~/Web.config");
                string par = "";
                par = DB + "¬";
                par += Reporte + "¬";
                par += ext + "¬";
                par += fileName + "¬";
                par += parametros + "¬";
                par += pathWebConfig;

                ProcessStartInfo processStartInfo = new ProcessStartInfo(Exe, par);
                processStartInfo.ErrorDialog = false;
                processStartInfo.UseShellExecute = false;
                processStartInfo.RedirectStandardError = true;
                processStartInfo.RedirectStandardInput = true;
                processStartInfo.RedirectStandardOutput = true;
                processStartInfo.WindowStyle = ProcessWindowStyle.Hidden;
                processStartInfo.UseShellExecute = false;
                processStartInfo.CreateNoWindow = true;

                //Execute the process

                process.StartInfo = processStartInfo;
                bool processStarted = process.Start();

                if (processStarted)
                {
                    //Get the output stream
                    outputReader = process.StandardOutput;
                    errorReader = process.StandardError;
                    process.WaitForExit();

                    //Display the result
                    string displayText = "Output" + Environment.NewLine + "==============" + Environment.NewLine;
                    displayText += outputReader.ReadToEnd();
                    displayText += Environment.NewLine + "Error" + Environment.NewLine + "==============" +
                                   Environment.NewLine;
                    displayText += errorReader.ReadToEnd();

                }
                
            }
            catch (Exception ex)
            {
                //process.Close(); 

            }
            finally
            {
                if (outputReader != null)
                {
                    outputReader.Close();
                }
                if (errorReader != null)
                {
                    errorReader.Close();
                }
            }


            //process.Dispose();
            //process.Close(); 
        }
        GC.Collect();
        //GC.WaitForPendingFinalizers();
    }

    private void DownloadFile(string fname, bool forceDownload)
    {
        FileInfo asd = new FileInfo(fname);
        string path = asd.FullName;
        string name = Path.GetFileName(path);
        string ext = Path.GetExtension(path);
        string type = "";
        // set known types based on file extension  
        if (ext != null)
        {
            switch (ext.ToLower())
            {
                case ".xls":
                    type = "application/vnd.ms-excel";
                    break;
                case ".pdf":
                    type = "application/pdf";
                    break;
            }
        }

        if (forceDownload)
        {
            Response.AppendHeader("content-disposition",
                "attachment; filename=" + name);
        }

        if (type != "")
            Response.ContentType = type;

        Response.WriteFile(path);  
        Response.Flush();


        if (File.Exists(fname))
            File.Delete(fname); 
        
        Response.End(); 
       
    }


}
