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


public partial class Administracion_Contabilidad_Afectacion : System.Web.UI.Page
{
    public int Direction
    {
        get { return ViewState["Direction"] != null ? (int)ViewState["Direction"] : 0; }
        set { ViewState["Direction"] = value; }
    }

    public string realPath;
    Pages_Base toolbar;


    protected void Page_Load(object sender, EventArgs e)
    {
        toolbar = (Pages_Base)this.Master;
        toolbar.PageEvent += new HandlerEvent(Me_Event);

        string end = (Request.ApplicationPath.EndsWith("/")) ? "" : "/";
        string path = Request.ApplicationPath + end;
        realPath = String.Format("http://{0}{1}{2}", Request.Url.Authority, path, "Img/dxpcFooterBack.gif");

        ctrlPagger1.ChangingPageIndex += new ControlctrlPagger.HandlerChangingPageIndex(ChangingPageIndex);
        ctrlPagger1.ChangingRowCount += new ControlctrlPagger.HandlerChangingRowCount(ChangingRowCount);

        if (!IsPostBack && !IsCallback)
        {
            Month();
            Year();
            cboMonth.SelectedValue = DateTime.Now.Month.ToString();
            cboEjercicio.SelectedValue = DateTime.Now.Year.ToString();
            txtEmpresa.Text = Contabilidad.SEMSession.GetInstance.IntEmpresa.ToString();
            TipoPolizas();
            txtEmpresa_TextChange(null, null);     
            Close();            
        }
    }

    protected void Page_PreRender(object sender, EventArgs e)
    {
        toolbar.Print(false);
        toolbar.Save(false);
        toolbar.New(false);
        toolbar.Exportar(false);
        toolbar.Email(false);
        toolbar.Delete(false);        
    }

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
        Encabezado();
        BindGrid();

        hddSucursal.UpdateAfterCallBack = true;
        txtEmpresa.UpdateAfterCallBack = true;
        txtNombreEmpresa.UpdateAfterCallBack = true;

