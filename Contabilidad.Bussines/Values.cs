/*
'===============================================================================
'  Company: RMM
'  Autor: Rub�n Mora Mart�nez
'  Date: 2011-07-29
'  **** Generated by MyGeneration Version # (1.3.0.3) ****
'===============================================================================
*/

using System;
using System.Data;
using System.Collections;
using Contabilidad.DataAccess;
using Contabilidad.Entity;

namespace Contabilidad.Bussines
{
    public class Values
    {

        #region Ejercicio
        public string Ejercicio(int intEmpresa, int intSucursal, int intValue)
        {
            return DACValues.Ejercicio(intEmpresa, intSucursal, intValue);
        }
        #endregion
      
    }
}
