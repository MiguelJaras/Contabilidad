<%@ Page Language="C#" MasterPageFile="~/Pages/Contabilidad/Opciones/Base.master" AutoEventWireup="true" CodeFile="ListaNegra.aspx.cs" Inherits="Pages_Contabilidad_Opciones_ListaNegra" Title="Untitled Page" culture="es-mx" uiculture="es" %>
<%@ Register Assembly="Anthem" Namespace="Anthem" TagPrefix="anthem" %>

<asp:Content ID="Content1" ContentPlaceHolderID="CPHBase" Runat="Server">
     <h3>Importar Archivo Excel</h3>
    <br />
    <table style="" cellspacing="1" cellpadding="2">
        <tr>
            <td class="tLetra3">Archivo Excel </td> 
            <asp:FileUpload ID="fuArchivo" runat="server" CssClass="FileUpload" TabIndex="5"  data-parsley-required="false" accept=".xls,.xlsx" />
            <td><anthem:Button runat="server" CssClass="Button" ID="btnGuardar" Text="Guardar" OnClick="btnGuardar_Click" /></td>

        </tr>
        
        <tr>
            <td colspan="2">
                <div runat="server" id="lblTablas">
        
                </div>

            </td>
        </tr>
    </table>
    
    
</asp:Content>
