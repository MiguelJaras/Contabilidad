using System;
using System.Data;
using System.Data.SqlClient;
using System.Collections;
using System.Collections.Specialized;

namespace Contabilidad.Entity
{
    public class Entity_Conciliacion : EntityBaseClass
    {
        public int _intConciliacion;
        public int _intEmpresa;
        public int _intEjercicio;
        public int _intMes;
        public int _intCuentaBancaria;
        public int _intPartida;
        public DateTime  _datFecha;
        public string  _strConcepto;
        public string  _strReferencia;
        public int _intTipoMovto;
        public decimal  _dblImporte;
        public int _intFolio;
        public string  _strPoliza;
        public int _intTipo;
        public int _intAutomatico;
        public string _strUsuarioAlta;
        public DateTime _datFechaAlta;
        public string _strMaquinaAlta;
        public int _intDireccion;
        public int _intMesRef;
        public int _intEjercicioRef;
        public int _intEjercicioBan;
        public int _intMesBan;
        public decimal _dblimporteBanco;
        public int _intPartidaBanco;
        public string _strBuscar;
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

        public int IntCuentaBancaria
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

        public DateTime DatFecha
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

        public Decimal DblImporte
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

        public int  IntFolio
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

        public string  StrPoliza
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

        public int  IntTipo
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

        public string  StrMaquinaAlta
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

        public int IntEjercicioBan
        {
            get
            {
                return _intEjercicioBan;
            }
            set
            {
                _intEjercicioBan = value;
            }
        }
        public int IntMesBan
        {
            get
            {
                return _intMesBan;
            }
            set
            {
                _intMesBan = value;
            }
        }

        public decimal DblimporteBanco
        {
            get
            {
                return _dblimporteBanco;
            }
            set
            {
                _dblimporteBanco = value;
            }
        }

        public int IntPartidaBanco
        {
            get
            {
                return _intPartidaBanco;
            }
            set
            {
                _intPartidaBanco = value;
            }
        }

        public string StrBuscar
        {
            get
            {
                return _strBuscar;
            }
            set
            {
                _strBuscar = value;
            }
        }
    }

}
