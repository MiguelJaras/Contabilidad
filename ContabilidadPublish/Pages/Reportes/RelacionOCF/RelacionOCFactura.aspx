<%@ Page Language="C#" Culture="Auto" UICulture="Auto" AutoEventWireup="true" MasterPageFile="~/Pages/Reportes/Base.master"
    CodeFile="RelacionOCFactura.aspx.cs" Inherits="Contabilidad_Compra_Reportes_RelacionOCFactura" %>

<%@ Register Assembly="Anthem" Namespace="Anthem" TagPrefix="anthem" %>
    
<asp:Content ID="Content" ContentPlaceHolderID="CPHFilters" runat="Server">
<script type="text/javascript" language="javascript" src="../../../Scripts/VetecUtils.js"></script>
    <script type="text/javascript" language="javascript" src="../../../Scripts/Validations.js"></script>
    <script type="text/javascript" language="javascript" src="../../../Scripts/popup.js"></script>
    <script type="text/javascript" language="javascript" src="../../../Scripts/VetecText.js"></script>  

    <table cellpadding="0" cellspacing="0" width="100%">
        <tr>
            <td colspan="7" style="height: 16px" class="tHead">
                Relacion OC - Factura</td>
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
                <anthem:ImageButton runat="server" ID="ImageButton7" OnClientClick="var a = Browse('ctl00_CPHFilters_txtEmpresa','ctl00_CPHFilters_txtEmpresa,ctl00_CPHFilters_txtNombreEmpresa','DACEmpresa','',1,ctl00_CPHFilters_txtEmpresa.value,ctl00_CPHFilters_hddSucursal.value,'8', true,'No hay información'); if(a != undefined) document.getElementById('ctl00_CPHFilters_txtEmpresa').onchange(); else return false;"
                    Height="17" ImageUrl="../../../Img/ayuda.gif" Width="20" ImageAlign="AbsMiddle" />
                <anthem:TextBox ID="txtNombreEmpresa" runat="server" CssClass="String" Width="300px"
                    ReadOnly="true" BorderColor="Navy" />
                <anthem:HiddenField ID="hddSucursal" runat="server" />
            </td>
            <td class="tLetra3">
                &nbsp; Reporte</td>
            <td>
                &nbsp;
                <asp:RadioButtonList ID="rbReporte" runat="server">
                    <asp:ListItem Value="0" Selected="True">Relacion Orden Compra Factura sin IVA</asp:ListItem>
                    <asp:ListItem Value="1">Ordenes de Compra - Facturas Liquidadas y por Liquidar</asp:ListItem>
                </asp:RadioButtonList></td>
        </tr>
        <tr>      
            <td class="tLetra3" valign="top" style="height: 23px">
                &nbsp;&nbsp;&nbsp;Prov Inicial</td>                
            <td class="tLetra3" valign="top" style="height: 23px">
                <anthem:TextBox ID="txtProveedor" runat="server" AutoCallBack="true" CssClass="String"
                    MaxLength="50" OnTextChanged="txtProveedor_TextChanged" TabIndex="2" Width="90px"></anthem:TextBox><asp:ImageButton ID="ImageButton5" runat="server" Height="17" ImageUrl="../../../Img/ayuda.gif"
                    OnClientClick="var a = Browse('ctl00_CPHFilters_txtProveedor','ctl00_CPHFilters_txtProveedor,ctl00_CPHFilters_txtNombreProveedor','DACPolizaDet','',8,ctl00_CPHFilters_txtEmpresa.value,ctl00_CPHFilters_hddSucursal.value,'8', true,'No hay obras'); if (a != undefined) document.getElementById('ctl00_CPHFilters_txtClienteFin').focus(); return false;"
                    Width="20" /><anthem:TextBox ID="txtNombreProveedor" runat="server" CssClass="tDatosDisable"
                        ReadOnly="True" Width="250px"></anthem:TextBox>&nbsp;</td>
            <td class="tLetra3" valign="top" style="height: 23px">
                Prov Final
            </td>                
            <td class="tLetra3" valign="top" style="height: 23px">
                <anthem:TextBox ID="txtProveedorFin" runat="server" AutoCallBack="true" CssClass="String"
                    MaxLength="50" OnTextChanged="txtProveedorFin_TextChanged" TabIndex="3" Width="90px"></anthem:TextBox><asp:ImageButton ID="ImageButton8" runat="server" Height="17" ImageUrl="../../../Img/ayuda.gif"
                    OnClientClick="var a = Browse('ctl00_CPHFilters_txtProveedorFin','ctl00_CPHFilters_txtProveedorFin,ctl00_CPHFilters_txtNombreProveedorFin','DACPolizaDet','',8,ctl00_CPHFilters_txtEmpresa.value,ctl00_CPHFilters_hddSucursal.value,'8', true,'No hay obras'); if (a != undefined) document.getElementById('ctl00_CPHFilters_txtColonia').focus(); return false;"
                    Width="20" /><anthem:TextBox ID="txtNombreProveedorFin" runat="server" CssClass="tDatosDisable"
                        ReadOnly="True" Width="250px"></anthem:TextBox></td>                
        </tr>
        <tr>
            <td class="tLetra3" valign="top">
                &nbsp;&nbsp; Fecha Inicial</td>
            <td class="tLetra3" valign="top">
                <anthem:TextBox ID="txtFechaInicial" Width="80px" runat="server" CssClass="String"
                    TabIndex="4"></anthem:TextBox>
                <anthem:ImageButton ID="ImgDate" runat="server" ImageUrl="../../../Scripts/Calendar/Calendar.JPG" /></td>
            <td class="tLetra3" valign="top">
                Fecha Final&nbsp;</td>
            <td class="tLetra3" valign="top">
                <anthem:TextBox ID="txtFechaFinal" Width="80px" runat="server" CssClass="String"
                    TabIndex="5"></anthem:TextBox>
                <anthem:ImageButton ID="ImgDateFin" runat="server" ImageUrl="../../../Scripts/Calendar/Calendar.JPG" /></td>
        </tr>
        <tr>
            <td class="tLetra3" colspan="4" rowspan="" valign="top">
                &nbsp;&nbsp; Reporte Listado de Ordenes de Compra - Area / Colonia / Sector * Se
                Excluye el reporte sin IVA</td>
        </tr>
        <tr>
            <td class="tLetra3" valign="top" style="height: 23px">
                &nbsp;&nbsp;&nbsp; Obra Inicial</td>
            <td class="tLetra3" valign="top" style="height: 23px">
                <anthem:TextBox ID="txtObraIni" runat="server" AutoCallBack="true" CssClass="String"
                    MaxLength="50" TabIndex="6" Width="90px" OnTextChanged="txtObraIni_TextChanged"></anthem:TextBox>
                <asp:ImageButton runat="server" ID="ImageButton6" OnClientClick="var a = Browse('ctl00_CPHFilters_txtObraIni','ctl00_CPHFilters_hddIntObraIni,ctl00_CPHFilters_txtObraIni,ctl00_CPHFilters_txtObraIniNombre','DACObra','',0,ctl00_CPHFilters_txtEmpresa.value,ctl00_CPHFilters_hddSucursal.value,'8', true,'No hay obras'); if (a != undefined) document.getElementById('ctl00_CPHFilters_txtObraIni').onchange(); return false;" height="17" ImageUrl="../../../Img/ayuda.gif" width="20" ImageAlign="AbsMiddle"/>
                <anthem:TextBox ID="txtObraIniNombre" runat="server" CssClass="tDatosDisable"
                            ReadOnly="True" Width="267px"></anthem:TextBox>
                &nbsp;&nbsp;
            </td>
            <td class="tLetra3" colspan="1" style="height: 23px" valign="top">
                Obra Final</td>
            <td class="tLetra3" valign="top" style="height: 23px">
                <anthem:TextBox ID="txtObraFin" runat="server" OnTextChanged="txtObraFin_TextChanged" AutoCallBack="true" CssClass="String" MaxLength="50" width="90px" TabIndex="7" ></anthem:TextBox>
                <asp:ImageButton runat="server" ID="ImageButton3" OnClientClick="var a = Browse('ctl00_CPHFilters_txtObraFin','ctl00_CPHFilters_hddIntObraFin,ctl00_CPHFilters_txtObraFin,ctl00_CPHFilters_txtObraFinNombre','DACObra','',0,ctl00_CPHFilters_txtEmpresa.value,ctl00_CPHFilters_hddSucursal.value,'8', true,'No hay obras'); if (a != undefined) document.getElementById('ctl00_CPHFilters_txtOCIni').onchange(); return false;" height="17" ImageUrl="../../../Img/ayuda.gif" width="20" ImageAlign="AbsMiddle"/>
                <anthem:TextBox ID="txtObraFinNombre" runat="server"  CssClass="tDatosDisable" width="268px" ReadOnly="True"></anthem:TextBox></td>
        </tr>
        <tr>
            <td class="tLetra3" style="height: 23px" valign="top">
                &nbsp;&nbsp;
                Orden Compra Ini</td>
            <td class="tLetra3" style="height: 23px" valign="top">
                <anthem:TextBox ID="txtOCIni" runat="server" AutoCallBack="true" CssClass="String"
                    MaxLength="50" TabIndex="8" Width="90px" OnTextChanged="txtOCIni_TextChanged"></anthem:TextBox>
                 <asp:ImageButton runat="server" ID="ImageButton1" OnClientClick="var a = Browse('ctl00_CPHFilters_txtOCIni','ctl00_CPHFilters_txtOCIni','DACOrdenCompra','',1,ctl00_CPHFilters_txtEmpresa.value,ctl00_CPHFilters_hddSucursal.value,'8', true,'No hay obras'); if (a != undefined) document.getElementById('ctl00_CPHFilters_txtOCini').onchange(); return false;" height="17" ImageUrl="../../../Img/ayuda.gif" width="20" ImageAlign="AbsMiddle"/></td>
            <td class="tLetra3" colspan="1" style="height: 23px" valign="top">
                Orden Compra Fin</td>
            <td class="tLetra3" style="height: 23px" valign="top">
                <anthem:TextBox ID="txtOCFin" runat="server" AutoCallBack="true" CssClass="String"
                    MaxLength="50" TabIndex="9" Width="90px"></anthem:TextBox>
                <asp:ImageButton runat="server" ID="ImageButton2" OnClientClick="var a = Browse('ctl00_CPHFilters_txtOCFin','ctl00_CPHFilters_txtOCFin','DACOrdenCompra','',1,ctl00_CPHFilters_txtEmpresa.value,ctl00_CPHFilters_hddSucursal.value,'8', true,'No hay obras'); if (a != undefined) document.getElementById('ctl00_CPHFilters_txtAreaIni').focus(); return false;" height="17" ImageUrl="../../../Img/ayuda.gif" width="20" ImageAlign="AbsMiddle"/></td>
        </tr>
        <tr>
            <td class="tLetra3" style="height: 23px" valign="top">
                &nbsp;&nbsp; Area Inicial</td>
            <td class="tLetra3" style="height: 23px" valign="top">
                <anthem:TextBox ID="txtAreaIni" runat="server" AutoCallBack="true" CssClass="String"
                    MaxLength="50" OnTextChanged="txtAreaIni_TextChanged" TabIndex="10" Width="90px"></anthem:TextBox>
               <asp:ImageButton runat="server" ID="ImageButton4" OnClientClick="var a = Browse('ctl00_CPHFilters_txtAreaIni','ctl00_CPHFilters_txtAreaIni,ctl00_CPHFilters_txtAreaIniNombre','DACArea','',1,ctl00_CPHFilters_txtEmpresa.value,ctl00_CPHFilters_hddSucursal.value,'8', true,'No hay obras'); if (a != undefined) document.getElementById('ctl00_CPHFilters_txtAreaFin').onchange(); return false;" height="17" ImageUrl="../../../Img/ayuda.gif" width="20" ImageAlign="AbsMiddle"/>
                <anthem:TextBox ID="txtAreaIniNombre" runat="server" CssClass="tDatosDisable" ReadOnly="True"
                    Width="267px"></anthem:TextBox></td>
            <td class="tLetra3" colspan="1" style="height: 23px" valign="top">
                Area Final</td>
            <td class="tLetra3" style="height: 23px" valign="top">
                <anthem:TextBox ID="txtAreaFin" runat="server" AutoCallBack="true" CssClass="String"
                    MaxLength="50" OnTextChanged="txtAreaFin_TextChanged" TabIndex="11" Width="90px"></anthem:TextBox>
              <asp:ImageButton runat="server" ID="ImageButton9" OnClientClick="var a = Browse('ctl00_CPHFilters_txtAreaFin','ctl00_CPHFilters_txtAreaFin,ctl00_CPHFilters_txtAreaFinNombre','DACArea','',1,ctl00_CPHFilters_txtEmpresa.value,ctl00_CPHFilters_hddSucursal.value,'8', true,'No hay obras'); if (a != undefined) document.getElementById('ctl00_CPHFilters_txtColonia').focus(); return false;" height="17" ImageUrl="../../../Img/ayuda.gif" width="20" ImageAlign="AbsMiddle"/>
                <anthem:TextBox ID="txtAreaFinNombre" runat="server" CssClass="tDatosDisable" ReadOnly="True"
                    Width="267px"></anthem:TextBox></td>
        </tr>
        <tr>
            <td class="tLetra3" style="height: 23px" valign="top">
                &nbsp;&nbsp; Col Inicial</td>
            <td class="tLetra3" style="height: 23px" valign="top">
                <anthem:TextBox ID="txtColonia" runat="server" AutoCallBack="true" CssClass="String"
                    MaxLength="50" OnTextChanged="txtColonia_TextChanged" TabIndex="12" Width="90px"></anthem:TextBox>
                    <asp:ImageButton ID="ImageButton10" runat="server" Height="17" ImageAlign="AbsMiddle" ImageUrl="../../../Img/ayuda.gif"
                        OnClientClick="var a = Browse('ctl00_CPHFilters_txtColonia','ctl00_CPHFilters_txtColonia,ctl00_CPHFilters_txtColoniaNombre','DACPolizaDet','',3,ctl00_CPHFilters_txtEmpresa.value,ctl00_CPHFilters_hddSucursal.value,'8', true,'No hay obras'); if (a != undefined) document.getElementById('ctl00_CPHFilters_txtColonia').onchange(); return false;"
                        Width="20" />
                <anthem:TextBox ID="txtColoniaNombre" runat="server" CssClass="tDatosDisable"
                            ReadOnly="True" Width="267px"></anthem:TextBox></td>
            <td class="tLetra3" colspan="1" style="height: 23px" valign="top">
                Col Final</td>
            <td class="tLetra3" style="height: 23px" valign="top">
                <anthem:TextBox ID="txtColoniaFin" runat="server" AutoCallBack="true" CssClass="String"
                    MaxLength="50" OnTextChanged="txtColoniaFin_TextChanged" TabIndex="13" Width="90px"></anthem:TextBox>
                    <asp:ImageButton                         ID="ImageButton11" runat="server" Height="17" ImageAlign="AbsMiddle" ImageUrl="../../../Img/ayuda.gif"
                        OnClientClick="var a = Browse('ctl00_CPHFilters_txtColoniaFin','ctl00_CPHFilters_txtColoniaFin,ctl00_CPHFilters_txtColoniaNombreFin','DACPolizaDet','',3,ctl00_CPHFilters_txtEmpresa.value,ctl00_CPHFilters_hddSucursal.value,'8', true,'No hay obras'); if (a != undefined) document.getElementById('ctl00_CPHFilters_txtSecIni').focus(); return false;"
                        Width="20" /><anthem:TextBox ID="txtColoniaNombreFin" runat="server" CssClass="tDatosDisable"
                            ReadOnly="True" Width="268px"></anthem:TextBox></td>
        </tr>
        <tr>
            <td class="tLetra3" style="height: 23px" valign="top">
                &nbsp;&nbsp; Sec Inicial</td>
            <td class="tLetra3" style="height: 23px" valign="top">
                <anthem:TextBox ID="txtSecIni" runat="server" AutoCallBack="true" CssClass="String"
                    MaxLength="50" OnTextChanged="txtSecIni_TextChanged" TabIndex="14" Width="90px"></anthem:TextBox>
           <asp:ImageButton runat="server" ID="ImageButton12" OnClientClick="var a = Browse('ctl00_CPHFilters_txtSecIni','ctl00_CPHFilters_txtSecIni,ctl00_CPHFilters_txtSecIniNombre','DACSector','',0,ctl00_CPHFilters_txtEmpresa.value,ctl00_CPHFilters_hddSucursal.value,'8', true,'No hay obras'); if (a != undefined) document.getElementById('ctl00_CPHFilters_txtSecIni').onchange(); return false;" height="17" ImageUrl="../../../Img/ayuda.gif" width="20" ImageAlign="AbsMiddle"/><anthem:TextBox ID="txtSecIniNombre" runat="server" CssClass="tDatosDisable"
                            ReadOnly="True" Width="267px"></anthem:TextBox></td>
            <td class="tLetra3" colspan="1" style="height: 23px" valign="top">
                Sec Final</td>
            <td class="tLetra3" style="height: 23px" valign="top">
                <anthem:TextBox ID="txtSecFin" runat="server" AutoCallBack="true" CssClass="String"
                    MaxLength="50" OnTextChanged="txtSecFin_TextChanged" TabIndex="15" Width="90px"></anthem:TextBox>
                <asp:ImageButton runat="server" ID="ImageButton13" OnClientClick="var a = Browse('ctl00_CPHFilters_txtSecFin','ctl00_CPHFilters_txtSecFin,ctl00_CPHFilters_txtSecFinNombre','DACSector','',0,ctl00_CPHFilters_txtEmpresa.value,ctl00_CPHFilters_hddSucursal.value,'8', true,'No hay obras'); if (a != undefined) document.getElementById('ctl00_CPHFilters_txtSecFin').focus(); return false;" height="17" ImageUrl="../../../Img/ayuda.gif" width="20" ImageAlign="AbsMiddle"/>
                <anthem:TextBox ID="txtSecFinNombre" runat="server" CssClass="tDatosDisable"
                            ReadOnly="True" Width="267px"></anthem:TextBox></td>
        </tr>
    </table>
    <div><anthem:HiddenField ID="hddIntObraIni" runat="server" /><anthem:HiddenField ID="hddIntObraFin" runat="server" />
        &nbsp;&nbsp;</div>
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
                                    OnClick="lknAuxiliarMensualOC_Click" Text="Relacion OC - Factura"></anthem:LinkButton>
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
