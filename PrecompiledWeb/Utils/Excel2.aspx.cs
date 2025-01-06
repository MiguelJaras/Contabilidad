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
using CarlosAg.ExcelXmlWriter;
using System.IO;
using System.Diagnostics;
using Contabilidad.Bussines;

public partial class Utils_Excel2 : System.Web.UI.Page
{
    int type;
    protected void Page_Load(object sender, EventArgs e)
    {
        //try
        //{
            type = Convert.ToInt32(Request.QueryString["type"]);
            string qry = Query(type.ToString());

            //DataTable dt;

            //VetecMarfilDO.VetecDALHelper DALHelper;
            //DALHelper = new VetecMarfilDO.VetecDALHelper();

            //dt = DALHelper.GetTableFromQuery(qry);

            //DALHelper = null;

            if (type == 3)
                ExporttoExcelER();

            if (type == 9)
                ExporttoExcelEResumen();

            if (type == 5)
                ConceptosPendientes();

            if (type == 6)
                Estimado();

            if (type == 10)
                Auditoria();

            if (type == 7)
                MOSUBFRENTE();

            if (type == 8)
                TarjetaPartida();

            if(type == 4)
                ExporttoCantidad();
            //else
            //    ExporttoExcelAvance();
        //}
        //catch (Exception ex)
        //{
        //    ClientScript.RegisterStartupScript(Page.GetType(), "msgEr", "alert('" + ex.Message + "');", true);
        //}
    }   

    private void ExporttoExcel(DataTable table)
    {
        string fileName = HttpContext.Current.Server.MapPath("~/Temp/") + "Excel" + "_" + System.IO.Path.GetRandomFileName().Replace(".", "") + "." + type;

        HttpContext.Current.Response.Clear();
        HttpContext.Current.Response.ClearContent();
        HttpContext.Current.Response.ClearHeaders();
        HttpContext.Current.Response.Buffer = true;
        HttpContext.Current.Response.ContentType = "application/ms-excel";
        HttpContext.Current.Response.Write(@"<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.0 Transitional//EN"">");
        HttpContext.Current.Response.AddHeader("Content-Disposition", "attachment;filename=" + fileName);
        HttpContext.Current.Response.Charset = "utf-8";
        HttpContext.Current.Response.ContentEncoding = System.Text.Encoding.GetEncoding("windows-1250");
        
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
        foreach (DataRow row in table.Rows)
        {
            HttpContext.Current.Response.Write("<tr>");
            for (int i = 0; i < table.Columns.Count; i++)
            {
                HttpContext.Current.Response.Write("<td>");
                HttpContext.Current.Response.Write(Text(row[i].ToString()));
                HttpContext.Current.Response.Write("</td>");
            }

            HttpContext.Current.Response.Write("</tr>");
        }
        HttpContext.Current.Response.Write("</table>");
        HttpContext.Current.Response.Write("</font>");
        HttpContext.Current.Response.Flush();
        HttpContext.Current.Response.End();
    }

