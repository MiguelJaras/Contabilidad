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

public partial class Contabilidad_Compra_Reportes_Cuentas : System.Web.UI.Page
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
            JavaScript();
        }
    }

    #region JavaScript
    private void JavaScript()
    {
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtEmpresa", "var objText = new VetecText('" + txtEmpresa.ClientID + "', 'number', 4);", true);
  
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
        cboNivel.SelectedValue = "1"; 
        cboNivel.UpdateAfterCallBack = true; 
    }
    #endregion

    protected void lknFac_Click(object sender, EventArgs e)
    {
        string[] arrDatos;
        arrDatos = new string[2];
        String strParameters = ""; 
         
        int intEmpresa =  txtEmpresa.Text == "" ? Contabilidad.SEMSession.GetInstance.IntEmpresa : Convert.ToInt32(txtEmpresa.Text);
        int intNivel = Convert.ToInt32(cboNivel.SelectedValue);
        arrDatos[0] = intEmpresa.ToString();
        arrDatos[1] = intNivel.ToString();
       
        strParameters = String.Format("{0}[--]{1}", arrDatos);
        if (!toolbar.Check())
        {                                               
            string strServerName = "http://" + HttpContext.Current.Request.ServerVariables["SERVER_NAME"].ToString() + ":" + HttpContext.Current.Request.ServerVariables["SERVER_PORT"].ToString() + "/Contabilidad/Utils/CRViewer.aspx";
            string strQueryString = string.Empty;
            strQueryString = "?type=pdf";
            strQueryString += "&report=Pages/Reportes/Cuentas/Cuentas.rpt";
            strQueryString += "&db=VetecMarfilAdmin";
            strQueryString += "&parameters=" + strParameters;

            strQueryString = strQueryString.Replace("'", "|");
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "rpt", "window.open('" + strServerName + strQueryString + "');", true);
        }
        else
        {
            string strServerName = "http://" + HttpContext.Current.Request.ServerVariables["SERVER_NAME"].ToString() + ":" + HttpContext.Current.Request.ServerVariables["SERVER_PORT"].ToString() + "/Contabilidad/Utils/CRViewer.aspx";
            string strQueryString = string.Empty;
            strQueryString = "?type=xls";
            strQueryString += "&report=Pages/Reportes/Cuentas/Cuentas.rpt";
            strQueryString += "&db=VetecMarfilAdmin";
            strQueryString += "&parameters=" + strParameters;

            strQueryString = strQueryString.Replace("'", "|");
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "rptt", "window.open('" + strServerName + strQueryString + "');", true);
        }
    }
    
}
