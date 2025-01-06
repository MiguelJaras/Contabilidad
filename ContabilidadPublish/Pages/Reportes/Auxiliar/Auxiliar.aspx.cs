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

public partial class Contabilidad_Reportes_Auxiliar : System.Web.UI.Page
{
    Report_Pages_Base toolbar;
    protected void Page_Load(object sender, EventArgs e)
    {
        toolbar = (Report_Pages_Base)this.Master;
        Anthem.Manager.Register(this);
        
        if (!IsPostBack)
        {
            btnExpandReportes.Attributes.Add("onClick", "ReportVisible(this,'" + pnlReportes1.ClientID + "');");
            txtEmpresa.Text = Contabilidad.SEMSession.GetInstance.IntEmpresa.ToString();
            txtEmpresa_TextChange(null, null);
            txtAnio.Text = DateTime.Now.Year.ToString();
            txtAnioFin.Text = DateTime.Now.Year.ToString();
            txtMes.Text = DateTime.Now.Month.ToString();
            txtMesFin.Text = DateTime.Now.Month.ToString();
            JavaScript();     
        }        
    }

    #region JavaScript
    private void JavaScript()
    {
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtEmpresa", "var objText = new VetecText('" + txtEmpresa.ClientID + "', 'number', 4);", true);
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtCuenta", "var objText = new VetecText('" + txtCuenta.ClientID + "', 'number', 4);", true);
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtAnio", "var objText = new VetecText('" + txtAnio.ClientID + "', 'number', 4);", true);
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtAnioFin", "var objText = new VetecText('" + txtAnioFin.ClientID + "', 'number', 4);", true);
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtMes", "var objText = new VetecText('" + txtMes.ClientID + "', 'number', 2);", true);
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtMesFin", "var objText = new VetecText('" + txtMesFin.ClientID + "', 'number', 2);", true);
        
        
        if (!IsPostBack && !IsCallback)
        {
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "focusss", "document.all('ctl00_CPHFilters_txtEmpresa').focus()", true);
        }
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

