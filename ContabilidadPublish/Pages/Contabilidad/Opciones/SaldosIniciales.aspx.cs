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

public partial class Pages_Opciones_SaldosIniciales : System.Web.UI.Page
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
        toolbar.New(false);
    }

    #region JavaScript
    private void JavaScript()
    { 
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtCuenta", "var objText = new VetecText('" + txtCuenta.ClientID + "', 'text', 12);", true);
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

        Anthem.Manager.RegisterStartupScript(Page.GetType(), "focCuen", "document.all('ctl00_CPHBase_txtCuenta').focus()", true);

        obj = null;
        emp = null;
    }
    #endregion

    #region txtCuenta_Change
    protected void txtCuenta_Change(object sender, EventArgs e)
    {
        if (txtCuenta.Text != "")
        {
            selCuenta(txtCuenta.Text);           
        }
    }

    public void selCuenta(string strCuenta)
    {
        Cuentas Obj = new Cuentas();
        Entity_Cuentas EntiCuentas;
        EntiCuentas = new Entity_Cuentas();

        try
        {           
            EntiCuentas.IntEmpresa  = txtEmpresa.Text == "" ? Contabilidad.SEMSession.GetInstance.IntEmpresa : Convert.ToInt32(txtEmpresa.Text);
            EntiCuentas.IntSucursal = hddSucursal.Value == "" ? Contabilidad.SEMSession.GetInstance.IntSucursal : Convert.ToInt32(hddSucursal.Value);
            EntiCuentas.StrCuenta   = strCuenta;

            EntiCuentas = Obj.GetByPrimaryKey(EntiCuentas);

            if (EntiCuentas != null)
            {
                txtCuenta.Text = EntiCuentas.StrCuenta;
                txtNombreCuenta.Text = EntiCuentas.StrNombre;
            }
            else
            {
                txtCuenta.Text = "";
                txtNombreCuenta.Text ="";
            }

            txtCuenta.UpdateAfterCallBack = true;
            txtNombreCuenta.UpdateAfterCallBack = true;
        }
        catch (System.IO.IOException ex) { }

        EntiCuentas = null;
    }


    #endregion

    #region Clear
    private void Clear()
    {
        txtCuenta.Text = "";
        txtNombreCuenta.Text = "";
        hddClaveCuenta.Value = "";

        txtCuenta.UpdateAfterCallBack = true;
        txtNombreCuenta.UpdateAfterCallBack = true;
        hddClaveCuenta.UpdateAfterCallBack = true;
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "focus", "document.all('ctl00_CPHBase_txtCuenta').focus()", true);
    }

    #endregion    

    #region Save
    void Save()
    {
        try
        {
            Entity_PolizasDet obj;
            obj =  new Entity_PolizasDet();
            Poliza saldo;
            saldo = new Poliza();

            obj.IntEmpresa = txtEmpresa.Text == "" ? Contabilidad.SEMSession.GetInstance.IntEmpresa : Convert.ToInt32(txtEmpresa.Text);
            obj.strCuenta = txtCuenta.Text;
            obj.intEjercicio = Convert.ToInt32(cboYear.SelectedValue);

            saldo.SaldosIniciales(obj); 
            
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "Alerta", "alert('La información se guardo correctamente.');", true);                
            Clear();
        }
        catch (Exception ex)
        {
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "mssErrr", "alert('" + ex.Message + "');", true);
        }
    }
    #endregion

    #region validaCuenta
    public bool validaCuenta(string strCuenta)
    {
        bool ret = false;
        string sPattern4 = "^\\d{4}$";
        string sPattern8 = "^\\d{4}\\d{4}$";
        string sPattern12 = "^\\d{4}\\d{4}\\d{4}$";
        int intCuentaLen = strCuenta.Length;

        if (intCuentaLen <= 4)
        {
            if (!System.Text.RegularExpressions.Regex.IsMatch(strCuenta, sPattern4))
             ret = true; 
        }
        else
            if (intCuentaLen <= 8)
            {
                if (!System.Text.RegularExpressions.Regex.IsMatch(strCuenta, sPattern8))
                    ret = true;
            }
            else
            {
                if (!System.Text.RegularExpressions.Regex.IsMatch(strCuenta, sPattern12))
                    ret = true; 
            }

        if(ret)
        {
         Anthem.Manager.RegisterStartupScript(Page.GetType(), "ErrDel3", "alert('Numero de cuenta incorrecta. solo 4,8 y 12 digitos NNNN, NNNNNNNN ó NNNNNNNNNNNN');", true);
         Anthem.Manager.RegisterStartupScript(Page.GetType(), "msgFoc212", "document.getElementById('" + txtCuenta.ClientID + "').focus();", true);
        }

        return ret;
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
            default:
                break;
        }
    }
    #endregion

}
