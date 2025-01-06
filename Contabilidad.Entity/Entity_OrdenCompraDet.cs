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
    public class Entity_OrdenCompraDet : EntityBaseClass
	{
        private int _intOrdenCompraEnc;
        private int _intOrdenCompraDet;
        private int _intPartida;
        private int _intArticulo;
        private string _strDescripcion;
        private double _dblCantidad;
        private double _dblPrecio;
        private double _dblPrecioPermitido;
        private double _dblTotal;
        private string _datFechaEntrega;
        private string _strComentario;
        private int _intEstatus;       
        private double _dblRecibido;
        private string _strNombreCorto;
        private string _strNombreArticulo;
        private string _strUnidadMedida;

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

        public int IntOrdenCompraDet
        {
            get
            {
                return _intOrdenCompraDet;
            }
            set
            {
                _intOrdenCompraDet = value;
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

        public int IntArticulo
        {
            get
            {
                return _intArticulo;
            }
            set
            {
                _intArticulo = value;
            }
        }

        public string StrDescripcion
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

        public double DblCantidad
        {
            get
            {
                return _dblCantidad;
            }
            set
            {
                _dblCantidad = value;
            }
        }

        public double DblPrecio
        {
            get
            {
                return _dblPrecio;
            }
            set
            {
                _dblPrecio = value;
            }
        }

        public double DblPrecioPermitido
        {
            get
            {
                return _dblPrecioPermitido;
            }
            set
            {
                _dblPrecioPermitido = value;
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

        public string StrComentario
        {
            get
            {
                return _strComentario;
            }
            set
            {
                _strComentario = value;
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

        public double DblRecibido
        {
            get
            {
                return _dblRecibido;
            }
            set
            {
                _dblRecibido = value;
            }
        }

        public string StrNombreCorto
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

        public string StrNombreArticulo
        {
            get
            {
                return _strNombreArticulo;
            }
            set
            {
                _strNombreArticulo = value;
            }
        }

        public string StrUnidadMedida
        {
            get
            {
                return _strUnidadMedida;
            }
            set
            {
                _strUnidadMedida = value;
            }
        }
      
	}
}
