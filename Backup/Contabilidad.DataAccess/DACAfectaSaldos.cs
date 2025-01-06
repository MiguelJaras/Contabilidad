using System;
using System.Data;
using System.Data.SqlClient;
using System.Collections;
using System.Collections.Specialized;
using Microsoft.ApplicationBlocks.Data;
using Contabilidad.Entity;

namespace Contabilidad.DataAccess
{
    public class DACAfectaSaldos : Base
	{
        #region GetList
        public static int GetList(Entity_AfectaSaldos obj)
        {
            int intResult = 0;

            SqlParameter[] arrPar = new SqlParameter[13];
            arrPar[0] = new SqlParameter("@intEmpresa", SqlDbType.Int);
            arrPar[0].Value = obj.intEmpresa ;
            arrPar[1] = new SqlParameter("@intProspecto", SqlDbType.Int);
            arrPar[1].Value = obj.intProspecto ;
            arrPar[2] = new SqlParameter("@strCuenta", SqlDbType.VarChar);
            arrPar[2].Value = obj.strCuenta ;
            arrPar[3] = new SqlParameter("@strSubCuenta", SqlDbType.VarChar);
            arrPar[3].Value = obj.strSubCuenta ;
            arrPar[4] = new SqlParameter("@strSubSubCuenta", SqlDbType.VarChar);
            arrPar[4].Value = obj.strSubSubCuenta ;
            arrPar[5] = new SqlParameter("@intMovto", SqlDbType.Int);
            arrPar[5].Value = obj.intMovto ;
            arrPar[6] = new SqlParameter("@intFactura", SqlDbType.VarChar);
            arrPar[6].Value = obj.intFactura ;
            arrPar[7] = new SqlParameter("@intObra", SqlDbType.Int);
            arrPar[7].Value = obj.intObra ;
            arrPar[8] = new SqlParameter("@strConcepto", SqlDbType.VarChar);
            arrPar[8].Value = obj.strConcepto ;
            arrPar[9] = new SqlParameter("@intTipoMovto", SqlDbType.Int);
            arrPar[9].Value = obj.intTipoMovto;
            arrPar[10] = new SqlParameter("@dblMonto", SqlDbType.Decimal);
            arrPar[10].Value = obj.dblMonto;
            arrPar[11] = new SqlParameter("@strUsuario", SqlDbType.VarChar);
            arrPar[11].Value = obj.strUsuario;
            arrPar[12] = new SqlParameter("@strMaquina", SqlDbType.VarChar);
            arrPar[12].Value = obj.strMaquina;

            try
            {
                intResult = SqlHelper.ExecuteNonQuery(ConnectionString, CommandType.StoredProcedure, "usp_tbTempAfectaSaldos_Save", arrPar);
            }
            catch (Exception e)
            {
                throw e;
            }

            return intResult;
        }
        #endregion

        #region CteAfecSaldo
        public static string  CteAfecSaldo(DateTime datFechaPoliza)
        {
            string result = "";

            SqlParameter[] arrPar = new SqlParameter[1];
            arrPar[0] = new SqlParameter("@datFechaPoliza", SqlDbType.DateTime);
            arrPar[0].Value = datFechaPoliza;

            try
            {
                result = SqlHelper.ExecuteScalar(ConnectionString, CommandType.StoredProcedure, "usp_tbClientes_AfectarSaldos", arrPar).ToString();
                //result = SqlHelper.ExecuteScalar(ConnectionString, CommandType.StoredProcedure, "VetecMarfilAdmin..usp_tbPolizasEnc_AfectaPoliza", arrPar).ToString();
                 
            }
            catch (Exception e)
            {
                throw e;
            }

            return result;
        }
        #endregion
    }
}
