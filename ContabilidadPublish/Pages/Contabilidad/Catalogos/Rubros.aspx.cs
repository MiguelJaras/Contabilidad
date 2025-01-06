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

public partial class Contabilidad_Compra_Opciones_Rubros : System.Web.UI.Page
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
            RubrosTipo();
        }

        JavaScript();
        RefreshSession();
    }

    protected void Page_PreRender(object sender, EventArgs e)
    {
        toolbar.List(false);
        toolbar.Print(false);
        toolbar.Email(false);
    }

    #region JavaScript
    private void JavaScript()
    {
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtEmpresa", "var objText = new VetecText('" + txtEmpresa.ClientID + "', 'number', 12);", true);
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtRubro", "var objText = new VetecText('" + txtRubro.ClientID + "', 'number', 12);", true);
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtNombre", "var objText = new VetecText('" + txtNombre.ClientID + "', 'text', 100);", true);
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtNombreCorto", "var objText = new VetecText('" + txtNombreCorto.ClientID + "', 'text', 100);", true);       
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

    #region RubrosTipo
    private void RubrosTipo()
    {
        List list;
        list = new List();

        cboRubrosTipos.DataSource = list.RubrosTipo(Contabilidad.SEMSession.GetInstance.IntEmpresa, Contabilidad.SEMSession.GetInstance.IntSucursal);
        cboRubrosTipos.DataTextField = "strNombre";
        cboRubrosTipos.DataValueField = "Id";
        cboRubrosTipos.DataBind();

        cboRubrosTipos.UpdateAfterCallBack = true;
        

        list = null;

    }
    #endregion 

    #region Signo
    private void Signo()
    {
        cboSigno.Items.Insert(0, new ListItem("-- Seleccione --", "0"));
        cboSigno.SelectedIndex = 0;

        cboSigno.UpdateAfterCallBack = true;
    }
    #endregion

    #region Clear
    private void Clear()
    {
        Values value;
        value = new Values();
        txtRubro.Text = "";
        txtNombre.Text = "";
        txtNombreCorto.Text = "";
        cboSigno.SelectedIndex = -1;
        cboRubrosTipos.SelectedIndex = 0;

        txtRubro.UpdateAfterCallBack = true;
        txtNombre.UpdateAfterCallBack = true;
        txtNombreCorto.UpdateAfterCallBack = true;
        cboSigno.UpdateAfterCallBack = true;
        cboRubrosTipos.UpdateAfterCallBack = true;
    }
    #endregion

    #region Delete
    private void Delete()
    {
        Entity_Rubros obj;
        obj = new Entity_Rubros();

        Rubros rub;
        rub = new Rubros();

        try
        {
            obj.intEmpresa = txtEmpresa.Text == "" ? Contabilidad.SEMSession.GetInstance.IntEmpresa : Convert.ToInt32(txtEmpresa.Text);
            obj.intRubro = txtRubro.Text == "" ? 0 : Convert.ToInt32(txtRubro.Text);
         
            string result = "";
            result = rub.Delete(obj);

            if (result != "")
            {
                Anthem.Manager.RegisterStartupScript(Page.GetType(), "ErrDel2", "alert('Se elimino correctamente.');", true);
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
    }
    #endregion

    #region Save
    private void Save()
    {
        Entity_Rubros obj;
        obj = new Entity_Rubros();

        Rubros rub;
        rub = new Rubros();

        try
        {
            obj.intEmpresa = txtEmpresa.Text == "" ? Contabilidad.SEMSession.GetInstance.IntEmpresa : Convert.ToInt32(txtEmpresa.Text);
            obj.intRubro = txtRubro.Text == "" ? 0 : Convert.ToInt32(txtRubro.Text);
            obj.strNombre = txtNombre.Text;
            obj.strNombreCorto = txtNombreCorto.Text;
            if (rbSi.Checked) 
                obj.intIndCambiaSignoSalida = 1;
            else
                obj.intIndCambiaSignoSalida = 0;

            if (cboSigno.SelectedValue == "1")
                obj.strSignoOperacionArit = cboSigno.SelectedItem.Text;
            obj.strTipoRubro = cboRubrosTipos.SelectedValue;
            obj.datFechaAlta = DateTime.Now;
            obj.strMaquinaAlta = Contabilidad.SEMSession.GetInstance.StrMaquina.ToString();
            obj.strUsuarioAlta = Contabilidad.SEMSession.GetInstance.StrUsuario.ToString();
            obj.strUsuarioMod = Contabilidad.SEMSession.GetInstance.StrUsuario.ToString();
            obj.strMaquinaMod = Contabilidad.SEMSession.GetInstance.StrMaquina.ToString();
            obj.datFechaMod = DateTime.Now;

            string  result = "";
            result = rub.Save(obj);

            if (result != "")
            {
                Anthem.Manager.RegisterStartupScript(Page.GetType(), "Alerta", "alert('La información se guardo correctamente.');", true);
                Clear();
            }
            else
            {
                Anthem.Manager.RegisterStartupScript(Page.GetType(), "ErrSave", "alert('No se puede guardar el rubro " + result.ToString()+".');", true);
            }
        }
        catch (Exception ex)
        {
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "msgSave", "alert('" + ex.Message + "');", true);
            Clear();
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
                Delete();
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
                    txtNombreCorto.Text = obj.strNombreCorto.ToString();
                    if (obj.strSignoOperacionArit == "+")
                        cboSigno.SelectedValue = "1";
                    else
                        cboSigno.SelectedValue = "0";
                    cboRubrosTipos.SelectedValue = obj.strTipoRubro.ToString ();

                    if (obj.intIndCambiaSignoSalida  == 1)
                    {
                        rbSi.Checked = true;
                        rbNo.Checked = false;
                    }
                    else
                    {
                        rbNo.Checked = true;
                        rbSi.Checked = false;
                    }

                }
            }
            else
            {
                txtNombre.Text = "";
                txtNombreCorto.Text = "";
                Clear();
            }
        }
        else
        {
            int rubro =0;
            rubro = txtRubro.Text == "" ? 0 : Convert.ToInt32(txtRubro.Text);
            Clear();
            txtRubro.Text = rubro.ToString ();
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtNombreFocus", "document.getElementById('" + txtNombre.ClientID + "').focus();", true);
        }
        
        txtNombre.UpdateAfterCallBack = true;
        txtNombreCorto.UpdateAfterCallBack = true;
        cboSigno.UpdateAfterCallBack = true;
        cboRubrosTipos.UpdateAfterCallBack = true;
        rbSi.UpdateAfterCallBack = true;
        rbNo.UpdateAfterCallBack = true;

        rub = null;
        obj = null;
    }
    #endregion

}


