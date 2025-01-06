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

public partial class Contabilidad_Compra_Reportes_Clientes : System.Web.UI.Page
{
    Report_Pages_Base toolbar;
    protected void Page_Load(object sender, EventArgs e)
    {
        toolbar = (Report_Pages_Base)this.Master;
        if (!IsPostBack)
        {

            btnExpandReportes.Attributes.Add("onClick", "ReportVisible(this,'" + pnlReportes1.ClientID + "');");
            Colonias();
            TipoCredito();
            txtFechaInicial.Text = DateTime.Now.ToString("dd/MM/yyyy");
            txtFechaFinal.Text = DateTime.Now.ToString("dd/MM/yyyy");
            txtFechaCorte.Text = DateTime.Now.ToString("dd/MM/yyyy");
            txtEmpresa.Text = Contabilidad.SEMSession.GetInstance.IntEmpresa.ToString();
            txtEmpresa_TextChange(null, null);
        }

        ImgDate.OnClientClick = "if(self.gfPop)gfPop.fPopCalendar(document.getElementById('" + txtFechaInicial.ClientID + "')); giDatePos=0; return false;";
        ImgDateFin.OnClientClick = "if(self.gfPop)gfPop.fPopCalendar(document.getElementById('" + txtFechaFinal.ClientID + "')); giDatePos=0; return false;";
        ImgDateCorte.OnClientClick = "if(self.gfPop)gfPop.fPopCalendar(document.getElementById('" + txtFechaCorte.ClientID + "')); giDatePos=0; return false;";
    }


    private void Colonias()
    {
        List list;
        list = new List();

        cboColonia.DataSource = list.Colonia(Contabilidad.SEMSession.GetInstance.IntEmpresa, Contabilidad.SEMSession.GetInstance.IntSucursal);
        cboColonia.DataTextField = "strNombre";
        cboColonia.DataValueField = "Id";
        cboColonia.DataBind();

        cboColonia.Items.Insert(0, new ListItem("-- Seleccione --", "0"));
        cboColonia.SelectedIndex = 0;

        cboColonia.UpdateAfterCallBack = true;

        list = null;
    }

    private void TipoCredito()
    {
        List list;
        list = new List();

        cboTipoCredito.DataSource = list.TipoCredito(Contabilidad.SEMSession.GetInstance.IntEmpresa, Contabilidad.SEMSession.GetInstance.IntSucursal);
        cboTipoCredito.DataTextField = "strNombre";
        cboTipoCredito.DataValueField = "Id";
        cboTipoCredito.DataBind();

        cboTipoCredito.Items.Insert(0, new ListItem("-- Seleccione --", "0"));
        cboTipoCredito.SelectedIndex = 0;

        cboTipoCredito.UpdateAfterCallBack = true;

        list = null;
    }


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
        txtFechaInicial.Text = DateTime.Now.ToString("dd/MM/yyyy");
        txtFechaFinal.Text = DateTime.Now.ToString("dd/MM/yyyy");
        txtFechaCorte.Text = DateTime.Now.ToString("dd/MM/yyyy");
        cboTipoCredito.SelectedIndex = -1;
        cboColonia.SelectedIndex = -1;

