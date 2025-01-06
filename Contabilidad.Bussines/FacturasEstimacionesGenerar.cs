using System;
using System.Data;
using System.Collections;
using System.Collections.Specialized;
using Contabilidad.DataAccess;
using Contabilidad.Entity;


namespace Contabilidad.Bussines
{
    public class FacturasEstimacionesGenerar
    {
        public string SaveEnc(Entity_FacturasEstimacionesGenerar obj)
        {
            return DACFacturasEstimacionesGenerar.SaveEnc(obj);
        }

        public string Save(Entity_FacturasEstimacionesGenerar obj)
        {
            return DACFacturasEstimacionesGenerar.Save(obj);
        }

        public DataTable List(Entity_FacturasEstimacionesGenerar obj)
        {
            return DACFacturasEstimacionesGenerar.List(obj);
        }
    }
}
