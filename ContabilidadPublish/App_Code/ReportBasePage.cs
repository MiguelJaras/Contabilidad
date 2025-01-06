using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;

    public abstract class ReportBasePage : System.Web.UI.Page
    {
        #region Properties

        public Anthem.Panel PnlFilter
        {
            get
            {
                return (Anthem.Panel)this.Master.FindControl("PnlFilter");
            }
        }

        public Anthem.Panel PnlDetails
        {
            get
            {
                return (Anthem.Panel)this.Master.FindControl("PnlDetails");
            }
        }
       
        public String TitleText
        {
            get
            {
                return ((Label)this.Master.FindControl("LblParentMenu")).Text;
            }
            set
            {
                ((Label)this.Master.FindControl("LblParentMenu")).Text = value;
            }
        }

        protected abstract Int16 IdPage { get; }


        #endregion Properties

        #region Methods


        public String FormatToPercent(object Value)
        {
            return Convert.ToDecimal(Value).ToString("P");
        }

        public String FormatToCurrency(object Value)
        {
            return Convert.ToDecimal(Value).ToString("c2");
        }

        public String FormatToHour(object Value)
        {
            return Convert.ToDecimal(Value).ToString("n2");
        }

        public String FormatToDate(object Value)
        {
            return Convert.ToDateTime(Value).ToString("dd/MM/yyyy");
        }

        public String SetEmptyCeroValue(String FormatedValue)
        {
            decimal dValue = 0;
            decimal.TryParse(FormatedValue.TrimStart('$'), out dValue);
            return dValue == 0 ? String.Empty : FormatedValue;
        }

        public virtual void AresPageLoad()
        {
            //Template = (ReportsTemplate)this.Master;
            //Template.Action += new HandlerTemplate02(m_Action);
            //if (!IsPostBack) {
            //    ValidatingSecurity();
            //}
        }

        protected abstract void m_Action(object sender, HandlerTemplate02Args args);

        private void ValidatingSecurity() {
            //if (!PageFrameMenu.IsPageAllowed(IdPage)) {
            //    PageHeader.SignOut();
            //}
        }

        #endregion

    }
