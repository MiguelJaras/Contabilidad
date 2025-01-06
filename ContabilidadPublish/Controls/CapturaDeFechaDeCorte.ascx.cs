using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.ComponentModel;
using System.Drawing;


public partial class ControlCapturaDeFechaDeCorte : System.Web.UI.UserControl
{
    #region Properties

        private const String FormatDate = "dd/MM/yyyy";

        //
        // Summary:
        //     Gets or sets the text content of the System.Web.UI.WebControls.TextBox control.
        //
        // Returns:
        //     The text displayed in the System.Web.UI.WebControls.TextBox control. The
        //     default is an empty string ("").
        [Bindable(true, BindingDirection.TwoWay)]
        [PersistenceMode(PersistenceMode.EncodedInnerDefaultProperty)]
        [Editor("System.ComponentModel.Design.MultilineStringEditor,System.Design, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a", typeof(System.Drawing.Design.UITypeEditor))]
        [Localizable(true)]
        [Themeable(false)]
        [Browsable(true)]
        [DefaultValue("")]
        public DateTime DateValue {
            get {
                if (!String.IsNullOrEmpty(TxtCutDate.Text))
                {
                    String [] AlDate = TxtCutDate.Text.Split('/');                    
                    int Day = Convert.ToInt32(AlDate[0]);
                    int Month = Convert.ToInt32(AlDate[1]);
                    int Year = Convert.ToInt32(AlDate[2]);
                    return new DateTime(Year, Month, Day);
                }
                else {
                    return DateTime.Now;
                }
                
            }
            set {
                TxtCutDate.Text = value.ToString(FormatDate);
            }
        }

        //
        // Summary:
        //     Gets or sets the name of the validation group to which this validation control
        //     belongs.
        //
        // Returns:
        //     The name of the validation group to which this validation control belongs.
        //     The default is an empty string (""), which indicates that this property is
        //     not set.
        [Themeable(false)]
        [Browsable(true)]        
        [DefaultValue("")]        
        public String ValidationGroup
        {
            get
            {
                return TxtCutDate.ValidationGroup;
            }
            set
            {
                TxtCutDate.ValidationGroup = value;
                RfvCutDate.ValidationGroup = value;
                CvCutDate.ValidationGroup = value;
            }
        }

        public String IncludeWitoutHours
        { get { return CbWithoutHours.Checked?"0":"1"; } }


        #endregion Properties

    #region Events

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack) {
                SetDefaultDate();
            }            
        }

        #endregion Events

    #region Methods

        public void SetDefaultDate() {
            TxtCutDate.Text = System.DateTime.Now.Date.ToString(FormatDate);
        }

        

        #endregion Methods
        
}