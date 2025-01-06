using System;
using System.Web;
using System.Data;
using System.Configuration;
using System.Collections;
using System.ComponentModel;
using System.Data.SqlClient;
using System.Web.UI.WebControls;
using Contabilidad.Bussines;

public partial class Controls_ctrlMenu : System.Web.UI.UserControl
{

    #region Properties

    #region Private

    private DataTable _dataSource;
    private String _dataFieldPagina = "strPagina";
    private String _dataFieldIdMenu = "intMenu";
    private String _dataFieldMenuName = "strNombre";
    private String _dataFieldIdMenuParent = "idMenuParent";
    private String _dataFieldHasChildren = "bHasChildren";

    #region Styles

    private String _backGroudStyle;

    #region Level1
    private String _parentCssMouseOverLevel1;
    private String _parentCssMouseOutLevel1;
    private String _childCssMouseOverLevel1;
    private String _childCssMouseOutLevel1;
    private String _childCssMouseClickedLevel1;
    #endregion Level1

    #region Level2
    private String _parentCssMouseOverLevel2;
    private String _parentCssMouseOutLevel2;
    private String _childCssMouseOverLevel2;
    private String _childCssMouseOutLevel2;
    private String _childCssMouseClickedLevel2;
    #endregion Level2

    #region Level3
    private String _childCssMouseOverLevel3;
    private String _childCssMouseOutLevel3;
    private String _childCssMouseClickedLevel3;
    #endregion Level3

    #endregion Styles

    #endregion Private



    #region Public

    #region Data

    [DefaultValue("strPagina")]
    [Description("Gets or sets a value that indicates the data field for .")]
    [Bindable(true)]
    public String DataFieldPagina
    {
        get { return _dataFieldPagina; }
        set
        {
            _dataFieldPagina = value;
        }
    }

    [DefaultValue("intMenu")]
    [Description("Gets or sets a value that indicates the data field for .")]
    [Bindable(true)]
    public String DataFieldIdMenu
    {
        get { return _dataFieldIdMenu; }
        set
        {
            _dataFieldIdMenu = value;
        }
    }

    [DefaultValue("strNombre")]
    [Description("Gets or sets a value that indicates the data field for .")]
    [Bindable(true)]
    public String DataFieldMenuName
    {
        get { return _dataFieldMenuName; }
        set
        {
            _dataFieldMenuName = value;
        }
    }

    [DefaultValue("idMenuParent")]
    [Description("Gets or sets a value that indicates the data field for .")]
    [Bindable(true)]
    public String DataFieldIdMenuParent
    {
        get { return _dataFieldIdMenuParent; }
        set
        {
            _dataFieldIdMenuParent = value;
        }
    }

    [DefaultValue("bHasChildren")]
    [Description("Gets or sets a value that indicates the data field for .")]
    [Bindable(true)]
    public String DataFieldHasChildren
    {
        get { return _dataFieldHasChildren; }
        set
        {
            _dataFieldHasChildren = value;
        }
    }

    #endregion Data

    [Description("Gets or sets a value that indicates the datasource.")]
    [Bindable(true)]
    public DataTable DataSource
    {
        get { return _dataSource; }
        set
        {
            _dataSource = value;
        }
    }

    [DefaultValue("DftBackGroundStyle")]
    [Description("Gets or sets the Cascading Style Sheet (CSS) class rendered by the menu background, on the client.")]
    [Bindable(true)]
    public String BackGroudStyle
    {
        get { return _backGroudStyle; }
        set { _backGroudStyle = value; }
    }

    #region Level1

    [DefaultValue("DftParentCssMouseOverLevel1")]
    [Description("Gets or sets the Cascading Style Sheet (CSS) class to the parent menu option rendered when the mouse is over, on the client.")]
    [Bindable(true)]
    public String ParentCssMouseOverLevel1
    {
        get { return _parentCssMouseOverLevel1; }
        set { _parentCssMouseOverLevel1 = value; }
    }

