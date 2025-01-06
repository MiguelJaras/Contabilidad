using System;
using System.Data;
using System.Collections;
using System.Collections.Specialized;
using Contabilidad.DataAccess;
using Contabilidad.Entity;

namespace Contabilidad.Bussines
{
    public class PolizasEnc
    {
        #region Save
        public string  Save(Entity_PolizasEnc obj)
        {
            return DACPolizasEnc .Save(obj);
        }
        #endregion   
   
        #region PolInv
        public string PolInv(Entity_PolizasEnc obj)
        {
            return DACPolizasEnc.PolInv(obj);
        }
        #endregion    

        #region PolInvDes
        public string PolInvDes(Entity_PolizasEnc obj)
        {
            return DACPolizasEnc.PolInvDes(obj);
        }
        #endregion 

        #region Fill
        public Entity_PolizasEnc Fill(Entity_PolizasEnc obj)
        {
            return DACPolizasEnc.Fill(obj);
        }
        #endregion 

        #region Delete
        public string Delete(Entity_PolizasEnc obj)
        {
            return DACPolizasEnc.Delete(obj);
        }
        #endregion 

        #region Copiar
        public string Copiar(Entity_PolizasEnc obj)
        {
            return DACPolizasEnc.Copiar(obj);
        }
        #endregion 

        #region Inversa
        public string Inversa(Entity_PolizasEnc obj)
        {
            return DACPolizasEnc.Inversa(obj);
        }
        #endregion 

        #region UpdateCA
        public string UpdateCA(Entity_PolizasEnc obj)
        {
            return DACPolizasEnc.UpdateCA(obj);
        }
        #endregion   

        #region SaveCFDI
        public string SaveCFDI(int intEmpresa, int intEjercicio, string strPoliza, string strCFDI, string strUsuario, string strMaquina)
        {
            return DACPolizasEnc.SaveCFDI(intEmpresa,intEjercicio,strPoliza,strCFDI,strUsuario,strMaquina);
        }
        #endregion   

        #region DelCFDI
        public string DelCFDI(int intEmpresa, int intEjercicio, string strPoliza)
        {
            return DACPolizasEnc.DelCFDI(intEmpresa, intEjercicio, strPoliza);
        }
        #endregion 

        #region ListCFDI
        public DataTable ListCFDI(int intEmpresa, int intEjercicio, string strPoliza)
        {
            return DACPolizasEnc.ListCFDI(intEmpresa, intEjercicio, strPoliza);
        }
        #endregion 
    }
}
