using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using Contabilidad.DataAccess;

namespace Contabilidad.Bussines
{
    public class ExcelPruebas
    {
        public string Save(string strNombre, string strApellidoPaterno, string strApellidoMaterno, string strNombreCompleto) 
        {
            return DACExcelPruebas.Save(strNombre, strApellidoPaterno, strApellidoMaterno, strNombreCompleto); 
        }
    }
}
