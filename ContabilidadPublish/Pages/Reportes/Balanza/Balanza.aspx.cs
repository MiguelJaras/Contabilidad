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

public partial class Contabilidad_Reportes_Balanza : System.Web.UI.Page
{
    Report_Pages_Base toolbar;
    protected void Page_Load(object sender, EventArgs e)
    {
        toolbar = (Report_Pages_Base)this.Master;
        Anthem.Manager.Register(this);
        
        if (!IsPostBack)
        {
            btnExpandReportes.Attributes.Add("onClick", "ReportVisible(this,'" + pnlReportes1.ClientID + "');");
            Month();
            Year();
            Nivel();
            txtEmpresa.Text = Contabilidad.SEMSession.GetInstance.IntEmpresa.ToString();
            txtEmpresa_TextChange(null, null);
            cboYear.SelectedValue = DateTime.Now.Year.ToString();
            cboMonth.SelectedValue = DateTime.Now.Month.ToString();
           
            JavaScript();

            string mes = DateTime.Now.Month < 10 ? "0" + DateTime.Now.Month.ToString() : DateTime.Now.Month.ToString();
            txtFechaInicial.Text = "01/" + mes + "/" + DateTime.Now.Year.ToString();
            txtFechaPrint.Text = "01/" + mes + "/" + DateTime.Now.Year.ToString();
            txtFechaFinal.Text = DateTime.Now.ToString("dd/MM/yyyy");
        }


        ImgDate.OnClientClick = "if(self.gfPop)gfPop.fPopCalendar(document.getElementById('" + txtFechaInicial.ClientID + "')); giDatePos=0; return false;";
        ImgDateFin.OnClientClick = "if(self.gfPop)gfPop.fPopCalendar(document.getElementById('" + txtFechaFinal.ClientID + "')); giDatePos=0; return false;";
        btnFechaPrint.OnClientClick = "if(self.gfPop)gfPop.fPopCalendar(document.getElementById('" + txtFechaPrint.ClientID + "')); giDatePos=0; return false;";
    }

