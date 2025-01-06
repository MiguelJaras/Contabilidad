using System;
using System.Data;
using System.Data.SqlClient;
using System.Collections;
using System.Collections.Specialized;

namespace Contabilidad.Entity
{
    public class Entity_RubrosCuentas : EntityBaseClass
	{
        public int _intRubro;
        public string _strCuenta;
        public int _intIndSumaResta;
        public DateTime _datFechaAlta;
        public string _strUsuarioAlta;
        public string _strMaquinaAlta;
        public DateTime _datFechaMod;
        public string _strUsuarioMod;
        public string _strMaquinaMod;
        public int _intEmpresa;

        #region intRubro
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
        #endregion 

        #region strCuenta
        public string  strCuenta
        {
            get
            {
                return _strCuenta;
            }
            set
            {
                _strCuenta = value;
            }
        }
        #endregion 

        #region intIndSumaResta
        public int intIndSumaResta
        {
            get
            {
                return _intIndSumaResta;
            }
            set
            {
                _intIndSumaResta = value;
            }
        }
        #endregion 

        #region datFechaAlta
        public DateTime datFechaAlta
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
        #endregion 

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
        #endregion 

        #region strMaquinaAlta
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
        #endregion 

        #region datFechaMod
        public DateTime  datFechaMod
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
        #endregion 

        #region strUsuarioMod
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
        #endregion 

        #region strMaquinaMod
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
        #endregion 

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
        #endregion 
    }
}
