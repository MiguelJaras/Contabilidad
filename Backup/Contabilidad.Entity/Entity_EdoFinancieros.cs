using System;
using System.Data;
using System.Data.SqlClient;
using System.Collections;
using System.Collections.Specialized;

namespace Contabilidad.Entity
{
    public class Entity_EdoFinancieros : EntityBaseClass
	{
        private int _intEstadoFin;
        private string  _strNombre;
        private string _strNombreCorto;
        private DateTime  _datFechaAlta;
        private string _strUsuarioAlta;
        private string _strMaquinaAlta;
        private DateTime  _datFechaMod;
        private string _strUsuarioMod;
        private string _strMaquinaMod;

        #region Properties

        #region intEstadoFin
        public int intEstadoFin
        {
            get
            {
                return _intEstadoFin;
            }
            set
            {
                _intEstadoFin = value;
            }
        }
        #endregion 

        #region strNombre
        public string strNombre
        {
            get
            {
                return _strNombre;
            }
            set
            {
                _strNombre = value;
            }
        }
        #endregion 

        #region strNombreCorto
        public string strNombreCorto
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
        #endregion 

        #region datFechaAlta
        public DateTime  datFechaAlta
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
        #endregion 

        #region strUsuarioAlta
        public string strUsuarioAlta
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
        #endregion 

        #region strMaquinaAlta
        public string strMaquinaAlta
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
        #endregion 

        #region datFechaMod
        public DateTime datFechaMod
        {
            get
            {
                return _datFechaMod;
            }
            set
            {
                _datFechaMod = value;
            }
        }
        #endregion 

        #region strUsuarioMod
        public string strUsuarioMod
        {
            get
            {
                return _strUsuarioMod;
            }
            set
            {
                _strUsuarioMod = value;
            }
        }
        #endregion 

        #region strMaquinaMod
        public string strMaquinaMod
        {
            get
            {
                return _strMaquinaMod;
            }
            set
            {
                _strMaquinaMod = value;
            }
        }
        #endregion 

        #endregion
    }
}
