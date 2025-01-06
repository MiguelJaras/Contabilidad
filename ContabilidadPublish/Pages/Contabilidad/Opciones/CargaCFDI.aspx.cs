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

public partial class Contabilidad_Compra_Opciones_CargaCFDI : System.Web.UI.Page
{
    public string realPath;
    public string intEmpresa;
    public string usuario;
    Pages_Base toolbar;

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
            hddEjercicio.Value = Request.QueryString["intEjercicio"].ToString();
            txtPoliza.Text = Request.QueryString["strPoliza"].ToString();
            txtEmpresa.Text = Request.QueryString["intEmpresa"].ToString();

            txtEmpresa_TextChange(null, null);
            Fill();
        }

        string a = Request.Params.Get("__EVENTTARGET");
        string argument = Request.Params.Get("__EVENTARGUMENT");
        //if (a == "Charge")
        //    Charge();
    }

    protected void Page_PreRender(object sender, EventArgs e)
    {
        toolbar.List(false);
        toolbar.Print(false);
        toolbar.New(false);
        toolbar.Exportar(false);
        toolbar.Email(false);
        toolbar.Delete(false);
    }

    #region Fill
    private void Fill()
    {
        try
        {
            PolizasEnc pol;
            pol = new PolizasEnc();
            DataTable dt;
            int IntEmpresa;
            int intEjercicio;
            string strPoliza;

            IntEmpresa = txtEmpresa.Text == "" ? Contabilidad.SEMSession.GetInstance.IntEmpresa : Convert.ToInt32(txtEmpresa.Text);
            intEjercicio = Convert.ToInt32(hddEjercicio.Value);
            strPoliza = txtPoliza.Text;

            dt = pol.ListCFDI(IntEmpresa, intEjercicio, strPoliza);

            if(dt.Rows.Count > 0)
            {
                grdPolizaDet.DataSource = dt;
                grdPolizaDet.DataBind();
                grdPolizaDet.Visible = true;

                grdPolizaDet.UpdateAfterCallBack = true;
            }

            pol = null;
        }
        catch (Exception ex)
        {
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "msfPolErr", "alert('" + ex.Message + "');", true);
        }
    }
    #endregion

    #region lknCharge_Click
    protected void lknCharge_Click(object sender, EventArgs e)
    {
        try
        {
            string end = (Request.ApplicationPath.EndsWith("/")) ? "" : "/";
            string path = Request.ApplicationPath + end;
            string appPath = Request.PhysicalApplicationPath;

            intEmpresa = txtEmpresa.Text;
            usuario = Contabilidad.SEMSession.GetInstance.StrUsuario ;

            string fileName = appPath + "Temp/CFDI" + intEmpresa + usuario + ".xls";
            fuArchivo.PostedFile.SaveAs(fileName);
            FileStream stream = File.Open(fileName, FileMode.Open, FileAccess.Read);

            IExcelDataReader excelReader = ExcelReaderFactory.CreateBinaryReader(stream);

            excelReader.IsFirstRowAsColumnNames = true;
            DataSet result = excelReader.AsDataSet();

            if (result.Tables.Count > 0)
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
        DataTable data = new DataTable();
        data.Columns.Add("cfdi");

        int count = 0;
        int row = 0;
        try
        {
            if (grdPolizaDet.Rows.Count > 0)
            {
                for (int i = 0; i < grdPolizaDet.Rows.Count; i++)
                {
                    DataRow dr2 = data.NewRow();
                    dr2["cfdi"] = grdPolizaDet.DataKeys[i].Values[0].ToString();
                    data.Rows.Add(dr2);
                    dr2 = null;
                }
            }

            foreach (DataRow dr in dt.Rows)
            {
                row++;
                if (dr["cfdi"].ToString() != "")
                {
                    if (!Exist(dr["cfdi"].ToString()))
                    {
                        count++;
                        DataRow dr1 = data.NewRow();

                        dr1["cfdi"] = dr["cfdi"].ToString();
                        data.Rows.Add(dr1);
                        dr1 = null;
                    }
                }
            }

            if (data.Rows.Count > 0)
            {
                grdPolizaDet.DataSource = data;
                grdPolizaDet.DataBind();
                grdPolizaDet.Visible = true;

                grdPolizaDet.UpdateAfterCallBack = true;
            }
        }
        catch (Exception ex)
        {
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "x", "alert('" + ex.Message + ", fila " + row.ToString() + " ');", true);
        }
    }
    #endregion

    #region Clear
    private void Clear()
    {

        grdPolizaDet.DataSource = null;
        grdPolizaDet.DataBind();

        grdPolizaDet.UpdateAfterCallBack = true;
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
            PolizasEnc pol;
            pol = new PolizasEnc();
            int IntEmpresa;
            int intEjercicio;
            string strPoliza;
            string cfdi;
            string value = "";
            string strUsuario = Contabilidad.SEMSession.GetInstance.StrUsuario;
            string strMaquina = Contabilidad.SEMSession.GetInstance.StrMaquina;

            IntEmpresa = txtEmpresa.Text == "" ? Contabilidad.SEMSession.GetInstance.IntEmpresa : Convert.ToInt32(txtEmpresa.Text);
            intEjercicio = Convert.ToInt32(hddEjercicio.Value);
            strPoliza = txtPoliza.Text;

            value = pol.DelCFDI(IntEmpresa, intEjercicio, strPoliza);

            for (int i = 0; i < grdPolizaDet.Rows.Count; i++)
            {
                cfdi = grdPolizaDet.DataKeys[i].Values[0].ToString();

                value = pol.SaveCFDI(IntEmpresa, intEjercicio, strPoliza, cfdi, strUsuario, strMaquina);
            }

            Anthem.Manager.RegisterStartupScript(Page.GetType(), "msgPolSave", "alert('Se guardo correctamente.');", true);
            //Clear();
            pol = null;      
        }
        catch (Exception ex)
        {
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "msfPolErr", "alert('" + ex.Message + "');", true);
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

        txtEmpresa.UpdateAfterCallBack = true;
        txtNombreEmpresa.UpdateAfterCallBack = true;

        Clear();

        obj = null;
        emp = null;
    }
    #endregion txtEmpresa_TextChange

    #region DgrdList_RowDeleting
    protected void DgrdList_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        string cdfi;
        try
        {
            DataTable dt = new DataTable();
            dt.Columns.Add("cfdi");

            cdfi = grdPolizaDet.DataKeys[e.RowIndex].Values[0].ToString();

            if (grdPolizaDet.Rows.Count > 0)
            {
                for (int i = 0; i < grdPolizaDet.Rows.Count; i++)
                {
                    if (i != e.RowIndex)
                    {
                        DataRow dr1 = dt.NewRow();
                        dr1["cfdi"] = grdPolizaDet.DataKeys[i].Values[0].ToString();
                        dt.Rows.Add(dr1);
                        dr1 = null;
                    }
                }
            }

            grdPolizaDet.DataSource = dt;
            grdPolizaDet.DataBind();

            grdPolizaDet.UpdateAfterCallBack = true;
        }
        catch (Exception ex)
        {
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "msfPolErr", "alert('" + ex.Message + "');", true);
        }
        //DALHelper = null;
    }
    #endregion DgrdList_RowDeleting

    #region DgrdList_RowCreated
    protected void DgrdList_RowCreated(object sender, GridViewRowEventArgs e)
    {
        int i = 0;
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            DataRowView dataRowView = (DataRowView)e.Row.DataItem;
            if (dataRowView != null)
            {
                i++;               
            }
        }
    }
    #endregion
    
    #region btnAgregar_Click
    protected void btnAgregar_Click(object sender, EventArgs e)
    {
        if (txtCFDI.Text != "")
        {
            DataTable dt = new DataTable();
            dt.Columns.Add("cfdi");
            string cdfi;
            cdfi = txtCFDI.Text;

            if (grdPolizaDet.Rows.Count > 0)
            {
                for (int i = 0; i < grdPolizaDet.Rows.Count; i++)
                {
                    DataRow dr1 = dt.NewRow();
                    dr1["cfdi"] = grdPolizaDet.DataKeys[i].Values[0].ToString();
                    dt.Rows.Add(dr1);
                    dr1 = null;
                }
            }

            if (!Exist(cdfi))
            {
                DataRow dr2 = dt.NewRow();
                dr2["cfdi"] = cdfi;
                dt.Rows.Add(dr2);
                dr2 = null;
            }

            grdPolizaDet.DataSource = dt;
            grdPolizaDet.DataBind();
            grdPolizaDet.Visible = true;
            txtCFDI.Text = "";

            grdPolizaDet.UpdateAfterCallBack = true;
            txtCFDI.UpdateAfterCallBack = true;
        }
    }
    #endregion btnAgregar_Click

    private bool Exist(string cfdi)
    {
        string grid;
        bool value = false;
        for (int i = 0; i < grdPolizaDet.Rows.Count; i++)
        {
            grid = grdPolizaDet.DataKeys[i].Values[0].ToString();
            if (cfdi == grid)
                value = true;
        }

        return value;
    }
}


