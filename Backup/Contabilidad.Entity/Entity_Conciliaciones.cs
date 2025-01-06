/*
'===============================================================================
'  Company: ISD
'  Autor: Ingrid Soto Dimas
'  Date: 2013-06-19
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
    public class Entity_Conciliaciones : EntityBaseClass
    {
        private int _intConciliacion;
        private int _intCuentaBancaria;        
        private int _intEjercicio;
        private int _intMes;
        private int _intPartida;
        private string _datFecha = string.Empty;
        private string _strConcepto = string.Empty;
        private string _strReferencia = string.Empty;
        private int _intTipoMovto;
        private int _intFolio;
        private decimal _dblImporte;
        private string _strPoliza= string.Empty;
        private int _intTipo;
        private int _intAutomatico;
        private int _intDireccion;
        private int _intMesRef;
        private int _intEjercicioRef;

        #region IntConciliacion
        public int IntConciliacion
        {
            get
            {
                return _intConciliacion;
            }
            set
            {
                _intConciliacion = value;
            }
        }
        #endregion

        #region intCuentaBancaria
        public int intCuentaBancaria
        {
            get
            {
                return _intCuentaBancaria;
            }
            set
            {
                _intCuentaBancaria = value;
            }
        }
        #endregion intCuentaBancaria

        #region IntEjercicio
        public int IntEjercicio
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
        #endregion intBanco

        #region IntMes
        public int IntMes
        {
            get
            {
                return _intMes;
            }
            set
            {
                _intMes = value;
            }
        }
        #endregion 

        #region IntPartida

        public int IntPartida
        {
            get
            {
                return _intPartida;
            }
            set
            {
                _intPartida = value;
            }
        }

        #endregion strSucursal

        #region DatFecha
        public string DatFecha
        {
            get
            {
                return _datFecha;
            }
            set
            {
                _datFecha = value;
            }
        }
        #endregion 

        #region StrConcepto
        public string StrConcepto
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
        #endregion 

        #region StrReferencia
        public string StrReferencia
        {
            get
            {
                return _strReferencia;
            }
            set
            {
                _strReferencia = value;
            }
        }
        #endregion 

        #region IntTipoMovto
        public int IntTipoMovto
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
        #endregion 

        #region IntFolio
        public int IntFolio
        {
            get
            {
                return _intFolio;
            }
            set
            {
                _intFolio = value;
            }
        }
        #endregion 

        #region DblImporte
        public decimal DblImporte
        {
            get
            {
                return _dblImporte;
            }
            set
            {
                _dblImporte = value;
            }
        }
        #endregion strTipoPoliza

        #region StrPoliza
        public string StrPoliza
        {
            get
            {
                return _strPoliza;
            }
            set
            {
                _strPoliza = value;
            }
        }
        #endregion 

        #region IntTipo
        public int IntTipo
        {
            get
            {
                return _intTipo;
            }
            set
            {
                _intTipo = value;
            }
        }
        #endregion 

        #region IntAutomatico
        public int IntAutomatico
        {
            get
            {
                return _intAutomatico;
            }
            set
            {
                _intAutomatico = value;
            }
        }
        #endregion 

        #region IntDireccion
        public int IntDireccion
        {
            get
            {
                return _intDireccion;
            }
            set
            {
                _intDireccion = value;
            }
        }
        #endregion      

        #region IntMesRef
        public int IntMesRef
        {
            get
            {
                return _intMesRef;
            }
            set
            {
                _intMesRef = value;
            }
        }
        #endregion 

        #region IntEjercicioRef
        public int IntEjercicioRef
        {
            get
            {
                return _intEjercicioRef;
            }
            set
            {
                _intEjercicioRef = value;
            }
        }
        #endregion 

    }
}