        obj = null;
        emp = null;
    }
    #endregion txtEmpresa_TextChange    

    #region Encabezado
    protected void Encabezado()
    {
        Entity_Poliza obj;
        obj = new Entity_Poliza();
        Poliza pol;
        pol = new Poliza();

        obj.IntEmpresa = Convert.ToInt32(txtEmpresa.Text);
        obj.IntEjercicio = Convert.ToInt32(cboEjercicio.SelectedValue);
        obj.IntMes = Convert.ToInt32(cboMonth.SelectedValue);
        obj.StrObraInicial = "0";

        pol.Encabezados(obj);

        pol = null;
        obj = null;
    }
    #endregion Encabezado

    #region ChangingPageIndex
    void ChangingPageIndex(object o, ControlctrlPagger.ArgsChangingPageIndex e)
    {
        ctrlPagger1.PageIndex = e.NewPageIndex;
        BindGrid();
    }
    #endregion

    #region ChangingRowCount
    void ChangingRowCount(object o, ControlctrlPagger.ArgsChangingRowCount e)
    {
        ctrlPagger1.PageIndex = 0;
        BindGrid();
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

    #region Close
    private void Close()
    {
        Entity_Poliza obj;
        obj = new Entity_Poliza();

        Poliza pol;
        pol = new Poliza();

        obj.IntEmpresa = Convert.ToInt32(txtEmpresa.Text);
        obj.IntEjercicio = Convert.ToInt32(cboEjercicio.SelectedValue);
        obj.IntMes = Convert.ToInt32(cboMonth.SelectedValue);
        obj.IntModulo = 1;

        hddClose.Value = pol.Close(obj);

        if (hddClose.Value == "1")
        {
            btnAfectar.Visible = false;
            btnDesAfecta.Visible = false;
            lblCerrado.Text = "Mes Cerrado";
            grdAfectacion.DataSource = null;
            grdAfectacion.DataBind();
        }
        else
        {
            btnAfectar.Visible = true;
            btnDesAfecta.Visible = true;
            lblCerrado.Text = "";
        }

        grdAfectacion.UpdateAfterCallBack = true;
        btnAfectar.UpdateAfterCallBack = true;
        btnDesAfecta.UpdateAfterCallBack = true;
        lblCerrado.UpdateAfterCallBack = true;

        obj = null;
        pol = null;
    }
    #endregion 

    #region TipoPolizas
    private void TipoPolizas()
    {
        TiposPoliza tp;
        tp = new TiposPoliza();
        Entity_TiposPoliza obj;
        obj = new Entity_TiposPoliza();
        DataTable dt;

        obj.IntEmpresa = txtEmpresa.Text == "" ? Contabilidad.SEMSession.GetInstance.IntEmpresa : Convert.ToInt32(txtEmpresa.Text);
        obj.intEjercicio = Convert.ToInt32(cboEjercicio.SelectedValue);

        dt = tp.Sel(obj);                        

        cboTipoPoliza.DataSource = dt;
        cboTipoPoliza.DataTextField = "strNombreCbo";
        cboTipoPoliza.DataValueField = "strTipoPoliza";                
        cboTipoPoliza.DataBind();
        cboTipoPoliza.Items.Insert(0, new ListItem("-- Todos --", "0"));
        cboTipoPoliza.SelectedIndex = 0;
        cboTipoPoliza.UpdateAfterCallBack = true;

        cboTipoPolizaFin.DataSource = dt;
        cboTipoPolizaFin.DataTextField = "strNombreCbo";
        cboTipoPolizaFin.DataValueField = "strTipoPoliza";
        cboTipoPolizaFin.DataBind();
        cboTipoPolizaFin.Items.Insert(0, new ListItem("-- Todos --", "0"));
        cboTipoPolizaFin.SelectedIndex = 0;
        cboTipoPolizaFin.UpdateAfterCallBack = true;

        tp = null;
        obj = null;
    }
    #endregion 

    #region cboTipoPoliza_SelectedIndexChanged
    protected void cboTipoPoliza_SelectedIndexChanged(object sender, EventArgs e)
    {
        if(cboTipoPoliza.SelectedValue != "0" && cboTipoPolizaFin.SelectedValue != "0")
            BindGrid();
    }
    #endregion
   
    #region BindGrid
    private void BindGrid()
    {
        Poliza pol;
        pol = new Poliza();
        Entity_Poliza obj;
        obj = new Entity_Poliza();
        DataTable dt;
        Close();

        
        obj.IntEmpresa = Convert.ToInt32(txtEmpresa.Text);
        obj.IntEjercicio = Convert.ToInt32(cboEjercicio.SelectedValue);
        obj.IntMes = Convert.ToInt32(cboMonth.SelectedValue);
        obj.StrObraInicial = cboTipoPoliza.SelectedValue;
        obj.StrObraFinal = cboTipoPolizaFin.SelectedValue;
        obj.IntFolioInicial = txtFolioIni.Text == "" ? 0 : Convert.ToInt32(txtFolioIni.Text);
        obj.intFolioFinal = txtFolioFin.Text == "" ? 0 : Convert.ToInt32(txtFolioFin.Text);
        obj.IntAfectada = Convert.ToInt32(rbdAfectadas.SelectedValue);
        obj.iNumPage = ctrlPagger1.PageIndex;
        obj.iNumRecords = ctrlPagger1.PageSize;
        obj.SortDirection = ctrlPagger1.SortDirection == SortDirection.Ascending ? 1 : 0;
        obj.SortExpression = ctrlPagger1.SortExpression;

        dt = pol.GetListAfecta(obj);

        if (dt != null)
        {
            if (dt.Rows.Count > 0)
            {
                ctrlPagger1.TotalRecords = obj.IntTotalRecords;
                ctrlPagger1.FromRecord = obj.iNumPage * obj.iNumRecords + 1;
                ctrlPagger1.ToRecord = Math.Min(obj.iNumPage * obj.iNumRecords + obj.iNumPage, Convert.ToInt32(ctrlPagger1.TotalRecords));
                ctrlPagger1.TotalPages = obj.IntTotalPages;
                ctrlPagger1.ShowButtons();
                pnlPagger.Visible = true;
            }
            else
                pnlPagger.Visible = false;

            grdAfectacion.DataSource = dt;
            grdAfectacion.DataBind();
        }
        else
            pnlPagger.Visible = false;
        
        grdAfectacion.UpdateAfterCallBack = true;
        pnlPagger.UpdateAfterCallBack = true;

        obj = null;
        pol = null;           
    }
    #endregion
          
    #region row_Created
    protected void row_Created(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            DataRowView dataRowView = (DataRowView)e.Row.DataItem;
            if (dataRowView != null)
            {
                Anthem.LinkButton lknPoliza = (Anthem.LinkButton)e.Row.FindControl("lknPoliza");
                Anthem.CheckBox chkAfectar = (Anthem.CheckBox)e.Row.FindControl("chkAfectar");                

                string poliza = dataRowView.Row["strPoliza"].ToString();
                string afectada = dataRowView.Row["intIndAfectada"].ToString();
                string intCuenta = dataRowView.Row["intCuenta"].ToString();
                string intEjercicio = dataRowView.Row["intEjercicio"].ToString();
                decimal dblDiferencias = Convert.ToDecimal(dataRowView.Row["dblDiferencias"].ToString());
                string empresa = txtEmpresa.Text;

                if (afectada == "1")
                    chkAfectar.Checked = true;
                else
                    chkAfectar.Checked = false;

                if (dblDiferencias == 0)
                    e.Row.Style.Value = "background-color:#EAF7FB;color:#000066;font-family: Tahoma;font-size: 7pt;Height:15px;font-weight:bold;";                
                else
                {
                    chkAfectar.Visible = false;
                    e.Row.Style.Value = "background-color:#FF0000;color:Black;font-family: Tahoma;font-size: 7pt;Height:15px;font-weight:bold";
                }

                if (intCuenta == "0")
                {
                    chkAfectar.Visible = false;
                    e.Row.Style.Value = "background-color:#FF7F24;color:Black;font-family: Tahoma;font-size: 7pt;Height:15px;font-weight:bold";
                }

                if (hddClose.Value == "1")
                {
                    chkAfectar.Visible = false;
                }

                lknPoliza.Text = poliza;
                if (afectada == "1")
                    lknPoliza.Attributes.Add("onClick", "window.open('../../../Utils/PopUpPoliza.aspx?intEmpresa=" + empresa + "&strPoliza=" + poliza + "&intEjercicio=" + intEjercicio + "','','height=700px width=1100px resizable scrollbars');  return false;");
                    //lknPoliza.Attributes.Add("onClick", "window.showModalDialog('../../../Utils/PopUpPoliza.aspx?intEmpresa=" + empresa + "&strPoliza=" + poliza + "&intEjercicio=" + intEjercicio + "',null,'dialogHeight:700px; dialogWidth:1100px;status:no;help:no;scroll:no;minimize:no;maximize:no;close:no;border:thin;');  return false;");
                //window.open(url, "", "height=230px width=600px resizable scrollbars");
                else
                    //lknPoliza.Attributes.Add("onClick", "window.showModalDialog('Polizas.aspx?intEmpresa=" + empresa + "&strPoliza=" + poliza + "&intEjercicio=" + intEjercicio + "',null,'dialogHeight:750px; dialogWidth:1100px;status:no;help:no;scroll:no;minimize:no;maximize:no;close:no;border:thin;');  return false;");
                    lknPoliza.Attributes.Add("onClick", "var a = popUpWin('Polizas.aspx?intEmpresa=" + empresa + "&strPoliza=" + poliza + "&intEjercicio=" + intEjercicio + "','console',1100,750); return false;");

                lknPoliza.Style.Value = "color:#00008B;font-family: Tahoma;font-size: 8pt;Height:30px;font-weight:bold;text-decoration:underline;";

                lknPoliza.UpdateAfterCallBack = true;
                chkAfectar.UpdateAfterCallBack = true;                               
            }
        }
    }
    #endregion

    protected void lknRefresh_Click(object sender, EventArgs e)
    {
        BindGrid();
    }

    #region grdFacturas_Sorting
    protected void grdFacturas_Sorting(object sender, GridViewSortEventArgs e)
    {
        ctrlPagger1.SetNewSort(e.SortExpression, e.SortDirection);
        BindGrid();
    }
    #endregion

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
            default:
                break;
        }
    }
    #endregion   
  
    #region Pagger
    public int PageSize
    {
        get { return ctrlPagger1.PageSize; }
        set { ctrlPagger1.PageSize = value; }
    }

    public int PageIndex
    {
        get { return ctrlPagger1.PageIndex; }
        set { ctrlPagger1.PageIndex = value; }
    }

    public SortDirection SortDirection
    {
        get { return ctrlPagger1.SortDirection; }
        set { ctrlPagger1.SortDirection = value; }
    }

    public string SortExpression
    {
        get { return ctrlPagger1.SortExpression; }
        set { ctrlPagger1.SortExpression = value; }
    }

    public int TotalRecords
    {
        get { return ctrlPagger1.TotalRecords; }
        set { ctrlPagger1.TotalRecords = value; }
    }
    public int FromRecord
    {
        get { return ctrlPagger1.FromRecord; }
        set { ctrlPagger1.FromRecord = value; }
    }
    public int ToRecord
    {
        get { return ctrlPagger1.ToRecord; }
        set { ctrlPagger1.ToRecord = value; }
    }
    public int TotalPages
    {
        get { return ctrlPagger1.TotalPages; }
        set { ctrlPagger1.TotalPages = value; }
    }
    public void ShowButtons()
    {
        ctrlPagger1.ShowButtons();
    }
    #endregion

    #region btnDesAfecta_Click
    protected void btnDesAfecta_Click(object sender, EventArgs e)
    {
        Poliza pol;
        pol = new Poliza();
        Entity_Poliza obj;
        obj = new Entity_Poliza();
        try
        {
            obj.IntEmpresa = Convert.ToInt32(txtEmpresa.Text);
            obj.IntEjercicio = Convert.ToInt32(cboEjercicio.SelectedValue);
            obj.IntMes = Convert.ToInt32(cboMonth.SelectedValue);
            //obj.StrObraInicial = cboTipoPoliza.SelectedValue;
            //obj.StrObraFinal = cboTipoPolizaFin.SelectedValue;
            //obj.IntFolioInicial = txtFolioIni.Text == "" ? 0 : Convert.ToInt32(txtFolioIni.Text);
            //obj.intFolioFinal = txtFolioFin.Text == "" ? 0 : Convert.ToInt32(txtFolioFin.Text);
            //obj.IntAfectada = 0;
            obj.StrUsuario = Contabilidad.SEMSession.GetInstance.StrUsuario;
            obj.StrMaquina = Contabilidad.SEMSession.GetInstance.StrMaquina;


            pol.DesaAfectarTodo(obj);

            Anthem.Manager.RegisterStartupScript(Page.GetType(), "msgDesaf", "alert('Se desafecto correctamente.');", true);

            ctrlPagger1.PageIndex = 0;
            BindGrid();

        }
        catch (Exception ex)
        {
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "x5des", "alert('" + ex.Message + "');", true);
        }

        obj = null;
        pol = null;
    }
    #endregion
    
    #region btnAfectar_Click
    protected void btnAfectar_Click(object sender, EventArgs e)
    {
        Poliza pol;
        pol = new Poliza();
        Entity_Poliza obj;
        obj = new Entity_Poliza();
        string val = pol.ValAfecta();

        if (val == "0")
        {
            try
            {
                obj.IntEmpresa = Convert.ToInt32(txtEmpresa.Text);
                obj.IntEjercicio = Convert.ToInt32(cboEjercicio.SelectedValue);
                obj.IntMes = Convert.ToInt32(cboMonth.SelectedValue);
                obj.StrObraInicial = cboTipoPoliza.SelectedValue;
                obj.StrObraFinal = cboTipoPolizaFin.SelectedValue;
                obj.IntFolioInicial = txtFolioIni.Text == "" ? 0 : Convert.ToInt32(txtFolioIni.Text);
                obj.intFolioFinal = txtFolioFin.Text == "" ? 0 : Convert.ToInt32(txtFolioFin.Text);
                obj.IntAfectada = 1;
                obj.StrUsuario = Contabilidad.SEMSession.GetInstance.StrUsuario;
                obj.StrMaquina = Contabilidad.SEMSession.GetInstance.StrMaquina;

                pol.Afecta(obj);

                Anthem.Manager.RegisterStartupScript(Page.GetType(), "msgDesaf", "alert('Se afecto correctamente.');", true);

                ctrlPagger1.PageIndex = 0;
                BindGrid();

            }
            catch (Exception ex)
            {
                Anthem.Manager.RegisterStartupScript(Page.GetType(), "x5des", "alert('" + ex.Message + "');", true);
            }
        }
        else
        {
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "ErrorRun", "alert('El proceso de afectación esta en uso, intentelo mas tarde.');", true);
        }

        obj = null;
        pol = null;
    }
    #endregion

    #region chkAfectar_Checked
    protected void chkAfectar_Checked(object sender, EventArgs e)
    {
        Anthem.CheckBox chkAfectar = (Anthem.CheckBox)sender;
        
        Poliza pol;
        pol = new Poliza();
        Entity_Poliza obj;
        obj = new Entity_Poliza();
        try
        {
            GridViewRow row = (GridViewRow)chkAfectar.NamingContainer;

            obj.IntEmpresa = Convert.ToInt32(txtEmpresa.Text);
            obj.IntEjercicio = Convert.ToInt32(grdAfectacion.DataKeys[row.DataItemIndex].Values[2].ToString());
            obj.IntMes = Convert.ToInt32(grdAfectacion.DataKeys[row.DataItemIndex].Values[3].ToString());
            obj.StrObraInicial = grdAfectacion.DataKeys[row.DataItemIndex].Values[4].ToString();
            obj.StrObraFinal = grdAfectacion.DataKeys[row.DataItemIndex].Values[4].ToString();
            obj.IntFolioInicial = Convert.ToInt32(grdAfectacion.DataKeys[row.DataItemIndex].Values[1].ToString());
            obj.intFolioFinal = Convert.ToInt32(grdAfectacion.DataKeys[row.DataItemIndex].Values[1].ToString());
            obj.IntAfectada = chkAfectar.Checked == true ? 1 : 0;
            obj.StrUsuario = Contabilidad.SEMSession.GetInstance.StrUsuario;
            obj.StrMaquina = Contabilidad.SEMSession.GetInstance.StrMaquina;
                 
            pol.Afecta(obj);

            Anthem.Manager.RegisterStartupScript(Page.GetType(), "msgDesaf", "alert('Se afecto correctamente.');", true);

            ctrlPagger1.PageIndex = 0;
            BindGrid();

        }
        catch (Exception ex)
        {
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "x52", "alert('" + ex.Message + "');", true);
            chkAfectar.Checked = !chkAfectar.Checked;
        }

        obj = null;
        pol = null;

        chkAfectar.UpdateAfterCallBack = true;  
    }
    #endregion

    #region cboMonth_Change
    protected void cboMonth_Change(object sender, EventArgs e)
    {
        Close();
        Encabezado();
        BindGrid();
    }
    #endregion
   
}
