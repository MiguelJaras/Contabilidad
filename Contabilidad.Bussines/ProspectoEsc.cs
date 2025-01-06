using System;
using System.Data;
using System.Collections;
using System.Collections.Specialized;
using Contabilidad.DataAccess;
using Contabilidad.Entity;

namespace Contabilidad.Bussines
{
    public class ProspectoEsc
    {

        public DataTable RegimenFiscal(int intProspecto)
        {
            return DACProspectosEsc.RegimenFiscal(intProspecto);
        }

        public Entity_ProspectoEsc Sel(Entity_ProspectoEsc obj)
        {
            return DACProspectosEsc.Sel(obj);
        }

        public Entity_ProspectoEsc SelNC(Entity_ProspectoEsc obj)
        {
            return DACProspectosEsc.SelNC(obj);
        }

        public bool Save(Entity_ProspectoEsc prospecto)
        {
            return DACProspectosEsc.Save(prospecto);
        }

        public bool SaveDatosFacturacion(Entity_ProspectoEsc prospecto)
        {
            return DACProspectosEsc.SaveDatosFacturacion(prospecto);
        }


        public bool SaveFormaPago(int intFactura, string strMetodoPago, string strFormaPago, string strUsoCFDI)
        {
            return DACProspectosEsc.SaveFormaPago(intFactura, strMetodoPago, strFormaPago, strUsoCFDI);
        }

        public bool SaveGenerar(int intProspecto)
        {
            return DACProspectosEsc.SaveGenerar(intProspecto);
        }

        public DataTable List(int intProspecto, int intEstatus)
        {
            return DACProspectosEsc.List(intProspecto, intEstatus);
        }

        public DataTable ListNC(int intProspecto, int intEstatus)
        {
            return DACProspectosEsc.ListNC(intProspecto, intEstatus);
        }
        public bool SaveNC(int intProspecto, decimal decImporte, string strUsuario, string strMaquina, string strFormaPago, string strMetodoPago, decimal decFolio, decimal decFolioAENP, int intFideicomiso, decimal dblBonificacion)
        {
            return DACProspectosEsc.SaveNC(intProspecto, decImporte, strUsuario, strMaquina, strFormaPago, strMetodoPago, decFolio, decFolioAENP, intFideicomiso, dblBonificacion);
        }

        public bool EliminarFacturas(int intFactura, int intEmpresa, int intFolio, int intProspecto)
        {
            return DACProspectosEsc.EliminarFacturas(intFactura, intEmpresa, intFolio, intProspecto);
        }

        public bool EliminarNC(int intNotaCredito, int intEmpresa, int intFolio, int intProspecto)
        {
            return DACProspectosEsc.EliminarNC(intNotaCredito, intEmpresa, intFolio, intProspecto);
        }

        public bool SaveGenerarXFaC(int intProspecto, int intFactura)
        {
            return DACProspectosEsc.SaveGenerarXFaC(intProspecto, intFactura);
        }
        public bool SaveGenerarXNot(int intProspecto, int intNotaCredito)
        {
            return DACProspectosEsc.SaveGenerarXNot(intProspecto, intNotaCredito);
        }

    }
}
