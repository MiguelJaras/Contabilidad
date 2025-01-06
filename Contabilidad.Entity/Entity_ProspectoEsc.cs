using System;
using System.Collections.Generic;
using System.Text;

namespace Contabilidad.Entity
{
    public class Entity_ProspectoEsc : EntityBaseClass
    {
        private int _intProspecto;
        private string _strProspecto;
        private string _strRFC;
        private string _strPais;
        private string _strEstado;
        private string _strCiudad;
        private int _intPais;
        private int _intEstado;
        private int _intCiudad;

        private string _strColonia;
        private string _strDireccion;
        private string _strCalle;
        private string _strNumero;
        private string _strNumeroExt;
        private int _intCP;
        private string _strTelefono;
        private string _strEmail;
        private string _dblDescuento;
        private string _dblPrecioTerreno;
        private string _dblPrecioEdificacion;
        private string _dblAvaluo;
        private string _strTerreno;

        private decimal _dblBonificacion;
        private decimal _dblImporteRestante;
        private decimal _dblFolioFactura;
        private string _strSerieFactura;
        private bool _bPublicoGeneral;
        private string _strFormaPago;
        private string _strMetodoPago;
        private int _bFideicomiso;
        private decimal _dblImporteFideicomiso;
        private int _bServicioCons;
        private decimal _dblServicioCons;
        private string _Constancia;
        private int _intDocumento;
        private int _intTipoRegimen;
        private int _intRegimenFiscal;

        private string _strNombreCliente;
        private string _strApellidoPaterno;
        private string _strApellidoMaterno;
        private decimal _dblFolioFacturaAenP;
        public string StrNombreCliente
        {
            get
            {
                return _strNombreCliente;
            }
            set
            {
                _strNombreCliente = value;
            }
        }

        public string StrApellidoPaterno
        {
            get
            {
                return _strApellidoPaterno;
            }
            set
            {
                _strApellidoPaterno = value;
            }
        }

        public string StrApellidoMaterno
        {
            get
            {
                return _strApellidoMaterno;
            }
            set
            {
                _strApellidoMaterno = value;
            }
        }

        public string StrNumeroExt
        {
            get
            {
                return _strNumeroExt;
            }
            set
            {
                _strNumeroExt = value;
            }
        }

        public string StrNumero
        {
            get
            {
                return _strNumero;
            }
            set
            {
                _strNumero = value;
            }
        }

        public int IntTipoRegimen
        {
            get
            {
                return _intTipoRegimen;
            }
            set
            {
                _intTipoRegimen = value;
            }
        }

        public int IntRegimenFiscal
        {
            get
            {
                return _intRegimenFiscal;
            }
            set
            {
                _intRegimenFiscal = value;
            }
        }

        public int IntDocumento
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

        public string Constancia
        {
            get
            {
                return _Constancia;
            }
            set
            {
                _Constancia = value;
            }
        }

        public int IntProspecto
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
        public string StrProspecto
        {
            get
            {
                return _strProspecto;
            }
            set
            {
                _strProspecto = value;
            }
        }
        public string StrRFC
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
        public string StrPais
        {
            get
            {
                return _strPais;
            }
            set
            {
                _strPais = value;
            }
        }
        public string StrEstado
        {
            get
            {
                return _strEstado;
            }
            set
            {
                _strEstado = value;
            }
        }
        public string StrCiudad
        {
            get
            {
                return _strCiudad;
            }
            set
            {
                _strCiudad = value;
            }
        }
        public string StrColonia
        {
            get
            {
                return _strColonia;
            }
            set
            {
                _strColonia = value;
            }
        }
        public string StrDireccion
        {
            get
            {
                return _strDireccion;
            }
            set
            {
                _strDireccion = value;
            }
        }
        public string StrCalle
        {
            get
            {
                return _strCalle;
            }
            set
            {
                _strCalle = value;
            }
        }
        public int IntCP
        {
            get
            {
                return _intCP;
            }
            set
            {
                _intCP = value;
            }
        }        
        public int IntPais
        {
            get
            {
                return _intPais;
            }
            set
            {
                _intPais = value;
            }
        }
        public int IntEstado
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
        public int IntCiudad
        {
            get
            {
                return _intCiudad;
            }
            set
            {
                _intCiudad = value;
            }
        }
        public string StrTelefono
        {
            get
            {
                return _strTelefono;
            }
            set
            {
                _strTelefono = value;
            }
        }
        public string StrEmail
        {
            get
            {
                return _strEmail;
            }
            set
            {
                _strEmail = value;
            }
        }
        public string DblDescuento
        {
            get
            {
                return _dblDescuento;
            }
            set
            {
                _dblDescuento = value;
            }
        }
        public string DblPrecioTerreno
        {
            get
            {
                return _dblPrecioTerreno;
            }
            set
            {
                _dblPrecioTerreno = value;
            }
        }
        public string DblPrecioEdificacion
        {
            get
            {
                return _dblPrecioEdificacion;
            }
            set
            {
                _dblPrecioEdificacion = value;
            }
        }
        public string DblAvaluo
        {
            get
            {
                return _dblAvaluo;
            }
            set
            {
                _dblAvaluo = value;
            }
        }
        public string StrTerreno
        {
            get
            {
                return _strTerreno;
            }
            set
            {
                _strTerreno = value;
            }
        }

        public decimal dblBonificacion
        {
            get
            {
                return _dblBonificacion;
            }
            set
            {
                _dblBonificacion = value;
            }
        }

        public decimal dblImporteRestante
        {
            get
            {
                return _dblImporteRestante;
            }
            set
            {
                _dblImporteRestante = value;
            }
        }

        public decimal dblFolioFactura
        {
            get
            {
                return _dblFolioFactura;
            }
            set
            {
                _dblFolioFactura = value;
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

        public bool bPublicoGeneral
        {
            get
            {
                return _bPublicoGeneral;
            }
            set
            {
                _bPublicoGeneral = value;
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

        public string strMetodoPago
        {
            get
            {
                return _strMetodoPago;
            }
            set
            {
                _strMetodoPago = value;
            }
        }

        public int BFideicomiso
        {
            get {
                return _bFideicomiso;
            }
            set
            {
                _bFideicomiso= value;
            }
        }

        public decimal DblImporteFideicomiso
        {
            get
            {
                return _dblImporteFideicomiso;
            }
            set
            {
                _dblImporteFideicomiso = value;
            }
        }

        public int BServicioCons
        {
            get
            {
                return _bServicioCons;
            }
            set
            {
                _bServicioCons = value;
            }
        }

        public decimal DblServicioCons
        {
            get
            {
                return _dblServicioCons;
            }
            set
            {
                _dblServicioCons = value;
            }
        }

        public decimal DblFolioFacturaAenP { get => _dblFolioFacturaAenP; set => _dblFolioFacturaAenP = value; }
    }
}
