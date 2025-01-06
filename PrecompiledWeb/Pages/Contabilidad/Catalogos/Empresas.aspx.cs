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

public partial class Contabilidad_Compra_Opciones_Empresas : System.Web.UI.Page
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
            toolbar.PrintValid();
            Monedas();
            txtEmpresa.Text = Contabilidad.SEMSession.GetInstance.IntEmpresa.ToString();
            txtEmpresa_TextChange(null, null);
        }

        JavaScript();
        RefreshSession();
    }

    #region JavaScript
    private void JavaScript()
    {
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtEmpresa", "var objText = new VetecText('" + txtEmpresa.ClientID + "', 'number', 12);", true);
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtNombre", "var objText = new VetecText('" + txtNombre.ClientID + "', 'text', 100);", true);
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtNombreCorto", "var objText = new VetecText('" + txtNombreCorto.ClientID + "', 'text', 100);", true);
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtDireccion", "var objText = new VetecText('" + txtDireccion.ClientID + "', 'text', 100);", true);
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtColonia", "var objText = new VetecText('" + txtColonia.ClientID + "', 'text', 100);", true);        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtDelegacion", "var objText = new VetecText('" + txtDelegacion.ClientID + "', 'text', 100);", true);
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtEstado", "var objText = new VetecText('" + txtEstado.ClientID + "', 'number', 12);", true);
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtEstadoDes", "var objText = new VetecText('" + txtEstadoDes.ClientID + "', 'text', 100);", true);
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtRFC", "var objText = new VetecText('" + txtRFC.ClientID + "', 'text', 100);", true);
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtIMSS", "var objText = new VetecText('" + txtIMSS.ClientID + "', 'text', 100);", true);
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtCP", "var objText = new VetecText('" + txtCP.ClientID + "', 'text', 100);", true);
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtRes", "var objText = new VetecText('" + txtRes.ClientID + "', 'text', 100);", true);
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtRFCRes", "var objText = new VetecText('" + txtRFCRes.ClientID + "', 'text', 100);", true);
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
        txtEmpresa.Text = "";
        txtDireccion.Text = "";
        txtColonia.Text =  "";
        cboMoneda.SelectedIndex = 0;
        txtEstado.Text  = "";
        txtEstadoDes .Text  = "";
        txtRFC.Text  = "";
        txtIMSS.Text = "";
        txtCP.Text  = "";
        txtRes.Text = "";
        txtRFCRes.Text  = "";
        txtNombre.Text = "";
        txtNombreCorto.Text = "";
        txtDelegacion.Text = "";

        txtEmpresa.UpdateAfterCallBack = true;
        txtDelegacion.UpdateAfterCallBack = true;
        txtNombre.UpdateAfterCallBack = true;
        txtNombreCorto.UpdateAfterCallBack = true;
        txtDireccion.UpdateAfterCallBack = true;
        txtColonia.UpdateAfterCallBack = true;
        cboMoneda.UpdateAfterCallBack = true;
        txtEstado.UpdateAfterCallBack = true;
        txtEstadoDes.UpdateAfterCallBack = true;
        txtRFC.UpdateAfterCallBack = true;
        txtIMSS.UpdateAfterCallBack = true;
        txtCP.UpdateAfterCallBack = true;
        txtRes.UpdateAfterCallBack = true;
        txtRFCRes.UpdateAfterCallBack = true;
    }
    #endregion

    #region Delete
    private void Delete()
    {
  
    }
    #endregion

    #region Save
    private void Save()
    {
        Entity_Empresa  obj;
        obj = new Entity_Empresa();

        Empresa emp;
        emp = new Empresa();
        string result = "";

        try
        {
            obj.IntEmpresa = txtEmpresa.Text == "" ? 0: Convert.ToInt32(txtEmpresa.Text);
            obj.StrNombre = txtNombre.Text;
            obj.StrNombreCorto = txtNombreCorto.Text;
            obj.StrDireccion = txtDireccion.Text;
            obj.StrColonia = txtColonia.Text;
            obj.intTipoMoneda = Convert.ToInt32(cboMoneda.SelectedValue);
            obj.strDelegacion = txtDelegacion.Text;
            obj.intEstado = txtEstado.Text == "" ? 0 : Convert.ToInt32(txtEstado.Text);
            obj.StrRfc = txtRFC.Text;
            obj.strRegImss = txtIMSS.Text;
            obj.strCodigoPostal = txtCP.Text;
            obj.strResponsable = txtRes.Text;
            obj.strRfcResponsable = txtRFCRes.Text;
            obj.strUsuarioAlta = Contabilidad.SEMSession.GetInstance.StrUsuario;
            obj.strUsuarioMod = Contabilidad.SEMSession.GetInstance.StrUsuario;
            obj.strMaquinaAlta = Contabilidad.SEMSession.GetInstance.StrMaquina;
            obj.strMaquinaMod = Contabilidad.SEMSession.GetInstance.StrMaquina;


            result = emp.Save(obj);

            if (result != "")
            {
                Anthem.Manager.RegisterStartupScript(Page.GetType(), "ErrSave", "alert('Se guardó  la empresa " + result.ToString() + ".');", true);
                Clear();
            }
            else
            {
                Anthem.Manager.RegisterStartupScript(Page.GetType(), "ErrSave", "alert('No se puede guardar la empresa " + result.ToString() + ".');", true);
            }
        }
        catch (Exception ex)
        {
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "msgSave", "alert('" + ex.Message + "');", true);
            Clear();
        }

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
                // BindGrid();
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
        int NumEmp=0;

        NumEmp = txtEmpresa.Text == "" ? 0 : Convert.ToInt32(txtEmpresa.Text);
        obj.IntEmpresa = NumEmp;
        obj = emp.Sel(obj);

        if (!(obj == null))
        {
            if (txtEmpresa.Text != "")
            {
                if (obj.StrNombre != null)
                {
                    txtEmpresa.Text = obj.IntEmpresa.ToString();
                    txtNombre.Text = obj.StrNombre.ToString();
                    txtNombreCorto.Text = obj.StrNombreCorto.ToString();
                    txtDireccion.Text = obj.StrDireccion.ToString();
                    txtColonia.Text = obj.StrColonia.ToString();
                    cboMoneda.SelectedValue = obj.intTipoMoneda.ToString();                    
                    txtEstado.Text = obj.intEstado.ToString();
                    Estados();
                    txtRFC.Text = obj.StrRfc.ToString();
                    txtIMSS.Text = obj.strRegImss.ToString();
                    txtCP.Text = obj.strCodigoPostal.ToString();
                    txtRes.Text = obj.strResponsable.ToString();
                    txtRFCRes.Text = obj.strRfcResponsable.ToString();
                    txtDelegacion.Text = obj.strDelegacion.ToString();
                    if (txtEmpresa.Text == "0") txtEmpresa.Text = NumEmp.ToString ();
                }
                else
                {
                    txtEmpresa.Text = "";
                    Clear();
                }
            }
            else
            {
                txtEmpresa.Text = "";
                Clear();
            }
        }
        else
        {
            Clear();
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtEmpresaFocus", "document.getElementById('" + txtEmpresa.ClientID + "').focus();", true);
        }

        txtDireccion.UpdateAfterCallBack = true;
        txtColonia.UpdateAfterCallBack = true;
        cboMoneda.UpdateAfterCallBack = true;
        txtEstado.UpdateAfterCallBack = true;
        txtRFC.UpdateAfterCallBack = true;
        txtIMSS.UpdateAfterCallBack = true;
        txtCP.UpdateAfterCallBack = true;
        txtRes.UpdateAfterCallBack = true;
        txtRFCRes.UpdateAfterCallBack = true;
        txtNombre.UpdateAfterCallBack = true;
        txtNombreCorto.UpdateAfterCallBack = true;
        txtDelegacion.UpdateAfterCallBack = true;
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtNombreFocus", "document.getElementById('" + txtNombre.ClientID + "').focus();", true);
        obj = null;
        emp = null;
    }
    #endregion txtEmpresa_TextChange

    #region Monedas
    private void Monedas()
    {
        List data;
        data = new List();

        cboMoneda.DataSource = data.Moneda(Contabilidad.SEMSession.GetInstance.IntEmpresa, Contabilidad.SEMSession.GetInstance.IntSucursal);
        cboMoneda.DataTextField = "strNombre";
        cboMoneda.DataValueField = "Id";
        cboMoneda.DataBind();

        cboMoneda.UpdateAfterCallBack = true;

        data = null;
    }
    #endregion

    private void Estados()
    {
        Entity_Estados obj;
        obj = new Entity_Estados();

        Estados edo;
        edo = new Estados();

        obj.intEstado = txtEstado.Text == "" ? 0 : Convert.ToInt32(txtEstado.Text);

        obj = edo.Fill(obj);

        if (!(obj == null))
        {
            if (txtEstado.Text != "")
            {
                if (obj.strNombre != null)
                {
                    txtEstadoDes.Text = obj.strNombre.ToString();
                }
                else
                {
                    txtEstado.Text = "";
                    txtEstadoDes.Text = "";
                }
            }
            else
            {
                txtEstado.Text = "";
                txtEstadoDes.Text = "";
            }
        }
        else
        {
            txtEstado.Text = "";
            txtEstadoDes.Text = "";
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtEstadoFocus", "document.getElementById('" + txtEstado.ClientID + "').focus();", true);
        }

        txtEstado.UpdateAfterCallBack = true;
        txtEstadoDes.UpdateAfterCallBack = true;

        edo = null;
        obj = null;
    }
    
    protected void txtEstado_TextChanged(object sender, EventArgs e)
    {
        Estados();
    }
}


