using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using Contabilidad.Entity;
using Contabilidad.Bussines;
using System.IO;
using System.Data.OleDb;

public partial class Administracion_Contabilidad_GridView : System.Web.UI.Page
{
    public int size;
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack) 
        {
            Int16 tipo = Convert.ToInt16(Request.QueryString.Get("Tipo"));

            switch (tipo)
            {
                case 1:
                    ReporteFinancieroObra();
                    break;
                //case 2:
                //    Cartera();
                //    break;
            }
        }
    }

    #region ReporteFinancieroObra
    protected void ReporteFinancieroObra()
    {
        Entity_Obra obj;
        obj = new Entity_Obra();
        EstadoResultados es;
        es = new EstadoResultados();
        DataTable dt;

        obj.IntEmpresa = Convert.ToInt32(Request.QueryString["intEmpresa"].ToString());
        obj.StrFechaInicial = Request.QueryString["datFechaIni"].ToString();
        obj.StrFechaFinal = Request.QueryString["datFechaFin"].ToString();
        obj.StrObraInicial = Request.QueryString["strCCIni"].ToString();
        obj.StrObraFinal = Request.QueryString["strCCFin"].ToString();
        obj.IntParametroInicial = Convert.ToInt32(Request.QueryString["strQuitar"].ToString());        
        string size = Request.QueryString["size"].ToString();

        dt = es.EstadoResuldatosList(obj);

        lblTitle.Text = Contabilidad.SEMSession.GetInstance.Empresa;
        lblTitle2.Text = "Periodo del " + obj.StrFechaInicial + " al " + obj.StrFechaFinal + " <br />";

        foreach (DataColumn dc in dt.Columns)
        {

            if (dc.ColumnName.Contains("Rubro") || dc.ColumnName.Contains("No"))
            {
                BoundField b = new BoundField();
                b.DataField = dc.ColumnName;
                b.HeaderText = dc.ColumnName;

                switch (dc.ColumnName)
                {
                    case "Rubro":
                        b.ItemStyle.Width = 150;
                        b.ItemStyle.HorizontalAlign = HorizontalAlign.Left;
                        break;
                    case "No":
                        b.ItemStyle.Width = 50;
                        b.ItemStyle.HorizontalAlign = HorizontalAlign.Center;
                        break;                   
                }

                b.ItemStyle.Height = 10;
                b.HeaderStyle.Height = 10;
                grdDetalle.Columns.Add(b);

                b = null;
            }
            else
            {
                TemplateField b = new TemplateField();
                b.HeaderText = dc.ColumnName;
                b.ItemTemplate = new AddTemplateToGridView(ListItemType.Item, dc.ColumnName);

                switch (dc.ColumnName)
                {
                    default:
                        b.ItemStyle.Width = 100;
                        b.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
                        b.HeaderStyle.HorizontalAlign = HorizontalAlign.Left;

                        break;                   
                }

                b.ItemStyle.Height = 10;
                b.HeaderStyle.Height = 10;
                grdDetalle.Columns.Add(b);

                b = null;                
            }                               
        }

        grdDetalle.DataSource = dt;
        grdDetalle.DataBind();

        grdDetalle.Width = Convert.ToUInt16(size);

        obj = null;
        es = null;
    }
    #endregion  
   
    public class AddTemplateToGridView : ITemplate
    {
        ListItemType _type;
        string _colName;

        public AddTemplateToGridView(ListItemType type, string colname)
        {
            _type = type;
            _colName = colname;
        }

        void ITemplate.InstantiateIn(System.Web.UI.Control container)
        {
            switch (_type)
            {
                case ListItemType.Item:

                    HyperLink ht = new HyperLink();
                    ht.Target = "_blank";
                    ht.DataBinding += new EventHandler(ht_DataBinding);
                    container.Controls.Add(ht);

                    break;
            }
        }

        void ht_DataBinding(object sender, EventArgs e)
        {

            HyperLink lnk = (HyperLink)sender;
            GridViewRow container = (GridViewRow)lnk.NamingContainer;
            object dataValue = DataBinder.Eval(container.DataItem, _colName);
            if (dataValue != DBNull.Value)
            {
                lnk.Text = dataValue.ToString();
                lnk.NavigateUrl = "http://www.google.com.mx";
                lnk.Style.Value = "color:#283B56;font-family: Tahoma;font-size: 8pt;Height:10px; font-weight:bolder;text-align:right;";
            }
        }

    }    
 
    #region row_Created
    protected void row_Created(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            DataRowView dataRowView = (DataRowView)e.Row.DataItem;
            if (dataRowView != null)
            {
                if (Request.QueryString.Get("Tipo").ToString() == "2")
                {
                    string strDescripcion = dataRowView.Row["Descripcion"].ToString();
                    if (strDescripcion == "SALDOS VENCIDOS BRUTOS" || strDescripcion == "MENOS" || strDescripcion == "SALDOS NETOS" || strDescripcion == "CLIENTES" || strDescripcion == "SALDOS VENCIDOS NETOS")
                    {
                        for (int i = 0; i < e.Row.Cells.Count; i++)
                        {
                            if (i == 1)
                                e.Row.Cells[1].Style.Value = "background-color:#7093DB;color:White;font-family: Tahoma;font-size: 8pt;Height:15px; font-weight:bolder;text-align:right;";
                            else
                                e.Row.Cells[i].Style.Value = "background-color:#7093DB;color:#7093DB;font-family: Tahoma;font-size: 7pt;Height:15px; font-weight:bolder;text-align:right;";
                        }
                    }


                    if (strDescripcion == "TOTAL CLIENTES")
                    {
                        //for (int i = 2; i < e.Row.Cells.Count; i++)
                        //{
                        //    dataRowView.Row[i] = dataRowView.Row[i].ToString().Replace("$", "");
                        //}
                        //dataRowView.Row["Descripcion"] = "";
                    }
                }
                //else
                //{
                //    for (int i = 2; i < e.Row.Cells.Count; i++)
                //    {
                //        e.Row.Cells[i].Style.Value = "color:#7093DB;font-family: Tahoma;font-size: 7pt;Height:15px; font-weight:bolder;text-align:right;";
                //    }
                //}
            }
        }
    }
    #endregion

}
