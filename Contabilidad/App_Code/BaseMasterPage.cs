using System;
using System.Data;
using System.Configuration;

using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;


/// <summary>
/// Summary description for BaseMasterPage_Template02
/// </summary>
//public class BaseMasterPage_Template02:MasterPage
//{
    

//    public BaseMasterPage_Template02()
//    {
//        //
//        // TODO: Add constructor logic here
//        //
//    }

    
//}
public enum Template02Action
{ 
    Save,
    SaveNew,
    Add,
    Cancel,
    Search, 
    Pagger,
    Modify,
    Delete
    
}

public delegate void HandlerTemplate02(object sender, HandlerTemplate02Args args);

public class HandlerTemplate02Args
{
    public Template02Action Action;
   public  int SelectedIndex;
}
