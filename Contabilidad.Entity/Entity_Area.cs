using System;
using System.Data;
using System.Data.SqlClient;
using System.Collections;
using System.Collections.Specialized;

namespace Contabilidad.Entity
{
    public class Entity_Area : EntityBaseClass
    {
        private int _intEmpresa;
        private int _intSucursal;
        private int _intArea;
        private string _strNombre;
        private string _strNombreCorto;
        private string _strUsuarioAlta;
        private string _strMaquinaAlta;
        private DateTime  _datFechaAlta;
        private string _strUsuarioMod;
        private int _strMaquinaMod;
        private DateTime _datFechaMod;

        #region intEmpresa
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
        #endregion intEmpresa

        #region intSucursal
        public int intSucursal
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
        #endregion intProspecto

        #region intArea
        public int intArea
        {
            get
            {
                return _intArea;
            }
            set
            {
                _intArea = value;
            }
        }
        #endregion intArea

        #region strNombre
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
        #endregion strNombre

        #region strNombreCorto
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
        #endregion strNombreCorto

        #region strUsuarioAlta
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
        #endregion strUsuarioAlta

        #region strMaquinaAlta
        public string  strMaquinaAlta
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
        #endregion strMaquinaAlta
    }
}
