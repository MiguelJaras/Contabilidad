<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Toolbar_Event.ascx.cs" Inherits="WebControl_Toolbar_Event" %>

<%@ Register Assembly="Anthem" Namespace="Anthem" TagPrefix="anthem" %>

<link href="../Style/StylesVetec.css" rel="stylesheet" type="text/css" />
<div id="DivMenu">
    <table width="100%" style='background-image: url(<%= realPath %>);background-position: top; 
	        background-repeat: repeat-x;height:26' border="0" cellpadding="0" cellspacing="0">
         <tr>
            <td align="left">
                <anthem:ImageButton ID="btnSave" runat="server" Visible="false" ImageAlign="Left" CommandName="Save" ImageUrl="../Img/bt_guardar.png" OnClick="btn_Click" />
                <anthem:ImageButton ID="btnDelete" runat="server" Visible="false" ImageAlign="Left" CommandName="Delete" ImageUrl="../Img/bt_eliminar.png" OnClick="btn_Click" />
                <anthem:ImageButton ID="btnNew" runat="server" Visible="false" ImageAlign="Left" CommandName="New" ImageUrl="../Img/bt_nuevo.png" OnClick="btn_Click" />
                <anthem:ImageButton ID="btnList" runat="server" Visible="false" ImageAlign="Left" CommandName="List" ImageUrl="../Img/bt_listar.png" OnClick="btn_Click" />
                <anthem:ImageButton ID="btnPrint" runat="server" Visible="false" ImageAlign="Left" CommandName="Print" ImageUrl="../Img/bt_imprimir.png" OnClick="btn_Click" />
                <anthem:ImageButton ID="btnEmail" runat="server" Visible="false" ImageAlign="Left" CommandName="Email" ImageUrl="../Img/bt_email.png" OnClick="btn_Click" />
            </td>
         </tr>                 
    </table>      
</div>


