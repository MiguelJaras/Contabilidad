<%@ Page Language="C#" AutoEventWireup="True" Inherits="LogOut" CodeFile="LogOut.aspx.cs" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>::: CSE :::</title>
     <link href="../Style/AresStyle.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <table border="0" cellpadding="0" cellspacing="0" style="width: 100%; height: 400px">
            <tr>
                <td style="width: 100px; height: 100px">
                </td>
                <td style="width: 100px">
                </td>
                <td style="width: 100px">
                </td>
            </tr>
            <tr>
                <td style="width: 100px;height: 200px">
                </td>
                <td style="text-align: center; background-color: #eeeeee;">
                    <asp:Button ID="btnEntrar" runat="server" CssClass="AresFormButton" Text="Entry" OnClick="btnEntrar_Click" />
                    </td>
                <td style="width: 100px">
                </td>
            </tr>
            <tr>
                <td style="width: 100px;height: 100px">
                </td>
                <td style="width: 100px">
                </td>
                <td style="width: 100px">
                </td>
            </tr>
        </table>
    </div>
    </form>
</body>
</html>
