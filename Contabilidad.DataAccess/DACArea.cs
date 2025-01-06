using System;
using System.Data;
using System.Data.SqlClient;
using System.Collections;
using System.Collections.Specialized;
using Microsoft.ApplicationBlocks.Data;
using Contabilidad.Entity;

namespace Contabilidad.DataAccess
{
    public class DACArea : Base
	{
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
                value = SqlHelper.ExecuteScalar(ConnectionString, CommandType.StoredProcedure, "usp_tbArea_Help", arrPar).ToString();
                return value;
            }
            catch (Exception e)
            {
                return "";
            }
        }
        #endregion

        #region GetList
        public static DataTable GetList(Entity_Articulo Ciudades)
        {
            DataSet ds;

            SqlParameter[] arrPar = new SqlParameter[4];
            //arrPar[0] = new SqlParameter("@intEstado", SqlDbType.Int);
            //arrPar[0].Value = Ciudades.IntEstado;
            //arrPar[1] = new SqlParameter("@intMunicipio", SqlDbType.Int);
            //arrPar[1].Value = 0;

            try
            {
                ds = SqlHelper.ExecuteDataset(ConnectionString, CommandType.StoredProcedure, "qryMunicipio_Sel", arrPar);
                return ds.Tables[0];
            }
            catch (Exception e)
            {
                return null;
            }
        }
        #endregion
			
        #region Fill
        public static Entity_Area Fill(Entity_Area obj)
        {
            IDataReader drd;
            Entity_Area oEntity_Area;
            oEntity_Area = new Entity_Area();

            SqlParameter[] arrPar = new SqlParameter[3];
            arrPar[0] = new SqlParameter("@intEmpresa", SqlDbType.Int);
                arrPar[0].Value = obj.intEmpresa;
            arrPar[1] = new SqlParameter("@intSucursal", SqlDbType.Int);
            arrPar[1].Value = obj.IntSucursal;
            arrPar[2] = new SqlParameter("@intArea", SqlDbType.Int);
            arrPar[2].Value = obj.intArea;

            try
            {
                    drd = SqlHelper.ExecuteReader(ConnectionString, CommandType.StoredProcedure, "qryArea_Sel", arrPar);
                if (drd.Read())
                {
                    oEntity_Area = CreateObject(drd);
                }
            }
            catch (Exception e)
            {
                oEntity_Area = null;
            }

            return oEntity_Area;
        }
        #endregion  


        #region Create
        static Entity_Area CreateObject(IDataReader drd)
        {
                Entity_Area oEnt_catArea;
                oEnt_catArea = new Entity_Area();

                oEnt_catArea.intArea = (int)drd["intArea"];
                oEnt_catArea.strNombre = (string)drd["strNombre"];
                oEnt_catArea.strNombreCorto = (string)drd["strNombreCorto"];
                //oEnt_catUser.IntPerfil = (int)drd["intPerfil"];
                //oEnt_catUser.StrNombrePerfil = (string)drd["strNombrePerfil"];
           
                return oEnt_catArea;
        }
        #endregion

       
		
    }
}
