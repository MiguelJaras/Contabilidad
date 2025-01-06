using Contabilidad.Bussines;
using Contabilidad.Entity;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Data;
using System.Net.Mail;
using System.Text;
using System.Web.Services;
using System.Web.UI;
using HtmlAgilityPack;
using System.IO;
using System.Data.OleDb;
using Excel;
using System.Collections;

public partial class Pages_Opciones_FacturacionEstimacion : System.Web.UI.Page
{
    public string realPath;
    Pages_Base toolbar;
    public StringBuilder dataList;
    public StringBuilder dataColumns;
    public StringBuilder colModel;
    public StringBuilder dataColony;

    protected void Page_Load(object sender, EventArgs e)
    {
        toolbar = (Pages_Base)this.Master;
        toolbar.PageEvent += new HandlerEvent(Me_Event);
        Anthem.Manager.Register(this);
        dataList = new StringBuilder();
        dataColumns = new StringBuilder();
        colModel = new StringBuilder();
        dataColony = new StringBuilder();

        if (!IsPostBack && !IsCallback)
        {
            Year();
            cboEjercicio.SelectedValue = DateTime.Now.Year.ToString();
            Semana();
        }
    }

    protected void Page_PreRender(object sender, EventArgs e)
    {
        JavaScript();        
        toolbar.Print(false);
        toolbar.Exportar(false);
        toolbar.Email(false);
        toolbar.Delete(false);
        toolbar.List(false);
    }
    #region Semana
    private void Semana()
    {
        DataTable dt;
        dt = null;
        Contabilidad.Bussines.FacturasGenerarComisiones fac = new Contabilidad.Bussines.FacturasGenerarComisiones();
        int intAnio = cboEjercicio.SelectedValue.ToString() == "" ? 0 : Convert.ToInt32(cboEjercicio.SelectedValue.ToString());
        dt = fac.GetSemana(intAnio);

        cboSemana.DataSource = dt;
        cboSemana.DataTextField = "intSemana";
        cboSemana.DataValueField = "intSemana";

        cboSemana.DataBind();

        cboSemana.Items.Insert(0, new ListItem("-- Seleccione --", "0"));
        cboSemana.SelectedIndex = 0;
        //cboSemana.UpdateAfterCallBack = true;
    }
    #endregion

    #region Year
    private void Year()
    {
        DataTable dt;
        dt = null;
        Contabilidad.Bussines.FacturasGenerarComisiones fac = new Contabilidad.Bussines.FacturasGenerarComisiones();
        dt = fac.GetAnio();

        cboEjercicio.DataSource = dt;
        cboEjercicio.DataTextField = "intAnio";
        cboEjercicio.DataValueField = "intAnio";

        cboEjercicio.DataBind();

        cboEjercicio.Items.Insert(0, new ListItem("-- Seleccione --", "0"));
        cboEjercicio.SelectedIndex = 0;
        cboEjercicio.UpdateAfterCallBack = true;


    }
    #endregion Year
    private void JavaScript()
    {
        cboSemana.Attributes.Add("onchange", "GetList()");
    }

    #region Event
    void Me_Event(object sender, HandlerArgs args)
    {
        switch (args.Event)
        {
            case Event.Save:
                Charge();
                //Save();
                break;
            case Event.New:
                Clear();
                break;
            case Event.Delete:
                break;
            case Event.Print:
                break;
            case Event.Email:
                break;
            case Event.List:
                break;
            default:
                break;
        }
    }
    #endregion 

    #region Clear
    private void Clear()
    {

        cboEjercicio.SelectedValue = DateTime.Now.Year.ToString();
        cboSemana.SelectedIndex = -1;

        //cboSemana.UpdateAfterCallBack = true;
        cboEjercicio.UpdateAfterCallBack = true;
    }
    #endregion
   
    #region Size
    private string Size(string data)
    {
        string result = "";
        if (data.ToUpper().Contains("FECHA"))
            result = "65";
        else
        {
            if (data.ToUpper().Contains("#"))
                result = "40";
            else
            {
                if (data.ToUpper().Contains("CLIENTE"))
                    result = "200";
                else
                    result = "100";
            }
        }

        return result;
    }
    #endregion

    #region TypeValue
    private string TypeValue(string data)
    {
        string result = "";
        switch (data)
        {
            case "System.String":
                result = "align: 'Left'";
                break;
            case "System.Boolean":
                result = "align: 'Center'";
                break;
            case "System.DateTime":
                result = "align: 'Center'";
                break;
            case "System.Decimal":
                result = "align: 'Right'";
                break;
            case "System.Double":
                result = "align: 'Right'";
                break;
            case "System.Int32":
                result = "align: 'Right'";
                break;
            case "System.Int16":
                result = "align: 'Right'";
                break;
            case "System.Int64":
                result = "align: 'Right'";
                break;
        }
        return result;
    }
    #endregion

