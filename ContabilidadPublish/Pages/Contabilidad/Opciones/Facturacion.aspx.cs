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

public partial class Pages_Reportes_Facturacion_Facturacion : System.Web.UI.Page
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
            
            JavaScript();
        }
        ImgDate.OnClientClick = "if(self.gfPop)gfPop.fPopCalendar(document.getElementById('" + txtFechaInicial.ClientID + "')); giDatePos=0; return false;";
        ImgDateFin.OnClientClick = "if(self.gfPop)gfPop.fPopCalendar(document.getElementById('" + txtFechaFinal.ClientID + "')); giDatePos=0; return false;";
    }

    #region JavaScript
    private void JavaScript()
    {  
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtFechaInicial", "var objText = new VetecText('" + txtFechaInicial.ClientID + "', 'number', 18);", true);
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtFechaFinal", "var objText = new VetecText('" + txtFechaFinal.ClientID + "', 'number', 18);", true);        
    }
    #endregion  

    protected void lknFacturacion_Click(object sender, EventArgs e)
    {
        string[] arrDatos = new string[2];
        String strParameters = "";

        //DateTime FechaIni = DateTime.ParseExact(this.txtFechaInicial.Text, "dd/MM/yyyy", null);
        //DateTime FechaFin = DateTime.ParseExact(this.txtFechaFinal.Text, "dd/MM/yyyy", null);

        string fechaIni = this.txtFechaInicial.Text;
        string fechaFin = this.txtFechaFinal.Text;
     
        //arrDatos[0] = FechaIni.ToString("dd/MM/yyyy");
        //arrDatos[1] = FechaFin.ToString("dd/MM/yyyy");

        arrDatos[0] = fechaIni;
        arrDatos[1] = fechaFin;
        

        //if (!toolbar.Check())
        //{
            strParameters = String.Format("{0}[--]{1}", arrDatos);

            string strServerName = "http://" + HttpContext.Current.Request.ServerVariables["SERVER_NAME"].ToString() + ":" + HttpContext.Current.Request.ServerVariables["SERVER_PORT"].ToString() + "/Contabilidad/Utils/RExport.aspx";
            string strQueryString = string.Empty;
            strQueryString = "?type=xls";
            strQueryString += "&parameters=" + strParameters;
            strQueryString += "&intEmpresa=0";
            strQueryString += "&intSucursal=0";
            strQueryString += "&intVersion=0";
            strQueryString += "&strClassName=DACFactorizacion";
            strQueryString += "&Titulos=Reporte de Facturacion";
            strQueryString += "&NombresSheets=Cliente,Direccion,Direcccion Lote";
            strQueryString = strQueryString.Replace("'", "|");
            
            
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "rpt", "window.open('" + strServerName + strQueryString + "');", true);
        //}
        //else
        //{
        //    Clientes cte;
        //    cte = new Clientes();
        //    string query = string.Empty;
        //    query = String.Format("VetecMarfilAdmin.dbo.usp_INCN5000_Rep_Aux_Mensual_OC {0},'{1}','{2}','{3}',{4},{5},{6},{7},{8},{9},{10},{11},{12}", arrDatos);
        //    //query = cte.rptAuxiliarMensualOC (intEmpresa,txtCuenta.Text != "" ? txtCuenta.Text : "21010001",FechaIni,FechaFin);

        //    cte = null;

        //    string queryString = "?query=" + query + "&type=xls";
        //    Response.Redirect("../../../Utils/Excel.aspx" + queryString);
        //}
    }
}
