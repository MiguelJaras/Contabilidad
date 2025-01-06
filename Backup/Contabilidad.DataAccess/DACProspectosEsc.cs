using System;
using System.Collections.Generic;
using System.Text;
using Contabilidad.Entity;
using System.Data.SqlClient;
using System.Data;
using Microsoft.ApplicationBlocks.Data;
using System.Xml;

namespace Contabilidad.DataAccess
{
    public class DACProspectosEsc :Base
    {
        #region Sel
        public static Entity_ProspectoEsc Sel(Entity_ProspectoEsc obj)
        {
            IDataReader drd;
            Entity_ProspectoEsc oEntity_ProspectoEsc;
            oEntity_ProspectoEsc = new Entity_ProspectoEsc();

            try
            {
                SqlParameter[] arrPar = new SqlParameter[1];
                arrPar[0] = new SqlParameter("@intProspecto", SqlDbType.Int);
                arrPar[0].Value = obj.IntProspecto;

                drd = SqlHelper.ExecuteReader(ConnectionString, CommandType.StoredProcedure, "usp_tbProspecto_Facturacion", arrPar);
                if (drd.Read())
                {
                    oEntity_ProspectoEsc = CreateObject(drd);
                }
                else
                {
                    oEntity_ProspectoEsc = null;
                }
            }
            catch (Exception e)
            {
                oEntity_ProspectoEsc = null;
            }

            return oEntity_ProspectoEsc;
        }
        #endregion 


        #region SelNC
        public static Entity_ProspectoEsc SelNC(Entity_ProspectoEsc obj)
        {
            IDataReader drd;
            Entity_ProspectoEsc oEntity_ProspectoEsc;
            oEntity_ProspectoEsc = new Entity_ProspectoEsc();

            try
            {
                SqlParameter[] arrPar = new SqlParameter[1];
                arrPar[0] = new SqlParameter("@intProspecto", SqlDbType.Int);
                arrPar[0].Value = obj.IntProspecto;

                drd = SqlHelper.ExecuteReader(ConnectionString, CommandType.StoredProcedure, "usp_tbProspecto_FacturacionNotaCredito", arrPar);
                if (drd.Read())
                {
                    oEntity_ProspectoEsc = CreateObject(drd);
                }
                else
                {
                    oEntity_ProspectoEsc = null;
                }
            }
            catch (Exception e)
            {
                oEntity_ProspectoEsc = null;
            }

            return oEntity_ProspectoEsc;
        }
        #endregion 


