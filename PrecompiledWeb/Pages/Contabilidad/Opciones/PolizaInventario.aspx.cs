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
using System.Data.SqlClient;
using Contabilidad.Bussines;
using Contabilidad.Entity;

public partial class Contabilidad_Compra_Opciones_PolizaInventario : System.Web.UI.Page
{
    public string realPath;
    Pages_Base toolbar;
    string usuario;

    public int Direction
    {
        get { return ViewState["Direction"] != null ? (int)ViewState["Direction"] : 0; }
        set { ViewState["Direction"] = value; }
    }

    public string SortExpression
    {
        get { return ViewState["SortExpression"] != null ? ViewState["SortExpression"].ToString() : ""; }
        set { ViewState["SortExpression"] = value; }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        toolbar = (Pages_Base)this.Master;
        toolbar.PageEvent += new HandlerEvent(Me_Event);
        Anthem.Manager.Register(this);
        string end = (Request.ApplicationPath.EndsWith("/")) ? "" : "/";
        string path = Request.ApplicationPath + end;
        realPath = String.Format("http://{0}{1}{2}", Request.Url.Authority, path, "Img/dxpcFooterBack.gif");
        if (!IsPostBack && !IsCallback)
        {            
            txtEmpresa.Text = Contabilidad.SEMSession.GetInstance.IntEmpresa.ToString();
            txtEmpresa_TextChange(null, null);
            Year();
            Month();
            cboMonth.SelectedValue = DateTime.Now.Month.ToString();
            cboYear.SelectedValue = DateTime.Now.Year.ToString();
            Close();
        }

        JavaScript();
        RefreshSession();
    }

    protected void Page_PreRender(object sender, EventArgs e)
    {
        toolbar.Print(false);
        toolbar.New(false);
        toolbar.Exportar(false);
        toolbar.Email(false);
        toolbar.Delete(false);
        toolbar.List(false);
    }

    #region JavaScript
    private void JavaScript()
    {
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtEmpresa", "var objText = new VetecText('" + txtEmpresa.ClientID + "', 'number', 12);", true);
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
        Close();

        if (hddClose.Value == "1")
        {
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "msgClosePeriod", "alert('No se puede generar la poliza, el mes esta cerrado.');", true);
            return;
        }
        try
        {
            Entity_PolizasEnc obj;
            obj = new Entity_PolizasEnc();

            PolizasEnc pol;
            pol = new PolizasEnc();

            string value = "";

            obj.IntEmpresa = txtEmpresa.Text == "" ? Contabilidad.SEMSession.GetInstance.IntEmpresa : Convert.ToInt32(txtEmpresa.Text);
            obj.intEjercicio  = Convert.ToInt32(cboYear.SelectedValue);
            obj.intMes = Convert.ToInt32(cboMonth.SelectedValue);
            obj.StrMaquina = Contabilidad.SEMSession.GetInstance.StrMaquina;
            obj.StrUsuario = Contabilidad.SEMSession.GetInstance.StrUsuario;

            value = pol.PolInv(obj);

            if (value != "")
            {
                Anthem.Manager.RegisterStartupScript(Page.GetType(), "msgSave", "alert('Se generaron las polizas " + value + ".')", true);
            }
            else
                Anthem.Manager.RegisterStartupScript(Page.GetType(), "msgDel", "alert('Ocurrio un error al guardar.')", true);

            obj = null;
            pol = null;
        }
        catch (Exception ex)
        {
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "msgEx", "alert('" + ex.Message + "')", true);
        }
    }

    #endregion

    #region btnDesAfecta_Click
    protected void btnDesAfecta_Click(object sender, EventArgs e)
    {
        Close();

        if (hddClose.Value == "1")
        {
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "msgClosePeriodo", "alert('No se puede eliminar la poliza, el mes esta cerrado.');", true);
            return;
        }
        try
        {
            Entity_PolizasEnc obj;
            obj = new Entity_PolizasEnc();

            PolizasEnc pol;
            pol = new PolizasEnc();

            string value = "";

            obj.IntEmpresa = txtEmpresa.Text == "" ? Contabilidad.SEMSession.GetInstance.IntEmpresa : Convert.ToInt32(txtEmpresa.Text);
            obj.intEjercicio = Convert.ToInt32(cboYear.SelectedValue);
            obj.intMes = Convert.ToInt32(cboMonth.SelectedValue);
            obj.StrMaquina = Contabilidad.SEMSession.GetInstance.StrMaquina;
            obj.StrUsuario = Contabilidad.SEMSession.GetInstance.StrUsuario;

            value = pol.PolInvDes(obj);

            if (value != "")
            {
                Anthem.Manager.RegisterStartupScript(Page.GetType(), "msgSave", "alert('Las polizas de inventario se eliminaron correctamente.')", true);
            }
            else
                Anthem.Manager.RegisterStartupScript(Page.GetType(), "msgDel", "alert('Ocurrio un error al eliminar.')", true);

            obj = null;
            pol = null;
        }
        catch (Exception ex)
        {
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "msgExx", "alert('" + ex.Message + "')", true);
        }
    }
    #endregion

    #region Clear
    private void Clear()
    {
        Values value;
        value = new Values();
        cboMonth.SelectedValue = DateTime.Now.Month.ToString();
        cboYear.SelectedValue = DateTime.Now.Year.ToString();

        cboYear.UpdateAfterCallBack = true;
        cboMonth.UpdateAfterCallBack = true;

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
            case Event.List:
                //BindGrid();
                break;
            default:
                break;
        }
    }
    #endregion
    
    #region txtEmpresa_TextChange
    protected void txtEmpresa_TextChange(object sender, EventArgs e)
    {
        Entity_Empresa obj;
        obj = new Entity_Empresa();
        Empresa emp;
        emp = new Empresa();

        obj.IntEmpresa = txtEmpresa.Text == "" ? Contabilidad.SEMSession.GetInstance.IntEmpresa : Convert.ToInt32(txtEmpresa.Text);
        obj = emp.Fill(obj.IntEmpresa);

        txtEmpresa.Text = obj.IntEmpresa.ToString();
        txtNombreEmpresa.Text = obj.StrNombre;
        hddSucursal.Value = emp.GetSucursal(obj.IntEmpresa.ToString());

        hddSucursal.UpdateAfterCallBack = true;
        txtEmpresa.UpdateAfterCallBack = true;
        txtNombreEmpresa.UpdateAfterCallBack = true;

        Clear();

        obj = null;
        emp = null;
    }
    #endregion txtEmpresa_TextChange

    #region Close
    private void Close()
    {
        Entity_CerrarPeriodo obj;
        obj = new Entity_CerrarPeriodo();

        CerrarPeriodo cp;
        cp = new CerrarPeriodo();

        string mes = cboMonth.SelectedValue;
        string año = cboYear.SelectedValue;
        obj.intEmpresa = txtEmpresa.Text == "" ? Contabilidad.SEMSession.GetInstance.IntEmpresa : Convert.ToInt32(txtEmpresa.Text);
        obj.intEjercicio = Convert.ToInt32 (año);
        obj.intMes =Convert.ToInt32 ( mes);
        obj.intModulo = 5;// Inventarios

        hddClose.Value = cp.Close(obj);
        hddClose.UpdateAfterCallBack = true;

        obj = null;
        cp = null;
    }
    #endregion 
}


