using System;
using System.Data;
using System.Collections;
using Contabilidad.DataAccess;
using Contabilidad.Entity;

namespace Contabilidad.Bussines
{
    public class RubrosCuentas
    {
        #region Save
        public string  Save(Entity_RubrosCuentas obj)
        {
            return DACRubrosCuentas.Save(obj);
        }
        #endregion  

        #region Delete
        public string Delete(Entity_RubrosCuentas obj)
        {
            return DACRubrosCuentas.Delete(obj);
        }
        #endregion  

        #region Fill
        public Entity_RubrosCuentas Fill(Entity_RubrosCuentas obj)
        {
            return DACRubrosCuentas.Fill(obj);
        }
        #endregion  

        #region Sel
        public DataTable Sel(Entity_RubrosCuentas obj)
        {
            return DACRubrosCuentas.Sel(obj);
        }
        #endregion  
    }
}
