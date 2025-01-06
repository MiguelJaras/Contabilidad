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
using Excel;

public partial class Contabilidad_Compra_Opciones_AfectacionSaldos : System.Web.UI.Page
{
    public string realPath;
    Pages_Base toolbar;
    string intEmpresa;
    string usuario;

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
            toolbar.PrintValid();
            txtEmpresa.Text = Contabilidad.SEMSession.GetInstance.IntEmpresa.ToString();
            txtEmpresa_TextChange(null, null);

            txtFechaInicial.Text = DateTime.Now.ToString("dd/MM/yyyy");
            txtEmpresa.Text = Contabilidad.SEMSession.GetInstance.IntEmpresa.ToString();
            txtEmpresa_TextChange(null, null);
        }

        JavaScript();
        RefreshSession();
        ImgDate.OnClientClick = "if(self.gfPop)gfPop.fPopCalendar(document.getElementById('" + txtFechaInicial.ClientID + "')); giDatePos=0; return false;";
    }

    

    #region JavaScript
    private void JavaScript()
    {
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtEmpresa", "var objText = new VetecText('" + txtEmpresa.ClientID + "', 'number', 12);", true);
    }
    
    #endregion

    #region RefreshSession
    private void RefreshSession()
    {
        string end = (Request.ApplicationPath.EndsWith("/")) ? "" : "/";
        string path = Request.ApplicationPath + end;
        string appPath = String.Format("http://{0}{1}{2}", Request.Url.Authority, path, "Login/FinSesion.aspx?id=0");

        Response.AppendHeader("Refresh", Convert.ToString((Session.Timeout * 50)) + "; URL=" + appPath);
    }
    #endregion

    #region Clear
    private void Clear()
    {
        txtFechaInicial.Text = DateTime.Now.ToString("dd/MM/yyyy");

        txtFechaInicial.UpdateAfterCallBack = true;
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
            string end = (Request.ApplicationPath.EndsWith("/")) ? "" : "/";
            string path = Request.ApplicationPath + end;
            string appPath = Request.PhysicalApplicationPath;

            intEmpresa = Convert.ToString(txtEmpresa.Text == "" ? Contabilidad.SEMSession.GetInstance.IntEmpresa : Convert.ToInt32(txtEmpresa.Text));
            usuario = Contabilidad.SEMSession.GetInstance.StrUsuario.ToString();

            string fileName = appPath + "Administracion/FileExcel" + intEmpresa + usuario + ".xls";
            fuArchivo.PostedFile.SaveAs(fileName);
            FileStream stream = File.Open(fileName, FileMode.Open, FileAccess.Read);

            IExcelDataReader excelReader = ExcelReaderFactory.CreateBinaryReader(stream);
            
            excelReader.IsFirstRowAsColumnNames = true;
            DataSet result = excelReader.AsDataSet();

            Poliza(result.Tables[0]);
            excelReader.Close();
            File.Delete(fileName);

        }
        catch (Exception ex)
        {
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "x5", "alert('" + ex.Message + "');", true);
        }  
    }
    #endregion

    #region Poliza
    private void Poliza(DataTable dt)
    {
       try
        {
            string usuario = Contabilidad.SEMSession.GetInstance.StrUsuario.ToString();
            string maquina = Contabilidad.SEMSession.GetInstance.StrMaquina.ToString();
            int i = 0;
            foreach (DataRow dr in dt.Rows)
            {
                if (dr["EMPRESA"].ToString() != "")
                {
                    AfectaSaldos Afs;
                    Afs = new AfectaSaldos();

                    Entity_AfectaSaldos obj;
                    obj = new Entity_AfectaSaldos();

                    int res;

                    obj.intEmpresa = Convert.ToInt32(dr["EMPRESA"].ToString());
                    obj.intProspecto = Convert.ToInt32(dr["CLIENTE"].ToString());
                    obj.strCuenta = dr["CUENTA"].ToString();
                    obj.strSubCuenta =  dr["SCTA"].ToString();
                    obj.strSubSubCuenta = dr["CCTA"].ToString();
                    obj.intMovto = Convert.ToInt32(dr["MOV"].ToString());
                    obj.intFactura  = Convert.ToInt32 (dr["REFERENCIA"].ToString());
                    obj.intObra  = Convert.ToInt32(dr["CC"].ToString());
                    obj.strConcepto  = dr["CONCEPTO"].ToString();
                    obj.intTipoMovto = Convert.ToInt32(dr["TIPO_MOVIMIENTO"].ToString());
                    obj.dblMonto = Convert.ToDecimal(dr["MONTO"].ToString());
                    obj.strUsuario  = usuario;
                    obj.strMaquina = maquina ;

                    res = Afs.GetList(obj);
                    i += 1;
                    Afs = null;
                    obj = null;
                }
            }

            AfectaSaldos af;
            af = new AfectaSaldos();

            string  result = "";

            DateTime fecha = Convert.ToDateTime ( "01/01/1900");
            fecha = Convert.ToDateTime (txtFechaInicial.Text);

            result = af.CteAfecSaldo(fecha);
            
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "Save", "alert('Se genero la poliza " + result + "');", true);
            af = null;
        }
        catch (Exception ex)
        {
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "x", "alert('" + ex.Message + "');", true);
        }

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
                // Delete();
                break;
            case Event.Print:
                //Print();
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


}


