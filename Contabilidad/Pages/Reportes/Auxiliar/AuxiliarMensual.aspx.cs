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

public partial class Contabilidad_Reportes_AuxiliarMensual : System.Web.UI.Page
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
            Year();
            Month();

            string mes = DateTime.Now.Month < 10 ? "0" + DateTime.Now.Month.ToString() : DateTime.Now.Month.ToString();
            txtFechaInicial.Text = "01/" + mes + "/" + DateTime.Now.Year.ToString();
            txtFechaPrint.Text = "01/" + mes + "/" + DateTime.Now.Year.ToString();
            txtFechaFinal.Text = DateTime.Now.ToString("dd/MM/yyyy");
        }
        JavaScript();
        //Anthem.Manager.RegisterStartupScript(Page.GetType(), "focusss", "document.all('ctl00_CPHFilters_txtEmpresa').focus()", true);
        ImgDate.OnClientClick = "if(self.gfPop)gfPop.fPopCalendar(document.getElementById('" + txtFechaInicial.ClientID + "')); giDatePos=0; return false;";
        ImgDateFin.OnClientClick = "if(self.gfPop)gfPop.fPopCalendar(document.getElementById('" + txtFechaFinal.ClientID + "')); giDatePos=0; return false;";
        btnFechaPrint.OnClientClick = "if(self.gfPop)gfPop.fPopCalendar(document.getElementById('" + txtFechaPrint.ClientID + "')); giDatePos=0; return false;";
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
        cboMonth.SelectedIndex = 0;

        cboMonth.Items.Insert(0, new ListItem("-- Seleccione --", "0"));
        cboMonth.SelectedValue = DateTime.Now.Month.ToString();
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
        cboYear.SelectedValue = DateTime.Now.Year.ToString();
        cboYear.UpdateAfterCallBack = true;

        list = null;
    }
    #endregion Year    

    #region JavaScript
    private void JavaScript()
    {
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtEmpresa", "var objText = new VetecText('" + txtEmpresa.ClientID + "', 'number', 4);", true);
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtCuenta", "var objText = new VetecText('" + txtCuenta.ClientID + "', 'text', 100);", true);
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtCuentaFin", "var objText = new VetecText('" + txtCuentaFin.ClientID + "', 'text', 100);", true);
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtArea", "var objText = new VetecText('" + txtArea.ClientID + "', 'number', 4);", true);
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtAreaFin", "var objText = new VetecText('" + txtAreaFin.ClientID + "', 'number', 4);", true);
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtColonia", "var objText = new VetecText('" + txtColonia.ClientID + "', 'number', 4);", true);
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtColoniaFin", "var objText = new VetecText('" + txtColoniaFin.ClientID + "', 'number', 4);", true);
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtFechaInicial", "var objText = new VetecText('" + txtFechaInicial.ClientID + "', 'text', 100);", true);
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtFechaFinal", "var objText = new VetecText('" + txtFechaFinal.ClientID + "', 'text', 100);", true);
        
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

        String strParameters = "";

        //Hoja@bHojaCC INT
        string strFechaInicial = txtFechaInicial.Text;
        string strFechaFinal = txtFechaFinal.Text;
        string strMes = Convert.ToInt32(cboMonth.SelectedValue) < 10 ? "0" + cboMonth.SelectedValue : cboMonth.SelectedValue;


        string s = cboYear.SelectedValue + strMes;
        DateTime firstDay = DateTime.ParseExact(s, "yyyyMM", null);
        string lastDay = firstDay.AddMonths(1).AddDays(-1).Day.ToString();

        if (!chkFecha.Checked)
        {
            strFechaInicial = "01/" + strMes + "/" + cboYear.SelectedValue;
            strFechaFinal = lastDay + "/" + strMes + "/" + cboYear.SelectedValue;
            //if (!toolbar.Check())
            //{
            //    strParameters = String.Format("{0}[--]{1}[--]{2}[--]{3}[--]{4}[--]{5}[--]{6}[--]{7}[--]{8}[--]{9}[--]{10}[--]{11}[--]{12}[--]{13}[--]{14}", arrDatos);

            //    string strServerName = "http://" + HttpContext.Current.Request.ServerVariables["SERVER_NAME"].ToString() + ":" + HttpContext.Current.Request.ServerVariables["SERVER_PORT"].ToString() + "/Contabilidad/Utils/CRViewer.aspx";
            //    string strQueryString = string.Empty;
            //    strQueryString = "?type=pdf";
            //    strQueryString += "&report=Pages/Reportes/Auxiliar/AuxIliarINNAUS.rpt";
            //    strQueryString += "&db=VetecMarfilAdmin";
            //    strQueryString += "&parameters=" + strParameters;

            //    strQueryString = strQueryString.Replace("'", "|");
            //    Anthem.Manager.RegisterStartupScript(Page.GetType(), "rptt", "window.open('" + strServerName + strQueryString + "');", true);
            //}
            //else
            //{
            //    string query;

            //    query = sqlQuery("vetecmarfiladmin..qryINCN4030_Sel_Rep_Auxiliar2 ", arrDatos);

            //    string queryString = "?query=" + query + "&type=xls";
            //    Response.Redirect("../../../Utils/Excel.aspx" + queryString);
            //}
        }

        string[] arrDatos2;
        arrDatos2 = new string[14];
        arrDatos2[0] = txtEmpresa.Text;
        arrDatos2[1] = strFechaInicial;
        arrDatos2[2] = strFechaFinal;
        arrDatos2[3] = txtCuenta.Text == "" ? "0" : txtCuenta.Text;
        arrDatos2[4] = txtCuentaFin.Text == "" ? "0" : txtCuentaFin.Text;
        arrDatos2[5] = txtClave.Text == "" ? "0" : txtClave.Text;
        arrDatos2[6] = txtClaveFin.Text == "" ? "0" : txtClaveFin.Text;     
        arrDatos2[7] = txtArea.Text == "" ? "0" : txtArea.Text;
        arrDatos2[8] = txtAreaFin.Text == "" ? "0" : txtAreaFin.Text; //Area  
        arrDatos2[9] = txtColonia.Text == "" ? "0" : txtColonia.Text;
        arrDatos2[10] = txtColoniaFin.Text == "" ? "0" : txtColoniaFin.Text; //Area 
        arrDatos2[11] = chkCero.Checked ? "1" : "0";
        arrDatos2[12] = chkFechaPrint.Checked == false ? "0" : txtFechaPrint.Text;
        arrDatos2[13] = rblReferencia.SelectedValue;

        if (!toolbar.Check())
        {
            strParameters = String.Format("{0}[--]{1}[--]{2}[--]{3}[--]{4}[--]{5}[--]{6}[--]{7}[--]{8}[--]{9}[--]{10}[--]{11}[--]{12}[--]{13}", arrDatos2);

            string strServerName = "http://" + HttpContext.Current.Request.ServerVariables["SERVER_NAME"].ToString() + ":" + HttpContext.Current.Request.ServerVariables["SERVER_PORT"].ToString() + "/Contabilidad/Utils/CRViewer.aspx";
            string strQueryString = string.Empty;
            strQueryString = "?type=pdf";
            strQueryString += "&report=Pages/Reportes/Auxiliar/AuxIliar.rpt";
            strQueryString += "&db=VetecMarfilAdmin";
            strQueryString += "&parameters=" + strParameters;

            strQueryString = strQueryString.Replace("'", "|");
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "rptt", "window.open('" + strServerName + strQueryString + "');", true);
        }
        else
        {
            strParameters = String.Format("{0}[--]{1}[--]{2}[--]{3}[--]{4}[--]{5}[--]{6}[--]{7}[--]{8}[--]{9}[--]{10}[--]{11}[--]{12}[--]{13}", arrDatos2);

            string strServerName = "http://" + HttpContext.Current.Request.ServerVariables["SERVER_NAME"].ToString() + ":" + HttpContext.Current.Request.ServerVariables["SERVER_PORT"].ToString() + "/Contabilidad/Utils/CRViewer.aspx";
            string strQueryString = string.Empty;
            strQueryString = "?type=xls";
            strQueryString += "&report=Pages/Reportes/Auxiliar/AuxIliar2.rpt";
            strQueryString += "&db=VetecMarfilAdmin";
            strQueryString += "&parameters=" + strParameters;

            strQueryString = strQueryString.Replace("'", "|");
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "rptt", "window.open('" + strServerName + strQueryString + "');", true);

            //string query;

            //query = sqlQuery("vetecmarfiladmin..usp_tbPolizasDet_Auxiliar ", arrDatos2);

            //string queryString = "?query=" + query + "&type=xls&tabla=1";
            //Response.Redirect("../../../Utils/Excel.aspx" + queryString);
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

            if (CuentaByKey != null)
            {
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

    protected void txtArea_TextChanged(object sender, EventArgs e)
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
    }

    protected void txtAreaFin_TextChanged(object sender, EventArgs e)
    {
        Entity_Area obj;
        obj = new Entity_Area();
        Area area;
        area = new Area();

        obj.IntEmpresa = txtEmpresa.Text == "" ? Contabilidad.SEMSession.GetInstance.IntEmpresa : Convert.ToInt32(txtEmpresa.Text);
        obj.IntSucursal = hddSucursal.Value == "" ? Contabilidad.SEMSession.GetInstance.IntSucursal : Convert.ToInt32(hddSucursal.Value);
        obj.intArea = txtAreaFin.Text == "" ? 0 : Convert.ToInt32(txtAreaFin.Text);

        obj = area.Fill(obj);

        if (obj != null)
        {
            txtAreaFin.Text = obj.intArea.ToString();
            txtNombreAreaFin.Text = obj.strNombre;
        }
        else
        {
            txtAreaFin.Text = "";
            txtNombreAreaFin.Text = "";
        }

        txtAreaFin.UpdateAfterCallBack = true;
        txtNombreAreaFin.UpdateAfterCallBack = true;
    }

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
            txtColonia.Text = obj.intColonia.ToString();
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

    protected void lknAuxiliarINNAUS_Click(object sender, EventArgs e)
    {
        String strParameters = "";
        string type = "pdf";

        if (!chkFecha.Checked)
        {
            string[] arrDatos2;
            arrDatos2 = new string[15];
            arrDatos2[0] = txtEmpresa.Text;
            arrDatos2[1] = cboYear.SelectedValue;
            arrDatos2[2] = cboMonth.SelectedValue;
            arrDatos2[3] = txtCuenta.Text == "" ? "0" : txtCuenta.Text;
            arrDatos2[4] = txtCuentaFin.Text == "" ? "0" : txtCuentaFin.Text;
            arrDatos2[5] = txtColonia.Text == "" ? "0" : txtColonia.Text;
            arrDatos2[6] = txtColoniaFin.Text == "" ? "0" : txtColoniaFin.Text; //Area 
            arrDatos2[7] = "0";
            arrDatos2[8] = "0";
            arrDatos2[9] = hddIntObraIni.Value == "" ? "0" : hddIntObraIni.Value;
            arrDatos2[10] = hddIntObraFin.Value == "" ? "0" : hddIntObraFin.Value;//Colonia            
            arrDatos2[11] = txtArea.Text == "" ? "0" : txtArea.Text;
            arrDatos2[12] = txtAreaFin.Text == "" ? "0" : txtAreaFin.Text;
            arrDatos2[13] = chkMov.Checked == true ? "1" : "0";
            arrDatos2[14] = chkHoja.Checked == true ? "1" : "0";

            strParameters = String.Format("{0}[--]{1}[--]{2}[--]{3}[--]{4}[--]{5}[--]{6}[--]{7}[--]{8}[--]{9}[--]{10}[--]{11}[--]{12}[--]{13}[--]{14}", arrDatos2);

            if (toolbar.Check()) type = "xls";

            string strServerName = "http://" + HttpContext.Current.Request.ServerVariables["SERVER_NAME"].ToString() + ":" + HttpContext.Current.Request.ServerVariables["SERVER_PORT"].ToString() + "/Contabilidad/Utils/CRViewer.aspx";
            string strQueryString = string.Empty;
            strQueryString = "?type=" + type;
            strQueryString += "&report=Pages/Reportes/Auxiliar/INCN4030.rpt";
            strQueryString += "&db=VetecMarfilAdmin";
            strQueryString += "&parameters=" + strParameters;
            strQueryString += "&Titulos=Auxiliar";
            strQueryString += "&Crystal=85";

            strQueryString = strQueryString.Replace("'", "|");
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "rpt", "window.open('" + strServerName + strQueryString + "');", true);
        }
        else
        {
            string[] arrDatos2;
            arrDatos2 = new string[16];
            arrDatos2[0] = txtEmpresa.Text;
            arrDatos2[1] = cboYear.SelectedValue;
            arrDatos2[2] = txtFechaInicial.Text;
            arrDatos2[3] = txtFechaFinal.Text;
            arrDatos2[4] = txtCuenta.Text == "" ? "0" : txtCuenta.Text;
            arrDatos2[5] = txtCuentaFin.Text == "" ? "0" : txtCuentaFin.Text;
            arrDatos2[6] = txtColonia.Text == "" ? "0" : txtColonia.Text;
            arrDatos2[7] = txtColoniaFin.Text == "" ? "0" : txtColoniaFin.Text; 
            arrDatos2[8] = "0";
            arrDatos2[9] = "0";
            arrDatos2[10] = hddIntObraIni.Value == "" ? "0" : hddIntObraIni.Value;
            arrDatos2[11] = hddIntObraFin.Value == "" ? "0" : hddIntObraFin.Value;//Colonia
            arrDatos2[12] = txtArea.Text == "" ? "0" : txtArea.Text;
            arrDatos2[13] = txtAreaFin.Text == "" ? "0" : txtAreaFin.Text;
            arrDatos2[14] = chkMov.Checked == true ? "1" : "0";
            arrDatos2[15] = chkHoja.Checked == true ? "1" : "0";

            strParameters = String.Format("{0}[--]{1}[--]{2}[--]{3}[--]{4}[--]{5}[--]{6}[--]{7}[--]{8}[--]{9}[--]{10}[--]{11}[--]{12}[--]{13}[--]{14}[--]{15}", arrDatos2);

            if (toolbar.Check()) type = "xls";

            string strServerName = "http://" + HttpContext.Current.Request.ServerVariables["SERVER_NAME"].ToString() + ":" + HttpContext.Current.Request.ServerVariables["SERVER_PORT"].ToString() + "/Contabilidad/Utils/CRViewer.aspx";
            string strQueryString = string.Empty;
            strQueryString = "?type=" + type;
            strQueryString += "&report=Pages/Reportes/Auxiliar/INCN4030_rango.rpt";
            strQueryString += "&db=VetecMarfilAdmin";
            strQueryString += "&parameters=" + strParameters;
            strQueryString += "&Titulos=Auxiliar";
            strQueryString += "&Crystal=85";

            strQueryString = strQueryString.Replace("'", "|");
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "rpt", "window.open('" + strServerName + strQueryString + "');", true);

        }
    }

}


