using System;
using System.Data;
using System.Data.SqlClient;
using System.Collections;
using System.Collections.Specialized;
using Microsoft.ApplicationBlocks.Data;
using Contabilidad.Entity;

namespace Contabilidad.DataAccess
{
    public class DACCuentas:Base
    {
        #region Variables

        int _ReturnValue;
        public int ReturnValue
        {
            get { return _ReturnValue; }
            set { _ReturnValue = value; }
        }
        #endregion Variables

        #region fn_tbCuentas_SubSubCuentas
        public static DataTable fn_tbCuentas_SubSubCuentas(int intEmpresa, string cta, string subCta, string subSubCta)
        {
            DataSet ds;

            try
            {
                ds = SqlHelper.ExecuteDataset(ConnectionString, CommandType.Text, "SELECT strCuenta, strNombre, intIndAuxiliar FROM VetecMarfilAdmin..fn_tbCuentas_SubSubCuentas(" + intEmpresa.ToString() + ",'" + cta + "','" + subCta + "','" + subSubCta + "')");
                return ds.Tables[0];
            }
            catch (Exception e)
            {
                return null;
            }
        }
        #endregion

        #region GetList
        public static DataTable GetList(Entity_Cuentas obj)
        {
            DataSet ds;

            SqlParameter[] arrPar = new SqlParameter[2];
            arrPar[0] = new SqlParameter("@intEmpresa", SqlDbType.Int);
            arrPar[0].Value = obj.IntEmpresa;
            arrPar[1] = new SqlParameter("@strCuenta", SqlDbType.VarChar);
            arrPar[1].Value = obj.StrCuenta;

            try
            {
                ds = SqlHelper.ExecuteDataset(ConnectionString, CommandType.StoredProcedure, "VetecMarfilAdmin..usp_tbCuentas_Sel", arrPar);
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
                value = SqlHelper.ExecuteScalar(ConnectionString, CommandType.StoredProcedure, "VetecMarfilAdmin..usp_tbCuentas_Help", arrPar).ToString();
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
                //value = SqlHelper.ExecuteDataset(ConnectionString, CommandType.StoredProcedure, "VetecMarfil..usp_tbSalidas_Help", arrPar).ToString();
                value = SqlHelper.ExecuteDataset(ConnectionString, CommandType.StoredProcedure, "VetecMarfilAdmin..usp_tbCuentas_Help", arrPar);
                return value;
            }
            catch (Exception e)
            {
                return null;
            }
        }

        #endregion

        #region GetByPrimaryKey
        public static Entity_Cuentas GetByPrimaryKey(Entity_Cuentas obj)
        {
            IDataReader drd;

            Entity_Cuentas oEntity_Cuentas = new Entity_Cuentas();

            SqlParameter[] arrPar = new SqlParameter[2];
            arrPar[0] = new SqlParameter("@intEmpresa", SqlDbType.Int);
            arrPar[0].Value = obj.IntEmpresa;
            arrPar[1] = new SqlParameter("@strCuenta", SqlDbType.VarChar);
            arrPar[1].Value = obj.StrCuenta;

            try
            {
                drd = SqlHelper.ExecuteReader(ConnectionString, CommandType.StoredProcedure, "VetecMarfilAdmin..usp_tbCuentas_Sel", arrPar);
                if (drd.Read())
                {
                    oEntity_Cuentas = CreateObject(drd);
                }
                else
                    oEntity_Cuentas = null;
            }
            catch (Exception e)
            {
                oEntity_Cuentas = null;
            }

            return oEntity_Cuentas;
        }
        #endregion

        #region Create
        static Entity_Cuentas CreateObject(IDataReader drd)
        {

            Entity_Cuentas obj = new Entity_Cuentas();

            obj.StrClasifEnc = drd["strClasifEnc"].ToString();
            obj.StrCuenta = drd["strCuenta"].ToString();
            obj.StrNombre= drd["strNombre"].ToString();
            obj.StrNombreCorto= drd["strNombreCorto"].ToString();
            obj.IntNivel= Convert.ToInt32(drd["intNivel"].ToString());
            obj.IntCtaRegistro= Convert.ToInt32(drd["intCtaRegistro"].ToString());
            obj.IntIndAuxiliar= Convert.ToInt32(drd["intIndAuxiliar"].ToString());
            obj.IntAcceso= Convert.ToInt32(drd["intAcceso"].ToString());
            obj.IntTipoGrupoContable= Convert.ToInt32(drd["intTipoGrupoContable"].ToString());
            obj.Tipo_GrupoContable= drd["Tipo_GrupoContable"].ToString();
            obj.IntGrupoContable= Convert.ToInt32(drd["intGrupoContable"].ToString());
            obj.GrupoContable= drd["GrupoContable"].ToString();           
            obj.StrAuditAlta= drd["strAuditAlta"].ToString();
            obj.StrAuditMod= drd["strAuditMod"].ToString();
            obj.StrCodigoAgrupador = drd["strCodigoAgrupador"].ToString(); 
            return obj;
        }
        #endregion

