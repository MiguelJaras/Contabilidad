using System;
using System.Data;
using System.Data.SqlClient;
using System.Collections;
using System.Collections.Specialized;
using Microsoft.ApplicationBlocks.Data;
using Contabilidad.Entity;

namespace Contabilidad.DataAccess
{

    public class DACFacturasGenerarComisiones : Base
    {
        #region GetList
        public static DataTable GetList(Entity_FacturasGenerarComisiones obj)
        {
            DataSet ds;

            SqlParameter[] arrPar = new SqlParameter[2];
            arrPar[0] = new SqlParameter("@intEjercicio", SqlDbType.Int);
            arrPar[0].Value = obj.intEjercicio;
            arrPar[1] = new SqlParameter("@intSemana", SqlDbType.Int);
            arrPar[1].Value = obj.intSemana;

            try
            {
                ds = SqlHelper.ExecuteDataset(ConnectionString, CommandType.StoredProcedure, "vetecmarfiladmin..usp_tbFacturasGenerarComisiones_list", arrPar);
                return ds.Tables[0];
            }
            catch (Exception e)
            {
                throw e;
            }

        }
        #endregion

        #region Save
        public static bool Save(Entity_FacturasGenerarComisiones obj)
        {
            bool intResult = false;

            SqlParameter[] arrPar = new SqlParameter[13];
            arrPar[0] = new SqlParameter("@intEjercicio", SqlDbType.Int);
            arrPar[0].Value = obj.intEjercicio;
            arrPar[1] = new SqlParameter("@intSemana", SqlDbType.Int);
            arrPar[1].Value = obj.intSemana;
            arrPar[2] = new SqlParameter("@intColonia", SqlDbType.Int);
            arrPar[2].Value = obj.intColonia;
            arrPar[3] = new SqlParameter("@intSector", SqlDbType.Int);
            arrPar[3].Value = obj.intSector;
            arrPar[4] = new SqlParameter("@intObra", SqlDbType.Int);
            arrPar[4].Value = obj.intObra;
            arrPar[5] = new SqlParameter("@decFolio", SqlDbType.Decimal);
            arrPar[5].Value = obj.decFolio;
            arrPar[6] = new SqlParameter("@strUsuarioAlta", SqlDbType.VarChar);
            arrPar[6].Value = obj.StrUsuario;
            arrPar[7] = new SqlParameter("@strMaquinaAlta", SqlDbType.VarChar);
            arrPar[7].Value = obj.StrMaquina;
            arrPar[8] = new SqlParameter("@dblImporte", SqlDbType.Decimal);
            arrPar[8].Value = obj.dblImporte;

            try
            {
                SqlHelper.ExecuteNonQuery(ConnectionString, CommandType.StoredProcedure, "vetecmarfiladmin..usp_tbFacturasGenerarComisiones_Save", arrPar);
                intResult = true;
            }
            catch (Exception e)
            {
                throw e;
            }

            return intResult;
        }
        #endregion

        public static DataTable GetAnio()
        {
            DataSet ds;

            try
            {
                ds = SqlHelper.ExecuteDataset(ConnectionString, CommandType.StoredProcedure, "vetecmarfiladmin..usp_tbSemanaNatural_ListAnio");
                return ds.Tables[0];
            }
            catch (Exception e)
            {
                throw e;
            }

        }

        public static DataTable GetSemana(int intEjercicio)
        {
            DataSet ds;

            SqlParameter[] arrPar = new SqlParameter[2];
            arrPar[0] = new SqlParameter("@intEjercicio", SqlDbType.Int);
            arrPar[0].Value = intEjercicio;

            try
            {
                ds = SqlHelper.ExecuteDataset(ConnectionString, CommandType.StoredProcedure, "vetecmarfiladmin..usp_tbSemanaNatural_ListSemana", arrPar);
                return ds.Tables[0];
            }
            catch (Exception e)
            {
                throw e;
            }

        }

        public static string GetFecha(int intSemana, int intEjercicio)
        {
            string res = "";

            SqlParameter[] arrPar = new SqlParameter[2];
            arrPar[0] = new SqlParameter("@intSemana", SqlDbType.Int);
            arrPar[0].Value = intSemana;
            arrPar[1] = new SqlParameter("@intAnio", SqlDbType.Int);
            arrPar[1].Value = intEjercicio;

            try
            {
                res = SqlHelper.ExecuteScalar(ConnectionString, CommandType.StoredProcedure, "vetecmarfiladmin..usp_tbSemanaNatural_SelFec", arrPar).ToString();
            }
            catch (Exception e)
            {
                throw e;
            }
            return res;
        }
    }
}
