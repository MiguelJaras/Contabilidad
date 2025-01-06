<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Pages/Reportes/Base.master" CodeFile="Balanza.aspx.cs" Inherits="Contabilidad_Reportes_Balanza" Culture="auto" UICulture="auto" %>
<%@ Register Assembly="Anthem" Namespace="Anthem" TagPrefix="anthem" %>   
                
<asp:Content ID="Content" ContentPlaceHolderID="CPHFilters" Runat="Server">              
    <table cellpadding="0" cellspacing="0" width="100%">
        <tr>
            <td colspan="7" style="height: 16px" class="tHead">
                Balanza de Comprobación
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

                       <anthem:ImageButton runat="server" ID="ImageButton8" OnClientClick="var a = JBrowse('ctl00_CPHFilters_txtEmpresa','ctl00_CPHFilters_txtEmpresa,ctl00_CPHFilters_txtNombreEmpresa','DACEmpresa','',1,ctl00_CPHFilters_txtEmpresa.value,ctl00_CPHFilters_hddSucursal.value,'8', true,'No hay información',function(){document.getElementById('ctl00_CPHFilters_txtEmpresa').onchange(); },0); "
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
            <td class="tLetra3" valign="top">
                &nbsp;&nbsp;&nbsp;Ejercicio&nbsp;
            </td>                
            <td class="tLetra3" valign="top">
                <anthem:DropDownList ID="cboYear" runat="server" CssClass="String" Width="120px" TabIndex="1">
                </anthem:DropDownList>
            </td>
            <td class="tLetra3" colspan="2" rowspan="2" >
               <table width="100%" style="border: Solid 1px #AECAF0">
                    <tr>
                        <td style="height: 24px; border:0;">
                            <anthem:CheckBox ID="chkFecha" runat="server" />
                            &nbsp;&nbsp;&nbsp;
                            Fecha Inicial
                            <anthem:TextBox ID="txtFechaInicial" runat="server" CssClass="String" TabIndex="6" Width="70px"></anthem:TextBox>&nbsp;
                            <anthem:ImageButton ID="ImgDate" runat="server" ImageUrl="../../../Scripts/Calendar/Calendar.JPG" />  
                        </td>
                        <td style="height: 24px; border:0;">
                            Fecha Final
                            <anthem:TextBox ID="txtFechaFinal" runat="server" CssClass="String" TabIndex="6" Width="70px"></anthem:TextBox>&nbsp;
                            <anthem:ImageButton ID="ImgDateFin" runat="server" ImageUrl="../../../Scripts/Calendar/Calendar.JPG" /> 
                        </td>
                    </tr>
                </table>
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

                       <anthem:ImageButton runat="server" ID="ImageButton9" OnClientClick="var a = JBrowse('ctl00_CPHFilters_txtCuenta','ctl00_CPHFilters_txtCuenta,ctl00_CPHFilters_txtNombreCuenta','DACCuentas','',1,ctl00_CPHFilters_txtEmpresa.value,ctl00_CPHFilters_hddSucursal.value,'8', true,'No hay información',function(){document.getElementById('ctl00_CPHFilters_txtCuenta').onchange(); },0); "
                    Height="18px" ImageUrl="../../../Img/ayuda.gif" Width="20" ImageAlign="AbsMiddle" />

                &nbsp;
                <anthem:TextBox ID="txtNombreCuenta" runat="server" CssClass="tDatosDisable" Width="250px"></anthem:TextBox>                        
            </td>
            <td class="tLetra3" valign="top">
                Cuenta Final
            </td>                
            <td class="tLetra3" valign="top">
                <anthem:TextBox ID="txtCuentaFin" runat="server" TabIndex="3" Width="90px" AutoCallBack="true" OnTextChanged="txtCuenta_ChangeFin" Style="color: Black; text-align: left; font: 8pt Tahoma;"></anthem:TextBox>

                       <anthem:ImageButton runat="server" ID="ImageButton13" OnClientClick="var a = JBrowse('ctl00_CPHFilters_txtCuentaFin','ctl00_CPHFilters_txtCuentaFin,ctl00_CPHFilters_txtNombreCuentaFin','DACCuentas','',1,ctl00_CPHFilters_txtEmpresa.value,ctl00_CPHFilters_hddSucursal.value,'8', true,'No hay información',function(){document.getElementById('ctl00_CPHFilters_txtClave').onchange(); },0); "
                    Height="18px" ImageUrl="../../../Img/ayuda.gif" Width="20" ImageAlign="AbsMiddle" />

                &nbsp;
                <anthem:TextBox ID="txtNombreCuentaFin" runat="server" CssClass="tDatosDisable" Width="250px"></anthem:TextBox>                               
            </td>                
        </tr>  
        <tr>      
            <td class="tLetra3" valign="top">
                &nbsp;&nbsp;&nbsp;Obra Inicial
            </td>                
            <td class="tLetra3" valign="top">
                <anthem:TextBox ID="txtClave" runat="server" OnTextChanged="txtObra_TextChanged" AutoCallBack="true" CssClass="String" MaxLength="50" width="140px" TabIndex="12" >
                </anthem:TextBox>

                       <anthem:ImageButton runat="server" ID="ImageButton10" OnClientClick="var a = JBrowse('ctl00_CPHFilters_txtClave','ctl00_CPHFilters_txtClave,ctl00_CPHFilters_txtNombre','DACPolizaDet','',1,ctl00_CPHFilters_txtEmpresa.value,ctl00_CPHFilters_hddSucursal.value,'8', true,'No hay información',function(){document.getElementById('ctl00_CPHFilters_txtClave').onchange(); },0); "
                    Height="18px" ImageUrl="../../../Img/ayuda.gif" Width="20" ImageAlign="AbsMiddle" />

                <anthem:TextBox ID="txtNombre" runat="server"  CssClass="tDatosDisable" width="220px" ReadOnly="True"></anthem:TextBox>                                
            </td>
            <td class="tLetra3" valign="top">
                Obra Final
            </td>                
            <td class="tLetra3" valign="top">
                <anthem:TextBox ID="txtClaveFin" runat="server" OnTextChanged="txtObraFin_TextChanged" AutoCallBack="true" CssClass="String" MaxLength="50" width="140px" TabIndex="12" >
                </anthem:TextBox>

                       <anthem:ImageButton runat="server" ID="ImageButton14" OnClientClick="var a = JBrowse('ctl00_CPHFilters_txtClaveFin','ctl00_CPHFilters_txtClaveFin,ctl00_CPHFilters_txtNombreFin','DACPolizaDet','',1,ctl00_CPHFilters_txtEmpresa.value,ctl00_CPHFilters_hddSucursal.value,'8', true,'No hay información',function(){document.getElementById('ctl00_CPHFilters_txtArea').focus(); },0); "
                    Height="18px" ImageUrl="../../../Img/ayuda.gif" Width="20" ImageAlign="AbsMiddle" />

                <anthem:TextBox ID="txtNombreFin" runat="server"  CssClass="tDatosDisable" width="220px" ReadOnly="True"></anthem:TextBox>                                  
            </td>                
        </tr> 
        <tr>      
            <td class="tLetra3" valign="top">
                &nbsp;&nbsp;&nbsp;Area Inicial
            </td>                
            <td class="tLetra3" valign="top">
                <anthem:TextBox ID="txtArea" runat="server" OnTextChanged="txtArea_TextChanged1" AutoCallBack="True" CssClass="String" 
                    Width="90px" TabIndex="13"></anthem:TextBox>

                       <anthem:ImageButton runat="server" ID="ImageButton11" OnClientClick="var a = JBrowse('ctl00_CPHFilters_txtArea','ctl00_CPHFilters_txtArea,ctl00_CPHFilters_txtNombreArea','DACPolizaDet','',2,ctl00_CPHFilters_txtEmpresa.value,ctl00_CPHFilters_hddSucursal.value,'8', true,'No hay información',function(){document.getElementById('ctl00_CPHFilters_txtArea').onchange(); },0); "
                    Height="18px" ImageUrl="../../../Img/ayuda.gif" Width="20" ImageAlign="AbsMiddle" />

                <anthem:TextBox ID="txtNombreArea" runat="server"  CssClass="tDatosDisable" width="220px" ReadOnly="True"></anthem:TextBox>                                
            </td>
            <td class="tLetra3" valign="top">
                Area Final
            </td>                
            <td class="tLetra3" valign="top">
                <anthem:TextBox ID="txtAreaFin" runat="server" AutoCallBack="true" CssClass="String" MaxLength="50" width="90px" TabIndex="12" >
                </anthem:TextBox>

                       <anthem:ImageButton runat="server" ID="ImageButton15" OnClientClick="var a = JBrowse('ctl00_CPHFilters_txtAreaFin','ctl00_CPHFilters_txtAreaFin,ctl00_CPHFilters_txtNombreAreaFin','DACPolizaDet','',2,ctl00_CPHFilters_txtEmpresa.value,ctl00_CPHFilters_hddSucursal.value,'8', true,'No hay información',function(){document.getElementById('ctl00_CPHFilters_txtColonia').onchange(); },0); "
                    Height="18px" ImageUrl="../../../Img/ayuda.gif" Width="20" ImageAlign="AbsMiddle" />

                <anthem:TextBox ID="txtNombreAreaFin" runat="server"  CssClass="tDatosDisable" width="220px" ReadOnly="True"></anthem:TextBox>                                  
            </td>                
        </tr>    
        <tr>      
            <td class="tLetra3" valign="top">
                &nbsp;&nbsp;&nbsp;Colonia Inicial
            </td>                
            <td class="tLetra3" valign="top">
                <anthem:TextBox ID="txtColonia" runat="server" OnTextChanged="txtColonia_TextChanged" AutoCallBack="true" CssClass="String" MaxLength="50" width="90px" TabIndex="12" >
                </anthem:TextBox>

                       <anthem:ImageButton runat="server" ID="ImageButton12" OnClientClick="var a = JBrowse('ctl00_CPHFilters_txtColonia','ctl00_CPHFilters_txtColonia,ctl00_CPHFilters_txtColoniaNombre','DACPolizaDet','',3,ctl00_CPHFilters_txtEmpresa.value,ctl00_CPHFilters_hddSucursal.value,'8', true,'No hay información',function(){document.getElementById('ctl00_CPHFilters_txtColonia').onchange(); },0); "
                    Height="18px" ImageUrl="../../../Img/ayuda.gif" Width="20" ImageAlign="AbsMiddle" />

                <anthem:TextBox ID="txtColoniaNombre" runat="server"  CssClass="tDatosDisable" width="220px" ReadOnly="True"></anthem:TextBox>                                
            </td>
            <td class="tLetra3" valign="top">
                Colonia Final
            </td>                
            <td class="tLetra3" valign="top">
                <anthem:TextBox ID="txtColoniaFin" runat="server" OnTextChanged="txtColoniaFin_TextChanged" AutoCallBack="true" CssClass="String" MaxLength="50" width="90px" TabIndex="12" >
                </anthem:TextBox>

                       <anthem:ImageButton runat="server" ID="ImageButton16" OnClientClick="var a = JBrowse('ctl00_CPHFilters_txtColoniaFin','ctl00_CPHFilters_txtColoniaFin,ctl00_CPHFilters_txtColoniaNombreFin','DACPolizaDet','',3,ctl00_CPHFilters_txtEmpresa.value,ctl00_CPHFilters_hddSucursal.value,'8', true,'No hay información',function(){document.getElementById('ctl00_CPHFilters_txtColoniaFin').focus(); },0); "
                    Height="18px" ImageUrl="../../../Img/ayuda.gif" Width="20" ImageAlign="AbsMiddle" />

                <anthem:TextBox ID="txtColoniaNombreFin" runat="server"  CssClass="tDatosDisable" width="220px" ReadOnly="True"></anthem:TextBox>                                  
            </td>                
        </tr>
        <tr>
            <td>
                &nbsp;
            </td>
        </tr>  
        <tr>
            <td colspan= "2">
                 <table width="100%" style="border: Solid 1px #AECAF0">
                    <tr>
                        <td class="tLetra3" valign="top">                
                            &nbsp;&nbsp;&nbsp;Fecha Impr.
                            &nbsp;&nbsp; 
                            <anthem:CheckBox ID="chkFechaPrint" runat="server" />
                            <anthem:TextBox ID="txtFechaPrint" runat="server" CssClass="String" TabIndex="6" Width="70px"></anthem:TextBox>&nbsp;
                            <anthem:ImageButton ID="btnFechaPrint" runat="server" ImageUrl="../../../Scripts/Calendar/Calendar.JPG" />  
                        </td>
                    </tr>
                </table>
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
                                <asp:LinkButton ID="lknBalanza" runat="server" OnClick="lknBalanza_Click" OnClientClick="return Review();" Text="Balanza de Comprobación">
                                </asp:LinkButton>
                            </td>
                        </tr>
                        <tr>
                            <td onmouseover="Over(this);" onmouseout="Out(this);" class="Out(this);" style="width: 100%; height:20px">
                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                <asp:LinkButton ID="lknBalanzaCero" runat="server" OnClick="lknBalanzaCero_Click" OnClientClick="return Review();" Text="Balanza de Comprobación en Cero">
                                </asp:LinkButton>
                            </td>
                        </tr>
                        <tr>
                            <td onmouseover="Over(this);" onmouseout="Out(this);" class="Out(this);" style="width: 100%; height:20px">
                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                <asp:LinkButton ID="lknObra" runat="server" OnClick="lknObra_Click" OnClientClick="return Review();" Text="Balanza de Comprobación por Obra">
                                </asp:LinkButton>
                            </td>
                        </tr> 
                        <tr>
                            <td onmouseover="Over(this);" onmouseout="Out(this);" class="Out(this);" style="width: 100%; height:20px">
                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                <asp:LinkButton ID="lknObraCero" runat="server" OnClick="lknObraCero_Click" OnClientClick="return Review();" Text="Balanza de Comprobación por Obra en Cero">
                                </asp:LinkButton>
                            </td>
                        </tr> 
                        <tr>
                            <td onmouseover="Over(this);" onmouseout="Out(this);" class="Out(this);" style="width: 100%; height:20px">
                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                <asp:LinkButton ID="lknAnalisis" runat="server" OnClick="lknAnalisis_Click" OnClientClick="return Review();" Text="Analisis">
                                </asp:LinkButton>
                            </td>
                        </tr>  
                        <tr>
                            <td onmouseover="Over(this);" onmouseout="Out(this);" class="Out(this);" style="width: 100%; height:20px">
                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                <asp:LinkButton ID="lknBalanzaElect" runat="server" OnClick="lknBalanzaElect_Click" OnClientClick="return Review();" Text="Balanza de Comprobación Electronica">
                                </asp:LinkButton>
                            </td>
                        </tr>  
                        <tr>
                            <td onmouseover="Over(this);" onmouseout="Out(this);" class="Out(this);" style="width: 100%; height:20px">
                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                <asp:LinkButton ID="lknBalanzaMensua" runat="server" OnClick="lknBalanzaMensual_Click" OnClientClick="return Review();" Text="Balanza de Saldos Mensual">
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