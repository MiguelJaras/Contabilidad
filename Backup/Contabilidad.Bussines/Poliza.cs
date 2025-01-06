using System;
using System.Data;
using System.Collections;
using System.Collections.Specialized;
using Contabilidad.DataAccess;
using Contabilidad.Entity;

namespace Contabilidad.Bussines
{
    public class Poliza
    {

        #region GetList
        public DataTable GetList(int intEmpresa, int intEjercicio, string strPoliza)
        {
            return DACPoliza.GetList(intEmpresa, intEjercicio, strPoliza);
        }
        #endregion      

        #region Fill
        public Entity_Poliza Fill(int intEmpresa, int intEjercicio, string strPoliza)
        {
            return DACPoliza.Fill(intEmpresa, intEjercicio, strPoliza);
        }
        #endregion

        #region Close
        public string Close(Entity_Poliza obj)
        {
            return DACPoliza.Close(obj);
        }
        #endregion

        #region GetListAfecta
        public DataTable GetListAfecta(Entity_Poliza obj)
        {
            return DACPoliza.GetListAfecta(obj);
        }
        #endregion  

        #region ValAfecta
        public string ValAfecta()
        {
            return DACPoliza.ValAfecta();
        }
        #endregion 
   
        #region Afecta
        public string Afecta(Entity_Poliza obj)
        {
            return DACPoliza.Afecta(obj);
        }
        #endregion 

        #region Auxiliar
        public DataTable Auxiliar(int intEmpresa, int aux)
        {
            return DACPoliza.Auxiliar(intEmpresa,aux);
        }
        #endregion 

        #region DesaAfectarTodo
        public string DesaAfectarTodo(Entity_Poliza obj)
        {
            return DACPoliza.DesaAfectarTodo(obj);
        }
        #endregion 

        #region SaldosIniciales
        public string SaldosIniciales(Entity_PolizasDet obj)
        {
            return DACPoliza.SaldosIniciales(obj);
        }
        #endregion 

        #region PolizaIva
        public DataTable PolizaIva(Entity_PolizasDet obj)
        {
            return DACPoliza.PolizaIva(obj);
        }
        #endregion
        
        #region SelPolizaIva
        public string SelPolizaIva(int intEmpresa, int intEjercicio, int intMes)
        {
            return DACPoliza.SelPolizaIva(intEmpresa, intEjercicio, intMes);
        }
        #endregion

        #region SavePolizaIva
        public  string SavePolizaIva(Entity_Poliza obj)
        {
            return DACPoliza.SavePolizaIva(obj);
        }
        #endregion

        #region Encabezados
        public string Encabezados(Entity_Poliza obj)
        {
            return DACPoliza.Encabezados(obj);
        }
        #endregion 

        #region ER
        public string ER(Entity_PolizasDet obj)
        {
            return DACPoliza.ER(obj);
        }
        #endregion 

    }
}