    #region JavaScript
    private void JavaScript()
    {
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtEmpresa", "var objText = new VetecText('" + txtEmpresa.ClientID + "', 'number', 4);", true);
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtCuenta", "var objText = new VetecText('" + txtCuenta.ClientID + "', 'number', 4);", true);

        if (!IsPostBack && !IsCallback)
        {
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "focusss", "document.all('ctl00_CPHFilters_txtEmpresa').focus()", true);
        }
    }
    #endregion  

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
        cboMonth.SelectedIndex = 0;

        cboMonth.Items.Insert(0, new ListItem("-- Seleccione --", "0"));
        cboMonth.SelectedIndex = 0;
        cboMonth.UpdateAfterCallBack = true;

        cboMonth.UpdateAfterCallBack = true;
    }
    #endregion

    #region Nivel
    private void Nivel()
    {
        cboNivel.Items.Insert(0, new ListItem("Nivel 1", "1"));
        cboNivel.Items.Insert(1, new ListItem("Nivel 2", "2"));
        cboNivel.Items.Insert(2, new ListItem("Nivel 3", "3"));

        cboNivel.SelectedIndex = 0;
        cboNivel.UpdateAfterCallBack = true;
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

        obj = null;
        emp = null;
    }
    #endregion            

    #region lknAnalisis_Click
    protected void lknAnalisis_Click(object sender, EventArgs e)
    {
        string url;
        string queryString;
        string intEmpresa = txtEmpresa.Text;
        string intEjercicio = cboYear.SelectedValue;
        string intMes = cboMonth.SelectedValue;
        string intNivel = cboNivel.SelectedValue;
        string obraIni = txtClave.Text == "" ? "0" : txtClave.Text;
        string obraFin = txtClaveFin.Text == "" ? "0" : txtClaveFin.Text;
        string CuentaIni = txtCuenta.Text == "" ? "0" : txtCuenta.Text;
        string CuentaFin = txtCuentaFin.Text == "" ? "0" : txtCuentaFin.Text;
        string AreaIni = txtArea.Text == "" ? "0" : txtArea.Text;
        string AreaFin = txtAreaFin.Text == "" ? "0" : txtAreaFin.Text;
        string ColoniaIni = txtColonia.Text == "" ? "0" : txtColonia.Text;
        string ColoniaFin = txtColoniaFin.Text == "" ? "0" : txtColoniaFin.Text;

        queryString = "?intEmpresa=" + intEmpresa + "&intEjercicio=" + intEjercicio + "&intMes=" + intMes + "&intNivel=" + intNivel + "&strObraIni=" + obraIni + "&strObraFin=" + obraFin + "&strCuentaIni=" + CuentaIni + "&strCuentaFin=" + CuentaFin + "&strAreaIni=" + AreaIni + "&strAreaFin=" + AreaFin + "&strColoniaIni=" + ColoniaIni + "&strColoniaFin=" + ColoniaFin;
        url = "Analisis.aspx" + queryString;

        Anthem.Manager.RegisterStartupScript(Page.GetType(), "rpt", "window.showModalDialog('" + url + "','', 'DialogWidth:1000px; DialogHeight:600px;toolbar=no,status=no,scroll=no');", true);        
    }
    #endregion

    #region lknBalanza_Click
    protected void lknBalanza_Click(object sender, EventArgs e)
    {
        if (!chkFecha.Checked)
        {
            string[] arrDatos;
            String strParameters = "";
            Entity_Conciliaciones obj;
            obj = new Entity_Conciliaciones();

            obj.IntEmpresa = Convert.ToInt32(txtEmpresa.Text);
            obj.IntEjercicio = Convert.ToInt32(cboYear.SelectedValue);
            obj.IntMes = Convert.ToInt32(cboMonth.SelectedValue);
            obj.IntFolio = Convert.ToInt32(cboNivel.SelectedValue);
            obj.StrObraInicial = txtClave.Text == "" ? "0" : txtClave.Text;
            obj.StrObraFinal = txtClaveFin.Text == "" ? "0" : txtClaveFin.Text;
            obj.StrFechaInicial = txtCuenta.Text == "" ? "0" : txtCuenta.Text;
            obj.StrFechaFinal = txtCuentaFin.Text == "" ? "0" : txtCuentaFin.Text;
            obj.IntProveedorInicial = txtArea.Text == "" ? 0 : Convert.ToInt32(txtArea.Text);
            obj.IntProveedorFinal = txtAreaFin.Text == "" ? 0 : Convert.ToInt32(txtAreaFin.Text);
            obj.IntParametroInicial = txtColonia.Text == "" ? 0 : Convert.ToInt32(txtColonia.Text);
            obj.IntParametroFinal = txtColoniaFin.Text == "" ? 0 : Convert.ToInt32(txtColoniaFin.Text);
            obj.StrInsumoInicial = "0";
            obj.StrInsumoFinal = "0";
            obj.StrMaquina = chkFechaPrint.Checked == false ? "0" : txtFechaPrint.Text;

            if (!toolbar.Check())
            {
                arrDatos = new string[15];
                arrDatos[0] = obj.IntEmpresa.ToString();
                arrDatos[1] = obj.IntEjercicio.ToString();
                arrDatos[2] = obj.IntMes.ToString();
                arrDatos[3] = obj.IntFolio.ToString();
                arrDatos[4] = obj.StrFechaInicial.ToString();
                arrDatos[5] = obj.StrFechaFinal.ToString();
                arrDatos[6] = obj.StrObraInicial.ToString();
                arrDatos[7] = obj.StrObraFinal.ToString();
                arrDatos[8] = obj.IntProveedorInicial.ToString();
                arrDatos[9] = obj.IntProveedorFinal.ToString();
                arrDatos[10] = obj.IntParametroInicial.ToString();
                arrDatos[11] = obj.IntParametroFinal.ToString();
                arrDatos[12] = obj.StrInsumoInicial.ToString();
                arrDatos[13] = obj.StrInsumoFinal.ToString();
                arrDatos[14] = obj.StrMaquina.ToString();

                strParameters = String.Format("{0}[--]{1}[--]{2}[--]{3}[--]{4}[--]{5}[--]{6}[--]{7}[--]{8}[--]{9}[--]{10}[--]{11}[--]{12}[--]{13}[--]{14}", arrDatos);

                string strServerName = "http://" + HttpContext.Current.Request.ServerVariables["SERVER_NAME"].ToString() + ":" + HttpContext.Current.Request.ServerVariables["SERVER_PORT"].ToString() + "/Contabilidad/Utils/CRViewer.aspx";
                string strQueryString = string.Empty;
                strQueryString = "?type=pdf";
                strQueryString += "&report=Pages/Reportes/Balanza/Balanza.rpt";
                strQueryString += "&db=VetecMarfilAdmin";
                strQueryString += "&parameters=" + strParameters;

                strQueryString = strQueryString.Replace("'", "|");
                Anthem.Manager.RegisterStartupScript(Page.GetType(), "rpt", "window.open('" + strServerName + strQueryString + "');", true);
            }
            else
            {
                PolizasDet pol;
                pol = new PolizasDet();

                string query;

                query = pol.ExportBalanza(obj);

                obj = null;
                pol = null;

                string queryString = "?query=" + query + "&type=xls&tabla=1";
                Response.Redirect("../../../Utils/Excel.aspx" + queryString);
            }
        }
        else
        {
            string[] arrDatos2;
            String strParameters = "";
            Entity_Conciliaciones obj;
            obj = new Entity_Conciliaciones();

            obj.IntEmpresa = Convert.ToInt32(txtEmpresa.Text);
            obj.StrFechaInicial = txtFechaInicial.Text;
            obj.StrFechaFinal = txtFechaFinal.Text;
            obj.IntFolio = Convert.ToInt32(cboNivel.SelectedValue);
            obj.StrObraInicial = txtClave.Text == "" ? "0" : txtClave.Text;
            obj.StrObraFinal = txtClaveFin.Text == "" ? "0" : txtClaveFin.Text;
            obj.StrPoliza = txtCuenta.Text == "" ? "0" : txtCuenta.Text;
            obj.StrReferencia = txtCuentaFin.Text == "" ? "0" : txtCuentaFin.Text;
            obj.IntProveedorInicial = txtArea.Text == "" ? 0 : Convert.ToInt32(txtArea.Text);
            obj.IntProveedorFinal = txtAreaFin.Text == "" ? 0 : Convert.ToInt32(txtAreaFin.Text);
            obj.IntParametroInicial = txtColonia.Text == "" ? 0 : Convert.ToInt32(txtColonia.Text);
            obj.IntParametroFinal = txtColoniaFin.Text == "" ? 0 : Convert.ToInt32(txtColoniaFin.Text);
            obj.StrInsumoInicial = "0";
            obj.StrInsumoFinal = "0";

            arrDatos2 = new string[14];

            arrDatos2[0] = obj.IntEmpresa.ToString();
            arrDatos2[1] = obj.StrFechaInicial.ToString();
            arrDatos2[2] = obj.StrFechaFinal.ToString();
            arrDatos2[3] = obj.IntFolio.ToString();
            arrDatos2[4] = obj.StrPoliza.ToString();
            arrDatos2[5] = obj.StrReferencia.ToString();
            arrDatos2[6] = obj.StrObraInicial.ToString();
            arrDatos2[7] = obj.StrObraFinal.ToString();
            arrDatos2[8] = obj.IntProveedorInicial.ToString();
            arrDatos2[9] = obj.IntProveedorFinal.ToString();
            arrDatos2[10] = obj.IntParametroInicial.ToString();
            arrDatos2[11] = obj.IntParametroFinal.ToString();
            arrDatos2[12] = obj.StrInsumoInicial.ToString();
            arrDatos2[13] = obj.StrInsumoFinal.ToString(); 

            if (!toolbar.Check())
            {                                             
                strParameters = String.Format("{0}[--]{1}[--]{2}[--]{3}[--]{4}[--]{5}[--]{6}[--]{7}[--]{8}[--]{9}[--]{10}[--]{11}[--]{12}[--]{13}", arrDatos2);

                string strServerName = "http://" + HttpContext.Current.Request.ServerVariables["SERVER_NAME"].ToString() + ":" + HttpContext.Current.Request.ServerVariables["SERVER_PORT"].ToString() + "/Contabilidad/Utils/CRViewer.aspx";
                string strQueryString = string.Empty;
                strQueryString = "?type=pdf";
                strQueryString += "&report=Pages/Reportes/Balanza/BalanzaRango.rpt";
                strQueryString += "&db=VetecMarfilAdmin";
                strQueryString += "&parameters=" + strParameters;

                strQueryString = strQueryString.Replace("'", "|");
                Anthem.Manager.RegisterStartupScript(Page.GetType(), "rpt", "window.open('" + strServerName + strQueryString + "');", true);
            }
            else
            {
                PolizasDet pol;
                pol = new PolizasDet();

                string query;

                query = sqlQuery("VetecMarfilAdmin..usp_tbPolizasDet_BalanzaRango ", arrDatos2);

                obj = null;
                pol = null;

                string queryString = "?query=" + query + "&type=xls&tabla=1";
                Response.Redirect("../../../Utils/Excel.aspx" + queryString);
            }
        }
    }
    #endregion

    #region lknBalanzaCero_Click
    protected void lknBalanzaCero_Click(object sender, EventArgs e)
    {
        if (!chkFecha.Checked)
        {
            string[] arrDatos;
            String strParameters = "";
            Entity_Conciliaciones obj;
            obj = new Entity_Conciliaciones();

            obj.IntEmpresa = Convert.ToInt32(txtEmpresa.Text);
            obj.IntEjercicio = Convert.ToInt32(cboYear.SelectedValue);
            obj.IntMes = Convert.ToInt32(cboMonth.SelectedValue);
            obj.IntFolio = Convert.ToInt32(cboNivel.SelectedValue);
            obj.StrObraInicial = txtClave.Text == "" ? "0" : txtClave.Text;
            obj.StrObraFinal = txtClaveFin.Text == "" ? "0" : txtClaveFin.Text;
            obj.StrFechaInicial = txtCuenta.Text == "" ? "0" : txtCuenta.Text;
            obj.StrFechaFinal = txtCuentaFin.Text == "" ? "0" : txtCuentaFin.Text;
            obj.IntProveedorInicial = txtArea.Text == "" ? 0 : Convert.ToInt32(txtArea.Text);
            obj.IntProveedorFinal = txtAreaFin.Text == "" ? 0 : Convert.ToInt32(txtAreaFin.Text);
            obj.IntParametroInicial = txtColonia.Text == "" ? 0 : Convert.ToInt32(txtColonia.Text);
            obj.IntParametroFinal = txtColoniaFin.Text == "" ? 0 : Convert.ToInt32(txtColoniaFin.Text);
            obj.StrInsumoInicial = "0";
            obj.StrInsumoFinal = "0";

            if (!toolbar.Check())
            {
                arrDatos = new string[14];
                arrDatos[0] = obj.IntEmpresa.ToString();
                arrDatos[1] = obj.IntEjercicio.ToString();
                arrDatos[2] = obj.IntMes.ToString();
                arrDatos[3] = obj.IntFolio.ToString();
                arrDatos[4] = obj.StrFechaInicial.ToString();
                arrDatos[5] = obj.StrFechaFinal.ToString();
                arrDatos[6] = obj.StrObraInicial.ToString();
                arrDatos[7] = obj.StrObraFinal.ToString();
                arrDatos[8] = obj.IntProveedorInicial.ToString();
                arrDatos[9] = obj.IntProveedorFinal.ToString();
                arrDatos[10] = obj.IntParametroInicial.ToString();
                arrDatos[11] = obj.IntParametroFinal.ToString();
                arrDatos[12] = obj.StrInsumoInicial.ToString();
                arrDatos[13] = obj.StrInsumoFinal.ToString();

                strParameters = String.Format("{0}[--]{1}[--]{2}[--]{3}[--]{4}[--]{5}[--]{6}[--]{7}[--]{8}[--]{9}[--]{10}[--]{11}[--]{12}[--]{13}", arrDatos);

                string strServerName = "http://" + HttpContext.Current.Request.ServerVariables["SERVER_NAME"].ToString() + ":" + HttpContext.Current.Request.ServerVariables["SERVER_PORT"].ToString() + "/Contabilidad/Utils/CRViewer.aspx";
                string strQueryString = string.Empty;
                strQueryString = "?type=pdf";
                strQueryString += "&report=Pages/Reportes/Balanza/Balanza_Cero.rpt";
                strQueryString += "&db=VetecMarfilAdmin";
                strQueryString += "&parameters=" + strParameters;

                strQueryString = strQueryString.Replace("'", "|");
                Anthem.Manager.RegisterStartupScript(Page.GetType(), "rpt", "window.open('" + strServerName + strQueryString + "');", true);
            }
            else
            {
                PolizasDet pol;
                pol = new PolizasDet();

                string query;

                query = pol.ExportBalanzaCero(obj);

                obj = null;
                pol = null;

                string queryString = "?query=" + query + "&type=xls";
                Response.Redirect("../../../Utils/Excel.aspx" + queryString);
            }
        }
        else
        {
            string[] arrDatos2;
            String strParameters = "";
            Entity_Conciliaciones obj;
            obj = new Entity_Conciliaciones();

            obj.IntEmpresa = Convert.ToInt32(txtEmpresa.Text);
            obj.StrFechaInicial = txtFechaInicial.Text;
            obj.StrFechaFinal = txtFechaFinal.Text;
            obj.IntFolio = Convert.ToInt32(cboNivel.SelectedValue);
            obj.StrObraInicial = txtClave.Text == "" ? "0" : txtClave.Text;
            obj.StrObraFinal = txtClaveFin.Text == "" ? "0" : txtClaveFin.Text;
            obj.StrPoliza = txtCuenta.Text == "" ? "0" : txtCuenta.Text;
            obj.StrReferencia = txtCuentaFin.Text == "" ? "0" : txtCuentaFin.Text;
            obj.IntProveedorInicial = txtArea.Text == "" ? 0 : Convert.ToInt32(txtArea.Text);
            obj.IntProveedorFinal = txtAreaFin.Text == "" ? 0 : Convert.ToInt32(txtAreaFin.Text);
            obj.IntParametroInicial = txtColonia.Text == "" ? 0 : Convert.ToInt32(txtColonia.Text);
            obj.IntParametroFinal = txtColoniaFin.Text == "" ? 0 : Convert.ToInt32(txtColoniaFin.Text);
            obj.StrInsumoInicial = "0";
            obj.StrInsumoFinal = "0";
            obj.IntConciliacion = 1;

            arrDatos2 = new string[14];

            arrDatos2[0] = obj.IntEmpresa.ToString();
            arrDatos2[1] = obj.StrFechaInicial.ToString();
            arrDatos2[2] = obj.StrFechaFinal.ToString();
            arrDatos2[3] = obj.IntFolio.ToString();
            arrDatos2[4] = obj.StrPoliza.ToString();
            arrDatos2[5] = obj.StrReferencia.ToString();
            arrDatos2[6] = obj.StrObraInicial.ToString();
            arrDatos2[7] = obj.StrObraFinal.ToString();
            arrDatos2[8] = obj.IntProveedorInicial.ToString();
            arrDatos2[9] = obj.IntProveedorFinal.ToString();
            arrDatos2[10] = obj.IntParametroInicial.ToString();
            arrDatos2[11] = obj.IntParametroFinal.ToString();
            arrDatos2[12] = obj.StrInsumoInicial.ToString();
            arrDatos2[13] = obj.StrInsumoFinal.ToString();

            if (!toolbar.Check())
            {
                strParameters = String.Format("{0}[--]{1}[--]{2}[--]{3}[--]{4}[--]{5}[--]{6}[--]{7}[--]{8}[--]{9}[--]{10}[--]{11}[--]{12}[--]{13}", arrDatos2);

                string strServerName = "http://" + HttpContext.Current.Request.ServerVariables["SERVER_NAME"].ToString() + ":" + HttpContext.Current.Request.ServerVariables["SERVER_PORT"].ToString() + "/Contabilidad/Utils/CRViewer.aspx";
                string strQueryString = string.Empty;
                strQueryString = "?type=pdf";
                strQueryString += "&report=Pages/Reportes/Balanza/Balanza_CeroRango.rpt";
                strQueryString += "&db=VetecMarfilAdmin";
                strQueryString += "&parameters=" + strParameters;

                strQueryString = strQueryString.Replace("'", "|");
                Anthem.Manager.RegisterStartupScript(Page.GetType(), "rpt", "window.open('" + strServerName + strQueryString + "');", true);
            }
            else
            {
                PolizasDet pol;
                pol = new PolizasDet();

                string query;

                query = sqlQuery("VetecMarfilAdmin..usp_tbPolizasDet_Balanza_CeroRango ", arrDatos2);

                obj = null;
                pol = null;

                string queryString = "?query=" + query + "&type=xls";
                Response.Redirect("../../../Utils/Excel.aspx" + queryString);
            }
        }
    }
    #endregion      

    #region lknObra_Click
    protected void lknObra_Click(object sender, EventArgs e)
    {
        if (!chkFecha.Checked)
        {
            string[] arrDatos;
            String strParameters = "";
            Entity_Conciliaciones obj;
            obj = new Entity_Conciliaciones();

            obj.IntEmpresa = Convert.ToInt32(txtEmpresa.Text);
            obj.IntEjercicio = Convert.ToInt32(cboYear.SelectedValue);
            obj.IntMes = Convert.ToInt32(cboMonth.SelectedValue);
            obj.IntFolio = Convert.ToInt32(cboNivel.SelectedValue);
            obj.StrObraInicial = txtClave.Text == "" ? "0" : txtClave.Text;
            obj.StrObraFinal = txtClaveFin.Text == "" ? "0" : txtClaveFin.Text;
            obj.StrFechaInicial = txtCuenta.Text == "" ? "0" : txtCuenta.Text;
            obj.StrFechaFinal = txtCuentaFin.Text == "" ? "0" : txtCuentaFin.Text;
            obj.IntProveedorInicial = txtArea.Text == "" ? 0 : Convert.ToInt32(txtArea.Text);
            obj.IntProveedorFinal = txtAreaFin.Text == "" ? 0 : Convert.ToInt32(txtAreaFin.Text);
            obj.IntParametroInicial = txtColonia.Text == "" ? 0 : Convert.ToInt32(txtColonia.Text);
            obj.IntParametroFinal = txtColoniaFin.Text == "" ? 0 : Convert.ToInt32(txtColoniaFin.Text);
            obj.StrInsumoInicial = "0";
            obj.StrInsumoFinal = "0";
            obj.IntConciliacion = 0;

            if (!toolbar.Check())
            {
                arrDatos = new string[15];
                arrDatos[0] = obj.IntEmpresa.ToString();
                arrDatos[1] = obj.IntEjercicio.ToString();
                arrDatos[2] = obj.IntMes.ToString();
                arrDatos[3] = obj.IntFolio.ToString();
                arrDatos[4] = obj.StrFechaInicial.ToString();
                arrDatos[5] = obj.StrFechaFinal.ToString();
                arrDatos[6] = obj.StrObraInicial.ToString();
                arrDatos[7] = obj.StrObraFinal.ToString();
                arrDatos[8] = obj.IntProveedorInicial.ToString();
                arrDatos[9] = obj.IntProveedorFinal.ToString();
                arrDatos[10] = obj.IntParametroInicial.ToString();
                arrDatos[11] = obj.IntParametroFinal.ToString();
                arrDatos[12] = obj.StrInsumoInicial.ToString();
                arrDatos[13] = obj.StrInsumoFinal.ToString();
                arrDatos[14] = obj.IntConciliacion.ToString();

                strParameters = String.Format("{0}[--]{1}[--]{2}[--]{3}[--]{4}[--]{5}[--]{6}[--]{7}[--]{8}[--]{9}[--]{10}[--]{11}[--]{12}[--]{13}[--]{14}", arrDatos);

                string strServerName = "http://" + HttpContext.Current.Request.ServerVariables["SERVER_NAME"].ToString() + ":" + HttpContext.Current.Request.ServerVariables["SERVER_PORT"].ToString() + "/Contabilidad/Utils/CRViewer.aspx";
                string strQueryString = string.Empty;
                strQueryString = "?type=pdf";
                strQueryString += "&report=Pages/Reportes/Balanza/Balanza_Obra.rpt";
                strQueryString += "&db=VetecMarfilAdmin";
                strQueryString += "&parameters=" + strParameters;

                strQueryString = strQueryString.Replace("'", "|");
                Anthem.Manager.RegisterStartupScript(Page.GetType(), "rpt", "window.open('" + strServerName + strQueryString + "');", true);
            }
            else
            {
                PolizasDet pol;
                pol = new PolizasDet();

                string query;

                query = pol.ExportBalanzaObra(obj);

                obj = null;
                pol = null;

                string queryString = "?query=" + query + "&type=xls";
                Response.Redirect("../../../Utils/Excel.aspx" + queryString);
            }
        }
        else
        {
            string[] arrDatos2;
            String strParameters = "";
            Entity_Conciliaciones obj;
            obj = new Entity_Conciliaciones();

            obj.IntEmpresa = Convert.ToInt32(txtEmpresa.Text);
            obj.StrFechaInicial = txtFechaInicial.Text;
            obj.StrFechaFinal = txtFechaFinal.Text;
            obj.IntFolio = Convert.ToInt32(cboNivel.SelectedValue);
            obj.StrObraInicial = txtClave.Text == "" ? "0" : txtClave.Text;
            obj.StrObraFinal = txtClaveFin.Text == "" ? "0" : txtClaveFin.Text;
            obj.StrPoliza = txtCuenta.Text == "" ? "0" : txtCuenta.Text;
            obj.StrReferencia = txtCuentaFin.Text == "" ? "0" : txtCuentaFin.Text;
            obj.IntProveedorInicial = txtArea.Text == "" ? 0 : Convert.ToInt32(txtArea.Text);
            obj.IntProveedorFinal = txtAreaFin.Text == "" ? 0 : Convert.ToInt32(txtAreaFin.Text);
            obj.IntParametroInicial = txtColonia.Text == "" ? 0 : Convert.ToInt32(txtColonia.Text);
            obj.IntParametroFinal = txtColoniaFin.Text == "" ? 0 : Convert.ToInt32(txtColoniaFin.Text);
            obj.StrInsumoInicial = "0";
            obj.StrInsumoFinal = "0";
            obj.IntConciliacion = 0;

            arrDatos2 = new string[15];

            arrDatos2[0] = obj.IntEmpresa.ToString();
            arrDatos2[1] = obj.StrFechaInicial.ToString();
            arrDatos2[2] = obj.StrFechaFinal.ToString();
            arrDatos2[3] = obj.IntFolio.ToString();
            arrDatos2[4] = obj.StrPoliza.ToString();
            arrDatos2[5] = obj.StrReferencia.ToString();
            arrDatos2[6] = obj.StrObraInicial.ToString();
            arrDatos2[7] = obj.StrObraFinal.ToString();
            arrDatos2[8] = obj.IntProveedorInicial.ToString();
            arrDatos2[9] = obj.IntProveedorFinal.ToString();
            arrDatos2[10] = obj.IntParametroInicial.ToString();
            arrDatos2[11] = obj.IntParametroFinal.ToString();
            arrDatos2[12] = obj.StrInsumoInicial.ToString();
            arrDatos2[13] = obj.StrInsumoFinal.ToString();
            arrDatos2[14] = obj.IntConciliacion.ToString();

            if (!toolbar.Check())
            {                
                strParameters = String.Format("{0}[--]{1}[--]{2}[--]{3}[--]{4}[--]{5}[--]{6}[--]{7}[--]{8}[--]{9}[--]{10}[--]{11}[--]{12}[--]{13}[--]{14}", arrDatos2);

                string strServerName = "http://" + HttpContext.Current.Request.ServerVariables["SERVER_NAME"].ToString() + ":" + HttpContext.Current.Request.ServerVariables["SERVER_PORT"].ToString() + "/Contabilidad/Utils/CRViewer.aspx";
                string strQueryString = string.Empty;
                strQueryString = "?type=pdf";
                strQueryString += "&report=Pages/Reportes/Balanza/Balanza_ObraRango.rpt";
                strQueryString += "&db=VetecMarfilAdmin";
                strQueryString += "&parameters=" + strParameters;

                strQueryString = strQueryString.Replace("'", "|");
                Anthem.Manager.RegisterStartupScript(Page.GetType(), "rpt", "window.open('" + strServerName + strQueryString + "');", true);
            }
            else
            {
                PolizasDet pol;
                pol = new PolizasDet();

                string query;

                query = sqlQuery("VetecMarfilAdmin..usp_tbPolizasDet_Balanza_ObraRango ", arrDatos2);

                obj = null;
                pol = null;

                string queryString = "?query=" + query + "&type=xls";
                Response.Redirect("../../../Utils/Excel.aspx" + queryString);
            }
        }
    }
    #endregion

    #region lknObraCero_Click
    protected void lknObraCero_Click(object sender, EventArgs e)
    {
        if (!chkFecha.Checked)
        {
            string[] arrDatos;
            String strParameters = "";
            Entity_Conciliaciones obj;
            obj = new Entity_Conciliaciones();

            obj.IntEmpresa = Convert.ToInt32(txtEmpresa.Text);
            obj.IntEjercicio = Convert.ToInt32(cboYear.SelectedValue);
            obj.IntMes = Convert.ToInt32(cboMonth.SelectedValue);
            obj.IntFolio = Convert.ToInt32(cboNivel.SelectedValue);
            obj.StrObraInicial = txtClave.Text == "" ? "0" : txtClave.Text;
            obj.StrObraFinal = txtClaveFin.Text == "" ? "0" : txtClaveFin.Text;
            obj.StrFechaInicial = txtCuenta.Text == "" ? "0" : txtCuenta.Text;
            obj.StrFechaFinal = txtCuentaFin.Text == "" ? "0" : txtCuentaFin.Text;
            obj.IntProveedorInicial = txtArea.Text == "" ? 0 : Convert.ToInt32(txtArea.Text);
            obj.IntProveedorFinal = txtAreaFin.Text == "" ? 0 : Convert.ToInt32(txtAreaFin.Text);
            obj.IntParametroInicial = txtColonia.Text == "" ? 0 : Convert.ToInt32(txtColonia.Text);
            obj.IntParametroFinal = txtColoniaFin.Text == "" ? 0 : Convert.ToInt32(txtColoniaFin.Text);
            obj.StrInsumoInicial = "0";
            obj.StrInsumoFinal = "0";
            obj.IntConciliacion = 1;

            if (!toolbar.Check())
            {
                arrDatos = new string[15];
                arrDatos[0] = obj.IntEmpresa.ToString();
                arrDatos[1] = obj.IntEjercicio.ToString();
                arrDatos[2] = obj.IntMes.ToString();
                arrDatos[3] = obj.IntFolio.ToString();
                arrDatos[4] = obj.StrFechaInicial.ToString();
                arrDatos[5] = obj.StrFechaFinal.ToString();
                arrDatos[6] = obj.StrObraInicial.ToString();
                arrDatos[7] = obj.StrObraFinal.ToString();
                arrDatos[8] = obj.IntProveedorInicial.ToString();
                arrDatos[9] = obj.IntProveedorFinal.ToString();
                arrDatos[10] = obj.IntParametroInicial.ToString();
                arrDatos[11] = obj.IntParametroFinal.ToString();
                arrDatos[12] = obj.StrInsumoInicial.ToString();
                arrDatos[13] = obj.StrInsumoFinal.ToString();
                arrDatos[14] = obj.IntConciliacion.ToString();

                strParameters = String.Format("{0}[--]{1}[--]{2}[--]{3}[--]{4}[--]{5}[--]{6}[--]{7}[--]{8}[--]{9}[--]{10}[--]{11}[--]{12}[--]{13}[--]{14}", arrDatos);

                string strServerName = "http://" + HttpContext.Current.Request.ServerVariables["SERVER_NAME"].ToString() + ":" + HttpContext.Current.Request.ServerVariables["SERVER_PORT"].ToString() + "/Contabilidad/Utils/CRViewer.aspx";
                string strQueryString = string.Empty;
                strQueryString = "?type=pdf";
                strQueryString += "&report=Pages/Reportes/Balanza/Balanza_Obra.rpt";
                strQueryString += "&db=VetecMarfilAdmin";
                strQueryString += "&parameters=" + strParameters;

                strQueryString = strQueryString.Replace("'", "|");
                Anthem.Manager.RegisterStartupScript(Page.GetType(), "rpt", "window.open('" + strServerName + strQueryString + "');", true);
            }
            else
            {
                PolizasDet pol;
                pol = new PolizasDet();

                string query;

                query = pol.ExportBalanzaObra(obj);

                obj = null;
                pol = null;

                string queryString = "?query=" + query + "&type=xls";
                Response.Redirect("../../../Utils/Excel.aspx" + queryString);
            }
        }
        else
        {
            string[] arrDatos2;
            String strParameters = "";
            Entity_Conciliaciones obj;
            obj = new Entity_Conciliaciones();

            obj.IntEmpresa = Convert.ToInt32(txtEmpresa.Text);
            obj.StrFechaInicial = txtFechaInicial.Text;
            obj.StrFechaFinal = txtFechaFinal.Text;
            obj.IntFolio = Convert.ToInt32(cboNivel.SelectedValue);
            obj.StrObraInicial = txtClave.Text == "" ? "0" : txtClave.Text;
            obj.StrObraFinal = txtClaveFin.Text == "" ? "0" : txtClaveFin.Text;
            obj.StrPoliza = txtCuenta.Text == "" ? "0" : txtCuenta.Text;
            obj.StrReferencia = txtCuentaFin.Text == "" ? "0" : txtCuentaFin.Text;
            obj.IntProveedorInicial = txtArea.Text == "" ? 0 : Convert.ToInt32(txtArea.Text);
            obj.IntProveedorFinal = txtAreaFin.Text == "" ? 0 : Convert.ToInt32(txtAreaFin.Text);
            obj.IntParametroInicial = txtColonia.Text == "" ? 0 : Convert.ToInt32(txtColonia.Text);
            obj.IntParametroFinal = txtColoniaFin.Text == "" ? 0 : Convert.ToInt32(txtColoniaFin.Text);
            obj.StrInsumoInicial = "0";
            obj.StrInsumoFinal = "0";
            obj.IntConciliacion = 1;

            arrDatos2 = new string[15];

            arrDatos2[0] = obj.IntEmpresa.ToString();
            arrDatos2[1] = obj.StrFechaInicial.ToString();
            arrDatos2[2] = obj.StrFechaFinal.ToString();
            arrDatos2[3] = obj.IntFolio.ToString();
            arrDatos2[4] = obj.StrPoliza.ToString();
            arrDatos2[5] = obj.StrReferencia.ToString();
            arrDatos2[6] = obj.StrObraInicial.ToString();
            arrDatos2[7] = obj.StrObraFinal.ToString();
            arrDatos2[8] = obj.IntProveedorInicial.ToString();
            arrDatos2[9] = obj.IntProveedorFinal.ToString();
            arrDatos2[10] = obj.IntParametroInicial.ToString();
            arrDatos2[11] = obj.IntParametroFinal.ToString();
            arrDatos2[12] = obj.StrInsumoInicial.ToString();
            arrDatos2[13] = obj.StrInsumoFinal.ToString();
            arrDatos2[14] = obj.IntConciliacion.ToString();

            if (!toolbar.Check())
            {                
                strParameters = String.Format("{0}[--]{1}[--]{2}[--]{3}[--]{4}[--]{5}[--]{6}[--]{7}[--]{8}[--]{9}[--]{10}[--]{11}[--]{12}[--]{13}[--]{14}", arrDatos2);

                string strServerName = "http://" + HttpContext.Current.Request.ServerVariables["SERVER_NAME"].ToString() + ":" + HttpContext.Current.Request.ServerVariables["SERVER_PORT"].ToString() + "/Contabilidad/Utils/CRViewer.aspx";
                string strQueryString = string.Empty;
                strQueryString = "?type=pdf";
                strQueryString += "&report=Pages/Reportes/Balanza/Balanza_ObraRango.rpt";
                strQueryString += "&db=VetecMarfilAdmin";
                strQueryString += "&parameters=" + strParameters;

                strQueryString = strQueryString.Replace("'", "|");
                Anthem.Manager.RegisterStartupScript(Page.GetType(), "rpt", "window.open('" + strServerName + strQueryString + "');", true);
            }
            else
            {
                PolizasDet pol;
                pol = new PolizasDet();

                string query;

                query = sqlQuery("VetecMarfilAdmin..usp_tbPolizasDet_Balanza_ObraRango ", arrDatos2);

                obj = null;
                pol = null;

                string queryString = "?query=" + query + "&type=xls";
                Response.Redirect("../../../Utils/Excel.aspx" + queryString);
            }
        }
    }
    #endregion

    #region txtObraFin_TextChanged
    protected void txtObraFin_TextChanged(object sender, EventArgs e)
    {
        Obra obra;
        obra = new Obra();
        Entity_Obra obj;
        obj = new Entity_Obra();

        obj.IntEmpresa = Convert.ToInt32(txtEmpresa.Text);
        obj.IntSucursal = Convert.ToInt32(hddSucursal.Value);
        obj.StrClave = txtClaveFin.Text;

        obj = obra.GetByCode(obj);

        if (obj == null)
        {
            this.txtClaveFin.Text = "";
            this.txtNombreFin.Text = "";
        }
        else
        {
            this.txtClaveFin.Text = obj.StrClave;
            this.txtNombreFin.Text = obj.StrNombre;
        }

        Anthem.Manager.RegisterStartupScript(Page.GetType(), "focusCFOF", "document.getElementById('" + txtArea.ClientID + "').focus()", true);


        this.txtClaveFin.UpdateAfterCallBack = true;
        this.txtNombreFin.UpdateAfterCallBack = true;
    }
    #endregion

    #region txtObra_TextChanged
    protected void txtObra_TextChanged(object sender, EventArgs e)
    {
        Obra obra;
        obra = new Obra();
        Entity_Obra obj;
        obj = new Entity_Obra();

        obj.IntEmpresa = Convert.ToInt32(txtEmpresa.Text);
        obj.IntSucursal = Convert.ToInt32(hddSucursal.Value);
        obj.StrClave = txtClave.Text;

        obj = obra.GetByCode(obj);

        if (obj == null)
        {
            this.txtClave.Text = "";
            this.txtNombre.Text = "";
            txtClaveFin.Text = "";
            txtNombreFin.Text = "";
        }
        else
        {
            this.txtClave.Text = obj.StrClave;
            this.txtNombre.Text = obj.StrNombre;
            txtClaveFin.Text = obj.StrClave;
            txtNombreFin.Text = obj.StrNombre;
        }

        Anthem.Manager.RegisterStartupScript(Page.GetType(), "focusCFFO", "document.getElementById('" + txtClaveFin.ClientID + "').focus()", true);

        this.txtClave.UpdateAfterCallBack = true;
        this.txtNombre.UpdateAfterCallBack = true;
        txtClaveFin.UpdateAfterCallBack = true;
        txtNombreFin.UpdateAfterCallBack = true;        
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

            if (CuentaByKey != null || txtCuenta.Text != "")
            {
                //txtCuenta.Text = CuentaByKey.StrCuenta;
                //txtNombreCuenta.Text = CuentaByKey.StrNombre;
                //txtCuentaFin.Text = CuentaByKey.StrCuenta;
                //txtNombreCuentaFin.Text = CuentaByKey.StrNombre;

                txtCuenta.Text = CuentaByKey.StrCuenta;
                txtNombreCuenta.Text = CuentaByKey.StrNombre;

                string cuenta = Obj.GetMaxCuenta(EntiCuentas);

                EntiCuentas.StrCuenta = cuenta;

                CuentaByKey = Obj.GetByPrimaryKey(EntiCuentas);

                txtCuentaFin.Text = CuentaByKey.StrCuenta;
                txtNombreCuentaFin.Text = CuentaByKey.StrNombre;

            }
            else
            {
                txtCuenta.Text = "";
                txtNombreCuenta.Text = "";
                txtCuentaFin.Text = "";
                txtNombreCuentaFin.Text = "";
            }

            txtCuenta.UpdateAfterCallBack = true;
            txtNombreCuenta.UpdateAfterCallBack = true;
            txtCuentaFin.UpdateAfterCallBack = true;
            txtNombreCuentaFin.UpdateAfterCallBack = true;

            Anthem.Manager.RegisterStartupScript(Page.GetType(), "focusCCF", "document.getElementById('" + txtCuentaFin .ClientID+ "').focus()", true);

        }
        catch (System.IO.IOException ex) 
        { 

        }
    }
    #endregion

    #region txtCuenta_ChangeFin
    protected void txtCuenta_ChangeFin(object sender, EventArgs e)
    {
        try
        {
            Cuentas Obj = new Cuentas();
            Entity_Cuentas EntiCuentas = new Entity_Cuentas();

            EntiCuentas.IntEmpresa = txtEmpresa.Text == "" ? Contabilidad.SEMSession.GetInstance.IntEmpresa : Convert.ToInt32(txtEmpresa.Text);
            EntiCuentas.IntSucursal = hddSucursal.Value == "" ? Contabilidad.SEMSession.GetInstance.IntSucursal : Convert.ToInt32(hddSucursal.Value);
            EntiCuentas.StrCuenta = txtCuentaFin.Text;

            Entity_Cuentas CuentaByKey = Obj.GetByPrimaryKey(EntiCuentas);

            if (CuentaByKey != null || txtCuentaFin.Text != "")
            {
                txtCuentaFin.Text = CuentaByKey.StrCuenta;
                txtNombreCuentaFin.Text = CuentaByKey.StrNombre;
            }
            else
            {
                txtCuentaFin.Text = "";
                txtNombreCuentaFin.Text = "";
            }

            txtCuentaFin.UpdateAfterCallBack = true;
            txtNombreCuentaFin.UpdateAfterCallBack = true;

            Anthem.Manager.RegisterStartupScript(Page.GetType(), "focusCF", "document.getElementById('" + txtCuentaFin.ClientID + "').focus()", true);

        }
        catch (System.IO.IOException ex)
        {

        }
    }
    #endregion

    #region sqlQuery
    private string sqlQuery(string sp, string[] parameters)
    {
        string query = sp;
        string value = "";
        string par = "";

        for (int i = 0; i < parameters.Length; i++)
        {
            try
            {
                value = Convert.ToDecimal(parameters[i].ToString()).ToString();
                value = parameters[i].ToString() + ",";
            }
            catch
            {
                value = "'" + parameters[i].ToString() + "',";
            }

            par = par + value;
        }

        return query + par.Substring(0, par.Length - 1);
    }
    #endregion
    
    protected void txtColonia_TextChanged(object sender, EventArgs e)
    {
        Entity_Colonia obj;
        obj = new Entity_Colonia();
        Colonia col;
        col = new Colonia();

        obj.intColonia = txtColonia.Text == "" ? 0 : Convert.ToInt32(txtColonia.Text);

        obj = col.Fill(obj);

        if (obj != null)
        {
            txtColonia.Text = obj.intColonia.ToString ();
            txtColoniaNombre.Text = obj.strNombre;
            txtColoniaFin.Text = txtColonia.Text;
            txtColoniaNombreFin.Text = txtColoniaNombre.Text;
        }
        else
        {
            txtColonia.Text = "";
            txtColoniaNombre.Text = "";
            txtColoniaFin.Text = "";
            txtColoniaNombreFin.Text = "";
        }

        txtColonia.UpdateAfterCallBack = true;
        txtColoniaNombre.UpdateAfterCallBack = true;
        txtColoniaFin.UpdateAfterCallBack = true;
        txtColoniaNombreFin.UpdateAfterCallBack = true;
    }

    protected void txtArea_TextChanged1(object sender, EventArgs e)
    {
        Entity_Area obj;
        obj = new Entity_Area();
        Area area;
        area = new Area();

        obj.IntEmpresa = txtEmpresa.Text == "" ? Contabilidad.SEMSession.GetInstance.IntEmpresa : Convert.ToInt32(txtEmpresa.Text);
        obj.IntSucursal = hddSucursal.Value == "" ? Contabilidad.SEMSession.GetInstance.IntSucursal : Convert.ToInt32(hddSucursal.Value);
        obj.intArea = txtArea.Text == "" ? 0 : Convert.ToInt32(txtArea.Text);

        obj = area.Fill(obj);

        if (obj != null)
        {
            txtArea.Text = obj.intArea.ToString();
            txtNombreArea.Text = obj.strNombre;
            txtAreaFin.Text = obj.intArea.ToString();
            txtNombreAreaFin.Text = obj.strNombre;
        }
        else
        {
            txtArea.Text = "";
            txtNombreArea.Text = "";
            txtAreaFin.Text = "";
            txtNombreAreaFin.Text = "";
        }

        txtArea.UpdateAfterCallBack = true;
        txtNombreArea.UpdateAfterCallBack = true;
        txtAreaFin.UpdateAfterCallBack = true;
        txtNombreAreaFin.UpdateAfterCallBack = true;

        Anthem.Manager.RegisterStartupScript(Page.GetType(), "focusCFFAA", "document.getElementById('" + txtAreaFin.ClientID + "').focus()", true);
    }

    protected void txtColoniaFin_TextChanged(object sender, EventArgs e)
    {
        Entity_Colonia obj;
        obj = new Entity_Colonia();
        Colonia col;
        col = new Colonia();

        obj.intColonia = txtColoniaFin.Text == "" ? 0 : Convert.ToInt32(txtColoniaFin.Text);

        obj = col.Fill(obj);

        if (obj != null)
        {
            txtColoniaFin.Text = txtColonia.Text;
            txtColoniaNombreFin.Text = txtColoniaNombre.Text;
        }
        else
        {
            txtColoniaFin.Text = "";
            txtColoniaNombreFin.Text = "";
        }

        txtColoniaFin.UpdateAfterCallBack = true;
        txtColoniaNombreFin.UpdateAfterCallBack = true;
    }



    #region lknBalanzaElect_Click
    protected void lknBalanzaElect_Click(object sender, EventArgs e)
    {
        //if (!chkFecha.Checked)
        //{
            string[] arrDatos;
            String strParameters = "";
            Entity_Conciliaciones obj;
            obj = new Entity_Conciliaciones();

            obj.IntEmpresa = Convert.ToInt32(txtEmpresa.Text);
            obj.IntEjercicio = Convert.ToInt32(cboYear.SelectedValue);
            obj.IntMes = Convert.ToInt32(cboMonth.SelectedValue);
            obj.IntFolio = Convert.ToInt32(cboNivel.SelectedValue);
            obj.StrObraInicial = txtClave.Text == "" ? "0" : txtClave.Text;
            obj.StrObraFinal = txtClaveFin.Text == "" ? "0" : txtClaveFin.Text;
            obj.StrFechaInicial = txtCuenta.Text == "" ? "0" : txtCuenta.Text;
            obj.StrFechaFinal = txtCuentaFin.Text == "" ? "0" : txtCuentaFin.Text;
            obj.IntProveedorInicial = txtArea.Text == "" ? 0 : Convert.ToInt32(txtArea.Text);
            obj.IntProveedorFinal = txtAreaFin.Text == "" ? 0 : Convert.ToInt32(txtAreaFin.Text);
            obj.IntParametroInicial = txtColonia.Text == "" ? 0 : Convert.ToInt32(txtColonia.Text);
            obj.IntParametroFinal = txtColoniaFin.Text == "" ? 0 : Convert.ToInt32(txtColoniaFin.Text);
            obj.StrInsumoInicial = "0";
            obj.StrInsumoFinal = "0";
            obj.StrMaquina = chkFechaPrint.Checked == false ? "0" : txtFechaPrint.Text;

            if (!toolbar.Check())
            {
                arrDatos = new string[15];
                arrDatos[0] = obj.IntEmpresa.ToString();
                arrDatos[1] = obj.IntEjercicio.ToString();
                arrDatos[2] = obj.IntMes.ToString();
                arrDatos[3] = obj.IntFolio.ToString();
                arrDatos[4] = obj.StrFechaInicial.ToString();
                arrDatos[5] = obj.StrFechaFinal.ToString();
                arrDatos[6] = obj.StrObraInicial.ToString();
                arrDatos[7] = obj.StrObraFinal.ToString();
                arrDatos[8] = obj.IntProveedorInicial.ToString();
                arrDatos[9] = obj.IntProveedorFinal.ToString();
                arrDatos[10] = obj.IntParametroInicial.ToString();
                arrDatos[11] = obj.IntParametroFinal.ToString();
                arrDatos[12] = obj.StrInsumoInicial.ToString();
                arrDatos[13] = obj.StrInsumoFinal.ToString();
                arrDatos[14] = obj.StrMaquina.ToString();

                strParameters = String.Format("{0}[--]{1}[--]{2}[--]{3}[--]{4}[--]{5}[--]{6}[--]{7}[--]{8}[--]{9}[--]{10}[--]{11}[--]{12}[--]{13}[--]{14}", arrDatos);

                string strServerName = "http://" + HttpContext.Current.Request.ServerVariables["SERVER_NAME"].ToString() + ":" + HttpContext.Current.Request.ServerVariables["SERVER_PORT"].ToString() + "/Contabilidad/Utils/CRViewer.aspx";
                string strQueryString = string.Empty;
                strQueryString = "?type=pdf";
                strQueryString += "&report=Pages/Reportes/Balanza/BalanzaElect.rpt";
                strQueryString += "&db=VetecMarfilAdmin";
                strQueryString += "&parameters=" + strParameters;

                strQueryString = strQueryString.Replace("'", "|");
                Anthem.Manager.RegisterStartupScript(Page.GetType(), "rpt", "window.open('" + strServerName + strQueryString + "');", true);
            }
            else
            {
                PolizasDet pol;
                pol = new PolizasDet();

                string query;

                query = pol.ExportBalanza_Elec(obj);

                obj = null;
                pol = null;

                string queryString = "?query=" + query + "&type=xls&tabla=1";
                Response.Redirect("../../../Utils/Excel.aspx" + queryString);
            }
        //}
        //else
        //{
        //    string[] arrDatos2;
        //    String strParameters = "";
        //    Entity_Conciliaciones obj;
        //    obj = new Entity_Conciliaciones();

        //    obj.IntEmpresa = Convert.ToInt32(txtEmpresa.Text);
        //    obj.StrFechaInicial = txtFechaInicial.Text;
        //    obj.StrFechaFinal = txtFechaFinal.Text;
        //    obj.IntFolio = Convert.ToInt32(cboNivel.SelectedValue);
        //    obj.StrObraInicial = txtClave.Text == "" ? "0" : txtClave.Text;
        //    obj.StrObraFinal = txtClaveFin.Text == "" ? "0" : txtClaveFin.Text;
        //    obj.StrPoliza = txtCuenta.Text == "" ? "0" : txtCuenta.Text;
        //    obj.StrReferencia = txtCuentaFin.Text == "" ? "0" : txtCuentaFin.Text;
        //    obj.IntProveedorInicial = txtArea.Text == "" ? 0 : Convert.ToInt32(txtArea.Text);
        //    obj.IntProveedorFinal = txtAreaFin.Text == "" ? 0 : Convert.ToInt32(txtAreaFin.Text);
        //    obj.IntParametroInicial = txtColonia.Text == "" ? 0 : Convert.ToInt32(txtColonia.Text);
        //    obj.IntParametroFinal = txtColoniaFin.Text == "" ? 0 : Convert.ToInt32(txtColoniaFin.Text);
        //    obj.StrInsumoInicial = "0";
        //    obj.StrInsumoFinal = "0";

        //    arrDatos2 = new string[14];

        //    arrDatos2[0] = obj.IntEmpresa.ToString();
        //    arrDatos2[1] = obj.StrFechaInicial.ToString();
        //    arrDatos2[2] = obj.StrFechaFinal.ToString();
        //    arrDatos2[3] = obj.IntFolio.ToString();
        //    arrDatos2[4] = obj.StrPoliza.ToString();
        //    arrDatos2[5] = obj.StrReferencia.ToString();
        //    arrDatos2[6] = obj.StrObraInicial.ToString();
        //    arrDatos2[7] = obj.StrObraFinal.ToString();
        //    arrDatos2[8] = obj.IntProveedorInicial.ToString();
        //    arrDatos2[9] = obj.IntProveedorFinal.ToString();
        //    arrDatos2[10] = obj.IntParametroInicial.ToString();
        //    arrDatos2[11] = obj.IntParametroFinal.ToString();
        //    arrDatos2[12] = obj.StrInsumoInicial.ToString();
        //    arrDatos2[13] = obj.StrInsumoFinal.ToString();

        //    if (!toolbar.Check())
        //    {
        //        strParameters = String.Format("{0}[--]{1}[--]{2}[--]{3}[--]{4}[--]{5}[--]{6}[--]{7}[--]{8}[--]{9}[--]{10}[--]{11}[--]{12}[--]{13}", arrDatos2);

        //        string strServerName = "http://" + HttpContext.Current.Request.ServerVariables["SERVER_NAME"].ToString() + ":" + HttpContext.Current.Request.ServerVariables["SERVER_PORT"].ToString() + "/Contabilidad/Utils/CRViewer.aspx";
        //        string strQueryString = string.Empty;
        //        strQueryString = "?type=pdf";
        //        strQueryString += "&report=Pages/Reportes/Balanza/BalanzaRango.rpt";
        //        strQueryString += "&db=VetecMarfilAdmin";
        //        strQueryString += "&parameters=" + strParameters;

        //        strQueryString = strQueryString.Replace("'", "|");
        //        Anthem.Manager.RegisterStartupScript(Page.GetType(), "rpt", "window.open('" + strServerName + strQueryString + "');", true);
        //    }
        //    else
        //    {
        //        PolizasDet pol;
        //        pol = new PolizasDet();

        //        string query;

        //        query = sqlQuery("VetecMarfilAdmin..usp_tbPolizasDet_BalanzaRango ", arrDatos2);

        //        obj = null;
        //        pol = null;

        //        string queryString = "?query=" + query + "&type=xls&tabla=1";
        //        Response.Redirect("../../../Utils/Excel.aspx" + queryString);
        //    }
        //}
    }
    #endregion


}


