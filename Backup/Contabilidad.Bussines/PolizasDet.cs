using System;
using System.Data;
using System.Collections;
using System.Collections.Specialized;
using Contabilidad.DataAccess;
using Contabilidad.Entity;

namespace Contabilidad.Bussines
{
    public class PolizasDet
    {
        #region Save
        public string Save(Entity_PolizasDet obj)
        {
            return DACPolizaDet.Save(obj);
        }
        #endregion Save

        #region ExportBalanza
        public string ExportBalanza(Entity_Conciliaciones obj)
        {
            string value = "VetecMarfilAdmin..usp_tbPolizasDet_Balanza ";
            value = value + obj.IntEmpresa.ToString() + ",";
            value = value + obj.IntEjercicio.ToString() + ",";
            value = value + obj.IntMes.ToString() + ",";
            value = value + obj.IntFolio.ToString() + ",'";
            value = value + obj.StrFechaInicial.ToString() + "','";
            value = value + obj.StrFechaFinal.ToString() + "','";
            value = value + obj.StrObraInicial.ToString() + "','";
            value = value + obj.StrObraFinal.ToString() + "',";
            value = value + obj.IntProveedorInicial.ToString() + ",";
            value = value + obj.IntProveedorFinal.ToString() + ",";
            value = value + obj.IntParametroInicial.ToString() + ",";
            value = value + obj.IntParametroFinal.ToString() + ",'";
            value = value + obj.StrInsumoInicial.ToString() + "','";
            value = value + obj.StrInsumoFinal.ToString() + "','";
            value = value + obj.StrMaquina.ToString() + "'";

            return value;
        }
        #endregion

        #region ExportBalanzaObra
        public string ExportBalanzaObra(Entity_Conciliaciones obj)
        {
            string value = "VetecMarfilAdmin..usp_tbPolizasDet_Balanza_Obra ";
            value = value + obj.IntEmpresa.ToString() + ",";
            value = value + obj.IntEjercicio.ToString() + ",";
            value = value + obj.IntMes.ToString() + ",";
            value = value + obj.IntFolio.ToString() + ",'";
            value = value + obj.StrFechaInicial.ToString() + "','";
            value = value + obj.StrFechaFinal.ToString() + "','";
            value = value + obj.StrObraInicial.ToString() + "','";
            value = value + obj.StrObraFinal.ToString() + "',";
            value = value + obj.IntProveedorInicial.ToString() + ",";
            value = value + obj.IntProveedorFinal.ToString() + ",";
            value = value + obj.IntParametroInicial.ToString() + ",";
            value = value + obj.IntParametroFinal.ToString() + ",'";
            value = value + obj.StrInsumoInicial.ToString() + "','";
            value = value + obj.StrInsumoFinal.ToString() + "',";
            value = value + obj.IntConciliacion.ToString();

            return value;
        }
        #endregion

        #region ExportBalanzaCero
        public string ExportBalanzaCero(Entity_Conciliaciones obj)
        {
            string value = "VetecMarfilAdmin..usp_tbPolizasDet_Balanza_Cero ";
            value = value + obj.IntEmpresa.ToString() + ",";
            value = value + obj.IntEjercicio.ToString() + ",";
            value = value + obj.IntMes.ToString() + ",";
            value = value + obj.IntFolio.ToString() + ",'";
            value = value + obj.StrFechaInicial.ToString() + "','";
            value = value + obj.StrFechaFinal.ToString() + "','";
            value = value + obj.StrObraInicial.ToString() + "','";
            value = value + obj.StrObraFinal.ToString() + "',";
            value = value + obj.IntProveedorInicial.ToString() + ",";
            value = value + obj.IntProveedorFinal.ToString() + ",";
            value = value + obj.IntParametroInicial.ToString() + ",";
            value = value + obj.IntParametroFinal.ToString() + ",'";
            value = value + obj.StrInsumoInicial.ToString() + "','";
            value = value + obj.StrInsumoFinal.ToString() + "'";

            return value;
        }
        #endregion

