using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Collections.Specialized;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using Contabilidad.DataAccess;
using Contabilidad.Entity;

public partial class PagePortal : MasterPage
{

    public event HandlerTemplate02 Action;

    public Status CurrentStatus
    {
        get { return (Status)ViewState["CurrentStatus"]; }
        set { ViewState["CurrentStatus"] = value; }
    }

    public Template02Action CurrentAction { get; set; }

//    public Template02Action CurrentAction { get; set; }
    

    public void SetNewSort(string sortExpression, SortDirection sortDirection)
    {
        //ctrlPagger1.SetNewSort(sortExpression, sortDirection);
    }

    public IOrderedDictionary Keys
    {
        get
        {
            if (ViewState["keys"] == null) return null;
            return (IOrderedDictionary)ViewState["keys"];
        }
        set
        {
            ViewState["keys"] = value;
        }
    }

    private string vcPrincipalTitle
    {
        get
        {
            if (Session["vcPrincipalTitle"] == null)
            {
                Session["vcPrincipalTitle"] = string.Empty;
            }

            if (Session["vcPrincipalTitle"].ToString() == string.Empty)
            {
                //SetLabelGeneral();
            }

            return Session["vcPrincipalTitle"].ToString();
        }
        set
        {
            Session["vcPrincipalTitle"] = value;
        }
    }

    private string vcMenuApp
    {
        get
        {
            if (Session["vcMenuApp"] == null)
            {
                Session["vcMenuApp"] = string.Empty;
            }

            if (Session["vcMenuApp"].ToString() == string.Empty)
            {
            }

            return Session["vcMenuApp"].ToString();
        }
        set
        {
            Session["vcMenuApp"] = value;
        }
    }

    private string vcMenuSelect
    {
        get
        {
            if (Session["vcMenuSelect"] == null)
            {
                Session["vcMenuSelect"] = string.Empty;
            }

            if (Session["vcMenuSelect"].ToString() == string.Empty)
            {
            }

            return Session["vcMenuSelect"].ToString();
        }
        set
        {
            Session["vcMenuSelect"] = value;
        }
    }

    public string idMenuQry;

   

    protected void Page_Load(object sender, EventArgs e)
    {
        //ctrlPagger1.ChangingPageIndex += new ControlctrlPagger.HandlerChangingPageIndex(ChangingPageIndex);
        //ctrlPagger1.ChangingRowCount += new ControlctrlPagger.HandlerChangingRowCount(ChangingRowCount);
        if (!IsPostBack)
        {
            Contabilidad.Bussines.Menu menu = new Contabilidad.Bussines.Menu();
            ctrlMenu1.DataSource = menu.BindMenu(0, 0);
            ctrlMenu1.CreateMenu(); 
        }
    }


    void ChangingPageIndex(object o, ControlctrlPagger.ArgsChangingPageIndex e)
    {
        ////ctrlPagger1.PageIndex = e.NewPageIndex;
        //HandlerTemplate02Args args = new HandlerTemplate02Args(); ;
        //args.Action = Template02Action.Pagger;

        //if (Action != null)
            //Action(ctrlPagger1, args);
    }

    void ChangingRowCount(object o, ControlctrlPagger.ArgsChangingRowCount e)
    {
        //ctrlPagger1.PageIndex = 0;
        //HandlerTemplate02Args args = new HandlerTemplate02Args(); ;
        //args.Action = Template02Action.Pagger;

        //if (Action != null)
        //    Action(ctrlPagger1, args);
    }

    protected void LinkButton3_Click(object sender, EventArgs e)
    {
        FormsAuthentication.SignOut();
        Session["vcMenuApp"] = string.Empty;
        Response.Redirect("~/login/LogOut.aspx", true);
    }       


   

  
    public enum Status
    {
        None,
        Search,
        Add,
        Delete,
        Modify
    }

    #region Show
   
    public void ShowDetail(Boolean value)
    {
             
    }
    public void ShowFilter(Boolean value)
    {
        //ContentPlaceHolder2.Visible = value;
        //pnlDetail.Visible = value;
        //pnlDetail.UpdateAfterCallBack = true;
    }
    public void ShowList(Boolean value)
    {
        //ctrlPagger1.Visible = value;
        //pnlPagger.Visible = value;
        //pnlGrid.Visible = value;
        //pnlGrid.UpdateAfterCallBack = true;
        //pnlPagger.CssClass = "Label";
        //pnlPagger.UpdateAfterCallBack = true;
        //ContentPlaceHolder3.Visible = value;
    }
   

    #endregion

    //#region Pagger
    //public int PageSize
    //{
    //    get { return ctrlPagger1.PageSize; }
    //    set { ctrlPagger1.PageSize = value; }
    //}

    //public int PageIndex
    //{
    //    get { return ctrlPagger1.PageIndex; }
    //    set { ctrlPagger1.PageIndex = value; }
    //}

    //public SortDirection SortDirection
    //{
    //    get { return ctrlPagger1.SortDirection; }
    //    set { ctrlPagger1.SortDirection = value; }
    //}

    //public string SortExpression
    //{
    //    get { return ctrlPagger1.SortExpression; }
    //    set { ctrlPagger1.SortExpression = value; }
    //}

    //public int TotalRecords
    //{
    //    get { return ctrlPagger1.TotalRecords; }
    //    set { ctrlPagger1.TotalRecords = value; }
    //}
    //public int FromRecord
    //{
    //    get { return ctrlPagger1.FromRecord; }
    //    set { ctrlPagger1.FromRecord = value; }
    //}
    //public int ToRecord
    //{
    //    get { return ctrlPagger1.ToRecord; }
    //    set { ctrlPagger1.ToRecord = value; }
    //}
    //public int TotalPages
    //{
    //    get { return ctrlPagger1.TotalPages; }
    //    set { ctrlPagger1.TotalPages = value; }
    //}
    //public void ShowButtons()
    //{
    //    ctrlPagger1.ShowButtons();
    //}
    //#endregion

   
}


