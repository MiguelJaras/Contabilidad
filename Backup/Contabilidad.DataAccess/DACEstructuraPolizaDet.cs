using System;
using System.Collections.Generic;
using System.Text;
using Contabilidad.Entity;
using System.Data.SqlClient;
using System.Data;
using Microsoft.ApplicationBlocks.Data;

namespace Contabilidad.DataAccess
{
    public class DACEstructuraPolizaDet : Base
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
        public static DataTable GetList(Entity_EstructuraPolizaDet obj)
        {
            DataSet ds;

            SqlParameter[] arrPar = new SqlParameter[3];
            arrPar[0] = new SqlParameter("@intEmpresa", SqlDbType.Int);
            arrPar[0].Value = obj.IntEmpresa;
            arrPar[1] = new SqlParameter("@intPartida", SqlDbType.Int);
            arrPar[1].Value = obj.IntPartida;
            arrPar[2] = new SqlParameter("@intClave", SqlDbType.Int);
            arrPar[2].Value = obj.IntClave;

            try
            {
                ds = SqlHelper.ExecuteDataset(ConnectionString, CommandType.StoredProcedure, "VetecMarfilAdmin..usp_tbEstructuraDet_Sel", arrPar);
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
                value = SqlHelper.ExecuteScalar(ConnectionString, CommandType.StoredProcedure, "VetecMarfilAdmin..usp_tbEstructuraDet_Help", arrPar).ToString();
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
                value = SqlHelper.ExecuteDataset(ConnectionString, CommandType.StoredProcedure, "VetecMarfilAdmin..usp_tbEstructuraDet_Help", arrPar);
                return value;
            }
            catch (Exception e)
            {
                return null;
            }
        }

        #endregion

        #region GetByPrimaryKey
        public static Entity_EstructuraPolizaDet GetByPrimaryKey(Entity_EstructuraPolizaDet obj)
        {
            IDataReader drd;
            Entity_EstructuraPolizaDet oEntity_EstructuraPolizaDet = new Entity_EstructuraPolizaDet();

            SqlParameter[] arrPar = new SqlParameter[3];
            arrPar[0] = new SqlParameter("@intEmpresa", SqlDbType.Int);
            arrPar[0].Value = obj.IntEmpresa;
            arrPar[1] = new SqlParameter("@intPartida", SqlDbType.Int);
            arrPar[1].Value = obj.IntPartida;
            arrPar[2] = new SqlParameter("@intClave", SqlDbType.Int);
            arrPar[2].Value = obj.IntClave;

            try
            {
                drd = SqlHelper.ExecuteReader(ConnectionString, CommandType.StoredProcedure, "VetecMarfilAdmin..usp_tbEstructuraDet_Sel", arrPar);
                if (drd.Read())
                {
                    oEntity_EstructuraPolizaDet = CreateObject(drd);
                }
                else
                    oEntity_EstructuraPolizaDet = null;
            }
            catch (Exception e)
            {
                oEntity_EstructuraPolizaDet = null;
            }

            return oEntity_EstructuraPolizaDet;
        }
        #endregion

        #region Create
        static Entity_EstructuraPolizaDet CreateObject(IDataReader drd)
        {
            Entity_EstructuraPolizaDet obj = new Entity_EstructuraPolizaDet();
            DateTime dt;

            obj.IntClave = Convert.ToInt32(drd["intClave"].ToString());
            obj.StrCuenta = drd["strCuenta"].ToString();
            obj.StrSubCuentat = drd["strSubCuentat"].ToString();
            obj.StrSubSubCuenta = drd["strSubSubCuenta"].ToString();
            obj.BitCargo = Convert.ToBoolean(drd["bitCargo"].ToString());
            obj.BitAux = Convert.ToBoolean(drd["bitAux"].ToString());
            obj.BitCC = Convert.ToBoolean(drd["bitCC"].ToString());
            obj.StrConcepto = drd["strConcepto"].ToString();
            obj.StrComentario = drd["strComentario"].ToString();
            obj.BitModif = Convert.ToBoolean(drd["bitModif"].ToString());
            obj.StrBase = drd["strBase"].ToString();
            obj.DblPtaje = Convert.ToDecimal(drd["intPtaje"].ToString());

            return obj;
        }
        #endregion

        #region Save
        public static string Save(Entity_EstructuraPolizaDet obj)
        {  
            string result = "";
            SqlParameter[] arrPar = new SqlParameter[14];

            arrPar[0] = new SqlParameter("@intEmpresa", SqlDbType.Int);
            arrPar[0].Value = obj.IntEmpresa;

            arrPar[1] = new SqlParameter("@intClave", SqlDbType.Int);
            arrPar[1].Value = obj.IntClave;

            arrPar[2] = new SqlParameter("intPartida", SqlDbType.Int);
            arrPar[2].Value = obj.IntPartida;

            arrPar[3] = new SqlParameter("@strCuenta", SqlDbType.VarChar);
            arrPar[3].Value = obj.StrCuenta;

            arrPar[4] = new SqlParameter("@strSubCuentat", SqlDbType.VarChar);
            arrPar[4].Value = obj.StrSubCuentat;

            arrPar[5] = new SqlParameter("@strSubSubCuenta", SqlDbType.VarChar);
            arrPar[5].Value = obj.StrSubSubCuenta;

            arrPar[6] = new SqlParameter("@bitCargo", SqlDbType.Bit);
            arrPar[6].Value = obj.BitCargo;

            arrPar[7] = new SqlParameter("@bitAux", SqlDbType.Bit);
            arrPar[7].Value = obj.BitAux;

            arrPar[8] = new SqlParameter("@bitCC", SqlDbType.Bit);
            arrPar[8].Value = obj.BitCC;

            arrPar[9] = new SqlParameter("@strConcepto", SqlDbType.VarChar);
            arrPar[9].Value = obj.StrConcepto;

            arrPar[10] = new SqlParameter("@strComentario", SqlDbType.VarChar);
            arrPar[10].Value = obj.StrComentario; 

            arrPar[11] = new SqlParameter("@bitModif", SqlDbType.Bit);
            arrPar[11].Value = obj.BitModif;

            arrPar[12] = new SqlParameter("@strBase", SqlDbType.VarChar);
            arrPar[12].Value = obj.StrBase;

            arrPar[13] = new SqlParameter("@dblPtaje", SqlDbType.Decimal);
            arrPar[13].Value = obj.DblPtaje; 

            try
            {
                result = SqlHelper.ExecuteScalar(ConnectionString, CommandType.StoredProcedure, "VetecMarfilAdmin..usp_tbEstructuraDet_Save", arrPar).ToString();
            }
            catch (Exception e)
            {
                throw e;
            }

            return result;
        }

        #endregion

        #region Delete
        public static bool Delete(Entity_EstructuraPolizaDet obj)
        {

            bool bResult = false; 

            SqlParameter[] arrPar = new SqlParameter[3];
            arrPar[0] = new SqlParameter("@intEmpresa", SqlDbType.Int);
            arrPar[0].Value = obj.IntEmpresa;
            arrPar[1] = new SqlParameter("@intPartida", SqlDbType.Int);
            arrPar[1].Value = obj.IntPartida;
            arrPar[2] = new SqlParameter("@intClave", SqlDbType.Int);
            arrPar[2].Value = obj.IntClave;

            try
            {
                SqlHelper.ExecuteNonQuery(ConnectionString, CommandType.StoredProcedure, "VetecMarfilAdmin..usp_tbEstructuraDet_Del", arrPar);
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
