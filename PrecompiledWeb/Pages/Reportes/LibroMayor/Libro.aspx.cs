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

public partial class Contabilidad_Reportes_Libro : System.Web.UI.Page
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
        }
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
    
    #region lknLibroMayor_Click
    protected void lknLibroMayor_Click(object sender, EventArgs e)
    {
        string[] arrDatos;
        String strParameters = "";
        Entity_PolizasDet obj; 
        obj = new Entity_PolizasDet();

        arrDatos = new string[14];
        arrDatos[0] = txtEmpresa.Text; 
        arrDatos[1] = cboYear.SelectedValue; 
        arrDatos[2] = cboNivel.SelectedValue; 
        arrDatos[3] = txtCuenta.Text == "" ? "0" : txtCuenta.Text;
        arrDatos[4] = txtCuentaFin.Text == "" ? "0" : txtCuentaFin.Text;
        arrDatos[5] = "0";
        arrDatos[6] = "0";
        arrDatos[7] = "0";
        arrDatos[8] = "0";
        arrDatos[9] = "0";
        arrDatos[10] = "0";
        arrDatos[11] = "0";
        arrDatos[12] = "0";
        arrDatos[13] = "0";
      
        if (!toolbar.Check())
        {           
            strParameters = String.Format("{0}[--]{1}[--]{2}[--]{3}[--]{4}[--]{5}[--]{6}[--]{7}[--]{8}[--]{9}[--]{10}[--]{11}[--]{12}[--]{13}", arrDatos);

            string strServerName = "http://" + HttpContext.Current.Request.ServerVariables["SERVER_NAME"].ToString() + ":" + HttpContext.Current.Request.ServerVariables["SERVER_PORT"].ToString() + "/Contabilidad/Utils/CRViewer.aspx";
            string strQueryString = string.Empty;
            strQueryString = "?type=pdf";
            strQueryString += "&report=Pages/Reportes/LibroMayor/LibroMayor.rpt";
            strQueryString += "&db=VetecMarfilAdmin";
            strQueryString += "&parameters=" + strParameters;

            strQueryString = strQueryString.Replace("'", "|");
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "rpt", "window.open('" + strServerName + strQueryString + "');", true);
        }
        else
        {
            string query;

            query = sqlQuery("vetecmarfiladmin..usp_LibroMayorContabilidad_Reporte ",arrDatos);

            string queryString = "?query=" + query + "&type=xls";
            Response.Redirect("../../../Utils/Excel.aspx" + queryString);
        }
    }
    #endregion  

    #region lknLibroMayorObra_Click
    protected void lknLibroMayorObra_Click(object sender, EventArgs e)
    {
        string[] arrDatos;
        String strParameters = "";
        Entity_PolizasDet obj; 
        obj = new Entity_PolizasDet();

        arrDatos = new string[14];
        arrDatos[0] = txtEmpresa.Text; ;
        arrDatos[1] = cboYear.SelectedValue; ;
        arrDatos[2] = cboNivel.SelectedValue; ;
        arrDatos[3] = txtCuenta.Text == "" ? "0" : txtCuenta.Text;
        arrDatos[4] = txtCuentaFin.Text == "" ? "0" : txtCuentaFin.Text;
        arrDatos[5] = "0";
        arrDatos[6] = "0";
        arrDatos[7] = "0";
        arrDatos[8] = "0";
        arrDatos[9] = "0";
        arrDatos[10] = "0";
        arrDatos[11] = "0";
        arrDatos[12] = "0";
        arrDatos[13] = "0";
      
        if (!toolbar.Check())
        {           
            strParameters = String.Format("{0}[--]{1}[--]{2}[--]{3}[--]{4}[--]{5}[--]{6}[--]{7}[--]{8}[--]{9}[--]{10}[--]{11}[--]{12}[--]{13}", arrDatos);

            string strServerName = "http://" + HttpContext.Current.Request.ServerVariables["SERVER_NAME"].ToString() + ":" + HttpContext.Current.Request.ServerVariables["SERVER_PORT"].ToString() + "/Contabilidad/Utils/CRViewer.aspx";
            string strQueryString = string.Empty;
            strQueryString = "?type=pdf";
            strQueryString += "&report=Pages/Reportes/LibroMayor/LibroMayorObra.rpt";
            strQueryString += "&db=VetecMarfilAdmin";
            strQueryString += "&parameters=" + strParameters;

            strQueryString = strQueryString.Replace("'", "|");
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "rpt", "window.open('" + strServerName + strQueryString + "');", true);
        }
        else
        {
            string query;

            query = sqlQuery("vetecmarfiladmin..usp_LibroMayorContabilidad_Reporte_Obra ", arrDatos);

            string queryString = "?query=" + query + "&type=xls";
            Response.Redirect("../../../Utils/Excel.aspx" + queryString);
        }
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

            if (CuentaByKey != null)
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
            }

            txtCuenta.UpdateAfterCallBack = true;
            txtNombreCuenta.UpdateAfterCallBack = true;
            txtCuentaFin.UpdateAfterCallBack = true;
            txtNombreCuentaFin.UpdateAfterCallBack = true;

            Anthem.Manager.RegisterStartupScript(Page.GetType(), "focusCF", "document.all('ctl00_CPHBase_txtCuentaFin').focus()", true);

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

            if (CuentaByKey != null)
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

            Anthem.Manager.RegisterStartupScript(Page.GetType(), "focusCF", "document.all('ctl00_CPHBase_txtCuentaFin').focus()", true);

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

        return query + par.Substring(0,par.Length - 1);
    }
    #endregion

}


