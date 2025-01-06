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
using System.IO;
using System.Data.OleDb;
using Contabilidad.Bussines;
using Contabilidad.Entity;

public partial class Utils_PopUpPoliza : System.Web.UI.Page
{
    int intEmpresa;
    string strPoliza;
    int intEjercicio;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack) 
        {
            intEmpresa = Convert.ToInt32(Request.QueryString["intEmpresa"].ToString());
            strPoliza = Request.QueryString["strPoliza"].ToString();
            intEjercicio = Convert.ToInt32(Request.QueryString["intEjercicio"].ToString());
            PolizaEnc();
            DetallePoliza();
        }
    }

    #region PolizaEnc
    protected void PolizaEnc()
    {
        Entity_Poliza obj;
        obj = new Entity_Poliza();
        Poliza pol;
        pol = new Poliza();

        obj = pol.Fill(intEmpresa, intEjercicio, strPoliza);
        lblEmpresa.Text = obj.Empresa;
        lblFecha.Text = obj.Fecha;
        lblTipoPoliza.Text = obj.TipoPoliza;
        lblPoliza.Text = obj.StrPoliza;

        lblEmpresa.UpdateAfterCallBack = true;
        lblFecha.UpdateAfterCallBack = true;
        lblTipoPoliza.UpdateAfterCallBack = true;
        lblPoliza.UpdateAfterCallBack = true;

        pol = null;
        obj = null;
    }
    #endregion     

    #region DetallePoliza
    protected void DetallePoliza()
    {
        Poliza pol;
        pol = new Poliza();
        DataTable dt;
        dt = pol.GetList(intEmpresa, intEjercicio, strPoliza);        

        grdDetalle.DataSource = dt;
        grdDetalle.DataBind();
        grdDetalle.UpdateAfterCallBack = true;

        pol = null;
    }
    #endregion     
 
    #region row_Created
    protected void row_Created(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            DataRowView dataRowView = (DataRowView)e.Row.DataItem;
            if (dataRowView != null)
            {
                string strObra = dataRowView.Row["strObra"].ToString();
                if (strObra == "DIFERENCIA:")
                    e.Row.Style.Value = "background-color:#7093DB;color:Black;font-family: Tahoma;font-size: 7pt;Height:25px; font-weight:bolder;";
                else
                {
                    if (strObra == "TOTAL:")
                        e.Row.Style.Value = "background-color:#BCD2EE;color:Navy;font-family: Tahoma;font-size: 7pt;Height:25px; font-weight:bolder;";
                    else
                        e.Row.Style.Value = "background-color:#EAF7FB;color:#000066;font-family: Tahoma;font-size: 7pt;Height:15px;font-weight:bold;";  
                }
            }
        }
    }
    #endregion

}
