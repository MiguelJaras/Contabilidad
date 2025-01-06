<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="Base.master" CodeFile="AfectacionSaldos.aspx.cs" Inherits="Contabilidad_Compra_Opciones_AfectacionSaldos" Culture="auto" UICulture="auto" %>
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
               return objUtils.validaItems("ctl00_CPHBase_txtEmpresa,ctl00_CPHBase_txtCtaBanc");

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
                        OnClientClick="var a = Browse('ctl00_CPHFilters_txtEmpresa','ctl00_CPHFilters_txtEmpresa,ctl00_CPHFilters_txtNombreEmpresa','DACEmpresa','',1,ctl00_CPHFilters_txtEmpresa.value,ctl00_CPHFilters_hddSucursal.value,'8', true,'No hay información'); if(a != undefined) document.getElementById('ctl00_CPHFilters_txtEmpresa').onchange(); else return false;"
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
                &nbsp;&nbsp; Fecha Poliza</td>
            <td class="tLetra36" style="height: 23px">
                <anthem:TextBox ID="txtFechaInicial" runat="server" CssClass="String" TabIndex="3"
                    Width="80px"></anthem:TextBox>&nbsp;<anthem:ImageButton ID="ImgDate" runat="server"
                        ImageUrl="../../../Scripts/Calendar/Calendar.JPG" /></td>
            <td class="tLetra3" style="height: 23px">
            </td>
            <td style="height: 23px">
            </td>
        </tr>
        <tr>
            <td class="tLetra3" style="height: 23px">
                &nbsp; Archivo</td>
            <td class="tLetra36" style="height: 23px">
                                            <asp:FileUpload ID="fuArchivo" runat="server" CssClass="FileUpload" Width="413px" /><asp:RequiredFieldValidator ID="rfvArchivo" runat="server" ControlToValidate="fuArchivo"
                                                Display="Static" ErrorMessage="Debe seleccionar un Archivo">
                                     *
                                     </asp:RequiredFieldValidator></td>
            <td class="tLetra3" style="height: 23px">
                                            <asp:ValidationSummary ID="ValidationSummary1" runat="server" ShowMessageBox="True"
                                                ShowSummary="False" />
            </td>
            <td style="height: 23px">
            </td>
        </tr>
        <tr>
            <td class="tLetra3" style="height: 23px">
            </td>
            <td class="tLetra36" style="height: 23px">
            </td>
            <td class="tLetra3" style="height: 23px">
            </td>
            <td style="height: 23px">
            </td>
        </tr>
    </table>
    </asp:Content>

   