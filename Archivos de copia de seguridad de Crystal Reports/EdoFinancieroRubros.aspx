<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="Base.master" CodeFile="EdoFinancieroRubros.aspx.cs" Inherits="Contabilidad_Compra_Opciones_EdoFinancieroRubros" Culture="auto" UICulture="auto" %>
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
               return objUtils.validaItems("ctl00_CPHBase_txtEmpresa,ctl00_CPHBase_txtRubro,ctl00_CPHBase_txtEdoFin");

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
                &nbsp;&nbsp; Estado Financiero:</td>
            <td class="tLetra36" style="height: 23px">
                <anthem:TextBox ID="txtEdoFin" runat="server" AutoCallBack="true" CssClass="String"  TabIndex="1" Width="80px" OnTextChanged="txtEdoFin_TextChanged" ></anthem:TextBox>
                <anthem:ImageButton
                        ID="ImageButton1" runat="server" Height="17" ImageUrl="../../../Img/ayuda.gif"
                        OnClientClick="var a = Browse('ctl00_CPHBase_txtEdoFin','ctl00_CPHBase_txtEdoFin,ctl00_CPHBase_txtEdoFinDes','DACFactura','',29,ctl00_CPHBase_txtEmpresa.value,ctl00_CPHBase_hddSucursal.value,'8', true,'No hay información'); if(a != undefined) document.getElementById('ctl00_CPHBase_txtRubro').focus(); return false;"
                        Width="20" />
                <anthem:TextBox ID="txtEdoFinDes" runat="server" CssClass="String" TabIndex="2" Width="300px" Enabled="False"></anthem:TextBox></td>
            <td class="tLetra3" style="height: 23px">
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
    <anthem:Panel ID="pnlDetail" runat="server" BackImageUrl="../../Img/dxpcFooterBack.gif"
        Width="100%">
        <anthem:Panel ID="Panel1" runat="server" BackImageUrl="/../../Img/dxpcFooterBack.gif"
            Width="100%">
            <table border="0" cellpadding="0" cellspacing="0" width="99%">
                <colgroup>
                    <col width="12%" />
                    <col width="30%" />
                    <col width="10%" />
                    <col width="22%" />
                    <col width="12%" />
                    <col width="20%" />
                </colgroup>
                <tr>
                    <td class="tLetra6" style="width: 12%; height: 23px">
                        Rubros:
                    </td>
                    <td class="tLetra6" style="width: 41%; height: 23px">
                        <anthem:TextBox ID="txtRubro" runat="server" AutoCallBack="true" CssClass="String"
                            OnTextChanged="txtRubro_TextChanged" TabIndex="3" Width="80px"></anthem:TextBox>
                        <anthem:ImageButton
                                ID="ImageButton2" runat="server" Height="17" ImageUrl="../../../Img/ayuda.gif"
                                OnClientClick="var a = Browse('ctl00_CPHBase_txtRubro','ctl00_CPHBase_txtRubro,ctl00_CPHBase_txtNombre','DACFactura','',27,ctl00_CPHBase_txtEmpresa.value,ctl00_CPHBase_hddSucursal.value,'8', true,'No hay información'); if(a != undefined) document.getElementById('ctl00_CPHBase_btnAgregar').focus(); return false;"
                                Width="20" />
                        <anthem:TextBox ID="txtNombre" runat="server" CssClass="String" TabIndex="4"
                                    Width="300px"></anthem:TextBox></td>
                    <td class="tLetra6" style="width: 16%; height: 23px">
                        <anthem:Button ID="btnAgregar" runat="server" CssClass="tdButton_Aqua" EnabledDuringCallBack="false"
                            Font-Bold="true" OnClick="btnAgregar_Click" OnClientClick="return datosCompletos();"
                            TabIndex="5" Text=" Agregar  >>" Width="120px" /></td>
                    <td class="tLetra6" style="height: 23px">
                        &nbsp;</td>
                </tr>
                <tr>
                    <td class="tLetra6" style="width: 12%">
                        &nbsp;</td>
                    <td class="tLetra6" style="width: 41%">
                        &nbsp;&nbsp;
                    </td>
                    <td class="tLetra6" style="width: 16%">
                    </td>
                    <td class="tLetra6">
                        &nbsp;</td>
                </tr>
            </table>
        </anthem:Panel>
    </anthem:Panel>
    <br />
    <br />
    <table width="100%">
        <tr>
            <td>
                <div id="div-ListPanel" style="left: 0px; width: 83%; top: -10px">
                    <anthem:GridView ID="DgrdList" runat="server" AllowSorting="True" AutoGenerateColumns="False"
                        CellPadding="0" CellSpacing="0" DataKeyNames="intRubro,intEstadoFin" GridLines="None"
                        HeaderStyle-CssClass="dxgvHeader_PlasticBlue" OnRowDeleting="DgrdList_RowDeleting"
                        Width="100%">
                        <Columns>
                            <asp:BoundField DataField="intSecuencia" HeaderText="Ord">
                                <itemstyle width="50px" />
                            </asp:BoundField>
                            <asp:BoundField DataField="intRubro" HeaderText="Rubro">
                                <itemstyle width="50px" />
                            </asp:BoundField>
                            <asp:BoundField DataField="strNombre" HeaderText="Nombre">
                                <itemstyle width="200px" />
                            </asp:BoundField>
                            <asp:BoundField DataField="strTipoRubro" HeaderText="Tipo Linea">
                                <itemstyle width="200px" />
                            </asp:BoundField>                            
                            <asp:TemplateField ShowHeader="False">
                                <itemtemplate>
		                            <asp:ImageButton runat="server" ImageUrl="~/Img/Deleted.PNG"  onclientClick="javascript:return confirm('¿Desea eliminar el rubro?');" CommandName="Delete" CausesValidation="False" ImageAlign="Middle" id="lknDelete"></asp:ImageButton>
                                
                                </itemtemplate>
                                <itemstyle horizontalalign="Center" width="20px" />
                            </asp:TemplateField>
                        </Columns>
                        <HeaderStyle CssClass="dxgvHeader_PlasticBlue" />
                    </anthem:GridView>
                </div>
            </td>
        </tr>
    </table>
    </asp:Content>

   