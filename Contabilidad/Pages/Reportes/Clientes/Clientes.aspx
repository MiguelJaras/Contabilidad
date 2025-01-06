<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Pages/Reportes/Base.master" CodeFile="Clientes.aspx.cs" Inherits="Contabilidad_Compra_Reportes_Clientes" %>
<%@ Register Assembly="Anthem" Namespace="Anthem" TagPrefix="anthem" %>    
               
<asp:Content ID="Content" ContentPlaceHolderID="CPHFilters" Runat="Server">              
    <table cellpadding="0" cellspacing="0" width="100%">
        <tr>
            <td colspan="7" style="height: 16px" class="tHead">
                Clientes
            </td>
        </tr>                
    </table>
    <br />
    <table>
        <tr>
            <td class="tLetra3">
                &nbsp;&nbsp;&nbsp;Empresa:
            </td>
            <td class="tLetra36" colspan="2">
                <anthem:TextBox ID="txtEmpresa" runat="server" CssClass="String" Width="80px" AutoCallBack="true" OnTextChanged="txtEmpresa_TextChange" BorderColor="Navy"/> 

                       <anthem:ImageButton runat="server" ID="ImageButton6" OnClientClick="var a = JBrowse('ctl00_CPHFilters_txtEmpresa','ctl00_CPHFilters_txtEmpresa,ctl00_CPHFilters_txtNombreEmpresa','DACEmpresa','',1,ctl00_CPHFilters_txtEmpresa.value,ctl00_CPHFilters_hddSucursal.value,'8', true,'No hay información',function(){document.getElementById('ctl00_CPHFilters_txtEmpresa').onchange(); },0); "
                    Height="18px" ImageUrl="../../../Img/ayuda.gif" Width="20" ImageAlign="AbsMiddle" />

                <anthem:TextBox ID="txtNombreEmpresa" runat="server" CssClass="String" Width="300px" ReadOnly="true" BorderColor="Navy"/>
                <anthem:HiddenField ID="hddSucursal" runat="server" />
            </td>
            <td  class="tLetra3">
                &nbsp;
            </td>
        </tr> 
         <tr>
            <td class="tLetra3">
                &nbsp;&nbsp;&nbsp;Fecha Inicial
            </td>
            <td class="tLetra36">
                <anthem:textbox ID="txtFechaInicial" Width="80px" runat="server" CssClass="String" TabIndex="1" ></anthem:textbox>
        		<anthem:ImageButton  ID="ImgDate" runat="server" ImageUrl="../../../Scripts/Calendar/Calendar.JPG"/>
            </td>
            <td  class="tLetra3">
               &nbsp;&nbsp;&nbsp;Fecha Final
            </td>
            <td>                    
                <anthem:textbox ID="txtFechaFinal" Width="80px" runat="server" CssClass="String" TabIndex="2"  ></anthem:textbox>
                <anthem:ImageButton  ID="ImgDateFin" runat="server" ImageUrl="../../../Scripts/Calendar/Calendar.JPG"/>
            </td>
        </tr>           
        <tr>      
            <td class="tLetra3" valign="top" style="height: 23px">
                 &nbsp;&nbsp;&nbsp;Fecha Corte
            </td>                
            <td class="tLetra3" valign="top" style="height: 23px" colspan="2">
                <anthem:TextBox ID="txtFechaCorte" runat="server" CssClass="String" Width="80px" TabIndex="3"></anthem:TextBox>
                <anthem:ImageButton  ID="ImgDateCorte" runat="server" ImageUrl="../../../Scripts/Calendar/Calendar.JPG"/>                                 
            </td>
            <td class="tLetra3" valign="top" style="height: 23px">
                &nbsp;
            </td>                
        </tr>
        <tr>      
            <td class="tLetra3" valign="top">
                &nbsp;&nbsp;&nbsp;Tipo Credito&nbsp;
            </td>                
            <td class="tLetra3" valign="top">
                <anthem:DropDownList ID="cboTipoCredito" runat="server" CssClass="tDatos250" Width="300px" TabIndex="4">
                </anthem:DropDownList>
            </td>
            <td class="tLetra3" valign="top">
                </td>                
            <td class="tLetra3" valign="top">
            </td>                
        </tr>
         <tr>      
            <td class="tLetra3" valign="top">
                &nbsp;&nbsp;&nbsp;Colonia
            </td>                
            <td class="tLetra3" valign="top">
                <anthem:DropDownList ID="cboColonia" runat="server" CssClass="tDatos250" Width="300px" TabIndex="5">
                </anthem:DropDownList>
            </td>           
        </tr>
    </table>
    
         <div>
             &nbsp;</div>
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
                                &nbsp;&nbsp;
                            <anthem:LinkButton ID="lknClientes" runat="server"  AutoUpdateAfterCallBack="true" OnClick="lknClientes_Click" Text="Saldo Clientes">
                            </anthem:LinkButton>
                            </td>
                        </tr>
                        <tr>
                            <td onmouseover="Over(this);" onmouseout="Out(this);" class="Out(this);" style="width: 100%; height:20px">
                                &nbsp;&nbsp;
                            <anthem:LinkButton ID="lknSaldo" runat="server"  AutoUpdateAfterCallBack="true" OnClick="lknSaldo_Click" Text="Saldo">
                            </anthem:LinkButton></td>
                        </tr>                        
                        <tr>
                            <td onmouseover="Over(this);" onmouseout="Out(this);" class="Out(this);" style="width: 100%; height:20px">
                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                            </td>
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