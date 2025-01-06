using System;
using System.Data;
using System.Data.SqlClient;
using System.Collections;
using System.Collections.Specialized;
using Microsoft.ApplicationBlocks.Data;
using Contabilidad.Entity;

namespace Contabilidad.DataAccess
{

    public class DACFacturasGenerar : Base
    {
        #region GetList
        public static DataTable GetList(Entity_FacturasGenerar obj)
        {
            DataSet ds;

            SqlParameter[] arrPar = new SqlParameter[2];
            arrPar[0] = new SqlParameter("@intProspecto", SqlDbType.Int);
            arrPar[0].Value = obj.intProspecto;

            try
            {
                ds = SqlHelper.ExecuteDataset(ConnectionString, CommandType.StoredProcedure, "vetecmarfiladmin..usp_tbFacturasGenerar_list", arrPar);
                return ds.Tables[0];
            }
            catch (Exception e)
            {
                throw e;
            }

        }
        #endregion

        #region Save
        public static bool Save(Entity_FacturasGenerar obj)
        {
            bool intResult = false;

            SqlParameter[] arrPar = new SqlParameter[12];
            arrPar[0] = new SqlParameter("@intProspecto", SqlDbType.Int);
            arrPar[0].Value = obj.intProspecto;
            arrPar[1] = new SqlParameter("@strRFC", SqlDbType.VarChar);
            arrPar[1].Value = obj.strRFC;
            arrPar[2] = new SqlParameter("@strSerie", SqlDbType.VarChar);
            arrPar[2].Value = obj.strSerie;
            arrPar[3] = new SqlParameter("@strFolio", SqlDbType.VarChar);
            arrPar[3].Value = obj.decFolio;
            arrPar[4] = new SqlParameter("@strFecha", SqlDbType.VarChar);
            arrPar[4].Value = obj.datFechaGen;
            arrPar[5] = new SqlParameter("@strUsoCFDI", SqlDbType.VarChar);
            arrPar[5].Value = obj.strUsoCFDI;
            arrPar[6] = new SqlParameter("@strFormaPago", SqlDbType.VarChar);
            arrPar[6].Value = obj.strFormaPago;
            arrPar[7] = new SqlParameter("@strMetodoPago", SqlDbType.VarChar);
            arrPar[7].Value = obj.strMetodopago;
            arrPar[8] = new SqlParameter("@strProducto", SqlDbType.VarChar);
            arrPar[8].Value = obj.strProducto;
            arrPar[9] = new SqlParameter("@strUsuarioAlta", SqlDbType.VarChar);
            arrPar[9].Value = obj.StrUsuario;
            arrPar[10] = new SqlParameter("@strMaquinaAlta", SqlDbType.VarChar);
            arrPar[10].Value = obj.StrMaquina;
            arrPar[11] = new SqlParameter("@dblImporte", SqlDbType.Decimal);
            arrPar[11].Value = obj.dblImporte;

            try
            {
                SqlHelper.ExecuteNonQuery(ConnectionString, CommandType.StoredProcedure, "vetecmarfiladmin..usp_tbFacturasGenerar_Save", arrPar);
                intResult = true;
            }
            catch (Exception e)
            {
                throw e;
            }

            return intResult;
        }
        #endregion

        #region SaveMafesa
        public static bool SaveMafesa(Entity_FacturasGenerar obj)
        {
            bool result = false;
            SqlParameter[] arrPar = new SqlParameter[12];
            arrPar[0] = new SqlParameter("@strRFC", SqlDbType.VarChar);
            arrPar[0].Value = obj.strRFC;
            arrPar[1] = new SqlParameter("@strSerie", SqlDbType.VarChar);
            arrPar[1].Value = obj.strSerie;
            arrPar[2] = new SqlParameter("@strFolio", SqlDbType.VarChar);
            arrPar[2].Value = obj.decFolio;
            arrPar[3] = new SqlParameter("@strFecha", SqlDbType.VarChar);
            arrPar[3].Value = obj.datFechaGen;
            arrPar[4] = new SqlParameter("@strUsoCFDI", SqlDbType.VarChar);
            arrPar[4].Value = obj.strUsoCFDI;
            arrPar[5] = new SqlParameter("@strFormaPago", SqlDbType.VarChar);
            arrPar[5].Value = obj.strFormaPago;
            arrPar[6] = new SqlParameter("@strMetodoPago", SqlDbType.VarChar);
            arrPar[6].Value = obj.strMetodopago;
            arrPar[7] = new SqlParameter("@strProducto", SqlDbType.VarChar);
            arrPar[7].Value = obj.strProducto;
            arrPar[8] = new SqlParameter("@strUsuarioAlta", SqlDbType.VarChar);
            arrPar[8].Value = obj.StrUsuario;
            arrPar[9] = new SqlParameter("@strMaquinaAlta", SqlDbType.VarChar);
            arrPar[9].Value = obj.StrMaquina;
            arrPar[10] = new SqlParameter("@dblImporte", SqlDbType.Decimal);
            arrPar[10].Value = obj.dblImporte;
            arrPar[11] = new SqlParameter("@strFolioFiscal", SqlDbType.VarChar);
            arrPar[11].Value = obj.StrInsumoInicial;

            try
            {
                SqlHelper.ExecuteNonQuery(ConnectionString, CommandType.StoredProcedure, "vetecmarfiladmin..usp_tbFacturasMafesa_Save", arrPar);
                result = true;
            }
            catch (Exception e)
            {
                throw e;
            }

            return result;
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
        public static bool  Delete(Entity_FacturasGenerar obj)
        {
            bool result = false;
            SqlParameter[] arrParDet = new SqlParameter[7];
            arrParDet[0] = new SqlParameter("@intProspecto", SqlDbType.Int);
            arrParDet[0].Value = obj.intProspecto;
            arrParDet[1] = new SqlParameter("@intFactura", SqlDbType.Int);
            arrParDet[1].Value = obj.intFactura;
            arrParDet[2] = new SqlParameter("@intDocumento", SqlDbType.Int);
            arrParDet[2].Value = obj.intDocumento;

            try
            {
                SqlHelper.ExecuteNonQuery(ConnectionString, CommandType.StoredProcedure, "VetecMarfilAdmin..usp_tbFacturasGenerar_Del", arrParDet);
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

        #region GetListMafesa
        public static DataTable GetListMafesa()
        {
            DataSet ds;

            try
            {
                ds = SqlHelper.ExecuteDataset(ConnectionString, CommandType.Text, "EXEC vetecmarfiladmin..usp_tbFacturasMafesa_list");
                return ds.Tables[0];
            }
            catch (Exception e)
            {
                throw e;
            }

        }
        #endregion

        #region DeleteMafesa
        public static bool DeleteMafesa(Entity_FacturasGenerar obj)
        {
            bool result = false;

            SqlParameter[] arrParDet = new SqlParameter[1];
            arrParDet[0] = new SqlParameter("@Factura", SqlDbType.VarChar);
            arrParDet[0].Value = obj.strFormaPago;

            try
            {
                SqlHelper.ExecuteNonQuery(ConnectionString, CommandType.StoredProcedure, "VetecMarfilAdmin..usp_tbFacturasMafesa_Del", arrParDet);
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
