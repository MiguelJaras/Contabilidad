using System;
using System.Data;
using System.Data.SqlClient;
using System.Collections;
using System.Collections.Specialized;
using Microsoft.ApplicationBlocks.Data;
using Contabilidad.Entity;

namespace Contabilidad.DataAccess
{
    public class DACSector : Base
    {
        #region GetListByColonia
        public static DataTable GetListByColonia(int intColonia)
        {
            DataSet ds;

            SqlParameter[] arrPar = new SqlParameter[1];
            arrPar[0] = new SqlParameter("@intColonia", SqlDbType.Int);
            arrPar[0].Value = intColonia;

            try
            {
                ds = SqlHelper.ExecuteDataset(ConnectionString, CommandType.StoredProcedure, "usp_tbColonia_ListByColonia", arrPar);
                return ds.Tables[0];
            }
            catch (Exception e)
            {
                return null;
            }
        }
        #endregion

        #region Retrive
        public static DataTable Retrive(Entity_Sector entSector)
        {
            DataSet ds;

            SqlParameter[] arrPar = new SqlParameter[3];
            arrPar[0] = new SqlParameter("@intEmpresa", SqlDbType.Int);
            arrPar[0].Value = entSector.IntEmpresa;
            arrPar[1] = new SqlParameter("@intSucursal", SqlDbType.Int);
            arrPar[1].Value = entSector.IntSucursal;
            arrPar[2] = new SqlParameter("@intSector", SqlDbType.Int);
            arrPar[2].Value = entSector.IntSector;

            try
            {
                ds = SqlHelper.ExecuteDataset(ConnectionString, CommandType.StoredProcedure, "qrySector_Sel", arrPar);
                return ds.Tables[0];
            }
            catch (Exception e)
            {
                return null;
            }
        }
        #endregion

        #region Fill
        public static Entity_Sector Fill(Entity_Sector entSector)
        {
            IDataReader drd;
            Entity_Sector oEntity_Sector;
            oEntity_Sector = new Entity_Sector();

            SqlParameter[] arrPar = new SqlParameter[3];
            arrPar[0] = new SqlParameter("@intEmpresa", SqlDbType.Int);
            arrPar[0].Value = entSector.IntEmpresa;
            arrPar[1] = new SqlParameter("@intSucursal", SqlDbType.Int);
            arrPar[1].Value = entSector.IntSucursal;
            arrPar[2] = new SqlParameter("@intSector", SqlDbType.Int);
            arrPar[2].Value = entSector.IntSector;
            try
            {
                drd = SqlHelper.ExecuteReader(ConnectionString, CommandType.StoredProcedure, "qrySector_Sel ", arrPar);
                if (drd.Read())
                {
                    oEntity_Sector = CreateObject(drd);
                }
                else
                    oEntity_Sector = null;
            }
            catch (Exception e)
            {
                oEntity_Sector = null;
            }

            return oEntity_Sector;
        }
        #endregion

        #region Create
        public static Entity_Sector CreateObject(IDataReader drd)
        {
            Entity_Sector obj;
            obj = new Entity_Sector();

            obj.IntEmpresa = (int)drd["intEmpresa"];
            obj.IntSucursal = (int)drd["intSucursal"];
            obj.IntColonia = (int)drd["intColonia"];
            obj.IntSector = (int)drd["intSector"];
            obj.StrNombre = (string)drd["strNombre"];
            obj.StrNombreCorto = (string)drd["strNombreCorto"];
            obj.IntNumLote = (int)drd["intNumLote"];
            obj.IntClave = (int)drd["intClave"];

            //clave

            return obj;
        }
        #endregion

        public static DataTable DataXColonia(Entity_Sector sector)
        {
            DataSet ds;

            SqlParameter[] arrPar = new SqlParameter[3];
            arrPar[0] = new SqlParameter("@intEmpresa", SqlDbType.Int);
            arrPar[0].Value = sector.IntEmpresa;
            arrPar[1] = new SqlParameter("@intSucursal", SqlDbType.Int);
            arrPar[1].Value = sector.IntSucursal;
            arrPar[2] = new SqlParameter("@intColonia", SqlDbType.Int);
            arrPar[2].Value = sector.IntColonia;

            try
            {
                ds = SqlHelper.ExecuteDataset(ConnectionString, CommandType.StoredProcedure, "qrySector_SelXColonia", arrPar);
                return ds.Tables[0];
            }
            catch (Exception e)
            {
                return null;
            }

        }


