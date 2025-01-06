using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using System.Data.SqlClient;
using Contabilidad.Entity;
using Microsoft.ApplicationBlocks.Data;

namespace Contabilidad.DataAccess
{
    public class DACPolizasEnc:Base
    {
        #region Save
        public static string  Save(Entity_PolizasEnc obj)
        {
            string result = "";

            SqlParameter[] arrPar = new SqlParameter[10];
            arrPar[0] = new SqlParameter("@intEmpresa", SqlDbType.Int);
            arrPar[0].Value = obj.IntEmpresa;
            arrPar[1] = new SqlParameter("@strPoliza", SqlDbType.VarChar);
            arrPar[1].Value = obj.strPoliza;
            arrPar[2] = new SqlParameter("@strTipoPoliza", SqlDbType.VarChar);
            arrPar[2].Value = obj.strTipoPoliza ;
            arrPar[3] = new SqlParameter("@datFecha", SqlDbType.DateTime);
            arrPar[3].Value = obj.datFecha ;
            arrPar[4] = new SqlParameter("@intMoneda", SqlDbType.Int);
            arrPar[4].Value = obj.IntParametroFinal ;
            arrPar[5] = new SqlParameter("@strConcepto", SqlDbType.VarChar);
            arrPar[5].Value = obj.strDescripcion ;
            arrPar[6] = new SqlParameter("@dblCargos", SqlDbType.Decimal);
            arrPar[6].Value = obj.dblCargos ;
            arrPar[7] = new SqlParameter("@dblAbonos", SqlDbType.Decimal);
            arrPar[7].Value = obj.dblAbonos ;
            arrPar[8] = new SqlParameter("@strUsuario", SqlDbType.VarChar);
            arrPar[8].Value = obj.StrUsuario ;
            arrPar[9] = new SqlParameter("@strMaquina", SqlDbType.VarChar);
            arrPar[9].Value = obj.StrMaquina ;
            
            try
            {
                result = SqlHelper.ExecuteScalar(ConnectionString, CommandType.StoredProcedure, "VetecMarfilAdmin.dbo.usp_tbPolizasEnc_Save", arrPar).ToString();
            }
            catch (Exception e)
            {
                throw e;
            }

            return result;
        }
        #endregion

        #region PolInv
        public static string PolInv(Entity_PolizasEnc obj)
        {
            string result = "";

            SqlParameter[] arrPar = new SqlParameter[5];
            arrPar[0] = new SqlParameter("@intEmpresa", SqlDbType.Int);
            arrPar[0].Value = obj.IntEmpresa;
            arrPar[1] = new SqlParameter("@intEjercicio", SqlDbType.Int );
            arrPar[1].Value = obj.intEjercicio;
            arrPar[2] = new SqlParameter("@intMes", SqlDbType.Int );
            arrPar[2].Value = obj.intMes;
            arrPar[3] = new SqlParameter("@strUsuario", SqlDbType.VarChar);
            arrPar[3].Value = obj.StrUsuario;
            arrPar[4] = new SqlParameter("@strMaquina", SqlDbType.VarChar);
            arrPar[4].Value = obj.StrMaquina;

            try
            {
                result = SqlHelper.ExecuteScalar(ConnectionString, CommandType.StoredProcedure, "usp_tbPolizas_Invetario", arrPar).ToString();
            }
            catch (Exception e)
            {
                throw e;
            }

            return result;

            return result;
        }
        #endregion

        #region PolInvDes
        public static string PolInvDes(Entity_PolizasEnc obj)
        {
            string result = "";

            SqlParameter[] arrPar = new SqlParameter[5];
            arrPar[0] = new SqlParameter("@intEmpresa", SqlDbType.Int);
            arrPar[0].Value = obj.IntEmpresa;
            arrPar[1] = new SqlParameter("@intEjercicio", SqlDbType.Int);
            arrPar[1].Value = obj.intEjercicio;
            arrPar[2] = new SqlParameter("@intMes", SqlDbType.Int);
            arrPar[2].Value = obj.intMes;
            arrPar[3] = new SqlParameter("@strUsuario", SqlDbType.VarChar);
            arrPar[3].Value = obj.StrUsuario;
            arrPar[4] = new SqlParameter("@strMaquina", SqlDbType.VarChar);
            arrPar[4].Value = obj.StrMaquina;

            try
            {
                result = SqlHelper.ExecuteScalar(ConnectionString, CommandType.StoredProcedure, "usp_tbPolizas_InvetarioDes", arrPar).ToString();
            }
            catch (Exception e)
            {
                throw e;
            }

            return result;

            return result;
        }
        #endregion

