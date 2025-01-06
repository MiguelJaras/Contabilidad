using System;
using System.Data;
using System.Collections;
using System.Collections.Specialized;
using Contabilidad.DataAccess;
using Contabilidad.Entity;

namespace Contabilidad.Bussines
{
    public class Sector
    {
        #region GetList
        public DataTable GetListByColonia(int intColonia)
        {
            return DACSector.GetListByColonia(intColonia);
        }
        #endregion

        #region Retrive
        public DataTable Retrive(Entity_Sector entSector)
        {
            return DACSector.Retrive(entSector);
        }
        #endregion

        #region DataXColonia
        public DataTable DataXColonia(Entity_Sector sector)
        {
            return DACSector.DataXColonia(sector);
        }
        #endregion DataXColonia

        #region Fill
        public Entity_Sector Fill(Entity_Sector entSector)
        {
            return DACSector.Fill(entSector);
        }
        #endregion


        public bool Save(Entity_Sector sector)
        {
            return DACSector.Save(sector);
        }

        public bool Delete(Entity_Sector obj)
        {
            return DACSector.Delete(obj);
        }

        public string Clave(Entity_Sector obj)
        {
            return DACSector.Clave(obj);
        }

        public Entity_Sector FillCve(Entity_Sector entSector)
        {
            return DACSector.FillCve(entSector);
        }
    }
}
