using System;
using System.Data;
using System.Collections;
using System.Collections.Specialized;
using Contabilidad.DataAccess;
using Contabilidad.Entity;

namespace Contabilidad.Bussines
{
    public class GenerarNC
    {
        #region Save
        public string Save(Entity_GenerarNC obj)
        {
            return DACGenerarNC.Save(obj);
        }
        #endregion   
   

        #region Fill
        public DataTable Fill(Entity_GenerarNC obj)
        {
            return DACGenerarNC.Fill(obj);
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
