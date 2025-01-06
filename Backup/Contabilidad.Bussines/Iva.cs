
using System;
using System.Data;
using System.Collections;
using Contabilidad.DataAccess;
using Contabilidad.Entity;

namespace Contabilidad.Bussines
{
    public class Iva
    {

        #region IvaDesglosado
        public string IvaDesglosado(int intCuentaBancaria, string  intMes, string  intEjercicio, int intEmpresa)
        {
            string value = "usp_IVA_Analitico ";
            value = value + intEmpresa.ToString() + ",";
            value = value + intMes.ToString() + ",";
            value = value + intEjercicio.ToString() + ",";
            value = value + intCuentaBancaria.ToString();

            return value;
        }
        #endregion

        #region IvaAcreditar
        public string IvaAcreditar(int intCuentaBancaria, string intMes, string intEjercicio, int intEmpresa)
        {
            string value = "usp_IVA_Acreditar_Rep ";
            value = value + intEmpresa.ToString() + ",";
            value = value + intMes.ToString() + ",";
            value = value + intEjercicio.ToString() + ",";
            value = value + intCuentaBancaria.ToString();

            return value;
        }
        #endregion

        #region IvaAnalitico
        public string IvaAnalitico(string intMes, string intEjercicio, int intEmpresa)
        {
            string value = "VetecMarfilAdmin..usp_tbIvaDesglosado_Rpt ";
            value = value + intEmpresa.ToString() + ",";
            value = value + intEjercicio.ToString() + ",";
            value = value + intMes.ToString();

            return value;
        }
        #endregion

        public bool Calcula(Entity_Iva obj)
        {
            return DACIva.Calcula (obj);
        }

        public string PolizaCheque(Entity_Iva obj)
        {
            return DACIva.PolizaCheque (obj);
        }
  
    }
}
