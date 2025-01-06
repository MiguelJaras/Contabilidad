using System;
using System.Collections.Generic;
using System.Text;

namespace Contabilidad.Entity
{
    public class Entity_FacturasGenerarComisiones : EntityBaseClass
    {
        private int _intFactura;
        private int _intEmpresa;
        private int _intEjercicio;
        private int _intSemana;
        private int _intColonia;
        private int _intSector;
        private string _strSerie;
        private decimal _decFolio;
        private DateTime _datFechaGen;
        private int _intEstatus;
        private DateTime _datFechaAlta;
        private string _strUsuarioAlta;
        private string _strMaquinaAlta;
        private string _strConcepto;
        private string _strError;
        private string _strUsoCFDI;
        private string _strFormaPago;
        private decimal _decDescuento;
        private string _strMetodopago;
        private decimal _dblImporte;
        private string _strProducto;
        private int _bPublicoGeneral;
        private int _intObra;

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

        public int intSemana
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

        public int intSector
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

        public string strSerie
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

        public decimal decFolio
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

        public DateTime datFechaGen
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

        public int intEstatus
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


        public string strConcepto
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

        public string strError
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

        public string strUsoCFDI
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

        public string strFormaPago
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

        public decimal decDescuento
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

        public string strMetodopago
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

        public decimal dblImporte
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

        public string strProducto
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


    }
}
