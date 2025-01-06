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

public partial class Contabilidad_Compra_Reportes_Iva : System.Web.UI.Page
{
    Report_Pages_Base toolbar;
    public string realPath;

    protected void Page_Load(object sender, EventArgs e)
    {
        toolbar = (Report_Pages_Base)this.Master;

        if (!IsPostBack)
        {
            btnExpandReportes.Attributes.Add("onClick", "ReportVisible(this,'" + pnlReportes1.ClientID + "');");
            Year();
            Month();
            txtEmpresa.Text = Contabilidad.SEMSession.GetInstance.IntEmpresa.ToString();
            txtEmpresa_TextChange(null, null);

            cboMonth.SelectedValue = DateTime.Now.Month.ToString();
            cboYear.SelectedValue = DateTime.Now.Year.ToString();
        }
        Anthem.Manager.Register(this);
        JavaScript();
    }

    #region JavaScript
    private void JavaScript()
    {
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtEmpresa", "var objText = new VetecText('" + txtEmpresa.ClientID + "', 'number', 12);", true);
        //Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtCtaBanc", "var objText = new VetecText('" + txtCtaBanc.ClientID + "', 'number', 12);", true);
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
        txtCtaBanc.Text = "";
        txtCtaBancDes.Text = "";

        cboMonth.UpdateAfterCallBack = true;
        cboYear.UpdateAfterCallBack = true;
        txtCtaBanc.UpdateAfterCallBack = true;
        txtCtaBancDes.UpdateAfterCallBack = true;
    }
    #endregion

    protected void txtCta_TextChanged(object sender, EventArgs e)
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