        #region ExportAuxiliar
        public string ExportAuxiliar(Entity_Conciliaciones obj)
        {
            string value = "VetecMarfilAdmin..usp_tbPolizasDet_Auxiliar ";
            value = value + obj.IntEmpresa.ToString() + ",";
            value = value + obj.IntEjercicioInicial.ToString() + ",";
            value = value + obj.IntEjercicioFinal.ToString() + ",";
            value = value + obj.IntMesInicial.ToString() + ",";
            value = value + obj.IntMesFinal.ToString() + ",'";
            value = value + obj.StrFechaInicial.ToString() + "','";
            value = value + obj.StrFechaFinal.ToString() + "','";
            value = value + obj.StrObraInicial.ToString() + "','";
            value = value + obj.StrObraFinal.ToString() + "',";
            value = value + obj.IntProveedorInicial.ToString() + ",";
            value = value + obj.IntProveedorFinal.ToString() + ",";
            value = value + obj.IntParametroInicial.ToString() + ",";
            value = value + obj.IntParametroFinal.ToString() + ",";
            value = value + obj.IntEjercicio.ToString();

            return value;
        }
        #endregion

        #region Balanza
        public DataTable Balanza(Entity_Conciliaciones obj)
        {
            return DACPolizaDet.Balanza(obj);
        }
        #endregion Balanza

        #region BalanzaCuenta
        public DataTable BalanzaCuenta(Entity_Conciliaciones obj)
        {
            return DACPolizaDet.BalanzaCuenta(obj);
        }
        #endregion BalanzaCuenta

        #region Sel
        public DataTable Sel(Entity_PolizasDet obj)
        {
            return DACPolizaDet.Sel(obj);
        }
        #endregion Save

        #region ListAux
        public DataTable ListAux(int intEmpresa)
        {
            return DACPolizaDet.ListAux(intEmpresa);
        }
        #endregion ListAux

        #region GetList
        public DataTable GetList(Entity_PolizasDet obj)
        {
            return DACPolizaDet.GetList(obj);
        }
        #endregion ListAux

        #region Delete
        public string Delete(Entity_PolizasDet obj)
        {
            return DACPolizaDet.Delete(obj);
        }
        #endregion 

        #region DeleteAll
        public string DeleteAll(Entity_PolizasDet obj)
        {
            return DACPolizaDet.DeleteAll(obj);
        }
        #endregion 

        #region SelXML
        public DataTable SelXML(Entity_PolizasDet obj)
        {
            return DACPolizaDet.SelXML(obj);
        }
        #endregion SelXML

        #region SelCuentaXML
        public DataTable SelCuentaXML(Entity_PolizasDet obj)
        {
            return DACPolizaDet.SelCuentaXML(obj);
        }
        #endregion SelCuentaXML

        #region SelAuxFolios
        public DataTable SelAuxFolios(Entity_PolizasDet obj)
        {
            return DACPolizaDet.SelAuxFolios(obj);
        }
        #endregion SelAuxFolios

        #region ExportBalanza_Elec
        public string ExportBalanza_Elec(Entity_Conciliaciones obj)
        {
            string value = "VetecMarfilAdmin..usp_tbPolizasDet_Balanza_Elec ";
            value = value + obj.IntEmpresa.ToString() + ",";
            value = value + obj.IntEjercicio.ToString() + ",";
            value = value + obj.IntMes.ToString() + ",";
            value = value + obj.IntFolio.ToString() + ",'";
            value = value + obj.StrFechaInicial.ToString() + "','";
            value = value + obj.StrFechaFinal.ToString() + "','";
            value = value + obj.StrObraInicial.ToString() + "','";
            value = value + obj.StrObraFinal.ToString() + "',";
            value = value + obj.IntProveedorInicial.ToString() + ",";
            value = value + obj.IntProveedorFinal.ToString() + ",";
            value = value + obj.IntParametroInicial.ToString() + ",";
            value = value + obj.IntParametroFinal.ToString() + ",'";
            value = value + obj.StrInsumoInicial.ToString() + "','";
            value = value + obj.StrInsumoFinal.ToString() + "','";
            value = value + obj.StrMaquina.ToString() + "'";

            return value;
        }
        #endregion
    }
}
