<%@ Page Title="" Language="C#" MasterPageFile="~/Pages/Contabilidad/Opciones/Base.master" AutoEventWireup="true" CodeFile="ProspectoNotaCredito.aspx.cs" Inherits="Pages_Contabilidad_Opciones_ProspectoNotaCredito" culture="es-mx" uiculture="es"%>
<%@ Register Assembly="Anthem" Namespace="Anthem" TagPrefix="anthem" %>

<asp:Content ID="Content1" ContentPlaceHolderID="CPHBase" Runat="Server">
    <script type="text/javascript" language="javascript">

        $(document).ready(function () {
            //$('#ctl00_CPHBase_txtProspecto').change(function() {  
            //    GetList();
            //});
        });

        //setInterval(function () { GetList(); }, 30000);

        function datosCompletos() { }

        function ReFresh() {
            setInterval(function () { GetList(); }, 30000);
        }

        function GetList() {
            var intProspecto = 0;
            intProspecto = $('#ctl00_CPHBase_txtProspecto').val() == '' ? 0 : $('#ctl00_CPHBase_txtProspecto').val();
            var urlData = 'ProspectoNotaCredito.aspx/GetList';
            var dataData = '{ intProspecto: ' + intProspecto + '}';
            CallMethod(urlData, dataData, SuccessData);
        }

        function SuccessData(response) {
            var message = response.d[0];
            if (message == "ok") {
                var data = JSON.parse(response.d[1]);
                GenerarGrid('Notas de Crédito', data);

            } else {
                alert('Error al cargar los datos')
            }
        }
        
        function GenerarGrid(caption, data) {
            try {
                for (var i in data) {
                    if (data[i].intEstatus == 0) { data[i].strEstatus = 'Alta'; }
                    else if (data[i].intEstatus == 3) { data[i].strEstatus = 'Completo'; }
                    else { data[i].strEstatus = 'En Proceso'; }
                }
                $('#grid').jqGrid('GridUnload');
                $grid = $("#grid").jqGrid
                (
                    {
                        datatype: 'local',
                        data: data,
                        colNames: [
                            "",
                            "Tipo",
                            "Empresa",
                            "Prospecto",
                            "Serie Factura",
                            "Folio Factura",
                            "Serie",
                            "Estatus",
                            "Folio",
                            "PDF",
                            "XML",
                            "Método Pago",
                            "Forma Pago",
                            "Método Pago",
                            "Forma Pago",
                            "Importe",
                            "Eliminar"

                        ],
                        colModel: [
                            { 'index': 'chk', 'name': 'chk', 'width': 100, align: 'Center', formatter: '', hidden: false, editable: true, edittype: 'checkbox', editoptions: { value: 'True:False' }, formatter: 'checkbox', formatoptions: { disabled: false }, onchecked: function (rowid) { jQuery(this).editRow(rowid, true); alert('chek'); } },
                            { 'index': 'intNotaCredito', 'name': 'intNotaCredito', 'width': 100, align: 'Center', formatter: '', hidden: true, key:true },
                            { 'index': 'strEmpresa', 'name': 'strEmpresa', 'width': 230, align: 'Center', formatter: '' },
                            { 'index': 'intProspecto', 'name': 'intProspecto', 'width': 60, align: 'Center', formatter: '' },
                            { 'index': 'strSerieFactura', 'name': 'strSerieFactura', 'width': 60, align: 'Center', formatter: '' },
                            { 'index': 'decFolioFactura', 'name': 'decFolioFactura', 'width': 80, align: 'Center', formatter: '' },
                            { 'index': 'strSerie', 'name': 'strSerie', 'width': 60, align: 'Center', formatter: '' },
                            { 'index': 'strEstatus', 'name': 'strEstatus', 'width': 150, align: 'Center', formatter: '' },
                            { 'index': 'decFolio', 'name': 'decFolio', 'width': 80, align: 'Center', formatter: '' },
                            { 'index': 'PDFURL', 'name': 'PDFURL', 'width': 150, align: 'Center', formatter: '' },
                            { 'index': 'XMLURL', 'name': 'XMLURL', 'width': 150, align: 'Center', formatter: '' },

                            { 'index': 'strMetodoPagoDesc', 'name': 'strMetodoPagoDesc', 'width': 180, align: 'Center' },
                            { 'index': 'strFormaPagoDesc', 'name': 'strFormaPagoDesc', 'width': 150, align: 'Center' },
                            { 'index': 'strMetodoPago', 'name': 'strMetodoPago', 'width': 180, align: 'Center', hidden: true },
                            { 'index': 'strFormaPago', 'name': 'strFormaPago', 'width': 150, align: 'Center', hidden: true },
                            { 'index': 'dblImporte', 'name': 'dblImporte', 'width': 150, align: 'Center' },
                            { 'index': 'Eliminar', 'name': 'Eliminar', 'width': 50, align: 'Center' },
                        ],
                        ondblClickRow: function (rowId) {
                            var rowData = jQuery(this).getRowData(rowId);

                        },

                        pager: "#pager", //Pager.
                        loadtext: 'Loading...',
                        recordtext: "{0} - {1} de {2} elements",
                        emptyrecords: 'No hay resultados',
                        pgtext: 'Pág: {0} de {1}', //Paging input control text format.
                        rowNum: "20", // PageSize.
                        rowList: [10, 20, 50], //Variable PageSize DropDownList. 
                        viewrecords: true, //Show the RecordCount in the pager.
                        multiselect: false,
                        width: "1100",
                        height: "200",
                        caption: caption,
                        gridview: true,
                        multiselect: false,
                        ignoreCase: true,
                        rownumbers: false,
                        shrinkToFit: false,

                        loadComplete: function () {

                            //if (data.length > 0) {
                            //    for (var i = 0; i < data.length; i++) {
                            //        if (data[i].intEstatus == 1 || data[i].intEstatus == 0) {
                            //            $("#grid > tbody > tr > td:nth-child(" + i + 1 + ")").find(":checkbox").prop("hidden", false);
                            //        }
                            //        else {
                            //            $("#grid > tbody > tr > td:nth-child(" + i + 1 + ")").find(":checkbox").prop("hidden", true);

                            //        }
                            //    }
                            //}
                        },
                    }
                );

            }//end try
            catch (oerror) {
                alert('Error Obtener 1 ' + oerror);
            }
        }

        function Eliminar(strNC,strEmpresa, strFolio, strProspecto,strFilePDF,strFileXML) {
        
            var bool = confirm('¿Desea eliminar la Nota de Crédito ?');
            if (bool)
            {
                var url = 'ProspectoNotaCredito.aspx/EliminarNC';
                var data = '{ strNC:' + strNC + ',strEmpresa:' + strEmpresa + ',strFolio:' + strFolio + ',strProspecto:' + strProspecto + ',strFilePDF:"' + strFilePDF + '",strFileXML:"' + strFileXML + '" }';
                CallMethod(url, data, SuccessEliminarNC);
            }
        }
        
        function SuccessEliminarNC(response) {
             var message = response.d[0];
            if (message == "ok") {
                alert('Nota de credito eliminada correctamente.')
                GetList();
            } else {
               alert(response.d[1]);
            }
        }

        function GenerarNotasDeCredito() {
            var intProspecto = 0;
            intProspecto = $('#ctl00_CPHBase_txtProspecto').val() == '' ? 0 : $('#ctl00_CPHBase_txtProspecto').val();
            var strFolio = Keys();

            var url = 'ProspectoNotaCredito.aspx/GenerarNotaCredito';
            //var data = '{ intProspecto: ' + intProspecto + ' ,strFolio:' + strFolio + '}';
            var data = '{ "intProspecto":"' + intProspecto + '","strFolio":"' + strFolio + '" }';
            CallMethod(url, data, SuccessGenerarNotas);
        }

        function SuccessGenerarNotas(response) {
            var message = response.d[0];
            if (message == "ok") {
                alert('Datos guardados correctamente.')
                GetList();
                setInterval(function () { GetList(); }, 30000);
            } else {
                alert(response.d[1]);
            }
        }

        function Keys() {

            var rows = jQuery("#grid").getDataIDs();
            var strKeys = "";
            var checked;

            for (var i = 0; i < rows.length; i++) {
                var rowData = jQuery("#grid").jqGrid('getRowData', rows[i]);
                checked = $('#grid').jqGrid('getCell', rows[i], 'chk');

                if (checked == 'True')
                    strKeys = strKeys + $('#grid').jqGrid('getCell', rows[i], 'intNotaCredito') + ";";
            }

            return strKeys.substring(0, strKeys.length - 1);
        }
    </script>
    <table border="0" cellpadding="0" cellspacing="0" width="100%">
        <colgroup>
            <col width="12%" />
            <col width="40%" />
            <col width="18%" />
            <col width="30%" />
        </colgroup>
        <tr>
            <td>
                &nbsp;
            </td>
        </tr>
        <tr>
            <td class="tLetra3" style="height: 23px; width: 13%;">
                &nbsp;
                Prospecto</td>
            <td class="tLetra36" style="height: 23px">
                <asp:TextBox ID="txtProspecto" runat="server" Width="75px" AutoPostBack="true" 
                    BackColor="#FFFF80" CssClass="tDatos250" OnTextChanged="txtProspecto_TextChanged"
                    TabIndex="1"></asp:TextBox>
                &nbsp;
                                
                       <anthem:ImageButton runat="server" ID="ImageButton6" OnClientClick="var a = JBrowse('ctl00_CPHBase_txtProspecto','ctl00_CPHBase_txtNombre,ctl00_CPHBase_txtNombre','DACProspectosEsc','',1,2,7,'8', true,'No hay información',function(){document.getElementById('ctl00_CPHBase_txtProspecto').onchange(); },0); "
                    Height="18px" ImageUrl="../../../Img/ayuda.gif" Width="20" ImageAlign="AbsMiddle" />

                &nbsp;<anthem:TextBox ID="txtNombre" runat="server" CssClass="String" TabIndex="3" 
                    Width="270px"></anthem:TextBox>
            </td>
            <td class="tLetra3" style="height: 23px">
                Avaluo</td>
            <td style="height: 23px">
                <anthem:TextBox ID="txtAvaluo" runat="server" CssClass="String" TabIndex="3" ReadOnly="true"
                    Width="100px" ></anthem:TextBox>
            </td>
        </tr>
        <tr>
            <td class="tLetra3" style="height: 23px; width: 13%;">
                &nbsp;
                RFC</td>
            <td class="tLetra36" style="height: 23px">
                <anthem:TextBox ID="txtRFC" runat="server" CssClass="String" TabIndex="3" 
                    Width="200px" ></anthem:TextBox>
            </td>
            <td class="tLetra3" style="height: 23px">
                Descuento</td>
            <td style="height: 23px">
                <anthem:TextBox ID="txtDescuento" runat="server" CssClass="String" TabIndex="3" ReadOnly="true"
                    Width="100px" ></anthem:TextBox>
            </td>
        </tr>
        <tr>
            <td class="tLetra3" style="height: 23px; width: 13%;">
                &nbsp;País&nbsp;</td>
            <td class="tLetra36" style="height: 23px">
                <anthem:TextBox ID="txtPais" runat="server" CssClass="String" TabIndex="3" 
                    Width="200px" ></anthem:TextBox>
            </td>
            <td class="tLetra3" style="height: 23px">
                Precio Terreno</td>
            <td style="height: 23px">
                <anthem:TextBox ID="txtPrecioTerreno" runat="server" CssClass="String"  ReadOnly="true"
                    TabIndex="3" Width="100px" ></anthem:TextBox>
            </td>
        </tr>
        <tr>
            <td class="tLetra3" style="height: 23px; width: 13%;">
                &nbsp;Estado&nbsp;</td>
            <td class="tLetra36" style="height: 23px">
                <anthem:TextBox ID="txtEstado" runat="server" CssClass="String" TabIndex="3" 
                    Width="200px" ></anthem:TextBox>
            </td>
            <td class="tLetra3" style="height: 23px">
                Precio Edificacion</td>
            <td style="height: 23px">
                <anthem:TextBox ID="txtPrecioEdificacion" runat="server" CssClass="String"  ReadOnly="true"
                    TabIndex="3" Width="100px" ></anthem:TextBox>
            </td>
        </tr>
        <tr>
            <td class="tLetra3" style="height: 23px; width: 13%;">
                &nbsp;Ciudad&nbsp;</td>
            <td class="tLetra36" style="height: 23px">
                <anthem:TextBox ID="txtCiudad" runat="server" CssClass="String" TabIndex="3" 
                    Width="200px" ></anthem:TextBox>
            </td>
            <td class="tLetra3" style="height: 23px">
                Terreno</td>
            <td style="height: 23px">
                <anthem:TextBox ID="txtTerreno" runat="server" CssClass="String" TabIndex="3" ReadOnly="true"
                    Width="100px" ></anthem:TextBox>
            </td>
        </tr>
        
        <tr>
            <td class="tLetra3"  style="width: 13%; height: 19px;">
                &nbsp;Colonia&nbsp;</td>
            <td class="tLetra36" colspan="2" style="height: 19px">
                <anthem:TextBox ID="txtColonia" runat="server" CssClass="String" TabIndex="3" 
                     Width="400px" ></anthem:TextBox>
            </td>
            <td style="height: 19px">
                &nbsp;</td>
        </tr>
        <tr>
            <td class="tLetra3"  style="width: 13%;">
                &nbsp;Calle&nbsp;</td>
            <td class="tLetra36">
                <anthem:TextBox ID="txtCalle" runat="server" CssClass="String" TabIndex="3" 
                     Width="100px" ></anthem:TextBox>
            </td>
            <td class="tLetra3">
                &nbsp;</td>
            <td>
                &nbsp;</td>
        </tr>
        <tr>
            <td class="tLetra3"  style="width: 13%; ">
                &nbsp;Número&nbsp;</td>
            <td class="tLetra36" colspan="2" style="height: 19px">
                <anthem:TextBox ID="txtNumero" runat="server" CssClass="String" TabIndex="3" 
                     Width="100px"  ></anthem:TextBox>
            </td>
            <td style="height: 19px">
                </td>
        </tr>
        <tr>
            <td class="tLetra3"  style="width: 13%;">
                &nbsp;C.P.&nbsp;</td>
            <td class="tLetra36">
                <anthem:TextBox ID="txtCP" runat="server" CssClass="String" TabIndex="3" 
                     Width="100px" ></anthem:TextBox>
            </td>
            <td class="tLetra3">
                &nbsp;</td>
            <td>
                &nbsp;</td>
        </tr>
        <tr>
            <td class="tLetra3"  style="width: 13%;">
                &nbsp;Telefono&nbsp;</td>
            <td class="tLetra36">
                <anthem:TextBox ID="txtTelefono" runat="server" CssClass="String" TabIndex="3" 
                     Width="200px" ></anthem:TextBox>
            </td>
            <td class="tLetra3">
                &nbsp;</td>
            <td>
                &nbsp;</td>
        </tr>
        <tr>
            <td class="tLetra3"  style="width: 13%;">
                &nbsp;Email&nbsp;</td>
            <td class="tLetra36">
                <anthem:TextBox ID="txtEmail" runat="server" CssClass="String" TabIndex="3" 
                     Width="200px" ></anthem:TextBox>
            </td>
            <td class="tLetra3">
                &nbsp;</td>
            <td>&nbsp;</td>
        </tr>

        <tr>
            <td class="tLetra3" style="height: 23px; width: 13%;">
                &nbsp;Bonificación</td>
            <td class="tLetra36" style="height: 23px">
                <anthem:TextBox runat="server" ID="txtBonificacion" CssClass="String"  ReadOnly="true" AutoPostBack="true"   OnTextChanged="txtBonificacion_TextChanged" ></anthem:TextBox>
            </td>
            <td class="tLetra3" style="height: 23px"></td>
            <td style="height: 23px">
            </td>
        </tr>
        <tr>
            <td class="tLetra3" style="height: 23px; width: 13%;">
                &nbsp;Importe Restante</td>
            <td class="tLetra36" style="height: 23px">
                <anthem:TextBox runat="server" ID="txtImporteRestante" CssClass="String" ReadOnly="true"></anthem:TextBox>
            </td>
            <td class="tLetra3" style="height: 23px"></td>
            <td style="height: 23px">
            </td>
        </tr>


        <tr>
            <td class="tLetra3" style="height: 23px; width: 13%;">&nbsp;Serie Factura</td>
            <td class="tLetra36" style="height: 23px">
                <anthem:TextBox runat="server" ID="txtSerie" CssClass="String"  ReadOnly="true"></anthem:TextBox>
            </td>
            <td class="tLetra3" style="height: 23px"></td>
            <td style="height: 23px">
            </td>
        </tr>
        <tr>
            <td class="tLetra3" style="height: 23px; width: 13%;">
                &nbsp;Folio Factura MD</td>
            <td class="tLetra36" style="height: 23px">
                <anthem:TextBox runat="server" ID="txtFolio" CssClass="String"></anthem:TextBox>
            </td>
            <td class="tLetra3" style="height: 23px"></td>
            <td style="height: 23px">
            </td>
        </tr>

        <tr>
            <td class="tLetra3" style="height: 23px; width: 13%;">
                &nbsp;Folio Factura A EN P</td>
            <td class="tLetra36" style="height: 23px">
                <anthem:TextBox runat="server" ID="txtFolioAENP" CssClass="String"></anthem:TextBox>
            </td>
            <td class="tLetra3" style="height: 23px">&nbsp;</td>
            <td style="height: 23px">
                &nbsp;</td>
        </tr>

        <tr>
            <td class="tLetra3" style="height: 23px; width: 13%;">
                &nbsp;Importe</td>
            <td class="tLetra36" style="height: 23px">
                <anthem:TextBox runat="server" ID="txtImporte" CssClass="String" ></anthem:TextBox>
            </td>
            <td class="tLetra3" style="height: 23px"></td>
            <td style="height: 23px">
            </td>
        </tr>
        <tr>
            <td class="tLetra3" style="height: 23px; width: 13%;">&nbsp;Forma de Pago</td>
            <td style="height: 23px">
                <anthem:DropDownList runat="server" ID="ddlFormaPago" CssClass="btn dropdown-toggle btn-default">
                    <asp:ListItem Value="01"  Text="(01) Efectivo" ></asp:ListItem>
                    <asp:ListItem Value="02"  Text="(02) Cheque nominativo" ></asp:ListItem>
                    <asp:ListItem Value="03"  Text="(03) Transferencia electrónica de fondos" ></asp:ListItem>
                    <asp:ListItem Value="04"  Text="(04) Tarjeta de crédito" ></asp:ListItem>
                    <asp:ListItem Value="05"  Text="(05) Monedero electrónico" ></asp:ListItem>
                    <asp:ListItem Value="06"  Text="(06) Dinero electrónico" ></asp:ListItem>
                    <asp:ListItem Value="08"  Text="(08) Vales de despensa" ></asp:ListItem>
                    <asp:ListItem Value="12"  Text="(12) Dación en pago" ></asp:ListItem>
                    <asp:ListItem Value="13"  Text="(13) Pago por subrogación" ></asp:ListItem>
                    <asp:ListItem Value="14"  Text="(14) Pago por consignación" ></asp:ListItem>
                    <asp:ListItem Value="15"  Text="(15) Condonación" ></asp:ListItem>
                    <asp:ListItem Value="17"  Text="(17) Compensación" ></asp:ListItem>
                    <asp:ListItem Value="23"  Text="(23) Novación" ></asp:ListItem>
                    <asp:ListItem Value="24"  Text="(24) Confusión" ></asp:ListItem>
                    <asp:ListItem Value="25"  Text="(25) Remisión de deuda" ></asp:ListItem>
                    <asp:ListItem Value="26"  Text="(26) Prescripción o caducidad" ></asp:ListItem>
                    <asp:ListItem Value="27"  Text="(27) A satisfacción del acreedor" ></asp:ListItem>
                    <asp:ListItem Value="28"  Text="(28) Tarjeta de débito" ></asp:ListItem>
                    <asp:ListItem Value="29"  Text="(29) Tarjeta de servicios" ></asp:ListItem>
                    <asp:ListItem Value="30"  Text="(30) Aplicación de anticipos" ></asp:ListItem>
                    <asp:ListItem Value="31"  Text="(31) Intermediario pagos" ></asp:ListItem>
                    <asp:ListItem Value="99"  Text="(99) Por definir" Selected="True"></asp:ListItem>
                </anthem:DropDownList>

                <%--<select id="ddlMetodoPago" class="btn dropdown-toggle btn-default">
                    <option value=""></option>
                    <option value="PUE">(PUE) Pago en una Sola Exhibición</option>
                    <option value="PPD">(PPD) Pago en Parcialidades o Diferido</option>
                </select>--%>
            </td>
        </tr>
        <tr>
            <td class="tLetra3" style="height: 23px; width: 13%;">&nbsp;Método de Pago</td>
            <td>
                <anthem:DropDownList runat="server" ID="ddlMetodoPago" CssClass="btn dropdown-toggle btn-default">
                    <asp:ListItem Value="PUE"  Text="(PUE) Pago en una Sola Exhibición" Selected="True" ></asp:ListItem>
                    <asp:ListItem Value="PPD"  Text="(PPD) Pago en Parcialidades o Diferido" ></asp:ListItem>
                </anthem:DropDownList>
                <%--<select id="ddlMetodoPago" class="btn dropdown-toggle btn-default">
                    <option value=""></option>
                    <option value="PUE">(PUE) Pago en una Sola Exhibición</option>
                    <option value="PPD">(PPD) Pago en Parcialidades o Diferido</option>
                </select>--%>
            </td>
        </tr>
        <tr>
            <td class="tLetra3" style="height: 23px; width: 13%;">&nbsp;Fideicomiso&nbsp;</td>
            <td>
                <anthem:CheckBox runat="server" ID="chkFideicomiso" />
            </td>
        </tr>
         <tr>
            <td class="tLetra3"  style="width: 13%;"></td>
            <td class="tLetra36" colspan="2">
                <button type="button" id="btnGenerar" onclick="GenerarNotasDeCredito();"  style="width: 120px; height: 20px;">Generar Notas</button>
            </td>
            
        </tr>
        <tr>
            <td>
                &nbsp;
                <anthem:HiddenField ID="hddPago" runat="server" /> 
                <anthem:HiddenField ID="hddTipo" runat="server" />
            </td>
        </tr>
        <tr style="font-size: 9pt">
            <td class="tLetra3" style="height: 23px;" colspan="4">
                <br />
            </td>
        </tr>
    </table>

    <table>
        <tr>
        <td colspan="5" align="left">                        
            <div style="width:90%;height:20%; " >
                <div id="grilla">
                    <table id="grid">
                        <tr><td /></tr>
                        </table>                                 
                        <div id="pager">
                        </div>
                    </div>
                </div>
            </td>
        </tr> 
    </table> 

</asp:Content>

