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
using System.Collections.Specialized;
using Contabilidad.DataAccess;
using Contabilidad.Entity;

namespace Contabilidad.Bussines
{
    public class DigBalanza
    {      

        #region Fill
        public DataTable Fill(Entity_DigBalanza obj)
        {
            return DACDigBalanza.Fill(obj); 
        }
        #endregion  
     
        public string Save(Entity_DigBalanza obj)
        {
            return DACDigBalanza.Save(obj); 
        }       
    }
}
