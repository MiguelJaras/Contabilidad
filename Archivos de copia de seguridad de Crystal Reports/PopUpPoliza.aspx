<%@ Page Language="C#" AutoEventWireup="true"  Debug="true" CodeFile="PopUpPoliza.aspx.cs" Inherits="Utils_PopUpPoliza" %>   
<%@ Register Assembly="Anthem" Namespace="Anthem" TagPrefix="anthem" %>
    
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Poliza</title>
    <link href ="../App_Themes/Plastic Blue/GridView/styles.css" rel="stylesheet" type="text/css" /> 
    <link href="../Style/StylesVetec.css" type="text/css" rel="stylesheet" />
    
    <style type="text/css">
        a:link { text-decoration: none; color: #0000CC; }
        a:hover { background: #EEEEEE; }
        a:active { background: #FFFFFF; }         
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <table width="100%" border="2" cellpadding="0" cellspacing="0" bordercolor="#bac1d7">
          <tr>
             <td style="height: 80px; width: 1320px;">
                <table width="100%" border="0" cellspacing="0" cellpadding="0">                                                                   
                    <tr>
                      <td valign="middle" width="100%">
                          <anthem:Panel id="pnlGrid" runat="server" Width="100%" Height="60px" BackImageUrl="../Img/mVertBack.gif">
                              <table width="100%" border="0" cellspacing="0" cellpadding="0">                                
                                <tr>
	                                <td style="height: 30px;color:#000066;font-family: Tahoma;font-size: 9pt;Height:20px; font-weight:bold;" Width="100px" align="right">
                                        EMPRESA&nbsp;
                                    </td>
                                    <td class="tLetra4" style="height: 30px;" Width="250px">
                                        <anthem:Label ID="lblEmpresa" runat="server" Font-Bold="true" ForeColor="#4156C5" Font-Size="9pt"></anthem:Label>
                                    </td>
                                    <td style="height: 30px;color:#000066;font-family: Tahoma;font-size: 9pt;Height:20px; font-weight:bold;" Width="100px" align="right">
                                        FECHA&nbsp;
                                    </td>
                                    <td class="tLetra4" style="height: 30px"  Width="200px">
                                        <anthem:Label ID="lblFecha" runat="server" Font-Bold="true" ForeColor="#4156C5" Font-Names="Tahoma" Font-Size="9pt"></anthem:Label>
                                    </td>
                                    <td Width="100px"></td>
                                </tr>
                                <tr background="../Img/fondo_down_long.jpg">
                                    <td style="height: 30px;color:#000066;font-family: Tahoma;font-size: 9pt;Height:20px; font-weight:bold;" Width="100px" align="right">
                                        POLIZA&nbsp;
                                    </td>
                                    <td class="tLetra4" style="height: 30px"  Width="250px">
                                        <anthem:Label ID="lblPoliza" runat="server" Font-Bold="true" ForeColor="#4156C5" Font-Names="Tahoma" Font-Size="9pt"></anthem:Label>
                                    </td>
                                    <td style="height: 30px;color:#000066;font-family: Tahoma;font-size: 9pt;Height:20px; font-weight:bold;" Width="100px" align="right">
                                        TIPO POLIZA&nbsp;
                                    </td>
                                    <td class="tLetra4" style="height: 30px"  Width="200px">
                                        <anthem:Label ID="lblTipoPoliza" runat="server" Font-Bold="true" ForeColor="#4156C5" Font-Names="Tahoma" Font-Size="9pt"></anthem:Label>
                                    </td>
                                    <td Width="100px">
                                    </td>
                                </tr>                                                                                                                                      
                             </table>                     
                         </anthem:Panel>
                        </td>
                    </tr>
               </table>
               <table width="100%" border="0" cellspacing="0" cellpadding="0">
                   <tr>
                        <td align="Left">
                            <div id="div-ListPanel3">
                             <anthem:GridView ID="grdDetalle" AutoGenerateColumns="false" runat="server" HeaderStyle-CssClass="dxgvHeader_PlasticBlue" 
                               CellPadding="0" CellSpacing="0" BorderColor="gray" BorderWidth="0" OnRowDataBound="row_Created" Width="99%">
                                  <Columns>                                                                                                                                        			    
			                          <asp:BoundField DataField="strCuenta" HeaderText="Cuenta" ItemStyle-HorizontalAlign="Left" ItemStyle-Width="70px">
			                          </asp:BoundField>	
			                          <asp:BoundField DataField="strNombre" HeaderText="Descripcion" ItemStyle-HorizontalAlign="Left" ItemStyle-Width="150px">
			                          </asp:BoundField>	
			                          <asp:BoundField DataField="strAuxiliar" HeaderText="Aux." ItemStyle-HorizontalAlign="Left" ItemStyle-Width="50px">
			                          </asp:BoundField>	
			                          <asp:BoundField DataField="strReferencia" HeaderText="Referencia" ItemStyle-HorizontalAlign="Left" ItemStyle-Width="70px">
			                          </asp:BoundField>	
			                          <asp:BoundField DataField="strObra" HeaderText="Obra" ItemStyle-HorizontalAlign="Center" ItemStyle-Width="50px">
			                          </asp:BoundField>	
			                          <asp:BoundField DataField="dblCargo" HeaderText="Cargos" ItemStyle-HorizontalAlign="Right" ItemStyle-Width="70px">
			                          </asp:BoundField>	 
			                          <asp:BoundField DataField="dblAbono" HeaderText="Abonos" ItemStyle-HorizontalAlign="Right" ItemStyle-Width="70px">
			                          </asp:BoundField>	
			                          <asp:BoundField DataField="strConcepto" HeaderText="Concepto" ItemStyle-HorizontalAlign="Left" ItemStyle-Width="300px">
			                          </asp:BoundField>	                       	                            
                                  </Columns>                                                                          
                              </anthem:GridView>
                              </div>            
                        </td>
                   </tr>
               </table>  
              </td>              
            </tr>
        </table>

</form>    
    <script type="text/javascript" language="javascript">
	
		window.onbeforeunload = function(e) 
		{
	        <%
                Response.Expires=0;
            %>
        };
                        
    </script>        
</body>
</html>
