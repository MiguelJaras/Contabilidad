using System;
using System.Data;
using System.Data.SqlClient;
using System.Collections;
using System.Collections.Specialized;
using Microsoft.ApplicationBlocks.Data;
using Contabilidad.Entity;

namespace Contabilidad.DataAccess
{
    public class DACTiposPoliza : Base
    {
        //[usp_tbTiposPoliza_Det]

        #region RptPolizasDet
        public static DataTable RptPolizasDet(int intEmpresa, int intEjerc, int intMes, string strTipoPolizaIni, string strTipoPolizaFin, int intFolioIni, int intFolioFin, int intAfectada, int intDesAfectada, int intCancelada, int intTipoImpresion)
        {
            IDataReader drd;
            DataSet ds;
            Entity_TiposPoliza oEntity_TiposPoliza;
            oEntity_TiposPoliza = new Entity_TiposPoliza();

            SqlParameter[] arrPar = new SqlParameter[11];
            arrPar[0] = new SqlParameter("@intEmpresa", SqlDbType.Int);
            arrPar[0].Value = intEmpresa;
            arrPar[1] = new SqlParameter("@intEjerc", SqlDbType.Int);
            arrPar[1].Value = intEjerc;
            arrPar[2] = new SqlParameter("@intMes", SqlDbType.Int );
            arrPar[2].Value = intMes;
            arrPar[3] = new SqlParameter("@strTipoPolizaIni", SqlDbType.VarChar );
            arrPar[3].Value = strTipoPolizaIni;
            arrPar[4] = new SqlParameter("@strTipoPolizaFin", SqlDbType.VarChar );
            arrPar[4].Value = strTipoPolizaFin;
            arrPar[5] = new SqlParameter("@intFolioIni", SqlDbType.Int );
            arrPar[5].Value = intFolioIni;
            arrPar[6] = new SqlParameter("@intFolioFin", SqlDbType.Int);
            arrPar[6].Value = intFolioFin;
            arrPar[7] = new SqlParameter("@intAfectada", SqlDbType.Int);
            arrPar[7].Value = intAfectada;
            arrPar[8] = new SqlParameter("@intDesAfectada", SqlDbType.Int );
            arrPar[8].Value = intDesAfectada;
            arrPar[9] = new SqlParameter("@intCancelada", SqlDbType.Int);
            arrPar[9].Value = intCancelada;
            arrPar[10] = new SqlParameter("@intTipoImpresion", SqlDbType.Int);
            arrPar[10].Value = intTipoImpresion;
         
            try
            {
                ds = SqlHelper.ExecuteDataset(ConnectionString, CommandType.StoredProcedure, "VetecMarfilAdmin..usp_tbPolizasDet_Print", arrPar);
                return ds.Tables[0];
            }
            catch (Exception e)
            {
                return null;
            }
        }
        #endregion

        #region Sel
        public static DataTable Det(Entity_TiposPoliza obj)
        {
            IDataReader drd;
            DataSet ds;
            Entity_TiposPoliza oEntity_TiposPoliza;
            oEntity_TiposPoliza = new Entity_TiposPoliza();

            SqlParameter[] arrPar = new SqlParameter[3];
            arrPar[0] = new SqlParameter("@intEmpresa", SqlDbType.Int);
            arrPar[0].Value = obj.IntEmpresa;
            arrPar[1] = new SqlParameter("@intEjercicio", SqlDbType.Int);
            arrPar[1].Value = obj.intEjercicio;
            arrPar[2] = new SqlParameter("@strTipoPoliza", SqlDbType.VarChar );
            arrPar[2].Value = obj.strTipoPoliza;

            try
            {
                ds = SqlHelper.ExecuteDataset(ConnectionString, CommandType.StoredProcedure, "VetecMarfilAdmin..usp_tbTiposPoliza_Det", arrPar);
                return ds.Tables[0];
            }
            catch (Exception e)
            {
                return null;
            }
        }
        #endregion

        #region Sel
        public static DataTable Sel(Entity_TiposPoliza obj)
        {
            IDataReader drd;
            DataSet ds;
            Entity_TiposPoliza oEntity_TiposPoliza;
            oEntity_TiposPoliza = new Entity_TiposPoliza();

            SqlParameter[] arrPar = new SqlParameter[2];
            arrPar[0] = new SqlParameter("@intEmpresa", SqlDbType.Int);
            arrPar[0].Value = obj.IntEmpresa;
            arrPar[1] = new SqlParameter("@intEjercicio", SqlDbType.Int);
            arrPar[1].Value = obj.intEjercicio;

            try
            {
                ds = SqlHelper.ExecuteDataset(ConnectionString, CommandType.StoredProcedure, "VetecMarfilAdmin..usp_tbTiposPoliza_Fill", arrPar);
                return ds.Tables[0];
            }
            catch (Exception e)
            {
                return null;
            }
        }
        #endregion

