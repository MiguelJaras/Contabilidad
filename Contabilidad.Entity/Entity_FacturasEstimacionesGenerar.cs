using System;
using System.Data;
using System.Data.SqlClient;
using System.Collections;
using System.Collections.Specialized;

namespace Contabilidad.Entity
{
    public class Entity_FacturasEstimacionesGenerar : EntityBaseClass
    {
        private int _intEmpresa;
        private int _intFactura;
        private int _intCliente;
        private string _strSerie;
        private decimal _decFolio;
        private DateTime _datFechaGen;
        private int _intEstatus;
        private int _intAño;
        private int _intSemana;
        private string _strObra;
        private int _intOC;
        private int _intColonia;
        private string _strConcepto;
        private string _strError;
        private string _strUsoCFDI;
        private string _strFormaPago;
        private decimal _decDescuento;
        private string _strMetodopago;
        private decimal _dblImporte;
        private string _strProducto;
        private decimal _decPorcIva;


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

        public int IntFactura
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

        public int IntCliente
        {
            get
            {
                return _intCliente;
            }
            set
            {
                _intCliente = value;
            }
        }
        public string StrSerie
        {
            get
            {
                return _strSerie;
            }
            set
            {
                _strSerie = value;
            }
        }
        public decimal DecFolio
        {
            get
            {
                return _decFolio;
            }
            set
            {
                _decFolio = value;
            }
        }

        public DateTime DatFechaGen
        {
            get
            {
                return _datFechaGen;
            }
            set
            {
                _datFechaGen = value;
            }
        }

        public int IntEstatus
        {
            get
            {
                return _intEstatus;
            }
            set
            {
                _intEstatus = value;
            }
        }

        public int IntAño
        {
            get
            {
                return _intAño;
            }
            set
            {
                _intAño = value;
            }
        }

        public int IntSemana
        {
            get
            {
                return _intSemana;
            }
            set
            {
                _intSemana = value;
            }
        }

        public string StrObra
        {
            get
            {
                return _strObra;
            }
            set
            {
                _strObra = value;
            }
        }

        public int IntOC
        {
            get
            {
                return _intOC;
            }
            set
            {
                _intOC = value;
            }
        }

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

        public string StrError
        {
            get
            {
                return _strError;
            }
            set
            {
                _strError = value;
            }
        }

        public string StrUsoCFDI
        {
            get
            {
                return _strUsoCFDI;
            }
            set
            {
                _strUsoCFDI = value;
            }
        }

        public string StrFormaPago
        {
            get
            {
                return _strFormaPago;
            }
            set
            {
                _strFormaPago = value;
            }
        }

        public decimal DecDescuento
        {
            get
            {
                return _decDescuento;
            }
            set
            {
                _decDescuento = value;
            }
        }

        public string StrMetodopago
        {
            get
            {
                return _strMetodopago;
            }
            set
            {
                _strMetodopago = value;
            }
        }

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
        public string StrProducto
        {
            get
            {
                return _strProducto;
            }
            set
            {
                _strProducto = value;
            }
        }
        
        public decimal DecPorcIva
        {
            get
            {
                return _decPorcIva;
            }
            set
            {
                _decPorcIva = value;
            }
        }
    }
}
