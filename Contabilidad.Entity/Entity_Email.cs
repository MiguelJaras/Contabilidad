using System;
using System.Collections.Generic;
using System.Text;
using System.Net.Mail;

namespace Contabilidad.Entity
{
    public class Entity_Email
    {
        private MailAddress _strFrom;
        private List<MailAddress> _lstTo;
        private List<MailAddress> _lstBBC;
        private List<MailAddress> _lstCC;
        private string _strSubject;
        private string _strContenido;
        private List<string> _lstAttachmentPath;

        #region constructores
        public Entity_Email()
        {
            _lstTo = new List<MailAddress>();
            _lstBBC = new List<MailAddress>();
            _lstCC = new List<MailAddress>();
            _lstAttachmentPath = new List<string>(); ;
        }
        public Entity_Email(MailAddress strFrom, string strContenido, List<MailAddress> lstTo, string strSubject, List<string> lstAttachmentPath)
        {
            _strFrom = strFrom;
            _strContenido = strContenido;
            _lstTo = lstTo;
            _lstBBC = new List<MailAddress>();
            _lstCC = new List<MailAddress>();
            _strSubject = strSubject;
            _lstAttachmentPath = lstAttachmentPath;

        }
        public Entity_Email(MailAddress strFrom, string strContenido, List<MailAddress> lstTo, List<MailAddress> lstCC, string strSubject, List<string> lstAttachmentPath)
        {
            _strFrom = strFrom;
            _strContenido = strContenido;
            _lstTo = lstTo;
            _lstBBC = new List<MailAddress>();
            _lstCC = lstCC;
            _strSubject = strSubject;
            _lstAttachmentPath = lstAttachmentPath;

        }

        #endregion

        #region propiedades públicas

        public MailAddress strFrom
        {
            get { return _strFrom; }
            set { _strFrom = value; }
        }
        public List<MailAddress> lstTo
        {
            get { return _lstTo; }
            set { _lstTo = value; }
        }
        public List<MailAddress> lstBBC
        {
            get { return _lstBBC; }
            set { _lstBBC = value; }
        }
        public List<MailAddress> lstCC
        {
            get { return _lstCC; }
            set { _lstCC = value; }
        }
        public string strSubject
        {
            get { return _strSubject; }
            set { _strSubject = value; }
        }
        public string strContenido
        {
            get { return _strContenido; }
            set { _strContenido = value; }
        }
        public List<string> lstAttachmentPath
        {
            get { return _lstAttachmentPath; }
            set { _lstAttachmentPath = value; }
        }
        #endregion

    }
}
