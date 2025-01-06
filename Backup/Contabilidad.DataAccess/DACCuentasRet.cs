using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using Contabilidad.Entity;
using System.Data.SqlClient;
using Microsoft.ApplicationBlocks.Data;

namespace Contabilidad.DataAccess
{
    public class DACCuentasRet:Base
    { 

        #region Variables

        int _ReturnValue;
        public int ReturnValue
        {
            get { return _ReturnValue; }
            set { _ReturnValue = value; }
        }
        #endregion Variables

        #region GetList
        public static DataTable GetList(Entity_CuentasRet obj)
        {
            DataSet ds;

            SqlParameter[] arrPar = new SqlParameter[13];
            arrPar[0] = new SqlParameter("@intEmpresa", SqlDbType.Int);
            arrPar[0].Value = obj.IntEmpresa;
            //arrPar[1] = new SqlParameter("@intCuentaRet", SqlDbType.Int);
            //arrPar[1].Value = obj.IntCuentaRet;
            arrPar[1] = new SqlParameter("@intArea", SqlDbType.Int);
            arrPar[1].Value = obj.IntArea;
            arrPar[2] = new SqlParameter("@strInsumoIni", SqlDbType.VarChar);
            arrPar[2].Value = obj.StrInsumoInicial;
            arrPar[3] = new SqlParameter("@strInsumoFin", SqlDbType.VarChar);
            arrPar[3].Value = obj.StrInsumoFinal; 
            arrPar[4] = new SqlParameter("@strCuentaCargo", SqlDbType.VarChar);
            arrPar[4].Value = obj.StrCuentaCargo;
            arrPar[5] = new SqlParameter("@strCuentaAbono", SqlDbType.VarChar);
            arrPar[5].Value = obj.StrCuentaAbono; 
            arrPar[6] = new SqlParameter("@intES", SqlDbType.Int);
            arrPar[6].Value = obj.IntES; 
            arrPar[7] = new SqlParameter("@NumPage", SqlDbType.Int);
            arrPar[7].Value = obj.iNumPage;
            arrPar[8] = new SqlParameter("@NumRecords", SqlDbType.Int);
            arrPar[8].Value = obj.iNumRecords;
            arrPar[9] = new SqlParameter("@intDireccion", SqlDbType.Int);
            arrPar[9].Value = obj.SortDirection;
            arrPar[10] = new SqlParameter("@SortExpression", SqlDbType.VarChar);
            arrPar[10].Value = obj.SortExpression;
            arrPar[11] = new SqlParameter("@TotalRows", SqlDbType.Int);
            arrPar[11].Direction = ParameterDirection.Output;
            arrPar[12] = new SqlParameter("@TotalPage", SqlDbType.Int);
            arrPar[12].Direction = ParameterDirection.Output;

            try
            {
                ds = SqlHelper.ExecuteDataset(ConnectionString, CommandType.StoredProcedure, "VetecMarfilAdmin..usp_tbCuentasRet_Sel_", arrPar);
                obj.iNumRecords = (int)arrPar[11].Value;
                obj.iNumPage = (int)arrPar[12].Value;
                return ds.Tables[0];
            }
            catch (Exception e)
            {
                return null;
            }
        }
        #endregion

        #region QueryHelp
        public override string QueryHelp(int intEmpresa, int intSucursal, string[] parametros, int version)
        {
            string value = "";
            string parameter = "";

            for (int i = 0; i < parametros.Length; i++)
            {
                parameter = parameter + parametros[i].ToString() + ",";
            }

            SqlParameter[] arrPar = new SqlParameter[4];
            arrPar[0] = new SqlParameter("@intEmpresa", SqlDbType.Int);
            arrPar[0].Value = intEmpresa;
            arrPar[1] = new SqlParameter("@intSucursal", SqlDbType.Int);
            arrPar[1].Value = intSucursal;
            arrPar[2] = new SqlParameter("@intVersion", SqlDbType.Int);
            arrPar[2].Value = version;
            arrPar[3] = new SqlParameter("@strParametros", SqlDbType.VarChar);
            arrPar[3].Value = parameter;
            try
            {
                value = SqlHelper.ExecuteScalar(ConnectionString, CommandType.StoredProcedure, "VetecMarfilAdmin..usp_tbCuentasRet_Help", arrPar).ToString();
                return value;
            }
            catch (Exception e)
            {
                return "";
            }
        }

