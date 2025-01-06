<%@ Page Title="" Language="C#" MasterPageFile="~/Pages/Contabilidad/Opciones/Base.master" AutoEventWireup="true" CodeFile="FacturacionCom.aspx.cs" Inherits="Pages_Contabilidad_Opciones_FacturacionCom" %>
<%@ Register Assembly="Anthem" Namespace="Anthem" TagPrefix="anthem" %>

<asp:Content ID="Content1" ContentPlaceHolderID="CPHBase" Runat="Server">
    <style type="text/css">
        .Hide
        {
            display: none;
        }
    </style>

    <script type="text/javascript" language="javascript">
        var objUtils = new VetecUtils();

        var interval;
        interval = setInterval(function () {

            $('#<%=lknPost.ClientID %>').click();

            //GetFacturaGenerar();
            //gvFacturas
        }, 20000);

        function datosCompletos() {
            return objUtils.validaItems("ctl00_CPHBase_cboEjercicio,ctl00_CPHBase_cboSemana");

        }

        function Desaplicar() {
            var rblDesplegar = 0;
                var selectedvalue = 0;
                var inputs = rblDesplegar.getElementsByTagName("input");

                for (var j = 0; j < inputs.length; j++) {
                    if (inputs[j].checked) {
                        selectedvalue = inputs[j].value;
                        break;
                    }
                }

                if (selectedvalue != 1) {
                    alert('Seleccione los clientes aplicados.');
                    return false;
                }

                var table = document.getElementById('<%=grdFacturacion.ClientID %>');
                var prospectos = 0;

                for (var i = 1; i < table.rows.length; i++) {
                    if (table.rows(i).cells(0).childNodes[0].childNodes[0].checked)
                        prospectos = prospectos + 1;
                }

                if (prospectos == 0) {
                    alert('Debe seleecionar al menos un prospecto.');
                    return false;
                }

                return confirm('¿Desea desaplicar la poliza?');
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
            <td class="tLetra3" style="height: 23px">
                &nbsp;</td>
            <td class="tLetra36" style="height: 23px">
                &nbsp;</td>
            <td class="tLetra3" style="height: 23px">
                                            &nbsp;</td>
            <td style="height: 23px">
                &nbsp;</td>
        </tr>
        <tr>
            <td class="tLetra3" style="height: 23px">
                &nbsp;&nbsp; Ejercicio:</td>
            <td class="tLetra36" style="height: 23px">
                <anthem:DropDownList ID="cboEjercicio" runat="server" CssClass="String"
                    TabIndex="3" Width="120px">
                </anthem:DropDownList></td>
            <td class="tLetra3" style="height: 23px">
                                            &nbsp;</td>
            <td style="height: 23px">
            </td>
        </tr>
        <tr>
            <td class="tLetra3">
                &nbsp;&nbsp; Semana:</td>
            <td class="tLetra36">
                <anthem:DropDownList ID="cboSemana" runat="server" CssClass="String" TabIndex="4" AutoCallBack="true" OnSelectedIndexChanged="cboMonth_Change"
                    Width="120px" AutoUpdateAfterCallBack="True">
                </anthem:DropDownList></td>
            <td class="tLetra3">
                <asp:LinkButton ID="lknPost" runat="server" onclick="lknPost_Click"></asp:LinkButton>
            </td>
            <td>
            </td>
        </tr>
        <tr>
            <td class="tLetra3">
                &nbsp;</td>
            <td class="tLetra36">
                <anthem:Label ID="lblFec" runat="server" CssClass="tLetra3"></anthem:Label>
            </td>
            <td class="tLetra3">
                &nbsp;</td>
            <td>
                &nbsp;</td>
        </tr>
        <tr>
            <td class="tLetra3">
                &nbsp;</td>
            <td class="tLetra36">
                <anthem:Button ID="btnExport" runat="server" CssClass="tdButton_Aqua" Text="Exportar" OnClick="btnExport_Click" />
            </td>
            <td class="tLetra3">
                &nbsp;</td>
            <td>
                &nbsp;</td>
        </tr>
        <tr>
            <td class="tLetra3">
                &nbsp;</td>
            <td class="tLetra36">
                &nbsp;</td>
            <td class="tLetra3">
                &nbsp;</td>
            <td>
                &nbsp;</td>
        </tr>
        </table>
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
            <td>
                <div id="div-ListPanel3">
                <anthem:GridView ID="grdFacturacion" AutoGenerateColumns="false" DataKeyNames="intFactura,intColonia,intSector, intobra" runat="server" GridLines="None" HeaderStyle-CssClass="dxgvHeader_PlasticBlue" AllowSorting="true" 
                  CellPadding="0" CellSpacing="0" BorderColor="gray" BorderWidth="0" OnRowDataBound="row_Created" CssClass="dxgvTable_Aqua" Width="99%"  >
                    <Columns>  
                        <asp:TemplateField ItemStyle-HorizontalAlign="Center" ItemStyle-Width="30px">
                            <itemtemplate> 
        		                <anthem:CheckBox ID="chkFac" runat="server" />       		                                    		           		                        
		           		    </itemtemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="intFactura" HeaderStyle-CssClass="Hide"  ItemStyle-CssClass ="Hide"  />
                        <asp:BoundField DataField="strPDF" HeaderStyle-CssClass="Hide"  ItemStyle-CssClass ="Hide"  />
                        <%--<asp:BoundField DataField="intColonia" HeaderText="intColonia" ItemStyle-HorizontalAlign="Left" ItemStyle-Width="200px" SortExpression="intColonia" />
                        <asp:BoundField DataField="intSector" HeaderText="Sector" ItemStyle-HorizontalAlign="Left" ItemStyle-Width="140px" SortExpression="intSector" />--%>
                        <asp:BoundField DataField="Colonia" HeaderText="Colonia" ItemStyle-HorizontalAlign="Left" ItemStyle-Width="240px" SortExpression="Colonia" />
                        <asp:BoundField DataField="Sector" HeaderText="Sector" ItemStyle-HorizontalAlign="Left" ItemStyle-Width="140px" SortExpression="Sector" />
                        <asp:BoundField DataField="Serie" HeaderText="Serie" ItemStyle-HorizontalAlign="Left" ItemStyle-Width="140px" SortExpression="Serie" />
                       <%-- <asp:BoundField DataField="Factura" HeaderText="Factura" ItemStyle-HorizontalAlign="Left" ItemStyle-Width="140px" SortExpression="Factura" />--%>
                        <asp:TemplateField HeaderText="Factura" ItemStyle-HorizontalAlign="Left" ItemStyle-Width="140px" SortExpression="Factura">
                            <itemtemplate> 
        		                <anthem:LinkButton id="lknFac" runat="server"></anthem:LinkButton>    		                                    		           		                        
		           		    </itemtemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="Comisiones" HeaderText="Comisiones" ItemStyle-HorizontalAlign="Right" ItemStyle-Width="140px" DataFormatString="{0:C}" />
                        <asp:BoundField DataField="Publicidad" HeaderText="Publicidad" ItemStyle-HorizontalAlign="Right" ItemStyle-Width="140px" DataFormatString="{0:C}" />
                        <asp:BoundField DataField="Utilidad" HeaderText="Utilidad" ItemStyle-HorizontalAlign="Right" ItemStyle-Width="140px" DataFormatString="{0:C}" />
                        <asp:BoundField DataField="Total" HeaderText="Total" ItemStyle-HorizontalAlign="Right" ItemStyle-Width="140px" DataFormatString="{0:C}" />
			                                                    	                            
                    </Columns>                                                                          
                </anthem:GridView>
            </div>
        </td>
    </tr> 
   </table>
</asp:Content>

