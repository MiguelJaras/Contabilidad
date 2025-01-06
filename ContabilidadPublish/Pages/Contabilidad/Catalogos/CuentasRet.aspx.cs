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

public partial class Pages_Inventarios_Opciones_CuentasRet : System.Web.UI.Page
{
    public string realPath;
    Pages_Base toolbar;
    public StringBuilder dataList;
    public StringBuilder dataColumns;
    public StringBuilder colModel;
    public StringBuilder dataColony;

    protected void Page_Load(object sender, EventArgs e)
    {

        //ctrlPagger1.ChangingPageIndex += new ControlctrlPagger.HandlerChangingPageIndex(ChangingPageIndex);
        //ctrlPagger1.ChangingRowCount += new ControlctrlPagger.HandlerChangingRowCount(ChangingRowCount);

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
            
            txtEmpresa.Text = Contabilidad.SEMSession.GetInstance.IntEmpresa.ToString();
            txtEmpresa_TextChange(null, null);
            hddSucursal.Value = Contabilidad.SEMSession.GetInstance.IntSucursal.ToString ();
            hddSucursal.UpdateAfterCallBack = true;
        }
        JavaScript();
        
    }

    protected void Page_PreRender(object sender, EventArgs e)
    {
        toolbar.ListPostBACK(true);
        toolbar.List(false);
        toolbar.Print(false);
        toolbar.New(true);
        toolbar.Exportar(false);
        toolbar.Email(false);
        toolbar.Delete(false);
    }

    //void ChangingPageIndex(object o, ControlctrlPagger.ArgsChangingPageIndex e)
    //{
    //    ctrlPagger1.PageIndex = e.NewPageIndex;
    //    BindGrid();

    //}

    //void ChangingRowCount(object o, ControlctrlPagger.ArgsChangingRowCount e)
    //{
    //    ctrlPagger1.PageIndex = 0;
    //    BindGrid();

    //}

    #region JavaScript
    private void JavaScript()
    {
        
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtEmpresa",   "var objText = new VetecText('" + txtEmpresa.ClientID + "',    'number', 6);", true);
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtArea",      "var objText = new VetecText('" + txtArea.ClientID + "',       'number', 6);", true);
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtInsumoIni", "var objText = new VetecText('" + txtInsumoIni.ClientID + "',  'number', 12);", true);
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtCtaCargo", "var objText = new VetecText('" + txtCtaCargo.ClientID + "',   'text', 100);", true);
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtInsumoFin", "var objText = new VetecText('" + txtInsumoFin.ClientID + "',  'number', 12);", true);
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtCtaAbono",  "var objText = new VetecText('" + txtCtaAbono.ClientID + "',   'text', 100);", true);
        

        if (!IsPostBack && !IsCallback)
        {
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "msgFoc212", "document.getElementById('" + this.txtArea.ClientID + "').focus();", true);
        }
    }
    #endregion 

    #region txtRowEdit_Change
    protected void txtRowEdit_Change(object sender, EventArgs e)
    {
        try
        {
            CuentasRet Obj = new CuentasRet();
            Entity_CuentasRet EntiCuentasRet = new Entity_CuentasRet();

            EntiCuentasRet.IntEmpresa = txtEmpresa.Text == "" ? Contabilidad.SEMSession.GetInstance.IntEmpresa : Convert.ToInt32(txtEmpresa.Text);
            EntiCuentasRet.IntSucursal = hddSucursal.Value == "" ? Contabilidad.SEMSession.GetInstance.IntSucursal : Convert.ToInt32(hddSucursal.Value);

            int intId = Convert.ToInt32(txtRowEdit.Text);
            EntiCuentasRet.IntArea = hddIntArea.Value =="" ? 0 : Convert.ToInt32(hddIntArea.Value);
            EntiCuentasRet.StrInsumoInicial = hddStrInsumoInicial .Value;
            EntiCuentasRet.StrInsumoFinal = hddStrInsumoFinal .Value;
            EntiCuentasRet.StrCuentaCargo = hddStrCuentaCargo.Value;
            EntiCuentasRet.StrCuentaAbono = hddStrCuentaAbono.Value;

            Entity_CuentasRet CuentaByKey = Obj.GetByPrimaryKey(EntiCuentasRet);

            if (CuentaByKey != null)
            {
                txtArea.Text = CuentaByKey.IntArea.ToString();
                txtNombreArea.Text = CuentaByKey.StrNombreArea;
                rbTipo.SelectedValue = CuentaByKey.IntES.ToString ();
                //rdlEntrada.Checked = CuentaByKey.IntES == 1 ? true : false;
                //rdlSalida.Checked = CuentaByKey.IntES == 1 ? false : true;
                txtInsumoIni.Text = CuentaByKey.StrInsumoInicial;
                txtNombreInsumoIni.Text = CuentaByKey.StrNombreArticuloIn;
                txtInsumoFin.Text = CuentaByKey.StrInsumoFinal;
                txtNombreInsumoFin.Text = CuentaByKey.StrNombreArticuloFin;
                txtCtaCargo.Text = CuentaByKey.StrCuentaCargo;
                txtNombreCtaCargo.Text = CuentaByKey.StrNombreCuentaCargo;
                txtCtaAbono.Text = CuentaByKey.StrCuentaAbono;
                txtNombreCtaAbono.Text = CuentaByKey.StrNombreCuentaAbono;
            }
            else
            {
                txtArea.Text = "";
                txtNombreArea.Text = "";
                rbTipo.SelectedValue = "1";
                //rdlEntrada.Checked = true;
                //rdlSalida.Checked = false;
                txtInsumoIni.Text = "";
                txtNombreInsumoIni.Text = "";
                txtInsumoFin.Text = "";
                txtNombreInsumoFin.Text = "";
                txtCtaCargo.Text = "";
                txtNombreCtaCargo.Text = "";
                txtCtaAbono.Text = "";
                txtNombreCtaAbono.Text = "";
                Anthem.Manager.RegisterStartupScript(Page.GetType(), "Alerta", "alert('No existe dato de Contabilización Insumo');", true);
            }

            txtArea.UpdateAfterCallBack = true;
            txtNombreArea.UpdateAfterCallBack = true;
            rbTipo.UpdateAfterCallBack = true;
            //rdlEntrada.UpdateAfterCallBack = true;
            //rdlSalida.UpdateAfterCallBack = true;
            txtInsumoIni.UpdateAfterCallBack = true;
            txtNombreInsumoIni.UpdateAfterCallBack = true;
            txtInsumoFin.UpdateAfterCallBack = true;
            txtNombreInsumoFin.UpdateAfterCallBack = true;
            txtCtaCargo.UpdateAfterCallBack = true;
            txtNombreCtaCargo.UpdateAfterCallBack = true;
            txtCtaAbono.UpdateAfterCallBack = true;
            txtNombreCtaAbono.UpdateAfterCallBack = true;

            //   Anthem.Manager.RegisterStartupScript(Page.GetType(), "focus", "document.all('ctl00_ContentPlaceHolder1_txtCuentaRet').focus()", true);

        }
        catch (System.IO.IOException ex) { } 
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
        hddSucursal.Value = emp.GetSucursal(obj.IntSucursal.ToString());

        hddSucursal.UpdateAfterCallBack = true;
        txtEmpresa.UpdateAfterCallBack = true;
        txtNombreEmpresa.UpdateAfterCallBack = true;

        Clear();
        List();
        //llenaCombos();

        obj = null;
        emp = null;
    }
    #endregion

    #region txtInsumoIni_TextChange
    protected void txtInsumoIni_TextChange(object sender, EventArgs e)
    {
        Entity_Articulo obj;
        obj = new Entity_Articulo();
        Articulo ins;
        ins = new Articulo();

        obj.IntEmpresa = txtEmpresa.Text == "" ? Contabilidad.SEMSession.GetInstance.IntEmpresa : Convert.ToInt32(txtEmpresa.Text);
        obj.IntSucursal = hddSucursal.Value == "" ? Contabilidad.SEMSession.GetInstance.IntSucursal : Convert.ToInt32(hddSucursal.Value);
        obj.StrNombreCorto = txtInsumoIni.Text;
        obj = ins.Sel(obj);

        if (!(obj == null))
        {
            if (txtInsumoIni.Text != "")
            {
                if (obj.StrNombre != null)
                {
                    txtNombreInsumoIni.Text = obj.StrNombre;
                    hddInsIni.Value = obj.IntArticulo.ToString();
                    //txtInsumoFin.Text = txtInsumoIni.Text;
                    //txtNombreInsumoFin.Text = txtNombreInsumoIni.Text;
                    //hddInsFin.Value = obj.IntArticulo.ToString();
                    Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtNombreFocus", "document.getElementById('" + txtInsumoFin.ClientID + "').focus();", true);
                }
                //else
                //{
                //    txtInsumoIni.Text = "";
                //    txtNombreInsumoIni.Text = "";
                //    hddInsIni.Value = "";
                //    Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtNombreFocus", "document.getElementById('" + txtInsumoIni.ClientID + "').focus();", true);
                //}
            }
            //else
            //{
            //    txtInsumoIni.Text = "";
            //    txtNombreInsumoIni.Text = "";
            //    hddInsIni.Value = "";
            //    Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtNombreFocus", "document.getElementById('" + txtInsumoIni.ClientID + "').focus();", true);

            //}
        }
        //else
        //{
        //    txtInsumoIni.Text = "";
        //    txtNombreInsumoIni.Text = "";
        //    hddInsIni.Value = "";
        //    Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtNombreFocus", "document.getElementById('" + txtInsumoIni.ClientID + "').focus();", true);
        //}

        txtInsumoIni.UpdateAfterCallBack = true;
        txtNombreInsumoIni.UpdateAfterCallBack = true;
        hddInsIni.UpdateAfterCallBack = true;

        obj = null;
        ins = null;
    }
    #endregion

    #region txtInsumoFin_TextChange
    protected void txtInsumoFin_TextChange(object sender, EventArgs e)
    {
        Entity_Articulo obj;
        obj = new Entity_Articulo();
        Articulo ins;
        ins = new Articulo();

        obj.IntEmpresa = txtEmpresa.Text == "" ? Contabilidad.SEMSession.GetInstance.IntEmpresa : Convert.ToInt32(txtEmpresa.Text);
        obj.IntSucursal = hddSucursal.Value == "" ? Contabilidad.SEMSession.GetInstance.IntSucursal : Convert.ToInt32(hddSucursal.Value);
        obj.StrNombreCorto = txtInsumoFin.Text;
        obj = ins.Sel(obj);

        if (!(obj == null))
        {
            if (txtInsumoFin.Text != "")
            {
                if (obj.StrNombre != null)
                {
                    txtNombreInsumoFin.Text = obj.StrNombre.ToString();
                    hddInsFin.Value = obj.IntArticulo.ToString();
                    Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtCtaCargoFocus", "document.getElementById('" + txtCtaCargo.ClientID + "').focus();", true);
                }
                //else
                //{
                //    txtInsumoFin.Text = "";
                //    txtNombreInsumoFin.Text = "";
                //    hddInsFin.Value = "";
                //    Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtInsumoFinFocus", "document.getElementById('" + txtInsumoFin.ClientID + "').focus();", true);
                //}
            }
            //else
            //{
            //    txtInsumoFin.Text = "";
            //    txtNombreInsumoFin.Text = "";
            //    hddInsFin.Value = "";
            //    Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtInsumoFinFocus", "document.getElementById('" + txtInsumoFin.ClientID + "').focus();", true);
            //}
        }
        //else
        //{
        //    txtInsumoFin.Text = "";
        //    txtNombreInsumoFin.Text = "";
        //    hddInsFin.Value = "";
        //    Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtInsumoFinFocus", "document.getElementById('" + txtInsumoFin.ClientID + "').focus();", true);
        //}

        txtInsumoFin.UpdateAfterCallBack = true;
        txtNombreInsumoFin.UpdateAfterCallBack = true;
        hddInsFin.UpdateAfterCallBack = true;

        obj = null;
        ins = null;

    }
    #endregion

    #region txtCtaCargo_TextChange
    protected void txtCtaCargo_TextChange(object sender, EventArgs e)
    {
        Entity_Cuentas obj;
        obj = new Entity_Cuentas();
        Cuentas cta;
        cta = new Cuentas();

        obj.IntEmpresa = txtEmpresa.Text == "" ? Contabilidad.SEMSession.GetInstance.IntEmpresa : Convert.ToInt32(txtEmpresa.Text);
        obj.IntSucursal = hddSucursal.Value == "" ? Contabilidad.SEMSession.GetInstance.IntSucursal : Convert.ToInt32(hddSucursal.Value);
        obj.StrCuenta = txtCtaCargo.Text.Replace ("-","");
        obj = cta.GetByPrimaryKey(obj);

        if (!(obj == null))
        {
            if (txtCtaCargo.Text != "")
            {
                if (obj.StrNombre != null)
                {
                    txtNombreCtaCargo.Text = obj.StrNombre.ToString();
                    Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtCtaAbonofocus", "document.getElementById('" + txtCtaAbono.ClientID + "').focus();", true);
                }
                else
                {
                    txtCtaCargo.Text = "";
                    txtNombreCtaCargo.Text = "";
                    Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtCtaCargofocus", "document.getElementById('" + txtCtaCargo.ClientID + "').focus();", true);
                }
            }
            else
            {
                txtCtaCargo.Text = "";
                txtNombreCtaCargo.Text = "";
                Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtCtaCargofocus", "document.getElementById('" + txtCtaCargo.ClientID + "').focus();", true);
            }
        }
        else
        {
            txtCtaCargo.Text = "";
            txtNombreCtaCargo.Text = "";
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtCtaCargofocus", "document.getElementById('" + txtCtaCargo.ClientID + "').focus();", true);
        }

        txtCtaCargo.UpdateAfterCallBack = true;
        txtNombreCtaCargo.UpdateAfterCallBack = true;

        obj = null;
        cta = null;
    }
    #endregion

    #region txtCtaAbono_TextChange
    protected void txtCtaAbono_TextChange(object sender, EventArgs e)
    {
        Entity_Cuentas obj;
        obj = new Entity_Cuentas();
        Cuentas cta;
        cta = new Cuentas();

        obj.IntEmpresa = txtEmpresa.Text == "" ? Contabilidad.SEMSession.GetInstance.IntEmpresa : Convert.ToInt32(txtEmpresa.Text);
        obj.IntSucursal = hddSucursal.Value == "" ? Contabilidad.SEMSession.GetInstance.IntSucursal : Convert.ToInt32(hddSucursal.Value);
        obj.StrCuenta = txtCtaAbono.Text.Replace("-", "");
        obj = cta.GetByPrimaryKey(obj);

        if (!(obj == null))
        {
            if (txtCtaAbono.Text != "")
            {
                if (obj.StrNombre != null)
                {
                    txtNombreCtaAbono.Text = obj.StrNombre.ToString();
                }
                else
                {
                    txtCtaAbono.Text = "";
                    txtNombreCtaAbono.Text = "";
                    Anthem.Manager.RegisterStartupScript(Page.GetType(), "txttxtCtaAbonofocus", "document.getElementById('" + txtCtaAbono.ClientID + "').focus();", true);
                }
            }
            else
            {
                txtCtaAbono.Text = "";
                txtNombreCtaAbono.Text = "";
                Anthem.Manager.RegisterStartupScript(Page.GetType(), "txttxtCtaAbonofocus", "document.getElementById('" + txtCtaAbono.ClientID + "').focus();", true);
            }
        }
        else
        {
            txtCtaAbono.Text = "";
            txtNombreCtaAbono.Text = "";
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "txttxtCtaAbonofocus", "document.getElementById('" + txtCtaAbono.ClientID + "').focus();", true);
        }

        txtCtaAbono.UpdateAfterCallBack = true;
        txtNombreCtaAbono.UpdateAfterCallBack = true;

        obj = null;
        cta = null;
    }
    #endregion

    #region txtArea_TextChange
    protected void txtArea_TextChange(object sender, EventArgs e)
    {
        Entity_Area obj;
        obj = new Entity_Area();
        Area area;
        area = new Area();

        obj.intArea = txtArea.Text == "" ? 0 : Convert.ToInt32(txtArea.Text);
        obj.IntSucursal = hddSucursal.Value == "" ? 0 : Convert.ToInt32(hddSucursal.Value); 
        obj.intEmpresa = txtEmpresa.Text == "" ? 0 : Convert.ToInt32(txtEmpresa.Text);
        obj = area.Fill(obj);

        if (!(obj == null))
        {
            if (txtArea.Text != "")
            {
                if (obj.strNombre != null)
                {
                    txtNombreArea.Text = obj.strNombre.ToString();
                    List();
                    //Clear2();
                    //BindGrid();
                }
                else
                {
                    txtArea.Text = "";
                    txtNombreArea.Text = "";
                    Clear();
                }
            }
            else
            {
                txtArea.Text = "";
                txtNombreArea.Text = "";
                Clear();
            }
        }
        else
        {
            txtArea.Text = "";
            txtNombreArea.Text = "";
            Clear();
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtAreaFocus", "document.getElementById('" + txtArea.ClientID + "').focus();", true);
        }
        txtArea.UpdateAfterCallBack = true;
        txtNombreArea.UpdateAfterCallBack = true;

        area = null;
        obj = null;
    }
    #endregion 

    #region btnBuscar_Click
    protected void btnBuscar_Click(object sender, EventArgs e)
    {
        List();
        //BindGrid();
    }
    #endregion

    #region Clear
    void Clear()
    {
        txtRowEdit.Text = "";

        txtArea.Text = "";
        txtNombreArea.Text = "";
        rbTipo.SelectedValue = "1";
        //rdlEntrada.Checked = true;
        //rdlSalida.Checked = false;
        txtInsumoIni.Text = "";
        txtNombreInsumoIni.Text = "";
        txtInsumoFin.Text = "";
        txtNombreInsumoFin.Text = "";
        txtCtaCargo.Text = "";
        txtNombreCtaCargo.Text = "";
        txtCtaAbono.Text = "";
        txtNombreCtaAbono.Text = "";
        //grdCuentasRet.DataSource = null;
        //grdCuentasRet.DataBind();
        
        txtArea.UpdateAfterCallBack = true;
        txtNombreArea.UpdateAfterCallBack = true;
        rbTipo.UpdateAfterCallBack = true;
        //rdlEntrada.UpdateAfterCallBack = true;
        //rdlSalida.UpdateAfterCallBack = true;
        txtInsumoIni.UpdateAfterCallBack = true;
        txtNombreInsumoIni.UpdateAfterCallBack = true;
        txtInsumoFin.UpdateAfterCallBack = true;
        txtNombreInsumoFin.UpdateAfterCallBack = true;
        txtCtaCargo.UpdateAfterCallBack = true;
        txtNombreCtaCargo.UpdateAfterCallBack = true;
        txtCtaAbono.UpdateAfterCallBack = true;
        txtNombreCtaAbono.UpdateAfterCallBack = true;
        txtRowEdit.UpdateAfterCallBack = true;
        //grdCuentasRet.UpdateAfterCallBack = true;

        Anthem.Manager.RegisterStartupScript(Page.GetType(), "msgFoc212", "document.getElementById('" + this.txtArea.ClientID + "').focus();", true);
    }
    #endregion

    #region Clear2
    void Clear2()
    {
        txtRowEdit.Text = "";

        txtInsumoIni.Text = "";
        txtNombreInsumoIni.Text = "";
        txtInsumoFin.Text = "";
        txtNombreInsumoFin.Text = "";
        txtCtaCargo.Text = "";
        txtNombreCtaCargo.Text = "";
        txtCtaAbono.Text = "";
        txtNombreCtaAbono.Text = "";


        txtInsumoIni.UpdateAfterCallBack = true;
        txtNombreInsumoIni.UpdateAfterCallBack = true;
        txtInsumoFin.UpdateAfterCallBack = true;
        txtNombreInsumoFin.UpdateAfterCallBack = true;
        txtCtaCargo.UpdateAfterCallBack = true;
        txtNombreCtaCargo.UpdateAfterCallBack = true;
        txtCtaAbono.UpdateAfterCallBack = true;
        txtNombreCtaAbono.UpdateAfterCallBack = true;
        txtRowEdit.UpdateAfterCallBack = true;
        //grdCuentasRet.UpdateAfterCallBack = true;

        Anthem.Manager.RegisterStartupScript(Page.GetType(), "msgFoc212", "document.getElementById('" + this.txtArea.ClientID + "').focus();", true);
    }
    #endregion


    #region Save
    void Save()
    {
        try
        {
            Entity_CuentasRet entCuentasRet = new Entity_CuentasRet();
            CuentasRet obj = new CuentasRet();

            entCuentasRet.IntEmpresa   = txtEmpresa.Text == "" ? Contabilidad.SEMSession.GetInstance.IntEmpresa : Convert.ToInt32(txtEmpresa.Text);
            entCuentasRet.IntSucursal  = hddSucursal.Value == "" ? Contabilidad.SEMSession.GetInstance.IntSucursal : Convert.ToInt32(hddSucursal.Value);
            entCuentasRet.IntArea = txtArea.Text == "" ? 0 : Convert.ToInt32(txtArea.Text);
            entCuentasRet.IntES = rbTipo .SelectedValue =="-1" ? 0 : Convert.ToInt32 ( rbTipo .SelectedValue);
            entCuentasRet.StrInsumoInicial = txtInsumoIni.Text;
            entCuentasRet.StrInsumoFinal = txtInsumoFin.Text;
            entCuentasRet.StrCuentaCargo = txtCtaCargo.Text;
            entCuentasRet.StrCuentaAbono = txtCtaAbono.Text;

            entCuentasRet.StrUsuario = Contabilidad.SEMSession.GetInstance.StrUsuario;
            entCuentasRet.StrMaquina = Contabilidad.SEMSession.GetInstance.StrMaquina;

            string strClave = obj.Save(entCuentasRet);

            //Clear();
            //Anthem.Manager.RegisterStartupScript(Page.GetType(), "Alerta", "alert('CuentasRet guardado con éxito');", true);
            if (strClave != "")
            {
                Anthem.Manager.RegisterStartupScript(Page.GetType(), "Alerta", "alert('CuentasRet guardado con éxito.');", true);
                Clear2();
                List();
            }
            else
            {
                Anthem.Manager.RegisterStartupScript(Page.GetType(), "ErrSave", "alert('No se puede guardar CuentasRet.');", true);
            }

        }
        catch (Exception ex)
        {
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "err", "alert('" + ex.Message + "');", true);
        }
    }

    #endregion

    #region Delete
    void Delete()
    {
        try
        {
            Entity_CuentasRet entCuentasRet = new Entity_CuentasRet();
            CuentasRet obj = new CuentasRet();

            entCuentasRet.IntEmpresa = txtEmpresa.Text == "" ? Contabilidad.SEMSession.GetInstance.IntEmpresa : Convert.ToInt32(txtEmpresa.Text);
            entCuentasRet.IntSucursal = hddSucursal.Value == "" ? Contabilidad.SEMSession.GetInstance.IntSucursal : Convert.ToInt32(hddSucursal.Value);

            entCuentasRet.IntArea= txtArea .Text =="" ? 0 : Convert .ToInt32(txtArea.Text);
            entCuentasRet.StrInsumoInicial =  txtInsumoIni .Text ;
            entCuentasRet.StrInsumoFinal= txtInsumoFin .Text;
            entCuentasRet.StrCuentaCargo= txtCtaCargo .Text;
            entCuentasRet.StrCuentaAbono = txtCtaAbono .Text;

            obj.Delete(entCuentasRet);

            Clear();

            Anthem.Manager.RegisterStartupScript(Page.GetType(), "errDel", "alert('Se elimino correctamente.');", true);
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "msgFoc212", "document.getElementById('" + this.txtArea.ClientID + "').focus();", true);


            entCuentasRet = null;
            obj = null;
        }
        catch (Exception ex)
        {
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "errexDel", "alert('" + ex.Message + "');", true);
        }
    }

    #endregion

    #region Print
    void Print()
    {
        return;

        string[] arrDatos;
        String strParameters = "";


        int intEmpresa = txtEmpresa.Text == "" ? Contabilidad.SEMSession.GetInstance.IntEmpresa : Convert.ToInt32(txtEmpresa.Text);
        int intSucursal = hddSucursal.Value == "" ? Contabilidad.SEMSession.GetInstance.IntSucursal : Convert.ToInt32(hddSucursal.Value);

        arrDatos = new string[2];
        arrDatos[0] = intEmpresa.ToString();
        //arrDatos[1] = txtCuentasRet.Text;

        strParameters = String.Format("{0}[--]{1}", arrDatos);//[--]{2}[--]{3}

        string strServerName = "http://" + HttpContext.Current.Request.ServerVariables["SERVER_NAME"].ToString() + ":" + HttpContext.Current.Request.ServerVariables["SERVER_PORT"].ToString() + "/Contabilidad/Utils/Export.aspx";
        //string strServerName = "http://" + HttpContext.Current.Request.ServerVariables["SERVER_NAME"].ToString() + ":" + HttpContext.Current.Request.ServerVariables["SERVER_PORT"].ToString() + "/Contabilidad/Utils/VisorReporte.aspx";
        string strQueryString = string.Empty;
        strQueryString = "?type=pdf";
        strQueryString += "&report=Pages/Inventarios/Reportes/InventarioFisico_Local.rpt";
        strQueryString += "&db=VetecMarfil";
        strQueryString += "&parameters=" + strParameters;
        strQueryString += "&Titulos=InventarioFisico";

        strQueryString = strQueryString.Replace("'", "|");
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "rpt", "window.open('" + strServerName + strQueryString + "');", true);
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
                Delete();
                break;
            case Event.Print:
                //Print();
                break;
            case Event.List:
                List();
                //BindGrid();
                break;
            default:
                break;
        }
    }
    #endregion 

    #region BindGrid
    private void BindGrid()
    {
        //Entity_CuentasRet obj = new Entity_CuentasRet();
        //CuentasRet clsCuentas = new CuentasRet();

        //obj.iNumRecords = this.PageSize;
        //obj.iNumPage = this.PageIndex;

        //obj.IntEmpresa = txtEmpresa.Text == "" ? Contabilidad.SEMSession.GetInstance.IntEmpresa : Convert.ToInt32(txtEmpresa.Text);
        //obj.IntSucursal = hddSucursal.Value == "" ? Contabilidad.SEMSession.GetInstance.IntSucursal : Convert.ToInt32(hddSucursal.Value);
        ////obj.IntCuentaRet = txtCuentasRet.Text != "" ? Convert.ToInt32(txtCuentasRet.Text) : 0;
        //obj.IntArea = txtArea.Text != "" ? Convert.ToInt32(txtArea.Text) : 0;
        //obj.StrInsumoInicial = txtInsumoIni.Text == "" ? null : txtInsumoIni.Text;
        //obj.StrInsumoFinal   = txtInsumoFin.Text == "" ? null : txtInsumoFin.Text;
        //obj.StrCuentaCargo   = txtCtaCargo.Text  == "" ? null : txtCtaCargo.Text;
        //obj.StrCuentaAbono   = txtCtaAbono.Text  == "" ? null : txtCtaAbono.Text;
        //obj.IntES = chkTodosTipo.Checked ? -1 : rdlEntrada.Checked ? 1 : 0;

        //obj.SortDirection = this.SortDirection == SortDirection.Ascending ? 1 : 0;
        //obj.SortExpression = SortExpression;

        //using (DataTable dt = clsCuentas.GetList(obj))
        //{
        //    if (dt != null)
        //    {
        //        if (dt.Rows.Count > 0)
        //        {

        //            this.TotalRecords = obj.iNumRecords;
        //            this.FromRecord = obj.iNumRecords * obj.iNumPage + 1;
        //            this.ToRecord = Math.Min(obj.iNumRecords * obj.iNumPage + obj.iNumRecords, TotalRecords);
        //            this.TotalPages = obj.iNumPage;
        //            this.ShowButtons();
        //            pnlPagger.Visible = true;
        //            pnlPagger.UpdateAfterCallBack = true; 

        //            grdCuentasRet.DataSource = dt;
        //            grdCuentasRet.DataBind();
        //            goto Done;
        //        }
        //    }

        //    ctrlPagger1.ShowButtons();
        //    pnlPagger.Visible = false;
        //    pnlPagger.UpdateAfterCallBack = true;
        //    grdCuentasRet.DataSource = null;
        //    grdCuentasRet.DataBind();

        //Done:
        //    grdCuentasRet.UpdateAfterCallBack = true;
        //}

        //clsCuentas = null;
        //obj = null;
    }
    #endregion

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
                for (int i = 0; i < e.Row.Cells.Count; i++)
                {
                    e.Row.Cells[i].Attributes.Add("onclick", "EditRow(" + e.Row.RowIndex + ")");
                    e.Row.Cells[i].Style.Value = "text-align:center";
                }

                //e.Row.Cells[0].Style.Value = "text-align:center";
                //e.Row.Cells[1].Style.Value = "text-align:center";
                //e.Row.Cells[2].Style.Value = "text-align:center";
                //e.Row.Cells[3].Style.Value = "text-align:center";
                //e.Row.Cells[4].Style.Value = "text-align:center";
                //e.Row.Cells[5].Style.Value = "text-align:center";
                //e.Row.Cells[6].Style.Value = "text-align:center";
                //e.Row.Cells[7].Style.Value = "text-align:center";
                //e.Row.Cells[8].Style.Value = "text-align:center";
                //e.Row.Cells[9].Style.Value = "text-align:center";
               // e.Row.Cells[10].Style.Value = "text-align:center";

            }
        }
    }
    #endregion

    //protected void grdCuentasRet_Sorting(object sender, GridViewSortEventArgs e)
    //{
    //    SetNewSort(e.SortExpression, e.SortDirection);
    //    BindGrid();
    //}

    //public void SetNewSort(string sortExpression, SortDirection sortDirection)
    //{
    //    ctrlPagger1.SetNewSort(sortExpression, sortDirection);
    //}

    //#region Pagger
    //public int PageSize
    //{
    //    get { return ctrlPagger1.PageSize; }
    //    set { ctrlPagger1.PageSize = value; }
    //}

    //public int PageIndex
    //{
    //    get { return ctrlPagger1.PageIndex; }
    //    set { ctrlPagger1.PageIndex = value; }
    //}

    //public SortDirection SortDirection
    //{
    //    get { return ctrlPagger1.SortDirection; }
    //    set { ctrlPagger1.SortDirection = value; }
    //}

    //public string SortExpression
    //{
    //    get { return ctrlPagger1.SortExpression; }
    //    set { ctrlPagger1.SortExpression = value; }
    //}

    //public int TotalRecords
    //{
    //    get { return ctrlPagger1.TotalRecords; }
    //    set { ctrlPagger1.TotalRecords = value; }
    //}
    //public int FromRecord
    //{
    //    get { return ctrlPagger1.FromRecord; }
    //    set { ctrlPagger1.FromRecord = value; }
    //}
    //public int ToRecord
    //{
    //    get { return ctrlPagger1.ToRecord; }
    //    set { ctrlPagger1.ToRecord = value; }
    //}
    //public int TotalPages
    //{
    //    get { return ctrlPagger1.TotalPages; }
    //    set { ctrlPagger1.TotalPages = value; }
    //}
    //public void ShowButtons()
    //{
    //    ctrlPagger1.ShowButtons();
    //}
    //#endregion

    #region List
    private void List()
    {
        int rows;
        int count = 0;
        int count2 = 0;
        int countColumn = 0;
        DataTable dt;


        Entity_CuentasRet obj = new Entity_CuentasRet();
        CuentasRet clsCuentas = new CuentasRet();

        //obj.iNumRecords = this.PageSize;
        //obj.iNumPage = this.PageIndex;

        obj.IntEmpresa = txtEmpresa.Text == "" ? Contabilidad.SEMSession.GetInstance.IntEmpresa : Convert.ToInt32(txtEmpresa.Text);
        obj.IntSucursal = hddSucursal.Value == "" ? Contabilidad.SEMSession.GetInstance.IntSucursal : Convert.ToInt32(hddSucursal.Value);
        //obj.IntCuentaRet = txtCuentasRet.Text != "" ? Convert.ToInt32(txtCuentasRet.Text) : 0;
        obj.IntArea = txtArea.Text != "" ? Convert.ToInt32(txtArea.Text) : 0;
        obj.StrInsumoInicial = txtInsumoIni.Text == "" ? null : txtInsumoIni.Text;
        obj.StrInsumoFinal = txtInsumoFin.Text == "" ? null : txtInsumoFin.Text;
        obj.StrCuentaCargo = txtCtaCargo.Text == "" ? null : txtCtaCargo.Text;
        obj.StrCuentaAbono = txtCtaAbono.Text == "" ? null : txtCtaAbono.Text;
        obj.IntES = Convert.ToInt32 ( rbTipo.SelectedValue); //chkTodosTipo.Checked ? -1 : rdlEntrada.Checked ? 1 : 0;

        //obj.SortDirection = this.SortDirection == SortDirection.Ascending ? 1 : 0;
        //obj.SortExpression = SortExpression;

        dt = clsCuentas.GetList(obj);

        rows = dt.Rows.Count;
        countColumn = dt.Columns.Count;

        foreach (DataColumn column in dt.Columns)
        {
            count = count + 1;
            if (count == countColumn)
            {
                dataColumns.Append("'" + column.ColumnName.Replace("%", "") + "'");
                colModel.Append("{ index:'" + column.ColumnName.Replace(" ", "").Replace("%", "") + "',name:'" + column.ColumnName.Replace(" ", "").Replace("%", "") + "',width:20," + TypeValue(column.DataType.ToString()) + ",  hidden:false }");
            }
            else
            {
                dataColumns.Append("'" + column.ColumnName.Trim().Replace("intArea", "#") + "',");

                switch (count)
                {
                    case 1:
                        colModel.Append("{ index:'" + column.ColumnName.Replace(" ", "").Replace("%", "") + "',name:'" + column.ColumnName.Replace(" ", "").Replace("%", "") + "',width:5," + TypeValue(column.DataType.ToString()) + " ,  hidden:true}, ");
                        break;
                    case 2:
                        colModel.Append("{ index:'" + column.ColumnName.Replace(" ", "").Replace("%", "") + "',name:'" + column.ColumnName.Replace(" ", "").Replace("%", "") + "',width:90," + TypeValue(column.DataType.ToString()) + ",  hidden:true },");
                        break;
                    case 3:
                        colModel.Append("{ index:'" + column.ColumnName.Replace(" ", "").Replace("%", "") + "',name:'" + column.ColumnName.Replace(" ", "").Replace("%", "") + "',width:100," + TypeValue(column.DataType.ToString()) + ",  hidden:false },");
                        break;
                    case 4:
                        colModel.Append("{ index:'" + column.ColumnName.Replace(" ", "").Replace("%", "") + "',name:'" + column.ColumnName.Replace(" ", "").Replace("%", "") + "',width:40," + TypeValue(column.DataType.ToString()) + ",  hidden:false },");//InsumoIni
                        break;
                    case 5:
                        colModel.Append("{ index:'" + column.ColumnName.Replace(" ", "").Replace("%", "") + "',name:'" + column.ColumnName.Replace(" ", "").Replace("%", "") + "',width:10," + TypeValue(column.DataType.ToString()) + ",  hidden:true },");
                        break;
                    case 6:
                        colModel.Append("{ index:'" + column.ColumnName.Replace(" ", "").Replace("%", "") + "',name:'" + column.ColumnName.Replace(" ", "").Replace("%", "") + "',width:40," + TypeValue(column.DataType.ToString()) + ",  hidden:false },");
                        break;
                    case 7:
                        colModel.Append("{ index:'" + column.ColumnName.Replace(" ", "").Replace("%", "") + "',name:'" + column.ColumnName.Replace(" ", "").Replace("%", "") + "',width:70," + TypeValue(column.DataType.ToString()) + ",  hidden:true },");//NombreInsumoFin
                        break;
                    case 8:
                        colModel.Append("{ index:'" + column.ColumnName.Replace(" ", "").Replace("%", "") + "',name:'" + column.ColumnName.Replace(" ", "").Replace("%", "") + "',width:90," + TypeValue(column.DataType.ToString()) + ",  hidden:false },");
                        break;
                    case 9:
                        colModel.Append("{ index:'" + column.ColumnName.Replace(" ", "").Replace("%", "") + "',name:'" + column.ColumnName.Replace(" ", "").Replace("%", "") + "',width:90," + TypeValue(column.DataType.ToString()) + ",  hidden:true },");
                        break;
                    case 10:
                        colModel.Append("{ index:'" + column.ColumnName.Replace(" ", "").Replace("%", "") + "',name:'" + column.ColumnName.Replace(" ", "").Replace("%", "") + "',width:90," + TypeValue(column.DataType.ToString()) + ",  hidden:false },");//CuentaAbono
                        break;
                    case 11:
                        colModel.Append("{ index:'" + column.ColumnName.Replace(" ", "").Replace("%", "") + "',name:'" + column.ColumnName.Replace(" ", "").Replace("%", "") + "',width:10," + TypeValue(column.DataType.ToString()) + ",  hidden:true },");
                        break;
                    case 12:
                        colModel.Append("{ index:'" + column.ColumnName.Replace(" ", "").Replace("%", "") + "',name:'" + column.ColumnName.Replace(" ", "").Replace("%", "") + "',width:90," + TypeValue(column.DataType.ToString()) + ",  hidden:false },");
                        break;
                    case 13:
                        colModel.Append("{ index:'" + column.ColumnName.Replace(" ", "").Replace("%", "") + "',name:'" + column.ColumnName.Replace(" ", "").Replace("%", "") + "',width:110," + TypeValue(column.DataType.ToString()) + ",  hidden:false },");
                        break;
                    case 14:
                        colModel.Append("{ index:'" + column.ColumnName.Replace(" ", "").Replace("%", "") + "',name:'" + column.ColumnName.Replace(" ", "").Replace("%", "") + "',width:110," + TypeValue(column.DataType.ToString()) + ",  hidden:true },");
                        break;
          
                    default:
                        colModel.Append("{ index:'" + column.ColumnName.Replace(" ", "").Replace("%", "") + "',name:'" + column.ColumnName.Replace(" ", "").Replace("%", "") + "',width:" + Size(column.ColumnName) + "," + TypeValue(column.DataType.ToString()) + " },");
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

        //dataList.Append("]");
        clsCuentas = null;
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
            if (data.ToUpper().Contains("#"))
                result = "40";
            else
            {
                if (data.ToUpper().Contains("CLIENTE"))
                    result = "200";
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
                result = "align: 'Right'";
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

    protected void lknEliminar_Click(object sender, EventArgs e)
    {
        string strInsIni, strInsFin, strCtaCargo, strCtaAbono;
        int empresa, area, intEntrada;

        area = hddIntArea.Value == "" ? 0 : Convert.ToInt32(hddIntArea.Value);
        empresa = txtEmpresa.Text == "" ? 0 : Convert.ToInt32(txtEmpresa .Text);
        strInsIni = hddStrInsumoInicial.Value;
        strInsFin = hddStrInsumoFinal.Value;
        strCtaCargo = hddStrCuentaCargo.Value;
        strCtaAbono = hddStrCuentaAbono.Value;
        intEntrada = hddEn.Value == "" ? 0 : Convert.ToInt32(hddEn.Value);

        Entity_CuentasRet obj;
        obj = new Entity_CuentasRet();
        CuentasRet cta;
        cta = new CuentasRet();
        bool res = false;

        obj.IntEmpresa = empresa;
        obj.IntArea = area;
        obj.StrInsumoInicial = strInsIni;
        obj.StrInsumoFinal = strInsFin;
        obj.StrCuentaCargo = strCtaCargo;
        obj.StrCuentaAbono = strCtaAbono;
        obj.IntES = intEntrada;

        res= cta.Delete(obj);

        if (res)
        {
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "Alerta", "alert('Se elimino correctamente el Insumo');", true);
            Clear2();
   
           // lknList_Click(null, null);
//            Anthem.Manager.RegisterStartupScript(Page.GetType(), "CuentaPoss", "document.getElementById('" + lknList.ClientID + "').onclick(); ", true);
        }
        else
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "Alerta", "alert('Ocurrio un error al eliminar el Insumo');", true);


    }
    protected void lknList_Click(object sender, EventArgs e)
    {
        List();
    }
}
