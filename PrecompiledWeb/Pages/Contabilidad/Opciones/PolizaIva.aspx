<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="Base.master" CodeFile="PolizaIva.aspx.cs" Inherits="Contabilidad_Compra_Opciones_CalculoIva" culture="es-mx" uiculture="es" %>
<%@ Register Assembly="Anthem" Namespace="Anthem" TagPrefix="anthem" %>
<%@ Register Assembly="DevExpress.Web.ASPxEditors.v8.3" Namespace="DevExpress.Web.ASPxEditors"
    TagPrefix="dxe" %>
<%@ Register Assembly="DevExpress.Web.ASPxEditors.v8.3, Version=8.3.4.0, Culture=neutral, PublicKeyToken=5377C8E3B72B4073"
    Namespace="DevExpress.Web.ASPxEditors" TagPrefix="dxe" %>

<asp:Content ID="Content" ContentPlaceHolderID="CPHBase" Runat="Server">      
        <table width="100%"  cellpadding="0" cellspacing="0" >
          <tr>
             <td style="height: 150px" background="../../Imagenes/img_tabs/fondo_down_long.jpg">
                <anthem:Panel id="pnlGrid" runat="server" Width="100%" Height="800px" >
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
	                        <td colspan="4" >
		                    </td>
	                    </tr>                                                                                                                               
                        <tr>
                            <td>
                                &nbsp;
                            </td>
                        </tr>
                        <tr style="height: 27px">
                            <td style="width: 200px; height: 25px">
                            </td>
                            <td align="right" class="tLetra3" style="height: 25px">
                                Empresa</td>
                            <td align="left" colspan="2" style="width: 200px; height: 25px">
                                <anthem:TextBox ID="txtEmpresa" runat="server" AutoCallBack="true" BorderColor="Navy"
                                    CssClass="String" OnTextChanged="txtEmpresa_TextChange" Width="80px"></anthem:TextBox>
                                <anthem:ImageButton
                                        ID="ImageButton6" runat="server" Height="18px" ImageUrl="../../../Img/ayuda.gif"
                                        OnClientClick="var a = JBrowse('ctl00_CPHBase_txtEmpresa','ctl00_CPHBase_txtEmpresa,ctl00_CPHBase_txtNombreEmpresa','DACEmpresa','',1,ctl00_CPHBase_txtEmpresa.value,ctl00_CPHBase_hddSucursal.value,'8', true,'No hay información',function(){document.getElementById('ctl00_CPHBase_txtEmpresa').onchange(); },0); "
                                        Width="20" ImageAlign="AbsMiddle" />
                                <anthem:TextBox ID="txtNombreEmpresa" runat="server" BorderColor="Navy"
                                            CssClass="String" ReadOnly="true" Width="300px"></anthem:TextBox><anthem:HiddenField
                                                ID="hddSucursal" runat="server" />
                            </td>
                        </tr>
                        <tr style="height: 27px">
                            <td style="width:200px; height: 25px;">
                                &nbsp;
                            </td>
                            <td class="tLetra3" style="height: 25px" align="right">
                                Ejercicio
                            </td>
                            <td align="left" style="height: 25px;width:200px">        
                                <anthem:DropDownList ID="cboYear" runat="server" Width="70%" >
                                </anthem:DropDownList>
                            </td>
                            <td style="width:500px; height: 25px;">
                                &nbsp;
                            </td>
                        </tr> 
                        <tr style="height: 27px">
                            <td style="width:200px; height: 25px;">
                                &nbsp;
                            </td>
                            <td class="tLetra3" style="height: 25px" align="right">
                                Mes
                            </td>
                            <td align="left" style="height: 25px;width:200px">  
                                <anthem:DropDownList ID="cboMonth" runat="server" Width="70%" >
                                </anthem:DropDownList>
                                <anthem:HiddenField ID="hddClose" runat="server" />
                            </td>
                            <td style="width:500px; height: 25px;">
                                &nbsp;
                            </td>
                        </tr>              
                        <tr>
                            <td>
                                <asp:ValidationSummary ID="ValidationSummary1" runat="server" ShowMessageBox="True" ShowSummary="False" />
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
                    </table> 
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                           <td align="center">
                                <div id="div-ListPanel2">
                                <anthem:GridView ID="grdIva" AutoGenerateColumns="false" runat="server"  AllowSorting="true" 
                                EmptyDataText="Seleccione un archivo." ForeColor="Navy" GridLines="None" HeaderStyle-CssClass="dxgvHeader_PlasticBlue"
                                CellPadding="0" CellSpacing="0" BorderColor="gray" BorderWidth="0" OnRowDataBound="row_Created"  Width="70%" OnSorting="grdFacturas_Sorting" CssClass="dxgvTable_Aqua" >
                                    <Columns>                                                                                                                                   			    
			                            <asp:BoundField DataField="intFolio" SortExpression="intFolio" HeaderText="Folio">
                                            <itemstyle horizontalalign="Center" width="60px" />
			                            </asp:BoundField>				                          
		                                <asp:BoundField DataField="datFecha" SortExpression="datFecha" HeaderText="Fecha">
                                            <itemstyle horizontalalign="Center" width="70px" />
			                            </asp:BoundField>	
			                            <asp:BoundField DataField="intEjercicio" SortExpression="intEjercicio" HeaderText="A&#241;o">
                                            <itemstyle horizontalalign="Center" width="70px" />
			                            </asp:BoundField>
			                            <asp:BoundField DataField="intMes" SortExpression="intMes" HeaderText="Mes">
                                            <itemstyle horizontalalign="Center" width="70px" />
			                            </asp:BoundField>
			                            <asp:BoundField DataField="TP" SortExpression="TP" HeaderText="Tipo Poliza">
                                            <itemstyle horizontalalign="Center" width="100px" />
			                            </asp:BoundField>	
			                            <asp:BoundField DataField="Procesada" SortExpression="Procesada" HeaderText="Procesada">
                                            <itemstyle horizontalalign="Center" width="70px" />
			                            </asp:BoundField> 
			                            <asp:TemplateField SortExpression="Poliza" HeaderText="Poliza" >
        		                            <itemtemplate>
 
        		                                <anthem:LinkButton id="lknPoliza" runat="server"></anthem:LinkButton>    		                                    		           		                        
		           		                     
