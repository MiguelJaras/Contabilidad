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
using System.Threading;
using CarlosAg.ExcelXmlWriter;
using System.IO;

public partial class Utils_RExport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        Anthem.Manager.Register(this);

        string type = string.Empty, titulo = string.Empty, strParametros = string.Empty, strClassName = string.Empty,strSheet = string.Empty;
        int intEmpresa = 0, intSucursal = 0, intVersion = 0;

        if (Request.QueryString["type"] != null)
            if (Request.QueryString["type"].ToString() != "")
                type = Request.QueryString["type"];

        if (Request.QueryString["Titulos"] != null)
            if (Request.QueryString["Titulos"].ToString() != "")
                titulo = Request.QueryString["Titulos"];

        if (Request.QueryString["NombresSheets"] != null)
            if (Request.QueryString["NombresSheets"].ToString() != "")
                strSheet = Request.QueryString["NombresSheets"];

        if (Request.QueryString["parameters"] != null)
            if (Request.QueryString["parameters"].ToString() != "")
                strParametros = Request.QueryString["parameters"];

        if (Request.QueryString["intEmpresa"] != null)
            if (Request.QueryString["intEmpresa"].ToString() != "")
                intEmpresa = int.Parse(Request.QueryString["intEmpresa"]);

        if (Request.QueryString["intSucursal"] != null)
            if (Request.QueryString["intSucursal"].ToString() != "")
                intSucursal = int.Parse(Request.QueryString["intSucursal"]);

        if (Request.QueryString["intVersion"] != null)
            if (Request.QueryString["intVersion"].ToString() != "")
                intVersion = int.Parse(Request.QueryString["intVersion"]);

        if (Request.QueryString["strClassName"] != null)
            if (Request.QueryString["strClassName"].ToString() != "")
                strClassName = Request.QueryString["strClassName"];

        //RExcelXml objExpo = new RExcelXml();

        Response.Clear();
        Response.ContentType = "text/excel";
        Response.Charset = "";
        string fileName = "Excel_" + titulo.Trim().Replace(" ", "_") + "_" + System.IO.Path.GetRandomFileName().Replace(".", "") + "." + type;
        Response.AddHeader("content-disposition", "attachment;filename="+fileName);

     
        //objExpo.ExportFile(Response.OutputStream, type, titulo, strSheet, strParametros, strClassName, intEmpresa, intSucursal, intVersion);
        ExportFile(Response.OutputStream, type, titulo, strSheet, strParametros, strClassName, intEmpresa, intSucursal, intVersion);

        Response.Flush();
        Response.End();

    }
 
    void ExportFile(Stream filename, string type, string titulo, string strSheet, string strParametros, string strClassName, int intEmpresa, int intSucursal, int intVersion)
    {
        try
        {
            string[] arr = strParametros.Replace("[--]", "¬").Split('¬');
            Type t = System.Web.Compilation.BuildManager.GetType("Contabilidad.DataAccess." + strClassName, true, true);

            Contabilidad.DataAccess.Base objBase = (Contabilidad.DataAccess.Base)Activator.CreateInstance(t);

            using (DataSet ds = objBase.QueryHelpData(intEmpresa, intSucursal, arr, intVersion))
            {
                if (ds != null)
                {
                    if (ds.Tables.Count > 0)
                    {
                        if (ds.Tables[0].Rows.Count > 0)
                        { 
                            ExpExcel(ds, filename, strSheet);
                        }
                    }
                }
            }
        }
        catch (ThreadAbortException ex) { UtilFunctions.WriteInFile(ex.Message); throw; }
        catch (Exception ex) { UtilFunctions.WriteInFile(ex.Message); throw; }
        //finally
        //{
        //    HttpContext.Current.Response.SuppressContent = true;
        //    HttpContext.Current.ApplicationInstance.CompleteRequest();
        //}

    }

    public void ExpExcel(DataSet ds, Stream filename, string strSheet)
    {
        Workbook workbook = new Workbook();
        workbook.Properties.Author = "Ruben Mora Martinez";
        workbook.Properties.LastAuthor = "";
        workbook.Properties.Created = DateTime.Now;
        workbook.Properties.LastSaved = DateTime.Now;
        workbook.Properties.Version = "0.1";
        workbook.ExcelWorkbook.WindowHeight = 10110;
        workbook.ExcelWorkbook.WindowWidth = 15180;
        workbook.ExcelWorkbook.WindowTopX = 480;
        workbook.ExcelWorkbook.WindowTopY = 120;
        workbook.ExcelWorkbook.ProtectWindows = false;
        workbook.ExcelWorkbook.ProtectStructure = false;
        Styles(workbook.Styles);

        CreateExcel(workbook.Worksheets,ds, strSheet);

        workbook.Save(filename);
        workbook = null;
    }

    public void CreateExcel(WorksheetCollection sheets, DataSet ds,string strSheet)
    {

        int intTable = 0; 

        foreach (string sheetName in strSheet.Split(','))
        { 
            Worksheet worksheet = sheets.Add(sheetName);
             

            foreach (DataColumn c in ds.Tables[intTable].Columns)
            { 
                worksheet.Table.Columns.Add(int.Parse(ds.Tables[intTable + 1].Rows[0][c.Ordinal].ToString()));
            }

            WorksheetRow rowTitulo = worksheet.Table.Rows.Add();
            

            foreach (DataColumn c in ds.Tables[intTable].Columns)
            {
                rowTitulo.Cells.Add(c.ColumnName.ToString(), DataType.String, "sHeader2"); 
            }

            WorksheetRow rowData;
            foreach (DataRow dr in ds.Tables[intTable].Rows)
            {
                 rowData = worksheet.Table.Rows.Add();
                foreach (DataColumn c in ds.Tables[intTable].Columns)
                { 
                    rowData.Cells.Add(dr[c.ColumnName.ToString()].ToString(), FormatColumn(c.DataType), "s01"); 
                }
            } 

            worksheet.Options.FreezePanes = true;
            worksheet.Options.FitToPage = true;
            worksheet.Options.SplitHorizontal = 1;
            worksheet.Options.TopRowBottomPane = 1;
            worksheet.Options.ActivePane = 2;
            worksheet.Options.ProtectObjects = false;
            worksheet.Options.ProtectScenarios = false;
            worksheet.Options.PageSetup.Layout.CenterHorizontal = true;
            worksheet.Options.PageSetup.Header.Margin = 0.3937008F;
            worksheet.Options.PageSetup.Footer.Margin = 0.3937008F;
            worksheet.Options.PageSetup.PageMargins.Bottom = 0.5905512F;
            worksheet.Options.PageSetup.PageMargins.Left = 0.3937008F;
            worksheet.Options.PageSetup.PageMargins.Right = 0.3937008F;
            worksheet.Options.PageSetup.PageMargins.Top = 0.5905512F;
            worksheet.Options.Print.PaperSizeIndex = 9;
            worksheet.Options.Print.Scale = 85;
            worksheet.Options.Print.FitHeight = 100;
            worksheet.Options.Print.ValidPrinterInfo = true;

            intTable+=2; 
        
        }
    }

    private void Styles(WorksheetStyleCollection styles)
    {
        WorksheetStyle worksheetStyle1 = styles.Add("Default");
        worksheetStyle1.Name = "Normal";
        worksheetStyle1.Alignment.Vertical = StyleVerticalAlignment.Bottom;


        WorksheetStyle worksheetStyle2 = styles.Add("sHeader");
        worksheetStyle2.Borders.Add(StylePosition.Bottom, LineStyleOption.Continuous, 1, "Gray");
        worksheetStyle2.Borders.Add(StylePosition.Left, LineStyleOption.Continuous, 1, "Gray");
        worksheetStyle2.Borders.Add(StylePosition.Right, LineStyleOption.Continuous, 1, "Gray");
        worksheetStyle2.Borders.Add(StylePosition.Top, LineStyleOption.Continuous, 1, "Gray");
        worksheetStyle2.Font.Color = "White";
        worksheetStyle2.Interior.Color = "Navy";
        worksheetStyle2.Interior.Pattern = StyleInteriorPattern.Solid;
        worksheetStyle2.Font.Size = 10;
        worksheetStyle2.Font.FontName = "Arial";
        worksheetStyle2.Font.Bold = true;
        worksheetStyle2.Alignment.Horizontal = StyleHorizontalAlignment.Left;

        WorksheetStyle sHeader2 = styles.Add("sHeader2");
        sHeader2.Borders.Add(StylePosition.Bottom, LineStyleOption.Continuous, 1, "Gray");
        sHeader2.Borders.Add(StylePosition.Left, LineStyleOption.Continuous, 1, "Gray");
        sHeader2.Borders.Add(StylePosition.Right, LineStyleOption.Continuous, 1, "Gray");
        sHeader2.Borders.Add(StylePosition.Top, LineStyleOption.Continuous, 1, "Gray");
        sHeader2.Font.Color = "White";
        sHeader2.Interior.Color = "Navy";
        sHeader2.Interior.Pattern = StyleInteriorPattern.Solid;
        sHeader2.Font.Size = 10;
        sHeader2.Font.FontName = "Arial";
        sHeader2.Font.Bold = true;
        sHeader2.Alignment.Horizontal = StyleHorizontalAlignment.Center;


        WorksheetStyle worksheetStyle3 = styles.Add("s01");
        worksheetStyle3.Alignment.Horizontal = StyleHorizontalAlignment.Left;
        worksheetStyle3.Borders.Add(StylePosition.Bottom, LineStyleOption.Continuous, 1, "#A3C0E8");
        worksheetStyle3.Borders.Add(StylePosition.Left, LineStyleOption.Continuous, 1, "#A3C0E8");
        worksheetStyle3.Borders.Add(StylePosition.Right, LineStyleOption.Continuous, 1, "#A3C0E8");
        worksheetStyle3.Borders.Add(StylePosition.Top, LineStyleOption.Continuous, 1, "#A3C0E8");
        WorksheetStyle s02 = styles.Add("s02");
        s02.Alignment.Horizontal = StyleHorizontalAlignment.Right;
        s02.Borders.Add(StylePosition.Bottom, LineStyleOption.Continuous, 1, "#A3C0E8");
        s02.Borders.Add(StylePosition.Left, LineStyleOption.Continuous, 1, "#A3C0E8");
        s02.Borders.Add(StylePosition.Right, LineStyleOption.Continuous, 1, "#A3C0E8");
        s02.Borders.Add(StylePosition.Top, LineStyleOption.Continuous, 1, "#A3C0E8");
        WorksheetStyle worksheetStyle4 = styles.Add("sPosotion");
        worksheetStyle4.Font.Bold = true;
        worksheetStyle4.Interior.Color = "#A3C0E8";
        worksheetStyle4.Interior.Pattern = StyleInteriorPattern.Solid;
        worksheetStyle4.Font.Size = 8;
        worksheetStyle4.Font.Color = "Black";
        worksheetStyle4.Alignment.Horizontal = StyleHorizontalAlignment.Left;
        worksheetStyle4.Borders.Add(StylePosition.Bottom, LineStyleOption.Continuous, 2).Color = "#F2F8FF";
        worksheetStyle4.Borders.Add(StylePosition.Left, LineStyleOption.Continuous, 1).Color = "#F2F8FF";
        worksheetStyle4.Borders.Add(StylePosition.Right, LineStyleOption.Continuous, 1).Color = "#F2F8FF";
        worksheetStyle4.Borders.Add(StylePosition.Top, LineStyleOption.Continuous, 2).Color = "#F2F8FF";
        WorksheetStyle worksheetStyle5 = styles.Add("sPosotionNumber");
        worksheetStyle5.Font.Bold = true;
        worksheetStyle5.Interior.Color = "#FF99FF";
        worksheetStyle5.Font.Size = 8;
        worksheetStyle5.Font.Color = "Black";
        worksheetStyle5.Alignment.Horizontal = StyleHorizontalAlignment.Right;
        worksheetStyle5.Borders.Add(StylePosition.Bottom, LineStyleOption.Continuous, 2).Color = "#EE7621";
        worksheetStyle5.Borders.Add(StylePosition.Left, LineStyleOption.Continuous, 1).Color = "#EE7621";
        worksheetStyle5.Borders.Add(StylePosition.Right, LineStyleOption.Continuous, 1).Color = "#EE7621";
        worksheetStyle5.Borders.Add(StylePosition.Top, LineStyleOption.Continuous, 2).Color = "#EE7621";

        WorksheetStyle worksheetStyle6 = styles.Add("sPay");
        worksheetStyle6.Font.Bold = true;
        //worksheetStyle6.Interior.Color = "Silver";
        worksheetStyle6.Interior.Pattern = StyleInteriorPattern.Solid;
        worksheetStyle6.Font.Size = 8;
        worksheetStyle6.Font.Color = "Black";
        worksheetStyle6.Alignment.Horizontal = StyleHorizontalAlignment.Left;
        worksheetStyle6.Borders.Add(StylePosition.Bottom, LineStyleOption.Continuous, 2).Color = "#F2F8FF";
        worksheetStyle6.Borders.Add(StylePosition.Left, LineStyleOption.Continuous, 1).Color = "#F2F8FF";
        worksheetStyle6.Borders.Add(StylePosition.Right, LineStyleOption.Continuous, 1).Color = "#F2F8FF";
        worksheetStyle6.Borders.Add(StylePosition.Top, LineStyleOption.Continuous, 2).Color = "#F2F8FF";
        worksheetStyle6.NumberFormat = "#,#";
        //worksheetStyle6.NumberFormat = "$#,###.####";
        worksheetStyle6.Alignment.Horizontal = StyleHorizontalAlignment.Right;

        WorksheetStyle styleTotal = styles.Add("styleTotal");
        styleTotal.Font.Bold = true;
        styleTotal.Interior.Color = "Silver";
        styleTotal.Interior.Pattern = StyleInteriorPattern.Solid;
        styleTotal.Font.Size = 8;
        styleTotal.Font.Color = "Black";
        styleTotal.Alignment.Horizontal = StyleHorizontalAlignment.Left;
        styleTotal.Borders.Add(StylePosition.Bottom, LineStyleOption.Continuous, 2).Color = "#F2F8FF";
        styleTotal.Borders.Add(StylePosition.Left, LineStyleOption.Continuous, 1).Color = "#F2F8FF";
        styleTotal.Borders.Add(StylePosition.Right, LineStyleOption.Continuous, 1).Color = "#F2F8FF";
        styleTotal.Borders.Add(StylePosition.Top, LineStyleOption.Continuous, 2).Color = "#F2F8FF";
        styleTotal.NumberFormat = "$#,##0.0000";
        //worksheetStyle6.NumberFormat = "$#,###.####";
        styleTotal.Alignment.Horizontal = StyleHorizontalAlignment.Right;

        WorksheetStyle styleTotalN = styles.Add("styleTotalN");
        styleTotalN.Font.Bold = true;
        styleTotalN.Interior.Color = "Silver";
        styleTotalN.Interior.Pattern = StyleInteriorPattern.Solid;
        styleTotalN.Font.Size = 8;
        styleTotalN.Font.Color = "Red";
        styleTotalN.Alignment.Horizontal = StyleHorizontalAlignment.Left;
        styleTotalN.Borders.Add(StylePosition.Bottom, LineStyleOption.Continuous, 2).Color = "#F2F8FF";
        styleTotalN.Borders.Add(StylePosition.Left, LineStyleOption.Continuous, 1).Color = "#F2F8FF";
        styleTotalN.Borders.Add(StylePosition.Right, LineStyleOption.Continuous, 1).Color = "#F2F8FF";
        styleTotalN.Borders.Add(StylePosition.Top, LineStyleOption.Continuous, 2).Color = "#F2F8FF";
        styleTotalN.NumberFormat = "#,#";
        styleTotalN.NumberFormat = "$#,##0.0000";
        //worksheetStyle6.NumberFormat = "$#,###.####";
        styleTotalN.Alignment.Horizontal = StyleHorizontalAlignment.Right;


        WorksheetStyle StyleText = styles.Add("StyleText");
        StyleText.Font.Bold = true;
        //worksheetStyle6.Interior.Color = "Silver";
        StyleText.Interior.Pattern = StyleInteriorPattern.Solid;
        StyleText.Font.Size = 8;
        StyleText.Font.Color = "Black";
        StyleText.Alignment.Horizontal = StyleHorizontalAlignment.Left;
        StyleText.Borders.Add(StylePosition.Bottom, LineStyleOption.Continuous, 2).Color = "#F2F8FF";
        StyleText.Borders.Add(StylePosition.Left, LineStyleOption.Continuous, 1).Color = "#F2F8FF";
        StyleText.Borders.Add(StylePosition.Right, LineStyleOption.Continuous, 1).Color = "#F2F8FF";
        StyleText.Borders.Add(StylePosition.Top, LineStyleOption.Continuous, 2).Color = "#F2F8FF";
        StyleText.NumberFormat = "#,#";
        //worksheetStyle6.NumberFormat = "$#,###.####";
        StyleText.Alignment.Horizontal = StyleHorizontalAlignment.Left;


        WorksheetStyle StyleMoney = styles.Add("StyleMoney");
        StyleMoney.Font.Bold = true;
        //StyleMoney.Interior.Color = "Silver";
        StyleMoney.Interior.Pattern = StyleInteriorPattern.Solid;
        StyleMoney.Font.Size = 8;
        StyleMoney.Font.Color = "Black";
        StyleMoney.Alignment.Horizontal = StyleHorizontalAlignment.Left;
        StyleMoney.Borders.Add(StylePosition.Bottom, LineStyleOption.Continuous, 2).Color = "#F2F8FF";
        StyleMoney.Borders.Add(StylePosition.Left, LineStyleOption.Continuous, 1).Color = "#F2F8FF";
        StyleMoney.Borders.Add(StylePosition.Right, LineStyleOption.Continuous, 1).Color = "#F2F8FF";
        StyleMoney.Borders.Add(StylePosition.Top, LineStyleOption.Continuous, 2).Color = "#F2F8FF";
        //worksheetStyle6.NumberFormat = "#,#";
        StyleMoney.NumberFormat = "$#,##0.0000";
        StyleMoney.Alignment.Horizontal = StyleHorizontalAlignment.Right;

        WorksheetStyle StyleMoneyN = styles.Add("StyleMoneyN");
        StyleMoneyN.Font.Bold = true;
        //StyleMoney.Interior.Color = "Silver";
        StyleMoneyN.Interior.Pattern = StyleInteriorPattern.Solid;
        StyleMoneyN.Font.Size = 8;
        StyleMoneyN.Font.Color = "Red";
        StyleMoneyN.Alignment.Horizontal = StyleHorizontalAlignment.Left;
        StyleMoneyN.Borders.Add(StylePosition.Bottom, LineStyleOption.Continuous, 2).Color = "#F2F8FF";
        StyleMoneyN.Borders.Add(StylePosition.Left, LineStyleOption.Continuous, 1).Color = "#F2F8FF";
        StyleMoneyN.Borders.Add(StylePosition.Right, LineStyleOption.Continuous, 1).Color = "#F2F8FF";
        StyleMoneyN.Borders.Add(StylePosition.Top, LineStyleOption.Continuous, 2).Color = "#F2F8FF";
        //worksheetStyle6.NumberFormat = "#,#";
        StyleMoneyN.NumberFormat = "$#,##0.0000";
        StyleMoneyN.Alignment.Horizontal = StyleHorizontalAlignment.Right;

        WorksheetStyle StyleCant = styles.Add("StyleCant");
        StyleCant.Font.Bold = true;
        //StyleCant.Interior.Color = "Silver";
        StyleCant.Interior.Pattern = StyleInteriorPattern.Solid;
        StyleCant.Font.Size = 8;
        StyleCant.Font.Color = "Black";
        StyleCant.Alignment.Horizontal = StyleHorizontalAlignment.Left;
        StyleCant.Borders.Add(StylePosition.Bottom, LineStyleOption.Continuous, 2).Color = "#F2F8FF";
        StyleCant.Borders.Add(StylePosition.Left, LineStyleOption.Continuous, 1).Color = "#F2F8FF";
        StyleCant.Borders.Add(StylePosition.Right, LineStyleOption.Continuous, 1).Color = "#F2F8FF";
        StyleCant.Borders.Add(StylePosition.Top, LineStyleOption.Continuous, 2).Color = "#F2F8FF";
        StyleCant.NumberFormat = "#,##0.000000";
        StyleCant.Alignment.Horizontal = StyleHorizontalAlignment.Right;

        WorksheetStyle StyleCantN = styles.Add("StyleCantN");
        StyleCantN.Font.Bold = true;
        //StyleCant.Interior.Color = "Silver";
        StyleCantN.Interior.Pattern = StyleInteriorPattern.Solid;
        StyleCantN.Font.Size = 8;
        StyleCantN.Font.Color = "Red";
        StyleCantN.Alignment.Horizontal = StyleHorizontalAlignment.Left;
        StyleCantN.Borders.Add(StylePosition.Bottom, LineStyleOption.Continuous, 2).Color = "#F2F8FF";
        StyleCantN.Borders.Add(StylePosition.Left, LineStyleOption.Continuous, 1).Color = "#F2F8FF";
        StyleCantN.Borders.Add(StylePosition.Right, LineStyleOption.Continuous, 1).Color = "#F2F8FF";
        StyleCantN.Borders.Add(StylePosition.Top, LineStyleOption.Continuous, 2).Color = "#F2F8FF";
        StyleCantN.NumberFormat = "#,##0.000000";
        StyleCantN.Alignment.Horizontal = StyleHorizontalAlignment.Right;



        WorksheetStyle worksheetStyle7 = styles.Add("sPayNumber");
        worksheetStyle7.Font.Bold = true;
        worksheetStyle7.Interior.Color = "#7DCC7D";
        worksheetStyle7.Font.Size = 8;
        worksheetStyle7.Font.Color = "Black";
        worksheetStyle7.Alignment.Horizontal = StyleHorizontalAlignment.Right;
        worksheetStyle7.Borders.Add(StylePosition.Bottom, LineStyleOption.Continuous, 2).Color = "#7DCC7D";
        worksheetStyle7.Borders.Add(StylePosition.Left, LineStyleOption.Continuous, 1).Color = "#7DCC7D";
        worksheetStyle7.Borders.Add(StylePosition.Right, LineStyleOption.Continuous, 1).Color = "#7DCC7D";
        worksheetStyle7.Borders.Add(StylePosition.Top, LineStyleOption.Continuous, 2).Color = "#7DCC7D";


        WorksheetStyle Format1 = styles.Add("Format1");
        Format1.Font.Bold = true;
        Format1.Interior.Color = "#A3C0E8";
        Format1.Interior.Pattern = StyleInteriorPattern.Solid;
        Format1.Font.Size = 8;
        Format1.Font.Color = "Black";
        Format1.Alignment.Horizontal = StyleHorizontalAlignment.Right;
        Format1.Borders.Add(StylePosition.Bottom, LineStyleOption.Continuous, 2).Color = "#A3C0E8";
        Format1.Borders.Add(StylePosition.Left, LineStyleOption.Continuous, 1).Color = "#A3C0E8";
        Format1.Borders.Add(StylePosition.Right, LineStyleOption.Continuous, 1).Color = "#A3C0E8";
        Format1.Borders.Add(StylePosition.Top, LineStyleOption.Continuous, 2).Color = "#A3C0E8";

        WorksheetStyle Format2 = styles.Add("Format2");
        Format2.Font.Bold = true;
        Format2.Interior.Color = "#66FF00";
        Format2.Interior.Pattern = StyleInteriorPattern.Solid;
        Format2.Font.Size = 8;
        Format2.Font.Color = "Black";
        Format2.Alignment.Horizontal = StyleHorizontalAlignment.Right;
        Format2.Borders.Add(StylePosition.Bottom, LineStyleOption.Continuous, 2).Color = "#66FF00";
        Format2.Borders.Add(StylePosition.Left, LineStyleOption.Continuous, 1).Color = "#66FF00";
        Format2.Borders.Add(StylePosition.Right, LineStyleOption.Continuous, 1).Color = "#66FF00";
        Format2.Borders.Add(StylePosition.Top, LineStyleOption.Continuous, 2).Color = "#66FF00";

        WorksheetStyle Format3 = styles.Add("Format3");
        Format3.Font.Bold = true;
        Format3.Interior.Color = "#CCCC00";
        Format3.Interior.Pattern = StyleInteriorPattern.Solid;
        Format3.Font.Size = 8;
        Format3.Font.Color = "Black";
        Format3.Alignment.Horizontal = StyleHorizontalAlignment.Right;
        Format3.Borders.Add(StylePosition.Bottom, LineStyleOption.Continuous, 2).Color = "#CCCC00";
        Format3.Borders.Add(StylePosition.Left, LineStyleOption.Continuous, 1).Color = "#CCCC00";
        Format3.Borders.Add(StylePosition.Right, LineStyleOption.Continuous, 1).Color = "#CCCC00";
        Format3.Borders.Add(StylePosition.Top, LineStyleOption.Continuous, 2).Color = "#CCCC00";

        WorksheetStyle Format4 = styles.Add("Format4");
        Format4.Font.Bold = true;
        Format4.Interior.Color = "#990000";
        Format4.Interior.Pattern = StyleInteriorPattern.Solid;
        Format4.Font.Size = 8;
        Format4.Font.Color = "Black";
        Format4.Alignment.Horizontal = StyleHorizontalAlignment.Right;
        Format4.Borders.Add(StylePosition.Bottom, LineStyleOption.Continuous, 2).Color = "#990000";
        Format4.Borders.Add(StylePosition.Left, LineStyleOption.Continuous, 1).Color = "#990000";
        Format4.Borders.Add(StylePosition.Right, LineStyleOption.Continuous, 1).Color = "#990000";
        Format4.Borders.Add(StylePosition.Top, LineStyleOption.Continuous, 2).Color = "#990000";

        WorksheetStyle Format5 = styles.Add("Format5");
        Format5.Font.Bold = true;
        Format5.Interior.Color = "#7DCC7D";
        Format5.Interior.Pattern = StyleInteriorPattern.Solid;
        Format5.Font.Size = 8;
        Format5.Font.Color = "Black";
        Format5.Alignment.Horizontal = StyleHorizontalAlignment.Right;
        Format5.Borders.Add(StylePosition.Bottom, LineStyleOption.Continuous, 2).Color = "#7DCC7D";
        Format5.Borders.Add(StylePosition.Left, LineStyleOption.Continuous, 1).Color = "#7DCC7D";
        Format5.Borders.Add(StylePosition.Right, LineStyleOption.Continuous, 1).Color = "#7DCC7D";
        Format5.Borders.Add(StylePosition.Top, LineStyleOption.Continuous, 2).Color = "#7DCC7D";

        WorksheetStyle Format6 = styles.Add("Format6");
        Format6.Font.Bold = true;
        Format6.Interior.Color = "Silver";
        Format6.Interior.Pattern = StyleInteriorPattern.Solid;
        Format6.Font.Size = 8;
        Format6.Font.Color = "Black";
        Format6.Alignment.Horizontal = StyleHorizontalAlignment.Right;
        Format6.Borders.Add(StylePosition.Bottom, LineStyleOption.Continuous, 2).Color = "Silver";
        Format6.Borders.Add(StylePosition.Left, LineStyleOption.Continuous, 1).Color = "Silver";
        Format6.Borders.Add(StylePosition.Right, LineStyleOption.Continuous, 1).Color = "Silver";
        Format6.Borders.Add(StylePosition.Top, LineStyleOption.Continuous, 2).Color = "Silver";

        WorksheetStyle Format7 = styles.Add("Format7");
        Format7.Font.Bold = true;
        Format7.Interior.Color = "Gray";
        Format7.Interior.Pattern = StyleInteriorPattern.Solid;
        Format7.Font.Size = 8;
        Format7.Font.Color = "Black";
        Format7.Alignment.Horizontal = StyleHorizontalAlignment.Right;
        Format7.Borders.Add(StylePosition.Bottom, LineStyleOption.Continuous, 2).Color = "Gray";
        Format7.Borders.Add(StylePosition.Left, LineStyleOption.Continuous, 1).Color = "Gray";
        Format7.Borders.Add(StylePosition.Right, LineStyleOption.Continuous, 1).Color = "Gray";
        Format7.Borders.Add(StylePosition.Top, LineStyleOption.Continuous, 2).Color = "Gray";



    }

    private string Format(string value)
    {
        string format = "";
        if (value.Contains("1."))
            format = "Format1";
        if (value.Contains("2."))
            format = "Format2";
        if (value.Contains("3."))
            format = "Format3";
        if (value.Contains("4."))
            format = "Format4";
        if (value.Contains("5."))
            format = "Format5";
        if (value.Contains("6."))
            format = "Format6";
        if (value.Contains("7."))
            format = "Format7";
        return format;
    }

    private DataType FormatColumn(Type typeColumn)
    {
        DataType val;
        switch (typeColumn.ToString()) 
        {
            case "bool": val = DataType.Boolean; break;
            case "byte": val = DataType.String; break;
            case "char": val = DataType.String; break;
            case "decimal": val = DataType.Number; break;
            case "double": val = DataType.Number; break;
            case "float": val = DataType.Number; break;
            case "int": val = DataType.Number; break;
            case "long": val = DataType.Number; break;
            case "sbyte": val = DataType.Number; break;
            case "short": val = DataType.Number; break;
            case "uint": val = DataType.Number; break;
            case "ulong": val = DataType.Number; break;
            case "ushort": val = DataType.Number; break;
            default: val = DataType.String; break;       
        }

        return val;
    }
 
}
