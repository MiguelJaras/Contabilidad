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

public partial class Contabilidad_Compra_Opciones_CerrarPeriodo : System.Web.UI.Page
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
        if (!IsPostBack && !IsCallback)
        {
            Year();
            Month();
            cboMonth.SelectedValue = DateTime.Now.Month.ToString();
            cboYear.SelectedValue = DateTime.Now.Year.ToString();
            txtEmpresa.Text = Contabilidad.SEMSession.GetInstance.IntEmpresa.ToString();
            txtEmpresa_TextChange(null, null);
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

    #region BindGrid
    private void BindGrid()
    {
        Entity_CerrarPeriodo obj;
        obj = new Entity_CerrarPeriodo();

        CerrarPeriodo cp;
        cp = new CerrarPeriodo();
        
        DataTable dt;

        obj.intEmpresa = txtEmpresa.Text == "" ? Contabilidad.SEMSession.GetInstance.IntEmpresa : Convert.ToInt32(txtEmpresa.Text);
        obj.intEjercicio = Convert.ToInt32( cboYear.SelectedValue);
        obj.intMes = Convert.ToInt32(cboMonth.SelectedValue);

        dt = cp.GetList(obj); 

        if (dt != null)
        {
            grdCerrar.DataSource = dt;
            grdCerrar.DataBind();
        }

        grdCerrar.UpdateAfterCallBack = true;

        cp = null;
    }
    #endregion

    #region row_Created
    protected void row_Created(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            DataRowView dataRowView = (DataRowView)e.Row.DataItem;
            if (dataRowView != null)
            {
                Anthem.CheckBox chkCerrar = (Anthem.CheckBox)e.Row.FindControl("chkCerrar");

                string bCerrado = dataRowView.Row["bCerrado"].ToString();


                if (bCerrado == "1")
                    chkCerrar.Checked = true;
                else
                    chkCerrar.Checked = false;


                chkCerrar.UpdateAfterCallBack = true;
            }
        }
    }
    #endregion   

    #region Save
    private void Save()
    {
        try
        {
            int intEmpresa;
            int intEjercicio;
            int intMes;
            int intModulo = 0;

            intEmpresa = txtEmpresa.Text == "" ? Contabilidad.SEMSession.GetInstance.IntEmpresa : Convert.ToInt32(txtEmpresa.Text);
            intEjercicio = Convert.ToInt32(cboYear.SelectedValue);
            intMes = Convert.ToInt32(cboMonth.SelectedValue);

            for (int i = 0; i < grdCerrar.Rows.Count; i++)
            {
                intModulo = Convert.ToInt32(grdCerrar.DataKeys[i].Value);
                Anthem.CheckBox chkCerrar = (Anthem.CheckBox)grdCerrar.Rows[i].FindControl("chkCerrar");
                
                Entity_CerrarPeriodo obj;
                obj = new Entity_CerrarPeriodo();

                CerrarPeriodo cp;
                cp = new CerrarPeriodo();

                obj.intEmpresa = intEmpresa;
                obj.intEjercicio = intEjercicio;
                obj.intMes = intMes;
                obj.intModulo = intModulo;
                obj.bCerrado = Convert.ToBoolean ( chkCerrar.Checked == true ? 1 : 0);
                obj.StrUsuario = Contabilidad.SEMSession.GetInstance.StrUsuario;

                bool res;
                res = cp.Save(obj);

                obj = null;
                cp = null;
            }

            Anthem.Manager.RegisterStartupScript(Page.GetType(), "msgDesaf", "alert('Se guardo correctamente.');", true);
            //Clear();
            BindGrid();
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
                BindGrid();
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
        BindGrid();

        obj = null;
        emp = null;
    }
    #endregion txtEmpresa_TextChange

    #region cboMonth_SelectedIndexChanged
    protected void cboMonth_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindGrid();
    }
    #endregion
}


