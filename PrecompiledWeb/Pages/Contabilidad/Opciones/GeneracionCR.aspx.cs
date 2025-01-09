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
using DevExpress.Web.ASPxGridView;
using System.Data.SqlClient;
using Contabilidad.Bussines;
using Contabilidad.Entity;
using System.IO;
using System.Data.OleDb;
using Excel;

public partial class Contabilidad_Compra_Opciones_GeneracionCR : System.Web.UI.Page
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
        
        if (!IsPostBack && !IsCallback)
        {
            txtFechaInicial.Text = DateTime.Now.ToString("dd/MM/yyyy");
            hddClose.Value = "0";
            txtEmpresa.Text = Contabilidad.SEMSession.GetInstance.IntEmpresa.ToString();
            txtEmpresa_TextChange(null, null);

        }

        ImgDate.OnClientClick = "if(self.gfPop)gfPop.fPopCalendar(document.getElementById('" + txtFechaInicial.ClientID + "')); giDatePos=0; return false;";
        JavaScript();

        string a = Request.Params.Get("__EVENTTARGET");
        string argument = Request.Params.Get("__EVENTARGUMENT");

    }

    protected void Page_PreRender(object sender, EventArgs e)
    {
        toolbar.List(false);
        toolbar.Print(false);
        toolbar.New(true);
        toolbar.Exportar(false);
        toolbar.Email(false);
        toolbar.Delete(false);        
    }

    

    #region JavaScript
    private void JavaScript()
    {
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtEmpresa", "var objText = new VetecText('" + txtEmpresa.ClientID + "', 'number', 12);", true);        
    }
    
    #endregion

    #region Clear
    private void Clear()
    {
        txtTipoMovto.Text = "";
        txtConcepto.Text = "";
        txtFechaInicial.Text = DateTime.Now.ToString("dd/MM/yyyy");
        txtOrden.Text = "";
        txtTipoMovto.Focus();
        lblTotal.Text = "";
        DgrdList.DataSource = null;
        DgrdList.DataBind();
        txtConcepto.UpdateAfterCallBack = true;
        txtFechaInicial.UpdateAfterCallBack = true;
        txtOrden.UpdateAfterCallBack = true;
        txtTipoMovto.UpdateAfterCallBack = true;
        lblTotal.UpdateAfterCallBack = true;

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
        if (txtEmpresa.Text.Length > 0 && txtTipoMovto.Text.Length > 0 && txtConcepto.Text.Length > 0 && txtOrden.Text.Length > 0)
        {
            try
            {
                Entity_ContraRecibos obj;
                obj = new Entity_ContraRecibos();

                ContraRecibos pol;
                pol = new ContraRecibos();
                string value;

                obj.IntEmpresa = txtEmpresa.Text == "" ? Contabilidad.SEMSession.GetInstance.IntEmpresa : Convert.ToInt32(txtEmpresa.Text);
                obj.IntTM = Convert.ToInt32(txtTipoMovto.Text);
                obj.DatFecha = Convert.ToDateTime(txtFechaInicial.Text);
                obj.IntFolioOC = Convert.ToInt32(txtOrden.Text);
                obj.StrConcepto = txtConcepto.Text;
                obj.StrUsuario = Contabilidad.SEMSession.GetInstance.StrUsuario;
                obj.StrMaquina = Contabilidad.SEMSession.GetInstance.StrMaquina;
                obj.DatFechaAlta = DateTime.Now;
                string end = (Request.ApplicationPath.EndsWith("/")) ? "" : "/";
                string path = Request.ApplicationPath + end;
                string appPath = Request.PhysicalApplicationPath;
                if (fuArchivo.HasFile && fuArchivo.PostedFile.ContentLength > 0)
                {
                    string fileName = appPath + "Temp/Facturas" + '_' + obj.IntFolioOC.ToString() + ".xlsx";
                    fuArchivo.PostedFile.SaveAs(fileName);
                    FileStream stream = File.Open(fileName, FileMode.Open, FileAccess.Read);
                    IExcelDataReader excelReader;
                    string extension = Path.GetExtension(fileName).ToLower();

                    if (extension == ".xls")
                    {
                        excelReader = ExcelReaderFactory.CreateBinaryReader(stream);
                    }
                    else
                    {
                        excelReader = ExcelReaderFactory.CreateOpenXmlReader(stream);
                    }
                    int count = 0;
                    excelReader.IsFirstRowAsColumnNames = true;
                    DataSet result = excelReader.AsDataSet();
                    if (result.Tables.Count > 0)
                    {
                        DataTable table = result.Tables[0];
                        foreach (DataRow row in table.Rows)
                        {
                            string strFactura = row[0].ToString();
                            string strFolio = row[1].ToString();
                            decimal dblTotal;
                            decimal.TryParse(row[2].ToString(), out dblTotal);
                            count++;
                            obj.StrFactura = strFactura;
                            obj.StrFolioFiscal = strFolio;
                            obj.DblTotal = dblTotal;

                            if (!string.IsNullOrEmpty(strFactura) && !string.IsNullOrEmpty(strFolio))
                            {
                                value = pol.Save(obj);
                            }
                        }
                    }
                    excelReader.Close();
                    File.Delete(fileName);
                }
                else
                {
                    obj = null;
                    pol = null;
          
                    Anthem.Manager.RegisterStartupScript(Page.GetType(), "msfPolErr", "alert('El archivo cargado está vacío o es inválido.');", true);
                    return;
                }

                obj = null;
                pol = null;


                Anthem.Manager.RegisterStartupScript(Page.GetType(), "msgPolSave", "alert('Las facturas se guardaron correctamente.');", true);

                List();

                //Clear();



            }
            catch (Exception ex)
            {
                Anthem.Manager.RegisterStartupScript(Page.GetType(), "msfPolErr", "alert('" + ex.Message + "');", true);
            }
        }
        else
        {
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "msgPolSave", "alert('Debe ingresar todos los datos.');", true);
        }
        
    }
    #endregion

    #region Listado
    private void List()
    {
        Entity_ContraRecibos cont;
        cont = new Entity_ContraRecibos();

        ContraRecibos ls;
        ls = new ContraRecibos();
        DataTable dt = new DataTable();

        cont.IntEmpresa = txtEmpresa.Text == "" ? Contabilidad.SEMSession.GetInstance.IntEmpresa : Convert.ToInt32(txtEmpresa.Text);
        cont.DatFecha = Convert.ToDateTime(txtFechaInicial.Text);
        cont.IntFolioOC = Convert.ToInt32(txtOrden.Text);
        
        dt = ls.Fill(cont);

        DgrdList.DataSource = dt;
        DgrdList.DataBind();

        decimal sumaTotal = Convert.ToDecimal(dt.Compute("SUM(dblTotal)", string.Empty));
        lblTotal.Text = "Total: $ " + sumaTotal.ToString();

        hddSucursal.UpdateAfterCallBack = true;
        txtEmpresa.UpdateAfterCallBack = true;
        txtNombreEmpresa.UpdateAfterCallBack = true;


        cont = null;
        ls = null;
        dt = null;  
    }
    #endregion   

    #region Print
    void Print()
    {

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
            case Event.Print:
                Print();
                break;
            case Event.List:
               // BindGrid();
                break;
            default:
                break;
        }
    }
    #endregion
    
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

        Clear();

        obj = null;
        emp = null;
    }
    #endregion txtEmpresa_TextChange



   

    #region TipoMovimiento
    
        protected void txtTipoMovto_TextChanged(object sender, EventArgs e)
    {
        Entity_TipoMovimiento obj;
        obj = new Entity_TipoMovimiento();
        TipoMovimiento tm;
        tm = new TipoMovimiento();

        obj.IntEmpresa = txtEmpresa.Text == "" ? Contabilidad.SEMSession.GetInstance.IntEmpresa : Convert.ToInt32(txtEmpresa.Text);
        obj.IntMovto = txtTipoMovto.Text == "" ? 0 : Convert.ToInt32(txtTipoMovto.Text);
        obj = tm.Sel(obj);

        if (!(obj == null))
        {
            
        }
        else
        {
          

            Anthem.Manager.RegisterStartupScript(Page.GetType(), "txttxtTipoMovtofocus", "document.getElementById('" + txtTipoMovto.ClientID + "').focus();", true);
        }


        obj = null;
        tm = null;
    }
    #endregion
}


