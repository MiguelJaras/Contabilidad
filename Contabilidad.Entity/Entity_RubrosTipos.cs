using System;
using System.Data;
using System.Data.SqlClient;
using System.Collections;
using System.Collections.Specialized;

namespace Contabilidad.Entity
{
    public class Entity_RubrosTipos : EntityBaseClass
	{


        private string  _strTipoRubro;
        private string _strNombre;


        public string  strTipoRubro
        {
            get
            {
                return _strTipoRubro;
            }
            set
            {
                _strTipoRubro = value;
            }
        }

        public string strNombre
        {
            get
            {
                return _strNombre;
            }
            set
            {
                _strNombre = value;
            }
        }
 
    }
}