        #region ExisteEnc
        public static int ExisteEnc(int intEmpresa, int intEjercicio, int intFolioPoliza, int intMes, string strTipoPoliza)
        {

            int result = 0;

            SqlParameter[] arrPar = new SqlParameter[5];

            arrPar[0] = new SqlParameter("@intEmpresa", SqlDbType.Int);
            arrPar[0].Value = intEmpresa;
            arrPar[1] = new SqlParameter("@intEjercicio", SqlDbType.Int);
            arrPar[1].Value = intEjercicio;
            arrPar[2] = new SqlParameter("@intFolioPoliza", SqlDbType.Int);
            arrPar[2].Value = intFolioPoliza;
            arrPar[3] = new SqlParameter("@intMes", SqlDbType.Int);
            arrPar[3].Value = intMes;
            arrPar[4] = new SqlParameter("@strTipoPoliza", SqlDbType.VarChar);
            arrPar[4].Value = strTipoPoliza;

            try
            {
                result = Convert .ToInt32 ( SqlHelper.ExecuteScalar(ConnectionString, CommandType.StoredProcedure, "VetecMarfilAdmin..usp_tbPolizasEnc_Sel", arrPar));
            }
            catch (Exception e)
            {
                throw e;
            }

            return result;

        }
        #endregion ExisteEnc

        #region Save
        public static bool  Save(int intEmpresa, int intEjercicio, string  strTipoPoliza, int intMes, int valPol)
        {
            bool bResult = false;

            SqlParameter[] arrPar = new SqlParameter[5];

            arrPar[0] = new SqlParameter("@intEmpresa", SqlDbType.Int);
            arrPar[0].Value = intEmpresa;
            arrPar[1] = new SqlParameter("@intEjercicio", SqlDbType.Int);
            arrPar[1].Value = intEjercicio;
            arrPar[2] = new SqlParameter("@strTipoPoliza", SqlDbType.VarChar );
            arrPar[2].Value = strTipoPoliza;
            arrPar[3] = new SqlParameter("@intMes", SqlDbType.Int);
            arrPar[3].Value = intMes;
            arrPar[4] = new SqlParameter("@valPol", SqlDbType.Int);
            arrPar[4].Value = valPol;

            try
            {
                SqlHelper.ExecuteNonQuery(ConnectionString, CommandType.StoredProcedure, "VetecMarfilAdmin..usp_tbTiposPoliza_Save", arrPar);
                bResult = false;
            }
            catch (Exception e)
            {
                throw e;
            }

            return bResult;

        }
        #endregion Save

        #region Fill
        public static Entity_TiposPoliza Fill(Entity_TiposPoliza obj)
        {
            IDataReader drd;
            Entity_TiposPoliza oEntity_Moneda;
            oEntity_Moneda = new Entity_TiposPoliza();

            try
            {
                drd = SqlHelper.ExecuteReader(ConnectionString, CommandType.Text, "SELECT * FROM VetecMarfilAdmin..tbTiposPoliza WHERE intEmpresa = " + obj.IntEmpresa.ToString() + " AND strTipoPoliza =  '" + obj.strTipoPoliza + "' AND intEjercicio = YEAR(GETDATE()) ");
                if (drd.Read())
                {
                    oEntity_Moneda = CreateObject(drd);
                }
            }
            catch (Exception e)
            {
                oEntity_Moneda = null;
            }

            return oEntity_Moneda;
        }
        #endregion

        #region Create
        static Entity_TiposPoliza CreateObject(IDataReader drd)
        {

            Entity_TiposPoliza obj;
            obj = new Entity_TiposPoliza();

            obj.intEmpresa = (int)drd["intEmpresa"];
            obj.strClasifEnc = (string)drd["strClasifEnc"];
            obj.strTipoPoliza = (string)drd["strTipoPoliza"];
            obj.strNombre = (string)drd["strNombre"];

            try
            {
                obj.iNumPage = (int)drd["iTotalPages"];
                obj.iNumRecords = (int)drd["iTotalRecords"];

            }
            catch (Exception e)
            {

            }

            return obj;
        }
        #endregion
    }
}
