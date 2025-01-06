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
using DevExpress.Web.ASPxGridView;
using System.Data.SqlClient;
using Contabilidad.Bussines;
using Contabilidad.Entity;

public partial class Pages_Contabilidad_Opciones_FacturacionCom : System.Web.UI.Page
{
    public string realPath;
    Pages_Base toolbar;
    public string strServerName;

    protected void Page_Load(object sender, EventArgs e)
    {
        strServerName = "http://" + HttpContext.Current.Request.ServerVariables["SERVER_NAME"].ToString() + ":" + HttpContext.Current.Request.ServerVariables["SERVER_PORT"].ToString() + "/Contabilidad/Utils/PDFF.aspx";
        toolbar = (Pages_Base)this.Master;
        toolbar.PageEvent += new HandlerEvent(Me_Event);
        Anthem.Manager.Register(this);
        string end = (Request.ApplicationPath.EndsWith("/")) ? "" : "/";
        string path = Request.ApplicationPath + end;
        realPath = String.Format("http://{0}{1}{2}", Request.Url.Authority, path, "Img/dxpcFooterBack.gif");
        if (!IsPostBack && !IsCallback)
        {
            Year();
            cboEjercicio.SelectedValue = DateTime.Now.Year.ToString();
            Semana();
            BindGrid();
        }
        
        RefreshSession();
    }

    protected void Page_PreRender(object sender, EventArgs e)
    {
        toolbar.Print(false);
        toolbar.Exportar(false);
        toolbar.Email(false);
        toolbar.Delete(false);
    }

    #region Event
    void Me_Event(object sender, HandlerArgs args)
    {
        switch (args.Event)
        {
            case Event.Save:
                Save();
                break;
            case Event.New:
                Clear();
                break;
            case Event.Delete:
                break;
            case Event.Print:
                break;
            case Event.List:
                BindGrid();
                break;
            default:
                break;
        }
    }
    #endregion


