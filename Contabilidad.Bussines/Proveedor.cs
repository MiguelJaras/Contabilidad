using System;
using System.Data;
using System.Collections;
using Contabilidad.DataAccess;
using Contabilidad.Entity;

namespace Contabilidad.Bussines
{
    public class Proveedor
    {
        #region GetList
        public DataTable GetList(Entity_Proveedor obj)
        {
            return DACProveedor.GetList(obj);
        }
        #endregion

        #region Fill
        public Entity_Proveedor Fill(Entity_Proveedor obj)
        {
            return DACProveedor.Fill(obj);
        }
        #endregion   
    
        #region Sel
        public DataTable  Sel(Entity_Proveedor obj)
        {
            return DACProveedor.Sel(obj);
        }
        #endregion   
    
        #region UpdateMail
        public bool UpdateMail(Entity_Proveedor obj)
        {
            return DACProveedor.UpdateMail(obj);
        }
        #endregion
       
    }
}
