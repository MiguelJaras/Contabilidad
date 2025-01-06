using System;
using System.Data;
using System.Collections;
using Contabilidad.DataAccess;
using Contabilidad.Entity;

namespace Contabilidad.Bussines
{
    public class EdoFinancieros
    {
        #region Save
        public string  Save(Entity_EdoFinancieros  obj)
        {
            return DACEdoFinancieros.Save(obj);
        }
        #endregion  

        #region Delete
        public string Delete(Entity_EdoFinancieros obj)
        {
            return DACEdoFinancieros.Delete(obj);
        }
        #endregion  

        #region Delete
        public Entity_EdoFinancieros Fill(Entity_EdoFinancieros obj)
        {
            return DACEdoFinancieros.Fill(obj);
        }
        #endregion 

    }
}
