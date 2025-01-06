using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using System.Data.SqlClient;
using Contabilidad.Entity;
using Microsoft.ApplicationBlocks.Data;

namespace Contabilidad.DataAccess
{
    public class DACRubrosCuentas : Base
    {
        #region Fill
        public static Entity_RubrosCuentas Fill(Entity_RubrosCuentas obj)
        {
            IDataReader drd;
            Entity_RubrosCuentas oEntity_Rubros;
            oEntity_Rubros = new Entity_RubrosCuentas();

            try
            {
                SqlParameter[] arrPar = new SqlParameter[3];
                arrPar[0] = new SqlParameter("@intEmpresa", SqlDbType.Int);
                arrPar[0].Value = obj.intEmpresa;
                arrPar[1] = new SqlParameter("@strCuenta", SqlDbType.VarChar);
                arrPar[1].Value = obj.strCuenta;
                arrPar[2] = new SqlParameter("@intRubro", SqlDbType.Int);
                arrPar[2].Value = obj.intRubro;

                drd = SqlHelper.ExecuteReader(ConnectionString, CommandType.StoredProcedure, "VetecMarfilAdmin..usp_tbRubrosCuentas_Fill", arrPar);
                if (drd.Read())
                {
                    oEntity_Rubros = CreateObject(drd);
                }
                else
                {
                    oEntity_Rubros = null;
                }
            }
            catch (Exception e)
            {
                oEntity_Rubros = null;
            }

            return oEntity_Rubros;
        }
        #endregion

        #region Sel
        public static DataTable  Sel(Entity_RubrosCuentas obj)
        {
            IDataReader drd;
            DataSet ds;
            Entity_RubrosCuentas oEntity_Rubros;
            oEntity_Rubros = new Entity_RubrosCuentas();

            SqlParameter[] arrPar = new SqlParameter[2];
            arrPar[0] = new SqlParameter("@intEmpresa", SqlDbType.Int);
            arrPar[0].Value = obj.intEmpresa;
            arrPar[1] = new SqlParameter("@intRubro", SqlDbType.Int);
            arrPar[1].Value = obj.intRubro;

            try
            {
                ds = SqlHelper.ExecuteDataset(ConnectionString, CommandType.StoredProcedure, "VetecMarfilAdmin..usp_tbRubrosCuentas_Sel", arrPar);
                return ds.Tables[0];
            }
            catch (Exception e)
            {
                return null;
            }
            
        }
        #endregion

        #region Create
        static Entity_RubrosCuentas CreateObject(IDataReader drd)
        {

            Entity_RubrosCuentas obj = new Entity_RubrosCuentas();

            obj.intRubro = Convert.ToInt32(drd["intRubro"].ToString());
            obj.strCuenta = drd["strCuenta"].ToString();
            obj.intIndSumaResta =  Convert.ToInt32(drd["intIndSumaResta"].ToString());
            obj.datFechaAlta =  Convert.ToDateTime (drd["datFechaAlta"].ToString());
            obj.strUsuarioAlta = drd["strUsuarioAlta"].ToString();
            obj.strMaquinaAlta = drd["strMaquinaAlta"].ToString();
            obj.datFechaMod = Convert.ToDateTime(drd["datFechaMod"].ToString());
            obj.strUsuarioMod = drd["strUsuarioMod"].ToString();
            obj.strMaquinaMod = drd["strMaquinaMod"].ToString();
            obj.intEmpresa = Convert.ToInt32(drd["intEmpresa"].ToString());

            return obj;
        }
        #endregion

        #region Save
        public static string Save(Entity_RubrosCuentas obj)
        {
            string result = "";
            SqlParameter[] arrPar = new SqlParameter[10];

            arrPar[0] = new SqlParameter("@intRubro", SqlDbType.Int);
            arrPar[0].Value = obj.intRubro;
            arrPar[1] = new SqlParameter("@strCuenta", SqlDbType.VarChar);
            arrPar[1].Value = obj.strCuenta;
            arrPar[2] = new SqlParameter("@intIndSumaResta", SqlDbType.Int );
            arrPar[2].Value = obj.intIndSumaResta;
            arrPar[3] = new SqlParameter("@datFechaAlta", SqlDbType.DateTime );
            arrPar[3].Value = obj.datFechaAlta;
            arrPar[4] = new SqlParameter("@strUsuarioAlta", SqlDbType.VarChar );
            arrPar[4].Value = obj.strUsuarioAlta;
            arrPar[5] = new SqlParameter("@strMaquinaAlta", SqlDbType.VarChar);
            arrPar[5].Value = obj.strMaquinaAlta;
            arrPar[6] = new SqlParameter("@datFechaMod", SqlDbType.DateTime);
            arrPar[6].Value = obj.datFechaMod;
            arrPar[7] = new SqlParameter("@strUsuarioMod", SqlDbType.VarChar);
            arrPar[7].Value = obj.strUsuarioMod;
            arrPar[8] = new SqlParameter("@strMaquinaMod", SqlDbType.VarChar);
            arrPar[8].Value = obj.strMaquinaMod;
            arrPar[9] = new SqlParameter("@intEmpresa", SqlDbType.Int );
            arrPar[9].Value = obj.intEmpresa;

            try
            {
                result = SqlHelper.ExecuteScalar(ConnectionString, CommandType.StoredProcedure, "VetecMarfilAdmin..usp_tbRubrosCuentas_Save", arrPar).ToString();
            }
            catch (Exception e)
            {
                throw e;
            }

            return result;
        }

        #endregion

        #region Delete
        public static string Delete(Entity_RubrosCuentas obj)
        {

            string result = "";

            SqlParameter[] arrPar = new SqlParameter[3];

            arrPar[0] = new SqlParameter("@intEmpresa", SqlDbType.Int);
            arrPar[0].Value = obj.intEmpresa;
            arrPar[1] = new SqlParameter("@strCuenta", SqlDbType.VarChar);
            arrPar[1].Value = obj.strCuenta;
            arrPar[2] = new SqlParameter("@intRubro", SqlDbType.Int);
            arrPar[2].Value = obj.intRubro;

            try
            {
                result = SqlHelper.ExecuteScalar(ConnectionString, CommandType.StoredProcedure, "VetecMarfilAdmin..usp_tbRubrosCuentas_Del", arrPar).ToString();
            }
            catch (Exception e)
            {
                throw e;
            }

            return result;
        }

        #endregion Delete  
    }
}
