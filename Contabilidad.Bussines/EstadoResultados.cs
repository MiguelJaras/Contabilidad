using System;
using System.Data;
using System.Collections;
using System.Collections.Specialized;
using Contabilidad.DataAccess;
using Contabilidad.Entity;

namespace Contabilidad.Bussines
{
    public class EstadoResultados
    {
        #region GetList
        public DataTable GetList(int intEmpresa, string ObraIni, string ObraFin)
        {
            return DACEstadoResultados.GetList(intEmpresa, ObraIni , ObraFin);
        }
        #endregion

        #region RepFinancieroObraQry
        public string RepFinancieroObraQry(int empresa, int intEstado, string datFechaIni, string datFechaFin, string strCCIni, string strCCFin, string strQuitar)
        {
            string value = "VetecMarfilAdmin..usp_tbPolizasDet_EstadoResultados ";
            value = value + empresa.ToString() + ",";
            value = value + intEstado.ToString() + ",'";
            value = value + datFechaIni + "','";
            value = value + datFechaFin + "','";
            value = value + strCCIni + "','";
            value = value + strCCFin + "','";
            value = value + strQuitar + "'";

            return value;
        }
        #endregion

        #region EstadoResuldatosList
        public DataTable EstadoResuldatosList(Entity_Obra obj)
        {
            return DACEstadoResultados.EstadoResuldatosList(obj);
        }
        #endregion
    }
}
