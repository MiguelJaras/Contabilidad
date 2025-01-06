using System;
using System.Collections.Generic;
using System.Text;
using Microsoft.ApplicationBlocks.Data;
using System.Data;
using System.Data.SqlClient;
using Contabilidad.Entity;

namespace Contabilidad.DataAccess
{
    public class DACExcelPruebas : Base
    {
        public static string Save(string strNombre, string strApellidoPaterno, string strApellidoMaterno, string strNombreCompleto) 
        {
            string result;

            SqlParameter[] arrPar = new SqlParameter[4];
            arrPar[0] = new SqlParameter("@strNombre", SqlDbType.VarChar);
            arrPar[0].Value = strNombre;
            arrPar[1] = new SqlParameter("@strApellidoPaterno", SqlDbType.VarChar);
            arrPar[1].Value = strApellidoPaterno;
            arrPar[2] = new SqlParameter("@strApellidoMaterno", SqlDbType.VarChar);
            arrPar[2].Value = strApellidoMaterno;
            arrPar[3] = new SqlParameter("@strNombreCompleto", SqlDbType.VarChar);
            arrPar[3].Value = strNombreCompleto;
           
            try
            {
            
                result = SqlHelper.ExecuteScalar(ConnectionString, CommandType.StoredProcedure, "vetecmarfil..usp_tbClientes_ListaNegra_Save", arrPar).ToString();
            
            }
            catch (Exception e)
            {
                throw e;
            }
            return result;

        }
    }
}
