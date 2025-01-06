using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using Contabilidad.DataAccess;
using Contabilidad.Entity;

namespace Contabilidad.Bussines
{
    public class Parametros
    {
        #region GetHost
        public DataTable GetHost()
        {
            return DACParametros.GetHost();
        }
        #endregion


        #region Get
        public Entity_Parametros Get(int intParametro)
        {
            Entity_Parametros entParametros = new Entity_Parametros();
            entParametros.intParametro = intParametro;
            return DACParametros.Get(entParametros);
        }

        #endregion

    }
}
