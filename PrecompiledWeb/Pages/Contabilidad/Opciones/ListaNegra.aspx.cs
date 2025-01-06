using System;
using System.Web.UI.WebControls;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.IO;
using System.Data;
using System.Data.OleDb;
using System.Data.SqlClient;
using System.Configuration;
using System.Collections;
using System.Web.Security;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using Excel;
using System.Text;
using System.Globalization;
using System.Threading;
using Contabilidad.Bussines;
using Contabilidad.DataAccess;
using Contabilidad.Entity;
using System.Windows.Forms;
using DocumentFormat.OpenXml.Spreadsheet;
using NPOI.SS.UserModel;
using NPOI.XSSF.UserModel; // Para archivos .xlsx
using NPOI.HSSF.UserModel; // Para archivos .xls
using OfficeOpenXml;
using CarlosAg.ExcelXmlWriter;
public partial class Pages_Contabilidad_Opciones_ListaNegra : System.Web.UI.Page
{
    Pages_Base toolbar;

    protected void Page_Load(object sender, EventArgs e)
    {
        toolbar = (Pages_Base)this.Master;
        Anthem.Manager.Register(this);

    }

    protected void Page_PreRender(object sender, EventArgs e)
    {
        toolbar.Save(false);
        toolbar.List(false);
        toolbar.Print(false);
        toolbar.New(false);
        toolbar.Exportar(false);
        toolbar.Email(false);
        toolbar.Delete(false);
    }


