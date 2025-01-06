using System;
using System.Collections;
using System.ComponentModel;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Web;
using System.Configuration;
using System.Web.SessionState;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using DevExpress.Web.ASPxGridView;
using Contabilidad.DataAccess;

public partial class Browse : System.Web.UI.Page
{
    string strQuery;

    protected void Page_Load(object sender, System.EventArgs e)
    {
        string strClassName = Request.QueryString["classname"].ToString();
        string page = "";
        int intParametros = int.Parse(Request.QueryString["parametros"]);
        string[] parametros = new string[intParametros];
        int intEmpresa = int.Parse(Request.QueryString["intEmpresa"]);
        int intSucursal = int.Parse(Request.QueryString["intSucursal"]);

        Type t = System.Web.Compilation.BuildManager.GetType("Contabilidad.DataAccess." + strClassName, true, true);
        Base objBase = (Base)Activator.CreateInstance(t);

        for (int intCount = 0; intCount < intParametros; intCount++)
        {
            parametros[intCount] = Request.QueryString["parametro" + intCount.ToString()].ToString();

            if (Request.QueryString["parametro" + intCount.ToString()].Length >= 4)
            {
                if (Request.QueryString["parametro" + intCount.ToString()].Substring(0, 4) == "Page")
                    page = Request.QueryString["parametro" + intCount.ToString()].ToString().Replace("Page", "");
            }
        }

        if (Request.QueryString["IsQuery"] != null)
        {
            if (Request.QueryString["IsQuery"].ToString() == "0")
            {
        strQuery = objBase.QueryHelp(intEmpresa, intSucursal, parametros, System.Int32.Parse(Request.QueryString["version"]));
        llenarGrid(strQuery);
            }
            else
            {
                using (DataSet ds = objBase.QueryHelpData(intEmpresa, intSucursal, parametros, System.Int32.Parse(Request.QueryString["version"])))
                {
                    llenarGrid(ds);
                }
            }
        }
        else
        {
            strQuery = objBase.QueryHelp(intEmpresa, intSucursal, parametros, System.Int32.Parse(Request.QueryString["version"]));
            llenarGrid(strQuery);
        }


        foreach (DevExpress.Web.ASPxGridView.GridViewColumn obj in ASPxGridViewAyuda.Columns)
        {
            switch (obj.GetType().Name)
        {
                case "GridViewDataTextColumn":
                    DevExpress.Web.ASPxGridView.GridViewDataTextColumn bcol = ((DevExpress.Web.ASPxGridView.GridViewDataTextColumn)obj);
            if (obj.ToString().Equals("#") || obj.ToString().Equals("#1") || obj.ToString().Equals("#2"))
            {
                obj.Width = Unit.Pixel(1);

                ASPxGridViewAyuda.Columns["#"].HeaderStyle.CssClass = "invisible";
                ASPxGridViewAyuda.Columns["#"].FooterCellStyle.CssClass = "invisible";
                ASPxGridViewAyuda.Columns["#"].CellStyle.CssClass = "invisible";

                        bcol.EditCellStyle.CssClass = "invisible";
                        bcol.FilterCellStyle.CssClass = "invisible";
                        bcol.HeaderStyle.CssClass = "invisible";

                        bcol.FooterCellStyle.CssClass = "invisible";
                        bcol.CellStyle.CssClass = "invisible";
                    }
                    ((DevExpress.Web.ASPxGridView.GridViewDataTextColumn)obj).PropertiesTextEdit.EncodeHtml = false;
                    break;

                #region more types Columns
                case "GridViewBandColumn": //break;
                case "GridViewCommandColumn": //break;
                case "GridViewDataBinaryImageColumn": //break;
                case "GridViewDataButtonEditColumn": //break;
                case "GridViewDataCheckColumn": //break;
                case "GridViewDataColorEditColumn": //break;
                case "GridViewDataColumn": //break;
                case "GridViewDataComboBoxColumn": //break;
                case "GridViewDataDateColumn": //break;
                case "GridViewDataDropDownEditColumn": //break;
                case "GridViewDataHyperLinkColumn": //break;
                case "GridViewDataImageColumn": //break;
                case "GridViewDataMemoColumn": //break;
                case "GridViewDataProgressBarColumn": //break;
                case "GridViewDataSpinEditColumn": //break; 
                case "GridViewDataTimeEditColumn": //break;
                case "GridViewEditDataColumn": //break;
                case "MVCxGridViewBandColumn": //break;
                case "MVCxGridViewColumn": //break;
                case "MVCxGridViewCommandColumn": //break;
                #endregion

                default:
                    obj.Visible = false;
                    break;

            }

        }

        ASPxGridViewAyuda.DataBind();

        if (!IsPostBack)
        {
            if (page != "")
            {
                ASPxGridViewAyuda.PageIndex = Convert.ToInt32(page);
                Session["PageIndex"] = page;
            }
        }
    }

    protected void gridView_PageIndexChanged(object sender, EventArgs e)
    {
        Session["PageIndex"] = ASPxGridViewAyuda.PageIndex.ToString();
    }

    private void llenarGrid(string p_strQuery)
    {
        try
        {
            Contabilidad.Bussines.Menu data;
            data = new Contabilidad.Bussines.Menu();
            DataSet ds;
            ds = data.BindGrid(p_strQuery);

            ASPxGridViewAyuda.DataSource = ds;
            ASPxGridViewAyuda.DataBind();
            ASPxGridViewAyuda.KeyFieldName = "intAlmacen";

        }
        catch (Exception)
        {
            Response.Write("No hay registros " + Request.QueryString["classname"].ToString());
        }
    }

    private void llenarGrid(DataSet ds)
    {
        try
        {
            if (ds.Tables.Count > 0)
            {
                if (ds.Tables[0].Rows.Count > 0)
                {
                    ASPxGridViewAyuda.DataSource = ds;
                    ASPxGridViewAyuda.DataBind();

                    if (ASPxGridViewAyuda.KeyFieldName.Contains("intAlmacen"))
                    {
                        ASPxGridViewAyuda.KeyFieldName = "intAlmacen";
                    }
                }
                else
                {
                    ASPxGridViewAyuda.DataSource = null;
                    ASPxGridViewAyuda.DataBind();
                }
            }
            else
            {
                ASPxGridViewAyuda.DataSource = null;
                ASPxGridViewAyuda.DataBind();
            }

        }
        catch (Exception ex)
        {
            Response.Write("No hay registros " + Request.QueryString["classname"].ToString());
        }
    }


    protected void ASPxGridViewAyuda_HtmlRowPrepared(object sender, ASPxGridViewTableRowEventArgs e)
    {
        if (e.RowType != GridViewRowType.Data) return;


    }

    #region Código generado por el Diseñador de Web Forms
    override protected void OnInit(EventArgs e)
    {
        //
        // CODEGEN: llamada requerida por el Diseñador de Web Forms ASP.NET.
        //
        InitializeComponent();
        base.OnInit(e);
    }

    /// <summary>
    /// Método necesario para admitir el Diseñador. No se puede modificar
    /// el contenido del método con el editor de código.
    /// </summary>
    private void InitializeComponent()
    {

    }
    #endregion

}