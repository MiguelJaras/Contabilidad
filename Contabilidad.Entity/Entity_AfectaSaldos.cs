using System;
using System.Data;
using System.Data.SqlClient;
using System.Collections;
using System.Collections.Specialized;

namespace Contabilidad.Entity
{
    public class Entity_AfectaSaldos : EntityBaseClass
    {
        private int _intEmpresa;
        private int _intProspecto;
        private string _strCuenta;
        private string _strSubCuenta;
        private string _strSubSubCuenta;
        private int _intMovto;
        private int _intFactura;
        private int _intObra;
        private string _strConcepto;
        private int _intTipoMovto;
        private decimal _dblMonto;
        private string _strUsuario;
        private string _strMaquina;

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

        #region intProspecto
        public int intProspecto
        {
            get
            {
                return _intProspecto;
            }
            set
            {
                _intProspecto = value;
            }
        }
        #endregion intProspecto

        #region strCuenta
        public string strCuenta
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
        #endregion strCuenta

        #region strSubCuenta
        public string strSubCuenta
        {
            get
            {
                return _strSubCuenta;
            }
            set
            {
                _strSubCuenta = value;
            }
        }
        #endregion strSubCuenta

        #region strSubCuenta
        public string strSubSubCuenta
        {
            get
            {
                return _strSubSubCuenta;
            }
            set
            {
                _strSubSubCuenta = value;
            }
        }
        #endregion strSubCuenta

        #region intMovto
        public int intMovto
        {
            get
            {
                return _intMovto;
            }
            set
            {
                _intMovto = value;
            }
        }
        #endregion intMovto

        #region intFactura
        public int intFactura
        {
            get
            {
                return _intFactura;
            }
            set
            {
                _intFactura = value;
            }
        }
        #endregion intFactura

        #region intObra
        public int intObra
        {
            get
            {
                return _intObra;
            }
            set
            {
                _intObra = value;
            }
        }
        #endregion intObra

        #region strConcepto
        public string  strConcepto
        {
            get
            {
                return _strConcepto;
            }
            set
            {
                _strConcepto = value;
            }
        }
        #endregion strConcepto

        #region intTipoMovto
        public int intTipoMovto
        {
            get
            {
                return _intTipoMovto;
            }
            set
            {
                _intTipoMovto = value;
            }
        }
        #endregion intTipoMovto

        #region dblMonto
        public decimal dblMonto
        {
            get
            {
                return _dblMonto;
            }
            set
            {
                _dblMonto = value;
            }
        }
        #endregion dblMonto

        #region strUsuario
        public string  strUsuario
        {
            get
            {
                return _strUsuario;
            }
            set
            {
                _strUsuario = value;
            }
        }
        #endregion strUsuario

        #region strMaquina
        public string strMaquina
        {
            get
            {
                return _strMaquina;
            }
            set
            {
                _strMaquina = value;
            }
        }
        #endregion strMaquina
    }
}
