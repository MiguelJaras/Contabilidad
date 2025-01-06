using System;
using System.Collections.Generic;
using System.Text;

namespace Contabilidad.Entity
{
    public class Entity_Parametros
    {
        #region variables privadas

        private int _intParametro;
        private string _strNombre;
        private string _strValor;

        #endregion

        #region propiedades públicas

        public int intParametro
        {
            get { return _intParametro; }
            set { _intParametro = value; }
        }
        public string strNombre
        {
            get { return _strNombre; }
            set { _strNombre = value; }
        }
        public string strValor
        {
            get { return _strValor; }
            set { _strValor = value; }
        }

        #endregion
    }
}
