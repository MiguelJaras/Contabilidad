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
using Anthem;

public partial class WebControl_Toolbar_Event : System.Web.UI.UserControl
{
    public event HandlerEvent PageEvent;
    public string realPath;
    protected void Page_Load(object sender, EventArgs e)
    {        
        string end = (Request.ApplicationPath.EndsWith("/")) ? "" : "/";
        string path = Request.ApplicationPath + end;
        //string appPath = String.Format("http://{0}{1}{2}", Request.Url.Authority, path, "FinSesion.aspx?id=0Proc=" + Contabilidad.SEMSession.GetInstance.StrUsuario);

        //Response.AppendHeader("Refresh", Convert.ToString((Session.Timeout * 50)) + "; URL=" + appPath);

        if (Contabilidad.SEMSession.GetInstance.StrUsuario == null || Contabilidad.SEMSession.GetInstance.IntEmpresa == 0)
            Response.Redirect("Login.aspx");

        btnSave.Attributes.Add("onclick", "return datosCompletos();");
        btnDelete.Attributes.Add("onclick", "return confirm('¿Desea eliminar?');");
        
        btnSave.UpdateAfterCallBack = true;
        btnDelete.UpdateAfterCallBack = true;

        realPath = String.Format("http://{0}{1}{2}", Request.Url.Authority, path, "Img/bg_btn.png");
        Permissions();

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
                //lblSave.Text = "";
                //lblDelete.Text = "";
                //lblError.Text = "";
                break;
            default:
                break;
        }

        if (PageEvent != null)
            PageEvent(sender, args);

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
    
}
