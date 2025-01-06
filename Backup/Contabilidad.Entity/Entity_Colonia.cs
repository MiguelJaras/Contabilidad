/*
'===============================================================================
'  Company: IASD
'  Autor: Ingrid Alexis Soto Dimas
'  Date: 2013-09-17
'  **** Generated by MyGeneration Version # (1.3.0.3) ****
'===============================================================================
*/

using System;
using System.Data;
using System.Data.SqlClient;
using System.Collections;
using System.Collections.Specialized;

namespace Contabilidad.Entity
{
    public class Entity_Colonia : EntityBaseClass
	{
        private int _intEmpresa;
        private int _intSucursal;
        private int _intColonia;
        private string _strNombre;
        private string _strNombreCorto;
        private decimal _dblFactorMercado;
        private decimal _dblPorcentajeIndirecto;
        private string _strTipo;
        private string _strUsuarioAlta;
        private string _strMaquinaAlta;
        private DateTime _datFechaAlta;
        private string _strUsuarioMod;
        private string _strMaquinaMod;
        private DateTime  _datFechaMod;
        private int _intTipoVivienda;
        private int _intMunicipio;
        private int _intEstado;
        private string _strCP;
        private int _intPuntoTamanio;
        private int _intArea;
        private int _intActivo;
        private int _intEmpleado;
        private string _strAliasSQL;
        private string _strAliasResumenSQL;

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

        public int intColonia
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

        public decimal dblFactorMercado
        {
            get
            {
                return _dblFactorMercado;
            }
            set
            {
                _dblFactorMercado = value;
            }
        }

        public decimal dblPorcentajeIndirecto
        {
            get
            {
                return _dblPorcentajeIndirecto;
            }
            set
            {
                _dblPorcentajeIndirecto = value;
            }
        }

        public string strTipo
        {
            get
            {
                return _strTipo;
            }
            set
            {
                _strTipo = value;
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

        public int intTipoVivienda
        {
            get
            {
                return _intTipoVivienda;
            }
            set
            {
                _intTipoVivienda = value;
            }
        }

        public int intMunicipio
        {
            get
            {
                return _intMunicipio;
            }
            set
            {
                _intMunicipio = value;
            }
        }

        public int intEstado
        {
            get
            {
                return _intEstado;
            }
            set
            {
                _intEstado = value;
            }
        }

        public string  strCP
        {
            get
            {
                return _strCP;
            }
            set
            {
                _strCP = value;
            }
        }

        public int intPuntoTamanio
        {
            get
            {
                return _intPuntoTamanio;
            }
            set
            {
                _intPuntoTamanio = value;
            }
        }

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

        public int intActivo
        {
            get
            {
                return _intActivo;
            }
            set
            {
                _intActivo = value;
            }
        }

        public int intEmpleado
        {
            get
            {
                return _intEmpleado;
            }
            set
            {
                _intEmpleado = value;
            }
        }

        public string strAliasSQL
        {
            get
            {
                return _strAliasSQL;
            }
            set
            {
                _strAliasSQL = value;
            }
        }

        public string strAliasResumenSQL
        {
            get
            {
                return _strAliasResumenSQL;
            }
            set
            {
                _strAliasResumenSQL = value;
            }
        }
    }
}