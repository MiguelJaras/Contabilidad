using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;

 public partial class ControlctrlHeader : System.Web.UI.UserControl
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
                BindHeader();
        }

        public void BindHeader()
        {
            this.lblFullName.Text = Contabilidad.SEMSession.GetInstance.Nombre;
            this.lblEmpresa.Text = Contabilidad.SEMSession.GetInstance.Empresa;
        }

        protected void LnkLogoff_Click(object sender, EventArgs e)
        {
            FormsAuthentication.SignOut();
            Context.Response.Cookies[FormsAuthentication.FormsCookieName].Expires = DateTime.Now;
            Response.Cache.SetCacheability(HttpCacheability.NoCache);
            Session.RemoveAll();
            Session.Abandon();

            FormsAuthentication.RedirectToLoginPage();
            Request.Cookies[FormsAuthentication.FormsCookieName].Expires = DateTime.Now;
        }       

    }
