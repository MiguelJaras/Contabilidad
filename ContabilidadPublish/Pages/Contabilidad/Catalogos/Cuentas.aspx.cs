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
using System.IO;
using System.Data.OleDb;
using Contabilidad.Entity;
using Contabilidad.Bussines;
using System.Net.Mail;
using CrystalDecisions.CrystalReports.Engine;
using CrystalDecisions.Shared;
using System.Net.Mail;
using Quiksoft.FreeSMTP;

public partial class Pages_Compras_Catalogos_Cuentas : System.Web.UI.Page
{
    public string realPath;
    Pages_Base toolbar;

    protected void Page_Load(object sender, EventArgs e)
    {
        toolbar = (Pages_Base)this.Master;
        toolbar.PageEvent += new HandlerEvent(Me_Event);

        string end = (Request.ApplicationPath.EndsWith("/")) ? "" : "/";
        string path = Request.ApplicationPath + end;
        //realPath = String.Format("http://{0}{1}{2}", Request.Url.Authority, path, "Img/dxpcFooterBack.gif");
        txtCodigoAgrupador.Attributes.Add("onkeypress", "KeyPressOnlyDecimal(this, 3, 2);");

        Anthem.Manager.Register(this);
        if (!IsPostBack && !IsCallback)
        { 
            txtEmpresa.Text = Contabilidad.SEMSession.GetInstance.IntEmpresa.ToString();
            txtEmpresa_TextChange(null, null); 
        } 
        
        JavaScript();
    }

