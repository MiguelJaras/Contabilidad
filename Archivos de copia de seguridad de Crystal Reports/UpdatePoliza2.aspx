<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="Base.master" CodeFile="UpdatePoliza2.aspx.cs" Inherits="Contabilidad_Compra_Opciones_UpdatePoliza2" Culture="auto" UICulture="auto" %>
<%@ Register Assembly="Anthem" Namespace="Anthem" TagPrefix="anthem" %>
<asp:Content ID="Content" ContentPlaceHolderID="CPHBase" Runat="Server">      	       
     <script type="text/javascript" language="javascript">
        var objUtils = new VetecUtils();      	
                				    
        var objUtils=new VetecUtils();
				
		function datosCompletos()
		{	   		     
		     var lblCargos = document.getElementById('<%=lblCargos.ClientID %>').innerHTML;;
		     var lblAbonos = document.getElementById('<%=lblAbonos.ClientID %>').innerHTML;;
		     var dblCargos = 0;
             var dblAbonos = 0;
             
             dblCargos = parseFloat(lblCargos);
             dblAbonos = parseFloat(lblAbonos);                                                             		    
		     		     
		     if(!(dblCargos - dblAbonos == 0)) 
             {                                    
                alert('La poliza esta descuadrada.');
                return false;
             }		     		    

            return true;
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
            }
            else 
            {                                
               if (key == 13) 
               {
                  window.event.keyCode = 0;
               }
            }
        } 
        
        function Extencion(elem) 
        {
             var filePath = elem.value; 
 
 
            if(filePath.indexOf('.') == -1) 
                return false; 
         
 
            var validExtensions = new Array(); 
            var ext = filePath.substring(filePath.lastIndexOf('.') + 1).toLowerCase(); 
     
            validExtensions[0] = 'xls'; 
            validExtensions[1] = 'xlsx';     
 
            for(var i = 0; i < validExtensions.length; i++) 
            { 
                if(ext == validExtensions[i]) 
                {                    
                    __doPostBack('Charge','');  
                    form_onSubmit();
                    return true;
                }
            } 
 
            elem.value = "";

            alert('Seleccione un archivo Excel.'); 
            return false; 
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
            <td>
                &nbsp;
            </td>
        </tr>
        <tr>
            <td class="tLetra3">
                &nbsp; &nbsp;Empresa:
            </td>
            <td class="tLetra36">
                <anthem:TextBox ID="txtEmpresa" runat="server" AutoCallBack="true" BorderColor="Navy"
                    CssClass="String" OnTextChanged="txtEmpresa_TextChange" Width="80px"></anthem:TextBox>
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
            <td class="tLetra3">
                &nbsp; &nbsp;Ejercicio:
            </td>
            <td class="tLetra36">
                 <anthem:DropDownList ID="cboYear" runat="server" CssClass="String" Width="120px" TabIndex="1">
                </anthem:DropDownList>
            </td>
            <td class="tLetra3">
                &nbsp;
            </td>
            <td>
                &nbsp;
            </td>
        </tr>
        <tr>
            <td class="tLetra3">
                &nbsp; &nbsp;Poliza:
            </td>
            <td class="tLetra36">
               <anthem:TextBox ID="txtPoliza" runat="server" MaxLength="20" Width="100px" TabIndex="9" AutoCallBack="True" OnTextChanged="txtPoliza_TextChanged" CssClass="String">
               </anthem:TextBox>
               <anthem:HiddenField ID="hddPoliza" runat="server" />
               <anthem:HiddenField ID="hddFecha" runat="server" />
               <anthem:HiddenField ID="hddTipoPoliza" runat="server" />
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
                &nbsp;&nbsp; Archivo:
            </td>
            <td class="tLetra36" style="height: 23px">
                 <asp:FileUpload ID="fuArchivo" runat="server" CssClass="FileUpload" onchange="Extencion(this);" TabIndex="4" />
            </td>
            <td class="tLetra3" style="height: 23px">
                &nbsp;
            </td>
            <td style="height: 23px">
                &nbsp;
            </td>
        </tr>        
    </table>
    <br />
    <table width="98%">
        <tr>
            <td align="center">
                <div id="div-ListPanel">
                    <anthem:GridView ID="grdPolizaDet" runat="server" AutoGenerateColumns="false" AutoUpdateAfterCallBack="true"
                        BorderWidth="0" CellPadding="0" CellSpacing="0" CssClass="dxgvTable_Aqua" DataKeyNames="intPartida"
                        EmptyDataText="Seleccione un archivo." ForeColor="Navy" GridLines="None" HeaderStyle-CssClass="dxgvHeader_PlasticBlue"
                        OnRowCreated="DgrdList_RowCreated" OnRowDeleting="DgrdList_RowDeleting" RowStyle-CssClass="GridViewRow"
                        Visible="false" Width="98%">
                        <Columns>
                            <asp:TemplateField HeaderText="Cuenta" ItemStyle-HorizontalAlign="Left" ItemStyle-Width="90px">
                                <itemtemplate>   
                                <Anthem:TextBox ID="txtCuentaDet" AutoCallBack="True" style="text-align:right;" Runat="server" ToolTip="Ingrese la cuenta" Width="90px" OnTextChanged="txtCuentaDet_TextChanged" /> 
		                  </itemtemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Nombre Cuenta" ItemStyle-HorizontalAlign="Left" ItemStyle-Width="150px">
                                <itemtemplate>   
                                <Anthem:TextBox ID="txtCuentaNombreDet" Runat="server" ToolTip="cuenta" Width="150px" /> 
		                  </itemtemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Auxiliar" ItemStyle-HorizontalAlign="Left" ItemStyle-Width="60px">
                                <itemtemplate>   
                                <Anthem:TextBox ID="txtAuxiliarDet" AutoCallBack="True" style="text-align:right;" Runat="server" ToolTip="Ingrese el auxiliar" Width="60px" OnTextChanged="txtAuxiliarDet_TextChanged" /> 
		                  </itemtemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Obra" ItemStyle-HorizontalAlign="Left" ItemStyle-Width="60px">
                                <itemtemplate>   
                                <Anthem:TextBox ID="txtObraDet" AutoCallBack="True" style="text-align:right;" Runat="server" ToolTip="Ingrese la obra" Width="60px" OnTextChanged="txtObraDet_TextChanged" />  
		                  </itemtemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Referencia" ItemStyle-HorizontalAlign="Left" ItemStyle-Width="90px">
                                <itemtemplate>   
                                <anthem:TextBox ID="txtReferenciaDet" runat="server" Width="90px"></anthem:TextBox>
		                  </itemtemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Cargos" ItemStyle-HorizontalAlign="Left" ItemStyle-Width="70px">
                                <itemtemplate>   
                                <anthem:TextBox ID="txtCargosDet" runat="server" Width="70px" AutoCallBack="True" OnTextChanged="txtCargosDet_TextChanged"></anthem:TextBox>
		                  </itemtemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Abonos" ItemStyle-HorizontalAlign="Left" ItemStyle-Width="70px">
                                <itemtemplate>   
                                <anthem:TextBox ID="txtAbonosDet" runat="server" Width="70px" AutoCallBack="True" OnTextChanged="txtAbonosDet_TextChanged"></anthem:TextBox>
		                  </itemtemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Descricpion" ItemStyle-HorizontalAlign="Left" ItemStyle-Width="200px">
                                <itemtemplate>   
                                <anthem:TextBox ID="txtDescripcionDet" runat="server" Width="200px"></anthem:TextBox>
		                  </itemtemplate>
                            </asp:TemplateField>
                            <asp:TemplateField ItemStyle-HorizontalAlign="Center" ItemStyle-Width="30px" ShowHeader="False">
                                <itemtemplate>		
			                <anthem:ImageButton runat="server" ImageUrl="~/Img/Deleted.PNG"   onclientClick="javascript:return confirm('¿Desea eliminar el registro?');" CommandName="Delete" CausesValidation="False" ImageAlign="Middle" id="lknDelete"></anthem:ImageButton>
		                </itemtemplate>
                            </asp:TemplateField>
                        </Columns>
                    </anthem:GridView>
                </div>
            </td>
        </tr>
        <tr>
            <td>
                <table>
                    <tr>
                        <td style="width: 90px; height: 9px">
                            &nbsp;
                        </td>
                        <td style="width: 150px; height: 9px">
                            &nbsp;
                        </td>
                        <td style="width: 60px; height: 9px">
                            &nbsp;
                        </td>
                        <td style="width: 60px; height: 9px">
                            &nbsp;
                        </td>
                        <td style="width: 90px; height: 9px">
                            &nbsp;
                        </td>
                        <td style="width: 70px; height: 9px">
                            &nbsp;
                        </td>
                        <td align="center" style="width: 70px; height: 9px">
                            <anthem:Label ID="lblCargos" runat="server" CssClass="tLetra5"></anthem:Label>
                        </td>
                        <td align="center" style="width: 70px; height: 9px">
                            <anthem:Label ID="lblAbonos" runat="server" CssClass="tLetra5"></anthem:Label>
                        </td>
                        <td style="width: 130px; height: 9px">
                            &nbsp;
                        </td>
                    </tr>
                    <tr>
                        <td style="width: 90px">
                            &nbsp;
                        </td>
                        <td style="width: 150px">
                            &nbsp;
                        </td>
                        <td style="width: 60px">
                            &nbsp;
                        </td>
                        <td style="width: 60px">
                            &nbsp;
                        </td>
                        <td style="width: 90px">
                            &nbsp;
                        </td>
                        <td style="width: 70px">
                            <anthem:Label ID="Label1" runat="server" CssClass="tLetra5" Text="Diferencia:"></anthem:Label>
                        </td>
                        <td align="center" colspan="2" style="width: 70px">
                            <anthem:Label ID="lblDiferencia" runat="server" CssClass="tLetra6"></anthem:Label>
                        </td>
                        <td style="width: 130px">
                            &nbsp;
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
    
    <script type="text/javascript" language="javascript">
               
	
	form_onSubmit_Hidden();
    
    
    </script>
    
    </asp:Content>

   