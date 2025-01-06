using System;
using System.Data;
using System.Collections;
using Contabilidad.DataAccess;
using Contabilidad.Entity;

namespace Contabilidad.Bussines
{
    public class TempPoliza_Remplazo
    {
        #region Save
        public bool Save(Entity_TempPoliza_Remplazo obj)
        {
            return DACTempPoliza_Remplazo.Save(obj);
        }
        #endregion 
    }
}