        #region Fill
        public static Entity_PolizasEnc Fill(Entity_PolizasEnc obj)
        {
            IDataReader drd;
            Entity_PolizasEnc objPol;
            objPol = new Entity_PolizasEnc();

            SqlParameter[] arrPar = new SqlParameter[3];
            arrPar[0] = new SqlParameter("@intEmpresa", SqlDbType.Int);
            arrPar[0].Value = obj.IntEmpresa;
            arrPar[1] = new SqlParameter("@intEjercicio", SqlDbType.Int);
            arrPar[1].Value = obj.intEjercicio;
            arrPar[2] = new SqlParameter("@strPoliza", SqlDbType.VarChar);
            arrPar[2].Value = obj.strPoliza;

            try
            {
                drd = SqlHelper.ExecuteReader(ConnectionString, CommandType.StoredProcedure, "VetecMarfilAdmin..usp_tbPolizasEnc_Fill", arrPar);
                if (drd.Read())
                {
                    objPol = CreateObject(drd);
                }
                else
                    objPol = null;
            }
            catch (Exception e)
            {
                objPol = null;
            }

            return objPol;
        }
        #endregion

        #region Create
        static Entity_PolizasEnc CreateObject(IDataReader drd)
        {
            Entity_PolizasEnc obj;
            obj = new Entity_PolizasEnc();

            obj.intEjercicio = (int)drd["intEjercicio"];
            obj.intMes =(int)drd["intMes"];
            obj.strPoliza = (string)drd["strPoliza"];
            obj.strTipoPoliza = (string)drd["strTipoPoliza"];
            obj.datFecha = Convert.ToDateTime(drd["datFecha"]);
            obj.intEstatus = (int)drd["intEstatus"];
            obj.strDescripcion = (string)drd["strDescripcion"];
            obj.dblCargos = Convert.ToDecimal(drd["dblCargos"]);
            obj.dblAbonos = Convert.ToDecimal(drd["dblAbonos"]);
            obj.intIndAfectada = (int)drd["intIndAfectada"];           
            obj.StrUsuario = (string)drd["strAuditAlta"];
            obj.intPartida = (int)drd["intPartida"];
            obj.StrFolio = (string)drd["strFolio"];

            return obj;
        }
        #endregion        

        #region Delete
        public static string Delete(Entity_PolizasEnc obj)
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
                result = SqlHelper.ExecuteScalar(ConnectionString, CommandType.StoredProcedure, "VetecMarfilAdmin..usp_tbPolizasEnc_Delete", arrParDet).ToString();
            }
            catch (Exception e)
            {
                throw e;
            }

