
using System;
using System.Data;
using System.Data.SqlClient;
using System.Collections;
using System.Collections.Specialized;
using Microsoft.ApplicationBlocks.Data;
using Contabilidad.Entity;

namespace Contabilidad.DataAccess
{
    public class DACRubrosTipos : Base
    {
        #region Fill
        public static Entity_RubrosTipos Fill(Entity_RubrosTipos obj)
        {
            IDataReader drd;
            Entity_RubrosTipos oEntity_Rubros;
            oEntity_Rubros = new Entity_RubrosTipos();

            try
            {
                SqlParameter[] arrPar = new SqlParameter[1];
                arrPar[0] = new SqlParameter("@strTipoRubro", SqlDbType.VarChar);
                arrPar[0].Value = obj.strTipoRubro;

                drd = SqlHelper.ExecuteReader(ConnectionString, CommandType.StoredProcedure, "usp_tbRubrosTipos_Fill", arrPar);
                if (drd.Read())
                {
                    oEntity_Rubros = CreateObject(drd);
                }
                else
                {
                    oEntity_Rubros = null;
                }
            }
            catch (Exception e)
            {
                oEntity_Rubros = null;
            }

            return oEntity_Rubros;
        }
        #endregion

        #region CreateObject
        static Entity_RubrosTipos CreateObject(IDataReader drd)
        {
            Entity_RubrosTipos obj;
            obj = new Entity_RubrosTipos();

            obj.strTipoRubro = (string)drd["strTipoRubro"];
            obj.strNombre = (string)drd["strNombre"];


            return obj;
        }
        #endregion

    }
}
