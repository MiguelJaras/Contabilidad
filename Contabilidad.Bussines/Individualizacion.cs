using System;
using System.Data;
using System.Collections;
using System.Collections.Specialized;
using Contabilidad.DataAccess;
using Contabilidad.Entity;

namespace Contabilidad.Bussines
{
    public class Individualizacion
    {
       #region GetList
        public DataTable GetList(Entity_CuentasBancarias obj)
        {
            return DACIndividualizacion.GetList(obj);
        }
        #endregion
    }
}
