using System;
using System.Data;
using System.Data.SqlClient;
using System.Collections;
using System.Collections.Specialized;
using Microsoft.ApplicationBlocks.Data;
using Contabilidad.Entity;

namespace Contabilidad.DataAccess
{
    public class DACIndividualizacion:Base
    {
        #region GetList
        public static DataTable GetList(Entity_CuentasBancarias  obj)
        {
            DataSet ds;

            SqlParameter[] arrPar = new SqlParameter[5];
            arrPar[0] = new SqlParameter("@datFechaInicial", SqlDbType.VarChar);
            arrPar[0].Value = obj.StrFechaInicial;
            arrPar[1] = new SqlParameter("@datFechaFinal", SqlDbType.VarChar);
            arrPar[1].Value = obj.StrFechaFinal;
            arrPar[2] = new SqlParameter("@intColonia", SqlDbType.Int);
            arrPar[2].Value = obj.intFolio;
            arrPar[3] = new SqlParameter("@intOrder", SqlDbType.Int);
            arrPar[3].Value = obj.IntParametroInicial;
            arrPar[4] = new SqlParameter("@intSector", SqlDbType.Int);
            arrPar[4].Value = obj.IntParametroFinal;

            try
            {
                ds = SqlHelper.ExecuteDataset(ConnectionString, CommandType.StoredProcedure, "usp_tbIndividualizacion_List", arrPar);
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
