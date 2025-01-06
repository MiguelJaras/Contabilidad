<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="Base.master" Debug="true" CodeFile="CargaNomina.aspx.cs" Inherits="Pages_Contabilidad_Opciones_CargaNomina" %>
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
   </table>                           
               
<script language="javascript" type="text/javascript">
    function Extencion(elem) {
        var filePath = elem.value;


        if (filePath.indexOf('.') == -1)
            return false;


        var validExtensions = new Array();
        var ext = filePath.substring(filePath.lastIndexOf('.') + 1).toLowerCase();

        validExtensions[0] = 'txt';
        validExtensions[1] = 'txt';

        for (var i = 0; i < validExtensions.length; i++) {
            if (ext == validExtensions[i]) {
                __doPostBack('Charge', '');
                form_onSubmit();
                return true;
            }
        }

        elem.value = "";

        alert('Seleccione un archivo Excel.');
        return false;
    }
</script>       
</asp:Content>


