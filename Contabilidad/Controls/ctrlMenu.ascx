<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ctrlMenu.ascx.cs" Inherits="Controls_ctrlMenu" %>


<style  type="text/css">
        .DftHeader
        {
        	background-color: #CBCBCB;            
        	color:White;        	
        	font-family: Cooper Black, sans-serif;   
        	cursor:hand;     
 	        font-size: 8px;
 	        font-weight: lighter;
        }
        
        
        a:link { text-decoration: underline; color: #EE9A00;}
        a:hover { background: #EEEEEE; }
        a:active { background: #FFFFFF; } 
        
         
                                    
        .DftBackGroundStyle
        {
            font-family: Tahoma, Arial, Helvetica, sans-serif;
            font-size: 11px;
            color: White; 
            margin: 0, 0, 0, 0;
            padding: 0, 0, 0, 0;
            width: 220px;
        }
        
        .DftParentCssMouseOverLevel1
        {           
            font: 8pt Tahoma;
			font-weight:bold;
	        color: Navy;
	        background-color: Silver;
	        border: Solid 1px #A3C0E8;
	        padding: 6px 6px 6px 10px;
        	
	        background-image: url('nbGroupHeaderBack.gif');
	        background-repeat: repeat-x;
	        background-position: top;
        }
        
        .Parent
        {           
            font: 8pt Tahoma;
	        color: #FFFFFF;
	        background-color: Navy;
	        padding: 1px;
        }
        
         .Level1
        {           
            font: 8pt Tahoma;
	        color: White;
	        background-color: #6A5ACD;
	        padding: 1px;
        }
        
         .Level2
        {           
            font: 8pt Tahoma;
	        color: Navy;
	        background-color: #F0F8FF;
	        padding: 1px;
        }
        
         .Level3
        {           
            font: 8pt Tahoma;
	        color: Black;
	        background-color: #CDC1C5;
	        padding: 1px;
        }
        

          .Parent:hover
        {           
            font: 8pt Tahoma;
                    background: #EE9A00;
                    color: #FFFFFF;
                    padding: 1px;
        }

                .Level1:hover
        {           
                     font: 8pt Tahoma;
                    background: #EE9A00;
                    color: #FFFFFF;
                    padding: 1px;
        }
        
         .Level2:hover
        {           
                    font: 8pt Tahoma;
                    background: #EE9A00;
                    color: #FFFFFF;
                    padding: 1px;
        }
        
         .Level3:hover
        {           
                    font: 8pt Tahoma;
                    background: #EE9A00;
                    color: #FFFFFF;
                    padding: 1px;
        }
        
        
        .DftChildCssMouseOverLevel1
        {           	
            font-weight: lighter;        
            background-color: #EEEEEE;            
            color: #FFFFFF;	
        }                
        
        .DftChildCssMouseOutLevel1
        {
            background-color: #EEEEEE;            
            color: Navy;
         }
        
        .DftChildCssMouseClickedLevel1
        {            
            font-weight: bold;                    
        }       
         
         .DftParentCssMouseOverLevel2
        {           	
            background-color: Red;            
            color: White;	
			text-decoration:underline;
        }
        
        .DftChildCssMouseOverLevel2
        {           	
            font: 8pt Tahoma;               	    
            background-color: #EEEEEE;            
            color: Navy;	
			text-decoration:underline;
        }                
        
        .DftChildCssMouseOutLevel2
        {            
            font: 8pt Tahoma;
	        color: #646C79;
	        border: Solid 1px #EEEEEE;
	        background-color: #F3F2F2;
	        padding: 0px; 
         }
         
         .DftChildCssMouseClickedLevel2
        {            
            color: Black;
        } 
         
         
         .DftChildCssMouseOverLevel3
        {           	
            font-weight: lighter;        
            background-color: #EEEEEE;            
            color: white;	
			border-bottom:#000033;
        }                
        
        .DftChildCssMouseOutLevel3
        {            
            font-weight: lighter;
            background-color: #F0F0F0;            
            color: Navy;
         }
         
         .DftChildCssMouseClickedLevel3
        {            
            font-weight: bold;            
        } 
                           
    </style>
    <script type="text/javascript" >


        var DivLevel1 = null;
        var DivLevel2 = null;
        var DivLevel3 = null;

        function OpenGrupo(intGrupo) {
            var url = "GrupoTarea.aspx?intGrupo=" + intGrupo;
            window.open(url, "", "height=210px width=420px resizable scrollbars");

            //var a = window.showModalDialog(url, "", "dialogHeight:210px;dialogWidth:420px;toolbar=no,status=no,scroll=no'");
            //if(a != undefined )
            //    __doPostBack('lknSave',intGrupo);
        }

        function OpenUpdateGrupo(intGrupo) {
            var url = "GrupoTarea.aspx?intGrupo=0&Id=" + intGrupo;
            window.open(url, "", "height=210px width=420px resizable scrollbars");

            //var a = window.showModalDialog(url, "", "dialogHeight:210px;dialogWidth:420px;toolbar=no,status=no,scroll=no'");
            //if(a != undefined )
            //    __doPostBack('lknSave',a);
        }

        function Redirect(url, col, Numlevel, TitleName) {
            MenuOptionClicked(col.firstChild, Numlevel);

            if (url == '') {
                alert('Configurar url a opción.');
            }
            else {
                document.getElementById('iGroup').src = url;
            }
        }

        function DisplayMenuOption(objectId) {

            var Table = document.getElementById(objectId);
            Table.style.display = (Table.style.display == 'none' ? 'block' : 'none');
        }

        function MenuOptionClicked(div, Numlevel) {

            if (DivLevel1 != null) DivLevel1.className = '';
            if (DivLevel2 != null) DivLevel2.className = '';
            if (DivLevel3 != null) DivLevel3.className = '';

            if (Numlevel == 1) {
                DivLevel1 = div;
                DivLevel1.className = '<%= this.ChildCssMouseClickedLevel1 %>';
                //document.getElementById("ctrlMenu_RptMenuOptions_ctl01_RptSubMenuOptionsLevel1_ctl00_img").src="ImgMenu/FolderOpenBlue.GIF"; 
            }
            if (Numlevel == 2) {
                DivLevel2 = div;
                DivLevel2.className = '<%= this.ChildCssMouseClickedLevel2 %>';
            }
            if (Numlevel == 3) {
                DivLevel3 = div;
                DivLevel3.className = '<%= this.ChildCssMouseClickedLevel3 %>';
            }
        }

        var DefaultCols = '';
        function menu_onclick(Header) {
            var framesetCols = top.document.getElementById('Columns');
            Header.style.display = 'none';

            var ContextMenu = document.getElementById('ContextMenu');
            if (DefaultCols == '') {
                DefaultCols = framesetCols.cols;
            }
            if (framesetCols.cols == '230,*') {
                framesetCols.cols = DefaultCols;
                document.getElementById('VerTabMenu').style.display = 'block';
                ContextMenu.style.display = 'none';
            }
            else {
                framesetCols.cols = '230,*';
                document.getElementById('HorTabMenu').style.display = 'block';
                ContextMenu.style.display = 'block';
            }
        }

    </script>
     
<div   id="ContextMenu">
  <asp:Repeater ID="RptMenuOptions" runat="server" OnItemDataBound="RptMenuOptions_OnItemDataBound">            
     <HeaderTemplate>
        <table id="tbMainMenu" border='0'  cellpadding="0" cellspacing="0" width="225px" >
           <tbody>                    
            </HeaderTemplate>                            
                <ItemTemplate>                     
                  <tr style='margin-left: 0px; height: 18px'>
                    <td id= '<%# Eval("intMenu") %>' align="left" style="cursor:hand;width: 225px" class="Parent" onclick='<%# this.ResolveAction(Container.DataItem,1) %>' >
                        <div style="margin-left: 5px; margin-right:0px" >                            
                            <asp:HiddenField ID="hddDireccion" runat="server" Value='<%# Eval("intMenu") %>' />
                            &nbsp;
                            <%# Eval("strNombre")%>
                        </div>                                             
                    </td>                
                  </tr>
                  <tr>
                    <td align='right'>  
                        <table border='0' width='225px' id='<%# "Table_" + Eval("intMenu").ToString() %>' style="margin-top: 1px; margin-bottom: 1px;display:none" cellpadding="0" cellspacing="0"> 
                            <tbody>
                            <asp:Repeater ID="RptSubMenuOptionsLevel1" runat="server" OnItemDataBound="RptMenuOptions2_OnItemDataBound">                                      
                                <ItemTemplate>                     
                                     <tr style='margin-left: 0px; height: 18px'>
                                         <td id= '<%# Eval("intMenu") %>' align="left" style="cursor:hand;width: 225px" class="Level1" onclick='<%# this.ResolveAction(Container.DataItem,1) %>' ondblclick="OpenUpdateGrupo('<%# Eval("intMenu") %>');" >
                                             <div style="margin-left: 5px; margin-right:0px" >
                                                 &nbsp;&nbsp;                                                
                                                  <%# Eval("strNombre")%>                                                  
                                              </div>                                             
                                           </td>                
                                       </tr>
                                       <tr>
                                           <td align='right'>  
                                              <table border='0' width='225px' id='<%# "Table_" + Eval("intMenu").ToString() %>' style="margin-top: 1px; margin-bottom: 1px;display:none" cellpadding="0" cellspacing="0"> 
                                                 <tbody>
                                                       <asp:Repeater ID="RptSubMenuOptionsLevel2" runat="server" OnItemDataBound="RptMenuOptions3_OnItemDataBound">                                      
                                                        <ItemTemplate>                     
                                                             <tr style='margin-left: 0px; height: 18px'>
                                                                 <td id= '<%# Eval("intMenu") %>' align="left" style="cursor:hand;width: 225px" class="Level2" onclick='<%# this.ResolveAction(Container.DataItem,1) %>' ondblclick="OpenUpdateGrupo('<%# Eval("intMenu") %>');" >
                                                                     <div style="margin-left: 5px; margin-right:0px" >
                                                                         &nbsp;&nbsp;                                                
                                                                          <%# Eval("strNombre")%>                                                  
                                                                      </div>                                             
                                                                   </td>                
                                                               </tr>
                                                               <tr>
                                                                   <td align='right'>  
                                                                      <table border='0' width='225px' id='<%# "Table_" + Eval("intMenu").ToString() %>' style="margin-top: 1px; margin-bottom: 1px;display:none" cellpadding="0" cellspacing="0"> 
                                                                         <tbody>
                                                                               <asp:Repeater ID="RptSubMenuOptionsLevel3" runat="server" OnItemDataBound="RptMenuOptions4_OnItemDataBound">                                      
                                                                                <ItemTemplate>                     
                                                                                     <tr style='margin-left: 0px; height: 18px'>
                                                                                         <td id= '<%# Eval("intMenu") %>' align="left" style="cursor:hand;width: 225px" class="Level3" onclick='<%# this.ResolveAction(Container.DataItem,1) %>' ondblclick="OpenUpdateGrupo('<%# Eval("intMenu") %>');" >
                                                                                             <div style="margin-left: 5px; margin-right:0px" >
                                                                                                 &nbsp;&nbsp;                                                
                                                                                                  <%# Eval("strNombre")%>                                                  
                                                                                              </div>                                             
                                                                                           </td>                
                                                                                       </tr>
                                                                                       <tr>
                                                                                           <td align='right'>  
                                                                                              <table border='0' width='225px' id='<%# "Table_" + Eval("intMenu").ToString() %>' style="margin-top: 1px; margin-bottom: 1px;display:none" cellpadding="0" cellspacing="0"> 
                                                                                                 <tbody>
                                                                                                       <asp:Repeater ID="RptSubMenuOptionsLevel4" runat="server">            
                                                                                                           <ItemTemplate>                    
                                                                                                             <tr style="margin-left: 10px; margin-left: 0px; height: 18px">
                                                                                                                 <td id= '<%# Eval("intMenu") %>' style="cursor:hand;width: 225px" align="left" class='<%# Style_CssClass_Level2(Container.DataItem)  %>'  onclick="<%# this.ResolveAction(Container.DataItem,3) %>" >
                                                                                                                   <div style="margin-left: 5px; margin-right:0px">                                                                      
                                                                                                                      &nbsp;&nbsp;
                                                                                                                      <%# Eval("strNombre")%>
                                                                                                                    </div>                                            
                                                                                                                 </td>                                
                                                                                                              </tr>                                                                                                                                                 
                                                                                                          </ItemTemplate>
                                                                                                       </asp:Repeater>  
                                                                                                  </tbody>
                                                                                              </table>
                                                                                           </td>
                                                                                      </tr>
                                                                                </ItemTemplate>
                                                                            </asp:Repeater>  
                                                                          </tbody>
                                                                      </table>
                                                                   </td>
                                                              </tr>
                                                        </ItemTemplate>
                                                    </asp:Repeater>  
                                                  </tbody>
                                              </table>
                                           </td>
                                      </tr>
                                </ItemTemplate>
                            </asp:Repeater>  
                            </tbody>
                        </table>
                    </td>
                  </tr>
                </ItemTemplate>
            <FooterTemplate>
                    </tbody>
                </table>
            </FooterTemplate>
        </asp:Repeater>        
    </div>

<asp:LinkButton id="lknSave" runat="server"> </asp:LinkButton>
<asp:HiddenField ID="hdnDefaultMenuOption" runat="server" />
    
