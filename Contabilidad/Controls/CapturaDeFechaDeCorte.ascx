<%@ Control Language="C#" AutoEventWireup="true" CodeFile="CapturaDeFechaDeCorte.ascx.cs" EnableViewState="true" Inherits="ControlCapturaDeFechaDeCorte" %>

<%@ Register Assembly="Anthem" Namespace="Anthem" TagPrefix="anthem" %>

<table width="100%">
        <tr>
            <td align="right" class="Label" style="width:20%">
               <asp:literal ID="lblCorte" Text="Corte Al*:" runat="server">
               </asp:literal>
            </td>
            <td align="right" style="width:20%">
                <anthem:textbox ID="TxtCutDate" CssClass="String" runat="server" MaxLength="10" >    
                </anthem:textbox>
            </td>
            <td align="left" style="width:10%">
                <a href="javascript:void(0)" onclick="if(self.gfPop)gfPop.fPopCalendar(document.getElementById('<%=this.TxtCutDate.ClientID%>')); giDatePos=0; return false;" >
                    <img align="top" src="../calendar/calbtn.gif" width="34px" height="22px" border="0" alt=""/>
                </a>
            </td>
            <td align="left" class="Label" style="width:50%">
                <anthem:CheckBox ID="CbWithoutHours" runat="server" 
                    Text="Incluir proyectos sin horas capturadas" />
            </td>            
        </tr>           
    </table>
    <anthem:RequiredFieldValidator ID="RfvCutDate" runat="server" 
        ControlToValidate="TxtCutDate" Display="None" 
        ErrorMessage="Fecha de corte requerida." SetFocusOnError="True"></anthem:RequiredFieldValidator>
      <anthem:CompareValidator ID="CvCutDate" runat="server" Display="None" 
        ErrorMessage="Fecha invalida. Favor de capturar fecha de corte valida." 
        SetFocusOnError="True" Type="Date" ControlToValidate="TxtCutDate" 
    Operator="DataTypeCheck" Enabled="False"></anthem:CompareValidator>      