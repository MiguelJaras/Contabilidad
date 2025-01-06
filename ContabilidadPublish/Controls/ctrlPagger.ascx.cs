using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;


public partial class ControlctrlPagger : System.Web.UI.UserControl
{
    public delegate void HandlerChangingPageIndex(object o, ArgsChangingPageIndex e);
    public delegate void HandlerChangingRowCount(object o, ArgsChangingRowCount e);
    public event HandlerChangingPageIndex ChangingPageIndex;
    public event HandlerChangingRowCount ChangingRowCount;

    protected void Page_Load(object sender, EventArgs e)
    {
        ddlRecordCount.Items.Insert(0, new ListItem("100", "100"));
        ddlRecordCount.Items.Insert(1, new ListItem("200", "200"));
        ddlRecordCount.Items.Insert(2, new ListItem("500", "500"));
        ddlRecordCount.Items.Insert(3, new ListItem("1000", "1000"));
        ddlRecordCount.Items.Insert(4, new ListItem("-Todos-", "10000"));
        ddlRecordCount.SelectedIndex = 0;
        ddlRecordCount.Visible = true;
        TextRecordCount.Visible = true;
    }

    public ListItemCollection Items
    {
        get
        {
            return ddlRecordCount.Items;
        }
    }

    public enum TypeButton
    {
        Next,
        Previous,
        First,
        Last,
        GoTo
    }

    public class ArgsChangingPageIndex : EventArgs
    {
        TypeButton _type;
        int _newPageIndex;

        public int NewPageIndex
        {
            get { return _newPageIndex; }
            set { _newPageIndex = value; }
        }

        public ArgsChangingPageIndex()
        {

        }

        public ArgsChangingPageIndex(TypeButton type)
        {
            this.Type = type;
        }

        public TypeButton Type
        {
            get { return _type; }
            set { _type = value; }
        }
    }

    public class ArgsChangingRowCount : EventArgs
    {

        int _newRowCount;

        public int NewRowCount
        {
            get { return _newRowCount; }
            set { _newRowCount = value; }
        }

        public ArgsChangingRowCount()
        {

        }

        public ArgsChangingRowCount(int newRowCount)
        {
            this.NewRowCount = newRowCount;
        }


    }

    public int FromRecord
    {
        get { if (string.IsNullOrEmpty(lblFromRecord.Text)) return 0; return Convert.ToInt32(lblFromRecord.Text); }
        set { lblFromRecord.Text = value.ToString(); lblFromRecord.UpdateAfterCallBack = true; }
    }
    public int ToRecord
    {
        get { if (string.IsNullOrEmpty(lblToRecord.Text)) return 0; return Convert.ToInt32(lblToRecord.Text); }
        set { lblToRecord.Text = value.ToString(); lblToRecord.UpdateAfterCallBack = true; }
    }
    public int TotalRecords
    {
        get { if (string.IsNullOrEmpty(lblTotalRecords.Text)) return 0; return Convert.ToInt32(lblTotalRecords.Text); }
        set { lblTotalRecords.Text = value.ToString(); lblTotalRecords.UpdateAfterCallBack = true; }
    }


    public int PageIndex
    {
        get
        {
            if (ViewState["PageIndex"] == null)
            {
                lblPageIndex.Text = "1";
                return 0;
            }
            return (int)ViewState["PageIndex"];
        }
        set
        {
            lblPageIndex.Text = (value + 1).ToString();
            ViewState["PageIndex"] = value;
        }
    }
    public int TotalPages
    {
        get { if (string.IsNullOrEmpty(lblTotalPages.Text)) return 0; return Convert.ToInt32(lblTotalPages.Text); }
        set { lblTotalPages.Text = value.ToString(); }
    }
    public int PageSize
    {
        get { return ddlRecordCount.SelectedValue == "" ? 100 : Convert.ToInt32(ddlRecordCount.SelectedValue); }
        set { ddlRecordCount.SelectedValue = value.ToString(); }
    }

    public string SortExpression
    {
        get { if (ViewState["SortExpression"] == null) return ""; return ViewState["SortExpression"].ToString(); }
        set { ViewState["SortExpression"] = value; }
    }
    public SortDirection SortDirection
    {
        get { if (ViewState["SortDirection"] == null) return SortDirection.Ascending; return (SortDirection)ViewState["SortDirection"]; }
        set { ViewState["SortDirection"] = value; }
    }

