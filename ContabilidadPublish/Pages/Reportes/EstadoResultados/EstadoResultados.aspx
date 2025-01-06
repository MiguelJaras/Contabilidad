<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Pages/Reportes/Base.master" CodeFile="EstadoResultados.aspx.cs" Inherits="Contabilidad_Reportes_EstadoResultados" %>
<%@ Register Assembly="Anthem" Namespace="Anthem" TagPrefix="anthem" %>   
                
<asp:Content ID="Content" ContentPlaceHolderID="CPHFilters" Runat="Server">              
    <table cellpadding="0" cellspacing="0" width="100%">
        <tr>
            <td colspan="7" style="height: 16px" class="tHead">
                Estado Resultados
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
                <anthem:TextBox ID="txtEmpresa" runat="server" CssClass="String" Width="80px" AutoCallBack="true" OnTextChanged="txtEmpresa_TextChange" BorderColor="Navy"/> 
                <anthem:ImageButton runat="server" ID="ImageButton7" OnClientClick="var a = Browse('ctl00_CPHFilters_txtEmpresa','ctl00_CPHFilters_txtEmpresa,ctl00_CPHFilters_txtNombreEmpresa','DACEmpresa','',1,ctl00_CPHFilters_txtEmpresa.value,ctl00_CPHFilters_hddSucursal.value,'8', true,'No hay información'); if(a != undefined) document.getElementById('ctl00_CPHFilters_txtEmpresa').onchange(); else return false;" height="17" ImageUrl="../../../Img/ayuda.gif" width="20"/> 
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
                &nbsp; Fecha Inicial</td>                
            <td class="tLetra3" valign="top">
                <anthem:TextBox ID="txtFechaInicial" runat="server" CssClass="String" TabIndex="1"
                    Width="80px"></anthem:TextBox><anthem:ImageButton ID="ImgDate" runat="server" ImageUrl="../../../Scripts/Calendar/Calendar.JPG" /></td>
            <td class="tLetra3" valign="top">
                Fecha Final</td>                
            <td class="tLetra3" valign="top">
                <anthem:TextBox ID="txtFechaFinal" runat="server" CssClass="String" TabIndex="2"
                    Width="80px"></anthem:TextBox><anthem:ImageButton ID="ImgDateFin" runat="server"
                        ImageUrl="../../../Scripts/Calendar/Calendar.JPG" /></td>                
        </tr>
           <tr>
               <td class="tLetra3" valign="top">
                   &nbsp; Obra Inicial</td>
               <td class="tLetra3" valign="top" style="width: 470px">
                   <anthem:TextBox ID="txtClave" runat="server" AutoPostBack="true" CssClass="String" TabIndex="3" Width="140px" OnTextChanged="txtObra_TextChanged"></anthem:TextBox><asp:ImageButton ID="ImageButton1" runat="server" Height="17" ImageUrl="../../../Img/ayuda.gif"
                       OnClientClick="var a = Browse('ctl00_CPHFilters_txtClave','ctl00_CPHFilters_txtClave,ctl00_CPHFilters_txtNombre','DACPolizaDet','',1,ctl00_CPHFilters_txtEmpresa.value,ctl00_CPHFilters_hddSucursal.value,'8', true,'No hay obras'); if (a != undefined) document.getElementById('ctl00_CPHFilters_txtClave').onchange(); return false;"
                       Width="20" /><anthem:TextBox ID="txtNombre" runat="server" CssClass="String"
                               Width="300px" TabIndex="4"></anthem:TextBox></td>
               <td class="tLetra3" valign="top">
                   Obra Final</td>
               <td class="tLetra3" valign="top" style="width: 470px">
                   <anthem:TextBox ID="txtClaveFin" runat="server" AutoPostBack="true" CssClass="String" TabIndex="3" Width="140px" OnTextChanged="txtObraFin_TextChanged"></anthem:TextBox><asp:ImageButton ID="ImageButton3" runat="server" Height="17" ImageUrl="../../../Img/ayuda.gif"
                       OnClientClick="var a = Browse('ctl00_CPHFilters_txtClaveFin','ctl00_CPHFilters_txtClaveFin,ctl00_CPHFilters_txtNombreFin','DACPolizaDet','',1,ctl00_CPHFilters_txtEmpresa.value,ctl00_CPHFilters_hddSucursal.value,'8', true,'No hay obras'); if (a != undefined) document.getElementById('ctl00_CPHFilters_lknEstado').focus(); return false;"
                       Width="20" /><anthem:TextBox ID="txtNombreFin" runat="server" CssClass="String" TabIndex="4" Width="300px"></anthem:TextBox></td>
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
                            <anthem:LinkButton ID="lknEstado" runat="server" OnClick="lknEstado_Click" Text="Estado resultados por colonia">
                            </anthem:LinkButton><anthem:CheckBox ID="chkQuitar" runat="server" Text="Mostrar columnas con 0" TextAlign="Right" /></td>
                        </tr>                        
                    </table>
                </asp:Panel>
                <asp:ValidationSummary ID="ValidationSummary1" runat="server" ShowMessageBox="True" ShowSummary="False" />
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