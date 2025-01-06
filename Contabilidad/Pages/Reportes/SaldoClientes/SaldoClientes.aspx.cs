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

public partial class Contabilidad_Compra_Reportes_SaldoClientes : System.Web.UI.Page
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
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtCuenta", "var objText = new VetecText('" + txtCuenta.ClientID + "', 'number', 15);", true);
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtClave", "var objText = new VetecText('" + txtClave.ClientID + "', 'number', 25);", true);
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtClaveFin", "var objText = new VetecText('" + txtClaveFin.ClientID + "', 'number', 25);", true);
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtColonia", "var objText = new VetecText('" + txtColonia.ClientID + "', 'number', 8);", true);
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtColoniaFin", "var objText = new VetecText('" + txtColoniaFin.ClientID + "', 'number', 8);", true);
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtFechaInicial", "var objText = new VetecText('" + txtFechaInicial.ClientID + "', 'number', 18);", true);
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtFechaFinal", "var objText = new VetecText('" + txtFechaFinal.ClientID + "', 'number', 18);", true);
  
        if (!IsPostBack && !IsCallback)
        {
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "focusss", "document.all('ctl00_CPHFilters_txtEmpresa').focus()", true);
        }
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
        txtCuenta.Text = "";
        txtFechaInicial.Text = DateTime.Now.ToString("dd/MM/yyyy");
        txtFechaFinal.Text = DateTime.Now.ToString("dd/MM/yyyy");
        txtClave.Text = "0";
        txtClaveFin.Text = "0";
        txtNombre.Text = "";
        txtNombreFin.Text = "";

        txtColonia.Text = "0";
        txtColoniaFin.Text = "0";
        txtColoniaNombre.Text = "";
        txtColoniaNombreFin.Text = "";


        txtCuenta.UpdateAfterCallBack = true;
        txtFechaInicial.UpdateAfterCallBack = true;
        txtFechaFinal.UpdateAfterCallBack = true;

        txtClave.UpdateAfterCallBack = true;
        txtClaveFin.UpdateAfterCallBack = true;
        txtNombre.UpdateAfterCallBack = true;
        txtNombreFin.UpdateAfterCallBack = true; 
        txtColonia.UpdateAfterCallBack = true;
        txtColoniaFin.UpdateAfterCallBack = true;
        txtColoniaNombre.UpdateAfterCallBack = true;
        txtColoniaNombreFin.UpdateAfterCallBack = true;
       

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

            Anthem.Manager.RegisterStartupScript(Page.GetType(), "focusCF", "document.all('ctl00_CPHBase_txtFechaInicial').focus()", true);

        }
        catch (System.IO.IOException ex)
        {

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
            this.txtClaveFin.Text = "0";
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
        Obra obra = new Obra();
        Entity_Obra obj;
        obj = new Entity_Obra();

        obj.IntEmpresa = Convert.ToInt32(txtEmpresa.Text);
        obj.IntSucursal = Convert.ToInt32(hddSucursal.Value);
        obj.StrClave = txtClave.Text;

        obj = obra.GetByCode(obj);

        if (obj == null)
        {
            this.txtClave.Text = "0";
            this.txtNombre.Text = "";
            txtClaveFin.Text = "0";
            txtNombreFin.Text = "";
        }
        else
        {
            this.txtClave.Text = obj.StrClave;
            this.txtNombre.Text = obj.StrNombre;
            txtClaveFin.Text = txtClave.Text;
            txtNombreFin.Text = txtNombre.Text;
        }

        this.txtClave.UpdateAfterCallBack = true;
        this.txtNombre.UpdateAfterCallBack = true;
        txtClaveFin.UpdateAfterCallBack = true;
        txtNombreFin.UpdateAfterCallBack = true;
    }
    #endregion

    #region txtColonia_TextChanged
    protected void txtColonia_TextChanged(object sender, EventArgs e)
    {
        Colonia Col = new Colonia();
        Entity_Colonia obj;
        obj = new Entity_Colonia();

        obj.IntEmpresa = Convert.ToInt32(txtEmpresa.Text);
        obj.IntSucursal = Convert.ToInt32(hddSucursal.Value);
        obj.intColonia = txtColonia.Text != "" ? Convert.ToInt32(txtColonia.Text): 0;

        obj = Col.Fill(obj);

        if (obj == null)
        {
            this.txtColonia.Text = "0";
            this.txtColoniaNombre.Text = "";
            txtColoniaFin.Text = "0";
            txtColoniaNombreFin.Text = "";
        }
        else
        {
            this.txtColonia.Text = obj.intColonia.ToString();
            this.txtColoniaNombre.Text = obj.strNombre;
            txtColoniaFin.Text = txtColonia.Text;
            txtColoniaNombreFin.Text = txtColoniaNombre.Text;
        }

        this.txtColonia.UpdateAfterCallBack = true;
        this.txtColoniaNombre.UpdateAfterCallBack = true;
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
        obj.intColonia = txtColoniaFin.Text != "" ? Convert.ToInt32(txtColoniaFin.Text):0;

        obj = Col.Fill(obj);

        if (obj == null)
        {
            this.txtColoniaFin.Text = "0";
            this.txtColoniaNombreFin.Text = "";
        }
        else
        {
            this.txtColoniaFin.Text = obj.intColonia.ToString();
            this.txtColoniaNombreFin.Text = obj.strNombre;
        }

        this.txtColoniaFin.UpdateAfterCallBack = true;
        this.txtColoniaNombreFin.UpdateAfterCallBack = true;
    }
    #endregion

    protected void lknAuxiliarMensualOC_Click(object sender, EventArgs e)
    {
        string[] arrDatos;
        arrDatos = new string[13];
        String strParameters = ""; 
         
        DateTime FechaIni = DateTime.ParseExact(this.txtFechaInicial.Text, "dd/MM/yyyy", null);
        DateTime FechaFin = DateTime.ParseExact(this.txtFechaFinal.Text, "dd/MM/yyyy", null); 
        int intEmpresa =  txtEmpresa.Text == "" ? Contabilidad.SEMSession.GetInstance.IntEmpresa : Convert.ToInt32(txtEmpresa.Text);
        int intSucursal = Convert.ToInt32(hddSucursal.Value);

        arrDatos[0] = intEmpresa.ToString();
        arrDatos[1] = txtCuenta.Text != "" ? txtCuenta.Text : "21010001";
        arrDatos[2] = FechaIni.ToString("dd/MM/yyyy");
        arrDatos[3] = FechaFin.ToString("dd/MM/yyyy");
        arrDatos[4] = "0";
        arrDatos[5] = "0";
        arrDatos[6] = txtColonia.Text == "" ? "0" : txtColonia.Text;//colini
        arrDatos[7] = txtColoniaFin.Text == "" ? "0" : txtColoniaFin.Text;//colfin 
        arrDatos[8] = txtClave.Text == "" ? "0" : txtClave.Text;//SectorIni
        arrDatos[9] = txtClaveFin.Text == "" ? "0" : txtClaveFin.Text;//SectorFin
        arrDatos[10] = "0";
        arrDatos[11] = "0";
        arrDatos[12] = "0";

        if (!toolbar.Check())
        {                                    
            strParameters = String.Format("{0}[--]{1}[--]{2}[--]{3}[--]{4}[--]{5}[--]{6}[--]{7}[--]{8}[--]{9}[--]{10}[--]{11}[--]{12}", arrDatos);

            string strServerName = "http://" + HttpContext.Current.Request.ServerVariables["SERVER_NAME"].ToString() + ":" + HttpContext.Current.Request.ServerVariables["SERVER_PORT"].ToString() + "/Contabilidad/Utils/CRViewer.aspx";
            string strQueryString = string.Empty;
            strQueryString = "?type=pdf";
            strQueryString += "&report=Pages/Reportes/SaldoClientes/AuxiliarOC.rpt";
            strQueryString += "&db=VetecMarfilAdmin";
            strQueryString += "&parameters=" + strParameters;
            //strQueryString += "&Titulos=ContraRecibo";

            strQueryString = strQueryString.Replace("'", "|");
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "rpt", "window.open('" + strServerName + strQueryString + "');", true);
        }
        else
        {
            Clientes cte;
            cte= new Clientes();
            string query = string.Empty;
            query = String.Format("VetecMarfilAdmin.dbo.usp_INCN5000_Rep_Aux_Mensual_OC {0},'{1}','{2}','{3}',{4},{5},{6},{7},{8},{9},{10},{11},{12}", arrDatos);
            //query = cte.rptAuxiliarMensualOC (intEmpresa,txtCuenta.Text != "" ? txtCuenta.Text : "21010001",FechaIni,FechaFin);

            cte = null;

            string queryString = "?query=" + query + "&type=xls";
            Response.Redirect("../../../Utils/Excel.aspx" + queryString);
        }
    }
    
}
