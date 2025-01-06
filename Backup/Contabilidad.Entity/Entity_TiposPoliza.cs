using System;
using System.Data;
using System.Data.SqlClient;
using System.Collections;
using System.Collections.Specialized;

namespace Contabilidad.Entity
{
    public class Entity_TiposPoliza: EntityBaseClass
    {
        private int _intEmpresa;
        private string _strClasifEnc = string.Empty;
        private string _strTipoPoliza = string.Empty;
        private string _strNombre = string.Empty;
        private string _strNombreCorto = string.Empty;
        private int _intCapturable;
        private int _intEjercicio;

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

        public string strClasifEnc
        {
            get
            {
                return _strClasifEnc;
            }
            set
            {
                _strClasifEnc = value;
            }
        }

        public string strTipoPoliza
        {
            get
            {
                return _strTipoPoliza;
            }
            set
            {
                _strTipoPoliza = value;
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

        public string strNombreCorto
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

        public int intCapturable
        {
            get
            {
                return _intCapturable;
            }
            set
            {
                _intCapturable = value;
            }
        }


        public int intEjercicio
        {
            get
            {
                return _intEjercicio;
            }
            set
            {
                _intEjercicio = value;
            }
        }
    }
}
