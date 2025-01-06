<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="Base.master" Debug="true" CodeFile="Afectacion.aspx.cs" Inherits="Administracion_Contabilidad_Afectacion" %>
<%@ Register src="~/Controls/ctrlPagger.ascx" tagname="ctrlPagger" tagprefix="uc3" %>
<%@ Register Assembly="Anthem" Namespace="Anthem" TagPrefix="anthem" %>

<asp:Content ID="Content" ContentPlaceHolderID="CPHBase" Runat="Server">  
   <table width="100%" border="0" cellspacing="0" cellpadding="0" id="TABLE1">
        <colgroup>
	        <col width="12%"/>
		    <col width="40%"/>
		    <col width="10%"/>
		    <col width="38%"/>
        </colgroup>
        <tr style="height:20px">
            <td>
                &nbsp;
            </td>
        </tr>
        <tr>
            <td class="tLetra3">
                &nbsp;&nbsp;Empresa:
            </td>
            <td class="tLetra3">
                <anthem:TextBox ID="txtEmpresa" runat="server" CssClass="String" Width="80px" AutoCallBack="true" OnTextChanged="txtEmpresa_TextChange" TabIndex="1" BorderColor="Navy"/> 
                <anthem:ImageButton runat="server" ID="ImageButton1" OnClientClick="var a = Browse('ctl00_CPHBase_txtEmpresa','ctl00_CPHBase_txtEmpresa,ctl00_CPHBase_txtNombreEmpresa','DACEmpresa','',1,ctl00_CPHBase_txtEmpresa.value,ctl00_CPHBase_hddSucursal.value,'8', true,'No hay información'); if(a != undefined) document.getElementById('ctl00_CPHBase_txtEmpresa').onchange(); else return false;" height="17" ImageUrl="../../../Img/ayuda.gif" width="20"/> 
                <anthem:TextBox ID="txtNombreEmpresa" runat="server" CssClass="String" Width="300px" TabIndex="4" ReadOnly="true" BorderColor="Navy"/>
                <anthem:HiddenField ID="hddSucursal" runat="server" />
            </td>
            <td  class="tLetra3">
                <anthem:LinkButton ID="lknRefresh" runat="server" OnClick="lknRefresh_Click"></anthem:LinkButton>
            </td>
            <td>                    
                &nbsp;
            </td>
        </tr>
        <tr style="height:20px">
            <td class="tLetra3">
                &nbsp;&nbsp;Ejercicio
            </td>
            <td align="left">
                <anthem:DropDownList ID="cboEjercicio" runat="server" CssClass="tDatos250" Width="200px">
                </anthem:DropDownList>&nbsp;
            </td>
            <td align="left">
                <anthem:Label ID="lblCerrado" runat="server" Font-Bold="true" ForeColor="red" Font-Size="9pt"></anthem:Label>
            </td>
            <td>
            </td>
        </tr> 
        <tr style="height:20px">
            <td class="tLetra3">
                &nbsp;&nbsp;Mes
            </td>
            <td align="left">
                <anthem:DropDownList ID="cboMonth" runat="server" CssClass="tDatos250" Width="200px" AutoCallBack="true" OnSelectedIndexChanged="cboMonth_Change">
                </anthem:DropDownList>&nbsp;
                <anthem:HiddenField ID="hddClose" runat="server" />
            </td>
            <td align="left">
            </td>
            <td>
            </td>
        </tr> 
        <tr style="height:20px">
            <td class="tLetra3">
                &nbsp;&nbsp;Tipo Poliza Inicial
            </td>
            <td align="left">
                <anthem:DropDownList ID="cboTipoPoliza" runat="server" CssClass="tDatos250" Width="250px" AutoCallBack="true" OnSelectedIndexChanged="cboTipoPoliza_SelectedIndexChanged">
                </anthem:DropDownList>
            </td>
            <td align="left" class="tLetra3">
                Tipo Poliza Final
            </td>
            <td>                    
                <anthem:DropDownList ID="cboTipoPolizaFin" runat="server" CssClass="tDatos250" Width="250px" AutoCallBack="true" OnSelectedIndexChanged="cboTipoPoliza_SelectedIndexChanged">
                </anthem:DropDownList>
            </td>
        </tr> 
        <tr style="height:20px">
            <td class="tLetra3" style="height: 20px">
                &nbsp;&nbsp;Folio Inicial
            </td>
            <td align="left" style="height: 20px">
                <anthem:TextBox ID="txtFolioIni" runat="server" CssClass="tDatos150" ></anthem:TextBox>
            </td>
            <td align="left" style="height: 20px" class="tLetra3">
                 Folio Final
            </td>
            <td>                    
                <anthem:TextBox ID="txtFolioFin" runat="server" CssClass="tDatos150" ></anthem:TextBox>
            </td>
        </tr>   
        <tr style="height:20px">
            <td class="tLetra3">
                 &nbsp;&nbsp;Afectadas
            </td>
            <td align="left">
                <anthem:RadioButtonList ID="rbdAfectadas" runat="server" AutoCallBack="True" OnSelectedIndexChanged="cboTipoPoliza_SelectedIndexChanged" CssClass="tLetra" CellPadding="2" CellSpacing="2" RepeatDirection="Horizontal">
                    <asp:ListItem Text="No" Value="0" Selected="True"></asp:ListItem>
                    <asp:ListItem Text="Si" Value="1"></asp:ListItem>
                </anthem:RadioButtonList>&nbsp;
            </td>
            <td align="left">
            </td>
            <td align="left">
            </td>
        </tr>                                                                                                   
        <tr style="height:20px">
            <td align="Right" colspan="4">
                <anthem:Button ID="btnAfectar" runat="server" CssClass="tdButton_Aqua" OnClick="btnAfectar_Click" OnClientClick="return confirm('Desea afectar todo');" Text="Afectar" Width="100px" Height="20px" />                                     
                  &nbsp;&nbsp;
                <anthem:Button ID="btnDesAfecta" runat="server" CssClass="tdButton_Orange" OnClick="btnDesAfecta_Click" OnClientClick="return confirm('Desea desafectar todo');" Text="Desafectar" Width="100px" Height="20px" />                                     
                &nbsp;&nbsp;&nbsp;&nbsp;
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
        <td>
            <anthem:Panel runat="server" ID="pnlPagger" Width="99%" CssClass="border" >
                <uc3:ctrlPagger ID="ctrlPagger1" runat="server" />
            </anthem:Panel>
        </td>
    </tr>
    <tr>
        <td>
            <div id="div-ListPanel3">
                <anthem:GridView ID="grdAfectacion" AutoGenerateColumns="false" DataKeyNames="intEmpresa,intFolio,intEjercicio,intMes,strTipoPoliza" runat="server" GridLines="None" HeaderStyle-CssClass="dxgvHeader_PlasticBlue" AllowSorting="true" 
                  CellPadding="0" CellSpacing="0" BorderColor="gray" BorderWidth="0" OnRowDataBound="row_Created" CssClass="dxgvTable_Aqua" Width="99%" OnSorting="grdFacturas_Sorting" >
                    <Columns>  
                    <asp:TemplateField ItemStyle-HorizontalAlign="Center" ItemStyle-Width="30px" >
        		       <itemtemplate> 
        		             <anthem:CheckBox ID="chkAfectar" runat="server" AutoCallBack="true" OnCheckedChanged="chkAfectar_Checked" />       		                                    		           		                        
		               </itemtemplate>
		            </asp:TemplateField>                                                                                                                                      			    
			        <asp:BoundField DataField="intEjercicio" SortExpression="Ejercicio" HeaderText="Ejercicio" ItemStyle-HorizontalAlign="Center" ItemStyle-Width="80px">
			        </asp:BoundField>				                          
		            <asp:BoundField DataField="intMes" SortExpression="Mes" HeaderText="Mes" ItemStyle-HorizontalAlign="Center" ItemStyle-Width="50px">
			        </asp:BoundField>	
			        <asp:BoundField DataField="datFecha" SortExpression="Fecha" HeaderText="Fecha" ItemStyle-HorizontalAlign="Left" ItemStyle-Width="80px">
			        </asp:BoundField>	
			        <asp:BoundField DataField="intFolio" SortExpression="Folio" HeaderText="Folio" ItemStyle-HorizontalAlign="Center" ItemStyle-Width="80px">
			        </asp:BoundField>	 
			        <asp:BoundField DataField="TipoPoliza" SortExpression="TipoPoliza" HeaderText="Tipo Poliza" ItemStyle-HorizontalAlign="Left" ItemStyle-Width="150px">
			        </asp:BoundField>	 
			        <asp:BoundField DataField="dblCargos" SortExpression="Cargos" HeaderText="Cargos" ItemStyle-HorizontalAlign="right" ItemStyle-Width="100px">
			        </asp:BoundField>	
			        <asp:BoundField DataField="dblAbonos" SortExpression="Abonos" HeaderText="Abonos" ItemStyle-HorizontalAlign="right" ItemStyle-Width="100px">
			        </asp:BoundField>	
			        <asp:BoundField DataField="dblDiferencias" SortExpression="Diferencia" HeaderText="Deferencia" ItemStyle-HorizontalAlign="right" ItemStyle-Width="100px">
			        </asp:BoundField>
			        <asp:TemplateField SortExpression="Poliza" HeaderText="Poliza" ItemStyle-HorizontalAlign="Center" ItemStyle-Width="100px" >
        		        <itemtemplate> 
        		         <anthem:LinkButton id="lknPoliza" runat="server" CssClass="Link" ></anthem:LinkButton>    		                                    		           		                        
		           	    </itemtemplate>
		            </asp:TemplateField>    				                                                    	                            
                    </Columns>                                                                          
                </anthem:GridView>
            </div>
        </td>
    </tr> 
 </table>                            
               