</itemtemplate>
                                            <itemstyle horizontalalign="Center" width="100px" />
		                                </asp:TemplateField>                     	                            
                                   </Columns>                                                                          
                                    <HeaderStyle CssClass="dxgvHeader_PlasticBlue" ForeColor="White" />
                                </anthem:GridView>
                                </div>
                            </td>
                        </tr> 
                   </table>                                     
                </anthem:Panel>
            </td>
        </tr>
    </table>  
    <script language="javascript" type="text/javascript">
    var objUtils=new VetecUtils();       
        
    function datosCompletos()
    {
	     return true;
    }
               
    </script> 
    
    <iframe width="0" height="0" name="gToday:normal:agenda.js" id="gToday:normal:agenda.js" src="../../js/Calendar/ipopeng.htm"
         scrolling="no" frameborder="0" style="visibility:visible; z-index:999; position:absolute; top:-500px; left:-500px;">
    </iframe>
    
<%--    <script type="text/javascript"  src="../../js/CommonUtilities.js"></script>
    <script type="text/javascript"  src="../../js/SessionExpiration.js"></script>
    <script type="text/javascript"  src="../../js/OnSubmit.js"></script>
    <script type="text/javascript"  src="../../js/ModalWindow.js"></script>   --%>
    <script type="text/javascript" language="javascript">
	
	window.onbeforeunload = function(e) 
	{
	    <%
            Response.Expires=0;
        %>
    };
        
    function Anthem_PreCallBack() 
    {
        form_onSubmit();
	    return true;
	}
	
	function Anthem_PostCallBack() 
	{	
	   form_onSubmit_Hidden();
	}

	function Anthem_Error(result) 
	{
	    alert('Anthem_Error was invoked with the following error message: ' + result.error);
	}    
    </script>   
           
</asp:Content>

   