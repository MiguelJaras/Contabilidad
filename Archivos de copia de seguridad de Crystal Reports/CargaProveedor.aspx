<%@ Page Language="C#" MasterPageFile="~/Pages/Contabilidad/Opciones/Base.master" AutoEventWireup="true" CodeFile="CargaProveedor.aspx.cs" Inherits="Pages_Contabilidad_Opciones_CargaProveedor" Title="Untitled Page" %>
<%@ Register Assembly="Anthem" Namespace="Anthem" TagPrefix="anthem" %>

<asp:Content ID="Content1" ContentPlaceHolderID="CPHBase" Runat="Server">
     <h3>Importar Archivos</h3>
    <br />
    <table style="" cellspacing="1" cellpadding="2">
        <tr>
            <td class="tLetra3">Archivo</td>
            <asp:FileUpload ID="fuArchivo" runat="server" CssClass="FileUpload" TabIndex="5" />
            <td><anthem:Button runat="server" CssClass="Button" ID="btnImportar" Text="Importar" OnClick="btnImportar_Click" /></td>
        </tr>
        
        <tr>
            <td colspan="2">
                <div runat="server" id="lblTablas">
        
                </div>

            </td>
        </tr>
    </table>
    
    
</asp:Content>
