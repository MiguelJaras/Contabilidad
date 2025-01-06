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


public partial class Pages_Contabilidad_Opciones_CargaProveedor : System.Web.UI.Page
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


    protected void btnImportar_Click(object sender, EventArgs e)
    {
        try
        {

            if (fuArchivo.FileName == "")
            {
                Anthem.Manager.RegisterStartupScript(Page.GetType(), "msgClosod", "alert('Debe seleccionar un archivo.');", true);
                return;
            }

            string appPath = Request.PhysicalApplicationPath;
            string fileName = fuArchivo.FileName;

            fileName = appPath + "Temp\\" + fileName;
            fuArchivo.PostedFile.SaveAs(fileName);


            LeerExcel(fileName);
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "xyes", "alert('Se proceso la información correctamente.');", true);

        }
        catch (Exception ex)
        {
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "x5", "alert('" + ex.Message + "');", true);
        }


    }


    //nombre de la tabla sin espacios
    //public string CreateScriptTable(string tableName, System.Data.DataTable table, bool bDropTable)
    //{

    //    string sqlsc = "";
    //    if (bDropTable)
    //    {
    //        sqlsc += "IF NOT EXISTS(SELECT object_id FROM SYS.OBJECTS WHERE name = 'tb" + tableName + "' and type = 'u')";
    
    //        sqlsc += "\n BEGIN";
    //    }
    //    sqlsc += "\n CREATE TABLE tb" + tableName + "(";
    //    for (int i = 0; i < table.Columns.Count; i++)
    //    {
           
    //        sqlsc += "\n [C" + (i+1).ToString() + "] Varchar(100) NULL ,";        

    //    }
        
    //    sqlsc = sqlsc.Remove(sqlsc.Length - 1, 1) + ") \n END" ;   
    //    return sqlsc;
    //}


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
                        case "tbPresuntos":
                        
                            cp.Save(ent, "usp_tbPresuntos_insert");
                            RptFacturas();
                            break;
                        case "tbSentenciasFavorables":
                            
                            cp.Save(ent, "usp_tbSentenciasFavorables_insert");
                            break;

                    }

                    //--------------------------

                }


                    //dt.TableName = table;
                    //dt.Columns.Add("dtmFechaAlta", typeof(DateTime));

                    //DateTime thisDay = DateTime.Today;
                    //dt.Columns["dtmFechaAlta"].Expression = '\'' + thisDay.ToString() + '\'';

                    //DataRow dr = dt.Rows[0];

                    //for (int i=0 ; i <dr.ItemArray.Length; i++)
                    //{
                    //    dt.Columns[i].ColumnName = dr[i].ToString();

                    //}

                    //dt.Columns[].ColumnName = "dtmFechaAlta";


                    //dt.Columns[thisDay.ToString()].ColumnName = "dtmFechaAlta";
                    //dt.Rows[0].Delete();
                    //excelRead.Close();


                    //string strTable = CreateScriptTable(table, dt, true);

                    //CargarProveedor cargarProveedor = new CargarProveedor();

                    //cargarProveedor.CreateTable(strTable);

                    //cargarProveedor.ImportExcel(dt);

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }

    public void RptFacturas()
    {
        string strServerName = "http://" + HttpContext.Current.Request.ServerVariables["SERVER_NAME"].ToString() + ":" + HttpContext.Current.Request.ServerVariables["SERVER_PORT"].ToString() + "/Contabilidad/Utils/CRViewerNoParameters.aspx";
        string strQueryString = string.Empty;
        strQueryString = "?type=pdf";
        strQueryString += "&report=Pages/Reportes/Facturas/FacturasElecSP.rpt";
        strQueryString += "&db=dbMarfil";
        //strQueryString += "&Titulos=ContraRecibo";

        strQueryString = strQueryString.Replace("'", "|");
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "rpt", "window.open('" + strServerName + strQueryString + "');", true);
    }

    
}