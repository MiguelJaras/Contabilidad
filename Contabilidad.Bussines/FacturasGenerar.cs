using System;
using System.Data;
using System.Collections;
using System.Collections.Specialized;
using Contabilidad.DataAccess;
using Contabilidad.Entity;


namespace Contabilidad.Bussines
{
    public class FacturasGenerar
    {
        public bool Save(Entity_FacturasGenerar obj)
        {
            return DACFacturasGenerar.Save(obj);
        }

        public bool SaveMafesa(Entity_FacturasGenerar obj)
        {
            return DACFacturasGenerar.SaveMafesa(obj);
        }

        public DataTable GetList(Entity_FacturasGenerar obj)
        {
            return DACFacturasGenerar.GetList(obj);
        }

        public DataTable GetListMafesa()
        {
            return DACFacturasGenerar.GetListMafesa();
        }

        public string DocumentosSave(int intEmpresa, int intSucursal, int intProspecto, int intGrupoDocumento, int intTipoDocumento, byte[] _Documento, string strNombreDocumento, string strUsuarioAlta, string strMaquinaAlta)
        {
            return DACFacturasGenerar.DocumentosSave(intEmpresa, intSucursal, intProspecto, intGrupoDocumento, intTipoDocumento, _Documento, strNombreDocumento, strUsuarioAlta, strMaquinaAlta);
        }

        public bool Delete(Entity_FacturasGenerar obj)
        {
            return DACFacturasGenerar.Delete(obj);
        }

        public bool DeleteMafesa(Entity_FacturasGenerar obj)
        {
            return DACFacturasGenerar.DeleteMafesa(obj);
        }
 
    }
}
