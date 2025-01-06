using System;
using System.Data;
using System.Data.SqlClient;
using System.Collections;
using System.Collections.Specialized;
using Microsoft.ApplicationBlocks.Data;
using Contabilidad.Entity;

namespace Contabilidad.DataAccess
{
    public class DACBalance : Base
    {
        #region Fill
        public static  DataTable Fill(int intEmpresa, int intEstadoFin, DateTime datFechaIni, DateTime datFechaFin, string strCCIni, string strCCFin, string strQuitar)
        {
            DataSet ds;

            SqlParameter[] arrPar = new SqlParameter[1];
            arrPar[0] = new SqlParameter("@intEmpresa", SqlDbType.Int);
            arrPar[0].Value = intEmpresa;
            arrPar[1] = new SqlParameter("@intEstadoFin", SqlDbType.Int);
            arrPar[1].Value = intEstadoFin;
            arrPar[2] = new SqlParameter("@datFechaIni", SqlDbType.DateTime );
            arrPar[2].Value = datFechaIni;
            arrPar[3] = new SqlParameter("@datFechaFin", SqlDbType.DateTime );
            arrPar[3].Value = datFechaFin;
            arrPar[4] = new SqlParameter("@strCCIni", SqlDbType.VarChar );
            arrPar[4].Value = strCCIni;
            arrPar[5] = new SqlParameter("@strCCFin", SqlDbType.VarChar );
            arrPar[5].Value = strCCFin;
            arrPar[6] = new SqlParameter("@strQuitar", SqlDbType.VarChar );
            arrPar[6].Value = strQuitar;


            try
            {
                ds = SqlHelper.ExecuteDataset(ConnectionString, CommandType.StoredProcedure, "VetecMarfilAdmin..qryINCN4070_Sel_Rep_Financieros_Obra", arrPar);
                return ds.Tables[0];
            }
            catch (Exception e)
            {
                return null;
            }
        }
        #endregion  

    }
}
