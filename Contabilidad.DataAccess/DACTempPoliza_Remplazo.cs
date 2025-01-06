using System;
using System.Data;
using System.Data.SqlClient;
using System.Collections;
using System.Collections.Specialized;
using Microsoft.ApplicationBlocks.Data;
using Contabilidad.Entity;

namespace Contabilidad.DataAccess
{
    public class DACTempPoliza_Remplazo : Base
    {
        #region Save
        public static bool  Save(Entity_TempPoliza_Remplazo obj)
        {
            bool bResult = false;

            SqlParameter[] arrPar = new SqlParameter[10];
            arrPar[0] = new SqlParameter("@intEmpresa", SqlDbType.Int);
            arrPar[0].Value = obj.IntEmpresa;
            arrPar[1] = new SqlParameter("@intPartida", SqlDbType.Int);
            arrPar[1].Value = obj.IntPartida;
            arrPar[2] = new SqlParameter("@strCuenta", SqlDbType.VarChar );
            arrPar[2].Value = obj.StrCuenta;
            arrPar[3] = new SqlParameter("@strAuxiliar", SqlDbType.VarChar);
            arrPar[3].Value = obj.StrAuxiliar;
            arrPar[4] = new SqlParameter("@strObra", SqlDbType.VarChar);
            arrPar[4].Value = obj.StrObra;
            arrPar[5] = new SqlParameter("@strReferencia", SqlDbType.VarChar);
            arrPar[5].Value = obj.StrReferencia;
            arrPar[6] = new SqlParameter("@dblCargos", SqlDbType.Decimal);
            arrPar[6].Value = obj.DblCargo;
            arrPar[7] = new SqlParameter("@dblAbonos", SqlDbType.Decimal);
            arrPar[7].Value = obj.DblAbono;
            arrPar[8] = new SqlParameter("@strDescricpion", SqlDbType.VarChar);
            arrPar[8].Value = obj.StrDescricpion;
            arrPar[9] = new SqlParameter("@strUsuario", SqlDbType.VarChar);
            arrPar[9].Value = obj.StrUsuario;

            try
            {
                SqlHelper.ExecuteNonQuery(ConnectionString, CommandType.StoredProcedure, "VetecMarfilAdmin..usp_TempPoliza_Remplazo_Save", arrPar);
                bResult = false;
            }
            catch (Exception e)
            {
                throw e;
            }

            return bResult;

        }
        #endregion Save
    }
}
