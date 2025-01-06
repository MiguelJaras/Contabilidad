using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;

namespace Contabilidad
{
    public class SEMSession
    {
        private const string InstaceName = "_SEMSession";

        private string strUsuario;
        private string nombre;
        private Int32 perfil;
        private string nombrePerfil;
        private Int32 intEmpresa;
        private Int32 intSucursal;
        private string strMaquina;
        private string empresa;

        private SEMSession(String[] Values)
        {           
            strUsuario = Values[0];
            nombre = Values[1];
            perfil = Convert.ToInt32(Values[2]);
            nombrePerfil = Values[3];
            intEmpresa = Convert.ToInt32(Values[4]);
            intSucursal = Convert.ToInt32(Values[5]);
            strMaquina = Values[6];
            empresa = Values[7];
        }

        public static SEMSession GetInstance
        {
            get
            {
                SEMSession SEMSession = (SEMSession)HttpContext.Current.Items[InstaceName];

                if (SEMSession == null)
                {
                    SEMSession = new SEMSession(HttpContext.Current.User.Identity.Name.Split('|'));
                    HttpContext.Current.Items.Add(InstaceName, SEMSession);
                }
                return SEMSession;
            }
        }

        public string StrUsuario
        {
            get { return strUsuario; }
            set { strUsuario = value; }
        }

        public string Nombre
        {
            get { return nombre; }
            set { nombre = value; }
        }

        public Int32 Perfil
        {
            get { return perfil; }
            set { perfil = value; }
        }
        public string NombrePerfil
        {
            get { return nombrePerfil; }
            set { nombrePerfil = value; }
        }

        public Int32 IntEmpresa
        {
            get { return intEmpresa; }
            set { intEmpresa = value; }
        }

        public Int32 IntSucursal
        {
            get { return intSucursal; }
            set { intSucursal = value; }
        }

        public string StrMaquina
        {
            get { return strMaquina; }
            set { strMaquina = value; }
        }

        public string Empresa
        {
            get { return empresa; }
            set { empresa = value; }
        }
    }
}