    private void ExporttoExcelAvance()
    {
       
            //DataTable dtActividades;
            //DataTable dtInsumos;
            //DataRow drActividades;
            //DataRow drInsumos;
            //DataTable dtLotes;
            //DataRow drLotes;
            //DataTable dtEstimado;
            //DataRow drEstimado;
            //decimal dblImporte = 0;
            //string value;
            //string fileName = HttpContext.Current.Server.MapPath("~/Temp/") + "Excel" + "_" + System.IO.Path.GetRandomFileName().Replace(".", "") + ".xlsx";
            

            //HttpContext.Current.Response.Clear();
            //HttpContext.Current.Response.ClearContent();
            //HttpContext.Current.Response.ClearHeaders();
            //HttpContext.Current.Response.Buffer = true;
            //HttpContext.Current.Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
            ////HttpContext.Current.Response.Write(@"<!DOCTYPE HTML PUBLIC ""-//W3C//DTD HTML 4.0 Transitional//EN"">");
            //HttpContext.Current.Response.AddHeader("Content-Disposition", "attachment;filename=" + fileName);
            //HttpContext.Current.Response.Charset = "utf-8";
            ////HttpContext.Current.Response.ContentEncoding = System.Text.Encoding.GetEncoding("windows-1250");

            ////Actividades
            //VetecMarfilDO.VetecDALHelper DALHelper;
            //DALHelper = new VetecMarfilDO.VetecDALHelper();
            //dtActividades = DALHelper.GetTableFromQuery("SELECT intPartidaVivienda, strClave + ' - ' + strNombre AS Actividad FROM tbPartidaVivienda WHERE intEmpresa = 1 and intTipoVivienda = (SELECT intTipoVivienda FROM tbColonia WHERE intColonia = (SELECT intColonia FROM tbObra WHERE intObra = " + obra + ")) AND intPartidaVivienda IN(SELECT DISTINCT intPartidaVivienda FROM tbPUTarjetaArticuloControl where intObra = " + obra + " AND intId in(SELECT intId FROM tbPUAvanceObra WHERE intObra = " + obra + " AND intEstimacion = " + Estimado + " and ISNULL(intEstimado,0) = 1)) ORDER BY CONVERT(int,strClave)");
            //DALHelper = null;

            ////HttpContext.Current.Response.Write("<font style='font-size:10.0pt; font-family:Tahoma;'>");
            ////HttpContext.Current.Response.Write("<br>");
            //HttpContext.Current.Response.Write("<table border='1' bgColor='#ffffff' borderColor='#000000' cellSpacing='0' cellPadding='0' style='font-size:10.0pt; font-family:Calibri; background:white;'>");

            //for (int i = 0; i < dtActividades.Rows.Count; i++)
            //{
            //    drActividades = dtActividades.Rows[i];
            //    HttpContext.Current.Response.Write("<tr>");
            //    HttpContext.Current.Response.Write("<td colspan='2' style='font-size:10.0pt; font-family:Calibri; background:Navy; color:white;'>");
            //    HttpContext.Current.Response.Write(drActividades["Actividad"].ToString());
            //    HttpContext.Current.Response.Write("</td>");


            //    VetecMarfilDO.VetecDALHelper DALHelperLote;
            //    DALHelperLote = new VetecMarfilDO.VetecDALHelper();

            //    dtLotes = DALHelperLote.GetTableFromQuery("EXEC usp_tbPUAvanceObra_SelWeek 1,1," + obra + ",0,0,0,0,0,0");
                
            //    DALHelperLote = null;

            //    for (int k = 0; k < dtLotes.Rows.Count; k++)
            //    {
            //        drLotes = dtLotes.Rows[k];
            //        HttpContext.Current.Response.Write("<td>");
            //        HttpContext.Current.Response.Write(drLotes["Id"].ToString());
            //        HttpContext.Current.Response.Write("</td>");
            //    }

            //    HttpContext.Current.Response.Write("</tr>");

            //    VetecMarfilDO.VetecDALHelper DALHelper1;
            //    DALHelper1 = new VetecMarfilDO.VetecDALHelper();
            //    dtInsumos = DALHelper1.GetTableFromQuery("usp_tbPUAvanceObra_Sel 1,1," + obra + ",0," + drActividades["intPartidaVivienda"].ToString());
            //    DALHelper1 = null;

            //    for (int j = 0; j < dtInsumos.Rows.Count; j++)
            //    {
            //        HttpContext.Current.Response.Write("<tr>");
            //        drInsumos = dtInsumos.Rows[j];
            //        HttpContext.Current.Response.Write("<td>");
            //        HttpContext.Current.Response.Write(drInsumos["strClave"].ToString());
            //        HttpContext.Current.Response.Write("</td>");
            //        HttpContext.Current.Response.Write("<td>");
            //        HttpContext.Current.Response.Write(drInsumos["strDescripcion"].ToString());
            //        HttpContext.Current.Response.Write("</td>");


            //        VetecMarfilDO.VetecDALHelper DALHelperEstimado;
            //        DALHelperEstimado = new VetecMarfilDO.VetecDALHelper();

            //        dtEstimado = DALHelperEstimado.GetTableFromQuery("EXEC usp_tbPUAvanceObra_SelWeek 1,1," + obra + ",0," + Estimado + ",1," + drInsumos["intArticulo"].ToString() + "," + drInsumos["intGrupo"].ToString() + ",0");
            //        DALHelperEstimado = null;

            //        for (int l = 0; l < dtEstimado.Rows.Count; l++)
            //        {
            //            drEstimado = dtEstimado.Rows[l];
            //            dblImporte = Convert.ToDecimal(drEstimado["strAcomulado"].ToString());

            //            value = dblImporte == 0 ? "" : "x";

            //            HttpContext.Current.Response.Write("<td>");
            //            HttpContext.Current.Response.Write(value);
            //            HttpContext.Current.Response.Write("</td>");
            //        }


            //        HttpContext.Current.Response.Write("</tr>");
            //    }
            //}

            //HttpContext.Current.Response.Write("</table>");
            //HttpContext.Current.Response.Write("</font>");
            //HttpContext.Current.Response.Flush();
            //HttpContext.Current.Response.End();

            ExcelXml excel;
            excel = new ExcelXml();

            string obra = Request.QueryString.Get("intObra").ToString();
            string Estimado = Request.QueryString.Get("intEstimado").ToString();
            string[] parameters = new string[2];

            parameters.SetValue(obra, 0);
            parameters.SetValue(Estimado, 1);

            Response.Clear();
            Response.ContentType = "text/excel";
            Response.Charset = "";
           
            Response.AddHeader("content-disposition", "attachment;filename=Report.xml");

            excel.ExportExcel(Response.OutputStream, parameters, type);
           
            Response.Flush();
            Response.End();
        
    }

