using System;
using System.Data;
using System.Data.SqlClient;
using System.Collections;
using System.Collections.Specialized;
using Microsoft.ApplicationBlocks.Data;
using Contabilidad.Entity;

namespace Contabilidad.DataAccess
{
    public class DACConciliacion : Base
    {
        #region Save
        public static bool Save(Entity_Conciliacion obj)
        {
            bool resultado=false;
            Entity_Conciliacion oEntity_Conciliacion;
            oEntity_Conciliacion = new Entity_Conciliacion();

            try
            {
                SqlParameter[] Parametro = new SqlParameter[21];
                Parametro[0] = new SqlParameter("@intEmpresa", SqlDbType.Int);
                Parametro[0].Value = obj .IntEmpresa;
                Parametro[1] = new SqlParameter("@intEjercicio", SqlDbType.Int);
                Parametro[1].Value = obj.IntEjercicio;
                Parametro[2] = new SqlParameter("@intMes", SqlDbType.Int);
                Parametro[2].Value = obj.IntMes;
                Parametro[3] = new SqlParameter("@intEjercicioBan", SqlDbType.Int);
                Parametro[3].Value = obj.IntEjercicioBan;
                Parametro[4] = new SqlParameter("@intMesBan", SqlDbType.Int);
                Parametro[4].Value = obj.IntMesBan;
                Parametro[5] = new SqlParameter("@intCuentaBancaria", SqlDbType.Int);
                Parametro[5].Value = obj.IntCuentaBancaria;
                Parametro[6] = new SqlParameter("@intFolio", SqlDbType.Int);
                Parametro[6].Value = obj.IntFolio;
                Parametro[7] = new SqlParameter("@strPoliza", SqlDbType.VarChar);
                Parametro[7].Value = obj.StrPoliza;
                Parametro[8] = new SqlParameter("@intPartida", SqlDbType.Int);
                Parametro[8].Value = obj.IntPartida;
                Parametro[9] = new SqlParameter("@datFecha", SqlDbType.DateTime);
                Parametro[9].Value = obj.DatFecha;
                Parametro[10] = new SqlParameter("@Descripcion", SqlDbType.VarChar);
                Parametro[10].Value = obj.StrConcepto;
                Parametro[11] = new SqlParameter("@Monto", SqlDbType.Decimal);
                Parametro[11].Value = obj.DblImporte;
                Parametro[12] = new SqlParameter("@strReferencia", SqlDbType.VarChar);
                Parametro[12].Value = obj.StrReferencia;
                Parametro[13] = new SqlParameter("@intTipo", SqlDbType.Int);
                Parametro[13].Value = obj.IntTipo;
                Parametro[14] = new SqlParameter("@strUsuario", SqlDbType.VarChar);
                Parametro[14].Value = obj.StrUsuario;
                Parametro[15] = new SqlParameter("@strMaquina", SqlDbType.VarChar);
                Parametro[15].Value = obj.StrMaquina;
                Parametro[16] = new SqlParameter("@intDireccion", SqlDbType.Int);
                Parametro[16].Value = obj.IntDireccion;
                Parametro[17] = new SqlParameter("@intEjercicioRef", SqlDbType.Int);
                Parametro[17].Value = obj.IntEjercicioRef;
                Parametro[18] = new SqlParameter("@intMesRef", SqlDbType.Int);
                Parametro[18].Value = obj.IntMesRef;
                Parametro[19] = new SqlParameter("@dblImporteBanco", SqlDbType.Decimal);
                Parametro[19].Value = obj.DblimporteBanco;
                Parametro[20] = new SqlParameter("@intPartidaBanco", SqlDbType.Int);
                Parametro[20].Value = obj.IntPartidaBanco;

                SqlHelper.ExecuteNonQuery(ConnectionString, CommandType.StoredProcedure, "VetecMarfilAdmin..qryINCN2220_App_tbConciliaciones", Parametro);
                resultado = true;
            }
            catch (Exception e)
            {
                resultado = false;
            }

            return resultado;
        }
        #endregion 

