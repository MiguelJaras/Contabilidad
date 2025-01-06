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

public partial class Contabilidad_Compra_Opciones_EdoFinancieroRubros : System.Web.UI.Page
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
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtEdoFin", "var objText = new VetecText('" + txtEdoFin.ClientID + "', 'number', 12);", true);
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtEdoFinDes", "var objText = new VetecText('" + txtEdoFinDes.ClientID + "', 'text', 100);", true);
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtRubro", "var objText = new VetecText('" + txtRubro.ClientID + "', 'number', 12);", true);
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
        txtEdoFin.Text = "";
        txtEdoFinDes.Text = "";
        txtRubro.Text = "";
        txtNombre.Text = "";
        DgrdList.DataSource = null;
        DgrdList.DataBind();

        DgrdList.UpdateAfterCallBack = true;
        txtEdoFin.UpdateAfterCallBack = true;
        txtEdoFinDes.UpdateAfterCallBack = true;
        txtRubro.UpdateAfterCallBack = true;
        txtNombre.UpdateAfterCallBack = true;
    }
    #endregion

    #region Event
    void Me_Event(object sender, HandlerArgs args)
    {
        switch (args.Event)
        {
            case Event.Save:
                //Save();
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
                Bindgrid();
                break;
            default:
                break;
        }
    }
    #endregion

    #region BindGrid
    private void Bindgrid()
    {
        Entity_EstadosFinRubros obj;
        obj = new Entity_EstadosFinRubros();

        EstadosFinRubros rub;
        rub = new EstadosFinRubros();
        DataTable dt = null;

        obj.intEmpresa = txtEmpresa.Text == "" ? Contabilidad.SEMSession.GetInstance.IntEmpresa : Convert.ToInt32(txtEmpresa.Text);
        obj.intEstadoFin = txtEdoFin.Text == "" ? 0 : Convert.ToInt32(txtEdoFin.Text);

        dt = rub.GetList(obj);

        DgrdList.DataSource = dt;
        DgrdList.DataBind();
        DgrdList.UpdateAfterCallBack = true;

        obj = null;
        rub = null;
    }
    #endregion


    #region TextChange

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

    #region txtEdoFin_TextChanged
    protected void txtEdoFin_TextChanged(object sender, EventArgs e)
    {
        Entity_EdoFinancieros obj;
        obj = new Entity_EdoFinancieros() ;
        EdoFinancieros EdoF;
        EdoF = new EdoFinancieros();

        obj.intEstadoFin = txtEdoFin.Text == "" ? 0 : Convert.ToInt32(txtEdoFin.Text);
        obj = EdoF.Fill(obj);

        if (!(obj == null))
        {
            if (txtEdoFin.Text != "")
            {
                if (obj.strNombre != null)
                {
                    txtEdoFinDes.Text = obj.strNombre.ToString();
                    Bindgrid();
                }
                else
                {
                    txtEdoFin.Text = "";
                    txtEdoFinDes.Text = "";
                    //Clear();
                }
            }
            else
            {
                txtEdoFin.Text = "";
                txtEdoFinDes.Text = "";
                Clear();
            }
        }
        else
        {
            txtEdoFin.Text = "";
            txtEdoFinDes.Text = "";
            Clear();
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtEdoFinFocus", "document.getElementById('" + txtEdoFin.ClientID + "').focus();", true);
        }
        txtEdoFin.UpdateAfterCallBack = true;
        txtEdoFinDes.UpdateAfterCallBack = true;

        EdoF = null;
        obj = null;

    }
    #endregion

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
                    //txtNombreCorto.Text = obj.strNombreCorto.ToString();
                }
            }
            else
            {
                txtNombre.Text = "";
                txtRubro.Text = "";
            }
        }
        else
        {
            txtNombre.Text = "";
            txtRubro.Text = "";
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtNombreFocus", "document.getElementById('" + txtRubro.ClientID + "').focus();", true);
        }

        txtNombre.UpdateAfterCallBack = true;
        txtRubro.UpdateAfterCallBack = true;

        rub = null;
        obj = null;
    }
    #endregion

    #endregion

    #region Agregar, Eliminar

    #region DgrdList_RowDeleting
    protected void DgrdList_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        Entity_EstadosFinRubros obj;
        obj = new Entity_EstadosFinRubros();

        EstadosFinRubros rub;
        rub = new EstadosFinRubros();

        try
        {
            obj.intEmpresa = txtEmpresa.Text == "" ? Contabilidad.SEMSession.GetInstance.IntEmpresa : Convert.ToInt32(txtEmpresa.Text);
            obj.intRubro = (int)DgrdList.DataKeys[e.RowIndex].Values[0];
            obj.intEstadoFin = (int)DgrdList.DataKeys[e.RowIndex].Values[1];

            string result = "";
            result = rub.Delete(obj);
            Bindgrid();


            if (result != "")
            {
                Anthem.Manager.RegisterStartupScript(Page.GetType(), "ErrDel", "alert('Se eliminó  el estado financiero " + txtEdoFin.Text + " ,rubro " + result.ToString() + " .');", true);
                Clear();
            }
            else
            {
                Anthem.Manager.RegisterStartupScript(Page.GetType(), "CorrDel", "alert('No se puede eliminar el estado financiero " + txtEdoFin.Text + " ,rubro " + result.ToString() + ".');", true);
            }
        }
        catch (Exception ex)
        {
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "msgDel", "alert('" + ex.Message + "');", true);
        }

        obj = null;
        rub = null;
    }
    #endregion

    #region btnAgregar_Click
    protected void btnAgregar_Click(object sender, EventArgs e)
    {
        
            Entity_EstadosFinRubros obj;
            obj = new Entity_EstadosFinRubros();

            EstadosFinRubros rub;
            rub = new EstadosFinRubros();
        try
        {
            obj.intEmpresa = txtEmpresa.Text == "" ? Contabilidad.SEMSession.GetInstance.IntEmpresa : Convert.ToInt32(txtEmpresa.Text);
            obj.intRubro = txtRubro.Text == "" ? 0 : Convert.ToInt32(txtRubro.Text);
            obj.intEstadoFin = txtEdoFin.Text == "" ? 0 : Convert.ToInt32(txtEdoFin.Text);
            obj.strMaquinaAlta = Contabilidad.SEMSession.GetInstance.StrMaquina.ToString();
            obj.strMaquinaMod = Contabilidad.SEMSession.GetInstance.StrMaquina.ToString();
            obj.strUsuarioAlta = Contabilidad.SEMSession.GetInstance.StrUsuario.ToString();
            obj.strUsuarioMod = Contabilidad.SEMSession.GetInstance.StrUsuario.ToString();
            obj.datFechaAlta = DateTime.Now;
            obj.datFechaMod = DateTime.Now;

            string res = "";
            res = rub.Save(obj);
            Bindgrid();

            if (res != "")
            {
                Anthem.Manager.RegisterStartupScript(Page.GetType(), "ErrSave", "alert('Se agregó  el estado financiero " + txtEdoFin .Text +" ,rubro " + res.ToString() + ".');", true);
                Clear();
            }
            else
            {
                Anthem.Manager.RegisterStartupScript(Page.GetType(), "ErrSave", "alert('No se puede agregar el estado financiero "+ txtEdoFin .Text +" ,rubro " + res.ToString() + ".');", true);
            }
        }
        catch (Exception ex)
        {
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "msgSave", "alert('" + ex.Message + "');", true);
        }

        obj = null;
        rub = null;
    }
    #endregion

    #endregion
}


