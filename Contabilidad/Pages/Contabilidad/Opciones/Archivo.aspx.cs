using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;

public partial class Pages_Opciones_Prospecto_Archivo : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        verArchivo();
    }

    public void verArchivo()
    {
         
        DataTable dt;
        string IdDocumento = Request.QueryString.Get("IdDocumento");
        int position;

        using (DataSet ds = Contabilidad.DataAccess.Base.ExecuteQuery("SELECT strNombreDocumento, Documento FROM dbDigitalizacion.dbo.tbProspectoDocumentos WHERE intDocumento=" + IdDocumento))
        {
            if (ds != null)
                if (ds.Tables.Count > 0)
                {
                    if (ds.Tables[0].Rows.Count > 0)
                    {
                        string FileName = ((string)(ds.Tables[0].Rows[0].ItemArray[0]));
                        position = FileName.LastIndexOf(".");
                        string extencionFile = FileName.Substring(position + 1);
                        byte[] FileByte = ((byte[])(ds.Tables[0].Rows[0].ItemArray[1]));

                        string contextType = "";

                        switch (extencionFile)
                        {
                            case "dwf":
                                contextType = "model/vnd.dwf";
                                break;
                            case "dwg":
                                contextType = "application/acad";
                                break;
                            case "jpg":
                                contextType = "image/jpeg";
                                break;
                            case "gif":
                                contextType = "image/gif";
                                break;
                            case "bmp":
                                contextType = "image/bmp";
                                break;
                            case "txt":
                                contextType = "text/plain";
                                break;
                            case "doc":
                                contextType = "application/msword";
                                break;
                            case "xls":
                                contextType = "application/msexcel";
                                break;
                            case "ppt":
                                contextType = "application/vnd.ms-powerpoint";
                                break;
                            case "pdf":
                                contextType = "application/pdf";
                                break;
                            case "zip":
                                contextType = "application/zip";
                                break;
                        }
                        Response.Buffer = true;
                        Response.AddHeader("Pragma", "no-cache");
                        Response.AddHeader("Content-Disposition", "attachment;filename=" + FileName);
                        Response.Expires = 0;
                        Response.ContentType = contextType;
                        Response.Clear();
                        Response.BinaryWrite(FileByte);
                        Response.Flush();
                        Response.End();

                        FileByte = null;
                    }
                }
        }
        dt = null;
    }
}