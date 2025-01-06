<%@ Page Language="C#" MasterPageFile="~/Pages/Contabilidad/Catalogos/Base.master"
    AutoEventWireup="true" CodeFile="EstructuraPolizas.aspx.cs" Inherits="Pages_Inventarios_Opciones_EstructuraPolizas"
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
            <td class="tLetra3">
                <anthem:TextBox ID="txtEmpresa" runat="server" CssClass="String" Width="80px" AutoCallBack="true"
                    OnTextChanged="txtEmpresa_TextChange" TabIndex="1" BorderColor="Navy" ondblclick="var a = Browse('ctl00_CPHBase_txtEmpresa','ctl00_CPHBase_txtEmpresa,ctl00_CPHBase_txtNombreEmpresa','DACEmpresa','',1,ctl00_CPHBase_txtEmpresa.value,ctl00_CPHBase_hddSucursal.value,'8', true,'No hay información'); if(a != undefined) document.getElementById('ctl00_CPHBase_txtEmpresa').onchange(); else return false;" />
                <anthem:ImageButton runat="server" ID="imgEmpresa" OnClientClick="var a = Browse('ctl00_CPHBase_txtEmpresa','ctl00_CPHBase_txtEmpresa,ctl00_CPHBase_txtNombreEmpresa','DACEmpresa','',1,ctl00_CPHBase_txtEmpresa.value,ctl00_CPHBase_hddSucursal.value,'8', true,'No hay información'); if(a != undefined) document.getElementById('ctl00_CPHBase_txtEmpresa').onchange(); else return false;"
                    Height="17" ImageUrl="../../../Img/ayuda.gif" Width="20" />
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
            <td class="tLetra3">
                Tipo Movto:
            </td>
            <td class="tLetra3" valign="middle" style="width: 600px; height: 25px">
                <anthem:TextBox ID="txtMovTo" runat="server" TabIndex="3" Width="80px" CssClass="String" ondblclick="var a = Browse('ctl00_CPHBase_txtMovTo','','DACEstructuraPolizaEnc','',1,ctl00_CPHBase_txtEmpresa.value,ctl00_CPHBase_hddSucursal.value,'8', true,'No hay Tipos de Movimiento',1); if(a != undefined) document.getElementById('ctl00_CPHBase_txtMovTo').onchange(); else return false;"
                    AutoCallBack="true" OnTextChanged="txtMovTo_Change"></anthem:TextBox>
                <anthem:ImageButton runat="server" ID="imgMovTo" OnClientClick="var a = Browse('ctl00_CPHBase_txtMovTo','','DACEstructuraPolizaEnc','',1,ctl00_CPHBase_txtEmpresa.value,ctl00_CPHBase_hddSucursal.value,'8', true,'No hay Tipos de Movimiento',1); if(a != undefined) document.getElementById('ctl00_CPHBase_txtMovTo').onchange(); else return false;"
                    ImageUrl="../../../Img/ayuda.gif" Height="17" Width="20" />
                <anthem:TextBox ID="txtNombreMovTo" runat="server" CssClass="String" Width="300px"></anthem:TextBox>
                <anthem:HiddenField ID="hddClave" runat="server" />
            </td>
            <td class="tLetra3">
                Descripción:
            </td>
            <td class="tLetra3">
                <anthem:TextBox ID="txtDescripcion" runat="server" CssClass="String" Width="300px"
                    TabIndex="4"></anthem:TextBox>
            </td>
        </tr>
        <tr>
            <td class="tLetra3">
                Tipo Póliza:
            </td>
            <td class="tLetra3" valign="middle" style="width: 600px; height: 25px">
                <anthem:TextBox ID="txtTipoPoliza" runat="server" TabIndex="5" Width="80px" CssClass="String" ondblclick="var a = Browse('ctl00_CPHBase_txtTipoPoliza','','DACEstructuraPolizaEnc','',2,ctl00_CPHBase_txtEmpresa.value,ctl00_CPHBase_hddSucursal.value,'8', true,'No hay Tipos de Póliza',1); if(a != undefined) document.getElementById('ctl00_CPHBase_txtTipoPoliza').onchange(); else return false;"
                    AutoCallBack="true" OnTextChanged="txtTipoPoliza_Change"></anthem:TextBox>
                <anthem:ImageButton runat="server" ID="imgTipoPoliza" OnClientClick="var a = Browse('ctl00_CPHBase_txtTipoPoliza','','DACEstructuraPolizaEnc','',2,ctl00_CPHBase_txtEmpresa.value,ctl00_CPHBase_hddSucursal.value,'8', true,'No hay Tipos de Póliza',1); if(a != undefined) document.getElementById('ctl00_CPHBase_txtTipoPoliza').onchange(); else return false;"
                    ImageUrl="../../../Img/ayuda.gif" Height="17" Width="20" />
                <anthem:TextBox ID="txtNombreTipoPoliza" runat="server" CssClass="String" Width="300px"></anthem:TextBox>
            </td>
            <td class="tLetra3">
                Autómatica:
            </td>
            <td class="tLetra3" valign="middle" style="width: 600px; height: 25px">
                <anthem:RadioButton ID="rdlSi" Text="Si" GroupName="Automatica" runat="server" TabIndex="6">
                </anthem:RadioButton>
                <anthem:RadioButton ID="rdlNo" Text="No" GroupName="Automatica" runat="server" TabIndex="7">
                </anthem:RadioButton>
            </td>
        </tr>
        <tr>
            <td class="tLetra3" style="height: 20px">
                Desc. Póliza:
            </td>
            <td class="tLetra3" style="height: 20px">
                <anthem:TextBox ID="txtDescPoliza" runat="server" CssClass="String" Width="300px"
                    TabIndex="8"></anthem:TextBox>
            </td>
        </tr>
    </table>
    <br />
    <anthem:Panel ID="pnlDetail" runat="server" BackImageUrl="../../../Img/dxpcFooterBack.gif"
        Width="100%">
        <table border="0" cellpadding="0" cellspacing="0" width="99%">
            <colgroup>
                <col width="15%" />
                <col width="12%" />
                <col width="10%" />
                <col width="10%" />
                <col width="10%" />
                <col width="10%" />
            </colgroup>
            <tr>
                <td class="tLetra3" style="width: 191px">
                    &nbsp; &nbsp;Cuenta&nbsp;&nbsp;
                    <anthem:TextBox ID="txtCuenta" runat="server" TabIndex="9" Width="100px" AutoCallBack="true" ondblclick="var a = Browse('ctl00_CPHBase_txtCuenta','ctl00_CPHBase_txtCuenta,ctl00_CPHBase_hddClaveCuenta','DACEstructuraPolizaDet','',0,ctl00_CPHBase_txtEmpresa.value,ctl00_CPHBase_hddSucursal.value,'8', true,'No hay Cuentas',1); if(a != undefined) document.getElementById('ctl00_CPHBase_txtCuenta').onchange(); else return false;"
                        OnTextChanged="txtCuenta_Change" Style="color: Black; text-align: left; font: 8pt Tahoma;"></anthem:TextBox>
                    <anthem:ImageButton runat="server" ID="btnAyudaCuenta" OnClientClick="var a = Browse('ctl00_CPHBase_txtCuenta','ctl00_CPHBase_txtCuenta,ctl00_CPHBase_hddClaveCuenta','DACCuentas','',1,ctl00_CPHBase_txtEmpresa.value,ctl00_CPHBase_hddSucursal.value,'8', true,'No hay Cuentas',1); if(a != undefined) document.getElementById('ctl00_CPHBase_txtCuenta').onchange(); else return false;"
                        Height="17" ImageUrl="../../../Img/ayuda.gif" Width="20" />&nbsp;
                    <anthem:HiddenField ID="hddClaveCuenta" runat="server" />
                </td>
                <td style="width: 14%">
                    <anthem:TextBox ID="txtNombreCuenta" runat="server" TabIndex="19" CssClass="tDatosDisable"
                        ReadOnly="true" Width="250px"></anthem:TextBox></td>
            </tr>
            <tr>
                <td>
                <anthem:HiddenField ID="hddIdClave" runat="server" />
                </td>
            </tr>
            <tr>
                <td class="tLetra3" style="width: 191px">
                    &nbsp; &nbsp;Complemento:
                </td>
                <td class="tLetra3">
                    <anthem:DropDownList ID="cboComplemento" runat="server" CssClass="tDatos150" Width="250px" TabIndex="10">
                    </anthem:DropDownList>
                </td>
                <td>
                </td>
                <td class="tLetra3" style="width: 10%">
                    <anthem:CheckBox ID="chkCargo" Text="Cargo" runat="server" TabIndex="13" />&nbsp;
                    &nbsp; &nbsp;<anthem:CheckBox ID="chkAux" Text="Aux" runat="server" TabIndex="14" />
                    &nbsp; &nbsp;
                    <anthem:CheckBox ID="chkCC" Text="CC" runat="server" TabIndex="15" />
                </td>
            </tr>
            <tr>
                <td class="tLetra3" style="width: 191px; height: 25px;" colspan="0">
                    &nbsp; &nbsp;Concepto:
                </td>
                <td style="width: 14%">
                    <anthem:DropDownList ID="cboConcepto" runat="server" CssClass="String" Width="250px" TabIndex="11">
                    </anthem:DropDownList>
                </td>
                <td class="tLetra3" style="width: 10%">
                    &nbsp; &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;Comentario:
               </td>
                <td class="tLetra3">
                    <anthem:TextBox ID="txtComentario" runat="server" CssClass="String" Width="300px" TabIndex="16"></anthem:TextBox>
                </td>
            </tr>
            <tr>
                <td class="tLetra3" style="width: 191px; height: 25px;" colspan="0">
                    &nbsp; &nbsp;Base:
                </td>
                <td style="width: 14%">
                    <anthem:DropDownList ID="cboBase" runat="server" CssClass="tDatos150" Width="250px" TabIndex="12">
                    </anthem:DropDownList>
                </td>
                <td class="tLetra3" style="width: 10%">
                    &nbsp; &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;Ptaje(%):</td>
                <td class="tLetra3">
                    <anthem:TextBox ID="txtPorcentaje" runat="server" CssClass="String" Width="90px"
                        TabIndex="17">
                    </anthem:TextBox>
                    &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp;
                    <anthem:CheckBox ID="chkModif" Text="Modif" runat="server" TabIndex="18" /></td>
                <td class="tLetra3" style="height: 22px">
                    <anthem:Button ID="btnAgregar" runat="server" Text=" Agregar  >>" CssClass="tdButton_Aqua" OnClientClick="return datosCompletosDet();" EnabledDuringCallBack="false" Font-Bold="true"
                        OnClick="btnAgregar_Click" Width="120px" TabIndex="19" />
                </td>
            </tr>
        </table>
    </anthem:Panel>
    <br />
    <table width="100%">
        <tr>
            <td>
                <div id="div-ListPanel">
                    <anthem:GridView ID="grdDet" runat="server" Width="98%" AutoGenerateColumns="False"
                        EmptyDataText="No han agregado partidas" HeaderStyle-CssClass="dxgvHeader_PlasticBlue"
                        DataKeyNames="intPartida" OnRowDeleting="DgrdList_RowDeleting" OnRowCreated="DgrdList_RowCreated"
                        RowStyle-CssClass="GridViewRow" CssClass="dxgvTable_Aqua" CellPadding="0" GridLines="None">
                        <Columns>
                            <asp:BoundField DataField="strCuenta" HeaderText="Cuenta">
                                <itemstyle horizontalalign="Center" width="30px" />
                            </asp:BoundField>
                            <asp:BoundField DataField="intClave" HeaderText="Clave" Visible="False">
                                <itemstyle horizontalalign="Center" width="30px" />
                            </asp:BoundField>
                            <asp:BoundField DataField="strSubCuentat" HeaderText="SCta">
                                <itemstyle horizontalalign="Center" width="30px" />
                            </asp:BoundField>
                            <asp:BoundField DataField="strSubSubCuenta" HeaderText="SSCta">
                                <itemstyle horizontalalign="Center" width="30px" />
                            </asp:BoundField>
                            <asp:CheckBoxField DataField="bitCargo" HeaderText="Cargo">
                                <itemstyle horizontalalign="Center" width="20px" />
                            </asp:CheckBoxField>
                            <asp:CheckBoxField DataField="bitAux" HeaderText="Aux">
                                <itemstyle horizontalalign="Center" width="20px" />
                            </asp:CheckBoxField>
                            <asp:CheckBoxField DataField="bitCC" HeaderText="CC">
                                <itemstyle horizontalalign="Center" width="20px" />
                            </asp:CheckBoxField>
                            <asp:BoundField DataField="strConcepto" HeaderText="Concepto">
                                <itemstyle horizontalalign="Center" width="50px" />
                            </asp:BoundField>
                            <asp:BoundField DataField="strComentario" HeaderText="Comentario">
                                <itemstyle horizontalalign="Center" width="90px" />
                            </asp:BoundField>
                            <asp:BoundField DataField="strBase" HeaderText="Base">
                                <itemstyle horizontalalign="Center" width="40px" />
                            </asp:BoundField>
                            <asp:BoundField DataField="intPtaje" HeaderText="Ptaje(%)">
                                <itemstyle horizontalalign="Center" width="30px" />
                            </asp:BoundField>
                            <asp:CheckBoxField DataField="bitModif" HeaderText="Modif">
                                <itemstyle horizontalalign="Center" width="20px" />
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
		         return objUtils.validaItems("ctl00_CPHBase_txtNumero,ctl00_CPHBase_txtMovTo,ctl00_CPHBase_txtTipoPoliza,ctl00_CPHBase_txtDescPoliza");
		         
		    }
		    
		    function datosCompletosDet()
            {
		         return objUtils.validaItems("ctl00_CPHBase_txtNumero,ctl00_CPHBase_txtCuenta,ctl00_CPHBase_txtPorcentaje");
		         
		    }
                
            function validPrint()
            {
		         return objUtils.validaItems("ctl00_CPHBase_txtNumero");
            }
                                               
    </script>

</asp:Content>
