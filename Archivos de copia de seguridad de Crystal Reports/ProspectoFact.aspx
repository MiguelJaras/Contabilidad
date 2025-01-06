<%@ Page Title="" Language="C#" MasterPageFile="Base.master" AutoEventWireup="true" CodeFile="ProspectoFact.aspx.cs" Inherits="Pages_Opciones_ProspectoFact" %>
<%@ Register Assembly="Anthem" Namespace="Anthem" TagPrefix="anthem" %>

<asp:Content ID="Content1" ContentPlaceHolderID="CPHBase" Runat="Server">

    <script type="text/javascript" src="../../../Scripts/Magnific-Popup-master/jquery.magnific-popup.js"></script>
    

    


 <script type="text/javascript" language="javascript">
     var objUtils = new VetecUtils();
        $(document).ready(function(){
            //$('#ctl00_CPHBase_txtProspecto').change(function() {  
            //    GetList();
            //});
        });

        

        function datosCompletos(){}
           
        function GetList() {
            var intProspecto = 0;
            intProspecto = $('#ctl00_CPHBase_txtProspecto').val() == '' ? 0 : $('#ctl00_CPHBase_txtProspecto').val();
            var urlData = 'ProspectoFac.aspx/GetList';
            var dataData = '{ intProspecto: ' + intProspecto + '}';
            CallMethod(urlData, dataData, SuccessData);
        }

        function SuccessData(response) {
            var message = response.d[0];
            if (message == "ok") {
                var data = JSON.parse(response.d[1]);
                GenerarGrid('Facturación', data);

            } else {
                alert('Error al cargar los datos')
            }
        }

        function GenerarGrid(caption, data) {
            try {

                $('#grid').jqGrid('GridUnload');
                $grid = $("#grid").jqGrid
                (
                    {
                        datatype: 'local',
                        data: data,
                        colNames: [
                            "Tipo",
                            "Empresa",
                            "Serie",
                            "Folio",
                            "Fecha",
                           //"Subtotal",
                            "Importe",
                            "PDF",
                            "XML",
                            "Método Pago",
                            "Forma Pago",
                            "Método Pago",
                            "Forma Pago",
                            "Estatus"
                        ],
                        colModel: [
                            { 'index': 'intFactura', 'name': 'intFactura', 'width': 100, align: 'Center', formatter: '', hidden: true },
                            { 'index': 'Empresa', 'name': 'Empresa', 'width': 200, align: 'left', formatter: '' },
                            { 'index': 'Serie', 'name': 'Serie', 'width': 50, align: 'Center', formatter: '' },
                            { 'index': 'Folio', 'name': 'Folio', 'width': 50, align: 'Center', formatter: '' },
                            { 'index': 'Fecha', 'name': 'Fecha', 'width': 80, align: 'Center', formatter: 'date', formatoptions: { srcformat: 'ISO8601Long', newformat: 'd/m/Y' } },
                            //{ 'index': 'Subtotal', 'name': 'Subtotal', 'width': 50, align: 'Center' },
                            {
                                'index': 'Importe', 'name': 'Importe', 'width': 80, align: 'right', formatter: 'currency',
                                formatoptions: { prefix: '$', thousandsSeparator: ',' }
                            },
                            { 'index': 'PDFURL', 'name': 'PDFURL', 'width': 130, align: 'Center' },
                            { 'index': 'XMLURL', 'name': 'XMLURL', 'width': 130, align: 'Center' },
                            { 'index': 'strMetodoPagoDesc', 'name': 'strMetodoPagoDesc', 'width': 180, align: 'Center' },
                            { 'index': 'strFormaPagoDesc', 'name': 'strFormaPagoDesc', 'width': 150, align: 'Center' },
                            { 'index': 'strMetodoPago', 'name': 'strMetodoPago', 'width': 180, align: 'Center', hidden: true },
                            { 'index': 'strFormaPago', 'name': 'strFormaPago', 'width': 150, align: 'Center', hidden: true },
                            { 'index': 'intEstatus', 'name': 'intEstatus', 'width': 150, align: 'Center', hidden: true },
                        ],
                        ondblClickRow: function (rowId) {
                            var rowData = jQuery(this).getRowData(rowId);
                            if (rowData.intEstatus == 0) {
                                
                                $('#hdnFactura').val(rowData.intFactura);
                                $('#ddlFormaPago').val(rowData.strFormaPago);
                                $('#ddlMetodoPago').val(rowData.strMetodoPago);
                                $.magnificPopup.open({
                                    items: [
                                        {
                                            type: 'inline',
                                            src: $('#PopUp')
                                        }
                                    ],
                                });
                            }
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
                        height: "460",
                        caption: caption,
                        gridview: true,
                        ignoreCase: true,
                        rownumbers: false,
                        shrinkToFit: false,

                        loadComplete: function () {
                            $('#cb_grid').css({ display: "none" });
                            for(var i in data)
                            {
                                if (data[i].intEstatus == 0) {
                                    $('#btnGenerar').removeClass('mfp-hide');
                                    $('#txtEstatus').val('Alta');
                                }
                                else if (data[i].intEstatus == 3)
                                {
                                    $('#btnGenerar').addClass('mfp-hide');
                                    $('#txtEstatus').val('Completo');
                                }
                                else {
                                    $('#btnGenerar').addClass('mfp-hide');
                                    $('#txtEstatus').val('En Proceso');

                                }
                            }
                        },
                    }
                );

            }//end try
            catch (oerror) {
                alert('Error Obtener 1 ' + oerror);
            }
        }


        
        function Save() {
            var intFactura = intFactura = $('#hdnFactura').val();
            var strFormaPago = $('#ddlFormaPago').val();
            var strMetodoPago = $('#ddlMetodoPago').val();

            var url = 'ProspectoFac.aspx/SaveFormaPago';
            var data = '{ intFactura: ' + intFactura + ', strMetodoPago: \'' + strMetodoPago + '\', strFormaPago: \'' + strFormaPago + '\'}';
            CallMethod(url, data, SuccessSave);
        }

        function SuccessSave(response) {
            var message = response.d[0];
            if (message == "ok") {
                alert('Datos guardados correctamente.')
                CerrarPopUp();
                GetList();
            } else {
                alert(response.d[1]);
            }
        }


        function GenerarFacturas() {
            var intProspecto = 0;
            intProspecto = $('#ctl00_CPHBase_txtProspecto').val() == '' ? 0 : $('#ctl00_CPHBase_txtProspecto').val();

            var url = 'ProspectoFac.aspx/GenerarFacturas';
            var data = '{ intProspecto: ' + intProspecto + '}';
            CallMethod(url, data, SuccessGenerarFacturas);
        }

        function SuccessGenerarFacturas(response) {
            var message = response.d[0];
            if (message == "ok") {
                alert('Datos guardados correctamente.')
                GetList();
                setInterval(function () { GetList(); }, 30000);
            } else {
                alert(response.d[1]);
            }
        }



        function CerrarPopUp() {
            var magnificPopup = $.magnificPopup.instance;
            magnificPopup.close();
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
                <anthem:ImageButton runat="server" ID="imgProspecto" OnClientClick="var a = Browse('ctl00_CPHBase_txtProspecto','ctl00_CPHBase_txtNombre,ctl00_CPHBase_txtNombre','DACProspectosEsc','',1,2,7,'8', true,'No hay información',1); if(a != undefined) document.getElementById('ctl00_CPHBase_txtProspecto').focus(); else {GetList();return false;}"
                    Height="20px" ImageUrl="../../../Img/ayuda.gif" Width="20" 
                    ImageAlign="AbsMiddle" />
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
                &nbsp;Direccion</td>
            <td class="tLetra36" style="height: 19px">
                <anthem:TextBox ID="txtDireccion" runat="server" CssClass="String" TabIndex="3" 
                     Width="400px" ></anthem:TextBox>
            </td>
             <td class="tLetra3" style="height: 23px">Público General</td>
            <td style="height: 23px">
                <anthem:CheckBox runat="server" ID="chkPG" />
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
            <td>
                &nbsp;</td>
        </tr>

        <tr>
            <td class="tLetra3"  style="width: 13%;">
                &nbsp;Fecha de Envio de Email&nbsp;</td>
            <td class="tLetra36">
                <anthem:TextBox ID="txtFechaEnvio" runat="server" CssClass="String" TabIndex="3" Width="200px" ReadOnly="true"></anthem:TextBox>
            </td>
            <td class="tLetra3">
                &nbsp;</td>
            <td>
                &nbsp;</td>
        </tr>

        <tr>
            <td class="tLetra3"  style="width: 13%;">
                &nbsp;Estatus&nbsp;</td>
            <td class="tLetra36" colspan="2">
                <input id="txtEstatus" class="String"  style="width: 200px;" />
            </td>
            
        </tr>
       
        <tr>
            <td class="tLetra3"  style="width: 13%;"></td>
            <td class="tLetra36" colspan="2">
                <button type="button" id="btnGenerar" onclick="GenerarFacturas();" class="tdButton_Aqua mfp-hide" style="width: 120px; height: 20px;">Generar Facturas</button>
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
            <div style="width:90%;height:auto; " >
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

    <div id="PopUp" class="white-popup mfp-hide">
        <input type="hidden" id="hdnFactura" />
        <table width="100%" border="0" cellspacing="3" cellpadding="3">
            <colgroup>
			    <col width="30%"/>
			    <col width="70%"/>
		    </colgroup>
            <tr>
                <td colspan="2"><h2>Editar Factura</h2></td>
            </tr>
            <tr>
                <td colspan="2"><hr /></td>
            </tr>
           <tr>
               <td>Forma de Pago</td>
               <td>
                   <select id="ddlFormaPago" class="btn dropdown-toggle btn-default">
                        <option value=""></option>
                        <option value="01">(01) Efectivo</option>
                        <option value="02">(02) Cheque nominativo</option>
                        <option value="03">(03) Transferencia electrónica de fondos</option>
                        <option value="04">(04) Tarjeta de crédito</option>
                        <option value="05">(05) Monedero electrónico</option>
                        <option value="06">(06) Dinero electrónico</option>
                        <option value="08">(08) Vales de despensa</option>
                        <option value="12">(12) Dación en pago</option>
                        <option value="13">(13) Pago por subrogación</option>
                        <option value="14">(14) Pago por consignación</option>
                        <option value="15">(15) Condonación</option>
                        <option value="17">(17) Compensación</option>
                        <option value="23">(23) Novación</option>
                        <option value="24">(24) Confusión</option>
                        <option value="25">(25) Remisión de deuda</option>
                        <option value="26">(26) Prescripción o caducidad</option>
                        <option value="27">(27) A satisfacción del acreedor</option>
                        <option value="28">(28) Tarjeta de débito</option>
                        <option value="29">(29) Tarjeta de servicios</option>
                        <option value="30">(30) Aplicación de anticipos</option>
                        <option value="31">(31) Intermediario pagos</option>
                        <option value="99">(99) Por definir</option>

                    </select>
               </td>
           </tr>
            <tr>
                <td>Método de Pago</td>
                <td>
                    <select id="ddlMetodoPago" class="btn dropdown-toggle btn-default">
                        <option value=""></option>
                        <option value="PUE">(PUE) Pago en una Sola Exhibición</option>
                        <option value="PPD">(PPD) Pago en Parcialidades o Diferido</option>
                    </select>
                </td>
            </tr>
            
            <tr>
                <td colspan="2">
                    <%--<button type="button" onclick="CerrarPopUp();" class="tdButton_Aqua" style="width: 120px; height: 22px;">Cancelar</button>--%>
                    <button type="button" onclick="Save();" class="tdButton_Aqua" style="width: 120px; height: 22px;">Guardar</button>
                </td>
            </tr>
        </table>

    </div>

    <div class="modal"></div>

</asp:Content>

