using System;
using System.Collections.Generic;
using System.Text;
using System.Data.SqlClient;
using System.Data;
using Contabilidad.Entity;
using Microsoft.ApplicationBlocks.Data;

namespace Contabilidad.DataAccess
{
    public class DACEstructuraPolizaEnc:Base
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
        public static DataTable GetList(Entity_EstructuraPolizaEnc obj)
        {
            DataSet ds;

            SqlParameter[] arrPar = new SqlParameter[2];
            arrPar[0] = new SqlParameter("@intEmpresa", SqlDbType.Int);
            arrPar[0].Value = obj.IntEmpresa;
            arrPar[1] = new SqlParameter("@intClave", SqlDbType.Int);
            arrPar[1].Value = obj.IntClave; 

            try
            {
                ds = SqlHelper.ExecuteDataset(ConnectionString, CommandType.StoredProcedure, "VetecMarfilAdmin..usp_tbEstructuraEnc_Sel", arrPar);
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
                value = SqlHelper.ExecuteScalar(ConnectionString, CommandType.StoredProcedure, "VetecMarfilAdmin..usp_tbEstructuraEnc_Help", arrPar).ToString();
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

            for (int i = 0; i < parametros.Length; i++)
            {
                parameter = parameter + parametros[i].ToString() + ",";
            }

            SqlParameter[] arrPar = new SqlParameter[5];
            arrPar[0] = new SqlParameter("@intEmpresa", SqlDbType.Int);
            arrPar[0].Value = intEmpresa;
            arrPar[1] = new SqlParameter("@intSucursal", SqlDbType.Int);
            arrPar[1].Value = intSucursal;
            arrPar[2] = new SqlParameter("@intVersion", SqlDbType.Int);
            arrPar[2].Value = version;
            arrPar[3] = new SqlParameter("@strParametros", SqlDbType.VarChar);
            arrPar[3].Value = parameter;
            arrPar[4] = new SqlParameter("@intTipo", SqlDbType.VarChar);
            arrPar[4].Value = 1;
            try
            {
                value = SqlHelper.ExecuteDataset(ConnectionString, CommandType.StoredProcedure, "VetecMarfilAdmin..usp_tbEstructuraEnc_Help", arrPar);
                return value;
            }
            catch (Exception e)
            {
                return null;
            }
        }

        #endregion

        #region GetByPrimaryKey
        public static Entity_EstructuraPolizaEnc GetByPrimaryKey(Entity_EstructuraPolizaEnc obj)
        {
            IDataReader drd;
            Entity_EstructuraPolizaEnc oEntity_EstructuraPolizaEnc = new Entity_EstructuraPolizaEnc();

            SqlParameter[] arrPar = new SqlParameter[2];
            arrPar[0] = new SqlParameter("@intEmpresa", SqlDbType.Int);
            arrPar[0].Value = obj.IntEmpresa;
            arrPar[1] = new SqlParameter("@intMovto", SqlDbType.Int);
            arrPar[1].Value = obj.IntMovto;

            try
            {
                drd = SqlHelper.ExecuteReader(ConnectionString, CommandType.StoredProcedure, "VetecMarfilAdmin..usp_tbEstructuraEnc_Sel", arrPar);
                if (drd.Read())
                {
                    oEntity_EstructuraPolizaEnc = CreateObject(drd);
                }
                else
                    oEntity_EstructuraPolizaEnc = null;
            }
            catch (Exception e)
            {
                oEntity_EstructuraPolizaEnc = null;
            }

            return oEntity_EstructuraPolizaEnc;
        }
        #endregion

        #region Create
        static Entity_EstructuraPolizaEnc CreateObject(IDataReader drd)
        {
            Entity_EstructuraPolizaEnc obj = new Entity_EstructuraPolizaEnc();
            DateTime dt;

            obj.IntClave = Convert.ToInt32(drd["intClave"].ToString());
            obj.StrTipoPoliza = drd["strTipoPoliza"].ToString();
            obj.StrDescripciónPoliza = drd["strDescripciónPoliza"].ToString();
            obj.StrDescrcipcion = drd["strDescrcipcion"].ToString();
            obj.BitAutomatica = Convert.ToBoolean(drd["bitAutomatica"].ToString());
            obj.IntMovto = Convert.ToInt32(drd["intMovto"].ToString());
            obj.StrNombrePoliza = drd["strNombrePoliza"].ToString();
            obj.StrNombreTipoMovto = drd["strNombreTipoMovto"].ToString();                    

            return obj;
        }
        #endregion

        #region Save
        public static string Save(Entity_EstructuraPolizaEnc obj)
        {
            string result = "";
            SqlParameter[] arrPar = new SqlParameter[11]; 

            arrPar[0] = new SqlParameter("@intEmpresa", SqlDbType.Int);
            arrPar[0].Value = obj.IntEmpresa;

            arrPar[1] = new SqlParameter("@intClave", SqlDbType.Int);
            arrPar[1].Value = obj.IntClave;

            arrPar[2] = new SqlParameter("@strDescrcipcion", SqlDbType.VarChar);
            arrPar[2].Value = obj.StrDescrcipcion;

            arrPar[3] = new SqlParameter("@strTipoPoliza", SqlDbType.VarChar);
            arrPar[3].Value = obj.StrTipoPoliza;

            arrPar[4] = new SqlParameter("@intModulo", SqlDbType.Int);
            arrPar[4].Value = obj.IntModulo;

            arrPar[5] = new SqlParameter("@bitAutomatica", SqlDbType.Bit);
            arrPar[5].Value = obj.BitAutomatica;  

            arrPar[6] = new SqlParameter("@strDescripciónPoliza", SqlDbType.VarChar);
            arrPar[6].Value = obj.StrDescripciónPoliza;

            arrPar[7] = new SqlParameter("@strUsuario", SqlDbType.VarChar);
            arrPar[7].Value = obj.StrUsuario;

            arrPar[8] = new SqlParameter("@strMaquina", SqlDbType.VarChar);
            arrPar[8].Value = obj.StrMaquina;

            arrPar[9] = new SqlParameter("@intMovto", SqlDbType.Int);
            arrPar[9].Value = obj.IntMovto;

            arrPar[10] = new SqlParameter("@intGrupoCredito", SqlDbType.Int);
            arrPar[10].Value = obj.IntGrupoCredito;  

            try
            {
                result = SqlHelper.ExecuteScalar(ConnectionString, CommandType.StoredProcedure, "VetecMarfilAdmin..usp_tbEstructuraEnc_Save", arrPar).ToString();
            }
            catch (Exception e)
            {
                throw e;
            }

            return result;
        } 

        #endregion 

        #region Delete
        public static bool Delete(Entity_EstructuraPolizaEnc obj)
        {

            bool bResult = false;

            SqlParameter[] arrPar = new SqlParameter[2];

            arrPar[0] = new SqlParameter("@intEmpresa", SqlDbType.Int);
            arrPar[0].Value = obj.IntEmpresa;
            arrPar[1] = new SqlParameter("@intClave", SqlDbType.Int);
            arrPar[1].Value = obj.IntClave; 

            try
            {
                SqlHelper.ExecuteNonQuery(ConnectionString, CommandType.StoredProcedure, "VetecMarfilAdmin..usp_tbEstructuraEnc_Del", arrPar);
                bResult = false;
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
