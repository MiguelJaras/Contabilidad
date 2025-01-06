using System;
using System.Data;
using System.Data.SqlClient;
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
using System.IO;
using System.Data.OleDb;
using Excel;
using System.Text;
using System.Globalization;


public partial class Pages_Contabilidad_Opciones_ConciliacionCFDI : System.Web.UI.Page
{
    public string realPath;

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


    Pages_Base toolbar;


    protected void Page_Load(object sender, EventArgs e)
    {
        toolbar = (Pages_Base)this.Master;
        toolbar.PageEvent += new HandlerEvent(Me_Event);
        string end = (Request.ApplicationPath.EndsWith("/")) ? "" : "/";
        string path = Request.ApplicationPath + end;
        Anthem.Manager.Register(this);
        //btnSave.UpdateAfterCallBack = true;

        if (!IsPostBack)
        {
            //btnSave.Attributes.Add("onclick", "return datosCompletos();");

            txtEmpresa.Text = Contabilidad.SEMSession.GetInstance.IntEmpresa.ToString();
            txtEmpresa_TextChange(null, null);
            Year();
            Month();
            cboEjercicio.SelectedValue = DateTime.Now.Year.ToString();
            cboMonth.SelectedValue = Convert.ToString(DateTime.Now.Month - 1);
            realPath = String.Format("http://{0}{1}{2}", Request.Url.Authority, path, "Img/bg_btn.png");
           
        }
    }

    #region Event
    void Me_Event(object sender, HandlerArgs args)
    {
        switch (args.Event)
        {
            case Event.Save:
                //Save();
                break;
            case Event.New:
                //Clear();
                break;
            case Event.Delete:
                //Delete();
                break;
            case Event.Print:
                //Print();
                break;
            case Event.List:
                BindGrid();
                break;
            case Event.Export:
                Excel();
                break;
            default:
                break;
        }
    }
    #endregion   
    #region btn_Click
    protected void btn_Click(object sender, ImageClickEventArgs e)
    {
        Anthem.ImageButton btn = (Anthem.ImageButton)sender;
        HandlerArgs args = new HandlerArgs();

        switch (btn.CommandName)
        {
            case "Save":
                args.Event = Event.Save;
                Save();
                break;
            case "Delete":
                args.Event = Event.Delete;
                break;
            case "New":
                args.Event = Event.New;
                break;
            case "List":
                args.Event = Event.List;
                BindGrid();
                break;
            case "Email":
                args.Event = Event.Email;
                break;
            case "Print":
                args.Event = Event.Print;
                Imprimir();
                break;
            case "Export":
                args.Event = Event.Export;
                Excel();
                break;
            default:
                break;
        }

    }
    #endregion btn_Click    

    protected void Page_PreRender(object sender, EventArgs e)
    {
        toolbar.Print(false);
        toolbar.Save(false);
        toolbar.New(false);
        toolbar.Exportar(true);
        toolbar.Email(false);
        toolbar.Delete(false);
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

        cboEjercicio.DataSource = list.Ejercicio(Contabilidad.SEMSession.GetInstance.IntEmpresa, Contabilidad.SEMSession.GetInstance.IntSucursal);
        cboEjercicio.DataTextField = "Id";
        cboEjercicio.DataValueField = "strNombre";
        cboEjercicio.DataBind();

        cboEjercicio.UpdateAfterCallBack = true;

        list = null;

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

        Clear();

        hddSucursal.UpdateAfterCallBack = true;
        txtEmpresa.UpdateAfterCallBack = true;
        txtNombreEmpresa.UpdateAfterCallBack = true;

        Anthem.Manager.RegisterStartupScript(Page.GetType(), "FocuscboEjercicio", "document.getElementById('" + cboEjercicio.ClientID + "').focus(); ", true);

        obj = null;
        emp = null;
    }
    #endregion txtEmpresa_TextChange  

    #region Clear
    private void Clear()
    {

        DgrdList.DataSource = null;
        DgrdList.DataBind();
       
        DgrdList.UpdateAfterCallBack = true;
     
    }
    #endregion



  

    #region Save
    private void Save()
    {

 
    }
    #endregion


    #region BtnBuscar
    protected void btnBuscar(object sender, ImageClickEventArgs e)
    {
        Entity_Conciliacion obj;
        obj = new Entity_Conciliacion();
        Conciliacion con;
        con = new Conciliacion();
        DataTable dt;

        obj.IntEmpresa = txtEmpresa.Text == "" ? 0 : Convert.ToInt32(txtEmpresa.Text);
        obj.IntEjercicio = Convert.ToInt32(cboEjercicio.SelectedValue);
        obj.IntMes = Convert.ToInt32(cboMonth.SelectedValue);
        obj.IntDireccion = Convert.ToInt32(this.Direction);
        obj.SortExpression = this.SortExpression;

        dt = con.Busqueda(obj);
        Session["GridViewData"] = dt;
        DgrdList.DataSource = dt;
        DgrdList.DataBind();
        DgrdList.UpdateAfterCallBack = true;

        obj = null;
        con = null;

    }
    #endregion


