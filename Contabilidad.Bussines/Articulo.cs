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
    public class Articulo
    {      

        #region GetList
        public DataTable GetList(Entity_Articulo obj)
        {
            return DACArticulo.GetList(obj);                   
        }
        #endregion       

        #region Fill
        public Entity_Articulo Fill(int IdUser)
        {
            return DACArticulo.Fill(IdUser); 
        }
        #endregion  
     
        public Entity_Articulo PresupuestoReq(Entity_Articulo obj)
        {
            return DACArticulo.PresupuestoReq(obj); 
        }

        public Entity_Articulo PresupuestoOC(Entity_Articulo obj)
        {
            return DACArticulo.PresupuestoOC(obj);
        }

        public Entity_Articulo Sel(Entity_Articulo obj)
        {
            return DACArticulo.Sel(obj);
        }
    }
}