        public override DataSet QueryHelpData(int intEmpresa, int intSucursal, string[] parametros, int version)
        {
            DataSet value;
            string parameter = "";

            if (parametros != null)
            {
                for (int i = 0; i < parametros.Length; i++)
                {
                    parameter = parameter + parametros[i].ToString() + ",";
                }
            }

            SqlParameter[] arrPar = new SqlParameter[4];
            arrPar[0] = new SqlParameter("@intEmpresa", SqlDbType.Int);
            arrPar[0].Value = intEmpresa;
            arrPar[1] = new SqlParameter("@intSucursal", SqlDbType.Int);
            arrPar[1].Value = intSucursal;
            arrPar[2] = new SqlParameter("@intVersion", SqlDbType.Int);
            arrPar[2].Value = version;
            arrPar[3] = new SqlParameter("@strParametros", SqlDbType.VarChar);
            arrPar[3].Value = parameter;
            try
            {
                value = SqlHelper.ExecuteDataset(ConnectionString, CommandType.StoredProcedure, "VetecMarfilAdmin..usp_tbCuentasRet_Help", arrPar);
                return value;
            }
            catch (Exception e)
            {
                return null;
            }
        }

        #endregion

        #region GetByPrimaryKey
        public static Entity_CuentasRet GetByPrimaryKey(Entity_CuentasRet obj)
        {
            IDataReader drd;
            Entity_CuentasRet oEntity_CuentasRet = new Entity_CuentasRet();

            SqlParameter[] arrPar = new SqlParameter[6];
            arrPar[0] = new SqlParameter("@intEmpresa", SqlDbType.Int);
            arrPar[0].Value = obj.IntEmpresa;
            arrPar[1] = new SqlParameter("@intArea", SqlDbType.Int);
            arrPar[1].Value = obj.IntArea ;
            arrPar[2] = new SqlParameter("@strInsumoIni", SqlDbType.VarChar);
            arrPar[2].Value = obj.StrInsumoInicial ;
            arrPar[3] = new SqlParameter("@strInsumoFin", SqlDbType.VarChar);
            arrPar[3].Value = obj.StrInsumoFinal;
            arrPar[4] = new SqlParameter("@strCuentaCargo", SqlDbType.VarChar);
            arrPar[4].Value = obj.StrCuentaCargo;
            arrPar[5] = new SqlParameter("@strCuentaAbono", SqlDbType.VarChar);
            arrPar[5].Value = obj.StrCuentaAbono;


            try
            {
                drd = SqlHelper.ExecuteReader(ConnectionString, CommandType.StoredProcedure, "VetecMarfilAdmin..usp_tbCuentasRet_Fill_", arrPar);
                if (drd.Read())
                {
                    oEntity_CuentasRet = CreateObject(drd);
                }
                else
                    oEntity_CuentasRet = null;
            }
            catch (Exception e)
            {
                oEntity_CuentasRet = null;
            }

            return oEntity_CuentasRet;
        }
        #endregion

        #region Create
        static Entity_CuentasRet CreateObject(IDataReader drd)
        {
            Entity_CuentasRet obj = new Entity_CuentasRet();

            //obj.IntCuentaRet = Convert.ToInt32(drd["intCuentaRet"].ToString());
            obj.IntArea = Convert.ToInt32(drd["intArea"].ToString());
            obj.StrNombreArea = drd["strNombreArea"].ToString(); 
            obj.StrInsumoInicial = drd["strInsumoIni"].ToString();
            obj.StrNombreArticuloIn = drd["NombreInsumoIni"].ToString();
            obj.StrInsumoFinal = drd["strInsumoFin"].ToString();
            obj.StrNombreArticuloFin = drd["NombreInsumoFin"].ToString();
            obj.StrCuentaCargo = drd["strCuentaCargo"].ToString();
            obj.StrNombreCuentaCargo = drd["NombreCuentaCargo"].ToString();
            obj.StrCuentaAbono = drd["strCuentaAbono"].ToString();
            obj.StrNombreCuentaAbono = drd["NombreCuentaAbono"].ToString();
            obj.IntES = Convert.ToInt32(drd["intES"].ToString()); 

            return obj;
        }
        #endregion

