using System;
using System.Collections.Generic;
using System.Text;
using Microsoft.ApplicationBlocks.Data;
using System.Data;
using System.Data.SqlClient;
using Contabilidad.Entity;

namespace Contabilidad.DataAccess
{
    public class DACParametros : Base
    {
        #region GetHost
        public static DataTable GetHost()
        {
            DataTable dt = new DataTable();
            try
            {
                DataSet ds = SqlHelper.ExecuteDataset(ConnectionString, CommandType.Text, "SELECT STRVALOR, STRVALOR2 FROM VetecMarfil.dbo.fn_tbParametros_Values(1)");
                dt = ds.Tables[0];
            }
            catch
            {

            }
            return dt;
        }
        #endregion


        #region Get
        public static Entity_Parametros Get(Entity_Parametros obj)
        {
            Entity_Parametros entParametro = new Entity_Parametros();

            SqlParameter[] arrPar = new SqlParameter[1];
            arrPar[0] = new SqlParameter("@intParametro", SqlDbType.Int);
            arrPar[0].Value = obj.intParametro;

            try
            {
                IDataReader dr = SqlHelper.ExecuteReader(ConnectionString, CommandType.StoredProcedure, "usp_tbParametrosSel", arrPar);
                if (dr.Read())
                {
                    entParametro = CreateObject(dr);
                }
            }
            catch
            {

            }
            return entParametro;
        }
        #endregion

        #region Create
        static Entity_Parametros CreateObject(IDataReader drd)
        {
            Entity_Parametros oEnt = new Entity_Parametros();
            oEnt.intParametro = (int)drd["intParametro"];
            oEnt.strNombre = (string)drd["strNombre"];
            oEnt.strValor = (string)drd["strValor"];
            return oEnt;
        }
        #endregion
    }
}
