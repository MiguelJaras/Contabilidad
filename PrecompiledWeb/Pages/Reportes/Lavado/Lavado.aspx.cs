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

public partial class Contabilidad_Compra_Reportes_Lavado : System.Web.UI.Page
{
    Report_Pages_Base toolbar;
    public string realPath;

    protected void Page_Load(object sender, EventArgs e)
    {
        toolbar = (Report_Pages_Base)this.Master;

        CheckBox masterCheckbox = (CheckBox)this.Master.FindControl("chkExcel");
        masterCheckbox.Checked = true;

        if (!IsPostBack)
        {
            btnExpandReportes.Attributes.Add("onClick", "ReportVisible(this,'" + pnlReportes1.ClientID + "');");
            Year();
            Month();
            cboMonth.SelectedValue = DateTime.Now.Month.ToString();
            cboYear.SelectedValue = DateTime.Now.Year.ToString();
        }
        Anthem.Manager.Register(this);
        JavaScript();
    }

    #region JavaScript
    private void JavaScript()
    {

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
    
    #region Clear
    private void Clear()
    {
        cboMonth.SelectedIndex = -1;
        cboYear.SelectedIndex = -1;

        cboMonth.UpdateAfterCallBack = true;
        cboYear.UpdateAfterCallBack = true;

    }
    #endregion

    protected void lknLavado_Click(object sender, EventArgs e)
    {
        string[] arrDatos;
        string strParameters = "";

        string intMes = cboMonth.SelectedValue;
        string intEjercicio = cboYear.SelectedValue;
        arrDatos = new string[2];
        arrDatos[0] = intEjercicio;
        arrDatos[1] = intMes;

        //if (!toolbar.Check())
        //{
        //    strParameters = String.Format("{0}[--]{1}", arrDatos);

        //    //string strServerName = "http://" + HttpContext.Current.Request.ServerVariables["SERVER_NAME"].ToString() + ":" + HttpContext.Current.Request.ServerVariables["SERVER_PORT"].ToString() + "/Contabilidad/Utils/CRViewer.aspx";
        //    //string strQueryString = string.Empty;
        //    //strQueryString = "?type=pdf";
        //    //strQueryString += "&report=Pages/Reportes/IVA/IVA Analitico.rpt";
        //    //strQueryString += "&db=VetecMarfil";
        //    //strQueryString += "&parameters=" + strParameters;
        //    //strQueryString += "&Titulos=IVA";

        //    //strQueryString = strQueryString.Replace("'", "|");
        //    //Anthem.Manager.RegisterStartupScript(Page.GetType(), "rpt", "window.open('" + strServerName + strQueryString + "');", true);
        //}
        //else
        //{
            Iva iva;
            iva = new Iva();

            string query;
            query = sqlQuery("VetecMarfilAdmin..usp_Contabilidad_Lavado ", arrDatos);

            iva = null;

            string queryString = "?query=" + query + "&type=xls&tabla=0";
            Response.Redirect("../../../Utils/Excel.aspx" + queryString);

        //}
    }

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
