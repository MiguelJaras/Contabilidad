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

public partial class Pages_Opciones_ProspectoFac : System.Web.UI.Page
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
        dataList = new StringBuilder();
        dataColumns = new StringBuilder();
        colModel = new StringBuilder();
        dataColony = new StringBuilder();

        if (!IsPostBack && !IsCallback)
        {
            txtImporteFideicomiso.Visible = false;
            lblImporteFideicomiso.Visible = false;
        }
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
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtImporteFideicomiso", "var objText = new VetecText('" + txtImporteFideicomiso.ClientID + "', 'decimal', 18, 2);", true);
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

            case Event.Email:
                EnviarEmail();
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

   
    #region Size
    private string Size(string data)
    {
        string result = "";
        if (data.ToUpper().Contains("FECHA"))
            result = "65";
        else
        {
            if (data.ToUpper().Contains("#"))
                result = "40";
            else
            {
                if (data.ToUpper().Contains("CLIENTE"))
                    result = "200";
                else
                    result = "100";
            }
        }

        return result;
    }
    #endregion

    #region TypeValue
    private string TypeValue(string data)
    {
        string result = "";
        switch (data)
        {
            case "System.String":
                result = "align: 'Left'";
                break;
            case "System.Boolean":
                result = "align: 'Center'";
                break;
            case "System.DateTime":
                result = "align: 'Center'";
                break;
            case "System.Decimal":
                result = "align: 'Right'";
                break;
            case "System.Double":
                result = "align: 'Right'";
                break;
            case "System.Int32":
                result = "align: 'Right'";
                break;
            case "System.Int16":
                result = "align: 'Right'";
                break;
            case "System.Int64":
                result = "align: 'Right'";
                break;
        }
        return result;
    }
    #endregion

    private void Save()
    {
        try
        {
            int intProspecto;
            int.TryParse(txtProspecto.Text, out intProspecto);

            if (intProspecto > 0)
            {
                bool bPublicoGeneral;
                bPublicoGeneral = chkPG.Checked;
                Entity_ProspectoEsc obj = new Entity_ProspectoEsc();
                ProspectoEsc pros = new ProspectoEsc();
                obj.StrColonia = txtColonia.Text;
                obj.IntProspecto = intProspecto;
                obj.StrUsuario = Contabilidad.SEMSession.GetInstance.StrUsuario;
                obj.StrMaquina = Contabilidad.SEMSession.GetInstance.StrMaquina;
                obj.bPublicoGeneral = bPublicoGeneral;
                obj.BFideicomiso = chkFideicomiso.Checked == true ? 1 : 0;
                obj.DblImporteFideicomiso = txtImporteFideicomiso.Text == "" ? 0 : Convert.ToDecimal(txtImporteFideicomiso.Text);
                obj.BServicioCons= chkServCons.Checked== true?1:0;
                obj.DblServicioCons = txtServCons.Text == "" ? 0 : Convert.ToDecimal(txtServCons.Text);
                bool res = false;
                res = pros.Save(obj);
                if (res)
                {
                    Anthem.Manager.RegisterStartupScript(Page.GetType(), "Alerta", "alert('Se guardó con éxito.'); GetList();", true);
                }
            }
        }
        catch (Exception ex)
        {
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "err", "alert('" + ex.Message + "');", true);
        }
    }

    #endregion
    protected void txtProspecto_TextChanged(object sender, EventArgs e)
    {
        int intprospecto = 0;
        intprospecto = txtProspecto.Text == "" ? 0 : Convert.ToInt32(txtProspecto.Text);

        Entity_ProspectoEsc obj = new Entity_ProspectoEsc();
        ProspectoEsc pros = new ProspectoEsc();

        obj.IntProspecto = intprospecto;
        obj = pros.Sel(obj);

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
            //cboPais.SelectedValue = obj.IntPais.ToString();
            //cboEstado.SelectedValue = obj.IntEstado.ToString();
            //cboEstado_SelectedIndexChanged(null, null);
            //cboMunicipio.SelectedValue = obj.IntCiudad.ToString();
            txtColonia.Text = obj.StrColonia;
            chkPG.Checked = obj.bPublicoGeneral;
            txtServCons.Text = obj.DblServicioCons.ToString();
           

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
            chkPG.UpdateAfterCallBack = true;
            txtServCons.UpdateAfterCallBack = true; 
            //Anthem.Manager.RegisterStartupScript(Page.GetType(), "GetList", "GetList();", true);
            //List();
        }
    }


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
        txtImporteFideicomiso.Text = "";
        chkFideicomiso.Checked = false;
        chkServCons.Checked = false;
        txtServCons.Text = "";

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
        txtImporteFideicomiso.UpdateAfterCallBack = true;
        chkFideicomiso.UpdateAfterCallBack = true;
        txtServCons.UpdateAfterCallBack = true;
    }

    protected void EnviarEmail()
    {
        int intProspecto;
        int.TryParse(txtProspecto.Text, out intProspecto);
        if (intProspecto > 0)
        {
            string strNombreCliente = txtNombre.Text;
            string strEmail = txtEmail.Text;


            if (strEmail != "")
            {

                Entity_ProspectoEsc entPros = new Entity_ProspectoEsc();
                entPros.IntProspecto = intProspecto;
                ProspectoEsc obj = new ProspectoEsc();
                DataTable dt = obj.List(intProspecto, 0);

                if (dt.Rows.Count > 0)
                {


                    MailAddress strFrom = new MailAddress("SEM@marfil.com", "Marfil Sistemas");
                    string strContenido = "";
                    string local = AppDomain.CurrentDomain.BaseDirectory + "Temp\\EnvioFacturas.htm";
                    HtmlDocument doc = new HtmlDocument();
                    doc.Load(local);
                    doc.Load(local);
                    strContenido = doc.DocumentNode.InnerHtml;
                    strContenido = strContenido.Replace("[@FECHA]", DateTime.Now.ToString("dd/MM/yyyy"));
                    strContenido = strContenido.Replace("[@CLIENTE]", strNombreCliente);


                    List<MailAddress> lstTo = new List<MailAddress>();
                    List<MailAddress> lstCC = new List<MailAddress>();
                    List<MailAddress> lstBBC = new List<MailAddress>();
                    lstTo.Add(new MailAddress("juliosoto@marfil.com", strNombreCliente));

                    lstBBC.Add(new MailAddress("juliosoto@marfil.com", "Julio César"));
                    lstBBC.Add(new MailAddress("rubenmora@marfil.com", "Ruben Mora"));
                    

                    List<string> lstAttachment = new List<string>();
                    for (int i = 0; i < dt.Rows.Count; i++)
                    {
                        int intEmpresa = int.Parse(dt.Rows[i]["intEmpresa"].ToString());
                        string strPDF = dt.Rows[i]["PDF"].ToString();
                        string strXML = dt.Rows[i]["XML"].ToString();
                        string strFilePDFAtt = @"\\Marfil-nas\sem\Contabilidad\Facturas\" + intEmpresa.ToString() + "\\" + strPDF;
                        string strFileXMLAtt = @"\\Marfil-nas\sem\Contabilidad\Facturas\" + intEmpresa.ToString() + "\\" + strXML;

                        lstAttachment.Add(strFilePDFAtt);
                        lstAttachment.Add(strFileXMLAtt);

                    }
                    Entity_Email entEmail = new Entity_Email(strFrom, strContenido, lstTo, "Envío de Facturas", lstAttachment);
                    entEmail.lstBBC = lstBBC;
                    entEmail.lstCC = lstCC;


                    Email objEmail = new Email();
                    objEmail.Send(entEmail);
                }
            }
            else
            {
                Anthem.Manager.RegisterStartupScript(Page.GetType(), "GetList", "Favor de ingresar un Email.", true);
            }
        }
        else
        {
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "GetList", "Favor de seleccionar un prospecto.", true);
        }

    }

    public void chkFideicomiso_change(object sender, EventArgs e)
    {
        if (chkFideicomiso.Checked)
        {
            txtImporteFideicomiso.Visible = true;
            lblImporteFideicomiso.Visible = true;
        }
        else {
            txtImporteFideicomiso.Visible = false;
            lblImporteFideicomiso.Visible = false;
        }
    }

    #region btnPreview_Click
    protected void btnPreview_Click(object sender, EventArgs e)
    {
        Anthem.LinkButton Preview = (Anthem.LinkButton)sender;
        string IdDocumento;

        IdDocumento = Preview.CommandArgument;

        Response.Redirect("Archivo.aspx?IdDocumento=" + IdDocumento);

    }
    #endregion

   

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
            DataTable dt = obj.List(intProspecto, 0);
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

    [WebMethod]
    public static string[] SaveFormaPago(int intFactura, string strMetodoPago, string strFormaPago)
    {
        string[] rtnData = new string[2];
        try
        {
            ProspectoEsc obj = new ProspectoEsc();
            obj.SaveFormaPago(intFactura, strMetodoPago, strFormaPago,"G01");
            
            rtnData[0] = "ok";
            rtnData[1] = "";
        }
        catch(Exception ex)
        {
            rtnData[0] = "no";
            rtnData[1] = ex.Message;
        }
        return rtnData;
    }

    [WebMethod]
    public static string[] GenerarFacturas(int intProspecto)
    {
        string[] rtnData = new string[2];
        try
        {
            ProspectoEsc obj = new ProspectoEsc();
            obj.SaveGenerar(intProspecto);

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
    #endregion

    public void chkServicioCons_change(object sender, EventArgs e)
    {
        if (chkServCons.Checked)
        {
            txtServCons.Visible = true;
            lblServCons.Visible = true;
        }
        else
        {
            txtServCons.Visible = false;
            lblServCons.Visible = false;
        }
    }


    [WebMethod]
    public static string[] EliminarFacturas(int strFactura, int strEmpresa, int strFolio,int strProspecto)
    {

        string[] rtnData = new string[2];
        try
        {
            ProspectoEsc obj = new ProspectoEsc();
            obj.EliminarFacturas(strFactura, strEmpresa, strFolio, strProspecto);

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