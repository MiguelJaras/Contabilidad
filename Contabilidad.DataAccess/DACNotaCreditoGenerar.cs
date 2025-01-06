using System;
using System.Data;
using System.Data.SqlClient;
using System.Collections;
using System.Collections.Specialized;
using Microsoft.ApplicationBlocks.Data;
using Contabilidad.Entity;

namespace Contabilidad.DataAccess
{

    public class DACNotaCreditoGenerar : Base
    {
        #region GetList
        public static DataTable GetList(EntityNotaCreditoGenerar obj)
        {
            DataSet ds;

            SqlParameter[] arrPar = new SqlParameter[2];
            arrPar[0] = new SqlParameter("@intProspecto", SqlDbType.Int);
            arrPar[0].Value = obj.intProspecto;

            try
            {
                ds = SqlHelper.ExecuteDataset(ConnectionString, CommandType.StoredProcedure, "vetecmarfiladmin..usp_tbNotaCreditoGenerar_list", arrPar);
                return ds.Tables[0];
            }
            catch (Exception e)
            {
                throw e;
            }

        }
        #endregion

        #region Save
        public static bool Save(EntityNotaCreditoGenerar obj)
        {
            bool intResult = false;

            SqlParameter[] arrPar = new SqlParameter[14];
            arrPar[0] = new SqlParameter("@intProspecto", SqlDbType.Int);
            arrPar[0].Value = obj.intProspecto;
            arrPar[1] = new SqlParameter("@strRFC", SqlDbType.VarChar);
            arrPar[1].Value = obj.strRFC;
            arrPar[2] = new SqlParameter("@strSerie", SqlDbType.VarChar);
            arrPar[2].Value = obj.strSerie;
            arrPar[3] = new SqlParameter("@strFolio", SqlDbType.VarChar);
            arrPar[3].Value = obj.decFolio;
            arrPar[4] = new SqlParameter("@strSerieFactura", SqlDbType.VarChar);
            arrPar[4].Value = obj.strSerieFactura;
            arrPar[5] = new SqlParameter("@decFolioFactura", SqlDbType.VarChar);
            arrPar[5].Value = obj.decFolioFactura;
            arrPar[6] = new SqlParameter("@strFecha", SqlDbType.VarChar);
            arrPar[6].Value = obj.datFechaGen;
            arrPar[7] = new SqlParameter("@strUsoCFDI", SqlDbType.VarChar);
            arrPar[7].Value = obj.strUsoCFDI;
            arrPar[8] = new SqlParameter("@strFormaPago", SqlDbType.VarChar);
            arrPar[8].Value = obj.strFormaPago;
            arrPar[9] = new SqlParameter("@strMetodoPago", SqlDbType.VarChar);
            arrPar[9].Value = obj.strMetodopago;
            arrPar[10] = new SqlParameter("@strRegimenFiscal", SqlDbType.VarChar);
            arrPar[10].Value = obj.strRegimenFiscal;
            arrPar[11] = new SqlParameter("@strUsuarioAlta", SqlDbType.VarChar);
            arrPar[11].Value = obj.StrUsuario;
            arrPar[12] = new SqlParameter("@strMaquinaAlta", SqlDbType.VarChar);
            arrPar[12].Value = obj.StrMaquina;
            arrPar[13] = new SqlParameter("@dblImporte", SqlDbType.Decimal);
            arrPar[13].Value = obj.dblImporte;        

            try
            {
                SqlHelper.ExecuteNonQuery(ConnectionString, CommandType.StoredProcedure, "vetecmarfiladmin..usp_tbNotaCreditoGenerar_Save", arrPar);
                intResult = true;
            }
            catch (Exception e)
            {
                throw e;
            }

            return intResult;
        }
        #endregion

        #region DocumentosSave
        public static string DocumentosSave(int intEmpresa, int intSucursal, int intProspecto, int intGrupoDocumento, int intTipoDocumento, byte[] _Documento, string strNombreDocumento, string strUsuarioAlta, string strMaquinaAlta)
        {

            string s1 = string.Empty;

            try
            {
                SqlParameter[] arrPar = new SqlParameter[52];
                arrPar[0] = new SqlParameter("@intEmpresa", SqlDbType.Int);
                arrPar[0].Value = intEmpresa;
                arrPar[1] = new SqlParameter("@intSucursal", SqlDbType.Int);
                arrPar[1].Value = intSucursal;
                arrPar[2] = new SqlParameter("@intProspecto", SqlDbType.Int);
                arrPar[2].Value = intProspecto;
                arrPar[3] = new SqlParameter("@intGrupoDocumento", SqlDbType.Int);
                arrPar[3].Value = intGrupoDocumento;
                arrPar[4] = new SqlParameter("@intTipoDocumento", SqlDbType.Int);
                arrPar[4].Value = intTipoDocumento;
                arrPar[5] = new SqlParameter("@Documento", SqlDbType.VarBinary);
                arrPar[5].Value = _Documento;
                arrPar[6] = new SqlParameter("@strNombreDocumento", SqlDbType.VarChar);
                arrPar[6].Value = strNombreDocumento;
                arrPar[7] = new SqlParameter("@strUsuarioAlta", SqlDbType.VarChar);
                arrPar[7].Value = strUsuarioAlta;
                arrPar[8] = new SqlParameter("@strMaquinaAlta", SqlDbType.VarChar);
                arrPar[8].Value = strMaquinaAlta;

                SqlHelper.ExecuteScalar(ConnectionString, CommandType.StoredProcedure, "dbDigitalizacion..usp_tbProspectoDocumentos_Save", arrPar);
                s1 = "true";

            }
            catch (Exception e)
            {
                throw e;
            }
            return s1;
        }
        #endregion DocumentosSave

        #region Delete
        public static bool Delete(EntityNotaCreditoGenerar obj)
        {
            bool result = false;

            SqlParameter[] arrParDet = new SqlParameter[7];
            arrParDet[0] = new SqlParameter("@intProspecto", SqlDbType.Int);
            arrParDet[0].Value = obj.intProspecto;
            arrParDet[1] = new SqlParameter("@intNotaCredito", SqlDbType.Int);
            arrParDet[1].Value = obj.intNotaCredito;
            arrParDet[2] = new SqlParameter("@intDocumento", SqlDbType.Int);
            arrParDet[2].Value = obj.intDocumento;

            try
            {
                SqlHelper.ExecuteNonQuery(ConnectionString, CommandType.StoredProcedure, "VetecMarfilAdmin..usp_tbNotaCreditoGenerar_Del", arrParDet);
                result = true;
            }
            catch (Exception e)
            {
                result = false;
                throw e;                
            }

            return result;
        }
        #endregion
    }
}
