using System;
using System.Data;
using System.Collections;
using Contabilidad.DataAccess;
using Contabilidad.Entity;

namespace Contabilidad.Bussines
{
    public class TipoMovimiento
    {
        #region Fill
        public Entity_TipoMovimiento Fill(Entity_TipoMovimiento obj)
        {
            return DACTipoMovimiento.Fill(obj);
        }
        #endregion  
    
        #region GetByNC
        public Entity_TipoMovimiento GetByNC(Entity_TipoMovimiento obj)
        {
            return DACTipoMovimiento.GetByNC(obj);
        }
        #endregion 

        #region Sel
        public Entity_TipoMovimiento Sel(Entity_TipoMovimiento obj)
        {
            return DACTipoMovimiento.Sel (obj);
        }
        #endregion

        #region Save
        public string Save(Entity_TipoMovimiento obj)
        {
            return DACTipoMovimiento.Save(obj);
        }
        #endregion

        #region Delete
        public  string Delete(Entity_TipoMovimiento obj)
        {
            return DACTipoMovimiento.Delete(obj);
        }
        #endregion

        #region Inc
        public string Inc(Entity_TipoMovimiento obj)
        {
            return DACTipoMovimiento.Inc(obj);
        }
        #endregion
    }
}
