using System;
using System.Data;
using System.Data.SqlClient;
using System.Collections;
using System.Collections.Specialized;

namespace Contabilidad.Entity
{
    public class Entity_Cuentas : EntityBaseClass
    {

        private string _strClasifEnc = string.Empty;
        private string _strCuenta = string.Empty;
        private string _strNombre = string.Empty;
        private string _strNombreCorto = string.Empty;
        private int _intNivel;
        private int _intCtaRegistro;
        private int _intIndAuxiliar;
        private int _intAcceso;
        private int _intTipoGrupoContable;
        private int _intGrupoContable;
        private int _intTipoGasto;
        private int _intIndBloqueo;
        private int _intEjercicioBloq;
        private int _intMesBloq;
        private int _intIndInterEmpresa;
        private int _intInterEmpresa;
        private string _strAuditAlta = string.Empty;
        private string _strAuditMod = string.Empty;
        private string _tipo_GrupoContable = string.Empty;
        private string _grupoContable = string.Empty;
        private string _strCodigoAgrupador = string.Empty; 

        #region Encapsulate Fields
        public string StrClasifEnc
        {
            get { return _strClasifEnc; }
            set { _strClasifEnc = value; }
        } 

        public string StrCuenta
        {
            get { return _strCuenta; }
            set { _strCuenta = value; }
        }
        
        public string StrNombre
        {
            get { return _strNombre; }
            set { _strNombre = value; }
        }
        
        public string StrNombreCorto
        {
            get { return _strNombreCorto; }
            set { _strNombreCorto = value; }
        }
        
        public int IntNivel
        {
            get { return _intNivel; }
            set { _intNivel = value; }
        }
        
        public int IntCtaRegistro
        {
            get { return _intCtaRegistro; }
            set { _intCtaRegistro = value; }
        }
        
        public int IntIndAuxiliar
        {
            get { return _intIndAuxiliar; }
            set { _intIndAuxiliar = value; }
        }
        
        public int IntAcceso
        {
            get { return _intAcceso; }
            set { _intAcceso = value; }
        }
        
        public int IntTipoGrupoContable
        {
            get { return _intTipoGrupoContable; }
            set { _intTipoGrupoContable = value; }
        }
        
        public int IntGrupoContable
        {
            get { return _intGrupoContable; }
            set { _intGrupoContable = value; }
        }
        
        public int IntTipoGasto
        {
            get { return _intTipoGasto; }
            set { _intTipoGasto = value; }
        }
        
        public int IntIndBloqueo
        {
            get { return _intIndBloqueo; }
            set { _intIndBloqueo = value; }
        }
        
        public int IntEjercicioBloq
        {
            get { return _intEjercicioBloq; }
            set { _intEjercicioBloq = value; }
        } 

        public int IntMesBloq
        {
            get { return _intMesBloq; }
            set { _intMesBloq = value; }
        } 

        public int IntIndInterEmpresa
        {
            get { return _intIndInterEmpresa; }
            set { _intIndInterEmpresa = value; }
        } 

        public int IntInterEmpresa
        {
            get { return _intInterEmpresa; }
            set { _intInterEmpresa = value; }
        } 

        public string StrAuditAlta
        {
            get { return _strAuditAlta; }
            set { _strAuditAlta = value; }
        } 

        public string StrAuditMod
        {
            get { return _strAuditMod; }
            set { _strAuditMod = value; }
        }

        #endregion


        #region Aux Fields
        public string Tipo_GrupoContable
        {
            get { return _tipo_GrupoContable; }
            set { _tipo_GrupoContable = value; }
        }

        public string GrupoContable
        {
            get { return _grupoContable; }
            set { _grupoContable = value; }
        }

        public string StrCodigoAgrupador
        {
            get { return _strCodigoAgrupador; }
            set { _strCodigoAgrupador = value; }
        }
        
        #endregion
    }
}
