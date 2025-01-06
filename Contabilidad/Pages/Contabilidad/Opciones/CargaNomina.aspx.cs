using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using Contabilidad.Bussines;
using Contabilidad.Entity;
using DevExpress.Web.ASPxGridView;
using Contabilidad.Bussines;
using Contabilidad.Entity;
using System.IO;
using System.Data.OleDb;
using Excel;

public partial class Pages_Contabilidad_Opciones_CargaNomina : System.Web.UI.Page
{
    string intEmpresa;
    Pages_Base toolbar;
    public string realPath;
    string usuario;

    public int Direction
    {
        get { return ViewState["Direction"] != null ? (int)ViewState["Direction"] : 0; }
        set { ViewState["Direction"] = value; }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        toolbar = (Pages_Base)this.Master;
        toolbar.PageEvent += new HandlerEvent(Me_Event);

        string end = (Request.ApplicationPath.EndsWith("/")) ? "" : "/";
        string path = Request.ApplicationPath + end;
        realPath = String.Format("http://{0}{1}{2}", Request.Url.Authority, path, "Img/dxpcFooterBack.gif");

        if (!IsPostBack)
        {
            Month();
            Year();
            cboMonth.SelectedValue = DateTime.Now.Month.ToString();
            cboEjercicio.SelectedValue = DateTime.Now.Year.ToString();
        }
    }

    #region Event
    void Me_Event(object sender, HandlerArgs args)
    {
        switch (args.Event)
        {
            case Event.Save:
                //Save();
                break;
            case Event.New:
                //Clear();
                break;
            case Event.Delete:
                //Delete();
                break;
            case Event.Print:
                //Print();
                break;
            default:
                break;
        }
    }
    #endregion  
    #region Month
    private void Month()
    {
        cboMonth.Items.Insert(0, new ListItem("1.- Enero", "1"));
        cboMonth.Items.Insert(1, new ListItem("2.- Febrero", "2"));
        cboMonth.Items.Insert(2, new ListItem("3.- Marzo", "3"));
        cboMonth.Items.Insert(3, new ListItem("4.- Abril", "4"));
        cboMonth.Items.Insert(4, new ListItem("5.- Mayo", "5"));
        cboMonth.Items.Insert(5, new ListItem("6.- Junio", "6"));
        cboMonth.Items.Insert(6, new ListItem("7.- Julio", "7"));
        cboMonth.Items.Insert(7, new ListItem("8.- Agosto", "8"));
        cboMonth.Items.Insert(8, new ListItem("9.- Septiembre", "9"));
        cboMonth.Items.Insert(9, new ListItem("10.- Octubre", "10"));
        cboMonth.Items.Insert(10, new ListItem("11.- Noviembre", "11"));
        cboMonth.Items.Insert(11, new ListItem("12.- Diciembre", "12"));
        cboMonth.SelectedIndex = 0;
        cboMonth.UpdateAfterCallBack = true;
    }
    #endregion
    #region Year
    private void Year()
    {
        List list;
        list = new List();

        cboEjercicio.DataSource = list.Ejercicio(Contabilidad.SEMSession.GetInstance.IntEmpresa, Contabilidad.SEMSession.GetInstance.IntSucursal);
        cboEjercicio.DataTextField = "Id";
        cboEjercicio.DataValueField = "strNombre";
        cboEjercicio.DataBind();

        cboEjercicio.UpdateAfterCallBack = true;

        list = null;
    }
    #endregion 
    #region cboMonth_Change
    protected void cboMonth_Change(object sender, EventArgs e)
    {

    }
    #endregion
    #region Charge
    private void Charge()
    {
        try
        {
            string end = (Request.ApplicationPath.EndsWith("/")) ? "" : "/";
            string path = Request.ApplicationPath + end;
            string appPath = Request.PhysicalApplicationPath;

            usuario = Contabilidad.SEMSession.GetInstance.StrUsuario;

            string fileName = appPath + "Temp/FilePoliza" + intEmpresa + usuario + ".xls";
            fuArchivo.PostedFile.SaveAs(fileName);
            FileStream stream = File.Open(fileName, FileMode.Open, FileAccess.Read);

            IExcelDataReader excelReader = ExcelReaderFactory.CreateBinaryReader(stream);

            excelReader.IsFirstRowAsColumnNames = true;
            DataSet result = excelReader.AsDataSet();

            //if (result.Tables.Count > 0)
            //    Poliza(result.Tables[0]);

            excelReader.Close();
            File.Delete(fileName);

        }
        catch (Exception ex)
        {
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "x5", "alert('" + ex.Message + "');", true);
        }
    }
    #endregion
}