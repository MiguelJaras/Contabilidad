using System;
using System.Data;
using System.Collections;
using Contabilidad.DataAccess;
using Contabilidad.Entity;

namespace Contabilidad.Bussines
{
    public class Usuario
    {
        #region GetList
        public DataTable GetList(Entity_Usuarios obj)
        {
            return DACUsuario.GetList(obj);            
        }
        #endregion

        #region Fill
        public Entity_Usuarios Fill(string strUsuario)
        {
            return DACUsuario.Fill(strUsuario);
        }
        #endregion       

        #region Login
        public Entity_Usuarios Login(Entity_Usuarios obj)
        {
            return DACUsuario.Login(obj);
        }
        #endregion       

        #region Permissions
        public DataTable Permissions(Entity_Usuarios obj)
        {
            return DACUsuario.Permissions(obj);
        }
        #endregion              
       
    }
}
