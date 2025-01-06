using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;

public enum Event
{
    Save,
    Delete,
    New,
    List,
    Print,
    Email,
    Export

}

public delegate void HandlerEvent(object sender, HandlerArgs args);

public class HandlerArgs
{
    public Event Event;
    public int SelectedIndex;
}
