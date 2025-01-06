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
using System.IO;
using System.Data.OleDb;
using Contabilidad.Entity;
using Contabilidad.Bussines;
using System.Net.Mail;
using CrystalDecisions.CrystalReports.Engine;
using CrystalDecisions.Shared;

public partial class Pages_Compras_Catalogos_TipoMovto : System.Web.UI.Page
{
    public string realPath;
    Pages_Base toolbar;

    protected void Page_Load(object sender, EventArgs e)
    {
        toolbar = (Pages_Base)this.Master;
        toolbar.PageEvent += new HandlerEvent(Me_Event);

        string end = (Request.ApplicationPath.EndsWith("/")) ? "" : "/";
        string path = Request.ApplicationPath + end;
        //realPath = String.Format("http://{0}{1}{2}", Request.Url.Authority, path, "Img/dxpcFooterBack.gif");
        // txtCodigoAgrupador.Attributes.Add("onkeypress", "KeyPressOnlyDecimal(this, 2, 2);");

        Anthem.Manager.Register(this);
        if (!IsPostBack && !IsCallback)
        { 
            txtEmpresa.Text = Contabilidad.SEMSession.GetInstance.IntEmpresa.ToString();
            txtEmpresa_TextChange(null, null);
            New();
        } 
        
        JavaScript();
    }

    protected void Page_PreRender(object sender, EventArgs e)
    {
        
        toolbar.Email(false);
        toolbar.Print(false);
        toolbar.List(false);
    }

    #region Event
    void Me_Event(object sender, HandlerArgs args)
    {
        switch (args.Event)
        {
            case Event.Save:
                Save();
                break;
            case Event.New:
                New();
                break;
            case Event.Delete:
                Delete();
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

    #region JavaScript
    private void JavaScript()
    {
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtTipoMovto", "var objText = new VetecText('" + txtTipoMovto.ClientID + "', 'number', 50);", true);
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtEmpresa", "var objText = new VetecText('" + txtEmpresa.ClientID + "', 'number', 50);", true);
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtNombre", "var objText = new VetecText('" + txtNombre.ClientID + "', 'text', 50);", true);
    }
    #endregion

    #region txtRowEdit_Change
    protected void txtRowEdit_Change(object sender, EventArgs e)
    {
    }  
    #endregion  

    #region llena Combos
    private void llenaCombos()
    {
        cboNaturaleza.Items.Insert(0, new ListItem("CARGO", "0"));
        cboNaturaleza.Items.Insert(1, new ListItem("ABONO", "1"));

        cboNaturaleza.SelectedIndex = 0;
        cboNaturaleza.UpdateAfterCallBack = true;
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
        llenaCombos();

        Anthem.Manager.RegisterStartupScript(Page.GetType(), "focCuen", "document.all('ctl00_CPHBase_txtCuenta').focus()", true);

        obj = null;
        emp = null;
    }
    #endregion

 
    #region Clear
    private void Clear()
    {
        txtNombre.Text = "";
        txtNombre.UpdateAfterCallBack = true;

        chkFactura.Checked = false;
        chkFactura.UpdateAfterCallBack = true;

        Anthem.Manager.RegisterStartupScript(Page.GetType(), "focus", "document.all('ctl00_CPHBase_txtNombre').focus()", true);
    }

    #endregion

    #region New
    private void New()
    {

        txtNombre.Text = "";
        txtNombre.UpdateAfterCallBack = true;
        chkFactura.Checked = false;
        chkFactura.UpdateAfterCallBack = true;

        Entity_TipoMovimiento obj;
        obj = new Entity_TipoMovimiento();
        TipoMovimiento tm;
        tm = new TipoMovimiento();
        string res = "";
        obj.IntEmpresa = txtEmpresa.Text == "" ? Contabilidad.SEMSession.GetInstance.IntEmpresa : Convert.ToInt32(txtEmpresa.Text);
        res = tm.Inc(obj);
        txtTipoMovto.Text = res;

        txtTipoMovto.UpdateAfterCallBack = true;
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "focus", "document.all('ctl00_CPHBase_txtNombre').focus()", true);
    }

    #endregion

   
    #region Save
    void Save()
    {
        try
        {
            Entity_TipoMovimiento obj;
            obj = new Entity_TipoMovimiento();
            TipoMovimiento tm;
            tm = new TipoMovimiento();
            string res= "false" ;

            obj.IntEmpresa = txtEmpresa.Text == "" ? Contabilidad.SEMSession.GetInstance.IntEmpresa : Convert.ToInt32(txtEmpresa.Text);
            obj.IntMovto = txtTipoMovto.Text == "" ? 0 : Convert.ToInt32(txtTipoMovto.Text);
            obj.StrNombre = txtNombre.Text;
            if (cboNaturaleza.SelectedValue == "0")
                obj.StrNaturaleza = "C";
            else
                obj.StrNaturaleza = "A";
            obj.BFactura = chkFactura.Checked;
            obj.StrAuditMod = Contabilidad.SEMSession.GetInstance.StrUsuario;
            obj.StrAuditAlta = Contabilidad.SEMSession.GetInstance.StrUsuario + " " + DateTime.Now.ToString("dd/MM/yyyy");
            res = tm.Save(obj);

            if (res == "true")
            {
                Anthem.Manager.RegisterStartupScript(Page.GetType(), "Alerta", "alert('La información se guardo correctamente.');", true);
                New();
            }
            else
            {
                Anthem.Manager.RegisterStartupScript(Page.GetType(), "Alerta", "alert('Ocurrió un error al guardar la información.');", true);
            }
            
        }
        catch (Exception ex)
        {
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "mssErrr", "alert('" + ex.Message + "');", true);
        }
    }
    #endregion


