using System;
using System.Data;
using System.Collections;
using Contabilidad.DataAccess;
using Contabilidad.Entity;

namespace Contabilidad.Bussines
{
    public class OrdenCompra
    {
        #region GetList
        public DataTable GetList(Entity_OrdenCompra obj)
        {
            return DACOrdenCompra.GetList(obj);       							
        }
        #endregion
        
        #region Fill
        public Entity_OrdenCompra Fill(Entity_OrdenCompra obj)
        {
            return DACOrdenCompra.Fill(obj);    
        }
        #endregion

        #region Save
        public string Save(Entity_OrdenCompra obj)
        {
            return DACOrdenCompra.Save(obj);
        }
        #endregion

        #region GetByFolio
        public Entity_OrdenCompra GetByFolio(Entity_OrdenCompra obj)
        {
            return DACOrdenCompra.GetByFolio(obj);   
        }
        #endregion       

        #region Estatus
        public string Estatus(Entity_OrdenCompra obj)
        {
            return DACOrdenCompra.Estatus(obj);
        }
        #endregion

        #region ExportKardex
        public string ExportKardex(Entity_OrdenCompra obj)
        {
            string value = "usp_Reporte_KardexInsumoObra ";
            value = value + obj.IntEmpresa.ToString() + ",'";
            value = value + obj.StrObraInicial + "','";
            value = value + obj.StrObraFinal + "','";
            value = value + obj.StrInsumoInicial + "','";
            value = value + obj.StrInsumoFinal + "','";
            value = value + obj.StrFechaInicial + "','";
            value = value + obj.StrFechaFinal + "'";

            return value;
        }
        #endregion

        #region ExportComprasInsumo
        public string ExportComprasInsumo(Entity_OrdenCompra obj)
        {
            string value = "usp_Reporte_ComprasInsumo ";
            value = value + obj.IntEmpresa.ToString() + ",'";
            value = value + obj.StrInsumoInicial + "','";
            value = value + obj.StrInsumoFinal + "','";
            value = value + obj.StrObraInicial + "','";
            value = value + obj.StrObraFinal + "','";
            value = value + obj.StrFechaInicial + "','";
            value = value + obj.StrFechaFinal + "'";

            return value;
        }
        #endregion

        #region ExportAnaliticoCompras
        public string ExportAnaliticoCompras(Entity_OrdenCompra obj)
        {
            string value = "usp_tbOrdenCompraEnc_AnalisisCompra ";
            value = value + obj.IntEmpresa.ToString() + ",'";
            value = value + obj.StrFechaInicial + "','";
            value = value + obj.StrFechaFinal + "','";
            value = value + obj.StrObraInicial + "','";
            value = value + obj.StrObraFinal + "',";
            value = value + obj.IntFolioInicial + ",";
            value = value + obj.intFolioFinal + ",'";
            value = value + obj.StrInsumoInicial + "','";
            value = value + obj.StrInsumoFinal + "'";            

            return value;
        }
        #endregion

        #region ExportAnaliticoComprasProv
        public string ExportAnaliticoComprasProv(Entity_OrdenCompra obj)
        {
            string value = "usp_tbOrdenCompraEnc_AnaliticoComprasProveedor ";
            value = value + obj.IntEmpresa.ToString() + ",'";
            value = value + obj.StrFechaInicial + "','";
            value = value + obj.StrFechaFinal + "','";
            value = value + obj.StrObraInicial + "','";
            value = value + obj.StrObraFinal + "',";
            value = value + obj.IntFolioInicial + ",";
            value = value + obj.intFolioFinal + ",'";
            value = value + obj.StrInsumoInicial + "','";
            value = value + obj.StrInsumoFinal + "'";

            return value;
        }
        #endregion

