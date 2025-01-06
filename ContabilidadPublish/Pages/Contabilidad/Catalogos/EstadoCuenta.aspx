<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="Base.master" CodeFile="EstadoCuenta.aspx.cs" Inherits="Contabilidad_Compra_Opciones_EstadoCuenta" Culture="auto" UICulture="auto" %>
<%@ Register Assembly="Anthem" Namespace="Anthem" TagPrefix="anthem" %>
<%@ Register Assembly="DevExpress.Web.ASPxEditors.v8.3" Namespace="DevExpress.Web.ASPxEditors"
    TagPrefix="dxe" %>
<%@ Register Assembly="DevExpress.Web.ASPxEditors.v8.3, Version=8.3.4.0, Culture=neutral, PublicKeyToken=5377C8E3B72B4073"
    Namespace="DevExpress.Web.ASPxEditors" TagPrefix="dxe" %>

<asp:Content ID="Content" ContentPlaceHolderID="CPHBase" Runat="Server">      
	  <table width="100%" border="0" cellspacing="0" cellpadding="0" style="border-color:Silver; border-width:1px;">                       
           <tr>
                <td>
                    &nbsp; &nbsp;
                </td>
           </tr>     
        </table>
         <script type="text/javascript" language="javascript">
            var objUtils = new VetecUtils();      	
                				    
                     function datosCompletos()
            {
               return objUtils.validaItems("ctl00_CPHBase_txtEmpresa,ctl00_CPHBase_txtCtaBanc,ctl00_CPHBase_fuArchivo");

            }                                 
                                                                                  
         </script>        
                <table width="100%" border="0" cellspacing="0" cellpadding="0">                                               
                    <tr>
                       <td valign="middle" background="../../Imagenes/img_tabs/fondo_down_long.jpg" width="100%" style="height: 814px">
                          <anthem:Panel id="pnlGrid" runat="server" Width="100%" Height="800px" >
                              <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                  <colgroup>
                                      <col width="12%" />
                                      <col width="40%" />
                                      <col width="10%" />
                                      <col width="38%" />
                                  </colgroup>
                                  <tr>
                                      <td class="tLetra3">
                                          &nbsp;&nbsp;Empresa:
                                      </td>
                                      <td class="tLetra36">
                                          <anthem:TextBox ID="txtEmpresa" runat="server" AutoCallBack="true" BorderColor="Navy"
                                              CssClass="String" OnTextChanged="txtEmpresa_TextChange" Width="80px"></anthem:TextBox>
                                          <anthem:ImageButton ID="ImageButton7" runat="server" Height="17" ImageUrl="../../../Img/ayuda.gif"
                                              OnClientClick="var a = Browse('ctl00_CPHFilters_txtEmpresa','ctl00_CPHFilters_txtEmpresa,ctl00_CPHFilters_txtNombreEmpresa','DACEmpresa','',1,ctl00_CPHFilters_txtEmpresa.value,ctl00_CPHFilters_hddSucursal.value,'8', true,'No hay información'); if(a != undefined) document.getElementById('ctl00_CPHFilters_txtEmpresa').onchange(); else return false;"
                                              Width="20" />
                                          <anthem:TextBox ID="txtNombreEmpresa" runat="server" BorderColor="Navy" CssClass="String"
                                              ReadOnly="true" Width="300px"></anthem:TextBox><anthem:HiddenField ID="hddSucursal"
                                                  runat="server" />
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
                                          &nbsp;&nbsp; Ejercicio:
                                      </td>
                                      <td class="tLetra36" style="height: 23px">
                                          <anthem:DropDownList ID="cboYear" runat="server" AutoCallBack="True" CssClass="String"
                                              TabIndex="1" Width="120px">
                                          </anthem:DropDownList></td>
                                      <td class="tLetra3" style="height: 23px">
                                          &nbsp;
                                      </td>
                                      <td style="height: 23px">
                                          &nbsp;
                                      </td>
                                  </tr>
                                  <tr>
                                      <td class="tLetra3">
                                          &nbsp;&nbsp; Mes:</td>
                                      <td class="tLetra36">
                                          <anthem:DropDownList ID="cboMonth" runat="server" CssClass="String" TabIndex="2"
                                              Width="120px">
                                          </anthem:DropDownList></td>
                                      <td class="tLetra3">
                                      </td>
                                      <td>
                                      </td>
                                  </tr>
                                  <tr>
                                      <td class="tLetra3" style="height: 23px">
                                          &nbsp;&nbsp; Cuenta Bancaria</td>
                                      <td class="tLetra36" style="height: 23px">
                                          <anthem:TextBox ID="txtCtaBanc" runat="server" AutoCallBack="true" CssClass="String"
                                              OnTextChanged="txtCtaBanc_TextChanged" TabIndex="3" Width="80px"></anthem:TextBox>&nbsp;<anthem:ImageButton
                                                  ID="ImageButton4" runat="server" Height="17" ImageUrl="../../../Img/ayuda.gif"
                                                  OnClientClick="var a = Browse('ctl00_CPHBase_txtCtaBanc','ctl00_CPHBase_txtCtaBanc,ctl00_CPHBase_txtCtaBancDes','DACFactura','',18,ctl00_CPHBase_txtEmpresa.value,ctl00_CPHBase_hddSucursal.value,'8', true,'No hay información'); if(a != undefined) document.getElementById('ctl00_CPHBase_txtCtaBanc').onchange(); return false;"
                                                  Width="20" />
                                          <anthem:TextBox ID="txtCtaBancDes" runat="server" CssClass="String" TabIndex="4"
                                              Width="300px"></anthem:TextBox></td>
                                      <td class="tLetra3" style="height: 23px">
                                      </td>
                                      <td style="height: 23px">
                                      </td>
                                  </tr>
                                  <tr>
                                      <td class="tLetra3" style="height: 23px">
                                          &nbsp;&nbsp; Archivo</td>
                                      <td class="tLetra36" style="height: 23px">
                                    <asp:FileUpload ID="fuArchivo" runat="server" CssClass="FileUpload" TabIndex="5" Width="416px" /></td>
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
                             <table width="100%" border="0" cellspacing="0" cellpadding="0">
                             <tr>
                                <td align="center">
                                    <div id="div-ListPanel2" style="height: 315px">
                                     <anthem:GridView ID="grdEstado" AutoGenerateColumns="false" runat="server"  AllowSorting="true" 
                                       CellPadding="0" CellSpacing="0" BorderWidth="0" GridLines="None" 
                                       OnRowDataBound="row_Created"
                                       CssClass="dxgvTable_Aqua" 
                                      HeaderStyle-CssClass="dxgvHeader_PlasticBlue"  Width="100%"
                                       >
                                          <Columns>                                                                                                                                                                                    			    
			                                  <asp:BoundField DataField="datFecha" HeaderText="Fecha" ItemStyle-HorizontalAlign="Center" ItemStyle-Width="100px">
			                                  </asp:BoundField>				                          
		                                      <asp:BoundField DataField="strConcepto" HeaderText="Concepto" ItemStyle-HorizontalAlign="Left" ItemStyle-Width="400px">
			                                  </asp:BoundField>	
			                                  <asp:BoundField DataField="strReferencia" HeaderText="Referencia" ItemStyle-HorizontalAlign="Left" ItemStyle-Width="140px">
			                                  </asp:BoundField>				                                   
			                                  <asp:BoundField DataField="Cargos" HeaderText="Cargos" ItemStyle-HorizontalAlign="Right" ItemStyle-Width="100px">
			                                  </asp:BoundField>
			                                  <asp:BoundField DataField="Abonos" HeaderText="Abonos" ItemStyle-HorizontalAlign="Right" ItemStyle-Width="100px">
			                                  </asp:BoundField>			                                                     	                            
                                          </Columns>                                                                          
                                      </anthem:GridView>
                                      </div>
                                </td>
                             </tr> 
                             </table>                             
                              <br />
                         </anthem:Panel>
                        </td>
                    </tr>
               </table>  
    </asp:Content>

   