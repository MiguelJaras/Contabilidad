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
    public class DACTipoMovimiento : Base
	{
        #region Fill
        public static Entity_TipoMovimiento Fill(Entity_TipoMovimiento obj)
        {
            IDataReader drd;
            Entity_TipoMovimiento tm;
            tm = new Entity_TipoMovimiento();

            try
            {
                drd = SqlHelper.ExecuteReader(ConnectionString, CommandType.Text, "SELECT T.intMovto,E.strDescrcipcion as StrNombre FROM VetecMarfilAdmin..tbTipoMovto T INNER JOIN VetecMarfilAdmin..tbEstructuraEnc E ON E.intMovto = t.intMovto AND E.intEmpresa = T.intEmpresa WHERE T.intEmpresa=" + obj.IntEmpresa + " AND T.intMovto=" + obj.IntTipoMovto);
                if (drd.Read())
                {
                    tm = CreateObject(drd);
                }
                else
                    tm = null;
            }
            catch (Exception e)
            {
                tm = null;
            }

            return tm;
        }
        #endregion   


        #region GetByNC
        public static Entity_TipoMovimiento GetByNC(Entity_TipoMovimiento obj)
        {
            IDataReader drd;
            Entity_TipoMovimiento tm;
            tm = new Entity_TipoMovimiento();

            try
            {
                drd = SqlHelper.ExecuteReader(ConnectionString, CommandType.Text, "SELECT T.intMovto,E.strDescrcipcion as StrNombre FROM VetecMarfilAdmin..tbTipoMovto T INNER JOIN VetecMarfilAdmin..tbEstructuraEnc E ON E.intMovto = t.intMovto AND E.intEmpresa = T.intEmpresa WHERE T.intEmpresa=" + obj.IntEmpresa + " AND T.intMovto=" + obj.IntTipoMovto + " AND strNombre like 'NC%' AND strNaturaleza = 'A'");
                if (drd.Read())
                {
                    tm = CreateObject(drd);
                }
                else
                    tm = null;
            }
            catch (Exception e)
            {
                tm = null;
            }

            return tm;
        }
        #endregion   


        #region Create
        static Entity_TipoMovimiento CreateObject(IDataReader drd)
        {
            Entity_TipoMovimiento obj;
            obj = new Entity_TipoMovimiento();

            obj.IntTipoMovto = (int)drd["intMovto"];
            obj.StrNombre = (string)drd["StrNombre"];
            
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
                value = SqlHelper.ExecuteScalar(ConnectionString, CommandType.StoredProcedure, "VetecMarfilAdmin..usp_tbTipoMovto_Help", arrPar).ToString();
                return value;
            }
            catch (Exception e)
            {
                return "";
            }

            return value;
        }
        #endregion

        #region Sel
        public static Entity_TipoMovimiento Sel(Entity_TipoMovimiento obj)
        {
            IDataReader drd;
            Entity_TipoMovimiento oEntity_TipoMovimiento;
            oEntity_TipoMovimiento = new Entity_TipoMovimiento();

            try
            {
                SqlParameter[] arrPar = new SqlParameter[2];
                arrPar[0] = new SqlParameter("@intEmpresa", SqlDbType.Int);
                arrPar[0].Value = obj.IntEmpresa;
                arrPar[1] = new SqlParameter("@intMovto", SqlDbType.Int);
                arrPar[1].Value = obj.IntMovto;

                drd = SqlHelper.ExecuteReader(ConnectionString, CommandType.StoredProcedure, "VetecMarfilAdmin..usp_tbTipoMovto_Sel", arrPar);
                if (drd.Read())
                {
                    oEntity_TipoMovimiento = CreateObject2(drd);
                }
                else
                {
                    oEntity_TipoMovimiento = null;
                }
            }
            catch (Exception e)
            {
                oEntity_TipoMovimiento = null;
            }

            return oEntity_TipoMovimiento;
        }
        #endregion

        #region Create2
        static Entity_TipoMovimiento CreateObject2(IDataReader drd)
        {

            Entity_TipoMovimiento obj = new Entity_TipoMovimiento();

            obj.IntEmpresa = Convert.ToInt32(drd["intEmpresa"].ToString());
            obj.IntMovto = Convert.ToInt32(drd["intMovto"].ToString());
            obj.StrNombre = drd["strNombre"].ToString();
            obj.StrAuditAlta = drd["strAuditAlta"].ToString();
            obj.StrAuditMod = drd["strAuditMod"].ToString();
            obj.StrNaturaleza = drd["strNaturaleza"].ToString();
            obj.BFactura = Convert.ToBoolean (drd["bFactura"].ToString());
          
            return obj;
        }
        #endregion

        public static string Save(Entity_TipoMovimiento obj)
        {
            string result;

            SqlParameter[] arrPar = new SqlParameter[15];
            arrPar[0] = new SqlParameter("@intEmpresa", SqlDbType.Int);
            arrPar[0].Value = obj.IntEmpresa;
            arrPar[1] = new SqlParameter("@intMovto", SqlDbType.Int);
            arrPar[1].Value = obj.IntMovto;
            arrPar[2] = new SqlParameter("@strNombre", SqlDbType.VarChar);
            arrPar[2].Value = obj.StrNombre;
            arrPar[3] = new SqlParameter("@strAuditAlta", SqlDbType.VarChar);
            arrPar[3].Value = obj.StrAuditAlta;
            arrPar[4] = new SqlParameter("@strAuditMod", SqlDbType.VarChar);
            arrPar[4].Value = obj.StrAuditMod;
            arrPar[5] = new SqlParameter("@strNaturaleza", SqlDbType.VarChar);
            arrPar[5].Value = obj.StrNaturaleza;
            arrPar[6] = new SqlParameter("@bFactura", SqlDbType.Bit);
            arrPar[6].Value = obj.BFactura;
           
            try
            {
                //result = SqlHelper.ExecuteScalar(ConnectionString, CommandType.StoredProcedure, "qryColonia_App", arrPar).ToString();
                SqlHelper.ExecuteNonQuery(ConnectionString, CommandType.StoredProcedure, "VetecMarfilAdmin..usp_tbTipoMovto_App", arrPar);
                result = "true";
            }
            catch (Exception e)
            {
                throw e;
            }
            return result;
        }

        public static string Delete(Entity_TipoMovimiento obj)
        {
            string result;

            SqlParameter[] arrPar = new SqlParameter[15];
            arrPar[0] = new SqlParameter("@intEmpresa", SqlDbType.Int);
            arrPar[0].Value = obj.IntEmpresa;
            arrPar[1] = new SqlParameter("@intMovto", SqlDbType.Int);
            arrPar[1].Value = obj.IntMovto;

            try
            {
                SqlHelper.ExecuteNonQuery(ConnectionString, CommandType.StoredProcedure, "VetecMarfilAdmin..usp_tbTipoMovto_Del", arrPar);
                result = "true";
            }
            catch (Exception e)
            {
                throw e;
            }
            return result;
        }

        #region Inc
        public static string Inc(Entity_TipoMovimiento obj)
        {
            string value = "";
            SqlParameter[] arrPar = new SqlParameter[1];
            arrPar[0] = new SqlParameter("@intEmpresa", SqlDbType.Int);
            arrPar[0].Value = obj.IntEmpresa;

            try
            {
                value = SqlHelper.ExecuteScalar(ConnectionString, CommandType.StoredProcedure, "VetecMarfilAdmin..usp_tbTipoMovto_Inc", arrPar).ToString();
                return value;
            }
            catch (Exception e)
            {
                return "";
            }

            return value;
        }
        #endregion



	}
}