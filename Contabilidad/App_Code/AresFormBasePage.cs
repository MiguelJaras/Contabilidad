using System;
using System.Collections.Generic;
using System.Text;
using System.Web.Security;
using System.Web.UI;
using System.Configuration;
using System.Web;

public class AresFormBasePage : System.Web.UI.Page
{        
        protected override void OnLoad(EventArgs e)
        {
            string rawTypeAuthenticacion;
            string[] sUsrIdentity;

            sUsrIdentity = this.Context.User.Identity.Name.Split('|');

            rawTypeAuthenticacion = sUsrIdentity[0];
           
            sUsrIdentity = null;
            

            base.OnLoad(e);
            
            AresPageLoad();
        }

        bool _currentUserIsEmployee;
        public bool currentUserIsEmployee
        {
            get { return _currentUserIsEmployee; }
            set { _currentUserIsEmployee = value; }
        }

        public void RedirectUserInvalid()
        {
            FormsAuthentication.SignOut();
            Response.Redirect("~/login/UserDeny.aspx");
        }

        public void DenyPageUser()
        {
            Response.Redirect("~/pages/DenyPage.aspx", true);
        }

        public void LogOut()
        {
            FormsAuthentication.SignOut();
            Response.Redirect("~/login/LogOut.aspx", true);
        }       

        bool _BreakAction = false;

        public bool BreakAction
        {
            get { return _BreakAction; }
            set { _BreakAction = value; }
        }

        public virtual void AresPageLoad()
        {
           
        }

        public void Message(string text)
        {
            Anthem.Manager.Register(this.Page); 
            Anthem.Manager.AddScriptForClientSideEval("Message('" + text + "')");
        }

        public string CurrentAction
        {
            get
            {
                if (ViewState["Action"] == null) return "";
                return (string)ViewState["Action"];
            }
            set { ViewState["Action"] = value; }
        }

        public string CurrentStatus
        {
            get
            {
                if (ViewState["Status"] == null) return "";
                return (string)ViewState["Status"];
            }
            set { ViewState["Status"] = value; }
        }

        public string PreviousAction
        {
            get
            {
                if (ViewState["PreviousAction"] == null) return "";
                return (string)ViewState["PreviousAction"];
            }
            set { ViewState["PreviousAction"] = value; }
        }

        public string PreviousStatus
        {
            get
            {
                if (ViewState["PreviousStatus"] == null) return "";
                return (string)ViewState["PreviousStatus"];
            }
            set { ViewState["PreviousStatus"] = value; }
        }                             
}
