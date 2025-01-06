<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="Base.master" CodeFile="ER.aspx.cs" Inherits="Contabilidad_Compra_Opciones_ER" Culture="auto" UICulture="auto" %>
<%@ Register Assembly="Anthem" Namespace="Anthem" TagPrefix="anthem" %>

<asp:Content ID="Content" ContentPlaceHolderID="CPHBase" Runat="Server">      
	  <table width="100%" border="0" cellspacing="0" cellpadding="0" style="border-color:Silver; border-width:1px;">                       
        <tr>
            <td>
                &nbsp;
                <anthem:TextBox ID="txtRowEdit" runat="server" AutoCallBack="true" style="display:none;"  ></anthem:TextBox>&nbsp;
                <anthem:TextBox ID="txtEmpleadoInt" runat="server" AutoCallBack="true" Style="display: none"></anthem:TextBox>
            </td>
         </tr>     
      </table>
         <script type="text/javascript" language="javascript">
            var objUtils = new VetecUtils();      	
                				    
            function datosCompletos()
            {		       
	            return objUtils.validaItems("ctl00_CPHBase_txtEmpresa,ctl00_CPHBase_cboYear,ctl00_CPHBase_cboMonth");
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
            <td class="tLetra3">
                &nbsp; &nbsp;Empresa:
            </td>
            <td class="tLetra36">
                <anthem:DropDownList ID="cboEmpresa" runat="server" CssClass="String"
                    TabIndex="1" Width="350px">
                </anthem:DropDownList>&nbsp;
            </td>
            <td class="tLetra3">
                &nbsp;
            </td>
            <td>
                &nbsp;
            </td>
        </tr>
        <tr>
            <td class="tLetra3" style="height: 23px">
                &nbsp;&nbsp; Ejercicio:
            </td>
            <td class="tLetra36" style="height: 23px">
                <anthem:DropDownList ID="cboYear" runat="server" CssClass="String"
                    TabIndex="1" Width="120px">
                </anthem:DropDownList>&nbsp;
            </td>
            <td class="tLetra3" style="height: 23px">
                &nbsp;
            </td>
            <td style="height: 23px">
                &nbsp;
            </td>
        </tr>
        <tr>
            <td class="tLetra3" style="height: 23px">
                &nbsp;&nbsp; Mes:</td>
            <td class="tLetra36" style="height: 23px">
                <anthem:DropDownList ID="cboMonth" runat="server" CssClass="String" TabIndex="2" Width="120px" >
                </anthem:DropDownList></td>
            <td class="tLetra3" style="height: 23px">
            </td>
            <td style="height: 23px">
            </td>
        </tr>
        <tr>
            <td class="tLetra3" style="height: 23px">
                </td>
            <td class="tLetra36" style="height: 23px">
                </td>
            <td class="tLetra3" style="height: 23px">
            </td>
            <td style="height: 23px">
            </td>
        </tr>
    </table>               
    </asp:Content>

   