    #region Delete
    void Delete()
    {
        try
        {
            Entity_TipoMovimiento obj;
            obj = new Entity_TipoMovimiento();
            TipoMovimiento tm;
            tm = new TipoMovimiento();
            string res = "false";

            obj.IntEmpresa = txtEmpresa.Text == "" ? Contabilidad.SEMSession.GetInstance.IntEmpresa : Convert.ToInt32(txtEmpresa.Text);
            obj.IntMovto = txtTipoMovto.Text == "" ? 0 : Convert.ToInt32(txtTipoMovto.Text);
            res = tm.Delete(obj);

            if (res == "true")
            {
                Anthem.Manager.RegisterStartupScript(Page.GetType(), "Alerta", "alert('La información se eliminó correctamente.');", true);
                Clear();
            }
            else
                Anthem.Manager.RegisterStartupScript(Page.GetType(), "Alerta", "alert('Ocurrió un error al eliminar la información.');", true);

        }
        catch (Exception ex)
        {
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "msfPolErr", "alert('" + ex.Message + "');", true);
        }
    }
    #endregion


    protected void txtTipoMovto_TextChanged(object sender, EventArgs e)
    {
        Entity_TipoMovimiento obj;
        obj = new Entity_TipoMovimiento();
        TipoMovimiento tm;
        tm = new TipoMovimiento();

        obj.IntEmpresa = txtEmpresa.Text == "" ? Contabilidad.SEMSession.GetInstance.IntEmpresa : Convert.ToInt32(txtEmpresa.Text);
        obj.IntMovto = txtTipoMovto.Text == "" ? 0 : Convert.ToInt32(txtTipoMovto.Text);
        obj = tm.Sel(obj);

        if (!(obj == null))
        {
            if (txtTipoMovto.Text != "")
            {
                if (obj.StrNombre != null)
                {
                    txtNombre.Text = obj.StrNombre.ToString();
                    if (obj.StrNaturaleza == "C")
                        cboNaturaleza.SelectedValue = "0";
                    else
                        cboNaturaleza.SelectedValue = "1";
                    chkFactura.Checked = obj.BFactura;


                    txtNombre.UpdateAfterCallBack = true;
                    cboNaturaleza.UpdateAfterCallBack = true;
                    chkFactura.UpdateAfterCallBack = true;
                }
                else
                {
                    txtNombre.Text = "";
                    chkFactura.Checked = false;

                    txtNombre.UpdateAfterCallBack = true;
                    chkFactura.UpdateAfterCallBack = true;

                    Anthem.Manager.RegisterStartupScript(Page.GetType(), "txttxtTipoMovtofocus", "document.getElementById('" + txtTipoMovto.ClientID + "').focus();", true);
                }
            }
            else
            {
                txtNombre.Text = "";
                chkFactura.Checked = false;

                txtNombre.UpdateAfterCallBack = true;
                chkFactura.UpdateAfterCallBack = true;

                Anthem.Manager.RegisterStartupScript(Page.GetType(), "txttxtTipoMovtofocus", "document.getElementById('" + txtTipoMovto.ClientID + "').focus();", true);
            }
        }
        else
        {
            txtNombre.Text = "";
            chkFactura.Checked = false;

            txtNombre.UpdateAfterCallBack = true;
            chkFactura.UpdateAfterCallBack = true;

            Anthem.Manager.RegisterStartupScript(Page.GetType(), "txttxtTipoMovtofocus", "document.getElementById('" + txtTipoMovto.ClientID + "').focus();", true);
        }


        obj = null;
        tm = null;
    }
}
