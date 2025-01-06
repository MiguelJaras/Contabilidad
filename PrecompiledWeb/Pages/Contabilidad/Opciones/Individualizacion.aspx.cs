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
using Contabilidad.Entity;
using Contabilidad.Bussines;
using System.Text;

public partial class Pages_Contabilidad_Opciones_Individualizacion : System.Web.UI.Page
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
        dataList = new StringBuilder();
        dataColumns = new StringBuilder();
        colModel = new StringBuilder();
        dataColony = new StringBuilder();

        string end = (Request.ApplicationPath.EndsWith("/")) ? "" : "/";
        string path = Request.ApplicationPath + end;
        realPath = String.Format("http://{0}{1}{2}", Request.Url.Authority, path, "Img/dxpcFooterBack.gif");

        Anthem.Manager.Register(this);
        if (!IsPostBack && !IsCallback)
        {
            toolbar.PrintValid();
            FillColonia();
            FillSector();
            txtFechaInicial.Text = DateTime.Now.ToString("dd/MM/yyyy");
            txtFechaFinal.Text = DateTime.Now.ToString("dd/MM/yyyy");
            List();
        }
        ImgDate.OnClientClick = "if(self.gfPop)gfPop.fPopCalendar(document.getElementById('" + txtFechaInicial.ClientID + "')); giDatePos=0; return false;";
        ImgDate.OnClientClick = "if(self.gfPop)gfPop.fPopCalendar(document.getElementById('" + txtFechaInicial.ClientID + "')); giDatePos=0; return false;";
        ImgDateFin.OnClientClick = "if(self.gfPop)gfPop.fPopCalendar(document.getElementById('" + txtFechaFinal.ClientID + "')); giDatePos=0; return false;";
    }

    protected void Page_PreRender(object sender, EventArgs e)
    {
     //   List();
        toolbar.ListPostBACK(true);
        toolbar.List(false);
        toolbar.Print(false);
        toolbar.New(false);
        toolbar.Exportar(true);
        toolbar.Email(false);
        toolbar.Delete(false);
        toolbar.Save(false);
    }


    #region Print
    private void Print()
    {
        Entity_CuentasBancarias obj = new Entity_CuentasBancarias();
        obj.intFolio = cboColonia.SelectedValue == "" ? 0 : Convert.ToInt32(cboColonia.SelectedValue);
        obj.StrFechaInicial = txtFechaInicial.Text;// ==""? Convert.ToDateTime("01/01/1900"): Convert.ToDateTime(txtFechaInicial.Text);
        obj.StrFechaFinal = txtFechaFinal.Text;// == "" ? Convert.ToDateTime("01/01/1900") : Convert.ToDateTime(txtFechaFinal.Text);

        string[] arrDatos;
        arrDatos = new string[5];
        arrDatos[0] = txtFechaInicial.Text;
        arrDatos[1] = txtFechaFinal.Text;
        arrDatos[2] = cboColonia.SelectedValue;
        arrDatos[3] = rbOrder.SelectedValue;
        arrDatos[4] = cboSector.SelectedValue == "" ? "0" : cboSector.SelectedValue;

        string query;

        query = sqlQuery("vetecmarfil..usp_tbIndividualizacion_ListXLS ", arrDatos);

        obj = null;

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

    #region FillColonia
    private void FillColonia()
    {
        Colonia col;
        col = new Colonia();
        Entity_Colonia obj = new Entity_Colonia();
        DataTable dt;
        obj.intColonia = 0;
        dt = col.List(obj);

        cboColonia.DataSource = dt;
        cboColonia.DataTextField = "strNombre";
        cboColonia.DataValueField = "intColonia";
        cboColonia.DataBind();

        cboColonia.Items.Insert(0, new ListItem("Seleccione...", "0"));
        cboColonia.UpdateAfterCallBack = true;

        col = null;
    }
    #endregion

    #region FillSector
    private void FillSector()
    {
        int colonia = 0;
        Sector sec = new Sector();
        DataTable dt;
        colonia = Convert.ToInt32( cboColonia.SelectedValue);
        dt = sec.GetListByColonia(colonia);

        cboSector.DataSource = dt;
        cboSector.DataTextField = "strNombre";
        cboSector.DataValueField = "intSector";
        cboSector.DataBind();

        cboSector.Items.Insert(0, new ListItem("Seleccione...", "0"));
        cboSector.UpdateAfterCallBack = true;

        sec = null;
    }
    #endregion

    #region Event
    void Me_Event(object sender, HandlerArgs args)
    {
        switch (args.Event)
        {
            case Event.Save:
                break;
            case Event.New:
                break;
            case Event.Delete:
                break;
            case Event.Print:
                break;
            case Event.List:
                List();
                break;
            case Event.Export:
                Print();
                break;
            default:
                break;
        }
    }
   #endregion

    #region List
    private void List()
    {
        int rows;
        int count = 0;
        int count2 = 0;
        int countColumn = 0;
        DataTable dt;

        Entity_CuentasBancarias obj = new Entity_CuentasBancarias();
        Individualizacion ind = new Individualizacion();

        obj.intFolio = cboColonia.SelectedValue =="" ? 0 : Convert.ToInt32(cboColonia.SelectedValue);
        obj.StrFechaInicial = txtFechaInicial.Text;// ==""? Convert.ToDateTime("01/01/1900"): Convert.ToDateTime(txtFechaInicial.Text);
        obj.StrFechaFinal = txtFechaFinal.Text;// == "" ? Convert.ToDateTime("01/01/1900") : Convert.ToDateTime(txtFechaFinal.Text);
        obj.IntParametroInicial = Convert.ToInt32( rbOrder.SelectedValue);
        obj.IntParametroFinal = cboSector.SelectedValue == "" ? 0 : Convert.ToInt32(cboSector.SelectedValue);
        dt = ind.GetList(obj);

        if (dt != null)
        {
            rows = dt.Rows.Count;
            countColumn = dt.Columns.Count;

            foreach (DataColumn column in dt.Columns)
            {
                count = count + 1;
                if (count == countColumn)
                {
                    dataColumns.Append("'" + column.ColumnName.Replace("%", "") + "'");
                    colModel.Append("{ index:'" + column.ColumnName.Replace(" ", "").Replace("%", "") + "',name:'" + column.ColumnName.Replace(" ", "").Replace("%", "") + "',width:100," + TypeValue(column.DataType.ToString()) + ",  hidden:false }");
                }
                else
                {
                    dataColumns.Append("'" + column.ColumnName.Trim().Replace("intArea", "#") + "',");

                    switch (count)
                    {
                        case 1:
                            colModel.Append("{ index:'" + column.ColumnName.Replace(" ", "").Replace("%", "") + "',name:'" + column.ColumnName.Replace(" ", "").Replace("%", "") + "',width:65," + TypeValue(column.DataType.ToString()) + " ,  hidden:false}, ");
                            break;
                        default:
                            colModel.Append("{ index:'" + column.ColumnName.Replace(" ", "").Replace("%", "") + "',name:'" + column.ColumnName.Replace(" ", "").Replace("%", "") + "',width:" + Size(column.ColumnName) + "," + TypeValue(column.DataType.ToString()) + Sum(column.ColumnName) + " },");
                            //colModel.Append("{ index:'" + column.ColumnName.Replace(" ", "").Replace("%", "") + "',name:'" + column.ColumnName.Replace(" ", "").Replace("%", "") + "',width:" + Size(column.ColumnName) + "," + TypeValue(column.DataType.ToString()) + " },");
                            break;
                    }
                }
            }

            count = 0;

            //dataList.Append("[");
            foreach (DataRow row in dt.Rows)
            {
                count = count + 1;
                count2 = 0;

                dataList.Append("{");
                foreach (DataColumn column in dt.Columns)
                {
                    count2 = count2 + 1;
                    if (count2 == countColumn)
                        dataList.Append("'" + column.ColumnName.Replace(" ", "").Replace("%", "") + "':'" + row[column.ColumnName] + "'");
                    else
                        dataList.Append("'" + column.ColumnName.Replace(" ", "").Replace("%", "") + "':'" + row[column.ColumnName] + "',");

                }

                if (count == rows)
                    dataList.Append("}");
                else
                    dataList.Append("},");

            }
        }
        ind = null;
        obj = null;
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
            if (data.ToUpper().Contains("COLONIA") || data.ToUpper().Contains("NOMBRE") || data.ToUpper().Contains("DIRECCION"))
                result = "200";
            else
            {
                if (data.ToUpper().Contains("CLIENTE"))
                    result = "200";
                else
                    if(data.ToUpper().Contains("VALOR TERRENO"))
                        result = "120";
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
                result = "align: 'Right', formatter: 'number'";
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

    #region Sum()
    private string Sum(string data)
    {
        string result = "";
        if (data.ToUpper().Contains("TERRENO") || data.ToUpper().Contains("CONSTRUCCION") || data.ToUpper().Contains("OPERACION") || data.ToUpper().Contains("BONIFICACION") || data.ToUpper().Contains("NETO"))           
            result = ",summaryType: 'sum'";
        else
            result = "";

        return result;
    }
    #endregion

    protected void lknList_Click(object sender, EventArgs e)
    {
        List();
    }

    protected void lknExport_Click(object sender, EventArgs e)
    {
        Entity_CuentasBancarias obj = new Entity_CuentasBancarias();
        obj.intFolio = cboColonia.SelectedValue == "" ? 0 : Convert.ToInt32(cboColonia.SelectedValue);
        obj.StrFechaInicial = txtFechaInicial.Text;// ==""? Convert.ToDateTime("01/01/1900"): Convert.ToDateTime(txtFechaInicial.Text);
        obj.StrFechaFinal = txtFechaFinal.Text;// == "" ? Convert.ToDateTime("01/01/1900") : Convert.ToDateTime(txtFechaFinal.Text);

        string[] arrDatos;
        arrDatos = new string[5];
        arrDatos[0] = txtFechaInicial.Text;
        arrDatos[1] = txtFechaFinal.Text;
        arrDatos[2] = cboColonia.SelectedValue;
        arrDatos[3] = rbOrder.SelectedValue;
        arrDatos[4] = cboSector.SelectedValue == "" ? "0" : cboSector.SelectedValue;

        string query;

        query = sqlQuery("vetecmarfil..usp_tbIndividualizacion_List ", arrDatos);//usp_tbIndividualizacion_ListXLS

        obj = null;

        string a = hddBody.Value ;

        string queryString = "?query=" + query + "&type=xls";
        Response.Redirect("../../../Utils/Excel.aspx" + queryString);
    }
    

    protected void cboColonia_SelectedIndexChanged(object sender, EventArgs e)
    {
        FillSector();
    }
}