    #region BindGrid
    public void BindGrid()
    {
        Entity_Conciliacion obj;
        obj = new Entity_Conciliacion();
        Conciliacion con;
        con = new Conciliacion();
        DataTable dt;


        obj.IntEmpresa = txtEmpresa.Text == "" ? 0 : Convert.ToInt32(txtEmpresa.Text);
        obj.IntEjercicio  = Convert.ToInt32(cboEjercicio.SelectedValue);
        obj.IntMes  = Convert.ToInt32(cboMonth.SelectedValue);
        obj.IntDireccion = Convert.ToInt32(this.Direction);
        obj.SortExpression = this.SortExpression;

        dt = con.Lista(obj);
        Session["GridViewData"] = dt;
        DgrdList.DataSource = dt;
        DgrdList.DataBind();
        DgrdList.UpdateAfterCallBack = true;

        obj = null;
        con  = null;
    }
    #endregion   
    

    #region btnFilter_Click
    protected void btnFilter_Click(object sender, EventArgs e)
    {
      
    }
    #endregion      

    #region DgrdList_Sorting
    protected void DgrdList_Sorting(object sender, GridViewSortEventArgs e)
    {
        if (SortExpression == e.SortExpression)
        {
            if (Direction == (e.SortDirection == SortDirection.Ascending ? 1 : 0))
                Direction = 0;
            else
                Direction = 1;
        }
        else
            Direction = e.SortDirection == SortDirection.Ascending ? 1 : 0;
        SortExpression = e.SortExpression;
        BindGrid();
    }
    #endregion

    #region AresFormGridView1_RowCreated
    protected void AresFormGridView1_RowCreated(object sender, GridViewRowEventArgs e)
    {
        //if (e.Row.RowType == DataControlRowType.Header)
        //    e.Row.SetRenderMethodDelegate(RenderHeaderGridAbonos);
    }
    #endregion

    #region DgrdList_RowCreated
    protected void DgrdList_RowCreated(object sender, GridViewRowEventArgs e)
    {
        //if (e.Row.RowType == DataControlRowType.Header)
        //    e.Row.SetRenderMethodDelegate(RenderHeaderGridCargos);
    }
    #endregion

    #region DgrdList_RowDataBound
    //protected void DgrdList_RowDataBound(object sender, GridViewRowEventArgs e)
    //{
    //    //if (e.Row.RowType == DataControlRowType.DataRow)
    //    //{
    //    //    e.Row.Cells[e.Row.Cells.Count - 1].Attributes.Add("onClick", "SumaCargos('" + e.Row.ClientID + "');");
    //    //    e.Row.Style.Add("cursor", "hand");
    //    //    DataRowView dataRowView = (DataRowView)e.Row.DataItem;
    //    //    if (dataRowView != null)
    //    //    {
    //    //        TextBox txtBanco = (TextBox)e.Row.FindControl("txtBanco");
    //    //        if (txtBanco != null)
    //    //        {
    //    //            txtBanco.Attributes.Add("onKeyPress", "OnlyNumber()");
    //    //            txtBanco.Attributes.Add("onKeyDown", "UpDownBank(" + e.Row.RowIndex.ToString() + ")");
    //    //            txtBanco.Style.Value = "font-family: Tahoma, Arial, Helvetica, sans-serif;font-size: 8pt;";
    //    //        }

    //    //        //e.Row.ToolTip = "Exp.\n" + DgrdList.DataKeys[e.Row.RowIndex]["VcMovExplanation"].ToString()
    //    //        //                + "\n\nExp. Remark\n" + DgrdList.DataKeys[e.Row.RowIndex]["VcMovExpRemark"].ToString();
    //    //    }
    //    //}
    //}
    #endregion
    protected void DgrdList_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        // Verifica si la fila es del tipo DataRow (una fila de datos)
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            // Cambia el color de la columna FechaPoliza
            int fechaPolizaColumnIndex = GetColumnIndexByName("FechaPoliza");
            if (fechaPolizaColumnIndex != -1)
            {
                e.Row.Cells[fechaPolizaColumnIndex].BackColor = System.Drawing.Color.FromArgb(204, 255, 204); // Color de fondo
            }

