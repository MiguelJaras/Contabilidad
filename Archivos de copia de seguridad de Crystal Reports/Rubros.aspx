<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="Base.master" CodeFile="Rubros.aspx.cs" Inherits="Contabilidad_Compra_Opciones_Rubros" Culture="auto" UICulture="auto" %>
<%@ Register Assembly="Anthem" Namespace="Anthem" TagPrefix="anthem" %>
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
               return objUtils.validaItems("ctl00_CPHBase_txtEmpresa,ctl00_CPHBase_txtRubro,ctl00_CPHBase_txtNombre,ctl00_CPHBase_txtNombreCorto,ctl00_CPHBase_cboSigno,ctl00_CPHBase_txtAtrib");

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
                    CssClass="String" OnTextChanged="txtEmpresa_TextChange" Width="80px"></anthem:TextBox>
                <anthem:ImageButton
                        ID="ImageButton7" runat="server" Height="17" ImageUrl="../../../Img/ayuda.gif"
                        OnClientClick="var a = Browse('ctl00_CPHBase_txtEmpresa','ctl00_CPHBase_txtEmpresa,ctl00_CPHBase_txtNombreEmpresa','DACEmpresa','',1,ctl00_CPHBase_txtEmpresa.value,ctl00_CPHBase_hddSucursal.value,'8', true,'No hay información'); if(a != undefined) document.getElementById('ctl00_CPHBase_txtEmpresa').onchange(); else return false;"
                        Width="20" />
                <anthem:TextBox ID="txtNombreEmpresa" runat="server" BorderColor="Navy"
                            CssClass="String" ReadOnly="true" Width="300px"></anthem:TextBox><anthem:HiddenField
                                ID="hddSucursal" runat="server" />
            </td>
            <td class="tLetra3">
                &nbsp;
            </td>
            <td>
                &nbsp;
            </td>
        </tr>
        <tr>
            <td class="tLetra3" style="height: 23px">
                &nbsp;&nbsp; Rubro:
            </td>
            <td class="tLetra36" style="height: 23px">
                <anthem:TextBox ID="txtRubro" runat="server" AutoCallBack="true" CssClass="String" TabIndex="1" Width="80px" OnTextChanged="txtRubro_TextChanged"></anthem:TextBox>
                <anthem:ImageButton ID="ImageButton2" runat="server" Height="17" ImageUrl="../../../Img/ayuda.gif" OnClientClick="var a = Browse('ctl00_CPHBase_txtRubro','ctl00_CPHBase_txtRubro,ctl00_CPHBase_txtNombre','DACRubros','',0,ctl00_CPHBase_txtEmpresa.value,ctl00_CPHBase_hddSucursal.value,'8', true,'No hay información'); if(a != undefined) document.getElementById('ctl00_CPHBase_txtRubro').onchange(); return false;" Width="20" /></td>
            <td class="tLetra3" style="height: 23px">
                &nbsp;
            </td>
            <td style="height: 23px">
                &nbsp;
            </td>
        </tr>
        <tr>
            <td class="tLetra3" style="height: 23px">
                &nbsp;&nbsp; Nombre:</td>
            <td class="tLetra36" style="height: 23px">
                <anthem:TextBox ID="txtNombre" runat="server" CssClass="String" TabIndex="2" Width="300px"></anthem:TextBox></td>
            <td class="tLetra3" style="height: 23px">
            </td>
            <td style="height: 23px">
            </td>
        </tr>
        <tr>
            <td class="tLetra3">
                &nbsp;&nbsp; Nombre Corto:</td>
            <td class="tLetra36">
                <anthem:TextBox ID="txtNombreCorto" runat="server" CssClass="String" TabIndex="3" Width="300px"></anthem:TextBox></td>
            <td class="tLetra3">
            </td>
            <td>
            </td>
        </tr>
        <tr>
            <td class="tLetra3" style="height: 23px">
                &nbsp;&nbsp; Atributo Impr:</td>
            <td class="tLetra36" style="height: 23px">
                <anthem:DropDownList ID="cboRubrosTipos" runat="server" AutoCallBack="True" CssClass="String" TabIndex="6" Width="152px">
                </anthem:DropDownList>
            </td>
            <td class="tLetra3" style="height: 23px">
            </td>
            <td style="height: 23px">
            </td>
        </tr>        
        <tr>
            <td class="tLetra3" style="height: 23px">
                &nbsp;&nbsp; Signo Aritmético</td>
            <td class="tLetra36" style="height: 23px">
                <anthem:DropDownList ID="cboSigno" runat="server" CssClass="String" TabIndex="6" Width="152px">
                    <asp:ListItem Value="0">-- Seleccione --</asp:ListItem>
                    <asp:ListItem Value="1">+</asp:ListItem>
                    <asp:ListItem Value="2">-</asp:ListItem>
                </anthem:DropDownList></td>
            <td class="tLetra3" style="height: 23px">
            </td>
            <td style="height: 23px">
            </td>
        </tr>
        <tr>
            <td class="tLetra3" style="height: 23px">
                &nbsp;&nbsp; Ind Cambia Signo:
            </td>
            <td class="tLetra3" style="height: 23px">
                &nbsp;<anthem:RadioButton ID="rbNo" runat="server" Text="No" ValidationGroup="signo" Checked="True" TabIndex="4" GroupName="signo" />
                &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp;
                <anthem:RadioButton ID="rbSi" runat="server" Text="Sí" ValidationGroup="signo" TabIndex="5" GroupName="signo" /></td>
            <td class="tLetra3" style="height: 23px">
            </td>
            <td style="height: 23px">
            </td>
        </tr>        
    </table>
    </asp:Content>

   