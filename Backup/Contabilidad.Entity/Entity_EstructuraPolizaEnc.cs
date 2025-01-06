using System;
using System.Collections.Generic;
using System.Text;

namespace Contabilidad.Entity
{
    public class Entity_EstructuraPolizaEnc:EntityBaseClass
    { 
        private int _intClave;
        private string _strDescrcipcion = string.Empty;
        private string _strTipoPoliza;
        private int _intModulo;
        private string _strDescripciónPoliza = string.Empty;
        private bool bitAutomatica;
        private string _strUsuarioAlta = string.Empty;
        private string _strMaquinaAlta = string.Empty;
        private DateTime _datFechaAlta;
        private string _strUsuarioMod = string.Empty;
        private string _strMaquinaMod = string.Empty;
        private DateTime _datFechaMod;
        private int _intMovto;
        private int _intGrupoCredito;  

        #region Encapsulate Fields
        public int IntClave
        {
          get { return _intClave; }
          set { _intClave = value; }
        }     

        public string StrDescrcipcion
        {
          get { return _strDescrcipcion; }
          set { _strDescrcipcion = value; }
        }        

        public string StrTipoPoliza
        {
          get { return _strTipoPoliza; }
          set { _strTipoPoliza = value; }
        } 

        public int IntModulo
        {
            get { return _intModulo; }
            set { _intModulo = value; }
        }
               
        public string StrDescripciónPoliza
        {
          get { return _strDescripciónPoliza; }
          set { _strDescripciónPoliza = value; }
        }
               
        public bool BitAutomatica
        {
          get { return bitAutomatica; }
          set { bitAutomatica = value; }
        }
                
        public string StrUsuarioAlta
        {
          get { return _strUsuarioAlta; }
          set { _strUsuarioAlta = value; }
        }
                
        public string StrMaquinaAlta
        {
          get { return _strMaquinaAlta; }
          set { _strMaquinaAlta = value; }
        }
                
        public DateTime DatFechaAlta
        {
          get { return _datFechaAlta; }
          set { _datFechaAlta = value; }
        }
                
        public string StrUsuarioMod
        {
          get { return _strUsuarioMod; }
          set { _strUsuarioMod = value; }
        }
                
        public string StrMaquinaMod
        {
          get { return _strMaquinaMod; }
          set { _strMaquinaMod = value; }
        }     

        public DateTime DatFechaMod
        {
          get { return _datFechaMod; }
          set { _datFechaMod = value; }
        }      

        public int IntMovto
        {
          get { return _intMovto; }
          set { _intMovto = value; }
        } 

        public int IntGrupoCredito
        {
          get { return _intGrupoCredito; }
          set { _intGrupoCredito = value; }
        }
        #endregion


        #region Aux Fields

        private string _strNombrePoliza = string.Empty;
        private string _strNombreTipoMovto = string.Empty;

        public string StrNombrePoliza
        {
            get { return _strNombrePoliza; }
            set { _strNombrePoliza = value; }
        } 

        public string StrNombreTipoMovto
        {
            get { return _strNombreTipoMovto; }
            set { _strNombreTipoMovto = value; }
        } 

        #endregion

    }
}
