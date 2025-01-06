<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Pages/Reportes/Base.master"CodeFile="Polizas.aspx.cs" Inherits="Contabilidad_Compra_Reportes_Polizas" %>
<%@ Register Assembly="Anthem" Namespace="Anthem" TagPrefix="anthem" %>    
                
<asp:Content ID="Content" ContentPlaceHolderID="CPHFilters" Runat="Server">              
    <table cellpadding="0" cellspacing="0" width="100%">
        <tr>
            <td colspan="7" style="height: 16px" class="tHead">
                Polizas
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
                &nbsp;&nbsp;&nbsp;Ejercicio
            </td>                
            <td class="tLetra3" valign="top">
                <anthem:DropDownList ID="cboYear" runat="server" CssClass="tDatos250" Width="150px" TabIndex="1">
                </anthem:DropDownList>
            </td>
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
        <tr style="height:20px">
            <td class="tLetra3">
                &nbsp;&nbsp;&nbsp;Tipo Poliza Inicial
            </td>
            <td align="left">
                <anthem:DropDownList ID="cboTipoPoliza" runat="server" CssClass="tDatos250" Width="250px">
                </anthem:DropDownList>
            </td>
            <td align="left" class="tLetra3">
                Tipo Poliza Final
            </td>
            <td>                    
                <anthem:DropDownList ID="cboTipoPolizaFin" runat="server" CssClass="tDatos250" Width="250px">
                </anthem:DropDownList>
            </td>
        </tr> 
        <tr>
               <td class="tLetra3" valign="top">
                   &nbsp;&nbsp;&nbsp;Poliza Ini
               </td>
               <td class="tLetra3" valign="top">
                   <anthem:TextBox ID="txtPolIni" runat="server" CssClass="String"  TabIndex="7" Width="80px" ></anthem:TextBox>&nbsp;
                   
                       <anthem:ImageButton runat="server" ID="ImageButton8" OnClientClick="var a = JBrowse('ctl00_CPHFilters_txtPolIni','ctl00_CPHFilters_txtPolIni,ctl00_CPHFilters_hddPoliza','DACPolizaDet','ctl00_CPHFilters_cboTipoPoliza,ctl00_CPHFilters_cboYear,ctl00_CPHFilters_cboMonth',4,ctl00_CPHFilters_txtEmpresa.value,ctl00_CPHFilters_hddSucursal.value,'8', true,'No hay información',function(){ document.getElementById('ctl00_CPHFilters_txtPolIni').value = document.getElementById('ctl00_CPHFilters_txtPolIni').value.substring(5); document.getElementById('ctl00_CPHFilters_txtPolFin').focus(); },0); "
                    Height="18px" ImageUrl="../../../Img/ayuda.gif" Width="20" ImageAlign="AbsMiddle" />

                    <anthem:HiddenField ID="hddPoliza" runat="server" />
               </td>
               <td class="tLetra3" valign="top">
                   Poliza Fin
               </td>
               <td class="tLetra3" valign="top">
                   <anthem:TextBox ID="txtPolFin" runat="server" CssClass="String"  TabIndex="9" Width="80px" ></anthem:TextBox>&nbsp;
                   
                       <anthem:ImageButton runat="server" ID="ImageButton9" OnClientClick="var a = JBrowse('ctl00_CPHFilters_txtPolFin','ctl00_CPHFilters_txtPolFin,ctl00_CPHFilters_hddPolizaFin,ctl00_CPHFilters_hddPolizaFin,ctl00_CPHFilters_hddPolizaFin','DACPolizaDet','ctl00_CPHFilters_cboTipoPolizaFin,ctl00_CPHFilters_cboYear,ctl00_CPHFilters_cboMonth',4,ctl00_CPHFilters_txtEmpresa.value,ctl00_CPHFilters_hddSucursal.value,'8', true,'No hay información',function(){document.getElementById('ctl00_CPHFilters_txtPolFin').value = document.getElementById('ctl00_CPHFilters_txtPolFin').value.substring(5); document.getElementById('ctl00_CPHFilters_chkAfec').focus(); },0); "
                    Height="18px" ImageUrl="../../../Img/ayuda.gif" Width="20" ImageAlign="AbsMiddle" />

                   <anthem:HiddenField ID="hddPolizaFin" runat="server" />
               </td>
           </tr>
           <tr>
               <td class="tLetra3" valign="top">
                   &nbsp;&nbsp;&nbsp;Filtrar
               </td>
               <td class="tLetra3" colspan="3" valign="top">
                   <asp:CheckBox ID="chkAfec" runat="server" TabIndex="10" Text="Afectadas" />
                    &nbsp; &nbsp; &nbsp; &nbsp;
                   <asp:CheckBox ID="chkNoAfec" runat="server" TabIndex="11" Text="No Afectadas" />                                     
                   &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp;
                   <asp:CheckBox ID="chkCancel" runat="server" TabIndex="12" Text="Canceladas" />
               </td>
           </tr>
            <tr>
               <td class="tLetra3" valign="top">
                   &nbsp;&nbsp;&nbsp;Tipo Impresión
               </td>
               <td class="tLetra3" colspan="3" valign="top">
                   <asp:RadioButtonList ID="rbdTipo" runat="server" CssClass="tLetra3" RepeatDirection="Horizontal" Width="200px" >
                        <asp:ListItem Value="1" Selected ="True" Text="Hoja por Póliza"></asp:ListItem>
                        <asp:ListItem Value="0" Text="Continuo"></asp:ListItem>
                   </asp:RadioButtonList>
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
                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
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
                                <anthem:LinkButton ID="lknPoliza" runat="server" Text="Polizas" OnClick="lknPoliza_Click" >
                                </anthem:LinkButton>
                            </td>
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