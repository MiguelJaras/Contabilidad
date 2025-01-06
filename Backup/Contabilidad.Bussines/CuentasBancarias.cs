using System;
using System.Data;
using System.Collections;
using Contabilidad.DataAccess;
using Contabilidad.Entity;

namespace Contabilidad.Bussines
{
    public class CuentasBancarias
    {


        #region Fill
        public Entity_CuentasBancarias Fill(Entity_CuentasBancarias obj)
        {
            return DACCuentasBancarias.Fill(obj);
        }
        #endregion

        #region Save
        public string Save(Entity_CuentasBancarias obj)
        {
            return DACCuentasBancarias.Save(obj);
        }
        #endregion

        #region Delete
        public bool Delete(Entity_CuentasBancarias obj)
        {
            return DACCuentasBancarias.Delete(obj);
        }

        #endregion Delete


    }
}
