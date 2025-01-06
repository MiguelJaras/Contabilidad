<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Pages/Reportes/Base.master" CodeFile="Saldos.aspx.cs" Inherits="Contabilidad_Reportes_Saldos" uiCulture="es" culture="es-MX" %>
<%@ Register Assembly="Anthem" Namespace="Anthem" TagPrefix="anthem" %>   
                
<asp:Content ID="Content" ContentPlaceHolderID="CPHFilters" Runat="Server">              
    <table cellpadding="0" cellspacing="0" width="100%">
        <tr>
            <td colspan="7" style="height: 16px" class="tHead">
                Saldos Clientes
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

                       <anthem:ImageButton runat="server" ID="ImageButton20" OnClientClick="var a = JBrowse('ctl00_CPHFilters_txtEmpresa','ctl00_CPHFilters_txtEmpresa,ctl00_CPHFilters_txtNombreEmpresa','DACEmpresa','',1,ctl00_CPHFilters_txtEmpresa.value,ctl00_CPHFilters_hddSucursal.value,'8', true,'No hay información',function(){document.getElementById('ctl00_CPHFilters_txtEmpresa').onchange(); },0); "
                    Height="18px" ImageUrl="../../../Img/ayuda.gif" Width="20" ImageAlign="AbsMiddle" />

                &nbsp;
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
            <td class="tLetra3" valign="top">
                &nbsp;&nbsp;&nbsp;Cuenta
            </td>                
            <td class="tLetra3" valign="top">
                <anthem:TextBox ID="txtCuenta" runat="server" TabIndex="2" Width="90px" AutoCallBack="true" OnTextChanged="txtCuenta_Change" Style="color: Black; text-align: left; font: 8pt Tahoma;">
                </anthem:TextBox>

                       <anthem:ImageButton runat="server" ID="ImageButton21" OnClientClick="var a = JBrowse('ctl00_CPHFilters_txtCuenta','ctl00_CPHFilters_txtCuenta,ctl00_CPHFilters_txtNombreCuenta','DACCuentas','',1,ctl00_CPHFilters_txtEmpresa.value,ctl00_CPHFilters_hddSucursal.value,'8', true,'No hay información',function(){document.getElementById('ctl00_CPHFilters_txtCliente').focus(); },0); "
                    Height="18px" ImageUrl="../../../Img/ayuda.gif" Width="20" ImageAlign="AbsMiddle" />

                &nbsp;<anthem:TextBox ID="txtNombreCuenta" runat="server" CssClass="tDatosDisable" Width="250px"></anthem:TextBox>                        
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
                &nbsp;&nbsp;&nbsp;Cliente Inicial
            </td>                
            <td class="tLetra3" valign="top">
                <anthem:TextBox ID="txtCliente" runat="server" OnTextChanged="txtCliente_TextChanged" AutoCallBack="true" CssClass="String" MaxLength="50" width="90px" TabIndex="12" >
                </anthem:TextBox>

                       <anthem:ImageButton runat="server" ID="ImageButton22" OnClientClick="var a = JBrowse('ctl00_CPHFilters_txtCliente','ctl00_CPHFilters_txtCliente,ctl00_CPHFilters_txtNombreCliente','DACPolizaDet','',6,ctl00_CPHFilters_txtEmpresa.value,ctl00_CPHFilters_hddSucursal.value,'8', true,'No hay información',function(){document.getElementById('ctl00_CPHFilters_txtClienteFin').focus(); },0); "
                    Height="18px" ImageUrl="../../../Img/ayuda.gif" Width="20" ImageAlign="AbsMiddle" />

                &nbsp;                   
                <anthem:TextBox ID="txtNombreCliente" runat="server"  CssClass="tDatosDisable" width="250px" ReadOnly="True"></anthem:TextBox>                                
            </td>
            <td class="tLetra3" valign="top">
                Cliente Final
            </td>                
            <td class="tLetra3" valign="top">
                <anthem:TextBox ID="txtClienteFin" runat="server" OnTextChanged="txtColoniaFin_TextChanged" AutoCallBack="true" CssClass="String" MaxLength="50" width="90px" TabIndex="12" >
                </anthem:TextBox>

                       <anthem:ImageButton runat="server" ID="ImageButton27" OnClientClick="var a = JBrowse('ctl00_CPHFilters_txtClienteFin','ctl00_CPHFilters_txtClienteFin,ctl00_CPHFilters_txtNombreClienteFin','DACPolizaDet','',6,ctl00_CPHFilters_txtEmpresa.value,ctl00_CPHFilters_hddSucursal.value,'8', true,'No hay información',function(){document.getElementById('ctl00_CPHFilters_txtColonia').focus(); },0); "
                    Height="18px" ImageUrl="../../../Img/ayuda.gif" Width="20" ImageAlign="AbsMiddle" />

                <anthem:TextBox ID="txtNombreClienteFin" runat="server"  CssClass="tDatosDisable" width="250px" ReadOnly="True"></anthem:TextBox>                                  
            </td>                
        </tr> 
        <tr>      
            <td class="tLetra3" valign="top">
                &nbsp;&nbsp;&nbsp;Proveedor Inicial
            </td>                
            <td class="tLetra3" valign="top">
                <anthem:TextBox ID="txtProveedor" runat="server" OnTextChanged="txtProveedor_TextChanged" AutoCallBack="true" CssClass="String" MaxLength="50" width="90px" TabIndex="12" >
                </anthem:TextBox>

                       <anthem:ImageButton runat="server" ID="ImageButton23" OnClientClick="var a = JBrowse('ctl00_CPHFilters_txtProveedor','ctl00_CPHFilters_txtProveedor,ctl00_CPHFilters_txtNombreProveedor','DACPolizaDet','',8,ctl00_CPHFilters_txtEmpresa.value,ctl00_CPHFilters_hddSucursal.value,'8', true,'No hay información',function(){document.getElementById('ctl00_CPHFilters_txtClienteFin').focus(); },0); "
                    Height="18px" ImageUrl="../../../Img/ayuda.gif" Width="20" ImageAlign="AbsMiddle" />

                &nbsp;                   
                <anthem:TextBox ID="txtNombreProveedor" runat="server"  CssClass="tDatosDisable" width="250px" ReadOnly="True"></anthem:TextBox>                                
            </td>
            <td class="tLetra3" valign="top">
                Proveedor Final
            </td>                
            <td class="tLetra3" valign="top">
                <anthem:TextBox ID="txtProveedorFin" runat="server" OnTextChanged="txtProveedorFin_TextChanged" AutoCallBack="true" CssClass="String" MaxLength="50" width="90px" TabIndex="12" >
                </anthem:TextBox>

                       <anthem:ImageButton runat="server" ID="ImageButton28" OnClientClick="var a = JBrowse('ctl00_CPHFilters_txtProveedorFin','ctl00_CPHFilters_txtProveedorFin,ctl00_CPHFilters_txtNombreProveedorFin','DACPolizaDet','',8,ctl00_CPHFilters_txtEmpresa.value,ctl00_CPHFilters_hddSucursal.value,'8', true,'No hay información',function(){document.getElementById('ctl00_CPHFilters_txtColonia').focus(); },0); "
                    Height="18px" ImageUrl="../../../Img/ayuda.gif" Width="20" ImageAlign="AbsMiddle" />

                <anthem:TextBox ID="txtNombreProveedorFin" runat="server"  CssClass="tDatosDisable" width="250px" ReadOnly="True"></anthem:TextBox>                                  
            </td>                
        </tr> 
        <tr>      
            <td class="tLetra3" valign="top">
                &nbsp;&nbsp;&nbsp;Obra Inicial
            </td>                
            <td class="tLetra3" valign="top">
                <anthem:TextBox ID="txtClave" runat="server" OnTextChanged="txtObra_TextChanged" AutoCallBack="true" CssClass="String" MaxLength="50" width="140px" TabIndex="12" >
                </anthem:TextBox>

                       <anthem:ImageButton runat="server" ID="ImageButton24" OnClientClick="var a = JBrowse('ctl00_CPHFilters_txtClave','ctl00_CPHFilters_txtClave,ctl00_CPHFilters_txtNombre','DACPolizaDet','',1,ctl00_CPHFilters_txtEmpresa.value,ctl00_CPHFilters_hddSucursal.value,'8', true,'No hay información',function(){document.getElementById('ctl00_CPHFilters_txtClaveFin').onchange(); },0); "
                    Height="18px" ImageUrl="../../../Img/ayuda.gif" Width="20" ImageAlign="AbsMiddle" />

                <anthem:TextBox ID="txtNombre" runat="server"  CssClass="tDatosDisable" width="220px" ReadOnly="True"></anthem:TextBox>                                
            </td>
            <td class="tLetra3" valign="top">
                Obra Final
            </td>                
            <td class="tLetra3" valign="top">
                <anthem:TextBox ID="txtClaveFin" runat="server" OnTextChanged="txtObraFin_TextChanged" AutoCallBack="true" CssClass="String" MaxLength="50" width="140px" TabIndex="12" >
                </anthem:TextBox>

                <asp:ImageButton runat="server" ID="ImageButton10" OnClientClick="var a = Browse('ctl00_CPHFilters_txtClaveFin','ctl00_CPHFilters_txtClaveFin,ctl00_CPHFilters_txtNombreFin','DACPolizaDet','',1,ctl00_CPHFilters_txtEmpresa.value,ctl00_CPHFilters_hddSucursal.value,'8', true,'No hay obras'); if (a != undefined) document.getElementById('ctl00_CPHFilters_txtArea').focus(); return false;" height="17" ImageUrl="../../../Img/ayuda.gif" width="20"/>                     
                <anthem:TextBox ID="txtNombreFin" runat="server"  CssClass="tDatosDisable" width="220px" ReadOnly="True"></anthem:TextBox>                                  
            </td>                
        </tr>            
        <tr>      
            <td class="tLetra3" valign="top">
                &nbsp;&nbsp;&nbsp;Colonia Inicial
            </td>                
            <td class="tLetra3" valign="top">
                <anthem:TextBox ID="txtColonia" runat="server" OnTextChanged="txtColonia_TextChanged" AutoCallBack="true" CssClass="String" MaxLength="50" width="90px" TabIndex="12" >
                </anthem:TextBox>

                       <anthem:ImageButton runat="server" ID="ImageButton25" OnClientClick="var a = JBrowse('ctl00_CPHFilters_txtColonia','ctl00_CPHFilters_txtColonia,ctl00_CPHFilters_txtColoniaNombre','DACPolizaDet','',3,ctl00_CPHFilters_txtEmpresa.value,ctl00_CPHFilters_hddSucursal.value,'8', true,'No hay información',function(){document.getElementById('ctl00_CPHFilters_txtColoniaFin').onchange(); },0); "
                    Height="18px" ImageUrl="../../../Img/ayuda.gif" Width="20" ImageAlign="AbsMiddle" />

                &nbsp;                    
                <anthem:TextBox ID="txtColoniaNombre" runat="server"  CssClass="tDatosDisable" width="250px" ReadOnly="True"></anthem:TextBox>                                
            </td>
            <td class="tLetra3" valign="top">
                Colonia Final
            </td>                
            <td class="tLetra3" valign="top">
                <anthem:TextBox ID="txtColoniaFin" runat="server" OnTextChanged="txtColoniaFin_TextChanged" AutoCallBack="true" CssClass="String" MaxLength="50" width="90px" TabIndex="12" >
                </anthem:TextBox>

                       <anthem:ImageButton runat="server" ID="ImageButton30" OnClientClick="var a = JBrowse('ctl00_CPHFilters_txtColoniaFin','ctl00_CPHFilters_txtColoniaFin,ctl00_CPHFilters_txtColoniaNombreFin','DACPolizaDet','',3,ctl00_CPHFilters_txtEmpresa.value,ctl00_CPHFilters_hddSucursal.value,'8', true,'No hay información',function(){document.getElementById('ctl00_CPHFilters_txtOC').focus(); },0); "
                    Height="18px" ImageUrl="../../../Img/ayuda.gif" Width="20" ImageAlign="AbsMiddle" />

                <anthem:TextBox ID="txtColoniaNombreFin" runat="server"  CssClass="tDatosDisable" width="250px" ReadOnly="True"></anthem:TextBox>                                  
            </td>                
        </tr>
        <tr>      
            <td class="tLetra3" valign="top">
                &nbsp;&nbsp;&nbsp;OC Inicial
            </td>                
            <td class="tLetra3" valign="top">
                <anthem:TextBox ID="txtOC" runat="server" CssClass="String" MaxLength="50" width="90px" TabIndex="12" >
                </anthem:TextBox>

                       <anthem:ImageButton runat="server" ID="ImageButton26" OnClientClick="var a = JBrowse('ctl00_CPHFilters_txtOC','ctl00_CPHFilters_txtOC','DACPolizaDet','',7,ctl00_CPHFilters_txtEmpresa.value,ctl00_CPHFilters_hddSucursal.value,'8', true,'No hay información',function(){document.getElementById('ctl00_CPHFilters_txtOCFin').onchange(); },0); "
                    Height="18px" ImageUrl="../../../Img/ayuda.gif" Width="20" ImageAlign="AbsMiddle" />

            </td>
            <td class="tLetra3" valign="top">
                OC Final
            </td>                
            <td class="tLetra3" valign="top">
                <anthem:TextBox ID="txtOCFin" runat="server" CssClass="String" MaxLength="50" width="90px" TabIndex="12" >
                </anthem:TextBox>

                       <anthem:ImageButton runat="server" ID="ImageButton31" OnClientClick="var a = JBrowse('ctl00_CPHFilters_txtOCFin','ctl00_CPHFilters_txtOCFin','DACPolizaDet','',7,ctl00_CPHFilters_txtEmpresa.value,ctl00_CPHFilters_hddSucursal.value,'8', true,'No hay información',function(){document.getElementById('ctl00_CPHFilters_txtOCFin').focus(); },0); "
                    Height="18px" ImageUrl="../../../Img/ayuda.gif" Width="20" ImageAlign="AbsMiddle" />

            </td>                
        </tr>
        <tr>
            <td class="tLetra3" valign="top">
                &nbsp;&nbsp;&nbsp;Tipo
            </td>  
              <td class="tLetra3" valign="top">
                <asp:RadioButtonList ID="rblDesglozado" runat="server" RepeatDirection="Horizontal">
                    <asp:ListItem Text="Cliente" Selected="True" Value="1"></asp:ListItem>
                    <asp:ListItem Text="Proveedor" Value="0"></asp:ListItem>
                </asp:RadioButtonList>
            </td>
            <td class="tLetra3" valign="top" colspan="2">
                <anthem:RadioButtonList ID="rblReferencia" runat="server" RepeatDirection="Horizontal" Width="200px">
                    <asp:ListItem Text="Referencia" Selected="True" Value="0"></asp:ListItem>
                    <asp:ListItem Text="Folio Fiscal" Value="1"></asp:ListItem>
                </anthem:RadioButtonList>   
            </td>
        </tr>
        <tr>      
            <td class="tLetra3" valign="top" colspan="2">
                &nbsp;&nbsp;&nbsp;Mostrar Movimientos Afectados
                <anthem:CheckBox ID="chkAfectado" runat="server" />
            </td>
           <td class="tLetra3" valign="top" colspan="2">
                Mostrar Movimientos Con Saldo
                <anthem:CheckBox ID="chkSaldo" runat="server"/>
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
                                <asp:LinkButton ID="lknCliente" runat="server" OnClick="lknCliente_Click" OnClientClick="return Review();" Text="Saldos Cliente / Proveedor">
                                </asp:LinkButton>
                                &nbsp;&nbsp;
                            </td>
                        </tr>
                        <tr>
                            <td onmouseover="Over(this);" onmouseout="Out(this);" class="Out(this);" style="width: 100%; height:20px">
                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                <asp:LinkButton ID="lknDesglozado" runat="server" OnClick="lknDesglozado_Click" OnClientClick="return Review();" Text="Auxiliar Desglozado OC / Cliente">
                                </asp:LinkButton>
                                &nbsp;&nbsp;                                
                            </td>
                        </tr>
                        <tr>
                            <td onmouseover="Over(this);" onmouseout="Out(this);" class="Out(this);" style="width: 100%; height:20px">
                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                <asp:LinkButton ID="lknAux" runat="server" OnClick="lknAux_Click" OnClientClick="return Review();" Text="Auxiliar Orden Compra">
                                </asp:LinkButton>
                            </td>
                        </tr>   
                        <tr>
                            <td onmouseover="Over(this);" onmouseout="Out(this);" class="Out(this);" style="width: 100%; height:20px">
                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                <asp:LinkButton ID="lknPage" runat="server" OnClientClick="return Curp();" Text="CURP" >
                                </asp:LinkButton>
                            </td>
                        </tr>                                             
                        <tr>
                            <td onmouseover="Over(this);" onmouseout="Out(this);" class="Out(this);" style="width: 100%; height:20px">
                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                <asp:LinkButton ID="lknClienteV2" runat="server" OnClick="lknClienteV2_Click" OnClientClick="return Review();" Text="Saldos Cliente / Proveedor v2.0">
                                </asp:LinkButton>
                                &nbsp;&nbsp;
                            </td>
                        </tr> 
                        <tr>
                            <td onmouseover="Over(this);" onmouseout="Out(this);" class="Out(this);" style="width: 100%; height:20px">
                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                <asp:LinkButton ID="lknDesglozadoV2" runat="server" OnClick="lknDesglozadoV2_Click" OnClientClick="return Review();" Text="Auxiliar Desglozado OC / Cliente v2.0">
                                </asp:LinkButton>
                                &nbsp;&nbsp;                                
                            </td>
                        </tr>                                       
                    </table>
                </asp:Panel>
            </td>
        </tr>
    </table>
 

    <script type="text/javascript" language="javascript">
    
        var objUtils=new VetecUtils();   
        
        function Curp()                		   
        {
            var win = window.open('http://consultas.curp.gob.mx/CurpSP/curp2.do?strCurp=MOMR820729HVZRRB00&strTipo=B&entfija=DF&depfija=11024','example', 'width=300,height=300')                                        
            var collection = win.document.getElementsByTagName("input");      
           
            for (var j = 1; j < collection.length; j++) 
            {                                                                                                                                                   
               if (collection[j].type == "hidden") 
               {           
                    alert(collection[j].id);            
                  alert(collection[j].value); 
               }                  
            }                                                                      
        }
    	
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