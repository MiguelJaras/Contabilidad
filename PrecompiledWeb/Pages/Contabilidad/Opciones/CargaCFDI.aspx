<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="Base.master" CodeFile="CargaCFDI.aspx.cs" Inherits="Contabilidad_Compra_Opciones_CargaCFDI" culture="es-mx" uiculture="es" %>
<%@ Register Assembly="Anthem" Namespace="Anthem" TagPrefix="anthem" %>
<asp:Content ID="Content" ContentPlaceHolderID="CPHBase" Runat="Server">      	       
     <script type="text/javascript" language="javascript">
        var objUtils = new VetecUtils();      	
				
		function datosCompletos()
		{	  		          		 
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
                    document.getElementById("ctl00_CPHBase_lknCharge").click();              
//                    __doPostBack('Charge','');  
//                    form_onSubmit();
                    return true;
                }
            } 
 
            elem.value = "";

            alert('Seleccione un archivo Excel.'); 
            return false; 
        }                                                                     
         </script>        

    <table border="0" cellpadding="0" cellspacing="0" width="80%">
        <colgroup>
            <col width="12%" />
            <col width="40%" />
            <col width="10%" />
            <col width="18%" />
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
                <anthem:TextBox ID="txtEmpresa" runat="server" BorderColor="Navy" Enabled="false" CssClass="String" Width="80px"></anthem:TextBox>
                <anthem:TextBox ID="txtNombreEmpresa" runat="server" BorderColor="Navy" Enabled="false" CssClass="String" ReadOnly="true" Width="300px"></anthem:TextBox>
                <anthem:HiddenField ID="hddEjercicio" runat="server" />
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
                &nbsp;&nbsp; Poliza:
            </td>
            <td class="tLetra36" style="height: 23px">
                <anthem:TextBox ID="txtPoliza" runat="server" BorderColor="Navy" Enabled="false" CssClass="String" Width="80px"></anthem:TextBox>
             </td>
            <td class="tLetra3" style="height: 23px">
                <anthem:LinkButton ID="lknCharge" runat="server" OnClick="lknCharge_Click"></anthem:LinkButton>
            </td>
            <td style="height: 23px">
                

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
        <tr>
            <td>
                &nbsp;
            </td>
        </tr> 
        <tr>
            <td>
                &nbsp;
            </td>
        </tr>
         <tr>
            <td class="tLetra3" style="height: 23px">
                &nbsp;&nbsp; CFDI:
            </td>
            <td class="tLetra36" style="height: 23px">
                <anthem:TextBox ID="txtCFDI" runat="server" BorderColor="Navy" CssClass="String" Width="150px"></anthem:TextBox>
                &nbsp;
                <anthem:Button ID="btnAgregar" CssClass="tdButton_Aqua" runat="server" Text="Agregar" Width="100px" OnClick="btnAgregar_Click" />
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
    <table width="80%">
        <tr>
            <td align="left">
                <div id="div-ListPanel">
                    <anthem:GridView ID="grdPolizaDet" runat="server" AutoGenerateColumns="false" AutoUpdateAfterCallBack="true"
                        BorderWidth="0" CellPadding="0" CellSpacing="0" CssClass="dxgvTable_Aqua" DataKeyNames="cfdi"
                        EmptyDataText="Seleccione un archivo." ForeColor="Navy" GridLines="None" HeaderStyle-CssClass="dxgvHeader_PlasticBlue"
                        OnRowCreated="DgrdList_RowCreated" OnRowDeleting="DgrdList_RowDeleting" RowStyle-CssClass="GridViewRow"
                        Visible="false" Width="40%">
                        <Columns>
                            <asp:BoundField DataField="cfdi" SortExpression="cfdi" HeaderText="CFDI" ItemStyle-HorizontalAlign="Left" ItemStyle-Width="300px">
			                </asp:BoundField> 
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
    </table>
    
    <script type="text/javascript" language="javascript">
               
	
	form_onSubmit_Hidden();
    
    
    </script>
    
    </asp:Content>

   