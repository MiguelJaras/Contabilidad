<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="Base.master" CodeFile="GeneracionCR.aspx.cs" Inherits="Contabilidad_Compra_Opciones_GeneracionCR" culture="es-mx" uiculture="es" %>
<%@ Register Assembly="Anthem" Namespace="Anthem" TagPrefix="anthem" %>
<asp:Content ID="Content" ContentPlaceHolderID="CPHBase" Runat="Server">      	       
     <script type="text/javascript" language="javascript">
        var objUtils = new VetecUtils();      	
                				    
        var objUtils=new VetecUtils();
				
		function datosCompletos()
		{
            form_onSubmit();

            return true;
		}						                                                
        
        function OnlyNumber() 
        {
            var key = window.event.keyCode;
            
            if (key < 48 || key > 57) 
            {
               if(key == 46)
                window.event.keyCode = 46;
               else
                window.event.keyCode = 0;
            }
            else 
            {                                
               if (key == 13) 
               {
                  window.event.keyCode = 0;
               }
            }
        } 
        
        function Extencion(elem) 
        {
             var filePath = elem.value; 
 
 
            if(filePath.indexOf('.') == -1) 
                return false; 
         
 
            var validExtensions = new Array(); 
            var ext = filePath.substring(filePath.lastIndexOf('.') + 1).toLowerCase(); 
     
            validExtensions[0] = 'xls'; 
            validExtensions[1] = 'xlsx';     
 
            for(var i = 0; i < validExtensions.length; i++) 
            { 
                if(ext == validExtensions[i]) 
                {                    
                    //__doPostBack('Charge','');  
                    //form_onSubmit();
                    return true;
                }
            } 
 
            elem.value = "";

            alert('Seleccione un archivo Excel.'); 
            return false; 
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
            <td>
                &nbsp;
            </td>
        </tr>
        <tr>
            <td class="tLetra3">
                &nbsp; &nbsp;Empresa:
            </td>
            <td class="tLetra36">
                <anthem:TextBox ID="txtEmpresa" runat="server" AutoCallBack="true" BorderColor="Navy"
                    CssClass="String" OnTextChanged="txtEmpresa_TextChange" Width="80px"></anthem:TextBox>

                       <anthem:ImageButton runat="server" ID="ImageButton6" OnClientClick="var a = JBrowse('ctl00_CPHBase_txtEmpresa','ctl00_CPHBase_txtEmpresa,ctl00_CPHBase_txtNombreEmpresa','DACEmpresa','',1,ctl00_CPHBase_txtEmpresa.value,ctl00_CPHBase_hddSucursal.value,'8', true,'No hay información',function(){document.getElementById('ctl00_CPHBase_txtEmpresa').onchange(); },0); "
                    Height="18px" ImageUrl="../../../Img/ayuda.gif" Width="20" ImageAlign="AbsMiddle" />

                <anthem:TextBox ID="txtNombreEmpresa" runat="server" BorderColor="Navy"
                            CssClass="String" ReadOnly="true" Width="300px"></anthem:TextBox><anthem:HiddenField
                                ID="hddSucursal" runat="server" />
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
                &nbsp;&nbsp; Fecha:
            </td>
            <td class="tLetra36" style="height: 23px">
                <anthem:TextBox ID="txtFechaInicial" runat="server" CssClass="String" TabIndex="3" Width="80px"></anthem:TextBox>&nbsp;
                <anthem:ImageButton ID="ImgDate" runat="server"  ImageUrl="../../../Scripts/Calendar/Calendar.JPG" />  
                <anthem:HiddenField ID="hddClose" runat="server" />  
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
                &nbsp;&nbsp; Tipo Movimiento:
            </td>
             <td class="tLetra36">
                 <anthem:TextBox ID="txtTipoMovto" runat="server" AutoPostBack ="true" Style="font: 8pt Tahoma; color: black; 
                     text-align: left" TabIndex="2" Width="115px" OnTextChanged="txtTipoMovto_TextChanged"></anthem:TextBox>
             
                        <anthem:ImageButton runat="server" ID="ImageButton7" OnClientClick="var a = JBrowse('ctl00_CPHBase_txtTipoMovto','ctl00_CPHBase_txtTipoMovto','DACTipoMovimiento','',1,ctl00_CPHBase_txtEmpresa.value,ctl00_CPHBase_hddSucursal.value,'8', true,'No hay información',function(){document.getElementById('ctl00_CPHBase_txtTipoMovto').onchange(); },0); "
                     Height="18px" ImageUrl="../../../Img/ayuda.gif" Width="20" ImageAlign="AbsMiddle" />

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
                &nbsp;&nbsp; Concepto:</td>
            <td class="tLetra36" style="height: 23px">
                <anthem:TextBox ID="txtConcepto" runat="server" CssClass="String" TabIndex="2" Width="416px"></anthem:TextBox></td>
            <td class="tLetra3" style="height: 23px">
                </td>
            <td style="height: 23px">
            </td>
        </tr>
         <tr>
             <td class="tLetra3" style="height: 23px">
                 &nbsp;&nbsp; Orden Compra:</td>
             <td class="tLetra36" style="height: 23px">
                 <anthem:TextBox ID="txtOrden" runat="server" CssClass="String" TabIndex="2" Width="416px"></anthem:TextBox></td>
             <td class="tLetra3" style="height: 23px">
                 </td>
             <td style="height: 23px">
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
    </table>
    <br />
    <table width="100%">
        <tr>
            <td>
                <div id="div-ListPanel" style="left: 0px; width: 83%; top: -10px">
                    <anthem:GridView ID="DgrdList" runat="server" AllowSorting="True" AutoGenerateColumns="False"
                        CellPadding="0" CellSpacing="0" DataKeyNames="intContraRecibo" GridLines="None"
                        HeaderStyle-CssClass="dxgvHeader_PlasticBlue"
                        Width="100%">
                        <Columns>
                            <asp:BoundField DataField="Consecutivo" HeaderText="#">
                                <itemstyle width="50px" />
                            </asp:BoundField>
                            <asp:BoundField DataField="strFactura" HeaderText="Folio Factura">
                                <itemstyle width="100px" />
                            </asp:BoundField>
                            <asp:BoundField DataField="strFolioFiscal" HeaderText="Folio Fiscal">
                                <itemstyle width="230px" />
                            </asp:BoundField>
                            <asp:BoundField DataField="dblTotal" ItemStyle-HorizontalAlign="Right" HeaderText="Importe">
                                <itemstyle width="200px"  />
                            </asp:BoundField>
                            <asp:BoundField DataField="intContraRecibo" ItemStyle-HorizontalAlign="Center" HeaderText="Contra Recibo">
                                <itemstyle width="100px" />
                            </asp:BoundField>
                        </Columns>
                        <HeaderStyle CssClass="dxgvHeader_PlasticBlue" />
                    </anthem:GridView>
                </div>
            </td>
        </tr>
        <tr>
            <td>
                <table>
                    <tr>
                        <td style="width: 90px; height: 9px">
                            &nbsp;
                        </td>
                        <td style="width: 150px; height: 9px">
                            &nbsp;
                        </td>
                        <td style="width: 60px; height: 9px">
                            &nbsp;
                        </td>
                        <td style="width: 60px; height: 9px">
                            &nbsp;
                        </td>
                        <td align="center" style="width:200px; height: 15px">
                            <anthem:Label ID="lblTotal" runat="server" CssClass="tLetra3"></anthem:Label>
                        </td>
                        
                    </tr>
                </table>
            </td>
        </tr>
    </table>
    <script type="text/javascript" language="javascript">

        //form_onSubmit_Hidden();
    
    </script>
    
    </asp:Content>

   