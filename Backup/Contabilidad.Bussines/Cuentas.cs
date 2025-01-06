using System;
using System.Data;
using System.Collections;
using System.Collections.Specialized;
using Contabilidad.DataAccess;
using Contabilidad.Entity;

namespace Contabilidad.Bussines
{
    public class Cuentas
    {
        #region Variables

        int _ReturnValue;
        public int ReturnValue
        {
            get { return _ReturnValue; }
            set { _ReturnValue = value; }
        }
        #endregion Variables

        #region fn_tbCuentas_SubSubCuentas
        public DataTable fn_tbCuentas_SubSubCuentas(int intEmpresa, string cta, string subCta, string subSubCta) 
        {
            return DACCuentas.fn_tbCuentas_SubSubCuentas(intEmpresa, cta, subCta, subSubCta);
        }
        #endregion fn_tbCuentas_SubSubCuentas

        #region GetList
        public DataTable GetList(Entity_Cuentas obj)
        {
            return DACCuentas.GetList(obj);
        }
        #endregion

        #region GetByPrimaryKey
        public Entity_Cuentas GetByPrimaryKey(Entity_Cuentas obj)
        {
            return DACCuentas.GetByPrimaryKey(obj);
        }
        #endregion

        #region Save
        public string Save(Entity_Cuentas obj)
        {
            return DACCuentas.Save(obj);
        }
        #endregion

        #region Delete
        public bool Delete(Entity_Cuentas obj)
        {
            return DACCuentas.Delete(obj);
        }

        #endregion Delete 

        #region GetMaxCuenta
        public string GetMaxCuenta(Entity_Cuentas obj)
        {
            return DACCuentas.GetMaxCuenta(obj);
        }
        #endregion

        public string ExisteCuenta(Entity_Cuentas obj)
        {
            return DACCuentas.ExisteCuenta(obj);
        }

    }
}
