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


public partial class Balanza_Analisis : System.Web.UI.Page
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

        obj.IntEmpresa = Convert.ToInt32(intEmpresa);
        obj.IntEjercicio = Convert.ToInt32(intEjercicio);
        obj.IntMes = Convert.ToInt32(intMes);
        obj.IntFolio = Convert.ToInt32(intNivel);
        obj.StrObraInicial = obraIni;
        obj.StrObraFinal = obraFin;
        obj.StrFechaInicial = CuentaIni;
        obj.StrFechaFinal = CuentaFin;
        obj.IntProveedorInicial = Convert.ToInt32(AreaIni);
        obj.IntProveedorFinal = Convert.ToInt32(AreaFin);
        obj.IntParametroInicial = Convert.ToInt32(ColoniaIni);
        obj.IntParametroFinal = Convert.ToInt32(ColoniaFin);
        obj.StrInsumoInicial = "0";
        obj.StrInsumoFinal = "0";

        DgrdList.DataSource = poliza.Balanza(obj);
        DgrdList.DataBind();
        DgrdList.UpdateAfterCallBack = true;

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
                string strCuenta = dr["strCuenta"].ToString();
                decimal Cargos = Convert.ToDecimal(dr["MesCargo"].ToString());
                decimal Abonos = Convert.ToDecimal(dr["MesAbono"].ToString());

                string queryString = "?intEmpresa=" + intEmpresa + "&intEjercicio=" + intEjercicio + "&intMes=" + intMes + "&intNivel=" + intNivel + "&strObraIni=" + obraIni + "&strObraFin=" + obraFin + "&strCuentaIni=" + CuentaIni + "&strCuentaFin=" + CuentaFin + "&strAreaIni=" + AreaIni + "&strAreaFin=" + AreaFin + "&strColoniaIni=" + ColoniaIni + "&strColoniaFin=" + ColoniaFin + "&strCuenta=" + strCuenta;
                string url = "AnalisisCuenta.aspx" + queryString;

                Anthem.LinkButton lknCargos = (Anthem.LinkButton)e.Row.FindControl("lknCargos");
                Anthem.LinkButton lknAbonos = (Anthem.LinkButton)e.Row.FindControl("lknAbonos");

                e.Row.Style.Value = "background-color:#FAFAFA;color:Black;font-family: Tahoma;font-size: 8pt;Height:15px;font-weight:bold";
                e.Row.Attributes.Add("onmouseover", "Over(this);");
                e.Row.Attributes.Add("onmouseout", "Out(this);");

                lknCargos.Style.Value = "color:Navy;font-family: Tahoma;font-size: 8pt;Height:15px;font-weight:bold";
                lknCargos.Text = Cargos.ToString("C2");
                lknCargos.Attributes.Add("onClick", "window.showModalDialog('" + url + "&intCargo=1" + "',null,'dialogHeight:600px; dialogWidth:800px;status:no;help:no;scroll:no;minimize:no;maximize:no;close:no;border:thin;');  return false;");

                lknAbonos.Style.Value = "color:Navy;font-family: Tahoma;font-size: 8pt;Height:15px;font-weight:bold";
                lknAbonos.Text = Abonos.ToString("C2");
                lknAbonos.Attributes.Add("onClick", "window.showModalDialog('" + url + "&intCargo=0" + "',null,'dialogHeight:600px; dialogWidth:800px;status:no;help:no;scroll:no;minimize:no;maximize:no;close:no;border:thin;');  return false;");

                e.Row.Cells[0].Style.Value = "text-align:center";
                e.Row.Cells[1].Style.Value = "text-align:left";
                e.Row.Cells[2].Style.Value = "text-align:right";
                e.Row.Cells[3].Style.Value = "text-align:right";
                e.Row.Cells[4].Style.Value = "text-align:right";
                e.Row.Cells[5].Style.Value = "text-align:right";

                lknCargos.UpdateAfterCallBack = true;
                lknAbonos.UpdateAfterCallBack = true;
            }
        }
    }
    #endregion DgrdList

}


