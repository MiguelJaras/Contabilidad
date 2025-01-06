using System;
using System.Data;
using System.Collections;
using Contabilidad.DataAccess;
using Contabilidad.Entity;

namespace Contabilidad.Bussines
{
    public class TiposPoliza
    {

        #region RptPolizasDet
        public DataTable RptPolizasDet(int intEmpresa, int intEjerc, int intMes, string strTipoPolizaIni, string strTipoPolizaFin, int intFolioIni, int intFolioFin, int intAfectada, int intDesAfectada, int intCancelada, int intTipoImpresion)
        {
            return DACTiposPoliza.RptPolizasDet(intEmpresa, intEjerc, intMes, strTipoPolizaIni, strTipoPolizaFin, intFolioIni, intFolioFin, intAfectada, intDesAfectada, intCancelada, intTipoImpresion);
        }
        #endregion

        #region RptPolizasDetQry
        public string RptPolizasDetQry(int intEmpresa, int intEjerc, int intMes, string strTipoPolizaIni, string strTipoPolizaFin, int intFolioIni, int intFolioFin, int intAfectada, int intDesAfectada, int intCancelada)
        {
            string value = "VetecMarfilAdmin..usp_tbPolizasDet_Print ";
            value = value + intEmpresa.ToString() + ",";
            value = value + intEjerc.ToString() + ",";
            value = value + intMes.ToString() + ",'";
            value = value + strTipoPolizaIni + "','";
            value = value + strTipoPolizaFin + "',";
            value = value + intFolioIni.ToString() + ",";
            value = value + intFolioFin.ToString() + ",";
            value = value + intAfectada.ToString() + ",";
            value = value + intDesAfectada.ToString() + ",";
            value = value + intCancelada.ToString();

            return value;
        }
        #endregion

        #region Det
        public DataTable det(Entity_TiposPoliza obj)
        {
            return DACTiposPoliza.Det(obj);
        }
        #endregion

        #region Sel
        public DataTable Sel(Entity_TiposPoliza obj)
        {
            return DACTiposPoliza.Sel(obj);
        }
        #endregion

        #region ExisteEnc
        public int ExisteEnc(int intEmpresa, int intEjercicio, int intFolioPoliza, int intMes, string strTipoPoliza)
        {
            return DACTiposPoliza.ExisteEnc(intEmpresa, intEjercicio, intFolioPoliza, intMes, strTipoPoliza );
        }
        #endregion

        #region Save
        public bool  Save(int intEmpresa, int intEjercicio, string strTipoPoliza, int intMes, int valPol)
        {
            return DACTiposPoliza.Save(intEmpresa, intEjercicio, strTipoPoliza, intMes, valPol);
        }
        #endregion

        #region Fill
        public Entity_TiposPoliza Fill(Entity_TiposPoliza obj)
        {
            return DACTiposPoliza.Fill(obj);
        }
        #endregion

        #region GetList
        public DataTable GetList()
        {
            return DACEmpresa.GetList();
        }
        #endregion

        #region GetSucursal
        public string GetSucursal(string intEmpresa)
        {
            return DACEmpresa.GetSucursal(intEmpresa);
        }
        #endregion
    }
}
