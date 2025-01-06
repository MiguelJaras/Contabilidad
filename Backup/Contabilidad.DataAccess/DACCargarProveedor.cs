using System;
using System.Data;
using System.Data.SqlClient;
using System.Collections;
using System.Collections.Specialized;
using Microsoft.ApplicationBlocks.Data;
using Contabilidad.Entity;
using System.Collections.Generic;

namespace Contabilidad.DataAccess
{
    public class DACCargarProveedor : Base
	{
 
        public static void ImportExcel(DataTable dataTable)
        {
            try
            {
                List<string> lstColumns = new List<string>();
                List<string> lstValues = new List<string>();
                foreach (DataColumn column in dataTable.Columns)
                {
                    lstColumns.Add("[" + column.ColumnName + "]");

                    string declare = "@" + column.ColumnName;
                    lstValues.Add(declare);
                }

                string columns = string.Join(",", lstColumns.ToArray());
                string values = string.Join(",", lstValues.ToArray());

                String sqlCommandInsert = string.Format("INSERT INTO dbo." + dataTable.TableName + "({0}) VALUES ({1})", columns, values);
                string ConnectionString2 = "Data Source=192.168.100.10;Initial Catalog=dbMarfil;User ID=vetec;password=vetec;";

                SqlConnection con = new SqlConnection(ConnectionString2);
                SqlCommand cmd = new SqlCommand(sqlCommandInsert, con);

                if (dataTable.Rows.Count > 0)
                {
                    con.Open();
                    foreach (DataRow row in dataTable.Rows)
                    {
                        cmd.Parameters.Clear();
                        foreach (string param in lstValues)
                        {
                            cmd.Parameters.AddWithValue(param, row[lstValues.IndexOf(param)]);
                        }
                        int inserted = cmd.ExecuteNonQuery();
                    }
                }

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }


        #region CreateTable
        public static bool CreateTable(string strTable)
        {
            bool bCreate = false;
            try
            {

                string ConnectionString2 = "Data Source=192.168.100.10;Initial Catalog=dbMarfil;User ID=vetec;password=vetec;";

                string strQuery = strTable;
                SqlHelper.ExecuteNonQuery(ConnectionString2, CommandType.Text, strQuery).ToString();
                bCreate = true;
            }
            catch (Exception ex)
            {

            }
            return bCreate;
        }
        #endregion CreateTable

        #region Save
        public static string Save(Entity_CargarProveedor obj, string strQuery)
        {
            string result = "";
            SqlParameter[] arrPar = new SqlParameter[18];

            arrPar[0] = new SqlParameter("@C1", SqlDbType.VarChar);
            arrPar[0].Value = obj.strC1;

            arrPar[1] = new SqlParameter("@C2", SqlDbType.VarChar);
            arrPar[1].Value = obj.strC2;

            arrPar[2] = new SqlParameter("@C3", SqlDbType.VarChar);
            arrPar[2].Value = obj.strC3;

            arrPar[3] = new SqlParameter("@C4", SqlDbType.VarChar);
            arrPar[3].Value = obj.strC4;

            arrPar[4] = new SqlParameter("@C5", SqlDbType.VarChar);
            arrPar[4].Value = obj.strC5;

            arrPar[5] = new SqlParameter("@C6", SqlDbType.VarChar);
            arrPar[5].Value = obj.strC6;

            arrPar[6] = new SqlParameter("@C7", SqlDbType.VarChar);
            arrPar[6].Value = obj.strC7;

            arrPar[7] = new SqlParameter("@C8", SqlDbType.VarChar);
            arrPar[7].Value = obj.strC8;

            arrPar[8] = new SqlParameter("@C9", SqlDbType.VarChar);
            arrPar[8].Value = obj.strC9;

            arrPar[9] = new SqlParameter("@C10", SqlDbType.VarChar);
            arrPar[9].Value = obj.strC10;

            arrPar[10] = new SqlParameter("@C11", SqlDbType.VarChar);
            arrPar[10].Value = obj.strC11;

            arrPar[11] = new SqlParameter("@C12", SqlDbType.VarChar);
            arrPar[11].Value = obj.strC12;

            arrPar[12] = new SqlParameter("@C13", SqlDbType.VarChar);
            arrPar[12].Value = obj.strC13;

            arrPar[13] = new SqlParameter("@C14", SqlDbType.VarChar);
            arrPar[13].Value = obj.strC14;

            arrPar[14] = new SqlParameter("@C15", SqlDbType.VarChar);
            arrPar[14].Value = obj.strC15;

            arrPar[15] = new SqlParameter("@C16", SqlDbType.VarChar);
            arrPar[15].Value = obj.strC16;

            arrPar[16] = new SqlParameter("@C17", SqlDbType.VarChar);
            arrPar[16].Value = obj.strC17;

            arrPar[17] = new SqlParameter("@C18", SqlDbType.VarChar);
            arrPar[17].Value = obj.strC18;



            //   string ConnectionString2 = "Data Source=192.168.100.10;Initial Catalog=dbMarfil;User ID=vetec;password=vetec;";

            try
            {

                SqlHelper.ExecuteScalar(ConnectionString, CommandType.StoredProcedure, "dbMarfil.." + strQuery, arrPar);
                result = "1";
            }
            catch (Exception e)
            {
                throw e;
            }

            return result;
        }

        #endregion

        #region Del
        public static string Del(string tabla)
        {
            string result = "";
            SqlParameter[] arrPar = new SqlParameter[1];

            arrPar[0] = new SqlParameter("@tabla", SqlDbType.VarChar);
            arrPar[0].Value = tabla;

            try
            {

                SqlHelper.ExecuteScalar(ConnectionString, CommandType.StoredProcedure, "dbMarfil..usp_File_Del", arrPar);
                result = "1";
            }
            catch (Exception e)
            {
                throw e;
            }

            return result;
        }

        #endregion


    }
}
