using System;
using System.Data;
using System.Data.SqlClient;
using System.Collections;
using System.Collections.Specialized;
using Microsoft.ApplicationBlocks.Data;
using Contabilidad.Entity;

namespace Contabilidad.DataAccess
{
    public class DACFacturasEstimacionesGenerar : Base
    {

        public static string SaveEnc(Entity_FacturasEstimacionesGenerar obj)
        {
            string result;

            try
            {
                SqlHelper.ExecuteNonQuery(ConnectionString, CommandType.Text, "EXEC VetecMarfilAdmin..usp_tbFacturasGenerarEstimaciones_Save");
                result = "true";
            }
            catch (Exception e)
            {
                throw e;
            }
            return result;
        }

        public static string Save(Entity_FacturasEstimacionesGenerar obj)
        {
            string result;

            SqlParameter[] arrPar = new SqlParameter[10];
            arrPar[0] = new SqlParameter("@intEmpresa", SqlDbType.Int);
            arrPar[0].Value = obj.IntEmpresa;
            arrPar[1] = new SqlParameter("@intCliente", SqlDbType.Int);
            arrPar[1].Value = obj.IntCliente;
            arrPar[2] = new SqlParameter("@intOC", SqlDbType.Int);
            arrPar[2].Value = obj.IntOC;
            arrPar[3] = new SqlParameter("@strObra", SqlDbType.VarChar);
            arrPar[3].Value = obj.StrObra;
            arrPar[4] = new SqlParameter("@dblImporte", SqlDbType.Decimal);
            arrPar[4].Value = obj.DblImporte;
            arrPar[5] = new SqlParameter("@strUsuarioAlta", SqlDbType.VarChar);
            arrPar[5].Value = obj.StrUsuario;
            arrPar[6] = new SqlParameter("@strMaquinaAlta", SqlDbType.VarChar);
            arrPar[6].Value = obj.StrMaquina;
            arrPar[7] = new SqlParameter("@intSemana", SqlDbType.Int);
            arrPar[7].Value = obj.IntSemana;
            arrPar[8] = new SqlParameter("@intEjercicio", SqlDbType.Int);
            arrPar[8].Value = obj.IntAño;
            arrPar[9] = new SqlParameter("@decPorcIva", SqlDbType.Decimal);
            arrPar[9].Value = obj.DecPorcIva;

            try
            {
                SqlHelper.ExecuteNonQuery(ConnectionString, CommandType.StoredProcedure, "VetecMarfilAdmin..usp_tbFacturasGenerarEstimacionesDetalle_Save", arrPar);
                result = "true";
            }
            catch (Exception e)
            {
                throw e;
            }
            return result;
        }

        public static DataTable List(Entity_FacturasEstimacionesGenerar obj)
        {
            DataSet ds;

            SqlParameter[] arrPar = new SqlParameter[2];
            arrPar[0] = new SqlParameter("@intSemana", SqlDbType.Int);
            arrPar[0].Value = obj.IntSemana;
            arrPar[1] = new SqlParameter("@intEjercicio", SqlDbType.Int);
            arrPar[1].Value = obj.IntAño;


            try
            {
                ds = SqlHelper.ExecuteDataset(ConnectionString, CommandType.StoredProcedure, "VetecMarfilAdmin..usp_tbFacturasGenerarEstimacionesDetalle_List", arrPar);
                return ds.Tables[0];
            }
            catch (Exception e)
            {
                return null;
            }
        }


    }
}
