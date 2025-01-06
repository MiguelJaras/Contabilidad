<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="Base.master" MaintainScrollPositionOnPostback="true" CodeFile="ConciliacionCFDI.aspx.cs" Inherits="Pages_Contabilidad_Opciones_ConciliacionCFDI"  culture="es-mx" uiculture="es" %>
<%@ Register Assembly="Anthem" Namespace="Anthem" TagPrefix="anthem" %>

<asp:Content ID="Content1" ContentPlaceHolderID="CPHBase" Runat="Server">
    <style type="text/css">
        a:link { text-decoration: none; color: #0000CC; }
        a:hover { background: #EEEEEE; }
        a:active { background: #FFFFFF; }         
    </style>
      
    <script src="../../Scripts/JBrowse.js" type="text/javascript"></script>
    <script type="text/javascript"  src="../../Scripts/Funciones.js"></script> 

    <script type="text/javascript" >  

        function saveScrollPos(object) 
        { 
            document.getElementById('scrollPos').value = object.scrollTop; 
        }
        function setScrollPos(elementId) 
        {
            document.getElementById(elementId).scrollTop = document.getElementById('scrollPos').value;
        } 
    
        var sel=0;

        function redondea(sVal, nDec) 
        {
            var n = parseFloat(sVal);
            var s;
            
            n = Math.round(n * Math.pow(10, nDec)) / Math.pow(10, nDec);
            s = String(n) + "." + String(Math.pow(10, nDec)).substr(1);
            s = s.substr(0, s.indexOf(".") + nDec + 1);
            
            return s;
        }

        function redondeo(numero) 
        {            
            var original = parseFloat(numero);
            var result = Math.round(original * 100) / 100;
            
            return result;
        }                      
           
   
    function Over(obj) 
    {
        obj.style.backgroundColor = "#FFA07A";             
        obj.style.border = "solid 1px #EEEEEE";                   
        obj.style.cursor = "hand";              
    }

    function Out(obj)
    {        
        obj.style.backgroundColor = "#FAFAFA";
        obj.style.color = "Black";
        obj.style.cursor = "";
    }

    function EditRow(rowIndex)
    {       
       document.getElementById("ctl00_ContentPlaceHolder1_txtRowEdit").value = rowIndex;
       document.getElementById("ctl00_ContentPlaceHolder1_txtRowEdit").onchange();
    } 
    
    //Atach Events
    if (typeof document.addEventListener != 'undefined')
        document.addEventListener('keydown', killBackSpace, false);
    else 
        if (typeof document.attachEvent != 'undefined')
        document.attachEvent('onkeydown', killBackSpace);
    else 
    {
        if (document.onkeydown != null) 
        {
            var oldOnkeydown = document.onkeydown;
            document.onkeydown = function(e) 
            {
                killBackSpace(e);
            };
        } 
        else
            document.onkeydown = killBackSpace;
    }


     function killBackSpace(e) 
    {   
        if(window.event.ctrlKey) 
            __isCtrl=true;	    
         else
            __isCtrl=false;	
	 
	    if("G" ==  String.fromCharCode(event.keyCode) && __isCtrl == true) 
	    {
		    if(document.getElementById("ctl00_btnSave")==null)
		    {
		        return false;
		    }
		    else
		    {
		        document.getElementById("ctl00_btnSave").onclick();
		    }
		    
		    return false;
	    }
	    
	    //Nuevo
	    if("N" ==  String.fromCharCode(event.keyCode) && __isCtrl == true) 
	    {
		    if(document.getElementById("ctl00_btnNew")==null)
		    {
		        return false;
		    }
		    else
		    {
		        document.getElementById("ctl00_btnNew").onclick();
		    }
		    
		    return false;
	    }
	    
	     //Listado
	    if("L" ==  String.fromCharCode(event.keyCode) && __isCtrl == true) 
	    {
		   if(document.getElementById("ctl00_btnList")==null)
		    {
		        return false;
		    }
		    else
		    {
		        document.getElementById("ctl00_btnList").onclick();
		    }
		    
		    return false;
	    }
	        
	    //Imprimir
	    if("I" ==  String.fromCharCode(event.keyCode) && __isCtrl == true) 
	    {
		   if(document.getElementById("ctl00_btnPrint")==null)
		    {
		        return false;
		    }
		    else
		    {
		        document.getElementById("ctl00_btnPrint").onclick();
		    }
		    
		    return false;
	    }
	    
	     //Eliminar
	    if("E" ==  String.fromCharCode(event.keyCode) && __isCtrl == true) 
	    {
		    if(document.getElementById("ctl00_btnDelete")==null)
		    {
		        return false;
		    }
		    else
		    {
		        document.getElementById("ctl00_btnDelete").onclick();
		    }
		    
		    return false;
	    }
	    
	    if(window.event==null)
	            return;
		             
        }

	
	function Browse(p_strClave,p_strTexts, p_strBO, p_strParam, p_intVersion, p_intEmpresa,p_intSucursal, p_intLength, p_blRequerido, p_strMsg, p_IsQuery)
{ 
	var _IsQuery = p_IsQuery || 0;
	var _objClave=document.getElementById(p_strClave);
	var _strBO=p_strBO;
	var _p_blRequerido=p_blRequerido;
	var _strParam=p_strParam;	
	var _intVersion=p_intVersion; 
	var _strMsg=p_strMsg;
	var _functionReady;
	var arrControles=p_strTexts.split(",");
	var _strCampoBusqueda = _strCampoBusqueda || "strNombre";
	var _strTemp="";
	var arrControlesParam=_strParam.split(",");
	for (var i=0; i<arrControlesParam.length; i++)
	{
        try
        {
            if(document.getElementById(arrControlesParam[i])!=null)
            {
			    if(document.getElementById(arrControlesParam[i]).type=="select-one")
			        if(document.getElementById(arrControlesParam[i]).value=="")
			            _strTemp=_strTemp+"[--]0";
			        else
			            _strTemp=_strTemp+"[--]"+document.getElementById(arrControlesParam[i]).value;
			    else
			        _strTemp=_strTemp+"[--]"+document.getElementById(arrControlesParam[i]).value;
		    }
			else 
			    _strTemp=_strTemp+"[--]"+arrControlesParam[i];
		 }
		 catch(ex)
		 {
		    _strTemp=_strTemp+"[--]0";
		 }
    }

	_strTemp=_strTemp.substring(4,100); 
	var result=MuestraPantalla(p_intEmpresa, p_intSucursal,_strBO,_strTemp,_intVersion,_strCampoBusqueda,_IsQuery);
	if(result==null)
	    return;		
	_objClave.value=result.split("[--]")[0];
	for (var i=0; i<arrControles.length; i++)
	{
	    if(document.getElementById(arrControles[i])!=null)
		{
		    if(document.getElementById(arrControles[i]).name == 'hddOperation')
			    document.getElementById(arrControles[i]).value = "2";
			else
			    if(document.getElementById(arrControles[i]).type == "checkbox")
			        document.getElementById(arrControles[i]).checked = (result.split("[--]")[i] == "1" ? true : false);
			    else
			    {
			        if(document.getElementById(arrControles[i]).name == 'cboUnidadInsumo')
			        {
			            if(document.getElementById(arrControles[1]).value != "0")
			            {
			                document.getElementById(arrControles[i]).style.backgroundColor="Silver"; 
			                document.getElementById(arrControles[i]).style.Color="#000066";
			                document.getElementById(arrControles[i]).style.textalign="right";
			            } 
			            else
			            {
			                document.getElementById(arrControles[i]).style.backgroundColor="white"; 
			                document.getElementById(arrControles[i]).style.Color="black";
			                document.getElementById(arrControles[i]).style.textalign="right";
			            }
			        }
			        
			        if(document.getElementById(arrControles[i]).name == 'txtPrecioInsumo')
			        {
			            if(document.getElementById(arrControles[1]).value != "0")
			            {
			                document.getElementById(arrControles[i]).style.backgroundColor="Silver"; 
			                document.getElementById(arrControles[i]).style.Color="#000066";
			                document.getElementById(arrControles[i]).style.textalign="right";
			            }
			            else
			            {
			                document.getElementById(arrControles[i]).style.backgroundColor="white"; 
			                document.getElementById(arrControles[i]).style.Color="black";
			                document.getElementById(arrControles[i]).style.textalign="right";
			            }  
			        }

				    document.getElementById(arrControles[i]).value=(result.split("[--]")[i] == '&nbsp;' ? '' : result.split("[--]")[i]);
		        }       
	        }	
		}
		return 	result;	
	}
    function UpDownBank(row, event) {
        // Obtén el código de la tecla presionada
        var key = window.event.keyCode;

        var table = document.getElementById('DgrdList');

        // Manejo de flecha hacia arriba (key: ArrowUp)
        if (key === 'ArrowUp') {
            if (row > 0) {
                var previousInput = table.rows[row - 1].cells[4].querySelector('input, select, textarea');
                if (previousInput) {
                    previousInput.focus();
                }
            }
        }

        // Obtener el total de filas
        var rows = table.rows.length;

        // Manejo de flecha hacia abajo (key: ArrowDown)
        if (key === 'ArrowDown') {
            if (row < rows - 1) {
                var nextInput = table.rows[row + 1].cells[4].querySelector('input, select, textarea');
                if (nextInput) {
                    nextInput.focus();
                }
            }
        }
    }

    function UpDownPoliza(row, event) {
        // Obtén el código de la tecla presionada
        var key = window.event.keyCode;

        var table = document.getElementById('DgrdPolizas');

        // Manejo de flecha hacia arriba (key: ArrowUp)
        if (key === 'ArrowUp') {
            if (row > 0) {
                var previousInput = table.rows[row - 1].cells[5].querySelector('input, select, textarea');
                if (previousInput) {
                    previousInput.focus();
                }
            }
        }

        // Obtener el total de filas
        var rows = table.rows.length;

        // Manejo de flecha hacia abajo (key: ArrowDown)
        if (key === 'ArrowDown') {
            if (row < rows - 1) {
                var nextInput = table.rows[row + 1].cells[5].querySelector('input, select, textarea');
                if (nextInput) {
                    nextInput.focus();
                }
            }
        }
    }

	function MuestraPantalla(intEmpresa, intSucursal,strBO, strParams, intVersion, strCampoBusqueda, strIsQuery)
    { 
		var arrParams=strParams.split("[--]");
		strParams="";
		var IsQuery = strIsQuery||0;
		if(strCampoBusqueda==null)
		    strCampoBusqueda="strNombre";
		strCampoBusqueda=strCampoBusqueda.replace('+','[MAS]');
		for(var i=0; i<arrParams.length; i++){
			strParams+="&parametro"+i+"="+arrParams[i];
		}
				
		var CSTRHOSTNAME="http://"+window.location.hostname+":" + window.location.port + "/";
        var CSTRDIRAYUDA=CSTRHOSTNAME+"Contabilidad/Utils/Browse.aspx";
                 
        var strResult = window.open(CSTRDIRAYUDA + "?intEmpresa=" + intEmpresa + "&intSucursal=" + intSucursal + "&classname=" + strBO + strParams + "&version=" + intVersion + "&parametros=" + i + "&buscarpor=" + strCampoBusqueda + "&IsQuery=" + IsQuery, '', 'dialogHeight:400px;resizable:yes;scroll:yes;');
		return strResult;
    }
       
    </script> 
    
</head>
<body>
    
       <table width="100%" border="0" cellpadding="0" cellspacing="0" bordercolor="#bac1d7">
          <tr>
             <td style="height: 500px" background="../../Imagenes/img_tabs/fondo_down_long.jpg">
                
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
	                        <td colspan="4" class="tHead" style="height: 16px">
                                Conciliación de CFDI
                            </td>
                        </tr>
	                    <tr>
	                        <td>
	                            &nbsp;
	                        </td>
	                    </tr>                                                                                                                              
                        <tr style="height: 25px">
                            <td class="tLetra3" style="width: 100px; height: 23px">
                                &nbsp;Empresa</td>
                           <td class="tLetra3">
                            <anthem:TextBox ID="txtEmpresa" runat="server" CssClass="String" Width="80px" AutoPostBack="true" ontextchanged="txtEmpresa_TextChange" TabIndex="1" BorderColor="Navy"/>
                            <anthem:ImageButton runat="server" ID="ImageButton6" OnClientClick="var a = JBrowse('ctl00_CPHBase_txtEmpresa','ctl00_CPHBase_txtEmpresa,ctl00_CPHBase_txtNombreEmpresa','DACEmpresa','',1,ctl00_CPHBase_txtEmpresa.value,ctl00_CPHBase_hddSucursal.value,'8', true,'No hay información',function(){document.getElementById('ctl00_CPHBase_txtEmpresa').onchange() },0); "
                                Height="18px" ImageUrl="../../../Img/ayuda.gif" Width="20" ImageAlign="AbsMiddle" />
                            <anthem:TextBox ID="txtNombreEmpresa" runat="server" CssClass="String" Width="300px" TabIndex="2" ReadOnly="true" BorderColor="Navy"/>
                            <anthem:HiddenField ID="hddSucursal" runat="server" />
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
                                <anthem:DropDownList ID="cboEjercicio" runat="server" CssClass="tDatos250" Width="200px" >
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
                                <%--OnSelectedIndexChanged="Month">--%>
                                <anthem:DropDownList ID="cboMonth" runat="server" CssClass="tDatos250" Width="200px"  > 
                                </anthem:DropDownList>&nbsp;
                                <anthem:HiddenField ID="hddClose" runat="server" />
                            </td>
                           
                           <%-- <td style="width:100px; height: 22px;FONT-WEIGHT:bolder;FONT-SIZE: 10pt;COLOR:Black;FONT-FAMILY: Arial;BACKGROUND-COLOR: transparent" align="right">                                  
                                <asp:Label ID="Label4" runat="server" Text="Buscar:"></asp:Label>
                            </td>--%>
                           <%-- <td style="width: 200px; height: 22px" align="left"> 
                                &nbsp;
                                <anthem:TextBox ID="txtBusqueda" runat="server" AutoCallBack="true" BorderColor="Navy"
                                    CssClass="String" Width="120px"></anthem:TextBox>
                                <anthem:ImageButton
                                        ID="ImageButton5" runat="server" Height="17" ImageUrl="../../../Img/ayuda.gif" OnClick="btnBuscar"
                                        Width="20" />                
                            </td>--%>
                        </tr>
                        
                       <tr>
                           <td> &nbsp; </td>
                       </tr>
                        <tr style="height:80%">
                            <td valign="top" style="height:80%" colspan="4">
                                <table width="100%" border="1px" cellpadding="0" cellspacing="0" style="border-color:#E0EEEE; border-style:solid;">
                                <tr>
                                    <td width="100%" align="center" >
                                        <asp:Label ID="lblBancario" runat="server" Text="CFDI" CssClass="tLetra6"></asp:Label>
                                    </td>
                                    
                                </tr>
                                <tr>
                                   <td width="150%" >
                                            <div id="div-ListPanel2">
                                            <anthem:GridView ID="DgrdList" runat="server" AutoGenerateColumns="False"
                                            CellPadding="1" CellSpacing="1" GridLines="None" Width="150%" OnSorting="DgrdList_Sorting"
                                            AllowSorting="True" OnRowCreated="DgrdList_RowCreated" DataKeyNames="rfcEmisor,rfcReceptor,Razon Social Emisor,Razon Social Receptor,Factura,FolioFiscal,FechaCFDI,FechaPoliza,Poliza,Importe" 
                                            onrowdatabound="DgrdList_RowDataBound">
                                            <HeaderStyle CssClass="locked" />
                                                <Columns>                                                    
                                                    <asp:BoundField DataField="RFCEmisor" HeaderText="RFC Emisor" SortExpression="RFCEmisor" ItemStyle-HorizontalAlign="Left" ItemStyle-Width="70px" ItemStyle-Height="25px">		                                            
			                                        </asp:BoundField> 
                                                    <asp:BoundField DataField="RFCReceptor" HeaderText="RFC Receptor" SortExpression="RFCReceptor" ItemStyle-HorizontalAlign="Left" ItemStyle-Width="70px" ItemStyle-Height="25px">		                                            
			                                        </asp:BoundField>
                                                    <asp:BoundField DataField="Razon Social Emisor" HeaderText="Razon Social Emisor" SortExpression="Razon Social Emisor" ItemStyle-HorizontalAlign="Left" ItemStyle-Width="400px" ItemStyle-Height="25px">		                                            
                                                    </asp:BoundField> 
                                                    <asp:BoundField DataField="Razon Social Receptor" HeaderText="Razon Social Receptor" SortExpression="Razon Social Receptor" ItemStyle-HorizontalAlign="Left" ItemStyle-Width="400px" ItemStyle-Height="25px">		                                            
                                                    </asp:BoundField>
			                                        <asp:BoundField DataField="Factura" HeaderText="Factura" SortExpression="Factura" ItemStyle-HorizontalAlign="Left" ItemStyle-Width="70px" ItemStyle-Height="25px">		                                            
			                                        </asp:BoundField>
                                                     <asp:BoundField DataField="FolioFiscal" HeaderText="Folio Fiscal" SortExpression="FolioFiscal" ItemStyle-HorizontalAlign="Left" ItemStyle-Width="300px" ItemStyle-Height="25px">		                                            
                                                    </asp:BoundField>
			                                        <asp:BoundField DataField="FechaCFDI" HeaderText="Fecha" SortExpression="FechaCFDI" ItemStyle-HorizontalAlign="Center" ItemStyle-Width="80px" ItemStyle-Height="25px">		                                            
                                                    </asp:BoundField>
                                                    <asp:BoundField DataField="Importe" HeaderText="Importe" SortExpression="Importe" ItemStyle-HorizontalAlign="Right" ItemStyle-Width="94px"  ItemStyle-Height="25px">		                                            
                                                    </asp:BoundField>
                                                    <asp:BoundField DataField="Poliza" HeaderText="Poliza" SortExpression="Poliza" ItemStyle-HorizontalAlign="Center" ItemStyle-Width="80px" ItemStyle-Height="25px">		                                            
                                                    </asp:BoundField>
                                                    <asp:BoundField DataField="FechaPoliza" HeaderText="Fecha Poliza" SortExpression="FechaPoliza" ItemStyle-HorizontalAlign="Center" ItemStyle-Width="80px" ItemStyle-Height="25px">		                                            
                                                    </asp:BoundField> 
                                                   <%-- <asp:TemplateField>
                                                        <itemstyle width="1px" horizontalalign="Center" />
                                                        <itemtemplate>
                                                            <asp:HiddenField runat="server" id="hddBanco" value='<%# Eval("Importe") %>'></asp:HiddenField>
                                                        </itemtemplate>
                                                    </asp:TemplateField>--%>
                                                 </Columns>
                                                 <AlternatingRowStyle CssClass="AresFormGridViewTypeBatchV" />
                                                 <RowStyle CssClass="AresFormGridViewTypeBatchV"/>
                                                 <PagerSettings Visible="False" />
                                                </anthem:GridView>
                                            </div>
                                     </td>    

                                     </tr>
                                     <tr>
                                        <td style="height: 20px">
                                            <input type="hidden" id="scrollPos" name="scrollPos" value="0" runat="server"/>
                                        </td> 
                                        <td style="height: 20px" align="center">
                                        </td>                                       
                                    </tr>
                                  </table>
                               </td>      
                            </tr>
                        <tr>
                            <td>
                                <anthem:HiddenField ID="hddDireccion" runat="server" />
                            </td>
                        </tr>
                    </table>                            
                
            </td>
        </tr>
    </table>  


    

     <iframe width="0" height="0" name="gToday:normal:agenda.js" id="gToday:normal:agenda.js" src="../../Scripts/Calendar/ipopeng.htm"
         scrolling="no" frameborder="0" style="visibility:visible; z-index:999; position:absolute; top:-500px; left:-500px;">
    </iframe>
    
    <script type="text/javascript"  src="../../Scripts/CommonUtilities.js"></script>
    <script type="text/javascript"  src="../../Scripts/SessionExpiration.js"></script>
    <script type="text/javascript"  src="../../Scripts/OnSubmit.js"></script> 
    <script type="text/javascript"  src="../../Scripts/ModalWindow.js"></script>   
  
      
    <script language="javascript" type="text/javascript">
        var objUtils = new VetecUtils();

        function fnDesconciliar() {
            var intEjercicio = document.getElementById("cboYear").value;
            var intMes = document.getElementById("cboMonth").value;
            var intCuantaContable = document.getElementById("txtCta").value;
            var nombre = document.getElementById("txtNombreCta").value;
            var intEmpresa = document.getElementById("txtEmpresa").value;

            if (intEjercicio == "" || intEjercicio == undefined) {
                alert("Seleccione el Ejercicio");
                return;
            }

            if (intCuantaContable == "" || intCuantaContable == undefined) {
                alert("Seleccione la Cuenta Bancaria");
                return;
            }
            // Deshabilitar la página principal
            document.body.style.pointerEvents = "none";
            var a = window.open("DesConciliacion.aspx?page=6100&intEjercicio=" + intEjercicio + "&intMes=" + intMes + "&intCuantaContable=" + intCuantaContable + "&Nombre=" + nombre + "&intEmpresa=" + intEmpresa, "", "dialogHeight:610px; dialogWidth:1030; resizable: yes; center:yes");
            // Al cerrar la ventana, reactivar la página principal
            // Verificar periódicamente si la ventana emergente fue cerrada
            var intervalId = setInterval(function () {
                if (a.closed) {
                    // Desbloquea la página principal al cerrar la ventana emergente
                    document.body.style.pointerEvents = "auto";
                    clearInterval(intervalId); // Detiene la verificación
                }
            }, 500); // Verifica cada medio segundo
            if (a == "1")
                __doPostBack('btnList', '');
        }

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
             if (result.error != 'BADRESPONSE')
             {
                alert(result.error);             
             }
             else
             {
                alert(result.responseText); 
             }         
	    }
    </script>  
</body>
     
</asp:Content>
