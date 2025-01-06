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
using System.Collections;


public partial class Contabilidad_Compra_Opciones_EstadoCuenta : System.Web.UI.Page
{
    public string realPath;
    Pages_Base toolbar;
    string intEmpresa;
    string usuario;
    public int Direction
    {
        get { return ViewState["Direction"] != null ? (int)ViewState["Direction"] : 1; }
        set { ViewState["Direction"] = value; }
    }

    public string SortExpression
    {
        get { return ViewState["SortExpression"] != null ? ViewState["SortExpression"].ToString() : ""; }
        set { ViewState["SortExpression"] = value; }
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
            toolbar.PrintValid();
            txtEmpresa.Text = Contabilidad.SEMSession.GetInstance.IntEmpresa.ToString();
            txtEmpresa_TextChange(null, null);
            Month();
            Year();
            
            txtEmpresa.Text = Contabilidad.SEMSession.GetInstance.IntEmpresa.ToString();
            txtEmpresa_TextChange(null, null);
            cboYear.SelectedValue = DateTime.Now.Year.ToString();
            cboMonth.SelectedValue = DateTime.Now.Month.ToString();
        }

        JavaScript();
        RefreshSession();
        
    }


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

    #region JavaScript
    private void JavaScript()
    {
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtEmpresa", "var objText = new VetecText('" + txtEmpresa.ClientID + "', 'number', 12);", true);
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtCtaBanc", "var objText = new VetecText('" + txtCtaBanc.ClientID + "', 'number', 12);", true);
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtCtaBancDes", "var objText = new VetecText('" + txtCtaBancDes.ClientID + "', 'text', 100);", true);
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
        Values value;
        value = new Values();
        cboYear.SelectedValue = value.Ejercicio(Contabilidad.SEMSession.GetInstance.IntEmpresa, Contabilidad.SEMSession.GetInstance.IntSucursal,1);
        cboMonth.SelectedIndex = -1;
        txtCtaBanc.Text = "";
        txtCtaBancDes.Text = "";
        grdEstado.DataSource = null;
        grdEstado.DataBind();

        cboYear.UpdateAfterCallBack = true;
        cboMonth.UpdateAfterCallBack = true;
        txtCtaBanc.UpdateAfterCallBack = true;
        txtCtaBancDes.UpdateAfterCallBack = true;
        grdEstado.UpdateAfterCallBack = true;
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
        string fileName = fuArchivo.FileName;

        if (fileName != "")
        {
            try
            {
                string end = (Request.ApplicationPath.EndsWith("/")) ? "" : "/";
                string path = Request.ApplicationPath + end;
                string appPath = Request.PhysicalApplicationPath;

                int lastPoint = fuArchivo.FileName.LastIndexOf(".");
                string extension = fuArchivo.FileName.Substring(lastPoint + 1);

                intEmpresa = Convert.ToString(txtEmpresa.Text == "" ? Contabilidad.SEMSession.GetInstance.IntEmpresa : Convert.ToInt32(txtEmpresa.Text));
                usuario = Contabilidad.SEMSession.GetInstance.StrUsuario.ToString();

                fileName = appPath + "Administracion/" + fileName;
                //fuArchivo.PostedFile.SaveAs(fileName);

                switch (txtCtaBanc.Text)
                {
                    case "101":
                        Bancomer(fileName);
                        break;
                    case "201":
                        Banamex(fileName);
                        break;
                    case "501":
                        BanRegio(fileName);
                        break;
                }

                //File.Delete(fileName);
                txtCtaBanc.Text = "";
                txtCtaBancDes.Text = "";
                Anthem.Manager.RegisterStartupScript(Page.GetType(), "CorrSave", "alert('Se proceso correctamente.');", true);
            }
            catch (Exception ex)
            {
                Anthem.Manager.RegisterStartupScript(Page.GetType(), "ErrorSave", "alert('" + ex.Message + "');", true);
            }
        }
        else
        {
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "Error1Save", "alert('Seleccione un archivo.');", true);
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

    #region txtCtaBanc_TextChanged
    protected void txtCtaBanc_TextChanged(object sender, EventArgs e)
    {
        CuentasBancarias cuentas;
        cuentas = new CuentasBancarias();

        Entity_CuentasBancarias obj;
        obj = new Entity_CuentasBancarias();

        obj.IntEmpresa = txtEmpresa.Text == "" ? Contabilidad.SEMSession.GetInstance.IntEmpresa : Convert.ToInt32(txtEmpresa.Text);
        obj.intCuentaBancaria = txtCtaBanc.Text == "" ? 0 : Convert.ToInt32(txtCtaBanc.Text);

        obj = cuentas.Fill(obj);

        if (!(obj == null))
        {
            if (txtCtaBanc.Text != "")
            {
                if (obj.strNombre != null)
                {
                    txtCtaBancDes.Text = obj.strNombre.ToString();

                }
                else
                {
                    txtCtaBanc.Text = "";
                    txtCtaBancDes.Text = "";
                    //Clear();
                }
            }
            else
            {
                txtCtaBanc.Text = "";
                txtCtaBancDes.Text = "";
                Clear();
            }
        }
        else
        {
            txtCtaBanc.Text = "";
            txtCtaBancDes.Text = "";
            Clear();
        }
        txtCtaBanc.UpdateAfterCallBack = true;
        txtCtaBancDes.UpdateAfterCallBack = true;
       
        cuentas = null;
        obj = null;
    }
    #endregion

    #region BindGrid
    public void BindGrid()
    {
        Conciliaciones con;
        con = new Conciliaciones();

        Entity_Conciliaciones obj;
        obj = new Entity_Conciliaciones();

        DataTable dt;

        obj.IntEmpresa = txtEmpresa.Text == "" ? Contabilidad.SEMSession.GetInstance.IntEmpresa : Convert.ToInt32(txtEmpresa.Text);
        obj.IntEjercicio = Convert.ToInt32(cboYear.SelectedValue);
        obj.IntMes = Convert.ToInt32(cboMonth.SelectedValue);
        obj.intCuentaBancaria = Convert.ToInt32(txtCtaBanc.Text);
        obj.IntDireccion = this.Direction;
        obj.SortExpression = this.SortExpression;

        dt = con.List(obj);

        grdEstado.DataSource = dt;
        grdEstado.DataBind();
        grdEstado.UpdateAfterCallBack = true;

        con = null;
        obj = null;

    }
    #endregion    

    #region row_Created
    protected void row_Created(object sender, GridViewRowEventArgs e)
    {
        ////if (e.Row.RowType == DataControlRowType.DataRow)
        ////{
        ////    DataRowView dataRowView = (DataRowView)e.Row.DataItem;
        ////    if (dataRowView != null)
        ////    {
        ////        e.Row.Style.Value = "background-color:#FFCC99;color:Black;font-family: Tahoma;font-size: 8pt;Height:30px;font-weight:bold";

        ////        //e.Row.Style.Value = "background-color:#DC143C;color:Black;font-family: Tahoma;font-size: 8pt;Height:30px;font-weight:bold";
        ////    }
        ////}
    }
    #endregion    

    #region Bancomer
    private void Bancomer(string path)
    {
        string result;
        try
        {
            Entity_Conciliaciones obj;
            obj = new Entity_Conciliaciones();

            Conciliaciones con;
            con = new Conciliaciones();

            string banco;
            string fecha;
            string referencia;
            string concepto;
            string monto;
            string movto;
            decimal dblMonto;
            int intEmpresa = txtEmpresa.Text == "" ? Contabilidad.SEMSession.GetInstance.IntEmpresa : Convert.ToInt32(txtEmpresa.Text);
            int intEjercicio = Convert.ToInt32(cboYear.SelectedValue);
            int intMes = Convert.ToInt32(cboMonth.SelectedValue);
            int intCuentaBancaria = Convert.ToInt32(txtCtaBanc.Text);
            int row = 1;


            using (StreamReader sr = new StreamReader(path))
            {
                string line;
                while ((line = sr.ReadLine()) != null)
                {
                    banco = line.Substring(0, 15);
                   fecha = line.Substring(18, 10);
                    referencia = line.Substring(28, 6);
                    concepto = line.Substring(34, 30);
                    monto = line.Substring(65, 16);
                    movto = line.Substring(64, 1);
                    fecha = fecha.Split('-')[2] + "-" + fecha.Split('-')[1] + "-" + fecha.Split('-')[0];

                    dblMonto = Convert.ToDecimal(monto);

                    if (referencia == "000000")
                    {
                        referencia = "00000" + row.ToString();
                        row++;
                    }

                    if (movto != "2")
                    {

                        if (movto == "0")
                            dblMonto = dblMonto * -1;

                        obj.IntEmpresa = txtEmpresa.Text == "" ? Contabilidad.SEMSession.GetInstance.IntEmpresa : Convert.ToInt32(txtEmpresa.Text);
                        obj.IntEjercicio = Convert.ToInt32(cboYear.SelectedValue);
                        obj.IntMes = Convert.ToInt32(cboMonth.SelectedValue);
                        obj.intCuentaBancaria = Convert.ToInt32(txtCtaBanc.Text);
                        obj.StrReferencia = referencia;
                        obj.DblImporte =  dblMonto;
                        obj.DatFecha = fecha;
                        obj.StrUsuario = Contabilidad.SEMSession.GetInstance.StrUsuario;
                        obj.StrMaquina = Contabilidad.SEMSession.GetInstance.StrMaquina;
                        obj.StrConcepto = concepto;
                        obj.strKeys = "0101";

                        bool res = false;

                        res = con.TemConciliacion(obj);

                    }

                }
            }
            obj = null;
            con = null;
            BindGrid();
        }
        catch (Exception e)
        {
            // Let the user know what went wrong.
            Console.WriteLine("The file could not be read:");
            Console.WriteLine(e.Message);
        }
    }
    #endregion

    #region Banamex
    private void Banamex(string path)
    {
        string result;
        try
        {
            string fecha;
            string concepto;
            string retiros;
            string depositos;
            decimal dblMonto;
            string referencia;
            string type;
            int last;
            
            Entity_Conciliaciones obj;
            obj = new Entity_Conciliaciones();

            Conciliaciones con;
            con = new Conciliaciones();

            obj.IntEmpresa  = txtEmpresa.Text == "" ? Contabilidad.SEMSession.GetInstance.IntEmpresa : Convert.ToInt32(txtEmpresa.Text);
            obj.IntEjercicio  = Convert.ToInt32(cboYear.SelectedValue);
            obj.IntMes  = Convert.ToInt32(cboMonth.SelectedValue);
            obj.intCuentaBancaria  = Convert.ToInt32(txtCtaBanc.Text);

            result = con.Val(obj);

            bool resDel = false;
            if (result == "0")
                resDel = con.Del(obj);
            else
            {
                Anthem.Manager.RegisterStartupScript(Page.GetType(), "ErrExist", "alert('No se puede generar. Existen conciliaciones');", true);
                return;
            }

            using (StreamReader sr = new StreamReader(path))
            {
                string line;
                while ((line = sr.ReadLine()) != null)
                {
                    last = line.IndexOf("$");
                    fecha = line.Split(',')[0];
                    if (fecha != "FECHA")
                    {
                        concepto = line.Split(',')[1];
                        retiros = line.Split('\"')[5];
                        depositos = line.Split('\"')[7];

                        fecha = fecha.Replace("\"", "");
                        concepto = concepto.Replace("\"", "");
                        retiros = retiros.Replace("\"", "").Replace("$", "").Replace("M.N", "").Replace(",", "");
                        depositos = depositos.Replace("\"", "").Replace("$", "").Replace("M.N", "").Replace(",", "");
                        last = concepto.LastIndexOf(" ");
                        referencia = concepto.Substring(last + 1);

                        //type = line.Split(',')[2].Replace("\"", "");

                        //if (type == "")
                        //    retiros = "";

                        if (!IsNumber(referencia))
                            referencia = "1";


                        if (retiros == "")
                            dblMonto = Convert.ToDecimal(depositos) * -1;
                        else
                            dblMonto = Convert.ToDecimal(retiros);

                        //fecha = fecha + "-" + cboEjercicio.SelectedValue;

                        if (fecha != "")
                        {
                            obj.IntEmpresa = txtEmpresa.Text == "" ? Contabilidad.SEMSession.GetInstance.IntEmpresa : Convert.ToInt32(txtEmpresa.Text);
                            obj.IntEjercicio = Convert.ToInt32(cboYear.SelectedValue);
                            obj.IntMes = Convert.ToInt32(cboMonth.SelectedValue);
                            obj.intCuentaBancaria = Convert.ToInt32(txtCtaBanc.Text);
                            obj.StrReferencia = referencia;
                            obj.DblImporte = dblMonto;
                            obj.DatFecha = fecha;
                            obj.StrUsuario = Contabilidad.SEMSession.GetInstance.StrUsuario;
                            obj.StrMaquina = Contabilidad.SEMSession.GetInstance.StrMaquina;
                            obj.StrConcepto = concepto;
                            obj.strKeys = "0201";

                            bool res = false;

                            res = con.TemConciliacion(obj);
                        }
                    }
                }
            }
            obj = null;
            con = null;
            BindGrid();
        }
        catch (Exception e)
        {
            // Let the user know what went wrong.
            Console.WriteLine("The file could not be read:");
            Console.WriteLine(e.Message);
        }

    }
    #endregion

    #region BanRegio
    private void BanRegio(string path)
    {

        string result;
        try
        {
            string fecha;
            string concepto;
            string referencia;
            string retiros;
            string depositos;
            decimal dblMonto;
            string type;
            int first;
            int last;

            Entity_Conciliaciones obj;
            obj = new Entity_Conciliaciones();

            Conciliaciones con;
            con = new Conciliaciones();

            obj.IntEmpresa = txtEmpresa.Text == "" ? Contabilidad.SEMSession.GetInstance.IntEmpresa : Convert.ToInt32(txtEmpresa.Text);
            obj.IntEjercicio = Convert.ToInt32(cboYear.SelectedValue);
            obj.IntMes = Convert.ToInt32(cboMonth.SelectedValue);
            obj.intCuentaBancaria = Convert.ToInt32(txtCtaBanc.Text);

            result = con.Val(obj);

            bool resDel = false;

            if (result == "0")
                resDel = con.Del(obj);
            else
            {
                Anthem.Manager.RegisterStartupScript(Page.GetType(), "ErrExist", "alert('No se puede generar. Existen conciliaciones');", true);
                return;
            }

            using (StreamReader sr = new StreamReader(path))
            {
                string line;
                while ((line = sr.ReadLine()) != null)
                {
                    fecha = line.Split(',')[0];
                    fecha = fecha.Replace("\"", "");

                    if (IsDate(fecha))
                    {
                        first = line.IndexOf("$");
                        last = line.LastIndexOf("$");
                        concepto = line.Split(',')[1];
                        referencia = line.Split(',')[2];
                        retiros = line.Substring(first + 1, last - first - 2);
                        depositos = line.Substring(first + 1, last - first - 2);

                        concepto = concepto.Replace("\"", "");
                        retiros = retiros.Replace("\"", "").Replace("$", "").Replace("M.N", "").Replace(",", "");
                        depositos = depositos.Replace("\"", "").Replace("$", "").Replace("M.N", "").Replace(",", "");
                        referencia = referencia.Replace("\"", "").Replace("_", "");

                        type = line.Split(',')[3].Replace("\"", "");

                        if (type == "")
                            retiros = "";

                        if (retiros == "")
                            dblMonto = Convert.ToDecimal(depositos) * -1;
                        else
                            dblMonto = Convert.ToDecimal(retiros);

                        obj.IntEmpresa = txtEmpresa.Text == "" ? Contabilidad.SEMSession.GetInstance.IntEmpresa : Convert.ToInt32(txtEmpresa.Text);
                        obj.IntEjercicio = Convert.ToInt32(cboYear.SelectedValue);
                        obj.IntMes = Convert.ToInt32(cboMonth.SelectedValue);
                        obj.intCuentaBancaria = Convert.ToInt32(txtCtaBanc.Text);
                        obj.StrReferencia = referencia;
                        obj.DblImporte = dblMonto;
                        obj.DatFecha = fecha;
                        obj.StrUsuario = Contabilidad.SEMSession.GetInstance.StrUsuario;
                        obj.StrMaquina = Contabilidad.SEMSession.GetInstance.StrMaquina;
                        obj.StrConcepto = concepto;
                        obj.strKeys = "0501";

                        bool res = false;

                        res = con.TemConciliacion(obj);
                    }
                }
            }
            con = null;
            obj = null;
            BindGrid();
        }
        catch (Exception e)
        {
            // Let the user know what went wrong.
            Console.WriteLine("The file could not be read:");
            Console.WriteLine(e.Message);
        }

    }
    #endregion

    #region IsDate
    private bool IsDate(string date)
    {
        bool Isdate = true;

        try
        {
            DateTime dt = DateTime.Parse(date);
        }
        catch
        {
            Isdate = false;
        }
        return Isdate;
    }
    #endregion

    #region IsNumber
    private bool IsNumber(string number)
    {
        bool Isnumber = true;

        try
        {
            int num = Convert.ToInt32(number);
        }
        catch
        {
            Isnumber = false;
        }
        return Isnumber;
    }
    #endregion
}


