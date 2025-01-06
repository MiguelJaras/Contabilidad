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
using Contabilidad.Bussines;
using Contabilidad.Entity;
using System.Collections.Generic;

public partial class Pages_Inventarios_Opciones_EstructuraPolizas : System.Web.UI.Page
{
    public string realPath;
    Pages_Base toolbar;

    protected void Page_Load(object sender, EventArgs e)
    {
        toolbar = (Pages_Base)this.Master;
        toolbar.PageEvent += new HandlerEvent(Me_Event);

        string end = (Request.ApplicationPath.EndsWith("/")) ? "" : "/";
        string path = Request.ApplicationPath + end;
        realPath = String.Format("http://{0}{1}{2}", Request.Url.Authority, path, "Img/dxpcFooterBack.gif");
        Anthem.Manager.Register(this);

        if (!IsPostBack && !IsCallback)
        {
            hddClave.Value = "0"; 
            toolbar.PrintValid(); 
            rdlSi.Checked = true;
            rdlNo.Checked = false;
            txtEmpresa.Text = Contabilidad.SEMSession.GetInstance.IntEmpresa.ToString();
            txtEmpresa_TextChange(null, null);
        }
               
        JavaScript();
    }

    protected void Page_PreRender(object sender, EventArgs e)
    {
        toolbar.Print(false);
        toolbar.Email(false);
    }

