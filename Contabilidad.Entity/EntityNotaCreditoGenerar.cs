using System;
using System.Collections.Generic;
using System.Text;

namespace Contabilidad.Entity
{
    public class EntityNotaCreditoGenerar : EntityBaseClass
    {
        private int _intNotaCredito;
        private int _intEmpresa;
        private int _intProspecto;
        private string _strSerie;
        private string _decFolio;
        private string _datFechaGen;
        private int _intEstatus;
        private string _strSerieFactura;
        private string _decFolioFactura;
        private string _strConcepto;
        private string _strError;
        private string _strUsoCFDI;
        private string _strFormaPago;
        private decimal _decDescuento;
        private string _strMetodopago;
        private decimal _dblImporte;
        private string _strRegimenFiscal;
        private int _intObra;
        private string _strRFC;
        private int _intDocumento;

        public string decFolioFactura
        {
            get
            {
                return _decFolioFactura;
            }
            set
            {
                _decFolioFactura = value;
            }
        }

        public string strSerieFactura
        {
            get
            {
                return _strSerieFactura;
            }
            set
            {
                _strSerieFactura = value;
            }
        }

        public int intDocumento
        {
            get
            {
                return _intDocumento;
            }
            set
            {
                _intDocumento = value;
            }
        }

        public string strRFC
        {
            get
            {
                return _strRFC;
            }
            set
            {
                _strRFC = value;
            }
        }

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

        public int intNotaCredito
        {
            get
            {
                return _intNotaCredito;
            }
            set
            {
                _intNotaCredito = value;
            }
        }

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

        public string decFolio
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

        public string datFechaGen
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

        public string strRegimenFiscal
        {
            get
            {
                return _strRegimenFiscal;
            }
            set
            {
                _strRegimenFiscal = value;
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
