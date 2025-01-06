using Contabilidad.Bussines;
using Contabilidad.Entity;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Net.Mail;
using System.Text;
using System.Web.Services;
using System.Web.UI;
using HtmlAgilityPack;

public partial class Pages_Contabilidad_Opciones_ProspectoNotaCredito : System.Web.UI.Page
{
    public string realPath;
    Pages_Base toolbar;
    public StringBuilder dataList;
    public StringBuilder dataColumns;
    public StringBuilder colModel;
    public StringBuilder dataColony;

    protected void Page_Load(object sender, EventArgs e)
    {
        toolbar = (Pages_Base)this.Master;
        toolbar.PageEvent += new HandlerEvent(Me_Event);
        Anthem.Manager.Register(this);
        
    }

    protected void Page_PreRender(object sender, EventArgs e)
    {
        JavaScript();
        toolbar.Print(false);
        toolbar.Exportar(false);
        toolbar.Email(true);
        toolbar.Delete(false);
        toolbar.List(false);
    }

    #region JavaScript
    private void JavaScript()
    {
        txtProspecto.Attributes.Add("onchange", "GetList()");

        Anthem.Manager.RegisterStartupScript(Page.GetType(), "objUtils", "var objUtils = new VetecUtils();", true);

        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtImporte", "var objText = new VetecText('" + txtImporte.ClientID + "', 'decimal', 18, 2);", true);

        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtProspecto", "var objText = new VetecText('" + txtProspecto.ClientID + "','number',7);", true);
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtNombre", "var objText = new VetecText('" + txtNombre.ClientID + "','text',50);", true);
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtRFC", "var objText = new VetecText('" + txtRFC.ClientID + "','text',50);", true);
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtPais", "var objText = new VetecText('" + txtPais.ClientID + "','text',200);", true);
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtEstado", "var objText = new VetecText('" + txtEstado.ClientID + "','text',200);", true);
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtCiudad", "var objText = new VetecText('" + txtCiudad.ClientID + "','text',200);", true);
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtDireccion", "var objText = new VetecText('" + txtDireccion.ClientID + "','text',50);", true);
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtCalle", "var objText = new VetecText('" + txtCalle.ClientID + "','text',50);", true);
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtCP", "var objText = new VetecText('" + txtCP.ClientID + "','text',50);", true);
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtEmail", "var objText = new VetecText('" + txtEmail.ClientID + "','text',100);", true);
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtTelefono", "var objText = new VetecText('" + txtTelefono.ClientID + "','text',50);", true);
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtDescuento", "var objText = new VetecText('" + txtDescuento.ClientID + "','text',50);", true);
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtPrecioTerreno", "var objText = new VetecText('" + txtPrecioTerreno.ClientID + "','text',5);", true);
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtPrecioEdificacion", "var objText = new VetecText('" + txtPrecioEdificacion.ClientID + "','text',12);", true);
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtTerreno", "var objText = new VetecText('" + txtTerreno.ClientID + "','text',11);", true);
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtAvaluo", "var objText = new VetecText('" + txtAvaluo.ClientID + "','text',11);", true);

    }
    #endregion
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

            case Event.Email:
                //EnviarEmail();
                break;

