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


public partial class Utils_Excel : System.Web.UI.Page
{
    string type;
    protected void Page_Load(object sender, EventArgs e)
    {
        type = Request.QueryString["type"];
        string qry = Request.QueryString["query"];
        int intTabla = 0;

        if (Request.QueryString["tabla"] != null)
        {
            intTabla = Request.QueryString["tabla"].ToString() == "" ? 0 : Convert.ToInt32(Request.QueryString["tabla"].ToString());
        }
        else
            intTabla = 0;

        DataTable dt;
        Contabilidad.Bussines.Menu menu;
        menu = new Contabilidad.Bussines.Menu();

        dt = menu.BindGrid(qry).Tables[intTabla];

        ExporttoExcel(dt);      
    }   

    private void ExporttoExcel(DataTable table)
    {
        string fileName = HttpContext.Current.Server.MapPath("~/Temp/") + "Excel" + "_" + System.IO.Path.GetRandomFileName().Replace(".", "") + "." + type;

        HttpContext.Current.Response.Clear();
        HttpContext.Current.Response.ClearContent();
        HttpContext.Current.Response.ClearHeaders();
        //HttpContext.Current.Response.Buffer = true;
        //HttpContext.Current.Response.ContentType = "application/ms-excel";
        //HttpContext.Current.Response.Write(@"<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.0 Transitional//EN"">");
        //HttpContext.Current.Response.AddHeader("Content-Disposition", "attachment;filename=" + fileName);
        //HttpContext.Current.Response.Charset = "utf-8";
        //HttpContext.Current.Response.ContentEncoding = System.Text.Encoding.GetEncoding("windows-1250");

        Response.Buffer = true;
        Response.AddHeader("Pragma", "no-cache");
        Response.ContentType = "application/msexcel";
        Response.AddHeader("Content-Disposition", "attachment;filename=" + fileName);
        Response.Expires = 0;

        
        HttpContext.Current.Response.Write("<font style='font-size:10.0pt; font-family:Tahoma;'>");
        HttpContext.Current.Response.Write("<br>");
        HttpContext.Current.Response.Write("<table border='1' bgColor='#ffffff' borderColor='#000000' cellSpacing='0' cellPadding='0' style='font-size:10.0pt; font-family:Calibri; background:white;'>");
        HttpContext.Current.Response.Write("<tr>");
        
        //Columns
        int columnscount = table.Columns.Count;
        //Header
        for (int j = 0; j < columnscount; j++)
        {  
            HttpContext.Current.Response.Write("<td style='font-size:10pt; font-family:Tahoma; background:Navy; color:White '>");            
            HttpContext.Current.Response.Write("<b>");
            HttpContext.Current.Response.Write(table.Columns[j].ColumnName);
            HttpContext.Current.Response.Write("</b>");
            HttpContext.Current.Response.Write("</td>");
        }
        HttpContext.Current.Response.Write("</tr>");

        //Rows
        int rowId = 1;
        int start = 2;
        foreach (DataRow row in table.Rows)
        {
            rowId = rowId + 1;
            HttpContext.Current.Response.Write("<tr>");
            for (int i = 0; i < table.Columns.Count; i++)
            {            
                HttpContext.Current.Response.Write("<td>");
                if (table.Columns[i].ColumnName.ToUpper() == "LOTE" || table.Columns[i].ColumnName.ToUpper() == "GRUPO")
                    HttpContext.Current.Response.Write("'" + Text(row[i].ToString()));
                else
                {
                    if (table.Columns[0].ColumnName == "ColoniaVivienda" && row["ColoniaVivienda"].ToString() == "")
                    {
                        switch (table.Columns[i].ColumnName)
                        {
                            case "SupConstruccion":
                                HttpContext.Current.Response.Write("<b>" + Text("=SUMA(E" + start.ToString() + ":E" + (rowId - 1) + ")") + "</b>");
                                break;
                            case "SupTerreno":
                                HttpContext.Current.Response.Write("<b>" + Text("=SUMA(F" + start.ToString() + ":F" + (rowId - 1) + ")") + "</b>");
                                break;
                            case "ValorTerrenoMaple":
                                HttpContext.Current.Response.Write("<b>" + Text("=SUMA(N" + start.ToString() + ":N" + (rowId - 1) + ")") + "</b>");
                                break;
                            case "ValorTerrenoDesarrollo":
                                HttpContext.Current.Response.Write("<b>" + Text("=SUMA(O" + start.ToString() + ":O" + (rowId - 1) + ")") + "</b>");
                                break;
                            case "ValorConstruccion":
                                HttpContext.Current.Response.Write("<b>" + Text("=SUMA(P" + start.ToString() + ":P" + (rowId - 1) + ")") + "</b>");
                                break;
                            case "ValorOPeracion":
                                HttpContext.Current.Response.Write("<b>" + Text("=SUMA(Q" + start.ToString() + ":Q" + (rowId - 1) + ")") + "</b>");
                                break;
                            case "ServiciosConstruccion":
                                HttpContext.Current.Response.Write("<b>" + Text("=SUMA(R" + start.ToString() + ":R" + (rowId - 1) + ")") + "</b>");
                                break;
                            case "Bonificacion":
                                HttpContext.Current.Response.Write("<b>" + Text("=SUMA(S" + start.ToString() + ":S" + (rowId - 1) + ")") + "</b>");
                                break;
                            case "ValorNeto":
                                HttpContext.Current.Response.Write("<b>" + Text("=SUMA(T" + start.ToString() + ":T" + (rowId - 1) + ")") + "</b>");
                                start = rowId + 1;
                                break;
                            default:
                                HttpContext.Current.Response.Write("");
                                break;
                        }
                        //if (table.Columns[i].ColumnName == "ValorOPeracion")
                        //    HttpContext.Current.Response.Write("<b>" + Text("=SUMA(P" + start.ToString() + ":P" + (rowId - 1) + ")") + "</b>");
                        //else
                        //{
                        //    if (table.Columns[i].ColumnName == "ValorNeto")
                        //    {
                        //        HttpContext.Current.Response.Write("<b>" + Text("=SUMA(S" + start.ToString() + ":S" + (rowId - 1) + ")") + "</b>");
                        //        start = rowId + 1;
                        //    }
                        //    else
                        //        HttpContext.Current.Response.Write("");
                        //}        
                    }
                    else
                    {
                        if (table.Columns[i].ColumnName == "ValorOPeracion")
                            HttpContext.Current.Response.Write(Text("=SUMA(N" + rowId.ToString() + ":P" + rowId.ToString() + ")"));
                        else
                        {
                            if (table.Columns[i].ColumnName == "ValorNeto")
                                HttpContext.Current.Response.Write(Text("=SUMA(Q" + rowId.ToString() + " + R" + rowId.ToString() + " - S" + rowId.ToString() + ")"));
                            else
                                HttpContext.Current.Response.Write(Text(row[i].ToString()));
                        }
                    }
                }
                HttpContext.Current.Response.Write("</td>");
            }

            HttpContext.Current.Response.Write("</tr>");
        }
        HttpContext.Current.Response.Write("</table>");
        HttpContext.Current.Response.Write("</font>");
        HttpContext.Current.Response.Flush();
        HttpContext.Current.Response.Close();
        HttpContext.Current.Response.End();
    }

    private string Text(string data)
    {
        string value = "";

        if (data.Contains("<"))
        {
            int point;

            point = data.LastIndexOf(">");

            value = data.Substring(point + 1);
        }
        else
            value = data;

        return value;
    }


}
