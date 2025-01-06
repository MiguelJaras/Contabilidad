<%@ Page Title="" Language="C#" MasterPageFile="Base.master" AutoEventWireup="true" CodeFile="FacturacionEstimacion.aspx.cs" Inherits="Pages_Opciones_FacturacionEstimacion" %>
<%@ Register Assembly="Anthem" Namespace="Anthem" TagPrefix="anthem" %>

<asp:Content ID="Content1" ContentPlaceHolderID="CPHBase" Runat="Server">

 <script type="text/javascript" src="../../../Scripts/Magnific-Popup-master/jquery.magnific-popup.js"></script>

    
 <script type="text/javascript" language="javascript">
     var objUtils = new VetecUtils();
        $(document).ready(function(){
        });


        //var interval;
        //interval = setInterval(function () {
        //   // GetList();
        // }, 15000);
        

        function GetList() {
            var intProspecto = 0;
            var intEjercicio = document.getElementById('<%=cboEjercicio.ClientID %>').value;
            var intSemana = document.getElementById('<%=cboSemana.ClientID %>').value;
            var urlData = 'FacturacionEstimacion.aspx/GetList';
            var dataData = '{ intEjercicio: ' + intEjercicio + ' ,intSemana:' + intSemana + '}';
            CallMethod(urlData, dataData, SuccessData);
        }

        function SuccessData(response) {
            var message = response.d[0];1
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
                            "Empresa",
                            "Cliente",
                            "Obra",
                            "Orden",
                        ],
                        colModel: [
                            { 'index': 'Empresa', 'name': 'Empresa', 'width': 250, align: 'left', formatter: '' },
                            { 'index': 'Cliente', 'name': 'Cliente', 'width': 250, align: 'Center', formatter: '' },
                            { 'index': 'Obra', 'name': 'Obra', 'width': 200, align: 'Center', formatter: '' },
                            { 'index': 'OC', 'name': 'OC', 'width': 200, align: 'Center', formatter: '' },
                            
                        ],
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

                    }
                );

            }//end try
            catch (oerror) {
                alert('Error Obtener 1 ' + oerror);
            }
        }


    </script>


    <table border="0" cellpadding="0" cellspacing="0" width="100%">
        <colgroup>
            <col width="12%" />
            <col width="88%" />
        </colgroup>
        <tr>
            <td>
                &nbsp;
            </td>
        </tr>
       
        <tr>
            <td class="tLetra3"  style="width: 13%;">Ejercicio:</td>
            <td class="tLetra36">
                <anthem:DropDownList ID="cboEjercicio" runat="server" CssClass="String"
                    TabIndex="3" Width="120px">
                </anthem:DropDownList>
            </td>
            
        </tr>


        <tr>
            <td class="tLetra3"  style="width: 13%; height: 23px;">Semana:</td>
            <td class="tLetra36" style="height: 23px">
                <anthem:DropDownList ID="cboSemana" runat="server" CssClass="String" TabIndex="4"
                    Width="120px" AutoCallBack="True">
                </anthem:DropDownList>
            </td>
            
        </tr>


        <tr>
            <td class="tLetra3"  style="width: 13%;">Archivo</td>
            <td class="tLetra36">
                <anthem:FileUpload ID="fuArchivo" runat="server" CssClass="FileUpload" Width="501px" />
            </td>
            
        </tr>


        <tr style="font-size: 9pt">
            <td class="tLetra3" style="height: 23px;" colspan="2">
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
    <script type="text/javascript" language="javascript">
        var objUtils = new VetecUtils();

        function datosCompletos() {
            var returnLlamada;
            returnLlamada = true;

            returnLlamada = objUtils.validaItems("ctl00_CPHBase_fuArchivo");

            return returnLlamada;
        }

    </script>


</asp:Content>

