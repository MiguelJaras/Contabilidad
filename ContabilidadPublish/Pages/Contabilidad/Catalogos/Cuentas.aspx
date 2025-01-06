<%@ Page Language="C#" MasterPageFile="~/Pages/Contabilidad/Catalogos/Base.master"
    AutoEventWireup="true" CodeFile="Cuentas.aspx.cs" Inherits="Pages_Compras_Catalogos_Cuentas"
    Title="Untitled Page" %>

<%@ Register Assembly="Anthem" Namespace="Anthem" TagPrefix="anthem" %>
<asp:Content ID="Content1" ContentPlaceHolderID="CPHBase" runat="Server">
    <table width="100%" border="0" cellspacing="0" cellpadding="0" style="border-color: Silver;
        border-width: 1px;">
        <tr>
            <td>
                &nbsp;
                <anthem:TextBox ID="txtRowEdit" runat="server" AutoCallBack="true" OnTextChanged="txtRowEdit_Change"
                    Style="display: none;"></anthem:TextBox>
            </td>
        </tr>
    </table>
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <colgroup>
            <col width="12%" />
            <col width="40%" />
            <col width="10%" />
            <col width="38%" />
        </colgroup>
        <tr>
            <td class="tLetra3">
                Empresa:
            </td>
            <td class="tLetra36">
                <anthem:TextBox ID="txtEmpresa" runat="server" CssClass="String" Width="90px" AutoCallBack="true"
                    OnTextChanged="txtEmpresa_TextChange" TabIndex="1" BorderColor="Navy" />

                <anthem:ImageButton runat="server" ID="imgEmpresa" OnClientClick="var a = Browse('ctl00$CPHBase$txtEmpresa','ctl00$CPHBase$txtEmpresa,ctl00$CPHBase$txtNombreEmpresa','DACEmpresa','',1,ctl00$CPHBase$txtEmpresa.value,ctl00$CPHBase$hddSucursal.value,'8', true,'No hay información'); if(a != undefined) document.getElementById('ctl00$CPHBase$txtEmpresa').onchange(); else return false;"
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
        <tr>
            <td class="tLetra3" style="width: 191px">
                Cuenta
            </td>
            <td class="tLetra36">
                <anthem:TextBox ID="txtCuenta" runat="server" TabIndex="2" Width="90px" AutoCallBack="true"
                    OnTextChanged="txtCuenta_Change" Style="color: Black; text-align: left; font: 8pt Tahoma;"></anthem:TextBox>
                <anthem:ImageButton runat="server" ID="btnAyudaCuenta" OnClientClick="var a = Browse('ctl00_CPHBase_txtCuenta','ctl00_CPHBase_hddCuenta,ctl00_CPHBase_hddClaveCuenta','DACCuentas','',1,ctl00_CPHBase_txtEmpresa.value,ctl00_CPHBase_hddSucursal.value,'8', true,'No hay Cuentas',1); if(a != undefined) document.getElementById('ctl00_CPHBase_txtCuenta').onchange(); else return false;"
                    Height="17" ImageUrl="../../../Img/ayuda.gif" Width="20" />&nbsp;
                <anthem:TextBox ID="txtNombreCuenta" Visible="false" runat="server"
                    CssClass="tDatosDisable" ReadOnly="true" Width="250px"></anthem:TextBox>
                <anthem:HiddenField ID="hddClaveCuenta" runat="server" />
                <anthem:HiddenField ID="hddCuenta" runat="server" />
            </td>
        </tr>
        <tr>
            <td class="tLetra3" style="width: 191px">
                Codigo Agrupador</td>
            <td class="tLetra36">
                <anthem:TextBox ID="txtCodigoAgrupador" runat="server" Width="90px"  Style="color: Black; text-align: left; font: 8pt Tahoma;"></anthem:TextBox>
            </td>
        </tr>
        <tr>
            <td class="tLetra3" style="width: 191px">
                Nombre
            </td>
            <td class="tLetra36">
                <anthem:TextBox ID="txtNombre" runat="server" TabIndex="3" Width="275px"  
                    Style="color: Black; text-align: left; font: 8pt Tahoma;"></anthem:TextBox>
            </td>
            <td style="width: 14%">
            </td>
        </tr>
        <tr>
            <td class="tLetra3" style="width: 191px; height: 21px;">
                Nombre Corto
            </td>
            <td class="tLetra36" style="height: 21px">
                <anthem:TextBox ID="txtNombreCorto" runat="server" TabIndex="4" Width="275px" 
                    Style="color: Black; text-align: left; font: 8pt Tahoma;"></anthem:TextBox>
            </td>
        </tr>
        <tr>
            <td class="tLetra3" style="width: 191px">
                Tipo Grupo Contable:
            </td>
            <td class="tLetra36">
                <anthem:DropDownList ID="cboTipoGrupoContable" runat="server" CssClass="String" Width="250px" TabIndex="5">
                </anthem:DropDownList>
            </td>
        </tr>
        <tr>
            <td class="tLetra3" style="width: 191px">
                Naturaleza:
            </td>
            <td class="tLetra36">
                <anthem:DropDownList ID="cboNaturaleza" runat="server" CssClass="String" Width="250px" TabIndex="5">
                </anthem:DropDownList>
            </td>
        </tr>        
        <tr>
            <td class="tLetra3" style="width: 191px">
                Auxiliar:
            </td>
            <td class="tLetra36">
                 <anthem:CheckBox ID="chkAuxiliar" runat="server" TabIndex="7" />
            </td>
        </tr>  
        <tr>
            <td class="tLetra3" style="width: 191px">
                Cuenta Registro:
            </td>
            <td class="tLetra36">
                 <anthem:CheckBox ID="chkRegistro" runat="server" TabIndex="8" />
            </td>
        </tr>
         <tr>
            <td class="tLetra3" style="width: 191px">
                Activo:
            </td>
            <td class="tLetra36">
                 <anthem:CheckBox ID="chkActivo" runat="server" TabIndex="8" />
            </td>
        </tr>              
    </table>
    <br />
    <table width="100%" style="display: none;">
        <tr>
            <td>
                <div id="div-ListPanel">
                    C</div>
            </td>
        </tr>
    </table>
       <br />
    <table width="100%" style="display: none;">
        <tr>
            <td>
                <div id="div1">
                    <anthem:GridView ID="grdDet" runat="server" Width="98%" AutoGenerateColumns="False"
                        EmptyDataText="No han agregado partidas" HeaderStyle-CssClass="dxgvHeader_PlasticBlue"
                        DataKeyNames="strCuenta" OnRowDeleting="DgrdList_RowDeleting" OnRowCreated="DgrdList_RowCreated"
                        RowStyle-CssClass="GridViewRow" CssClass="dxgvTable_Aqua" CellPadding="0" GridLines="None" OnSelectedIndexChanged="grdDet_SelectedIndexChanged">
                        <Columns>
                            <asp:BoundField DataField="strCuenta" HeaderText="Cuenta">
                                <itemstyle horizontalalign="Center" width="80px" />
                            </asp:BoundField>
                            <asp:BoundField DataField="intEmpresa" HeaderText="Empresa" Visible="False">
                                <itemstyle horizontalalign="Center" width="90px" />
                            </asp:BoundField>
                            <asp:BoundField DataField="strNombre" HeaderText="Nombre">
                                <itemstyle horizontalalign="Center" width="80px" />
                            </asp:BoundField>
                            <asp:BoundField DataField="strNombreCorto" HeaderText="Nombre Corto">
                                <itemstyle horizontalalign="Center" width="80px" />
                            </asp:BoundField>
                            <asp:BoundField DataField="intNivel" HeaderText="Nivel" Visible="False">
                                <itemstyle horizontalalign="Center" width="20px" />
                            </asp:BoundField>
                            <asp:BoundField DataField="Tipo_GrupoContable" HeaderText="Nom. Tipo Gpo">
                                <itemstyle horizontalalign="Center" width="90px" />
                            </asp:BoundField>
                            <asp:BoundField DataField="GrupoContable" HeaderText="Nom. Gpo" Visible="False">
                                <itemstyle horizontalalign="Center" width="90px" />
                            </asp:BoundField>
                            <asp:CheckBoxField DataField="Auxiliar" HeaderText="Auxiliar">
                                <itemstyle horizontalalign="Center" width="40px" />
                            </asp:CheckBoxField>
                            <asp:TemplateField ShowHeader="False">
                                <itemtemplate>
		                            <asp:ImageButton runat="server" ImageUrl="~/Img/Delete.gif"  onclientClick="javascript:return confirm('¿Desea eliminar la partida?');" CommandName="Delete" CausesValidation="False" ImageAlign="Middle" id="lknDelete"></asp:ImageButton>		                        
                                </itemtemplate>
                                <itemstyle horizontalalign="Center" width="20px" />
                            </asp:TemplateField>
                        </Columns>
                        <HeaderStyle CssClass="dxgvHeader_PlasticBlue" />
                        <RowStyle CssClass="GridViewRow" />
                    </anthem:GridView>
                </div>
            </td>
        </tr>
    </table>
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
         
        
                				    
            function datosCompletos()
            {
		         return objUtils.validaItems("ctl00_CPHBase_txtCuenta,ctl00_CPHBase_txtNombre,ctl00_CPHBase_txtNombreCorto");
		         
		    } 
                
            function validPrint()
            {
		         return objUtils.validaItems("ctl00_CPHBase_txtCuenta");
            }


            function KeyPressOnlyDecimal(field, ent, dec) {
                var e = window.event;
                var key = e.keyCode;
                var value = field.value;
                var bool;

                // permitimos el backspace
                if (key == 8) return true
                // permitimos del 0-9
                if (key > 47 && key < 58 || key == 46 || key == 45) {
                    //No permitimos un punto al inicio del control.
                    if (value == "" && key == 46) window.event.keyCode = 0;
                    //dejamos que el primer campo este vacio.
                    if (value == "") return true

                    for (i = 0; i < value.length; i++) {
                        //Revisamos si existe un punto.
                        if (value.substring(i, i + 1) == ".") {
                            bool = 1;
                            break;
                        }
                        else {
                            bool = 0;
                        }
                    }



                    //Revisamos cuando se ingresa un punto.                     

                    if (key == 46) {

                        bool = 1;

                        for (i = 0; i < value.length; i++) {

                            if (value.substring(i, i + 1) == ".") {

                                //Si existe un punto, no permitimos otro.

                                window.event.keyCode = 0;

                            }

                        }

                    }

                    else {

                        var size = ent + (dec + 1); //Octenemos el largo de la cadena de enteros + decimales y el punto.

                        var position;



                        for (i = 0; i < value.length; i++) {

                            if (value.substring(i, i + 1) == ".") {

                                //Si existe un punto, no permitimos otro.

                                position = i + 1;

                            }

                        }



                        var point = value.length - position;



                        if (point == 6)

                            window.event.keyCode = 0;



                        if (value.length >= ent && bool == 0) {

                            //Si no contiene deciamles y el tamaño de la cadena es mayor al establecido, no lo permitimos.

                            window.event.keyCode = 0;

                        }

                        if (value.length == size && bool == 1) {

                            //Si contiene decimales y esta fuera del limite permitido de enteros + decimales, no lo permitimos.

                            window.event.keyCode = 0;

                        }

                    }

                    return true;

                }



                // other key

                window.event.keyCode = 0;

            }



                                               
    </script>

</asp:Content>