    private void ConceptosPendientes()
    {
        ExcelXml excel;
        excel = new ExcelXml();

        string obra = Request.QueryString.Get("intObra").ToString();
        string[] parameters = new string[1];

        parameters.SetValue(obra, 0);

        Response.Clear();
        Response.ContentType = "text/excel";
        Response.Charset = "";

        Response.AddHeader("content-disposition", "attachment;filename=Report.xml");

        excel.ExportExcel(Response.OutputStream, parameters, 5);

        Response.Flush();
        Response.End();

    }

    private void Estimado()
    {
        ExcelXml excel;
        excel = new ExcelXml();

        string obra = Request.QueryString.Get("intObra").ToString();
        string intEstimacion = Request.QueryString.Get("intEstimacion").ToString();
        string[] parameters = new string[2];

        parameters.SetValue(obra, 0);
        parameters.SetValue(intEstimacion, 1);

        Response.Clear();
        Response.ContentType = "text/excel";
        Response.Charset = "";

        Response.AddHeader("content-disposition", "attachment;filename=Report.xml");

        excel.ExportExcel(Response.OutputStream, parameters, 6);

        Response.Flush();
        Response.End();

    }

    private void Auditoria()
    {
        ExcelXml excel;
        excel = new ExcelXml();

        string obra = Request.QueryString.Get("intObra").ToString();
        string[] parameters = new string[2];

        parameters.SetValue(obra, 0);
        parameters.SetValue("0", 1);

        Response.Clear();
        Response.ContentType = "text/excel";
        Response.Charset = "";

        Response.AddHeader("content-disposition", "attachment;filename=Report.xml");

        excel.ExportExcel(Response.OutputStream, parameters, 10);

        Response.Flush();
        Response.End();

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

    private string Query(string type)
    {
        string value = "";

       

        return value;
    }

    //private void ExporttoExcelER()
    //{                   
    //        ExcelXml excel;
    //        excel = new ExcelXml();

    //        string strObra = Request.QueryString.Get("strObra");
    //        string dblIva = Request.QueryString.Get("dblIva");
    //        string dblIndirectos = Request.QueryString.Get("dblIndirectos");
    //        string dblFactor = Request.QueryString.Get("dblFactor");
    //        string dblProteccion = Request.QueryString.Get("dblProteccion");

    //        string[] parameters = new string[6];

    //        parameters.SetValue("3", 0);
    //        parameters.SetValue(strObra, 1);
    //        parameters.SetValue(dblIva, 2);
    //        parameters.SetValue(dblIndirectos, 3);
    //        parameters.SetValue(dblFactor, 4);
    //        parameters.SetValue(dblProteccion, 5);

    //        Response.Clear();
    //        Response.ContentType = "text/excel";
    //        Response.Charset = "";

    //        Response.AddHeader("content-disposition", "attachment;filename=Report.xls");

    //        excel.ExportExcel(Response.OutputStream, parameters, type);

    //        Response.Flush();
    //        Response.End();

    //}

    private void ExporttoExcelER()
    {
        ExcelXml excel;
        excel = new ExcelXml();

        string intColonia = Request.QueryString.Get("intColonia");
        string intSector = Request.QueryString.Get("intSector");
        string intObra = Request.QueryString.Get("intObra");

        string[] parameters = new string[4];

        parameters.SetValue("3", 0);
        parameters.SetValue(intColonia, 1);
        parameters.SetValue(intSector, 2);
        parameters.SetValue(intObra, 3);


        Response.Clear();
        Response.ContentType = "text/excel";
        Response.Charset = "";

        Response.AddHeader("content-disposition", "attachment;filename=Report.xls");

        excel.ExportExcel(Response.OutputStream, parameters, type);

        Response.Flush();
        Response.End();

    }
    private void ExporttoExcelEResumen()
    {
        ExcelXml excel;
        excel = new ExcelXml();

        string strObra = Request.QueryString.Get("strObra").ToString();
        string dblIva = Request.QueryString.Get("dblIva").ToString();
        string dblIndirectos = Request.QueryString.Get("dblIndirectos").ToString();
        string dblFactor = Request.QueryString.Get("dblFactor").ToString();
        string dblProteccion = Request.QueryString.Get("dblProteccion").ToString();

        string[] parameters = new string[6];

        parameters.SetValue("3", 0);
        parameters.SetValue(strObra, 1);
        parameters.SetValue(dblIva, 2);
        parameters.SetValue(dblIndirectos, 3);
        parameters.SetValue(dblFactor, 4);
        parameters.SetValue(dblProteccion, 5);

        Response.Clear();
        Response.ContentType = "text/excel";
        Response.Charset = "";

        Response.AddHeader("content-disposition", "attachment;filename=Report.xls");

        excel.ExportExcel(Response.OutputStream, parameters, type);

        Response.Flush();
        Response.End();

    }

    private void ExporttoCantidad()
    {
        ExcelXml excel;
        excel = new ExcelXml();

        string intObra = Request.QueryString.Get("intObra").ToString();
        string strFrente = Request.QueryString.Get("strFrente").ToString();
        string strFrenteFin = Request.QueryString.Get("strFrenteFin").ToString();
        string strPartida = Request.QueryString.Get("strPartida").ToString();
        string strPartidaFin = Request.QueryString.Get("strPartidaFin").ToString();
        string strInsumo = Request.QueryString.Get("strInsumo").ToString();
        string strInsumoFin = Request.QueryString.Get("strInsumoFin").ToString();
        string strCantidad = Request.QueryString.Get("strCantidad").ToString();

        string[] parameters = new string[9];

        parameters.SetValue("4", 0);
        parameters.SetValue(intObra, 1);
        parameters.SetValue(strFrente, 2);
        parameters.SetValue(strFrenteFin, 3);
        parameters.SetValue(strPartida, 4);
        parameters.SetValue(strPartidaFin, 5);
        parameters.SetValue(strInsumo, 6);
        parameters.SetValue(strInsumoFin, 7);
        parameters.SetValue(strCantidad, 8);

        Response.Clear();
        Response.ContentType = "text/excel";
        Response.Charset = "";

        Response.AddHeader("content-disposition", "attachment;filename=Report.xls");

        excel.ExportExcel(Response.OutputStream, parameters, type);

        Response.Flush();
        Response.End();

    }

    private void MOSUBFRENTE()
    {
        ExcelXml excel;
        excel = new ExcelXml();

        string obra = Request.QueryString.Get("intObra").ToString();
        string[] parameters = new string[1];

        parameters.SetValue(obra, 0);

        Response.Clear();
        Response.ContentType = "text/excel";
        Response.Charset = "";

        Response.AddHeader("content-disposition", "attachment;filename=Report.xml");

        excel.ExportExcel(Response.OutputStream, parameters, 7);

        Response.Flush();
        Response.End();

    }

    private void TarjetaPartida()
    {
        ExcelXml excel;
        excel = new ExcelXml();

        string obra = Request.QueryString.Get("intObra").ToString();
        string[] parameters = new string[1];

        parameters.SetValue(obra, 0);

        Response.Clear();
        Response.ContentType = "text/excel";
        Response.Charset = "";

        Response.AddHeader("content-disposition", "attachment;filename=Report.xml");

        excel.ExportExcel(Response.OutputStream, parameters, 8);

        Response.Flush();
        Response.End();

    }
}