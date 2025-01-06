<%@ Page Language="C#" Culture="Auto" UICulture="Auto" AutoEventWireup="true" MasterPageFile="~/Pages/Reportes/Base.master"
    CodeFile="SaldoClientes.aspx.cs" Inherits="Contabilidad_Compra_Reportes_SaldoClientes" %>

<%@ Register Assembly="Anthem" Namespace="Anthem" TagPrefix="anthem" %>
    
<asp:Content ID="Content" ContentPlaceHolderID="CPHFilters" runat="Server">
    <table cellpadding="0" cellspacing="0" width="100%">
        <tr>
            <td colspan="7" style="height: 16px" class="tHead">
                Saldo de Clientes</td>
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

                       <anthem:ImageButton runat="server" ID="ImageButton6" OnClientClick="var a = JBrowse('ctl00_CPHFilters_txtEmpresa','ctl00_CPHFilters_txtEmpresa,ctl00_CPHFilters_txtNombreEmpresa','DACEmpresa','',1,ctl00_CPHFilters_txtEmpresa.value,ctl00_CPHFilters_hddSucursal.value,'8', true,'No hay información',function(){document.getElementById('ctl00_CPHFilters_txtEmpresa').onchange(); },0); "
                    Height="18px" ImageUrl="../../../Img/ayuda.gif" Width="20" ImageAlign="AbsMiddle" />

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
            <td class="tLetra3" valign="top">
               &nbsp;&nbsp;&nbsp; Cuenta
            </td>
            <td>
                <anthem:TextBox ID="txtCuenta" AutoPostBack="true" runat="server" OnTextChanged="txtCuenta_Change"
                    TabIndex="2" CssClass="String" Width="104px" BorderColor="Navy"></anthem:TextBox>

                       <anthem:ImageButton runat="server" ID="ImageButton8" OnClientClick="var a = JBrowse('ctl00_CPHFilters_txtCuenta','ctl00_CPHFilters_txtCuenta,ctl00_CPHFilters_txtNombreCuenta','DACCuentas','',1,ctl00_CPHFilters_txtEmpresa.value,ctl00_CPHFilters_hddSucursal.value,'8', true,'No hay información',function(){document.getElementById('ctl00_CPHFilters_txtClave').focus(); },0); "
                    Height="18px" ImageUrl="../../../Img/ayuda.gif" Width="20" ImageAlign="AbsMiddle" />

                &nbsp;
                <anthem:TextBox ID="txtNombreCuenta" runat="server" CssClass="tDatosDisable" Width="250px"
                    ReadOnly="True"></anthem:TextBox>
            </td>
        </tr>
        <tr>      
            <td class="tLetra3" valign="top">
                &nbsp;&nbsp;&nbsp;Obra Inicial
            </td>                
            <td class="tLetra3" valign="top">
                <anthem:TextBox ID="txtClave" runat="server"  AutoCallBack="true" CssClass="String" MaxLength="50" width="140px" TabIndex="3" OnTextChanged="txtObra_TextChanged" ></anthem:TextBox> 

                       <anthem:ImageButton runat="server" ID="ImageButton9" OnClientClick="var a = JBrowse('ctl00_CPHFilters_txtClave','ctl00_CPHFilters_txtClave,ctl00_CPHFilters_txtNombre','DACPolizaDet','',1,ctl00_CPHFilters_txtEmpresa.value,ctl00_CPHFilters_hddSucursal.value,'8', true,'No hay información',function(){document.getElementById('ctl00_CPHFilters_txtClave').onchange(); },0); "
                    Height="18px" ImageUrl="../../../Img/ayuda.gif" Width="20" ImageAlign="AbsMiddle" />

                <anthem:TextBox ID="txtNombre" runat="server"  CssClass="tDatosDisable" width="220px" ReadOnly="True"></anthem:TextBox>                                
            </td>
            <td class="tLetra3" valign="top">
                Obra Final
            </td>                
            <td class="tLetra3" valign="top">
                <anthem:TextBox ID="txtClaveFin" runat="server" OnTextChanged="txtObraFin_TextChanged" AutoCallBack="true" CssClass="String" MaxLength="50" width="140px" TabIndex="4" ></anthem:TextBox> 

                       <anthem:ImageButton runat="server" ID="ImageButton10" OnClientClick="var a = JBrowse('ctl00_CPHFilters_txtClaveFin','ctl00_CPHFilters_txtClaveFin,ctl00_CPHFilters_txtNombreFin','DACPolizaDet','',1,ctl00_CPHFilters_txtEmpresa.value,ctl00_CPHFilters_hddSucursal.value,'8', true,'No hay información',function(){document.getElementById('ctl00_CPHFilters_lknEstado').focus(); },0); "
                    Height="18px" ImageUrl="../../../Img/ayuda.gif" Width="20" ImageAlign="AbsMiddle" />

                <anthem:TextBox ID="txtNombreFin" runat="server"  CssClass="tDatosDisable" width="220px" ReadOnly="True"></anthem:TextBox>                                  
            </td>                
        </tr>
        <tr>      
            <td class="tLetra3" valign="top">
                &nbsp;&nbsp;&nbsp;Colonia Inicial
            </td>                
            <td class="tLetra3" valign="top">
                <anthem:TextBox ID="txtColonia" runat="server" OnTextChanged="txtColonia_TextChanged" AutoCallBack="true" CssClass="String" MaxLength="50" width="90px" TabIndex="5" ></anthem:TextBox> 

                       <anthem:ImageButton runat="server" ID="ImageButton11" OnClientClick="var a = JBrowse('ctl00_CPHFilters_txtColonia','ctl00_CPHFilters_txtColonia,ctl00_CPHFilters_txtColoniaNombre','DACPolizaDet','',3,ctl00_CPHFilters_txtEmpresa.value,ctl00_CPHFilters_hddSucursal.value,'8', true,'No hay información',function(){document.getElementById('ctl00_CPHFilters_txtColonia').onchange(); },0); "
                    Height="18px" ImageUrl="../../../Img/ayuda.gif" Width="20" ImageAlign="AbsMiddle" />

                <anthem:TextBox ID="txtColoniaNombre" runat="server"  CssClass="tDatosDisable" width="267px" ReadOnly="True"></anthem:TextBox>                                
            </td>
            <td class="tLetra3" valign="top">
                Colonia Final
            </td>                
            <td class="tLetra3" valign="top">
                <anthem:TextBox ID="txtColoniaFin" runat="server" OnTextChanged="txtColoniaFin_TextChanged" AutoCallBack="true" CssClass="String" MaxLength="50" width="90px" TabIndex="6" ></anthem:TextBox> 

                       <anthem:ImageButton runat="server" ID="ImageButton12" OnClientClick="var a = JBrowse('ctl00_CPHFilters_txtColoniaFin','ctl00_CPHFilters_txtColoniaFin,ctl00_CPHFilters_txtColoniaNombreFin','DACPolizaDet','',3,ctl00_CPHFilters_txtEmpresa.value,ctl00_CPHFilters_hddSucursal.value,'8', true,'No hay información',function(){document.getElementById('ctl00_CPHFilters_txtColoniaFin').focus(); },0); "
                    Height="18px" ImageUrl="../../../Img/ayuda.gif" Width="20" ImageAlign="AbsMiddle" />

                <anthem:TextBox ID="txtColoniaNombreFin" runat="server"  CssClass="tDatosDisable" width="268px" ReadOnly="True"></anthem:TextBox>                                  
            </td>                
        </tr>
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
                                <anthem:LinkButton ID="lknAuxiliarMensualOC" runat="server" AutoUpdateAfterCallBack="true"
                                    OnClick="lknAuxiliarMensualOC_Click" Text="Auxiliar Mensual por Orden de Compra">
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
