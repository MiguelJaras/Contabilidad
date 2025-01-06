<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Pages/Reportes/Base.master" CodeFile="Libro.aspx.cs" Inherits="Contabilidad_Reportes_Libro" Culture="auto" UICulture="auto" %>
<%@ Register Assembly="Anthem" Namespace="Anthem" TagPrefix="anthem" %>   
                
<asp:Content ID="Content" ContentPlaceHolderID="CPHFilters" Runat="Server">              
    <table cellpadding="0" cellspacing="0" width="100%">
        <tr>
            <td colspan="7" style="height: 16px" class="tHead">
                Libro Mayor
            </td>
        </tr>                
    </table>
    <br />
    <table>
        <tr>
            <td class="tLetra3">
                &nbsp;&nbsp;&nbsp;Empresa:
            </td>
            <td class="tLetra36">
               <anthem:TextBox ID="txtEmpresa" runat="server" CssClass="String" Width="90px" AutoCallBack="true"
                    OnTextChanged="txtEmpresa_TextChange" TabIndex="1" BorderColor="Navy" />
                <anthem:ImageButton runat="server" ID="imgEmpresa" OnClientClick="var a = Browse('ctl00_CPHFilters_txtEmpresa','ctl00_CPHFilters_txtEmpresa,ctl00_CPHFilters_txtNombreEmpresa','DACEmpresa','',1,ctl00_CPHFilters_txtEmpresa.value,ctl00_CPHFilters_hddSucursal.value,'8', true,'No hay información'); if(a != undefined) document.getElementById('ctl00_CPHFilters_txtEmpresa').onchange(); else return false;"
                    Height="17" ImageUrl="../../../Img/ayuda.gif" Width="20" />&nbsp;
                <anthem:TextBox ID="txtNombreEmpresa" runat="server" CssClass="String" Width="300px"
                    ReadOnly="true" BorderColor="Navy" />
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
                &nbsp;&nbsp;&nbsp;Ejercicio&nbsp;
            </td>                
            <td class="tLetra3" valign="top">
                <anthem:DropDownList ID="cboYear" runat="server" CssClass="String" Width="120px" TabIndex="1">
                </anthem:DropDownList>
            </td>
             <td class="tLetra3" valign="top">
                &nbsp;
            </td>                
            <td class="tLetra3" valign="top">
               &nbsp;
           </td>               
        </tr>
        <tr>      
            <td class="tLetra3" valign="top">
                &nbsp;&nbsp;&nbsp;Mes
            </td>                
            <td class="tLetra3" valign="top">
                <anthem:DropDownList ID="cboMonth" runat="server" CssClass="String" Width="120px" TabIndex="2">
                </anthem:DropDownList>
           </td> 
            <td class="tLetra3" valign="top">
                &nbsp;
            </td>                
            <td class="tLetra3" valign="top">
               &nbsp;
           </td>                
        </tr>
        <tr>      
            <td class="tLetra3" valign="top">
                &nbsp;&nbsp;&nbsp;Nivel
            </td>                
            <td class="tLetra3" valign="top">
                <anthem:DropDownList ID="cboNivel" runat="server" CssClass="String" Width="120px" TabIndex="3">
                </anthem:DropDownList>
           </td> 
            <td class="tLetra3" valign="top">
                &nbsp;
            </td>                
            <td class="tLetra3" valign="top">
               &nbsp;
           </td>                
        </tr>
        <tr>      
            <td class="tLetra3" valign="top">
                &nbsp;&nbsp;&nbsp;Cuenta Inicial
            </td>                
            <td class="tLetra3" valign="top">
                <anthem:TextBox ID="txtCuenta" runat="server" TabIndex="2" Width="90px" AutoCallBack="true" OnTextChanged="txtCuenta_Change" Style="color: Black; text-align: left; font: 8pt Tahoma;">
                </anthem:TextBox>
                <anthem:ImageButton runat="server" ID="btnAyudaCuenta" OnClientClick="var a = Browse('ctl00_CPHFilters_txtCuenta','ctl00_CPHFilters_txtCuenta,ctl00_CPHFilters_txtNombreCuenta','DACCuentas','',1,ctl00_CPHFilters_txtEmpresa.value,ctl00_CPHFilters_hddSucursal.value,'8', true,'No hay Cuentas',1); if(a != undefined) document.getElementById('ctl00_CPHFilters_txtCuentaFin').focus(); return false;"
                    Height="17" ImageUrl="../../../Img/ayuda.gif" Width="20" />&nbsp;
                <anthem:TextBox ID="txtNombreCuenta" runat="server" CssClass="tDatosDisable" Width="250px"></anthem:TextBox>                        
            </td>
            <td class="tLetra3" valign="top">
                Cuenta Final
            </td>                
            <td class="tLetra3" valign="top">
                <anthem:TextBox ID="txtCuentaFin" runat="server" TabIndex="3" Width="90px" AutoCallBack="true" OnTextChanged="txtCuenta_ChangeFin" Style="color: Black; text-align: left; font: 8pt Tahoma;"></anthem:TextBox>
                <anthem:ImageButton runat="server" ID="ImageButton3" OnClientClick="var a = Browse('ctl00_CPHFilters_txtCuentaFin','ctl00_CPHFilters_txtCuentaFin,ctl00_CPHFilters_txtNombreCuentaFin','DACCuentas','',1,ctl00_CPHFilters_txtEmpresa.value,ctl00_CPHFilters_hddSucursal.value,'8', true,'No hay Cuentas',1); if(a != undefined) document.getElementById('ctl00_CPHFilters_txtClave').focus(); return false;"
                    Height="17" ImageUrl="../../../Img/ayuda.gif" Width="20" />&nbsp;
                <anthem:TextBox ID="txtNombreCuentaFin" runat="server" CssClass="tDatosDisable" Width="250px"></anthem:TextBox>                               
            </td>                
        </tr>          
        <tr>
            <td>
                &nbsp;
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
                                <asp:LinkButton ID="lknLibroMayor" runat="server" OnClick="lknLibroMayor_Click" OnClientClick="return Review();" Text="Libro Mayor">
                                </asp:LinkButton>
                            </td>
                        </tr>   
                        <tr>
                            <td onmouseover="Over(this);" onmouseout="Out(this);" class="Out(this);" style="width: 100%; height:20px">
                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                <asp:LinkButton ID="lknLibroMayorObra" runat="server" OnClick="lknLibroMayorObra_Click" OnClientClick="return Review();" Text="Libro Mayor Obra">
                                </asp:LinkButton>
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