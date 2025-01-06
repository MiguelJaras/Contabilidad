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
    public class DACEmpresa : Base
	{
        
		#region GetList
			public static DataTable GetList()
			{
                DataSet ds;

                SqlParameter[] arrPar = new SqlParameter[1];
                arrPar[0] = new SqlParameter("@intEmpresa", SqlDbType.Int);
                arrPar[0].Value = 0;               

                try
                {
                    ds = SqlHelper.ExecuteDataset(ConnectionString, CommandType.StoredProcedure, "qryEmpresas_Sel", arrPar);
                    return ds.Tables[0];
                }
                catch (Exception e)
                {
                    return null;
                }														
			}
			#endregion

        #region GetSucursal
        public static string GetSucursal(string intEmpresa)
        {
            string value = "";

            SqlParameter[] arrPar = new SqlParameter[1];
            arrPar[0] = new SqlParameter("@intEmpresa", SqlDbType.Int);
            arrPar[0].Value = intEmpresa;

            try
            {
                value = SqlHelper.ExecuteScalar(ConnectionString, CommandType.Text, "SELECT intSucursal FROM tbSucursales WHERE intEmpresa = " + intEmpresa).ToString();
                return value;
            }
            catch (Exception e)
            {
                return "";
            }
        }
        #endregion
			
		#region Fill
        public static Entity_Empresa Fill(int intEmpresa)
			{
                IDataReader drd;
                Entity_Empresa oEntity_Empresa;
                oEntity_Empresa = new Entity_Empresa();

                SqlParameter[] arrPar = new SqlParameter[1];
                arrPar[0] = new SqlParameter("@intEmpresa", SqlDbType.Int);
                arrPar[0].Value = intEmpresa;              

                try
                {
                    drd = SqlHelper.ExecuteReader(ConnectionString, CommandType.StoredProcedure, "VetecMarfilAdmin..usp_tbEmpresas_Fill", arrPar);
                    if (drd.Read())
                    {
                        oEntity_Empresa = CreateObject(drd);
                    }
                }
                catch (Exception e)
                {
                    oEntity_Empresa = null;
                }

                return oEntity_Empresa;									
			}
			#endregion            

        #region Save
        public static string Save(Entity_Empresa  obj)
        {
            string result = "";
            SqlParameter[] arrPar = new SqlParameter[23];
            arrPar[0] = new SqlParameter("@intEmpresa", SqlDbType.Int);
            arrPar[0].Value = obj.IntEmpresa;
            arrPar[1] = new SqlParameter("@strNombre", SqlDbType.VarChar);
            arrPar[1].Value = obj.StrNombre ;
            arrPar[2] = new SqlParameter("@strNombreCorto", SqlDbType.VarChar);
            arrPar[2].Value = obj.StrNombreCorto;
            arrPar[3] = new SqlParameter("@strDireccion", SqlDbType.VarChar);
            arrPar[3].Value = obj.StrDireccion;
            arrPar[4] = new SqlParameter("@strColonia", SqlDbType.VarChar );
            arrPar[4].Value = obj.StrColonia;
            arrPar[5] = new SqlParameter("@strDelegacion", SqlDbType.VarChar);
            arrPar[5].Value = obj.strDelegacion;
            arrPar[6] = new SqlParameter("@intEstado", SqlDbType.Int);
            arrPar[6].Value = obj.intEstado;
            arrPar[7] = new SqlParameter("@intCiudad", SqlDbType.Int);
            arrPar[7].Value = obj.intCiudad;
            arrPar[8] = new SqlParameter("@strRfc", SqlDbType.VarChar );
            arrPar[8].Value = obj.StrRfc;
            arrPar[9] = new SqlParameter("@strRegImss", SqlDbType.VarChar );
            arrPar[9].Value = obj.strRegImss;
            arrPar[10] = new SqlParameter("@strCodigoPostal", SqlDbType.VarChar );
            arrPar[10].Value = obj.strCodigoPostal;
            arrPar[11] = new SqlParameter("@strResponsable", SqlDbType.VarChar );
            arrPar[11].Value = obj.strResponsable;
            arrPar[12] = new SqlParameter("@strRfcResponsable", SqlDbType.VarChar );
            arrPar[12].Value = obj.strRfcResponsable;
            arrPar[13] = new SqlParameter("@strUsuario", SqlDbType.VarChar);
            arrPar[13].Value = obj.strUsuarioAlta;
            arrPar[14] = new SqlParameter("@strMaquina", SqlDbType.VarChar);
            arrPar[14].Value = obj.strMaquinaAlta;
            arrPar[15] = new SqlParameter("@intGrupo", SqlDbType.Int);
            arrPar[15].Value = obj.intGrupo;
            arrPar[16] = new SqlParameter("@intTipoMoneda", SqlDbType.Int);
            arrPar[16].Value = obj.intTipoMoneda;
            arrPar[17] = new SqlParameter("@intLogo", SqlDbType.Int);
            arrPar[17].Value = obj.intLogo;                      
            arrPar[18] = new SqlParameter("@dblInteresMoratorio", SqlDbType.Decimal);
            arrPar[18].Value = obj.dblInteresMoratorio;

            try
            {
                result = SqlHelper.ExecuteScalar(ConnectionString, CommandType.StoredProcedure, "VetecMarfilAdmin..usp_tbEmpresas_Save", arrPar).ToString();
            }
            catch (Exception e)
            {
                throw e;
            }

            return result;
        }

        #endregion
    
        #region Sel
        public static Entity_Empresa Sel(Entity_Empresa obj)
        {
            IDataReader drd;
            Entity_Empresa oEntity_Empresa;
            oEntity_Empresa = new Entity_Empresa();

            SqlParameter[] arrPar = new SqlParameter[1];
            arrPar[0] = new SqlParameter("@intEmpresa", SqlDbType.Int);
            arrPar[0].Value = obj.IntEmpresa.ToString();

            try
            {
                drd = SqlHelper.ExecuteReader(ConnectionString, CommandType.StoredProcedure, "VetecMarfilAdmin..usp_tbEmpresas_Fill", arrPar);
                if (drd.Read())
                {
                    oEntity_Empresa = CreateObject(drd);
                }
                else
                    oEntity_Empresa = null;
            }
            catch (Exception e)
            {
                oEntity_Empresa = null;
            }

            return oEntity_Empresa;
        }
        #endregion    

        #region Create
        static Entity_Empresa CreateObject(IDataReader drd)
            {
                Entity_Empresa oEnt_catUser;
                oEnt_catUser = new Entity_Empresa();

                oEnt_catUser.IntEmpresa = (int)drd["IntEmpresa"];
                oEnt_catUser.StrColonia = (string)drd["StrColonia"];
                oEnt_catUser.StrNombre = (string)drd["StrNombre"];
                oEnt_catUser.StrNombreCorto = (string)drd["StrNombreCorto"];
                oEnt_catUser.StrRfc = (string)drd["StrRfc"];
                oEnt_catUser.intGrupo = (int)drd["intGrupo"];    
                oEnt_catUser.StrDireccion = (string)drd["strDireccion"];
                oEnt_catUser.strDelegacion = (string)drd["strDelegacion"];
                oEnt_catUser.intEstado = (int)drd["intEstado"];
                oEnt_catUser.strRegImss = (string)drd["strRegImss"];
                oEnt_catUser.strCodigoPostal = (string)drd["strCodigoPostal"];
                oEnt_catUser.strResponsable = (string)drd["strResponsable"];
                oEnt_catUser.strRfcResponsable = (string)drd["strRfcResponsable"];
                oEnt_catUser.intTipoMoneda = (int)drd["intTipoMoneda"];
                oEnt_catUser.IntSucursal = (int)drd["intSucursal"];
				
				return oEnt_catUser;
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
                value = SqlHelper.ExecuteScalar(ConnectionString, CommandType.StoredProcedure, "VetecMarfilAdmin..usp_tbEmpresas_Help", arrPar).ToString();
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