        #region Create
        static Entity_ProspectoEsc CreateObject(IDataReader drd)
        {
            Entity_ProspectoEsc obj;
            obj = new Entity_ProspectoEsc();

            if (drd["dblBonificacion"] != DBNull.Value)
                obj.dblBonificacion = (decimal)drd["dblBonificacion"];

            if (drd["dblImporteRestante"] != DBNull.Value)
                obj.dblImporteRestante = (decimal)drd["dblImporteRestante"];

            if (drd["strSerieFactura"] != DBNull.Value)
                obj.strSerieFactura = (string)drd["strSerieFactura"];

            if (drd["decFolioFactura"] != DBNull.Value)
                obj.dblFolioFactura = (decimal)drd["decFolioFactura"];

            if (drd["bPublicoGeneral"] != DBNull.Value)
                obj.bPublicoGeneral = (bool)drd["bPublicoGeneral"];


            if (drd["dblImporteServCons"] != DBNull.Value)
                obj.DblServicioCons = Convert.ToDecimal( drd["dblImporteServCons"]);


            obj.IntProspecto = (int)drd["intProspecto"];
            obj.StrProspecto = (string)drd["cliente"];
            obj.StrRFC = (string)drd["rfc"];
            obj.StrPais = (string)drd["pais"];
            obj.StrEstado = (string)drd["estado"];
            obj.StrCiudad = (string)drd["ciudad"];
            obj.StrColonia = (string)drd["colonia"];
            obj.StrDireccion = (string)drd["direccion"];
            obj.StrCalle = (string)drd["calle"];
            obj.IntCP = (int)drd["cp"];
            obj.StrTelefono = (string)drd["telefono"];
            obj.StrEmail = (string)drd["email"];
            obj.DblDescuento = (string)drd["descuento"];
            obj.StrTerreno =  (string)drd["terreno"];
            obj.DblPrecioTerreno = (string)drd["precioterreno"];
            obj.DblPrecioEdificacion = (string)drd["precioedificacion"];
            obj.DblAvaluo = (string)drd["Avaluo"];
            obj.IntPais = (int)drd["intPais"];
            obj.IntEstado = (int)drd["intEstado"];
            obj.IntCiudad = (int)drd["intCiudad"];

            


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
                value = SqlHelper.ExecuteScalar(ConnectionString, CommandType.StoredProcedure, "usp_tbProspectoEsc_Help", arrPar).ToString();
                return value;
            }
            catch (Exception e)
            {
                return "";
            }
        }

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
                value = SqlHelper.ExecuteDataset(ConnectionString, CommandType.StoredProcedure, "usp_tbProspecto_Help", arrPar);
                return value;
            }
            catch (Exception e)
            {
                return null;
            }
        }

        #endregion

        public static bool Save(Entity_ProspectoEsc prospecto)
        {
            bool res = false;
            try
            {
                SqlParameter[] arrPar = new SqlParameter[8];
                arrPar[0] = new SqlParameter("@intProspecto", SqlDbType.Int);
                arrPar[0].Value = prospecto.IntProspecto;
                arrPar[1] = new SqlParameter("@strUsuario", SqlDbType.VarChar);
                arrPar[1].Value = prospecto.StrUsuario;
                arrPar[2] = new SqlParameter("@strMaquina", SqlDbType.VarChar);
                arrPar[2].Value = prospecto.StrMaquina;
                arrPar[3] = new SqlParameter("@bPublicoGeneral", SqlDbType.Bit);
                arrPar[3].Value = prospecto.bPublicoGeneral;
                arrPar[4] = new SqlParameter("@bFideicomiso", SqlDbType.Int);
                arrPar[4].Value = prospecto.BFideicomiso;
                arrPar[5] = new SqlParameter("@dblImporteFid", SqlDbType.Decimal);
                arrPar[5].Value = prospecto.DblImporteFideicomiso;
                arrPar[6] = new SqlParameter("@bServCons", SqlDbType.Int);
                arrPar[6].Value = prospecto.BServicioCons;
                arrPar[7] = new SqlParameter("@dblServCons", SqlDbType.Decimal);
                arrPar[7].Value = prospecto.DblServicioCons;
                SqlHelper.ExecuteNonQuery(ConnectionString, CommandType.StoredProcedure, "usp_tbProspecto_FacturacionSave", arrPar);
                res = true;

            }
            catch (Exception e)
            {
                throw e;
            }
            return res;
        }


        public static bool SaveFormaPago(int intFactura, string strMetodoPago, string strFormaPago)
        {
            bool res = false;
            try
            {
                SqlParameter[] arrPar = new SqlParameter[4];
                arrPar[0] = new SqlParameter("@intFactura", SqlDbType.Int);
                arrPar[0].Value = intFactura;
                arrPar[1] = new SqlParameter("@strMetodoPago", SqlDbType.VarChar);
                arrPar[1].Value = strMetodoPago;
                arrPar[2] = new SqlParameter("@strFormaPago", SqlDbType.VarChar);
                arrPar[2].Value = strFormaPago;
                
                SqlHelper.ExecuteNonQuery(ConnectionString, CommandType.StoredProcedure, "usp_tbFacturasGenerar_SavePago", arrPar);
                res = true;

            }
            catch (Exception e)
            {
                throw e;
            }
            return res;
        }


        public static bool SaveGenerar(int intProspecto)
        {
            bool res = false;
            try
            {
                SqlParameter[] arrPar = new SqlParameter[1];
                arrPar[0] = new SqlParameter("@intProspecto", SqlDbType.Int);
                arrPar[0].Value = intProspecto;

                SqlHelper.ExecuteNonQuery(ConnectionString, CommandType.StoredProcedure, "usp_tbFacturasGenerar_SaveGenerar", arrPar);
                res = true;

            }
            catch (Exception e)
            {
                throw e;
            }
            return res;
        }



        public static DataTable List(int intProspecto, int intEstatus)
        {
            DataSet ds;

            try
            {
                SqlParameter[] arrPar = new SqlParameter[3];
                arrPar[0] = new SqlParameter("@intProspecto", SqlDbType.Int);
                arrPar[0].Value = intProspecto;
                arrPar[1] = new SqlParameter("@intEstatus", SqlDbType.Int);
                arrPar[1].Value = intEstatus;
                ds = SqlHelper.ExecuteDataset(ConnectionString, CommandType.StoredProcedure, "usp_tbProspecto_FacturacionList ", arrPar);
                return ds.Tables[0];

            }
            catch (Exception e)
            {
                return null;
            }
        }

        public static DataTable ListNC(int intProspecto, int intEstatus)
        {
            DataSet ds;

            try
            {
                SqlParameter[] arrPar = new SqlParameter[3];
                arrPar[0] = new SqlParameter("@intProspecto", SqlDbType.Int);
                arrPar[0].Value = intProspecto;
                arrPar[1] = new SqlParameter("@intEstatus", SqlDbType.Int);
                arrPar[1].Value = intEstatus;
                ds = SqlHelper.ExecuteDataset(ConnectionString, CommandType.StoredProcedure, "usp_tbProspecto_FacturacionNotaCreditoList ", arrPar);
                return ds.Tables[0];

            }
            catch (Exception e)
            {
                return null;
            }
        }


        public static bool SaveNC(int intProspecto, decimal decImporte, string strUsuario, string strMaquina, string strFormaPago, string strMetodoPago, decimal decFolio)
        {
            bool res = false;

            try
            {

                SqlParameter[] arrPar = new SqlParameter[7];
                arrPar[0] = new SqlParameter("@intProspecto", SqlDbType.Int);
                arrPar[0].Value = intProspecto;
                arrPar[1] = new SqlParameter("@dblImporte", SqlDbType.Decimal);
                arrPar[1].Value = decImporte;
                arrPar[2] = new SqlParameter("@strUsuario", SqlDbType.VarChar);
                arrPar[2].Value = strUsuario;
                arrPar[3] = new SqlParameter("@strMaquina", SqlDbType.VarChar);
                arrPar[3].Value = strMaquina;
                arrPar[4] = new SqlParameter("@strFormaPago", SqlDbType.VarChar);
                arrPar[4].Value = strFormaPago;
                arrPar[5] = new SqlParameter("@strMetodopago", SqlDbType.VarChar);
                arrPar[5].Value = strMetodoPago;
                arrPar[6] = new SqlParameter("@decFolioFactura", SqlDbType.Decimal);
                arrPar[6].Value = decFolio;


                SqlHelper.ExecuteNonQuery(ConnectionString, CommandType.StoredProcedure, "usp_tbProspecto_FacturacionNotaCredito_Save", arrPar);
                res = true;
            }
            catch (Exception e)
            {
                throw e;
            }
            return res;
        }

        public static bool EliminarFacturas(int intFactura, int intEmpresa, int intFolio, int intProspecto)
        {
            bool res = false;
            try
            {
                SqlParameter[] arrPar = new SqlParameter[8];
                arrPar[0] = new SqlParameter("@intFactura", SqlDbType.Int);
                arrPar[0].Value = intFactura;
                arrPar[1] = new SqlParameter("@intEmpresa", SqlDbType.Int);
                arrPar[1].Value = intEmpresa;
                arrPar[2] = new SqlParameter("@intFolio", SqlDbType.Int);
                arrPar[2].Value = intFolio;
                arrPar[3] = new SqlParameter("@intProspecto", SqlDbType.Int);
                arrPar[3].Value = intProspecto;


                SqlHelper.ExecuteNonQuery(ConnectionString, CommandType.StoredProcedure, "usp_tbFacturasGenerar_Delete", arrPar);
                res = true;

            }
            catch (Exception e)
            {
                throw e;
            }
            return res;
        }


        public static bool EliminarNC(int intNotaCredito, int intEmpresa, int intFolio, int intProspecto)
        {
            bool res = false;
            try
            {
                SqlParameter[] arrPar = new SqlParameter[8];
                arrPar[0] = new SqlParameter("@intNotaCredito", SqlDbType.Int);
                arrPar[0].Value = intNotaCredito;
                arrPar[1] = new SqlParameter("@intEmpresa", SqlDbType.Int);
                arrPar[1].Value = intEmpresa;
                arrPar[2] = new SqlParameter("@intFolio", SqlDbType.Int);
                arrPar[2].Value = intFolio;
                arrPar[3] = new SqlParameter("@intProspecto", SqlDbType.Int);
                arrPar[3].Value = intProspecto;

                SqlHelper.ExecuteNonQuery(ConnectionString, CommandType.StoredProcedure, "usp_tbNotaCreditoGenerar_Delete", arrPar);
                res = true;

            }
            catch (Exception e)
            {
                throw e;
            }
            return res;
        }

    }

         
}