    private void Save()
    {
        try
        {
            //FacturasEstimacionesGenerar fac = new FacturasEstimacionesGenerar();
            //Entity_FacturasEstimacionesGenerar obj = new Entity_FacturasEstimacionesGenerar();
            //fac.SaveEnc(obj);

            Anthem.Manager.RegisterStartupScript(Page.GetType(), "Alerta", "alert('Se guardó correctamente.'); GetList();", true);
                
            
        }
        catch (Exception ex)
        {
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "err", "alert('" + ex.Message + "');", true);
        }
    }

    
    [WebMethod]
    public static string[] GetList(int intEjercicio, int intSemana)
    {
        string[] rtnData = new string[2];
        try
        {
            Entity_FacturasEstimacionesGenerar obj = new Entity_FacturasEstimacionesGenerar();
            FacturasEstimacionesGenerar fac = new FacturasEstimacionesGenerar();
            obj.IntSemana = intSemana;
            obj.IntAño = intEjercicio;
            DataTable dt = null;
            dt = fac.List(obj);
            string JSONData = JsonConvert.SerializeObject(dt);
            rtnData[0] = "ok";
            rtnData[1] = JSONData;
        }
        catch
        {
            rtnData[0] = "no";
            rtnData[1] = "[]";
        }
        return rtnData;
    }

    #region Charge
    private void Charge()
    {
        try
        {
            string MsjRes = "";
            int intEjercicio, intSemana;
            string end = (Request.ApplicationPath.EndsWith("/")) ? "" : "/";
            string path = Request.ApplicationPath + end;
            string appPath = Request.PhysicalApplicationPath;

            string usuario = Contabilidad.SEMSession.GetInstance.StrUsuario;
            intEjercicio = cboEjercicio.SelectedValue == "" ? 0 : Convert.ToInt32(cboEjercicio.SelectedValue);
            intSemana = cboSemana.SelectedValue == "" ? 0 : Convert.ToInt32(cboSemana.SelectedValue);


            string fileName = appPath + fuArchivo.FileName; 
            fuArchivo.PostedFile.SaveAs(fileName);
            FileStream stream = File.Open(fileName, FileMode.Open, FileAccess.Read);
            IExcelDataReader excelReader;
            if (fileName.Contains(".xlsx"))
                excelReader = ExcelReaderFactory.CreateOpenXmlReader(stream);
            else
                excelReader = ExcelReaderFactory.CreateBinaryReader(stream);

            excelReader.IsFirstRowAsColumnNames = true;
            DataSet result = excelReader.AsDataSet();
            int intSheets = 0;
            intSheets = result.Tables.Count;

            int j = 0;
            if (result.Tables.Count > 0)
            {
                for (int i = 0; i < intSheets; i++)
                {

                    foreach (DataRow dr in result.Tables[i].Rows)
                    {
                        if (dr["Empresa"].ToString() == "" )
                        {
                            break;
                        }

                        int intEmpresa=0, intCliente=0, intOC=0;
                        decimal DblImporte=0, dblPorcentaje=0;
                        string StrObra="";

                        intEmpresa = dr["Empresa"].ToString().Trim().Replace("\r", "").Replace("$", "").Replace(",", "") == "" ? 0 : Convert.ToInt32(dr["Empresa"].ToString().Trim().Replace("\r", "").Replace("$", "").Replace(",", ""));
                        intCliente = dr["Cliente"].ToString().Trim().Replace("\r", "").Replace("$", "").Replace(",", "") == "" ? 0 : Convert.ToInt32(dr["Cliente"].ToString().Trim().Replace("\r", "").Replace("$", "").Replace(",", ""));
                        intOC = dr["OC"].ToString().Trim().Replace("\r", "").Replace("$", "").Replace(",", "") == "" ? 0 : Convert.ToInt32(dr["OC"].ToString().Trim().Replace("\r", "").Replace("$", "").Replace(",", ""));
                        StrObra = dr["Obra"].ToString().Trim().Replace("\r", "").Replace("$", "").Replace(",", "");
                        DblImporte = dr["Importe"].ToString().Trim().Replace("\r", "").Replace("$", "").Replace(",", "") == "" ? 0 : Convert.ToDecimal(dr["Importe"].ToString().Trim().Replace("\r", "").Replace("$", "").Replace(",", ""));
                        dblPorcentaje = dr["Porcentaje"].ToString().Trim().Replace("\r", "").Replace("$", "").Replace(",", "") == "" ? 0 : Convert.ToDecimal(dr["Porcentaje"].ToString().Trim().Replace("\r", "").Replace("$", "").Replace(",", ""));

                        Entity_FacturasEstimacionesGenerar obj = new Entity_FacturasEstimacionesGenerar();
                        FacturasEstimacionesGenerar fac = new FacturasEstimacionesGenerar();

                        obj.IntEmpresa = intEmpresa;
                        obj.IntCliente= intCliente;
                        obj.IntOC = intOC;
                        obj.StrObra = StrObra;
                        obj.DblImporte= DblImporte;
                        obj.StrUsuario = Contabilidad.SEMSession.GetInstance.StrUsuario;
                        obj.StrMaquina = Contabilidad.SEMSession.GetInstance.StrMaquina;
                        obj.IntSemana = intSemana;
                        obj.IntAño = intEjercicio;
                        obj.DecPorcIva = dblPorcentaje;

                        fac.Save(obj);

                        fac = null;
                        obj = null;

                        intEmpresa = 0;
                        intCliente = 0;
                        DblImporte = 0;
                        StrObra = "";
                    }
                }
                excelReader.Close();
                //Anthem.Manager.RegisterStartupScript(Page.GetType(), "file", "alert('Se guardo correctamente." + MsjRes + "');", true);
                Anthem.Manager.RegisterStartupScript(Page.GetType(), "Alerta", "alert('Se guardó correctamente.'); GetList();", true);
            }

            excelReader.Close();
            //Anthem.Manager.RegisterStartupScript(Page.GetType(), "file", "alert('Se guardo correctamente." + MsjRes + "');", true);
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "Alerta", "alert('Se guardó correctamente.'); GetList();", true);

        }
        catch (Exception ex)
        {
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "x5", "alert('" + ex.Message.Replace("'", "") + "');", true);
        }
    }
    #endregion

}