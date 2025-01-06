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

public partial class Contabilidad_Compra_Opciones_AdmonPolizas : System.Web.UI.Page
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
            Ejercicio();            
            toolbar.PrintValid();
            txtEmpresa.Text = Contabilidad.SEMSession.GetInstance.IntEmpresa.ToString();
            TipoPoliza();
            txtEmpresa_TextChange(null, null);            
            cboTipoPol_SelectedIndexChanged(null, null);
        }

        JavaScript();
        RefreshSession();
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

    #region Clear
    private void Clear()
    {
        Values value;
        value = new Values();
        cboEjercicio.SelectedValue = value.Ejercicio(Contabilidad.SEMSession.GetInstance.IntEmpresa, Contabilidad.SEMSession.GetInstance.IntSucursal,1);
        cboTipoPol.SelectedValue = "0";
        cboTipoPol_SelectedIndexChanged(null, null);
        
        cboEjercicio.UpdateAfterCallBack = true;
        cboTipoPol.UpdateAfterCallBack = true;
        DgrdList.UpdateAfterCallBack = true;
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
        int rows;
        rows = DgrdList.Rows.Count;
        string strTipoPoliza = "";
        TiposPoliza tp;
        tp = new TiposPoliza();

        int intEmpresa = txtEmpresa.Text == "" ? Contabilidad.SEMSession.GetInstance.IntEmpresa : Convert.ToInt32(txtEmpresa.Text);
        int intSucursal = Convert.ToInt32(hddSucursal.Value);
        int intEjercicio = Convert.ToInt32 ( cboEjercicio.SelectedValue);
        int intFolioPoliza = 0;
        string Nombretxt = "";
        
        foreach (GridViewRow row in this.DgrdList.Rows)
        {
            for (int i = 0; i < 12; i++)
            {
                if (i == 0) strTipoPoliza = row.Cells[i].Text;
                Nombretxt = "txtM" + Convert.ToString(i + 1);
                row.Cells.ToString();
                TextBox txt = (TextBox)row.Cells[i].FindControl(Nombretxt);
                intFolioPoliza =Convert.ToInt32 (txt.Text);
                int existe = 0;
                existe = tp.ExisteEnc(intEmpresa, intEjercicio, intFolioPoliza, i + 1, strTipoPoliza);
                if (existe == 1)
                {
                    Anthem.Manager.RegisterStartupScript(Page.GetType(), "ErrSave", "alert('No se puede guardar la poliza " + strTipoPoliza.ToString() + "del mes" + (i + 1).ToString() + ", porque ya existe en el encabezado.');", true);
                    BindGrid();
                    return;
                }
                else
                {
                    tp.Save(intEmpresa, intEjercicio, strTipoPoliza, i + 1, intFolioPoliza);
                }
            }
        }
        BindGrid();
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "AlSave", "alert('Se guardaron correctamente las polizas.');", true);
    }
    #endregion

    #region Print
    void Print()
    {

    }
    #endregion       

    #region BindGrid
    private void BindGrid()
    {
        Entity_TiposPoliza obj;
        obj = new Entity_TiposPoliza();

        TiposPoliza tp;
        tp = new TiposPoliza();

        obj.IntEmpresa = txtEmpresa.Text == "" ? Contabilidad.SEMSession.GetInstance.IntEmpresa : Convert.ToInt32(txtEmpresa.Text);
        obj.intEjercicio = Convert.ToInt32 ( cboEjercicio.SelectedValue);
        obj.strTipoPoliza = cboTipoPol.SelectedValue;

        DgrdList.DataSource = tp.det(obj); 
        DgrdList.DataBind();
        DgrdList.UpdateAfterCallBack = true;

        obj = null;
        tp = null;
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
    
    #region cboEjercicio
    private void Ejercicio()
    {
        List  list;
        list = new List();

        cboEjercicio.DataSource = list.Ejercicio(Contabilidad.SEMSession.GetInstance.IntEmpresa, Contabilidad.SEMSession.GetInstance.IntSucursal);
        cboEjercicio.DataTextField = "Id";
        cboEjercicio.DataValueField = "strNombre";
        cboEjercicio.DataBind();

        cboEjercicio.SelectedValue = DateTime.Now.Date.Year.ToString();

        cboEjercicio.UpdateAfterCallBack = true;

        list = null;   
    }
    #endregion cboEjercicio

    #region cboTipoPoliza
    private void TipoPoliza()
    {
        TiposPoliza tp;
        tp = new TiposPoliza();

        Entity_TiposPoliza  obj;
        obj = new Entity_TiposPoliza();

        obj.IntEmpresa = txtEmpresa.Text == "" ? Contabilidad.SEMSession.GetInstance.IntEmpresa : Convert.ToInt32(txtEmpresa.Text);
        obj.intEjercicio = Convert.ToInt32 ( cboEjercicio.SelectedValue);

        cboTipoPol.DataSource = tp.Sel(obj);
        cboTipoPol.DataTextField = "strNombreCbo";
        cboTipoPol.DataValueField = "strTipoPoliza";
        cboTipoPol.DataBind();

        cboTipoPol.Items.Insert(0, new ListItem("-- Todos --", "0"));
        cboTipoPol.SelectedIndex = 0;
        cboTipoPol.UpdateAfterCallBack = true;
        tp = null;
        obj = null;
    }
    #endregion cboTipoPoliza

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

    #region DgrdList_RowCreated
    protected void DgrdList_RowCreated(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            DataRowView dr = (DataRowView)e.Row.DataItem;
            if (dr != null)
            {
                Anthem.TextBox txtM1 = (Anthem.TextBox)e.Row.FindControl("txtM1");
                Anthem.TextBox txtM2 = (Anthem.TextBox)e.Row.FindControl("txtM2");
                Anthem.TextBox txtM3 = (Anthem.TextBox)e.Row.FindControl("txtM3");
                Anthem.TextBox txtM4 = (Anthem.TextBox)e.Row.FindControl("txtM4");
                Anthem.TextBox txtM5 = (Anthem.TextBox)e.Row.FindControl("txtM5");
                Anthem.TextBox txtM6 = (Anthem.TextBox)e.Row.FindControl("txtM6");
                Anthem.TextBox txtM7 = (Anthem.TextBox)e.Row.FindControl("txtM7");
                Anthem.TextBox txtM8 = (Anthem.TextBox)e.Row.FindControl("txtM8");
                Anthem.TextBox txtM9 = (Anthem.TextBox)e.Row.FindControl("txtM9");
                Anthem.TextBox txtM10 = (Anthem.TextBox)e.Row.FindControl("txtM10");
                Anthem.TextBox txtM11 = (Anthem.TextBox)e.Row.FindControl("txtM11");
                Anthem.TextBox txtM12 = (Anthem.TextBox)e.Row.FindControl("txtM12");

                e.Row.Style.Value = "background-color:#FAFAFA;color:Black;font-family: Tahoma;font-size: 8pt;Height:15px;font-weight:bold;";


                txtM1.Style.Value = "color:Black;font-family: Tahoma;font-size: 8pt;Height:15px;text-align:right;";
                txtM2.Style.Value = "color:Black;font-family: Tahoma;font-size: 8pt;Height:15px;text-align:right;";
                txtM3.Style.Value = "color:Black;font-family: Tahoma;font-size: 8pt;Height:15px;text-align:right;";
                txtM4.Style.Value = "color:Black;font-family: Tahoma;font-size: 8pt;Height:15px;text-align:right;";
                txtM5.Style.Value = "color:Black;font-family: Tahoma;font-size: 8pt;Height:15px;text-align:right;";
                txtM6.Style.Value = "color:Black;font-family: Tahoma;font-size: 8pt;Height:15px;text-align:right;";
                txtM7.Style.Value = "color:Black;font-family: Tahoma;font-size: 8pt;Height:15px;text-align:right;";
                txtM8.Style.Value = "color:Black;font-family: Tahoma;font-size: 8pt;Height:15px;text-align:right;";
                txtM9.Style.Value = "color:Black;font-family: Tahoma;font-size: 8pt;Height:15px;text-align:right;";
                txtM10.Style.Value = "color:Black;font-family: Tahoma;font-size: 8pt;Height:15px;text-align:right;";
                txtM11.Style.Value = "color:Black;font-family: Tahoma;font-size: 8pt;Height:15px;text-align:right;";
                txtM12.Style.Value = "color:Black;font-family: Tahoma;font-size: 8pt;Height:15px;text-align:right;";

                txtM1.Attributes.Add("onkeypress", "OnlyNumber();");
                txtM2.Attributes.Add("onkeypress", "OnlyNumber();");
                txtM3.Attributes.Add("onkeypress", "OnlyNumber();");
                txtM4.Attributes.Add("onkeypress", "OnlyNumber();");
                txtM5.Attributes.Add("onkeypress", "OnlyNumber();");
                txtM6.Attributes.Add("onkeypress", "OnlyNumber();");
                txtM7.Attributes.Add("onkeypress", "OnlyNumber();");
                txtM8.Attributes.Add("onkeypress", "OnlyNumber();");
                txtM9.Attributes.Add("onkeypress", "OnlyNumber();");
                txtM10.Attributes.Add("onkeypress", "OnlyNumber();");
                txtM11.Attributes.Add("onkeypress", "OnlyNumber();");
                txtM12.Attributes.Add("onkeypress", "OnlyNumber();");

                txtM1.UpdateAfterCallBack = true;
                txtM2.UpdateAfterCallBack = true;
                txtM3.UpdateAfterCallBack = true;
                txtM4.UpdateAfterCallBack = true;
                txtM5.UpdateAfterCallBack = true;
                txtM6.UpdateAfterCallBack = true;
                txtM7.UpdateAfterCallBack = true;
                txtM8.UpdateAfterCallBack = true;
                txtM9.UpdateAfterCallBack = true;
                txtM10.UpdateAfterCallBack = true;
                txtM11.UpdateAfterCallBack = true;
                txtM12.UpdateAfterCallBack = true;
            }
        }
    }
    #endregion DgrdList

    #region DgrdList_RowDeleting
    protected void DgrdList_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {

    }
    #endregion DgrdList_RowDeleting

    #region cboEjercicio_SelectedIndexChanged
    protected void cboEjercicio_SelectedIndexChanged(object sender, EventArgs e)
    {
        TipoPoliza();
        BindGrid();
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "cboTipoPolFocus", "document.getElementById('" + cboTipoPol.ClientID + "').focus();", true);
    }
    #endregion

    #region cboTipoPol_SelectedIndexChanged
    protected void cboTipoPol_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindGrid();
    }
    #endregion

}


