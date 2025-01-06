/*
'===============================================================================
'  Company: RMM
'  Autor: Rubén Mora Martínez
'  Date: 2011-07-29
'  **** Generated by MyGeneration Version # (1.3.0.3) ****
'===============================================================================
*/

using System;
using System.Data;
using System.Data.SqlClient;
using System.Collections;
using System.Collections.Specialized;
using Microsoft.ApplicationBlocks.Data;
using Contabilidad.Entity;

namespace Contabilidad.DataAccess
{
    public class DACPolizaDet : Base
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
                value = SqlHelper.ExecuteScalar(ConnectionString, CommandType.StoredProcedure, "VetecMarfilAdmin..usp_tbPolizasDet_Help", arrPar).ToString();
                return value;
            }
            catch (Exception e)
            {
                return "";
            }
        }
        #endregion

        #region QueryHelpData
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
                value = SqlHelper.ExecuteDataset(ConnectionString, CommandType.StoredProcedure, "VetecMarfilAdmin..usp_tbPolizasDet_Help", arrPar);
                return value;
            }
            catch (Exception e)
            {
                return null;
            }
        }
        #endregion

        #region Save
        public static string Save(Entity_PolizasDet obj)
        {
            string result = "";

            SqlParameter[] arrParDet = new SqlParameter[15];
            arrParDet[0] = new SqlParameter("@intEmpresa", SqlDbType.Int);
            arrParDet[0].Value = obj.IntEmpresa;
            arrParDet[1] = new SqlParameter("@strPoliza", SqlDbType.VarChar);
            arrParDet[1].Value = obj.strPoliza;
            arrParDet[2] = new SqlParameter("@strTipoPoliza", SqlDbType.VarChar);
            arrParDet[2].Value = obj.strTipoPoliza;
            arrParDet[3] = new SqlParameter("@datFecha", SqlDbType.DateTime);
            arrParDet[3].Value = obj.datFecha;
            arrParDet[4] = new SqlParameter("@intPartida", SqlDbType.Int);
            arrParDet[4].Value = obj.intPartida;
            arrParDet[5] = new SqlParameter("@strCuenta", SqlDbType.VarChar);
            arrParDet[5].Value = obj.strCuenta;
            arrParDet[6] = new SqlParameter("@strAxiliar", SqlDbType.VarChar);
            arrParDet[6].Value = obj.strKeys;
            arrParDet[7] = new SqlParameter("@strObra", SqlDbType.VarChar);
            arrParDet[7].Value = obj.StrObraInicial;
            arrParDet[8] = new SqlParameter("@strReferencia", SqlDbType.VarChar);
            arrParDet[8].Value = obj.strReferencia;
            arrParDet[9] = new SqlParameter("@strConcepto", SqlDbType.VarChar);
            arrParDet[9].Value = obj.strDescripcion;
            arrParDet[10] = new SqlParameter("@dblCargos", SqlDbType.Decimal);
            arrParDet[10].Value = obj.dblImporte; //Solo para pasar valor de cargo
            arrParDet[11] = new SqlParameter("@dblAbonos", SqlDbType.Decimal);
            arrParDet[11].Value = obj.dblImporteTipoMoneda; //Solo para pasar valor de abono
            arrParDet[12] = new SqlParameter("@strUsuario", SqlDbType.VarChar);
            arrParDet[12].Value = obj.StrUsuario;
            arrParDet[13] = new SqlParameter("@strMaquina", SqlDbType.VarChar);
            arrParDet[13].Value = obj.StrMaquina;
            arrParDet[14] = new SqlParameter("@intConceptoPago", SqlDbType.Int);
            arrParDet[14].Value = obj.IntParametroInicial;

            try
            {
                result = SqlHelper.ExecuteScalar(ConnectionString, CommandType.StoredProcedure, "VetecMarfilAdmin..usp_tbPolizasDet_Save", arrParDet).ToString();
            }
            catch (Exception e)
            {
                throw e;
            }

            return result;
        }

        #endregion

        #region Balanza
        public static DataTable Balanza(Entity_Conciliaciones obj)
        {
            DataSet ds;

            SqlParameter[] arrPar = new SqlParameter[16];
            arrPar[0] = new SqlParameter("@intEmpresa", SqlDbType.Int);
            arrPar[0].Value = obj.IntEmpresa;
            arrPar[1] = new SqlParameter("@intEjercicioIni", SqlDbType.Int);
            arrPar[1].Value = obj.IntEjercicioInicial;
            arrPar[2] = new SqlParameter("@intEjercicioIniFin", SqlDbType.Int);
            arrPar[2].Value = obj.IntEjercicioFinal;
            arrPar[3] = new SqlParameter("@intMesIni", SqlDbType.Int);
            arrPar[3].Value = obj.IntMesInicial;
            arrPar[4] = new SqlParameter("@intMesFin", SqlDbType.Int);
            arrPar[4].Value = obj.IntMesFinal;
            arrPar[5] = new SqlParameter("@strCuentaIni", SqlDbType.VarChar);
            arrPar[5].Value = obj.StrFechaInicial;
            arrPar[6] = new SqlParameter("@strCuentaFin", SqlDbType.VarChar);
            arrPar[6].Value = obj.StrFechaFinal;
            arrPar[7] = new SqlParameter("@strObra", SqlDbType.VarChar);
            arrPar[7].Value = obj.StrObraInicial;
            arrPar[8] = new SqlParameter("@strObraFin", SqlDbType.VarChar);
            arrPar[8].Value = obj.StrObraFinal;
            arrPar[9] = new SqlParameter("@intAreaIni", SqlDbType.Int);
            arrPar[9].Value = obj.IntProveedorInicial;
            arrPar[10] = new SqlParameter("@intAreaFin", SqlDbType.Int);
            arrPar[10].Value = obj.IntProveedorFinal;
            arrPar[11] = new SqlParameter("@intColIni", SqlDbType.Int);
            arrPar[11].Value = obj.IntParametroInicial;
            arrPar[12] = new SqlParameter("@intColFin", SqlDbType.Int);
            arrPar[12].Value = obj.IntParametroFinal;
            arrPar[13] = new SqlParameter("@intSectorIni", SqlDbType.Int);
            arrPar[13].Value = obj.StrInsumoInicial;
            arrPar[14] = new SqlParameter("@intSectorFin", SqlDbType.Int);
            arrPar[14].Value = obj.StrInsumoFinal;
            arrPar[15] = new SqlParameter("@intCero", SqlDbType.Int);
            arrPar[15].Value = obj.IntEjercicio;

            try
            {
                ds = SqlHelper.ExecuteDataset(ConnectionString, CommandType.StoredProcedure, "VetecMarfilAdmin..usp_tbPolizasDet_Balanza", arrPar);
                return ds.Tables[0];
            }
            catch (Exception e)
            {
                return null;
            }
        }
        #endregion 
		
        #region BalanzaCuenta
        public static DataTable BalanzaCuenta(Entity_Conciliaciones obj)
        {
            DataSet ds;

            SqlParameter[] arrPar = new SqlParameter[15];
            arrPar[0] = new SqlParameter("@intEmpresa", SqlDbType.Int);
            arrPar[0].Value = obj.IntEmpresa;
            arrPar[1] = new SqlParameter("@intEjercicio", SqlDbType.Int);
            arrPar[1].Value = obj.IntEjercicio;
            arrPar[2] = new SqlParameter("@intMes", SqlDbType.Int);
            arrPar[2].Value = obj.IntMes;
            arrPar[3] = new SqlParameter("@intNivel", SqlDbType.Int);
            arrPar[3].Value = obj.IntFolio;
            arrPar[4] = new SqlParameter("@strCuentaIni", SqlDbType.VarChar);
            arrPar[4].Value = obj.StrFechaInicial;
            arrPar[5] = new SqlParameter("@strCuentaFin", SqlDbType.VarChar);
            arrPar[5].Value = obj.StrFechaFinal;
            arrPar[6] = new SqlParameter("@strObra", SqlDbType.VarChar);
            arrPar[6].Value = obj.StrObraInicial;
            arrPar[7] = new SqlParameter("@strObraFin", SqlDbType.VarChar);
            arrPar[7].Value = obj.StrObraFinal;
            arrPar[8] = new SqlParameter("@intAreaIni", SqlDbType.Int);
            arrPar[8].Value = obj.IntProveedorInicial;
            arrPar[9] = new SqlParameter("@intAreaFin", SqlDbType.Int);
            arrPar[9].Value = obj.IntProveedorFinal;
            arrPar[10] = new SqlParameter("@intColIni", SqlDbType.Int);
            arrPar[10].Value = obj.IntParametroInicial;
            arrPar[11] = new SqlParameter("@intColFin", SqlDbType.Int);
            arrPar[11].Value = obj.IntParametroFinal;
            arrPar[12] = new SqlParameter("@intSectorIni", SqlDbType.Int);
            arrPar[12].Value = obj.StrInsumoInicial;
            arrPar[13] = new SqlParameter("@intSectorFin", SqlDbType.Int);
            arrPar[13].Value = obj.StrInsumoFinal;
            arrPar[14] = new SqlParameter("@intCargo", SqlDbType.Int);
            arrPar[14].Value = obj.IntEjercicioRef;

            try
            {
                ds = SqlHelper.ExecuteDataset(ConnectionString, CommandType.StoredProcedure, "VetecMarfilAdmin..usp_tbPolizasDet_BalanzaCuenta", arrPar);
                return ds.Tables[0];
            }
            catch (Exception e)
            {
                return null;
            }
        }
        #endregion 

        #region Sel
        public static DataTable Sel(Entity_PolizasDet obj)
        {
            string result = "";

            SqlParameter[] arrParDet = new SqlParameter[3];
            arrParDet[0] = new SqlParameter("@intEmpresa", SqlDbType.Int);
            arrParDet[0].Value = obj.IntEmpresa;
            arrParDet[1] = new SqlParameter("@intEjercicio", SqlDbType.Int);
            arrParDet[1].Value = obj.intEjercicio;
            arrParDet[2] = new SqlParameter("@strTipoPoliza", SqlDbType.VarChar);
            arrParDet[2].Value = obj.strTipoPoliza;

            DataSet ds;

            try
            {
                ds = SqlHelper.ExecuteDataset(ConnectionString, CommandType.StoredProcedure, "usp_PolizasDet_Sel", arrParDet);
                return ds.Tables[0];
            }
            catch (Exception e)
            {
                return null;
            }

        }
        #endregion

        #region ListAux
        public static DataTable ListAux(int intEmpresa)
        {
            DataSet ds;

            SqlParameter[] arrParDet = new SqlParameter[5];
            arrParDet[0] = new SqlParameter("@intEmpresa", SqlDbType.Int);
            arrParDet[0].Value = intEmpresa;

            try
            {
                ds = SqlHelper.ExecuteDataset(ConnectionString, CommandType.StoredProcedure, "VetecMarfilAdmin..usp_tbPolizasDet_ListAux", arrParDet);
                return ds.Tables[0];
            }
            catch (Exception e)
            {
                return null;
            }
        }

        #endregion

        #region GetList
        public static DataTable GetList(Entity_PolizasDet obj)
        {
            DataSet ds;

            SqlParameter[] arrPar = new SqlParameter[13];
            arrPar[0] = new SqlParameter("@intEmpresa", SqlDbType.Int);
            arrPar[0].Value = obj.IntEmpresa;
            arrPar[1] = new SqlParameter("@strPoliza", SqlDbType.VarChar);
            arrPar[1].Value = obj.strPoliza;
            arrPar[2] = new SqlParameter("@intEjercicio", SqlDbType.Int);
            arrPar[2].Value = obj.intEjercicio;
            arrPar[3] = new SqlParameter("@intDirection", SqlDbType.Int);
            arrPar[3].Value = obj.SortDirection;
            arrPar[4] = new SqlParameter("@SortExpression", SqlDbType.VarChar);
            arrPar[4].Value = obj.SortExpression;
            arrPar[5] = new SqlParameter("@NumPage", SqlDbType.Int);
            arrPar[5].Value = obj.iNumPage;
            arrPar[6] = new SqlParameter("@NumRecords", SqlDbType.Int);
            arrPar[6].Value = obj.iNumRecords;
            arrPar[7] = new SqlParameter("@TotalRows", SqlDbType.Int);
            arrPar[7].Direction = ParameterDirection.Output;
            arrPar[8] = new SqlParameter("@TotalPage", SqlDbType.Int);
            arrPar[8].Direction = ParameterDirection.Output;
            arrPar[9] = new SqlParameter("@TotalAbonos", SqlDbType.Decimal);
            arrPar[9].Scale = 2;
            arrPar[9].Direction = ParameterDirection.Output;
            arrPar[10] = new SqlParameter("@TotalCargos", SqlDbType.Decimal);
            arrPar[10].Scale = 2;
            arrPar[10].Direction = ParameterDirection.Output;
            arrPar[11] = new SqlParameter("@TotalDiferencia", SqlDbType.Decimal);
            arrPar[11].Scale = 2;
            arrPar[11].Direction = ParameterDirection.Output;
            arrPar[12] = new SqlParameter("@Partida", SqlDbType.Int);
            arrPar[12].Direction = ParameterDirection.Output;  


            try
            {
                ds = SqlHelper.ExecuteDataset(ConnectionString, CommandType.StoredProcedure, "VetecMarfilAdmin..usp_tbPolizasDet_List", arrPar);
                obj.IntTotalPages = (int)arrPar[8].Value;
                obj.IntTotalRecords = (int)arrPar[7].Value;
                obj.DblCargos = arrPar[9].Value == DBNull.Value ? 0 : Convert.ToDecimal(arrPar[9].Value);
                obj.DblAbonos = arrPar[10].Value == DBNull.Value ? 0 : Convert.ToDecimal(arrPar[10].Value);
                obj.DblTotal = arrPar[11].Value == DBNull.Value ? 0 : Convert.ToDecimal(arrPar[11].Value);
                obj.intPartida = (int)arrPar[12].Value;
                return ds.Tables[0];
            }
            catch (Exception e)
            {
                throw e;
            }
        }

        #endregion

        #region Delete
        public static string Delete(Entity_PolizasDet obj)
        {
            string result = "";

            SqlParameter[] arrParDet = new SqlParameter[7];
            arrParDet[0] = new SqlParameter("@intEmpresa", SqlDbType.Int);
            arrParDet[0].Value = obj.IntEmpresa;
            arrParDet[1] = new SqlParameter("@strPoliza", SqlDbType.VarChar);
            arrParDet[1].Value = obj.strPoliza;
            arrParDet[2] = new SqlParameter("@strTipoPoliza", SqlDbType.VarChar);
            arrParDet[2].Value = obj.strTipoPoliza;
            arrParDet[3] = new SqlParameter("@intPartida", SqlDbType.Int);
            arrParDet[3].Value = obj.intPartida;
            arrParDet[4] = new SqlParameter("@datFecha", SqlDbType.DateTime);
            arrParDet[4].Value = obj.datFecha;
            arrParDet[5] = new SqlParameter("@strUsuario", SqlDbType.VarChar);
            arrParDet[5].Value = obj.StrUsuario; ;
            arrParDet[6] = new SqlParameter("@strMaquina", SqlDbType.VarChar);
            arrParDet[6].Value = obj.StrMaquina;

            try
            {
                result = SqlHelper.ExecuteScalar(ConnectionString, CommandType.StoredProcedure, "VetecMarfilAdmin..usp_tbPolizasDet_Delete", arrParDet).ToString();
            }
            catch (Exception e)
            {
                throw e;
            }

            return result;
        }
        #endregion

        #region DeleteAll
        public static string DeleteAll(Entity_PolizasDet obj)
        {
            string result = "";

            SqlParameter[] arrParDet = new SqlParameter[5];
            arrParDet[0] = new SqlParameter("@intEmpresa", SqlDbType.Int);
            arrParDet[0].Value = obj.IntEmpresa;
            arrParDet[1] = new SqlParameter("@strPoliza", SqlDbType.VarChar);
            arrParDet[1].Value = obj.strPoliza;
            arrParDet[2] = new SqlParameter("@intEjercicio", SqlDbType.Int);
            arrParDet[2].Value = obj.intEjercicio;          
            arrParDet[3] = new SqlParameter("@strUsuario", SqlDbType.VarChar);
            arrParDet[3].Value = obj.StrUsuario; ;
            arrParDet[4] = new SqlParameter("@strMaquina", SqlDbType.VarChar);
            arrParDet[4].Value = obj.StrMaquina;

            try
            {
                result = SqlHelper.ExecuteScalar(ConnectionString, CommandType.StoredProcedure, "VetecMarfilAdmin..usp_tbPolizasDet_DeleteAll", arrParDet).ToString();
            }
            catch (Exception e)
            {
                throw e;
            }

            return result;
        }
        #endregion

        #region SelXML
        public static DataTable SelXML(Entity_PolizasDet obj)
        {
            string result = "";

            SqlParameter[] arrParDet = new SqlParameter[3];
            arrParDet[0] = new SqlParameter("@intEmpresa", SqlDbType.Int);
            arrParDet[0].Value = obj.IntEmpresa;
            arrParDet[1] = new SqlParameter("@intEjercicio", SqlDbType.Int);
            arrParDet[1].Value = obj.intEjercicio;
            arrParDet[2] = new SqlParameter("@strPoliza", SqlDbType.VarChar);
            arrParDet[2].Value = obj.strPoliza;

            DataSet ds;

            try
            {
                ds = SqlHelper.ExecuteDataset(ConnectionString, CommandType.StoredProcedure, "vetecmarfiladmin..usp_tbPolizasDet_XML", arrParDet);
                return ds.Tables[0];
            }
            catch (Exception e)
            {
                return null;
            }

        }
        #endregion

        #region SelCuentaXML
        public static DataTable SelCuentaXML(Entity_PolizasDet obj)
        {
            string result = "";

            SqlParameter[] arrParDet = new SqlParameter[4];
            arrParDet[0] = new SqlParameter("@intEmpresa", SqlDbType.Int);
            arrParDet[0].Value = obj.IntEmpresa;
            arrParDet[1] = new SqlParameter("@intEjercicio", SqlDbType.Int);
            arrParDet[1].Value = obj.intEjercicio;
            arrParDet[2] = new SqlParameter("@intMes", SqlDbType.Int);
            arrParDet[2].Value = obj.intMes;
            arrParDet[3] = new SqlParameter("@strCuenta", SqlDbType.VarChar);
            arrParDet[3].Value = obj.strCuenta;

            DataSet ds;

            try
            {
                ds = SqlHelper.ExecuteDataset(ConnectionString, CommandType.StoredProcedure, "vetecmarfiladmin..usp_tbPolizasDet_XML_Cuenta", arrParDet);
                return ds.Tables[0];
            }
            catch (Exception e)
            {
                return null;
            }

        }
        #endregion

        #region SelAuxFolios
        public static DataTable SelAuxFolios(Entity_PolizasDet obj)
        {
            string result = "";

            SqlParameter[] arrParDet = new SqlParameter[4];
            arrParDet[0] = new SqlParameter("@intEmpresa", SqlDbType.Int);
            arrParDet[0].Value = obj.IntEmpresa;
            arrParDet[1] = new SqlParameter("@intEjercicio", SqlDbType.Int);
            arrParDet[1].Value = obj.intEjercicio;
            arrParDet[2] = new SqlParameter("@intMes", SqlDbType.Int);
            arrParDet[2].Value = obj.intMes;
            arrParDet[3] = new SqlParameter("@strPoliza", SqlDbType.VarChar);
            arrParDet[3].Value = obj.strPoliza;

            DataSet ds;

            try
            {
                ds = SqlHelper.ExecuteDataset(ConnectionString, CommandType.StoredProcedure, "vetecmarfiladmin..usp_tbPolizasDet_XML_AuxFol", arrParDet);
                return ds.Tables[0];
            }
            catch (Exception e)
            {
                return null;
            }

        }
        #endregion

	}
}