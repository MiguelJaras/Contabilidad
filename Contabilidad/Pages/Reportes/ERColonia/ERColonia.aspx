<%@ Page Language="C#" Culture="Auto" UICulture="Auto" AutoEventWireup="true" MasterPageFile="~/Pages/Reportes/Base.master"
    CodeFile="ERColonia.aspx.cs" Inherits="Contabilidad_Compra_Reportes_ER" %>

<%@ Register Assembly="Anthem" Namespace="Anthem" TagPrefix="anthem" %>
    
<asp:Content ID="Content" ContentPlaceHolderID="CPHFilters" runat="Server">
    <script type="text/javascript" language="javascript" src="../../../Scripts/VetecUtils.js"></script>
    <script type="text/javascript" language="javascript" src="../../../Scripts/Validations.js"></script>
    <script type="text/javascript" language="javascript" src="../../../Scripts/popup.js"></script>
    <script type="text/javascript" language="javascript" src="../../../Scripts/VetecText.js"></script>  

    <anthem:HiddenField ID="hddEmpresa" runat="server" />

    <table cellpadding="0" cellspacing="0" width="100%">
        <tr>
            <td colspan="7" style="height: 16px" class="tHead">
                Estado de Resultados por Colonia
            </td>
        </tr>
    </table>
    <br />
    <table>
        <tr>
            <td class="tLetra3" style="height: 23px" valign="top">
                &nbsp;&nbsp; Colonia</td>
            <td class="tLetra3" style="height: 23px" valign="top">
                <anthem:TextBox ID="txtColonia" runat="server" AutoCallBack="true" CssClass="String"
                    MaxLength="50" OnTextChanged="txtColonia_TextChanged" TabIndex="12" Width="150px"></anthem:TextBox>
                

                       <anthem:ImageButton runat="server" ID="ImageButton25" OnClientClick="var a = JBrowse('ctl00_CPHFilters_txtColonia','ctl00_CPHFilters_txtColonia,ctl00_CPHFilters_txtColoniaNombre','DACPolizaDet','',3,0,0,'8', true,'No hay información',function(){document.getElementById('ctl00_CPHFilters_txtColonia').onchange(); },0); "
                    Height="18px" ImageUrl="../../../Img/ayuda.gif" Width="20" ImageAlign="AbsMiddle" />

                <anthem:TextBox ID="txtColoniaNombre" runat="server" CssClass="tDatosDisable"
                            ReadOnly="True" Width="267px"></anthem:TextBox></td>
        </tr>
        <tr>
            <td class="tLetra3" style="height: 23px" valign="top">
                &nbsp;&nbsp; Sector</td>
            <td class="tLetra3" style="height: 23px" valign="top">
                <anthem:TextBox ID="txtSector" runat="server" AutoCallBack="true" CssClass="String"
                    MaxLength="50" OnTextChanged="txtSector_TextChanged" TabIndex="14" Width="150px"></anthem:TextBox>
                

                       <anthem:ImageButton runat="server" ID="ImageButton26" OnClientClick="var a = JBrowse('ctl00_CPHFilters_txtSector','ctl00_CPHFilters_txtSector,ctl00_CPHFilters_txtSectorNombre','DACSector','ctl00_CPHFilters_txtColonia',1,0,0,'8', true,'No hay información',function(){document.getElementById('ctl00_CPHFilters_txtSector').onchange(); },0); "
                    Height="18px" ImageUrl="../../../Img/ayuda.gif" Width="20" ImageAlign="AbsMiddle" />

                <anthem:TextBox ID="txtSectorNombre" runat="server" CssClass="tDatosDisable"
                            ReadOnly="True" Width="267px"></anthem:TextBox></td>
        </tr>
        <tr>
            <td class="tLetra3" colspan="3" valign="top">
                 &nbsp;&nbsp;&nbsp;<asp:CheckBox ID="chkResumen" runat="server" TabIndex="10" Text="Resumen" />     
            </td>
        </tr>
        <tr>
            <td class="tLetra3" colspan="3" valign="top">
                 &nbsp;&nbsp;&nbsp;<asp:CheckBox ID="chkAditiva" runat="server" TabIndex="10" Text="Aditiva" />     
            </td>
        </tr>
    </table>
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
                                <anthem:LinkButton ID="lknEstadoResultados" runat="server" AutoUpdateAfterCallBack="true"
                                    OnClientClick="return Validaciones();" OnClick="lknEstadoResultados_Click"  Text="Estado de Resultados"></anthem:LinkButton>
                            </td>
                        </tr>
                    </table>
                </asp:Panel>
            </td>
        </tr>
    </table>

    <script type="text/javascript" language="javascript">


        //var hddEmpresa = document.getElementById("hddEmpresa").value;
        //  OnClientClick="Validaciones()"  OnClick="lknEstadoResultados_Click"

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

        function Validaciones()
        {
            var sector = document.getElementById('<%= txtSector.ClientID %>').value.trim();
            var colonia = document.getElementById('<%= txtColonia.ClientID %>').value.trim();
           

            if (!colonia) {
                alert("Favor de ingresar Colonia");
                document.all('ctl00_CPHFilters_txtColonia').focus();
                return false;
            }
            if (!sector) {
                alert("Favor de ingresar Sector");
                document.all('ctl00_CPHFilters_txtSector').focus();
                return false;
            }
            
            return true;
        }
    </script>

</asp:Content>
