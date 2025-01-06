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
using Contabilidad.Bussines;
using Contabilidad.Entity;
using System.Data.SqlClient;
using System.Text;

public partial class Administracion_Contabilidad_Polizas : System.Web.UI.Page
{
    public string realPath;
    Pages_Base toolbar;

    public int Direction
    {
        get { return ViewState["Direction"] != null ? (int)ViewState["Direction"] : 0; }
        set { ViewState["Direction"] = value; }
    }
    
    public int Operation
    {
        get { return ViewState["operation"] != null ? (int)ViewState["operation"] : 0; }
        set { ViewState["operation"] = value; }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        string end = (Request.ApplicationPath.EndsWith("/")) ? "" : "/";
        string path = Request.ApplicationPath + end;
        realPath = String.Format("http://{0}{1}{2}", Request.Url.Authority, path, "Img/bg_btn.png");

        toolbar = (Pages_Base)this.Master;
        toolbar.PageEvent += new HandlerEvent(Me_Event);

        ctrlPagger1.ChangingPageIndex += new ControlctrlPagger.HandlerChangingPageIndex(ChangingPageIndex);
        ctrlPagger1.ChangingRowCount += new ControlctrlPagger.HandlerChangingRowCount(ChangingRowCount);

        Anthem.Manager.Register(this);

        if (!IsPostBack)
        {
            txtEmpresa.Text = Contabilidad.SEMSession.GetInstance.IntEmpresa.ToString();
            txtEmpresa_TextChange(null, null);
            txtFechaInicial.Text = DateTime.Now.ToString("dd/MM/yyyy");
            TipoPolizas();
            Monedas();
            TM();
            hddMonth.Value = Convert.ToDateTime(txtFechaInicial.Text).Date.Month.ToString();
            hddYear.Value = Convert.ToDateTime(txtFechaInicial.Text).Date.Year.ToString();
            ctrlPagger1.Visible = false;
            hddPartida.Value = "1";

            if (!(Contabilidad.SEMSession.GetInstance.Perfil == 14 || Contabilidad.SEMSession.GetInstance.Perfil == 24))
            {
                cboTM.Visible = false;
                lblTM.Visible = false;

                cboTM.UpdateAfterCallBack = true;
                lblTM.UpdateAfterCallBack = true;
            }
        }

        ImgDate.OnClientClick = "if(self.gfPop)gfPop.fPopCalendar(document.getElementById('" + txtFechaInicial.ClientID + "')); giDatePos=0; return false;";
        txtFechaInicial.Attributes.Add("onchange", "Ejercicio();"); 
        txtConceptoPoliza.Attributes.Add("OnKeyDown", "EnterButton();");

        txtCuenta.Attributes.Add("ondblclick", "var x=JBrowse('" + txtCuenta.ClientID + "','" + txtCuenta.ClientID + "," + txtSubCuenta.ClientID + "," + txtSubSubCuenta.ClientID + "," + hddNombreCuenta.ClientID + "," + hddIndAuxiliar.ClientID + "','DACCuentas','',4,ctl00_CPHBase_txtEmpresa.value,ctl00_CPHBase_hddSucursal.value,'20', true,'No hay información');");
        txtSubCuenta.Attributes.Add("ondblclick", "var x=JBrowse('" + txtCuenta.ClientID + "','" + txtCuenta.ClientID + "," + txtSubCuenta.ClientID + "," + txtSubSubCuenta.ClientID + "," + hddNombreCuenta.ClientID + "," + hddIndAuxiliar.ClientID + "','DACCuentas','',4,ctl00_CPHBase_txtEmpresa.value,ctl00_CPHBase_hddSucursal.value,'20', true,'No hay información');");
        txtSubSubCuenta.Attributes.Add("ondblclick", "var x=JBrowse('" + txtCuenta.ClientID + "','" + txtCuenta.ClientID + "," + txtSubCuenta.ClientID + "," + txtSubSubCuenta.ClientID + "," + hddNombreCuenta.ClientID + "," + hddIndAuxiliar.ClientID + "','DACCuentas','',4,ctl00_CPHBase_txtEmpresa.value,ctl00_CPHBase_hddSucursal.value,'20', true,'No hay información');");               

        txtObra.Attributes.Add("ondblclick", "var x= JBrowse('" + txtObra.ClientID + "','" + txtObra.ClientID + "','DACPolizaDet','',5,ctl00_CPHBase_txtEmpresa.value,ctl00_CPHBase_hddSucursal.value,'20', true,'No hay información');");
        txtObra.Attributes.Add("onchange", "FindObra('" + txtObra.ClientID + "');");

        //txtAuxiliar.Attributes.Add("ondblclick", "var x= Browse('" + txtAuxiliar.ClientID + "','" + txtAuxiliar.ClientID + ",hddUnidadInsumo,hddUnidadInsumo','AdministrativoBO','hddEmpresa',6,1,'text','8', 'false'); return false;");
        txtAuxiliar.Attributes.Add("onchange", "FindAux('" + txtAuxiliar.ClientID + "');");

        Anthem.Manager.RegisterStartupScript(Page.GetType(), "objUtils", "var objUtils = new VetecUtils();", true);
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtCargos", "var objText = new VetecText('" + txtCargos.ClientID + "', 'decimal', 12);", true);
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtAbonos", "var objText = new VetecText('" + txtAbonos.ClientID + "', 'decimal', 12);", true);
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtCuenta", "var objText = new VetecText('" + txtCuenta.ClientID + "', 'number', 20);", true);
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtObra", "var objText = new VetecText('" + txtObra.ClientID + "', 'number', 20);", true);
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtAuxiliar", "var objText = new VetecText('" + txtAuxiliar.ClientID + "', 'number', 20);", true);
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtPoliza", "var objText = new VetecText('" + txtPoliza.ClientID + "', 'text', 20);", true);
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtCuenta", "var objText = new VetecText('" + txtCuenta.ClientID + "', 'number', 4);", true);
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtSubCuenta", "var objText = new VetecText('" + txtSubCuenta.ClientID + "', 'number', 4);", true);
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtSubSubCuenta", "var objText = new VetecText('" + txtSubSubCuenta.ClientID + "', 'number', 4);", true);
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtEmpresa", "var objText = new VetecText('" + txtEmpresa.ClientID + "', 'number', 4);", true);
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtConcepto", "var objText = new VetecText('" + txtConcepto.ClientID + "', 'text', 400);", true);
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtReferencia", "var objText = new VetecText('" + txtReferencia.ClientID + "', 'text', 100);", true);
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtNombreEmpresa", "var objText = new VetecText('" + txtNombreEmpresa.ClientID + "', 'text', 400);", true);

        string a = Request.Params.Get("__EVENTTARGET");
        string argument = Request.Params.Get("__EVENTARGUMENT");
        //if (a == "Charge")
        //    Charge();
    }

