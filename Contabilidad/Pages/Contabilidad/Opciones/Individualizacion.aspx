<%@ Page Language="C#" MasterPageFile="Base.master" MaintainScrollPositionOnPostback="true" ValidateRequest="false"
 CodeFile="Individualizacion.aspx.cs" Inherits="Pages_Contabilidad_Opciones_Individualizacion"
    Title="Individualizacion" %>


<%@ Register Assembly="Anthem" Namespace="Anthem" TagPrefix="anthem" %>
<asp:Content ID="Content1" ContentPlaceHolderID="CPHBase" runat="Server">
 <script type="text/javascript">
    
     $(document).ready(function(){
        Obtener();
     });
    
    function Obtener() 
    {
        var grid = $("#grid");
        grid.jqGrid('GridUnload');
           try {         
               $grid = $("#grid").jqGrid(
                {
                    datatype: 'local',
                    data:[ <%= dataList.ToString() %>],                    
                    colNames: [<%= dataColumns.ToString() %>],
                    colModel: //Columns
                    [
                        <%= colModel.ToString() %>
                    ],                                                            
                      pager: "#pager", //Pager.
                    loadtext: 'Loading...',
                    recordtext: "{0} - {1} de {2} elements",
                    emptyrecords: 'No hay resultados',
                    pgtext: 'Pág: {0} de {1}', //Paging input control text format.
                    rowNum: "100", // PageSize.
                    rowList: [100,200,300,500], //Variable PageSize DropDownList. 
                    viewrecords: true, //Show the RecordCount in the pager.
                    multiselect: false,
                    sortname: "intLote", //Default SortColumn
                    sortorder: "asc", //Default SortOrder.
                    //autowidth: true,
                    //setGridWidth : "1000",
                    width:"1090",
                    shrinkToFit:false, 
                    height: "400",
                    caption: "Individualizacion",
                    gridview:true,
                    ignoreCase:true,
                    rownumbers:false,
                                       
                    grouping: true,
                    groupingView: {
                            groupField: ['ColoniaVivienda'],
                            groupSummary: [true],
                            groupColumnShow: [false],
                            groupText: ['<b>{0}</b>'],
                            groupCollapse: false,
                            groupOrder: ['asc']
                     },                    
                     summaryType: function (val, name, record) {
                        if (typeof (val) === "string") {
                            val = {max: false, totalCount: 0, checkedCount: 0};
                        }
                        val.totalCount += 1;
                        if (record[name]) {
                            val.checkedCount += 1;
                            val.max = true;
                        }
                        return val;
                    },                                       
                    
                    onCellSelect: function (rowid, index, contents, event) {
                                    
                                 }
                                     }).trigger("reloadGrid").navGrid("#pager", { edit: false, add: false, search: false, del: false },
                    {},     //  default settings for edit
                    {},     //  default settings for add
                    {},     // delete instead that del:false we need this
                    {}, // search options
                    {});

                    grid.jqGrid('navButtonAdd', '#pager', {
                    caption: "Export to Excel",
                    onClickButton: function () {
                        Export();
//                        grid.jqGrid('excelExport', { url: '/Export/ExportExcel.xls' });
                        }
                    })

                var timeoutHnd, k = $.ui.keyCode,
                toSkip = [k.TAB, k.SHIFT, k.ALT, k.ESCAPE, k.LEFT, k.UP, k.RIGHT, k.DOWN, k.HOME, k.END, k.INSERT];
                $("#grid").filterToolbar({ stringResult: true, searchOnEnter: false, multipleSearch: true });

                $grid.closest(".ui-jqgrid-view")
                      .find(".ui-jqgrid-hdiv .ui-search-toolbar input[type=text]")
                      .keydown(function (e) {
                          var key = e.which;
                          if ($.inArray(key, toSkip) < 0) {
                              if (timeoutHnd) { clearTimeout(timeoutHnd); timeoutHnd = 0; }
                              timeoutHnd = setTimeout(function () {
                                  var sgrid = $grid[0];
                                  sgrid.triggerToolbar();
                                  timeoutHnd = 0;
                              }, 1000);
                          }
                      });
                       

               } 
               catch (oerror) 
               {
                   alert('Error Obtener ' + oerror.Message);
               }
                                         
//                        }).navGrid("#pager", { edit: false, add: false, search: false, del: false },
//                    {},     //  default settings for edit
//                    {},     //  default settings for add
//                    {},     // delete instead that del:false we need this
//                    {}, // search options
//                    {});

//                var timeoutHnd, k = $.ui.keyCode,
//                toSkip = [k.TAB, k.SHIFT, k.ALT, k.ESCAPE, k.LEFT, k.UP, k.RIGHT, k.DOWN, k.HOME, k.END, k.INSERT];
//                $("#grid").filterToolbar({ stringResult: true, searchOnEnter: false, multipleSearch: true });
//               
//                $grid.closest(".ui-jqgrid-view")
//                      .find(".ui-jqgrid-hdiv .ui-search-toolbar input[type=text]")
//                      .keydown(function (e) {
//                          var key = e.which;
//                          if ($.inArray(key, toSkip) < 0) {
//                              if (timeoutHnd) { clearTimeout(timeoutHnd); timeoutHnd = 0; }
//                              timeoutHnd = setTimeout(function () {
//                                  var sgrid = $grid[0];
//                                  sgrid.triggerToolbar();
//                                  timeoutHnd = 0;
//                              }, 1000);
//                          }
//                      });

//                      $("#grid").jqGrid('setGridParam',{datatype:'local'}).trigger('reloadGrid');   

//               } 
//               catch (oerror) 
//               {
//                   alert('Error Obtener ' + oerror.Message);
//               }
           }

           
    function Export(){
    var html = document.getElementById("grid").innerHTML;
    document.getElementById("ctl00_CPHBase_hddBody").value = html;
    document.getElementById("ctl00_CPHBase_lknExport").click();
    }
    </script>
    
    <table width="100%" border="0" cellspacing="0" cellpadding="0" style="border-color: Silver;
        border-width: 1px;">
        <tr>
            <td style="height: 25px">
                &nbsp; &nbsp;<%--<anthem:LinkButton ID="lknEliminar" runat="server" AutoUpdateAfterCallBack="true" OnClientClick="return confirm('¿Desea eliminar?');"  OnClick="lknEliminar_Click" >LinkButton</anthem:LinkButton>--%>
                <asp:LinkButton ID="lknList" runat="server" OnClick="lknList_Click"  Style="display: none">List</asp:LinkButton>
                <asp:LinkButton ID="lknExport" runat="server" OnClick="lknExport_Click"  Style="display: none">List</asp:LinkButton>
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
                Colonia:
            </td>
            <td class="tLetra36">
                <anthem:DropDownList ID="cboColonia" runat="server" CssClass="String" TabIndex="2"
                    Width="419px" AutoPostBack="True" OnSelectedIndexChanged="cboColonia_SelectedIndexChanged" >
                </anthem:DropDownList></td>
            <td class="tLetra3">
            </td>
            <td class="tLetra36" valign="middle" style="width: 600px; height: 25px">
                <asp:HiddenField ID="hddBody" runat="server" />;
                </td>
        </tr>
        <tr>
            <td class="tLetra3">
                Sector:</td>
            <td class="tLetra36">
                <anthem:DropDownList ID="cboSector" runat="server" CssClass="String" TabIndex="2"
                    Width="219px" AutoPostBack="True" >
                </anthem:DropDownList></td>
            <td class="tLetra3">
            </td>
            <td class="tLetra36" style="width: 600px; height: 25px" valign="middle">
            </td>
        </tr>
        <tr>
            <td class="tLetra3" style="height: 21px">
                Fecha Ini:
            </td>
            <td class="tLetra36" style="height: 21px">
                <anthem:TextBox ID="txtFechaInicial" runat="server" CssClass="String" TabIndex="1" AutoCallBack="true"
                    Width="80px"></anthem:TextBox>
                <anthem:ImageButton ID="ImgDate" runat="server" ImageUrl="../../../Scripts/Calendar/Calendar.JPG" />
                </td>
            <td class="tLetra3" style="height: 21px">
                Fecha Fin:
            </td>
            <td class="tLetra36" style="height: 21px">
                &nbsp;<anthem:TextBox ID="txtFechaFinal" runat="server" CssClass="String" TabIndex="2" AutoCallBack="true"
                    Width="80px"></anthem:TextBox>
                <anthem:ImageButton ID="ImgDateFin" runat="server"
                        ImageUrl="../../../Scripts/Calendar/Calendar.JPG" />
            </td>
        </tr>
        <tr>
            <td class="tLetra3" style="height: 64px">
                Ordenamiento:</td>
            <td class="tLetra36" style="height: 64px">
                <asp:RadioButtonList ID="rbOrder" runat="server">
                    <asp:ListItem Selected="True" Value="1">Fecha Escrituraci&#243;n</asp:ListItem>
                    <asp:ListItem Value="2">Manzana - Lote</asp:ListItem>
                </asp:RadioButtonList></td>
            <td class="tLetra3" style="height: 64px">
            </td>
            <td class="tLetra36" style="height: 64px">
            </td>
        </tr>
    </table>
    <br />
    <table >
        <tr>
            <td >
                <div style="background: #f5f3f4;">
                    <div id="grilla">
                        <table id="grid">
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
                				    
            function datosCompletos()
            {
               return objUtils.validaItems("ctl00_CPHBase_cboColonia");
            }                                 
            
//            function Out(obj) 
//            {            
//                obj.style.font = "12px Tahoma";
//                obj.style.color = "#283B56"; 
//                obj.style.padding = "0px";
//                obj.style.backgroundColor = "#F2F8FF";            
//                obj.style.border = "solid 1px #F2F8FF";                   
//                obj.style.cursor = "hand";
//            }
//            
//            function Over(obj) 
//            {         
//                obj.style.border = "Solid 1px #FFAB3F";
//                obj.style.font = "12px Tahoma";
//                obj.style.color = "#283B56"; 
//                obj.style.padding = "0px";
//                obj.style.backgroundColor = "#FFBD69";            
//                obj.style.border = "solid 1px #F2F8FF";                   
//                obj.style.cursor = "hand";
//            }
                                                                                              
         </script>    
</asp:Content>
