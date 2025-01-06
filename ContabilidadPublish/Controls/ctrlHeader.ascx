<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ctrlHeader.ascx.cs" Inherits="ControlctrlHeader" %>

<table cellpadding="0" cellspacing="0" width="100%" background="../Controls/ImgHeader/dxpcFooterBack.gif" >
    <tr>
        <td style="width:230px">
           <img src="../Img/top_empresa.png"  alt="logo"/>
       </td>
       <td style="font-weight:bold; color:Navy; width:830px" align="center" >  
            <table width="100%" >
            <tr>
                <td style="width:100%;color:Navy; font-size:12pt">
                   Contabilidad
                </td>
            </tr>
            <tr>
                <td style="width:100%;color:Navy; height: 22px; font-size:12pt">
                     <asp:Label ID="lblEmpresa" runat="server" CssClass="tLetra4"></asp:Label>                                                         
                </td>
            </tr>            
            </table>                  
       </td>
       <td align="right">
            <table width="100%" >
            <tr>
                <td style="width:100%;color:Navy;">
                    <span id="LiveClockIE" style="width:300px; background-color:Transparent"></span>
                </td>
            </tr>
            <tr>
                <td style="width:100%;color:Navy; height: 22px;">
                     <img src="../Controls/ImgHeader/users.png" alt="User" />&nbsp;<asp:Literal ID="lblFullName" runat="server"></asp:Literal>&nbsp;|&nbsp;<asp:LinkButton ID="LnkLogoff" runat="server" OnClick="LnkLogoff_Click" CausesValidation="false">Cerrar</asp:LinkButton>             
                     &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;                                                          
                </td>
            </tr>            
            </table>
       </td>                         
    </tr>   
</table>

