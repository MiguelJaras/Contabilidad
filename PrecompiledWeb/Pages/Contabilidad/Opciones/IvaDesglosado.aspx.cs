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
using Contabilidad.Entity;
using Contabilidad.Bussines;

public partial class Pages_Opciones_IvaDesglosado : System.Web.UI.Page
{
    public string realPath;
    Pages_Base toolbar;
    protected void Page_Load(object sender, EventArgs e)
    {
        toolbar = (Pages_Base)this.Master;
        toolbar.PageEvent += new HandlerEvent(Me_Event);

        string end = (Request.ApplicationPath.EndsWith("/")) ? "" : "/";
        string path = Request.ApplicationPath + end;
        realPath = String.Format("http://{0}{1}{2}", Request.Url.Authority, path, "Img/dxpcFooterBack.gif");

        Anthem.Manager.Register(this);
        if (!IsPostBack && !IsCallback)
        { 
            txtEmpresa.Text = Contabilidad.SEMSession.GetInstance.IntEmpresa.ToString();
            txtEmpresa_TextChange(null, null);
            Year();
        } 
        
        JavaScript();
    }

    protected void Page_PreRender(object sender, EventArgs e)
    {
        toolbar.List(false);
        toolbar.Delete(false);
        toolbar.Print(false);
        toolbar.Email(false);
        toolbar.New(true);
    }

    #region JavaScript
    private void JavaScript()
    {
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtCheque", "var objText = new VetecText('" + txtCheque.ClientID + "', 'number', 18);", true);
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtEmpresa", "var objText = new VetecText('" + txtEmpresa.ClientID + "', 'number', 18);", true);
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

        cboYear.UpdateAfterCallBack = true;

        list = null;
    }
    #endregion Year    
    
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

        Anthem.Manager.RegisterStartupScript(Page.GetType(), "focCuen", "document.all('ctl00_CPHBase_cboYear').focus()", true);

        obj = null;
        emp = null;
    }
    #endregion

    #region Clear
    private void Clear()
    {
        cboYear.SelectedIndex = -1;
        cboMes.SelectedIndex = -1;
        txtCheque.Text = "";
        hddPoliza.Value="";

        cboYear.UpdateAfterCallBack = true;
        cboMes.UpdateAfterCallBack = true;
        txtCheque.UpdateAfterCallBack = true;
        hddPoliza.UpdateAfterCallBack = true;

        Anthem.Manager.RegisterStartupScript(Page.GetType(), "focus", "document.all('ctl00_CPHBase_cboYear').focus()", true);
    }

    #endregion    

    #region Save
    void Save()
    {
        try
        {
            Entity_Iva obj = new Entity_Iva();
            Iva iva = new Iva();
            bool res;
            obj.intEjercicio = cboYear.SelectedValue=="" ? 0 : Convert.ToInt32(cboYear.SelectedValue);
            obj.intCheque = txtCheque.Text == "" ? 0 : Convert.ToInt32(txtCheque.Text);
            obj.intMes = cboMes.SelectedValue == "" ? 0 : Convert.ToInt32( cboMes.SelectedValue);
            obj.IntEmpresa = txtEmpresa.Text == "" ? 0 : Convert.ToInt32(txtEmpresa.Text);
            obj.strPoliza = hddPoliza.Value;

            res = false;// iva.IvaDesglosado(obj);
            if (res)
            {
                Anthem.Manager.RegisterStartupScript(Page.GetType(), "Alerta", "alert('La información se guardo correctamente.');", true);
                Clear();
            }
            else
                Anthem.Manager.RegisterStartupScript(Page.GetType(), "Alerta", "alert('Ocurrió un error al guardar.');", true);
        }
        catch (Exception ex)
        {
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "mssErrr", "alert('" + ex.Message + "');", true);
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
            default:
                break;
        }
    }
    #endregion

    protected void txtCheque_TextChanged(object sender, EventArgs e)
    {
        Entity_Iva obj = new Entity_Iva();
        Iva iva = new Iva();
        string poliza;
        obj.IntEmpresa = txtEmpresa.Text == "" ? 0 : Convert.ToInt32(txtEmpresa.Text);
        obj.intCheque = txtCheque.Text == "" ? 0 : Convert.ToInt32(txtCheque.Text);
        poliza = iva.PolizaCheque(obj);
        hddPoliza.Value = poliza;
        hddPoliza.UpdateAfterCallBack = true;
    }
}
