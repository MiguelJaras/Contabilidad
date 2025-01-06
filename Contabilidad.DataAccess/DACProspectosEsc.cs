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
    public class DACProspectosEsc : Base
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
                obj.DblServicioCons = Convert.ToDecimal(drd["dblImporteServCons"]);

            DataTable schemaTable = drd.GetSchemaTable();
            foreach (DataRow row in schemaTable.Rows)
            {
                if (row["ColumnName"].ToString() == "decFolioFacturaAenP")
                {
                    if (drd["decFolioFacturaAenP"] != DBNull.Value)
                        obj.DblFolioFacturaAenP = (decimal)drd["decFolioFacturaAenP"];
                    break;
                }
            }

            obj.IntProspecto = (int)drd["intProspecto"];
            obj.StrProspecto = (string)drd["cliente"];
            obj.StrRFC = (string)drd["rfc"];
            obj.StrPais = (string)drd["pais"];
            obj.StrEstado = (string)drd["estado"];
            obj.StrCiudad = (string)drd["ciudad"];
            obj.StrColonia = (string)drd["colonia"];
            obj.StrDireccion = (string)drd["direccion"];
            obj.StrCalle = (string)drd["calle"];
            obj.strKeys = (string)drd["cp"];
            obj.StrTelefono = (string)drd["telefono"];
            obj.StrEmail = (string)drd["email"];
            obj.DblDescuento = (string)drd["descuento"];
            obj.StrTerreno = (string)drd["terreno"];
            obj.DblPrecioTerreno = (string)drd["precioterreno"];
            obj.DblPrecioEdificacion = (string)drd["precioedificacion"];
            obj.DblAvaluo = (string)drd["Avaluo"];
            obj.IntPais = (int)drd["intPais"];
            obj.IntEstado = (int)drd["intEstado"];
            obj.IntCiudad = (int)drd["intCiudad"];
            obj.Constancia = (string)drd["Constancia"];
            obj.IntDocumento = (int)drd["intDocumento"];
            obj.IntTipoRegimen = (int)drd["intTipoRegimen"];
            obj.IntRegimenFiscal = (int)drd["intRegimenFiscal"];

            obj.StrNombreCliente = (string)drd["strNombreCliente"];
            obj.StrApellidoPaterno = (string)drd["strApellidoPaterno"];
            obj.StrApellidoMaterno = (string)drd["strApellidoMaterno"];
            obj.StrNumero = (string)drd["strNumero"];
            obj.StrNumeroExt = (string)drd["strNumeroExt"];

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

        public static bool SaveDatosFacturacion(Entity_ProspectoEsc prospecto)
        {
            bool res = false;
            try
            {

                SqlParameter[] arrPar = new SqlParameter[21];
                arrPar[0] = new SqlParameter("@intProspecto", SqlDbType.Int);
                arrPar[0].Value = prospecto.IntProspecto;
                arrPar[1] = new SqlParameter("@strCodigoPostalFiscal", SqlDbType.VarChar);
                arrPar[1].Value = prospecto.strKeys;
                arrPar[2] = new SqlParameter("@strVialidadFiscal", SqlDbType.VarChar);
                arrPar[2].Value = "99";
                arrPar[3] = new SqlParameter("@strNombVialidadFiscal", SqlDbType.VarChar);
                arrPar[3].Value = "";
                arrPar[4] = new SqlParameter("@strExteriorFiscal", SqlDbType.VarChar);
                arrPar[4].Value = prospecto.StrNumeroExt;
                arrPar[5] = new SqlParameter("@strInteriorFiscal", SqlDbType.VarChar);
                arrPar[5].Value = prospecto.StrNumero;
                arrPar[6] = new SqlParameter("@strColoniaFiscal", SqlDbType.VarChar);
                arrPar[6].Value = prospecto.StrColonia;
                arrPar[7] = new SqlParameter("@strLocalidadFiscal", SqlDbType.VarChar);
                arrPar[7].Value = prospecto.StrCiudad;
                arrPar[8] = new SqlParameter("@strMunicipioDemarcacionFiscal", SqlDbType.VarChar);
                arrPar[8].Value = prospecto.StrCiudad;
                arrPar[9] = new SqlParameter("@strEntidadFederativaFiscal", SqlDbType.VarChar);
                arrPar[9].Value = prospecto.StrEstado;
                arrPar[10] = new SqlParameter("@strEntreCalleFiscal", SqlDbType.VarChar);
                arrPar[10].Value = "";
                arrPar[11] = new SqlParameter("@strCalleFiscal", SqlDbType.VarChar);
                arrPar[11].Value = prospecto.StrCalle;
                arrPar[12] = new SqlParameter("@strCorreoElectronicoFiscal", SqlDbType.VarChar);
                arrPar[12].Value = prospecto.StrEmail;
                arrPar[13] = new SqlParameter("@strTelFijoLadaFiscal", SqlDbType.VarChar);
                arrPar[13].Value = prospecto.StrTelefono;
                arrPar[14] = new SqlParameter("@strNumeroFiscal", SqlDbType.VarChar);
                arrPar[14].Value = prospecto.StrNumero;
                arrPar[15] = new SqlParameter("@strRutaConstanciaFiscal", SqlDbType.VarChar);
                arrPar[15].Value = "";
                arrPar[16] = new SqlParameter("@strRFCFiscal", SqlDbType.VarChar);
                arrPar[16].Value = prospecto.StrRFC;
                arrPar[17] = new SqlParameter("@strRegimenFiscal", SqlDbType.VarChar);
                arrPar[17].Value = prospecto.IntRegimenFiscal;
                arrPar[18] = new SqlParameter("@strNombre", SqlDbType.VarChar);
                arrPar[18].Value = prospecto.StrNombreCliente;
                arrPar[19] = new SqlParameter("@strApellidoPaterno", SqlDbType.VarChar);
                arrPar[19].Value = prospecto.StrApellidoPaterno;
                arrPar[20] = new SqlParameter("@strApellidoMaterno", SqlDbType.VarChar);
                arrPar[20].Value = prospecto.StrApellidoMaterno;
                SqlHelper.ExecuteScalar(ConnectionString, CommandType.StoredProcedure, "usp_tbProspectoConstanciaFiscal_Save", arrPar).ToString();
                res = true;

            }
            catch (Exception e)
            {
                throw e;
            }
            return res;
        }

        public static bool SaveFormaPago(int intFactura, string strMetodoPago, string strFormaPago, string strUsoCFDI)
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
                arrPar[3] = new SqlParameter("@strUsoCFDI", SqlDbType.VarChar);
                arrPar[3].Value = strUsoCFDI;

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

        public static bool SaveGenerarXFaC(int intProspecto, int intFactura)
        {
            bool res = false;
            try
            {
                SqlParameter[] arrPar = new SqlParameter[2];
                arrPar[0] = new SqlParameter("@intProspecto", SqlDbType.Int);
                arrPar[0].Value = intProspecto;
                arrPar[1] = new SqlParameter("@intFactura", SqlDbType.Int);
                arrPar[1].Value = intFactura;

                SqlHelper.ExecuteNonQuery(ConnectionString, CommandType.StoredProcedure, "usp_tbFacturasGenerar_SaveGenerarXFac", arrPar);
                res = true;

            }
            catch (Exception e)
            {
                throw e;
            }
            return res;
        }

        public static bool SaveGenerarXNot(int intProspecto, int intNotaCredito)
        {
            bool res = false;
            try
            {
                SqlParameter[] arrPar = new SqlParameter[2];
                arrPar[0] = new SqlParameter("@intProspecto", SqlDbType.Int);
                arrPar[0].Value = intProspecto;
                arrPar[1] = new SqlParameter("@intNotaCredito", SqlDbType.Int);
                arrPar[1].Value = intNotaCredito;

                SqlHelper.ExecuteNonQuery(ConnectionString, CommandType.StoredProcedure, "usp_tbNotasCreditoGenerar_SaveGenerarXNot", arrPar);
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

        public static bool SaveNC(int intProspecto, decimal decImporte, string strUsuario, string strMaquina, string strFormaPago, string strMetodoPago, decimal decFolio, decimal decFolioAENP, int intFideicomiso, decimal dblBonificacion)
        {
            bool res = false;

            try
            {

                SqlParameter[] arrPar = new SqlParameter[10];
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
                arrPar[7] = new SqlParameter("@decFolioFacturaAENP", SqlDbType.Decimal);
                arrPar[7].Value = decFolioAENP;
                arrPar[8] = new SqlParameter("@intFideicomiso", SqlDbType.Int);
                arrPar[8].Value = intFideicomiso;
                arrPar[9] = new SqlParameter("@dblBonificacion", SqlDbType.Decimal);
                arrPar[9].Value = dblBonificacion;

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

        public static DataTable RegimenFiscal(int intTipo)
        {
            DataSet ds;

            try
            {
                ds = SqlHelper.ExecuteDataset(ConnectionString, CommandType.Text, "SELECT intRegimen,strNombre FROM tbRegimenFiscal WHERE intTipo =" + intTipo.ToString());
                return ds.Tables[0];
            }
            catch (Exception e)
            {
                return null;
            }
        }

    }
}