        #region Save
        public static string Save(Entity_CuentasRet obj)
        {
            string result = "false";
            SqlParameter[] arrPar = new SqlParameter[8];
            arrPar[0] = new SqlParameter("@IntEmpresa", SqlDbType.Int);
            arrPar[0].Value = obj.IntEmpresa;
            //arrPar[1] = new SqlParameter("@intCuentaRet", SqlDbType.Int);
            //arrPar[1].Value = obj.IntCuentaRet;
            arrPar[1] = new SqlParameter("@intArea", SqlDbType.Int);
            arrPar[1].Value = obj.IntArea;
            arrPar[2] = new SqlParameter("@strInsumoIni", SqlDbType.VarChar);
            arrPar[2].Value = obj.StrInsumoInicial;
            arrPar[3] = new SqlParameter("@strInsumoFin", SqlDbType.VarChar);
            arrPar[3].Value = obj.StrInsumoFinal;
            arrPar[4] = new SqlParameter("@strCuentaCargo", SqlDbType.VarChar);
            arrPar[4].Value = obj.StrCuentaCargo;
            arrPar[5] = new SqlParameter("@strCuentaAbono", SqlDbType.VarChar);
            arrPar[5].Value = obj.StrCuentaAbono;
            arrPar[6] = new SqlParameter("@intES", SqlDbType.Int);
            arrPar[6].Value = obj.IntES;
            arrPar[7] = new SqlParameter("@strUsuario", SqlDbType.VarChar);
            arrPar[7].Value = obj.StrUsuario;  

            try
            {
                SqlHelper.ExecuteNonQuery (ConnectionString, CommandType.StoredProcedure, "VetecMarfilAdmin..usp_tbCuentasRet_Save_", arrPar).ToString();
                result = "true";
            }
            catch (Exception e)
            {
                throw e;
            }

            return result;
        }

        #endregion

        #region Delete
        public static bool Delete(Entity_CuentasRet obj)
        {

            bool bResult = false;

            SqlParameter[] arrPar = new SqlParameter[7];
            arrPar[0] = new SqlParameter("@intEmpresa", SqlDbType.Int);
            arrPar[0].Value = obj.IntEmpresa;
            arrPar[1] = new SqlParameter("@intArea", SqlDbType.Int);
            arrPar[1].Value = obj.IntArea;
            arrPar[2] = new SqlParameter("@strInsumoIni", SqlDbType.VarChar);
            arrPar[2].Value = obj.StrInsumoInicial ;
            arrPar[3] = new SqlParameter("@strInsumoFin", SqlDbType.VarChar);
            arrPar[3].Value = obj.StrInsumoFinal ;
            arrPar[4] = new SqlParameter("@strCuentaCargo", SqlDbType.VarChar);
            arrPar[4].Value = obj.StrCuentaCargo;
            arrPar[5] = new SqlParameter("@strCuentaAbono", SqlDbType.VarChar);
            arrPar[5].Value = obj.StrCuentaAbono;
            arrPar[6] = new SqlParameter("@intES", SqlDbType.Int);
            arrPar[6].Value = obj.IntES;

            try
            {
                SqlHelper.ExecuteNonQuery(ConnectionString, CommandType.StoredProcedure, "VetecMarfilAdmin..usp_tbCuentasRet_Del_", arrPar);
                bResult = true;
            }
            catch (Exception e)
            {
                throw e;
            }

            return bResult;
        }

        #endregion Delete
    }
}
