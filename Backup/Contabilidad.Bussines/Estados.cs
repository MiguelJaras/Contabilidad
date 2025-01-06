using System;
using System.Collections.Generic;
using System.Text;
using Contabilidad.Entity;
using Contabilidad.DataAccess;
using System.Data;

namespace Contabilidad.Bussines
{
    public class Estados
    {
        #region Fill
        public Entity_Estados Fill(Entity_Estados obj)
        {
            return DACEstados .Fill (obj);
        }
        #endregion
    }
}
