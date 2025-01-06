using System;
using System.Collections.Generic;
using System.Text;

namespace Contabilidad.Entity
{
    public class Entity_EstructuraPolizaDet:EntityBaseClass
    {
        private int _intClave;
        private int _intPartida;
        private string _strCuenta = string.Empty;
        private string _strSubCuentat = string.Empty;
        private string _strSubSubCuenta = string.Empty;
        private bool _bitCargo;
        private bool _bitAux;
        private bool _bitCC;
        private string _strConcepto = string.Empty;
        private string _strComentario = string.Empty;
        private bool _bitModif;
        private string _strBase = string.Empty;
        private decimal _dblPtaje;

        #region Encapsulate Fields
        public int IntClave
        {
            get { return _intClave; }
            set { _intClave = value; }
        }
        
        public int IntPartida
        {
            get { return _intPartida; }
            set { _intPartida = value; }
        }
        
        public string StrCuenta
        {
            get { return _strCuenta; }
            set { _strCuenta = value; }
        }
        
        public string StrSubCuentat
        {
            get { return _strSubCuentat; }
            set { _strSubCuentat = value; }
        }
        
        public string StrSubSubCuenta
        {
            get { return _strSubSubCuenta; }
            set { _strSubSubCuenta = value; }
        }
        
        public bool BitCargo
        {
            get { return _bitCargo; }
            set { _bitCargo = value; }
        }
        
        public bool BitAux
        {
            get { return _bitAux; }
            set { _bitAux = value; }
        }
        
        public bool BitCC
        {
            get { return _bitCC; }
            set { _bitCC = value; }
        }
        
        public string StrConcepto
        {
            get { return _strConcepto; }
            set { _strConcepto = value; }
        }
        
        public string StrComentario
        {
            get { return _strComentario; }
            set { _strComentario = value; }
        }
        
        public bool BitModif
        {
            get { return _bitModif; }
            set { _bitModif = value; }
        }
        
        public string StrBase
        {
            get { return _strBase; }
            set { _strBase = value; }
        } 

        public decimal DblPtaje
        {
            get { return _dblPtaje; }
            set { _dblPtaje = value; }
        }

        #endregion
    }
}
