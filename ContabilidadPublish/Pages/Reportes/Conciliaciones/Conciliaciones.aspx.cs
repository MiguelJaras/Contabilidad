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

public partial class Contabilidad_Reportes_Concil : System.Web.UI.Page
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
            txtEmpresa.Text = Contabilidad.SEMSession.GetInstance.IntEmpresa.ToString();
            txtEmpresa_TextChange(null, null);
            cboYear.SelectedValue = DateTime.Now.Year.ToString();
            cboMonth.SelectedValue = DateTime.Now.Month.ToString();
            
            JavaScript();

            lknMovimientosConcilidos.Attributes.Add("onClick", "return Valida()");
        }
    }

    #region JavaScript
    private void JavaScript()
    {
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtEmpresa", "var objText = new VetecText('" + txtEmpresa.ClientID + "', 'number', 4);", true);
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtCtaBanc", "var objText = new VetecText('" + txtCtaBanc.ClientID + "', 'number', 4);", true);

        if (!IsPostBack && !IsCallback)
        {
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "focus", "document.all('ctl00_CPHFilters_txtEmpresa').focus()", true);
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

        txtCtaBanc.Text = "";
        txtCtaBancDes.Text = "";

        txtEmpresa.Text = obj.IntEmpresa.ToString();
        txtNombreEmpresa.Text = obj.StrNombre;
        hddSucursal.Value = emp.GetSucursal(obj.IntEmpresa.ToString());

        hddSucursal.UpdateAfterCallBack = true;
        txtEmpresa.UpdateAfterCallBack = true;
        txtNombreEmpresa.UpdateAfterCallBack = true;
        txtCtaBanc.UpdateAfterCallBack = true;
        txtCtaBancDes.UpdateAfterCallBack = true; ;

        obj = null;
        emp = null;
    }
    #endregion  
    
    #region txtCtaBanc_TextChange
    protected void txtCtaBanc_TextChange(object sender, EventArgs e)
    {
        CuentasBancarias cuentas;
        cuentas = new CuentasBancarias();

        Entity_CuentasBancarias obj;
        obj = new Entity_CuentasBancarias();

        obj.IntEmpresa = txtEmpresa.Text == "" ? Contabilidad.SEMSession.GetInstance.IntEmpresa : Convert.ToInt32(txtEmpresa.Text);
        obj.intCuentaBancaria = txtCtaBanc.Text == "" ? 0 : Convert.ToInt32(txtCtaBanc.Text);

        obj = cuentas.Fill(obj);

        if (!(obj == null))
        {
            if (txtCtaBanc.Text != "")
            {
                if (obj.strNombre != null)
                {
                    txtCtaBancDes.Text = obj.strNombre.ToString();

                }
                else
                {
                    txtCtaBanc.Text = "";
                    txtCtaBancDes.Text = "";
                }
            }
            else
            {
                txtCtaBanc.Text = "";
                txtCtaBancDes.Text = "";
            }
        }
        else
        {
            txtCtaBanc.Text = "";
            //Anthem.Manager.RegisterStartupScript(Page.GetType(), "CtaBancFocus", "document.getElementById('" + txtCuenta.ClientID + "').focus();", true);
        }
        txtCtaBanc.UpdateAfterCallBack = true;
        txtCtaBancDes.UpdateAfterCallBack = true;

        cuentas = null;
        obj = null;
    }
    #endregion

    #region lknConciliados_Click
    protected void lknConciliados_Click(object sender, EventArgs e)
    {
        string[] arrDatos;
        String strParameters = "";
        Entity_Conciliaciones obj;
        obj = new Entity_Conciliaciones();

        obj.IntEmpresa = Convert.ToInt32(txtEmpresa.Text);
        obj.IntEjercicio = Convert.ToInt32(cboYear.SelectedValue);
        obj.IntMes = Convert.ToInt32(cboMonth.SelectedValue);
        obj.intCuentaBancaria = txtCtaBanc.Text == "" ? 0 : Convert.ToInt32(txtCtaBanc.Text);     

        if (!toolbar.Check())
        {           
            arrDatos = new string[4];
            arrDatos[0] = obj.IntEmpresa.ToString();
            arrDatos[1] = obj.intCuentaBancaria.ToString();
            arrDatos[2] = obj.IntMes.ToString();
            arrDatos[3] = obj.IntEjercicio.ToString();

            strParameters = String.Format("{0}[--]{1}[--]{2}[--]{3}", arrDatos);

            string strServerName = "http://" + HttpContext.Current.Request.ServerVariables["SERVER_NAME"].ToString() + ":" + HttpContext.Current.Request.ServerVariables["SERVER_PORT"].ToString() + "/Contabilidad/Utils/CRViewer.aspx";
            string strQueryString = string.Empty;
            strQueryString = "?type=pdf";
            strQueryString += "&report=Pages/Reportes/Conciliaciones/Conciliaciones.rpt";
            strQueryString += "&db=VetecMarfil";
            strQueryString += "&parameters=" + strParameters;

            strQueryString = strQueryString.Replace("'", "|");
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "rpt", "window.open('" + strServerName + strQueryString + "');", true);
        }
        else
        {
            Conciliaciones con;
            con = new Conciliaciones();
            
            string query;

            query = con.MovimientosConciliados(obj);

            obj = null;
            con = null;

            string queryString = "?query=" + query + "&type=xls";
            Response.Redirect("../../../Utils/Excel.aspx" + queryString);
        }
    }
    #endregion

    #region lknConciliacion_Click
    protected void lknConciliacion_Click(object sender, EventArgs e)
    {
        string[] arrDatos;
        String strParameters = "";
        Entity_Conciliaciones obj;
        obj = new Entity_Conciliaciones();

        obj.IntEmpresa = Convert.ToInt32(txtEmpresa.Text);
        obj.IntEjercicio = Convert.ToInt32(cboYear.SelectedValue);
        obj.IntMes = Convert.ToInt32(cboMonth.SelectedValue);
        obj.intCuentaBancaria = txtCtaBanc.Text == "" ? 0 : Convert.ToInt32(txtCtaBanc.Text);     

        if (!toolbar.Check())
        {
            arrDatos = new string[4];
            arrDatos[0] = obj.IntEmpresa.ToString();
            arrDatos[1] = obj.intCuentaBancaria.ToString();
            arrDatos[2] = obj.IntMes.ToString();
            arrDatos[3] = obj.IntEjercicio.ToString();

            strParameters = String.Format("{0}[--]{1}[--]{2}[--]{3}", arrDatos);

            string strServerName = "http://" + HttpContext.Current.Request.ServerVariables["SERVER_NAME"].ToString() + ":" + HttpContext.Current.Request.ServerVariables["SERVER_PORT"].ToString() + "/Contabilidad/Utils/CRViewer.aspx";
            string strQueryString = string.Empty;
            strQueryString = "?type=pdf";
            strQueryString += "&report=Pages/Reportes/Conciliaciones/Conciliacion_Bancaria_Transito.rpt";
            strQueryString += "&db=VetecMarfil";
            strQueryString += "&parameters=" + strParameters;

            strQueryString = strQueryString.Replace("'", "|");
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "rpt", "window.open('" + strServerName + strQueryString + "');", true);
        }
        else
        {
            Conciliaciones con;
            con = new Conciliaciones();

            string query;

            query = con.ConciliacionBancaria(obj);

            obj = null;
            con = null;

            string queryString = "?query=" + query + "&type=xls";
            Response.Redirect("../../../Utils/Excel.aspx" + queryString);
        }
    }
    #endregion

    #region lknTransitoChequera_Click
    protected void lknTransitoChequera_Click(object sender, EventArgs e)
    {
        string[] arrDatos;
        String strParameters = "";
        Entity_Conciliaciones obj;
        obj = new Entity_Conciliaciones();

        obj.IntEmpresa = Convert.ToInt32(txtEmpresa.Text);
        obj.IntEjercicio = Convert.ToInt32(cboYear.SelectedValue);
        obj.IntMes = Convert.ToInt32(cboMonth.SelectedValue);
        obj.intCuentaBancaria = txtCtaBanc.Text == "" ? 0 : Convert.ToInt32(txtCtaBanc.Text);

        if (!toolbar.Check())
        {
            arrDatos = new string[5];
            arrDatos[0] = obj.IntEmpresa.ToString();
            arrDatos[1] = obj.intCuentaBancaria.ToString();
            arrDatos[2] = obj.IntMes.ToString();
            arrDatos[3] = obj.IntEjercicio.ToString();
            arrDatos[4] = "1";
            strParameters = String.Format("{0}[--]{1}[--]{2}[--]{3}[--]{4}", arrDatos);

            string strServerName = "http://" + HttpContext.Current.Request.ServerVariables["SERVER_NAME"].ToString() + ":" + HttpContext.Current.Request.ServerVariables["SERVER_PORT"].ToString() + "/Contabilidad/Utils/CRViewer.aspx";
            string strQueryString = string.Empty;
            strQueryString = "?type=pdf";
            strQueryString += "&report=Pages/Reportes/Conciliaciones/ReporteConciliacion.rpt";
            strQueryString += "&db=VetecMarfil";
            strQueryString += "&parameters=" + strParameters;

            strQueryString = strQueryString.Replace("'", "|");
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "rpt", "window.open('" + strServerName + strQueryString + "');", true);
        }
        else
        {
            Conciliaciones con;
            con = new Conciliaciones();

            string query;

            query = con.TransitoChequera(obj);

            obj = null;
            con = null;

            string queryString = "?query=" + query + "&type=xls";
            Response.Redirect("../../../Utils/Excel.aspx" + queryString);
        }
    }
    #endregion

    #region lknTransitoBancario_Click
    protected void lknTransitoBancario_Click(object sender, EventArgs e)
    {
        string[] arrDatos;
        String strParameters = "";
        Entity_Conciliaciones obj;
        obj = new Entity_Conciliaciones();

        obj.IntEmpresa = Convert.ToInt32(txtEmpresa.Text);
        obj.IntEjercicio = Convert.ToInt32(cboYear.SelectedValue);
        obj.IntMes = Convert.ToInt32(cboMonth.SelectedValue);
        obj.intCuentaBancaria = txtCtaBanc.Text == "" ? 0 : Convert.ToInt32(txtCtaBanc.Text);

        if (!toolbar.Check())
        {
            arrDatos = new string[5];
            arrDatos[0] = obj.IntEmpresa.ToString();
            arrDatos[1] = obj.intCuentaBancaria.ToString();
            arrDatos[2] = obj.IntMes.ToString();
            arrDatos[3] = obj.IntEjercicio.ToString();
            arrDatos[4] = "0";
            strParameters = String.Format("{0}[--]{1}[--]{2}[--]{3}[--]{4}", arrDatos);

            string strServerName = "http://" + HttpContext.Current.Request.ServerVariables["SERVER_NAME"].ToString() + ":" + HttpContext.Current.Request.ServerVariables["SERVER_PORT"].ToString() + "/Contabilidad/Utils/CRViewer.aspx";
            string strQueryString = string.Empty;
            strQueryString = "?type=pdf";
            strQueryString += "&report=Pages/Reportes/Conciliaciones/ReporteConciliacion.rpt";
            strQueryString += "&db=VetecMarfil";
            strQueryString += "&parameters=" + strParameters;

            strQueryString = strQueryString.Replace("'", "|");
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "rpt", "window.open('" + strServerName + strQueryString + "');", true);
        }
        else
        {
            Conciliaciones con;
            con = new Conciliaciones();

            string query;

            query = con.TransitoChequera(obj);

            obj = null;
            con = null;

            string queryString = "?query=" + query + "&type=xls";
            Response.Redirect("../../../Utils/Excel.aspx" + queryString);
        }
    }
    #endregion

    #region lknCash_Click
    protected void lknCash_Click(object sender, EventArgs e)
    {
        string[] arrDatos;
        String strParameters = "";
        Entity_Conciliaciones obj;
        obj = new Entity_Conciliaciones();

        obj.IntEmpresa = Convert.ToInt32(txtEmpresa.Text);
        obj.IntEjercicio = Convert.ToInt32(cboYear.SelectedValue);
        obj.IntMes = Convert.ToInt32(cboMonth.SelectedValue);
        obj.intCuentaBancaria = txtCtaBanc.Text == "" ? 0 : Convert.ToInt32(txtCtaBanc.Text);

        arrDatos = new string[4];
        arrDatos[0] = obj.IntEmpresa.ToString();
        arrDatos[1] = obj.IntEjercicio.ToString();
        arrDatos[2] = obj.intCuentaBancaria.ToString(); 
        arrDatos[3] = obj.IntMes.ToString(); 

        if (!toolbar.Check())
        {            
            strParameters = String.Format("{0}[--]{1}[--]{2}[--]{3}", arrDatos);
            string strServerName = "http://" + HttpContext.Current.Request.ServerVariables["SERVER_NAME"].ToString() + ":" + HttpContext.Current.Request.ServerVariables["SERVER_PORT"].ToString() + "/Contabilidad/Utils/CRViewer.aspx";
            string strQueryString = string.Empty;
            strQueryString = "?type=pdf";
            strQueryString += "&report=Pages/Reportes/Conciliaciones/RptCash.rpt";
            strQueryString += "&db=VetecMarfilAdmin";
            strQueryString += "&parameters=" + strParameters;

            strQueryString = strQueryString.Replace("'", "|");
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "rpt", "window.open('" + strServerName + strQueryString + "');", true);
        }
        else
        {
            string query;

            query = sqlQuery("VetecMarfilAdmin..usp_tbTempConciliacion_Rpt ", arrDatos);

            string queryString = "?query=" + query + "&type=xls&tabla=1";
            Response.Redirect("../../../Utils/Excel.aspx" + queryString);
        }

        obj = null;
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

}