    protected void lknDesglosado_Click(object sender, EventArgs e)
    {
        string[] arrDatos;
        string strParameters = "";

        int intEmpresa = txtEmpresa.Text == "" ? Contabilidad.SEMSession.GetInstance.IntEmpresa : Convert.ToInt32(txtEmpresa.Text);
        int intCuentaBancaria = txtCtaBanc.Text == "" ? 0 : Convert.ToInt32(txtCtaBanc.Text);
        string intMes = cboMonth.SelectedValue;
        string intEjercicio = cboYear.SelectedValue;

        if (!toolbar.Check())
        {
            arrDatos = new string[4];
            arrDatos[0] = intEmpresa.ToString ();
            arrDatos[1] = intMes;
            arrDatos[2] = intEjercicio;
            arrDatos[3] = intCuentaBancaria.ToString ();

            strParameters = String.Format("{0}[--]{1}[--]{2}[--]{3}", arrDatos);

            string strServerName = "http://" + HttpContext.Current.Request.ServerVariables["SERVER_NAME"].ToString() + ":" + HttpContext.Current.Request.ServerVariables["SERVER_PORT"].ToString() + "/Contabilidad/Utils/CRViewer.aspx";
            string strQueryString = string.Empty;
            strQueryString = "?type=pdf";
            strQueryString += "&report=Pages/Reportes/IVA/IVA Analitico.rpt";
            strQueryString += "&db=VetecMarfil";
            strQueryString += "&parameters=" + strParameters;
            strQueryString += "&Titulos=IVA";

            strQueryString = strQueryString.Replace("'", "|");
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "rpt", "window.open('" + strServerName + strQueryString + "');", true);
        }
        else
        {
            Iva iva;
            iva = new Iva();

            string query;
            query = iva.IvaDesglosado(intCuentaBancaria, intMes, intEjercicio, intEmpresa);

            iva = null;

            string queryString = "?query=" + query + "&type=xls&tabla=1";
            Response.Redirect("../../../Utils/Excel.aspx" + queryString);

        }
    }

    protected void lknAnalitico_Click(object sender, EventArgs e)
    {
        string[] arrDatos;
        string strParameters = "";

        int intEmpresa = txtEmpresa.Text == "" ? Contabilidad.SEMSession.GetInstance.IntEmpresa : Convert.ToInt32(txtEmpresa.Text);
        int intCuentaBancaria = txtCtaBanc.Text == "" ? 0 : Convert.ToInt32(txtCtaBanc.Text);
        string intMes = cboMonth.SelectedValue;
        string intEjercicio = cboYear.SelectedValue;

        if (!toolbar.Check())
        {
            arrDatos = new string[4];
            arrDatos[0] = intEmpresa.ToString();
            arrDatos[1] = intMes;
            arrDatos[2] = intEjercicio;
            arrDatos[3] = intCuentaBancaria.ToString();

            strParameters = String.Format("{0}[--]{1}[--]{2}[--]{3}", arrDatos);

            string strServerName = "http://" + HttpContext.Current.Request.ServerVariables["SERVER_NAME"].ToString() + ":" + HttpContext.Current.Request.ServerVariables["SERVER_PORT"].ToString() + "/Contabilidad/Utils/CRViewer.aspx";
            string strQueryString = string.Empty;
            strQueryString = "?type=pdf";
            strQueryString += "&report=Pages/Reportes/IVA/IVA por Acreditar.rpt";
            strQueryString += "&db=VetecMarfil";
            strQueryString += "&parameters=" + strParameters;
            strQueryString += "&Titulos=IVA";

            strQueryString = strQueryString.Replace("'", "|");
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "rpt", "window.open('" + strServerName + strQueryString + "');", true);
        }
        else
        {
            Iva iva;
            iva = new Iva();

            string query;
            query = iva.IvaAcreditar(intCuentaBancaria, intMes, intEjercicio, intEmpresa);

            iva = null;

            string queryString = "?query=" + query + "&type=xls&tabla=1";
            Response.Redirect("../../../Utils/Excel.aspx" + queryString);
        }

    }

    protected void lknAnalitico2_Click(object sender, EventArgs e)
    {
        string[] arrDatos;
        string strParameters = "";

        int intEmpresa = txtEmpresa.Text == "" ? Contabilidad.SEMSession.GetInstance.IntEmpresa : Convert.ToInt32(txtEmpresa.Text);
        int intCuentaBancaria = txtCtaBanc.Text == "" ? 0 : Convert.ToInt32(txtCtaBanc.Text);
        string intMes = cboMonth.SelectedValue;
        string intEjercicio = cboYear.SelectedValue;

        if (!toolbar.Check())
        {
            arrDatos = new string[4];
            arrDatos[0] = intEmpresa.ToString();
            arrDatos[1] = intMes;
            arrDatos[2] = intEjercicio;
            arrDatos[3] = intCuentaBancaria.ToString();

            strParameters = String.Format("{0}[--]{1}[--]{2}[--]{3}", arrDatos);

            string strServerName = "http://" + HttpContext.Current.Request.ServerVariables["SERVER_NAME"].ToString() + ":" + HttpContext.Current.Request.ServerVariables["SERVER_PORT"].ToString() + "/Contabilidad/Utils/CRViewer.aspx";
            string strQueryString = string.Empty;
            strQueryString = "?type=pdf";
            strQueryString += "&report=Pages/Reportes/IVA/IVA por Acreditar 2.rpt";
            strQueryString += "&db=VetecMarfil";
            strQueryString += "&parameters=" + strParameters;
            strQueryString += "&Titulos=IVA";

            strQueryString = strQueryString.Replace("'", "|");
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "rpt", "window.open('" + strServerName + strQueryString + "');", true);
        }
        else
        {
            Iva iva;
            iva = new Iva();

            string query;
            query = iva.IvaNoAcreditar(intCuentaBancaria, intMes, intEjercicio, intEmpresa);

            iva = null;

            string queryString = "?query=" + query + "&type=xls&tabla=1";
            Response.Redirect("../../../Utils/Excel.aspx" + queryString);
        }

    }

    protected void lknIvaAnalitico_Click(object sender, EventArgs e)
    {
        string[] arrDatos;
        string strParameters = "";

        int intEmpresa = txtEmpresa.Text == "" ? Contabilidad.SEMSession.GetInstance.IntEmpresa : Convert.ToInt32(txtEmpresa.Text);
        string intMes = cboMonth.SelectedValue;
        string intEjercicio = cboYear.SelectedValue;

        if (!toolbar.Check())
        {
            arrDatos = new string[4];
            arrDatos[0] = intEmpresa.ToString();
            arrDatos[1] = intEjercicio;
            arrDatos[2] = intMes;

            strParameters = String.Format("{0}[--]{1}[--]{2}", arrDatos);

            string strServerName = "http://" + HttpContext.Current.Request.ServerVariables["SERVER_NAME"].ToString() + ":" + HttpContext.Current.Request.ServerVariables["SERVER_PORT"].ToString() + "/Contabilidad/Utils/CRViewer.aspx";
            string strQueryString = string.Empty;
            strQueryString = "?type=pdf";
            strQueryString += "&report=Pages/Reportes/IVA/IvaDesglosado.rpt";
            strQueryString += "&db=VetecMarfilAdmin";
            strQueryString += "&parameters=" + strParameters;
            strQueryString += "&Titulos=IVA";

            strQueryString = strQueryString.Replace("'", "|");
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "rpt", "window.open('" + strServerName + strQueryString + "');", true);
        }
        else
        {
            Iva iva;
            iva = new Iva();

            string query;
            query = iva.IvaAnalitico(intMes, intEjercicio, intEmpresa);

            iva = null;

            string queryString = "?query=" + query + "&type=xls&tabla=1";
            Response.Redirect("../../../Utils/Excel.aspx" + queryString);
        }

    }
}
