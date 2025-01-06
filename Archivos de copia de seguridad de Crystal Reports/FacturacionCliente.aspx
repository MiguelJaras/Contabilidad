<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="Base.master" CodeFile="FacturacionCliente.aspx.cs" Inherits="Contabilidad_Compra_Opciones_FacturacionCliente" Culture="auto" UICulture="auto" %>
<%@ Register Assembly="Anthem" Namespace="Anthem" TagPrefix="anthem" %>

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
               return objUtils.validaItems("ctl00_CPHBase_txtEmpresa,ctl00_CPHBase_cboEjercicio,ctl00_CPHBase_cboMonth");

            }     
            
            function Desaplicar()
            {
                var rblDesplegar = document.getElementById('<%=rblDesplegar.ClientID %>');
                var selectedvalue = 0;                 
                var inputs = rblDesplegar.getElementsByTagName("input");                          
                                
                for (var j = 0; j < inputs.length; j++) 
                {              
                    if (inputs[j].checked) 
                    {                     
                        selectedvalue = inputs[j].value;
                        break;                 
                    }             
                } 
                                          
                if(selectedvalue != 1)
                {
                    alert('Seleccione los clientes aplicados.');
                    return false;
                }
        
                var table = document.getElementById('<%=grdEscrituracion.ClientID %>');  
                var prospectos = 0;                    
                                                               
                for (var i = 1; i < table.rows.length; i++) 
                {                      
                    if (table.rows(i).cells(0).childNodes[0].childNodes[0].checked)                              
                        prospectos = prospectos + 1;                                    
                }   
                    
                if(prospectos == 0)
                {
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
            <td class="tLetra3">
                &nbsp; &nbsp;Empresa:
            </td>
            <td class="tLetra36">
                <anthem:TextBox ID="txtEmpresa" runat="server" AutoCallBack="true" BorderColor="Navy"
                    CssClass="String" OnTextChanged="txtEmpresa_TextChange" Width="80px" TabIndex="1"></anthem:TextBox>
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
                &nbsp;&nbsp; Colonia:
            </td>
            <td class="tLetra36" style="height: 23px">
                <anthem:DropDownList ID="cboColonia" runat="server" CssClass="String" TabIndex="2"
                    Width="419px">
                </anthem:DropDownList></td>
            <td class="tLetra3" style="height: 23px">
                &nbsp;
                                            <anthem:Button ID="btnDesaplicar" runat="server" CssClass="tdButton_Aqua" Height="20px"
                                                OnClick="btnDesaplicar_Click" OnClientClick="return Desaplicar();" Text="Desaplicar"
                                                Width="100px" /></td>
            <td style="height: 23px">
                &nbsp;
            </td>
        </tr>
        <tr>
            <td class="tLetra3" style="height: 23px">
                &nbsp;&nbsp; Ejercicio:</td>
            <td class="tLetra36" style="height: 23px">
                <anthem:DropDownList ID="cboEjercicio" runat="server" CssClass="String"
                    TabIndex="3" Width="120px">
                </anthem:DropDownList></td>
            <td class="tLetra3" style="height: 23px">
            </td>
            <td style="height: 23px">
            </td>
        </tr>
        <tr>
            <td class="tLetra3">
                &nbsp;&nbsp; Mes:</td>
            <td class="tLetra36">
                <anthem:DropDownList ID="cboMonth" runat="server" CssClass="String" TabIndex="4" AutoCallBack="true" OnSelectedIndexChanged="cboMonth_Change"
                    Width="120px">
                </anthem:DropDownList></td>
            <td class="tLetra3">
            </td>
            <td>
            </td>
        </tr>
        <tr>
            <td class="tLetra3" style="height: 23px">
                &nbsp;&nbsp; Aplicado:</td>
            <td class="tLetra3" style="height: 23px">
                <anthem:RadioButtonList
                    ID="rblDesplegar" runat="server" AutoCallBack="True" CssClass="tLetra" OnSelectedIndexChanged="chkAplicado_Change"
                    RepeatDirection="Horizontal" TabIndex="5">
                    <Items>
                        <asp:ListItem Value="2">Todos</asp:ListItem>
                        <asp:ListItem Value="0">No</asp:ListItem>
                        <asp:ListItem Value="1">Si</asp:ListItem>
                    </Items>
                </anthem:RadioButtonList>
                &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
            </td>
            <td class="tLetra3" style="height: 23px">
            </td>
            <td style="height: 23px">
            </td>
        </tr>
    </table>
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
            <td>
                <div id="div-ListPanel3">
                <anthem:GridView ID="grdEscrituracion" AutoGenerateColumns="false" DataKeyNames="intProspecto" runat="server" GridLines="None" HeaderStyle-CssClass="dxgvHeader_PlasticBlue" AllowSorting="true" 
                  CellPadding="0" CellSpacing="0" BorderColor="gray" BorderWidth="0" OnRowDataBound="row_Created" CssClass="dxgvTable_Aqua" Width="99%" OnSorting="grdFacturas_Sorting" >
                    <Columns>  
                        <asp:TemplateField ItemStyle-HorizontalAlign="Center" ItemStyle-Width="30px">
                            <itemtemplate> 
        		                <anthem:CheckBox ID="chkEscriturar" runat="server" />       		                                    		           		                        
		           		    </itemtemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="intProspecto" HeaderText="Cliente" ItemStyle-HorizontalAlign="Center" ItemStyle-Width="60px" SortExpression="intProspecto" />
                        <asp:BoundField DataField="Prospecto" HeaderText="Nombre" ItemStyle-HorizontalAlign="Left" ItemStyle-Width="200px" SortExpression="Prospecto" />
                        <asp:BoundField DataField="TipoCredito" HeaderText="Tipo Credito" ItemStyle-HorizontalAlign="Left" ItemStyle-Width="140px" SortExpression="TipoCredito" />
                        <asp:TemplateField HeaderText="Terreno" ItemStyle-HorizontalAlign="Left" ItemStyle-Width="60px" SortExpression="Terreno">
                            <itemtemplate> 
                                <anthem:DropDownList ID="cboTerreno" runat="server"  AutoCallBack="True" OnSelectedIndexChanged="cboTerreno_SelectedIndexChanged" CssClass="tDatos150" Width="80px" />  	                                                                                                                                                          	                                    		           		                        
		           		    </itemtemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Fecha" ItemStyle-HorizontalAlign="Center" ItemStyle-Width="110px" SortExpression="Fecha">
                            <itemtemplate> 
        		                <anthem:textbox ID="txtFecha" Width="75px" CssClass="String" runat="server" MaxLength="10" Text='<%#  Eval("datFechaEscrituracion") %>'>
                                </anthem:textbox>
                                <anthem:ImageButton  ID="ImgDate" runat="server" ImageUrl="../../../Scripts/Calendar/Calendar.JPG"/>      	                                                                                                                                                          	                                    		           		                        
		           		    </itemtemplate>
                            </asp:TemplateField>
                            <asp:BoundField DataField="strColonia" HeaderText="Colonia" ItemStyle-HorizontalAlign="Left" ItemStyle-Width="100px" SortExpression="strColonia" />
                            <asp:TemplateField HeaderText="Poliza" ItemStyle-HorizontalAlign="Left" ItemStyle-Width="60px" SortExpression="Poliza">
                                <itemtemplate> 
        		                    <anthem:LinkButton id="lknPoliza" runat="server"></anthem:LinkButton>    		                                    		           		                        
		           		        </itemtemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Maple" ItemStyle-HorizontalAlign="Left" ItemStyle-Width="60px" SortExpression="Poliza">
                                <itemtemplate> 
        		                    <anthem:LinkButton id="lknPolizaMaple" runat="server"></anthem:LinkButton>    		                                    		           		                        
		           		        </itemtemplate>
                            </asp:TemplateField>  				                                                    	                            
                    </Columns>                                                                          
                </anthem:GridView>
            </div>
        </td>
    </tr> 
   </table>
</asp:Content>

   