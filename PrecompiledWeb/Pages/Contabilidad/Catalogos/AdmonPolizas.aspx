<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="Base.master" CodeFile="AdmonPolizas.aspx.cs" Inherits="Contabilidad_Compra_Opciones_AdmonPolizas" Culture="auto" UICulture="auto" %>
<%@ Register Assembly="Anthem" Namespace="Anthem" TagPrefix="anthem" %>

<asp:Content ID="Content" ContentPlaceHolderID="CPHBase" Runat="Server">      
      <table width="100%" border="0" cellspacing="0" cellpadding="0" style="border-color:Silver; border-width:1px;">                       
           <tr>
                <td>
                    &nbsp;
                    <anthem:TextBox ID="txtRowEdit" runat="server" AutoCallBack="true" style="display:none;"  ></anthem:TextBox>&nbsp;
                    <anthem:TextBox ID="txtEmpleadoInt" runat="server" AutoCallBack="true" Style="display: none"></anthem:TextBox>
               </td>
           </tr>     
        </table>
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <colgroup>
			    <col width="12%"/>
			    <col width="40%"/>
			    <col width="10%"/>
			    <col width="38%"/>
		    </colgroup>
		    <tr>
                <td class="tLetra3">
                    &nbsp;&nbsp;&nbsp;Empresa:
                </td>
                <td class="tLetra36">
                    <anthem:TextBox ID="txtEmpresa" runat="server" AutoCallBack="true" BorderColor="Navy"
                        CssClass="String" OnTextChanged="txtEmpresa_TextChange" TabIndex="1" Width="80px"></anthem:TextBox>&nbsp;
                    
                       <anthem:ImageButton runat="server" ID="ImageButton6" OnClientClick="var a = JBrowse('ctl00_CPHBase_txtEmpresa','ctl00_CPHBase_txtEmpresa,ctl00_CPHBase_txtNombreEmpresa','DACEmpresa','',1,ctl00_CPHBase_txtEmpresa.value,ctl00_CPHBase_hddSucursal.value,'8', true,'No hay información',function(){document.getElementById('ctl00_CPHBase_txtEmpresa').onchange(); },0); "
                    Height="18px" ImageUrl="../../../Img/ayuda.gif" Width="20" ImageAlign="AbsMiddle" />

                    <anthem:TextBox ID="txtNombreEmpresa" runat="server" BorderColor="Navy" CssClass="String"
                        ReadOnly="true" Width="300px"></anthem:TextBox><anthem:HiddenField ID="hddSucursal"
                            runat="server" />
                </td>
                <td  class="tLetra3">
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
                    <anthem:DropDownList ID="cboEjercicio" runat="server" CssClass="tDatos150" TabIndex="8"
                        Width="300px" AutoCallBack="True" OnSelectedIndexChanged="cboEjercicio_SelectedIndexChanged">
                    </anthem:DropDownList></td>
                <td  class="tLetra3" style="height: 23px">
                    &nbsp;
                </td>
                <td style="height: 23px">                    
                   &nbsp;
               </td>
            </tr>
          <tr>
              <td class="tLetra3">
                  &nbsp;&nbsp; Tipo Poliza:</td>
              <td class="tLetra36">
                  <anthem:DropDownList ID="cboTipoPol" runat="server" CssClass="tDatos150" 
                      TabIndex="8" Width="300px" AutoCallBack="True" OnSelectedIndexChanged="cboTipoPol_SelectedIndexChanged">
                  </anthem:DropDownList></td>
              <td class="tLetra3">
              </td>
              <td>
              </td>
          </tr>
          <tr>
              <td class="tLetra3" style="height: 23px">
                  &nbsp;&nbsp; </td>
              <td class="tLetra36" style="height: 23px">
                  </td>
              <td class="tLetra3" style="height: 23px">
              </td>
              <td style="height: 23px">
              </td>
          </tr>
        </table>
      <table width="100%" > 
            <tr> 
                <td>   
                    <div  id="div-ListPanel"> 
		                <anthem:GridView Width="98%" DataKeyNames="strTipoPoliza"  ID="DgrdList" HeaderStyle-CssClass="dxgvHeader_PlasticBlue"
			                  OnRowDeleting="DgrdList_RowDeleting" runat="server" AllowSorting="True" AutoGenerateColumns="False"  OnRowCreated ="DgrdList_RowCreated"
		                    CellPadding="0" CellSpacing="0" GridLines="None" >			
		                <Columns>
		                    <asp:BoundField DataField="strTipoPoliza"  HeaderText="#" ItemStyle-Width="8%">
                             </asp:BoundField>
		                     <asp:BoundField DataField="strNombre"  HeaderText="Tipo Poliza" ItemStyle-Width="18%">
                             </asp:BoundField>                             
       				         <asp:TemplateField HeaderText="Enero" ShowHeader="True" ItemStyle-Width="6%">
		                        <itemtemplate>
		                            <anthem:TextBox runat="server" ID="txtM1" Text='<%# Eval("intM1") %>' Width="99%"></anthem:TextBox>
		                         </itemtemplate>
		                    </asp:TemplateField>		                    
				            <asp:TemplateField HeaderText="Febrero" ShowHeader="True" ItemStyle-Width="6%">
		                        <itemtemplate>
		                            <anthem:TextBox runat="server" ID="txtM2" Text='<%# Eval("intM2") %>' Width="99%"></anthem:TextBox>
                                </itemtemplate>
		                    </asp:TemplateField>		                    
				            <asp:TemplateField HeaderText="Marzo" ShowHeader="True" ItemStyle-Width="6%">
		                        <itemtemplate>
		                           <anthem:TextBox runat="server" ID="txtM3" Text='<%# Eval("intM3") %>' Width="99%"></anthem:TextBox>
                                </itemtemplate>
		                    </asp:TemplateField>		                    
		                    <asp:TemplateField HeaderText="Abril" ShowHeader="True" ItemStyle-Width="6%">
		                        <itemtemplate>
		                           <anthem:TextBox runat="server" ID="txtM4" Text='<%# Eval("intM4") %>' Width="99%"></anthem:TextBox>
                                </itemtemplate>
		                    </asp:TemplateField>			                    
		                    <asp:TemplateField HeaderText="Mayo" ShowHeader="True" ItemStyle-Width="6%">
		                        <itemtemplate>
		                           <anthem:TextBox runat="server" ID="txtM5" Text='<%# Eval("intM5") %>' Width="99%"></anthem:TextBox>
                                </itemtemplate>
		                    </asp:TemplateField>			                    
		                    <asp:TemplateField HeaderText="Junio" ShowHeader="True" ItemStyle-Width="6%">
		                        <itemtemplate>
		                           <anthem:TextBox runat="server" ID="txtM6" Text='<%# Eval("intM6") %>' Width="99%"></anthem:TextBox>
                                </itemtemplate>
		                    </asp:TemplateField>			                    
		                    <asp:TemplateField HeaderText="Julio" ShowHeader="True" ItemStyle-Width="6%">
		                        <itemtemplate>
		                           <anthem:TextBox runat="server" ID="txtM7" Text='<%# Eval("intM7") %>' Width="99%"></anthem:TextBox>
                                </itemtemplate>
		                    </asp:TemplateField>			                    
		                    <asp:TemplateField HeaderText="Agosto" ShowHeader="True" ItemStyle-Width="6%">
		                        <itemtemplate>
		                           <anthem:TextBox runat="server" ID="txtM8" Text='<%# Eval("intM8") %>' Width="99%"></anthem:TextBox>
                                </itemtemplate>
		                    </asp:TemplateField>			                    
		                    <asp:TemplateField HeaderText="Septiembre" ShowHeader="True" ItemStyle-Width="6%">
		                        <itemtemplate>
		                           <anthem:TextBox runat="server" ID="txtM9" Text='<%# Eval("intM9") %>' Width="99%"></anthem:TextBox>
                                </itemtemplate>
		                    </asp:TemplateField>			                    
		                    <asp:TemplateField HeaderText="Octubre" ShowHeader="True" ItemStyle-Width="6%">
		                        <itemtemplate>
		                           <anthem:TextBox runat="server" ID="txtM10" Text='<%# Eval("intM10") %>' Width="98%"></anthem:TextBox>
                                </itemtemplate>
		                    </asp:TemplateField>			                    
		                    <asp:TemplateField HeaderText="Noviembre" ShowHeader="True" ItemStyle-Width="6%">
		                        <itemtemplate>
		                           <anthem:TextBox runat="server" ID="txtM11" Text='<%# Eval("intM11") %>' Width="98%"></anthem:TextBox>
                                </itemtemplate>
		                    </asp:TemplateField>			                    
		                    <asp:TemplateField HeaderText="Diciembre" ShowHeader="True" ItemStyle-Width="6%">
		                        <itemtemplate>
		                           <anthem:TextBox runat="server" ID="txtM12" Text='<%# Eval("intM12") %>' Width="98%"></anthem:TextBox>
                                </itemtemplate>
		                    </asp:TemplateField>	                    		                    
		                </Columns>
                            <HeaderStyle CssClass="dxgvHeader_PlasticBlue" />
		                </anthem:GridView>
                    </div>                         
                </td> 
            </tr> 
        </table> 
         <script type="text/javascript" language="javascript">
            var objUtils = new VetecUtils();      	
                				    
            function datosCompletos()
            {
               return objUtils.validaItems("ctl00_CPHBase_txtAlmacen,ctl00_CPHBase_txtDescripcion,ctl00_CPHBase_txtDireccion,ctl00_CPHBase_txtEmpleado");

            }                                 
            
            function OnlyNumber() 
            {
                var key = window.event.keyCode;        
                                        
                if (key < 48 || key > 57) 
                {
                    if(key == 46)
                        window.event.keyCode = 46;
                    else
                        window.event.keyCode = 0;
                                                                
                    if (key == 13) 
                        window.event.keyCode = 9;
                    else
                        window.event.keyCode = 0;
                }        
            } 
                                                                                  
         </script>        
    </asp:Content>

   