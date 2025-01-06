using System;
using System.Data;
using System.Collections;
using System.Collections.Specialized;
using Contabilidad.DataAccess;
using Contabilidad.Entity;

namespace Contabilidad.Bussines
{
    public class Prospecto
    {
        #region ProsBitacora
        public DataTable ProsBitacora(int intEmpresa, int intTipoVivienda, string datFechaIni, string size)
        {
            return DACProspecto.ProsBitacora(intEmpresa, intTipoVivienda, datFechaIni, size);
        }
        #endregion   
        
        #region Sel
        public DataTable Sel(Entity_Prospectos obj)
        {
            return DACProspecto.Sel(obj);
        }
        #endregion   

        #region UpdateTerreno
        public string UpdateTerreno(Entity_Prospectos obj)
        {
            return DACProspecto.UpdateTerreno(obj);
        }
        #endregion   

        #region EscList
        public DataTable EscList(Entity_Prospectos obj)
        {
            return DACProspecto.EscList(obj);
        }
        #endregion 
  
        #region EscSave
        public bool  EscSave(Entity_Prospectos obj)
        {
            return DACProspecto.EscSave(obj);
        }
        #endregion  

        #region EscDesaplicar
        public bool EscDesaplicar(Entity_Prospectos obj)
        {
            return DACProspecto.EscDesaplicar(obj);
        }
        #endregion  
    }
}
