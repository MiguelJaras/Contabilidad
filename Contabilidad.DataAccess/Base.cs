using System;
using System.ComponentModel;
using System.Collections;
using System.Diagnostics;
using System.Data;
using System.Xml;
using System.Configuration;
using Microsoft.ApplicationBlocks.Data;
using System.Data.SqlClient;

namespace Contabilidad.DataAccess
{
    public abstract class Base 
    {            
        protected Base()
        {
        }

        public static string ConnectionString
        {
            get
            {
                //return "Data Source=SISTEMAS03;Initial Catalog=VetecMarfil;User ID=sa;password=soto";
                //return "Data Source=192.168.100.10;Initial Catalog=VetecMarfil;User ID=conta;password=conta2014;";
                return "Data Source=192.168.80.5;Initial Catalog=VetecMarfil;User ID=sa;password=M1rf3l;";
                //return "Data Source=RUBEN-PC;Initial Catalog=VetecMarfil;User ID=sa;password=mora";
            }
        }

        public virtual string QueryHelp(int intEmpresa, int intSucursal, string[] parametros, int version)
        {
            string a = "";
            return a;
        }

        public virtual DataSet QueryHelpData(int intEmpresa, int intSucursal, string[] parametros, int version)
        {
            return new DataSet();
        }


        #region ExecuteQuery
        public static DataSet ExecuteQuery(string strQuery)
        { 
            try
            {
                using (DataSet ds = SqlHelper.ExecuteDataset(ConnectionString, CommandType.Text, strQuery))
                {
                    return ds;
                }
            }
            catch (Exception e)
            {
                return null;
            }
        }
        #endregion

        #region ExecuteStored
        public static DataSet ExecuteStored(string strStoredName, SqlParameter[] arrParDet)
        { 
            try
            {
                return SqlHelper.ExecuteDataset(ConnectionString, CommandType.StoredProcedure, strStoredName, arrParDet);
            }
            catch (Exception e)
            {
                return null;
            }  
        }
        #endregion

    }
}
