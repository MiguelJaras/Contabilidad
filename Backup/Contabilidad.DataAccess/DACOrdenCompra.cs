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
    public class DACOrdenCompra : Base
	{      

		#region GetList
			public static DataTable GetList(Entity_OrdenCompra obj)
			{
                DataSet ds;

                SqlParameter[] arrPar = new SqlParameter[7];
                arrPar[0] = new SqlParameter("@intEmpresa", SqlDbType.Int);
                arrPar[0].Value = obj.IntEmpresa;
                arrPar[1] = new SqlParameter("@intSucursal", SqlDbType.Int);
                arrPar[1].Value = obj.IntSucursal;
                arrPar[2] = new SqlParameter("@intFolioInicial", SqlDbType.Int);
                arrPar[2].Value = obj.IntFolioInicial;
                arrPar[3] = new SqlParameter("@intFolioFinal", SqlDbType.Int);
                arrPar[3].Value = obj.intFolioFinal;
                arrPar[4] = new SqlParameter("@datFecha", SqlDbType.VarChar);
                arrPar[4].Value = obj.StrFechaInicial;
                arrPar[5] = new SqlParameter("@datFechaFinal", SqlDbType.VarChar);
                arrPar[5].Value = obj.StrFechaFinal;
                arrPar[6] = new SqlParameter("@intEstatus", SqlDbType.Int);
                arrPar[6].Value = obj.IntEstatus; 

                try
                {
                    ds = SqlHelper.ExecuteDataset(ConnectionString, CommandType.StoredProcedure, "usp_tbOrdenCompraEnc_List", arrPar);
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
                value = SqlHelper.ExecuteScalar(ConnectionString, CommandType.StoredProcedure, "usp_tbOrdenCompra_Help", arrPar).ToString();
                return value;
            }
            catch (Exception e)
            {
                return "";
            }

            return value;
        }
        #endregion

        #region Fill
        public static Entity_OrdenCompra Fill(Entity_OrdenCompra obj)
			{
                IDataReader drd;
                Entity_OrdenCompra oEntity_OrdenCompra;
                oEntity_OrdenCompra = new Entity_OrdenCompra();

                SqlParameter[] arrPar = new SqlParameter[3];
                arrPar[0] = new SqlParameter("@intEmpresa", SqlDbType.Int);
                arrPar[0].Value = obj.IntEmpresa;
                arrPar[1] = new SqlParameter("@intSucursal", SqlDbType.Int);
                arrPar[1].Value = obj.IntSucursal;
                arrPar[2] = new SqlParameter("@intOrdenCompraEnc", SqlDbType.Int);
                arrPar[2].Value = obj.IntOrdenCompraEnc;

                try
                {
                    drd = SqlHelper.ExecuteReader(ConnectionString, CommandType.StoredProcedure, "usp_tbOrdenCompraEnc_FillById", arrPar);
                    if (drd.Read())
                    {
                        oEntity_OrdenCompra = CreateObject(drd);
                    }
                    else
                        oEntity_OrdenCompra = null;
                }
                catch (Exception e)
                {
                    oEntity_OrdenCompra = null;
                }

                return oEntity_OrdenCompra;									
			}
			#endregion                  

		#region GetByFolio
            public static Entity_OrdenCompra GetByFolio(Entity_OrdenCompra obj)
			{
                IDataReader drd;
                Entity_OrdenCompra oEntity_OrdenCompra;
                oEntity_OrdenCompra = new Entity_OrdenCompra();

                SqlParameter[] arrPar = new SqlParameter[4];
                arrPar[0] = new SqlParameter("@intEmpresa", SqlDbType.Int);
                arrPar[0].Value = obj.IntEmpresa;
                arrPar[1] = new SqlParameter("@intSucursal", SqlDbType.Int);
                arrPar[1].Value = obj.IntSucursal;
                arrPar[2] = new SqlParameter("@intFolio", SqlDbType.Int);
                arrPar[2].Value = obj.IntFolio;
                arrPar[3] = new SqlParameter("@intProveedor", SqlDbType.Int);
                arrPar[3].Value = obj.IntProveedor;

                try
                {
                    drd = SqlHelper.ExecuteReader(ConnectionString, CommandType.StoredProcedure, "usp_tbOrdenCompraEnc_Fill", arrPar);
                    if (drd.Read())
                    {
                        oEntity_OrdenCompra = CreateObject(drd);
                    }
                    else
                        oEntity_OrdenCompra = null;
                }
                catch (Exception e)
                {
                    oEntity_OrdenCompra = null;
                }

                return oEntity_OrdenCompra;									
			}
			#endregion                  

        #region Create
        static Entity_OrdenCompra CreateObject(IDataReader drd)
        {
            Entity_OrdenCompra obj;
            obj = new Entity_OrdenCompra();

            obj.IntOrdenCompraEnc = (int)drd["IntOrdenCompraEnc"];
            obj.IntFolio = (int)drd["intFolio"];
            obj.DatFecha = Convert.ToString(drd["datFecha"]);
            obj.IntCentroCosto = (int)drd["intCentroCosto"];
            obj.StrUsuarioSolicita = (string)drd["strUsuarioSolicita"];
            obj.StrUsuarioAutoriza = (string)drd["strUsuarioAutoriza"];
            obj.StrUsuarioVoBo = (string)drd["strUsuarioVoBo"];
            obj.IntMoneda = (int)drd["intMoneda"];
            obj.DblTipoCambio = Convert.ToDouble(drd["DblTipoCambio"]);
            obj.IntEstatus = (int)drd["intEstatus"];
            obj.DblTotal = Convert.ToDouble(drd["DblTotal"]);
            obj.StrObservaciones = (string)drd["strObservaciones"];
            obj.IntAlmacen = (int)drd["IntAlmacen"];
            obj.IntSubAlmacen = (int)drd["IntSubAlmacen"];
            obj.IntObra = (int)drd["IntObra"];
            obj.Estatus = (string)drd["Estatus"];
            obj.Requisicion = (string)drd["Requisicion"];
            obj.IntProveedor = (int)drd["IntProveedor"];
            obj.IntTipoOrdenCompra = (int)drd["intTipoOrdenCompra"];
            obj.DblPorcentajeIVA = Convert.ToDouble(drd["DblPorcentajeIVA"]);
            obj.DblPorcentajeRetencion = Convert.ToDouble(drd["dblPorcentajeRetencion"]);
            obj.DblPorcentajeRetencion2 = Convert.ToDouble(drd["dblPorcentajeRetencion2"]);
            obj.IntAutoRecepcionable = (int)drd["intAutoRecepcionable"];
            obj.IntLab = (int)drd["IntLab"];

            return obj;
        }
        #endregion        
		
        #region Save
        public static string Save(Entity_OrdenCompra obj)
        {
            string result = "";

            SqlParameter[] arrPar = new SqlParameter[24];
            arrPar[0] = new SqlParameter("@intEmpresa", SqlDbType.Int);
            arrPar[0].Value = obj.IntEmpresa;
            arrPar[1] = new SqlParameter("@intSucursal", SqlDbType.Int);
            arrPar[1].Value = obj.IntSucursal;
            arrPar[2] = new SqlParameter("@intOrdenCompraEnc", SqlDbType.Int);
            arrPar[2].Value = obj.IntOrdenCompraEnc;
            arrPar[3] = new SqlParameter("@intTipoOrdenCompra", SqlDbType.Int);
            arrPar[3].Value = obj.IntTipoOrdenCompra;
            arrPar[4] = new SqlParameter("@intProveedor", SqlDbType.Int);
            arrPar[4].Value = obj.IntProveedor;
            arrPar[5] = new SqlParameter("@dblTipoCambio", SqlDbType.Decimal);
            arrPar[5].Value = obj.DblTipoCambio;
            arrPar[6] = new SqlParameter("@datFecha", SqlDbType.DateTime);
            arrPar[6].Value = obj.DatFecha;
            arrPar[7] = new SqlParameter("@datFechaEntrega", SqlDbType.VarChar);
            arrPar[7].Value = obj.DatFechaEntrega;
            arrPar[8] = new SqlParameter("@intCondicionPago", SqlDbType.Int);
            arrPar[8].Value = obj.IntCondicionPago;
            arrPar[9] = new SqlParameter("@intMoneda", SqlDbType.Int);
            arrPar[9].Value = obj.IntMoneda;
            arrPar[10] = new SqlParameter("@intLAB", SqlDbType.Int);
            arrPar[10].Value = obj.IntLab;
            arrPar[11] = new SqlParameter("@strObservaciones", SqlDbType.VarChar);
            arrPar[11].Value = obj.StrObservaciones;
            arrPar[12] = new SqlParameter("@intEstatus", SqlDbType.Int);
            arrPar[12].Value = obj.IntEstatus;
            arrPar[13] = new SqlParameter("@datFechaRealRecepcion", SqlDbType.VarChar);
            arrPar[13].Value = obj.DatFechaRealRecepcion;
            arrPar[14] = new SqlParameter("@strUsuarioCompra", SqlDbType.VarChar);
            arrPar[14].Value = obj.StrUsuarioCompra;
            arrPar[15] = new SqlParameter("@strUsuarioSolicita", SqlDbType.VarChar);
            arrPar[15].Value = obj.StrUsuarioSolicita;
            arrPar[16] = new SqlParameter("@strUsuarioVoBo", SqlDbType.VarChar);
            arrPar[16].Value = obj.StrUsuarioVoBo;
            arrPar[17] = new SqlParameter("@dblPorcentajeIVA", SqlDbType.Decimal);
            arrPar[17].Value = obj.DblPorcentajeIVA;
            arrPar[18] = new SqlParameter("@strUsuario", SqlDbType.VarChar);
            arrPar[18].Value = obj.StrUsuario;
            arrPar[19] = new SqlParameter("@strMaquina", SqlDbType.VarChar);
            arrPar[19].Value = obj.StrMaquina; 
            arrPar[20] = new SqlParameter("@intObra", SqlDbType.Int);
            arrPar[20].Value = obj.IntObra;
            arrPar[21] = new SqlParameter("@dblPorcentajeRetencion", SqlDbType.Decimal);
            arrPar[21].Value = obj.DblPorcentajeRetencion;
            arrPar[22] = new SqlParameter("@dblPorcentajeRetencion2", SqlDbType.Decimal);
            arrPar[22].Value = obj.DblPorcentajeRetencion2;
            arrPar[23] = new SqlParameter("@intAutoRecepcionable", SqlDbType.Int);
            arrPar[23].Value = obj.IntAutoRecepcionable;

            try
            {
                result = SqlHelper.ExecuteScalar(ConnectionString, CommandType.StoredProcedure, "usp_tbOrdenCompraEnc_Save", arrPar).ToString();
            }
            catch (Exception e)
            {
                result = "";
            }

            return result;
        }
        #endregion

        #region Estatus
        public static string Estatus(Entity_OrdenCompra obj)
        {
            string result = "";

            SqlParameter[] arrPar = new SqlParameter[19];
            arrPar[0] = new SqlParameter("@intEmpresa", SqlDbType.Int);
            arrPar[0].Value = obj.IntEmpresa;
            arrPar[1] = new SqlParameter("@intSucursal", SqlDbType.Int);
            arrPar[1].Value = obj.IntSucursal;
            arrPar[2] = new SqlParameter("@strKeys", SqlDbType.VarChar);
            arrPar[2].Value = obj.strKeys;
            arrPar[3] = new SqlParameter("@intEstatus", SqlDbType.Int);
            arrPar[3].Value = obj.IntEstatus;
            arrPar[4] = new SqlParameter("@strComentario", SqlDbType.VarChar);
            arrPar[4].Value = obj.StrObservaciones;
            arrPar[5] = new SqlParameter("@strUsuario", SqlDbType.VarChar);
            arrPar[5].Value = obj.StrUsuario;
            arrPar[6] = new SqlParameter("@strMaquina", SqlDbType.VarChar);
            arrPar[6].Value = obj.StrMaquina;

            try
            {
                result = SqlHelper.ExecuteScalar(ConnectionString, CommandType.StoredProcedure, "usp_tbOrdenCompraEnc_Autoriza", arrPar).ToString();
            }
            catch (Exception e)
            {
                throw e;
            }

            return result;
        }
        #endregion
	}
}