            case Event.List:
                //List();
                //BindGrid();
                break;
            default:
                break;
        }
    }
    #endregion 

    private void Clear()
    {
        txtProspecto.Text = "";
        txtNombre.Text = "";
        txtCalle.Text = "";
        txtCP.Text = "";
        txtDescuento.Text = "";
        txtDireccion.Text = "";
        txtEmail.Text = "";
        txtNombre.Text = "";
        txtPrecioEdificacion.Text = "";
        txtPrecioTerreno.Text = "";
        txtRFC.Text = "";
        txtTelefono.Text = "";
        txtTerreno.Text = "";
        txtColonia.Text = "";
        txtPrecioEdificacion.Text = "";
        txtPrecioTerreno.Text = "";
        txtTerreno.Text = "";
        txtDescuento.Text = "";
        txtCiudad.Text = "";
        txtEstado.Text = "";
        txtPais.Text = "";
        txtAvaluo.Text = "";

        txtBonificacion.Text = "";
        txtImporteRestante.Text = "";
        txtSerie.Text = "";
        txtFolio.Text = "";
        txtImporte.Text = "";

        txtAvaluo.UpdateAfterCallBack = true;
        txtCiudad.UpdateAfterCallBack = true;
        txtPais.UpdateAfterCallBack = true;
        txtEstado.UpdateAfterCallBack = true;
        //txtProspecto.UpdateAfterCallBack = true;
        txtNombre.UpdateAfterCallBack = true;
        txtCalle.UpdateAfterCallBack = true;
        txtCP.UpdateAfterCallBack = true;
        txtDescuento.UpdateAfterCallBack = true;
        txtDireccion.UpdateAfterCallBack = true;
        txtEmail.UpdateAfterCallBack = true;
        txtNombre.UpdateAfterCallBack = true;
        txtPrecioEdificacion.UpdateAfterCallBack = true;
        txtPrecioTerreno.UpdateAfterCallBack = true;
        txtRFC.UpdateAfterCallBack = true;
        txtTelefono.UpdateAfterCallBack = true;
        txtTerreno.UpdateAfterCallBack = true;
        txtColonia.UpdateAfterCallBack = true;
        txtPrecioEdificacion.UpdateAfterCallBack = true;
        txtPrecioTerreno.UpdateAfterCallBack = true;
        txtTerreno.UpdateAfterCallBack = true;
        txtDescuento.UpdateAfterCallBack = true;
        txtBonificacion.UpdateAfterCallBack = true;
        txtImporteRestante.UpdateAfterCallBack = true;
        txtSerie.UpdateAfterCallBack = true;
        txtFolio.UpdateAfterCallBack = true;
        txtImporte.UpdateAfterCallBack = true;

    }



    private void Save()
    {
        try
        {
            int intProspecto;
            int.TryParse(txtProspecto.Text, out intProspecto);

            decimal decImporte;
            decimal.TryParse(txtImporte.Text, out decImporte);

            Entity_ProspectoEsc obj = new Entity_ProspectoEsc();
            ProspectoEsc pros = new ProspectoEsc();

            obj.StrColonia = txtColonia.Text;
            obj.IntProspecto = intProspecto;
            obj.StrUsuario = Contabilidad.SEMSession.GetInstance.StrUsuario;
            obj.StrMaquina = Contabilidad.SEMSession.GetInstance.StrMaquina;
            obj.IntFolioInicial = txtFolio.Text == "" ? 0 : Convert.ToInt32(txtFolio.Text);
            string strFormaPago = ddlFormaPago.SelectedValue;
            string strMetodoPago = ddlMetodoPago.SelectedValue;


            bool res = false;
            res = pros.SaveNC(obj.IntProspecto, decImporte, obj.StrUsuario, obj.StrMaquina, strFormaPago, strMetodoPago, obj.IntFolioInicial);
            if (res)
            {
                Anthem.Manager.RegisterStartupScript(Page.GetType(), "Alerta", "alert('Se guardó con éxito.'); GetList(); ReFresh();", true);
                txtProspecto_TextChanged(null, null);
            }
        }
        catch (Exception ex)
        {
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "err", "alert('" + ex.Message + "'); GetList(); ", true);
        }
    }


    protected void txtProspecto_TextChanged(object sender, EventArgs e)
    {
       
        int intprospecto = 0;

        int.TryParse(txtProspecto.Text, out intprospecto);

        Entity_ProspectoEsc obj = new Entity_ProspectoEsc();
        ProspectoEsc pros = new ProspectoEsc();

        obj.IntProspecto = intprospecto;
        obj = pros.SelNC(obj);

        if (obj != null)
        {
            txtCalle.Text = obj.StrCalle;
            txtCP.Text = obj.IntCP.ToString();
            txtDescuento.Text = obj.DblDescuento.ToString();
            txtDireccion.Text = obj.StrDireccion;
            txtEmail.Text = obj.StrEmail;
            txtNombre.Text = obj.StrProspecto;
            txtPrecioEdificacion.Text = obj.DblPrecioEdificacion.ToString();
            txtPrecioTerreno.Text = obj.DblPrecioTerreno.ToString();
            txtRFC.Text = obj.StrRFC;
            txtTelefono.Text = obj.StrTelefono;
            txtTerreno.Text = obj.StrTerreno;
            txtAvaluo.Text = obj.DblAvaluo;
            txtBonificacion.Text = obj.dblBonificacion.ToString();
            txtImporteRestante.Text = obj.dblImporteRestante.ToString();
            txtSerie.Text = obj.strSerieFactura;
            txtFolio.Text = decimal.ToInt32(obj.dblFolioFactura).ToString();

            //cboPais.SelectedValue = obj.IntPais.ToString();
            //cboEstado.SelectedValue = obj.IntEstado.ToString();
            //cboEstado_SelectedIndexChanged(null, null);
            //cboMunicipio.SelectedValue = obj.IntCiudad.ToString();
            txtColonia.Text = obj.StrColonia;

            txtCiudad.Text = obj.StrCiudad;
            txtEstado.Text = obj.StrEstado;
            txtPais.Text = obj.StrPais;
            txtCiudad.UpdateAfterCallBack = true;
            txtPais.UpdateAfterCallBack = true;
            txtEstado.UpdateAfterCallBack = true;
            txtAvaluo.UpdateAfterCallBack = true;
            txtCalle.UpdateAfterCallBack = true;
            txtCP.UpdateAfterCallBack = true;
            txtDescuento.UpdateAfterCallBack = true;
            txtDireccion.UpdateAfterCallBack = true;
            txtEmail.UpdateAfterCallBack = true;
            txtNombre.UpdateAfterCallBack = true;
            txtPrecioEdificacion.UpdateAfterCallBack = true;
            txtPrecioTerreno.UpdateAfterCallBack = true;
            txtRFC.UpdateAfterCallBack = true;
            txtTelefono.UpdateAfterCallBack = true;
            txtTerreno.UpdateAfterCallBack = true;
            //cboPais.UpdateAfterCallBack = true;
            //cboEstado.UpdateAfterCallBack = true;
            //cboMunicipio.UpdateAfterCallBack = true;
            txtColonia.UpdateAfterCallBack = true;

            //List();

            txtBonificacion.UpdateAfterCallBack = true;
            txtImporteRestante.UpdateAfterCallBack = true;
            txtSerie.UpdateAfterCallBack = true;
            txtFolio.UpdateAfterCallBack = true;

            Anthem.Manager.RegisterStartupScript(Page.GetType(), "GetList", "GetList();", true);
        }
        else
        {
            Clear();
        }
    }

    /*WebMethods*/
    #region WebMethods
    [WebMethod]
    public static string[] GetList(int intProspecto)
    {
        string[] rtnData = new string[2];
        try
        {
            Entity_ProspectoEsc entPros = new Entity_ProspectoEsc();
            entPros.IntProspecto = intProspecto;

            ProspectoEsc obj = new ProspectoEsc();
            DataTable dt = obj.ListNC(intProspecto, 0);
            string JSONData = JsonConvert.SerializeObject(dt);
            rtnData[0] = "ok";
            rtnData[1] = JSONData;
        }
        catch
        {
            rtnData[0] = "no";
            rtnData[1] = "[]";
        }
        return rtnData;
    }
    #endregion

    [WebMethod]
    public static string[] EliminarNC(int strNC, int strEmpresa, int strFolio, int strProspecto)
    {

        string[] rtnData = new string[2];
        try
        {
            ProspectoEsc obj = new ProspectoEsc();
            obj.EliminarNC(strNC, strEmpresa, strFolio, strProspecto);

            rtnData[0] = "ok";
            rtnData[1] = "";
        }
        catch (Exception ex)
        {
            rtnData[0] = "no";
            rtnData[1] = ex.Message;
        }
        return rtnData;
    }


}