    protected void Page_PreRender(object sender, EventArgs e)
    {
        toolbar.List(false);
        toolbar.Exportar(false);
        toolbar.Email(false);   

        string a = Request.Params.Get("__EVENTTARGET");
        string argument = Request.Params.Get("__EVENTARGUMENT");

        if (!IsPostBack)
        {
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "IniCuentas", "var objCuentas = [];", true);
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "IniAux", "var objAux = [];", true);
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "IniObras", "var objObras = [];", true);  

            JavaScriptCuentas();
            JavaScriptObras();
            JavaScriptAux();

            if (Request.QueryString["strPoliza"] != null)
            {
                string empresa = Request.QueryString["intEmpresa"].ToString();
                string poliza = Request.QueryString["strPoliza"].ToString();
                string ejercicio = Request.QueryString["intEjercicio"].ToString();

                txtEmpresa.Text = empresa;
                txtEmpresa_TextChange(null, null);
                txtFechaInicial.Text = "01/" + poliza.Substring(0, 2) + "/" + ejercicio;
                txtPoliza.Text = poliza;
                txtPoliza_TextChanged(null, null);

                txtEmpresa.Enabled = false;
                txtFechaInicial.Enabled = false;
                btnAyudaPoliza.Visible = false;
                ImgDate.Visible = false;
                cboTipoPoliza.Enabled = false;
                cboMoneda.Enabled = false;
                txtPoliza.Enabled = false;
            }
        }

        if (a == "ctl00$CPHBase$txtEmpresa")
        {           
            JavaScriptCuentas();
            JavaScriptObras();
            JavaScriptAux();
        }

        if (a == "")
        {
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "IniCuentas", "var objCuentas = [];", true);
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "IniAux", "var objAux = [];", true);
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "IniObras", "var objObras = [];", true);

            JavaScriptCuentas();
            JavaScriptObras();
            JavaScriptAux();
        }
    }

    #region txtFechaInicial_Change
    protected void txtFechaInicial_Change(object sender, EventArgs e)
    {
         Close();               
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

        Clear();

        hddSucursal.UpdateAfterCallBack = true;
        txtEmpresa.UpdateAfterCallBack = true;
        txtNombreEmpresa.UpdateAfterCallBack = true;

        Anthem.Manager.RegisterStartupScript(Page.GetType(), "PolFoc", "document.getElementById('" + txtPoliza.ClientID + "').focus(); ", true); 

        obj = null;
        emp = null;
    }
    #endregion txtEmpresa_TextChange   

    #region Clear
    private void Clear()
    {
        txtCuenta.Text = "";
        txtSubCuenta.Text = "";
        txtSubSubCuenta.Text = "";
        txtAuxiliar.Text = "";
        txtObra.Text = "";
        txtCargos.Text = "";
        txtAbonos.Text = "";
        txtPoliza.Text = "";
        cboMoneda.SelectedIndex = 0;
        cboMoneda.Enabled = true;
        cboTipoPoliza.Enabled = true;
        cboTipoPoliza.SelectedIndex = 0;
        txtFechaInicial.Text = DateTime.Now.ToString("dd/MM/yyyy");
        txtConcepto.Text = "";
        txtConcepto.Enabled = true;
        lblAfectada.Text = "";
        this.PageIndex = 0;
        this.PageSize = 100;
        this.ctrlPagger1.Visible = false;
        txtOrdenCompra.Text = "";
        txtTotalCargos.Text = "";
        txtTotalAbonos.Text = "";
        txtDiferenciia.Text = "";
        txtPoliza.Focus();
        btnCopiar.Visible = false;
        btnCopy.Visible = false;
        btnCFDI.Visible = false;
        pnlPagger.Visible = false;
        hddClose.Value = "0";
        hddPartida.Value = "1";
        txtPoliza.Focus();
        txtConceptoPoliza.Text = "";
        txtReferencia.Text = "";

        txtConceptoPoliza.UpdateAfterCallBack = true;
        txtReferencia.UpdateAfterCallBack = true;
        btnCopiar.UpdateAfterCallBack = true;
        btnCFDI.UpdateAfterCallBack = true;
        txtCuenta.UpdateAfterCallBack = true;
        txtSubCuenta.UpdateAfterCallBack = true;
        txtAuxiliar.UpdateAfterCallBack = true;
        txtObra.UpdateAfterCallBack = true;
        txtCargos.UpdateAfterCallBack = true;
        txtAbonos.UpdateAfterCallBack = true;
        txtSubSubCuenta.UpdateAfterCallBack = true;
        txtPoliza.UpdateAfterCallBack = true;
        cboMoneda.UpdateAfterCallBack = true;
        cboTipoPoliza.UpdateAfterCallBack = true;
        txtConcepto.UpdateAfterCallBack = true;
        txtTotalAbonos.UpdateAfterCallBack = true;
        txtTotalCargos.UpdateAfterCallBack = true;
        lblAfectada.UpdateAfterCallBack = true;
        txtDiferenciia.UpdateAfterCallBack = true;
        btnCopy.UpdateAfterCallBack = true;
        txtOrdenCompra.UpdateAfterCallBack = true;
        pnlPagger.UpdateAfterCallBack = true;
        hddClose.UpdateAfterCallBack = true;
        hddPartida.UpdateAfterCallBack = true;
        txtPoliza.UpdateAfterCallBack = true;

        grdPolizaDet.DataSource = null;
        grdPolizaDet.DataBind();

        grdPolizaDet.UpdateAfterCallBack = true;

        TM();

    }
    #endregion

    #region ChangingPageIndex
    void ChangingPageIndex(object o, ControlctrlPagger.ArgsChangingPageIndex e)
    {
        ctrlPagger1.PageIndex = e.NewPageIndex;
        BindGrid();
    }
    #endregion

    #region ChangingRowCount
    void ChangingRowCount(object o, ControlctrlPagger.ArgsChangingRowCount e)
    {
        ctrlPagger1.PageIndex = 0;
        BindGrid();
    }
    #endregion 

    #region Close
    private void Close()
    {
        Entity_Poliza obj;
        obj = new Entity_Poliza();

        Poliza pol;
        pol = new Poliza();

        obj.IntEmpresa = Convert.ToInt32(txtEmpresa.Text);
        obj.IntEjercicio = Convert.ToDateTime(txtFechaInicial.Text).Date.Year;
        obj.IntMes = Convert.ToDateTime(txtFechaInicial.Text).Date.Month;
        obj.IntModulo = 1;

        if (pol.Close(obj) == "1")
        {
            lblAfectada.Text = "Mes Cerrado";
            txtConceptoPoliza.Enabled = false;
            btnCopiar.Visible = false;
            btnCopy.Visible = false;
            btnCFDI.Visible = false;
            txtCuenta.Enabled = false;
            txtCuenta.Style.Value = "background-color:Silver;color:#000066;text-align:left;font-family: Tahoma;font-size: 8pt;";
            txtSubCuenta.Enabled = false;
            txtSubCuenta.Style.Value = "background-color:Silver;color:#000066;text-align:left;font-family: Tahoma;font-size: 8pt;";
            txtSubSubCuenta.Enabled = false;
            txtSubSubCuenta.Style.Value = "background-color:Silver;color:#000066;text-align:left;font-family: Tahoma;font-size: 8pt;";
            txtObra.Enabled = false;
            txtObra.Style.Value = "background-color:Silver;color:#000066;text-align:left;font-family: Tahoma;font-size: 8pt;";
            txtAbonos.Enabled = false;
            txtAbonos.Style.Value = "background-color:Silver;color:#000066;text-align:left;font-family: Tahoma;font-size: 8pt;";
            txtAuxiliar.Enabled = false;
            txtAuxiliar.Style.Value = "background-color:Silver;color:#000066;text-align:left;font-family: Tahoma;font-size: 8pt;";
            txtCargos.Enabled = false;
            txtCargos.Style.Value = "background-color:Silver;color:#000066;text-align:left;font-family: Tahoma;font-size: 8pt;";
            txtConceptoPoliza.Enabled = false;
            txtConceptoPoliza.Style.Value = "background-color:Silver;color:#000066;text-align:left;font-family: Tahoma;font-size: 8pt;";
            txtReferencia.Enabled = false;
            txtReferencia.Style.Value = "background-color:Silver;color:#000066;text-align:left;font-family: Tahoma;font-size: 8pt;";
        }
        else
        {
            lblAfectada.Text = "";
            if (txtPoliza.Text != "")
            {
                btnCopiar.Visible = true;
                btnCopy.Visible = true;
                btnCFDI.Visible = true;
            }
            txtConceptoPoliza.Enabled = true;
            txtCuenta.Enabled = true;
            txtCuenta.Style.Value = "background-color:White;color:Navy;text-align:left;Tahoma;font-size: 8pt;";
            txtSubCuenta.Enabled = true;
            txtSubCuenta.Style.Value = "background-color:White;color:Navy;text-align:left;Tahoma;font-size: 8pt;";
            txtSubSubCuenta.Enabled = true;
            txtSubSubCuenta.Style.Value = "background-color:White;color:Navy;text-align:left;Tahoma;font-size: 8pt;";
            txtObra.Enabled = true;
            txtObra.Style.Value = "background-color:White;color:Navy;text-align:left;Tahoma;font-size: 8pt;";
            txtAbonos.Enabled = true;
            txtAbonos.Style.Value = "background-color:White;color:Navy;text-align:left;Tahoma;font-size: 8pt;";
            txtAuxiliar.Enabled = true;
            txtAuxiliar.Style.Value = "background-color:White;color:Navy;text-align:left;Tahoma;font-size: 8pt;";
            txtCargos.Enabled = true;
            txtCargos.Style.Value = "background-color:White;color:Navy;text-align:left;Tahoma;font-size: 8pt;";
            txtConceptoPoliza.Enabled = true;
            txtConceptoPoliza.Style.Value = "background-color:White;color:Navy;text-align:left;Tahoma;font-size: 8pt;";
            txtReferencia.Enabled = true;
            txtReferencia.Style.Value = "background-color:White;color:Navy;text-align:left;Tahoma;font-size: 8pt;";
        }

        lblAfectada.UpdateAfterCallBack = true;
        btnCopiar.UpdateAfterCallBack = true;
        txtConceptoPoliza.UpdateAfterCallBack = true;
        btnCopy.UpdateAfterCallBack = true;
        btnCFDI.UpdateAfterCallBack = true;
        txtCuenta.UpdateAfterCallBack = true;
        txtSubCuenta.UpdateAfterCallBack = true;
        txtSubSubCuenta.UpdateAfterCallBack = true;
        txtObra.UpdateAfterCallBack = true;
        txtAbonos.UpdateAfterCallBack = true;
        txtAuxiliar.UpdateAfterCallBack = true;
        txtCargos.UpdateAfterCallBack = true;
        txtConceptoPoliza.UpdateAfterCallBack = true;
        txtReferencia.UpdateAfterCallBack = true;

        obj = null;
        pol = null;
    }
    #endregion 

    #region TipoPolizas
    private void TipoPolizas()
    {
        TiposPoliza tp;
        tp = new TiposPoliza();
        Entity_TiposPoliza obj;
        obj = new Entity_TiposPoliza();
        DataTable dt;

        obj.IntEmpresa = txtEmpresa.Text == "" ? Contabilidad.SEMSession.GetInstance.IntEmpresa : Convert.ToInt32(txtEmpresa.Text);
        obj.intEjercicio = Convert.ToDateTime(txtFechaInicial.Text).Date.Year;
        dt = tp.Sel(obj);    

        cboTipoPoliza.DataSource = dt;
        cboTipoPoliza.DataTextField = "strNombreCbo";
        cboTipoPoliza.DataValueField = "strTipoPoliza";
        cboTipoPoliza.SelectedIndex = 0;
        cboTipoPoliza.DataBind();
        cboTipoPoliza.UpdateAfterCallBack = true;

        tp = null;
        obj = null;
    }
    #endregion

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

    #region TM
    private void TM()
    {
        List data;
        data = new List();

        int intEmpresa = Convert.ToInt32(txtEmpresa.Text);
        int intSucursal = Convert.ToInt32(hddSucursal.Value);

        cboTM.DataSource = data.TM(intEmpresa, intSucursal);
        cboTM.DataTextField = "strNombre";
        cboTM.DataValueField = "Id";
        cboTM.DataBind();

        cboTM.Items.Insert(0, new ListItem("--Ninguno--", "0"));

        cboTM.UpdateAfterCallBack = true;

        data = null;
    }
    #endregion    

    #region txtPoliza_TextChanged
    protected void txtPoliza_TextChanged(object sender, EventArgs e)
    {
        Poliza();
        BindGrid();
        Find();

        btnCopiar.Attributes.Add("onClick", "Copiar('" + txtPoliza.Text + "','" + Convert.ToDateTime(txtFechaInicial.Text).Date.Year + "','0','"+txtEmpresa.Text+"'); return false;");
        btnCopiar.Visible = true;
        btnCopiar.UpdateAfterCallBack = true;

        btnCopy.Attributes.Add("onClick", "Copiar('" + txtPoliza.Text + "','" + Convert.ToDateTime(txtFechaInicial.Text).Date.Year + "','1','" + txtEmpresa.Text + "'); return false;");
        btnCopy.Visible = true;
        btnCopy.UpdateAfterCallBack = true;

        btnCFDI.Attributes.Add("onClick", "CFDI('" + txtPoliza.Text + "','" + Convert.ToDateTime(txtFechaInicial.Text).Date.Year + "','" + txtEmpresa.Text + "'); return false;");
        btnCFDI.Visible = true;
        btnCFDI.UpdateAfterCallBack = true;

        Anthem.Manager.RegisterStartupScript(Page.GetType(), "CuentaPoss", "document.getElementById('" + txtCuenta.ClientID + "').focus(); ", true);
    }
    #endregion

    #region Poliza
    protected void Poliza()
    {
        PolizasEnc poliza;
        poliza = new PolizasEnc();
        Entity_PolizasEnc obj;
        obj = new Entity_PolizasEnc();
        string afectada;

        obj.IntEmpresa = txtEmpresa.Text == "" ? Contabilidad.SEMSession.GetInstance.IntEmpresa : Convert.ToInt32(txtEmpresa.Text);
        obj.strPoliza = txtPoliza.Text;
        obj.intEjercicio = Convert.ToDateTime(txtFechaInicial.Text).Date.Year;

        obj = poliza.Fill(obj);

        if (obj != null)
        {
            txtPoliza.Text = obj.strPoliza;
            txtFechaInicial.Text = obj.datFecha.ToShortDateString();
            cboTipoPoliza.SelectedValue = obj.strTipoPoliza;
            txtConcepto.Text = obj.strDescripcion;
            afectada = obj.intIndAfectada.ToString();
            txtOrdenCompra.Text = obj.StrFolio;
            Close();

            if (afectada == "1" || hddClose.Value == "1")
            {
                if (hddClose.Value == "1")
                    lblAfectada.Text = "Mes Cerrado";
                else
                {
                    if (afectada == "1")
                        lblAfectada.Text = "Afectada";
                }

                cboTipoPoliza.Enabled = false;
                txtConcepto.Enabled = false;
                cboMoneda.Enabled = false;
            }
            else
            {
                lblAfectada.Text = "";
            }
        }
        else
        {
            txtPoliza.Text = "";
            cboTipoPoliza.SelectedIndex = 0;
            cboMoneda.SelectedIndex = 0;
            lblAfectada.Text = "";
            txtOrdenCompra.Text = "";
        }

        txtPoliza.UpdateAfterCallBack = true;
        cboTipoPoliza.UpdateAfterCallBack = true;
        cboTipoPoliza.UpdateAfterCallBack = true;
        txtConcepto.UpdateAfterCallBack = true;
        lblAfectada.UpdateAfterCallBack = true;
        txtOrdenCompra.UpdateAfterCallBack = true;
        txtFechaInicial.UpdateAfterCallBack = true;

        poliza = null;
        obj = null;
    }
    #endregion

    #region BindGrid
    protected void BindGrid()
    {
        PolizasDet poliza;
        poliza = new PolizasDet();
        Entity_PolizasDet obj;
        obj = new Entity_PolizasDet();
        DataTable dt;

        obj.IntEmpresa = Convert.ToInt32(txtEmpresa.Text);
        obj.strPoliza = txtPoliza.Text;
        obj.intEjercicio = Convert.ToDateTime(txtFechaInicial.Text).Date.Year;
        obj.SortDirection = ctrlPagger1.SortDirection == SortDirection.Ascending ? 1 : 0;
        obj.SortExpression = ctrlPagger1.SortExpression;
        obj.iNumPage = ctrlPagger1.PageSize;
        obj.iNumRecords = ctrlPagger1.PageIndex;

        dt = poliza.GetList(obj);

        if (dt != null)
        {
            if (dt.Rows.Count > 0)
            {
                ctrlPagger1.TotalRecords = obj.IntTotalRecords;
                ctrlPagger1.FromRecord = ctrlPagger1.PageSize * ctrlPagger1.PageIndex + 1;
                ctrlPagger1.ToRecord = Math.Min(ctrlPagger1.PageSize * ctrlPagger1.PageIndex + ctrlPagger1.PageSize, Convert.ToInt32(ctrlPagger1.TotalRecords));
                ctrlPagger1.TotalPages = obj.IntTotalPages;
                ctrlPagger1.ShowButtons();
                pnlPagger.Visible = true;
                txtTotalAbonos.Text = obj.DblAbonos.ToString("C2").Replace(",","");
                txtTotalCargos.Text = obj.DblCargos.ToString("C2").Replace(",", "");
                txtDiferenciia.Text = obj.DblTotal.ToString("C2").Replace(",", "");
                hddPartida.Value = obj.intPartida.ToString();

                grdPolizaDet.DataSource = dt;
                grdPolizaDet.DataBind();
            }
            else
            {
                pnlPagger.Visible = false;
                if (dt.Rows.Count == 0 && this.PageIndex > 0)
                {
                    this.PageIndex = this.PageIndex - 1;
                    BindGrid();
                }
                else
                {
                    grdPolizaDet.DataSource = null;
                    grdPolizaDet.DataBind();
                }
            }
        }
        else
            pnlPagger.Visible = false;


        hddPartida.UpdateAfterCallBack = true;
        txtTotalAbonos.UpdateAfterCallBack = true;
        txtTotalCargos.UpdateAfterCallBack = true;
        pnlPagger.UpdateAfterCallBack = true;
        grdPolizaDet.UpdateAfterCallBack = true;
        txtDiferenciia.UpdateAfterCallBack = true;                

        obj = null;
        poliza = null;
    }
    #endregion

    #region JavaScriptCuentas
    private void JavaScriptCuentas()
    {
        Cuentas cuenta;
        cuenta = new Cuentas();
        Entity_Cuentas obj;
        obj = new Entity_Cuentas();
        DataTable dt;
        DataRow dr;
        StringBuilder str = new StringBuilder();

        obj.IntEmpresa = txtEmpresa.Text == "" ? Contabilidad.SEMSession.GetInstance.IntEmpresa : Convert.ToInt32(txtEmpresa.Text);
        obj.StrCuenta = "0";

        dt = cuenta.GetList(obj);

        str.Append("objCuentas.splice(0,objCuentas.length);");
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            dr = dt.Rows[i];
            str.Append("objCuentas.push({id:'" + dr["strCuenta"] + "',name:'" + dr["strNombre"] + "'});");
        }

        Anthem.Manager.RegisterStartupScript(Page.GetType(), "objCuentas", str.ToString(), true);        

        obj = null;
        cuenta = null;
    }
    #endregion

    #region JavaScriptObras
    private void JavaScriptObras()
    {
        Obra obra;
        obra = new Obra();
        Entity_Obra obj;
        obj = new Entity_Obra();
        DataTable dt;
        DataRow dr;
        StringBuilder str = new StringBuilder();

        obj.IntEmpresa = txtEmpresa.Text == "" ? Contabilidad.SEMSession.GetInstance.IntEmpresa : Convert.ToInt32(txtEmpresa.Text);

        dt = obra.GetList(obj);

        str.Append("objObras.splice(0,objObras.length);");
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            dr = dt.Rows[i];
            str.Append("objObras.push({id:'" + dr["intObra"].ToString() + "'});");
        }

        Anthem.Manager.RegisterStartupScript(Page.GetType(), "objObras", str.ToString(), true); 

        obj = null;
        obra = null;
    }
    #endregion

    #region JavaScriptAux
    private void JavaScriptAux()
    {
        PolizasDet pol;
        pol = new PolizasDet();

        DataTable dt;
        DataRow dr;
        StringBuilder str = new StringBuilder();

        int intEmpresa = txtEmpresa.Text == "" ? Contabilidad.SEMSession.GetInstance.IntEmpresa : Convert.ToInt32(txtEmpresa.Text);

        dt = pol.ListAux(intEmpresa);

        str.Append("objAux.splice(0,objAux.length);");
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            dr = dt.Rows[i];
            str.Append("objAux.push({id:'" + dr["Id"] + "'});");
        }

        
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "objAux", str.ToString(), true); 

        pol = null;
    }
    #endregion

    #region Find
    private void Find()
    {
        string partida;
        for (int i = 0; i < grdPolizaDet.Rows.Count; i++)
        {
            Anthem.TextBox txtCuentaDet = (Anthem.TextBox)grdPolizaDet.Rows[i].FindControl("txtCuentaDet");
            Anthem.TextBox txtObraDet = (Anthem.TextBox)grdPolizaDet.Rows[i].FindControl("txtObraDet");
            Anthem.TextBox txtAuxiliarDet = (Anthem.TextBox)grdPolizaDet.Rows[i].FindControl("txtAuxiliarDet");
            Anthem.TextBox txtCuentaNombreDet = (Anthem.TextBox)grdPolizaDet.Rows[i].FindControl("txtCuentaNombreDet");
            Anthem.TextBox txtCargosDet = (Anthem.TextBox)grdPolizaDet.Rows[i].FindControl("txtCargosDet");
            Anthem.TextBox txtAbonosDet = (Anthem.TextBox)grdPolizaDet.Rows[i].FindControl("txtAbonosDet");
            Anthem.ImageButton lknDelete = (Anthem.ImageButton)grdPolizaDet.Rows[i].FindControl("lknDelete");
            Anthem.CheckBox chkSelect = (Anthem.CheckBox)grdPolizaDet.Rows[i].FindControl("chkSelect");
            Anthem.TextBox txtReferenciaDet = (Anthem.TextBox)grdPolizaDet.Rows[i].FindControl("txtReferenciaDet");
            Anthem.TextBox txtDescripcionDet = (Anthem.TextBox)grdPolizaDet.Rows[i].FindControl("txtDescripcionDet");

            if (lblAfectada.Text == "Afectada" || hddClose.Value == "1")
            {
                txtCuentaNombreDet.ReadOnly = true;
                txtCuentaNombreDet.Style.Value = "background-color:Silver;color:#000066;text-align:left;font-family: Tahoma;font-size: 8pt;";
                txtCuentaDet.ReadOnly = true;
                txtCuentaDet.Style.Value = "background-color:Silver;color:#000066;text-align:left;font-family: Tahoma;font-size: 8pt;";
                txtAuxiliarDet.ReadOnly = true;
                txtAuxiliarDet.Style.Value = "background-color:Silver;color:#000066;text-align:left;font-family: Tahoma;font-size: 8pt;";
                txtObraDet.Style.Value = "background-color:Silver;color:#000066;text-align:left;Tahoma;font-size: 8pt;";
                txtObraDet.ReadOnly = true;
                txtReferenciaDet.Style.Value = "background-color:Silver;color:#000066;text-align:left;font-family: Tahoma;font-size: 8pt;";
                txtReferenciaDet.ReadOnly = true;
                txtCargosDet.Style.Value = "background-color:Silver;color:#000066;text-align:right;font-family: Tahoma;font-size: 8pt;;";
                txtCargosDet.ReadOnly = true;
                txtAbonosDet.Style.Value = "background-color:Silver;color:#000066;text-align:right;font-family: Tahoma;font-size: 8pt;";
                txtAbonosDet.ReadOnly = true;
                txtDescripcionDet.Style.Value = "background-color:Silver;color:#000066;text-align:left;font-family: Tahoma;font-size: 8pt;";
                txtDescripcionDet.ReadOnly = true;
                lknDelete.Visible = false;
            }
            else
            {
                if (grdPolizaDet.DataKeys[i].Values[1].ToString() == "1")
                {
                    lknDelete.Visible = false;
                    txtCuentaDet.ReadOnly = true;
                    txtCuentaDet.Style.Value = "background-color:Silver;color:#000066;text-align:left;font-family: Tahoma;font-size: 8pt;";
                    txtAuxiliarDet.ReadOnly = true;
                    txtAuxiliarDet.Style.Value = "background-color:Silver;color:#000066;text-align:left;font-family: Tahoma;font-size: 8pt;";
                    txtObraDet.ReadOnly = true;
                    txtObraDet.Style.Value = "background-color:Silver;color:#000066;text-align:left;font-family: Tahoma;font-size: 8pt;";
                    txtReferenciaDet.Style.Value = "background-color:Silver;color:#000066;text-align:left;font-family: Tahoma;font-size: 8pt;";
                    txtReferenciaDet.ReadOnly = true;
                    txtCargosDet.Style.Value = "background-color:Silver;color:#000066;text-align:right;font-family: Tahoma;font-size: 8pt;";
                    txtCargosDet.ReadOnly = true;
                    txtAbonosDet.Style.Value = "background-color:Silver;color:#000066;text-align:right;Tfont-family: Tahoma;font-size: 8pt;";
                    txtAbonosDet.ReadOnly = true;
                    txtDescripcionDet.Style.Value = "color:#000066;text-align:left;Tahoma;font-size: 8pt;";
                    txtCuentaNombreDet.ReadOnly = true;
                    txtCuentaNombreDet.Style.Value = "background-color:Silver;color:#000066;text-align:left;font-family: Tahoma;font-size: 8pt;";
                }
                else
                {
                    txtCuentaDet.Attributes.Add("onkeypress", "OnlyNumber();");
                    txtCuentaDet.Attributes.Add("ondblclick", "var x=Browse('" + txtCuentaDet.ClientID + "','" + txtCuentaDet.ClientID + "," + txtCuentaNombreDet.ClientID + "','DACCuentas','',1,ctl00_CPHBase_txtEmpresa.value,ctl00_CPHBase_hddSucursal.value,'20', true,'No hay información'); if(x != undefined) SelectCHK(" + i.ToString() + ");");
                    txtCuentaDet.Style.Value = "background-color:#EEEE00;color:Navy;text-align:left;Tahoma;font-size: 8pt;";

                    txtObraDet.Attributes.Add("onkeypress", "OnlyNumber();");
                    txtObraDet.Attributes.Add("ondblclick", "var x= Browse('" + txtObraDet.ClientID + "','" + txtObraDet.ClientID + "','DACPolizaDet','',5,ctl00_CPHBase_txtEmpresa.value,ctl00_CPHBase_hddSucursal.value,'20', true,'No hay información'); SelectCHK(" + i.ToString() + ");");
                    txtObraDet.Style.Value = "background-color:#EEEE00;color:Navy;text-align:left;Tahoma;font-size: 8pt;";

                    txtAuxiliarDet.Attributes.Add("onkeypress", "OnlyNumber();");
                    //txtAuxiliarDet.Attributes.Add("ondblclick", "var x= Find('" + txtAuxiliarDet.ClientID + "','" + txtAuxiliarDet.ClientID + ",hddUnidadInsumo,hddUnidadInsumo','AdministrativoBO','hddEmpresa',6,1,'text','8', 'false'); return false;");
                    txtAuxiliarDet.Style.Value = "background-color:#EEEE00;color:Navy;text-align:left;Tahoma;font-size: 8pt;";

                    txtCuentaNombreDet.Style.Value = "background-color:Silver;color:#000066;text-align:left;font-family: Tahoma;font-size: 8pt;";

                    txtCargosDet.Style.Value = "color:#000066;text-align:right;Tahoma;font-size: 8pt;";
                    txtAbonosDet.Style.Value = "color:#000066;text-align:right;Tahoma;font-size: 8pt;";
                    txtDescripcionDet.Style.Value = "color:#000066;text-align:left;Tahoma;font-size: 8pt;";
                    lknDelete.Visible = true;
                    txtReferenciaDet.Style.Value = "color:#000066;text-align:left;Tahoma;font-size: 8pt;";
                    txtDescripcionDet.Style.Value = "color:#000066;text-align:left;Tahoma;font-size: 8pt;";
                }
            }

            txtCuentaDet.Attributes.Add("onKeyDown", "UpDownCuenta(" + i.ToString() + ")");
            txtAuxiliarDet.Attributes.Add("onKeyDown", "UpDownAuxiliar(" + i.ToString() + ")");
            txtObraDet.Attributes.Add("onKeyDown", "UpDownObra(" + i.ToString() + ")");
            txtReferenciaDet.Attributes.Add("onKeyDown", "UpDownReferencia(" + i.ToString() + ")");
            txtCargosDet.Attributes.Add("onKeyDown", "UpDownCargos(" + i.ToString() + ")");
            txtAbonosDet.Attributes.Add("onKeyDown", "UpDownAbonos(" + i.ToString() + ")");
            txtDescripcionDet.Attributes.Add("onKeyDown", "UpDownDescripcion(" + i.ToString() + ")");
            txtCargosDet.Attributes.Add("onchange", "UpdateCargos(); SelectCHK(" + i.ToString() + ")");
            txtAbonosDet.Attributes.Add("onchange", "UpdateAbonos(); SelectCHK(" + i.ToString() + ")");
            txtCuentaNombreDet.Attributes.Add("onKeyDown", "UpDownCuenta(" + i.ToString() + ")");

            txtCuentaDet.Attributes.Add("onchange", "CuentaName(" + i.ToString() + "); SelectCHK(" + i.ToString() + ");");
            txtAuxiliarDet.Attributes.Add("onchange", "Auxiliares(" + i.ToString() + "); SelectCHK(" + i.ToString() + ")");
            txtObraDet.Attributes.Add("onchange", "Obras(" + i.ToString() + "); SelectCHK(" + i.ToString() + ")");
            txtReferenciaDet.Attributes.Add("onchange", "SelectCHK(" + i.ToString() + ")");
            txtDescripcionDet.Attributes.Add("onchange", "SelectCHK(" + i.ToString() + ")");

            grdPolizaDet.Rows[i].Style.Value = "color:Navy;text-align:right;Tahoma;font-size: 8pt;border:0px;";

            partida = grdPolizaDet.DataKeys[i].Values[0].ToString();

            lknDelete.OnClientClick = "var rValue = confirm('¿Desea eliminar el registro?'); if(rValue){ document.getElementById('" + hddPartida.ClientID + "').value = " + partida + "; document.getElementById('" + lknDeletePartida.ClientID + "').onclick(); document.getElementById('" + txtCuenta.ClientID + "').focus(); } return false;";

            txtAuxiliarDet.UpdateAfterCallBack = true;
            txtObraDet.UpdateAfterCallBack = true;
            txtCuentaDet.UpdateAfterCallBack = true;
            txtCuentaNombreDet.UpdateAfterCallBack = true;
            lknDelete.UpdateAfterCallBack = true;
            txtDescripcionDet.UpdateAfterCallBack = true;
            txtAbonosDet.UpdateAfterCallBack = true;
            txtCargosDet.UpdateAfterCallBack = true;
        }

        grdPolizaDet.UpdateAfterCallBack = true;
    }
    #endregion

    #region lknDeletePoliza_Click
    protected void lknDeletePoliza_Click(object sender, EventArgs e)
    {
        Delete();
    }
    #endregion

    #region lknDelete_Click
    protected void lknDelete_Click(object sender, EventArgs e)
    {
        try
        {
            Entity_PolizasDet obj;
            obj = new Entity_PolizasDet();
            PolizasDet pol;
            pol = new PolizasDet();
            string value = "";
            int partida = Convert.ToInt32(hddPartida.Value);

            obj.IntEmpresa = txtEmpresa.Text == "" ? Contabilidad.SEMSession.GetInstance.IntEmpresa : Convert.ToInt32(txtEmpresa.Text);
            obj.strPoliza = txtPoliza.Text;
            obj.strTipoPoliza = cboTipoPoliza.SelectedValue;
            obj.intPartida = partida;
            obj.datFecha = Convert.ToDateTime(txtFechaInicial.Text);
            obj.StrUsuario = Contabilidad.SEMSession.GetInstance.StrUsuario;
            obj.StrMaquina = Contabilidad.SEMSession.GetInstance.StrMaquina;

            value = pol.Delete(obj);

            obj = null;
            pol = null;
            BindGrid();
            UpdateCA();
            Find();

            Anthem.Manager.RegisterStartupScript(Page.GetType(), "CuentaPosition", "document.getElementById('" + txtCuenta.ClientID + "').focus(); ", true);
        }
        catch (Exception ex)
        {
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "msfPolErr", "alert('" + ex.Message + "');", true);
        }
    }
    #endregion

    #region txtConceptoPoliza_Change
    protected void txtConceptoPoliza_Change(object sender, EventArgs e)
    {
        if (txtCuenta.Text != "")
        {
            try
            {
                Entity_PolizasDet obj;
                obj = new Entity_PolizasDet();
                PolizasDet pol;
                pol = new PolizasDet();

                string value;
                int intPartida;
                string cargos = txtCargos.Text == "" ? "0" : txtCargos.Text;
                string abonos = txtAbonos.Text == "" ? "0" : txtAbonos.Text;

                Cuentas();

                if (hddIndAuxiliar.Value == "1" && txtAuxiliar.Text == "")
                {
                    Anthem.Manager.RegisterStartupScript(Page.GetType(), "msgErrCuentaAux", "alert('Esta cuenta requiere de auxiliar.'); document.getElementById('" + txtAuxiliar.ClientID + "').focus()", true);
                    txtConceptoPoliza.UpdateAfterCallBack = true;
                    return;
                }

                if (hddNombreCuenta.Value == "")
                {
                    Anthem.Manager.RegisterStartupScript(Page.GetType(), "msgErrCuenta", "alert('Cuenta invalida'); document.getElementById('" + txtCuenta.ClientID + "').focus()", true);
                    txtConceptoPoliza.UpdateAfterCallBack = true;
                    return;
                }

                if (txtAuxiliar.Text == "" && hddIndAuxiliar.Value == "1")
                {
                    Anthem.Manager.RegisterStartupScript(Page.GetType(), "msgErrAux", "alert('Esta cuenta requiere Auxiliar.'); document.getElementById('" + txtAuxiliar.ClientID + "').focus()", true);
                    txtConceptoPoliza.UpdateAfterCallBack = true;
                    return;
                }

                if (txtObra.Text == "")
                {
                    Anthem.Manager.RegisterStartupScript(Page.GetType(), "msgErrObra", "alert('Obra invalida'); document.getElementById('" + txtObra.ClientID + "').focus()", true);
                    txtConceptoPoliza.UpdateAfterCallBack = true;
                    return;
                }

                if (txtPoliza.Text == "")
                {
                    txtTotalCargos.Text = "0";
                    txtTotalAbonos.Text = "0";
                    SaveEnc();
                }

                value = txtPoliza.Text;

                if (value != "")
                {
                    SaveAllDetail();

                    intPartida = Convert.ToInt32(hddPartida.Value);

                    obj.IntEmpresa = txtEmpresa.Text == "" ? Contabilidad.SEMSession.GetInstance.IntEmpresa : Convert.ToInt32(txtEmpresa.Text);
                    obj.strPoliza = txtPoliza.Text;
                    obj.strTipoPoliza = cboTipoPoliza.SelectedValue;
                    obj.datFecha = Convert.ToDateTime(txtFechaInicial.Text);
                    obj.intPartida = intPartida;
                    obj.strCuenta = hddCuenta.Value;
                    obj.strKeys = txtAuxiliar.Text;
                    obj.StrObraInicial = txtObra.Text;
                    obj.strReferencia = txtReferencia.Text;
                    obj.strDescripcion = txtConceptoPoliza.Text;
                    obj.dblImporte = txtCargos.Text == "" ? 0 : Convert.ToDecimal(txtCargos.Text);
                    obj.dblImporteTipoMoneda = txtAbonos.Text == "" ? 0 : Convert.ToDecimal(txtAbonos.Text);
                    obj.StrUsuario = Contabilidad.SEMSession.GetInstance.StrUsuario;
                    obj.StrMaquina = Contabilidad.SEMSession.GetInstance.StrMaquina;
                    obj.IntParametroInicial = cboTM.Visible == true ? Convert.ToInt32(cboTM.SelectedValue) : 0;

                    pol.Save(obj);

                    txtCuenta.Text = "";
                    hddNombreCuenta.Value = "";
                    hddIndAuxiliar.Value = "0";
                    txtSubCuenta.Text = "";
                    txtSubSubCuenta.Text = "";
                    txtAuxiliar.Text = "";
                    txtObra.Text = "";
                    txtCargos.Text = "";
                    txtAbonos.Text = "";
                    txtCuenta.Focus();

                    txtCuenta.UpdateAfterCallBack = true;
                    txtSubCuenta.UpdateAfterCallBack = true;
                    txtAuxiliar.UpdateAfterCallBack = true;
                    txtObra.UpdateAfterCallBack = true;
                    txtCargos.UpdateAfterCallBack = true;
                    txtAbonos.UpdateAfterCallBack = true;
                    txtSubSubCuenta.UpdateAfterCallBack = true;
                    hddNombreCuenta.UpdateAfterCallBack = true;
                    hddIndAuxiliar.UpdateAfterCallBack = true;
                    pnlDetail.UpdateAfterCallBack = true;

                    BindGrid();
                    Find();
                    Anthem.Manager.RegisterStartupScript(Page.GetType(), "scrollPosition", "var elem = document.getElementById('div-ListPanelPoliza'); elem.scrollTop = elem.scrollHeight; ", true);
                    Anthem.Manager.RegisterStartupScript(Page.GetType(), "CuentaPos", "document.getElementById('" + txtCuenta.ClientID + "').focus(); ", true);

                    pol = null;
                    obj = null;
                }
                else
                {
                    Anthem.Manager.RegisterStartupScript(Page.GetType(), "ErrorSaving", "alert('Ocurrio un error al guardar');", true);
                }

                UpdateCA();
            }
            catch (Exception ex)
            {
                Anthem.Manager.RegisterStartupScript(Page.GetType(), "msfPolErr", "alert('" + ex.Message + "');", true);
            }
        }

        Anthem.Manager.RegisterStartupScript(Page.GetType(), "CuentaPo", "document.getElementById('" + txtCuenta.ClientID + "').focus(); ", true);
        txtCuenta.Focus();
        txtCuenta.UpdateAfterCallBack = true;
    }
    #endregion   

    #region Me_Event
    void Me_Event(object sender, HandlerArgs args)
    {
        switch (args.Event)
        {
            case Event.Save:
                SaveEnc();
                SaveAllDetail();
                UpdateCA();
                Anthem.Manager.RegisterStartupScript(Page.GetType(), "msgPolSave", "alert('La poliza " + txtPoliza.Text + " guardo correctamente.');", true);
                Clear();
                if(txtPoliza.Enabled == false)                                   
                    Anthem.Manager.RegisterStartupScript(Page.GetType(), "polExit", "window.opener.document.getElementById('ctl00_CPHBase_lknRefresh').click(); window.close(); ", true);
                else
                    Anthem.Manager.RegisterStartupScript(Page.GetType(), "polFoc", "document.getElementById('" + txtPoliza.ClientID + "').focus(); ", true);
                //Anthem.Manager.RegisterStartupScript(Page.GetType(), "EmpPost", "window.location=window.location;", true);
                break;
            case Event.New:
                Clear();
                break;
            case Event.Delete:
                //Clear();
                Delete();
                //Anthem.Manager.RegisterStartupScript(Page.GetType(), "EmpPost3", "window.location=window.location;", true);
                break;
            case Event.Print:
                Print();
                break;
            case Event.List:
                //BindGrid();
                break;
            default:
                break;
        }
    }
    #endregion

    #region SaveEnc
    protected void SaveEnc()
    {
        try
        {
            Entity_PolizasEnc obj;
            obj = new Entity_PolizasEnc();
            PolizasEnc pol;
            pol = new PolizasEnc();
            string value = "";

            obj.IntEmpresa = txtEmpresa.Text == "" ? Contabilidad.SEMSession.GetInstance.IntEmpresa : Convert.ToInt32(txtEmpresa.Text);
            obj.strPoliza = txtPoliza.Text;
            obj.strTipoPoliza = cboTipoPoliza.SelectedValue;
            obj.datFecha = Convert.ToDateTime(txtFechaInicial.Text);
            obj.IntParametroFinal = Convert.ToInt32(cboMoneda.SelectedValue);
            obj.strDescripcion = txtConcepto.Text;
            obj.dblCargos = Convert.ToDecimal(txtTotalCargos.Text.Replace(",", "").Replace("$", ""));
            obj.dblAbonos = Convert.ToDecimal(txtTotalAbonos.Text.Replace(",", "").Replace("$", ""));
            obj.StrUsuario = Contabilidad.SEMSession.GetInstance.StrUsuario;
            obj.StrMaquina = Contabilidad.SEMSession.GetInstance.StrMaquina;

            value = pol.Save(obj);

            if (value != "")            
                txtPoliza.Text = value;                
            else
                txtPoliza.Text = "";

            txtPoliza.UpdateAfterCallBack = true;                      
            obj = null;
            pol = null;
        }
        catch (Exception ex)
        {
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "msfPolErr", "alert('" + ex.Message + "');", true);
        }
    }
    #endregion  
    
    #region SaveAllDetail
    protected void SaveAllDetail()
    {
        try
        {
            Entity_PolizasDet obj;
            obj = new Entity_PolizasDet();
            PolizasDet pol;
            pol = new PolizasDet();
            int partida = 0;
            string value = "";

            obj.IntEmpresa = txtEmpresa.Text == "" ? Contabilidad.SEMSession.GetInstance.IntEmpresa : Convert.ToInt32(txtEmpresa.Text);
            obj.strPoliza = txtPoliza.Text;
            obj.strTipoPoliza = cboTipoPoliza.SelectedValue;
            obj.datFecha = Convert.ToDateTime(txtFechaInicial.Text);           
            obj.StrUsuario = Contabilidad.SEMSession.GetInstance.StrUsuario;
            obj.StrMaquina = Contabilidad.SEMSession.GetInstance.StrMaquina;

            for (int i = 0; i < grdPolizaDet.Rows.Count; i++)
            {
                partida = Convert.ToInt32(grdPolizaDet.DataKeys[i].Values[0].ToString());
                Anthem.TextBox txtCuentaDet = (Anthem.TextBox)grdPolizaDet.Rows[i].FindControl("txtCuentaDet");
                Anthem.TextBox txtAuxiliarDet = (Anthem.TextBox)grdPolizaDet.Rows[i].FindControl("txtAuxiliarDet");
                Anthem.TextBox txtObraDet = (Anthem.TextBox)grdPolizaDet.Rows[i].FindControl("txtObraDet");
                Anthem.TextBox txtReferenciaDet = (Anthem.TextBox)grdPolizaDet.Rows[i].FindControl("txtReferenciaDet");
                Anthem.TextBox txtDescripcionDet = (Anthem.TextBox)grdPolizaDet.Rows[i].FindControl("txtDescripcionDet");
                Anthem.TextBox txtCargosDet = (Anthem.TextBox)grdPolizaDet.Rows[i].FindControl("txtCargosDet");
                Anthem.TextBox txtAbonosDet = (Anthem.TextBox)grdPolizaDet.Rows[i].FindControl("txtAbonosDet");
                Anthem.CheckBox chkSelect = (Anthem.CheckBox)grdPolizaDet.Rows[i].FindControl("chkSelect");

                if (chkSelect.Checked)
                {
                    obj.intPartida = partida;
                    obj.strCuenta = txtCuentaDet.Text;
                    obj.strKeys = txtAuxiliarDet.Text;
                    obj.StrObraInicial = txtObraDet.Text;
                    obj.strReferencia = txtReferenciaDet.Text;
                    obj.strDescripcion = txtDescripcionDet.Text;
                    obj.dblImporte = txtCargosDet.Text == "" ? 0 : Convert.ToDecimal(txtCargosDet.Text.Replace(",", "").Replace("$", ""));
                    obj.dblImporteTipoMoneda = txtAbonosDet.Text == "" ? 0 : Convert.ToDecimal(txtAbonosDet.Text.Replace(",", "").Replace("$", ""));

                    value = pol.Save(obj);
                }
            }                                   

            obj = null;
            pol = null;
        }
        catch (Exception ex)
        {
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "msfPolErr", "alert('" + ex.Message + "');", true);
        }
    }
    #endregion  

    #region UpdateCA
    protected void UpdateCA()
    {
        try
        {
            Entity_PolizasEnc obj;
            obj = new Entity_PolizasEnc();
            PolizasEnc pol;
            pol = new PolizasEnc();
            string value = "";

            obj.IntEmpresa = txtEmpresa.Text == "" ? Contabilidad.SEMSession.GetInstance.IntEmpresa : Convert.ToInt32(txtEmpresa.Text);
            obj.strPoliza = txtPoliza.Text;            
            obj.datFecha = Convert.ToDateTime(txtFechaInicial.Text);

            value = pol.UpdateCA(obj);             
           
            obj = null;
            pol = null;
        }
        catch (Exception ex)
        {
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "msfPolErr", "alert('" + ex.Message + "');", true);
        }
    }
    #endregion  

    #region DrgdList

    #region DgrdList_RowDeleting
    protected void DgrdList_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        //try
        //{
        //    Entity_PolizasDet obj;
        //    obj = new Entity_PolizasDet();
        //    PolizasDet pol;
        //    pol = new PolizasDet();
        //    string value = "";

        //    obj.IntEmpresa = txtEmpresa.Text == "" ? Contabilidad.SEMSession.GetInstance.IntEmpresa : Convert.ToInt32(txtEmpresa.Text);
        //    obj.strPoliza = txtPoliza.Text;
        //    obj.strTipoPoliza = cboTipoPoliza.SelectedValue;
        //    obj.intPartida = Convert.ToInt32(grdPolizaDet.DataKeys[e.RowIndex].Values[0].ToString());
        //    obj.datFecha = Convert.ToDateTime(txtFechaInicial.Text);
        //    obj.StrUsuario = Contabilidad.SEMSession.GetInstance.StrUsuario;
        //    obj.StrMaquina = Contabilidad.SEMSession.GetInstance.StrMaquina;

        //    value = pol.Delete(obj);

        //    obj = null;
        //    pol = null;
        //    BindGrid();
        //    Find();

        //    Anthem.Manager.RegisterStartupScript(Page.GetType(), "CuentaPosition", "document.getElementById('" + txtCuenta.ClientID + "').focus(); ", true);
        //}
        //catch (Exception ex)
        //{
        //    Anthem.Manager.RegisterStartupScript(Page.GetType(), "msfPolErr", "alert('" + ex.Message + "');", true);
        //}        
    }
    #endregion DgrdList_RowDeleting

    #region DgrdList_RowCreated
    protected void DgrdList_RowCreated(object sender, GridViewRowEventArgs e)
    {
        int i = 0;
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            DataRowView dataRowView = (DataRowView)e.Row.DataItem;
            if (dataRowView != null)
            {
                i++;
                string cuenta = dataRowView.Row["Cuenta"].ToString();
                string nombre = dataRowView.Row["DesCuenta"].ToString();
                string auxiliar = dataRowView.Row["Auxiliar"].ToString();
                string obra = dataRowView.Row["Obra"].ToString();
                string referencia = dataRowView.Row["Referencia"].ToString();
                string cargos = dataRowView.Row["Cargos"].ToString();
                string abonos = dataRowView.Row["Abonos"].ToString();
                string descripcion = dataRowView.Row["Descricpion"].ToString();
                string conciliado = dataRowView.Row["Conciliado"].ToString();

                Anthem.TextBox txtCuentaDet = (Anthem.TextBox)e.Row.FindControl("txtCuentaDet");
                Anthem.TextBox txtCuentaNombreDet = (Anthem.TextBox)e.Row.FindControl("txtCuentaNombreDet");
                Anthem.TextBox txtAuxiliarDet = (Anthem.TextBox)e.Row.FindControl("txtAuxiliarDet");
                Anthem.TextBox txtObraDet = (Anthem.TextBox)e.Row.FindControl("txtObraDet");
                Anthem.TextBox txtReferenciaDet = (Anthem.TextBox)e.Row.FindControl("txtReferenciaDet");
                Anthem.TextBox txtCargosDet = (Anthem.TextBox)e.Row.FindControl("txtCargosDet");
                Anthem.TextBox txtAbonosDet = (Anthem.TextBox)e.Row.FindControl("txtAbonosDet");
                Anthem.TextBox txtDescripcionDet = (Anthem.TextBox)e.Row.FindControl("txtDescripcionDet");
                Anthem.ImageButton lknDelete = (Anthem.ImageButton)e.Row.FindControl("lknDelete");
                Anthem.CheckBox chkSelect = (Anthem.CheckBox)e.Row.FindControl("chkSelect");

                txtCuentaDet.Text = cuenta;
                txtCuentaNombreDet.Text = nombre;
                txtAuxiliarDet.Text = auxiliar;
                txtObraDet.Text = obra;
                txtReferenciaDet.Text = referencia;
                txtCargosDet.Text = cargos;
                txtAbonosDet.Text = abonos;
                txtDescripcionDet.Text = descripcion;

                txtCuentaNombreDet.Style.Value = "background-color:Silver;color:#000066;text-align:left;";

                txtCargosDet.Attributes.Add("onkeypress", "OnlyNumber();");
                txtAbonosDet.Attributes.Add("onkeypress", "OnlyNumber();");
                txtCargosDet.Attributes.Add("onchange", "UpdateCargos();");
                txtAbonosDet.Attributes.Add("onchange", "UpdateAbonos();");

                txtCuentaDet.Attributes.Add("onchange", "SelectCHK(" + chkSelect.ClientID + ")");
                txtAuxiliarDet.Attributes.Add("onchange", "SelectCHK(" + chkSelect.ClientID + ")");
                txtObraDet.Attributes.Add("onchange", "SelectCHK(" + chkSelect.ClientID + ")");
                txtReferenciaDet.Attributes.Add("onchange", "SelectCHK(" + chkSelect.ClientID + ")");
                txtDescripcionDet.Attributes.Add("onchange", "SelectCHK(" + chkSelect.ClientID + ")");

                txtCuentaDet.UpdateAfterCallBack = true;
                txtCuentaNombreDet.UpdateAfterCallBack = true;
                txtAuxiliarDet.UpdateAfterCallBack = true;
                txtObraDet.UpdateAfterCallBack = true;
                txtReferenciaDet.UpdateAfterCallBack = true;
                txtCargosDet.UpdateAfterCallBack = true;
                txtAbonosDet.UpdateAfterCallBack = true;
                txtDescripcionDet.UpdateAfterCallBack = true;
                lknDelete.UpdateAfterCallBack = true;
            }
        }
    }
    #endregion    

    #region DgrdList_Sorting
    protected void DgrdList_Sorting(object sender, GridViewSortEventArgs e)
    {
        ctrlPagger1.SetNewSort(e.SortExpression, e.SortDirection);
        BindGrid();
    }
    #endregion

    #endregion   

    #region Cuentas
    protected void Cuentas()
    {
        Contabilidad.Bussines.Cuentas cuentas;
        cuentas = new Cuentas();
        Entity_Cuentas obj;
        obj = new Entity_Cuentas();

        obj.IntEmpresa = txtEmpresa.Text == "" ? Contabilidad.SEMSession.GetInstance.IntEmpresa : Convert.ToInt32(txtEmpresa.Text);
        obj.StrCuenta = Zero(txtCuenta.Text) + Zero(txtSubCuenta.Text) + Zero(txtSubSubCuenta.Text);
        obj = cuentas.GetByPrimaryKey(obj);

        if (obj != null)
        {
            hddNombreCuenta.Value = obj.StrNombre; ;
            hddCuenta.Value = obj.StrCuenta;
            hddIndAuxiliar.Value = obj.IntIndAuxiliar.ToString();
        }
        else
        {
            hddNombreCuenta.Value = "";
            hddIndAuxiliar.Value = "0";
            hddCuenta.Value = "";
            txtSubCuenta.Text = "";
            txtSubSubCuenta.Text = "";
        }

        txtCuenta.UpdateAfterCallBack = true;
        hddNombreCuenta.UpdateAfterCallBack = true;
        txtSubCuenta.UpdateAfterCallBack = true;
        txtSubSubCuenta.UpdateAfterCallBack = true;
        hddIndAuxiliar.UpdateAfterCallBack = true;

        obj = null;
        cuentas = null;
    }
    #endregion

    #region Zero
    private string Zero(string value)
    {
        string strZero = "";

        switch (value.Length)
        {
            case 1:
                strZero = "000" + value;
                break;
            case 2:
                strZero = "00" + value;
                break;
            case 3:
                strZero = "0" + value;
                break;
            case 4:
                strZero = value;
                break;
        }            

        return strZero;
    }
    #endregion

    #region Pagger
    public int PageSize
    {
        get { return ctrlPagger1.PageSize; }
        set { ctrlPagger1.PageSize = value; }
    }

    public int PageIndex
    {
        get { return ctrlPagger1.PageIndex; }
        set { ctrlPagger1.PageIndex = value; }
    }

    public SortDirection SortDirection
    {
        get { return ctrlPagger1.SortDirection; }
        set { ctrlPagger1.SortDirection = value; }
    }

    public string SortExpression
    {
        get { return ctrlPagger1.SortExpression; }
        set { ctrlPagger1.SortExpression = value; }
    }

    public int TotalRecords
    {
        get { return ctrlPagger1.TotalRecords; }
        set { ctrlPagger1.TotalRecords = value; }
    }
    public int FromRecord
    {
        get { return ctrlPagger1.FromRecord; }
        set { ctrlPagger1.FromRecord = value; }
    }
    public int ToRecord
    {
        get { return ctrlPagger1.ToRecord; }
        set { ctrlPagger1.ToRecord = value; }
    }
    public int TotalPages
    {
        get { return ctrlPagger1.TotalPages; }
        set { ctrlPagger1.TotalPages = value; }
    }
    public void ShowButtons()
    {
        ctrlPagger1.ShowButtons();
    }
    #endregion

    #region Print
    private void Print()
    {
        string[] arrDatos;
        String strParameters = "";

        arrDatos = new string[12];
        arrDatos[0] = txtEmpresa.Text == "" ? Contabilidad.SEMSession.GetInstance.IntEmpresa.ToString() : txtEmpresa.Text;
        arrDatos[1] = Convert.ToDateTime(txtFechaInicial.Text).Date.Year.ToString();
        arrDatos[2] = Convert.ToDateTime(txtFechaInicial.Text).Date.Month.ToString(); ;
        arrDatos[3] = cboTipoPoliza.SelectedValue;
        arrDatos[4] = cboTipoPoliza.SelectedValue;
        arrDatos[5] = txtPoliza.Text.Substring(5);
        arrDatos[6] = txtPoliza.Text.Substring(5);
        arrDatos[7] = "1";
        arrDatos[8] = "1";
        arrDatos[9] = "1";
        arrDatos[10] = "1";
        arrDatos[11] = "0";

        strParameters = String.Format("{0}[--]{1}[--]{2}[--]{3}[--]{4}[--]{5}[--]{6}[--]{7}[--]{8}[--]{9}[--]{10}[--]{11}", arrDatos);

        string strServerName = "http://" + HttpContext.Current.Request.ServerVariables["SERVER_NAME"].ToString() + ":" + HttpContext.Current.Request.ServerVariables["SERVER_PORT"].ToString() + "/Contabilidad/Utils/CRViewer.aspx";
        string strQueryString = string.Empty;
        strQueryString = "?type=pdf";
        strQueryString += "&report=Pages/Reportes/Polizas/Poliza.rpt";
        strQueryString += "&db=VetecMarfilAdmin";
        strQueryString += "&parameters=" + strParameters;
        strQueryString += "&Titulos=Reporte de Pólizas'";

        strQueryString = strQueryString.Replace("'", "|");
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "rpt", "window.open('" + strServerName + strQueryString + "');", true);
    }
    #endregion     

    #region Delete
    protected void Delete()
    {
        try
        {
            Entity_PolizasEnc obj;
            obj = new Entity_PolizasEnc();
            PolizasEnc pol;
            pol = new PolizasEnc();
            string value = "";

            obj.IntEmpresa = txtEmpresa.Text == "" ? Contabilidad.SEMSession.GetInstance.IntEmpresa : Convert.ToInt32(txtEmpresa.Text);
            obj.strPoliza = txtPoliza.Text;
            obj.intEjercicio = Convert.ToDateTime(txtFechaInicial.Text).Date.Year;
            obj.StrUsuario = Contabilidad.SEMSession.GetInstance.StrUsuario;
            obj.StrMaquina = Contabilidad.SEMSession.GetInstance.StrMaquina;

            value = pol.Delete(obj);

            if (txtPoliza.Enabled == false)
                Anthem.Manager.RegisterStartupScript(Page.GetType(), "polErase", "alert('La poliza " + txtPoliza.Text + " se elimino correctamente.'); window.opener.document.getElementById('ctl00_CPHBase_lknRefresh').click(); window.close(); ", true);
            else
                Anthem.Manager.RegisterStartupScript(Page.GetType(), "msgPolDel222", "alert('La poliza " + txtPoliza.Text + " se elimino correctamente.');", true);
            Clear();
        }
        catch (Exception ex)
        {
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "msfPolErr", "alert('" + ex.Message + "');", true);
        }
    }
    #endregion          
    
}