    #region JavaScript
    private void JavaScript()
    {
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtMovTo", "var objText = new VetecText('" + txtMovTo.ClientID + "', 'number', 12);", true);
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtPorcentaje", "var objText = new VetecText('" + txtPorcentaje.ClientID + "', 'decimal6',12);", true);
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtTipoPoliza", "var objText = new VetecText('" + txtTipoPoliza.ClientID + "', 'text', 7);", true);
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtDescripcion", "var objText = new VetecText('" + txtDescripcion.ClientID + "', 'text', 50);", true);
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtDescPoliza", "var objText = new VetecText('" + txtDescPoliza.ClientID + "', 'text', 100);", true);
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtComentario", "var objText = new VetecText('" + txtComentario.ClientID + "', 'text', 100);", true);
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtCuenta", "var objText = new VetecText('" + txtCuenta.ClientID + "', 'text', 16);", true);

        if (!IsPostBack && !IsCallback)
        {
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "focus", "document.all('ctl00_CPHBase_txtMovTo').focus()", true);
        }
    }
    #endregion 

    #region llena Combos
    private void llenaCombos()
    {
        UtilFunctions util = new UtilFunctions();
        int intEmpresa = txtEmpresa.Text == "" ? Contabilidad.SEMSession.GetInstance.IntEmpresa : Convert.ToInt32(txtEmpresa.Text);
        int intSucursal = hddSucursal.Value == "" ? Contabilidad.SEMSession.GetInstance.IntSucursal : Convert.ToInt32(hddSucursal.Value);
        
        
        util.setFillDataControls(intEmpresa, intSucursal, "DACEstructuraPolizaDet", null, 1, "Concepto", "Concepto", cboConcepto);
        util.setFillDataControls(intEmpresa, intSucursal, "DACEstructuraPolizaDet", null, 2, "Base", "Base", cboBase);
        util.setFillDataControls(intEmpresa, intSucursal, "DACEstructuraPolizaDet", null, 3, "strParametro", "strParametro", cboComplemento); 
    } 

    #endregion

    #region txtRowEdit_Change
    protected void txtRowEdit_Change(object sender, EventArgs e)
    {
        try
        {
            Entity_EstructuraPolizaDet estPolDet = new Entity_EstructuraPolizaDet();
            EstructuraPolizaDet obj = new EstructuraPolizaDet();
            ClearDet();
            int intId = Convert.ToInt32(txtRowEdit.Text); 
            estPolDet.IntEmpresa = txtEmpresa.Text == "" ? Contabilidad.SEMSession.GetInstance.IntEmpresa : Convert.ToInt32(txtEmpresa.Text);
            estPolDet.IntSucursal = hddSucursal.Value == "" ? Contabilidad.SEMSession.GetInstance.IntSucursal : Convert.ToInt32(hddSucursal.Value);
            estPolDet.IntPartida = Convert.ToInt32(grdDet.DataKeys[intId].Value.ToString());
            estPolDet.IntClave = hddClave.Value == "" ? -1 : Convert.ToInt32(hddClave.Value); 

            Entity_EstructuraPolizaDet fgh = obj.GetByPrimaryKey(estPolDet);

            if (fgh != null)
            {
                //txtCuenta.Text = fgh.StrCuenta;
                hddIdClave.Value = fgh.IntClave.ToString();
                int xCta = 0, xSubCta = 0, xSSubCta = 0;

                if (int.TryParse(fgh.StrCuenta, out xCta) && int.TryParse(fgh.StrSubCuentat, out xSubCta) && int.TryParse(fgh.StrSubSubCuenta, out xSSubCta))
                {
                    txtCuenta.Text = fgh.StrCuenta + fgh.StrSubCuentat + fgh.StrSubSubCuenta; 
                }
                else
                    if (int.TryParse(fgh.StrCuenta, out xCta) && int.TryParse(fgh.StrSubCuentat, out xSubCta))
                    {
                        txtCuenta.Text = fgh.StrCuenta + fgh.StrSubCuentat;
                        selCboComplemento(fgh.StrSubSubCuenta); 
                    }
                    else
                        if (int.TryParse(fgh.StrCuenta, out xCta))
                        {
                            txtCuenta.Text = fgh.StrCuenta;
                            selCboComplemento(fgh.StrSubCuentat);  
                        }
                txtCuenta.UpdateAfterCallBack = true;
                txtCuenta_Change(null, null);
                cboConcepto.SelectedValue = fgh.StrConcepto;
                cboBase.SelectedValue = fgh.StrBase;
                chkAux.Checked = fgh.BitAux;
                chkCargo.Checked = fgh.BitCargo;
                chkCC.Checked = fgh.BitCC;
                txtComentario.Text = fgh.StrComentario;
                txtPorcentaje.Text = fgh.DblPtaje.ToString();
                chkModif.Checked = fgh.BitModif;

            }
            else
            {
                txtCuenta.Text = "";
                hddClaveCuenta.Value = "";
                hddIdClave.Value = "";
                txtNombreCuenta.Text = "";
                cboComplemento.SelectedIndex = 0;
                chkCargo.Checked = false;
                chkAux.Checked = false;
                chkCC.Checked = false;
                cboConcepto.SelectedIndex = 0;
                txtComentario.Text = "";
                cboBase.SelectedIndex = 0;
                txtPorcentaje.Text = "";
                chkModif.Checked = false; 
            }

            btnAgregar.Text = "Actualizar";

            btnAgregar.UpdateAfterCallBack = true;
            txtCuenta.UpdateAfterCallBack = true;
            hddClaveCuenta.UpdateAfterCallBack = true;
            hddIdClave.UpdateAfterCallBack = true;
            txtNombreCuenta.UpdateAfterCallBack = true;
            cboComplemento.UpdateAfterCallBack = true;
            chkCargo.UpdateAfterCallBack = true;
            chkAux.UpdateAfterCallBack = true;
            chkCC.UpdateAfterCallBack = true;
            cboConcepto.UpdateAfterCallBack = true;
            txtComentario.UpdateAfterCallBack = true;
            cboBase.UpdateAfterCallBack = true;
            txtPorcentaje.UpdateAfterCallBack = true;
            chkModif.UpdateAfterCallBack = true; 
            

        }
        catch (Exception ex)
        {
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "msgEr", "Alert('" + ex.Message + "');", true);

        }
    }

    public void ClearOnCta()
    {  
        hddIdClave.Value = "";
        txtNombreCuenta.Text = "";
        cboComplemento.SelectedIndex = 0;
        chkCargo.Checked = false;
        chkAux.Checked = false;
        chkCC.Checked = false;
        cboConcepto.SelectedIndex = 0;
        txtComentario.Text = "";
        cboBase.SelectedIndex = 0;
        txtPorcentaje.Text = "";
        chkModif.Checked = false; 
       
        hddIdClave.UpdateAfterCallBack = true;
        txtNombreCuenta.UpdateAfterCallBack = true;
        cboComplemento.UpdateAfterCallBack = true;
        chkCargo.UpdateAfterCallBack = true;
        chkAux.UpdateAfterCallBack = true;
        chkCC.UpdateAfterCallBack = true;
        cboConcepto.UpdateAfterCallBack = true;
        txtComentario.UpdateAfterCallBack = true;
        cboBase.UpdateAfterCallBack = true;
        txtPorcentaje.UpdateAfterCallBack = true;
        chkModif.UpdateAfterCallBack = true; 
    }

    public void selCboComplemento(string strVal)
    {
        if (strVal != "")
            cboComplemento.SelectedValue = strVal;
        else
            cboComplemento.SelectedIndex = 0;
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

        Anthem.Manager.RegisterStartupScript(Page.GetType(), "focus", "document.all('ctl00_CPHBase_txtMovTo').focus()", true);

        obj = null;
        emp = null;
    }
    #endregion

    #region txtMovTo_Change
    protected void txtMovTo_Change(object sender, EventArgs e)
    {
        EstructuraPolizaEnc EstPoliza = new EstructuraPolizaEnc();
        Entity_EstructuraPolizaEnc obj = new Entity_EstructuraPolizaEnc();

        if (txtMovTo.Text == "" || txtMovTo.Text == "0")
        {
            txtMovTo.Text = "0";
            txtMovTo.UpdateAfterCallBack = true;
            return;
        }

        obj.IntMovto = Convert.ToInt32(txtMovTo.Text);         
        obj.IntEmpresa = txtEmpresa.Text == "" ? Contabilidad.SEMSession.GetInstance.IntEmpresa : Convert.ToInt32(txtEmpresa.Text);
        obj.IntSucursal = hddSucursal.Value == "" ? Contabilidad.SEMSession.GetInstance.IntSucursal : Convert.ToInt32(hddSucursal.Value);

        obj = EstPoliza.GetByPrimaryKey(obj);
        
        if (obj != null)
        {
            txtMovTo.Text = obj.IntMovto.ToString();
            txtNombreMovTo.Text = obj.StrNombreTipoMovto;
            txtDescripcion.Text = obj.StrDescrcipcion;
            txtTipoPoliza.Text = obj.StrTipoPoliza;
            txtNombreTipoPoliza.Text = obj.StrNombrePoliza;
            hddClave.Value = obj.IntClave.ToString();

            if (obj.BitAutomatica)
            {
                rdlSi.Checked = true;
                rdlNo.Checked = false;
            }
            else
            {
                rdlNo.Checked = true;
                rdlSi.Checked = false;
            }
            txtDescPoliza.Text = obj.StrDescripciónPoliza;
            BindGrid();
        }
        else
        {
            Contabilidad.DataAccess.DACEstructuraPolizaEnc obj2 = new Contabilidad.DataAccess.DACEstructuraPolizaEnc();
            int intEmpresa = txtEmpresa.Text == "" ? Contabilidad.SEMSession.GetInstance.IntEmpresa : Convert.ToInt32(txtEmpresa.Text);
            int intSucursal = hddSucursal.Value == "" ? Contabilidad.SEMSession.GetInstance.IntSucursal : Convert.ToInt32(hddSucursal.Value);

            string[] arr = new string[] { txtMovTo.Text, ",", "," };
            using (DataSet ds = obj2.QueryHelpData(intEmpresa, intSucursal, arr, 1))
            {
                if (ds.Tables.Count > 0)
                {
                    if (ds.Tables[0].Rows.Count > 0)
                    {
                        txtNombreMovTo.Text = ds.Tables[0].Rows[0]["strNombre"].ToString();
                        txtNombreMovTo.UpdateAfterCallBack = true;
                    }
                }
                else
                {
                    txtNombreMovTo.Text = "";
                    txtMovTo.Text = "";
                }
            }

            obj2 = null;
            txtDescripcion.Text = "";
            txtTipoPoliza.Text = ""; 
            txtNombreTipoPoliza.Text = "";
            rdlSi.Checked = true;
            rdlNo.Checked = false;
            txtDescPoliza.Text = "";
            grdDet.DataSource = null;
            grdDet.DataBind();
        }

        txtMovTo.UpdateAfterCallBack=true;
        txtNombreMovTo.UpdateAfterCallBack = true;
        txtDescripcion.UpdateAfterCallBack = true;
        txtTipoPoliza.UpdateAfterCallBack = true;
        txtNombreTipoPoliza.UpdateAfterCallBack = true;
        rdlSi.UpdateAfterCallBack = true;
        rdlNo.UpdateAfterCallBack = true; 
        txtDescPoliza.UpdateAfterCallBack = true;
        hddClave.UpdateAfterCallBack = true;
        grdDet.UpdateAfterCallBack = true;
        txtNombreMovTo.UpdateAfterCallBack = true;

        Anthem.Manager.RegisterStartupScript(Page.GetType(), "focus", "document.all('ctl00_CPHBase_txtDescripcion').focus()", true);
    }
    #endregion   

    #region txtTipoPoliza_Change
    protected void txtTipoPoliza_Change(object sender, EventArgs e)
    {
        if (txtTipoPoliza.Text != "")
        {
            try
            {
                Contabilidad.DataAccess.DACEstructuraPolizaEnc obj = new Contabilidad.DataAccess.DACEstructuraPolizaEnc();
                string[] arr = new string[] { txtTipoPoliza.Text, ",", "," };
                int intEmpresa = txtEmpresa.Text == "" ? Contabilidad.SEMSession.GetInstance.IntEmpresa : Convert.ToInt32(txtEmpresa.Text);
                int intSucursal = hddSucursal.Value == "" ? Contabilidad.SEMSession.GetInstance.IntSucursal : Convert.ToInt32(hddSucursal.Value);

                using (DataSet ds = obj.QueryHelpData(intEmpresa, intSucursal, arr, 2))
                {
                    if (ds.Tables.Count > 0)
                    {
                        if (ds.Tables[0].Rows.Count > 0)
                        { 
                            txtNombreTipoPoliza.Text = ds.Tables[0].Rows[0]["strNombre"].ToString();
                            txtNombreTipoPoliza.UpdateAfterCallBack = true;
                            Anthem.Manager.RegisterStartupScript(Page.GetType(), "focus", "document.all('ctl00_CPHBase_rdlSi').focus()", true);
                            return;
                        }
                    }
                }

                txtTipoPoliza.Text = "";
                txtNombreTipoPoliza.Text = "";
                txtTipoPoliza.UpdateAfterCallBack = true;
                txtNombreTipoPoliza.UpdateAfterCallBack = true;
                Anthem.Manager.RegisterStartupScript(Page.GetType(), "Alerta", "alert('No existe tipo de Poliza');", true);
                Anthem.Manager.RegisterStartupScript(Page.GetType(), "focus", "document.all('ctl00_CPHBase_txtTipoPoliza').focus()", true); 
            }
            catch (System.IO.IOException ex) { }
        }
    }
    #endregion

    #region txtCuenta_Change
    protected void txtCuenta_Change(object sender, EventArgs e)
    {
        if (txtCuenta.Text != "")
        {
            try
            {
                Contabilidad.DataAccess.DACEstructuraPolizaDet obj = new Contabilidad.DataAccess.DACEstructuraPolizaDet();
                string[] arr = new string[] { txtCuenta.Text, ",", "," };
                int intEmpresa = txtEmpresa.Text == "" ? Contabilidad.SEMSession.GetInstance.IntEmpresa : Convert.ToInt32(txtEmpresa.Text);
                int intSucursal = hddSucursal.Value == "" ? Contabilidad.SEMSession.GetInstance.IntSucursal : Convert.ToInt32(hddSucursal.Value);

                using (DataSet ds = obj.QueryHelpData(intEmpresa, intSucursal, arr, 0))
                {
                    if (ds.Tables.Count > 0)
                    {
                        if (ds.Tables[0].Rows.Count > 0)
                        {
                            txtNombreCuenta.Text = ds.Tables[0].Rows[0]["strNombre"].ToString();
                            txtNombreCuenta.UpdateAfterCallBack = true;
                            return;
                        }
                    }

                    txtCuenta.Text = "";
                    txtNombreCuenta.Text = "";
                    txtCuenta.UpdateAfterCallBack = true;
                    txtNombreCuenta.UpdateAfterCallBack = true;
                    Anthem.Manager.RegisterStartupScript(Page.GetType(), "Alerta", "alert('No existe tipo de cuenta');", true);
                    Anthem.Manager.RegisterStartupScript(Page.GetType(), "focus", "document.all('ctl00_CPHBase_txtCuenta').focus()", true); 
                }
            }
            catch (System.IO.IOException ex) { }
        }
    }
    #endregion       

    #region Clear
    private void Clear()
    {
        hddClave.Value = "";
        txtMovTo.Text = ""; 
        txtNombreMovTo.Text = "";
        txtDescripcion.Text = "";
        txtTipoPoliza.Text = "";
        txtNombreTipoPoliza.Text = "";
        rdlSi.Checked = true;
        rdlNo.Checked = false;
        txtDescPoliza.Text = ""; 
        txtCuenta.Text = "";
        hddClaveCuenta.Value = "";
        txtNombreCuenta.Text = ""; 
        cboComplemento.SelectedIndex = 0;
        chkCargo.Checked = false;
        chkAux.Checked = false;
        chkCC.Checked = false;
        cboConcepto.SelectedIndex = 0;
        txtComentario.Text = ""; 
        cboBase.SelectedIndex = 0;
        txtPorcentaje.Text = "";
        chkModif.Checked = false; 
        grdDet.DataSource = null;
        grdDet.DataBind(); 

        txtMovTo.UpdateAfterCallBack = true;
        txtNombreMovTo.UpdateAfterCallBack = true;
        txtDescripcion.UpdateAfterCallBack = true;
        txtTipoPoliza.UpdateAfterCallBack = true;
        txtNombreTipoPoliza.UpdateAfterCallBack = true;
        rdlSi.UpdateAfterCallBack = true;
        rdlNo.UpdateAfterCallBack = true;
        txtDescPoliza.UpdateAfterCallBack = true; 
        txtCuenta.UpdateAfterCallBack = true;
        hddClaveCuenta.UpdateAfterCallBack = true;
        txtNombreCuenta.UpdateAfterCallBack = true; 
        cboComplemento.UpdateAfterCallBack = true;
        chkCargo.UpdateAfterCallBack = true;
        chkAux.UpdateAfterCallBack = true;
        chkCC.UpdateAfterCallBack = true;
        cboConcepto.UpdateAfterCallBack = true;
        txtComentario.UpdateAfterCallBack = true;
        cboBase.UpdateAfterCallBack = true;
        txtPorcentaje.UpdateAfterCallBack = true;
        chkModif.UpdateAfterCallBack = true; 
        grdDet.DataSource = null;
        grdDet.UpdateAfterCallBack = true;
        hddClave.UpdateAfterCallBack = true;

    }

    void ClearDet()
    {
        txtCuenta.Text = ""; 
        hddClaveCuenta.Value = "";
        hddIdClave.Value = "";
        txtNombreCuenta.Text = "";
        cboComplemento.SelectedIndex = 0;
        chkCargo.Checked = false;
        chkAux.Checked = false;
        chkCC.Checked = false;
        cboConcepto.SelectedIndex = 0;
        txtComentario.Text = "";
        cboBase.SelectedIndex = 0;
        txtPorcentaje.Text = "";
        chkModif.Checked = false;       

        txtCuenta.UpdateAfterCallBack = true;
        hddClaveCuenta.UpdateAfterCallBack = true;
        hddIdClave.UpdateAfterCallBack = true;
        txtNombreCuenta.UpdateAfterCallBack = true;
        cboComplemento.UpdateAfterCallBack = true;
        chkCargo.UpdateAfterCallBack = true;
        chkAux.UpdateAfterCallBack = true;
        chkCC.UpdateAfterCallBack = true;
        cboConcepto.UpdateAfterCallBack = true;
        txtComentario.UpdateAfterCallBack = true;
        cboBase.UpdateAfterCallBack = true;
        txtPorcentaje.UpdateAfterCallBack = true;
        chkModif.UpdateAfterCallBack = true;
    }
    #endregion

    #region BindGrid
    private void BindGrid()
    {
        Entity_EstructuraPolizaDet obj = new Entity_EstructuraPolizaDet();
        EstructuraPolizaDet EstPolizaDet = new EstructuraPolizaDet();

        obj.IntEmpresa = txtEmpresa.Text == "" ? Contabilidad.SEMSession.GetInstance.IntEmpresa : Convert.ToInt32(txtEmpresa.Text); 
        obj.IntSucursal = hddSucursal.Value == "" ? Contabilidad.SEMSession.GetInstance.IntSucursal : Convert.ToInt32(hddSucursal.Value);
        int val= 0;
        obj.IntPartida = 0;
        obj.IntClave = hddClave.Value == "" ? -1 : int.TryParse(hddClave.Value, out val) == true && val > 0 ? val : -1;

        using(DataTable dt = EstPolizaDet.GetList(obj))
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

        EstPolizaDet = null;
        obj = null;
    }
    #endregion

    #region DgrdList_RowDeleting
    protected void DgrdList_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        try
        {

            DeleteDet((int)grdDet.DataKeys[e.RowIndex].Value);  
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
                e.Row.Cells[9].Style.Value = "text-align:center";
                e.Row.Cells[10].Style.Value = "text-align:center";
                 
            }
        } 
    }
    #endregion

    #region btnAgregar_Click
    protected void btnAgregar_Click(object sender, EventArgs e)
    {
        try
        {
            Save();

            btnAgregar.Text = "Agregar  >>";

            btnAgregar.UpdateAfterCallBack = true;
        }
        catch (Exception ex)
        {
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "mssEr", "alert('" + ex.Message + "')", true);
        }
    }
    #endregion

    #region Save
    void Save()
    {
        try
        { 

            Entity_EstructuraPolizaEnc entEstPolEnc = new Entity_EstructuraPolizaEnc();
            EstructuraPolizaEnc obj = new EstructuraPolizaEnc();

            entEstPolEnc.IntEmpresa = txtEmpresa.Text == "" ? Contabilidad.SEMSession.GetInstance.IntEmpresa : Convert.ToInt32(txtEmpresa.Text);
            entEstPolEnc.IntSucursal = hddSucursal.Value == "" ? Contabilidad.SEMSession.GetInstance.IntSucursal : Convert.ToInt32(hddSucursal.Value);
            entEstPolEnc.IntClave = Convert.ToInt32(hddClave.Value == "" ? "0" : hddClave.Value);
            entEstPolEnc.StrDescrcipcion = txtDescripcion.Text;
            entEstPolEnc.StrTipoPoliza = txtTipoPoliza.Text;
            entEstPolEnc.IntModulo = 1;
            entEstPolEnc.StrDescripciónPoliza = txtNombreTipoPoliza.Text;
            entEstPolEnc.BitAutomatica = rdlSi.Checked ? true: false;
            entEstPolEnc.IntMovto = Convert.ToInt32(txtMovTo.Text == "" ? "0" : txtMovTo.Text);
            entEstPolEnc.IntGrupoCredito = 1;
            entEstPolEnc.StrUsuario = Contabilidad.SEMSession.GetInstance.StrUsuario;
            entEstPolEnc.StrMaquina = Contabilidad.SEMSession.GetInstance.StrMaquina;
            entEstPolEnc.IntGrupoCredito = 1;

            string strClave = obj.Save(entEstPolEnc);

            if (txtCuenta.Text.Trim() != "")
            {
                SaveDet(strClave); 
            }
            else
            {
                Anthem.Manager.RegisterStartupScript(Page.GetType(), "Alerta", "alert('Estructura de Póliza guardada');", true);
                Anthem.Manager.RegisterStartupScript(Page.GetType(), "focus", "document.all('ctl00_CPHBase_txtCuenta').focus()", true);
                return;
            }

            hddClave.Value = strClave;
            hddClave.UpdateAfterCallBack = true;

            BindGrid(); 
        }
        catch (Exception ex)
        {
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "mssErrr", "alert('" + ex.Message + "');", true);
        }
    }

    void SaveDet(string strClave)
    {
        try
        {

            decimal porc = 0;
            int intPartida = 0;
            if (txtPorcentaje.Text != "")
            {
                porc = Convert.ToDecimal(txtPorcentaje.Text == "" ? "0" : txtPorcentaje.Text);

                if (porc > 100)
                {
                    Anthem.Manager.RegisterStartupScript(Page.GetType(), "Alerta", "alert('El porcentaje no debe ser mayor a 100');", true);
                    Anthem.Manager.RegisterStartupScript(Page.GetType(), "focus", "document.all('ctl00_CPHBase_txtPorcentaje').focus()", true);
                    return;
                }
            }

            intPartida = txtRowEdit.Text == "" ? 0 : Convert.ToInt32(txtRowEdit.Text);

            Entity_EstructuraPolizaDet entEstPolDet = new Entity_EstructuraPolizaDet();
            EstructuraPolizaDet obj = new EstructuraPolizaDet();

            entEstPolDet.IntEmpresa = txtEmpresa.Text == "" ? Contabilidad.SEMSession.GetInstance.IntEmpresa : Convert.ToInt32(txtEmpresa.Text);
            entEstPolDet.IntSucursal = hddSucursal.Value == "" ? Contabilidad.SEMSession.GetInstance.IntSucursal : Convert.ToInt32(hddSucursal.Value);
            entEstPolDet.IntClave = Convert.ToInt32(strClave);
            entEstPolDet.IntPartida = txtRowEdit.Text == "" ? 0 : Convert.ToInt32(grdDet.DataKeys[intPartida].Value); 

            string strCuenta = string.Empty;
            string strSubCuentat = string.Empty;
            string strSubSubCuenta = string.Empty;

            if (txtCuenta.Text.Trim() != "")
            {
                if (txtCuenta.Text.Trim().Length > 8 && txtCuenta.Text.Trim().Length >= 12)
                {
                    strCuenta = txtCuenta.Text.Trim().Substring(0, 4);
                    strSubCuentat = txtCuenta.Text.Trim().Substring(4, 4);
                    strSubSubCuenta = txtCuenta.Text.Trim().Substring(8, 4);
                }
                else
                if (txtCuenta.Text.Trim().Length > 4 && txtCuenta.Text.Trim().Length >= 8)
                {
                    strCuenta = txtCuenta.Text.Trim().Substring(0, 4);
                    strSubCuentat = txtCuenta.Text.Trim().Substring(4, 4);
                    //if (validaComplemento())
                    //    strSubSubCuenta = cboComplemento.SelectedValue;
                    //else
                    //    return;

                    if (cboComplemento.SelectedIndex > 0)
                    {
                        strSubSubCuenta = cboComplemento.SelectedValue;
                    }
                }
                else
                if (txtCuenta.Text.Trim().Length == 4)
                {
                    strCuenta = txtCuenta.Text.Trim().Substring(0, 4);
                    //if (validaComplemento())
                    //    strSubCuentat = cboComplemento.SelectedValue;
                    //else
                    //    return;

                    if (cboComplemento.SelectedIndex > 0)
                    {
                        strSubCuentat = cboComplemento.SelectedValue;
                    }
                }
            }

            entEstPolDet.StrCuenta = strCuenta;
            entEstPolDet.StrSubCuentat = strSubCuentat;
            entEstPolDet.StrSubSubCuenta = strSubSubCuenta; 
            entEstPolDet.BitCargo = chkCargo.Checked;
            entEstPolDet.BitAux = chkAux.Checked;
            entEstPolDet.BitCC = chkCC.Checked; 
            entEstPolDet.StrConcepto = cboConcepto.SelectedValue;
            entEstPolDet.StrComentario = txtComentario.Text;
            entEstPolDet.BitModif = chkModif.Checked;
            entEstPolDet.StrBase = cboBase.SelectedValue;
            entEstPolDet.DblPtaje = Convert.ToDecimal(txtPorcentaje.Text == "" ? "0" : txtPorcentaje.Text);

            string datClave = obj.Save(entEstPolDet);
            if (datClave != "")
            {
                Anthem.Manager.RegisterStartupScript(Page.GetType(), "Alerta", "alert('La información se guardo correctamente.');", true);
                Anthem.Manager.RegisterStartupScript(Page.GetType(), "focus", "document.all('ctl00_CPHBase_txtCuenta').focus()", true);
            }

            ClearDet();

            txtRowEdit.Text = "";
            txtRowEdit.UpdateAfterCallBack = true;
        }
        catch (Exception ex)
        {
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "mssErrr", "alert('" + ex.Message + "');", true);
        }
    }

    public bool validaComplemento()
    {
        if (cboComplemento.SelectedIndex > 0)
            return true;
        else
        {
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "Error", "alert('Debe seleccionar un complemento');", true);
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "focus", "document.all('ctl00_CPHBase_cboComplemento').focus()", true);
            return false;
        }
    }

    #endregion

    #region Delete
    void Delete()
    {
        try
        {
            EstructuraPolizaEnc estPolEnc = new EstructuraPolizaEnc(); 
            Entity_EstructuraPolizaEnc obj = new Entity_EstructuraPolizaEnc();

            obj.IntEmpresa = txtEmpresa.Text == "" ? Contabilidad.SEMSession.GetInstance.IntEmpresa : Convert.ToInt32(txtEmpresa.Text);
            obj.IntSucursal = hddSucursal.Value == "" ? Contabilidad.SEMSession.GetInstance.IntSucursal : Convert.ToInt32(hddSucursal.Value);
            obj.IntClave = Convert.ToInt32(hddClave.Value);

            estPolEnc.Delete(obj);            
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "ErrDel2", "alert('Se elimino correctamente.');", true);
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "msgFoc212", "document.getElementById('" + this.txtMovTo.ClientID + "').focus();", true);

            Clear();

            estPolEnc = null;
            obj = null;
        }
        catch (Exception ex)
        {
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "msfPolErr", "alert('" + ex.Message + "');", true);
        }
    }

    void DeleteDet(int pIntClave)
    {
        try
        {
            EstructuraPolizaDet estPolDet = new EstructuraPolizaDet(); 
            Entity_EstructuraPolizaDet obj = new Entity_EstructuraPolizaDet(); 

            obj.IntEmpresa = Convert.ToInt32(txtEmpresa.Text);
            obj.IntPartida = pIntClave;
            obj.IntClave = Convert.ToInt32(hddClave.Value);

            estPolDet.Delete(obj);
            BindGrid();

            Anthem.Manager.RegisterStartupScript(Page.GetType(), "ErrDel2", "alert('Se elimino correctamente.');", true);
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "msgFoc212", "document.getElementById('" + txtCuenta.ClientID + "').focus();", true);
             
           
            estPolDet = null;
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
        arrDatos[1] = hddClave.Value;

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
            case Event.List:
                BindGrid();
                break;
            default:
                break;
        }
    }
    #endregion
}
