using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using System.Data.SqlClient;
using Contabilidad.Entity;
using Microsoft.ApplicationBlocks.Data;

namespace Contabilidad.DataAccess
{
    public class DACGenerarNC:Base
    {
        #region Save
        public static string Save(Entity_GenerarNC obj)
        {
            string result = "";

            SqlParameter[] arrPar = new SqlParameter[12];
            arrPar[0] = new SqlParameter("@intEmpresa", SqlDbType.Int);
            arrPar[0].Value = obj.IntEmpresa;
            arrPar[1] = new SqlParameter("@intTM", SqlDbType.Int);
            arrPar[1].Value = obj.IntTM;
            arrPar[2] = new SqlParameter("@datFecha", SqlDbType.DateTime);
            arrPar[2].Value = obj.DatFecha ;
            arrPar[3] = new SqlParameter("@intFolioOC", SqlDbType.Int);
            arrPar[3].Value = obj.IntFolioOC ;
            arrPar[4] = new SqlParameter("@strConcepto", SqlDbType.VarChar);
            arrPar[4].Value = obj.StrConcepto ;
            arrPar[5] = new SqlParameter("@strFactura", SqlDbType.VarChar);
            arrPar[5].Value = obj.StrFactura ;
            arrPar[6] = new SqlParameter("@dblTotal", SqlDbType.Decimal);
            arrPar[6].Value = obj.DblTotal ;
            arrPar[7] = new SqlParameter("@strFolioFiscal", SqlDbType.VarChar);
            arrPar[7].Value = obj.StrFolioFiscal ;
            arrPar[8] = new SqlParameter("@strNC", SqlDbType.VarChar);
            arrPar[8].Value = obj.StrNC;
            arrPar[9] = new SqlParameter("@strUsuario", SqlDbType.VarChar);
            arrPar[9].Value = obj.StrUsuario ;
            arrPar[10] = new SqlParameter("@strMaquina", SqlDbType.VarChar);
            arrPar[10].Value = obj.StrMaquina ;
            arrPar[11] = new SqlParameter("@datFechaAlta", SqlDbType.DateTime);
            arrPar[11].Value = obj.DatFechaAlta;

            try
            {
                result = SqlHelper.ExecuteScalar(ConnectionString, CommandType.StoredProcedure, "VetecMarfilAdmin..usp_tbGeneracionNC_Save", arrPar).ToString();
            }
            catch (Exception e)
            {
                throw e;
            }

            return result;
        }
        #endregion

        #region Fill
        public static DataTable Fill(Entity_GenerarNC obj)
        {
            DataSet dt = new DataSet();

            SqlParameter[] arrPar = new SqlParameter[3];
            arrPar[0] = new SqlParameter("@intEmpresa", SqlDbType.Int);
            arrPar[0].Value = obj.IntEmpresa;
            arrPar[1] = new SqlParameter("@datFecha", SqlDbType.DateTime);
            arrPar[1].Value = obj.DatFecha;
            arrPar[2] = new SqlParameter("@intFolioOC", SqlDbType.Int);
            arrPar[2].Value = obj.IntFolioOC;

            try
            {
                dt = SqlHelper.ExecuteDataset(ConnectionString, CommandType.StoredProcedure, "VetecMarfilAdmin..usp_tbGeneracionNC_Fill", arrPar);
                return dt.Tables[0];
            }
            catch (Exception e)
            {
                return null;
            }
        }
        #endregion
       

        #region Delete
        //public static string Delete(Entity_PolizasEnc obj)
        //{
        //    string result = "";

        //    SqlParameter[] arrParDet = new SqlParameter[5];
        //    arrParDet[0] = new SqlParameter("@intEmpresa", SqlDbType.Int);
        //    arrParDet[0].Value = obj.IntEmpresa;
        //    arrParDet[1] = new SqlParameter("@strPoliza", SqlDbType.VarChar);
        //    arrParDet[1].Value = obj.strPoliza;
        //    arrParDet[2] = new SqlParameter("@intEjercicio", SqlDbType.Int);
        //    arrParDet[2].Value = obj.intEjercicio;
        //    arrParDet[3] = new SqlParameter("@strUsuario", SqlDbType.VarChar);
        //    arrParDet[3].Value = obj.StrUsuario; ;
        //    arrParDet[4] = new SqlParameter("@strMaquina", SqlDbType.VarChar);
        //    arrParDet[4].Value = obj.StrMaquina;

        //    try
        //    {
        //        result = SqlHelper.ExecuteScalar(ConnectionString, CommandType.StoredProcedure, "VetecMarfilAdmin..usp_tbPolizasEnc_Delete", arrParDet).ToString();
        //    }
        //    catch (Exception e)
        //    {
        //        throw e;
        //    }

        //    return result;
        //}
        #endregion


    }
}
