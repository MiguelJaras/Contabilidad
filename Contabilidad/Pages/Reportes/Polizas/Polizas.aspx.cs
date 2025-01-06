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

public partial class Contabilidad_Compra_Reportes_Polizas : System.Web.UI.Page
{
    Report_Pages_Base toolbar;
    public string realPath;

    protected void Page_Load(object sender, EventArgs e)
    {
        toolbar = (Report_Pages_Base)this.Master;
        //Anthem.Manager.Register(this);
        if (!IsPostBack)
        {
            btnExpandReportes.Attributes.Add("onClick", "ReportVisible(this,'" + pnlReportes1.ClientID + "');");
            Year();
            Month();
            txtEmpresa.Text = Contabilidad.SEMSession.GetInstance.IntEmpresa.ToString();
            txtEmpresa_TextChange(null, null);

            string mes = DateTime.Now.Month < 10 ? "0" + DateTime.Now.Month.ToString() : DateTime.Now.Month.ToString();
            cboMonth.SelectedValue = DateTime.Now.Month.ToString();
            cboYear.SelectedValue = DateTime.Now.Year.ToString();
            txtFechaPrint.Text = "01/" + mes + "/" + DateTime.Now.Year.ToString();
            chkAfec.Checked = true;
            chkCancel.Checked = true;
            chkNoAfec.Checked = true;

            TipoPolizas();
        }
        Anthem.Manager.Register(this);
        JavaScript();
        RefreshSession();
        btnFechaPrint.OnClientClick = "if(self.gfPop)gfPop.fPopCalendar(document.getElementById('" + txtFechaPrint.ClientID + "')); giDatePos=0; return false;";
    }

    #region JavaScript
    private void JavaScript()
    {
        //Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtEmpresa", "var objText = new VetecText('" + txtEmpresa.ClientID + "', 'number', 12);", true);
        //Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtCtaBanc", "var objText = new VetecText('" + txtCtaBanc.ClientID + "', 'number', 12);", true);
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

        obj = null;
        emp = null;
    }
    #endregion  
    
    #region Clear
    private void Clear()
    {
        cboMonth.SelectedIndex = -1;
        cboYear.SelectedIndex = -1;

        cboMonth.UpdateAfterCallBack = true;
        cboYear.UpdateAfterCallBack = true;
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
        obj.intEjercicio = Convert.ToInt32(cboYear.SelectedValue);

        dt = tp.Sel(obj);

        cboTipoPoliza.DataSource = dt;
        cboTipoPoliza.DataTextField = "strNombreCbo";
        cboTipoPoliza.DataValueField = "strTipoPoliza";
        cboTipoPoliza.DataBind();
        cboTipoPoliza.Items.Insert(0, new ListItem("-- Todos --", "0"));
        cboTipoPoliza.SelectedIndex = 0;
        cboTipoPoliza.UpdateAfterCallBack = true;

        cboTipoPolizaFin.DataSource = dt;
        cboTipoPolizaFin.DataTextField = "strNombreCbo";
        cboTipoPolizaFin.DataValueField = "strTipoPoliza";
        cboTipoPolizaFin.DataBind();
        cboTipoPolizaFin.Items.Insert(0, new ListItem("-- Todos --", "0"));
        cboTipoPolizaFin.SelectedIndex = 0;
        cboTipoPolizaFin.UpdateAfterCallBack = true;

        tp = null;
        obj = null;
    }
    #endregion 

