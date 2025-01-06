<%@ Page Language="C#" MasterPageFile="~/Pages/Contabilidad/Catalogos/Base.master"
    AutoEventWireup="true" CodeFile="CuentasRet.aspx.cs" Inherits="Pages_Inventarios_Opciones_CuentasRet"
    Title="Untitled Page" %>


<%@ Register Src="~/Controls/ctrlPagger.ascx" TagName="ctrlPagger" TagPrefix="uc3" %>
<%@ Register Assembly="Anthem" Namespace="Anthem" TagPrefix="anthem" %>
<asp:Content ID="Content1" ContentPlaceHolderID="CPHBase" runat="Server">
    <script type="text/javascript">
    
     $(document).ready(function(){
     $('#firma').hide();
        Obtener();
     });
    
    function Obtener() 
    {
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
                    sortname: "hddintCarteraDet", //Default SortColumn
                    sortorder: "asc", //Default SortOrder.
                    width: "1020",
                    height: "300",
                    caption: "Contabilidad Insumos",
                    gridview:true,
                    ignoreCase:true,
                    rownumbers:false,
                    onCellSelect: function (rowid, index, contents, event) {

//                                    var area = $('#grid').getCell(rowid, 2);
//                                    var StrInsumoInicial =  $('#grid').getCell(rowid, 4);
//                                    var StrInsumoFinal = $('#grid').getCell(rowid, 6);
//                                    var StrCuentaCargo = $('#grid').getCell(rowid, 8);
//                                    var StrCuentaAbono =  $('#grid').getCell(rowid, 10);
                                    
                                    
                                    var area = $('#grid').getCell(rowid, 1);
                                    var StrInsumoInicial =  $('#grid').getCell(rowid, 3);
                                    var StrInsumoFinal = $('#grid').getCell(rowid, 5);
                                    var StrCuentaCargo = $('#grid').getCell(rowid, 7);
                                    var StrCuentaAbono =  $('#grid').getCell(rowid, 9);
                                    var En =  $('#grid').getCell(rowid, 12);
                                    
                                   
                                    document.getElementById("ctl00_CPHBase_hddIntArea").value = area;                                   
                                    document.getElementById("ctl00_CPHBase_hddStrInsumoInicial").value = StrInsumoInicial;                                   
                                    document.getElementById("ctl00_CPHBase_hddStrInsumoFinal").value = StrInsumoFinal;
                                    document.getElementById("ctl00_CPHBase_hddStrCuentaCargo").value= StrCuentaCargo;
                                    document.getElementById("ctl00_CPHBase_hddStrCuentaAbono").value= StrCuentaAbono;
                                    document.getElementById("ctl00_CPHBase_hddEn").value= En;
                                    
                                    if(index < 10)
                                    {
                                        document.getElementById("ctl00_CPHBase_txtRowEdit").value = rowid;
                                        document.getElementById("ctl00_CPHBase_txtRowEdit").onchange(); 
                                    }
                                    
                                   if (index == 13) {
                                        Del();
                                    }
                                 }
                                         
                        }).navGrid("#pager", { edit: false, add: false, search: false, del: false },
                    {},     //  default settings for edit
                    {},     //  default settings for add
                    {},     // delete instead that del:false we need this
                    {}, // search options
                    {});

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

                      $("#grid").jqGrid('setGridParam',{datatype:'local'}).trigger('reloadGrid');   

               } 
               catch (oerror) 
               {
                   alert('Error Obtener ' + oerror.Message);
               }
           }

           

    </script>
    
    <table width="100%" border="0" cellspacing="0" cellpadding="0" style="border-color: Silver;
        border-width: 1px;">
        <tr>
            <td style="height: 24px">
                &nbsp;
                <anthem:TextBox ID="txtRowEdit" runat="server" AutoCallBack="true" OnTextChanged="txtRowEdit_Change"
                    Style="display: none;"></anthem:TextBox>
                <%--<anthem:LinkButton ID="lknEliminar" runat="server" AutoUpdateAfterCallBack="true" OnClientClick="return confirm('¿Desea eliminar?');"  OnClick="lknEliminar_Click" >LinkButton</anthem:LinkButton>--%>
                <asp:LinkButton ID="lknEliminar" runat="server"  OnClick="lknEliminar_Click" Style="display: none">Eliminar</asp:LinkButton>
                <asp:LinkButton ID="lknList" runat="server" OnClick="lknList_Click"  Style="display: none">List</asp:LinkButton>
                <asp:Button ID="btnUpdate" runat="server" OnClick="lknEliminar_Click" Style="display: none" /></td>
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
                <anthem:TextBox ID="txtEmpresa" runat="server" CssClass="String" Width="98px" AutoPostBack="true"
                    OnTextChanged="txtEmpresa_TextChange" TabIndex="1" BorderColor="Navy" />

                       <anthem:ImageButton runat="server" ID="ImageButton6" OnClientClick="var a = JBrowse('ctl00_CPHBase_txtEmpresa','ctl00_CPHBase_txtEmpresa,ctl00_CPHBase_txtNombreEmpresa','DACEmpresa','',1,ctl00_CPHBase_txtEmpresa.value,ctl00_CPHBase_hddSucursal.value,'8', true,'No hay información',function(){document.getElementById('ctl00_CPHBase_txtEmpresa').onchange(); },0); "
                    Height="18px" ImageUrl="../../../Img/ayuda.gif" Width="20" ImageAlign="AbsMiddle" />

                <anthem:TextBox ID="txtNombreEmpresa" runat="server" CssClass="String" Width="250px"
                    ReadOnly="true" BorderColor="Navy" />
                <anthem:HiddenField ID="hddSucursal" runat="server" /><anthem:HiddenField ID="hddInsIni" runat="server" />
                <anthem:HiddenField ID="hddInsFin" runat="server" /><anthem:HiddenField ID="hddEn" runat="server" />
                &nbsp; &nbsp;
                &nbsp; &nbsp;&nbsp;
            </td>
            <td class="tLetra36">
                <anthem:HiddenField ID="hddIntArea" runat="server" />
                <anthem:HiddenField ID="hddStrInsumoInicial" runat="server" />
                <anthem:HiddenField ID="hddStrInsumoFinal" runat="server" />
                <anthem:HiddenField ID="hddStrCuentaCargo" runat="server" />
                <anthem:HiddenField ID="hddStrCuentaAbono" runat="server" />
            </td>
        </tr>
        <tr>
            <td class="tLetra3">
                Area:
            </td>
            <td class="tLetra36">
                <anthem:TextBox ID="txtArea" runat="server" CssClass="String" Width="98px" AutoPostBack="true"
                    OnTextChanged="txtArea_TextChange" TabIndex="7" BorderColor="Navy" />

                       <anthem:ImageButton runat="server" ID="ImageButton7" OnClientClick="var a = JBrowse('ctl00_CPHBase_txtArea','ctl00_CPHBase_txtArea,ctl00_CPHBase_txtNombreArea','DACArea','',1,ctl00_CPHBase_txtEmpresa.value,ctl00_CPHBase_hddSucursal.value,'8', true,'No hay información',function(){document.getElementById('ctl00_CPHBase_txtArea').onchange(); },0); "
                    Height="18px" ImageUrl="../../../Img/ayuda.gif" Width="20" ImageAlign="AbsMiddle" />

                <anthem:TextBox ID="txtNombreArea" runat="server" CssClass="String" Width="250px"
                    ReadOnly="true" BorderColor="Navy" />
            </td>
            <td class="tLetra3">
                Tipo:
            </td>
            <td class="tLetra36" valign="middle" style="width: 600px; height: 25px">
                <anthem:RadioButtonList ID="rbTipo" runat="server" RepeatDirection="Horizontal">
                    <Items>
                    <asp:ListItem Value="1">Entrada</asp:ListItem>
                    <asp:ListItem Value="0">Salida</asp:ListItem>
                    <asp:ListItem Value="-1" Selected="True">Todos</asp:ListItem>
                    </Items>
                </anthem:RadioButtonList></td>
        </tr>
        <tr>
            <td class="tLetra3">
                Insumo Ini:
            </td>
            <td class="tLetra36">
                <anthem:TextBox ID="txtInsumoIni" runat="server" CssClass="String" Width="98px" AutoCallBack="true"
                    OnTextChanged="txtInsumoIni_TextChange" TabIndex="7" BorderColor="Navy" />

                       <anthem:ImageButton runat="server" ID="ImageButton8" OnClientClick="var a = JBrowse('ctl00_CPHBase_txtInsumoIni','ctl00_CPHBase_txtInsumoIni,ctl00_CPHBase_txtNombreInsumoIni','DACArticulo','',4,ctl00_CPHBase_txtEmpresa.value,ctl00_CPHBase_hddSucursal.value,'8', true,'No hay información',function(){document.getElementById('ctl00_CPHBase_txtInsumoIni').onchange(); },0); "
                    Height="18px" ImageUrl="../../../Img/ayuda.gif" Width="20" ImageAlign="AbsMiddle" />

                <anthem:TextBox ID="txtNombreInsumoIni" runat="server" CssClass="String" Width="250px"
                    ReadOnly="true" BorderColor="Navy" />
            </td>
            <td class="tLetra3">
                Cta Cargo:
            </td>
            <td class="tLetra36">
                <anthem:TextBox ID="txtCtaCargo" runat="server" CssClass="String" Width="98px" AutoCallBack="true"
                    OnTextChanged="txtCtaCargo_TextChange" TabIndex="7" BorderColor="Navy" />

                       <anthem:ImageButton runat="server" ID="ImageButton10" OnClientClick="var a = JBrowse('ctl00_CPHBase_txtCtaCargo','ctl00_CPHBase_txtCtaCargo,ctl00_CPHBase_txtNombreCtaCargo','DACCuentas','',1,ctl00_CPHBase_txtEmpresa.value,ctl00_CPHBase_hddSucursal.value,'8', true,'No hay información',function(){document.getElementById('ctl00_CPHBase_txtCtaAbono').focus(); },0); "
                    Height="18px" ImageUrl="../../../Img/ayuda.gif" Width="20" ImageAlign="AbsMiddle" />

                <anthem:TextBox ID="txtNombreCtaCargo" runat="server" CssClass="String" Width="274px"
                    ReadOnly="true" BorderColor="Navy" />
            </td>
        </tr>
        <tr>
            <td class="tLetra3">
                Insumo Fin:
            </td>
            <td class="tLetra36">
                <anthem:TextBox ID="txtInsumoFin" runat="server" CssClass="String" Width="98px" AutoCallBack="true"
                    OnTextChanged="txtInsumoFin_TextChange" TabIndex="7" BorderColor="Navy" />

                       <anthem:ImageButton runat="server" ID="ImageButton9" OnClientClick="var a = JBrowse('ctl00_CPHBase_txtInsumoFin','ctl00_CPHBase_txtInsumoFin,ctl00_CPHBase_txtNombreInsumoFin','DACArticulo','',4,ctl00_CPHBase_txtEmpresa.value,ctl00_CPHBase_hddSucursal.value,'8', true,'No hay información',function(){document.getElementById('ctl00_CPHBase_txtCtaCargo').onchange(); },0); "
                    Height="18px" ImageUrl="../../../Img/ayuda.gif" Width="20" ImageAlign="AbsMiddle" />

                <anthem:TextBox ID="txtNombreInsumoFin" runat="server" CssClass="String" Width="250px"
                    ReadOnly="true" BorderColor="Navy" />
            </td>
            <td class="tLetra3">
                Cta Abono:
            </td>
            <td class="tLetra36">
                <anthem:TextBox ID="txtCtaAbono" runat="server" CssClass="String" Width="98px" AutoCallBack="true"
                    OnTextChanged="txtCtaAbono_TextChange" TabIndex="7" BorderColor="Navy" />

                       <anthem:ImageButton runat="server" ID="ImageButton11" OnClientClick="var a = JBrowse('ctl00_CPHBase_txtCtaAbono','ctl00_CPHBase_txtCtaAbono,ctl00_CPHBase_txtNombreCtaAbono','DACCuentas','',1,ctl00_CPHBase_txtEmpresa.value,ctl00_CPHBase_hddSucursal.value,'8', true,'No hay información',function(){document.getElementById('ctl00_CPHBase_btnBuscar').focus(); },0); "
                    Height="18px" ImageUrl="../../../Img/ayuda.gif" Width="20" ImageAlign="AbsMiddle" />

                <anthem:TextBox ID="txtNombreCtaAbono" runat="server" CssClass="String" Width="274px"
                    ReadOnly="true" BorderColor="Navy" />
            </td>
        </tr>
    </table>
    <br />
        <table>
        <tr>
            <td style="width: 5px">
                <div style="width: 100%; height: auto; background: #f5f3f4;">
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
               return objUtils.validaItems("ctl00_CPHBase_txtEmpresa,ctl00_CPHBase_txtArea,ctl00_CPHBase_txtInsumoIni,ctl00_CPHBase_txtInsumoFin,ctl00_CPHBase_txtCtaCargo,ctl00_CPHBase_txtCtaAbono");

            }                                 
                 
             function Del()
            {
               // document.getElementById("ctl00_CPHBase_lknEliminar").onclick();
                document.getElementById('<%=lknEliminar.ClientID%>').click(); 
                //document.getElementById('<%=btnUpdate.ClientID%>').click();
            }
                                                                                              
         </script>    
</asp:Content>
