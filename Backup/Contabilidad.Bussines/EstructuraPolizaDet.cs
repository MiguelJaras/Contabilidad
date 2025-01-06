using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using Contabilidad.Entity;
using Contabilidad.DataAccess;

namespace Contabilidad.Bussines
{
    public class EstructuraPolizaDet
    {
        #region Variables

        int _ReturnValue;
        public int ReturnValue
        {
            get { return _ReturnValue; }
            set { _ReturnValue = value; }
        }
        #endregion Variables

        #region GetList
        public DataTable GetList(Entity_EstructuraPolizaDet obj)
        {
            return DACEstructuraPolizaDet.GetList(obj);
        }
        #endregion

        #region GetByPrimaryKey
        public Entity_EstructuraPolizaDet GetByPrimaryKey(Entity_EstructuraPolizaDet obj)
        {
            return DACEstructuraPolizaDet.GetByPrimaryKey(obj);
        }
        #endregion

        #region Save
        public string Save(Entity_EstructuraPolizaDet obj)
        {
            return DACEstructuraPolizaDet.Save(obj);
        }
        #endregion

        #region Delete
        public bool Delete(Entity_EstructuraPolizaDet obj)
        {
            return DACEstructuraPolizaDet.Delete(obj);
        }

        #endregion Delete 
    }
}
