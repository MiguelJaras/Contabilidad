using System;
using System.Data;
using System.Collections;
using Contabilidad.DataAccess;
using Contabilidad.Entity;

namespace Contabilidad.Bussines
{
    public class EstadosFinRubros
    {
        #region Save
        public DataTable GetList(Entity_EstadosFinRubros obj)
        {
            return DACEstadosFinRubros.GetList(obj);
        }
        #endregion

        #region Save
        public string Save(Entity_EstadosFinRubros obj)
        {
            return DACEstadosFinRubros.Save(obj);
        }
        #endregion

        #region Delete
        public string Delete(Entity_EstadosFinRubros obj)
        {
            return DACEstadosFinRubros.Delete(obj);
        }
        #endregion

        #region Delete
        public Entity_EstadosFinRubros Fill(Entity_EstadosFinRubros obj)
        {
            return DACEstadosFinRubros.Fill(obj);
        }
        #endregion

    }
}
