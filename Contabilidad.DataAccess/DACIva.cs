using System;
using System.Data;
using System.Data.SqlClient;
using System.Collections;
using System.Collections.Specialized;
using Microsoft.ApplicationBlocks.Data;
using Contabilidad.Entity;

namespace Contabilidad.DataAccess
{
    public class DACIva : Base
    {

        #region Calcula
        public static bool Calcula(Entity_Iva obj)
        {

            bool bResult = false;

            SqlParameter[] arrPar = new SqlParameter[8];

            arrPar[0] = new SqlParameter("@intEmpresa", SqlDbType.Int);
            arrPar[0].Value = obj.intEmpresa;
            arrPar[1] = new SqlParameter("@intCuentaBancaria", SqlDbType.Int );
            arrPar[1].Value = obj.intCuentaBancaria;
            arrPar[2] = new SqlParameter("@intSistema", SqlDbType.Int );
            arrPar[2].Value = 0;
            arrPar[3] = new SqlParameter("@intEjercicio", SqlDbType.Int );
            arrPar[3].Value = obj.intEjercicio;
            arrPar[4] = new SqlParameter("@intMes", SqlDbType.Int );
            arrPar[4].Value = obj.intMes;
            arrPar[5] = new SqlParameter("@datFechaProceso", SqlDbType.DateTime);
            arrPar[5].Value = obj.datFecha;
            arrPar[6] = new SqlParameter("@strUsuario", SqlDbType.VarChar);
            arrPar[6].Value = obj.StrUsuario;
            arrPar[7] = new SqlParameter("@strMaquina", SqlDbType.VarChar);
            arrPar[7].Value = obj.StrMaquina;


            try
            {
                SqlHelper.ExecuteNonQuery(ConnectionString, CommandType.StoredProcedure, "VetecMarfilAdmin..QryINCN4600_CalculoIva", arrPar);
                bResult = false;
            }
            catch (Exception e)
            {
                throw e;
            }

            return bResult;
        }

        #endregion Delete  
    
        #region IvaDesglosado
        public static bool IvaDesglosado(Entity_Iva obj)
        {

            bool bResult = false;

            SqlParameter[] arrPar = new SqlParameter[5];

            arrPar[0] = new SqlParameter("@intEmpresa", SqlDbType.Int);
            arrPar[0].Value = obj.intEmpresa;
            arrPar[1] = new SqlParameter("@intEjercicio", SqlDbType.Int);
            arrPar[1].Value = obj.intEjercicio;
            arrPar[2] = new SqlParameter("@intMes", SqlDbType.Int);
            arrPar[2].Value = obj.intMes;
            arrPar[3] = new SqlParameter("@strPoliza", SqlDbType.VarChar);
            arrPar[3].Value = obj.strPoliza;
            arrPar[4] = new SqlParameter("@intCheque", SqlDbType.Int);
            arrPar[4].Value = obj.intCheque;

            try
            {
                SqlHelper.ExecuteNonQuery(ConnectionString, CommandType.StoredProcedure, "VetecMarfilAdmin..usp_tbivadesglosado_save", arrPar);
                bResult = true;
            }
            catch (Exception e)
            {
                throw e;
            }

            return bResult;
        }
        #endregion IvaDesglosado


        #region PolizaCheque
        public static string PolizaCheque(Entity_Iva obj)
        {

            string bResult = "";

            SqlParameter[] arrPar = new SqlParameter[2];

            arrPar[0] = new SqlParameter("@intEmpresa", SqlDbType.Int);
            arrPar[0].Value = obj.IntEmpresa;
            arrPar[1] = new SqlParameter("@intCheque", SqlDbType.Int);
            arrPar[1].Value = obj.intCheque;

            try
            {
                bResult = SqlHelper.ExecuteScalar(ConnectionString, CommandType.StoredProcedure, "VetecMarfilAdmin..usp_tbChequesEnc_FPol", arrPar).ToString();
            }
            catch (Exception e)
            {
                throw e;
            }

            return bResult;
        }

        #endregion PolizaCheque

    }
}
