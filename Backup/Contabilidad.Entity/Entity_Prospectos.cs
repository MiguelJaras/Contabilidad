using System;
using System.Collections.Generic;
using System.Text;

namespace Contabilidad.Entity
{
    public class Entity_Prospectos : EntityBaseClass
    {
        private int _intEmpresa;
        private int _intSucursal;
        private int _intProspecto;
        private string _strNombreCliente;
        private string _strApellidoPaterno;
        private string _strApellidoMaterno;
        private int _intColonia;
        private DateTime _datFechaVisita;


        #region intEmpresa
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
        #endregion 

        #region intSucursal
        public int intSucursal
        {
            get
            {
                return _intSucursal;
            }
            set
            {
                _intSucursal = value;
            }
        }
        #endregion 

        #region intProspecto
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
        #endregion 

        #region strNombreCliente
        public string strNombreCliente
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
        #endregion 

        #region strApellidoPaterno
        public string strApellidoPaterno
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
        #endregion 

        #region strApellidoMaterno
        public string strApellidoMaterno
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
        #endregion 

        
        #region intColonia
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
        #endregion 

        

        #region datFechaVisita
        public DateTime datFechaVisita
        {
            get
            {
                return _datFechaVisita;
            }
            set
            {
                _datFechaVisita = value;
            }
        }
        #endregion 
    }
}