            return result;
        }
        #endregion

        #region Copiar
        public static string Copiar(Entity_PolizasEnc obj)
        {
            string result = "";

            SqlParameter[] arrPar = new SqlParameter[8];
            arrPar[0] = new SqlParameter("@intEmpresa", SqlDbType.Int);
            arrPar[0].Value = obj.IntEmpresa;
            arrPar[1] = new SqlParameter("@strPolizaOriginal", SqlDbType.VarChar);
            arrPar[1].Value = obj.strPoliza;
            arrPar[2] = new SqlParameter("@intEjercicio", SqlDbType.Int);
            arrPar[2].Value = obj.intEjercicio;
            arrPar[3] = new SqlParameter("@datFecha", SqlDbType.DateTime);
            arrPar[3].Value = obj.datFecha;
            arrPar[4] = new SqlParameter("@strDescripcion", SqlDbType.VarChar);
            arrPar[4].Value = obj.strDescripcion;
            arrPar[5] = new SqlParameter("@strReferencia", SqlDbType.VarChar);
            arrPar[5].Value = obj.StrFolio;            
            arrPar[6] = new SqlParameter("@strUsuario", SqlDbType.VarChar);
            arrPar[6].Value = obj.StrUsuario;
            arrPar[7] = new SqlParameter("@strMaquina", SqlDbType.VarChar);
            arrPar[7].Value = obj.StrMaquina;

            try
            {
                result = SqlHelper.ExecuteScalar(ConnectionString, CommandType.StoredProcedure, "VetecMarfilAdmin.dbo.usp_tbPolizas_Copiar", arrPar).ToString();
            }
            catch (Exception e)
            {
                throw e;
            }

            return result;
        }
        #endregion

        #region Inversa
        public static string Inversa(Entity_PolizasEnc obj)
        {
            string result = "";

            SqlParameter[] arrPar = new SqlParameter[7];
            arrPar[0] = new SqlParameter("@intEmpresa", SqlDbType.Int);
            arrPar[0].Value = obj.IntEmpresa;
            arrPar[1] = new SqlParameter("@strPolizaOriginal", SqlDbType.VarChar);
            arrPar[1].Value = obj.strPoliza;
            arrPar[2] = new SqlParameter("@intEjercicio", SqlDbType.Int);
            arrPar[2].Value = obj.intEjercicio;
            arrPar[3] = new SqlParameter("@datFecha", SqlDbType.DateTime);
            arrPar[3].Value = obj.datFecha;
            arrPar[4] = new SqlParameter("@strDescripcion", SqlDbType.VarChar);
            arrPar[4].Value = obj.strDescripcion;
            arrPar[5] = new SqlParameter("@strUsuario", SqlDbType.VarChar);
            arrPar[5].Value = obj.StrUsuario;
            arrPar[6] = new SqlParameter("@strMaquina", SqlDbType.VarChar);
            arrPar[6].Value = obj.StrMaquina;

            try
            {
                result = SqlHelper.ExecuteScalar(ConnectionString, CommandType.StoredProcedure, "VetecMarfilAdmin.dbo.usp_tbPolizas_SaldosInversos", arrPar).ToString();
            }
            catch (Exception e)
            {
                throw e;
            }

            return result;
        }
        #endregion

        #region UpdateCA
        public static string UpdateCA(Entity_PolizasEnc obj)
        {
            string result = "";

            SqlParameter[] arrPar = new SqlParameter[3];
            arrPar[0] = new SqlParameter("@intEmpresa", SqlDbType.Int);
            arrPar[0].Value = obj.IntEmpresa;
            arrPar[1] = new SqlParameter("@strPoliza", SqlDbType.VarChar);
            arrPar[1].Value = obj.strPoliza;
            arrPar[2] = new SqlParameter("@datFecha", SqlDbType.DateTime);
            arrPar[2].Value = obj.datFecha;
            
            try
            {
                result = SqlHelper.ExecuteScalar(ConnectionString, CommandType.StoredProcedure, "VetecMarfilAdmin.dbo.usp_tbPolizasEnc_UpdCA", arrPar).ToString();
            }
            catch (Exception e)
            {
                throw e;
            }

            return result;
        }
        #endregion

        #region DelCFDI
        public static string DelCFDI(int intEmpresa, int intEjercicio, string strPoliza)
        {
            string result = "";
            try
            {
                result = SqlHelper.ExecuteNonQuery(ConnectionString, CommandType.Text, "DELETE FROM VetecMarfilAdmin.dbo.tbPolizasEnc_CFDI WHERE intEmpresa = " + intEmpresa.ToString() + " and intEjercicio = " + intEjercicio.ToString() + " and strPoliza = '" + strPoliza + "'").ToString();
            }
            catch (Exception e)
            {
                throw e;
            }

            return result;
        }
        #endregion

        #region SaveCFDI
        public static string SaveCFDI(int intEmpresa, int intEjercicio, string strPoliza, string strCFDI,string strUsuario,string strMaquina)
        {
            string result = "";

            SqlParameter[] arrPar = new SqlParameter[6];
            arrPar[0] = new SqlParameter("@intEmpresa", SqlDbType.Int);
            arrPar[0].Value = intEmpresa;
            arrPar[1] = new SqlParameter("@intEjercicio", SqlDbType.Int);
            arrPar[1].Value = intEjercicio;
            arrPar[2] = new SqlParameter("@strPoliza", SqlDbType.VarChar);
            arrPar[2].Value = strPoliza;
            arrPar[3] = new SqlParameter("@strCFDI", SqlDbType.VarChar);
            arrPar[3].Value = strCFDI;
            arrPar[4] = new SqlParameter("@strUsuario", SqlDbType.VarChar);
            arrPar[4].Value = strUsuario;
            arrPar[5] = new SqlParameter("@strMaquina", SqlDbType.VarChar);
            arrPar[5].Value = strMaquina;

            try
            {                
                result = SqlHelper.ExecuteScalar(ConnectionString, CommandType.StoredProcedure, "VetecMarfilAdmin.dbo.usp_tbPolizasEnc_CFDI_Save", arrPar).ToString();
            }
            catch (Exception e)
            {
                throw e;
            }

            return result;
        }
        #endregion

        #region ListCFDI
        public static DataTable ListCFDI(int intEmpresa, int intEjercicio, string strPoliza)
        {
            DataSet ds;

            SqlParameter[] arrParDet = new SqlParameter[3];
            arrParDet[0] = new SqlParameter("@intEmpresa", SqlDbType.Int);
            arrParDet[0].Value = intEmpresa;
            arrParDet[1] = new SqlParameter("@intEjercicio", SqlDbType.Int);
            arrParDet[1].Value = intEjercicio;
            arrParDet[2] = new SqlParameter("@strPoliza", SqlDbType.VarChar);
            arrParDet[2].Value = strPoliza;

            try
            {
                ds = SqlHelper.ExecuteDataset(ConnectionString, CommandType.StoredProcedure, "VetecMarfilAdmin..tbPolizasEnc_CFDI_List", arrParDet);
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
