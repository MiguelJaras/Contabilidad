<%@ Page Language="C#" AutoEventWireup="true" CodeFile="GridView.aspx.cs" Inherits="Administracion_Contabilidad_GridView" %>      
    
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>Datos</title>
    <link href="../App_Themes/Aqua/GridView/styles.css" rel="stylesheet" type="text/css" />
    <link href="../Style/Style.css" type="text/css" rel="stylesheet" />  
    <base target="_self" />   
</head>
<body>
    <form id="form1" runat="server">
        <table width="1100px" border="0" cellspacing="0" cellpadding="0">
            <tr>
                <td>
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">  
                        <tr>
                            <td align="center" style="width:100%">
                                <asp:Label ID="lblTitle" runat="server" CssClass="tdSubHead" ></asp:Label>
                            </td>  
                        </tr>
                        <tr>
                            <td align="center" style="width:100%">
                                <asp:Label ID="lblTitle2" runat="server" ></asp:Label>
                            </td>            
                        </tr>
                        <tr>
                            <td align="center" style="width:100%">
                                <asp:Label ID="lblTitle3" runat="server" ></asp:Label>
                            </td>            
                        </tr>
                        <tr>
                            <td align="center" style="width:100%">
                                  &nbsp;
                             </td>
                        </tr>
                    </table>
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                        <td align="center">
                            &nbsp;&nbsp;
                           <asp:Panel id="pan1" runat="server" Width="1180px" Height="590px" ScrollBars="Auto">                               
                               <asp:GridView runat="server" ID="grdDetalle" HeaderStyle-CssClass="dxgvHeader_Aqua3" CssClass="dxgvTable_Aqua"
                                    AutoGenerateColumns="false" ForeColor="Black" BorderWidth="0px" BorderColor="Silver" OnRowCreated="row_Created">
                               </asp:GridView>   
                          </asp:Panel>          
                        </td>
                    </tr>                   
                    </table>  
                </td>      
            </tr>            
       </table> 
       
 </form>       
  <script type="text/javascript" language="javascript" >
		window.onbeforeunload = function(e) 
		{
	        <%
                Response.Expires=0;
            %>
        };

    </script> 
</body>
</html>
