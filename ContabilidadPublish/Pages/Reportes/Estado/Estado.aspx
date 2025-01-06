<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Pages/Reportes/Base.master" CodeFile="Estado.aspx.cs" Inherits="Contabilidad_Reportes_Estado" %>
<%@ Register Assembly="Anthem" Namespace="Anthem" TagPrefix="anthem" %>   
                
<asp:Content ID="Content" ContentPlaceHolderID="CPHFilters" Runat="Server">              
    <table cellpadding="0" cellspacing="0" width="100%">
        <tr>
            <td colspan="7" style="height: 16px" class="tHead">
                Estado de Resultados
            </td>
        </tr>                
    </table>
    <br />
    <table style="width: 1089px">
        <tr>
            <td class="tLetra3" style="width: 85px">
                &nbsp;&nbsp;&nbsp;Empresa:
            </td>
            <td class="tLetra3" style="width: 417px">
                <anthem:TextBox ID="txtEmpresa" runat="server" CssClass="String" Width="80px" AutoCallBack="true" OnTextChanged="txtEmpresa_TextChange" BorderColor="Navy"/> 
                <anthem:ImageButton runat="server" ID="ImageButton7" OnClientClick="var a = Browse('ctl00_CPHFilters_txtEmpresa','ctl00_CPHFilters_txtEmpresa,ctl00_CPHFilters_txtNombreEmpresa','DACEmpresa','',1,ctl00_CPHFilters_txtEmpresa.value,ctl00_CPHFilters_hddSucursal.value,'8', true,'No hay información'); if(a != undefined) document.getElementById('ctl00_CPHFilters_txtEmpresa').onchange(); else return false;" height="17" ImageUrl="../../../Img/ayuda.gif" width="20"/> 
                <anthem:TextBox ID="txtNombreEmpresa" runat="server" CssClass="String" Width="300px" ReadOnly="true" BorderColor="Navy"/>
                <anthem:HiddenField ID="hddSucursal" runat="server" />
            </td>
            <td  class="tLetra3" style="width: 74px">
                &nbsp;
            </td>
            <td style="width: 417px">                    
                &nbsp;
            </td>
        </tr> 
        <tr>      
            <td class="tLetra3" valign="top" style="width: 85px">
                &nbsp;&nbsp;&nbsp;Ejercicio&nbsp;
            </td>                
            <td class="tLetra3" valign="top" style="width: 417px">
                <anthem:DropDownList ID="cboYear" runat="server" CssClass="String" Width="120px" TabIndex="1">
                </anthem:DropDownList>
            </td>
             <td class="tLetra3" valign="top" style="width: 74px">
                &nbsp;
            </td>                
            <td class="tLetra3" valign="top" style="width: 417px">
               &nbsp;
           </td>               
        </tr>
        <tr>      
            <td class="tLetra3" valign="top" style="width: 85px">
                &nbsp;&nbsp;&nbsp;Mes
            </td>                
            <td class="tLetra3" valign="top" style="width: 417px">
                <anthem:DropDownList ID="cboMonth" runat="server" CssClass="String" Width="120px" TabIndex="2">
                </anthem:DropDownList>
           </td> 
            <td class="tLetra3" valign="top" style="width: 74px">
                &nbsp;
            </td>                
            <td class="tLetra3" valign="top" style="width: 417px">
               &nbsp;
           </td>                
        </tr>       
        <tr>
            <td class="tLetra3" valign="top" style="width: 85px">
                &nbsp;</td>
            <td class="tLetra3" valign="top" style="width: 417px">
                </td>
            <td class="tLetra3" valign="top" style="width: 74px">
            </td>
            <td class="tLetra3" style="width: 417px" valign="top">
                </td>
        </tr>
    </table>
</asp:Content>
<asp:Content ID="Content1" ContentPlaceHolderID="CPHReports" Runat="Server">  
   <table width="100%">  
        <tr >
            <td class="dxnbGroupHeader_Aqua" style="width:95%">
                <asp:Image id="btnExpandReportes" runat="server" ImageUrl="~/Img/menos.gif" ></asp:Image>
                <asp:Label ID="Label1" runat="server" Text="Reportes"></asp:Label>            
            </td>
        </tr>
        <tr >
            <td style="width: 95%">
                <asp:Panel ID="pnlReportes1" runat="server" Visible="True" CssClass="dxnbControl_Aqua" Width="100%">
                    <table width="100%" style="border: Solid 1px #AECAF0;padding: 1px;">                                           
                        <tr>
                            <td onmouseover="Over(this);" onmouseout="Out(this);" class="Out(this);" style="width: 100%; height:20px">
                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                            <asp:LinkButton ID="lknBalance" runat="server" OnClientClick="return Review();" Text="Estado de Resultados" OnClick="lknBalance_Click" ></asp:LinkButton></td>
                        </tr>                        
                    </table>
                </asp:Panel>
            </td>
        </tr>
    </table>
 

    <script type="text/javascript" language="javascript">
    
        var objUtils=new VetecUtils();                   		   
    	
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