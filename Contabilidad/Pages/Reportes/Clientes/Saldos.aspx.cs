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

public partial class Contabilidad_Reportes_Saldos : System.Web.UI.Page
{
    Report_Pages_Base toolbar;
    protected void Page_Load(object sender, EventArgs e)
    {
        toolbar = (Report_Pages_Base)this.Master;
        Anthem.Manager.Register(this);
        
        if (!IsPostBack)
        {
            btnExpandReportes.Attributes.Add("onClick", "ReportVisible(this,'" + pnlReportes1.ClientID + "');");
            txtFechaInicial.Text = DateTime.Now.ToString("dd/MM/yyyy");
            txtFechaFinal.Text = DateTime.Now.ToString("dd/MM/yyyy");
            txtEmpresa.Text = Contabilidad.SEMSession.GetInstance.IntEmpresa.ToString();
            txtEmpresa_TextChange(null, null);
           
            JavaScript();
        }

        ImgDate.OnClientClick = "if(self.gfPop)gfPop.fPopCalendar(document.getElementById('" + txtFechaInicial.ClientID + "')); giDatePos=0; return false;";
        ImgDateFin.OnClientClick = "if(self.gfPop)gfPop.fPopCalendar(document.getElementById('" + txtFechaFinal.ClientID + "')); giDatePos=0; return false;";
    }

    #region JavaScript
    private void JavaScript()
    {
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtEmpresa", "var objText = new VetecText('" + txtEmpresa.ClientID + "', 'number', 4);", true);
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtCuenta", "var objText = new VetecText('" + txtCuenta.ClientID + "', 'number', 4);", true);
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtClienteFin", "var objText = new VetecText('" + txtClienteFin.ClientID + "', 'number', 4);", true);
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtCliente", "var objText = new VetecText('" + txtCliente.ClientID + "', 'number', 4);", true);
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtProveedorFin", "var objText = new VetecText('" + txtProveedorFin.ClientID + "', 'number', 4);", true);
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtProveedor", "var objText = new VetecText('" + txtProveedor.ClientID + "', 'number', 4);", true);

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

    #region lknCliente_Click
    protected void lknCliente_Click(object sender, EventArgs e)
    {
        string[] arrDatos;
        String strParameters = "";

        string intClienteProveedor = rblDesglozado.SelectedValue;
        string intClienteIni;
        string intClienteFin;
        string report;
        string sp;

        if(chkSaldo.Checked)
        {
            if (chkAfectado.Checked)
            {
                report = "INCN5000SaldoClientes_ConSaldo_Afectada.rpt";
                sp = "vetecmarfiladmin..qryINCN5000_Sel_Rep_SaldosClientes_Afectada ";
            }
            else
            {
                report = "INCN5000SaldoClientes_ConSaldo.rpt";
                sp = "vetecmarfiladmin..qryINCN5000_Sel_Rep_SaldosClientes ";
            }
        }
        else
        {
            if (chkAfectado.Checked)
            {
                report = "INCN5000SaldoClientes_Afectada.rpt";
                sp = "vetecmarfiladmin..qryINCN5000_Sel_Rep_SaldosClientes_Afectada ";
            }
            else
            {
                report = "INCN5000SaldoClientes.rpt";
                sp = "vetecmarfiladmin..qryINCN5000_Sel_Rep_SaldosClientes ";
            }
        }


        if (intClienteProveedor == "1")
        {
            intClienteIni = txtCliente.Text == "" ? "0" : txtCliente.Text;
            intClienteFin = txtClienteFin.Text == "" ? "0" : txtClienteFin.Text;
        }
        else
        {
            intClienteIni = txtProveedor.Text == "" ? "0" : txtProveedor.Text;
            intClienteFin = txtProveedorFin.Text == "" ? "0" : txtProveedorFin.Text;
        }

        arrDatos = new string[13];
        arrDatos[0] = txtEmpresa.Text; 
        arrDatos[1] = txtCuenta.Text;
        arrDatos[2] = intClienteIni;
        arrDatos[3] = intClienteFin;
        arrDatos[4] = txtFechaInicial.Text;
        arrDatos[5] = txtFechaFinal.Text;
        arrDatos[6] = txtColonia.Text == "" ? "0" : txtColonia.Text;
        arrDatos[7] = txtColoniaFin.Text == "" ? "0" : txtColoniaFin.Text;
        arrDatos[8] = "0";
        arrDatos[9] = "0";
        arrDatos[10] = intClienteProveedor;
        arrDatos[11] = txtClave.Text == "" ? "0" : txtClave.Text;
        arrDatos[12] = txtClaveFin.Text == "" ? "0" : txtClaveFin.Text; 

        if (!toolbar.Check())
        {
            strParameters = String.Format("{0}[--]{1}[--]{2}[--]{3}[--]{4}[--]{5}[--]{6}[--]{7}[--]{8}[--]{9}[--]{10}[--]{11}[--]{12}", arrDatos);

            string strServerName = "http://" + HttpContext.Current.Request.ServerVariables["SERVER_NAME"].ToString() + ":" + HttpContext.Current.Request.ServerVariables["SERVER_PORT"].ToString() + "/Contabilidad/Utils/CRViewer.aspx";
            string strQueryString = string.Empty;
            strQueryString = "?type=pdf";
            strQueryString += "&report=Pages/Reportes/Clientes/" + report;
            strQueryString += "&db=VetecMarfilAdmin";
            strQueryString += "&parameters=" + strParameters;

            strQueryString = strQueryString.Replace("'", "|");
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "rpt", "window.open('" + strServerName + strQueryString + "');", true);
        }
        else
        {
            string query;

            query = sqlQuery(sp, arrDatos);

            string queryString = "?query=" + query + "&type=xls";
            Response.Redirect("../../../Utils/Excel.aspx" + queryString);
        }
    }
    #endregion

