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

public partial class Contabilidad_Compra_Reportes_RelacionOCFactura : System.Web.UI.Page
{
    Report_Pages_Base toolbar;
    protected void Page_Load(object sender, EventArgs e)
    {
        toolbar = (Report_Pages_Base)this.Master;
        Anthem.Manager.Register(this);

        if (!IsPostBack && !IsCallback)
        { 
            btnExpandReportes.Attributes.Add("onClick", "ReportVisible(this,'" + pnlReportes1.ClientID + "');"); 
            txtFechaInicial.Text = DateTime.Now.ToString("dd/MM/yyyy");
            txtFechaFinal.Text = DateTime.Now.ToString("dd/MM/yyyy"); 
            txtEmpresa.Text = Contabilidad.SEMSession.GetInstance.IntEmpresa.ToString();
            txtEmpresa_TextChange(null, null);
            
        }

        JavaScript();
        ImgDate.OnClientClick = "if(self.gfPop)gfPop.fPopCalendar(document.getElementById('" + txtFechaInicial.ClientID + "')); giDatePos=0; return false;";
        ImgDateFin.OnClientClick = "if(self.gfPop)gfPop.fPopCalendar(document.getElementById('" + txtFechaFinal.ClientID + "')); giDatePos=0; return false;";
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtProveedorInicialfocus", "document.all('ctl00_CPHFilters_txtProveedor').focus()", true);
    }