    protected void btnGuardar_Click(object sender, EventArgs e)
    {

        try
        {
            //MessageBox.Show("paso? 1");
            if (fuArchivo.FileName == "")
            {
                Anthem.Manager.RegisterStartupScript(Page.GetType(), "msgClosod", "alert('Debe seleccionar un archivo.');", true);
                return;
            }

            string appPath = Request.PhysicalApplicationPath;
            string fileName = fuArchivo.FileName;

            fileName = appPath + "Temp\\" + fileName;
            fuArchivo.PostedFile.SaveAs(fileName);
          
            string newfile = EliminarRegistros(fileName);
            txt(fileName);
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "xyes", "alert('Se proceso la información correctamente.');", true);

        }
        catch (Exception ex)
        {
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "x5", "alert('" + ex.Message + "');", true);
        }


    }



    private void LeerExcel(string path)
    {


        using (FileStream stream = File.Open(path, FileMode.Open, FileAccess.Read))
        {
            try
            {
                System.Threading.Thread.CurrentThread.CurrentCulture = new CultureInfo("eS-Mx");
                FileInfo file = new FileInfo(path);
                IExcelDataReader excelRead;

                if (file.Extension.Equals(".xls"))
                    excelRead = ExcelReaderFactory.CreateBinaryReader(stream);

                else if (file.Extension.Equals(".xlsx"))
                    excelRead = ExcelReaderFactory.CreateOpenXmlReader(stream);
                else
                    throw new Exception("Invalid FileName");


                string table = "tb" + Path.GetFileNameWithoutExtension(file.Name);


                DataSet ds = excelRead.AsDataSet();
                DataTable dt = ds.Tables[0];

                Entity_CargarProveedor ent = new Entity_CargarProveedor();
                DataRow dr;
                CargarProveedor cp1 = new CargarProveedor();
                cp1.Del(table);
                cp1 = null;

                for (int i = 1; i < dt.Rows.Count; i++)
                {

                    dr = dt.Rows[i];

                    ent.strC1 = dr[0].ToString();
                    ent.strC2 = dr[1].ToString();
                    ent.strC3 = dr[2].ToString();
                    ent.strC4 = dr[3].ToString();
                    ent.strC5 = dr[4].ToString();
                    ent.strC6 = dr[5].ToString();
                    ent.strC7 = dr[6].ToString();
                    ent.strC8 = dr[7].ToString();
                    ent.strC9 = dr[8].ToString();
                    ent.strC10 = dr[9].ToString();
                    ent.strC11 = dr[10].ToString();
                    ent.strC12 = dr[11].ToString();
                    ent.strC13 = dr[12].ToString();
                    ent.strC14 = dr[13].ToString();
                    ent.strC15 = dr[14].ToString();
                    ent.strC16 = dr[15].ToString();
                    ent.strC17 = dr[16].ToString();
                    ent.strC18 = dr[17].ToString();

                    CargarProveedor cp = new CargarProveedor();

                    switch (table)
                    {

                        case "tbDesvirtuados":

                            cp.Save(ent, "usp_tbDesvirtuados_insert");
                            break;
                        case "tbDefinitivos":

                            cp.Save(ent, "usp_tbDefinitivos_insert");
                            break;
                        case "tbSentenciasFavorables":

                            cp.Save(ent, "usp_tbSentenciasFavorables_insert");
                            break;

                    }

                    //--------------------------

                }

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

    }

    //private void txt(string path)
    //{
    //    string result;

    //    string strNombre = "";
    //    string strApellidoPaterno = "";
    //    string strApellidoMaterno = "";
    //    string strNombreCompleto = "";

    //    try
    //    {
    //        DataRow dr;
    //        ExcelPruebas Registro = new ExcelPruebas();

    //        IExcelDataReader excelReader;
    //        FileStream stream = File.Open(path, FileMode.Open, FileAccess.Read);
    //        try
    //        {
    //            excelReader = ExcelReaderFactory.CreateOpenXmlReader(stream);
    //        }
    //        catch
    //        {
    //            excelReader = ExcelReaderFactory.CreateBinaryReader(stream);
    //        }

    //        DataSet ds = excelReader.AsDataSet();
    //        DataTable dt = ds.Tables[0];
    //        excelReader.Close();

    //        for (int i = 0; i < dt.Rows.Count; i++)
    //        {
    //            dr = dt.Rows[i];

    //            if (i != 0)
    //            {

    //                if (dr.IsNull(2) && dr.IsNull(3)) { strNombre = " "; }
    //                else { strNombre = dr[2].ToString() + " " + dr[3].ToString(); }

    //                if (dr.IsNull(4)) { strApellidoPaterno = " "; }
    //                else { strApellidoPaterno = dr[4].ToString(); }

    //                if (dr.IsNull(5)) { strApellidoMaterno = " "; }
    //                else { strApellidoMaterno = dr[5].ToString(); }

    //                if (dr.IsNull(6)) { strNombreCompleto = " "; }
    //                else { strNombreCompleto = dr[6].ToString(); }


    //                string strRes = "";
    //                strRes = Registro.Save(strNombre, strApellidoPaterno, strApellidoMaterno, strNombreCompleto);

    //            }


    //        }

    //        fuArchivo.Dispose();
    //        //fuArchivo.UpdateAfterCallBack = true;
    //        Anthem.Manager.RegisterStartupScript(Page.GetType(), "msgSave", "Buscar(); alert('La informacion se proceso correctamente.');", true);

    //    }
    //    catch (Exception e)
    //    {
    //        Anthem.Manager.RegisterStartupScript(Page.GetType(), "msgErr", "alert('" + e.Message + "');", true);
    //        Console.WriteLine(e.Message);
    //    }
    //}

    static string EliminarRegistros(string filePath)
    {

        // Abrir el archivo Excel
        IWorkbook workbook;
        using (FileStream file = new FileStream(filePath, FileMode.Open, FileAccess.Read))
        {
            // Para archivos .xlsx
            workbook = new XSSFWorkbook(file);

            // Si fuera un archivo .xls (Excel 97-2003), usa HSSFWorkbook
            // workbook = new HSSFWorkbook(file);
        }

        // Obtener la primera hoja (puedes cambiar el índice o nombre)
        ISheet sheet = workbook.GetSheetAt(0);

        // Eliminar las primeras 12 filas
        for (int rowIndex = 6; rowIndex <=0 ; rowIndex--) // Empezar desde la fila 12 y bajar
        {
            IRow row = sheet.GetRow(rowIndex);
            //if (row != null)
            //{
            sheet.RemoveRow(row);
            //}
        }
        string newFilePath = Path.Combine(Path.GetDirectoryName(filePath),
                         Path.GetFileNameWithoutExtension(filePath) + "_modificado" +
                         Path.GetExtension(filePath));

        // Guardar los cambios en el archivo Excel
        using (FileStream fileOut = new FileStream(newFilePath, FileMode.Create, FileAccess.Write))
        {
            workbook.Write(fileOut);
        }


        return newFilePath;
    }

    private void txt(string filepath)
    {
        string result;

        string strNombre = "";
        string strApellidoPaterno = "";
        string strApellidoMaterno = "";
        string strNombreCompleto = "";


        try
        {
            DataRow dr;
            ExcelPruebas Registro = new ExcelPruebas();

            IExcelDataReader excelReader;
            FileStream stream = File.Open(filepath, FileMode.Open, FileAccess.Read);
            try
            {
                // Crear el lector dependiendo del formato del archivo
                excelReader = ExcelReaderFactory.CreateOpenXmlReader(stream); // Para .xlsx
            }
            catch
            {
                excelReader = ExcelReaderFactory.CreateBinaryReader(stream); // Para .xls
            }

            DataSet ds = excelReader.AsDataSet(); // Cargar el archivo Excel en un DataSet
            DataTable dt = ds.Tables[0]; // Trabajar con la primera hoja del archivo Excel
            excelReader.Close(); // Cerrar el lector

            int value = 0;
            string strValue = "";
            // Ignorar las primeras 5 filas del DataTable y comenzar desde la fila 6
            for (int i = 5; i < dt.Rows.Count; i++) // Cambiado el inicio del for a 5 para ignorar las primeras 5 filas
            {
                dr = dt.Rows[i]; // Obtener la fila actual
                strValue = dt.Rows[i][1].ToString();
                Int32.TryParse(strValue,out value);
                // Procesar los datos si la fila no es nula
                if (value > 0)
                {
                    strNombre = dr.IsNull(2) && dr.IsNull(3) ? " " : dr[2].ToString() + " " + dr[3].ToString();
                    strApellidoPaterno = "";
                    strApellidoMaterno = "";
                    strNombreCompleto = dr.IsNull(2) ? " " : dr[2].ToString();
                    System.IO.File.AppendAllText("C:\\Users\\sistemas03\\Desktop\\Codigos\\Contabilidad\\Contabilidad\\ruta_del_archivo.txt", strNombre + "   " + strNombreCompleto+ Environment.NewLine);
                    // Llamada al método Save() para almacenar los datos
                    //string strRes = Registro.Save(strNombre, strApellidoPaterno, strApellidoMaterno, strNombreCompleto);
                }
            }

            fuArchivo.Dispose();
            // fuArchivo.UpdateAfterCallBack = true;
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "msgSave", "Buscar(); alert('La informacion se proceso correctamente.');", true);

        }
        catch (Exception e)
        {
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "msgErr", "alert('" + e.Message + "');", true);
            Console.WriteLine(e.Message);
        }
    }
}
    // Lee el archivo Excel

// }

//private void txt(string filepath)
//{
//    Workbook wb = new Workbook("excel.xlsx");

//    // Obtener todas las hojas de trabajo
//    WorksheetCollection collection = wb.Worksheets;

//    // Recorra todas las hojas de trabajo
//    for (int worksheetIndex = 0; worksheetIndex < collection.Count; worksheetIndex++)
//    {

//        // Obtener hoja de trabajo usando su índice
//        Worksheet worksheet = collection[worksheetIndex];

//        // Imprimir el nombre de la hoja de trabajo
//        Console.WriteLine("Worksheet: " + worksheet.Name);

//        // Obtener el número de filas y columnas
//        int rows = worksheet.Cells.MaxDataRow;
//        int cols = worksheet.Cells.MaxDataColumn;

//        // Bucle a través de filas
//        for (int i = 0; i < rows; i++)
//        {

//            // Recorra cada columna en la fila seleccionada
//            for (int j = 0; j < cols; j++)
//            {
//                // Valor de la celda de impresión
//                Console.Write(worksheet.Cells[i, j].Value + " | ");
//            }
//            // Salto de línea de impresión
//            Console.WriteLine(" ");
//        }
//    }
//}