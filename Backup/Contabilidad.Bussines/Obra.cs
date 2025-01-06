/*
'===============================================================================
'  Company: RMM
'  Autor: Rub�n Mora Mart�nez
'  Date: 2011-07-29
'  **** Generated by MyGeneration Version # (1.3.0.3) ****
'===============================================================================
*/

using System;
using System.Data;
using System.Collections;
using System.Collections.Specialized;
using Contabilidad.DataAccess;
using Contabilidad.Entity;

namespace Contabilidad.Bussines
{
    public class Obra
    {      
        #region RepFinancieroObra
        public DataTable RepFinancieroObra(int empresa, int intEstado, DateTime datFechaIni, DateTime datFechaFin, string strCCIni, string strCCFin, string strQuitar, string size)
        {
            return DACObra.RepFinancieroObra(empresa, intEstado, datFechaIni, datFechaFin, strCCIni, strCCFin, strQuitar, size);
        }
        #endregion   

        #region RepFinancieroObraQry
        public string RepFinancieroObraQry(int empresa, int intEstado, DateTime datFechaIni, DateTime datFechaFin, string strCCIni, string strCCFin, string strQuitar)
        {
            string value = "VetecMarfilAdmin..qryINCN4070_Sel_Rep_Financieros_Obra ";
            value = value + empresa.ToString() + ",";
            value = value + intEstado.ToString() + ",'";
            value = value + datFechaIni + "','";
            value = value + datFechaFin + "','";
            value = value + strCCIni + "','";
            value = value + strCCFin + "','";
            value = value + strQuitar + "'";

            return value;
        }
        #endregion   

        #region SelStrCv
        public Entity_Obra SelStrCv(Entity_Obra obj)
        {
            return DACObra.SelStrCv(obj);
        }
        #endregion

        #region Sel
        public Entity_Obra Sel(Entity_Obra obj)
        {
            return DACObra.Sel(obj);
        }
        #endregion

        public DataTable SelDt(Entity_Obra obj)
        {
            return DACObra.SelDt(obj);
        }

        #region GetList
        public DataTable GetList(Entity_Obra obj)
        {
            return DACObra.GetList(obj);                   
        }
        #endregion   
    
        #region GetByCode
        public Entity_Obra GetByCode(Entity_Obra obj)
        {
            return DACObra.GetByCode(obj);
        }
        #endregion  

        #region Fill
        public Entity_Obra Fill(Entity_Obra obj)
        {
            return DACObra.Fill(obj); 
        }
        #endregion                     

    }
}