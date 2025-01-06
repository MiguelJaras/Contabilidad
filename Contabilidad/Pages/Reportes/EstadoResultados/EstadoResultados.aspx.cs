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

public partial class Contabilidad_Reportes_EstadoResultados : System.Web.UI.Page
{
    Report_Pages_Base toolbar;
    protected void Page_Load(object sender, EventArgs e)
    {
        toolbar = (Report_Pages_Base)this.Master;
        Anthem.Manager.Register(this);

        if (!IsPostBack)
        {
            btnExpandReportes.Attributes.Add("onClick", "ReportVisible(this,'" + pnlReportes1.ClientID + "');");
            txtEmpresa.Text = Contabilidad.SEMSession.GetInstance.IntEmpresa.ToString();
            txtEmpresa_TextChange(null, null);

            txtFechaInicial.Text = DateTime.Now.ToString("dd/MM/yyyy");
            txtFechaFinal.Text = DateTime.Now.ToString("dd/MM/yyyy");

            JavaScript();
        }
        ImgDate.OnClientClick = "if(self.gfPop)gfPop.fPopCalendar(document.getElementById('" + txtFechaInicial.ClientID + "')); giDatePos=0; return false;";
        ImgDateFin.OnClientClick = "if(self.gfPop)gfPop.fPopCalendar(document.getElementById('" + txtFechaFinal.ClientID + "')); giDatePos=0; return false;";

    }

    #region JavaScript
    private void JavaScript()
    {
        Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtEmpresa", "var objText = new VetecText('" + txtEmpresa.ClientID + "', 'number', 4);", true);
       
        if (!IsPostBack && !IsCallback)
        {
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "focus", "document.all('ctl00_CPHFilters_txtEmpresa').focus()", true);
        }
    }
    #endregion JavaScript

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
    #endregion

    #region Size
    private string Size(string ObraIni, string ObraFin)
    {
        string value = "";

        DataTable dt;
        int empresa = txtEmpresa.Text == "" ? Contabilidad.SEMSession.GetInstance.IntEmpresa : Convert.ToInt32(txtEmpresa.Text);

        EstadoResultados EdoR;
        EdoR = new EstadoResultados();

        dt = EdoR.GetList(empresa, ObraIni, ObraFin);

        if (dt != null)
        {
            value = Convert.ToString((200 + (dt.Rows.Count * 100)));
        }

        EdoR = null;
        return value;
    }
    #endregion 

    #region Clear
    private void Clear()
    {
        txtFechaInicial.Text = DateTime.Now.ToString("dd/MM/yyyy");
        txtFechaFinal.Text = DateTime.Now.ToString("dd/MM/yyyy");
        txtClave.Text = "";
        txtNombre.Text = "";
        txtClaveFin.Text = "";
        txtNombreFin.Text = "";

        txtClave.UpdateAfterCallBack = true;
        txtNombre.UpdateAfterCallBack = true;
        txtClaveFin.UpdateAfterCallBack = true;
        txtNombreFin.UpdateAfterCallBack = true;
        txtFechaFinal.UpdateAfterCallBack = true;
        txtFechaInicial.UpdateAfterCallBack = true;
    }
    #endregion

    #region txtObraFin_TextChanged
    protected void txtObraFin_TextChanged(object sender, EventArgs e)
    {
        Obra obra;
        obra = new Obra();
        Entity_Obra obj;
        obj = new Entity_Obra();

        obj.IntEmpresa = Convert.ToInt32(txtEmpresa.Text);
        obj.IntSucursal = Convert.ToInt32(hddSucursal.Value);
        obj.StrClave = txtClaveFin.Text;

        obj = obra.GetByCode(obj);

        if (obj == null)
        {
            this.txtClaveFin.Text = "";
            this.txtNombreFin.Text = "";
        }
        else
        {
            this.txtClaveFin.Text = obj.StrClave;
            this.txtNombreFin.Text = obj.StrNombre;
        }

        this.txtClaveFin.UpdateAfterCallBack = true;
        this.txtNombreFin.UpdateAfterCallBack = true;
    }
    #endregion

    #region txtObra_TextChanged
    protected void txtObra_TextChanged(object sender, EventArgs e)
    {
        Obra obra;
        obra = new Obra();
        Entity_Obra obj;
        obj = new Entity_Obra();

        obj.IntEmpresa = Convert.ToInt32(txtEmpresa.Text);
        obj.IntSucursal = Convert.ToInt32(hddSucursal.Value);
        obj.StrClave = txtClave.Text;

        obj = obra.GetByCode(obj);

        if (obj == null)
        {
            this.txtClave.Text = "";
            this.txtNombre.Text = "";
            txtClaveFin.Text = "";
            txtNombreFin.Text = "";
        }
        else
        {
            this.txtClave.Text = obj.StrClave;
            this.txtNombre.Text = obj.StrNombre;
            txtClaveFin.Text = txtClave.Text;
            txtNombreFin.Text = txtNombre.Text;
        }

        this.txtClave.UpdateAfterCallBack = true;
        this.txtNombre.UpdateAfterCallBack = true;
        txtClaveFin.UpdateAfterCallBack = true;
        txtNombreFin.UpdateAfterCallBack = true;

    }
    #endregion

    #region lknEstado_Click
    protected void lknEstado_Click(object sender, EventArgs e)
    {
        string FechaIni = txtFechaInicial.Text;
        string FechaFin = txtFechaFinal.Text;

        string strCCIni = txtClave.Text == "" ? "0" : txtClave.Text;
        string strCCFin = txtClaveFin.Text == "" ? "0" : txtClaveFin.Text;
        string strQuitar = chkQuitar.Checked == true ? "1" : "0";
        string sise = Size(strCCIni, strCCFin);
        int IntEmpresa = txtEmpresa.Text == "" ? Contabilidad.SEMSession.GetInstance.IntEmpresa : Convert.ToInt32(txtEmpresa.Text);
        string url = "";

       if (!toolbar.Check())
        {
            url = "../../../Utils/GridView.aspx?Tipo=1&intEmpresa=" + IntEmpresa.ToString() + "&datFechaIni=" + FechaIni + "&datFechaFin=" + FechaFin + "&strCCIni=" + strCCIni + "&strCCFin=" + strCCFin + "&strQuitar=" + strQuitar + "&size=" + sise;
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "openDetail", "window.open('" + url + "',null,'height=700px width=1200px resizable scrollbars');", true);
            //Anthem.Manager.RegisterStartupScript(Page.GetType(), "openDetail", "window.showModalDialog('" + url + "',null,'dialogHeight:700px; dialogWidth:1200px;status:no;help:no;scroll:no;minimize:no;maximize:no;close:no;border:thin;');", true);
        }
        else
        {
            EstadoResultados es;
            es = new EstadoResultados();

            string query;
            query = es.RepFinancieroObraQry (IntEmpresa,5,FechaIni,FechaFin,strCCIni,strCCFin,strQuitar);

            es = null;

            string queryString = "?query=" + query + "&type=xls";
            Response.Redirect("../../../Utils/Excel.aspx" + queryString);
        }
    }
    #endregion

}
