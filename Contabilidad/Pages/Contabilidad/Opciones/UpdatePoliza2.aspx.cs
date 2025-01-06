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

public partial class Contabilidad_Compra_Opciones_UpdatePoliza2 : System.Web.UI.Page
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
            Year();
            txtEmpresa.Text = Contabilidad.SEMSession.GetInstance.IntEmpresa.ToString();
            txtEmpresa_TextChange(null, null);
        }

        JavaScript();

        string a = Request.Params.Get("__EVENTTARGET");
        string argument = Request.Params.Get("__EVENTARGUMENT");
        if (a == "Charge")
            Charge();
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

    #region Charge
    private void Charge()
    {        
        try
        {
            string end = (Request.ApplicationPath.EndsWith("/")) ? "" : "/";
            string path = Request.ApplicationPath + end;
            string appPath = Request.PhysicalApplicationPath;

            intEmpresa = txtEmpresa.Text;
            usuario = Contabilidad.SEMSession.GetInstance.StrUsuario ;

            string fileName = appPath + "Temp/FilePoliza" + intEmpresa + usuario + ".xls";
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
        Entity_TempPoliza_Remplazo obj;
        obj = new Entity_TempPoliza_Remplazo();
        TempPoliza_Remplazo dac;
        dac = new TempPoliza_Remplazo();
        
        int count = 0;

        try
        {
            foreach (DataRow dr in dt.Rows)
            {
                if (dr["CUENTA"].ToString() != "")
                {
                    count++;

                    Cuentas(dr["CUENTA"].ToString(), dr["SCTA"].ToString(), dr["CCTA"].ToString());
                    Obras(dr["OBRA"].ToString());
                    Auxiliares(dr["AUXILIAR"].ToString());

                    obj.IntEmpresa = Convert.ToInt32(txtEmpresa.Text);
                    obj.IntPartida = count;
                    obj.StrCuenta = dr["CUENTA"].ToString() + Cuenta(dr["SCTA"].ToString()) + Cuenta(dr["CCTA"].ToString());
                    obj.StrAuxiliar = dr["AUXILIAR"].ToString();
                    obj.StrObra = dr["OBRA"].ToString();
                    obj.StrReferencia = dr["REFERENCIA"].ToString();
                    obj.DblCargo = dr["CARGOS"].ToString() == "" ? 0 : Convert.ToDecimal(dr["CARGOS"].ToString());
                    obj.DblAbono = dr["ABONOS"].ToString() == "" ? 0 : Convert.ToDecimal(dr["ABONOS"].ToString());
                    obj.StrDescricpion = dr["DESCRIPCION"].ToString();
                    obj.StrUsuario = Contabilidad.SEMSession.GetInstance.StrUsuario;

                    dac.Save(obj);
                }
            }

            //if (data.Rows.Count > 0)
            //{
            //    grdPolizaDet.DataSource = data;
            //    grdPolizaDet.DataBind();
            //    grdPolizaDet.Visible = true;
            //    Find();

            //    grdPolizaDet.UpdateAfterCallBack = true;
            //}
        }
        catch (Exception ex)
        {
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "x", "alert('" + ex.Message + "');", true);
        }
    }
    #endregion

    private string Cuenta(string Strcuenta)
    {
        string value = "";

        if (Strcuenta.Length == 1)
            value = "000" + Strcuenta;
        if (Strcuenta.Length == 2)
            value = "00" + Strcuenta;
        if (Strcuenta.Length == 3)
            value = "0" + Strcuenta;
        if (Strcuenta.Length == 4)
            value = Strcuenta;

        return value;
    }

    #region JavaScript
    private void JavaScript()
    {
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtEmpresa", "var objText = new VetecText('" + txtEmpresa.ClientID + "', 'number', 12);", true);        
    }
    
    #endregion

    #region Cuentas
    protected void Cuentas(string cuenta, string Subcuenta, string subSubCuenta)
    {
        DataTable dt;

        Cuentas cta;
        cta = new Cuentas();

        int intEmpresa = txtEmpresa.Text == "" ? Contabilidad.SEMSession.GetInstance.IntEmpresa : Convert.ToInt32(txtEmpresa.Text);
        dt = cta.fn_tbCuentas_SubSubCuentas(intEmpresa, cuenta, Subcuenta, subSubCuenta);

        if (dt.Rows.Count > 0)
        {
            DataRow dr;
            dr = dt.Rows[0];

            NomCuenta = dr["strNombre"].ToString();
            strCuenta = dr["strCuenta"].ToString();
            auxiliar = Convert.ToInt32(dr["intIndAuxiliar"].ToString());
        }
        else
        {
            NomCuenta = "";
            auxiliar = 0;
            strCuenta = "";
        }

        cta = null;
    }
    #endregion

    #region Obras
    protected void Obras(string obra)
    {
        Entity_Obra obj;
        obj = new Entity_Obra();

        Obra ob;
        ob = new Obra();

        DataTable dt;
        string obr = obra == "" ? "0" : obra;

        obj.IntEmpresa = txtEmpresa.Text == "" ? Contabilidad.SEMSession.GetInstance.IntEmpresa : Convert.ToInt32(txtEmpresa.Text);
        obj.IntObra = Convert.ToInt32(obra);

        dt = ob.SelDt(obj);
        if (dt.Rows.Count > 0)
        {
            DataRow dr;
            dr = dt.Rows[0];

            strObra = dr["intObra"].ToString();
        }
        else
        {
            strObra = "";
        }

        ob = null;
        obj = null;
    }
    #endregion   

    #region Clear
    private void Clear()
    {
        cboYear.SelectedValue = DateTime.Now.Year.ToString();
        txtPoliza.Text = "";        
        lblAbonos.Text = "";
        lblCargos.Text = "";
        cboYear.Focus();
        grdPolizaDet.DataSource = null;
        grdPolizaDet.DataBind();

        grdPolizaDet.UpdateAfterCallBack = true;
        cboYear.UpdateAfterCallBack = true;
        txtPoliza.UpdateAfterCallBack = true;
        lblAbonos.UpdateAfterCallBack = true;
        lblCargos.UpdateAfterCallBack = true;

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
            int partida = 0;
            string value = "0";            
            Entity_PolizasDet obj;
            obj = new Entity_PolizasDet();
            PolizasDet pol;
            pol = new PolizasDet();

            obj.IntEmpresa = txtEmpresa.Text == "" ? Contabilidad.SEMSession.GetInstance.IntEmpresa : Convert.ToInt32(txtEmpresa.Text);
            obj.strPoliza = txtPoliza.Text;
            obj.intEjercicio = Convert.ToDateTime(hddFecha.Value).Year;
            obj.StrUsuario = Contabilidad.SEMSession.GetInstance.StrUsuario;
            obj.StrMaquina = Contabilidad.SEMSession.GetInstance.StrMaquina;

            value = pol.DeleteAll(obj);

            if (value != "")
            {
                for (int i = 0; i < grdPolizaDet.Rows.Count; i++)
                {
                    partida = Convert.ToInt32(grdPolizaDet.DataKeys[i].Values[0].ToString());
                    Anthem.TextBox txtCuentaDet = (Anthem.TextBox)grdPolizaDet.Rows[i].FindControl("txtCuentaDet");
                    Anthem.TextBox txtAuxiliarDet = (Anthem.TextBox)grdPolizaDet.Rows[i].FindControl("txtAuxiliarDet");
                    Anthem.TextBox txtObraDet = (Anthem.TextBox)grdPolizaDet.Rows[i].FindControl("txtObraDet");
                    Anthem.TextBox txtReferenciaDet = (Anthem.TextBox)grdPolizaDet.Rows[i].FindControl("txtReferenciaDet");
                    Anthem.TextBox txtDescripcionDet = (Anthem.TextBox)grdPolizaDet.Rows[i].FindControl("txtDescripcionDet");
                    Anthem.TextBox txtCargosDet = (Anthem.TextBox)grdPolizaDet.Rows[i].FindControl("txtCargosDet");
                    Anthem.TextBox txtAbonosDet = (Anthem.TextBox)grdPolizaDet.Rows[i].FindControl("txtAbonosDet");

                    Entity_PolizasDet objPol;
                    objPol = new Entity_PolizasDet();

                    PolizasDet polDet;
                    polDet = new PolizasDet();

                    objPol.IntEmpresa = txtEmpresa.Text == "" ? Contabilidad.SEMSession.GetInstance.IntEmpresa : Convert.ToInt32(txtEmpresa.Text);
                    objPol.strPoliza = txtPoliza.Text;
                    objPol.intPartida = partida;
                    objPol.strTipoPoliza = hddTipoPoliza.Value;
                    objPol.datFecha = Convert.ToDateTime(hddFecha.Value);
                    objPol.strCuenta = txtCuentaDet.Text;
                    objPol.strKeys = txtAuxiliarDet.Text;
                    objPol.StrObraInicial = txtObraDet.Text;
                    objPol.strReferencia = txtReferenciaDet.Text;
                    objPol.strDescripcion = txtDescripcionDet.Text;
                    objPol.dblImporte = txtCargosDet.Text == "" ? 0 : Convert.ToDecimal(txtCargosDet.Text);  //Solo para pasar valor de cargo
                    objPol.dblImporteTipoMoneda = txtAbonosDet.Text == "" ? 0 : Convert.ToDecimal(txtAbonosDet.Text); //Solo para pasar valor de abono
                    objPol.StrUsuario = Contabilidad.SEMSession.GetInstance.StrUsuario;
                    objPol.StrMaquina = Contabilidad.SEMSession.GetInstance.StrMaquina;

                    value = polDet.Save(objPol);

                    objPol = null;
                    polDet = null;
                }

                Anthem.Manager.RegisterStartupScript(Page.GetType(), "msgPolSave", "alert('La poliza " + txtPoliza.Text + " guardo correctamente.');", true);
                UpdateCA();
                Clear();
            }
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
        hddSucursal.Value = emp.GetSucursal(obj.IntEmpresa.ToString());

        hddSucursal.UpdateAfterCallBack = true;
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
        //VetecMarfilDO.VetecDALHelper DALHelper;
        //DALHelper = new VetecMarfilDO.VetecDALHelper();

        int partida;
        try
        {
            DataTable dt = new DataTable();
            dt.Columns.Add("intPartida");
            dt.Columns.Add("Cuenta");
            dt.Columns.Add("DesCuenta");
            dt.Columns.Add("Auxiliar");
            dt.Columns.Add("Obra");
            dt.Columns.Add("Referencia");
            dt.Columns.Add("Cargos");
            dt.Columns.Add("Abonos");
            dt.Columns.Add("Descricpion");
            dt.Columns.Add("Conciliado");

            partida = Convert.ToInt32(grdPolizaDet.DataKeys[e.RowIndex].Values[0].ToString());

            if (grdPolizaDet.Rows.Count > 0)
            {
                for (int i = 0; i < grdPolizaDet.Rows.Count; i++)
                {
                    if (i != e.RowIndex)
                    {
                        DataRow dr1 = dt.NewRow();
                        Anthem.TextBox txtCuentaDet = (Anthem.TextBox)grdPolizaDet.Rows[i].FindControl("txtCuentaDet");
                        Anthem.TextBox txtCuentaNombreDet = (Anthem.TextBox)grdPolizaDet.Rows[i].FindControl("txtCuentaNombreDet");
                        Anthem.TextBox txtAuxiliarDet = (Anthem.TextBox)grdPolizaDet.Rows[i].FindControl("txtAuxiliarDet");
                        Anthem.TextBox txtObraDet = (Anthem.TextBox)grdPolizaDet.Rows[i].FindControl("txtObraDet");
                        Anthem.TextBox txtReferenciaDet = (Anthem.TextBox)grdPolizaDet.Rows[i].FindControl("txtReferenciaDet");
                        Anthem.TextBox txtCargosDet = (Anthem.TextBox)grdPolizaDet.Rows[i].FindControl("txtCargosDet");
                        Anthem.TextBox txtAbonosDet = (Anthem.TextBox)grdPolizaDet.Rows[i].FindControl("txtAbonosDet");
                        Anthem.TextBox txtDescripcionDet = (Anthem.TextBox)grdPolizaDet.Rows[i].FindControl("txtDescripcionDet");
                        dr1["intPartida"] = grdPolizaDet.DataKeys[i].Values[0].ToString();
                        dr1["Cuenta"] = txtCuentaDet.Text;
                        dr1["DesCuenta"] = txtCuentaNombreDet.Text;
                        dr1["Auxiliar"] = txtAuxiliarDet.Text;
                        dr1["Obra"] = txtObraDet.Text;
                        dr1["Referencia"] = txtReferenciaDet.Text;
                        dr1["Cargos"] = txtCargosDet.Text;
                        dr1["Abonos"] = txtAbonosDet.Text;
                        dr1["Descricpion"] = txtDescripcionDet.Text;
                        dr1["Conciliado"] = "0";
                        dt.Rows.Add(dr1);
                        dr1 = null;
                    }
                }
            }

            grdPolizaDet.DataSource = dt;
            grdPolizaDet.DataBind();

            Find();

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
                string cuenta = dataRowView.Row["Cuenta"].ToString();
                string nombre = dataRowView.Row["DesCuenta"].ToString();
                string auxiliar = dataRowView.Row["Auxiliar"].ToString();
                string obra = dataRowView.Row["Obra"].ToString();
                string referencia = dataRowView.Row["Referencia"].ToString();
                string cargos = dataRowView.Row["Cargos"].ToString();
                string abonos = dataRowView.Row["Abonos"].ToString();
                string descripcion = dataRowView.Row["Descricpion"].ToString();

                Anthem.TextBox txtCuentaDet = (Anthem.TextBox)e.Row.FindControl("txtCuentaDet");
                Anthem.TextBox txtCuentaNombreDet = (Anthem.TextBox)e.Row.FindControl("txtCuentaNombreDet");
                Anthem.TextBox txtAuxiliarDet = (Anthem.TextBox)e.Row.FindControl("txtAuxiliarDet");
                Anthem.TextBox txtObraDet = (Anthem.TextBox)e.Row.FindControl("txtObraDet");
                Anthem.TextBox txtReferenciaDet = (Anthem.TextBox)e.Row.FindControl("txtReferenciaDet");
                Anthem.TextBox txtCargosDet = (Anthem.TextBox)e.Row.FindControl("txtCargosDet");
                Anthem.TextBox txtAbonosDet = (Anthem.TextBox)e.Row.FindControl("txtAbonosDet");
                Anthem.TextBox txtDescripcionDet = (Anthem.TextBox)e.Row.FindControl("txtDescripcionDet");
                Anthem.ImageButton lknDelete = (Anthem.ImageButton)e.Row.FindControl("lknDelete");

                txtCuentaDet.Text = cuenta;
                txtCuentaNombreDet.Text = nombre;
                txtAuxiliarDet.Text = auxiliar;
                txtObraDet.Text = obra;
                txtReferenciaDet.Text = referencia;
                txtCargosDet.Text = cargos;
                txtAbonosDet.Text = abonos;
                txtDescripcionDet.Text = descripcion;

                txtCuentaNombreDet.Style.Value = "background-color:Silver;color:#000066;text-align:left;";

                txtCargosDet.Attributes.Add("onkeypress", "OnlyNumber();");
                txtAbonosDet.Attributes.Add("onkeypress", "OnlyNumber();");

                txtCuentaDet.UpdateAfterCallBack = true;
                txtCuentaNombreDet.UpdateAfterCallBack = true;
                txtAuxiliarDet.UpdateAfterCallBack = true;
                txtObraDet.UpdateAfterCallBack = true;
                txtReferenciaDet.UpdateAfterCallBack = true;
                txtCargosDet.UpdateAfterCallBack = true;
                txtAbonosDet.UpdateAfterCallBack = true;
                txtDescripcionDet.UpdateAfterCallBack = true;
                lknDelete.UpdateAfterCallBack = true;
            }
        }
    }
    #endregion

    #region txtCuentaDet_TextChanged
    protected void txtCuentaDet_TextChanged(object sender, EventArgs e)
    {
        string a = Request.Params.Get("__EVENTTARGET");
        if (a != "txtProveedor")
            a = "";
        ////{
        Anthem.TextBox thisTextBox = (Anthem.TextBox)sender;
        if (thisTextBox.Text != "")
        {
            GridViewRow thisGridViewRow = (GridViewRow)thisTextBox.Parent.Parent;
            thisTextBox = null;
            int row = thisGridViewRow.RowIndex;

            Anthem.TextBox txtCuentaDet = (Anthem.TextBox)grdPolizaDet.Rows[row].FindControl("txtCuentaDet");
            Anthem.TextBox txtCuentaNombreDet = (Anthem.TextBox)grdPolizaDet.Rows[row].FindControl("txtCuentaNombreDet");

            string clave = txtCuentaDet.Text;

            DataRow dr;
            dr = Cuentas(clave);

            if (dr == null)
            {
                txtCuentaDet.Text = "";
                txtCuentaNombreDet.Text = "";
            }
            else
            {
                txtCuentaDet.Text = dr["strCuenta"].ToString();
                txtCuentaNombreDet.Text = dr["strNombre"].ToString();
            }

            txtCuentaDet.UpdateAfterCallBack = true;
            txtCuentaNombreDet.UpdateAfterCallBack = true;

            Find();
        }
    }
    #endregion

    #region txtAuxiliarDet_TextChanged
    protected void txtAuxiliarDet_TextChanged(object sender, EventArgs e)
    {
        string a = Request.Params.Get("__EVENTTARGET");
        if (a != "txtProveedor")
            a = "";
        ////{
        Anthem.TextBox thisTextBox = (Anthem.TextBox)sender;
        if (thisTextBox.Text != "")
        {
            GridViewRow thisGridViewRow = (GridViewRow)thisTextBox.Parent.Parent;
            thisTextBox = null;
            int row = thisGridViewRow.RowIndex;

            Anthem.TextBox txtAuxiliarDet = (Anthem.TextBox)grdPolizaDet.Rows[row].FindControl("txtAuxiliarDet");

            string clave = txtAuxiliarDet.Text;

            DataRow dr;
            dr = Auxiliar(clave);

            if (dr == null)
                txtAuxiliarDet.Text = "";
            else
                txtAuxiliarDet.Text = dr["id"].ToString();

            txtAuxiliarDet.UpdateAfterCallBack = true;

            Find();
        }
    }
    #endregion

    #region txtObraDet_TextChanged
    protected void txtObraDet_TextChanged(object sender, EventArgs e)
    {
        string a = Request.Params.Get("__EVENTTARGET");
        if (a != "txtProveedor")
            a = "";
        ////{
        Anthem.TextBox thisTextBox = (Anthem.TextBox)sender;
        if (thisTextBox.Text != "")
        {
            GridViewRow thisGridViewRow = (GridViewRow)thisTextBox.Parent.Parent;
            thisTextBox = null;
            int row = thisGridViewRow.RowIndex;

            Anthem.TextBox txtObraDet = (Anthem.TextBox)grdPolizaDet.Rows[row].FindControl("txtObraDet");

            string clave = txtObraDet.Text;

            DataRow dr;
            dr = Obra(clave);

            if (dr == null)
                txtObraDet.Text = "";
            else
                txtObraDet.Text = dr["intObra"].ToString();

            txtObraDet.UpdateAfterCallBack = true;

            Find();
        }
    }
    #endregion   
    
    #region txtCargosDet_TextChanged
    protected void txtCargosDet_TextChanged(object sender, EventArgs e)
    {
       Find();
    }
    #endregion

    #region txtAbonosDet_TextChanged
    protected void txtAbonosDet_TextChanged(object sender, EventArgs e)
    {
        Find();
    }
    #endregion

    #region Auxiliares
    protected void Auxiliares(string aux)
    {
        Poliza poliza;
        poliza = new Poliza();
        
        DataTable dt;
        string auxiliar = aux == "" ? "0" : aux;
        int intEmpresa = 0;
        intEmpresa = txtEmpresa.Text == "" ? Contabilidad.SEMSession.GetInstance.IntEmpresa : Convert.ToInt32(txtEmpresa.Text);

        dt = poliza.Auxiliar(intEmpresa, Convert.ToInt32(auxiliar));                

        if (dt.Rows.Count > 0)
        {
            DataRow dr;
            dr = dt.Rows[0];

            strAuxiliar = dr["id"].ToString();
        }
        else
        {
            strAuxiliar = "";
        }

        poliza = null;;
    }
    #endregion

    #region Cuentas
    private DataRow Cuentas(string clave)
    {
        Entity_Cuentas obj;
        obj = new Entity_Cuentas();

        Cuentas cta;
        cta = new Cuentas();

        DataTable dt;
        DataRow dr;

        obj.IntEmpresa = txtEmpresa.Text == "" ? Contabilidad.SEMSession.GetInstance.IntEmpresa : Convert.ToInt32(txtEmpresa.Text);
        obj.StrCuenta = clave;

        dt= cta.GetList (obj);

        //dt = DALHelper.GetTableFromQuery("SELECT strCuenta, strNombre FROM VetecMarfilAdmin.dbo.tbCuentas WHERE intEmpresa=" + Session["numEmpresa"].ToString() + " AND strCuenta = '" + clave + "'");

        if (!(dt == null) && dt.Rows.Count > 0)
            dr = dt.Rows[0];
        else
            dr = null;

        obj = null;
        cta = null;
        return dr;

    }
    #endregion

    #region Auxiliar
    private DataRow Auxiliar(string clave)
    {
        DataTable dt;
        DataRow dr;

        int intEmpresa = 0;
        intEmpresa = txtEmpresa.Text == "" ? Contabilidad.SEMSession.GetInstance.IntEmpresa : Convert.ToInt32(txtEmpresa.Text);

        if (intEmpresa == 2)
        {
            Entity_Prospectos obj;
            obj = new Entity_Prospectos();
            Prospecto pro;
            pro = new Prospecto();

            obj.intEmpresa = intEmpresa;
            dt = pro.Sel(obj);
            obj = null;
            pro = null;
        }
        else
        {
            Entity_Clientes obj;
            obj = new Entity_Clientes();
            Clientes cte;
            cte = new Clientes();

            obj.intEmpresa = txtEmpresa.Text == "" ? Contabilidad.SEMSession.GetInstance.IntEmpresa : Convert.ToInt32(txtEmpresa.Text);
            obj.strClave = clave;
            dt = cte.Sel(obj);
            obj = null;
            cte = null;
        }
        if (dt.Rows.Count == 0 || dt == null)
        {
            Entity_Proveedor obj;
            obj = new Entity_Proveedor();
            Proveedor prov;
            prov = new Proveedor();

            obj.IntEmpresa = txtEmpresa.Text == "" ? Contabilidad.SEMSession.GetInstance.IntEmpresa : Convert.ToInt32(txtEmpresa.Text);
            obj.IntProveedor = Convert.ToInt32(auxiliar);
            dt = prov.Sel(obj);
            obj = null;
            prov = null;

        }
        if (!(dt == null) && dt.Rows.Count > 0)
            dr = dt.Rows[0];
        else
            dr = null;

        return dr;

    }
    #endregion

    #region Obra
    private DataRow Obra(string clave)
    {
        DataTable dt;
        DataRow dr;

        Entity_Obra obj;
        obj = new Entity_Obra();
        Obra ob;
        ob = new Obra();

        obj.IntEmpresa = txtEmpresa.Text == "" ? Contabilidad.SEMSession.GetInstance.IntEmpresa : Convert.ToInt32(txtEmpresa.Text);
        obj.IntObra = Convert.ToInt32(clave);

        dt = ob.SelDt(obj);

        if (!(dt == null) && dt.Rows.Count > 0)
            dr = dt.Rows[0];
        else
            dr = null;

        obj = null;
        ob = null;
        return dr;

    }
    #endregion

    #region Find
    private void Find()
    {
        decimal cargos = 0;
        decimal abonos = 0;
        for (int i = 0; i < grdPolizaDet.Rows.Count; i++)
        {
            Anthem.TextBox txtCuentaDet = (Anthem.TextBox)grdPolizaDet.Rows[i].FindControl("txtCuentaDet");
            Anthem.TextBox txtObraDet = (Anthem.TextBox)grdPolizaDet.Rows[i].FindControl("txtObraDet");
            Anthem.TextBox txtAuxiliarDet = (Anthem.TextBox)grdPolizaDet.Rows[i].FindControl("txtAuxiliarDet");
            Anthem.TextBox txtCuentaNombreDet = (Anthem.TextBox)grdPolizaDet.Rows[i].FindControl("txtCuentaNombreDet");
            Anthem.TextBox txtCargosDet = (Anthem.TextBox)grdPolizaDet.Rows[i].FindControl("txtCargosDet");
            Anthem.TextBox txtAbonosDet = (Anthem.TextBox)grdPolizaDet.Rows[i].FindControl("txtAbonosDet");
            Anthem.ImageButton lknDelete = (Anthem.ImageButton)grdPolizaDet.Rows[i].FindControl("lknDelete");
            Anthem.TextBox txtReferenciaDet = (Anthem.TextBox)grdPolizaDet.Rows[i].FindControl("txtReferenciaDet");
            Anthem.TextBox txtDescripcionDet = (Anthem.TextBox)grdPolizaDet.Rows[i].FindControl("txtDescripcionDet");


            txtCuentaDet.Attributes.Add("onkeypress", "OnlyNumber();");
            txtCuentaDet.Attributes.Add("ondblclick", "var x=Find('" + txtCuentaDet.ClientID + "','" + txtCuentaDet.ClientID + "," + txtCuentaNombreDet.ClientID + "','AdministrativoBO','hddEmpresa',4,0,'number','20', false);");
            txtCuentaDet.Style.Value = "background-color:#EEEE00;color:Navy;text-align:left;Tahoma;font-size: 8pt;";

            txtObraDet.Attributes.Add("onkeypress", "OnlyNumber();");
            txtObraDet.Attributes.Add("ondblclick", "var x= Find('" + txtObraDet.ClientID + "','" + txtObraDet.ClientID + ",hddUnidadInsumo,hddUnidadInsumo','AdministrativoBO','hddEmpresa',5,1,'text','8', 'false'); return false;");
            txtObraDet.Style.Value = "background-color:#EEEE00;color:Navy;text-align:left;Tahoma;font-size: 8pt;";

            txtAuxiliarDet.Attributes.Add("onkeypress", "OnlyNumber();");
            txtAuxiliarDet.Attributes.Add("ondblclick", "var x= Find('" + txtAuxiliarDet.ClientID + "','" + txtAuxiliarDet.ClientID + ",hddUnidadInsumo,hddUnidadInsumo','AdministrativoBO','hddEmpresa',6,1,'text','8', 'false'); return false;");
            txtAuxiliarDet.Style.Value = "background-color:#EEEE00;color:Navy;text-align:left;Tahoma;font-size: 8pt;";

            txtCuentaNombreDet.Style.Value = "background-color:Silver;color:#000066;text-align:left;font-family: Tahoma;font-size: 8pt;";

            txtCargosDet.Style.Value = "color:#000066;text-align:right;Tahoma;font-size: 8pt;";
            txtAbonosDet.Style.Value = "color:#000066;text-align:right;Tahoma;font-size: 8pt;";
            txtDescripcionDet.Style.Value = "color:#000066;text-align:left;Tahoma;font-size: 8pt;";
            lknDelete.Visible = true;
            txtReferenciaDet.Style.Value = "color:#000066;text-align:left;Tahoma;font-size: 8pt;";
            txtDescripcionDet.Style.Value = "color:#000066;text-align:left;Tahoma;font-size: 8pt;";

            cargos = cargos + (txtCargosDet.Text == "" ? 0 : Convert.ToDecimal(txtCargosDet.Text));
            abonos = abonos + (txtAbonosDet.Text == "" ? 0 : Convert.ToDecimal(txtAbonosDet.Text));

            txtAuxiliarDet.UpdateAfterCallBack = true;
            txtObraDet.UpdateAfterCallBack = true;
            txtCuentaDet.UpdateAfterCallBack = true;
            txtCuentaNombreDet.UpdateAfterCallBack = true;
            lknDelete.UpdateAfterCallBack = true;
            txtDescripcionDet.UpdateAfterCallBack = true;
            txtAbonosDet.UpdateAfterCallBack = true;
            txtCargosDet.UpdateAfterCallBack = true;
        }

        lblAbonos.Text = abonos.ToString();
        lblCargos.Text = cargos.ToString();
        lblDiferencia.Text = Convert.ToString(cargos - abonos);

        grdPolizaDet.UpdateAfterCallBack = true;
        lblAbonos.UpdateAfterCallBack = true;
        lblCargos.UpdateAfterCallBack = true;
        lblDiferencia.UpdateAfterCallBack = true;
    }
    #endregion     

    #region txtPoliza_TextChanged
    protected void txtPoliza_TextChanged(object sender, EventArgs e)
    {
        PolizasEnc poliza;
        poliza = new PolizasEnc();
        Entity_PolizasEnc obj;
        obj = new Entity_PolizasEnc();

        obj.IntEmpresa = txtEmpresa.Text == "" ? Contabilidad.SEMSession.GetInstance.IntEmpresa : Convert.ToInt32(txtEmpresa.Text);
        obj.strPoliza = txtPoliza.Text;
        obj.intEjercicio = Convert.ToInt32(cboYear.SelectedValue);

        obj = poliza.Fill(obj);

        if (obj != null)
        {
            txtPoliza.Text = obj.strPoliza;
            hddFecha.Value = obj.datFecha.ToShortDateString();
            hddTipoPoliza.Value = obj.strTipoPoliza;
            Close();            
        }
        else
        {
            txtPoliza.Text = "";
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "msgMSGFind", "alert('No se encontro la poliza.');", true);
        }

        txtPoliza.UpdateAfterCallBack = true;
        hddFecha.UpdateAfterCallBack = true;
        hddTipoPoliza.UpdateAfterCallBack = true;
       
        poliza = null;
        obj = null;
    }  
    #endregion

    #region Close
    private void Close()
    {
        Entity_Poliza obj;
        obj = new Entity_Poliza();

        Poliza pol;
        pol = new Poliza();

        obj.IntEmpresa = Convert.ToInt32(txtEmpresa.Text);
        obj.IntEjercicio = Convert.ToInt32(cboYear.SelectedValue);
        obj.IntMes = Convert.ToDateTime(hddFecha.Value).Month;
        obj.IntModulo = 1;

        if (pol.Close(obj) == "1")
        {
            txtPoliza.Text = "";
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "msgMes", "alert('El mes esta cerrado.');", true);
        }

        txtPoliza.UpdateAfterCallBack = true;       

        obj = null;
        pol = null;
    }
    #endregion 

    #region UpdateCA
    protected void UpdateCA()
    {
        try
        {
            Entity_PolizasEnc obj;
            obj = new Entity_PolizasEnc();
            PolizasEnc pol;
            pol = new PolizasEnc();
            string value = "";

            obj.IntEmpresa = txtEmpresa.Text == "" ? Contabilidad.SEMSession.GetInstance.IntEmpresa : Convert.ToInt32(txtEmpresa.Text);
            obj.strPoliza = txtPoliza.Text;
            obj.datFecha = Convert.ToDateTime(hddFecha.Value);

            value = pol.UpdateCA(obj);

            Anthem.Manager.RegisterStartupScript(Page.GetType(), "msgPolSave", "alert('La poliza " + txtPoliza.Text + " guardo correctamente.');", true);

            obj = null;
            pol = null;
        }
        catch (Exception ex)
        {
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "msfPolErr", "alert('" + ex.Message + "');", true);
        }
    }
    #endregion  

}