        #region Save
        public static string Save(Entity_Cuentas obj)
        {
            string result = "";
            SqlParameter[] arrPar = new SqlParameter[11]; 

            arrPar[0] = new SqlParameter("@intEmpresa", SqlDbType.Int);
            arrPar[0].Value = obj.IntEmpresa;
            arrPar[1] = new SqlParameter("@strCuenta", SqlDbType.VarChar);
            arrPar[1].Value = obj.StrCuenta;
            arrPar[2] = new SqlParameter("@strNombre", SqlDbType.VarChar);
            arrPar[2].Value = obj.StrNombre;
            arrPar[3] = new SqlParameter("@strNombreCorto", SqlDbType.VarChar);
            arrPar[3].Value = obj.StrNombreCorto;
            arrPar[4] = new SqlParameter("@intCtaRegistro", SqlDbType.Int);
            arrPar[4].Value = obj.IntCtaRegistro;
            arrPar[5] = new SqlParameter("@intIndAuxiliar", SqlDbType.Int);
            arrPar[5].Value = obj.IntIndAuxiliar;
            arrPar[6] = new SqlParameter("@intTipoGrupoContable", SqlDbType.Int);
            arrPar[6].Value = obj.IntTipoGrupoContable;
            arrPar[7] = new SqlParameter("@intAcceso", SqlDbType.Int);
            arrPar[7].Value = obj.IntAcceso;
            arrPar[8] = new SqlParameter("@intGrupoContable", SqlDbType.Int);
            arrPar[8].Value = obj.IntGrupoContable;
            arrPar[9] = new SqlParameter("@strAuditAlta", SqlDbType.VarChar);
            arrPar[9].Value = obj.StrAuditAlta;
            arrPar[10] = new SqlParameter("@StrCodigoAgrupador", SqlDbType.VarChar);
            arrPar[10].Value = obj.StrCodigoAgrupador;
            try
            {
                result = SqlHelper.ExecuteScalar(ConnectionString, CommandType.StoredProcedure, "VetecMarfilAdmin..usp_tbCuentas_Save", arrPar).ToString();
            }
            catch (Exception e)
            {
                throw e;
            }

            return result;
        }

        #endregion

        #region Delete
        public static bool Delete(Entity_Cuentas obj)
        {

            bool bResult = false;

            SqlParameter[] arrPar = new SqlParameter[2];

            arrPar[0] = new SqlParameter("@intEmpresa", SqlDbType.Int);
            arrPar[0].Value = obj.IntEmpresa;

            arrPar[1] = new SqlParameter("@strCuenta", SqlDbType.VarChar);
            arrPar[1].Value = obj.StrCuenta;

            try
            {
                SqlHelper.ExecuteNonQuery(ConnectionString, CommandType.StoredProcedure, "VetecMarfilAdmin..usp_tbCuentas_Del", arrPar);
                bResult = false;
            }
            catch (Exception e)
            {
                throw e;
            }

            return bResult;
        }

        #endregion Delete  

        #region GetMaxCuenta
        public static string GetMaxCuenta(Entity_Cuentas obj)
        {
            string value = "";

            try
            {
                value = SqlHelper.ExecuteScalar(ConnectionString, CommandType.Text, "SELECT VetecMarfilAdmin.dbo.fn_tbCuentas_Max(" + obj.IntEmpresa.ToString() + ",'" + obj.StrCuenta + "')").ToString();                              
            }
            catch (Exception e)
            {
                value = "";
            }

            return value;
        }
        #endregion

         #region ExisteCuenta
        public static string ExisteCuenta(Entity_Cuentas obj)
        {
            string result = "";
            SqlParameter[] arrPar = new SqlParameter[2]; 

            arrPar[0] = new SqlParameter("@intEmpresa", SqlDbType.Int);
            arrPar[0].Value = obj.IntEmpresa;
            arrPar[1] = new SqlParameter("@strCuenta", SqlDbType.VarChar);
            arrPar[1].Value = obj.StrCuenta;
            
            try
            {
                result = SqlHelper.ExecuteScalar(ConnectionString, CommandType.StoredProcedure, "VetecMarfilAdmin..usp_tbCuentas_Existe", arrPar).ToString();
            }
            catch (Exception e)
            {
                throw e;
            }

            return result;
        }

        #endregion

    }
}