        #region SaveAut
        public static bool SaveAut(Entity_Conciliacion obj)
        {
            bool resultado = false;
            Entity_Conciliacion oEntity_Conciliacion;
            oEntity_Conciliacion = new Entity_Conciliacion();

            try
            {
                SqlParameter[] Parametro = new SqlParameter[6];
                Parametro[0] = new SqlParameter("@intEmpresa", SqlDbType.Int);
                Parametro[0].Value = obj.IntEmpresa;
                Parametro[1] = new SqlParameter("@intEjercicio", SqlDbType.Int);
                Parametro[1].Value = obj.IntEjercicio;
                Parametro[2] = new SqlParameter("@intMes", SqlDbType.Int);
                Parametro[2].Value = obj.IntMes;
                Parametro[3] = new SqlParameter("@intCuentaBancaria", SqlDbType.Int);
                Parametro[3].Value = obj.IntCuentaBancaria;                
                Parametro[4] = new SqlParameter("@strUsuario", SqlDbType.VarChar);
                Parametro[4].Value = obj.StrUsuario;
                Parametro[5] = new SqlParameter("@strMaquina", SqlDbType.VarChar);
                Parametro[5].Value = obj.StrMaquina;

                SqlHelper.ExecuteNonQuery(ConnectionString, CommandType.StoredProcedure, "VetecMarfilAdmin..usp_tbConciliaciones_Automatic", Parametro);
                resultado = true;
            }
            catch (Exception e)
            {
                throw e;
            }

            return resultado;
        }
        #endregion 
    
        #region List
        public static DataTable  List(Entity_Conciliacion obj)
        {
            DataSet ds;
            
            try
            {

                SqlParameter[] Parametro = new SqlParameter[6];
                Parametro[0] = new SqlParameter("@intEmpresa", SqlDbType.Int);
                Parametro[0].Value = obj.IntEmpresa ;
                Parametro[1] = new SqlParameter("@intEjercicio", SqlDbType.Int);
                Parametro[1].Value = obj.IntEjercicio ;
                Parametro[2] = new SqlParameter("@intMes", SqlDbType.Int);
                Parametro[2].Value = obj.IntMes ;
                Parametro[3] = new SqlParameter("@intCuentaBancaria", SqlDbType.Int);
                Parametro[3].Value = obj.IntCuentaBancaria ;
                Parametro[4] = new SqlParameter("@intDireccion", SqlDbType.Int);
                Parametro[4].Value = obj.IntDireccion ;
                Parametro[5] = new SqlParameter("@SortExpression", SqlDbType.VarChar);
                Parametro[5].Value = obj.SortExpression;

                ds = SqlHelper.ExecuteDataset(ConnectionString, CommandType.StoredProcedure, "usp_tbTempConciliacion_List", Parametro);
                return ds.Tables[0];

            }
            catch (Exception e)
            {
                return null;
            }
        }
        #endregion 

        #region List2
        public static DataTable List2(Entity_Conciliacion obj)
        {
            DataSet ds;

            try
            {
                SqlParameter[] Parametro = new SqlParameter[8];
                Parametro[0] = new SqlParameter("@intEmpresa", SqlDbType.Int);
                Parametro[0].Value =obj.IntEmpresa ;
                Parametro[1] = new SqlParameter("@intCuentaBancaria", SqlDbType.Int);
                Parametro[1].Value = obj.IntCuentaBancaria ;
                Parametro[2] = new SqlParameter("@FechaIni", SqlDbType.DateTime);
                Parametro[3] = new SqlParameter("@FechaFin", SqlDbType.DateTime);
                Parametro[4] = new SqlParameter("@intEjercicio", SqlDbType.Int);
                Parametro[4].Value = obj.IntEjercicio;
                Parametro[5] = new SqlParameter("@intMes", SqlDbType.Int);
                Parametro[5].Value = obj.IntMes ;
                Parametro[6] = new SqlParameter("@intDireccion", SqlDbType.Int);
                Parametro[6].Value =obj.IntDireccion ;
                Parametro[7] = new SqlParameter("@SortExpression", SqlDbType.VarChar);
                Parametro[7].Value = obj.SortExpression;

                ds = SqlHelper.ExecuteDataset(ConnectionString, CommandType.StoredProcedure, "usp_tbTempConciliacion_ChequesPolizas", Parametro);
                return ds.Tables[0];

            }
            catch (Exception e)
            {
                return null;
            }
        }
        #endregion 

