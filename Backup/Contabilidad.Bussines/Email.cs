using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using Contabilidad.Entity;
using System.Net;
using System.Net.Mail;

namespace Contabilidad.Bussines
{
    public class Email
    {
        #region Send
        public bool Send(Entity_Email entEmail)
        {
            bool blnSend = true;
            try
            {
                //Datos servidor
                string strHost = "50.97.68.227";
                int intPort = 587;
                Parametros objParametros = new Parametros();
                DataTable dtHost = objParametros.GetHost();
                if (dtHost.Rows.Count > 0)
                {
                    strHost = dtHost.Rows[0][0].ToString();
                    intPort = int.Parse(dtHost.Rows[0][1].ToString());
                }
                NetworkCredential objNetCred = new NetworkCredential("SEM@marfil.com", "M1rf3l");
                //Datos servidor


                MailMessage objMM = new MailMessage();
                objMM.From = entEmail.strFrom;
                foreach (MailAddress obj in entEmail.lstTo)
                    objMM.To.Add(obj);

                foreach (MailAddress obj in entEmail.lstBBC)
                    objMM.Bcc.Add(obj);

                foreach (MailAddress obj in entEmail.lstCC)
                    objMM.CC.Add(obj);

                objMM.Subject = entEmail.strSubject;
                objMM.Body = entEmail.strContenido;
                objMM.IsBodyHtml = true;

                foreach (string strPath in entEmail.lstAttachmentPath)
                    objMM.Attachments.Add(new Attachment(strPath));

                SmtpClient objSMTP = new SmtpClient();
                objSMTP.Port = intPort;
                objSMTP.DeliveryMethod = SmtpDeliveryMethod.Network;
                objSMTP.Host = strHost;
                objSMTP.UseDefaultCredentials = false;
                objSMTP.Credentials = objNetCred;
                objSMTP.Send(objMM);
                objMM.Attachments.Dispose();
                objMM.Dispose();
                objMM = null;
                objSMTP = null;
            }
            catch (Exception ex) { blnSend = false; }
            return blnSend;
        }
        #endregion
    }
}
