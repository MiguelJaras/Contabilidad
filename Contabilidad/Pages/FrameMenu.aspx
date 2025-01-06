<%@ Page Language="C#" AutoEventWireup="true" Inherits="PageFrameMenu" CodeFile="FrameMenu.aspx.cs" %>

<%@ Register Src="~/Controls/ctrlMenu.ascx" TagName="ctrlMenu" TagPrefix="uc1" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Untitled Page</title>
    <link href="../Style/Style.css"rel="stylesheet" type="text/css" />
</head>
<body>
    <form id="form1" runat="server" style="padding: 0, 0, 0, 0; margin: 0, 0, 0, 0">
    <div>
        <uc1:ctrlMenu ID="ucTemplateMenu" runat="server" DataFieldHasChildren="HasChildren" DataFieldIdMenu="IdMenu" DataFieldIdMenuParent="IdParentMenu" DataFieldMenuName="MenuName" DataFieldPagina="MenuPage" />        
    </div>
    </form>
</body>
</html>
