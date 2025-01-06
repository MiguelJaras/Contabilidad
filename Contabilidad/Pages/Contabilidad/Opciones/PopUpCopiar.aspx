<%@ Page Language="C#" MasterPageFile="Base.master"  AutoEventWireup="true" CodeFile="PopUpCopiar.aspx.cs" Inherits="PopUpCopiar" Title="::: Copiar Poliza :::" Culture="Auto" UICulture="Auto" %>
<%@ Register Assembly="Anthem" Namespace="Anthem" TagPrefix="anthem" %>

<asp:Content ID="Content" ContentPlaceHolderID="CPHBase" Runat="Server" > 
	<table border="0" cellpadding="2" cellspacing="2" style="width: 600px;">
		<colgroup>			
			<col width="10%"/>
			<col width="30%"/>
			<col width="30%"/>
			<col width="30%"/>
		</colgroup>			    
        <tr>            
            <td align="right" class="tLetra3">
               <anthem:Label ID="lblApellido" runat="server" Text="Poliza">
               </anthem:Label>
    		</td>
    		<td colspan="2"> 
    		    <anthem:Label ID="lblPoliza" runat="server" Text="Poliza" CssClass="tLetra5" Font-Size="Medium">
               </anthem:Label>
    		</td>
	   		<td>
		        &nbsp;
		    </td>
		</tr>
		<tr>
            <td align="right" class="tLetra3" style="width: 4%">
               <anthem:Label ID="Label1" runat="server" Text="Fecha">
               </anthem:Label>
    		</td>
    		<td colspan="2" style="width: 16%"> 
    		    <anthem:TextBox ID="txtFechaInicial" runat="server" CssClass="String" AutoCallBack="true" TabIndex="6" Width="70px" OnTextChanged="txtFechaInicial_Change"></anthem:TextBox>&nbsp;
                <anthem:ImageButton ID="ImgDate" runat="server" ImageUrl="../../../Scripts/Calendar/Calendar.JPG" />    
    		</td>
	   		<td>
		        &nbsp;
		    </td>
		</tr>
		<tr>
            <td align="right" class="tLetra3">
               <anthem:Label ID="Label3" runat="server" Text="Referencia">
               </anthem:Label>
    		</td>
    		<td colspan="2">
    		    <anthem:TextBox ID="txtReferencia" runat="server" TabIndex="25" Width="120px" CssClass="String"></anthem:TextBox>
    		</td>
    		<td>
		        &nbsp;
		    </td>	   		
		</tr>
		<tr>
            <td align="right" class="tLetra3">
               <anthem:Label ID="Label2" runat="server" Text="Descripciòn">
               </anthem:Label>
    		</td>
    		<td colspan="3"> 
    		    <anthem:TextBox ID="txtDescripcion" runat="server" CssClass="String" Width="450px" STYLE="border-color:Navy;" Height="80px" TextMode="MultiLine"  ></anthem:TextBox>     		    
    		</td>	   		
		</tr>
		<tr>
		    <td>
		        &nbsp;		        
		    </td>
		</tr>
		<tr>
            <td colspan="4" align="center">
               <anthem:Button ID="btnSave" runat="server" CssClass="tdButton_Aqua" Text="Guardar" OnClick="btnSave_Click" Width="100px"/>                   
               &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
               <input id="btnClose" runat="server" class="tdButton_Aqua" type="button" value="Salir" onclick="window.close();" style="width:100px" />                                        
            </td>
         </tr>
	</table>
	</asp:Content>
		

    
