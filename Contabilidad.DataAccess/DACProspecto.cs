using System;
using System.Data;
using System.Data.SqlClient;
using System.Collections;
using System.Collections.Specialized;
using Microsoft.ApplicationBlocks.Data;
using Contabilidad.Entity;

namespace Contabilidad.DataAccess
{
    public class DACProspecto : Base
    {
        #region ProsBitacora
        public static DataTable ProsBitacora(int intEmpresa, int intTipoVivienda, string datFechaIni, string size)
        {
            DataSet ds;

            SqlParameter[] arrPar = new SqlParameter[4];
            arrPar[0] = new SqlParameter("@intEmpresa", SqlDbType.Int);
            arrPar[0].Value = intEmpresa;
            arrPar[1] = new SqlParameter("@intTipoVivienda", SqlDbType.Int );
            arrPar[1].Value = intTipoVivienda;
            arrPar[2] = new SqlParameter("@datFechaIni", SqlDbType.VarChar);
            arrPar[2].Value = datFechaIni;
            arrPar[3] = new SqlParameter("@size", SqlDbType.VarChar );
            arrPar[3].Value = size;

            try
            {
                ds = SqlHelper.ExecuteDataset(ConnectionString, CommandType.StoredProcedure, "usp_tbProspecto_rptBitacora", arrPar);
                return ds.Tables[0];
            }
            catch (Exception e)
            {
                return null;
            }
        }
        #endregion

        #region Sel
        public static DataTable Sel(Entity_Prospectos obj)
        {
            DataSet ds;

            SqlParameter[] arrPar = new SqlParameter[1];
            arrPar[0] = new SqlParameter("@intProspecto", SqlDbType.Int);
            arrPar[0].Value = obj.intProspecto;

            try
            {
                ds = SqlHelper.ExecuteDataset(ConnectionString, CommandType.StoredProcedure, "VetecMarfilAdmin..usp_tbProspecto_Sel", arrPar);
                return ds.Tables[0];
            }
            catch (Exception e)
            {
                return null;
            }
        }
        #endregion

        #region UpdateTerreno
        public static string UpdateTerreno(Entity_Prospectos obj)
        {
            DataSet ds;
            string result;

            SqlParameter[] arrPar = new SqlParameter[2];
            arrPar[0] = new SqlParameter("@intProspecto", SqlDbType.Int);
            arrPar[0].Value = obj.intProspecto;
            arrPar[1] = new SqlParameter("@intEmpresaTerreno", SqlDbType.Int);
            arrPar[1].Value = obj.intEmpresa;

            try
            {
                result = SqlHelper.ExecuteScalar(ConnectionString, CommandType.StoredProcedure, "usp_tbProspecto_UpdateTerreno", arrPar).ToString() ;
            }
            catch (Exception e)
            {
                return null;
            }

            return result;
        }
        #endregion

        #region EscList
        public static DataTable EscList(Entity_Prospectos obj)
        {
            DataSet ds;

            SqlParameter[] arrPar = new SqlParameter[8];
            arrPar[0] = new SqlParameter("@intEmpresa", SqlDbType.Int);
            arrPar[0].Value = obj.intEmpresa;
            arrPar[1] = new SqlParameter("@intSucursal", SqlDbType.Int);
            arrPar[1].Value = obj.intSucursal;
            arrPar[2] = new SqlParameter("@intColonia", SqlDbType.Int);
            arrPar[2].Value = obj.intColonia;
            arrPar[3] = new SqlParameter("@intDireccion", SqlDbType.VarChar);
            arrPar[3].Value = obj.IntParametroInicial;
            arrPar[4] = new SqlParameter("@SortExpression", SqlDbType.VarChar);
            arrPar[4].Value = obj.SortExpression;
            arrPar[5] = new SqlParameter("@bAplicado", SqlDbType.Int);
            arrPar[5].Value = obj.IntParametroFinal;
            arrPar[6] = new SqlParameter("@intEjercicio", SqlDbType.Int);
            arrPar[6].Value = obj.IntProveedorInicial;
            arrPar[7] = new SqlParameter("@intMes", SqlDbType.Int);
            arrPar[7].Value = obj.IntProveedorFinal;


            try
            {
                ds = SqlHelper.ExecuteDataset(ConnectionString, CommandType.StoredProcedure, "usp_tbProspecto_EscList", arrPar);
                return ds.Tables[0];
            }
            catch (Exception e)
            {
                return null;
            }
        }
        #endregion

        #region EscSave
        public static bool EscSave(Entity_Prospectos obj)
        {
            bool bResult = false;

            SqlParameter[] arrPar = new SqlParameter[4];
            arrPar[0] = new SqlParameter("@intProspecto", SqlDbType.Int);
            arrPar[0].Value = obj.intProspecto;
            arrPar[1] = new SqlParameter("@datFecha", SqlDbType.DateTime);
            arrPar[1].Value = obj.datFechaVisita;
            arrPar[2] = new SqlParameter("@strUsuario", SqlDbType.VarChar);
            arrPar[2].Value = obj.StrUsuario;
            arrPar[3] = new SqlParameter("@strMaquina", SqlDbType.VarChar);
            arrPar[3].Value = obj.StrMaquina;

            try
            {
                SqlHelper.ExecuteNonQuery(ConnectionString, CommandType.StoredProcedure, "usp_tbProspecto_EscSave", arrPar);
                bResult = false;
            }
            catch (Exception e)
            {
                throw e;
            }

            return bResult;
        }

        #endregion EscSave 

        #region EscDesaplicar
        public static bool EscDesaplicar(Entity_Prospectos obj)
        {
            bool bResult = false;

            SqlParameter[] arrPar = new SqlParameter[3];

            arrPar[0] = new SqlParameter("@intProspecto", SqlDbType.Int);
            arrPar[0].Value = obj.intProspecto;
            arrPar[1] = new SqlParameter("@strUsuario", SqlDbType.VarChar);
            arrPar[1].Value = obj.StrUsuario;
            arrPar[2] = new SqlParameter("@strMaquina", SqlDbType.VarChar);
            arrPar[2].Value = obj.StrMaquina;

            try
            {
                SqlHelper.ExecuteNonQuery(ConnectionString, CommandType.StoredProcedure, "usp_tbProspecto_EscDesaplicar", arrPar);
                bResult = false;
            }
            catch (Exception e)
            {
                throw e;
            }

            return bResult;
        }

        #endregion EscDesaplicar
    }
}
