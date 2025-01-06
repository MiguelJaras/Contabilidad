using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Collections.Generic;
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
using System.IO;
using System.Data.OleDb;
using System.Xml;
using System.Xml.Linq;
using Excel;

public partial class Contabilidad_Compra_Opciones_NotasDeCredito : System.Web.UI.Page
{
    public string realPath;
    Pages_Base toolbar;
    string intEmpresa;
    string usuario;
    string strCuenta;
    string NomCuenta;
    int auxiliar;
    string strObra;
    string strAuxiliar;
    public string strDirectoryTemp;

    public int Operation
    {
        get { return ViewState["operation"] != null ? (int)ViewState["operation"] : 0; }
        set { ViewState["operation"] = value; }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        toolbar = (Pages_Base)this.Master;
        toolbar.PageEvent += new HandlerEvent(Me_Event);
        Anthem.Manager.Register(this);
        string end = (Request.ApplicationPath.EndsWith("/")) ? "" : "/";
        string path = Request.ApplicationPath + end;
        realPath = String.Format("http://{0}{1}{2}", Request.Url.Authority, path, "Img/dxpcFooterBack.gif");

        strDirectoryTemp = Server.MapPath("~/Temp/NotasCredito/");
        
        if (!IsPostBack && !IsCallback)
        {
            fuXML.Attributes.Add("onchange", "__doPostBack('lknFacturaXML', '');");
            fuPDF.Attributes.Add("onchange", "__doPostBack('lknFacturaPDF','');");
        }

        Anthem.Manager.Register(this);
        string target = Request.Params.Get("__EVENTTARGET");

        if (target != null)
        {
            if (target.Contains("lknFacturaXML"))
                lknXML_Click(null, null);

            if (target.Contains("lknFacturaPDF"))
                lnkFile_Click(this.fuPDF, FileType.FacturaPDF, lblPDF, hddArchivoFacturaPDF, true);
        }

        JavaScript();

    }