        #region ExportAnaliticoComprasIns
        public string ExportAnaliticoComprasIns(Entity_OrdenCompra obj)
        {
            string value = "usp_tbOrdenCompraEnc_AnaliticoComprasInsumo ";
            value = value + obj.IntEmpresa.ToString() + ",'";
            value = value + obj.StrFechaInicial + "','";
            value = value + obj.StrFechaFinal + "','";
            value = value + obj.StrObraInicial + "','";
            value = value + obj.StrObraFinal + "',";
            value = value + obj.IntFolioInicial + ",";
            value = value + obj.intFolioFinal + ",'";
            value = value + obj.StrInsumoInicial + "','";
            value = value + obj.StrInsumoFinal + "'";

            return value;
        }
        #endregion

        #region ExportOCFactura
        public string ExportOCFactura(Entity_OrdenCompra obj)
        {
            string value = "usp_Relacion_OC_Factura ";
            value = value + obj.IntEmpresa.ToString() + ",'";
            value = value + obj.StrFechaInicial + "','";
            value = value + obj.StrFechaFinal + "',";
            value = value + obj.IntFolioInicial + ",";
            value = value + obj.intFolioFinal + ",'";
            value = value + obj.StrObraInicial + "','";
            value = value + obj.StrObraFinal + "',";
            value = value + obj.IntProveedorInicial + ",";
            value = value + obj.IntProveedorFinal + ",'";
            value = value + obj.StrInsumoInicial + "','";
            value = value + obj.StrInsumoFinal + "'";

            return value;
        }
        #endregion

        #region ExportEstadisticoMensual
        public string ExportEstadisticoMensual(Entity_OrdenCompra obj)
        {

            string value = "usp_Reporte_EstadisticoMensualProveedor ";
            value = value + obj.IntEmpresa.ToString() + ",";
            value = value + obj.IntProveedorInicial + ",";
            value = value + obj.IntProveedorFinal + ",";
            value = value + obj.IntFolioInicial + ",";
            value = value + obj.intFolioFinal;          

            return value;
        }
        #endregion

        #region ExportAdmin
        public string ExportAdmin(Entity_OrdenCompra obj)
        {
            string value = "usp_tbOrdenCompraEnc_List ";
            value = value + obj.IntEmpresa.ToString() + ",";
            value = value + obj.IntSucursal.ToString() + ",";
            value = value + obj.IntFolioInicial.ToString() + ",";
            value = value + obj.intFolioFinal.ToString() + ",'";
            value = value + obj.StrFechaInicial + "','";
            value = value + obj.StrFechaFinal + "',";
            value = value + obj.IntEstatus.ToString();

            return value;
        }
        #endregion

        #region ExportProveedores
        public string ExportProveedores(Entity_OrdenCompra obj)
        {
            string value = "VetecMarfilAdmin..usp_Prove_Sel ";
            value = value + obj.IntEmpresa.ToString();

            return value;
        }
        #endregion

        #region RptQry
        public string RptQry(int intEmpresa, string intProvIni, string intProvFin, string intColIni, string intColFin, string intSectorIni, string intSectorFin, string intCCIni, string intCCFin, string intAreaIni, string intAreaFin, string intOCIni, string intOCFin, string datFechaIni, string datFechaFin)
        {
            string value = "VetecMarfilAdmin..usp_OC_Rep ";
            value = value + intEmpresa.ToString() + ",";
            value = value + intProvIni.ToString() + ",";
            value = value + intProvFin.ToString() + ",";
            value = value + intColIni.ToString () + ",";
            value = value + intColFin.ToString() + ",";
            value = value + intSectorIni.ToString() + ",";
            value = value + intSectorFin.ToString() + ",";
            value = value + intCCIni.ToString() + ",";
            value = value + intCCFin.ToString() + ",";
            value = value + intAreaIni.ToString() + ",";
            value = value + intAreaFin.ToString() + ",";
            value = value + intOCIni.ToString() + ",";
            value = value + intCCFin.ToString() + ",'";
            value = value + datFechaIni + "','";
            value = value + datFechaFin + "'";


            return value;
        }
        #endregion

    }
}
