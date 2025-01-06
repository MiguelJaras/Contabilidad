<%@ Page Language="C#"  culture="es-mx" uiculture="es" AutoEventWireup="true" MasterPageFile="~/Pages/Reportes/Base.master"
CodeFile="Facturacion.aspx.cs" Inherits="Pages_Reportes_Facturacion_Facturacion"  %>
 
<%@ Register Assembly="Anthem" Namespace="Anthem" TagPrefix="anthem" %>
    
<asp:Content ID="Content" ContentPlaceHolderID="CPHFilters" runat="Server">
    <table cellpadding="0" cellspacing="0" width="100%">
        <tr>
            <td colspan="7" style="height: 16px" class="tHead">
                Datos Facturacion</td>
        </tr>
    </table>
    <br />
    <table>  
        <tr>
            <td class="tLetra3" valign="top" style="height: 23px">
                &nbsp;&nbsp;&nbsp;Fecha Inicial
            </td>
            <td class="tLetra3" valign="top" style="height: 23px" colspan="2">
                <anthem:TextBox ID="txtFechaInicial" Width="80px" runat="server" CssClass="String"
                    TabIndex="7"></anthem:TextBox>
                <anthem:ImageButton ID="ImgDate" runat="server" ImageUrl="../../../Scripts/Calendar/Calendar.JPG" />
                &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; Fecha Final&nbsp;
                <anthem:TextBox ID="txtFechaFinal" Width="80px" runat="server" CssClass="String"
                    TabIndex="8"></anthem:TextBox>
                <anthem:ImageButton ID="ImgDateFin" runat="server" ImageUrl="../../../Scripts/Calendar/Calendar.JPG" /></td>
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
                                <anthem:LinkButton ID="lknFacturacion" runat="server" AutoUpdateAfterCallBack="true"
                                    OnClick="lknFacturacion_Click" Text="Datos de facturacion">
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