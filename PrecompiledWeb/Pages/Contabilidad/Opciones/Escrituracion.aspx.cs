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

public partial class Contabilidad_Compra_Opciones_Escrituracion : System.Web.UI.Page
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
        if (!IsPostBack && !IsCallback)
        {
            txtEmpresa.Text = "2";
            txtEmpresa_TextChange(null, null);
            Year();
            Month();
            cboMonth.SelectedValue = DateTime.Now.Month.ToString();
            cboEjercicio.SelectedValue = DateTime.Now.Year.ToString();

            txtEmpresa.Enabled = false;
            txtNombreEmpresa.Enabled = false;

            rblDesplegar.SelectedValue = "0";
            FillColionia();
            BindGrid();
        }

        JavaScript();
        RefreshSession();
    }

    protected void Page_PreRender(object sender, EventArgs e)
    {
        toolbar.Print(false);
        toolbar.Exportar(false);
        toolbar.Email(false);
        toolbar.Delete(false);
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

        cboEjercicio.DataSource = list.Ejercicio(Contabilidad.SEMSession.GetInstance.IntEmpresa, Contabilidad.SEMSession.GetInstance.IntSucursal);
        cboEjercicio.DataTextField = "Id";
        cboEjercicio.DataValueField = "strNombre";
        cboEjercicio.DataBind();

        cboEjercicio.Items.Insert(0, new ListItem("-- Seleccione --", "0"));
        cboEjercicio.SelectedIndex = 0;
        cboEjercicio.UpdateAfterCallBack = true;

        cboEjercicio.UpdateAfterCallBack = true;

        list = null;
    }
    #endregion Year  

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
        cboMonth.SelectedValue = DateTime.Now.Month.ToString();
        cboEjercicio.SelectedValue = DateTime.Now.Year.ToString();
        cboColonia.SelectedIndex = -1;
        grdEscrituracion.DataSource = null;
        grdEscrituracion.DataBind();

        grdEscrituracion.UpdateAfterCallBack = true;
        cboMonth.UpdateAfterCallBack = true;
        cboColonia.UpdateAfterCallBack = true;
        cboEjercicio.UpdateAfterCallBack = true;
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
        bool execute;
        int intProspecto;
        DateTime fecha;
        for (int i = 0; i < grdEscrituracion.Rows.Count; i++)
        {
            Anthem.CheckBox chkEscriturar = (Anthem.CheckBox)grdEscrituracion.Rows[i].FindControl("chkEscriturar");
            if (chkEscriturar.Checked)
            {
                Anthem.TextBox txtFecha = (Anthem.TextBox)grdEscrituracion.Rows[i].FindControl("txtFecha");
                fecha = Convert.ToDateTime(txtFecha.Text);
                intProspecto = Convert.ToInt32(grdEscrituracion.DataKeys[i].Value);

                Entity_Prospectos obj;
                obj = new Entity_Prospectos();

                Prospecto pros;
                pros = new Prospecto();

                obj.intProspecto = intProspecto;
                obj.datFechaVisita= fecha;
                obj.StrUsuario = Contabilidad.SEMSession.GetInstance.StrUsuario;
                obj.StrMaquina = Contabilidad.SEMSession.GetInstance.StrMaquina;

                execute = pros.EscSave(obj);

                pros = null;
                obj = null;
            }
        }
        BindGrid();
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

    #region FillColionia
    private void FillColionia()
    {
        Colonia col;
        col = new Colonia();

        DataTable dt;
        dt = col.GetList();

        cboColonia.DataSource = dt;
        cboColonia.DataTextField = "strNombre";
        cboColonia.DataValueField = "intColonia";
        cboColonia.DataBind();

        cboColonia.Items.Insert(0, new ListItem("Seleccione...", "0"));
        cboColonia.UpdateAfterCallBack = true;

        col = null;
    }
    #endregion

    #region cboTerreno_SelectedIndexChanged
    protected void cboTerreno_SelectedIndexChanged(object sender, EventArgs e)
    {
        try
        {
            Prospecto pro;
            pro = new Prospecto();

            Entity_Prospectos obj;
            obj = new Entity_Prospectos();

            Anthem.DropDownList cboTerreno = (Anthem.DropDownList)sender;
            GridViewRow row = (GridViewRow)cboTerreno.NamingContainer;
            string value;

            obj.intProspecto = Convert.ToInt32(grdEscrituracion.DataKeys[row.DataItemIndex].Value.ToString());
            obj.intEmpresa = Convert.ToInt32(cboTerreno.SelectedValue);

            value = pro.UpdateTerreno(obj);

            Anthem.Manager.RegisterStartupScript(Page.GetType(), "msgSave2", "alert('Se guardo correctamente.');", true);
            BindGrid();

            obj = null;
            pro = null;
        }
        catch (Exception ex)
        {
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "x52", "alert('" + ex.Message + "');", true);
        }
    }
    #endregion

    #region cboColonia_SelectedIndexChanged
    protected void cboColonia_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindGrid();
    }
    #endregion

    #region cboMonth_Change
    protected void cboMonth_Change(object sender, EventArgs e)
    {
        BindGrid();
    }
    #endregion    

    #region BindGrid
    private void BindGrid()
    {
        Entity_Prospectos obj;
        obj = new Entity_Prospectos();

        Prospecto pro;
        pro = new Prospecto();

        DataTable dt;

        obj.intEmpresa = txtEmpresa.Text == "" ? Contabilidad.SEMSession.GetInstance.IntEmpresa : Convert.ToInt32(txtEmpresa.Text);
        obj.intSucursal = Convert.ToInt32 (  hddSucursal.Value);
        obj.intColonia= Convert.ToInt32(cboColonia.SelectedValue);
        obj.IntParametroInicial = Convert.ToInt32 ( Direction.ToString()); //Direction
        obj.SortExpression =SortExpression;
        obj.IntParametroFinal = Convert.ToInt32(rblDesplegar.SelectedValue);//bAplicado
        obj.IntProveedorInicial = Convert.ToInt32(cboEjercicio.SelectedValue);//intEjercicio
        obj.IntProveedorFinal= Convert.ToInt32(cboMonth.SelectedValue);//intMes

        dt = pro.EscList(obj);

        grdEscrituracion.DataSource = dt;
        grdEscrituracion.DataBind();
        grdEscrituracion.UpdateAfterCallBack = true;

        pro = null;
        obj = null;
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

    #region chkAplicado_Change
    protected void chkAplicado_Change(object sender, EventArgs e)
    {
        BindGrid();
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
                Anthem.TextBox txt = (Anthem.TextBox)e.Row.FindControl("txtFecha");
                Anthem.ImageButton lkn = (Anthem.ImageButton)e.Row.FindControl("ImgDate");
                Anthem.CheckBox chkEscriturar = (Anthem.CheckBox)e.Row.FindControl("chkEscriturar");
                Anthem.LinkButton lknPoliza = (Anthem.LinkButton)e.Row.FindControl("lknPoliza");
                Anthem.DropDownList cboTerreno = (Anthem.DropDownList)e.Row.FindControl("cboTerreno");
                Anthem.LinkButton lknPolizaMaple = (Anthem.LinkButton)e.Row.FindControl("lknPolizaMaple");

                cboTerreno.Items.Insert(0, new ListItem("Fideicomiso", "1"));
                cboTerreno.Items.Insert(1, new ListItem("Desarrollo", "2"));
                cboTerreno.Items.Insert(2, new ListItem("Maple", "3"));

                string PolizaTerreno = dataRowView.Row["strPolizaTerreno"].ToString();
                string poliza = dataRowView.Row["strPoliza"].ToString();
                string intEmpresaTerreno = dataRowView.Row["intEmpresaTerreno"].ToString();
                string intEjercicio = dataRowView.Row["intEjercicio"].ToString();
                string empresa = txtEmpresa.Text == "" ? Contabilidad.SEMSession.GetInstance.IntEmpresa.ToString () : txtEmpresa.Text;
                string terreno = dataRowView.Row["Terreno"].ToString();
                decimal dblTerreno = Convert.ToDecimal(dataRowView.Row["dblTerreno"].ToString());
                decimal dblEdificacion = Convert.ToDecimal(dataRowView.Row["dblEdificacion"].ToString());

                cboTerreno.SelectedValue = intEmpresaTerreno;

                if (lkn != null)
                {
                    lkn.OnClientClick = "if(self.gfPop)gfPop.fPopCalendar(document.getElementById('" + txt.ClientID + "')); giDatePos=0; return false;";

                    txt = null;
                    lkn = null;
                }

                if (poliza == "")
                {
                    lknPoliza.Visible = false;
                    e.Row.Style.Value = "background-color:#EAF7FB;color:#000066;font-family: Tahoma;font-size: 7pt;Height:30px;font-weight:bold;";
                }
                else
                {
                    lknPoliza.Visible = true;
                    lknPoliza.Text = poliza;
                    lknPoliza.Style.Value = "color:#00008B;font-family: Tahoma;font-size: 8pt;Height:30px;font-weight:bold;text-decoration:underline;";
                    lknPoliza.Attributes.Add("onClick", "window.open('../../../Utils/PopUpPoliza.aspx?intEmpresa=" + empresa + "&strPoliza=" + poliza + "&intEjercicio=" + intEjercicio + "','','height=700px width=1000px resizable scrollbars');  return false;");
                    //lknPoliza.Attributes.Add("onClick", "window.showModalDialog('../../../Utils/PopUpPoliza.aspx?intEmpresa=" + empresa + "&strPoliza=" + poliza + "&intEjercicio=" + intEjercicio + "',null,'dialogHeight:700px; dialogWidth:1000px;status:no;help:no;scroll:no;minimize:no;maximize:no;close:no;border:thin;');  return false;");

                    e.Row.Style.Value = "background-color:#FFA07A;color:Black;font-family: Tahoma;font-size: 7pt;Height:30px;font-weight:bold";
                    cboTerreno.Enabled = false;
                }

                lknPoliza.UpdateAfterCallBack = true;

                //if (PolizaTerreno != "")
                //{
                //    lknPolizaMaple.Visible = true;
                //    lknPolizaMaple.Text = PolizaTerreno;
                //    lknPolizaMaple.Style.Value = "color:#00008B;font-family: Tahoma;font-size: 8pt;Height:30px;font-weight:bold;text-decoration:underline;";
                //    lknPolizaMaple.Attributes.Add("onClick", "window.showModalDialog('../../../Utils/PopUpPoliza.aspx?intEmpresa=3&strPoliza=" + PolizaTerreno + "&intEjercicio=" + intEjercicio + "',null,'dialogHeight:700px; dialogWidth:1000px;status:no;help:no;scroll:no;minimize:no;maximize:no;close:no;border:thin;');  return false;");
                //    e.Row.Style.Value = "background-color:#FFA07A;color:Black;font-family: Tahoma;font-size: 7pt;Height:30px;font-weight:bold";
                //}
                //else
                //{
                //    lknPolizaMaple.Visible = false;
                //    e.Row.Style.Value = "background-color:#EAF7FB;color:#000066;font-family: Tahoma;font-size: 7pt;Height:30px;font-weight:bold;";
                //}
                lknPolizaMaple.UpdateAfterCallBack = true;

                if (dblTerreno == 0 && terreno != "Fideicomiso")
                {
                    chkEscriturar.Visible = false;
                    chkEscriturar.UpdateAfterCallBack = true;
                    e.Row.Style.Value = "background-color:#DC143C;color:Black;font-family: Tahoma;font-size: 7pt;Height:30px;font-weight:bold";
                    cboTerreno.Enabled = false;
                }

                if (dblEdificacion <= 0)
                {
                    chkEscriturar.Visible = false;
                    chkEscriturar.UpdateAfterCallBack = true;
                    e.Row.Style.Value = "background-color:#DC143C;color:Black;font-family: Tahoma;font-size: 7pt;Height:30px;font-weight:bold";
                    cboTerreno.Enabled = false;
                }
            }
        }
    }
    #endregion

    #region btnDesaplicar_Click
    protected void btnDesaplicar_Click(object sender, EventArgs e)
    {
        bool execute;
        int intProspecto;

        try
        {
            for (int i = 0; i < grdEscrituracion.Rows.Count; i++)
            {
                Anthem.CheckBox chkEscriturar = (Anthem.CheckBox)grdEscrituracion.Rows[i].FindControl("chkEscriturar");
                if (chkEscriturar.Checked)
                {
                    intProspecto = Convert.ToInt32(grdEscrituracion.DataKeys[i].Value);

                    Entity_Prospectos obj;
                    obj = new Entity_Prospectos();

                    Prospecto pros;
                    pros = new Prospecto();

                    obj.intProspecto =intProspecto;
                    obj.StrUsuario = Contabilidad.SEMSession.GetInstance.StrUsuario;
                    obj.StrMaquina = Contabilidad.SEMSession.GetInstance.StrMaquina;

                    execute = pros.EscDesaplicar(obj);

                    pros  = null;
                    obj = null;
                }
            }
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "msgSave", "alert('Se desaplico correctamente');", true);
            BindGrid();
        }
        catch (Exception ex)
        {
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "msgSave", "alert('" + ex.Message + "');", true);
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
}


