using System;
using System.Data;
using System.Collections;
using System.Collections.Specialized;
using Contabilidad.DataAccess;
using Contabilidad.Entity;

namespace Contabilidad.Bussines
{
    public class Area
    {

        #region Fill
        public Entity_Area Fill(Entity_Area obj)
        {
            return DACArea.Fill(obj);
        }
        #endregion  
    }
}
