using System;
using System.Data;
using System.Data.SqlClient;
using System.Collections;
using System.Collections.Specialized;

namespace Contabilidad.Entity
{
    public class Entity_Sector : EntityBaseClass
    {
        private int _intEmpresa;
        private int _intSucursal;
        private int _intClave;
        private string _strNombreCorto;
        private int _intNumLote;
        private string _strUsuarioAlta;
        private string _strMaquinaAlta;
        private DateTime _datFechaAlta;
        private string _strUsuarioMod;
        private string _strMaquinaMod;
        private DateTime _datFechaMod;
        private Boolean _bPrecioTecho;

        private int _intSector;
        private int _intColonia;
        private string _strNombre;
        private int _BActivo;

        #region Properties


        #region IntSector
        public int IntSector
        {
            get
            {
                return _intSector;
            }
            set
            {
                _intSector = value;
            }
        }
        #endregion IntSector

        #region IntColonia
        public int IntColonia
        {
            get
            {
                return _intColonia;
            }
            set
            {
                _intColonia = value;
            }
        }
        #endregion IntColonia

        #region StrNombre
        public string StrNombre
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
        #endregion VcRolName

        #region BActivo
        public int BActivo
        {
            get
            {
                return _BActivo;
            }
            set
            {
                _BActivo = value;
            }
        }
        #endregion BActivo

        #endregion

        #region IntEmpresa
        public int IntEmpresa
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
        #endregion IntEmpresa

        #region IntSucursal
        public int IntSucursal
        {
            get
            {
                return _intSucursal;
            }
            set
            {
                _intSucursal = value;
            }
        }
        #endregion IntSucursal

        #region IntClave
        public int IntClave
        {
            get
            {
                return _intClave;
            }
            set
            {
                _intClave = value;
            }
        }
        #endregion IntClave

        #region StrNombreCorto
        public string StrNombreCorto
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
        #endregion StrNombreCorto

        #region IntNumLote
        public int IntNumLote
        {
            get
            {
                return _intNumLote;
            }
            set
            {
                _intNumLote = value;
            }
        }
        #endregion IntNumLote

        #region StrUsuarioAlta
        public string StrUsuarioAlta
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
        #endregion StrUsuarioAlta

        #region StrMaquinaAlta
        public string StrMaquinaAlta
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
        #endregion StrMaquinaAlta

        #region DatFechaAlta
        public DateTime DatFechaAlta
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
        #endregion DatFechaAlta

        #region StrUsuarioMod
        public string StrUsuarioMod
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
        #endregion StrUsuarioMod

        #region StrMaquinaMod
        public string StrMaquinaMod
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
        #endregion StrMaquinaMod

        #region DatFechaMod
        public DateTime DatFechaMod
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
        #endregion DatFechaMod

        #region BPrecioTecho
        public Boolean BPrecioTecho
        {
            get
            {
                return _bPrecioTecho;
            }
            set
            {
                _bPrecioTecho = value;
            }
        }
        #endregion BPrecioTecho
    }
}
