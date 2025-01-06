using System;
using System.Data;
using System.Collections;
using System.Collections.Specialized;
using Contabilidad.DataAccess;
using Contabilidad.Entity;


namespace Contabilidad.Bussines
{
    public class NotaCreditoGenerar
    {
        public bool Save(EntityNotaCreditoGenerar obj)
        {
            return DACNotaCreditoGenerar.Save(obj);
        }

        public DataTable GetList(EntityNotaCreditoGenerar obj)
        {
            return DACNotaCreditoGenerar.GetList(obj);
        }

        public string DocumentosSave(int intEmpresa, int intSucursal, int intProspecto, int intGrupoDocumento, int intTipoDocumento, byte[] _Documento, string strNombreDocumento, string strUsuarioAlta, string strMaquinaAlta)
        {
            return DACNotaCreditoGenerar.DocumentosSave(intEmpresa, intSucursal, intProspecto, intGrupoDocumento, intTipoDocumento, _Documento, strNombreDocumento, strUsuarioAlta, strMaquinaAlta);
        }

        public bool Delete(EntityNotaCreditoGenerar obj)
        {
            return DACNotaCreditoGenerar.Delete(obj);
        }
 
    }
}