    protected void lknPoliza_Click(object sender, EventArgs e)
    {
        string[] arrDatos;
        string strParameters = "";

        int intEmpresa = txtEmpresa.Text == "" ? Contabilidad.SEMSession.GetInstance.IntEmpresa : Convert.ToInt32(txtEmpresa.Text);
        string intTipoPolIni = cboTipoPoliza.SelectedValue;
        string intTipoPolFin = cboTipoPolizaFin.SelectedValue;
        int intMes = Convert .ToInt32 ( cboMonth.SelectedValue);
        int intEjercicio = Convert.ToInt32 ( cboYear.SelectedValue);
        int PolIni = txtPolIni.Text == "" ? 0 : Convert.ToInt32(txtPolIni.Text);
        int PolFin = txtPolFin.Text == "" ? 0 : Convert.ToInt32(txtPolFin.Text);
        int intAfectada=0;
        int intDesAfectada=0;
        int intCancelada = 0;
        int intTipoImpresion = Convert.ToInt32(rbdTipo.SelectedValue);
        
        if (chkAfec.Checked == true)
            intAfectada = 1;
        if ( chkNoAfec .Checked == true)
            intDesAfectada = 1;
        if ( chkCancel.Checked == true)
            intCancelada = 1;   

        if (!toolbar.Check())
        {
            TiposPoliza tp;
            tp = new TiposPoliza();

            arrDatos = new string[12];
            arrDatos[0] = intEmpresa.ToString();
            arrDatos[1] = intEjercicio.ToString();
            arrDatos[2] = intMes.ToString();
            arrDatos[3] = intTipoPolIni;
            arrDatos[4] = intTipoPolFin;
            arrDatos[5] = PolIni.ToString();
            arrDatos[6] = PolFin.ToString();
            arrDatos[7] = intAfectada.ToString ();
            arrDatos[8] = intDesAfectada.ToString();
            arrDatos[9] = intCancelada.ToString();
            arrDatos[10] = intTipoImpresion.ToString();
            arrDatos[11] = chkFechaPrint.Checked == false ? "0" : txtFechaPrint.Text;

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
        else
        {
            //TiposPoliza tp;
            //tp = new TiposPoliza();

            //string query="";
            //query = tp.RptPolizasDetQry(intEmpresa, intEjercicio, intMes, intTipoPolIni, intTipoPolFin, PolIni, PolFin, intAfectada, intDesAfectada, intCancelada);

            //tp = null;

            //string queryString = "?query=" + query + "&type=xls";
            //Response.Redirect("../../../Utils/Excel.aspx" + queryString);

            TiposPoliza tp;
            tp = new TiposPoliza();

            arrDatos = new string[12];
            arrDatos[0] = intEmpresa.ToString();
            arrDatos[1] = intEjercicio.ToString();
            arrDatos[2] = intMes.ToString();
            arrDatos[3] = intTipoPolIni;
            arrDatos[4] = intTipoPolFin;
            arrDatos[5] = PolIni.ToString();
            arrDatos[6] = PolFin.ToString();
            arrDatos[7] = intAfectada.ToString();
            arrDatos[8] = intDesAfectada.ToString();
            arrDatos[9] = intCancelada.ToString();
            arrDatos[10] = intTipoImpresion.ToString();
            arrDatos[11] = chkFechaPrint.Checked == false ? "0" : txtFechaPrint.Text;

            strParameters = String.Format("{0}[--]{1}[--]{2}[--]{3}[--]{4}[--]{5}[--]{6}[--]{7}[--]{8}[--]{9}[--]{10}[--]{11}", arrDatos);

            string strServerName = "http://" + HttpContext.Current.Request.ServerVariables["SERVER_NAME"].ToString() + ":" + HttpContext.Current.Request.ServerVariables["SERVER_PORT"].ToString() + "/Contabilidad/Utils/CRViewer.aspx";
            string strQueryString = string.Empty;
            strQueryString = "?type=xls";
            strQueryString += "&report=Pages/Reportes/Polizas/Poliza.rpt";
            strQueryString += "&db=VetecMarfilAdmin";
            strQueryString += "&parameters=" + strParameters;
            strQueryString += "&Titulos=Reporte de Pólizas'";

            strQueryString = strQueryString.Replace("'", "|");
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "rpt", "window.open('" + strServerName + strQueryString + "');", true);
        }
    }
}
