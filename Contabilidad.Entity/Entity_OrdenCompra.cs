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
    public class Entity_OrdenCompra : EntityBaseClass
	{
		private string _datFecha;
        private string _datFechaEntrega;
        private string _datFechaRealRecepcion;
        private double _dblPorcentajeIVA;
        private double _dblSubTotal;
        private double _dblTipoCambio;
        private double _dblTotal;
        private int _intCentroCosto;
        private int _intCondicionPago;
        private int _intEstatus;
        private int _intEtiqueta;
        private int _intFolio;
        private int _intLab;
        private int _intMoneda;
        private int _intOrdenCompraEnc;
        private int _intProveedor;
        private int _intTipoEmbarque;
        private int _intTipoOrdenCompra;
        private string _strAtencion;
        private string _strColonia;
        private string _strContacto;
        private string _strDireccion;
        private string _strObservaciones;
        private string _strPais;
        private string _strPoblacion;
        private string _strTelefono;
        private string _strUsuarioAutoriza;
        private string _strUsuarioCompra;
        private string _strUsuarioSolicita;
        private string _strUsuarioVoBo;
        private int _intAlmacen;
        private int _intSubAlmacen;
        private int _intObra;
        private double _dblPorcentajeRetencion;
        private double _dblPorcentajeRetencion2;
        private int _intAutoRecepcionable;
        private string _Estatus;
        private string _Requisicion;

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

        public string DatFechaEntrega
        {
            get
            {
                return _datFechaEntrega;
            }
            set
            {
                _datFechaEntrega = value;
            }
        }

        public string DatFechaRealRecepcion
        {
            get
            {
                return _datFechaRealRecepcion;
            }
            set
            {
                _datFechaRealRecepcion = value;
            }
        }

        public double DblPorcentajeIVA
        {
            get
            {
                return _dblPorcentajeIVA;
            }
            set
            {
                _dblPorcentajeIVA = value;
            }
        }

        public double DblSubTotal
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

        public double DblTipoCambio
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

        public double DblTotal
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

        public int IntCentroCosto
        {
            get
            {
                return _intCentroCosto;
            }
            set
            {
                _intCentroCosto = value;
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

        public int IntEtiqueta
        {
            get
            {
                return _intEtiqueta;
            }
            set
            {
                _intEtiqueta = value;
            }
        }

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

        public int IntLab
        {
            get
            {
                return _intLab;
            }
            set
            {
                _intLab = value;
            }
        }

        public int IntMoneda
        {
            get
            {
                return _intMoneda;
            }
            set
            {
                _intMoneda = value;
            }
        }

        public int IntOrdenCompraEnc
        {
            get
            {
                return _intOrdenCompraEnc;
            }
            set
            {
                _intOrdenCompraEnc = value;
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

        public int IntTipoEmbarque
        {
            get
            {
                return _intTipoEmbarque;
            }
            set
            {
                _intTipoEmbarque = value;
            }
        }

        public int IntTipoOrdenCompra
        {
            get
            {
                return _intTipoOrdenCompra;
            }
            set
            {
                _intTipoOrdenCompra = value;
            }
        }

        public string StrAtencion
        {
            get
            {
                return _strAtencion;
            }
            set
            {
                _strAtencion = value;
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

        public string StrContacto
        {
            get
            {
                return _strContacto;
            }
            set
            {
                _strContacto = value;
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

        public string StrPoblacion
        {
            get
            {
                return _strPoblacion;
            }
            set
            {
                _strPoblacion = value;
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

        public string StrUsuarioAutoriza
        {
            get
            {
                return _strUsuarioAutoriza;
            }
            set
            {
                _strUsuarioAutoriza = value;
            }
        }

        public string StrUsuarioCompra
        {
            get
            {
                return _strUsuarioCompra;
            }
            set
            {
                _strUsuarioCompra = value;
            }
        }

        public string StrUsuarioSolicita
        {
            get
            {
                return _strUsuarioSolicita;
            }
            set
            {
                _strUsuarioSolicita = value;
            }
        }

        public string StrUsuarioVoBo
        {
            get
            {
                return _strUsuarioVoBo;
            }
            set
            {
                _strUsuarioVoBo = value;
            }
        }
        
        public int IntAlmacen
        {
            get
            {
                return _intAlmacen;
            }
            set
            {
                _intAlmacen = value;

            }
        }
        public int IntSubAlmacen
        {
            get
            {
                return _intSubAlmacen;
            }
            set
            {
                _intSubAlmacen = value;
            }
        }

        public int IntObra
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


        public double DblPorcentajeRetencion
        {
            get
            {
                return _dblPorcentajeRetencion;
            }
            set
            {
                _dblPorcentajeRetencion = value;
            }
        }

        public double DblPorcentajeRetencion2
        {
            get
            {
                return _dblPorcentajeRetencion2;
            }
            set
            {
                _dblPorcentajeRetencion2 = value;
            }
        }

        public int IntAutoRecepcionable
        {
            get
            {
                return _intAutoRecepcionable;
            }
            set
            {
                _intAutoRecepcionable = value;
            }
        }

        public string Estatus
        {
            get
            {
                return _Estatus;
            }
            set
            {
                _Estatus = value;
            }
        }

        public string Requisicion
        {
            get
            {
                return _Requisicion;
            }
            set
            {
                _Requisicion = value;
            }
        }

	}
}
