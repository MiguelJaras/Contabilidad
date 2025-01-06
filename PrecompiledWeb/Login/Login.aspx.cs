using System;
using System.Data;
using System.Collections;
using System.Configuration;
using System.Web.UI.WebControls;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using Contabilidad.Entity;
using Contabilidad.Bussines;

   public partial class Login : System.Web.UI.Page
    {

       private Entity_Usuarios CurrentUser;

        #region Events

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                Empresas();
            }

            Anthem.Manager.Register(this);
            Anthem.Manager.RegisterStartupScript(Page.GetType(), "txtUsuario", "var objText = new VetecText('" + txtUsuario.ClientID + "', 'text', 20);", true);            
        }

      #region Empresas
        private void Empresas()
       {
           Empresa empresas = new Empresa();
           DataTable dt;

           dt = empresas.GetList();
           cboEmpresa.DataSource = dt;
           cboEmpresa.DataTextField = "strNombre";
           cboEmpresa.DataValueField = "intEmpresa";
           cboEmpresa.DataBind();

           cboEmpresa_Change(null, null);
       }
        #endregion

      protected void btnAceptar_Click(object sender, EventArgs e)
       {

           CurrentUser = GetUser();

           if (CurrentUser == null)
           {
               ClientScript.RegisterStartupScript(Page.GetType(), "msgHabib", "alert('Usuario no autorizado para ingresar a la aplicación.');", true);
               return;
           }

           if (cboEmpresa.SelectedValue == "22")
           {
               if (!(CurrentUser.StrUsuario == "432" || CurrentUser.StrUsuario == "442"))
               {
                   ClientScript.RegisterStartupScript(Page.GetType(), "msgHabib", "alert('Usuario no autorizado para esta empresa.');", true);
               }
           }

           //if (User.Identity.IsAuthenticated)
           //{
           //    FormsAuthentication.SignOut();
           //}
             
           String strUserName = "{0}|{1}|{2}|{3}|{4}|{5}|{6}|{7}";
           strUserName = String.Format(strUserName, CurrentUser.StrUsuario, CurrentUser.StrNombre, CurrentUser.IntPerfil, CurrentUser.StrNombrePerfil, cboEmpresa.SelectedValue, hddSucursal.Value, Request.ServerVariables["REMOTE_HOST"], cboEmpresa.SelectedItem.Text);
           FormsAuthentication.RedirectFromLoginPage(strUserName,false);
           string url = FormsAuthentication.GetRedirectUrl(strUserName, false);
           Response.Redirect(FormsAuthentication.DefaultUrl + (url != FormsAuthentication.DefaultUrl ? "?ReturnUrl=" + url : String.Empty));
        }
        
        #endregion Events            

        #region GetUser
        private Entity_Usuarios GetUser()
       {

           Entity_Usuarios usuario;
           usuario = new Entity_Usuarios();

           usuario.StrUsuario = txtUsuario.Text;
           usuario.StrPassword = txtContrasena.Text;

           Usuario ObjUser;
           ObjUser = new Usuario();

           usuario = ObjUser.Login(usuario);

           ObjUser = null;
           
           return usuario;
       }
        #endregion

       protected void cboEmpresa_Change(object sender, EventArgs e)
       {
           Empresa empresas = new Empresa();
           string intSucursal;

           intSucursal = empresas.GetSucursal(cboEmpresa.SelectedValue);
           hddSucursal.Value = intSucursal;

           hddSucursal.UpdateAfterCallBack = true;
       }

   }