        #region List3
        public static DataTable List3(Entity_Conciliacion obj)
        {
            DataSet ds;

            try
            {

                SqlParameter[] Parametro = new SqlParameter[6];
                Parametro[0] = new SqlParameter("@intEmpresa", SqlDbType.Int);
                Parametro[0].Value = obj.IntEmpresa;
                Parametro[1] = new SqlParameter("@intEjercicio", SqlDbType.Int);
                Parametro[1].Value = obj.IntEjercicio;
                Parametro[2] = new SqlParameter("@intMes", SqlDbType.Int);
                Parametro[2].Value = obj.IntMes;
                Parametro[3] = new SqlParameter("@intCuentaBancaria", SqlDbType.Int);
                Parametro[3].Value = obj.IntCuentaBancaria;
                Parametro[4] = new SqlParameter("@intDireccion", SqlDbType.Int);
                Parametro[4].Value = obj.IntDireccion;
                Parametro[5] = new SqlParameter("@SortExpression", SqlDbType.VarChar);
                Parametro[5].Value = obj.SortExpression;

                ds = SqlHelper.ExecuteDataset(ConnectionString, CommandType.StoredProcedure, "usp_tbTempConciliacion_List2", Parametro);
                return ds.Tables[0];

            }
            catch (Exception e)
            {
                return null;
            }
        }
        #endregion 

        #region MovBanConciliados
        public static DataTable MovBanConciliados(Entity_Conciliacion obj)
        {
            DataSet ds;

            try
            {
                SqlParameter[] Parametro = new SqlParameter[4];
                Parametro[0] = new SqlParameter("@intEmpresa", SqlDbType.Int);
                Parametro[0].Value = obj.IntEmpresa;
                Parametro[1] = new SqlParameter("@intCuentaBancaria", SqlDbType.Int);
                Parametro[1].Value = obj.IntCuentaBancaria ;
                Parametro[2] = new SqlParameter("@intMes", SqlDbType.Int);
                Parametro[2].Value = obj.IntMes ;
                Parametro[3] = new SqlParameter("@intEjercicio", SqlDbType.Int);
                Parametro[3].Value = obj.IntEjercicio ;

                ds = SqlHelper.ExecuteDataset(ConnectionString, CommandType.StoredProcedure, "usp_Movimientos_Bancarios_Conciliados", Parametro);
                return ds.Tables[0];

            }
            catch (Exception e)
            {
                return null;
            }
        }
        #endregion 

        #region Desconciliacion
        public static bool Desconciliacion(Entity_Conciliacion obj)
        {
            bool resultado = false;
            Entity_Conciliacion oEntity_Conciliacion;
            oEntity_Conciliacion = new Entity_Conciliacion();

            try
            {
                SqlParameter[] arrPar = new SqlParameter[7];
                arrPar[0] = new SqlParameter("@intEmpresa", SqlDbType.Int);
                arrPar[0].Value = obj.IntEmpresa;
                arrPar[1] = new SqlParameter("@intEjercicio", SqlDbType.Int);
                arrPar[1].Value = obj.IntEjercicio ;
                arrPar[2] = new SqlParameter("@intMes", SqlDbType.Int);
                arrPar[2].Value = obj.IntMes ;
                arrPar[3] = new SqlParameter("@intCuentaBancaria", SqlDbType.Int);
                arrPar[3].Value = obj.IntCuentaBancaria ;
                arrPar[4] = new SqlParameter("@intConciliacion", SqlDbType.Int);
                arrPar[4].Value = obj.IntConciliacion ;
                arrPar[5] = new SqlParameter("@strUsuario", SqlDbType.VarChar);
                arrPar[5].Value = obj.StrUsuario ;
                arrPar[6] = new SqlParameter("@strMaquina", SqlDbType.VarChar);
                arrPar[6].Value = obj.StrMaquina;

                SqlHelper.ExecuteNonQuery(ConnectionString, CommandType.StoredProcedure, "usp_tbConciliaciones_Desconciliacion", arrPar);
                resultado = true;
            }
            catch (Exception e)
            {
                resultado = false;
            }

            return resultado;
        }
        #endregion

