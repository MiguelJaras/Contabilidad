/*
'===============================================================================
'  Company: IASD
'  Autor: Ingrid Soto Dimas
'  Date: 2013-09-04
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
    public class Entity_PolizasDet : EntityBaseClass
	{
        public string _strClasifEnc;
        public int _intEjercicio;
        public int _intMes;
        public string _strPoliza;
        public string _strTipoPoliza;
        public int _intFolioPoliza;
        public int _intPartida;
        public DateTime  _datFecha;
        public string _strClasifDP;
        public string _strClasifDS;
        public string _strCuenta;
        public string _strCuentaOrig;
        public int _intTipoMovto;
        public decimal _dblImporte;
        public int _intTipoMoneda;
        public decimal  _dblTipoCambio;
        public decimal  _dblImporteTipoMoneda;
        public string _strReferencia;
        public string _strDescripcion;
        public int _intIndAfectada;
        public string _strFactura;
        public int _intFacConsec;
        public int _intProveedor;
        public int _intTipoConcepto;
        public int _intConcepto;
        public int _intCuentaBancaria;
        public int _intCheque;
        public int _intConciliado;
        public int _intConcilFolio;
        public string _strClaveRef;
        public string _strFolioRef;
        public string _strAuditAlta;
        public string _strAuditMod;
        public int _intTipoAux;
        public int _intConceptoPago;

        public string  strClasifEnc
        {
            get
            {
                return _strClasifEnc;
            }
            set
            {
                _strClasifEnc = value;
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

        public int intMes
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

        public string strPoliza
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

        public string strTipoPoliza
        {
            get
            {
                return _strTipoPoliza;
            }
            set
            {
                _strTipoPoliza = value;
            }
        }

        public int intFolioPoliza
        {
            get
            {
                return _intFolioPoliza;
            }
            set
            {
                _intFolioPoliza = value;
            }
        }

        public int intPartida
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

        public  DateTime datFecha
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

        public string strClasifDP
        {
            get
            {
                return _strClasifDP;
            }
            set
            {
                _strClasifDP = value;
            }
        }

        public string strClasifDS
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

        public string strCuentaOrig
        {
            get
            {
                return _strCuentaOrig;
            }
            set
            {
                _strCuentaOrig = value;
            }
        }

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

        public int intTipoMoneda
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

        public decimal dblTipoCambio
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

        public decimal dblImporteTipoMoneda
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

        public string strReferencia
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

        public string strDescripcion
        {
            get
            {
                return _strDescripcion;
            }
            set
            {
                _strDescripcion = value;
            }
        }

        public int intIndAfectada
        {
            get
            {
                return _intIndAfectada;
            }
            set
            {
                _intIndAfectada = value;
            }
        }

        public string strFactura
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
        public int intFacConsec
        {
            get
            {
                return _intFacConsec;
            }
            set
            {
                _intFacConsec = value;
            }
        }

        public int intProveedor
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

        public int intTipoConcepto
        {
            get
            {
                return _intTipoConcepto;
            }
            set
            {
                _intTipoConcepto = value;
            }
        }

        public int intConcepto
        {
            get
            {
                return _intConcepto;
            }
            set
            {
                _intConcepto = value;
            }
        }

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
        public int intCheque
        {
            get
            {
                return _intCheque;
            }
            set
            {
                _intCheque = value;
            }
        }

        public int intConciliado
        {
            get
            {
                return _intConciliado;
            }
            set
            {
                _intConciliado = value;
            }
        }
        public int intConcilFolio
        {
            get
            {
                return _intConcilFolio;
            }
            set
            {
                _intConcilFolio = value;
            }
        }

        public string strClaveRef
        {
            get
            {
                return _strClaveRef;
            }
            set
            {
                _strClaveRef = value;
            }
        }

        public string strFolioRef
        {
            get
            {
                return _strFolioRef;
            }
            set
            {
                _strFolioRef = value;
            }
        }
        public string strAuditAlta
        {
            get
            {
                return _strAuditAlta;
            }
            set
            {
                _strAuditAlta = value;
            }
        }

        public string strAuditMod
        {
            get
            {
                return _strAuditMod;
            }
            set
            {
                _strAuditMod = value;
            }
        }

        public int intTipoAux
        {
            get
            {
                return _intTipoAux;
            }
            set
            {
                _intTipoAux = value;
            }
        }
        public int intConceptoPago
        {
            get
            {
                return _intConceptoPago;
            }
            set
            {
                _intConceptoPago = value;
            }
        }

    }
}