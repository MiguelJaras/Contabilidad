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

public partial class Contabilidad_Compra_Opciones_CalculoIva : System.Web.UI.Page
{
    public string realPath;
    Pages_Base toolbar;

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
        Direction = 1;
        SortExpression = "1";
        if (!IsPostBack && !IsCallback)
        {
            Month();
            Year();
            txtEmpresa.Text = Contabilidad.SEMSession.GetInstance.IntEmpresa.ToString();
            txtEmpresa_TextChange(null, null);
            cboYear.SelectedValue = DateTime.Now.Year.ToString();
            cboMonth.SelectedValue = DateTime.Now.Month.ToString();
            BindGrid();
        }
        RefreshSession();
    }

    protected void Page_PreRender(object sender, EventArgs e)
    {
        toolbar.Print(false);
        toolbar.New(false);
        toolbar.Exportar(false);
        toolbar.Email(false);
        toolbar.Delete(false);
        toolbar.List(true);
    }
    
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

        cboYear.DataSource = list.Ejercicio(txtEmpresa .Text =="" ? Contabilidad.SEMSession.GetInstance.IntEmpresa : Convert.ToInt32 (txtEmpresa .Text), hddSucursal .Value =="" ? Contabilidad.SEMSession.GetInstance.IntSucursal : Convert .ToInt32 (hddSucursal .Value) );
        cboYear.DataTextField = "Id";
        cboYear.DataValueField = "strNombre";
        cboYear.DataBind();

        cboYear.UpdateAfterCallBack = true;

        list = null;
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
 
    #region BindGrid
    private void BindGrid()
    {
        Entity_PolizasDet obj;
        obj = new Entity_PolizasDet();
        Poliza pol;
        pol = new Poliza();
        DataTable dt;

        obj.IntEmpresa = txtEmpresa .Text =="" ? Contabilidad.SEMSession.GetInstance.IntEmpresa: Convert.ToInt32 (txtEmpresa .Text);
        obj.strDescripcion = "1";// Direction.ToString();
        obj.SortExpression = "";// SortExpression;

        dt = pol.PolizaIva(obj);

        grdIva.DataSource = dt;
        grdIva.DataBind();
        grdIva.UpdateAfterCallBack = true;

        pol = null;
        obj = null;
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

    #region Clear
    private void Clear()
    {
        cboYear.SelectedValue = DateTime.Now.Year.ToString();
        cboMonth.SelectedValue = DateTime.Now.Month.ToString();

        cboYear.UpdateAfterCallBack = true;
        cboMonth.UpdateAfterCallBack = true;
    }
    #endregion  

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
            string value = "";
            Entity_Poliza obj;
            obj = new Entity_Poliza();
            Poliza pol;
            pol = new Poliza();

            obj.IntEmpresa = txtEmpresa .Text =="" ? Contabilidad.SEMSession.GetInstance.IntEmpresa: Convert.ToInt32 (txtEmpresa .Text);
            obj.IntEjercicio = Convert.ToInt32(cboYear.SelectedValue);
            obj.IntMes = Convert.ToInt32 ( cboMonth.SelectedValue);
            obj.StrUsuario = Contabilidad.SEMSession.GetInstance.StrUsuario;
            obj.StrMaquina = Contabilidad.SEMSession.GetInstance.StrMaquina;

            value = pol.SavePolizaIva(obj);

            if (value == "1")
            {
                Anthem.Manager.RegisterStartupScript(Page.GetType(), "msgSave", "alert('Se guardo correctamente.')", true);
                BindGrid();
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
                break;
            case Event.Print:
                break;
            case Event.List:
                BindGrid();
                break;
            default:
                break;
        }
    }
    #endregion

    #region grdFacturas_Sorting
    protected void grdFacturas_Sorting(object sender, GridViewSortEventArgs e)
    {
        if (SortExpression == e.SortExpression)
        {
            if (Direction == (e.SortDirection == SortDirection.Ascending ? 1 : 0))
                Direction = 0;
            else
                Direction = 1;
        }
        else
            Direction = e.SortDirection == SortDirection.Ascending ? 1 : 0;
        SortExpression = e.SortExpression;
        BindGrid();
    }
    #endregion

    #region Close
    private void Close()
    {
        Poliza poli;
        poli = new Poliza();

        int mes = Convert.ToInt32 ( cboMonth.SelectedValue);
        int año = Convert.ToInt32 (cboYear.SelectedValue);
        int intEmpresa = Contabilidad .SEMSession .GetInstance .IntEmpresa ;

        hddClose.Value = poli.SelPolizaIva(intEmpresa, año, mes);// DALHelper.ExecuteScalarFromQuery("SELECT Convert(int,bCerrado) FROM tbCerrarPeriodo WHERE intEmpresa = " + Session["numEmpresa"].ToString() + " AND intEjercicio =" + año + " AND intMes = " + mes + " AND intModulo = 1").ToString();
        hddClose.UpdateAfterCallBack = true;

        poli = null;
    }
    #endregion 

    #region row_Created
    protected void row_Created(object sender, GridViewRowEventArgs e)
    {
        int intEmpresa = txtEmpresa .Text =="" ? Contabilidad.SEMSession.GetInstance.IntEmpresa : Convert.ToInt32 (txtEmpresa .Text);
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            DataRowView dataRowView = (DataRowView)e.Row.DataItem;
            if (dataRowView != null)
            {
                Anthem.LinkButton lknPoliza = (Anthem.LinkButton)e.Row.FindControl("lknPoliza");

                string poliza = dataRowView.Row["strPoliza"].ToString();
                string intEjercicio = dataRowView.Row["intEjercicio"].ToString();

                lknPoliza.Text = poliza;
                lknPoliza.Style.Value = "color:#FF4500;font-family: Tahoma;font-size: 8pt;Height:30px;font-weight:bold;";
                lknPoliza.Attributes.Add("onClick", "window.open('../../../Utils/PopUpPoliza.aspx?intEmpresa=" + intEmpresa.ToString() + "&strPoliza=" + poliza + "&intEjercicio=" + intEjercicio + "','','height=700px width=1000px resizable scrollbars');  return false;");
                //lknPoliza.Attributes.Add("onClick", "window.showModalDialog('../../../Utils/PopUpPoliza.aspx?intEmpresa=" + intEmpresa.ToString() + "&strPoliza=" + poliza + "&intEjercicio=" + intEjercicio + "',null,'dialogHeight:700px; dialogWidth:1000px;status:no;help:no;scroll:no;minimize:no;maximize:no;close:no;border:thin;');  return false;");
                e.Row.Style.Value = "background-color:#EAF7FB;color:#000066;font-family: Tahoma;font-size: 7pt;Height:30px;font-weight:bold;";
            }
        }
    }
    #endregion

}


