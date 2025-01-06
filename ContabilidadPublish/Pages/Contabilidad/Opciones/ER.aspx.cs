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
using DevExpress.Web.ASPxGridView;
using System.Data.SqlClient;
using Contabilidad.Bussines;
using Contabilidad.Entity;
using System.Text;

public partial class Contabilidad_Compra_Opciones_ER : System.Web.UI.Page
{
    public string realPath;
    Pages_Base toolbar;

    public int Direction
    {
        get { return ViewState["Direction"] != null ? (int)ViewState["Direction"] : 0; }
        set { ViewState["Direction"] = value; }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        toolbar = (Pages_Base)this.Master;
        toolbar.PageEvent += new HandlerEvent(Me_Event);
        Anthem.Manager.Register(this);
        string end = (Request.ApplicationPath.EndsWith("/")) ? "" : "/";
        string path = Request.ApplicationPath + end;
        realPath = String.Format("http://{0}{1}{2}", Request.Url.Authority, path, "Img/dxpcFooterBack.gif");
        int mes;
        if (!IsPostBack && !IsCallback)
        {
            mes = DateTime.Now.Month;
            Year();
            Month();
            cboMonth.SelectedValue = Convert.ToString(mes == 1 ? 1 : mes - 1);
            cboYear.SelectedValue = DateTime.Now.Year.ToString();
            cboEmpresa.Items.Add(new ListItem("MARFIL DESARROLLO, S.A. DE C.V.", "2"));
            cboEmpresa.Items.Add(new ListItem("MAPLE URBANIZADORA, S.A. DE C.V", "3"));
        }

        JavaScript();
        RefreshSession();
    }

    protected void Page_PreRender(object sender, EventArgs e)
    {
        toolbar.Print(false);
        toolbar.List(false);
        toolbar.New(false);
        toolbar.Exportar(false);
        toolbar.Email(false);
        toolbar.Delete(false);
    }

    #region JavaScript
    private void JavaScript()
    {       

    }
    
    #endregion

    #region RefreshSession
    private void RefreshSession()
    {
        string end = (Request.ApplicationPath.EndsWith("/")) ? "" : "/";
        string path = Request.ApplicationPath + end;
        string appPath = String.Format("http://{0}{1}{2}", Request.Url.Authority, path, "Login/FinSesion.aspx?id=0");

        Response.AppendHeader("Refresh", Convert.ToString((Session.Timeout * 50)) + "; URL=" + appPath);
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

        cboMonth.Items.Insert(0, new ListItem("-- Seleccione --", "0"));
        cboMonth.SelectedIndex = 0;

        cboMonth.UpdateAfterCallBack = true;
    }
    #endregion

    #region Year
    private void Year()
    {
        List list;
        list = new List();

        cboYear.DataSource = list.Ejercicio(Contabilidad.SEMSession.GetInstance.IntEmpresa, Contabilidad.SEMSession.GetInstance.IntSucursal);
        cboYear.DataTextField = "Id";
        cboYear.DataValueField = "strNombre";
        cboYear.DataBind();

        cboYear.Items.Insert(0, new ListItem("-- Seleccione --", "0"));
        cboYear.SelectedIndex = 0;
        cboYear.UpdateAfterCallBack = true;

        list = null;
    }
    #endregion Year  

    #region Save
    private void Save()
    {
        try
        {
            int intEmpresa;
            int intEjercicio;
            int intMes;
            Poliza pol = new Poliza();
            Entity_PolizasDet obj = new Entity_PolizasDet();

            intEmpresa =  Convert.ToInt32(cboEmpresa.SelectedValue);
            intEjercicio = Convert.ToInt32(cboYear.SelectedValue);
            intMes = Convert.ToInt32(cboMonth.SelectedValue);

            obj.IntEmpresa = intEmpresa;
            obj.intEjercicio = intEjercicio;
            obj.intMes = intMes;

            pol.ER(obj);

            pol = null;
            obj = null;
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "msgDesaf", "alert('Se ejecuto el proceso de estado de resultados correctamente.');", true);
            //Clear();
        }
        catch (Exception ex)
        {
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "xafe2", "alert('" + ex.Message + "');", true);
        }
    }

    #endregion

    #region Clear
    private void Clear()
    {        

    }
    #endregion   
   
    #region Event
    void Me_Event(object sender, HandlerArgs args)
    {
        switch (args.Event)
        {
            case Event.Save:
                Save();
                break;
            case Event.New:
                Clear();
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

}


