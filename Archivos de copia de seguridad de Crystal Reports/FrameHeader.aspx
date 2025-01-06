<%@ Page Language="C#" AutoEventWireup="true" Inherits="PageHeader" CodeFile="FrameHeader.aspx.cs" %>
<%@ Register src="../Controls/ctrlHeader.ascx" tagname="ctrlHeader" tagprefix="uc2" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body >
    <form id="FrmHeader" runat="server" target="_top" >
    <div >
        <table style="width: 100%; height:40px" cellpadding="0" cellspacing="0">
            <colgroup>
                <col width="30%" />
                <col width="40%" />
                <col width="30%"  align="right" style=""/>
            </colgroup> 
            <tr style="height:30px">
                <td colspan="3">
                    <uc2:ctrlHeader ID="CtrlHeader1" runat="server" />
                </td>
            </tr>           
        </table>
    </div>
    </form>
</body>
</html>
