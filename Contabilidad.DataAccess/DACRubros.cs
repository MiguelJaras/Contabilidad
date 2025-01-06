using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using System.Data.SqlClient;
using Contabilidad.Entity;
using Microsoft.ApplicationBlocks.Data;

namespace Contabilidad.DataAccess
{
    public class DACRubros : Base
    {
        #region Variables

        int _ReturnValue;
        public int ReturnValue
        {
            get { return _ReturnValue; }
            set { _ReturnValue = value; }
        }
        #endregion Variables

        #region Fill
        public static Entity_Rubros Fill(Entity_Rubros obj)
        {
            IDataReader drd;
            Entity_Rubros oEntity_Rubros;
            oEntity_Rubros = new Entity_Rubros();

            try
            {
                SqlParameter[] arrPar = new SqlParameter[2];
                arrPar[0] = new SqlParameter("@intEmpresa", SqlDbType.Int);
                arrPar[0].Value = obj.intEmpresa;
                arrPar[1] = new SqlParameter("@intRubro", SqlDbType.Int);
                arrPar[1].Value = obj.intRubro;

                drd = SqlHelper.ExecuteReader(ConnectionString, CommandType.StoredProcedure, "usp_tbRubros_Fill", arrPar);
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

        #region Create
        static Entity_Rubros CreateObject(IDataReader drd)
        {

            Entity_Rubros obj = new Entity_Rubros();

            obj.intRubro = Convert.ToInt32(drd["intRubro"].ToString());
            obj.strNombre = drd["strNombre"].ToString();
            obj.strNombreCorto = drd["strNombreCorto"].ToString();
            obj.strTipoRubro = drd["strTipoRubro"].ToString();
            obj.intIndCambiaSignoSalida = Convert.ToInt32(drd["intIndCambiaSignoSalida"].ToString());
            obj.strSignoOperacionArit = drd["strSignoOperacionArit"].ToString();
            obj.datFechaAlta = Convert.ToDateTime(drd["datFechaAlta"].ToString());
            obj.strUsuarioAlta = drd["strUsuarioAlta"].ToString();
            obj.strMaquinaAlta = drd["strMaquinaAlta"].ToString();
            obj.datFechaMod = Convert.ToDateTime (drd["datFechaMod"].ToString());
            obj.strUsuarioMod = drd["strUsuarioMod"].ToString();
            obj.strMaquinaMod = drd["strMaquinaMod"].ToString();
            obj.intEmpresa = Convert.ToInt32(drd["intEmpresa"].ToString());
            
            return obj;
        }
        #endregion

        #region Save
        public static string Save(Entity_Rubros obj)
        {
            string result = "";
            SqlParameter[] arrPar = new SqlParameter[13]; 

            arrPar[0] = new SqlParameter("@intEmpresa", SqlDbType.Int);
            arrPar[0].Value = obj.intEmpresa ;
            arrPar[1] = new SqlParameter("@intRubro", SqlDbType.Int );
            arrPar[1].Value = obj.intRubro ;
            arrPar[2] = new SqlParameter("@strNombre", SqlDbType.VarChar);
            arrPar[2].Value = obj.strNombre ;
            arrPar[3] = new SqlParameter("@strNombreCorto", SqlDbType.VarChar);
            arrPar[3].Value = obj.strNombreCorto ;
            arrPar[4] = new SqlParameter("@strTipoRubro", SqlDbType.VarChar);
            arrPar[4].Value = obj.strTipoRubro ;
            arrPar[5] = new SqlParameter("@intIndCambiaSignoSalida", SqlDbType.Int);
            arrPar[5].Value = obj.intIndCambiaSignoSalida ;  
            arrPar[6] = new SqlParameter("@strSignoOperacionArit", SqlDbType.VarChar );
            arrPar[6].Value = obj.strSignoOperacionArit ;
            arrPar[7] = new SqlParameter("@datFechaAlta", SqlDbType.DateTime);
            arrPar[7].Value = obj.datFechaAlta ; 
            arrPar[8] = new SqlParameter("@strUsuarioAlta", SqlDbType.VarChar );
            arrPar[8].Value = obj.strUsuarioAlta ; 
            arrPar[9] = new SqlParameter("@strMaquinaAlta", SqlDbType.VarChar );
            arrPar[9].Value = obj.strMaquinaAlta ;
            arrPar[10] = new SqlParameter("@datFechaMod", SqlDbType.DateTime );
            arrPar[10].Value = obj.datFechaMod ; 
            arrPar[11] = new SqlParameter("@strUsuarioMod", SqlDbType.VarChar );
            arrPar[11].Value = obj.strUsuarioMod ;
            arrPar[12] = new SqlParameter("@strMaquinaMod", SqlDbType.VarChar );
            arrPar[12].Value = obj.strMaquinaMod ;

            try
            {
                result = SqlHelper.ExecuteScalar(ConnectionString, CommandType.StoredProcedure, "VetecMarfilAdmin..usp_tbRubros_Save", arrPar).ToString();
            }
            catch (Exception e)
            {
                throw e;
            }

            return result;
        }

        #endregion

        #region Delete
        public static string  Delete(Entity_Rubros obj)
        {

            string result = "";

            SqlParameter[] arrPar = new SqlParameter[2];

            arrPar[0] = new SqlParameter("@intEmpresa", SqlDbType.Int);
            arrPar[0].Value = obj.intEmpresa;
            arrPar[1] = new SqlParameter("@intRubro", SqlDbType.VarChar);
            arrPar[1].Value = obj.intRubro;

            try
            {
                result = SqlHelper.ExecuteScalar(ConnectionString, CommandType.StoredProcedure, "VetecMarfilAdmin..usp_tbRubros_Del", arrPar).ToString();
            }
            catch (Exception e)
            {
                throw e;
            }

            return result;
        }

        #endregion Delete  
        
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
                value = SqlHelper.ExecuteScalar(ConnectionString, CommandType.StoredProcedure, "VetecMarfilAdmin..usp_tbRubros_Help", arrPar).ToString();
                return value;
            }
            catch (Exception e)
            {
                return "";
            }

            return value;
        }
        #endregion

    }
}
