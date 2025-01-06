/*
'===============================================================================
'  Company: RMM
'  Autor: Rubén Mora Martínez
'  Date: 2011-07-29
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
    public class Entity_Factura : EntityBaseClass
    {
        private int _lngConsecutivo;
        private int _intProveedor;
        private string _strFactura;
        private int _intEstatus;
        private string _datFechaFac;
        private string _datFechaRecepcion;
        private string _datFechaVence;
        private string _strFolio;
        private int _intDepto;
        private string _strNombreProv;
        private string _datFechaProv;
        private int _intPolEjercicio;
        private string _strPolProv;
        private string _strPolClasifEnc;
        private int _intCondicionPago;
        private int _intTipoMoneda;
        private decimal _dblTipoCambio;
        private decimal _dblSubTotal;
        private decimal _dblPtajeIVA;
        private decimal _dblRetencion;
        private decimal _dblRet2;
        private decimal _dblRet3;
        private decimal _dblRet4;
        private decimal _dblMontoIVA;
        private decimal _dblTotal;
        private decimal _dblImporteTipoMoneda;
        private decimal _dblMontoSaldado;
        private string _datFechaSaldo;
        private string _strObservaciones;
        private int _intProrrateada;
        private int _intProvHosp;
        private int _intProvMega;
        private string _strConcepto;
        private string _strArchivo;
        private int _intUnidadMedidaVenta;
        private string _datFechaFactoraje;
        private string _strUsuarioPrograma;
        private int _intCuentaBancaria;
        private int _intMovto;
        private string _strClasifDS;
        private int _intContraRecibo;
        private string _strCCProv;
        private byte[] _FilePDF;
        private string _FilePDFName;
        private byte[] _FileXML;
        private string _strOCR;
        private int _intEnviado;

        public int LngConsecutivo
        {
            get
            {
                return _lngConsecutivo;
            }
            set
            {
                _lngConsecutivo = value;
            }
        }

        public int IntProveedor
        {
            get
            {
                return _intProveedor;
            }
            set
            {
                _intProveedor = value;
            }
        }

        public string StrFactura
        {
            get
            {
                return _strFactura;
            }
            set
            {
                _strFactura = value;
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

        public string DatFechaFac
        {
            get
            {
                return _datFechaFac;
            }
            set
            {
                _datFechaFac = value;
            }
        }

        public string DatFechaRecepcion
        {
            get
            {
                return _datFechaRecepcion;
            }
            set
            {
                _datFechaRecepcion = value;
            }
        }

        public string DatFechaVence
        {
            get
            {
                return _datFechaVence;
            }
            set
            {
                _datFechaVence = value;
            }
        }

        public string StrFolio
        {
            get
            {
                return _strFolio;
            }
            set
            {
                _strFolio = value;
            }
        }

        public int IntDepto
        {
            get
            {
                return _intDepto;
            }
            set
            {
                _intDepto = value;
            }
        }

        public string StrNombreProv
        {
            get
            {
                return _strNombreProv;
            }
            set
            {
                _strNombreProv = value;
            }
        }

        public string DatFechaProv
        {
            get
            {
                return _datFechaProv;
            }
            set
            {
                _datFechaProv = value;
            }
        }

        public int IntPolEjercicio
        {
            get
            {
                return _intPolEjercicio;
            }
            set
            {
                _intPolEjercicio = value;
            }
        }

        public string StrPolProv
        {
            get
            {
                return _strPolProv;
            }
            set
            {
                _strPolProv = value;
            }
        }

        public string StrPolClasifEnc
        {
            get
            {
                return _strPolClasifEnc;
            }
            set
            {
                _strPolClasifEnc = value;
            }
        }

        public int IntCondicionPago
        {
            get
            {
                return _intCondicionPago;
            }
            set
            {
                _intCondicionPago = value;
            }
        }

        public int IntTipoMoneda
        {
            get
            {
                return _intTipoMoneda;
            }
            set
            {
                _intTipoMoneda = value;
            }
        }

        public decimal DblTipoCambio
        {
            get
            {
                return _dblTipoCambio;
            }
            set
            {
                _dblTipoCambio = value;
            }
        }

        public decimal DblSubTotal
        {
            get
            {
                return _dblSubTotal;
            }
            set
            {
                _dblSubTotal = value;
            }
        }

        public decimal DblPtajeIVA
        {
            get
            {
                return _dblPtajeIVA;
            }
            set
            {
                _dblPtajeIVA = value;
            }
        }

        public decimal DblRetencion
        {
            get
            {
                return _dblRetencion;
            }
            set
            {
                _dblRetencion = value;
            }
        }

        public decimal DblRet2
        {
            get
            {
                return _dblRet2;
            }
            set
            {
                _dblRet2 = value;
            }
        }

        public decimal DblRet3
        {
            get
            {
                return _dblRet3;
            }
            set
            {
                _dblRet3 = value;
            }
        }

        public decimal DblRet4
        {
            get
            {
                return _dblRet4;
            }
            set
            {
                _dblRet4 = value;
            }
        }

        public decimal DblMontoIVA
        {
            get
            {
                return _dblMontoIVA;
            }
            set
            {
                _dblMontoIVA = value;
            }
        }

        public decimal DblTotal
        {
            get
            {
                return _dblTotal;
            }
            set
            {
                _dblTotal = value;
            }
        }

        public decimal DblImporteTipoMoneda
        {
            get
            {
                return _dblImporteTipoMoneda;
            }
            set
            {
                _dblImporteTipoMoneda = value;
            }
        }

        public decimal DblMontoSaldado
        {
            get
            {
                return _dblMontoSaldado;
            }
            set
            {
                _dblMontoSaldado = value;
            }
        }

        public string DatFechaSaldo
        {
            get
            {
                return _datFechaSaldo;
            }
            set
            {
                _datFechaSaldo = value;
            }
        }

        public string StrObservaciones
        {
            get
            {
                return _strObservaciones;
            }
            set
            {
                _strObservaciones = value;
            }
        }

        public int IntProrrateada
        {
            get
            {
                return _intProrrateada;
            }
            set
            {
                _intProrrateada = value;
            }
        }

        public int IntProvHosp
        {
            get
            {
                return _intProvHosp;
            }
            set
            {
                _intProvHosp = value;
            }
        }

        public int IntProvMega
        {
            get
            {
                return _intProvMega;
            }
            set
            {
                _intProvMega = value;
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

        public string StrArchivo
        {
            get
            {
                return _strArchivo;
            }
            set
            {
                _strArchivo = value;
            }
        }

        public int IntUnidadMedidaVenta
        {
            get
            {
                return _intUnidadMedidaVenta;
            }
            set
            {
                _intUnidadMedidaVenta = value;
            }
        }

        public string DatFechaFactoraje
        {
            get
            {
                return _datFechaFactoraje;
            }
            set
            {
                _datFechaFactoraje = value;
            }
        }

        public string StrUsuarioPrograma
        {
            get
            {
                return _strUsuarioPrograma;
            }
            set
            {
                _strUsuarioPrograma = value;
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

        public int IntMovto
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

        public string StrClasifDS
        {
            get
            {
                return _strClasifDS;
            }
            set
            {
                _strClasifDS = value;
            }
        }

        public int IntContraRecibo
        {
            get
            {
                return _intContraRecibo;
            }
            set
            {
                _intContraRecibo = value;
            }
        }

        public string StrCCProv
        {
            get
            {
                return _strCCProv;
            }
            set
            {
                _strCCProv = value;
            }
        }

        public byte[] FilePDF
        {
            get
            {
                return _FilePDF;
            }
            set
            {
                _FilePDF = value;
            }
        }

        public string FilePDFName
        {
            get
            {
                return _FilePDFName;
            }
            set
            {
                _FilePDFName = value;
            }
        }

        public byte[] FileXML
        {
            get
            {
                return _FileXML;
            }
            set
            {
                _FileXML = value;
            }
        }

        public string StrOCR
        {
            get
            {
                return _strOCR;
            }
            set
            {
                _strOCR = value;
            }
        }

        public int IntEnviado
        {
            get
            {
                return _intEnviado;
            }
            set
            {
                _intEnviado = value;
            }
        }
        
        

    }
}