using System;
using System.Data;
using System.Collections;
using Contabilidad.DataAccess;
using Contabilidad.Entity;

namespace Contabilidad.Bussines
{
    public class Empresa
    {
        #region GetList
        public DataTable GetList()
        {
            return DACEmpresa.GetList();
        }
        #endregion

        #region GetSucursal
        public string GetSucursal(string intEmpresa)
        {
            return DACEmpresa.GetSucursal(intEmpresa);
        }
        #endregion 
        
        #region Fill
        public Entity_Empresa Fill(int intEmpresa)
        {
            return DACEmpresa.Fill(intEmpresa);
        }
        #endregion

        #region Sel
        public Entity_Empresa Sel(Entity_Empresa obj)
        {
            return DACEmpresa.Sel(obj);
        }
        #endregion

        #region Save
        public string Save(Entity_Empresa obj)
        {
            return DACEmpresa.Save(obj);
        }
        #endregion
       
    }
}
