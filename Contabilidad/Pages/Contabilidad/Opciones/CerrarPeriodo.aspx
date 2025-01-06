<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="Base.master" CodeFile="CerrarPeriodo.aspx.cs" Inherits="Contabilidad_Compra_Opciones_CerrarPeriodo" Culture="auto" UICulture="auto" %>
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
         <script type="text/javascript" language="javascript">
            var objUtils = new VetecUtils();      	
                				    
            function datosCompletos()
            {		       
	            return objUtils.validaItems("ctl00_CPHBase_txtEmpresa,ctl00_CPHBase_cboYear,ctl00_CPHBase_cboMonth");
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

                       <anthem:ImageButton runat="server" ID="ImageButton6" OnClientClick="var a = JBrowse('ctl00_CPHBase_txtEmpresa','ctl00_CPHBase_txtEmpresa,ctl00_CPHBase_txtNombreEmpresa','DACEmpresa','',1,ctl00_CPHBase_txtEmpresa.value,ctl00_CPHBase_hddSucursal.value,'8', true,'No hay información',function(){document.getElementById('ctl00_CPHBase_txtEmpresa').onchange(); },0); "
                    Height="18px" ImageUrl="../../../Img/ayuda.gif" Width="20" ImageAlign="AbsMiddle" />

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
                &nbsp;&nbsp; Ejercicio:
            </td>
            <td class="tLetra36" style="height: 23px">
                <anthem:DropDownList ID="cboYear" runat="server" AutoCallBack="True" CssClass="String"
                    TabIndex="1" Width="120px">
                </anthem:DropDownList>&nbsp;
            </td>
            <td class="tLetra3" style="height: 23px">
                &nbsp;
            </td>
            <td style="height: 23px">
                &nbsp;
            </td>
        </tr>
        <tr>
            <td class="tLetra3" style="height: 23px">
                &nbsp;&nbsp; Mes:</td>
            <td class="tLetra36" style="height: 23px">
                <anthem:DropDownList ID="cboMonth" runat="server" CssClass="String" TabIndex="2"
                    Width="120px" AutoCallBack="True" OnSelectedIndexChanged="cboMonth_SelectedIndexChanged">
                </anthem:DropDownList></td>
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
        <div id="div-ListPanel4" style="left: 0px; top: 0px">
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
            <anthem:GridView ID="grdCerrar" AutoGenerateColumns="false" DataKeyNames="intModulo" runat="server" GridLines="None" HeaderStyle-CssClass="dxgvHeader_PlasticBlue" 
             CellPadding="0" CellSpacing="0" BorderColor="gray" BorderWidth="0" OnRowDataBound="row_Created" CssClass="dxgvTable_Aqua" Width="400px" >
            <Columns>  
                <asp:TemplateField ItemStyle-HorizontalAlign="Center" ItemStyle-Width="60px" >
        		    <itemtemplate> 
        		        <anthem:CheckBox ID="chkCerrar" runat="server" />       		                                    		           		                        
		            </itemtemplate>
		        </asp:TemplateField>                                                                                                                                      			    
			    <asp:BoundField DataField="strNombre" SortExpression="strNombre" HeaderText="Modulo" ItemStyle-HorizontalAlign="Left" ItemStyle-Width="300px">
			    </asp:BoundField>				                          		                                        				                                                    	                            
            </Columns>                                                                          
            </anthem:GridView>
         </div>        
    </asp:Content>

   