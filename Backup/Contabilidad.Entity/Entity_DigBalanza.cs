using System;
using System.Data;
using System.Data.SqlClient;
using System.Collections;
using System.Collections.Specialized;

namespace Contabilidad.Entity
{
    public class Entity_DigBalanza : EntityBaseClass
    {
        private int _intEmpresa;
        private int _intEjercicio;
        private int _intMes;
        private int _intFolio;
        private string _XMLFileName;
        private byte[] _XMLFile;
        private string _strUsuario;
        private string _strMaquina;

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
        #endregion intEmpresa

        #region IntEjercicio
        public int IntEjercicio
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
        #endregion IntEjercicio

        #region IntMes
        public int IntMes
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
        #endregion IntMes

        #region IntFolio
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
        #endregion IntFolio

        #region XMLFileName
        public string XMLFileName
        {
            get
            {
                return _XMLFileName;
            }
            set
            {
                _XMLFileName = value;
            }
        }
        #endregion XMLFileName

        #region XMLFile
        public byte[] XMLFile
        {
            get { return _XMLFile; }
            set { _XMLFile = value; }
        }
        #endregion XMLFile

        #region strUsuario
        public string  strUsuario
        {
            get
            {
                return _strUsuario;
            }
            set
            {
                _strUsuario = value;
            }
        }
        #endregion strUsuario

        #region strMaquina
        public string strMaquina
        {
            get
            {
                return _strMaquina;
            }
            set
            {
                _strMaquina = value;
            }
        }
        #endregion strMaquina
    }
}
