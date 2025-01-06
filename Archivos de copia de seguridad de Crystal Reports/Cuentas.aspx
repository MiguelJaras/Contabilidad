<%@ page language="C#" culture="Auto" uiculture="Auto" autoeventwireup="true" masterpagefile="~/Pages/Reportes/Base.master" CodeFile="Cuentas.aspx.cs" inherits="Contabilidad_Compra_Reportes_Cuentas" %>

<%@ Register Assembly="Anthem" Namespace="Anthem" TagPrefix="anthem" %>
    
<asp:Content ID="Content" ContentPlaceHolderID="CPHFilters" runat="Server">
    <table cellpadding="0" cellspacing="0" width="100%">
        <tr>
            <td colspan="7" style="height: 16px" class="tHead">
                Cuentas</td>
        </tr>
    </table>
    <br />
    <table>
        <tr>
            <td class="tLetra3">
                &nbsp;&nbsp;&nbsp;Empresa:
            </td>
            <td class="tLetra36">
                <anthem:TextBox ID="txtEmpresa" runat="server" CssClass="String" Width="80px" AutoCallBack="true"
                    OnTextChanged="txtEmpresa_TextChange" BorderColor="Navy" TabIndex="1" />
                <anthem:ImageButton runat="server" ID="ImageButton7" OnClientClick="var a = Browse('ctl00_CPHFilters_txtEmpresa','ctl00_CPHFilters_txtEmpresa,ctl00_CPHFilters_txtNombreEmpresa','DACEmpresa','',1,ctl00_CPHFilters_txtEmpresa.value,ctl00_CPHFilters_hddSucursal.value,'8', true,'No hay información'); if(a != undefined) document.getElementById('ctl00_CPHFilters_txtEmpresa').onchange(); else return false;"
                    Height="17" ImageUrl="../../../Img/ayuda.gif" Width="20" ImageAlign="AbsMiddle" />
                <anthem:TextBox ID="txtNombreEmpresa" runat="server" CssClass="String" Width="300px"
                    ReadOnly="true" BorderColor="Navy" />
                <anthem:HiddenField ID="hddSucursal" runat="server" />
            </td>
            <td class="tLetra3">
                &nbsp;
            </td>
            <td>
                &nbsp;
            </td>
        </tr>       
        <tr>
            <td class="tLetra3" valign="top" style="height: 23px">
                &nbsp;&nbsp;&nbsp;Nivel
            </td>
            <td class="tLetra3" valign="top" style="height: 23px" colspan="2">
                <anthem:DropDownList ID="cboNivel" runat="server" Width="100px">
                    <asp:ListItem Selected="true" Text="1 Nivel" Value="1"></asp:ListItem>
                    <asp:ListItem Text="2 Nivel" Value="2"></asp:ListItem>
                    <asp:ListItem Text="3 Nivel" Value="3"></asp:ListItem>
                </anthem:DropDownList>
            </td>
            <td class="tLetra3" valign="top" style="height: 23px">
                &nbsp;
            </td>
        </tr>
    </table>
    <div>
        &nbsp;</div>
</asp:Content>
<asp:Content ID="Content1" ContentPlaceHolderID="CPHReports" runat="Server">
    <table width="100%">
        <tr>
            <td class="dxnbGroupHeader_Aqua" style="width: 95%">
                <asp:Image ID="btnExpandReportes" runat="server" ImageUrl="~/Img/menos.gif"></asp:Image>
                <asp:Label ID="Label1" runat="server" Text="Reportes"></asp:Label>
            </td>
        </tr>
        <tr>
            <td style="width: 95%">
                <asp:Panel ID="pnlReportes1" runat="server" Visible="True" CssClass="dxnbControl_Aqua"
                    Width="100%">
                    <table width="100%" style="border: Solid 1px #AECAF0; padding: 1px;">
                        <tr>
                            <td onmouseover="Over(this);" onmouseout="Out(this);" class="Out(this);" style="width: 100%;
                                height: 20px">
                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                <anthem:LinkButton ID="lknFac" runat="server" OnClick="lknFac_Click" Text="Cuentas.">
                                </anthem:LinkButton>
                            </td>
                        </tr>
                    </table>
                </asp:Panel>
            </td>
        </tr>
    </table>

    <script type="text/javascript" language="javascript">
    
                   		   
    	
	    function ReportVisible(me, control)
        {
            if(document.getElementById(control).style.visibility == "")
                document.getElementById(control).style.visibility  = "visible"
                    
             if (document.getElementById(control).style.visibility == "visible")
             {
                document.getElementById(control).style.visibility  = "hidden";
                me.src= "../../../Img/menos.GIF"
             }
             else
             {
                 document.getElementById(control).style.visibility  = "visible";
                 me.src="../../../Img/mas.GIF"
             }
        }
    	
        function Out(obj) 
        {            
            obj.style.font = "12px Tahoma";
            obj.style.color = "#283B56"; 
            obj.style.padding = "0px";
            obj.style.backgroundColor = "#F2F8FF";            
            obj.style.border = "solid 1px #F2F8FF";                   
            obj.style.cursor = "hand";
        }
        
        function Over(obj) 
        {         
            obj.style.border = "Solid 1px #FFAB3F";
            obj.style.font = "12px Tahoma";
            obj.style.color = "#283B56"; 
            obj.style.padding = "0px";
            obj.style.backgroundColor = "#FFBD69";            
            obj.style.border = "solid 1px #F2F8FF";                   
            obj.style.cursor = "hand";
        }

    </script>

</asp:Content>
