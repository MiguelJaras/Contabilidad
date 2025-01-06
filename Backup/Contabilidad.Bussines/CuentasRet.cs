using System;
using System.Collections.Generic;
using System.Text;
using Contabilidad.DataAccess;
using Contabilidad.Entity;
using System.Data;

namespace Contabilidad.Bussines
{
    public class CuentasRet
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
        public DataTable GetList(Entity_CuentasRet obj)
        {
            return DACCuentasRet.GetList(obj);
        }
        #endregion  

        #region GetByPrimaryKey
        public Entity_CuentasRet GetByPrimaryKey(Entity_CuentasRet obj)
        {
            return DACCuentasRet.GetByPrimaryKey(obj);
        }
        #endregion

        #region Save
        public string Save(Entity_CuentasRet obj)
        {
            return DACCuentasRet.Save(obj);
        }
        #endregion

        #region Delete
        public bool Delete(Entity_CuentasRet obj)
        {
            return DACCuentasRet.Delete(obj);
        }

        #endregion Delete 
    }
}
