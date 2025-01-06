<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Pages/Contabilidad/SAT/Base.master" CodeFile="Balanza.aspx.cs" Inherits="Contabilidad_SAT_Balanza" culture="es-mx" uiculture="es" %>
<%@ Register Assembly="Anthem" Namespace="Anthem" TagPrefix="anthem" %>   
                
<asp:Content ID="Content" ContentPlaceHolderID="CPHFilters" Runat="Server">              
    <table cellpadding="0" cellspacing="0" width="100%">
        <tr>
            <td colspan="7" style="height: 16px" class="tHead">
                Contabilidad Electronica
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
                <asp:Label ID="Label1" runat="server" Text="Balanza"></asp:Label>            
            </td>
        </tr>
        <tr >
            <td style="width: 95%">
                <anthem:Panel ID="pnlReportes1" runat="server" Visible="True" CssClass="dxnbControl_Aqua" AddCallBacks="true" Width="100%">
                    <table width="100%" style="border: Solid 1px #AECAF0;padding: 1px;"> 
                        <tr>
                            <td onmouseover="Over(this);" onmouseout="Out(this);" class="Out(this);" style="width: 20%; height:20px">
                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                <anthem:LinkButton ID="LinkButton1" runat="server" OnClick="lknCuentas_Click" OnClientClick="" Text="Cuentas">
                                </anthem:LinkButton>
                            </td>
                            <td onmouseover="Over(this);" onmouseout="Out(this);" class="Out(this);" style="width: 80%; height:20px;text-align:left">
                            </td>
                        </tr>                                            
                        <tr>
                            <td onmouseover="Over(this);" onmouseout="Out(this);" class="Out(this);" style="width: 20%; height:20px">
                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                <anthem:LinkButton ID="lknBalanza" runat="server" OnClick="lknBalanza_Click" OnClientClick="" Text="Balanza de Comprobación">
                                </anthem:LinkButton>
                            </td>
                            <td onmouseover="Over(this);" onmouseout="Out(this);" class="Out(this);" style="width: 80%; height:20px;text-align:left">
                            </td>
                        </tr>    
                        <tr>
                            <td onmouseover="Over(this);" onmouseout="Out(this);" class="Out(this);" style="width: 20%; height:20px">
                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                <anthem:LinkButton ID="lknPolizas" runat="server" OnClick="lknPolizas_Click" OnClientClick="return validNumPol();" Text="Polizas">
                                </anthem:LinkButton>                                                              
                            </td>
                            <td onmouseover="Over(this);" onmouseout="Out(this);" class="Out(this);" style="width: 80%; height:20px;text-align:left">
                                  <asp:DropDownList ID="cboTipoSolicitud" runat="server" CssClass="String" Width="150px" TabIndex="2">
                                    <asp:ListItem Text="Acto de Fiscalización" Selected="True" Value ="AF"></asp:ListItem>
                                    <asp:ListItem Text="Fiscalización Compulsa" Value ="FC"></asp:ListItem>
                                    <asp:ListItem Text="Devolución" Value ="DE"></asp:ListItem>
                                    <asp:ListItem Text="Compensación" Value ="CO"></asp:ListItem>
                                </asp:DropDownList>
                                &nbsp;&nbsp;
                                Num Orden/Num Tramite
                                &nbsp;&nbsp;
                                <anthem:TextBox ID="txtNumPol" runat="server" MaxLength="13" Width="120px" ></anthem:TextBox>
                            </td>
                        </tr>                                                                
                        <tr>
                            <td onmouseover="Over(this);" onmouseout="Out(this);" class="Out(this);" style="width: 20%; height:20px">
                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                <anthem:LinkButton ID="lknAuxCuentas" runat="server" OnClick="lknAuxCuentas_Click" OnClientClick="return validNumCuent();" Text="Auxiliares de cuenta">
                                </anthem:LinkButton>
                            </td>
                            <td onmouseover="Over(this);" onmouseout="Out(this);" class="Out(this);" style="width: 80%; height:20px;text-align:left">
                                <asp:DropDownList ID="cboTipoSolicitudCuentas" runat="server" CssClass="String" Width="150px" TabIndex="2">
                                    <asp:ListItem Text="Acto de Fiscalización" Selected="True" Value ="AF"></asp:ListItem>
                                    <asp:ListItem Text="Fiscalización Compulsa" Value ="FC"></asp:ListItem>
                                    <asp:ListItem Text="Devolución" Value ="DE"></asp:ListItem>
                                    <asp:ListItem Text="Compensación" Value ="CO"></asp:ListItem>
                                </asp:DropDownList>
                                &nbsp;&nbsp;
                                Num Orden/Num Tramite
                                &nbsp;&nbsp;
                                <anthem:TextBox ID="txtNumCuent" runat="server" MaxLength="13" Width="120px" ></anthem:TextBox>
                            </td>
                        </tr> 
                        <tr>
                            <td onmouseover="Over(this);" onmouseout="Out(this);" class="Out(this);" style="width: 20%; height:20px">
                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                <anthem:LinkButton ID="lknAuxFolios" runat="server" OnClick="lknAuxFolios_Click" OnClientClick="return validNumFol();" Text="Auxiliares de folios">
                                </anthem:LinkButton>    
                             </td>                                                           
                                <td onmouseover="Over(this);" onmouseout="Out(this);" class="Out(this);" style="width: 80%; height:20px;text-align:left">
                                    <asp:DropDownList ID="cboTipoSolicitudFolios" runat="server" CssClass="String" Width="150px" TabIndex="2">
                                    <asp:ListItem Text="Acto de Fiscalización" Selected="True" Value ="AF"></asp:ListItem>
                                    <asp:ListItem Text="Fiscalización Compulsa" Value ="FC"></asp:ListItem>
                                    <asp:ListItem Text="Devolución" Value ="DE"></asp:ListItem>
                                    <asp:ListItem Text="Compensación" Value ="CO"></asp:ListItem>
                                    </asp:DropDownList>
                                     &nbsp;&nbsp;
                                    Num Orden/Num Tramite                                                                                                
                                    &nbsp;&nbsp;
                                    <anthem:TextBox ID="txtNumFol" runat="server" MaxLength="13" Width="120px" ></anthem:TextBox>
                                </td>
                        </tr>
                        <tr>
                            <td>
                            &nbsp;
                            </td>
                        </tr> 
                        <tr>
                            <td class="tdText" style="height:20px">
                                CONTPAQ i® 
                            </td>
                        </tr>   
                         <tr>
                            <td>
                            &nbsp;
                            </td>
                        </tr>                                           
                        <tr>
                            <td onmouseover="Over(this);" onmouseout="Out(this);" class="Out(this);" style="width: 20%; height:20px">
                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                <anthem:LinkButton ID="lknCuentas" runat="server" OnClick="lknCuenta_Click" OnClientClick="" Text="Cuentas">
                                </anthem:LinkButton>
                            </td>
                            <td onmouseover="Over(this);" onmouseout="Out(this);" class="Out(this);" style="width: 80%; height:20px;text-align:left">
                            </td>
                        </tr>
                         <tr>
                            <td onmouseover="Over(this);" onmouseout="Out(this);" class="Out(this);" style="width: 20%; height:20px">
                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                <anthem:LinkButton ID="lknObras" runat="server" OnClick="lknObras_Click" OnClientClick="" Text="Obras">
                                </anthem:LinkButton>
                            </td>
                            <td onmouseover="Over(this);" onmouseout="Out(this);" class="Out(this);" style="width: 80%; height:20px;text-align:left">
                            </td>
                        </tr>
                        <tr>
                            <td onmouseover="Over(this);" onmouseout="Out(this);" class="Out(this);" style="width: 20%; height:20px">
                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                <anthem:LinkButton ID="lknSaldosFinales" runat="server" OnClick="lknSaldosFinales_Click" OnClientClick="" Text="Saldos Finales">
                                </anthem:LinkButton>
                            </td>
                            <td onmouseover="Over(this);" onmouseout="Out(this);" class="Out(this);" style="width: 80%; height:20px;text-align:left">
                            </td>
                        </tr>                          
                         <tr>
                            <td onmouseover="Over(this);" onmouseout="Out(this);" class="Out(this);" style="width: 20%; height:20px">
                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                <anthem:LinkButton ID="lknProveedores" runat="server" OnClick="lknProveedores_Click" OnClientClick="" Text="Proveedores">
                                </anthem:LinkButton>
                            </td>
                            <td onmouseover="Over(this);" onmouseout="Out(this);" class="Out(this);" style="width: 80%; height:20px;text-align:left">
                            </td>
                        </tr> 
                        <tr>
                            <td onmouseover="Over(this);" onmouseout="Out(this);" class="Out(this);" style="width: 20%; height:20px">
                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                <anthem:LinkButton ID="lknDiario" runat="server" OnClick="lknPolizasDiario_Click" OnClientClick="" Text="Polizas Diario">
                                </anthem:LinkButton>
                            </td>
                            <td onmouseover="Over(this);" onmouseout="Out(this);" class="Out(this);" style="width: 80%; height:20px;text-align:left">
                                Poliza
                                &nbsp;&nbsp;
                                <anthem:TextBox ID="txtPolizaDiario" runat="server" MaxLength="13" Width="120px" ></anthem:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td onmouseover="Over(this);" onmouseout="Out(this);" class="Out(this);" style="width: 20%; height:20px">
                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                <anthem:LinkButton ID="lknPolizasEgresos" runat="server" OnClick="lknPolizasEgresos_Click" OnClientClick="" Text="Polizas Egresos">
                                </anthem:LinkButton>
                            </td>
                            <td onmouseover="Over(this);" onmouseout="Out(this);" class="Out(this);" style="width: 80%; height:20px;text-align:left">
                                Poliza
                                &nbsp;&nbsp;
                                <anthem:TextBox ID="txtPolizaEgresos" runat="server" MaxLength="13" Width="120px" ></anthem:TextBox>
                            </td>
                        </tr>    
                        <tr>
                            <td onmouseover="Over(this);" onmouseout="Out(this);" class="Out(this);" style="width: 20%; height:20px">
                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                <anthem:LinkButton ID="lknIngreso" runat="server" OnClick="lknIngreso_Click" OnClientClick="" Text="Polizas Ingresos">
                                </anthem:LinkButton>
                            </td>
                            <td onmouseover="Over(this);" onmouseout="Out(this);" class="Out(this);" style="width: 80%; height:20px;text-align:left">
                                Poliza
                                &nbsp;&nbsp;
                                <anthem:TextBox ID="txtPolizaIngresos" runat="server" MaxLength="13" Width="120px" ></anthem:TextBox>
                            </td>
                        </tr>                                                           
                    </table>
                </anthem:Panel>
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
        
        function validNumPol() 
        {      
            var con = confirm('Esta seguro de continuar?');

            if(con)
            {            
                var value = document.getElementById("ctl00_CPHReports_txtNumPol").value;   
                var back = true;
                if(validTS("ctl00_CPHReports_cboTipoSolicitud","ctl00_CPHReports_txtNumPol"))
                {
                    if(value == "")
                    {
                        alert("Faltan datos por ingresar.");
                        document.getElementById("ctl00_CPHReports_txtNumPol").focus();
                        back = false;
                    }
                }
                else
                    back = false;
            }
            else
               back = false; 

            return back;   
        }
        
        //ctl00_CPHReports_txtNumCuent     
        function validNumCuent() 
        {      
            var con = confirm('Esta seguro de continuar?');

            if(con)
            {            
                var value = document.getElementById("ctl00_CPHReports_txtNumCuent").value;   
                var back = true;
                if(validTS("ctl00_CPHReports_cboTipoSolicitudCuentas","ctl00_CPHReports_txtNumCuent"))
                {
                    if(value == "")
                    {
                        alert("Faltan datos por ingresar.");
                        document.getElementById("ctl00_CPHReports_txtNumCuent").focus();
                        back = false;
                    }
                }
                else
                    back = false;
            }
            else
               back = false; 

            return back;  
        }
        
        //ctl00_CPHReports_txtNumFol
        function validNumFol() 
        {      
            var con = confirm('Esta seguro de continuar?');

            if(con)
            {            
                var value = document.getElementById("ctl00_CPHReports_txtNumFol").value;   
                var back = true;
                if(validTS("ctl00_CPHReports_cboTipoSolicitudFolios","ctl00_CPHReports_txtNumFol"))
                {
                    if(value == "")
                    {
                        alert("Faltan datos por ingresar.");
                        document.getElementById("ctl00_CPHReports_txtNumFol").focus();
                        back = false;
                    }
                }
                else
                    back = false;
            }
            else
               back = false; 

            return back;  
        }
        
        
        function validTS(ctrlCBO,ctrlTXT) 
        {      
            var ts = document.getElementById(ctrlCBO).value; 
            var value = document.getElementById(ctrlTXT).value;             
            var back = true;
            var valid1 = false;
            var valid2 = false;
            var valid3 = false;
            var valid4 = false;
            var valid5 = false;
            var valid6 = false;
            
            if(ts == "AF" || ts == "FC")
            {
                if(value.length < 13)
                {
                    alert("Numero incorrecto, deben ser 13 caracteres");
                    back = false;
                    document.getElementById(ctrlTXT).focus();
                }
                else
                {
                    //AAA0000000/00
                    valid1 = isNaN(parseFloat(value.substring(0,1))); //true;
                    valid2 = isNaN(parseFloat(value.substring(1,2))); //true;
                    valid3 = isNaN(parseFloat(value.substring(2,3))); //true;
                    valid4 = isNaN(parseFloat(value.substring(3,10))); //false;
                    valid5 = value.substring(10,11);///
                    valid6 = isNaN(parseFloat(value.substring(11,13))); //false;

                    if(valid1 == true && valid2 == true && valid3 == true && valid4 == false && valid5 == '/' && valid6 == false)
                    {
                        back = true;                        
                    }  
                    else
                    {
                        alert("Ocurrio un error, formato invalido.");
                        document.getElementById(ctrlTXT).focus();
                        back = false;
                    }                                                                           
                }
            }
            else
            {
                if(value.length != 10)
                {
                    alert("Numero incorrecto, deben ser 10 caracteres");
                    back = false;
                    document.getElementById(ctrlTXT).focus();
                }
                else
                {              
                    back = true;                        
                }    
            }

            return back; 
        }

    </script>
</asp:Content>