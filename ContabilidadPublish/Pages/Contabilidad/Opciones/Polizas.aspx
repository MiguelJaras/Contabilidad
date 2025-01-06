<%@ Page Language="C#" MasterPageFile="Base.master"  MaintainScrollPositionOnPostback="true" CodeFile="Polizas.aspx.cs" Inherits="Administracion_Contabilidad_Polizas" Culture="Auto" UICulture="Auto" %>

<%@ Register Assembly="Anthem" Namespace="Anthem" TagPrefix="anthem" %>
<%@ Register src="~/Controls/ctrlPagger.ascx" tagname="ctrlPagger" tagprefix="uc3" %>

<asp:Content ID="Content" ContentPlaceHolderID="CPHBase" Runat="Server">
        <table width="99%" border="0" cellspacing="1" cellpadding="1"> 
        <colgroup>
	        <col width="12%"/>
		    <col width="12%"/>
		    <col width="12%"/>
		    <col width="12%"/>
		    <col width="12%"/>
		    <col width="12%"/>
		    <col width="12%"/>
		    <col width="12%"/>
         </colgroup> 
            <tr>
                <td colspan="8">
                    &nbsp;
                </td>
            </tr>     
            <tr>
            <td class="tLetra3">
                &nbsp;&nbsp;&nbsp;Empresa:
            </td>
            <td class="tLetra3" colspan="4">
                <anthem:TextBox ID="txtEmpresa" runat="server" CssClass="String" Width="100px" AutoCallBack="true" OnTextChanged="txtEmpresa_TextChange" TabIndex="1" BorderColor="Navy"/> 
                <anthem:ImageButton runat="server" ID="ImageButton1" OnClientClick="var a = Browse('ctl00_CPHBase_txtEmpresa','ctl00_CPHBase_txtEmpresa,ctl00_CPHBase_txtNombreEmpresa','DACEmpresa','',1,ctl00_CPHBase_txtEmpresa.value,ctl00_CPHBase_hddSucursal.value,'8', true,'No hay información'); if(a != undefined) document.getElementById('ctl00_CPHBase_txtEmpresa').onchange(); else return false;" height="17" ImageUrl="../../../Img/ayuda.gif" width="20"/> 
                <anthem:TextBox ID="txtNombreEmpresa" runat="server" CssClass="String" Width="300px" TabIndex="4" Enabled="true" BorderColor="Navy"/>
                <anthem:HiddenField ID="hddSucursal" runat="server" />
            </td>
            <td  class="tLetra3" colspan="2">
                <anthem:Button ID="btnCopy" runat="server" CssClass="tdButton_Aqua" Visible="false" Width="80px" Text="Copiar Poliza" TabIndex="50" />
                &nbsp;
                <anthem:Button ID="btnCopiar" runat="server" CssClass="tdButton_Aqua" Visible="false" Width="80px" Text="Poliza Inversa" TabIndex="51"  />
                &nbsp;
                <anthem:Button ID="btnCFDI" runat="server" CssClass="tdButton_Orange" Visible="false"  Text="CFDI" Width="100px" Height="20px" />                                                        
                <anthem:HiddenField ID="hddClose" runat="server" />
            </td>
            <td>                    
                &nbsp;
                <anthem:Label ID="lblAfectada" runat="server" Font-Bold="true" ForeColor="red" Font-Size="12pt"></anthem:Label>
            </td>
            </tr>     
            <tr style="height: 15px">
                <td class="tLetra3">
                    &nbsp;&nbsp;&nbsp;Tipo Poliza
                </td>
                <td style="height: 20px;"> 
                    <anthem:DropDownList ID="cboTipoPoliza" runat="server" CssClass="String" Width="150px" TabIndex="5" />                                                                    
                </td>
                <td class="tLetra3" style="height: 20px;">
                     Fecha &nbsp;
                </td>
                <td style="height: 20px;">                          
                    <anthem:TextBox ID="txtFechaInicial" runat="server" CssClass="String" AutoCallBack="true" TabIndex="6" Width="70px" OnTextChanged="txtFechaInicial_Change"></anthem:TextBox>&nbsp;
                    <anthem:ImageButton ID="ImgDate" runat="server" ImageUrl="../../../Scripts/Calendar/Calendar.JPG" />  
                    <anthem:HiddenField ID="HiddenField1" runat="server" />
                     <anthem:HiddenField ID="hddMonth" runat="server" />
                     <anthem:HiddenField ID="hddYear" runat="server" />                                     
                </td>
                <td class="tLetra3" >                               
                     Orden Compra &nbsp;&nbsp;                             
                </td> 
                <td style="width: 12%">                   
                    <anthem:TextBox ID="txtOrdenCompra" runat="server" MaxLength="20" TabIndex="7" CssClass="String" Width="100px">
                    </anthem:TextBox>
                </td>  
                <td class="tLetra3">
                     Moneda &nbsp;
                </td>
                <td class="tLetra3" >                               
                    <anthem:DropDownList ID="cboMoneda" runat="server" CssClass="String" Width="100px" TabIndex="8" />                                   
                </td>                              
            </tr>
            <tr style="height: 15px">
                <td class="tLetra3">
                    &nbsp;&nbsp;&nbsp;Poliza 
                </td>
                <td>                                                                     
                    <anthem:TextBox ID="txtPoliza" runat="server" MaxLength="20" Width="100px" TabIndex="9" AutoCallBack="True" OnTextChanged="txtPoliza_TextChanged" CssClass="String">
                    </anthem:TextBox>
                    <anthem:ImageButton runat="server" ID="btnAyudaPoliza" OnClientClick="var a = Browse('ctl00_CPHBase_txtPoliza','ctl00_CPHBase_txtPoliza,ctl00_CPHBase_hddPoliza,ctl00_CPHBase_hddPoliza,ctl00_CPHBase_hddPoliza','DACPolizaDet','ctl00_CPHBase_cboTipoPoliza,ctl00_CPHBase_hddYear,ctl00_CPHBase_hddMonth',4,ctl00_CPHBase_txtEmpresa.value,ctl00_CPHBase_hddSucursal.value,'8', true,'No hay información'); if(a != undefined) return true; else return false;" height="17" ImageUrl="../../../Img/ayuda.gif" width="20"/> 
                    <anthem:HiddenField ID="hddPoliza" runat="server" />
                </td>
                <td class="tLetra3" style="height: 25px;">
                    Cargos
                </td>
                <td style="height: 25px;">                               
                    <anthem:TextBox ID="txtTotalCargos" runat="server" ReadOnly="true" BackColor="#EEEE00" Width="100px" CssClass="String"></anthem:TextBox>                 
                </td>
                <td class="tLetra3" style="height: 25px;">
                    Abonos &nbsp;
                </td> 
                <td style="height: 25px; width: 12%;">
                    <anthem:TextBox ID="txtTotalAbonos" runat="server" ReadOnly="true" BackColor="#EEEE00" Width="100px" CssClass="String"></anthem:TextBox>
                </td> 
                <td class="tLetra3" style="height: 25px;">
                     Diferencia &nbsp;  
                </td> 
                 <td class="tLetra3" style="height: 25px;">                                                                                                   
                    <anthem:TextBox ID="txtDiferenciia" runat="server" ReadOnly="true" BackColor="#FFA07A" Width="100px" CssClass="String"></anthem:TextBox>
                    <anthem:HiddenField ID="hddPartida" runat="server" />
                </td>                                           
            </tr>                           
            <tr style="height: 15px">
                <td class="tLetra3">
                    &nbsp;&nbsp;&nbsp;Concepto
                </td>
                <td colspan="5">     
                    <anthem:TextBox ID="txtConcepto" runat="server" Width="745px" CssClass="String" TabIndex="10"></anthem:TextBox>                            
                </td>                
            </tr> 
        </table>
        <br />
        <anthem:Panel ID="pnlDetail" runat="server" BackImageUrl="../../../Img/dxpcFooterBack.gif"  width="100%">
        <table border="0" cellpadding="0" cellspacing="0" width="99%">            
            <tr style="height:30px">
                <td class="tLetra5" style="width:60px">
                    &nbsp;&nbsp;&nbsp;Cuenta
                </td>
                <td style="width:200px">                    
                    <anthem:TextBox ID="txtCuenta" runat="server" TabIndex="20" Width="40px" MaxLength="4" CssClass="String"></anthem:TextBox>
                    &nbsp;
                    <anthem:TextBox ID="txtSubCuenta" runat="server" TabIndex="21" Width="40px" MaxLength="4" CssClass="String" ></anthem:TextBox>
                    &nbsp;
                    <anthem:TextBox ID="txtSubSubCuenta" runat="server" TabIndex="22" Width="40px" MaxLength="4" CssClass="String" ></anthem:TextBox>
                    <anthem:HiddenField ID="hddNombreCuenta" runat="server" />
                    <anthem:HiddenField ID="hddCuenta" runat="server" />
                    <anthem:HiddenField ID="hddIndAuxiliar" runat="server" />
                 </td> 
                 <td class="tLetra5" style="width:60px">
                    Auxiliar
                    &nbsp;
                </td>
                 <td>                    
                    <anthem:TextBox ID="txtAuxiliar" runat="server" TabIndex="23" Width="100px" CssClass="String"></anthem:TextBox>
                 </td>
                 <td class="tLetra5" style="width:60px">
                    Obra
                </td> 
                 <td>                    
                    <anthem:TextBox ID="txtObra" runat="server" TabIndex="24" Width="100px" CssClass="String"></anthem:TextBox>                 
                 </td> 
                 <td class="tLetra5" style="width:60px">
                     Referencia
                </td>                   
                 <td>
                    <anthem:TextBox ID="txtReferencia" runat="server" TabIndex="25" Width="120px" CssClass="String"></anthem:TextBox>
                    &nbsp;
                    <anthem:Label ID="lblTM" runat="server" CssClass="tLetra5">TM</anthem:Label>
                    &nbsp;
                    <anthem:DropDownList ID="cboTM" runat="server" CssClass="String" Width="200px"></anthem:DropDownList>
                 </td>                                           
           </tr>
           <tr  style="height:30px">
                <td class="tLetra5" style="width:60px">
                    &nbsp;&nbsp;&nbsp;Cargos
                </td>  
                <td class="style20">
                    <anthem:TextBox ID="txtCargos" runat="server" TabIndex="26" Width="100px" CssClass="String"></anthem:TextBox>
                 </td>
                 <td class="tLetra5" style="width:60px">
                     Abonos
                    &nbsp;
                </td>        
                <td class="style20">
                    <anthem:TextBox ID="txtAbonos" runat="server" TabIndex="27" Width="100px" CssClass="String"></anthem:TextBox>
                </td>  
                <td class="tLetra5" style="width:60px">
                     Concepto
                    &nbsp;
                </td>  
                <td class="style20" colspan="4">
                     <anthem:TextBox ID="txtConceptoPoliza" runat="server" Width="590px" CssClass="String" TabIndex="28" >
                    </anthem:TextBox> 
                    <anthem:LinkButton id="lklConcepto" runat="server" OnClick="txtConceptoPoliza_Change"></anthem:LinkButton>  
                    <anthem:LinkButton id="lknDeletePartida" runat="server" OnClick="lknDelete_Click"></anthem:LinkButton>                     
                 </td>   
             </tr>
        </table>
        </anthem:Panel>
        <table width="100%">
            <tr>
                <td style="width:100%">
                    <anthem:Panel runat="server" ID="pnlPagger" Width="99%" CssClass="border" >
                       <uc3:ctrlPagger ID="ctrlPagger1" runat="server" />
                    </anthem:Panel>
                </td>
            </tr> 
            <tr>
                <td align="left" style="width:100%">
                    <div  id="div-ListPanelPoliza2"> 
                    <anthem:GridView ID="grdPolizaDet" TabIndex="29" runat="server" AutoGenerateColumns="false" EmptyDataText="Agrege una linea." HeaderStyle-CssClass="locked" 
                     DataKeyNames="intPartida,Conciliado" CellPadding="0" CellSpacing="0" RowStyle-CssClass="GridViewRow"  
                     CssClass="dxgvTable_Aqua" Width="98%" BorderWidth="0" ForeColor="Navy" OnRowDeleting="DgrdList_RowDeleting" OnSorting="DgrdList_Sorting" GridLines="None">
                    <Columns>
                      <asp:BoundField DataField="intPartida" SortExpression="intPartida" HeaderText="No" ItemStyle-HorizontalAlign="Center" ItemStyle-Width="20px">
			          </asp:BoundField>     
                      <asp:TemplateField HeaderText="Cuenta" SortExpression="Cuenta" ItemStyle-HorizontalAlign="Left" ItemStyle-Width="90px" >
                          <itemtemplate>   
                                <Anthem:TextBox ID="txtCuentaDet" style="text-align:right;" Runat="server" Text='<%# Eval("Cuenta") %>' ToolTip="Ingrese la cuenta"  MaxLength="16" Width="90px" /> 
		                  </itemtemplate>   
		             </asp:TemplateField>                   		             
		               <asp:TemplateField HeaderText="Nombre Cuenta" SortExpression="DesCuenta" ItemStyle-HorizontalAlign="Left" ItemStyle-Width="180px" >
                          <itemtemplate>   
                                <Anthem:TextBox ID="txtCuentaNombreDet" Runat="server" ToolTip="cuenta" Width="180px" Text='<%# Eval("DesCuenta") %>' /> 
		                  </itemtemplate>
		             </asp:TemplateField>                			               	
		             <asp:TemplateField HeaderText="Auxiliar" SortExpression="Auxiliar" ItemStyle-HorizontalAlign="Left" ItemStyle-Width="60px" >
                          <itemtemplate>   
                                <Anthem:TextBox ID="txtAuxiliarDet" style="text-align:right;" Runat="server" ToolTip="Ingrese el auxiliar" Width="60px" Text='<%# Eval("Auxiliar") %>' /> 
		                  </itemtemplate>
		             </asp:TemplateField>
		             <asp:TemplateField HeaderText="Obra" SortExpression="Obra" ItemStyle-HorizontalAlign="Left" ItemStyle-Width="60px" >
                          <itemtemplate>   
                                <Anthem:TextBox ID="txtObraDet" style="text-align:right;" Runat="server" ToolTip="Ingrese la obra" Width="60px" Text='<%# Eval("Obra") %>' />  
		                  </itemtemplate>
		             </asp:TemplateField>	
		             <asp:TemplateField HeaderText="Referencia" SortExpression="Referencia" ItemStyle-HorizontalAlign="Left" ItemStyle-Width="90px" >
                          <itemtemplate>   
                                <anthem:TextBox ID="txtReferenciaDet" runat="server" Width="90px" Text='<%# Eval("Referencia") %>'></anthem:TextBox>
		                  </itemtemplate>
		             </asp:TemplateField>	
		             <asp:TemplateField HeaderText="Cargos" SortExpression="Cargos" ItemStyle-HorizontalAlign="Left" ItemStyle-Width="70px" >
                          <itemtemplate>   
                                <anthem:TextBox ID="txtCargosDet" runat="server" Width="70px" Text='<%# Eval("Cargos") %>' ></anthem:TextBox>
		                  </itemtemplate>
		             </asp:TemplateField>
		             <asp:TemplateField HeaderText="Abonos" SortExpression="Abonos" ItemStyle-HorizontalAlign="Left" ItemStyle-Width="70px" >
                          <itemtemplate>   
                                <anthem:TextBox ID="txtAbonosDet" runat="server" Width="70px" Text='<%# Eval("Abonos") %>'  ></anthem:TextBox>
		                  </itemtemplate>
		             </asp:TemplateField>	
		             <asp:TemplateField HeaderText="Descricpion" SortExpression="Descricpion" ItemStyle-HorizontalAlign="Left" ItemStyle-Width="300px" >
                          <itemtemplate>   
                                <anthem:TextBox ID="txtDescripcionDet" runat="server" Width="300px" Text='<%# Eval("Descricpion") %>' ></anthem:TextBox>
		                  </itemtemplate>
		             </asp:TemplateField>
		             <asp:TemplateField HeaderText="SOB" ItemStyle-HorizontalAlign="Center" ItemStyle-Width="30px">
		                <itemtemplate>		
			                <anthem:CheckBox ID="chkSelect" runat="server" CssClass="tLetra4" />
		                </itemtemplate>
		            </asp:TemplateField>
		             <asp:TemplateField ShowHeader="False" ItemStyle-HorizontalAlign="Center" ItemStyle-Width="30px">
		                <itemtemplate>		
			                <anthem:ImageButton runat="server" ImageUrl="../../../Img/Deleted.png" CausesValidation="False" ImageAlign="Middle" id="lknDelete">
			                </anthem:ImageButton>
		                </itemtemplate>
		            </asp:TemplateField>            	                     	                
                 </Columns>                                        
                 </anthem:GridView>  
                 </div>    
                </td>
            </tr>
        </table>        
	            		   	
	<script type="text/javascript" language="javascript">							
		
		window.onbeforeunload = function(e) 
	    {
	        <%
                Response.Expires=0;
            %>
        };                   
	    	     	    
	    function FindObra(ctrl)
	    {
	        var obj = document.getElementById(ctrl);
	        var id;
	        var value = '';
	        
	        if(objObras == null)
	            alert('undefined');
                          	        
	        for(i=0;i<objObras.length;i++)
		    {
		       id = objObras[i].id;

		       if(id == obj.value)
		           value = id;
		    }
		    		    		    	    
		    if(value == '')
		    {
		        alert('No existe la obra, para esta empresa.');
		        obj.value = '';
		        obj.focus();
		    }
	    }
	    
	     function FindAux(ctrl)
	    {
	        var obj = document.getElementById(ctrl);
	        var id;
	        var value = '';
	                	                                                	        
	        for(i=0;i<objAux.length;i++)
		    {
		       id = objAux[i].id;
		       
    	       if(id == obj.value)
		           value = id;
		    }
		    		    		    	    
		    if(value == '')
		    {
		        alert('Auxiliar no valido.');
		        obj.value = '';
		        obj.focus();
		    }
	    }
	    
	    function Obras(row)
	    {
	        var objObra;
	        var id;
	        var value;
	        
	        var table = document.getElementById('<%=grdPolizaDet.ClientID %>');          
            var inputs = table.rows(row + 1).getElementsByTagName("input");            
	        	        
            for (var i = 0; i < inputs.length; i++)
            {
                if (inputs[i].name.indexOf("txtObraDet") != -1) 
                {
                    objObra = inputs[i];                    
                }                               
            }  
            
            value = '';
                    	        
	        for(i=0;i<objObras.length;i++)
		    {
		       id = objObras[i].id;

		       if(id == objObra.value)
		           value = id;
		    }
		    
		    if(value == '')
		    {
		        alert('No existe la obra, para esta empresa.');
		        objObra.value = '';
		    }
	    }
	    
	    function Auxiliares(row)
	    {
	        var Aux;
	        var id;
	        var value;
	        
	        var table = document.getElementById('<%=grdPolizaDet.ClientID %>');          
            var inputs = table.rows(row + 1).getElementsByTagName("input");            
	        	        
            for (var i = 0; i < inputs.length; i++)
            {
                if (inputs[i].name.indexOf("txtAuxiliarDet") != -1)  
                {
                    Aux = inputs[i];                    
                }                               
            }  
            
            value = '';
                    	        
	        for(i=0;i<objAux.length;i++)
		    {
		       id = objAux[i].id;

		       if(id == Aux.value)
		           value = id;
		    }
		    
		    if(value == '')
		    {
		        alert('Auxiliar no valido.');
		        Aux.value = '';
		    }
	    }
	    
	    function CuentaName(row)
	    {
	        var objCuenta;
	        var objNombre;
	        var id;
	        var value;        	       
	        
	        var table = document.getElementById('<%=grdPolizaDet.ClientID %>');          
            var inputs = table.rows(row + 1).getElementsByTagName("input");                                    
	        	        
            for (var i = 0; i < inputs.length; i++)
            {                               
                if (inputs[i].name.indexOf("txtCuentaDet") != -1) 
                {                    
                    objCuenta = inputs[i];                    
                }
                
                if (inputs[i].name.indexOf("txtCuentaNombreDet") != -1) 
                {
                    objNombre = inputs[i];                    
                }
            }  
            
            objNombre.value = '';           
                    	        
	        for(i=0;i<objCuentas.length;i++)
		    {
		       id = objCuentas[i].id;
		       value = objCuentas[i].name;
		       if(id == objCuenta.value)
		           objNombre.value = value;
		    }
		    		    
		    if(objNombre.value == '')
		    {
		        objCuenta.value = '';
		        alert('No existe la cuenta, para esta empresa.');
		    }
	    }
	    
	    function SelectCHK(row)
	    {	        
            var table = document.getElementById('<%=grdPolizaDet.ClientID %>');
          
            var inputs = table.rows(row + 1).getElementsByTagName("input");            
	        	        
            for (var i = 1; i < inputs.length; i++)
            {
                if (inputs[i].type == "checkbox") 
                {
                    inputs[i].checked=true                    
                }
            }                                                       
	    }
	    
	    function UpdateCargos()
	    {
	        var GridView = document.getElementById('<%=grdPolizaDet.ClientID%>');
	        var txtTotalCargos = document.getElementById('<%=txtTotalCargos.ClientID %>');
	        var txtDiferenciia = document.getElementById('<%=txtDiferenciia.ClientID %>');
		    var Abonos = document.getElementById('<%=txtTotalAbonos.ClientID %>').value;
	        var dblCargo = parseFloat(0);
	        var ctl = '';
	        
	        Abonos = Abonos.replace("$","");    
	        Abonos = Abonos.replace(",",""); 
	        Abonos = Abonos.replace(",","");
	        Abonos = Abonos.replace(",","");
	        
	        var inputs = GridView.getElementsByTagName("input");
	        
	        
            for (var i = 0; i < inputs.length; i++) 
            {
                if (inputs[i].type == "text") 
                {
                    if(inputs[i].id.indexOf("txtCargosDet") != -1)
                    {                                        
                        dblCargo += parseFloat(inputs[i].value); 
                    }                  
                }
            }            
                      
            var res = parseFloat(dblCargo) - parseFloat(Abonos);                                     
                       
            txtTotalCargos.value = "$" + parseFloat(dblCargo).toFixed(2);                                                          
            txtDiferenciia.value =  "$" + parseFloat(res).toFixed(2);
            
            if(txtDiferenciia.value == '$-0.00')
                 txtDiferenciia.value = "$0.00"                             
	    }	
	        	   
	    function UpdateAbonos()
	    {
	        var GridView = document.getElementById('<%=grdPolizaDet.ClientID%>');
	        var txtTotalAbonos = document.getElementById('<%=txtTotalAbonos.ClientID %>');
	        var txtDiferenciia = document.getElementById('<%=txtDiferenciia.ClientID %>');
		    var Cargo = document.getElementById('<%=txtTotalCargos.ClientID %>').value;
	        var dblAbonos = parseFloat(0);
	        var ctl = '';
	        
	        Cargo = Cargo.replace("$","");    
	        Cargo = Cargo.replace(",",""); 
	        Cargo = Cargo.replace(",","");
	        Cargo = Cargo.replace(",","");
	        
	        var inputs = GridView.getElementsByTagName("input");
	        
            for (var i = 0; i < inputs.length; i++) 
            {
                if (inputs[i].type == "text") 
                {
                    if(inputs[i].id.indexOf("txtAbonosDet") != -1)
                    {                              
                        dblAbonos += parseFloat(inputs[i].value); 
                    }                  
                }
            }        

            var res = parseFloat(Cargo) - parseFloat(dblAbonos); 

            txtTotalAbonos.value = "$" + parseFloat(dblAbonos).toFixed(2);                                                          
            txtDiferenciia.value =  "$" + parseFloat(res).toFixed(2); 
            
            if(txtDiferenciia.value == '$-0.00')
                 txtDiferenciia.value = "$0.00"
	    }	
				
		function datosCompletos()
		{	   		    		
		     var lblAfectada = document.getElementById('<%=lblAfectada.ClientID %>').innerHTML;		    	     
		     var txtPoliza = document.getElementById('<%=txtPoliza.ClientID %>');
		     var lblCargos = document.getElementById('<%=txtTotalCargos.ClientID %>').value;
		     var lblAbonos = document.getElementById('<%=txtTotalAbonos.ClientID %>').value;
		     var dblCargos = 0;
             var dblAbonos = 0;
                                      
             if(lblCargos == "")
                lblCargos = "0";
               
               if(lblAbonos == "")
                lblAbonos = "0";                 
                          
             dblCargos = lblCargos.replace("$","").replace(",","");
             dblAbonos = lblAbonos.replace("$","").replace(",","");      
             
             dblCargos = dblCargos.replace(",","");
             dblAbonos = dblAbonos.replace(",",""); 
                                           
		     if(lblAfectada == "Poliza Afectada")
		     {
		         alert('No se puede modificar una poliza afectada'); 
		         txtPoliza.focus(); 
		         txtPoliza.runtimeStyle.backgroundColor='#FFFF00';
		         return false;
		     }                                                                                
		     		     			     		     
		     if(!(dblCargos - dblAbonos == 0)) 
             {                                    
                alert('La poliza esta descuadrada.');
                return false;
             }		     		    

            return true;
		}									                             
          
        function ValidaDetalle()
        {     
            var hddIndAuxiliar = document.getElementById('hddIndAuxiliar').value;

            if(hddIndAuxiliar == "1")
                return objUtils.validaItems("ctl00_CPHBase_txtCuenta,ctl00_CPHBase_txtAuxiliar,ctl00_CPHBase_txtObra,ctl00_CPHBase_txtReferencia");  
            else
                return objUtils.validaItems("ctl00_CPHBase_txtCuenta,ctl00_CPHBase_txtObra,ctl00_CPHBase_txtReferencia");            
        }        
        
        function OnlyNumber() 
        {
            var key = window.event.keyCode;
            
            if (key < 48 || key > 57) 
            {
               if(key == 46)
                window.event.keyCode = 46;
               else
               {
                    if(key == 45)
                        window.event.keyCode = 45;
                    else
                    window.event.keyCode = 0;
               }
            }
            else 
            {                                
               if (key == 13) 
               {
                  window.event.keyCode = 0;
               }
            }
        }  
        
        function EnterButton()
        {
            var key = window.event.keyCode;
                                                   
            if (key == 13) 
            {            
                window.event.keyCode = 9;
            
                 var hddIndAuxiliar = document.getElementById('<%=hddIndAuxiliar.ClientID %>').value;
                 var yes = true;
                 var txtSubSubCuenta = document.getElementById("<%=txtSubSubCuenta.ClientID %>");
                 var auxiliar = document.getElementById("<%=txtAuxiliar.ClientID %>");
                 var obra = document.getElementById("<%=txtObra.ClientID %>");
                 var referencia = document.getElementById("<%=txtReferencia.ClientID %>");                                  
                                                  
                 if(hddIndAuxiliar == "1")
                 {
                    if(auxiliar.value == "")
                    {
                        alert('La cuenta requiere de auxiliar');
                        txtSubSubCuenta.focus();
                        return false;
                    }
                    else 
                        yes = true;
                 }
                                                    
                 if(obra.value == "")
                 {
                     alert('Debe seleccinar una obra');
                     obra.focus();
                     return false;
                 }
                 else 
                     yes = true; 
 
                 if(referencia.value == "")
                 {
                     alert('Debe seleccinar una referencia');
                     referencia.focus();
                     return false;
                 }
                 else 
                     yes = true;                                   
                 
                 if(yes)                    
                 {
                    //__doPostBack('txtConceptoPoliza','');
                    document.getElementById('<%=lklConcepto.ClientID %>').onclick();
                    document.getElementById('<%=txtCuenta.ClientID %>').focus();
                   return true;
                 }
                 else 
                    return false;
            }
                       
            if (key == 9) 
            {
                 var hddIndAuxiliar = document.getElementById('hddIndAuxiliar').value;
                 var yes = true;
                 var txtSubSubCuenta = document.getElementById("txtSubSubCuenta");
                 var auxiliar = document.getElementById("txtAuxiliar");
                 var obra = document.getElementById("txtObra");
                 var referencia = document.getElementById("txtReferencia");
                 
                 if(hddIndAuxiliar == "1")
                 {
                    if(auxiliar.value == "")
                    {
                        alert('La cuenta requiere de auxiliar');
                        txtSubSubCuenta.focus();
                        return false;
                    }
                    else 
                        yes = true;
                 }
                                
                 if(obra.value == "")
                 {
                     alert('Debe seleccinar una obra');
                     obra.focus();
                     return false;
                 }
                 else 
                     yes = true; 
                     
                 if(referencia.value == "")
                 {
                     alert('Debe seleccinar una referencia');
                     referencia.focus();
                     return false;
                 }
                 else 
                     yes = true; 
                         
                 if(yes)                    
                 {
                   //__doPostBack('txtConceptoPoliza','');
                    document.getElementById('<%=lklConcepto.ClientID %>').onclick();
                    document.getElementById('<%=txtCuenta.ClientID %>').focus();
                   return true;
                 }
                 else 
                    return false;                                                            
            }                                     
            
            return true;                                   
        }
        
        function UpDownCuenta(row) 
        {
           var key = window.event.keyCode;
           var table = document.getElementById('<%=grdPolizaDet.ClientID %>');
           
           if(key == 13)
                window.event.keyCode = 9;
          
           var gv = document.getElementById("<%= grdPolizaDet.ClientID %>");     
           var tb;
                     
           if (key == 38) 
           {
                if(row > 0)
                {
                    tb = gv.rows(row).cells(0).getElementsByTagName("input");  
                    tb(0).focus();                   
                }                        
           }  
           
           var rows = gv.rows.length;             
           rows = rows - 2;     
                                
           if (key == 40) 
           {      
                if(row < rows) 
                {
                    tb = gv.rows(row + 2).cells(0).getElementsByTagName("input"); 
                    tb(0).focus();  
                 }
           }           
        } 
        
        function UpDownAuxiliar(row) 
        {
           var key = window.event.keyCode;
           var table = document.getElementById('<%=grdPolizaDet.ClientID %>');
           
           if(key == 13)
                window.event.keyCode = 9;
          
          var gv = document.getElementById("<%= grdPolizaDet.ClientID %>");     
          var tb;
                     
           if (key == 38) 
           {
                if(row > 0)
                {
                    tb = gv.rows(row).cells(2).getElementsByTagName("input");  
                    tb(0).focus();                   
                }
           }  
           
           var rows = gv.rows.length;             
           rows = rows - 2;     
                                
           if (key == 40) 
           {      
                if(row < rows) 
                {
                    tb = gv.rows(row + 2).cells(2).getElementsByTagName("input"); 
                    tb(0).focus();  
                 }
           }           
        }   
        
        function UpDownObra(row) 
        {
           var key = window.event.keyCode;
           var table = document.getElementById('<%=grdPolizaDet.ClientID %>');
           
           if(key == 13)
                window.event.keyCode = 9;
          
          var gv = document.getElementById("<%= grdPolizaDet.ClientID %>");     
          var tb;
                     
           if (key == 38) 
           {
                if(row > 0)
                {
                    tb = gv.rows(row).cells(3).getElementsByTagName("input");  
                    tb(0).focus();                   
                }
           }  
           
           var rows = gv.rows.length;             
           rows = rows - 2;     
                                
           if (key == 40) 
           {      
                if(row < rows) 
                {
                    tb = gv.rows(row + 2).cells(3).getElementsByTagName("input"); 
                    tb(0).focus();  
                 }
           }           
        }  
        
        function UpDownReferencia(row) 
        {
           var key = window.event.keyCode;
           var table = document.getElementById('<%=grdPolizaDet.ClientID %>');
           
           if(key == 13)
                window.event.keyCode = 9;
          
          var gv = document.getElementById("<%= grdPolizaDet.ClientID %>");     
          var tb;
                     
           if (key == 38) 
           {
                if(row > 0)
                {
                    tb = gv.rows(row).cells(4).getElementsByTagName("input");  
                    tb(0).focus();                   
                }
           }  
           
           var rows = gv.rows.length;             
           rows = rows - 2;     
                                
           if (key == 40) 
           {      
                if(row < rows) 
                {
                    tb = gv.rows(row + 2).cells(4).getElementsByTagName("input"); 
                    tb(0).focus();  
                 }
           }           
        }     
        
        function UpDownCargos(row) 
        {
           var key = window.event.keyCode;
           var table = document.getElementById('<%=grdPolizaDet.ClientID %>');
           
           if(key == 13)
                window.event.keyCode = 9;
          
          var gv = document.getElementById("<%=grdPolizaDet.ClientID %>");     
          var tb;
                     
           if (key == 38) 
           {
                if(row > 0)
                {
                    tb = gv.rows(row).cells(5).getElementsByTagName("input");  
                    tb(0).focus();                   
                }
           }  
           
           var rows = gv.rows.length;             
           rows = rows - 2;     
                                
           if (key == 40) 
           {      
                if(row < rows) 
                {
                    tb = gv.rows(row + 2).cells(5).getElementsByTagName("input"); 
                    tb(0).focus();  
                 }
           }           
        } 
        
        function UpDownAbonos(row) 
        {
           var key = window.event.keyCode;
           var table = document.getElementById('<%=grdPolizaDet.ClientID %>');
           
           if(key == 13)
                window.event.keyCode = 9;
          
          var gv = document.getElementById("<%=grdPolizaDet.ClientID %>");     
          var tb;
                     
           if (key == 38) 
           {
                if(row > 0)
                {
                    tb = gv.rows(row).cells(6).getElementsByTagName("input");  
                    tb(0).focus();                   
                }
           }  
           
           var rows = gv.rows.length;             
           rows = rows - 2;     
                                
           if (key == 40) 
           {      
                if(row < rows) 
                {
                    tb = gv.rows(row + 2).cells(6).getElementsByTagName("input"); 
                    tb(0).focus();  
                 }
           }           
        }  
        
        function UpDownDescripcion(row) 
        {
           var key = window.event.keyCode;
           var table = document.getElementById('<%=grdPolizaDet.ClientID %>');
           
           if(key == 13)
                window.event.keyCode = 9;
          
          var gv = document.getElementById("<%= grdPolizaDet.ClientID %>");     
          var tb;
                     
           if (key == 38) 
           {
                if(row > 0)
                {
                    tb = gv.rows(row).cells(7).getElementsByTagName("input");  
                    tb(0).focus();                   
                }
           }  
           
           var rows = gv.rows.length;             
           rows = rows - 2;     
                                
           if (key == 40) 
           {      
                if(row < rows) 
                {
                    tb = gv.rows(row + 2).cells(7).getElementsByTagName("input"); 
                    tb(0).focus();  
                 }
           }           
        }                                             
        
        function Copiar(poliza, intEjercicio, intTipo,intEmpresa)
        {       
           var url = "PopUpCopiar.aspx?strPoliza=" + poliza + "&intEjercicio=" + intEjercicio + "&intTipo=" + intTipo + "&intEmpresa=" + intEmpresa;
           var a = window.showModalDialog(url, "", "dialogHeight:250px;dialogWidth:610px;toolbar=no,status=no,scroll=no'");
                                 
           if(a != undefined)
           {           
               var poliza = document.getElementById('<%=txtPoliza.ClientID %>');
               poliza.value = a;
               poliza.onchange();
           }
        }
        
        function CFDI(poliza,intEjercicio,intEmpresa)
        {       
           var url = "CargaCFDI.aspx?strPoliza=" + poliza + "&intEjercicio=" + intEjercicio + "&intEmpresa=" + intEmpresa;
           var a = window.showModalDialog(url, "", "dialogHeight:600px;dialogWidth:600px;toolbar=no,status=no,scroll=no'");
                                 
           if(a != undefined)
           {           
               var poliza = document.getElementById('<%=txtPoliza.ClientID %>');
//               poliza.value = a;
//               poliza.onchange();
           }
        }  
        
        function Ejercicio()
        {     
            var fecha = document.getElementById('<%=txtFechaInicial.ClientID %>').value;
            
            var elem = fecha.split('/');
            var dia = elem[0];
            var mes = elem[1];
            var año = elem[2];
            
            var hddMonth = document.getElementById('<%=hddMonth.ClientID %>');
            var hddYear = document.getElementById('<%=hddYear.ClientID %>');
            hddYear.value = año; 
            hddMonth.value = mes;   
         }
                      
        
    </script>

</asp:Content>
