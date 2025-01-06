<%@ Page Language="C#" MasterPageFile="~/Pages/Contabilidad/Opciones/Base.master"
    AutoEventWireup="true" CodeFile="SaldosIniciales.aspx.cs" Inherits="Pages_Opciones_SaldosIniciales"
    Title="Untitled Page" %>

<%@ Register Assembly="Anthem" Namespace="Anthem" TagPrefix="anthem" %>
<asp:Content ID="Content1" ContentPlaceHolderID="CPHBase" runat="Server">
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <colgroup>
            <col width="12%" />
            <col width="40%" />
            <col width="10%" />
            <col width="38%" />
        </colgroup>
        <tr>
            <td>
                &nbsp;
            </td>
        </tr>
        <tr style="height:20px">
            <td class="tLetra3">
                Empresa:
            </td>
            <td class="tLetra36">
                <anthem:TextBox ID="txtEmpresa" runat="server" CssClass="String" Width="90px" AutoCallBack="true"
                    OnTextChanged="txtEmpresa_TextChange" TabIndex="1" BorderColor="Navy" />
                <anthem:ImageButton runat="server" ID="imgEmpresa" OnClientClick="var a = Browse('ctl00_CPHBase_txtEmpresa','ctl00_CPHBase_txtEmpresa,ctl00_CPHBase_txtNombreEmpresa','DACEmpresa','',1,ctl00_CPHBase_txtEmpresa.value,ctl00_CPHBase_hddSucursal.value,'8', true,'No hay información'); if(a != undefined) document.getElementById('ctl00_CPHBase_txtEmpresa').onchange(); else return false;"
                    Height="17" ImageUrl="../../../Img/ayuda.gif" Width="20" />&nbsp;
                <anthem:TextBox ID="txtNombreEmpresa" runat="server" CssClass="String" Width="300px"
                    ReadOnly="true" BorderColor="Navy" />
                <anthem:HiddenField ID="hddSucursal" runat="server" />
            </td>
            <td class="tLetra3">
                &nbsp;
            </td>
            <td>
                &nbsp;
            </td>
        </tr>        
        <tr style="height:20px">
            <td class="tLetra3" style="width: 191px">
                Cuenta
            </td>
            <td class="tLetra36">
                <anthem:TextBox ID="txtCuenta" runat="server" TabIndex="2" Width="90px" AutoCallBack="true"
                    OnTextChanged="txtCuenta_Change" Style="color: Black; text-align: left; font: 8pt Tahoma;"></anthem:TextBox>
                <anthem:ImageButton runat="server" ID="btnAyudaCuenta" OnClientClick="var a = Browse('ctl00_CPHBase_txtCuenta','ctl00_CPHBase_txtCuenta,ctl00_CPHBase_txtNombreCuenta','DACCuentas','',1,ctl00_CPHBase_txtEmpresa.value,ctl00_CPHBase_hddSucursal.value,'8', true,'No hay Cuentas',1); if(a != undefined) document.getElementById('ctl00_CPHBase_txtCuenta').onchange(); else return false;"
                    Height="17" ImageUrl="../../../Img/ayuda.gif" Width="20" />&nbsp;
                <anthem:TextBox ID="txtNombreCuenta" runat="server" ReadOnly="true" CssClass="String" Width="300px"></anthem:TextBox>
                <anthem:HiddenField ID="hddClaveCuenta" runat="server" />
                <anthem:HiddenField ID="hddCuenta" runat="server" />
            </td>
        </tr>  
        <tr style="height:20px">    
            <td class="tLetra3">
                Ejercicio a Cerrar&nbsp;
            </td>                
            <td class="tLetra3">
                <anthem:DropDownList ID="cboYear" runat="server" CssClass="String" Width="120px" TabIndex="1">
                </anthem:DropDownList>
            </td>
             <td class="tLetra3">
                &nbsp;
            </td>                
           <td class="tLetra3">
               &nbsp;
           </td>               
        </tr>                  
    </table>
    <br />

    <script type="text/javascript" language="javascript">
            var objUtils = new VetecUtils();      	
                	
            function Upper(object)
            {
                object.value = object.value.toUpperCase();
            }


        function ChangeOnEnter(event, target) 
        {
             if (event.keyCode === 13) 
             {
                 document.getElementById(target).focus();
                 return event.keyCode!=13;
             }
         }
         
        function OnlyNumber() 
        {
            var key = window.event.keyCode;
            
            if (key < 48 || key > 57) 
            {
               if(key == 46)
                window.event.keyCode = 46;
               else
               {
                if(key == 45)
                    window.event.keyCode = 45;
                else
                    window.event.keyCode = 0;
               }
            }
            else 
            {                                
               if (key == 13) 
               {
                  window.event.keyCode = 0;
               }
            }
        } 
                				    
            function datosCompletos()
            {
		         return objUtils.validaItems("ctl00_CPHBase_txtEmpresa,ctl00_CPHBase_txtCuenta");
		         
		    } 
                
            function validPrint()
            {
		         return objUtils.validaItems("ctl00_CPHBase_txtCuenta");
            }
                                               
    </script>

</asp:Content>
