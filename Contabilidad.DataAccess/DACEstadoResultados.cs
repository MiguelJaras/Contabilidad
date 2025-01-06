/*
'===============================================================================
'  Company: IASD
'  Autor: Ingrid Alexis Soto Dimas
'  Date: 2013-08-19
'  **** Generated by MyGeneration Version # (1.3.0.3) ****
'===============================================================================
*/

using System;
using System.Data;
using System.Data.SqlClient;
using System.Collections;
using System.Collections.Specialized;
using Microsoft.ApplicationBlocks.Data;
using Contabilidad.Entity;

namespace Contabilidad.DataAccess
{
    public class DACEstadoResultados : Base
    {
        #region GetList
        public static DataTable GetList(int intEmpresa, string ObraIni, string ObraFin)
        {
            DataSet ds;

            SqlParameter[] arrPar = new SqlParameter[3];
            arrPar[0] = new SqlParameter("@intEmpresa", SqlDbType.Int);
            arrPar[0].Value = intEmpresa;
            arrPar[1] = new SqlParameter("@ObraIni", SqlDbType.VarChar );
            arrPar[1].Value = ObraIni;
            arrPar[2] = new SqlParameter("@ObraFin", SqlDbType.VarChar );
            arrPar[2].Value = ObraFin;
            try
            {
                ds = SqlHelper.ExecuteDataset(ConnectionString, CommandType.StoredProcedure, "VetecMarfilAdmin..usp_SizeObra", arrPar);
                return ds.Tables[0];
            }
            catch (Exception e)
            {
                return null;
            }
        }
        #endregion
  

         #region EstadoResuldatosList
        public static DataTable EstadoResuldatosList(Entity_Obra obj)
        {
            DataSet ds;

            SqlParameter[] arrPar = new SqlParameter[7];
            arrPar[0] = new SqlParameter("@intEmpresa", SqlDbType.Int);
            arrPar[0].Value = obj.IntEmpresa;
            arrPar[1] = new SqlParameter("@intEstadoFin", SqlDbType.Int);
            arrPar[1].Value = 5;
            arrPar[2] = new SqlParameter("@datFechaIni", SqlDbType.VarChar);
            arrPar[2].Value = obj.StrFechaInicial;
            arrPar[3] = new SqlParameter("@datFechaFin", SqlDbType.VarChar);
            arrPar[3].Value = obj.StrFechaFinal;
            arrPar[4] = new SqlParameter("@strCCIni", SqlDbType.VarChar);
            arrPar[4].Value = obj.StrObraInicial;
            arrPar[5] = new SqlParameter("@strCCFin", SqlDbType.VarChar);
            arrPar[5].Value = obj.StrObraFinal;
            arrPar[6] = new SqlParameter("@strQuitar", SqlDbType.VarChar);
            arrPar[6].Value = obj.IntParametroInicial.ToString();
            try
            {
                ds = SqlHelper.ExecuteDataset(ConnectionString, CommandType.StoredProcedure, "VetecMarfilAdmin..usp_tbPolizasDet_EstadoResultados", arrPar);
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