    protected void Page_PreRender(object sender, EventArgs e)
    {
        
        toolbar.Email(false);
    }

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
                Delete();
                break;
            case Event.Print:
                //Print();
                break;
            case Event.List:
                //BindGrid();
                break;
            default:
                break;
        }
    }
    #endregion

    #region JavaScript
    private void JavaScript()
    { 
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtCuenta", "var objText = new VetecText('" + txtCuenta.ClientID + "', 'text', 12);", true);
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtNombre", "var objText = new VetecText('" + txtNombre.ClientID + "', 'text', 50);", true);
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtNombreCorto", "var objText = new VetecText('" + txtNombreCorto.ClientID + "', 'text', 50);", true);         
    }
    #endregion

    #region txtRowEdit_Change
    protected void txtRowEdit_Change(object sender, EventArgs e)
    {
        if (txtRowEdit.Text != "")
        {
            int intId = Convert.ToInt32(txtRowEdit.Text);
            string strCuenta = grdDet.DataKeys[intId].Value.ToString();

            selCuenta(strCuenta);
            txtCuenta.Text = strCuenta;
            txtCuenta.UpdateAfterCallBack = true;
        }
    }  
    #endregion  

    #region llena Combos
    private void llenaCombos()
    {
        List list;
        list = new List();

        cboTipoGrupoContable.DataSource = list.TiposGruposContables(Contabilidad.SEMSession.GetInstance.IntEmpresa, Contabilidad.SEMSession.GetInstance.IntSucursal);
        cboTipoGrupoContable.DataTextField = "strNombre";
        cboTipoGrupoContable.DataValueField = "Id";
        cboTipoGrupoContable.DataBind();

        cboTipoGrupoContable.UpdateAfterCallBack = true;

        list = null;


        cboNaturaleza.Items.Insert(0, new ListItem("DEUDOR", "0"));
        cboNaturaleza.Items.Insert(1, new ListItem("ACREEDOR", "1"));

        cboNaturaleza.SelectedIndex = 0;
        cboNaturaleza.UpdateAfterCallBack = true;
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
        llenaCombos();

        Anthem.Manager.RegisterStartupScript(Page.GetType(), "focCuen", "document.all('ctl00_CPHBase_txtCuenta').focus()", true);

        obj = null;
        emp = null;
    }
    #endregion

    #region txtCuenta_Change
    protected void txtCuenta_Change(object sender, EventArgs e)
    {
        if (txtCuenta.Text != "")
        {
            selCuenta(txtCuenta.Text);
        }
    }

    public void selCuenta(string strCuenta)
    {
        try
        {
            Cuentas Obj = new Cuentas();
            Entity_Cuentas EntiCuentas = new Entity_Cuentas();

            EntiCuentas.IntEmpresa = txtEmpresa.Text == "" ? Contabilidad.SEMSession.GetInstance.IntEmpresa : Convert.ToInt32(txtEmpresa.Text);
            EntiCuentas.IntSucursal = hddSucursal.Value == "" ? Contabilidad.SEMSession.GetInstance.IntSucursal : Convert.ToInt32(hddSucursal.Value);
            EntiCuentas.StrCuenta   = strCuenta;

            Entity_Cuentas CuentaByKey = Obj.GetByPrimaryKey(EntiCuentas);

            if (CuentaByKey != null)
            {
                txtNombre.Text = CuentaByKey.StrNombre;
                txtNombreCorto.Text = CuentaByKey.StrNombreCorto;
                cboTipoGrupoContable.SelectedValue = CuentaByKey.IntTipoGrupoContable.ToString();
                cboNaturaleza.SelectedValue = CuentaByKey.IntGrupoContable.ToString();
                chkAuxiliar.Checked = CuentaByKey.IntIndAuxiliar == 1 ? true : false;
                chkRegistro.Checked = CuentaByKey.IntCtaRegistro == 1 ? true : false;
                chkActivo.Checked = CuentaByKey.IntAcceso == 1 ? true : false;
                txtCodigoAgrupador.Text = CuentaByKey.StrCodigoAgrupador;                                
            }
            else
            {
                //1113
                txtNombre.Text = "";
                txtNombreCorto.Text = "";
                txtCodigoAgrupador.Text = "";
                //cboTipoGrupoContable.SelectedIndex = 0;
                //cboNaturaleza.SelectedIndex = 0;
                //chkAuxiliar.Checked = false;
                //chkRegistro.Checked = false;
                //chkActivo.Checked = true;
            }

            txtNombre.UpdateAfterCallBack = true;
            txtNombreCorto.UpdateAfterCallBack = true;
            cboTipoGrupoContable.UpdateAfterCallBack = true;
            chkAuxiliar.UpdateAfterCallBack = true;
            cboNaturaleza.UpdateAfterCallBack = true;
            chkRegistro.UpdateAfterCallBack = true;
            chkActivo.UpdateAfterCallBack = true;
            txtCodigoAgrupador.UpdateAfterCallBack = true;

            //Anthem.Manager.RegisterStartupScript(Page.GetType(), "Alerta", "alert('No existe tipo de cuenta');", true);
            //Anthem.Manager.RegisterStartupScript(Page.GetType(), "focus", "document.all('ctl00_CPHBase_txtCuenta').focus()", true);

        }
        catch (System.IO.IOException ex) { }
    
    }


    #endregion

    #region Clear
    private void Clear()
    {
        txtCuenta.Text = "";
        txtNombreCuenta.Text = "";
        hddClaveCuenta.Value = "";
        txtNombre.Text = "";
        chkAuxiliar.Checked = false;
        chkRegistro.Checked = false;
        chkActivo.Checked = true;
        txtNombreCorto.Text = "";
        cboTipoGrupoContable.SelectedIndex = 0;
        cboNaturaleza.SelectedIndex = 0;
        txtCodigoAgrupador.Text = "";

        txtCuenta.UpdateAfterCallBack = true;
        txtNombreCuenta.UpdateAfterCallBack = true;
        hddClaveCuenta.UpdateAfterCallBack = true;
        txtNombre.UpdateAfterCallBack = true;
        chkAuxiliar.UpdateAfterCallBack = true;
        txtNombreCorto.UpdateAfterCallBack = true;
        cboTipoGrupoContable.UpdateAfterCallBack = true;
        chkRegistro.UpdateAfterCallBack = true;
        cboNaturaleza.UpdateAfterCallBack = true;
        txtCodigoAgrupador.UpdateAfterCallBack = true;
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "focus", "document.all('ctl00_CPHBase_txtCuenta').focus()", true);
    }

    #endregion

    #region BindGrid
    private void BindGrid()
    { 
        Entity_Cuentas obj = new Entity_Cuentas();
        Cuentas clsCuentas = new Cuentas();

        obj.IntEmpresa = txtEmpresa.Text == "" ? Contabilidad.SEMSession.GetInstance.IntEmpresa : Convert.ToInt32(txtEmpresa.Text);
        obj.IntSucursal = hddSucursal.Value == "" ? Contabilidad.SEMSession.GetInstance.IntSucursal : Convert.ToInt32(hddSucursal.Value);

        obj.StrCuenta = null;

        using (DataTable dt = clsCuentas.GetList(obj))
        {
            if (dt.Rows.Count > 0)
            {
                grdDet.DataSource = dt;
                grdDet.DataBind();
                goto Done;
            }

            grdDet.DataSource = null;
            grdDet.DataBind();

        Done:
            grdDet.UpdateAfterCallBack = true;
        }

        clsCuentas = null;
        obj = null;
    }
    #endregion

    #region DgrdList_RowDeleting
    protected void DgrdList_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        try
        {

            DeleteDet(grdDet.DataKeys[e.RowIndex].Value.ToString());
        }
        catch (Exception ex)
        {
            string msg = ex.Message.Replace("\r", "").Replace("\n", ""); ;
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "ErrDel3", "alert('" + msg + "');", true);
        }
    }
    #endregion DgrdList_RowDeleting

    #region DgrdList_RowCreated
    protected void DgrdList_RowCreated(object sender, GridViewRowEventArgs e)
    { 
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            e.Row.Style.Value = "background-color:#FAFAFA;color:Black;font-family: Tahoma;font-size: 8pt;Height:15px;font-weight:bold";
            e.Row.Attributes.Add("onmouseover", "Over(this);");
            e.Row.Attributes.Add("onmouseout", "Out(this);");


            DataRowView dataRowView = (DataRowView)e.Row.DataItem;
            if (dataRowView != null)
            {
                //Cuando sea por celda
                for (int i = 0; i < e.Row.Cells.Count - 2; i++)
                {
                    e.Row.Cells[i].Attributes.Add("onclick", "EditRow(" + e.Row.RowIndex + ")");
                }

                e.Row.Cells[0].Style.Value = "text-align:center";
                e.Row.Cells[1].Style.Value = "text-align:center";
                e.Row.Cells[2].Style.Value = "text-align:center";
                e.Row.Cells[3].Style.Value = "text-align:center";
                e.Row.Cells[4].Style.Value = "text-align:center";
                e.Row.Cells[5].Style.Value = "text-align:center";
                e.Row.Cells[6].Style.Value = "text-align:center";
                e.Row.Cells[7].Style.Value = "text-align:center";
                e.Row.Cells[8].Style.Value = "text-align:center";

            }
        }

    }
    #endregion

    #region SelectedIndexChanged
    protected void grdDet_SelectedIndexChanged(object sender, EventArgs e)
    {

        GridViewRow row = grdDet.SelectedRow;
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "ErrDel3", "alert('" + row.Cells[0].Text + "');", true);
    }
    #endregion

    #region Save
    void Save()
    {
        try
        {  
            if (validaCuenta(txtCuenta.Text.Trim()))
                return;

            Entity_Cuentas obj = new Entity_Cuentas();
            Cuentas clsCuentas = new Cuentas();

            obj.IntEmpresa = txtEmpresa.Text == "" ? Contabilidad.SEMSession.GetInstance.IntEmpresa : Convert.ToInt32(txtEmpresa.Text);
            obj.IntSucursal = hddSucursal.Value == "" ? Contabilidad.SEMSession.GetInstance.IntSucursal : Convert.ToInt32(hddSucursal.Value);

            obj.StrCuenta = txtCuenta.Text;
            obj.StrNombre = txtNombre.Text;
            obj.StrNombreCorto = txtNombreCorto.Text;
            obj.StrUsuario = Contabilidad.SEMSession.GetInstance.StrUsuario;
            obj.StrMaquina = Contabilidad.SEMSession.GetInstance.StrMaquina;
            obj.IntTipoGrupoContable = Convert.ToInt32(cboTipoGrupoContable.SelectedValue);
            obj.IntGrupoContable = Convert.ToInt32(cboNaturaleza.SelectedValue);
            obj.IntCtaRegistro = chkRegistro.Checked ? 1 : 0;
            obj.IntIndAuxiliar = chkAuxiliar.Checked ? 1 : 0;
            obj.IntAcceso = chkActivo.Checked ? 1 : 0;
            obj.StrAuditAlta = Contabilidad.SEMSession.GetInstance.StrUsuario + " " + Contabilidad.SEMSession.GetInstance.Nombre;
            obj.StrCodigoAgrupador = txtCodigoAgrupador.Text;

            string strE = "";
            strE = clsCuentas.ExisteCuenta(obj);

            string strClave = clsCuentas.Save(obj); 
            if (strE == "0")
                Send(txtCuenta.Text);
            
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "Alerta", "alert('La información se guardo correctamente.');", true);
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "focus", "document.all('ctl00_CPHBase_txtCuenta').focus()", true);
                
            Clear();
        }
        catch (Exception ex)
        {
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "mssErrr", "alert('" + ex.Message + "');", true);
        }
    }
    #endregion

    #region validaCuenta
    public bool validaCuenta(string strCuenta)
    {
        bool ret = false;
        string sPattern4 = "^\\d{4}$";
        string sPattern8 = "^\\d{4}\\d{4}$";
        string sPattern12 = "^\\d{4}\\d{4}\\d{4}$";
        int intCuentaLen = strCuenta.Length;

        if (intCuentaLen <= 4)
        {
            if (!System.Text.RegularExpressions.Regex.IsMatch(strCuenta, sPattern4))
             ret = true; 
        }
        else
            if (intCuentaLen <= 8)
            {
                if (!System.Text.RegularExpressions.Regex.IsMatch(strCuenta, sPattern8))
                    ret = true;
            }
            else
            {
                if (!System.Text.RegularExpressions.Regex.IsMatch(strCuenta, sPattern12))
                    ret = true; 
            }

        if(ret)
        {
         Anthem.Manager.RegisterStartupScript(Page.GetType(), "ErrDel3", "alert('Numero de cuenta incorrecta. solo 4,8 y 12 digitos NNNN, NNNNNNNN ó NNNNNNNNNNNN');", true);
         Anthem.Manager.RegisterStartupScript(Page.GetType(), "msgFoc212", "document.getElementById('" + txtCuenta.ClientID + "').focus();", true);
        }

        return ret;
    }
    #endregion

    #region Delete
    void Delete()
    {
        try
        {
            Cuentas clsCuentas = new Cuentas();
            Entity_Cuentas obj = new Entity_Cuentas();

            obj.IntEmpresa = txtEmpresa.Text == "" ? Contabilidad.SEMSession.GetInstance.IntEmpresa : Convert.ToInt32(txtEmpresa.Text);
            obj.IntSucursal = hddSucursal.Value == "" ? Contabilidad.SEMSession.GetInstance.IntSucursal : Convert.ToInt32(hddSucursal.Value);
            obj.StrCuenta = txtCuenta.Text;

            clsCuentas.Delete(obj);
            
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "ErrDel2", "alert('Se elimino correctamente.');", true);
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "msgFoc212", "document.getElementById('" + this.txtCuenta.ClientID + "').focus();", true);

            Clear();

            clsCuentas = null;
            obj = null;
        }
        catch (Exception ex)
        {
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "msfPolErr", "alert('" + ex.Message + "');", true);
        }
    }

    void DeleteDet(string pstrCuenta)
    {
        try
        {
            Cuentas clsCuentas = new Cuentas();
            Entity_Cuentas obj = new Entity_Cuentas();

            obj.IntEmpresa = txtEmpresa.Text == "" ? Contabilidad.SEMSession.GetInstance.IntEmpresa : Convert.ToInt32(txtEmpresa.Text);
            obj.IntSucursal = hddSucursal.Value == "" ? Contabilidad.SEMSession.GetInstance.IntSucursal : Convert.ToInt32(hddSucursal.Value);

            obj.StrCuenta = pstrCuenta;


            clsCuentas.Delete(obj);
            //BindGrid();

            Anthem.Manager.RegisterStartupScript(Page.GetType(), "ErrDel2", "alert('Se elimino correctamente.');", true);
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "msgFoc212", "document.getElementById('" + txtCuenta.ClientID + "').focus();", true);


            clsCuentas = null;
            obj = null;
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
        string[] arrDatos;
        String strParameters = "";


        int intEmpresa = txtEmpresa.Text == "" ? Contabilidad.SEMSession.GetInstance.IntEmpresa : Convert.ToInt32(txtEmpresa.Text);
        int intSucursal = hddSucursal.Value == "" ? Contabilidad.SEMSession.GetInstance.IntSucursal : Convert.ToInt32(hddSucursal.Value);

        arrDatos = new string[2];
        arrDatos[0] = intEmpresa.ToString();
        arrDatos[1] = txtCuenta.Text;

        //strParameters = String.Format("{0}[--]{1}", arrDatos);//[--]{2}[--]{3}

        //string strServerName = "http://" + HttpContext.Current.Request.ServerVariables["SERVER_NAME"].ToString() + ":" + HttpContext.Current.Request.ServerVariables["SERVER_PORT"].ToString() + "/Contabilidad/Utils/Export.aspx";
        ////string strServerName = "http://" + HttpContext.Current.Request.ServerVariables["SERVER_NAME"].ToString() + ":" + HttpContext.Current.Request.ServerVariables["SERVER_PORT"].ToString() + "/Contabilidad/Utils/VisorReporte.aspx";
        //string strQueryString = string.Empty;
        //strQueryString = "?type=pdf";
        //strQueryString += "&report=Pages/Inventarios/Reportes/InventarioFisico_Local.rpt";
        //strQueryString += "&db=VetecMarfil";
        //strQueryString += "&parameters=" + strParameters;
        //strQueryString += "&Titulos=InventarioFisico";

        //strQueryString = strQueryString.Replace("'", "|");
        //Anthem.Manager.RegisterStartupScript(Page.GetType(), "rpt", "window.open('" + strServerName + strQueryString + "');", true);
    }
    #endregion

    #region Send
    private void Send(string strCuenta)
    {
        EmailMessage msgObj = new EmailMessage();

        //Specify from address and display name
        msgObj.From.Email = "sistemas01@marfil.com";
        msgObj.From.Name = "Marfil Sistemas";

        //Add a normal recipient
        msgObj.Recipients.Add("rmora@marfil.com", "rmora@marfil.com", RecipientType.To);
        msgObj.Recipients.Add("rchavez@marfil.com", "rchavez@marfil.com", RecipientType.To);
        msgObj.Recipients.Add("svalerio@marfil.com", "svalerio@marfil.com", RecipientType.To);

        msgObj.Subject = "Aviso Alta Cuenta";

        string bodyBegin;
        string bodyEnd;
        string body;
        string html = "";
        bodyBegin = "<html><body><table width='95%'><tr><td><font size='4' color='black' style='font-weight:bold'></font></td></tr>";
        bodyEnd = "</table></body></html>";
        html = html + "<tr><td> <font size='2' color='black' style='font-family:Arial'>Buen Dia </font><font size='2' color='black' style='font-family:Arial'> </font><br/><br/></td></tr>";
        html = html + "<tr><td> <font size='2' color='black' style='font-family:Arial'>El usuario <b>" + Contabilidad.SEMSession.GetInstance.Nombre + "</b> dio de alta la cuenta <b>" + strCuenta + " de la empresa "+ txtNombreEmpresa.Text +"</b>. </font><font size='2' color='black' style='font-family:Arial'> </font><br/><br/></td></tr>";
        html = html + "<tr><td> <font size='2' color='black' style='font-family:Arial'>        </font><font size='2' color='black' style='font-family:Arial'> </font></td></tr>";

        body = bodyBegin + html + bodyEnd;

        msgObj.BodyParts.Add(body, BodyPartFormat.HTML);

        //Add a text body part to server as alternative text for non HTML mail readers
        //msgObj.BodyParts.Add("Message body.", BodyPartFormat.HTML);

        //Create the SMTP object using the constructor to specify the mail server
        SMTP smtpObj = new SMTP("192.168.80.254");

        //Send the message
        try
        {
            smtpObj.Send(msgObj);
        }
        catch (Exception e)
        {
            string a = e.Message;
        }

       
    }
    #endregion
}
