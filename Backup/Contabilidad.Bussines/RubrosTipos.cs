using System;
using System.Data;
using System.Collections;
using Contabilidad.DataAccess;
using Contabilidad.Entity;

namespace Contabilidad.Bussines
{
    public class RubrosTipos
    {
        #region Fill
        public Entity_RubrosTipos Fill(Entity_RubrosTipos obj)
        {
            return DACRubrosTipos.Fill(obj);
        }
        #endregion

    }
}
