using System;
using System.Data;
using System.Collections;
using Contabilidad.DataAccess;
using Contabilidad.Entity;

namespace Contabilidad.Bussines
{
    public class Rubros
    {
        #region Save
        public string  Save(Entity_Rubros obj)
        {
            return DACRubros.Save(obj);
        }
        #endregion  

        #region Delete
        public string  Delete(Entity_Rubros obj)
        {
            return DACRubros.Delete(obj);
        }
        #endregion  

        #region Delete
        public Entity_Rubros Fill(Entity_Rubros obj)
        {
            return DACRubros.Fill(obj);
        }
        #endregion  

    }
}
