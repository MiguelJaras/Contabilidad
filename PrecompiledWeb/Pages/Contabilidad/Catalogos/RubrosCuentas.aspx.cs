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

public partial class Contabilidad_Compra_Opciones_RubrosCuentas : System.Web.UI.Page
{
    public string realPath;
    Pages_Base toolbar;

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
        }

        JavaScript();
        RefreshSession();
    }

    protected void Page_PreRender(object sender, EventArgs e)
    {
        toolbar.List(false);
        toolbar.Print(false);
        toolbar.Email(false);
        toolbar.Save(false);
        toolbar.Delete(false);
    }

    #region JavaScript
    private void JavaScript()
    {
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtEmpresa", "var objText = new VetecText('" + txtEmpresa.ClientID + "', 'number', 12);", true);
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtRubro", "var objText = new VetecText('" + txtRubro.ClientID + "', 'number', 12);", true);
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtNombre", "var objText = new VetecText('" + txtNombre.ClientID + "', 'text', 100);", true);
        
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
        Values value;
        value = new Values();
        txtRubro.Text = "";
        txtNombre.Text = "";
        txtCuenta.Text = "";
        txtNombreCuenta.Text = "";
        DgrdList.DataSource = null;
        DgrdList.DataBind();

        DgrdList.UpdateAfterCallBack = true;
        txtRubro.UpdateAfterCallBack = true;
        txtNombre.UpdateAfterCallBack = true;
        txtCuenta.UpdateAfterCallBack = true;
        txtNombreCuenta.UpdateAfterCallBack = true;
    }
    #endregion

    #region Delete
    private void Delete()
    {
        Entity_RubrosCuentas obj;
        obj = new Entity_RubrosCuentas();

        RubrosCuentas rub;
        rub = new RubrosCuentas();

        try
        {
            obj.intEmpresa = txtEmpresa.Text == "" ? Contabilidad.SEMSession.GetInstance.IntEmpresa : Convert.ToInt32(txtEmpresa.Text);
            obj.intRubro = txtRubro.Text == "" ? 0 : Convert.ToInt32(txtRubro.Text);
            obj.strCuenta = txtCuenta.Text;

            string result = "";
            result = rub.Delete(obj);

            if (result != "")
            {
                Anthem.Manager.RegisterStartupScript(Page.GetType(), "ErrDel", "alert('Se eliminó  el rubro " + result.ToString() + ".');", true);
                Clear();
            }
            else
            {
                Anthem.Manager.RegisterStartupScript(Page.GetType(), "CorrDel", "alert('No se puede eliminar el rubro " + result.ToString() + ".');", true);
            }
        }
        catch (Exception ex)
        {
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "msgDel", "alert('" + ex.Message + "');", true);
            Clear();
        }
        
        obj = null;
        rub = null;
    }
    #endregion

    #region Save
    private void Save()
    {
        Entity_RubrosCuentas obj;
        obj = new Entity_RubrosCuentas();

        RubrosCuentas rub;
        rub = new RubrosCuentas();

        try
        {
            obj.intEmpresa = txtEmpresa.Text == "" ? Contabilidad.SEMSession.GetInstance.IntEmpresa : Convert.ToInt32(txtEmpresa.Text);
            obj.intRubro = txtRubro.Text == "" ? 0 : Convert.ToInt32(txtRubro.Text);
            obj.strCuenta = txtCuenta.Text;
            obj.datFechaAlta = DateTime.Now;
            obj.strMaquinaAlta = Contabilidad.SEMSession.GetInstance.StrMaquina.ToString();
            obj.strUsuarioAlta = Contabilidad.SEMSession.GetInstance.StrUsuario.ToString();
            obj.strUsuarioMod = Contabilidad.SEMSession.GetInstance.StrUsuario.ToString();
            obj.strMaquinaMod = Contabilidad.SEMSession.GetInstance.StrMaquina.ToString();
            obj.datFechaMod = DateTime.Now;
            if (rbSi.Checked)
                obj.intIndSumaResta = 1;
            else
                obj.intIndSumaResta = -1;

            string result = "";
            result = rub.Save(obj);
            BindGrid();

            if (result != "")
            {
                Anthem.Manager.RegisterStartupScript(Page.GetType(), "Alerta", "alert('La información se guardo correctamente.');", true);
                Anthem.Manager.RegisterStartupScript(Page.GetType(), "focus", "document.all('ctl00_CPHBase_txtCuenta').focus()", true);
                txtCuenta.Text = "";
                txtNombreCuenta.Text = "";

                txtCuenta.UpdateAfterCallBack = true;
                txtNombreCuenta.UpdateAfterCallBack = true;
            }
            else
            {
                Anthem.Manager.RegisterStartupScript(Page.GetType(), "ErrSave", "alert('No se puede agregar el rubro " + result.ToString() + ", cuenta " + obj.strCuenta + " .');", true);
            }
        }
        catch (Exception ex)
        {
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "msgSave", "alert('" + ex.Message + "');", true);
            Clear();
        }
        
        obj = null;
        rub = null;
    }
    #endregion

    #region Print
    void Print()
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
                Delete();
                break;
            case Event.Print:
                Print();
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

        obj = null;
        emp = null;
    }
    #endregion txtEmpresa_TextChange

    #region txtRubro_TextChanged
    protected void txtRubro_TextChanged(object sender, EventArgs e)
    {
        Entity_Rubros obj;
        obj = new Entity_Rubros();

        Rubros rub;
        rub = new Rubros();

        obj.intEmpresa = txtEmpresa.Text == "" ? Contabilidad.SEMSession.GetInstance.IntEmpresa : Convert.ToInt32(txtEmpresa.Text);
        obj.intRubro = txtRubro.Text == "" ? 0 : Convert.ToInt32(txtRubro.Text);

        obj = rub.Fill(obj);

        if (!(obj == null))
        {
            if (txtRubro.Text != "")
            {
                if (obj.strNombre != null)
                {
                    txtNombre.Text = obj.strNombre.ToString();
                }
            }
            else
            {
                txtRubro.Text = "";
                txtNombre.Text = "";
                Clear();
            }
        }
        else
        {
            txtRubro.Text = "";
            txtNombre.Text = "";
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtNombreFocus", "document.getElementById('" + txtNombre.ClientID + "').focus();", true);
        }
        
        txtNombre.UpdateAfterCallBack = true;
        txtRubro.UpdateAfterCallBack = true;

        rub = null;
        obj = null;
        BindGrid();
    }
    #endregion

    #region DgrdList_RowDeleting
    protected void DgrdList_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        Entity_RubrosCuentas obj;
        obj = new Entity_RubrosCuentas();

        RubrosCuentas rub;
        rub = new RubrosCuentas();

        try
        {
            obj.intEmpresa = txtEmpresa.Text == "" ? Contabilidad.SEMSession.GetInstance.IntEmpresa : Convert.ToInt32(txtEmpresa.Text);
            obj.intRubro = (int)DgrdList.DataKeys[e.RowIndex].Values[0];
            obj.strCuenta = (string)DgrdList.DataKeys[e.RowIndex].Values[1];

            string result = "";
            result = rub.Delete(obj);
            BindGrid();


            if (result != "")
            {
                Anthem.Manager.RegisterStartupScript(Page.GetType(), "ErrDel2", "alert('Se elimino correctamente.');", true);
            }
            else
            {
                Anthem.Manager.RegisterStartupScript(Page.GetType(), "CorrDel", "alert('No se puede eliminar el rubro " + result.ToString() + ", cuenta " + obj.strCuenta + ".');", true);
            }
        }
        catch (Exception ex)
        {
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "msgDel", "alert('" + ex.Message + "');", true);
            Clear();
        }

        obj = null;
        rub = null;
    }
    #endregion DgrdList_RowDeleting

    #region BindGrid
    private void BindGrid()
    {
        Entity_RubrosCuentas obj;
        obj = new Entity_RubrosCuentas();

        RubrosCuentas rub;
        rub = new RubrosCuentas();
        DataTable dt= null;

        obj.intEmpresa = txtEmpresa.Text == "" ? Contabilidad.SEMSession.GetInstance.IntEmpresa : Convert.ToInt32(txtEmpresa.Text);
        obj.strCuenta = txtCuenta.Text;
        obj.intRubro = txtRubro.Text == "" ? 0 : Convert.ToInt32(txtRubro.Text);

        dt = rub.Sel(obj);

        DgrdList.DataSource = rub.Sel(obj);
        DgrdList.DataBind();
        DgrdList.UpdateAfterCallBack = true;

        obj = null;
        rub = null;
    }
    #endregion 

    #region txtCuenta_Change
    protected void txtCuenta_Change(object sender, EventArgs e)
    {
        try
        {
            Cuentas Obj = new Cuentas();
            Entity_Cuentas EntiCuentas = new Entity_Cuentas();

            EntiCuentas.IntEmpresa = txtEmpresa.Text == "" ? Contabilidad.SEMSession.GetInstance.IntEmpresa : Convert.ToInt32(txtEmpresa.Text);
            EntiCuentas.IntSucursal = hddSucursal.Value == "" ? Contabilidad.SEMSession.GetInstance.IntSucursal : Convert.ToInt32(hddSucursal.Value);
            EntiCuentas.StrCuenta = txtCuenta.Text;

            Entity_Cuentas CuentaByKey = Obj.GetByPrimaryKey(EntiCuentas);

            if (CuentaByKey != null)
            {
                txtCuenta.Text = CuentaByKey.StrCuenta;
                txtNombreCuenta.Text = CuentaByKey.StrNombre;
            }
            else
            {
                txtCuenta.Text = "";
                txtNombreCuenta.Text = "";
            }

            txtCuenta.UpdateAfterCallBack = true;
            txtNombreCuenta.UpdateAfterCallBack = true;

            Obj = null;
            EntiCuentas = null;

            Anthem.Manager.RegisterStartupScript(Page.GetType(), "focusCF", "document.all('ctl00_CPHBase_txtCuentaFin').focus()", true);

        }
        catch (System.IO.IOException ex)
        {

        }
        BindGrid();
    }
    protected void btnAgregar_Click(object sender, EventArgs e)
    {
        Save();
    }
    #endregion

}


