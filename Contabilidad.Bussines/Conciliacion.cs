using System;
using System.Data;
using System.Collections;
using Contabilidad.DataAccess;
using Contabilidad.Entity;

namespace Contabilidad.Bussines
{
   public class Conciliacion
    {
       #region Save
       public bool Save(Entity_Conciliacion obj)
       {
           return DACConciliacion.Save(obj);
       }
       #endregion

       #region SaveAut
       public bool SaveAut(Entity_Conciliacion obj)
       {
           return DACConciliacion.SaveAut(obj);
       }
       #endregion

       #region List
       public DataTable List(Entity_Conciliacion obj)
       {
           return DACConciliacion.List(obj);
       }
       #endregion
       
       #region List2
       public DataTable List2(Entity_Conciliacion obj)
       {
           return DACConciliacion.List2(obj);

       }
       #endregion

       #region List3
       public DataTable List3(Entity_Conciliacion obj)
       {
           return DACConciliacion.List3(obj);
       }
       #endregion

       #region MovBanConciliados
        public DataTable MovBanConciliados(Entity_Conciliacion obj)
        {
            return DACConciliacion.MovBanConciliados(obj);

        }
        #endregion

        #region MovBanConcilBusc
        public DataTable MovBanConcilBusc(Entity_Conciliacion obj)
        {
            return DACConciliacion.MovBanConcilBusc(obj);

        }
        #endregion

        #region Desconciliacion
        public bool Desconciliacion(Entity_Conciliacion obj)
        {
            return DACConciliacion.Desconciliacion(obj);
        }
        #endregion

        #region MovimientosConciliados
       public string MovimientosConciliados(Entity_Conciliacion obj)
        {
            string value = "usp_Movimientos_Bancarios_Conciliados ";
            value = value + obj.IntEmpresa.ToString() + ",";
            value = value + obj.IntCuentaBancaria.ToString() + ",";
            value = value + obj.IntMes.ToString() + ",";
            value = value + obj.IntEjercicio.ToString();

            return value;
        }
        #endregion

        #region ConciliacionBancaria
       public string ConciliacionBancaria(Entity_Conciliacion obj)
        {
            string value = "usp_Movimientos_Transito_Conciliados ";
            value = value + obj.IntEmpresa.ToString() + ",";
            value = value + obj.IntCuentaBancaria.ToString() + ",";
            value = value + obj.IntMes.ToString() + ",";
            value = value + obj.IntEjercicio.ToString();

            return value;
        }
        #endregion

        #region TransitoChequera
       public string TransitoChequera(Entity_Conciliacion obj)
        {
            string value = "usp_Movimientos_Conciliados ";
            value = value + obj.IntEmpresa.ToString() + ",";
            value = value + obj.IntCuentaBancaria.ToString() + ",";
            value = value + obj.IntMes.ToString() + ",";
            value = value + obj.IntEjercicio.ToString() + ",";
            value = value + obj.IntTipoMovto.ToString();

            return value;
        }
        #endregion

        #region TransitoBancario
        public string TransitoBancario(Entity_Conciliacion obj)
        {
            string value = "usp_Movimientos_Conciliados ";
            value = value + obj.IntEmpresa.ToString() + ",";
            value = value + obj.IntCuentaBancaria.ToString() + ",";
            value = value + obj.IntMes.ToString() + ",";
            value = value + obj.IntEjercicio.ToString() + ",";
            value = value + obj.IntTipoMovto.ToString();

            return value;
        }
        #endregion

        #region Lista
        public DataTable Lista(Entity_Conciliacion obj)
        {
            return DACConciliacion.Lista(obj);
        }
        #endregion

        #region Busqueda
        public DataTable Busqueda(Entity_Conciliacion obj)
        {
            return DACConciliacion.Busqueda(obj);
        }
        #endregion
    }
}
