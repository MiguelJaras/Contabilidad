using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Collections;
using System.Collections.Specialized;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using Contabilidad.Bussines;
using Contabilidad.Entity;
using System.Drawing;

public partial class PopUpCopiar : System.Web.UI.Page
{
    
    public string vsStrPoliza
    {
        get
        {
            return ViewState["vsStrPoliza"].ToString();
        }
        set
        {
            ViewState["vsStrPoliza"] = value;
        }
    }

    public int vsintEmpresa
    {
        get
        {
            return Convert.ToInt32(ViewState["vsintEmpresa"].ToString());
        }
        set
        {
            ViewState["vsintEmpresa"] = value;
        }
    }

    public int vsintEjercicio
    {
        get
        {
            return Convert.ToInt32(ViewState["vsintEjercicio"].ToString());
        }
        set
        {
            ViewState["vsintEjercicio"] = value;
        }
    }

    public int vsintTipo
    {
        get
        {
            return Convert.ToInt32(ViewState["vsintTipo"].ToString());
        }
        set
        {
            ViewState["vsintTipo"] = value;
        }
    }
    Pages_Base toolbar;

    protected void Page_Load(object sender, EventArgs e)
    {
        toolbar = (Pages_Base)this.Master;
        if (!Page.IsPostBack)
        {
            vsStrPoliza = Request.QueryString["strPoliza"].ToString();
            vsintEmpresa = Convert.ToInt32(Request.QueryString["intEmpresa"].ToString());
            vsintEjercicio = Convert.ToInt32(Request.QueryString["intEjercicio"].ToString());
            vsintTipo = Convert.ToInt32(Request.QueryString["intTipo"].ToString());
            txtFechaInicial.Text = DateTime.Now.ToString("dd/MM/yyyy");
            Anthem.Manager.Register(this);
            Poliza();
        }
        
        ImgDate.OnClientClick = "if(self.gfPop)gfPop.fPopCalendar(document.getElementById('" + txtFechaInicial.ClientID + "')); giDatePos=0; return false;";
        //Anthem.Manager.RegisterStartupScript(Page.GetType(), "objUtils", "var objUtils = new VetecUtils();", true);
        //Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtReferencia", "var objText = new VetecText('" + txtReferencia.ClientID + "', 'text', 100);", true);
    }

    protected void Page_PreRender(object sender, EventArgs e)
    {
        toolbar.List(false);
        toolbar.Exportar(false);
        toolbar.Email(false);
        toolbar.Save(false);
        toolbar.Delete(false);
        toolbar.Print(false);
        toolbar.New(false);
    }

    #region Poliza
    private void Poliza()
    {
        PolizasEnc poliza;
        poliza = new PolizasEnc();
        Entity_PolizasEnc obj;
        obj = new Entity_PolizasEnc();

        obj.IntEmpresa = vsintEmpresa;
        obj.strPoliza = vsStrPoliza;
        obj.intEjercicio = vsintEjercicio;

        obj = poliza.Fill(obj);

        if (obj != null)
        {
            txtDescripcion.Text = obj.strDescripcion;
            txtFechaInicial.Text = obj.datFecha.ToShortDateString();
            lblPoliza.Text = obj.strPoliza;
        }

        obj = null;
        poliza = null;
    }
    #endregion 
    
    #region btnSave_Click
    protected void btnSave_Click(object sender, EventArgs e)
    {
        string close;
        close = Close();

        if (close == "1")
        {
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "isClose", "alert('El mes esta Cerrado.');", true);
            return;
        }

        try
        {
            PolizasEnc poliza;
            poliza = new PolizasEnc();
            Entity_PolizasEnc obj;
            obj = new Entity_PolizasEnc();
            string value = "";

            obj.IntEmpresa = vsintEmpresa;
            obj.strPoliza = vsStrPoliza;
            obj.intEjercicio = vsintEjercicio;
            obj.datFecha = Convert.ToDateTime(txtFechaInicial.Text);
            obj.StrFolio = txtReferencia.Text;
            obj.strDescripcion = txtDescripcion.Text;
            obj.StrUsuario = Contabilidad.SEMSession.GetInstance.StrUsuario;
            obj.StrMaquina = Contabilidad.SEMSession.GetInstance.StrMaquina;

            if (vsintTipo == 1)
                value = poliza.Copiar(obj);
            else
                value = poliza.Inversa(obj);

            //Anthem.Manager.RegisterStartupScript(Page.GetType(), "msgSave", "alert('La poliza " + value + " guardo correctamente.'); window.returnValue = '"+ value +"'; window.close();", true);
            UtilFunctions.ShowAlert(this, "La poliza " + value + " guardo correctamente.");
            UtilFunctions.retornaVal(this, value);
            Anthem.Manager.RegisterStartupScript(this.GetType(), "close", "window.close();", true);


        }
        catch (Exception ex)
        {
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "msfPolErr", "alert('" + ex.Message + "');", true);
        }  
    }
    #endregion

    #region txtFechaInicial_Change
    protected void txtFechaInicial_Change(object sender, EventArgs e)
    {
        string close = "";
        close = Close();

        if (close == "1")
        {
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "isClose2", "alert('El mes esta Cerrado.');", true);
            btnSave.Visible = false;
        }
        else
            btnSave.Visible = true;

        btnSave.UpdateAfterCallBack = true;
    }
    #endregion

    #region Close
    private string Close()
    {
        Entity_Poliza obj;
        obj = new Entity_Poliza();
        string value;

        Poliza pol;
        pol = new Poliza();

        obj.IntEmpresa = vsintEmpresa;
        obj.IntEjercicio = Convert.ToDateTime(txtFechaInicial.Text).Date.Year;
        obj.IntMes = Convert.ToDateTime(txtFechaInicial.Text).Date.Month;
        obj.IntModulo = 1;

        value = pol.Close(obj);

        pol = null;
        obj = null;

        return value;
    }
    #endregion
}