    [DefaultValue("DftParentCssMouseOverLevel1")]
    [Description("Gets or sets the Cascading Style Sheet (CSS) class to the parent menu option rendered when the mouse is out, on the client.")]
    [Bindable(true)]
    public String ParentCssMouseOutLevel1
    {
        get { return _parentCssMouseOutLevel1; }
        set { _parentCssMouseOutLevel1 = value; }
    }

    [DefaultValue("DftChildCssMouseOverLevel1")]
    [Description("Gets or sets the Cascading Style Sheet (CSS) class to the child menu option rendered when the mouse is over, on the client.")]
    [Bindable(true)]
    public String ChildCssMouseOverLevel1
    {
        get { return _childCssMouseOverLevel1; }
        set { _childCssMouseOverLevel1 = value; }
    }

    [DefaultValue("DftChildCssMouseOutLevel1")]
    [Description("Gets or sets the Cascading Style Sheet (CSS) class to the child menu option rendered when the mouse is out, on the client")]
    [Bindable(true)]
    public String ChildCssMouseOutLevel1
    {
        get { return _childCssMouseOutLevel1; }
        set { _childCssMouseOutLevel1 = value; }
    }

    [DefaultValue("DftChildCssMouseClickedLevel1")]
    [Description("Gets or sets the Cascading Style Sheet (CSS) class to the child menu option rendered when the mouse is out, on the client")]
    [Bindable(true)]
    public String ChildCssMouseClickedLevel1
    {
        get { return _childCssMouseClickedLevel1; }
        set { _childCssMouseClickedLevel1 = value; }
    }


    #endregion Level1

    #region Level2

    [DefaultValue("DftParentCssMouseOverLevel2")]
    [Description("Gets or sets the Cascading Style Sheet (CSS) class to the parent menu option rendered when the mouse is over, on the client.")]
    [Bindable(true)]
    public String ParentCssMouseOverLevel2
    {
        get { return _parentCssMouseOverLevel2; }
        set { _parentCssMouseOverLevel2 = value; }
    }

    [DefaultValue("DftParentCssMouseOverLevel2")]
    [Description("Gets or sets the Cascading Style Sheet (CSS) class to the parent menu option rendered when the mouse is out, on the client.")]
    [Bindable(true)]
    public String ParentCssMouseOutLevel2
    {
        get { return _parentCssMouseOutLevel2; }
        set { _parentCssMouseOutLevel2 = value; }
    }

    [DefaultValue("DftChildCssMouseOverLevel2")]
    [Description("Gets or sets the Cascading Style Sheet (CSS) class to the child menu option rendered when the mouse is over, on the client.")]
    [Bindable(true)]
    public String ChildCssMouseOverLevel2
    {
        get { return _childCssMouseOverLevel2; }
        set { _childCssMouseOverLevel2 = value; }
    }

    [DefaultValue("DftChildCssMouseOutLevel2")]
    [Description("Gets or sets the Cascading Style Sheet (CSS) class to the child menu option rendered when the mouse is out, on the client")]
    [Bindable(true)]
    public String ChildCssMouseOutLevel2
    {
        get { return _childCssMouseOutLevel2; }
        set { _childCssMouseOutLevel2 = value; }
    }

    [DefaultValue("DftChildCssMouseClickedLevel2")]
    [Description("Gets or sets the Cascading Style Sheet (CSS) class to the child menu option rendered when the mouse is out, on the client")]
    [Bindable(true)]
    public String ChildCssMouseClickedLevel2
    {
        get { return _childCssMouseClickedLevel2; }
        set { _childCssMouseClickedLevel2 = value; }
    }

    #endregion Level2

    #region Level3

    [DefaultValue("DftChildCssMouseOverLevel3")]
    [Description("Gets or sets the Cascading Style Sheet (CSS) class to the child menu option rendered when the mouse is over, on the client.")]
    [Bindable(true)]
    public String ChildCssMouseOverLevel3
    {
        get { return _childCssMouseOverLevel3; }
        set { _childCssMouseOverLevel3 = value; }
    }

