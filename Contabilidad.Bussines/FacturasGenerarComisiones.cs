using System;
using System.Data;
using System.Collections;
using System.Collections.Specialized;
using Contabilidad.DataAccess;
using Contabilidad.Entity;


namespace Contabilidad.Bussines
{
    public class FacturasGenerarComisiones
    {
        public DataTable GetList(Entity_FacturasGenerarComisiones obj)
        {
            return DACFacturasGenerarComisiones.GetList(obj);
        }

        public bool Save(Entity_FacturasGenerarComisiones obj)
        {
            return DACFacturasGenerarComisiones.Save(obj);
        }

        public DataTable GetAnio()
        {
            return Contabilidad.DataAccess.DACFacturasGenerarComisiones.GetAnio();
        }

        public DataTable GetSemana(int intEjercicio)
        {
            return Contabilidad.DataAccess.DACFacturasGenerarComisiones.GetSemana(intEjercicio);
        }

        public  string GetFecha(int intSemana, int intEjercicio)
        {
            return DACFacturasGenerarComisiones.GetFecha(intSemana, intEjercicio);
        }
    }
}