<script language="javascript" type="text/javascript">
    var objUtils=new VetecUtils(); 
    
    var objText=new VetecText("txtFolioIni", "number",20);
	var objText=new VetecText("txtFolioFin", "number",20);      
        
    function datosCompletos()
    {
	     return true;
    }
    
    function Desaplicar()
    {
        var rblDesplegar = null;
        var selectedvalue = 0; 
            
        for (var j = 0; j < rblDesplegar.length; j++) 
        {                 
           if (rblDesplegar[j].checked) 
           {                     
              selectedvalue = rblDesplegar[j].value;
              break;                 
           }             
        } 
                          
        if(selectedvalue != 1)
        {
            alert('Seleccione los clientes aplicados.');
            return false;
        }
        
        var table = document.getElementById('grdEscrituracion');  
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
    
    function clickCheck(p_obj){
        var objRow=p_obj.parentElement.parentElement;
        actualizar(objRow);
    }
    
    function activarControl(obj){
        if(obj.onblur==null){
            var objText=new VetecText(obj.id,"text",200);
            objText.setFunctionBlur(capturaListo);
        }
    }
    
    function capturaListo(p_obj){
        var objRow=p_obj.parentElement.parentElement;
        actualizar(objRow);
    }
    	      
    function clickDate(p_obj, p_e){
        var objRow=document.getElementById(p_obj.uniqueID).parentElement.parentElement.parentElement.parentElement.parentElement.parentElement;
        actualizar(objRow);
    }     
    
       
    function cancela(cartaOferta)
    {
        if(confirm('¿Desea cancelar la Carta Oferta ?'))       
            return  firmar(cartaOferta, 'CANCELA');
		else
    	    return false;         
    }       			       
  	
	window.onbeforeunload = function(e) 
	{
	   <%
          Response.Expires=0;
        %>
    };                   
</script>       
</asp:Content>