        #region MovBanConciliados
        public static DataTable MovBanConcilBusc(Entity_Conciliacion obj)
        {
            DataSet ds;

            try
            {
                SqlParameter[] Parametro = new SqlParameter[5];
                Parametro[0] = new SqlParameter("@intEmpresa", SqlDbType.Int);
                Parametro[0].Value = obj.IntEmpresa;
                Parametro[1] = new SqlParameter("@intCuentaBancaria", SqlDbType.Int);
                Parametro[1].Value = obj.IntCuentaBancaria;
                Parametro[2] = new SqlParameter("@intMes", SqlDbType.Int);
                Parametro[2].Value = obj.IntMes;
                Parametro[3] = new SqlParameter("@intEjercicio", SqlDbType.Int);
                Parametro[3].Value = obj.IntEjercicio;
                Parametro[4] = new SqlParameter("@strBuscar", SqlDbType.VarChar);
                Parametro[4].Value = obj.StrBuscar;

                ds = SqlHelper.ExecuteDataset(ConnectionString, CommandType.StoredProcedure, "usp_Movimientos_Bancarios_Conciliados_Busqueda", Parametro);
                return ds.Tables[0];

            }
            catch (Exception e)
            {
                return null;
            }
        }
        #endregion 

        #region Lista
        public static DataTable Lista(Entity_Conciliacion obj)
        {
            DataSet ds;

            try
            {

                SqlParameter[] Parametro = new SqlParameter[5];
                Parametro[0] = new SqlParameter("@intEmpresa", SqlDbType.Int);
                Parametro[0].Value = obj.IntEmpresa;
                Parametro[1] = new SqlParameter("@intEjercicio", SqlDbType.Int);
                Parametro[1].Value = obj.IntEjercicio;
                Parametro[2] = new SqlParameter("@intMes", SqlDbType.Int);
                Parametro[2].Value = obj.IntMes;
                Parametro[3] = new SqlParameter("@intDireccion", SqlDbType.Int);
                Parametro[3].Value = obj.IntDireccion;
                Parametro[4] = new SqlParameter("@SortExpression", SqlDbType.VarChar);
                Parametro[4].Value = obj.SortExpression;
                ds = SqlHelper.ExecuteDataset(ConnectionString, CommandType.StoredProcedure, "VetecMarfilAdmin..usp_tbCFDI_Conciliacion", Parametro);
                return ds.Tables[0];

            }
            catch (Exception e)
            {
                return null;
            }
        }
        #endregion 

        #region Lista
        public static DataTable Busqueda(Entity_Conciliacion obj)
        {
            DataSet ds;

            try
            {

                SqlParameter[] Parametro = new SqlParameter[5];
                Parametro[0] = new SqlParameter("@intEmpresa", SqlDbType.Int);
                Parametro[0].Value = obj.IntEmpresa;
                Parametro[1] = new SqlParameter("@intEjercicio", SqlDbType.Int);
                Parametro[1].Value = obj.IntEjercicio;
                Parametro[2] = new SqlParameter("@intMes", SqlDbType.Int);
                Parametro[2].Value = obj.IntMes;
                Parametro[3] = new SqlParameter("@intDireccion", SqlDbType.Int);
                Parametro[3].Value = obj.IntDireccion;
                Parametro[4] = new SqlParameter("@SortExpression", SqlDbType.VarChar);
                Parametro[4].Value = obj.SortExpression;
                ds = SqlHelper.ExecuteDataset(ConnectionString, CommandType.StoredProcedure, "VetecMarfilAdmin..usp_tbCFDI_Conciliacion", Parametro);
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
