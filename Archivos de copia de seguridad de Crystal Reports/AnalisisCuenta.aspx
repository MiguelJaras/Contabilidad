<%@ Page Language="C#" AutoEventWireup="true" CodeFile="AnalisisCuenta.aspx.cs" Inherits="Balanza_AnalisisCuenta" %>
<%@ Register Assembly="Anthem" Namespace="Anthem" TagPrefix="anthem" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
    <base target="_self" />
    <title>
        Balanza
    </title>

    <link href="../../../App_Themes/Plastic Blue/GridView/styles.css"type="text/css" rel="stylesheet" />
    <link href="../../../Style/Style.css" rel="stylesheet" type="text/css" /> 
    <link href="../../../Style/StylesVetec.css" rel="stylesheet" type="text/css" /> 
    
    <script type="text/javascript" language="javascript">    
    
       function Over(obj) 
        {
            obj.style.backgroundColor = "#FFA07A";                             
            obj.style.cursor = "hand";              
        }

        function Out(obj)
        {        
            obj.style.backgroundColor = "#FAFAFA";
            obj.style.color = "Black";
            obj.style.cursor = "";
        }
        
        function Open(tipo, intObra, frente, partida)
        {
            var hddTipo = document.getElementById("hddTipo");
                        
            var url = "PUExplosionTipos.aspx?page=81&tipo=" + tipo + "&Obra=" + intObra + "&frente=" + frente + "&partida=" + partida + "&intTipo=" + hddTipo.value;
            var a = window.showModalDialog(url, "", "DialogWidth:800px; DialogHeight:600px;toolbar=no,status=no,scroll=no'");
            if(a != undefined)
            {
                var theForm = document.forms['form1'];
                theForm.__EVENTTARGET.value = 'lknSave';
                theForm.__EVENTARGUMENT.value = a;
                theForm.submit();
            }
        }                
               
    </script>
</head>
<body >
	<form  runat="server" id="form1"  method="post" >
	    <table width="100%">
	        <tr>
                <td style="height: 16px" class="tHead">
                    Balanza de Comprobación
                </td>
            </tr>
            <tr>
                <td>
                    <table width="100%">
                        <tr>
                            <td style="width:60%">
                            
                            </td>
                            <td style="width:20%" align="right" class="tCostoDirecto">
                             Total:
                            </td>
                            <td style="width:20%" align="right">
                                <anthem:Label id="lblTotal" runat="server" CssClass="tCostoDirecto"></anthem:Label>
                            </td>                            
                        </tr>
                     </table>
                </td>
            </tr>	            	   		        
            <tr>
                <td align="center" style="width:100%">
                   <div  id="div-ListPanel"> 
		                <anthem:GridView Width="97%" DataKeyNames="strCuenta"  ID="DgrdList" HeaderStyle-CssClass="dxgvHeader_PlasticBlue" 
		                    AutoUpdateAfterCallBack="true" runat="server" AllowSorting="True" AutoGenerateColumns="False" OnRowCreated="DgrdList_RowCreated"
		                    CellPadding="0" CellSpacing="0" GridLines="None">			
		                <Columns>
		                    <asp:TemplateField HeaderText="Poliza" ItemStyle-HorizontalAlign="Center" ItemStyle-Width="100px">
		                        <itemtemplate>
		                            <anthem:LinkButton runat="server" id="lknPoliza"></anthem:LinkButton>
		                        </itemtemplate>
		                     </asp:TemplateField>
		                     <asp:BoundField DataField="strCuenta" HeaderText="Cuenta" ItemStyle-Width="60px">
                             </asp:BoundField>
        		             <asp:BoundField DataField="strAuxiliar" HeaderText="Auxiliar" ItemStyle-Width="100px">
                             </asp:BoundField>
                             <asp:BoundField DataField="strObra" HeaderText="Obra" ItemStyle-Width="100px">
                             </asp:BoundField>                                                         		                   
                             <asp:BoundField DataField="dblImporte" HeaderText="Importe" ItemStyle-Width="100px">
                             </asp:BoundField>                       
		                </Columns>
		                </anthem:GridView>
                    </div>   
                </td>
            </tr>
        </table>        
	</form>
	
	<script type="text/javascript" language="javascript">
		
		window.onbeforeunload = function(e) {
	    <%
            Response.Expires=0;
        %>

        };
              
                
        function OpenChild(intTarjeta)
        {
            var obra = document.getElementById("hddObra").value;
            var result = window.showModalDialog("../Catalogos/PUTarjetaPopUP.aspx?page=1&intTarjeta="+intTarjeta + "&Obra="+obra,null,"dialogHeight:900px; dialogWidth:1000px;status:no;help:no;scroll:no;minimize:no;maximize:no;close:no;border:thin;");
        }
                
	</script>

</body>
</html>