    public void ShowButtons()
    {
        bool ShowPrevious;
        bool ShowNext;
        ShowPrevious = (TotalPages > 0 && PageIndex > 0 && PageIndex <= TotalPages - 1);
        ShowNext = (TotalPages > 0 && PageIndex >= 0 && PageIndex < TotalPages - 1);

        btnPrevious.Visible = ShowPrevious;
        btnFirst.Visible = ShowPrevious;
        btnLast.Visible = ShowNext;
        btnNext.Visible = ShowNext;
        txtGoTo.Visible = ShowPrevious || ShowNext;
        btnGotTo.Visible = ShowPrevious || ShowNext;


        if (ddlRecordCount.Items == null || ddlRecordCount.Items.Count == 0)
        {
            ddlRecordCount.Visible = false;
            TextRecordCount.Visible = false;
        }
        else
        {
            if (TotalRecords <= Convert.ToInt32(ddlRecordCount.Items[0].Value))
            {
                ddlRecordCount.Visible = false;
                TextRecordCount.Visible = false;
            }
            else
            {
                ddlRecordCount.Visible = true;
                TextRecordCount.Visible = true;
            }
        }

        ddlRecordCount.UpdateAfterCallBack = true;
        TextRecordCount.UpdateAfterCallBack = true;
        btnPrevious.UpdateAfterCallBack = true;
        btnFirst.UpdateAfterCallBack = true;
        btnLast.UpdateAfterCallBack = true;
        btnNext.UpdateAfterCallBack = true;
        txtGoTo.UpdateAfterCallBack = true;
        btnGotTo.UpdateAfterCallBack = true;

        TextCurrentPage.UpdateAfterCallBack = true;
        lblPageIndex.UpdateAfterCallBack = true;
        TextTotalPages.UpdateAfterCallBack = true;
        lblTotalPages.UpdateAfterCallBack = true;

        this.Visible = (TotalPages > 0);
    }
    public void SetNewSort(string sortExpression, SortDirection sortDirection)
    {
        if (this.SortExpression == sortExpression)
        {
            if (this.SortDirection == SortDirection.Ascending)
                this.SortDirection = SortDirection.Descending;
            else
                this.SortDirection = SortDirection.Ascending;
        }
        else
        {
            this.SortDirection = SortDirection.Ascending;
        }
        this.SortExpression = sortExpression;
    }

    protected void Image_Click(object sender, EventArgs args)
    {
        Button btn = (Button)sender;


        switch (btn.CommandArgument)
        {
            case "first":
                OnChangingPageIndex(sender, new ArgsChangingPageIndex(TypeButton.First));
                break;
            case "previous":
                OnChangingPageIndex(sender, new ArgsChangingPageIndex(TypeButton.Previous));
                break;
            case "goto":
                OnChangingPageIndex(sender, new ArgsChangingPageIndex(TypeButton.GoTo));
                break;
            case "next":
                OnChangingPageIndex(sender, new ArgsChangingPageIndex(TypeButton.Next));
                break;
            case "last":
                OnChangingPageIndex(sender, new ArgsChangingPageIndex(TypeButton.Last));
                break;
        }

    }

    protected void ddlRowSelectedIndexChanged(object sender, EventArgs e)
    {
        int newRowCount;
        newRowCount = Convert.ToInt32(ddlRecordCount.SelectedValue);
        OnChangingRowCount(sender, new ArgsChangingRowCount(newRowCount));
    }

    protected void txtGoTo_TextChanged(object sender, EventArgs e)
    {
        if (!string.IsNullOrEmpty(this.txtGoTo.Text))
        {
            txtGoTo.Focus();
            OnChangingPageIndex(sender, new ArgsChangingPageIndex(TypeButton.GoTo));

        }
    }

    public void OnChangingPageIndex(object sender, ArgsChangingPageIndex e)
    {
        switch (e.Type)
        {
            case TypeButton.First:
                e.NewPageIndex = 0;
                txtGoTo.Text = "";
                break;
            case TypeButton.Last:
                e.NewPageIndex = this.TotalPages - 1;
                txtGoTo.Text = "";
                break;
            case TypeButton.Next:
                e.NewPageIndex = this.PageIndex + 1;
                txtGoTo.Text = "";
                break;
            case TypeButton.Previous:
                e.NewPageIndex = this.PageIndex - 1;
                txtGoTo.Text = "";
                break;
            case TypeButton.GoTo:
                int pageIndex = 0;
                if (!int.TryParse(this.txtGoTo.Text, out pageIndex))
                {
                    pageIndex = this.PageIndex + 1;
                    txtGoTo.Text = pageIndex.ToString();
                }
                if (pageIndex > this.TotalPages - 1) txtGoTo.Text = this.TotalPages.ToString();
                if (pageIndex < 0) txtGoTo.Text = "1";

                e.NewPageIndex = pageIndex - 1;
                break;
        }

        if (e.NewPageIndex > this.TotalPages - 1) e.NewPageIndex = this.TotalPages - 1;
        if (e.NewPageIndex < 0) e.NewPageIndex = 0;

        if (ChangingPageIndex != null)
            ChangingPageIndex(sender, e);
    }

    public void OnChangingRowCount(object sender, ArgsChangingRowCount e)
    {
        if (ChangingRowCount != null)
        {
            txtGoTo.Text = "";
            ChangingRowCount(sender, e);
        }
    }

    protected void Image_Click(object sender, ImageClickEventArgs e)
    {
        ImageButton btn = (ImageButton)sender;

        switch (btn.CommandArgument)
        {
            case "first":
                OnChangingPageIndex(sender, new ArgsChangingPageIndex(TypeButton.First));
                break;
            case "previous":
                OnChangingPageIndex(sender, new ArgsChangingPageIndex(TypeButton.Previous));
                break;
            case "goto":
                OnChangingPageIndex(sender, new ArgsChangingPageIndex(TypeButton.GoTo));
                break;
            case "next":
                OnChangingPageIndex(sender, new ArgsChangingPageIndex(TypeButton.Next));
                break;
            case "last":
                OnChangingPageIndex(sender, new ArgsChangingPageIndex(TypeButton.Last));
                break;
        }
    }








}