    #region lknXML_Click
    protected void lknXML_Click(object sender, EventArgs e)
    {
        try
        {
            FileInfo objExtension = new FileInfo(fuXML.FileName);
            string strExtension = objExtension.Extension;
            if (strExtension.ToLower() == ".xml")
            {
                string strSerie, strFolio, strMonto, strFolioFiscal, strSubTotal, strDescuento, strEmisorRFC, strReceptorRFC, strFecha, strTipoDeComprobante;
                string strIva, strRetencion, strRetencionISR, strDescripcion, strOC, strMetodoPago, strNumCtaPago;
                string strVersion, strUsoCFDI, strFormaPago, strTasaIva, strMoneda, strRetencionISRTasaCuouta, strRegimenFiscal, strProducto;
                XmlDocument doc = new XmlDocument();


                //Se carga xml del fileupload
                doc.Load(fuXML.FileContent);

                //Se remueven los prefijos namespace xmlns
                doc = UtilFunctions.RemoveAllNamespaces(doc);
                strVersion = UtilFunctions.GetValueAttribute(doc, "Comprobante", new string[] { "version" });
                strSerie = UtilFunctions.GetValueAttribute(doc, "Comprobante", new string[] { "serie" });
                strSerie = strSerie.Replace(" ", "");
                strFolio = UtilFunctions.GetValueAttribute(doc, "Comprobante", new string[] { "Folio", "NO.", "NUM" });
                strMonto = UtilFunctions.GetValueAttribute(doc, "Comprobante", new string[] { "Total", "Monto" });
                strFolioFiscal = UtilFunctions.GetValueAttribute(doc, "Complemento", new string[] { "UUID" });
                strSubTotal = UtilFunctions.GetValueAttribute(doc, "Comprobante", new string[] { "Subtotal" });
                strDescuento = UtilFunctions.GetValueAttribute(doc, "Comprobante", new string[] { "Descuento" });
                strEmisorRFC = UtilFunctions.GetValueAttribute(doc, "Emisor", new string[] { "Rfc" });
                strReceptorRFC = UtilFunctions.GetValueAttribute(doc, "Receptor", new string[] { "Rfc" });
                strFecha = UtilFunctions.GetValueAttribute(doc, "Comprobante", new string[] { "Fecha" });
                strMoneda = UtilFunctions.GetValueAttribute(doc, "Comprobante", new string[] { "Moneda" });                
                if (strSerie == "" && strFolio == "")
                    strFolio = strFolioFiscal.Replace("-", "").Substring(strFolioFiscal.Replace("-", "").Length - 12, 12);

                strTipoDeComprobante = UtilFunctions.GetValueAttribute(doc, "Comprobante", new string[] { "TipoDeComprobante" });
                if (strTipoDeComprobante != "E")
                {
                    Anthem.Manager.RegisterStartupScript(Page.GetType(), "msgXMLError", "alert('Error, el archivo que se intenta agregar no corresponde a una nota de credito');", true);
                    return;
                }

                //Se extrae iva, retencion y descripcion
                strUsoCFDI = UtilFunctions.GetValueAttribute(doc, "Receptor", new string[] { "UsoCFDI" });
                strFormaPago = UtilFunctions.GetValueAttribute(doc, "Comprobante", new string[] { "FormaPago" });
                strMetodoPago = UtilFunctions.GetValueAttribute(doc, "Comprobante", new string[] { "metodoDePago", "MetodoPago" });             
                strNumCtaPago = UtilFunctions.GetValueAttribute(doc, "Comprobante", new string[] { "NumCtaPago" });
                strRegimenFiscal = UtilFunctions.GetValueAttribute(doc, "Emisor", new string[] { "RegimenFiscal" });

                strProducto = UtilFunctions.GetValueAttribute(doc, "Concepto", new string[] { "NoIdentificacion" }); 

                try
                {
                    string strFileName = getFileNameFactura(FileType.FacturaXML, true);

                    //Se guarda en el directorio temporal
                    string strPath = strDirectoryTemp + strFileName;
                    fuXML.PostedFile.SaveAs(strPath);

                    FileFactura objFactura = new FileFactura(FileType.FacturaXML, strPath);
                    vsListFileFactura.Add(objFactura);

                    lblXML.Visible = true;
                    lblXML.Text = fuXML.FileName;
                    fuXML.Visible = false;
                    lblXML.UpdateAfterCallBack = true;
                    fuXML.UpdateAfterCallBack = true;

                    //Si es válida la factura se guarda fisicamente el archivo y se habiltan campos file
                    hddArchivoFacturaXML.Value = strFileName;

                    //Se guardan valores en controles hidden
                    hddSerie.Value = strSerie;
                    hddFolio.Value = strFolio;
                    hddMontoFac.Value = strMonto;
                    HddFolioFiscal.Value = strFolioFiscal.Replace("-", "");
                    hddEmisorRfc.Value = strEmisorRFC;
                    hddReceptorRfc.Value = strReceptorRFC;
                    hddMetodoPago.Value = strMetodoPago;
                    hddNumCtaPago.Value = strCuenta;
                    hddVersion.Value = strVersion;
                    hddUsoCFDI.Value = strUsoCFDI;
                    hddFormaPago.Value = strFormaPago;
                    hddMoneda.Value = strMoneda;
                    hddRegimenFiscal.Value = strRegimenFiscal;
                    hddProducto.Value = strProducto;

                    DateTime datFecha = DateTime.Now;
                    DateTime.TryParse(strFecha, out datFecha);
                    hddFecha.Value = datFecha.ToString("dd/MM/yyyy");

                }
                catch (Exception ex)
                {
                    Anthem.Manager.RegisterStartupScript(Page.GetType(), "msgXMLError", "alert('" + ex.Message + "');", true);
                }
            }
            else
                Anthem.Manager.RegisterStartupScript(Page.GetType(), "msgXMLError", "alert('Archivo no válido');", true);
        }
        catch (Exception EXE)
        {
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "msgXMLError", "alert('" + EXE.Message + "');", true);
        }
    }
    #endregion

    #region lnkFile_Click
    protected void lnkFile_Click(Anthem.FileUpload fuObject, FileType fileType, Label lblObject, Anthem.HiddenField hddObject, bool blnSave)
    {
        try
        {
            //Valida si contiene archivo
            if (fuObject.HasFile)
            {

                string strFileName = "", strPath;
                FileInfo objFileInfo = new FileInfo(fuObject.FileName);
                string strExtension = objFileInfo.Extension;
                string strNombreArchivo = objFileInfo.Name;
                string strNombrePDFOriginal = Path.GetFileNameWithoutExtension(strNombreArchivo);

                //Se valida el tipo de archivo
                bool blnArchivoValido = false;
                switch (fileType)
                {
                    case FileType.FacturaPDF:
                        if (strExtension.ToLower() == ".pdf") blnArchivoValido = true;
                        break;
                    case FileType.FacturaXML:
                        if (strExtension.ToLower() == ".xml") blnArchivoValido = true;
                        break;
                    case FileType.NotaPDF:
                        if (strExtension.ToLower() == ".pdf") blnArchivoValido = true;
                        break;
                    case FileType.NotaXML:
                        if (strExtension.ToLower() == ".xml") blnArchivoValido = true;
                        break;
                    case FileType.Remision:
                        if (strExtension.ToLower() == ".pdf") blnArchivoValido = true;
                        break;
                    default:
                        break;
                }
                if (blnArchivoValido)
                {
                    try
                    {
                        //Se guarda nombre original de la factura pdf para guardar temporalmente los archivos
                        if (fileType == FileType.FacturaPDF)
                        {
                            hddNombreArchivoPDFOriginal.Value = strNombrePDFOriginal;
                            hddNombreArchivoPDFOriginal.UpdateAfterCallBack = true;
                            fuXML.Enabled = true;
                            fuXML.UpdateAfterCallBack = true;
                        }

                        //Se guarda en la carpeta temporal
                        strFileName = getFileNameFactura(fileType, true);
                        strPath = strDirectoryTemp + strFileName;
                        fuObject.PostedFile.SaveAs(strPath);
                        FileFactura objFactura = new FileFactura(fileType, strPath);
                        vsListFileFactura.Add(objFactura);

                        //Se aplican propiedades a controles
                        lblObject.Visible = true;
                        lblObject.Text = fuObject.FileName;
                        hddObject.Value = strFileName;
                        fuObject.Visible = false;
                        fuObject.UpdateAfterCallBack = true;
                        fuObject.UpdateAfterCallBack = true;

                    }
                    catch (Exception ex)
                    {
                        Anthem.Manager.RegisterStartupScript(Page.GetType(), "msgXMLError", "alert('" + ex.Message + "');", true);
                    }
                    finally
                    {
                        fuObject = null;
                    }
                }
                else
                {
                    Anthem.Manager.RegisterStartupScript(Page.GetType(), "msgXMLError", "alert('Archivo no válido');", true);
                }
            }
        }
        catch (Exception ex) { Anthem.Manager.RegisterStartupScript(Page.GetType(), "msgXMLError", "alert('Error al tratar de agregar el archivo. " + ex.Message + "');", true); }
    }
    #endregion

    #region Page_PreRender
    protected void Page_PreRender(object sender, EventArgs e)
    {
        toolbar.List(false);
        toolbar.Print(false);
        toolbar.New(true);
        toolbar.Exportar(false);
        toolbar.Email(false);
        toolbar.Delete(false);        
    }
    #endregion

    #region txtProspecto_TextChanged
    protected void txtProspecto_TextChanged(object sender, EventArgs e)
    {
        try
        {
            int intprospecto = 0;
            intprospecto = txtProspecto.Text == "" ? 0 : Convert.ToInt32(txtProspecto.Text);

            Entity_ProspectoEsc obj = new Entity_ProspectoEsc();
            ProspectoEsc pros = new ProspectoEsc();

            obj.IntProspecto = intprospecto;
            obj = pros.Sel(obj);

            if (obj != null)
            {
                txtNombre.Text = obj.StrProspecto;
                txtNombre.UpdateAfterCallBack = true;
                BindGrid();
            }
            else
            {
                txtProspecto.Text = "";
                txtNombre.Text = "";
                //txtFolio.Text = "";
                //txtSerie.Text = "";

                //txtFolio.UpdateAfterCallBack = true;
                //txtSerie.UpdateAfterCallBack = true;
                txtNombre.UpdateAfterCallBack = true;
                txtProspecto.UpdateAfterCallBack = true;
            }
        }
        catch (Exception ex)
        {
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "msfSaErr", "alert('Prospecto incorrecto.');", true);
            Clear();
        }
    }
    #endregion

    #region JavaScript
    private void JavaScript()
    {
           
    }
    
    #endregion
   
    #region Clear
    private void Clear()
    {
        fuPDF.Visible = true;
        fuXML.Visible = true;
        fuXML.Enabled = false;
        lblPDF.Visible = false;
        lblXML.Visible = false;

        txtProspecto.Text = "";
        txtNombre.Text = "";
        grdList.DataSource = null;
        grdList.DataBind();
        //txtFolio.Text = "";
        //txtSerie.Text = "";

        //txtFolio.UpdateAfterCallBack = true;
        //txtSerie.UpdateAfterCallBack = true;
        lblPDF.UpdateAfterCallBack = true;
        lblXML.UpdateAfterCallBack = true;
        fuPDF.UpdateAfterCallBack = true;
        fuXML.UpdateAfterCallBack = true;
        txtNombre.UpdateAfterCallBack = true;
        grdList.UpdateAfterCallBack = true;
        txtProspecto.UpdateAfterCallBack = true;
    }
    #endregion

    #region Delete
    private void Delete()
    {
       
    }
    #endregion

    #region Save
    private void Save()
    {
        try
        {
            EntityNotaCreditoGenerar obj;
            obj = new EntityNotaCreditoGenerar();
            NotaCreditoGenerar fac = new NotaCreditoGenerar();

            bool value = false;

            int intProspecto = 0;
            string strReceptorRFC, strFactura, strFolioFiscal,strProducto, strRegimenFiscal;
            decimal dblImporte, dblTotalNota = 0, dblIva, dblSubTotal, dblRetencion, dblRetencionISR, dblDescuento, dblIvaNota, dblSubtotalNota, dblTasaIva;
            DateTime datFechaFac;
            string strOCR = "", strOCRNota = "", strPDF = "", strXML = "";
            string strIvaNota, strDescripcionNota, strSubtotalNota;
            string strMetodoPago, strCuentaPago, strRfcEmisor;
            string strVersion, strUsoCFDI, strFormaPago;
            string strMoneda = "", strRetencionISRTasaCuouta;
            int intRegimenFiscal;

            //Asignacion a variables
            dblImporte = 0;
            decimal.TryParse(hddMontoFac.Value, out dblImporte);
            strReceptorRFC = hddReceptorRfc.Value;
            strFactura = hddFolio.Value;
            strFolioFiscal = HddFolioFiscal.Value;        
            DateTime.TryParse(hddFecha.Value, out datFechaFac);              

            strMetodoPago = hddMetodoPago.Value;
            strCuentaPago = hddNumCtaPago.Value;
            strRfcEmisor = hddEmisorRfc.Value;
            strVersion = hddVersion.Value;
            strUsoCFDI = hddUsoCFDI.Value;
            strFormaPago = hddFormaPago.Value;
            strMoneda = hddMoneda.Value;

            strRegimenFiscal = hddRegimenFiscal.Value;
            int.TryParse(strRegimenFiscal, out intRegimenFiscal);
            int.TryParse(txtProspecto.Text, out intProspecto);

            obj.intProspecto = intProspecto;
            obj.strRFC = hddEmisorRfc.Value;
            obj.strSerie = "NCR";
            obj.decFolio = hddFolio.Value;
            obj.datFechaGen = datFechaFac.ToShortDateString().ToString();
            obj.strUsoCFDI = hddUsoCFDI.Value;
            obj.strFormaPago = hddFormaPago.Value;
            obj.strMetodopago = hddMetodoPago.Value;
            obj.strRegimenFiscal = hddRegimenFiscal.Value;
            obj.StrUsuario = Contabilidad.SEMSession.GetInstance.StrUsuario;
            obj.StrMaquina = Contabilidad.SEMSession.GetInstance.StrMaquina;
            obj.dblImporte = dblImporte;
            obj.strSerieFactura = "";// txtSerie.Text;
            obj.decFolioFactura = "";//txtFolio.Text;


            value = fac.Save(obj);

            if (value == true)
            {
                fuPDF.Visible = true;
                fuXML.Visible = true;
                fuXML.Enabled = false;
                lblPDF.Visible = false;
                lblXML.Visible = false;
                Digitalizacion();
                //txtFolio.Text = "";
                //txtSerie.Text = "";

                //txtFolio.UpdateAfterCallBack = true;
                //txtSerie.UpdateAfterCallBack = true;
                lblPDF.UpdateAfterCallBack = true;
                lblXML.UpdateAfterCallBack = true;
                fuPDF.UpdateAfterCallBack = true;
                fuXML.UpdateAfterCallBack = true;

                BindGrid();
            }

            Anthem.Manager.RegisterStartupScript(Page.GetType(), "msfSaErr", "alert('Los archivos se guardaron correctamente.');", true);

            obj = null;
            fac = null;         
        }
        catch (Exception ex)
        {
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "msfPolErr", "alert('" + ex.Message + "');", true);

            fuPDF.Visible = true;
            fuXML.Visible = true;
            fuXML.Enabled = false;
            lblPDF.Visible = false;
            lblXML.Visible = false;
            //txtFolio.Text = "";
            //txtSerie.Text = "";

            //txtFolio.UpdateAfterCallBack = true;
            //txtSerie.UpdateAfterCallBack = true;
            lblPDF.UpdateAfterCallBack = true;
            lblXML.UpdateAfterCallBack = true;
            fuPDF.UpdateAfterCallBack = true;
            fuXML.UpdateAfterCallBack = true;

            BindGrid();
        }          
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
                //Delete();
                break;
            case Event.List:
                BindGrid();
                break;
            default:
                break;
        }
    }
    #endregion    

    #region BindGrid
    public void BindGrid()
    {
        NotaCreditoGenerar fac = new NotaCreditoGenerar();
        EntityNotaCreditoGenerar obj = new EntityNotaCreditoGenerar();
        int intProspecto = 0;
        DataTable dt;

        if (txtProspecto.Text != "")
        {
            intProspecto = Convert.ToInt32(txtProspecto.Text);
            obj.intProspecto = intProspecto;
            dt = fac.GetList(obj);

            grdList.DataSource = dt;
            grdList.DataBind();
        }
        else
        {
            grdList.DataSource = null;
            grdList.DataBind();
        }

        grdList.UpdateAfterCallBack = true;
        fac = null;
        obj = null;
    }
    #endregion BindGrid

    public void Digitalizacion()
    {
        NotaCreditoGenerar fac = new NotaCreditoGenerar();

        string strFileName, strPathFile, strPathFileTemp;
        string strDirectory = Server.MapPath("~/Temp/NotasCredito/");
        foreach (FileFactura file in vsListFileFactura)
        {
            strFileName = getFileNameFactura(file.fileType, false); //Se obtiene nombre de archivo final
            strPathFile = strDirectory + strFileName;
            strPathFileTemp = file.strPathTemporal;

            byte[] bfile;

            System.IO.FileStream fs = new System.IO.FileStream(strPathFile, System.IO.FileMode.Open, System.IO.FileAccess.Read);
            System.IO.BinaryReader binaryReader = new System.IO.BinaryReader(fs);
            long byteLength = new System.IO.FileInfo(strPathFile).Length;
            bfile = binaryReader.ReadBytes((Int32)byteLength);

            int intProspecto = Convert.ToInt32(txtProspecto.Text);


            if (fac.DocumentosSave(2, 7, intProspecto, 9, 215, bfile, strFileName, Contabilidad.SEMSession.GetInstance.StrUsuario, Contabilidad.SEMSession.GetInstance.StrMaquina) != "true")
            {
                Anthem.Manager.RegisterStartupScript(Page.GetType(), "yes2", "alert('Ocurrio un error al guardar la constancia de situacion fiscal.');", true);
            }

        }       
                
    }

    #region DgrdList_RowDeleting
    protected void DgrdList_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        try
        {
            EntityNotaCreditoGenerar obj = new EntityNotaCreditoGenerar();
            NotaCreditoGenerar fac = new NotaCreditoGenerar();
            string value = "";

            obj.intProspecto = Convert.ToInt32(grdList.DataKeys[e.RowIndex].Values[0].ToString());
            obj.intDocumento = Convert.ToInt32(grdList.DataKeys[e.RowIndex].Values[1].ToString());
            obj.intNotaCredito = Convert.ToInt32(grdList.DataKeys[e.RowIndex].Values[2].ToString());

            if(fac.Delete(obj) == true)
                Anthem.Manager.RegisterStartupScript(Page.GetType(), "CuentaPosition", "alert('Se elimino el documento'); ", true);
            else
                Anthem.Manager.RegisterStartupScript(Page.GetType(), "msfPolErr23", "alert('Ocurrio un error al tratar de eliminar un documento.'); ", true);

            obj = null;
            fac = null;
            BindGrid();            
        }
        catch (Exception ex)
        {
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "msfPolErr", "alert('" + ex.Message + "');", true);
        }        
    }
    #endregion DgrdList_RowDeleting

    #region DgrdList_RowCreated
    protected void DgrdList_RowCreated(object sender, GridViewRowEventArgs e)
    {

    }
    #endregion

    #region getFileNameFactura
    public string getFileNameFactura(FileType enFileType, bool blnTempName)
    {
        string strFileName = "", strType = "", strExtension = "";
        //int intProveedor = Facturas.SEMSession.GetInstance.IntProveedor;
        string strFactura = hddNombreArchivoPDFOriginal.Value + "TMP";
        DateTime dtFecha = DateTime.Now;

        string strFecha = dtFecha.ToString("ddMMyyyy");
        switch (enFileType)
        {
            case FileType.FacturaPDF: //No.Prov-Fecha(DDMMYYY)-No.Factura ejemplo: 17-02092015-GAMA001.pdf
                strType = "";
                strExtension = ".pdf";
                break;
            case FileType.FacturaXML: //No.Prov-Fecha(DDMMYYY)-No.Factura ejemplo: 17-02092015-GAMA001.xml
                strType = "";
                strExtension = ".xml";
                break;
            case FileType.NotaPDF: //No.Prov-Fecha(DDMMYYY)-NC-No.Factura 17-02092015-NC-GAMA001.pdf
                strType = "-NC";
                strExtension = ".pdf";
                break;
            case FileType.NotaXML: //No.Prov-Fecha(DDMMYYY)-NC-No.Factura 17-02092015-NC-GAMA001.xml
                strType = "-NC";
                strExtension = ".xml";
                break;
            case FileType.Remision: //No.Prov-Fecha(DDMMYYY)-Remision-No.Factura. 17-02092015-Remision-GAMA001.pdf
                strType = "-Remision";
                strExtension = ".pdf";
                break;
            default:
                break;
        }
        strFileName = strFactura + strType + strExtension;

        return strFileName;
    }
    #endregion

    [System.Serializable]
    public class FileFactura
    {
        private FileType _fileType;
        private string _strPathTemporal;

        public FileFactura(FileType fileType, string strPathTemporal)
        {
            _fileType = fileType;
            _strPathTemporal = strPathTemporal;
        }

        public FileType fileType
        {
            get { return _fileType; }
            set { _fileType = value; }
        }
        public string strPathTemporal
        {
            get { return _strPathTemporal; }
            set { _strPathTemporal = value; }
        }
    }

    public enum FileType
    {
        FacturaPDF,
        FacturaXML,
        NotaPDF,
        NotaXML,
        Remision
    }

    private List<FileFactura> vsListFileFactura
    {
        get
        {
            if (!(ViewState["vsListFileFactura"] is List<FileFactura>))
                ViewState["vsListFileFactura"] = new List<FileFactura>();

            return (List<FileFactura>)ViewState["vsListFileFactura"];
        }
        set { ViewState["vsListFileFactura"] = value; }
    }   

}


