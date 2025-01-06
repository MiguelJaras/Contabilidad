/*
'===============================================================================
'  Company: IASD
'  Autor: Ingrid Alexis Soto Dimas
'  Date: 2013-09-09
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
    public class Entity_CerrarPeriodo : EntityBaseClass
	{
        private int _intEmpresa;
        private int _intEjercicio;
        private int _intMes;
        private int _intModulo;
        private bool _bCerrado;

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

        public int intEjercicio
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

        public int intMes
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

        public int intModulo
        {
            get
            {
                return _intModulo;
            }
            set
            {
                _intModulo = value;
            }
        }

        public bool bCerrado
        {
            get
            {
                return _bCerrado;
            }
            set
            {
                _bCerrado = value;
            }
        }
    }
}