    [DefaultValue("DftChildCssMouseOutLevel3")]
    [Description("Gets or sets the Cascading Style Sheet (CSS) class to the child menu option rendered when the mouse is out, on the client")]
    [Bindable(true)]
    public String ChildCssMouseOutLevel3
    {
        get { return _childCssMouseOutLevel3; }
        set { _childCssMouseOutLevel3 = value; }
    }

    [DefaultValue("DftChildCssMouseClickedLevel3")]
    [Description("Gets or sets the Cascading Style Sheet (CSS) class to the child menu option rendered when the mouse is out, on the client")]
    [Bindable(true)]
    public String ChildCssMouseClickedLevel3
    {
        get { return _childCssMouseClickedLevel3; }
        set { _childCssMouseClickedLevel3 = value; }
    }

    #endregion Level3

    #endregion Public

    #endregion Properties

    protected void Page_Load(object sender, EventArgs e)
    {
        string a = Request.Params.Get("__EVENTTARGET");
        string argument = Request.Params.Get("__EVENTARGUMENT"); 
        if (a == "lknSave")
            lknSave_Click(argument);
    }


    #region Methods


    public void CreateMenu()
    {
        RptMenuOptions.DataSource = _dataSource.DefaultView;
        RptMenuOptions.DataBind();
    }

    protected DataView GetSubMenuOptions(int idMenuParent)
    {
        DataTable dtMenuOptions = _dataSource;
        dtMenuOptions.DefaultView.RowFilter = this._dataFieldIdMenuParent + "=" + idMenuParent;
        return dtMenuOptions.DefaultView;
    }

    protected Boolean IsParent(DataRowView dvrMenuOption)
    {
        return Convert.ToBoolean(dvrMenuOption[_dataFieldHasChildren]);
    }

    protected string ResolveAction(object ObjMenuOption, int NumLevel)
    {
        DataRowView dvrMenuOption = (DataRowView)ObjMenuOption;
        String PageUrl;
        PageUrl = dvrMenuOption["strPagina"].ToString();

        String idMenu = dvrMenuOption["intMenu"].ToString();
        String TitleName = dvrMenuOption["strNombre"].ToString();
        String Action = "Redirect(&quot;" + base.ResolveUrl(PageUrl) + "&quot;,this," + NumLevel.ToString() + ",&quot;" + TitleName + "&quot;)";
        if (IsParent(dvrMenuOption))
        {
            Action = "DisplayMenuOption(&quot;Table_" + idMenu + "&quot;)";
        }
        //if (dvrMenuOption["Visible"] != null)
        //{
        //    string visible = dvrMenuOption["Visible"].ToString();
        //    string direccion = dvrMenuOption["Direccion"].ToString();
        //    if (visible == "False")
        //        Action = "OpenGrupo(" + direccion + ");";
        //}

        return Action;
    }

    #region Style CssClass Methods

    #region Level1

    protected String Style_CssClass_Level1(object ObjMenuOption)
    {
        DataRowView dvrMenuOption = (DataRowView)ObjMenuOption;
        return IsParent(dvrMenuOption) ? ParentCssMouseOutLevel1 : ChildCssMouseOutLevel1;
    }

    protected String Style_MouseOver_Level1(object ObjMenuOption)
    {
        DataRowView dvrMenuOption = (DataRowView)ObjMenuOption;
        return "this.className=&quot;" + (IsParent(dvrMenuOption) ? ParentCssMouseOverLevel1 : ChildCssMouseOverLevel1) + "&quot;";
    }

    protected String Style_MouseOut_Level1(object ObjMenuOption)
    {
        DataRowView dvrMenuOption = (DataRowView)ObjMenuOption;
        return "this.className=&quot;" +(IsParent(dvrMenuOption) ? ParentCssMouseOutLevel1 : ChildCssMouseOutLevel1) + "&quot;";
    }

    #endregion Level1

    #region Level2

    protected String Style_CssClass_Level2(object ObjMenuOption)
    {
        DataRowView dvrMenuOption = (DataRowView)ObjMenuOption;
        return IsParent(dvrMenuOption) ? ParentCssMouseOutLevel2 : ChildCssMouseOutLevel2;
    }

