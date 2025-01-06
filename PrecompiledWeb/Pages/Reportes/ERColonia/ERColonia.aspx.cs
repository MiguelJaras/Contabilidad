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
using iTextSharp.text;
using System.Windows.Forms;
using System.Xml.Linq;
using Contabilidad.DataAccess;
//using static System.Windows.Forms.VisualStyles.VisualStyleElement;

public partial class Contabilidad_Compra_Reportes_ER : System.Web.UI.Page
{
    Report_Pages_Base toolbar;
    protected void Page_Load(object sender, EventArgs e)
    {
        toolbar = (Report_Pages_Base)this.Master;
        Anthem.Manager.Register(this);
        if (!IsPostBack && !IsCallback)
        { 
            btnExpandReportes.Attributes.Add("onClick", "ReportVisible(this,'" + pnlReportes1.ClientID + "');"); 
        }

        JavaScript();
    }

    #region JavaScript
    private void JavaScript()
    {
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "objUtils", "var objUtils = new VetecUtils();", true);
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtColonia", "var objText = new VetecText('" + txtColonia.ClientID + "', 'number', 10);", true);
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtSector", "var objText = new VetecText('" + txtSector.ClientID + "', 'number', 10);", true);
       
    }
    #endregion  

    
    #region Clear
    private void Clear()
    {
        
       
        txtColonia.Text = "";
        txtColoniaNombre.Text = "";
        txtSector.Text = "";
        txtSectorNombre.Text = "";
        chkAditiva.Checked = false;
        chkResumen.Checked = false;
       
        txtSector.UpdateAfterCallBack = true;
        txtSectorNombre.UpdateAfterCallBack = true;
        txtColonia.UpdateAfterCallBack = true;
        txtColoniaNombre.UpdateAfterCallBack = true;
    }
    #endregion
   
    protected void lknEstadoResultados_Click(object sender, EventArgs e)
    {
        string[] arrDatos;
        string strParameters = "";

        arrDatos = new string[4];
        arrDatos[0] = txtColonia.Text;
        arrDatos[1] = txtSector.Text;
        arrDatos[2] = chkResumen.Checked ? "1" : "0";
        arrDatos[3] = chkAditiva.Checked ? "1" : "0";

        strParameters = String.Format("{0}[--]{1}[--]{2}[--]{3}", arrDatos);

        string strServerName = "http://" + HttpContext.Current.Request.ServerVariables["SERVER_NAME"].ToString() + ":" + HttpContext.Current.Request.ServerVariables["SERVER_PORT"].ToString() + "/Contabilidad/Utils/CRViewer.aspx";
        string strQueryString = string.Empty;
        if (!toolbar.Check())
        {   strQueryString = "?type=pdf";}
        else { strQueryString = "?type=xls"; }
        strQueryString += "&report=Pages/Reportes/ERColonia/estadoDeResultados2024.rpt";
        strQueryString += "&db=VetecMarfil";
        strQueryString += "&parameters=" + strParameters;
        strQueryString += "&Titulos=Reporte de Estado de Resultados por Colonia'";

        strQueryString = strQueryString.Replace("'", "|");
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "rpt", "window.open('" + strServerName + strQueryString + "');", true);

    }

  
   
    #region txtColonia_TextChanged
    protected void txtColonia_TextChanged(object sender, EventArgs e)
    {
        Colonia Col = new Colonia();
        Entity_Colonia obj;
        obj = new Entity_Colonia();

        obj.intColonia = txtColonia.Text != "" ? Convert.ToInt32(txtColonia.Text) : 0;

        obj = Col.Sel(obj);

        if (obj == null)
        {
            txtColonia.Text = "";
            txtColoniaNombre.Text = "";
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtColonia3focus", "document.all('ctl00_CPHFilters_txtColonia').focus()", true);
        }
        else
        {
            txtColonia.Text = obj.intColonia.ToString();
            txtColoniaNombre.Text = obj.strNombre;
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtSectorfocus", "document.all('ctl00_CPHFilters_txtSector').focus()", true);
        }
        txtColonia.UpdateAfterCallBack = true;
        txtColoniaNombre.UpdateAfterCallBack = true;
    }
    #endregion


    protected void txtSector_TextChanged(object sender, EventArgs e)
    {
        Entity_Sector obj;
        obj = new Entity_Sector();
        Sector sec;
        sec = new Sector();

        //obj.IntEmpresa = Convert.ToInt32(txtEmpresa.Text);
        //obj.IntSucursal = Convert.ToInt32(hddSucursal.Value);
        obj.IntSector = txtSector.Text != "" ? Convert.ToInt32(txtSector.Text) : 0;

        obj = sec.Fill(obj);

        if (obj != null)
        {
            txtSector.Text = obj.IntSector.ToString();
            txtSectorNombre.Text = obj.StrNombre;
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "lknEstadoResultadosfocus", "document.all('ctl00_CPHFilters_lknEstadoResultados').focus()", true);
        }
        else
        {
            txtSector.Text = "";
            txtSectorNombre.Text = "";
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtSectorfocus", "document.all('ctl00_CPHFilters_txtSector').focus()", true);
        }
        txtSector.UpdateAfterCallBack = true;
        txtSectorNombre.UpdateAfterCallBack = true;

        obj = null;
        sec = null;
    }

}
