using System;
using System.Data;
using System.Collections;
using System.Collections.Specialized;
using Contabilidad.DataAccess;
using Contabilidad.Entity;

namespace Contabilidad.Bussines
{
    public class ContraRecibos
    {
        #region Save
        public string Save(Entity_ContraRecibos obj)
        {
            return DACContraRecibos.Save(obj);
        }
        #endregion   
   

        #region Fill
        public DataTable Fill(Entity_ContraRecibos obj)
        {
            return DACContraRecibos.Fill(obj);
        }
        #endregion 

        #region Delete
        public string Delete(Entity_PolizasEnc obj)
        {
            return DACPolizasEnc.Delete(obj);
        }
        #endregion 

    }
}
