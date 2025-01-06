using System;
using System.Data;
using System.Collections;
using System.Collections.Specialized;
using Contabilidad.DataAccess;
using Contabilidad.Entity;

namespace Contabilidad.Bussines
{
    public class Balance 
    {
        #region Fill
        public DataTable Fill(int intEmpresa, int intEstadoFin, DateTime datFechaIni, DateTime datFechaFin, string strCCIni, string strCCFin, string strQuitar)
        {
            return DACBalance.Fill(intEmpresa,intEstadoFin,datFechaIni,datFechaFin,strCCIni,strCCFin,strQuitar);
        }
        #endregion 

        #region RptQry
        public string RptQry(int intEmpresa, int intEstadoFin, int intEjercicio, int intMes)
        {
            string value = "VetecMarfilAdmin..usp_tbRubros_BalanceGeneral ";
            value = value + intEmpresa.ToString() + ",";
            value = value + intEstadoFin.ToString() + ",";
            value = value + intEjercicio.ToString () + ",";
            value = value + intMes.ToString () + ",'";
            value = value +  "0','";
            value = value +  "0'";

            return value;
        }
        #endregion

    }
}
