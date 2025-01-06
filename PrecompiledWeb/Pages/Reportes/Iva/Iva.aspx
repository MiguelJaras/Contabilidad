<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Pages/Reportes/Base.master" CodeFile="Iva.aspx.cs" Inherits="Contabilidad_Compra_Reportes_Iva" %>
<%@ Register Assembly="Anthem" Namespace="Anthem" TagPrefix="anthem" %>    


               
<asp:Content ID="Content" ContentPlaceHolderID="CPHFilters" Runat="Server">              
    <table cellpadding="0" cellspacing="0" width="100%">
        <tr>
            <td colspan="7" style="height: 16px" class="tHead">
                Iva</td>
        </tr>                
    </table>
    <br />
       <table>
        <tr>
            <td class="tLetra3">
                &nbsp;&nbsp;&nbsp;Empresa:
            </td>
            <td class="tLetra36">
                <anthem:TextBox ID="txtEmpresa" runat="server" CssClass="String" Width="80px" AutoPostBack="true" OnTextChanged="txtEmpresa_TextChange" BorderColor="Navy"/> 

                       <anthem:ImageButton runat="server" ID="ImageButton6" OnClientClick="var a = JBrowse('ctl00_CPHFilters_txtEmpresa','ctl00_CPHFilters_txtEmpresa,ctl00_CPHFilters_txtNombreEmpresa','DACEmpresa','',1,ctl00_CPHFilters_txtEmpresa.value,ctl00_CPHFilters_hddSucursal.value,'8', true,'No hay información',function(){document.getElementById('ctl00_CPHFilters_txtEmpresa').onchange(); },0); "
                    Height="18px" ImageUrl="../../../Img/ayuda.gif" Width="20" ImageAlign="AbsMiddle" />

                <anthem:TextBox ID="txtNombreEmpresa" runat="server" CssClass="String" Width="300px" ReadOnly="true" BorderColor="Navy"/>
                <anthem:HiddenField ID="hddSucursal" runat="server" />
            </td>
            <td  class="tLetra3">
                &nbsp;
            </td>
            <td>                    
                &nbsp;
            </td>
        </tr> 
         <tr>
            <td class="tLetra3" valign="top">
                &nbsp;&nbsp; Cuenta Bancaria</td>
            <td class="tLetra3" valign="top">
                <anthem:TextBox ID="txtCtaBanc" runat="server" AutoPostBack="true" CssClass="String" TabIndex="3" Width="80px" OnTextChanged="txtCta_TextChanged" ></anthem:TextBox>&nbsp;<anthem:ImageButton runat="server" ID="ImageButton8" 
                            OnClientClick="var a = JBrowse('ctl00_CPHFilters_txtCtaBanc','ctl00_CPHFilters_txtCtaBanc,ctl00_CPHFilters_txtCtaBancDes','DACFactura','',18,ctl00_CPHFilters_txtEmpresa.value,ctl00_CPHFilters_hddSucursal.value,'8', true,'No hay información',function(){document.getElementById('ctl00_CPHFilters_txtCtaBanc').onchange(); },0); "
                    Height="18px" ImageUrl="../../../Img/ayuda.gif" Width="20" ImageAlign="AbsMiddle" />

                <anthem:TextBox ID="txtCtaBancDes" runat="server" CssClass="String" TabIndex="4"
                    Width="300px" ReadOnly="True"></anthem:TextBox></td>
            <td class="tLetra3" valign="top">
            </td>
            <td class="tLetra3" valign="top">
            </td>
        </tr>           
        <tr>      
            <td class="tLetra3" valign="top">
                &nbsp;&nbsp;&nbsp;Ejercicio
            </td>                
            <td class="tLetra3" valign="top">
                <anthem:DropDownList ID="cboYear" runat="server" CssClass="tDatos250" Width="150px" TabIndex="1">
                    </anthem:DropDownList></td>
            <td class="tLetra3" valign="top">
            </td>                
            <td class="tLetra3" valign="top">
            </td>                
        </tr>
        <tr>      
            <td class="tLetra3" valign="top">
                &nbsp;&nbsp;&nbsp;Mes
           </td>                
            <td class="tLetra3" valign="top">
                <anthem:DropDownList ID="cboMonth" runat="server" CssClass="tDatos250" Width="150px" TabIndex="2">
                </anthem:DropDownList>
            </td>
            <td class="tLetra3" valign="top">
            </td>                
            <td class="tLetra3" valign="top">
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
                            <anthem:LinkButton ID="lknDesglosado" runat="server" Text="Desglosado" OnClick="lknDesglosado_Click" >
                            </anthem:LinkButton></td>
                        </tr>
                        <tr>
                            <td onmouseover="Over(this);" onmouseout="Out(this);" class="Out(this);" style="width: 100%; height:20px">
                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                            <anthem:LinkButton ID="lknAnalitico" runat="server"  Text="Analitico" OnClick="lknAnalitico_Click" >
                            </anthem:LinkButton></td>
                        </tr> 

                        <tr>
                            <td onmouseover="Over(this);" onmouseout="Out(this);" class="Out(this);" style="width: 100%; height:20px">
                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                            <anthem:LinkButton ID="lknAnalitico2" runat="server"  Text="Analitico No Acreditable" OnClick="lknAnalitico2_Click" >
                            </anthem:LinkButton></td>
                        </tr>

                        <tr>
                            <td onmouseover="Over(this);" onmouseout="Out(this);" class="Out(this);" style="width: 100%; height:20px">
                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                            <anthem:LinkButton ID="lknIvaAnalitico" runat="server"  Text="Iva Analitico Detallado" OnClick="lknIvaAnalitico_Click" >
                            </anthem:LinkButton></td>
                        </tr>                                               
                    </table>
                </asp:Panel>
            </td>
        </tr>
    </table>
            <!-- Reportes con Anthem -->
 

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