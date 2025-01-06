<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="Base.master" CodeFile="CalculoIva.aspx.cs" Inherits="Contabilidad_Compra_Opciones_CalculoIva" culture="es-mx" uiculture="es" %>
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
                &nbsp; Cuenta Bancaria</td>
            <td class="tLetra36" style="height: 23px">
                <anthem:TextBox ID="txtCtaBanc" runat="server" AutoCallBack="true" CssClass="String" TabIndex="4" Width="80px" OnTextChanged="txtCtaBanc_TextChanged"></anthem:TextBox>&nbsp;<anthem:ImageButton
                        ID="ImageButton4" runat="server" Height="17" ImageUrl="../../../Img/ayuda.gif"
                        OnClientClick="var a = Browse('ctl00_CPHBase_txtCtaBanc','ctl00_CPHBase_txtCtaBanc,ctl00_CPHBase_txtCtaBancDes','DACFactura','',18,ctl00_CPHBase_txtEmpresa.value,ctl00_CPHBase_hddSucursal.value,'8', true,'No hay información'); if(a != undefined) document.getElementById('ctl00_CPHBase_txtCtaBanc').onchange(); return false;"
                        Width="20" />
                <anthem:TextBox ID="txtCtaBancDes" runat="server" CssClass="String" Width="300px" TabIndex="5"></anthem:TextBox></td>
            <td class="tLetra3" style="height: 23px">
            </td>
            <td style="height: 23px">
            </td>
        </tr>
        <tr>
            <td class="tLetra3" style="height: 23px">
                &nbsp;&nbsp; Ejercicio:
            </td>
            <td class="tLetra36" style="height: 23px">
                <anthem:DropDownList ID="cboYear" runat="server" AutoCallBack="True" CssClass="String" TabIndex="1" Width="120px">
                </anthem:DropDownList></td>
            <td class="tLetra3" style="height: 23px">
                &nbsp;
            </td>
            <td style="height: 23px">
                <anthem:HiddenField ID="hddClose" runat="server" />
            </td>
        </tr>
        <tr>
            <td class="tLetra3">
                &nbsp;&nbsp; Mes:</td>
            <td class="tLetra36">
                <anthem:DropDownList ID="cboMonth" runat="server" CssClass="String" TabIndex="2"
                    Width="120px">
                </anthem:DropDownList></td>
            <td class="tLetra3">
            </td>
            <td>
            </td>
        </tr>
        <tr>
            <td class="tLetra3" style="height: 23px">
                &nbsp;&nbsp; Fecha Calculo</td>
            <td class="tLetra36" style="height: 23px">
                <anthem:TextBox ID="txtFechaInicial" runat="server" CssClass="String" TabIndex="3"
                    Width="80px"></anthem:TextBox>&nbsp;<anthem:ImageButton ID="ImgDate" runat="server"
                        ImageUrl="../../../Scripts/Calendar/Calendar.JPG" /></td>
            <td class="tLetra3" style="height: 23px">
            </td>
            <td style="height: 23px">
            </td>
        </tr>        
    </table>
    </asp:Content>

   