    protected String Style_MouseOver_Level2(object ObjMenuOption)
    {
        DataRowView dvrMenuOption = (DataRowView)ObjMenuOption;
        return "this.className=&quot;" + (IsParent(dvrMenuOption) ? ParentCssMouseOverLevel2 : ChildCssMouseOverLevel2) + "&quot;";
    }

    protected String Style_MouseOut_Level2(object ObjMenuOption)
    {
        DataRowView dvrMenuOption = (DataRowView)ObjMenuOption;
        return "this.className=&quot;" + (IsParent(dvrMenuOption) ? ParentCssMouseOutLevel2 : ChildCssMouseOutLevel2) + "&quot;";
    }

    #endregion Level2

    #region Level3

    protected String Style_CssClass_Level3(object dvrMenuOption)
    {
        return ChildCssMouseOutLevel3;
    }

    protected String Style_MouseOver_Level3(object dvrMenuOption)
    {
        return "this.className=&quot;" + ChildCssMouseOverLevel3 + "&quot;";
    }

    protected String Style_MouseOut_Level3(object dvrMenuOption)
    {
        return "this.className=&quot;" + ChildCssMouseOutLevel3 + "&quot;";
    }

    #endregion Level3

    #endregion Style CssClass Methods

    #endregion Methods

    #region Events

    protected void Page_Init(object sender, EventArgs e)
    {
        DataFieldPagina = (DataFieldPagina == null ? "vcPagina" : DataFieldPagina);
        DataFieldIdMenu = (DataFieldIdMenu == null ? "idMenu" : DataFieldIdMenu);
        DataFieldMenuName = (DataFieldMenuName == null ? "vcMenu" : DataFieldMenuName);
        DataFieldIdMenuParent = (DataFieldIdMenuParent == null ? "idMenuParent" : DataFieldIdMenuParent);
        DataFieldHasChildren = (DataFieldHasChildren == null ? "bHasChildren" : DataFieldHasChildren);

        BackGroudStyle = (BackGroudStyle == null ? "DftBackGroundStyle" : BackGroudStyle);
        ParentCssMouseOverLevel1 = (ParentCssMouseOverLevel1 == null ? "DftParentCssMouseOverLevel1" : ParentCssMouseOverLevel1);
        ParentCssMouseOutLevel1 = (ParentCssMouseOutLevel1 == null ? "DftParentCssMouseOverLevel1" : ParentCssMouseOutLevel1);
        ChildCssMouseOverLevel1 = (ChildCssMouseOverLevel1 == null ? "DftChildCssMouseOverLevel1" : ChildCssMouseOverLevel1);
        ChildCssMouseOutLevel1 = (ChildCssMouseOutLevel1 == null ? "DftChildCssMouseOutLevel1" : ChildCssMouseOutLevel1);
        ChildCssMouseClickedLevel1 = (ChildCssMouseClickedLevel1 == null ? "DftChildCssMouseClickedLevel1" : ChildCssMouseClickedLevel1);

        ParentCssMouseOverLevel2 = (ParentCssMouseOverLevel2 == null ? "DftParentCssMouseOverLevel2" : ParentCssMouseOverLevel2);
        ParentCssMouseOutLevel2 = (ParentCssMouseOutLevel2 == null ? "DftParentCssMouseOverLevel2" : ParentCssMouseOutLevel2);
        ChildCssMouseOverLevel2 = (ChildCssMouseOverLevel2 == null ? "DftChildCssMouseOverLevel2" : ChildCssMouseOverLevel2);
        ChildCssMouseOutLevel2 = (ChildCssMouseOutLevel2 == null ? "DftChildCssMouseOutLevel2" : ChildCssMouseOutLevel2);
        ChildCssMouseClickedLevel2 = (ChildCssMouseClickedLevel2 == null ? "DftChildCssMouseClickedLevel2" : ChildCssMouseClickedLevel2);

        ChildCssMouseOverLevel3 = (ChildCssMouseOverLevel3 == null ? "DftChildCssMouseOverLevel3" : ChildCssMouseOverLevel3);
        ChildCssMouseOutLevel3 = (ChildCssMouseOutLevel3 == null ? "DftChildCssMouseOutLevel3" : ChildCssMouseOutLevel3);
        ChildCssMouseClickedLevel3 = (ChildCssMouseClickedLevel3 == null ? "DftChildCssMouseClickedLevel3" : ChildCssMouseClickedLevel3);
    }