        obj = null;
        emp = null;
    }
    #endregion         

    #region lknAuxiliar_Click
    protected void lknAuxiliar_Click(object sender, EventArgs e)
    {
        string[] arrDatos;
        String strParameters = "";
        Entity_Conciliaciones obj;
        obj = new Entity_Conciliaciones();

        txtAnio.Text = txtAnio.Text == "" ? DateTime.Now.Year.ToString() : txtAnio.Text;
        txtAnioFin.Text = txtAnioFin.Text == "" ? DateTime.Now.Year.ToString() : txtAnioFin.Text;
        txtMes.Text = txtMes.Text == "" ? DateTime.Now.Month.ToString() : txtMes.Text;
        txtMesFin.Text = txtMesFin.Text == "" ? DateTime.Now.Month.ToString() : txtMesFin.Text;

        obj.IntEmpresa = Convert.ToInt32(txtEmpresa.Text);
        obj.IntEjercicioInicial = Convert.ToInt32(txtAnio.Text);
        obj.IntEjercicioFinal = Convert.ToInt32(txtAnioFin.Text);
        obj.IntMesInicial = Convert.ToInt32(txtMes.Text);
        obj.IntMesFinal = Convert.ToInt32(txtMesFin.Text);
        obj.StrObraInicial = txtClave.Text == "" ? "0" : txtClave.Text;
        obj.StrObraFinal = txtClaveFin.Text == "" ? "0" : txtClaveFin.Text;
        obj.StrFechaInicial = txtCuenta.Text == "" ? "0" : txtCuenta.Text;
        obj.StrFechaFinal = txtCuentaFin.Text == "" ? "0" : txtCuentaFin.Text;
        obj.IntProveedorInicial = txtArea.Text == "" ? 0 : Convert.ToInt32(txtArea.Text);
        obj.IntProveedorFinal = txtAreaFin.Text == "" ? 0 : Convert.ToInt32(txtAreaFin.Text);
        obj.IntParametroInicial = txtColonia.Text == "" ? 0 : Convert.ToInt32(txtColonia.Text);
        obj.IntParametroFinal = txtColoniaFin.Text == "" ? 0 : Convert.ToInt32(txtColoniaFin.Text);
        obj.IntEjercicio = chkCero.Checked ? 1 : 0;

    //        @intEmpresa int, 
    //@intEjercicio int, 
    //@intMes int,                                       
    //@strCuentaIni varchar(50), 
    //@strCuentaFin varchar(50), 
    //@intColIni INT,
    //@intColFin INT,
    //@intSectorIni INT,
    //@intSectorFin INT,
    //@intCCIni INT, 
    //@intCCFin INT,
    //@intAreaIni INT, 
    //@intAreaFin INT,
    //@bMovimiento INT,
    //@bHojaCC INT
        
        arrDatos = new string[14];
        arrDatos[0] = obj.IntEmpresa.ToString();
        arrDatos[1] = obj.IntEjercicioInicial.ToString();
        arrDatos[2] = obj.IntEjercicioFinal.ToString();
        arrDatos[3] = obj.IntMesInicial.ToString();
        arrDatos[4] = obj.IntMesFinal.ToString();
        arrDatos[5] = obj.StrFechaInicial.ToString();
        arrDatos[6] = obj.StrFechaFinal.ToString();
        arrDatos[7] = obj.StrObraInicial.ToString();
        arrDatos[8] = obj.StrObraFinal.ToString();
        arrDatos[9] = obj.IntProveedorInicial.ToString();
        arrDatos[10] = obj.IntProveedorFinal.ToString();
        arrDatos[11] = obj.IntParametroInicial.ToString();
        arrDatos[12] = obj.IntParametroFinal.ToString();
        arrDatos[13] = obj.IntEjercicio.ToString();

        if (!toolbar.Check())
        {            
            strParameters = String.Format("{0}[--]{1}[--]{2}[--]{3}[--]{4}[--]{5}[--]{6}[--]{7}[--]{8}[--]{9}[--]{10}[--]{11}[--]{12}[--]{13}", arrDatos);

            string strServerName = "http://" + HttpContext.Current.Request.ServerVariables["SERVER_NAME"].ToString() + ":" + HttpContext.Current.Request.ServerVariables["SERVER_PORT"].ToString() + "/Contabilidad/Utils/CRViewer.aspx";
            string strQueryString = string.Empty;
            strQueryString = "?type=pdf";
            strQueryString += "&report=Pages/Reportes/Auxiliar/Auxiliar.rpt";
            strQueryString += "&db=VetecMarfilAdmin";
            strQueryString += "&parameters=" + strParameters;

            strQueryString = strQueryString.Replace("'", "|");
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "rptt", "window.open('" + strServerName + strQueryString + "');", true);
        }
        else
        {
            PolizasDet pol;
            pol = new PolizasDet();

            string query;

            query = sqlQuery("vetecmarfiladmin..qryINCN4030_Sel_Rep_Auxiliar2 ", arrDatos);
                            
            obj = null;
            pol = null;

            string queryString = "?query=" + query + "&type=xls";
            Response.Redirect("../../../Utils/Excel.aspx" + queryString);
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
        }
        else
        {
            this.txtClave.Text = obj.StrClave;
            this.txtNombre.Text = obj.StrNombre;
        }

        this.txtClave.UpdateAfterCallBack = true;
        this.txtNombre.UpdateAfterCallBack = true;
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
                txtCuenta.Text = CuentaByKey.StrCuenta;
                txtNombreCuenta.Text = CuentaByKey.StrNombre;
            }
            else
            {
                txtCuenta.Text = "";
                txtNombreCuenta.Text = "";
            }

            txtCuenta.UpdateAfterCallBack = true;
            txtNombreCuenta.UpdateAfterCallBack = true;

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

        return query + par.Substring(0, par.Length - 1);
    }
    #endregion

}


