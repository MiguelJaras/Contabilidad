using System;
using System.Collections.Generic;
using System.Text;

namespace Contabilidad.Entity
{
    public class Entity_CuentasRet:EntityBaseClass
    {
        private int _intCuentaRet; 
        private int _intArea; 
        private int _intFamilia; 
        private int _intGrupo;
        private string _strCuentaCargo = string.Empty;
        private string _strCuentaAbono = string.Empty;
        private int _intArticuloIni;
        private int _intArticuloFin;
        private int _intES; 

        #region Encapsulate Fields

        public int IntCuentaRet
        {
            get { return _intCuentaRet; }
            set { _intCuentaRet = value; }
        }

        public int IntArea
        {
            get { return _intArea; }
            set { _intArea = value; }
        }

        public int IntFamilia
        {
            get { return _intFamilia; }
            set { _intFamilia = value; }
        }

        public int IntGrupo
        {
            get { return _intGrupo; }
            set { _intGrupo = value; }
        }

        public string StrCuentaCargo
        {
            get { return _strCuentaCargo; }
            set { _strCuentaCargo = value; }
        }

        public string StrCuentaAbono
        {
            get { return _strCuentaAbono; }
            set { _strCuentaAbono = value; }
        }

        public int IntArticuloIni
        {
            get { return _intArticuloIni; }
            set { _intArticuloIni = value; }
        }

        public int IntArticuloFin
        {
            get { return _intArticuloFin; }
            set { _intArticuloFin = value; }
        }

        public int IntES
        {
            get { return _intES; }
            set { _intES = value; }
        }

        

        #endregion 

        #region Aux

        private string _strNombreArea = string.Empty;
        private string _strNombreArticuloIn = string.Empty;
        private string _strNombreArticuloFin = string.Empty;
        private string _strNombreCuentaAbono = string.Empty;
        private string _strNombreCuentaCargo = string.Empty;


        public string StrNombreArea
        {
            get { return _strNombreArea; }
            set { _strNombreArea = value; }
        }
        
        public string StrNombreArticuloIn
        {
            get { return _strNombreArticuloIn; }
            set { _strNombreArticuloIn = value; }
        }
        
        public string StrNombreArticuloFin
        {
            get { return _strNombreArticuloFin; }
            set { _strNombreArticuloFin = value; }
        }
        
        public string StrNombreCuentaAbono
        {
            get { return _strNombreCuentaAbono; }
            set { _strNombreCuentaAbono = value; }
        } 

        public string StrNombreCuentaCargo
        {
            get { return _strNombreCuentaCargo; }
            set { _strNombreCuentaCargo = value; }
        }
        #endregion

       
    }
}
