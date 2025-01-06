
using Contabilidad.Entity;
using System.Data;
using Contabilidad.DataAccess;

namespace Contabilidad.Bussines
{
    public class CargarProveedor
    {
        #region CreateTable
        public bool CreateTable(string strTable)
        {
            return DACCargarProveedor.CreateTable(strTable);
        }
        #endregion


        #region ImportExcel
        public void ImportExcel(DataTable dataTable)
        {
            DACCargarProveedor.ImportExcel(dataTable);
        }
        #endregion


        #region Save
        public string Save(Entity_CargarProveedor ent,string strQuery)
        {
            return DACCargarProveedor.Save(ent, strQuery);
        }
        #endregion Save

        #region Del
        public string Del(string tabla)
        {
            return DACCargarProveedor.Del(tabla);
        }
        #endregion Save
    }
}