        txtFechaInicial.UpdateAfterCallBack = true;
        txtFechaFinal.UpdateAfterCallBack = true;
        txtFechaCorte.UpdateAfterCallBack = true;
        cboTipoCredito.UpdateAfterCallBack = true;
        cboColonia.UpdateAfterCallBack = true;

    }
    #endregion

    protected void lknClientes_Click(object sender, EventArgs e)
    {
        string[] arrDatos;
        String strParameters = "";

        int intColonia = Convert.ToInt32(cboColonia.SelectedValue);
        int intTipoCredito = Convert.ToInt32(cboTipoCredito.SelectedValue);
        string FechaIni = this.txtFechaInicial.Text;
        string FechaFin = this.txtFechaFinal.Text;
        int intEmpresa =  txtEmpresa.Text == "" ? Contabilidad.SEMSession.GetInstance.IntEmpresa : Convert.ToInt32(txtEmpresa.Text);
        int intSucursal = Convert.ToInt32(hddSucursal.Value); 

        if (!toolbar.Check())
        {
            arrDatos = new string[6];
            arrDatos[0] = intEmpresa.ToString ();
            arrDatos[1] = intSucursal.ToString ();
            arrDatos[2] = intColonia.ToString();
            arrDatos[3] = intTipoCredito.ToString();
            arrDatos[4] = FechaIni.ToString ();
            arrDatos[5] = FechaFin.ToString();

            strParameters = String.Format("{0}[--]{1}[--]{2}[--]{3}[--]{4}[--]{5}", arrDatos);

            string strServerName = "http://" + HttpContext.Current.Request.ServerVariables["SERVER_NAME"].ToString() + ":" + HttpContext.Current.Request.ServerVariables["SERVER_PORT"].ToString() + "/Contabilidad/Utils/CRViewer.aspx";
            string strQueryString = string.Empty;
            strQueryString = "?type=pdf";
            strQueryString += "&report=Pages/Reportes/rptSaldoClientes.rpt";
            strQueryString += "&db=VetecMarfil";
            strQueryString += "&parameters=" + strParameters;
            //strQueryString += "&Titulos=ContraRecibo";

            strQueryString = strQueryString.Replace("'", "|");
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "rpt", "window.open('" + strServerName + strQueryString + "');", true);
        }
        else
        {
            Clientes cte;
            cte= new Clientes();
            string query;
            query = cte.ExportAnaliticoComprasProv (intColonia, intTipoCredito,FechaIni,FechaFin,intEmpresa,intSucursal);

            cte = null;

            string queryString = "?query=" + query + "&type=xls";
            Response.Redirect("../../../Utils/Excel.aspx" + queryString);
        }
    }
    protected void lknSaldo_Click(object sender, EventArgs e)
    {


        string[] arrDatos;
        String strParameters = "";

        int intColonia = Convert.ToInt32(cboColonia.SelectedValue);
        int intTipoCredito = Convert.ToInt32(cboTipoCredito.SelectedValue);
        string FechaCorte = this.txtFechaCorte.Text;
        int intEmpresa = txtEmpresa.Text == "" ? Contabilidad.SEMSession.GetInstance.IntEmpresa : Convert.ToInt32(txtEmpresa.Text);
        int intSucursal = Convert.ToInt32(hddSucursal.Value); 

        if (!toolbar.Check())
        {
            Clientes cte;
            cte = new Clientes();
            string query;

            arrDatos = new string[4];
            arrDatos[0] = intEmpresa.ToString();
            arrDatos[1] = "0";
            arrDatos[2] = "0";
            arrDatos[3] = txtFechaCorte.Text == "" ? "0" : txtFechaCorte.Text;
             
            strParameters = String.Format("{0}[--]{1}[--]{2}[--]{3}", arrDatos);

            string strServerName = "http://" + HttpContext.Current.Request.ServerVariables["SERVER_NAME"].ToString() + ":" + HttpContext.Current.Request.ServerVariables["SERVER_PORT"].ToString() + "/Contabilidad/Utils/CRViewer.aspx";
            string strQueryString = string.Empty;
            strQueryString = "?type=pdf";
            strQueryString += "&report=Pages/Reportes/rptSaldo.rpt";
            strQueryString += "&db=VetecMarfil";
            strQueryString += "&parameters=" + strParameters;
            //strQueryString += "&Titulos=ContraRecibo";

            strQueryString = strQueryString.Replace("'", "|");
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "rpt", "window.open('" + strServerName + strQueryString + "');", true);
        }
        else
        {
            Clientes cte;
            cte = new Clientes();
            string query;

            query = cte.ExportSaldo(intEmpresa, FechaCorte);

            cte = null;

            string queryString = "?query=" + query + "&type=xls";
            Response.Redirect("../../../Utils/Excel.aspx" + queryString);
        }

    }
}
