<%@ Page Language="C#" MasterPageFile="~/Pages/Contabilidad/Opciones/Base.master"
    AutoEventWireup="true" CodeFile="IvaDesglosado.aspx.cs" Inherits="Pages_Opciones_IvaDesglosado"
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

                       <anthem:ImageButton runat="server" ID="ImageButton6" OnClientClick="var a = JBrowse('ctl00_CPHBase_txtEmpresa','ctl00_CPHBase_txtEmpresa,ctl00_CPHBase_txtNombreEmpresa','DACEmpresa','',1,ctl00_CPHBase_txtEmpresa.value,ctl00_CPHBase_hddSucursal.value,'8', true,'No hay información',function(){document.getElementById('ctl00_CPHBase_txtEmpresa').onchange(); },0); "
                    Height="18px" ImageUrl="../../../Img/ayuda.gif" Width="20" ImageAlign="AbsMiddle" />

                &nbsp;
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
            <td class="tLetra3" style="height: 23px">
                Ejercicio</td>                
            <td class="tLetra3" style="height: 23px">
                <anthem:DropDownList ID="cboYear" runat="server" CssClass="String" Width="120px" TabIndex="1">
                </anthem:DropDownList>
            </td>
             <td class="tLetra3" style="height: 23px">
                &nbsp;
            </td>                
           <td class="tLetra3" style="height: 23px">
               &nbsp;
           </td>               
        </tr>                  
        <tr style="height: 20px">
            <td class="tLetra3" style="height: 22px">
                Mes</td>
            <td class="tLetra3" style="height: 22px">
                <anthem:DropDownList ID="cboMes" runat="server" CssClass="String" Width="120px" TabIndex="1">
                    <asp:ListItem Value="0">-- Seleccione --</asp:ListItem>
                    <asp:ListItem Value="1">Enero</asp:ListItem>
                    <asp:ListItem Value="2">Febrero</asp:ListItem>
                    <asp:ListItem Value="3">Marzo</asp:ListItem>
                    <asp:ListItem Value="4">Abril</asp:ListItem>
                    <asp:ListItem Value="5">Mayo</asp:ListItem>
                    <asp:ListItem Value="6">Junio</asp:ListItem>
                    <asp:ListItem Value="7">Julio</asp:ListItem>
                    <asp:ListItem Value="8">Agosto</asp:ListItem>
                    <asp:ListItem Value="9">Septiembre</asp:ListItem>
                    <asp:ListItem Value="10">Octubre</asp:ListItem>
                    <asp:ListItem Value="11">Noviembre</asp:ListItem>
                    <asp:ListItem Value="12">Diciembre</asp:ListItem>
                </anthem:DropDownList>
            </td>
            <td class="tLetra3" style="height: 22px">
            </td>
            <td class="tLetra3" style="height: 22px">
            </td>
        </tr>
        <tr style="height: 20px">
            <td class="tLetra3" style="height: 23px">
                Cheque Num.</td>
            <td class="tLetra3" style="height: 23px">
                <anthem:TextBox ID="txtCheque" runat="server" OnTextChanged="txtCheque_TextChanged" AutoPostBack="True"></anthem:TextBox></td>
            <td class="tLetra3" style="height: 23px">
            </td>
            <td class="tLetra3" style="height: 23px">
            </td>
        </tr>
        <tr style="height: 20px">
            <td class="tLetra3" style="height: 23px">
            </td>
            <td class="tLetra3" style="height: 23px"><anthem:HiddenField ID="hddPoliza" runat="server" />
            </td>
            <td class="tLetra3" style="height: 23px">
            </td>
            <td class="tLetra3" style="height: 23px">
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
		         return objUtils.validaItems("ctl00_CPHBase_txtEmpresa,ctl00_CPHBase_cboYear,ctl00_CPHBase_cboMes,ctl00_CPHBase_txtCheque");
		         
		    } 
                
            function validPrint()
            {
		         return objUtils.validaItems("ctl00_CPHBase_txtCuenta");
            }
                                               
    </script>

</asp:Content>
