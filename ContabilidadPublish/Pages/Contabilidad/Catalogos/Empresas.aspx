<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="Base.master" CodeFile="Empresas.aspx.cs" Inherits="Contabilidad_Compra_Opciones_Empresas" Culture="auto" UICulture="auto" %>
<%@ Register Assembly="Anthem" Namespace="Anthem" TagPrefix="anthem" %>
<%@ Register Assembly="DevExpress.Web.ASPxEditors.v8.3" Namespace="DevExpress.Web.ASPxEditors"
    TagPrefix="dxe" %>
<%@ Register Assembly="DevExpress.Web.ASPxEditors.v8.3, Version=8.3.4.0, Culture=neutral, PublicKeyToken=5377C8E3B72B4073"
    Namespace="DevExpress.Web.ASPxEditors" TagPrefix="dxe" %>

<asp:Content ID="Content" ContentPlaceHolderID="CPHBase" Runat="Server">      
	  <table width="100%" border="0" cellspacing="0" cellpadding="0" style="border-color:Silver; border-width:1px;">                       
           <tr>
                <td>
                    &nbsp;
                    <anthem:TextBox ID="txtRowEdit" runat="server" AutoCallBack="true" style="display:none;"  ></anthem:TextBox>&nbsp;
                    <anthem:TextBox ID="txtEmpleadoInt" runat="server" AutoCallBack="true" Style="display: none"></anthem:TextBox></td>
           </tr>     
        </table>
         <script type="text/javascript" language="javascript">
            var objUtils = new VetecUtils();      	
                				    
            function datosCompletos()
            {
               return objUtils.validaItems("ctl00_CPHBase_txtEmpresa");

            }                                 
                                                                                  
         </script>        

    <table border="0" cellpadding="0" cellspacing="0" width="100%">
        <colgroup>
            <col width="12%" />
            <col width="40%" />
            <col width="10%" />
            <col width="38%" />
        </colgroup>
        <tr>
            <td class="tLetra3">
                &nbsp; &nbsp;Empresa:
            </td>
            <td class="tLetra36">
                <anthem:TextBox ID="txtEmpresa" runat="server" AutoCallBack="true" BorderColor="Navy"
                    CssClass="String" OnTextChanged="txtEmpresa_TextChange" Width="80px" TabIndex="1"></anthem:TextBox>
                <anthem:ImageButton
                        ID="ImageButton7" runat="server" Height="17" ImageUrl="../../../Img/ayuda.gif"
                        OnClientClick="var a = Browse('ctl00_CPHBase_txtEmpresa','ctl00_CPHBase_txtEmpresa,ctl00_CPHBase_txtNombre','DACEmpresa','',1,'0','0','8', true,'No hay información'); if(a != undefined) document.getElementById('ctl00_CPHBase_txtEmpresa').onchange(); else return false;"
                        Width="20" />&nbsp;
            </td>
            <td class="tLetra3">
                </td>
            <td>
                </td>
        </tr>
        <tr>
            <td class="tLetra3" style="height: 23px">
                &nbsp;&nbsp; Nombre:</td>
            <td class="tLetra36" style="height: 23px">
                <anthem:TextBox ID="txtNombre" runat="server" CssClass="String" TabIndex="3" Width="412px"></anthem:TextBox></td>
            <td class="tLetra3" style="height: 23px">
                Estado:</td>
            <td style="height: 23px">
                <anthem:TextBox ID="txtEstado" runat="server" AutoCallBack="true" CssClass="String" TabIndex="10" Width="80px" OnTextChanged="txtEstado_TextChanged"></anthem:TextBox>
                <anthem:ImageButton ID="ImageButton1" runat="server" Height="17" ImageUrl="../../../Img/ayuda.gif" OnClientClick="var a = Browse('ctl00_CPHBase_txtEstado','ctl00_CPHBase_txtEstado,ctl00_CPHBase_txtEstadoDes','DACEmpresa','',2,'0','0','8', true,'No hay información'); if(a != undefined) document.getElementById('ctl00_CPHBase_txtNombreCorto').focus(); return false;" Width="20" />
                <anthem:TextBox ID="txtEstadoDes" runat="server" CssClass="String" Enabled="False" TabIndex="11" Width="300px">
                </anthem:TextBox>
            </td>
        </tr>
        <tr>
            <td class="tLetra3">
                &nbsp;&nbsp; Nombre Corto:</td>
            <td class="tLetra36">
                <anthem:TextBox ID="txtNombreCorto" runat="server" CssClass="String" TabIndex="4" Width="412px"></anthem:TextBox></td>
            <td class="tLetra3">
                RFC:</td>
            <td>
                <anthem:TextBox ID="txtRFC" runat="server" CssClass="String" TabIndex="12" Width="412px"></anthem:TextBox></td>
        </tr>
        <tr>
            <td class="tLetra3" style="height: 23px">
                &nbsp;&nbsp; Direccion:</td>
            <td class="tLetra36" style="height: 23px">
                <anthem:TextBox ID="txtDireccion" runat="server" CssClass="String" TabIndex="5" Width="412px"></anthem:TextBox></td>
            <td class="tLetra3" style="height: 23px">
                Reg. IMSS:</td>
            <td style="height: 23px">
                <anthem:TextBox ID="txtIMSS" runat="server" CssClass="String" TabIndex="13" Width="412px"></anthem:TextBox></td>
        </tr>
        <tr>
            <td class="tLetra3">
                &nbsp;&nbsp; Colonia:</td>
            <td class="tLetra36">
                <anthem:TextBox ID="txtColonia" runat="server" CssClass="String" TabIndex="6" Width="412px"></anthem:TextBox></td>
            <td class="tLetra3">
                Cód. Postal:</td>
            <td>
                <anthem:TextBox ID="txtCP" runat="server" CssClass="String" TabIndex="14" Width="412px"></anthem:TextBox></td>
        </tr>
        <tr>
            <td class="tLetra3">
                &nbsp;&nbsp; Tipo Moneda
            </td>
            <td class="tLetra36">
                <anthem:DropDownList ID="cboMoneda" runat="server" CssClass="tDatos150" Width="200px" /> 
            </td>
            <td class="tLetra3">
                Responsable:
            </td>
            <td>
                <anthem:TextBox ID="txtRes" runat="server" CssClass="String" TabIndex="15" Width="412px">
                </anthem:TextBox>
            </td>
        </tr>
        <tr>
            <td class="tLetra3" style="height: 22px">
                &nbsp;&nbsp; 
                Delegación:
            </td>
            <td class="tLetra36" style="height: 22px">
                <anthem:TextBox ID="txtDelegacion" runat="server" CssClass="String" TabIndex="9" Width="412px">
                </anthem:TextBox>
            </td>
            <td class="tLetra3" style="height: 22px">
                RFC Responsable:</td>
            <td style="height: 22px">
                <anthem:TextBox ID="txtRFCRes" runat="server" CssClass="String" TabIndex="16" Width="412px">
                </anthem:TextBox>
            </td>
        </tr>        
    </table>
    </asp:Content>

   