    #region lknDesglozado_Click
    protected void lknDesglozado_Click(object sender, EventArgs e)
    {
        string[] arrDatos;
        String strParameters = "";

        string intClienteProveedor = rblDesglozado.SelectedValue;
        string intClienteIni;
        string intClienteFin;
        string report;
        string sp;
        string rbdTipo;

        rbdTipo = rblReferencia.SelectedValue;

        if (chkSaldo.Checked)
        {
            if (chkAfectado.Checked)
            {
                report = "INCN5000SaldoClientesDesglosado_ConSaldo_Afectada.rpt";
                sp = "vetecmarfiladmin..qryINCN5000_Sel_Rep_SaldosClientesProveedor_OC_Afectada_ConSaldo ";
            }
            else
            {
                report = "INCN5000SaldoClientesDesglosado_ConSaldo.rpt";
                sp = "vetecmarfiladmin..qryINCN5000_Sel_Rep_SaldosClientesProveedor_OC_ConSaldo ";
            }
        }
        else
        {
            if (chkAfectado.Checked)
            {
                report = "INCN5000SaldoClientesDesglosado_Afectada.rpt";
                sp = "vetecmarfiladmin..qryINCN5000_Sel_Rep_SaldosClientesProveedor_OC_Afectada ";
            }
            else
            {
                report = "INCN5000SaldoClientesDesglosado.rpt";
                sp = "vetecmarfiladmin..qryINCN5000_Sel_Rep_SaldosClientesProveedor_OC ";
            }
        }

        if (intClienteProveedor == "1")
        {
            intClienteIni = txtCliente.Text == "" ? "0" : txtCliente.Text;
            intClienteFin = txtClienteFin.Text == "" ? "0" : txtClienteFin.Text;
        }
        else
        {
            intClienteIni = txtProveedor.Text == "" ? "0" : txtProveedor.Text;
            intClienteFin = txtProveedorFin.Text == "" ? "0" : txtProveedorFin.Text;
        }

        arrDatos = new string[16];
        arrDatos[0] = txtEmpresa.Text;
        arrDatos[1] = txtCuenta.Text;
        arrDatos[2] = intClienteIni;
        arrDatos[3] = intClienteFin;
        arrDatos[4] = txtFechaInicial.Text;
        arrDatos[5] = txtFechaFinal.Text;
        arrDatos[6] = txtColonia.Text == "" ? "0" : txtColonia.Text;
        arrDatos[7] = txtColoniaFin.Text == "" ? "0" : txtColoniaFin.Text;
        arrDatos[8] = "0";
        arrDatos[9] = "0";
        arrDatos[10] = txtOC.Text == "" ? "0" : txtOC.Text;
        arrDatos[11] = txtOCFin.Text == "" ? "0" : txtOCFin.Text;
        arrDatos[12] = intClienteProveedor;
        arrDatos[13] = rbdTipo;
        arrDatos[14] = txtClave.Text == "" ? "0" : txtClave.Text;
        arrDatos[15] = txtClaveFin.Text == "" ? "0" : txtClaveFin.Text; 

        if (!toolbar.Check())
        {
            switch (sp)
            {
                case "vetecmarfiladmin..qryINCN5000_Sel_Rep_SaldosClientesProveedor_OC ":
                    strParameters = String.Format("{0}[--]{1}[--]{2}[--]{3}[--]{4}[--]{5}[--]{6}[--]{7}[--]{8}[--]{9}[--]{10}[--]{11}[--]{12}[--]{13}[--]{14}[--]{15}", arrDatos);
                    break;
                case "vetecmarfiladmin..qryINCN5000_Sel_Rep_SaldosClientesProveedor_OC_Afectada_ConSaldo ":
                    strParameters = String.Format("{0}[--]{1}[--]{2}[--]{3}[--]{4}[--]{5}[--]{6}[--]{7}[--]{8}[--]{9}[--]{10}[--]{11}[--]{12}[--]{14}[--]{15}", arrDatos);
                    break;
                case "vetecmarfiladmin..qryINCN5000_Sel_Rep_SaldosClientesProveedor_OC_Afectada ":
                    strParameters = String.Format("{0}[--]{1}[--]{2}[--]{3}[--]{4}[--]{5}[--]{6}[--]{7}[--]{8}[--]{9}[--]{10}[--]{11}[--]{12}[--]{14}[--]{15}", arrDatos);
                    break;
                default:
                    strParameters = String.Format("{0}[--]{1}[--]{2}[--]{3}[--]{4}[--]{5}[--]{6}[--]{7}[--]{8}[--]{9}[--]{10}[--]{11}[--]{12}[--]{13}[--]{14}[--]{15}", arrDatos);
                    break;

            }
            //if (sp != "vetecmarfiladmin..qryINCN5000_Sel_Rep_SaldosClientesProveedor_OC_Afectada_ConSaldo" || sp == "vetecmarfiladmin..qryINCN5000_Sel_Rep_SaldosClientesProveedor_OC")
            //    strParameters = String.Format("{0}[--]{1}[--]{2}[--]{3}[--]{4}[--]{5}[--]{6}[--]{7}[--]{8}[--]{9}[--]{10}[--]{11}[--]{12}[--]{13}[--]{14}[--]{15}", arrDatos);
            //else
            //    strParameters = String.Format("{0}[--]{1}[--]{2}[--]{3}[--]{4}[--]{5}[--]{6}[--]{7}[--]{8}[--]{9}[--]{10}[--]{11}[--]{12}[--]{14}[--]{15}", arrDatos);

            string strServerName = "http://" + HttpContext.Current.Request.ServerVariables["SERVER_NAME"].ToString() + ":" + HttpContext.Current.Request.ServerVariables["SERVER_PORT"].ToString() + "/Contabilidad/Utils/CRViewer.aspx";
            string strQueryString = string.Empty;
            strQueryString = "?type=pdf";
            strQueryString += "&report=Pages/Reportes/Clientes/" + report;
            strQueryString += "&db=VetecMarfilAdmin";
            strQueryString += "&parameters=" + strParameters;

            strQueryString = strQueryString.Replace("'", "|");
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "rpt", "window.open('" + strServerName + strQueryString + "');", true);
        }
        else
        {
            string query;

            query = sqlQuery(sp, arrDatos);

            string queryString = "?query=" + query + "&type=xls";
            Response.Redirect("../../../Utils/Excel.aspx" + queryString);
        }
    }
    #endregion      

    #region lknAux_Click
    protected void lknAux_Click(object sender, EventArgs e)
    {
        string[] arrDatos;
        String strParameters = "";

        string intClienteProveedor = rblDesglozado.SelectedValue;
        string intClienteIni;
        string intClienteFin;

        if (intClienteProveedor == "1")
        {
            intClienteIni = txtCliente.Text == "" ? "0" : txtCliente.Text;
            intClienteFin = txtClienteFin.Text == "" ? "0" : txtClienteFin.Text;
        }
        else
        {
            intClienteIni = txtProveedor.Text == "" ? "0" : txtProveedor.Text;
            intClienteFin = txtProveedorFin.Text == "" ? "0" : txtProveedorFin.Text;
        }

        arrDatos = new string[13];
        arrDatos[0] = txtEmpresa.Text;
        arrDatos[1] = txtCuenta.Text;
        arrDatos[2] = intClienteIni;
        arrDatos[3] = intClienteFin;
        arrDatos[4] = txtFechaInicial.Text;
        arrDatos[5] = txtFechaFinal.Text;
        arrDatos[6] = txtColonia.Text == "" ? "0" : txtColonia.Text;
        arrDatos[7] = txtColoniaFin.Text == "" ? "0" : txtColoniaFin.Text;
        arrDatos[8] = "0";
        arrDatos[9] = "0";
        arrDatos[10] = txtOC.Text == "" ? "0" : txtOC.Text;
        arrDatos[11] = txtOCFin.Text == "" ? "0" : txtOCFin.Text;
        arrDatos[12] = intClienteProveedor;

        if (!toolbar.Check())
        {
            strParameters = String.Format("{0}[--]{1}[--]{2}[--]{3}[--]{4}[--]{5}[--]{6}[--]{7}[--]{8}[--]{9}[--]{10}[--]{11}[--]{12}", arrDatos);

            string strServerName = "http://" + HttpContext.Current.Request.ServerVariables["SERVER_NAME"].ToString() + ":" + HttpContext.Current.Request.ServerVariables["SERVER_PORT"].ToString() + "/Contabilidad/Utils/CRViewer.aspx";
            string strQueryString = string.Empty;
            strQueryString = "?type=pdf";
            strQueryString += "&report=Pages/Reportes/Clientes/RepAuxMensualOC.rpt";
            strQueryString += "&db=VetecMarfilAdmin";
            strQueryString += "&parameters=" + strParameters;

            strQueryString = strQueryString.Replace("'", "|");
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "rpt", "window.open('" + strServerName + strQueryString + "');", true);
        }
        else
        {
            string query;

            query = sqlQuery("vetecmarfiladmin..qryINCN5000_Rep_Aux_Mensual_OC ", arrDatos);

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

    #region txtColonia_TextChanged
    protected void txtColonia_TextChanged(object sender, EventArgs e)
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

    #region txtColoniaFin_TextChanged
    protected void txtColoniaFin_TextChanged(object sender, EventArgs e)
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

    #region txtCliente_TextChanged
    protected void txtCliente_TextChanged(object sender, EventArgs e)
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

    #region txtClienteFin_TextChanged
    protected void txtClienteFin_TextChanged(object sender, EventArgs e)
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

    #region txtProveedor_TextChanged
    protected void txtProveedor_TextChanged(object sender, EventArgs e)
    {
        try
        {
            Proveedor Obj = new Proveedor();
            Entity_Proveedor EntiCuentas = new Entity_Proveedor();

            EntiCuentas.IntEmpresa = txtEmpresa.Text == "" ? Contabilidad.SEMSession.GetInstance.IntEmpresa : Convert.ToInt32(txtEmpresa.Text);
            EntiCuentas.IntProveedor = txtProveedor.Text == "" ? 0 : Convert.ToInt32(txtProveedor.Text);

            Entity_Proveedor CuentaByKey = Obj.Fill(EntiCuentas);

            if (CuentaByKey != null)
            {
                txtProveedor.Text = CuentaByKey.IntProveedor.ToString();
                txtNombreProveedor.Text = CuentaByKey.StrNombre;
                txtProveedorFin.Text = CuentaByKey.IntProveedor.ToString();
                txtNombreProveedorFin.Text = CuentaByKey.StrNombre;
            }
            else
            {
                txtProveedor.Text = "";
                txtNombreProveedor.Text = "";
            }

            txtProveedor.UpdateAfterCallBack = true;
            txtNombreProveedor.UpdateAfterCallBack = true;
            txtProveedorFin.UpdateAfterCallBack = true;
            txtNombreProveedorFin.UpdateAfterCallBack = true;

            Anthem.Manager.RegisterStartupScript(Page.GetType(), "focusCF", "document.all('ctl00_CPHBase_txtCuentaFin').focus()", true);

        }
        catch (System.IO.IOException ex)
        {

        }
    }
    #endregion

    #region txtProveedorFin_TextChanged
    protected void txtProveedorFin_TextChanged(object sender, EventArgs e)
    {
        try
        {
            Proveedor Obj = new Proveedor();
            Entity_Proveedor EntiCuentas = new Entity_Proveedor();

            EntiCuentas.IntEmpresa = txtEmpresa.Text == "" ? Contabilidad.SEMSession.GetInstance.IntEmpresa : Convert.ToInt32(txtEmpresa.Text);
            EntiCuentas.IntProveedor = txtProveedorFin.Text == "" ? 0 : Convert.ToInt32(txtProveedorFin.Text);

            Entity_Proveedor CuentaByKey = Obj.Fill(EntiCuentas);

            if (CuentaByKey != null)
            {
                txtProveedorFin.Text = CuentaByKey.IntProveedor.ToString();
                txtNombreProveedorFin.Text = CuentaByKey.StrNombre;
            }
            else
            {
                txtProveedorFin.Text = "";
                txtNombreProveedorFin.Text = "";
            }

            txtProveedorFin.UpdateAfterCallBack = true;
            txtNombreProveedorFin.UpdateAfterCallBack = true;

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

    #region lknClienteV2_Click
    protected void lknClienteV2_Click(object sender, EventArgs e)
    {
        string[] arrDatos;
        String strParameters = "";

        string intClienteProveedor = rblDesglozado.SelectedValue;
        string intClienteIni;
        string intClienteFin;
        string strSaldo;
        string strAfectado; 

        if (intClienteProveedor == "1")
        {
            intClienteIni = txtCliente.Text == "" ? "0" : txtCliente.Text;
            intClienteFin = txtClienteFin.Text == "" ? "0" : txtClienteFin.Text;
        }
        else
        {
            intClienteIni = txtProveedor.Text == "" ? "0" : txtProveedor.Text;
            intClienteFin = txtProveedorFin.Text == "" ? "0" : txtProveedorFin.Text;
        }

        strSaldo = chkSaldo.Checked == true ? "1" : "0";
        strAfectado = chkAfectado.Checked == true ? "1" : "0";

        arrDatos = new string[15];
        arrDatos[0] = txtEmpresa.Text;
        arrDatos[1] = txtCuenta.Text;
        arrDatos[2] = intClienteIni;
        arrDatos[3] = intClienteFin;
        arrDatos[4] = txtFechaInicial.Text;
        arrDatos[5] = txtFechaFinal.Text;
        //arrDatos[6] = "0";
        //arrDatos[7] = "0";
        arrDatos[6] = txtColonia.Text == "" ? "0" : txtColonia.Text;
        arrDatos[7] = txtColoniaFin.Text == "" ? "0" : txtColoniaFin.Text;
        arrDatos[8] = "0";
        arrDatos[9] = "0";
        arrDatos[10] = intClienteProveedor;
        arrDatos[11] = strAfectado;
        arrDatos[12] = strSaldo;
        arrDatos[13] = txtClave.Text == "" ? "0" : txtClave.Text;
        arrDatos[14] = txtClaveFin.Text == "" ? "0" : txtClaveFin.Text; 

        if (!toolbar.Check())
        {
            strParameters = String.Format("{0}[--]{1}[--]{2}[--]{3}[--]{4}[--]{5}[--]{6}[--]{7}[--]{8}[--]{9}[--]{10}[--]{11}[--]{12}[--]{13}[--]{14}", arrDatos);

            string strServerName = "http://" + HttpContext.Current.Request.ServerVariables["SERVER_NAME"].ToString() + ":" + HttpContext.Current.Request.ServerVariables["SERVER_PORT"].ToString() + "/Contabilidad/Utils/CRViewer.aspx";
            string strQueryString = string.Empty;
            strQueryString = "?type=pdf";
            //strQueryString += "&report=Pages/Reportes/Clientes/rptSaldosCliProv.rpt";
            strQueryString += "&report=Pages/Reportes/Clientes/SaldoClientes.rpt";
            strQueryString += "&db=VetecMarfilAdmin";
            strQueryString += "&parameters=" + strParameters;

            strQueryString = strQueryString.Replace("'", "|");
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "rpt", "window.open('" + strServerName + strQueryString + "');", true);
        }
        else
        {
            string query;
            string sp = "VetecMarfilAdmin..usp_tbPolizasDet_SaldoCliente ";
            query = sqlQuery(sp, arrDatos);

            string queryString = "?query=" + query + "&type=xls&tabla=1";
            Response.Redirect("../../../Utils/Excel.aspx" + queryString);
        }
    }
    #endregion

    #region lknDesglozadoV2_Click
    protected void lknDesglozadoV2_Click(object sender, EventArgs e)
    {
        string[] arrDatos;
        String strParameters = "";

        string intClienteProveedor = rblDesglozado.SelectedValue;
        string intClienteIni;
        string intClienteFin;
        string report;
        string sp;
        string rbdTipo;

        rbdTipo = rblReferencia.SelectedValue;

        if (intClienteProveedor == "1")
        {
            intClienteIni = txtCliente.Text == "" ? "0" : txtCliente.Text;
            intClienteFin = txtClienteFin.Text == "" ? "0" : txtClienteFin.Text;
        }
        else
        {
            intClienteIni = txtProveedor.Text == "" ? "0" : txtProveedor.Text;
            intClienteFin = txtProveedorFin.Text == "" ? "0" : txtProveedorFin.Text;
        }

        report = "SaldoClientesDes.rpt";
        sp = "vetecmarfiladmin..usp_tbPolizasDet_SaldoCliente_DES ";

        arrDatos = new string[14];
        arrDatos[0] = txtEmpresa.Text;
        arrDatos[1] = txtCuenta.Text;
        arrDatos[2] = intClienteIni;
        arrDatos[3] = intClienteFin;
        arrDatos[4] = txtFechaInicial.Text;
        arrDatos[5] = txtFechaFinal.Text;
        arrDatos[6] = txtColonia.Text == "" ? "0" : txtColonia.Text;
        arrDatos[7] = txtColoniaFin.Text == "" ? "0" : txtColoniaFin.Text;
        arrDatos[8] = "0";
        arrDatos[9] = "0";
        arrDatos[10] = txtOC.Text == "" ? "0" : txtOC.Text;
        arrDatos[11] = txtOCFin.Text == "" ? "0" : txtOCFin.Text;
        arrDatos[12] = intClienteProveedor;
        arrDatos[13] = rbdTipo;

        if (!toolbar.Check())
        {
            strParameters = String.Format("{0}[--]{1}[--]{2}[--]{3}[--]{4}[--]{5}[--]{6}[--]{7}[--]{8}[--]{9}[--]{10}[--]{11}[--]{12}[--]{13}", arrDatos);

            string strServerName = "http://" + HttpContext.Current.Request.ServerVariables["SERVER_NAME"].ToString() + ":" + HttpContext.Current.Request.ServerVariables["SERVER_PORT"].ToString() + "/Contabilidad/Utils/CRViewer.aspx";
            string strQueryString = string.Empty;
            strQueryString = "?type=pdf";
            strQueryString += "&report=Pages/Reportes/Clientes/" + report;
            strQueryString += "&db=VetecMarfilAdmin";
            strQueryString += "&parameters=" + strParameters;

            strQueryString = strQueryString.Replace("'", "|");
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "rpt", "window.open('" + strServerName + strQueryString + "');", true);
        }
        else
        {
            string query;

            query = sqlQuery(sp, arrDatos);

            string queryString = "?query=" + query + "&type=xls&tabla=1";
            Response.Redirect("../../../Utils/Excel.aspx" + queryString);
        }
    }
    #endregion  

}