    private void Exportar() {
        FacturasGenerarComisiones fac;
        fac = new FacturasGenerarComisiones();

        string query;
        string[] arrDatos;
        arrDatos = new string[2];
        arrDatos[0] = cboEjercicio.SelectedValue.ToString();
        arrDatos[1] = cboSemana.SelectedValue.ToString();

        query = sqlQuery("vetecmarfiladmin..usp_tbFacturasGenerarComisiones_listXLS ", arrDatos);

        fac = null;

        string queryString = "?query=" + query + "&type=xls";
        Response.Redirect("../../../Utils/Excel.aspx" + queryString);
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
    #region Semana
    private void Semana()
    {
        DataTable dt;
        dt = null;
        Contabilidad.Bussines.FacturasGenerarComisiones fac = new Contabilidad.Bussines.FacturasGenerarComisiones();
        int intAnio=  cboEjercicio.SelectedValue.ToString()=="" ? 0 : Convert.ToInt32(cboEjercicio.SelectedValue.ToString());
        dt= fac.GetSemana(intAnio);

        cboSemana.DataSource = dt;
        cboSemana.DataTextField = "intSemana";
        cboSemana.DataValueField = "intSemana";
        
        cboSemana.DataBind();

        cboSemana.Items.Insert(0, new ListItem("-- Seleccione --", "0"));
        cboSemana.SelectedIndex = 0;
        cboSemana.UpdateAfterCallBack = true;
    }
    #endregion

    #region Year
    private void Year()
    {
        DataTable dt;
        dt = null;
        Contabilidad.Bussines.FacturasGenerarComisiones fac = new Contabilidad.Bussines.FacturasGenerarComisiones();
        dt = fac.GetAnio();

        cboEjercicio.DataSource = dt;
        cboEjercicio.DataTextField = "intAnio";
        cboEjercicio.DataValueField = "intAnio";
        
        cboEjercicio.DataBind();

        cboEjercicio.Items.Insert(0, new ListItem("-- Seleccione --", "0"));
        cboEjercicio.SelectedIndex = 0;
        cboEjercicio.UpdateAfterCallBack = true;


    }
    #endregion Year


    #region RefreshSession
    private void RefreshSession()
    {
        string end = (Request.ApplicationPath.EndsWith("/")) ? "" : "/";
        string path = Request.ApplicationPath + end;
        string appPath = String.Format("http://{0}{1}{2}", Request.Url.Authority, path, "Login/FinSesion.aspx?id=0");

        Response.AppendHeader("Refresh", Convert.ToString((Session.Timeout * 50)) + "; URL=" + appPath);
    }
    #endregion

    protected void BindGrid()
    {
        Entity_FacturasGenerarComisiones obj = new Entity_FacturasGenerarComisiones();
        FacturasGenerarComisiones fac = new FacturasGenerarComisiones();
        DataTable dt = null;

        obj.intSemana = cboSemana.SelectedValue.ToString() == "" ? 0 : Convert.ToInt32(cboSemana.SelectedValue.ToString());
        obj.intEjercicio = cboEjercicio.SelectedValue.ToString() == "" ? 0 : Convert.ToInt32( cboEjercicio.SelectedValue.ToString());
        dt = fac.GetList(obj);

        grdFacturacion.DataSource = dt;
        grdFacturacion.DataBind();
        grdFacturacion.UpdateAfterCallBack = true;

        fac = null;
        obj = null;

    }
    #region Clear
    private void Clear()
    {

        cboEjercicio.SelectedValue = DateTime.Now.Year.ToString();
        cboSemana.SelectedIndex = -1;
        grdFacturacion.DataSource = null;
        grdFacturacion.DataBind();
        lblFec.Text = "";

        grdFacturacion.UpdateAfterCallBack = true;
        cboSemana.UpdateAfterCallBack = true;
        cboEjercicio.UpdateAfterCallBack = true;
        lblFec.UpdateAfterCallBack = true;
    }
    #endregion

    #region Save
    private void Save()
    {

        int intFactura, intColonia, intSector, intEjercicio, intSemana, intObra;
        intSemana = cboSemana.SelectedValue.ToString() == "" ? 0 : Convert.ToInt32(cboSemana.SelectedValue.ToString());
        intEjercicio = cboEjercicio.SelectedValue.ToString() == "" ? 0 : Convert.ToInt32( cboEjercicio.SelectedValue.ToString());

        for (int i = 0; i < grdFacturacion.Rows.Count; i++)
        {
            Anthem.CheckBox chkEscriturar = (Anthem.CheckBox)grdFacturacion.Rows[i].FindControl("chkFac");
            if (chkEscriturar.Checked)
            {

                intFactura = Convert.ToInt32(grdFacturacion.DataKeys[i].Values[0]);
                intColonia = Convert.ToInt32(grdFacturacion.DataKeys[i].Values[1]);
                intSector = Convert.ToInt32(grdFacturacion.DataKeys[i].Values[2]);
                intObra = Convert.ToInt32(grdFacturacion.DataKeys[i].Values[3]);

                Entity_FacturasGenerarComisiones obj = new Entity_FacturasGenerarComisiones();
                FacturasGenerarComisiones fac = new FacturasGenerarComisiones();

                obj.intEjercicio = intEjercicio;
                obj.intSemana= intSemana;
                obj.intColonia= intColonia;
                obj.intSector= intSector;
                obj.decFolio=0;
                obj.intObra = intObra;
                obj.StrUsuario= Contabilidad.SEMSession.GetInstance.StrUsuario;
                obj.StrMaquina= Contabilidad.SEMSession.GetInstance.StrMaquina;
                obj.dblImporte = grdFacturacion.Rows[i].Cells[10].Text =="" ? 0 : Convert.ToDecimal(grdFacturacion.Rows[i].Cells[10].Text.Replace("$", "").Replace(",", "")); 

                fac.Save(obj);
                fac = null;
                obj = null;
            }
        }
        BindGrid();
    }
    #endregion

    protected void cboMonth_Change(object sender, EventArgs e)
    {
        lblFec.Text = "";
        int intSemana = cboSemana.SelectedValue.ToString() == "" ? 0 : Convert.ToInt32(cboSemana.SelectedValue.ToString());
        int intEjercicio = cboEjercicio.SelectedValue.ToString() == "" ? 0 : Convert.ToInt32(cboEjercicio.SelectedValue.ToString());
        FacturasGenerarComisiones fac = new FacturasGenerarComisiones();
        lblFec.Text = fac.GetFecha(intSemana, intEjercicio);
        lblFec.UpdateAfterCallBack = true;
        BindGrid();
    }

    #region row_Created
    protected void row_Created(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            DataRowView dataRowView = (DataRowView)e.Row.DataItem;
            if (dataRowView != null)
            {

                Anthem.CheckBox chkEscriturar = (Anthem.CheckBox)e.Row.FindControl("chkFac");
                int intFactura =Convert.ToInt32(dataRowView.Row["intFactura"].ToString());
                string strPDF = dataRowView.Row["strPDF"].ToString();
                string strFac = dataRowView.Row["Factura"].ToString();
                Anthem.LinkButton lknFac= (Anthem.LinkButton)e.Row.FindControl("lknFac");

                string strQueryString = "?type=pdf&empresa=4&FileName=" + strPDF; 
                string url = strServerName;
                url = url + strQueryString;
                

                if (intFactura != 0)
                {
                    chkEscriturar.Visible = false;
                }
                else {
                    chkEscriturar.Visible = true;
                }



                if (strPDF == "")
                {
                    lknFac.Visible = false;
                    //e.Row.Style.Value = "background-color:#EAF7FB;color:#000066;font-family: Tahoma;font-size: 7pt;Height:30px;font-weight:bold;";
                }
                else
                {
                    lknFac.Visible = true;
                    lknFac.Text = strFac;
                    //lknFac.Style.Value = "color:#00008B;font-family: Tahoma;font-size: 8pt;Height:30px;font-weight:bold;text-decoration:underline;";
                    lknFac.Attributes.Add("onClick", "window.open('" + url + "');  return false;");
                    //e.Row.Style.Value = "background-color:#FFA07A;color:Black;font-family: Tahoma;font-size: 7pt;Height:30px;font-weight:bold";
                  
                }

            }
        }
    }
    #endregion
    protected void btnList_Click(object sender, EventArgs e)
    {
        BindGrid();
    }
    protected void btnExport_Click(object sender, EventArgs e)
    {
        Exportar();
    }
    protected void lknPost_Click(object sender, EventArgs e)
    {
        BindGrid();
    }
}