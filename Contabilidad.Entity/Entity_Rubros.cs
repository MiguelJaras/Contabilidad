using System;
using System.Data;
using System.Data.SqlClient;
using System.Collections;
using System.Collections.Specialized;

namespace Contabilidad.Entity
{
    public class Entity_Rubros : EntityBaseClass
	{
        public int _intRubro;
        public string  _strNombre;
        public string  _strNombreCorto;
        public string  _strTipoRubro;
        public int _intIndCambiaSignoSalida;
        public string  _strSignoOperacionArit;
        public string  _strFormula;
        public DateTime  _datFechaAlta;
        public string  _strUsuarioAlta;
        public string  _strMaquinaAlta;
        public DateTime  _datFechaMod;
        public string  _strUsuarioMod;
        public string  _strMaquinaMod;
        public int _intEmpresa;

        public int intRubro
        {
            get
            {
                return _intRubro;
            }
            set
            {
                _intRubro = value;
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

        public string  strNombreCorto
        {
            get
            {
                return _strNombreCorto;
            }
            set
            {
                _strNombreCorto = value;
            }
        }

        public string strTipoRubro
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

        public int intIndCambiaSignoSalida
        {
            get
            {
                return _intIndCambiaSignoSalida;
            }
            set
            {
                _intIndCambiaSignoSalida = value;
            }
        }

        public string strSignoOperacionArit
        {
            get
            {
                return _strSignoOperacionArit;
            }
            set
            {
                _strSignoOperacionArit = value;
            }
        }

        public string strFormula
        {
            get
            {
                return _strFormula;
            }
            set
            {
                _strFormula = value;
            }
        }

        public DateTime  datFechaAlta
        {
            get
            {
                return _datFechaAlta;
            }
            set
            {
                _datFechaAlta = value;
            }
        }

        public string strUsuarioAlta
        {
            get
            {
                return _strUsuarioAlta;
            }
            set
            {
                _strUsuarioAlta = value;
            }
        }

        public string strMaquinaAlta
        {
            get
            {
                return _strMaquinaAlta;
            }
            set
            {
                _strMaquinaAlta = value;
            }
        }

        public DateTime datFechaMod
        {
            get
            {
                return _datFechaMod;
            }
            set
            {
                _datFechaMod = value;
            }
        }

        public string strUsuarioMod
        {
            get
            {
                return _strUsuarioMod;
            }
            set
            {
                _strUsuarioMod = value;
            }
        }

        public string strMaquinaMod
        {
            get
            {
                return _strMaquinaMod;
            }
            set
            {
                _strMaquinaMod = value;
            }
        }

        public int intEmpresa
        {
            get
            {
                return _intEmpresa;
            }
            set
            {
                _intEmpresa = value;
            }
        }
    }
}
