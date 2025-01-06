using System;
using System.Data;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;


namespace Contabilidad.Web
{
    public class WebConfigConstantsId
    {
        public const string LDAPPath = "LDAPPath";
        public const string TypeAuthentication = "TypeAuthentication";
    }

    public class WebConfigConstantsValues
    {
        public const String TypeAuthenticationActiveDirectory = "ACTIVEDIRECTORY";
        public const String TypeAuthenticationBasica = "BASICA";
    }

}
