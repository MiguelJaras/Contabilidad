using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;

/// <summary>
/// Summary description for BasePage
/// </summary>
public class BasePage 
{


    public string ClearMsgErr(string strMessage)
    {
        string value = "";
        value = strMessage.Replace("/","").Replace("\n","").Replace("\r","").Replace("\\","");
        return value;
    }

    int _IdMenu = 0;

    public int IdMenu
    {
        get { return _IdMenu; }
        set { _IdMenu = value; }
    }

     



}
