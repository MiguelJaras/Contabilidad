using System;
using System.Collections.Generic;
using System.Text;
using Contabilidad.Entity;
using System.Data;
using Contabilidad.DataAccess;

namespace Contabilidad.Bussines
{
    public class EstructuraPolizaEnc
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
        public DataTable GetList(Entity_EstructuraPolizaEnc obj)
        {
            return DACEstructuraPolizaEnc.GetList(obj);
        }
        #endregion

        #region GetByPrimaryKey
        public Entity_EstructuraPolizaEnc GetByPrimaryKey(Entity_EstructuraPolizaEnc obj)
        {
            return DACEstructuraPolizaEnc.GetByPrimaryKey(obj);
        }
        #endregion

        #region Save
        public string Save(Entity_EstructuraPolizaEnc obj)
        {
            return DACEstructuraPolizaEnc.Save(obj);
        }
        #endregion

        #region Delete
        public bool Delete(Entity_EstructuraPolizaEnc obj)
        {
            return DACEstructuraPolizaEnc.Delete(obj);
        }

        #endregion Delete 
    }
}