            // Cambia el color de la columna Poliza
            int polizaColumnIndex = GetColumnIndexByName("Poliza");
            if (polizaColumnIndex != -1)
            {
                e.Row.Cells[polizaColumnIndex].BackColor = System.Drawing.Color.FromArgb(204, 255, 204); // Color de fondo
            }
        }
        // Verifica si es la fila del encabezado
    if (e.Row.RowType == DataControlRowType.Header)
    {
        for (int i = 0; i < DgrdList.Columns.Count; i++)
        {
            string sortExpression = ((BoundField)DgrdList.Columns[i]).SortExpression;
            
            // Agrega el evento de doble clic al encabezado
           // e.Row.Cells[i].Attributes["ondblclick"] = $"sortGridView('{sortExpression}')";
        }
    }
    }

    // Método para obtener el índice de la columna por nombre
    private int GetColumnIndexByName(string columnName)
    {
        foreach (DataControlField column in DgrdList.Columns)
        {
            if (column is BoundField && ((BoundField)column).DataField == columnName)
            {
                return DgrdList.Columns.IndexOf(column);
            }
        }
        return -1; // Si no se encuentra la columna
    }
    #region AresFormGridView1_RowDataBound
    protected void AresFormGridView1_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        //se asigana a la celda del checkbox la funcion en java script 
        //para hacer las suma de los abonos de los registros que se seleccionen
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            e.Row.Cells[e.Row.Cells.Count - 1].Attributes.Add("onClick", "SumaAbonos('" + e.Row.ClientID + "');");
            e.Row.Style.Add("cursor", "hand");

            DataRowView dataRowView = (DataRowView)e.Row.DataItem;
            if (dataRowView != null)
            {
                TextBox txtPoliza = (TextBox)e.Row.FindControl("txtPoliza");
                if (txtPoliza != null)
                {
                    txtPoliza.Style.Value = "font-family: Tahoma, Arial, Helvetica, sans-serif;font-size: 8pt;";
                    txtPoliza.Attributes.Add("onKeyPress", "OnlyNumber()");
                    txtPoliza.Attributes.Add("onKeyDown", "UpDownPoliza(" + e.Row.RowIndex.ToString() + ")");
                }

                //e.Row.ToolTip = "Exp.\n" + DgrdList.DataKeys[e.Row.RowIndex]["VcMovExplanation"].ToString()
                //                + "\n\nExp. Remark\n" + DgrdList.DataKeys[e.Row.RowIndex]["VcMovExpRemark"].ToString();
            }
            //e.Row.ToolTip = "Exp.\n" + AresFormGridView1.DataKeys[e.Row.RowIndex]["VcMovExplanation"].ToString()
            //                + "\n\nExp. Remark\n" + AresFormGridView1.DataKeys[e.Row.RowIndex]["VcMovExpRemark"].ToString();
        }
    }
    #endregion

    #region Imprimir
    protected void Imprimir()
    {

    }
    #endregion  

    #region Excel
    protected void Excel()
    {
        string[] arrDatos;
        Entity_Conciliacion obj;
        obj = new Entity_Conciliacion();

        int intEmpresa = txtEmpresa.Text == "" ? 0 : Convert.ToInt32(txtEmpresa.Text);
        int intEjercicio = Convert.ToInt32(cboEjercicio.SelectedValue);
        int intMes = Convert.ToInt32(cboMonth.SelectedValue);
        int intDireccion = Convert.ToInt32(this.Direction);
        string strSortExpresion = this.SortExpression;
        arrDatos = new string[5];
        arrDatos[0] = intEmpresa.ToString();
        arrDatos[1] = intEjercicio.ToString();
        arrDatos[2] = intMes.ToString();
        arrDatos[3] = intDireccion.ToString();
        arrDatos[4] = strSortExpresion;

        string query;
        query = sqlQuery("VetecMarfilAdmin..usp_tbCFDI_Conciliacion ", arrDatos);

        string queryString = "?query=" + query + "&type=xls";
        Response.Redirect("../../../Utils/Excel.aspx" + queryString);

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


    private string Direccion(string strFolio)
    {
        int countBanco = 0;
        int countCheque = 0;
        string value = "";

        for (int i = 0; i < DgrdList.Rows.Count; i++)
        {
            TextBox txtBanco = (TextBox)DgrdList.Rows[i].FindControl("txtBanco");

            if (txtBanco.Text == strFolio)
                countBanco++;
        }

        for (int j = 0; j < DgrdList.Rows.Count; j++)
        {
            TextBox txtPoliza = (TextBox)DgrdList.Rows[j].FindControl("txtPoliza");

            if (txtPoliza.Text == strFolio)
                countCheque++;
        }

        if (countBanco == countCheque)
            value = "2";

        if (countBanco > countCheque)
            value = "1";

        if (countBanco < countCheque)
            value = "1";

        return value;
    }
}
