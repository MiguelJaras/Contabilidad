<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="Base.master" CodeFile="FacturasMafesa.aspx.cs" Inherits="Contabilidad_Compra_Opciones_FacturasMafesa" culture="es-mx" uiculture="es" %>
<%@ Register Assembly="Anthem" Namespace="Anthem" TagPrefix="anthem" %>
<asp:Content ID="Content" ContentPlaceHolderID="CPHBase" Runat="Server">      	       
     <script type="text/javascript" language="javascript">
        var objUtils = new VetecUtils();      	
                				    
        var objUtils=new VetecUtils();
				
		function datosCompletos()
        {
		    var facturaPDF = $('#ctl00_CPHBase_lblPDF').text();
		    var facturaXML = $('#ctl00_CPHBase_lblXML').text();

		    if (facturaPDF == '' || facturaXML == '') {
		        alert('Favor de seleccionar la factura.')
		        return false;
		    }
            
		    form_onSubmit();
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
            <td>
                &nbsp;
            </td>
        </tr>
       <tr>
            <td class="tLetra3">
                 &nbsp; &nbsp;*Factura PDF
    	    </td>
    	    <td align="left" >    		    
                <anthem:FileUpload Id="fuPDF" runat="server" CssClass="FileUpload" />
                <anthem:Label ID="lblPDF" runat="server" ></anthem:Label>
    	    </td>
	   		 <td style="border:0px;">
	   		       <anthem:LinkButton ID="lknPDF" runat="server" Text=""></anthem:LinkButton>	   		                            
	   		   </td>
		     </tr>
        <tr>
            <td class="tLetra3">
                 &nbsp; &nbsp;*Factura XML
    	     </td>
    	     <td >    		    
                <anthem:FileUpload Id="fuXML" runat="server" CssClass="FileUpload"  Enabled=false/>
                <anthem:Label ID="lblXML" runat="server" ></anthem:Label>
    	    </td>
	   	    <td style="border:0px;"> 
                <anthem:LinkButton ID="lknXML" runat="server" Text="" ></anthem:LinkButton>		                            
	   	     </td>
        </tr>
        <tr>      
            <td class="tLetra3" >
                &nbsp;&nbsp;&nbsp;Fecha
            </td>                
            <td class="tLetra3" colspan="2">
                <anthem:TextBox ID="txtFecha" runat="server" CssClass="String" Width="80px" TabIndex="3"></anthem:TextBox>
                <anthem:ImageButton  ID="ImgDate" runat="server" ImageUrl="../../../Scripts/Calendar/Calendar.JPG"/>                                 
            </td>            
        </tr>
    </table>
    <br />
    <br />
    <br />
    <br />
    <table width="98%">
        <tr>
            <td align="center">
                <div id="div-ListPanel">
                    <anthem:GridView ID="grdList" runat="server" AutoGenerateColumns="false" AutoUpdateAfterCallBack="true"
                        BorderWidth="0" CellPadding="0" CellSpacing="0" CssClass="dxgvTable_Aqua" DataKeyNames="Factura"
                        EmptyDataText="Seleccione un archivo." ForeColor="Navy" GridLines="None" HeaderStyle-CssClass="dxgvHeader_PlasticBlue"
                        OnRowCreated="DgrdList_RowCreated" OnRowDeleting="DgrdList_RowDeleting" RowStyle-CssClass="GridViewRow"
                        Width="98%">
                        <Columns>     
                            <asp:BoundField DataField="Empresa" SortExpression="Empresa" HeaderText="Empresa" ItemStyle-HorizontalAlign="Left" ItemStyle-Width="150px">
			                </asp:BoundField>  
                            <asp:BoundField DataField="Factura" SortExpression="Factura" HeaderText="Factura" ItemStyle-HorizontalAlign="Center" ItemStyle-Width="50px">
			                </asp:BoundField>  
                            <asp:BoundField DataField="UsoCFDI" SortExpression="UsoCFDI" HeaderText="UsoCFDI" ItemStyle-HorizontalAlign="Center" ItemStyle-Width="50px">
			                </asp:BoundField>  
                            <asp:BoundField DataField="FormaPago" SortExpression="FormaPago" HeaderText="FormaPago" ItemStyle-HorizontalAlign="Center" ItemStyle-Width="50px">
			                </asp:BoundField>
                            <asp:BoundField DataField="MetodoPago" SortExpression="MetodoPago" HeaderText="MetodoPago" ItemStyle-HorizontalAlign="Center" ItemStyle-Width="50px">
			                </asp:BoundField>
                            <asp:BoundField DataField="Importe" SortExpression="Importe" HeaderText="Importe" ItemStyle-HorizontalAlign="Right" ItemStyle-Width="50px">
			                </asp:BoundField>  
                            <asp:BoundField DataField="Producto" SortExpression="Producto" HeaderText="Producto" ItemStyle-HorizontalAlign="Center" ItemStyle-Width="50px">
			                </asp:BoundField>  
                             <asp:BoundField DataField="Poliza" SortExpression="Poliza" HeaderText="Poliza" ItemStyle-HorizontalAlign="Center" ItemStyle-Width="50px">
			                </asp:BoundField>                         
                           <asp:TemplateField ItemStyle-HorizontalAlign="Center" ItemStyle-Width="30px" ShowHeader="False">
                                <itemtemplate>		
			                        <anthem:ImageButton runat="server" ImageUrl="~/Img/Deleted.PNG" onclientClick="javascript:return confirm('¿Desea eliminar el registro?');" CommandName="Delete" CausesValidation="False" ImageAlign="Middle" id="lknDelete"></anthem:ImageButton>
		                        </itemtemplate>
                            </asp:TemplateField>
                        </Columns>
                    </anthem:GridView>
                </div>
            </td>
        </tr>
    </table>
    <table>
        <tr>
            <td>
                <anthem:HiddenField ID="HddFolioFiscal" runat="server" />
                <anthem:HiddenField ID="hddReceptorRfc" runat="server" />
                <anthem:HiddenField ID="hddEmisorRfc" runat="server" />
                <anthem:HiddenField ID="hddEmpresa" runat="server" />
                <anthem:HiddenField ID="hddFecha" runat="server" />
                <anthem:HiddenField ID="hddArchivoFacturaPDF" runat="server" />
                <anthem:HiddenField ID="hddArchivoFacturaXML" runat="server" />
                <anthem:HiddenField ID="hddSerie" runat="server" />
                <anthem:HiddenField ID="hddFolio" runat="server" />
                <anthem:HiddenField ID="hddMontoFac" runat="server" />
                <anthem:HiddenField ID="hddNombreArchivoPDFOriginal" runat="server" />
                <anthem:HiddenField ID="hddMetodoPago" runat="server" />
                <anthem:HiddenField ID="hddNumCtaPago" runat="server" />
                <anthem:HiddenField ID="hddVersion" runat="server" />
                <anthem:HiddenField ID="hddUsoCFDI" runat="server" />
                <anthem:HiddenField ID="hddFormaPago" runat="server" />
                <anthem:HiddenField ID="hddMoneda" runat="server" />
                <anthem:HiddenField ID="hddRegimenFiscal" runat="server" />
                <anthem:HiddenField ID="hddProducto" runat="server" />
            </td>
        </tr>
    </table>
    <script type="text/javascript" language="javascript">

        //form_onSubmit_Hidden();
    
    </script>
    
    </asp:Content>

   