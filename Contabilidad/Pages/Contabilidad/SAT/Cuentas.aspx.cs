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
using System.Xml;
using System.Text;
using System.IO;
using System.Xml.Schema;
using System.Text;

public partial class Contabilidad_SAT_Cuentas : System.Web.UI.Page
{
    Report_SAT_Base toolbar;
    protected void Page_Load(object sender, EventArgs e)
    {
        toolbar = (Report_SAT_Base)this.Master;
        Anthem.Manager.Register(this);
        
        if (!IsPostBack)
        {
            btnExpandReportes.Attributes.Add("onClick", "ReportVisible(this,'" + pnlReportes1.ClientID + "');");
            Month();
            Year();
            txtEmpresa.Text = Contabilidad.SEMSession.GetInstance.IntEmpresa.ToString();
            txtEmpresa_TextChange(null, null);
            cboYear.SelectedValue = DateTime.Now.Year.ToString();
            cboMonth.SelectedValue = DateTime.Now.Month.ToString();
           
            JavaScript();
        }
    }

    #region JavaScript
    private void JavaScript()
    {
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtEmpresa", "var objText = new VetecText('" + txtEmpresa.ClientID + "', 'number', 4);", true);

        if (!IsPostBack && !IsCallback)
        {
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "focusss", "document.all('ctl00_CPHFilters_txtEmpresa').focus()", true);
        }
    }
    #endregion  

    #region Month
    private void Month()
    {
        cboMonth.Items.Insert(0, new ListItem("1.- Enero", "1"));
        cboMonth.Items.Insert(1, new ListItem("2.- Febrero", "2"));
        cboMonth.Items.Insert(2, new ListItem("3.- Marzo", "3"));
        cboMonth.Items.Insert(3, new ListItem("4.- Abril", "4"));
        cboMonth.Items.Insert(4, new ListItem("5.- Mayo", "5"));
        cboMonth.Items.Insert(5, new ListItem("6.- Junio", "6"));
        cboMonth.Items.Insert(6, new ListItem("7.- Julio", "7"));
        cboMonth.Items.Insert(7, new ListItem("8.- Agosto", "8"));
        cboMonth.Items.Insert(8, new ListItem("9.- Septiembre", "9"));
        cboMonth.Items.Insert(9, new ListItem("10.- Octubre", "10"));
        cboMonth.Items.Insert(10, new ListItem("11.- Noviembre", "11"));
        cboMonth.Items.Insert(11, new ListItem("12.- Diciembre", "12"));
        cboMonth.SelectedIndex = 0;

        cboMonth.Items.Insert(0, new ListItem("-- Seleccione --", "0"));
        cboMonth.SelectedIndex = 0;
        cboMonth.UpdateAfterCallBack = true;

        cboMonth.UpdateAfterCallBack = true;
    }
    #endregion      

    #region Year
    private void Year()
    {
        List list;
        list = new List();

        cboYear.DataSource = list.Ejercicio(Contabilidad.SEMSession.GetInstance.IntEmpresa, Contabilidad.SEMSession.GetInstance.IntSucursal);
        cboYear.DataTextField = "Id";
        cboYear.DataValueField = "strNombre";
        cboYear.DataBind();

        cboYear.Items.Insert(0, new ListItem("-- Seleccione --", "0"));
        cboYear.SelectedIndex = 0;
        cboYear.UpdateAfterCallBack = true;

        cboYear.UpdateAfterCallBack = true;

        list = null;
    }
    #endregion Year    

    #region txtEmpresa_TextChange
    protected void txtEmpresa_TextChange(object sender, EventArgs e)
    {
        Entity_Empresa obj;
        obj = new Entity_Empresa();
        Empresa emp;
        emp = new Empresa();

        obj.IntEmpresa = txtEmpresa.Text == "" ? Contabilidad.SEMSession.GetInstance.IntEmpresa : Convert.ToInt32(txtEmpresa.Text);
        obj = emp.Fill(obj.IntEmpresa);

        txtEmpresa.Text = obj.IntEmpresa.ToString();
        txtNombreEmpresa.Text = obj.StrNombre;
        hddSucursal.Value = emp.GetSucursal(obj.IntEmpresa.ToString());

        hddSucursal.UpdateAfterCallBack = true;
        txtEmpresa.UpdateAfterCallBack = true;
        txtNombreEmpresa.UpdateAfterCallBack = true;

        obj = null;
        emp = null;
    }
    #endregion            
   
    #region lknCuentas_Click
    protected void lknCuentas_Click(object sender, EventArgs e)
    {
        string[] arrDatos;
        arrDatos = new string[1];
        arrDatos[0] = txtEmpresa.Text;

        string query;
        string intFolio = "";

        query = sqlQuery("VetecMarfilAdmin..usp_tbCuentas_XML ", arrDatos);

        arrDatos = null;

        intFolio = ExportXML(query);

        string queryString = "?intEmpresa=" + txtEmpresa.Text + "&intFolio=" + intFolio + "&strType=C";
        Response.Redirect("../../../Utils/XML.aspx" + queryString);        
    }
    #endregion

    #region ExportXML
    private string ExportXML(string query)
    {
        Empresa emp;
        emp = new Empresa();
        Entity_Empresa obj;
        obj = new Entity_Empresa();

        Entity_DigCuentas objCuenta;
        objCuenta = new Entity_DigCuentas();
        DigCuentas cuenta;
        cuenta = new DigCuentas();

        Contabilidad.Bussines.Menu menu;
        menu = new Contabilidad.Bussines.Menu();
        DataTable dt;
        string result = "";

        dt = menu.BindGrid(query).Tables[0];

        int intEmpresa = Convert.ToInt32(txtEmpresa.Text);
        string intEjercicio = cboYear.SelectedValue;
        string intMes = cboMonth.SelectedValue;

        obj.IntEmpresa = intEmpresa;
        obj = emp.Sel(obj);

        if (obj != null)
        {
            //string fileName = HttpContext.Current.Server.MapPath("~/Temp/") + "Excel" + "_" + System.IO.Path.GetRandomFileName().Replace(".", "") + ".xml";
            DataRow dr;
            XmlDocument xmldoc = new XmlDocument();
            XmlNode docNode = xmldoc.CreateXmlDeclaration("1.0", "UTF-8", null);
            xmldoc.AppendChild(docNode);


            XmlElement Catalogo = xmldoc.CreateElement("catalogocuentas", "Catalogo", "http://tempuri.org/foo");
            Catalogo.SetAttribute("xmlns:catalogocuentas", "www.sat.gob.mx/esquemas/ContabilidadE/1_1/CatalogoCuentas");
            Catalogo.SetAttribute("xmlns:xsi", "http://www.w3.org/2001/XMLSchema-instance");
            Catalogo.SetAttribute("xsi:schemaLocation", "http://www.sat.gob.mx/esquemas/ContabilidadE/1_1/CatalogoCuentas/CatalogoCuentas_1_1.xsd");

            xmldoc.AppendChild(Catalogo);

            XmlAttribute Version = xmldoc.CreateAttribute("Version");
            Version.Value = "1.0";
            XmlAttribute RFC = xmldoc.CreateAttribute("RFC");
            RFC.Value = obj.StrRfc.Replace("-", "");
            XmlAttribute TotalCtas = xmldoc.CreateAttribute("TotalCtas");
            TotalCtas.Value = dt.Rows.Count.ToString();
            XmlAttribute Mes = xmldoc.CreateAttribute("Mes");
            Mes.Value = Convert.ToInt32(intMes) < 10 ? "0" + intMes : intMes;
            XmlAttribute Ano = xmldoc.CreateAttribute("Ano");
            Ano.Value = intEjercicio;
            XmlAttribute Certificado = xmldoc.CreateAttribute("Certificado");
            Certificado.Value = "MIIEiTCCA3GgAwIBAgIUMDAwMDEwMDAwMDAyMDI3NDgzOTcwDQYJKoZIhvcNAQEFBQAwggGVMTgwNgYDVQQDDC9BLkMuIGRlbCBTZXJ2aWNpbyBkZSBBZG1pbmlzdHJhY2nDs24gVHJpYnV0YXJpYTEvMC0GA1UECgwmU2VydmljaW8gZGUgQWRtaW5pc3RyYWNpw7NuIFRyaWJ1dGFyaWExODA2BgNVBAsML0FkbWluaXN0cmFjacOzbiBkZSBTZWd1cmlkYWQgZGUgbGEgSW5mb3JtYWNpw7NuMSEwHwYJKoZIhvcNAQkBFhJhc2lzbmV0QHNhdC5nb2IubXgxJjAkBgNVBAkMHUF2LiBIaWRhbGdvIDc3LCBDb2wuIEd1ZXJyZXJvMQ4wDAYDVQQRDAUwNjMwMDELMAkGA1UEBhMCTVgxGTAXBgNVBAgMEERpc3RyaXRvIEZlZGVyYWwxFDASBgNVBAcMC0N1YXVodMOpbW9jMRUwEwYDVQQtEwxTQVQ5NzA3MDFOTjMxPjA8BgkqhkiG9w0BCQIML1Jlc3BvbnNhYmxlOiBDZWNpbGlhIEd1aWxsZXJtaW5hIEdhcmPDrWEgR3VlcnJhMB4XDTEzMDEwODAxMzY1NFoXDTE3MDEwODAxMzY1NFowgcoxIzAhBgNVBAMTGk1BUkZJTCBERVNBUlJPTExPIFNBIERFIENWMSMwIQYDVQQpExpNQVJGSUwgREVTQVJST0xMTyBTQSBERSBDVjEjMCEGA1UEChMaTUFSRklMIERFU0FSUk9MTE8gU0EgREUgQ1YxJTAjBgNVBC0THE1ERTg5MDQyOE1YMyAvIEdBREg2NzExMTNBSDIxHjAcBgNVBAUTFSAvIEdBREg2NzExMTNITU5STkIwMTESMBAGA1UECxMJUFJJTkNJUEFMMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDHP2pkT19CakJL6omkrZgZxIdLTqMMbW1UbzdigYrPv/ePc0fLrITTaKyDACcv0yNZ35rkpmmqZLWOTSwzzT8ObzpYH9QNS6gRLYoGhtfvd8H6W373CmSKjmpYPth+cARDEk5R9mydgP5ImZl8d6FYlrjA+8m6vKuXOJJ6CzcfLwIDAQABox0wGzAMBgNVHRMBAf8EAjAAMAsGA1UdDwQEAwIGwDANBgkqhkiG9w0BAQUFAAOCAQEAnRYqW/bZZs4p4/9RUXibxiqzXpyFnlWKgIoeSRPQmhzeH+xrCYkyhsz1T7FnsOuugTdgNOkwp1pME0/r3L+gzMUaNi/8eBAlisgmnsl3qohL1YPGL+j4Dy2+vsHoB7JplOE9pkCN9VMiSzJZsCeUmTJoi7cGKZ9U/w0yIfrpz7SLnQ4asOLYKF9c9XCD+S8oRU9dc0WIQl4b3dV6sd/w0nr8Qhu+V9FLzWTdx22Zdj8F3R+8i4BdGrqgrLN9mawFZT2+sGKQjRfWbdesSqQChXiwVuWfxZp0Wx5ujO1Ffb1Q8fPtHeDbOV8YGHx1Tqp0/U5DZ2XmEy22tF0C5SwY+Q==";
                                 
            XmlAttribute noCertificado = xmldoc.CreateAttribute("noCertificado");
            noCertificado.Value = "00001000000202748397";
            XmlAttribute Sello = xmldoc.CreateAttribute("Sello");
            Sello.Value = "TGKVDJcmyfHSb/joTMz0TUClRHKGokgGY8UYDkdqv/yhkRs+YhYelYHWv58Z6f7Eg8sUUo2ptEzt7lNdUAsvRKMehj6LF+Cg+KXfcNEIGw1pC99muKFsjmuaBMn7uZnHWjuqIvWFnvDT5Pvo0HplngH2y1uRo9FLQY7rXbGHa48=";

            Catalogo.Attributes.Append(Version);
            Catalogo.Attributes.Append(RFC);
            Catalogo.Attributes.Append(TotalCtas);
            Catalogo.Attributes.Append(Mes);
            Catalogo.Attributes.Append(Ano);
            Catalogo.Attributes.Append(Certificado);
            Catalogo.Attributes.Append(noCertificado);
            Catalogo.Attributes.Append(Sello);

            StringBuilder header = new StringBuilder();
            string strMes = Convert.ToInt32(intMes) < 10 ? "0" + intMes.ToString() : intMes.ToString();
            string fileName = obj.StrRfc.Replace("-", "") + intEjercicio.ToString() + strMes + "CT.xml";

            header.Append("<?xml version='1.0' encoding='UTF-8'?><catalogocuentas:Catalogo xmlns:catalogocuentas='www.sat.gob.mx/esquemas/ContabilidadE/1_1/CatalogoCuentas' xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xsi:schemaLocation='www.sat.gob.mx/esquemas/ContabilidadE/1_1/CatalogoCuentas http://www.sat.gob.mx/esquemas/ContabilidadE/1_1/CatalogoCuentas/CatalogoCuentas_1_1.xsd' Version='1.1' ");
            header.Append("RFC='" + obj.StrRfc.Replace("-", "") + "' ");
            header.Append("Anio='" + intEjercicio + "' ");
            header.Append("Mes='" + strMes + "' >");
            //header.Append("Certificado='MIIEizCCA3OgAwIBAgIUMDAwMDEwMDAwMDAzMDU5MDg5NzUwDQYJKoZIhvcNAQEFBQAwggGKMTgwNgYDVQQDDC9BLkMuIGRlbCBTZXJ2aWNpbyBkZSBBZG1pbmlzdHJhY2nDs24gVHJpYnV0YXJpYTEvMC0GA1UECgwmU2VydmljaW8gZGUgQWRtaW5pc3RyYWNpw7NuIFRyaWJ1dGFyaWExODA2BgNVBAsML0FkbWluaXN0cmFjacOzbiBkZSBTZWd1cmlkYWQgZGUgbGEgSW5mb3JtYWNpw7NuMR8wHQYJKoZIhvcNAQkBFhBhY29kc0BzYXQuZ29iLm14MSYwJAYDVQQJDB1Bdi4gSGlkYWxnbyA3NywgQ29sLiBHdWVycmVybzEOMAwGA1UEEQwFMDYzMDAxCzAJBgNVBAYTAk1YMRkwFwYDVQQIDBBEaXN0cml0byBGZWRlcmFsMRQwEgYDVQQHDAtDdWF1aHTDqW1vYzEVMBMGA1UELRMMU0FUOTcwNzAxTk4zMTUwMwYJKoZIhvcNAQkCDCZSZXNwb25zYWJsZTogQ2xhdWRpYSBDb3ZhcnJ1YmlhcyBPY2hvYTAeFw0xNTAxMjMxNDQwNDVaFw0xOTAxMjMxNDQwNDVaMIHXMSIwIAYDVQQDExlIWUwgVEVDSE5PTE9HSUVTIFNBIERFIENWMSIwIAYDVQQpExlIWUwgVEVDSE5PTE9HSUVTIFNBIERFIENWMSIwIAYDVQQKExlIWUwgVEVDSE5PTE9HSUVTIFNBIERFIENWMSUwIwYDVQQtExxIVEUwNTA5MjNOVDggLyBGQU1BNzUwODEyN0I1MR4wHAYDVQQFExUgLyBGQVhNNzUwODEySE5FTFhSMDExIjAgBgNVBAsTGUhZTCBURUNITk9MT0dJRVMgU0EgREUgQ1YwgZ8wDQYJKoZIhvcNAQEBBQADgY0AMIGJAoGBALEFXazDkO51fldlKUvzo8Uji65aPDA1d7ajqGdXb0RWolVTe/ZuqU/o39O4MGNDotI14EOy2oACS/rxxyHNRHVdAq1RWj+wb8nnFlln4ug15umXDn6rR+zHKGZMKy9RUNMEVaJldvdRQ7kKrq1Xy09FTwSbsX6Gej4NvTVOjYXPAgMBAAGjHTAbMAwGA1UdEwEB/wQCMAAwCwYDVR0PBAQDAgbAMA0GCSqGSIb3DQEBBQUAA4IBAQAKrOPV0BHoSTjT9qw2CenlEWbOqqOQkq5A/xvG2vKX9gcwbXYuGBCzEoalLKPr/y5wRmvvjgL77FWB2g8TY/wKVzT0eVsK8E6Pf842Q2F7lJdrrIxLDTxKmY6cPfLpAkdjmXvSaS+AbLUb+0tpELFg6pFNci3/wFbh9fWx3uANQMPXdgWUtKeUaDT3Wmkn2HznC0yPZfGf7V3rCJHVcumA1COgj4KvDtPRHXcB7eY9o/E3Rm4W6RlvcV6LH0ohg8wj84Qtk5+7QKBdtexrkBt/FOXEC6X9IXwz1RQqihS++HFRCkvKo3R5j3//SP3P3u9eW1KBalsITvRwum4965rb' ");
            //header.Append("noCertificado='00001000000305908975' >");
            //header.Append("Sello='G4y1/eo46TldGPZDFSZBYQSYb9a8qu8DlzQ1OnN59vYA4T1YZPJEtM/+VTBe2JwKJeUsThItJ5Wy2fqMZxuyTnU4vvRYtfDy/LTbF1MZ2yJihdSEDxkFV5+MSf5a4IixiDKA0avLnj9tuVUPCjVUrCs8LBnxmOthncEVCGD7fWA=' >");

            StringBuilder cuentas = new StringBuilder();

            for (int i = 0; i < dt.Rows.Count; i++)
            {
                dr = dt.Rows[i];

                cuentas.Append("<catalogocuentas:Ctas CodAgrup='" + dr["CodAgrup"].ToString() + "' NumCta='" + dr["NumCta"].ToString() + "' Desc='" + dr["Desc"].ToString() + "' Nivel='" + dr["Nivel"].ToString() + "' Natur='" + dr["Natur"].ToString() + "' />");
                //XmlElement Ctas = xmldoc.CreateElement("catalogocuentas", "1", "Ctas");
                //XmlNode Ctas = xmldoc.CreateElement("Ctas");
                //Catalogo.AppendChild(Ctas);

                //XmlAttribute CodAgrup = xmldoc.CreateAttribute("CodAgrup");
                //CodAgrup.Value = dr["CodAgrup"].ToString();
                //XmlAttribute NumCta = xmldoc.CreateAttribute("NumCta");
                //NumCta.Value = dr["NumCta"].ToString();
                //XmlAttribute Desc = xmldoc.CreateAttribute("Desc");
                //Desc.Value = dr["Desc"].ToString();
                //XmlAttribute Nivel = xmldoc.CreateAttribute("Nivel");
                //Nivel.Value = dr["Nivel"].ToString();
                //XmlAttribute Natur = xmldoc.CreateAttribute("Natur");
                //Natur.Value = dr["Natur"].ToString();

                //Ctas.Attributes.Append(CodAgrup);
                //Ctas.Attributes.Append(NumCta);
                //Ctas.Attributes.Append(Desc);
                //Ctas.Attributes.Append(Nivel);
                //Ctas.Attributes.Append(Natur);
            }


            MemoryStream ms = new MemoryStream();
            //xmldoc.OuterXml.Replace("schemaLocation","xsi:schemaLocation");
            //xmldoc.InnerXml = "<?xml version='1.0' encoding='UTF-8'?><catalogocuentas:Catalogo xmlns:catalogocuentas='www.sat.gob.mx/esquemas/ContabilidadE/1_1/CatalogoCuentas' xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xsi:schemaLocation='www.sat.gob.mx/esquemas/ContabilidadE/1_1/CatalogoCuentas http://www.sat.gob.mx/esquemas/ContabilidadE/1_1/CatalogoCuentas/CatalogoCuentas_1_1.xsd' Version='1.1' RFC='HTE050923NT8' Anio='2015' Mes='01' Sello='G4y1/eo46TldGPZDFSZBYQSYb9a8qu8DlzQ1OnN59vYA4T1YZPJEtM/+VTBe2JwKJeUsThItJ5Wy2fqMZxuyTnU4vvRYtfDy/LTbF1MZ2yJihdSEDxkFV5+MSf5a4IixiDKA0avLnj9tuVUPCjVUrCs8LBnxmOthncEVCGD7fWA=' noCertificado='00001000000305908975' Certificado='MIIEizCCA3OgAwIBAgIUMDAwMDEwMDAwMDAzMDU5MDg5NzUwDQYJKoZIhvcNAQEFBQAwggGKMTgwNgYDVQQDDC9BLkMuIGRlbCBTZXJ2aWNpbyBkZSBBZG1pbmlzdHJhY2nDs24gVHJpYnV0YXJpYTEvMC0GA1UECgwmU2VydmljaW8gZGUgQWRtaW5pc3RyYWNpw7NuIFRyaWJ1dGFyaWExODA2BgNVBAsML0FkbWluaXN0cmFjacOzbiBkZSBTZWd1cmlkYWQgZGUgbGEgSW5mb3JtYWNpw7NuMR8wHQYJKoZIhvcNAQkBFhBhY29kc0BzYXQuZ29iLm14MSYwJAYDVQQJDB1Bdi4gSGlkYWxnbyA3NywgQ29sLiBHdWVycmVybzEOMAwGA1UEEQwFMDYzMDAxCzAJBgNVBAYTAk1YMRkwFwYDVQQIDBBEaXN0cml0byBGZWRlcmFsMRQwEgYDVQQHDAtDdWF1aHTDqW1vYzEVMBMGA1UELRMMU0FUOTcwNzAxTk4zMTUwMwYJKoZIhvcNAQkCDCZSZXNwb25zYWJsZTogQ2xhdWRpYSBDb3ZhcnJ1YmlhcyBPY2hvYTAeFw0xNTAxMjMxNDQwNDVaFw0xOTAxMjMxNDQwNDVaMIHXMSIwIAYDVQQDExlIWUwgVEVDSE5PTE9HSUVTIFNBIERFIENWMSIwIAYDVQQpExlIWUwgVEVDSE5PTE9HSUVTIFNBIERFIENWMSIwIAYDVQQKExlIWUwgVEVDSE5PTE9HSUVTIFNBIERFIENWMSUwIwYDVQQtExxIVEUwNTA5MjNOVDggLyBGQU1BNzUwODEyN0I1MR4wHAYDVQQFExUgLyBGQVhNNzUwODEySE5FTFhSMDExIjAgBgNVBAsTGUhZTCBURUNITk9MT0dJRVMgU0EgREUgQ1YwgZ8wDQYJKoZIhvcNAQEBBQADgY0AMIGJAoGBALEFXazDkO51fldlKUvzo8Uji65aPDA1d7ajqGdXb0RWolVTe/ZuqU/o39O4MGNDotI14EOy2oACS/rxxyHNRHVdAq1RWj+wb8nnFlln4ug15umXDn6rR+zHKGZMKy9RUNMEVaJldvdRQ7kKrq1Xy09FTwSbsX6Gej4NvTVOjYXPAgMBAAGjHTAbMAwGA1UdEwEB/wQCMAAwCwYDVR0PBAQDAgbAMA0GCSqGSIb3DQEBBQUAA4IBAQAKrOPV0BHoSTjT9qw2CenlEWbOqqOQkq5A/xvG2vKX9gcwbXYuGBCzEoalLKPr/y5wRmvvjgL77FWB2g8TY/wKVzT0eVsK8E6Pf842Q2F7lJdrrIxLDTxKmY6cPfLpAkdjmXvSaS+AbLUb+0tpELFg6pFNci3/wFbh9fWx3uANQMPXdgWUtKeUaDT3Wmkn2HznC0yPZfGf7V3rCJHVcumA1COgj4KvDtPRHXcB7eY9o/E3Rm4W6RlvcV6LH0ohg8wj84Qtk5+7QKBdtexrkBt/FOXEC6X9IXwz1RQqihS++HFRCkvKo3R5j3//SP3P3u9eW1KBalsITvRwum4965rb'> " + cuentas.ToString() + " </catalogocuentas:Catalogo>";
            xmldoc.InnerXml = header.ToString() + cuentas.ToString() + " </catalogocuentas:Catalogo>";
            xmldoc.Save(ms);
            byte[] bytes = ms.ToArray();

            objCuenta.IntEmpresa = intEmpresa;
            objCuenta.IntEjercicio = Convert.ToInt32(intEjercicio);
            objCuenta.IntMes = Convert.ToInt32(intMes);
            objCuenta.IntFolio = 0;
            objCuenta.XMLFileName = fileName;
            objCuenta.XMLFile = bytes;
            objCuenta.StrUsuario = Contabilidad.SEMSession.GetInstance.StrUsuario;
            objCuenta.StrMaquina = Contabilidad.SEMSession.GetInstance.StrMaquina;

            result = cuenta.Save(objCuenta);
        }

        obj = null;
        emp = null;
        objCuenta = null;
        objCuenta = null;

        return result;
    }
    #endregion

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
  
}

