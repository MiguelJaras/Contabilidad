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
using System.Data.SqlClient;
using System.IO;
using System.Diagnostics;
using Contabilidad.Bussines;
using Contabilidad.Entity;
using System.Xml;

public partial class Utils_XML : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        
        DataTable dt = new DataTable();

        string type = Request.QueryString["strType"].ToString();
       
        switch (type)
        { 
            case "B":
                dt = Balanza();
                break;
            case "C":
                dt = Cuenta();
                break;
            case "P":
                dt = Balanza();
                break;
            case "AC":
                dt = Balanza();
                break;
            case "AF":
                dt = Balanza();
                break;
        }

        byte[] archivo = (byte[])dt.Rows[0].ItemArray[0];
        string FileName = ((string)(dt.Rows[0].ItemArray[1]));                             

        Response.Buffer = true;
        Response.AddHeader("Pragma", "no-cache");
        Response.AddHeader("Content-Disposition", "attachment;filename=" + FileName);
        Response.Expires = 0;
        Response.ContentType = "text/xml";
        Response.Clear();
        Response.BinaryWrite(archivo);
        Response.Flush();
        Response.End();
    }

    #region Cuenta
    private DataTable Cuenta()
    {
        DataTable dt;
        Entity_DigCuentas objCuenta;
        objCuenta = new Entity_DigCuentas();
        DigCuentas cuenta;
        cuenta = new DigCuentas();

        int intEmpresa = Convert.ToInt32(Request.QueryString["intEmpresa"]);
        int intFolio = Convert.ToInt32(Request.QueryString["intFolio"].ToString());
          
        objCuenta.IntEmpresa = intEmpresa;
        objCuenta.IntFolio = intFolio;

        dt = cuenta.Fill(objCuenta);

        cuenta = null;
        objCuenta = null;

        return dt;
    }
    #endregion Cuenta

    #region Balanza
    private DataTable Balanza()
    {
        DataTable dt;
        Entity_DigBalanza objCuenta;
        objCuenta = new Entity_DigBalanza();
        DigBalanza cuenta;
        cuenta = new DigBalanza();

        int intEmpresa = Convert.ToInt32(Request.QueryString["intEmpresa"]);
        int intFolio = Convert.ToInt32(Request.QueryString["intFolio"].ToString());

        objCuenta.IntEmpresa = intEmpresa;
        objCuenta.IntFolio = intFolio;

        dt = cuenta.Fill(objCuenta);

        cuenta = null;
        objCuenta = null;

        return dt;
    }
    #endregion Balanza   

}