    #endregion Events

    protected void RptMenuOptions_OnItemDataBound(object sender, RepeaterItemEventArgs e)
    {
        DataRowView data = (DataRowView)e.Item.DataItem;
        Contabilidad.Bussines.Menu menu;
        menu = new Contabilidad.Bussines.Menu();
        if (!(data == null))
        {
            Repeater rpt = (Repeater)e.Item.FindControl("RptSubMenuOptionsLevel1");
            if (!(data == null))
            {
                int parent = Convert.ToInt32(data["intMenu"]);
                rpt.DataSource = menu.BindMenu(parent,0);
                rpt.DataBind();
            }
        }    
    }

    protected void RptMenuOptions2_OnItemDataBound(object sender, RepeaterItemEventArgs e)
    {
        DataRowView data = (DataRowView)e.Item.DataItem;
        Contabilidad.Bussines.Menu menu;
        menu = new Contabilidad.Bussines.Menu();
        if (!(data == null))
        {
            Repeater rpt = (Repeater)e.Item.FindControl("RptSubMenuOptionsLevel2");
            if (!(data == null))
            {
                int parent = Convert.ToInt32(data["intMenu"].ToString());
                rpt.DataSource = menu.BindMenu(parent,0);
                rpt.DataBind();
            }
        }
    }


    protected void RptMenuOptions3_OnItemDataBound(object sender, RepeaterItemEventArgs e)
    {
        DataRowView data = (DataRowView)e.Item.DataItem;
        Contabilidad.Bussines.Menu menu;
        menu = new Contabilidad.Bussines.Menu();
        if (!(data == null))
        {
            Repeater rpt = (Repeater)e.Item.FindControl("RptSubMenuOptionsLevel3");
            if (!(data == null))
            {
                int parent = Convert.ToInt32(data["intMenu"].ToString());
                rpt.DataSource = menu.BindMenu(parent, 0);
                rpt.DataBind();
            }
        }
    }

    protected void RptMenuOptions4_OnItemDataBound(object sender, RepeaterItemEventArgs e)
    {
        DataRowView data = (DataRowView)e.Item.DataItem;
        Contabilidad.Bussines.Menu menu;
        menu = new Contabilidad.Bussines.Menu();
        if (!(data == null))
        {
            Repeater rpt = (Repeater)e.Item.FindControl("RptSubMenuOptionsLevel4");
            if (!(data == null))
            {
                int parent = Convert.ToInt32(data["intMenu"].ToString());
                rpt.DataSource = menu.BindMenu(parent, 0);
                rpt.DataBind();
            }
        }
    }

    


    private void lknSave_Click(string argument)
    {
        for (int i = 0; i < RptMenuOptions.Items.Count; i++)
        {
            HiddenField dataRowView = (HiddenField)RptMenuOptions.Items[i].FindControl("hddDireccion");
            if (dataRowView != null)
            {
                string Direccion = dataRowView.Value;
                if (Direccion == argument)
                {
                    Repeater grupos = (Repeater)RptMenuOptions.Items[i].FindControl("RptSubMenuOptionsLevel1");
                    if (grupos != null)
                    {
                        Contabilidad.Bussines.Menu menu;
                        menu = new Contabilidad.Bussines.Menu();

                        int parent = Convert.ToInt32(argument);
                        grupos.DataSource = menu.BindMenu(parent,0);
                        grupos.DataBind();
                        menu = null;
                        return;
                    }
                }                
            }                                                             
        }     

        //Menu menu;
        //menu = new Menu();
        //string usuario = Session["usuario"].ToString();
        //this.DataSource = menu.DataDireccion(usuario);
        //CreateMenu();

        //menu = null;
    }




}
