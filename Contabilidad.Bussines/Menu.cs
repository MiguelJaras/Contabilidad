using System;
using System.Data;
using System.Collections;
using Contabilidad.DataAccess;
using Contabilidad.Entity;

namespace Contabilidad.Bussines
{
    public class Menu
    {      
        #region BindMenu
        public DataTable BindMenu(int ParentId, int intRol)
        {
            return DACMenu.BindMenu(ParentId, intRol);
        }
        #endregion

        #region BindGrid
        public DataSet BindGrid(string query)
        {
            return DACMenu.BindGrid(query);            
        }
        #endregion
       
    }
}
