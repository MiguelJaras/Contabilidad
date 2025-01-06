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


public partial class Balanza_AnalisisCuenta : System.Web.UI.Page
{
    public string intEmpresa;
    public string intEjercicio;
    public string intMes;
    public string intNivel;
    public string obraIni;
    public string obraFin;
    public string CuentaIni;
    public string CuentaFin;
    public string AreaIni;
    public string AreaFin;
    public string ColoniaIni;
    public string ColoniaFin;
    public string strCuenta;
    public string intCargo;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            intEmpresa = Request.QueryString["intEmpresa"].ToString();
            intEjercicio = Request.QueryString["intEjercicio"].ToString();
            intMes = Request.QueryString["intMes"].ToString();
            intNivel = Request.QueryString["intNivel"].ToString();
            obraIni = Request.QueryString["strObraIni"].ToString();
            obraFin = Request.QueryString["strObraFin"].ToString();
            CuentaIni = Request.QueryString["strCuentaIni"].ToString();
            CuentaFin = Request.QueryString["strCuentaFin"].ToString();
            AreaIni = Request.QueryString["strAreaIni"].ToString();
            AreaFin = Request.QueryString["strAreaFin"].ToString();
            ColoniaIni = Request.QueryString["strColoniaIni"].ToString();
            ColoniaFin = Request.QueryString["strColoniaFin"].ToString();
            strCuenta = Request.QueryString["strCuenta"].ToString();
            intCargo = Request.QueryString["intCargo"].ToString();

            BindGrid();
        }
    }

    #region BindGrid
    private void BindGrid()
    {
        Entity_Conciliaciones obj;
        obj = new Entity_Conciliaciones();
        PolizasDet poliza;
        poliza = new PolizasDet();
        DataTable dt;
        DataRow dr;

        obj.IntEmpresa = Convert.ToInt32(intEmpresa);
        obj.IntEjercicio = Convert.ToInt32(intEjercicio);
        obj.IntMes = Convert.ToInt32(intMes);
        obj.IntFolio = Convert.ToInt32(intNivel);
        obj.StrObraInicial = obraIni;
        obj.StrObraFinal = obraFin;
        obj.StrFechaInicial = strCuenta;
        obj.StrFechaFinal = strCuenta;
        obj.IntProveedorInicial = Convert.ToInt32(AreaIni);
        obj.IntProveedorFinal = Convert.ToInt32(AreaFin);
        obj.IntParametroInicial = Convert.ToInt32(ColoniaIni);
        obj.IntParametroFinal = Convert.ToInt32(ColoniaFin);
        obj.StrInsumoInicial = "0";
        obj.StrInsumoFinal = "0";
        obj.IntEjercicioRef = Convert.ToInt32(intCargo);

        dt = poliza.BalanzaCuenta(obj);
        DgrdList.DataSource = dt;
        DgrdList.DataBind();
        DgrdList.UpdateAfterCallBack = true;

        if (dt.Rows.Count > 0)
        {
            dr = dt.Rows[0];
            lblTotal.Text = dr["Total"].ToString();
            lblTotal.UpdateAfterCallBack = true;
        }

        poliza = null;
        obj = null;
    }
    #endregion     
    
    #region DgrdList_RowCreated
    protected void DgrdList_RowCreated(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {//#FFA07A

            DataRowView dr = (DataRowView)e.Row.DataItem;
            if (dr != null)
            {
                string strPoliza = dr["strPoliza"].ToString();

                string queryString = "?intEmpresa=" + intEmpresa + "&intMes=" + intMes + "&intEjercicio=" + intEjercicio + "&strCuenta=" + strCuenta;
                string url = "AnalisisCuenta.aspx" + queryString;

                Anthem.LinkButton lknPoliza = (Anthem.LinkButton)e.Row.FindControl("lknPoliza");

                e.Row.Style.Value = "background-color:#FAFAFA;color:Black;font-family: Tahoma;font-size: 8pt;Height:15px;font-weight:bold";
                e.Row.Attributes.Add("onmouseover", "Over(this);");
                e.Row.Attributes.Add("onmouseout", "Out(this);");

                lknPoliza.Style.Value = "color:Navy;font-family: Tahoma;font-size: 8pt;Height:15px;font-weight:bold";
                lknPoliza.Text = strPoliza;
//                lknPoliza.Attributes.Add("onClick", "window.showModalDialog('" + url + "',null,'dialogHeight:600px; dialogWidth:1000px;status:no;help:no;scroll:no;minimize:no;maximize:no;close:no;border:thin;');  return false;");
                lknPoliza.Attributes.Add("onClick", "window.open('" + url + "',null,'height=700px width=1100px resizable scrollbars');  return false;");
                
                e.Row.Cells[0].Style.Value = "text-align:center";
                e.Row.Cells[1].Style.Value = "text-align:center";
                e.Row.Cells[2].Style.Value = "text-align:center";
                e.Row.Cells[3].Style.Value = "text-align:center";
                e.Row.Cells[4].Style.Value = "text-align:right";

                lknPoliza.UpdateAfterCallBack = true;
            }
        }
    }
    #endregion DgrdList

}


