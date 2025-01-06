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

public partial class Pages_Base : MasterPage
{
    public event HandlerEvent PageEvent;
    public string realPath;

    protected void Page_Load(object sender, EventArgs e)
    {
        string end = (Request.ApplicationPath.EndsWith("/")) ? "" : "/";
        string path = Request.ApplicationPath + end;

        //if (!IsPostBack)
        //{
            btnSave.Attributes.Add("onclick", "return datosCompletos();");
            btnDelete.Attributes.Add("onclick", "return confirm('¿Desea eliminar?');");

            btnSave.UpdateAfterCallBack = true;
            btnDelete.UpdateAfterCallBack = true;
        //}

        realPath = String.Format("http://{0}{1}{2}", Request.Url.Authority, path, "Img/bg_btn.png");
        Permissions();
    }

    protected void Page_PreRender(object sender, EventArgs e)
    {
        string end = (Request.ApplicationPath.EndsWith("/")) ? "" : "/";
        string path = Request.ApplicationPath + end;
        string appPath = String.Format("http://{0}{1}{2}", Request.Url.Authority, path, "Login/FinSesion.aspx?id=0");

        Response.ClearHeaders();
        Response.AppendHeader("Refresh", Convert.ToString((Session.Timeout * 50)) + "; URL=" + appPath);

        //this.ScriptManager.RegisterStartupScript(this.Type(), "Refresh", "window.setTimeout('window.location=''thisPage.aspx''',5000)", true);        
    }
  
    #region btn_Click
    protected void btn_Click(object sender, ImageClickEventArgs e)
    {
        Anthem.ImageButton btn = (Anthem.ImageButton)sender;
        HandlerArgs args = new HandlerArgs();
        switch (btn.CommandName)
        {
            case "Save":
                args.Event = Event.Save;
                break;
            case "Delete":
                args.Event = Event.Delete;
                break;
            case "New":
                args.Event = Event.New;
                break;
            case "List":
                args.Event = Event.List;
                break;
            case "Email":
                args.Event = Event.Email;
                break;
            case "Print":
                args.Event = Event.Print;
                break;
            case "Export":
                args.Event = Event.Export;
                break;
            default:
                break;
        }

        if (PageEvent != null)
            PageEvent(sender, args);

        pnlBase.UpdateAfterCallBack = true;
    }
    #endregion btn_Click

    private void Permissions()
    {
        btnSave.Visible = true;
        btnSave.UpdateAfterCallBack = true;
        btnDelete.Visible = true;
        btnDelete.UpdateAfterCallBack = true;
        btnNew.Visible = true;
        btnNew.UpdateAfterCallBack = true;
        btnList.Visible = true;
        btnList.UpdateAfterCallBack = true;
        btnPrint.Visible = true;
        btnPrint.UpdateAfterCallBack = true;
        btnEmail.Visible = true;
        btnEmail.UpdateAfterCallBack = true;

        //Usuario usuario;
        //usuario = new Usuario();
        //Entity_Usuarios obj;
        //obj = new Entity_Usuarios();

        //obj.StrUsuario = Contabilidad.SEMSession.GetInstance.StrUsuario;
        //obj.IntMenu = Convert.ToInt32(Request.QueryString["page"].ToString());

        //DataTable dt;
        //dt = usuario.Permissions(obj);

        //foreach (DataRow dr in dt.Rows)
        //{
        //    string funcion = dr["strFuncion"].ToString();
        //    switch (funcion)
        //    {
        //        case "btnSave":
        //            btnSave.Visible = true;
        //            btnSave.UpdateAfterCallBack = true;
        //            break;
        //        case "btnDelete":
        //            btnDelete.Visible = true;
        //            btnDelete.UpdateAfterCallBack = true;
        //            break;
        //        case "btnNew":
        //            btnNew.Visible = true;
        //            btnNew.UpdateAfterCallBack = true;
        //            break;
        //        case "btnList":
        //            btnList.Visible = true;
        //            btnList.UpdateAfterCallBack = true;
        //            break;
        //        case "btnPrint":
        //            btnPrint.Visible = true;
        //            btnPrint.UpdateAfterCallBack = true;
        //            break;
        //        case "btnEmail":
        //            btnEmail.Visible = true;
        //            btnEmail.UpdateAfterCallBack = true;
        //            break;
        //        case "btnPreview":
        //            //btnPreview.Visible = true;
        //            //btnPreview.UpdateAfterCallBack = true;
        //            break;
        //    }
        //}

        //usuario = null;
        //obj = null;
    }

    public void New(Boolean visible)
    {
        btnNew.Visible = visible;
        btnNew.UpdateAfterCallBack = true;
    }

    public void Email(Boolean visible)
    {
        btnEmail.Visible = visible;
        btnEmail.UpdateAfterCallBack = true;
    }

    public void List(Boolean visible)
    {
        btnList.Visible = visible;
        btnList.UpdateAfterCallBack = true;
    }

    public void Delete(Boolean visible)
    {
        btnDelete.Visible = visible;
        btnDelete.UpdateAfterCallBack = true;
    }

    public void Print(Boolean visible)
    {
        btnPrint.Visible = visible;
        btnPrint.UpdateAfterCallBack = true;
    }

    public void Save(Boolean visible)
    {
        btnSave.Visible = visible;
        btnSave.UpdateAfterCallBack = true;
    }

    public void Exportar(Boolean visible)
    {
        btnExcel.Visible = visible;
        btnExcel.UpdateAfterCallBack = true;
    }

    public void PrintValid()
    {
        btnPrint.Attributes.Add("onClick", "return validPrint();");
        btnPrint.UpdateAfterCallBack = true;
    }

    public void DeleteValid()
    {
        btnDelete.Attributes.Add("onClick", "return validDelete();");
        btnDelete.UpdateAfterCallBack = true;
    }

    public void ListPostBack()
    {
        btnList.Attributes.Add("onClick", "document.forms[0].submit();");
        btnList.UpdateAfterCallBack = true;
    }

    public void ListPostBACK(Boolean visible)
    {
        btnListPostback.Visible = visible;
    }

    protected void btn_Clickpostback(object sender, ImageClickEventArgs e)
    {
        ImageButton btn = (ImageButton)sender;
        HandlerArgs args = new HandlerArgs();
        switch (btn.CommandName)
        {
            case "Save":
                args.Event = Event.Save;
                break;
            case "Delete":
                args.Event = Event.Delete;
                break;
            case "New":
                args.Event = Event.New;
                break;
            case "List":
                args.Event = Event.List;
                break;
            case "Email":
                args.Event = Event.Email;
                break;
            case "Print":
                args.Event = Event.Print;
                break;
            case "Export":
                args.Event = Event.Export;
                break;
            default:
                break;

        }

        if (PageEvent != null)
            PageEvent(sender, args);
    }
}