        public static bool Save(Entity_Sector sector)
        {
            bool res;
            res = false;

            SqlParameter[] arrPar = new SqlParameter[13];
            arrPar[0] = new SqlParameter("@intEmpresa", SqlDbType.Int);
            arrPar[0].Value = sector.IntEmpresa;
            arrPar[1] = new SqlParameter("@intSucursal", SqlDbType.Int);
            arrPar[1].Value = sector.IntSucursal;
            arrPar[2] = new SqlParameter("@intSector", SqlDbType.Int);
            arrPar[2].Value = sector.IntSector;
            arrPar[3] = new SqlParameter("@intClave", SqlDbType.Int);
            arrPar[3].Value = sector.IntClave;
            arrPar[4] = new SqlParameter("@intColonia", SqlDbType.Int);
            arrPar[4].Value = sector.IntColonia;
            arrPar[5] = new SqlParameter("@strNombre", SqlDbType.VarChar);
            arrPar[5].Value = sector.StrNombre;
            arrPar[6] = new SqlParameter("@strNombreCorto", SqlDbType.VarChar);
            arrPar[6].Value = sector.StrNombreCorto;
            arrPar[7] = new SqlParameter("@intNumLote", SqlDbType.Int);
            arrPar[7].Value = sector.IntNumLote;
            arrPar[8] = new SqlParameter("@strUsuarioAlta", SqlDbType.VarChar);
            arrPar[8].Value = sector.StrUsuarioAlta;
            arrPar[9] = new SqlParameter("@strMaquinaAlta", SqlDbType.VarChar);
            arrPar[9].Value = sector.StrMaquinaAlta;
            arrPar[10] = new SqlParameter("@strUsuarioMod", SqlDbType.VarChar);
            arrPar[10].Value = sector.StrUsuarioMod;
            arrPar[11] = new SqlParameter("@strMaquinaMod", SqlDbType.VarChar);
            arrPar[11].Value = sector.StrMaquinaMod;
            arrPar[12] = new SqlParameter("@bPrecioTecho", SqlDbType.Bit);
            arrPar[12].Value = sector.BPrecioTecho;

            try
            {
                SqlHelper.ExecuteDataset(ConnectionString, CommandType.StoredProcedure, "usp_tbSector_App", arrPar);
                res = true;
            }
            catch (Exception e)
            {
                res = false;
            }
            return res;
        }


        public static bool Delete(Entity_Sector obj)
        {
            bool flag;

            SqlParameter[] arrPar = new SqlParameter[3];
            arrPar[0] = new SqlParameter("@intEmpresa", SqlDbType.Int);
            arrPar[0].Value = obj.IntEmpresa;
            arrPar[1] = new SqlParameter("@intSucursal", SqlDbType.Int);
            arrPar[1].Value = obj.IntSucursal;
            arrPar[2] = new SqlParameter("@intSector", SqlDbType.Int);
            arrPar[2].Value = obj.IntSector;

            try
            {
                SqlHelper.ExecuteNonQuery(ConnectionString, CommandType.StoredProcedure, "usp_tbSector_Del", arrPar);
                flag = true;
            }
            catch (Exception e)
            {
                throw e;
            }
            return flag;
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
                value = SqlHelper.ExecuteDataset(ConnectionString, CommandType.StoredProcedure, "usp_tbSector_Help", arrPar);
                return value;
            }
            catch (Exception e)
            {
                return null;
            }
        }


        public static string Clave(Entity_Sector obj)
        {
            string res = "0";

            SqlParameter[] arrPar = new SqlParameter[3];
            arrPar[0] = new SqlParameter("@intEmpresa", SqlDbType.Int);
            arrPar[0].Value = obj.IntEmpresa;
            arrPar[1] = new SqlParameter("@intSucursal", SqlDbType.Int);
            arrPar[1].Value = obj.IntSucursal;
            arrPar[2] = new SqlParameter("@intColonia", SqlDbType.VarChar);
            arrPar[2].Value = obj.IntColonia;

            try
            {
                res = SqlHelper.ExecuteScalar(ConnectionString, CommandType.StoredProcedure, "usp_tbSector_CveXColonia", arrPar).ToString();

            }
            catch (Exception e)
            {
                res = "0";
            }
            return res;
        }

        #region FillCve
        public static Entity_Sector FillCve(Entity_Sector entSector)
        {
            IDataReader drd;
            Entity_Sector oEntity_Sector;
            oEntity_Sector = new Entity_Sector();

            SqlParameter[] arrPar = new SqlParameter[4];
            arrPar[0] = new SqlParameter("@intEmpresa", SqlDbType.Int);
            arrPar[0].Value = entSector.IntEmpresa;
            arrPar[1] = new SqlParameter("@intSucursal", SqlDbType.Int);
            arrPar[1].Value = entSector.IntSucursal;
            arrPar[2] = new SqlParameter("@intColonia", SqlDbType.Int);
            arrPar[2].Value = entSector.IntColonia;
            arrPar[3] = new SqlParameter("@intClave", SqlDbType.Int);
            arrPar[3].Value = entSector.IntClave;
            try
            {
                drd = SqlHelper.ExecuteReader(ConnectionString, CommandType.StoredProcedure, "qrySector_SelCve ", arrPar);
                if (drd.Read())
                {
                    oEntity_Sector = CreateObject(drd);
                }
                else
                    oEntity_Sector = null;
            }
            catch (Exception e)
            {
                oEntity_Sector = null;
            }

            return oEntity_Sector;
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
                value = SqlHelper.ExecuteScalar(ConnectionString, CommandType.StoredProcedure, "usp_tbSector_Help_", arrPar).ToString();
                return value;
            }
            catch (Exception e)
            {
                return "";
            }
        }
        #endregion
    }
}
