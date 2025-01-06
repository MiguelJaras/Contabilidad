using System;
using System.Data;
using System.Data.SqlClient;
using System.Collections;
using System.Collections.Specialized;
using Microsoft.ApplicationBlocks.Data;
using Contabilidad.Entity;

namespace Contabilidad.DataAccess
{
    public class DACDigBalanza : Base
    {
        #region Fill
        public static DataTable Fill(Entity_DigBalanza obj)
        {
            DataSet ds;

            SqlParameter[] arrPar = new SqlParameter[2];
            arrPar[0] = new SqlParameter("@intEmpresa", SqlDbType.Int);
            arrPar[0].Value = obj.IntEmpresa;
            arrPar[1] = new SqlParameter("@intFolio", SqlDbType.Int);
            arrPar[1].Value = obj.IntFolio;

            try
            {
                ds = SqlHelper.ExecuteDataset(ConnectionString, CommandType.StoredProcedure, "dbDigitalizacion.dbo.usp_tbDigBalanza_Fill", arrPar);
                return ds.Tables[0];
            }
            catch (Exception e)
            {
                return null;
            }
        }
        #endregion         

		#region Save
        public static string Save(Entity_DigBalanza obj)
        {
            string bResult;

            SqlParameter[] arrPar = new SqlParameter[8];
            arrPar[0] = new SqlParameter("@intEmpresa", SqlDbType.Int);
            arrPar[0].Value = obj.IntEmpresa;
            arrPar[1] = new SqlParameter("@intEjercicio", SqlDbType.Int);
            arrPar[1].Value = obj.IntEjercicio;
            arrPar[2] = new SqlParameter("@intMes", SqlDbType.Int);
            arrPar[2].Value = obj.IntMes;
            arrPar[3] = new SqlParameter("@intFolio", SqlDbType.Int);
            arrPar[3].Value = obj.IntFolio;
            arrPar[4] = new SqlParameter("@XMLFileName", SqlDbType.VarChar);
            arrPar[4].Value = obj.XMLFileName;
            arrPar[5] = new SqlParameter("@XMLFile", SqlDbType.VarBinary);
            arrPar[5].Value = obj.XMLFile;            
            arrPar[6] = new SqlParameter("@strUsuario", SqlDbType.VarChar);
            arrPar[6].Value = obj.StrUsuario;
            arrPar[7] = new SqlParameter("@strMaquina", SqlDbType.VarChar);
            arrPar[7].Value = obj.StrMaquina;
            try
            {
                bResult = SqlHelper.ExecuteScalar(ConnectionString, CommandType.StoredProcedure, "dbDigitalizacion.dbo.usp_tbDigBalanza_Save", arrPar).ToString();
            }
            catch (Exception e)
            {
                throw e;
            }

            return bResult;
        }
		#endregion		
		

	
    }
}