    #region JavaScript
    private void JavaScript()
    {
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "objUtils", "var objUtils = new VetecUtils();", true);
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtEmpresa", "var objText = new VetecText('" + txtEmpresa.ClientID + "', 'number', 10);", true);
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtObraIni", "var objText = new VetecText('" + txtObraIni.ClientID + "', 'text', 100);", true);
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtObraFin", "var objText = new VetecText('" + txtObraFin.ClientID + "', 'text', 100);", true);
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtProveedorFin", "var objText = new VetecText('" + txtProveedorFin.ClientID + "', 'number', 50);", true);
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtProveedor", "var objText = new VetecText('" + txtProveedor.ClientID + "', 'number', 50);", true);
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtOCIni", "var objText = new VetecText('" + txtOCIni.ClientID + "', 'number', 10);", true);
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtOCFin", "var objText = new VetecText('" + txtOCFin.ClientID + "', 'number', 10);", true);
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtAreaIni", "var objText = new VetecText('" + txtAreaIni.ClientID + "', 'number', 10);", true);
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtAreaFin", "var objText = new VetecText('" + txtAreaFin.ClientID + "', 'number', 10);", true);
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtColonia", "var objText = new VetecText('" + txtColonia.ClientID + "', 'number', 10);", true);
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtColoniaFin", "var objText = new VetecText('" + txtColoniaFin.ClientID + "', 'number', 10);", true);
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtSecIni", "var objText = new VetecText('" + txtSecIni.ClientID + "', 'number', 10);", true);
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtSecFin", "var objText = new VetecText('" + txtSecFin.ClientID + "', 'number', 10);", true);

        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtFechaInicial", "var objText = new VetecText('" + txtFechaInicial.ClientID + "', 'text', 100);", true);
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtFechaFinal", "var objText = new VetecText('" + txtFechaFinal.ClientID + "', 'text', 100);", true);
       
    }
    #endregion  

    #region txtEmpresa_TextChange
    protected void txtEmpresa_TextChange(object sender, EventArgs e)
    {
        Entity_Empresa obj = new Entity_Empresa();
        Empresa emp = new Empresa();

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
        txtProveedor.Text = "";
        txtNombreProveedor.Text = "";
        txtProveedorFin.Text = "";
        txtNombreProveedorFin.Text = "";
        txtObraIni.Text = "";
        txtObraIniNombre.Text = "";
        txtObraFin.Text = "";
        txtObraFinNombre.Text = "";
        txtOCIni.Text = "";
        txtOCFin.Text = "";
        txtAreaIni.Text = "";
        txtAreaIniNombre.Text = "";
        txtAreaFin.Text = "";
        txtAreaFinNombre.Text = "";
        txtSecIni.Text = "";
        txtSecIniNombre.Text = "";
        txtSecFin.Text = "";
        txtSecFinNombre.Text = "";

        txtProveedor.UpdateAfterCallBack = true;
        txtNombreProveedor.UpdateAfterCallBack = true;
        txtProveedorFin.UpdateAfterCallBack = true;
        txtNombreProveedorFin.UpdateAfterCallBack = true;
        txtObraIni.UpdateAfterCallBack = true;
        txtObraIniNombre.UpdateAfterCallBack = true;
        txtObraFin.UpdateAfterCallBack = true;
        txtObraFinNombre.UpdateAfterCallBack = true;
        txtOCIni.UpdateAfterCallBack = true;
        txtOCFin.UpdateAfterCallBack = true;
        txtAreaIni.UpdateAfterCallBack = true;
        txtAreaIniNombre.UpdateAfterCallBack = true;
        txtAreaFin.UpdateAfterCallBack = true;
        txtAreaFinNombre.UpdateAfterCallBack = true;
        txtSecIni.UpdateAfterCallBack = true;
        txtSecIniNombre.UpdateAfterCallBack = true;
        txtSecFin.UpdateAfterCallBack = true;
        txtSecFinNombre.UpdateAfterCallBack = true;
    }
    #endregion

    //#region txtCuenta_Change
    //protected void txtCuenta_Change(object sender, EventArgs e)
    //{
    //    try
    //    {
    //        Cuentas Obj = new Cuentas();
    //        Entity_Cuentas EntiCuentas = new Entity_Cuentas();

    //        EntiCuentas.IntEmpresa = txtEmpresa.Text == "" ? Contabilidad.SEMSession.GetInstance.IntEmpresa : Convert.ToInt32(txtEmpresa.Text);
    //        EntiCuentas.IntSucursal = hddSucursal.Value == "" ? Contabilidad.SEMSession.GetInstance.IntSucursal : Convert.ToInt32(hddSucursal.Value);
    //        EntiCuentas.StrCuenta = txtCuenta.Text;

    //        Entity_Cuentas CuentaByKey = Obj.GetByPrimaryKey(EntiCuentas);

    //        if (CuentaByKey != null)
    //        {
    //            txtCuenta.Text = CuentaByKey.StrCuenta;
    //            txtNombreCuenta.Text = CuentaByKey.StrNombre;
    //        }
    //        else
    //        {
    //            txtCuenta.Text = "";
    //            txtNombreCuenta.Text = "";
    //        }

    //        txtCuenta.UpdateAfterCallBack = true;
    //        txtNombreCuenta.UpdateAfterCallBack = true;

    //        Anthem.Manager.RegisterStartupScript(Page.GetType(), "focusCF", "document.all('ctl00_CPHBase_txtFechaInicial').focus()", true);

    //    }
    //    catch (System.IO.IOException ex)
    //    {

    //    }
    //}
    //#endregion

    #region txtProveedor_TextChanged
    protected void txtProveedor_TextChanged(object sender, EventArgs e)
    {
        try
        {
            Entity_Proveedor obj;
            obj = new Entity_Proveedor();
            Proveedor prov;
            prov = new Proveedor();

            obj.IntEmpresa = txtEmpresa.Text == "" ? Contabilidad.SEMSession.GetInstance.IntEmpresa : Convert.ToInt32(txtEmpresa.Text);
            obj.IntSucursal = hddSucursal.Value == "" ? Contabilidad.SEMSession.GetInstance.IntSucursal : Convert.ToInt32(hddSucursal.Value);
            obj.IntProveedor = txtProveedor.Text == "" ? 0 : Convert.ToInt32(txtProveedor.Text);
            obj = prov.Fill(obj);

            if (obj != null)
            {
                txtProveedor.Text = obj.IntProveedor.ToString ();
                txtNombreProveedor.Text = obj.StrNombre;
                txtProveedorFin.Text = txtProveedor.Text;
                txtNombreProveedorFin.Text = txtNombreProveedor.Text;
            }
            else
            {
                txtProveedor.Text = "";
                txtNombreProveedor.Text = "";
                txtProveedorFin.Text = "";
                txtNombreProveedorFin.Text = "";
            }

            txtProveedor.UpdateAfterCallBack = true;
            txtNombreProveedor.UpdateAfterCallBack = true;
            txtProveedorFin.UpdateAfterCallBack = true;
            txtNombreProveedorFin.UpdateAfterCallBack = true;

            Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtFechaInicialfocus", "document.all('ctl00_CPHFilters_txtFechaInicial').focus()", true);

            obj = null;
            prov = null;
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
            Entity_Proveedor obj;
            obj = new Entity_Proveedor();
            Proveedor prov;
            prov = new Proveedor();

            obj.IntEmpresa = txtEmpresa.Text == "" ? Contabilidad.SEMSession.GetInstance.IntEmpresa : Convert.ToInt32(txtEmpresa.Text);
            obj.IntSucursal = hddSucursal.Value == "" ? Contabilidad.SEMSession.GetInstance.IntSucursal : Convert.ToInt32(hddSucursal.Value);
            obj.IntProveedor = txtProveedorFin.Text == "" ? 0 : Convert.ToInt32(txtProveedorFin.Text);
            obj = prov.Fill(obj);

            if (obj != null)
            {
                txtProveedorFin.Text = obj.IntProveedor.ToString ();
                txtNombreProveedorFin.Text = obj.StrNombre;
                Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtFechaInicial2focus", "document.all('ctl00_CPHFilters_txtFechaInicial').focus()", true);
            }
            else
            {
                txtProveedorFin.Text = "";
                txtNombreProveedorFin.Text = "";
                Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtProveedorFinfocus", "document.all('ctl00_CPHFilters_txtProveedorFin').focus()", true);
            }

            txtProveedorFin.UpdateAfterCallBack = true;
            txtNombreProveedorFin.UpdateAfterCallBack = true;

            

            obj = null;
            prov = null;
        }
        catch (System.IO.IOException ex)
        {

        }
    }
    #endregion

   
    protected void lknAuxiliarMensualOC_Click(object sender, EventArgs e)
    {
        if (rbReporte.SelectedValue == "0")
        {
            string[] arrDatos;
            arrDatos = new string[5];
            String strParameters = "";

            DateTime FechaIni = DateTime.ParseExact(this.txtFechaInicial.Text, "dd/MM/yyyy", null);
            DateTime FechaFin = DateTime.ParseExact(this.txtFechaFinal.Text, "dd/MM/yyyy", null);
            int intEmpresa = txtEmpresa.Text == "" ? Contabilidad.SEMSession.GetInstance.IntEmpresa : Convert.ToInt32(txtEmpresa.Text);
            int intSucursal = Convert.ToInt32(hddSucursal.Value);

            arrDatos[0] = intEmpresa.ToString();
            arrDatos[1] = txtProveedor .Text =="" ? "0" : txtProveedor.Text;
            arrDatos[2] = txtProveedorFin.Text == "" ? "0" : txtProveedorFin.Text;
            arrDatos[3] = txtFechaInicial.Text;
            arrDatos[4] = txtFechaFinal.Text;

            string type = "pdf";

            if (toolbar.Check()) type = "xls";

            strParameters = String.Format("{0}[--]{1}[--]{2}[--]{3}[--]{4}", arrDatos);

            string strServerName = "http://" + HttpContext.Current.Request.ServerVariables["SERVER_NAME"].ToString() + ":" + HttpContext.Current.Request.ServerVariables["SERVER_PORT"].ToString() + "/Contabilidad/Utils/CRViewer.aspx";
            string strQueryString = string.Empty;
            strQueryString = "?type="+ type;
            strQueryString += "&report=Pages/Reportes/RelacionOCF/RelacionOCFacturaSinIva.rpt";
            strQueryString += "&db=VetecMarfilAdmin";
            strQueryString += "&parameters=" + strParameters;
            strQueryString += "&Titulos=RelacionOCFacturaSinIva";
            strQueryString += "&Crystal=85";

            strQueryString = strQueryString.Replace("'", "|");
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "rpt", "window.open('" + strServerName + strQueryString + "');", true);

            //else
            //{
            //    //TiposPoliza tp;
            //    //tp = new TiposPoliza();

            //    //string query = "";
            //    //query = tp.RptPolizasDetQry(intEmpresa, intEjercicio, intMes, intTipoPolIni, intTipoPolFin, PolIni, PolFin, intAfectada, intDesAfectada, intCancelada);

            //    //tp = null;

            //    //string queryString = "?query=" + query + "&type=xls";
            //    //Response.Redirect("../../../Utils/Excel.aspx" + queryString);
            //}
           
        }
        else
        {
            string[] arrDatos;
            arrDatos = new string[15];
            String strParameters = "";

            DateTime FechaIni = DateTime.ParseExact(this.txtFechaInicial.Text, "dd/MM/yyyy", null);
            DateTime FechaFin = DateTime.ParseExact(this.txtFechaFinal.Text, "dd/MM/yyyy", null);
            int intEmpresa = txtEmpresa.Text == "" ? Contabilidad.SEMSession.GetInstance.IntEmpresa : Convert.ToInt32(txtEmpresa.Text);
            int intSucursal = Convert.ToInt32(hddSucursal.Value);

            arrDatos[0] = intEmpresa.ToString();
            arrDatos[1] = txtProveedor.Text == "" ? "0" : txtProveedor.Text;
            arrDatos[2] = txtProveedorFin.Text == "" ? "0" : txtProveedorFin.Text;
            arrDatos[3] = txtColonia .Text =="" ? "0": txtColonia .Text;
            arrDatos[4] = txtColoniaFin .Text =="" ? "0": txtColoniaFin .Text;
            arrDatos[5] = txtSecIni .Text =="" ? "0" : txtSecIni .Text;
            arrDatos[6] = txtSecFin.Text == "" ? "0" : txtSecFin.Text;
            arrDatos[7] = hddIntObraIni.Value == "" ? "0" : hddIntObraIni.Value;
            arrDatos[8] = hddIntObraFin.Value == "" ? "0" : hddIntObraFin.Value;
            arrDatos[9] = txtAreaIni.Text == "" ? "0" : txtAreaIni.Text;
            arrDatos[10] = txtAreaFin.Text == "" ? "0" : txtAreaFin.Text;
            arrDatos[11] = txtOCIni.Text == "" ? "0" : txtOCIni.Text;
            arrDatos[12] = txtOCFin.Text == "" ? "0" : txtOCFin.Text;
            arrDatos[13] = txtFechaInicial.Text;
            arrDatos[14] = txtFechaFinal.Text;

            strParameters = String.Format("{0}[--]{1}[--]{2}[--]{3}[--]{4}[--]{5}[--]{6}[--]{7}[--]{8}[--]{9}[--]{10}[--]{11}[--]{12}[--]{13}[--]{14}", arrDatos);
            string  type = "pdf";
            if (toolbar.Check()) type = "xls";

            string strServerName = "http://" + HttpContext.Current.Request.ServerVariables["SERVER_NAME"].ToString() + ":" + HttpContext.Current.Request.ServerVariables["SERVER_PORT"].ToString() + "/Contabilidad/Utils/CRViewer.aspx";
            string strQueryString = string.Empty;
            strQueryString = "?type=" + type;
            strQueryString += "&report=Pages/Reportes/RelacionOCF/OrdenCompraFacturas.rpt";
            strQueryString += "&db=VetecMarfilAdmin";
            strQueryString += "&parameters=" + strParameters;
            strQueryString += "&Titulos=OrdenCompraFacturas";
            strQueryString += "&Crystal=85";

            strQueryString = strQueryString.Replace("'", "|");
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "rpt", "window.open('" + strServerName + strQueryString + "');", true);

            //else
            //{
            //    //string strServerName = "http://" + HttpContext.Current.Request.ServerVariables["SERVER_NAME"].ToString() + ":" + HttpContext.Current.Request.ServerVariables["SERVER_PORT"].ToString() + "/Comercial/Utils/Export.aspx";
            //    string strServerName = "http://" + HttpContext.Current.Request.ServerVariables["SERVER_NAME"].ToString() + ":" + HttpContext.Current.Request.ServerVariables["SERVER_PORT"].ToString() + "/Contabilidad/Utils/CRViewer.aspx";
            //    string strQueryString = string.Empty;
            //    strQueryString = "?type=xls";
            //    strQueryString += "&report=Pages/Reportes/RelacionOCF/OrdenCompraFacturas.rpt";
            //    strQueryString += "&db=VetecMarfilAdmin";
            //    strQueryString += "&parameters=" + strParameters;
            //    strQueryString += "&Titulos=RelacionOCF";
            //    strQueryString += "&Crystal=85";

            //    strQueryString = strQueryString.Replace("'", "|");
            //    Anthem.Manager.RegisterStartupScript(Page.GetType(), "rpt", "window.open('" + strServerName + strQueryString + "');", true);

            //    //OrdenCompra oc;
            //    //oc = new OrdenCompra();

            //    //string query = "";
            //    //query = oc.RptQry(intEmpresa, arrDatos[1], arrDatos[2], arrDatos[3], arrDatos[4], arrDatos[5], arrDatos[6], arrDatos[7], arrDatos[8], arrDatos[9], arrDatos[10], arrDatos[11], arrDatos[12], txtFechaInicial.Text,txtFechaFinal.Text);

            //    //oc = null;

            //    //string queryString = "?query=" + query + "&type=xls";
            //    //Response.Redirect("../../../Utils/Excel.aspx" + queryString);
            //}
            
        }
        
    }

    protected void txtObraIni_TextChanged(object sender, EventArgs e)
    {
        Entity_Obra obj;
        obj = new Entity_Obra();
        Obra obra;
        obra = new Obra();

        obj.IntEmpresa = Convert.ToInt32(txtEmpresa.Text);
        obj.IntSucursal = Convert.ToInt32(hddSucursal.Value);
        obj.IntObra = hddIntObraIni.Value != "" ? Convert.ToInt32(hddIntObraIni.Value) : 0;
        obj = obra.Fill(obj);

        if (obj != null)
        {
            hddIntObraIni.Value = obj.IntObra.ToString();
            txtObraIni.Text = obj.StrClave;
            txtObraIniNombre.Text = obj.StrNombre;
            hddIntObraFin.Value = hddIntObraIni.Value;
            txtObraFin.Text = txtObraIni.Text;
            txtObraFinNombre.Text = txtObraIniNombre.Text;
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtOCInifocus", "document.all('ctl00_CPHFilters_txtOCIni').focus()", true);
        }
        else
        {
            txtObraIni.Text = "";
            txtObraIniNombre.Text = "";
            txtObraFin.Text = "";
            txtObraFinNombre.Text = "";
            hddIntObraIni.Value = "";
            hddIntObraFin.Value = "";
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtObraIni2focus", "document.all('ctl00_CPHFilters_txtObraIni').focus()", true);
        }

        txtObraIni.UpdateAfterCallBack = true;
        txtObraIniNombre.UpdateAfterCallBack = true;
        txtObraFin.UpdateAfterCallBack = true;
        txtObraFinNombre.UpdateAfterCallBack = true;
        hddIntObraFin.UpdateAfterCallBack = true;
        hddIntObraIni.UpdateAfterCallBack = true;

        obj = null;
        obra = null;
    }
    protected void txtObraFin_TextChanged(object sender, EventArgs e)
    {
        Entity_Obra obj;
        obj = new Entity_Obra();
        Obra obra;
        obra = new Obra();

        obj.IntEmpresa = Convert.ToInt32(txtEmpresa.Text);
        obj.IntSucursal = Convert.ToInt32(hddSucursal.Value);
        obj.IntObra = hddIntObraFin.Value != "" ? Convert.ToInt32(hddIntObraFin.Value) : 0;
        obj = obra.Fill(obj);

        if (obj != null)
        {
            hddIntObraFin.Value = obj.IntObra.ToString();
            txtObraFin.Text = obj.StrClave; 
            txtObraFinNombre.Text = obj.StrNombre;
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtOCIni2focus", "document.all('ctl00_CPHFilters_txtOCIni').focus()", true);
        }
        else
        {
            hddIntObraFin.Value = "";
            txtObraFin.Text = "";
            txtObraFinNombre.Text = "";
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtObraFinfocus", "document.all('ctl00_CPHFilters_txtObraFin').focus()", true);
        }

        hddIntObraFin.UpdateAfterCallBack = true;
        txtObraFin.UpdateAfterCallBack = true;
        txtObraFinNombre.UpdateAfterCallBack = true;

        obj = null;
        obra = null;
    }
    protected void txtAreaIni_TextChanged(object sender, EventArgs e)
    {
        Entity_Area obj;
        obj = new Entity_Area();
        Area area;
        area = new Area();

        obj.intEmpresa  = Convert.ToInt32(txtEmpresa.Text);
        obj.IntSucursal = Convert.ToInt32(hddSucursal.Value);
        obj.intArea = txtAreaIni.Text != "" ? Convert.ToInt32(txtAreaIni.Text) : 0;
        obj = area.Fill(obj);

        if (obj != null)
        {
            txtAreaIni.Text = obj.intArea.ToString();
            txtAreaIniNombre.Text = obj.strNombre;
            txtAreaFin.Text = txtAreaIni.Text;
            txtAreaFinNombre.Text = txtAreaIniNombre.Text;
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtColonia1focus", "document.all('ctl00_CPHFilters_txtColonia').focus()", true);
        }
        else 
        {
            txtAreaIni.Text = "";
            txtAreaIniNombre.Text = "";
            txtAreaFin.Text = "";
            txtAreaFinNombre.Text = "";
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtAreaIni2focus", "document.all('ctl00_CPHFilters_txtAreaIni').focus()", true);
        }

        txtAreaIni.UpdateAfterCallBack = true;
        txtAreaIniNombre.UpdateAfterCallBack = true;
        txtAreaFin.UpdateAfterCallBack = true;
        txtAreaFinNombre.UpdateAfterCallBack = true;

    }
    protected void txtAreaFin_TextChanged(object sender, EventArgs e)
    {
        Entity_Area obj;
        obj = new Entity_Area();
        Area area;
        area = new Area();

        obj.intEmpresa = Convert.ToInt32(txtEmpresa.Text);
        obj.IntSucursal = Convert.ToInt32(hddSucursal.Value);
        obj.intArea = txtAreaFin.Text != "" ? Convert.ToInt32(txtAreaFin.Text) : 0;
        obj = area.Fill(obj);

        if (obj != null)
        {
            txtAreaFin.Text = obj.intArea.ToString();
            txtAreaFinNombre.Text = obj.strNombre;
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtColonia4focus", "document.all('ctl00_CPHFilters_txtColonia').focus()", true);
        }
        else
        {
            txtAreaFin.Text = "";
            txtAreaFinNombre.Text = "";
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtAreaFin2focus", "document.all('ctl00_CPHFilters_txtAreaFin').focus()", true);
        }

        txtAreaFin.UpdateAfterCallBack = true;
        txtAreaFinNombre.UpdateAfterCallBack = true;
    }

    #region txtColonia_TextChanged
    protected void txtColonia_TextChanged(object sender, EventArgs e)
    {
        Colonia Col = new Colonia();
        Entity_Colonia obj;
        obj = new Entity_Colonia();

        obj.IntEmpresa = Convert.ToInt32(txtEmpresa.Text);
        obj.IntSucursal = Convert.ToInt32(hddSucursal.Value);
        obj.intColonia = txtColonia.Text != "" ? Convert.ToInt32(txtColonia.Text) : 0;

        obj = Col.Sel(obj);

        if (obj == null)
        {
            txtColonia.Text = "";
            txtColoniaNombre.Text = "";
            txtColoniaFin.Text = "";
            txtColoniaNombreFin.Text = "";
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtColonia3focus", "document.all('ctl00_CPHFilters_txtColonia').focus()", true);
        }
        else
        {
            txtColonia.Text = obj.intColonia.ToString();
            txtColoniaNombre.Text = obj.strNombre;
            txtColoniaFin.Text = txtColonia.Text;
            txtColoniaNombreFin.Text = txtColoniaNombre.Text;
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtSecInifocus", "document.all('ctl00_CPHFilters_txtSecIni').focus()", true);
        }

        txtColonia.UpdateAfterCallBack = true;
        txtColoniaNombre.UpdateAfterCallBack = true;
        txtColoniaFin.UpdateAfterCallBack = true;
        txtColoniaNombreFin.UpdateAfterCallBack = true;
    }
    #endregion

    #region txtColoniaFin_TextChanged
    protected void txtColoniaFin_TextChanged(object sender, EventArgs e)
    {
        Colonia Col = new Colonia();
        Entity_Colonia obj;
        obj = new Entity_Colonia();

        obj.IntEmpresa = Convert.ToInt32(txtEmpresa.Text);
        obj.IntSucursal = Convert.ToInt32(hddSucursal.Value);
        obj.intColonia = txtColoniaFin.Text != "" ? Convert.ToInt32(txtColoniaFin.Text) : 0;

        obj = Col.Sel(obj);

        if (obj == null)
        {
            this.txtColoniaFin.Text = "";
            this.txtColoniaNombreFin.Text = "";
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtColoniaFinfocus", "document.all('ctl00_CPHFilters_txtColoniaFin').focus()", true);
        }
        else
        {
            this.txtColoniaFin.Text = obj.intColonia.ToString();
            this.txtColoniaNombreFin.Text = obj.strNombre;
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtSecIni2focus", "document.all('ctl00_CPHFilters_txtSecIni').focus()", true);
        }

        this.txtColoniaFin.UpdateAfterCallBack = true;
        this.txtColoniaNombreFin.UpdateAfterCallBack = true;
    }
    #endregion

    protected void txtSecIni_TextChanged(object sender, EventArgs e)
    {
        Entity_Sector obj;
        obj = new Entity_Sector();
        Sector sec;
        sec = new Sector();

        obj.IntEmpresa = Convert.ToInt32(txtEmpresa.Text);
        obj.IntSucursal = Convert.ToInt32(hddSucursal.Value);
        obj.IntSector = txtSecIni.Text != "" ? Convert.ToInt32(txtSecIni.Text) : 0;

        obj = sec.Fill(obj);

        if (obj != null)
        {
            txtSecIni.Text = obj.IntSector.ToString();
            txtSecIniNombre.Text = obj.StrNombre;
            txtSecFin.Text = txtSecIni.Text;
            txtSecFinNombre.Text = txtSecIniNombre.Text;
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "lknAuxiliarMensualOCfocus", "document.all('ctl00_CPHFilters_lknAuxiliarMensualOC').focus()", true);
        }
        else
        {
            txtSecIni.Text = "";
            txtSecIniNombre.Text = "";
            txtSecFin.Text = "";
            txtSecFinNombre.Text = "";
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtSecInifocus", "document.all('ctl00_CPHFilters_txtSecIni').focus()", true);
        }

        txtSecIni.UpdateAfterCallBack = true;
        txtSecIniNombre.UpdateAfterCallBack = true;
        txtSecFin.UpdateAfterCallBack = true;
        txtSecFinNombre.UpdateAfterCallBack = true;

        obj = null;
        sec = null;
    }

    protected void txtSecFin_TextChanged(object sender, EventArgs e)
    {
        Entity_Sector obj;
        obj = new Entity_Sector();
        Sector sec;
        sec = new Sector();

        obj.IntEmpresa = Convert.ToInt32(txtEmpresa.Text);
        obj.IntSucursal = Convert.ToInt32(hddSucursal.Value);
        obj.IntSector = txtSecFin.Text != "" ? Convert.ToInt32(txtSecFin.Text) : 0;

        obj = sec.Fill(obj);

        if (obj != null)
        {
            txtSecFin.Text = obj.IntSector.ToString();
            txtSecFinNombre.Text = obj.StrNombre;
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "lknAuxiliarMensualOC2focus", "document.all('ctl00_CPHFilters_lknAuxiliarMensualOC').focus()", true);
        }
        else
        {
            txtSecFin.Text = "";
            txtSecFinNombre.Text = "";
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtSecFin3focus", "document.all('ctl00_CPHFilters_txtSecFin').focus()", true);
        }

        txtSecFin.UpdateAfterCallBack = true;
        txtSecFinNombre.UpdateAfterCallBack = true;

        obj = null;
        sec = null;
    }
    protected void txtOCIni_TextChanged(object sender, EventArgs e)
    {
        txtOCFin.Text = txtOCIni.Text;
        txtOCFin.UpdateAfterCallBack = true;
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtAreaIni1focus", "document.all('ctl00_CPHFilters_txtAreaIni').focus()", true);
        
    }
}
