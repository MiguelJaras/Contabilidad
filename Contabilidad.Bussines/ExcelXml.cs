using System;
using System.Data;
using System.IO;
using CarlosAg.ExcelXmlWriter;
using Contabilidad.Entity;
using Contabilidad.Bussines;
//using Newtonsoft.Json;


//namespace PreciosUnitarios.App_Code
//{
namespace Contabilidad.Bussines
{
    public class ExcelXml
    {
        public ExcelXml()
        {

        }
        public void ExportExcel(Stream filename, string[] parameters, int reporte)
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

            switch (reporte)
            {
                case 3://case 1:
                    ER(workbook.Worksheets, parameters.GetValue(1).ToString(), parameters.GetValue(2).ToString(), parameters.GetValue(3).ToString());
                    break;

            }

            workbook.Save(filename);
            workbook = null;
        }

        private string[] rtnData;    
        public void ER(WorksheetCollection sheets, string intColonia, string intSector, string intObra)
        {
            DataTable dt;
            DataRow drInsumos;
            string fecha = DateTime.Now.ToString();
            string colonias = Colonias(intObra);
            string sector = Sector(intObra);
            string Numero = Casas(intObra);
            string strObras = Obras(intObra);

            Worksheet worksheet = sheets.Add("Analisis");
            worksheet.Table.Columns.Add(50);//tipo
            worksheet.Table.Columns.Add(50);//grupo
            worksheet.Table.Columns.Add(70);//insumo
            worksheet.Table.Columns.Add(100);//desc_tipo
            worksheet.Table.Columns.Add(100);//desc_grupo
            worksheet.Table.Columns.Add(200);//descripcion        				
            worksheet.Table.Columns.Add(50);//unidad
            worksheet.Table.Columns.Add(70);//precio_ek

            worksheet.Table.Columns.Add(70);//Cantidad
            worksheet.Table.Columns.Add(70);//Ctd/Casa
            worksheet.Table.Columns.Add(70);//Importe

            worksheet.Table.Columns.Add(70);//Cantidad
            worksheet.Table.Columns.Add(70);//Ctd/Casa
            worksheet.Table.Columns.Add(70);//Importe

            worksheet.Table.Columns.Add(70);//Cantidad
            worksheet.Table.Columns.Add(70);//Ctd/Casa
            worksheet.Table.Columns.Add(70);//Importe

            worksheet.Table.Columns.Add(70);//% Dif
            worksheet.Table.Columns.Add(70);//IVA e Ind Marfil

            worksheet.Table.Columns.Add(70);//Importe Real
            worksheet.Table.Columns.Add(70);//Ajuste
            worksheet.Table.Columns.Add(70);//Ajuste

            WorksheetRow worksheetBlank1 = worksheet.Table.Rows.Add();

            worksheetBlank1.Cells.Add("", DataType.String, "Default");
            worksheetBlank1.Cells.Add("Colonia", DataType.String, "Default");
            worksheetBlank1.Cells.Add(colonias, DataType.String, "Default").MergeAcross = 1;
            worksheetBlank1.Cells.Add("", DataType.String, "Default");
            worksheetBlank1.Cells.Add("Obra:", DataType.String, "Default");
            worksheetBlank1.Cells.Add(strObras, DataType.String, "Default").MergeAcross = 6;
            worksheetBlank1.Cells.Add("", DataType.String, "Default");
            worksheetBlank1.Cells.Add("", DataType.String, "Default");
            worksheetBlank1.Cells.Add("", DataType.String, "Default");
            worksheetBlank1.Cells.Add("", DataType.String, "Default");
            worksheetBlank1.Cells.Add("", DataType.String, "Default");
            worksheetBlank1.Cells.Add("", DataType.String, "Default");
            worksheetBlank1.Cells.Add("", DataType.String, "Default");

            WorksheetRow worksheetBlankCol = worksheet.Table.Rows.Add();

            worksheetBlankCol.Cells.Add("", DataType.String, "Default");
            worksheetBlankCol.Cells.Add("Sector", DataType.String, "Default");
            worksheetBlankCol.Cells.Add(sector, DataType.String, "Default").MergeAcross = 1;
            worksheetBlankCol.Cells.Add("", DataType.String, "Default");
            worksheetBlankCol.Cells.Add("Numero de casas:", DataType.String, "Default");
            worksheetBlankCol.Cells.Add(Numero, DataType.String, "Default").MergeAcross = 6;
            worksheetBlankCol.Cells.Add("", DataType.String, "Default");
            worksheetBlankCol.Cells.Add("", DataType.String, "Default");
            worksheetBlankCol.Cells.Add("", DataType.String, "Default");
            worksheetBlankCol.Cells.Add("", DataType.String, "Default");
            worksheetBlankCol.Cells.Add("", DataType.String, "Default");
            worksheetBlankCol.Cells.Add("", DataType.String, "Default");
            worksheetBlankCol.Cells.Add("", DataType.String, "Default");

            WorksheetRow worksheetBlankFec = worksheet.Table.Rows.Add();

            worksheetBlankFec.Cells.Add("", DataType.String, "Default");
            worksheetBlankFec.Cells.Add("Fecha:", DataType.String, "Default");
            worksheetBlankFec.Cells.Add(fecha, DataType.String, "Default").MergeAcross = 1;
            worksheetBlankFec.Cells.Add("", DataType.String, "Default");
            worksheetBlankFec.Cells.Add("", DataType.String, "Default");
            worksheetBlankFec.Cells.Add("", DataType.String, "Default").MergeAcross = 6;
            worksheetBlankFec.Cells.Add("", DataType.String, "Default");
            worksheetBlankFec.Cells.Add("", DataType.String, "Default");
            worksheetBlankFec.Cells.Add("", DataType.String, "Default");
            worksheetBlankFec.Cells.Add("", DataType.String, "Default");
            worksheetBlankFec.Cells.Add("", DataType.String, "Default");
            worksheetBlankFec.Cells.Add("", DataType.String, "Default");
            worksheetBlankFec.Cells.Add("", DataType.String, "Default");

            WorksheetRow worksheetBlank2 = worksheet.Table.Rows.Add();

            worksheetBlank2.Cells.Add("", DataType.String, "Default");
            worksheetBlank2.Cells.Add("", DataType.String, "Default");
            worksheetBlank2.Cells.Add("", DataType.String, "Default");
            worksheetBlank2.Cells.Add("", DataType.String, "Default");
            worksheetBlank2.Cells.Add("", DataType.String, "Default");
            worksheetBlank2.Cells.Add("", DataType.String, "Default");
            worksheetBlank2.Cells.Add("", DataType.String, "Default");
            worksheetBlank2.Cells.Add("", DataType.String, "Default");
            worksheetBlank2.Cells.Add("", DataType.String, "Default");
            worksheetBlank2.Cells.Add("", DataType.String, "Default");
            worksheetBlank2.Cells.Add("", DataType.String, "Default");
            worksheetBlank2.Cells.Add("", DataType.String, "Default");
            worksheetBlank2.Cells.Add("", DataType.String, "Default");
            worksheetBlank2.Cells.Add("", DataType.String, "Default");
            worksheetBlank2.Cells.Add("", DataType.String, "Default");
            worksheetBlank2.Cells.Add("", DataType.String, "Default");
            worksheetBlank2.Cells.Add("", DataType.String, "Default");
            worksheetBlank2.Cells.Add("", DataType.String, "Default");
            worksheetBlank2.Cells.Add("", DataType.String, "Default");
            worksheetBlank2.Cells.Add("", DataType.String, "Default");
            worksheetBlank2.Cells.Add("", DataType.String, "Default");

            WorksheetRow worksheetHead = worksheet.Table.Rows.Add();
            worksheetHead.Cells.Add("Colonia", DataType.String, "sHeader");
            worksheetHead.Cells.Add("Sector", DataType.String, "sHeader");
            worksheetHead.Cells.Add("Manzana", DataType.String, "sHeader");
            worksheetHead.Cells.Add("Lote", DataType.String, "sHeader");
            worksheetHead.Cells.Add("Obra", DataType.String, "sHeader");
            worksheetHead.Cells.Add("MtsConstr", DataType.String, "sHeader");
            worksheetHead.Cells.Add("MtsTerreno", DataType.String, "sHeader");
            worksheetHead.Cells.Add("Prospecto", DataType.String, "sHeader");
            worksheetHead.Cells.Add("Nombre", DataType.String, "sHeader");
            worksheetHead.Cells.Add("FechaFirma", DataType.String, "sHeader");
            worksheetHead.Cells.Add("FechaUbicacion", DataType.String, "sHeader");
            worksheetHead.Cells.Add("ValorNeto", DataType.String, "sHeader");
            worksheetHead.Cells.Add("Participacion", DataType.String, "sHeader");
            worksheetHead.Cells.Add("VentaUrbanizacion", DataType.String, "sHeader");
            worksheetHead.Cells.Add("VentaEdificacion", DataType.String, "sHeader");
            worksheetHead.Cells.Add("CostoEdificacion", DataType.String, "sHeader");
            worksheetHead.Cells.Add("BardaMedianera", DataType.String, "sHeader");
            worksheetHead.Cells.Add("BardaPerimetral", DataType.String, "sHeader");
            worksheetHead.Cells.Add("TotalEdificacion", DataType.String, "sHeader");
            worksheetHead.Cells.Add("PrecioM2", DataType.String, "sHeader");
            worksheetHead.Cells.Add("Utilidad", DataType.String, "sHeader");
            worksheetHead.Cells.Add("Porcentaje", DataType.String, "sHeader");

            Obra objCO = new Obra();
            dt = objCO.GetTableControlObra(intColonia, intSector, intObra);
            if (dt != null)
            { 
                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    WorksheetRow worksheetRowInsumo = worksheet.Table.Rows.Add();
                    drInsumos = dt.Rows[i];

                    worksheetRowInsumo.Cells.Add(drInsumos["Colonia"].ToString(), DataType.String, "StyleText");
                    worksheetRowInsumo.Cells.Add(drInsumos["Sector"].ToString(), DataType.String, "StyleText");
                    worksheetRowInsumo.Cells.Add(drInsumos["Manzana"].ToString(), DataType.String, "StyleText");
                    worksheetRowInsumo.Cells.Add(drInsumos["Lote"].ToString(), DataType.String, "StyleText");
                    worksheetRowInsumo.Cells.Add(drInsumos["Obra"].ToString(), DataType.String, "StyleText");

                    if (drInsumos["MtsConstr"].ToString() == "")
                        worksheetRowInsumo.Cells.Add("", DataType.String, "StyleCant");
                    else
                        worksheetRowInsumo.Cells.Add(drInsumos["MtsConstr"].ToString(), DataType.Number, "StyleCant");

                    if (drInsumos["MtsTerreno"].ToString() == "")
                        worksheetRowInsumo.Cells.Add("", DataType.String, "StyleCant");
                    else
                        worksheetRowInsumo.Cells.Add(drInsumos["MtsTerreno"].ToString(), DataType.Number, "StyleCant");

                    worksheetRowInsumo.Cells.Add(drInsumos["Prospecto"].ToString(), DataType.String, "StyleText");
                    worksheetRowInsumo.Cells.Add(drInsumos["Nombre"].ToString(), DataType.String, "StyleText");
                    worksheetRowInsumo.Cells.Add(drInsumos["FechaFirma"].ToString(), DataType.String, "StyleText");
                    worksheetRowInsumo.Cells.Add(drInsumos["FechaUbicacion"].ToString(), DataType.String, "StyleText");

                    if (drInsumos["ValorNeto"].ToString() == "" || drInsumos["ValorNeto"].ToString() == "0")
                        worksheetRowInsumo.Cells.Add("", DataType.String, "StyleCant");
                    else
                        worksheetRowInsumo.Cells.Add(drInsumos["ValorNeto"].ToString(), DataType.Number, "StyleCant");


                    if (drInsumos["Participacion"].ToString() == "" || drInsumos["Participacion"].ToString() == "0")
                        worksheetRowInsumo.Cells.Add("", DataType.String, "StyleCant");
                    else
                        worksheetRowInsumo.Cells.Add(drInsumos["Participacion"].ToString(), DataType.Number, "StyleMoney");

                    if (drInsumos["VentaUrbanizacion"].ToString() != "")
                        if (Convert.ToDecimal(drInsumos["VentaUrbanizacion"].ToString()) < 0)
                            worksheetRowInsumo.Cells.Add(drInsumos["VentaUrbanizacion"].ToString(), DataType.Number, "styleTotalN");
                        else
                            worksheetRowInsumo.Cells.Add(drInsumos["VentaUrbanizacion"].ToString(), DataType.Number, "styleTotal");
                    else
                    {
                        if (drInsumos["VentaUrbanizacion"].ToString() == "")
                            worksheetRowInsumo.Cells.Add("", DataType.String, "StyleCant");
                        else
                            worksheetRowInsumo.Cells.Add(drInsumos["VentaUrbanizacion"].ToString(), DataType.Number, "StyleMoney");
                    }
                    if (drInsumos["VentaEdificacion"].ToString() != "")
                        if (Convert.ToDecimal(drInsumos["VentaEdificacion"].ToString()) < 0)
                            worksheetRowInsumo.Cells.Add(drInsumos["VentaEdificacion"].ToString(), DataType.Number, "styleTotalN");
                        else
                            worksheetRowInsumo.Cells.Add(drInsumos["VentaEdificacion"].ToString(), DataType.Number, "styleTotal");
                    else
                    {
                        if (drInsumos["VentaEdificacion"].ToString() == "")
                            worksheetRowInsumo.Cells.Add("", DataType.String, "StyleCant");
                        else
                            worksheetRowInsumo.Cells.Add(drInsumos["VentaEdificacion"].ToString(), DataType.Number, "StyleMoney");
                    }
                    if (drInsumos["CostoEdificacion"].ToString() != "")
                        if (Convert.ToDecimal(drInsumos["CostoEdificacion"].ToString()) < 0)
                            worksheetRowInsumo.Cells.Add(drInsumos["CostoEdificacion"].ToString(), DataType.Number, "styleTotalN");
                        else
                            worksheetRowInsumo.Cells.Add(drInsumos["CostoEdificacion"].ToString(), DataType.Number, "styleTotal");
                    else
                    {
                        if (drInsumos["CostoEdificacion"].ToString() == "")
                            worksheetRowInsumo.Cells.Add("", DataType.String, "StyleCant");
                        else
                            worksheetRowInsumo.Cells.Add(drInsumos["CostoEdificacion"].ToString(), DataType.Number, "StyleMoney");
                    }

                    if (drInsumos["BardaMedianera"].ToString() == "" || drInsumos["BardaMedianera"].ToString() == "0")
                        worksheetRowInsumo.Cells.Add("", DataType.String, "StyleCant");
                    else
                        worksheetRowInsumo.Cells.Add(drInsumos["BardaMedianera"].ToString(), DataType.Number, "StyleCant");

                    if (drInsumos["BardaPerimetral"].ToString() == "" || drInsumos["BardaPerimetral"].ToString() == "0")
                        worksheetRowInsumo.Cells.Add("", DataType.String, "StyleCant");
                    else
                        worksheetRowInsumo.Cells.Add(drInsumos["BardaPerimetral"].ToString(), DataType.Number, "StyleCant");

                    if (drInsumos["Bodegas"].ToString() == "" || drInsumos["Bodegas"].ToString() == "0")
                        worksheetRowInsumo.Cells.Add("", DataType.String, "StyleCant");
                    else
                        worksheetRowInsumo.Cells.Add(drInsumos["Bodegas"].ToString(), DataType.Number, "StyleCant");

                    if (drInsumos["BardaPerimetral"].ToString() == "" || drInsumos["BardaPerimetral"].ToString() == "0")
                        worksheetRowInsumo.Cells.Add("", DataType.String, "StyleCant");
                    else
                        worksheetRowInsumo.Cells.Add(drInsumos["BardaPerimetral"].ToString(), DataType.Number, "StyleCant");

                    if (drInsumos["TotalEdificacion"].ToString() != "")
                        if (Convert.ToDecimal(drInsumos["TotalEdificacion"].ToString()) < 0)
                            worksheetRowInsumo.Cells.Add(drInsumos["TotalEdificacion"].ToString(), DataType.Number, "styleTotalN");
                        else
                            worksheetRowInsumo.Cells.Add(drInsumos["TotalEdificacion"].ToString(), DataType.Number, "styleTotal");
                    else
                    {
                        if (drInsumos["TotalEdificacion"].ToString() == "")
                            worksheetRowInsumo.Cells.Add("", DataType.String, "StyleCant");
                        else
                            worksheetRowInsumo.Cells.Add(drInsumos["TotalEdificacion"].ToString(), DataType.Number, "StyleMoney");
                    }

                    if (drInsumos["PrecioM2"].ToString() != "")
                        if (Convert.ToDecimal(drInsumos["PrecioM2"].ToString()) < 0)
                            worksheetRowInsumo.Cells.Add(drInsumos["PrecioM2"].ToString(), DataType.Number, "styleTotalN");
                        else
                            worksheetRowInsumo.Cells.Add(drInsumos["PrecioM2"].ToString(), DataType.Number, "styleTotal");
                    else
                    {
                        if (drInsumos["PrecioM2"].ToString() == "")
                            worksheetRowInsumo.Cells.Add("", DataType.String, "StyleCant");
                        else
                            worksheetRowInsumo.Cells.Add(drInsumos["PrecioM2"].ToString(), DataType.Number, "StyleMoney");
                    }
                    if (drInsumos["Utilidad"].ToString() != "")
                    {
                        if (Convert.ToDecimal(drInsumos["Utilidad"].ToString()) < 0)
                            worksheetRowInsumo.Cells.Add(drInsumos["Utilidad"].ToString(), DataType.Number, "StyleCantN");
                        else
                        {
                            if (drInsumos["Utilidad"].ToString() == "")
                                worksheetRowInsumo.Cells.Add("", DataType.String, "StyleCant");
                            else
                                worksheetRowInsumo.Cells.Add(drInsumos["Utilidad"].ToString(), DataType.Number, "StyleMoney");
                        }
                    }
                    else
                    {
                        if (drInsumos["Utilidad"].ToString() == "")
                            worksheetRowInsumo.Cells.Add("", DataType.String, "StyleCant");
                        else
                            worksheetRowInsumo.Cells.Add(drInsumos["Utilidad"].ToString(), DataType.Number, "styleTotal");
                    }
                    if (drInsumos["Porcentaje"].ToString() != "")
                    {
                        if (Convert.ToDecimal(drInsumos["Porcentaje"].ToString()) < 0)
                            worksheetRowInsumo.Cells.Add(drInsumos["Porcentaje"].ToString(), DataType.Number, "StyleCantN");
                        else
                        {
                            if (drInsumos["Porcentaje"].ToString() == "")
                                worksheetRowInsumo.Cells.Add("", DataType.String, "StyleCant");
                            else
                                worksheetRowInsumo.Cells.Add(drInsumos["Porcentaje"].ToString(), DataType.Number, "StyleMoney");
                        }
                    }
                    else
                    {
                        if (drInsumos["Porcentaje"].ToString() == "")
                            worksheetRowInsumo.Cells.Add("", DataType.String, "StyleCant");
                        else
                            worksheetRowInsumo.Cells.Add(drInsumos["Porcentaje"].ToString(), DataType.Number, "styleTotal");
                    }
                }
            }
        }

        private string Colonias(string strObras)
        {
            //strObras = strObras.Substring(0, strObras.LastIndexOf(","));
            string value = "";
            //VetecMarfilDO.VetecDALHelper DALHelper;
            //DALHelper = new VetecMarfilDO.VetecDALHelper();


            Colonia objColonia = new Colonia();
            value = objColonia.GetColonias(strObras);
            //value = DALHelper.ExecuteScalarFromQuery("DECLARE @Colonias VARCHAR(300) SELECT  @Colonias = COALESCE(@Colonias + ', ', '') + strNombre FROM tbColonia WHERE intColonia IN(SELECT intColonia FROM tbObra where intObra in("+strObras+")) SELECT @Colonias ").ToString();

            //DALHelper = null;
            return value;
        }

        private string Sector(string strObras)
        {
            //strObras = strObras.Substring(0, strObras.LastIndexOf(","));
            string value = "";
            //VetecMarfilDO.VetecDALHelper DALHelper;
            //DALHelper = new VetecMarfilDO.VetecDALHelper();
            Sector objSector = new Sector();
            value = objSector.GetSectores(strObras);
            //value = DALHelper.ExecuteScalarFromQuery("DECLARE @Colonias VARCHAR(300) SELECT  @Colonias = COALESCE(@Colonias + ', ', '') + strNombre FROM tbSector WHERE intSector IN(SELECT intSector FROM tbObra where intObra in(" + strObras + ")) SELECT @Colonias ").ToString();

            //DALHelper = null;
            return value;
        }

        private string Casas(string strObras)
        {
            //strObras = strObras.Substring(0, strObras.LastIndexOf(","));
            string value = "";
            //VetecMarfilDO.VetecDALHelper DALHelper;
            //DALHelper = new VetecMarfilDO.VetecDALHelper();

            Colonia objCasa = new Colonia();
            value = objCasa.GetCasas(strObras);
            //value = DALHelper.ExecuteScalarFromQuery("SELECT SUM(dblFactor) FROM tbPUfrente WHERE intObra in(" + strObras + ") AND bCasa = 1").ToString();

            //DALHelper = null;
            return value;
        }

        private string Obras(string strObras)
        {
            DataTable dt;
            DataRow dr;
            string value = "";
            Obra objobra = new Obra();
            dt = objobra.GetObrasExcel(strObras);
            if (dt != null)
            {
                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    dr = dt.Rows[i];
                    if (i == dt.Rows.Count - 1)
                        value = value + dr["strClave"].ToString();
                    else
                        value = value + dr["strClave"].ToString() + ", ";
                }
             }
            return value;
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
            //worksheetStyle6.Alignment.Horizontal = StyleHorizontalAlignment.Right;

            WorksheetStyle worksheetStyleR = styles.Add("sPayRed");
            worksheetStyleR.Font.Bold = true;
            //worksheetStyle6.Interior.Color = "Silver";
            worksheetStyleR.Interior.Pattern = StyleInteriorPattern.Solid;
            worksheetStyleR.Font.Size = 8;
            worksheetStyleR.Font.Color = "Red";
            worksheetStyleR.Alignment.Horizontal = StyleHorizontalAlignment.Left;
            worksheetStyleR.Borders.Add(StylePosition.Bottom, LineStyleOption.Continuous, 2).Color = "#F2F8FF";
            worksheetStyleR.Borders.Add(StylePosition.Left, LineStyleOption.Continuous, 1).Color = "#F2F8FF";
            worksheetStyleR.Borders.Add(StylePosition.Right, LineStyleOption.Continuous, 1).Color = "#F2F8FF";
            worksheetStyleR.Borders.Add(StylePosition.Top, LineStyleOption.Continuous, 2).Color = "#F2F8FF";
            worksheetStyleR.NumberFormat = "#,#";

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
            styleTotal.NumberFormat = "$#,##0.00";
            //worksheetStyle6.NumberFormat = "$#,###.####";
            styleTotal.Alignment.Horizontal = StyleHorizontalAlignment.Right;

            WorksheetStyle styleTotal2 = styles.Add("styleTotal2");
            styleTotal2.Font.Bold = true;
            styleTotal2.Interior.Color = "Silver";
            styleTotal2.Interior.Pattern = StyleInteriorPattern.Solid;
            styleTotal2.Font.Size = 8;
            styleTotal2.Font.Color = "Black";
            styleTotal2.Alignment.Horizontal = StyleHorizontalAlignment.Left;
            styleTotal2.Borders.Add(StylePosition.Bottom, LineStyleOption.Continuous, 2).Color = "#F2F8FF";
            styleTotal2.Borders.Add(StylePosition.Left, LineStyleOption.Continuous, 1).Color = "#F2F8FF";
            styleTotal2.Borders.Add(StylePosition.Right, LineStyleOption.Continuous, 1).Color = "#F2F8FF";
            styleTotal2.Borders.Add(StylePosition.Top, LineStyleOption.Continuous, 2).Color = "#F2F8FF";
            styleTotal2.NumberFormat = "$#,##0.00";
            //worksheetStyle6.NumberFormat = "$#,###.####";
            styleTotal2.Alignment.Horizontal = StyleHorizontalAlignment.Right;

            WorksheetStyle styleTotal2Can = styles.Add("styleTotal2Can");
            styleTotal2Can.Font.Bold = true;
            styleTotal2Can.Interior.Color = "Silver";
            styleTotal2Can.Interior.Pattern = StyleInteriorPattern.Solid;
            styleTotal2Can.Font.Size = 8;
            styleTotal2Can.Font.Color = "Black";
            styleTotal2Can.Alignment.Horizontal = StyleHorizontalAlignment.Left;
            styleTotal2Can.Borders.Add(StylePosition.Bottom, LineStyleOption.Continuous, 2).Color = "#F2F8FF";
            styleTotal2Can.Borders.Add(StylePosition.Left, LineStyleOption.Continuous, 1).Color = "#F2F8FF";
            styleTotal2Can.Borders.Add(StylePosition.Right, LineStyleOption.Continuous, 1).Color = "#F2F8FF";
            styleTotal2Can.Borders.Add(StylePosition.Top, LineStyleOption.Continuous, 2).Color = "#F2F8FF";
            styleTotal2Can.NumberFormat = "#,##0.00";
            //worksheetStyle6.NumberFormat = "$#,###.####";
            styleTotal2Can.Alignment.Horizontal = StyleHorizontalAlignment.Right;

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
            styleTotalN.NumberFormat = "$#,##0.00";
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
            StyleMoney.NumberFormat = "$#,##0.00";
            StyleMoney.Alignment.Horizontal = StyleHorizontalAlignment.Right;

            WorksheetStyle StyleMoney3 = styles.Add("StyleMoney3");
            StyleMoney3.Font.Bold = true;
            //StyleMoney.Interior.Color = "Silver";
            StyleMoney3.Interior.Pattern = StyleInteriorPattern.Solid;
            StyleMoney3.Font.Size = 8;
            StyleMoney3.Font.Color = "Black";
            StyleMoney3.Alignment.Horizontal = StyleHorizontalAlignment.Left;
            StyleMoney3.Borders.Add(StylePosition.Bottom, LineStyleOption.Continuous, 2).Color = "#F2F8FF";
            StyleMoney3.Borders.Add(StylePosition.Left, LineStyleOption.Continuous, 1).Color = "#F2F8FF";
            StyleMoney3.Borders.Add(StylePosition.Right, LineStyleOption.Continuous, 1).Color = "#F2F8FF";
            StyleMoney3.Borders.Add(StylePosition.Top, LineStyleOption.Continuous, 2).Color = "#F2F8FF";
            //worksheetStyle6.NumberFormat = "#,#";
            StyleMoney3.NumberFormat = "$#,##0.00000000";
            StyleMoney3.Alignment.Horizontal = StyleHorizontalAlignment.Right;

            WorksheetStyle StyleMoney2 = styles.Add("StyleMoney2");
            StyleMoney2.Font.Bold = true;
            //StyleMoney.Interior.Color = "Silver";
            StyleMoney2.Interior.Pattern = StyleInteriorPattern.Solid;
            StyleMoney2.Font.Size = 8;
            StyleMoney2.Font.Color = "Black";
            StyleMoney2.Alignment.Horizontal = StyleHorizontalAlignment.Left;
            StyleMoney2.Borders.Add(StylePosition.Bottom, LineStyleOption.Continuous, 2).Color = "#F2F8FF";
            StyleMoney2.Borders.Add(StylePosition.Left, LineStyleOption.Continuous, 1).Color = "#F2F8FF";
            StyleMoney2.Borders.Add(StylePosition.Right, LineStyleOption.Continuous, 1).Color = "#F2F8FF";
            StyleMoney2.Borders.Add(StylePosition.Top, LineStyleOption.Continuous, 2).Color = "#F2F8FF";
            //worksheetStyle6.NumberFormat = "#,#";
            StyleMoney2.NumberFormat = "$#,##0.00";
            StyleMoney2.Alignment.Horizontal = StyleHorizontalAlignment.Right;

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
            StyleMoneyN.NumberFormat = "$#,##0.00";
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
            StyleCant.NumberFormat = "#,##0.00";
            StyleCant.Alignment.Horizontal = StyleHorizontalAlignment.Right;

            WorksheetStyle StyleCant2 = styles.Add("StyleCant2");
            StyleCant2.Font.Bold = true;
            //StyleCant.Interior.Color = "Silver";
            StyleCant2.Interior.Pattern = StyleInteriorPattern.Solid;
            StyleCant2.Font.Size = 8;
            StyleCant2.Font.Color = "Black";
            StyleCant2.Alignment.Horizontal = StyleHorizontalAlignment.Left;
            StyleCant2.Borders.Add(StylePosition.Bottom, LineStyleOption.Continuous, 2).Color = "#F2F8FF";
            StyleCant2.Borders.Add(StylePosition.Left, LineStyleOption.Continuous, 1).Color = "#F2F8FF";
            StyleCant2.Borders.Add(StylePosition.Right, LineStyleOption.Continuous, 1).Color = "#F2F8FF";
            StyleCant2.Borders.Add(StylePosition.Top, LineStyleOption.Continuous, 2).Color = "#F2F8FF";
            StyleCant2.NumberFormat = "#,##0.00";
            StyleCant2.Alignment.Horizontal = StyleHorizontalAlignment.Right;

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

        public void MOSUBFRENTE(WorksheetCollection sheets, string intObra)
        {
            DataTable dt;
            DataTable dtFrentes;
            DataTable dtPartidas;
            DataTable dtInsumos;
            DataRow drFrentes;
            DataRow drPartida;
            DataRow drInsumos;
            decimal importe;
            decimal cantidad;
            string fecha = DateTime.Now.ToString();

            dtFrentes = Frentes(intObra);
            dtPartidas = Partidas(intObra);

            Worksheet worksheet = sheets.Add("MO y SUB " + intObra.ToString());
            worksheet.Table.Columns.Add(50);//tipo
            worksheet.Table.Columns.Add(50);//cons
            worksheet.Table.Columns.Add(50);//tarjeta
            worksheet.Table.Columns.Add(200);//desc_grupo  
            worksheet.Table.Columns.Add(50);//Insumo
            worksheet.Table.Columns.Add(100);//desc_grupo    				
            worksheet.Table.Columns.Add(50);//unidad
            worksheet.Table.Columns.Add(70);//precio

            for (int i = 0; i < dtFrentes.Rows.Count; i++)
            {
                worksheet.Table.Columns.Add(70);//% Dif
                worksheet.Table.Columns.Add(70);//IVA e Ind Marfil
            }

            WorksheetRow worksheetFrente = worksheet.Table.Rows.Add();

            worksheetFrente.Cells.Add("", DataType.String, "sHeader2");
            worksheetFrente.Cells.Add("", DataType.String, "sHeader2");
            worksheetFrente.Cells.Add("", DataType.String, "sHeader2");
            worksheetFrente.Cells.Add("", DataType.String, "sHeader2");
            worksheetFrente.Cells.Add("", DataType.String, "sHeader2");
            worksheetFrente.Cells.Add("", DataType.String, "sHeader2");
            worksheetFrente.Cells.Add("", DataType.String, "sHeader2");
            worksheetFrente.Cells.Add("", DataType.String, "sHeader2");

            for (int f = 0; f < dtFrentes.Rows.Count; f++)
            {
                drFrentes = dtFrentes.Rows[f];
                worksheetFrente.Cells.Add(drFrentes["strClave"].ToString(), DataType.String, "sHeader2").MergeAcross = 1;
            }

            WorksheetRow worksheetTitle = worksheet.Table.Rows.Add();

            worksheetTitle.Cells.Add("TIPO", DataType.String, "sHeader");
            worksheetTitle.Cells.Add("CONS", DataType.String, "sHeader");
            worksheetTitle.Cells.Add("TARJETA", DataType.String, "sHeader");
            worksheetTitle.Cells.Add("DESC. TARJETA", DataType.String, "sHeader");
            worksheetTitle.Cells.Add("INSUMO", DataType.String, "sHeader");
            worksheetTitle.Cells.Add("DESCRIPCION", DataType.String, "sHeader");
            worksheetTitle.Cells.Add("U", DataType.String, "sHeader");
            worksheetTitle.Cells.Add("PRECIO", DataType.String, "sHeader");

            for (int j = 0; j < dtFrentes.Rows.Count; j++)
            {
                worksheetTitle.Cells.Add("CANTIDAD", DataType.String, "sHeader");
                worksheetTitle.Cells.Add("IMPORTE", DataType.String, "sHeader");
            }

            for (int k = 0; k < dtPartidas.Rows.Count; k++)
            {
                drPartida = dtPartidas.Rows[k];

                WorksheetRow worksheetPartida = worksheet.Table.Rows.Add();

                worksheetPartida.Cells.Add("", DataType.String, "Default");
                worksheetPartida.Cells.Add("Partida:", DataType.String, "Default");
                worksheetPartida.Cells.Add(drPartida["strClave"].ToString(), DataType.String, "Default").MergeAcross = 6;
                worksheetPartida.Cells.Add("", DataType.String, "Default");
                worksheetPartida.Cells.Add("", DataType.String, "Default");
                worksheetPartida.Cells.Add("", DataType.String, "Default");
                worksheetPartida.Cells.Add("", DataType.String, "Default");
                worksheetPartida.Cells.Add("", DataType.String, "Default");

                //VetecMarfilDO.VetecDALHelper DALHelper;
                //DALHelper = new VetecMarfilDO.VetecDALHelper();
                Obra objObraAC = new Obra();
                dt = objObraAC.GetTableArticuloControlRep(intObra, drPartida["intPartida"].ToString());

                //dt = DALHelper.GetTableFromQuery("usp_tbPUTarjetaArticuloControl_Rep_MOSUB " + intObra.ToString() + "," + drPartida["intPartida"].ToString());

                //DALHelper = null;

                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    WorksheetRow worksheetRowInsumo = worksheet.Table.Rows.Add();
                    drInsumos = dt.Rows[i];

                    worksheetRowInsumo.Cells.Add(drInsumos["Tipo"].ToString(), DataType.String, "StyleText");
                    worksheetRowInsumo.Cells.Add(drInsumos["CONS"].ToString(), DataType.String, "StyleText");
                    worksheetRowInsumo.Cells.Add(drInsumos["Tarjeta"].ToString(), DataType.String, "StyleText");
                    worksheetRowInsumo.Cells.Add(drInsumos["DescTarjeta"].ToString(), DataType.String, "StyleText");
                    worksheetRowInsumo.Cells.Add(drInsumos["Insumo"].ToString(), DataType.String, "StyleText");
                    worksheetRowInsumo.Cells.Add(drInsumos["Descripcion"].ToString(), DataType.String, "StyleText");
                    worksheetRowInsumo.Cells.Add(drInsumos["M"].ToString(), DataType.String, "StyleText");
                    worksheetRowInsumo.Cells.Add(drInsumos["Precio"].ToString(), DataType.String, "StyleCant");

                    for (int j = 0; j < dtFrentes.Rows.Count; j++)
                    {
                        drFrentes = dtFrentes.Rows[j];

                        if (drInsumos["Cantidad" + drFrentes["strClave"].ToString()].ToString() != "0.000000")
                        {
                            worksheetRowInsumo.Cells.Add(drInsumos["Cantidad" + drFrentes["strClave"].ToString()].ToString(), DataType.String, "StyleCant");
                            worksheetRowInsumo.Cells.Add(drInsumos["Importe" + drFrentes["strClave"].ToString()].ToString(), DataType.String, "StyleCant");
                        }
                        else
                        {
                            worksheetRowInsumo.Cells.Add("-", DataType.String, "StyleCant");
                            worksheetRowInsumo.Cells.Add("-", DataType.String, "StyleCant");
                        }
                    }
                    //worksheetRowInsumo.Cells.Add(drInsumos["DifXCasa"].ToString(), DataType.Number, "StyleCant");         
                }

                WorksheetRow worksheetPartida2 = worksheet.Table.Rows.Add();

                worksheetPartida2.Cells.Add("", DataType.String, "Default");
                worksheetPartida2.Cells.Add("", DataType.String, "Default");
                worksheetPartida2.Cells.Add("", DataType.String, "Default").MergeAcross = 6;
                worksheetPartida2.Cells.Add("", DataType.String, "Default");
                worksheetPartida2.Cells.Add("", DataType.String, "Default");
                worksheetPartida2.Cells.Add("", DataType.String, "Default");
                worksheetPartida2.Cells.Add("", DataType.String, "Default");
                worksheetPartida2.Cells.Add("", DataType.String, "Default");
            }

            worksheet.Options.Selected = true;
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
        }

        public void TarjetaPartida(WorksheetCollection sheets, string intObra)
        {
            DataTable dt;
            DataTable dtFrentes;
            DataTable dtPartidas;
            DataTable dtInsumos;
            DataRow drFrentes;
            DataRow drPartida;
            DataRow drInsumos;
            string fecha = DateTime.Now.ToString();

            dtFrentes = Frentes(intObra);
            dtPartidas = Partidas(intObra);

            Worksheet worksheet = sheets.Add("Tarjetas " + intObra.ToString());
            worksheet.Table.Columns.Add(50);//cons
            worksheet.Table.Columns.Add(50);//tarjeta
            worksheet.Table.Columns.Add(200);//desc_grupo         
            worksheet.Table.Columns.Add(70);//precio

            for (int i = 0; i < dtFrentes.Rows.Count; i++)
            {
                worksheet.Table.Columns.Add(70);//% Dif
                worksheet.Table.Columns.Add(70);//IVA e Ind Marfil
            }

            WorksheetRow worksheetFrente = worksheet.Table.Rows.Add();

            worksheetFrente.Cells.Add("", DataType.String, "sHeader2");
            worksheetFrente.Cells.Add("", DataType.String, "sHeader2");
            worksheetFrente.Cells.Add("", DataType.String, "sHeader2");
            worksheetFrente.Cells.Add("", DataType.String, "sHeader2");

            for (int f = 0; f < dtFrentes.Rows.Count; f++)
            {
                drFrentes = dtFrentes.Rows[f];
                worksheetFrente.Cells.Add(drFrentes["strClave"].ToString(), DataType.String, "sHeader2").MergeAcross = 1;
            }

            WorksheetRow worksheetTitle = worksheet.Table.Rows.Add();

            worksheetTitle.Cells.Add("CONS", DataType.String, "sHeader");
            worksheetTitle.Cells.Add("TARJETA", DataType.String, "sHeader");
            worksheetTitle.Cells.Add("DESC. TARJETA", DataType.String, "sHeader");
            worksheetTitle.Cells.Add("PRECIO", DataType.String, "sHeader");

            for (int j = 0; j < dtFrentes.Rows.Count; j++)
            {
                worksheetTitle.Cells.Add("CANTIDAD", DataType.String, "sHeader");
                worksheetTitle.Cells.Add("IMPORTE", DataType.String, "sHeader");
            }

            for (int k = 0; k < dtPartidas.Rows.Count; k++)
            {
                drPartida = dtPartidas.Rows[k];

                WorksheetRow worksheetPartida = worksheet.Table.Rows.Add();

                worksheetPartida.Cells.Add("", DataType.String, "Default");
                worksheetPartida.Cells.Add("Partida:", DataType.String, "Default");
                worksheetPartida.Cells.Add(drPartida["strClave"].ToString(), DataType.String, "Default").MergeAcross = 2;
                worksheetPartida.Cells.Add("", DataType.String, "Default");
                worksheetPartida.Cells.Add("", DataType.String, "Default");
                worksheetPartida.Cells.Add("", DataType.String, "Default");
                worksheetPartida.Cells.Add("", DataType.String, "Default");
                worksheetPartida.Cells.Add("", DataType.String, "Default");

                Obra objObraTP = new Obra();
                dt = objObraTP.GetTableTrarjetaPartidaRep(intObra, drPartida["intPartida"].ToString());

                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    WorksheetRow worksheetRowInsumo = worksheet.Table.Rows.Add();
                    drInsumos = dt.Rows[i];

                    worksheetRowInsumo.Cells.Add(drInsumos["CONS"].ToString(), DataType.String, "StyleText");
                    worksheetRowInsumo.Cells.Add(drInsumos["Tarjeta"].ToString(), DataType.String, "StyleText");
                    worksheetRowInsumo.Cells.Add(drInsumos["DescTarjeta"].ToString(), DataType.String, "StyleText");
                    worksheetRowInsumo.Cells.Add(drInsumos["Precio"].ToString(), DataType.String, "StyleCant");

                    for (int j = 0; j < dtFrentes.Rows.Count; j++)
                    {
                        drFrentes = dtFrentes.Rows[j];

                        if (drInsumos["Cantidad" + drFrentes["strClave"].ToString()].ToString() != "0.000000")
                        {
                            worksheetRowInsumo.Cells.Add(drInsumos["Cantidad" + drFrentes["strClave"].ToString()].ToString(), DataType.String, "StyleCant");
                            worksheetRowInsumo.Cells.Add(drInsumos["Importe" + drFrentes["strClave"].ToString()].ToString(), DataType.String, "StyleCant");
                        }
                        else
                        {
                            worksheetRowInsumo.Cells.Add("-", DataType.String, "StyleCant");
                            worksheetRowInsumo.Cells.Add("-", DataType.String, "StyleCant");
                        }
                    }       
                }

                WorksheetRow worksheetPartida2 = worksheet.Table.Rows.Add();

                worksheetPartida2.Cells.Add("", DataType.String, "Default");
                worksheetPartida2.Cells.Add("", DataType.String, "Default");
                worksheetPartida2.Cells.Add("", DataType.String, "Default").MergeAcross = 2;
                worksheetPartida2.Cells.Add("", DataType.String, "Default");
                worksheetPartida2.Cells.Add("", DataType.String, "Default");
                worksheetPartida2.Cells.Add("", DataType.String, "Default");
                worksheetPartida2.Cells.Add("", DataType.String, "Default");
                worksheetPartida2.Cells.Add("", DataType.String, "Default");
            }

            worksheet.Options.Selected = true;
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
        }

        private DataTable Frentes(string intObra)
        {
            DataTable dt;
            Obra objFrente = new Obra();
            dt = objFrente.GetFrenteExcel(intObra);
            return dt;
        }

        private DataTable Partidas(string intObra)
        {
            DataTable dt;
            Obra objFrente = new Obra();
            dt = objFrente.GetPartidaExcel(intObra);
            return dt;
        }

        public void Resumen(WorksheetCollection sheets, string obras, string strIva, string strIndirectos, string strFactor, string strProteccion)
        {
            DataTable dt;
            DataRow drInsumos;
            string fecha = DateTime.Now.ToString();
            string colonias = Colonias(obras);
            string sector = Sector(obras);
            string Numero = Casas(obras);
            string strObras = Obras(obras);

            Worksheet worksheet = sheets.Add("Resumen");
            worksheet.Table.Columns.Add(100);//Obra
            worksheet.Table.Columns.Add(80);//No. Casas
            worksheet.Table.Columns.Add(100);//m2 constr.
            worksheet.Table.Columns.Add(100);//Costo Directo
            worksheet.Table.Columns.Add(100);//Tabulador
            worksheet.Table.Columns.Add(100);//Con Inds 20%+ 3%
            worksheet.Table.Columns.Add(100);// $/M2       				
            worksheet.Table.Columns.Add(100);//Costo Directo
            worksheet.Table.Columns.Add(100);//Con Inds 20%+ 3%
            worksheet.Table.Columns.Add(100);// $/M2  
            worksheet.Table.Columns.Add(100);//Costo Inventario
            worksheet.Table.Columns.Add(100);//$/M2

            WorksheetRow worksheetBlank1 = worksheet.Table.Rows.Add();

            worksheetBlank1.Cells.Add("", DataType.String, "sHeader");
            worksheetBlank1.Cells.Add("", DataType.String, "sHeader");
            worksheetBlank1.Cells.Add("", DataType.String, "sHeader");
            worksheetBlank1.Cells.Add("", DataType.String, "sHeader");
            worksheetBlank1.Cells.Add("", DataType.String, "sHeader");
            worksheetBlank1.Cells.Add("PRESUPUESTO .-", DataType.String, "sHeader").MergeAcross = 3;
            worksheetBlank1.Cells.Add("GASTADO REAL .-", DataType.String, "sHeader").MergeAcross = 2;
            worksheetBlank1.Cells.Add("VENTA .-", DataType.String, "sHeader").MergeAcross = 1;

            WorksheetRow worksheetBlankCol = worksheet.Table.Rows.Add();

            worksheetBlankCol.Cells.Add("Obra", DataType.String, "sHeader");
            worksheetBlankCol.Cells.Add("Inicio", DataType.String, "sHeader");
            worksheetBlankCol.Cells.Add("Terminación", DataType.String, "sHeader");
            worksheetBlankCol.Cells.Add("No. Casas", DataType.String, "sHeader");
            worksheetBlankCol.Cells.Add("m2 constr.", DataType.String, "sHeader");
            worksheetBlankCol.Cells.Add("Costo Directo", DataType.String, "sHeader");
            worksheetBlankCol.Cells.Add("Tabulador", DataType.String, "sHeader");
            worksheetBlankCol.Cells.Add("Con Inds 20%", DataType.String, "sHeader");//+ 3%
            worksheetBlankCol.Cells.Add("$/M2  ", DataType.String, "sHeader");
            worksheetBlankCol.Cells.Add("Costo Directo", DataType.String, "sHeader");
            worksheetBlankCol.Cells.Add("Con Inds 20%", DataType.String, "sHeader");
            worksheetBlankCol.Cells.Add("$/M2", DataType.String, "sHeader");
            worksheetBlankCol.Cells.Add("Costo Inventario", DataType.String, "sHeader");
            worksheetBlankCol.Cells.Add("$/M2", DataType.String, "sHeader");

            //WorksheetRow worksheetBlank2 = worksheet.Table.Rows.Add();

            //worksheetBlank2.Cells.Add("", DataType.String, "Default");
            //worksheetBlank2.Cells.Add("", DataType.String, "Default");
            //worksheetBlank2.Cells.Add("", DataType.String, "Default");
            //worksheetBlank2.Cells.Add("", DataType.String, "Default");
            //worksheetBlank2.Cells.Add("", DataType.String, "Default");
            //worksheetBlank2.Cells.Add("", DataType.String, "Default");
            //worksheetBlank2.Cells.Add("", DataType.String, "Default");
            //worksheetBlank2.Cells.Add("", DataType.String, "Default");
            //worksheetBlank2.Cells.Add("", DataType.String, "Default");
            //worksheetBlank2.Cells.Add("", DataType.String, "Default");
            //worksheetBlank2.Cells.Add("", DataType.String, "Default");
            //worksheetBlank2.Cells.Add("", DataType.String, "Default");
            //worksheetBlank2.Cells.Add("", DataType.String, "Default");
            //worksheetBlank2.Cells.Add("", DataType.String, "Default");
            //worksheetBlank2.Cells.Add("", DataType.String, "Default");
            //worksheetBlank2.Cells.Add("", DataType.String, "Default");
            //worksheetBlank2.Cells.Add("", DataType.String, "Default");
            //worksheetBlank2.Cells.Add("", DataType.String, "Default");
            //worksheetBlank2.Cells.Add("", DataType.String, "Default");
            //worksheetBlank2.Cells.Add("", DataType.String, "Default");
            //worksheetBlank2.Cells.Add("", DataType.String, "Default");

            //VetecMarfilDO.VetecDALHelper DALHelper;
            //DALHelper = new VetecMarfilDO.VetecDALHelper();


            Obra objCO = new Obra();
            dt = objCO.GetTableControlObraResumen(obras, strIva, strIndirectos, strFactor, strProteccion);

            //dt = DALHelper.GetTableFromQuery("EXEC usp_tbcontrolobra_ResumenObras '" + obras + "'," + strIva + "," + strIndirectos + "," + strFactor + "," + strProteccion);

            //DALHelper = null;

            for (int i = 0; i < dt.Rows.Count; i++)
            {
                WorksheetRow worksheetRowInsumo = worksheet.Table.Rows.Add();
                drInsumos = dt.Rows[i];

                if (drInsumos["Obra"].ToString() == "TOTAL")
                {
                    worksheetRowInsumo.Cells.Add(drInsumos["Obra"].ToString(), DataType.String, "styleTotal2");
                    worksheetRowInsumo.Cells.Add(drInsumos["Inicio"].ToString(), DataType.String, "styleTotal2");
                    worksheetRowInsumo.Cells.Add(drInsumos["Terminacion"].ToString(), DataType.String, "styleTotal2");
                    worksheetRowInsumo.Cells.Add(drInsumos["Casas"].ToString(), DataType.Number, "styleTotal2Can");
                    worksheetRowInsumo.Cells.Add(drInsumos["M2"].ToString(), DataType.Number, "styleTotal2Can");
                    worksheetRowInsumo.Cells.Add(drInsumos["ImportePresupuesto"].ToString(), DataType.Number, "styleTotal2");
                    worksheetRowInsumo.Cells.Add(drInsumos["Tabulador"].ToString(), DataType.String, "styleTotal2");
                    worksheetRowInsumo.Cells.Add(drInsumos["ImportePresupuestoInd"].ToString(), DataType.Number, "styleTotal2");
                    worksheetRowInsumo.Cells.Add(drInsumos["M2PresupuestoInd"].ToString(), DataType.Number, "styleTotal2Can");
                    worksheetRowInsumo.Cells.Add(drInsumos["ImporteGastado"].ToString(), DataType.Number, "styleTotal2");
                    worksheetRowInsumo.Cells.Add(drInsumos["ImporteGastadoInd"].ToString(), DataType.Number, "styleTotal2");
                    worksheetRowInsumo.Cells.Add(drInsumos["M2GastadoInd"].ToString(), DataType.Number, "styleTotal2Can");
                    worksheetRowInsumo.Cells.Add(drInsumos["ImporteInventario"].ToString(), DataType.Number, "styleTotal2");
                    worksheetRowInsumo.Cells.Add(drInsumos["ImporteInventarioM2"].ToString(), DataType.Number, "styleTotal2Can");
                }
                else
                {
                    worksheetRowInsumo.Cells.Add(drInsumos["Obra"].ToString(), DataType.String, "StyleText");
                    worksheetRowInsumo.Cells.Add(drInsumos["Inicio"].ToString(), DataType.String, "StyleText");
                    worksheetRowInsumo.Cells.Add(drInsumos["Terminacion"].ToString(), DataType.String, "StyleText");
                    worksheetRowInsumo.Cells.Add(drInsumos["Casas"].ToString(), DataType.Number, "StyleCant2");
                    worksheetRowInsumo.Cells.Add(drInsumos["M2"].ToString(), DataType.Number, "StyleCant2");
                    worksheetRowInsumo.Cells.Add(drInsumos["ImportePresupuesto"].ToString(), DataType.Number, "StyleMoney2");
                    worksheetRowInsumo.Cells.Add(drInsumos["Tabulador"].ToString(), DataType.String, "StyleText");
                    worksheetRowInsumo.Cells.Add(drInsumos["ImportePresupuestoInd"].ToString(), DataType.Number, "StyleMoney2");
                    worksheetRowInsumo.Cells.Add(drInsumos["M2PresupuestoInd"].ToString(), DataType.Number, "StyleCant2");
                    worksheetRowInsumo.Cells.Add(drInsumos["ImporteGastado"].ToString(), DataType.Number, "StyleMoney2");
                    worksheetRowInsumo.Cells.Add(drInsumos["ImporteGastadoInd"].ToString(), DataType.Number, "StyleMoney2");
                    worksheetRowInsumo.Cells.Add(drInsumos["M2GastadoInd"].ToString(), DataType.Number, "StyleCant2");
                    worksheetRowInsumo.Cells.Add(drInsumos["ImporteInventario"].ToString(), DataType.Number, "StyleMoney2");
                    worksheetRowInsumo.Cells.Add(drInsumos["ImporteInventarioM2"].ToString(), DataType.Number, "StyleCant2");
                }
            }

            worksheet.Options.Selected = true;
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
        }

        public void Contractual(WorksheetCollection sheets, string obras, string intcontratista)
        {
            DataTable dt;
            DataRow drInsumos;
            string fecha = DateTime.Now.ToString();
            //string colonias = Colonias(obras);
            //string sector = Sector(obras);
            //string Numero = Casas(obras);
            string strObras = Obras(obras);

            Worksheet worksheet = sheets.Add("Control Contractual");
            worksheet.Table.Columns.Add(100);//Obra
            worksheet.Table.Columns.Add(80);//No. Casas
            worksheet.Table.Columns.Add(100);//m2 constr.
            worksheet.Table.Columns.Add(100);//Costo Directo
            worksheet.Table.Columns.Add(100);//Con Inds 20%+ 3%
            worksheet.Table.Columns.Add(100);// $/M2       				
            worksheet.Table.Columns.Add(100);//Costo Directo
            worksheet.Table.Columns.Add(100);//Con Inds 20%+ 3%
            worksheet.Table.Columns.Add(100);// $/M2  
            worksheet.Table.Columns.Add(100);//Costo Inventario
            worksheet.Table.Columns.Add(100);//$/M2

            //WorksheetRow worksheetBlank1 = worksheet.Table.Rows.Add();

            //worksheetBlank1.Cells.Add("", DataType.String, "sHeader");
            //worksheetBlank1.Cells.Add("", DataType.String, "sHeader");
            //worksheetBlank1.Cells.Add("", DataType.String, "sHeader");
            //worksheetBlank1.Cells.Add("PRESUPUESTO .-", DataType.String, "sHeader").MergeAcross = 2;
            //worksheetBlank1.Cells.Add("GASTADO REAL .-", DataType.String, "sHeader").MergeAcross = 2;
            //worksheetBlank1.Cells.Add("VENTA .-", DataType.String, "sHeader").MergeAcross = 1;

            //WorksheetRow worksheetBlankCol = worksheet.Table.Rows.Add();

            //worksheetBlankCol.Cells.Add("Obra", DataType.String, "sHeader");
            //worksheetBlankCol.Cells.Add("No. Casas", DataType.String, "sHeader");
            //worksheetBlankCol.Cells.Add("m2 constr.", DataType.String, "sHeader");
            //worksheetBlankCol.Cells.Add("Costo Directo", DataType.String, "sHeader");
            //worksheetBlankCol.Cells.Add("Con Inds 20%+ 3%", DataType.String, "sHeader");
            //worksheetBlankCol.Cells.Add("$/M2  ", DataType.String, "sHeader");
            //worksheetBlankCol.Cells.Add("Costo Directo", DataType.String, "sHeader");
            //worksheetBlankCol.Cells.Add("Con Inds 20%+ 3%", DataType.String, "sHeader");
            //worksheetBlankCol.Cells.Add("$/M2", DataType.String, "sHeader");
            //worksheetBlankCol.Cells.Add("Costo Inventario", DataType.String, "sHeader");
            //worksheetBlankCol.Cells.Add("$/M2", DataType.String, "sHeader");

            //WorksheetRow worksheetBlank2 = worksheet.Table.Rows.Add();

            //worksheetBlank2.Cells.Add("", DataType.String, "Default");
            //worksheetBlank2.Cells.Add("", DataType.String, "Default");
            //worksheetBlank2.Cells.Add("", DataType.String, "Default");
            //worksheetBlank2.Cells.Add("", DataType.String, "Default");
            //worksheetBlank2.Cells.Add("", DataType.String, "Default");
            //worksheetBlank2.Cells.Add("", DataType.String, "Default");
            //worksheetBlank2.Cells.Add("", DataType.String, "Default");
            //worksheetBlank2.Cells.Add("", DataType.String, "Default");
            //worksheetBlank2.Cells.Add("", DataType.String, "Default");
            //worksheetBlank2.Cells.Add("", DataType.String, "Default");
            //worksheetBlank2.Cells.Add("", DataType.String, "Default");
            //worksheetBlank2.Cells.Add("", DataType.String, "Default");
            //worksheetBlank2.Cells.Add("", DataType.String, "Default");
            //worksheetBlank2.Cells.Add("", DataType.String, "Default");
            //worksheetBlank2.Cells.Add("", DataType.String, "Default");
            //worksheetBlank2.Cells.Add("", DataType.String, "Default");
            //worksheetBlank2.Cells.Add("", DataType.String, "Default");
            //worksheetBlank2.Cells.Add("", DataType.String, "Default");
            //worksheetBlank2.Cells.Add("", DataType.String, "Default");
            //worksheetBlank2.Cells.Add("", DataType.String, "Default");
            //worksheetBlank2.Cells.Add("", DataType.String, "Default");

            //VetecMarfilDO.VetecDALHelper DALHelper;
            //DALHelper = new VetecMarfilDO.VetecDALHelper();

            //dt = DALHelper.GetTableFromQuery("EXEC usp_tbcontrolobra_ResumenObras '" + obras + "'," + strIva + "," + strIndirectos + "," + strFactor + "," + strProteccion);

            //DALHelper = null;

            //for (int i = 0; i < dt.Rows.Count; i++)
            //{
            //    WorksheetRow worksheetRowInsumo = worksheet.Table.Rows.Add();
            //    drInsumos = dt.Rows[i];

            //    if (drInsumos["Obra"].ToString() == "TOTAL")
            //    {
            //        worksheetRowInsumo.Cells.Add(drInsumos["Obra"].ToString(), DataType.String, "styleTotal2");
            //        worksheetRowInsumo.Cells.Add(drInsumos["Casas"].ToString(), DataType.Number, "styleTotal2Can");
            //        worksheetRowInsumo.Cells.Add(drInsumos["M2"].ToString(), DataType.Number, "styleTotal2Can");
            //        worksheetRowInsumo.Cells.Add(drInsumos["ImportePresupuesto"].ToString(), DataType.Number, "styleTotal2");
            //        worksheetRowInsumo.Cells.Add(drInsumos["ImportePresupuestoInd"].ToString(), DataType.Number, "styleTotal2");
            //        worksheetRowInsumo.Cells.Add(drInsumos["M2PresupuestoInd"].ToString(), DataType.Number, "styleTotal2Can");
            //        worksheetRowInsumo.Cells.Add(drInsumos["ImporteGastado"].ToString(), DataType.Number, "styleTotal2");
            //        worksheetRowInsumo.Cells.Add(drInsumos["ImporteGastadoInd"].ToString(), DataType.Number, "styleTotal2");
            //        worksheetRowInsumo.Cells.Add(drInsumos["M2GastadoInd"].ToString(), DataType.Number, "styleTotal2Can");
            //        worksheetRowInsumo.Cells.Add(drInsumos["ImporteInventario"].ToString(), DataType.Number, "styleTotal2");
            //        worksheetRowInsumo.Cells.Add(drInsumos["ImporteInventarioM2"].ToString(), DataType.Number, "styleTotal2Can");
            //    }
            //    else
            //    {
            //        worksheetRowInsumo.Cells.Add(drInsumos["Obra"].ToString(), DataType.String, "StyleText");
            //        worksheetRowInsumo.Cells.Add(drInsumos["Casas"].ToString(), DataType.Number, "StyleCant2");
            //        worksheetRowInsumo.Cells.Add(drInsumos["M2"].ToString(), DataType.Number, "StyleCant2");
            //        worksheetRowInsumo.Cells.Add(drInsumos["ImportePresupuesto"].ToString(), DataType.Number, "StyleMoney2");
            //        worksheetRowInsumo.Cells.Add(drInsumos["ImportePresupuestoInd"].ToString(), DataType.Number, "StyleMoney2");
            //        worksheetRowInsumo.Cells.Add(drInsumos["M2PresupuestoInd"].ToString(), DataType.Number, "StyleCant2");
            //        worksheetRowInsumo.Cells.Add(drInsumos["ImporteGastado"].ToString(), DataType.Number, "StyleMoney2");
            //        worksheetRowInsumo.Cells.Add(drInsumos["ImporteGastadoInd"].ToString(), DataType.Number, "StyleMoney2");
            //        worksheetRowInsumo.Cells.Add(drInsumos["M2GastadoInd"].ToString(), DataType.Number, "StyleCant2");
            //        worksheetRowInsumo.Cells.Add(drInsumos["ImporteInventario"].ToString(), DataType.Number, "StyleMoney2");
            //        worksheetRowInsumo.Cells.Add(drInsumos["ImporteInventarioM2"].ToString(), DataType.Number, "StyleCant2");
            //    }
            //}

            worksheet.Options.Selected = true;
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
        }

        public string[] GetResultados()
        {
            return rtnData;
        }
    }
}
