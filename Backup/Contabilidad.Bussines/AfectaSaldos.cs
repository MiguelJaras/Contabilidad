using System;
using System.Data;
using System.Collections;
using System.Collections.Specialized;
using Contabilidad.DataAccess;
using Contabilidad.Entity;

namespace Contabilidad.Bussines
{
    public class AfectaSaldos
    {
        #region GetList
        public int GetList(Entity_AfectaSaldos obj)
        {
            return DACAfectaSaldos.GetList(obj);
        }
        #endregion 

        #region CteAfecSaldo
        public string CteAfecSaldo(DateTime datFechaPoliza)
        {
            return DACAfectaSaldos.CteAfecSaldo(datFechaPoliza);
        }
        #endregion 
    }
}
