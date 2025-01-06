<%@ Page language="c#" AutoEventWireup="true" Inherits="Browse" CodeFile="Browse.aspx.cs" %>

<%@ Register Assembly="DevExpress.Web.ASPxGridView.v8.3, Version=8.3.4.0, Culture=neutral, PublicKeyToken=5377c8e3b72b4073"
    Namespace="DevExpress.Web.ASPxGridView" TagPrefix="dxwgv" %>
<%@ Register Assembly="DevExpress.Web.ASPxEditors.v8.3, Version=8.3.4.0, Culture=neutral, PublicKeyToken=5377c8e3b72b4073"
    Namespace="DevExpress.Web.ASPxEditors" TagPrefix="dxe" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>Ayuda</title>
		<base target="_self"/>
		<script type="text/javascript" language="javascript" src="../Scripts/Variables.js"></script>
        <script type="text/javascript" language="javascript" src="../Scripts/SimpleGrid.js"></script>
	</head>
	<body>
		<form id="frmAyuda" runat="server">
			<table cellspacing="1" cellpadding="1" width="100%" align="center" border="0">
				<tr>
					<td>
                        <dxwgv:aspxgridview id="ASPxGridViewAyuda" runat="server" CssFilePath="~/App_Themes/Aqua/{0}/styles.css"  OnHtmlRowPrepared="ASPxGridViewAyuda_HtmlRowPrepared" CssPostfix="Aqua" Width="100%" OnPageIndexChanged="gridView_PageIndexChanged" >
                            <Styles CssFilePath="~/App_Themes/Aqua/{0}/styles.css" CssPostfix="Aqua">
                            </Styles>
                            <SettingsLoadingPanel Text="" />
                            <Images ImageFolder="~/App_Themes/Aqua/{0}/">
                                <CollapsedButton Height="15px" Url="~/App_Themes/Aqua/GridView/gvCollapsedButton.png"
                                    Width="15px" />
                                <ExpandedButton Height="15px" Url="~/App_Themes/Aqua/GridView/gvExpandedButton.png"
                                    Width="15px" />
                                <DetailCollapsedButton Height="15px" Url="~/App_Themes/Aqua/GridView/gvDetailCollapsedButton.png"
                                    Width="15px" />
                                <DetailExpandedButton Height="15px" Url="~/App_Themes/Aqua/GridView/gvDetailExpandedButton.png"
                                    Width="15px" />
                                <HeaderFilter Height="19px" Url="~/App_Themes/Aqua/GridView/gvHeaderFilter.png" Width="19px" />
                                <HeaderActiveFilter Height="19px" Url="~/App_Themes/Aqua/GridView/gvHeaderFilterActive.png"
                                    Width="19px" />
                                <HeaderSortDown Height="5px" Url="~/App_Themes/Aqua/GridView/gvHeaderSortDown.png"
                                    Width="7px" />
                                <HeaderSortUp Height="5px" Url="~/App_Themes/Aqua/GridView/gvHeaderSortUp.png" Width="7px" />
                                <FilterRowButton Height="13px" Width="13px" />
                                <WindowResizer Height="13px" Url="~/App_Themes/Aqua/GridView/WindowResizer.png" Width="13px" />
                            </Images>
                            <SettingsPager PageSize="100" Position="TopAndBottom">
                                <AllButton>
                                    <Image Height="19px" Width="27px" />
                                </AllButton>
                                <FirstPageButton>
                                    <Image Height="19px" Width="23px" />
                                </FirstPageButton>
                                <LastPageButton>
                                    <Image Height="19px" Width="23px" />
                                </LastPageButton>
                                <NextPageButton>
                                    <Image Height="19px" Width="19px" />
                                </NextPageButton>
                                <PrevPageButton>
                                    <Image Height="19px" Width="19px" />
                                </PrevPageButton>
                            </SettingsPager>
                            <Settings ShowFilterRow="True"   />
                            <ImagesEditors>
                                <CalendarFastNavPrevYear Height="19px" Url="~/App_Themes/Aqua/Editors/edtCalendarFNPrevYear.png"
                                    Width="19px" />
                                <CalendarFastNavNextYear Height="19px" Url="~/App_Themes/Aqua/Editors/edtCalendarFNNextYear.png"
                                    Width="19px" />
                                <DropDownEditDropDown Height="7px" Url="~/App_Themes/Aqua/Editors/edtDropDown.png"
                                    UrlDisabled="~/App_Themes/Aqua/Editors/edtDropDownDisabled.png" UrlHottracked="~/App_Themes/Aqua/Editors/edtDropDownHottracked.png"
                                    Width="9px" />
                            </ImagesEditors>
                        </dxwgv:aspxgridview>
                    </td>
				</tr>
				<tr>
				    <td>
				        <asp:HiddenField ID="hddPage" runat="server" />
				    </td>
				</tr>
			</table>
		</form>
		<script language="javascript" type="text/javascript">
		
		    window.onbeforeunload = function(e) 
		    {
	            <%
                    Response.Expires=0;
                %>
            };
		
			if(document.getElementById("ASPxGridViewAyuda")!=null)
			{
				document.getElementById("ASPxGridViewAyuda").incluirDiv=0;
			}
			
			var objGrid=new VetecSimpleGrid("ASPxGridViewAyuda");
			
			if(objGrid.setEventClick!=null)
			{
				objGrid.setEventClick(whenClick);
		    }
				
			function whenClick(p_obj) {
			   var strResult="";			  			   
			    if(p_obj.id.indexOf("_DXDataRow")>0){
			    		       			    
			        for(var intCount=0; intCount<p_obj.cells.length; intCount++)
					    strResult+=p_obj.cells[intCount].innerHTML+"[--]";
					   
				    window.returnValue=strResult;
				    window.close();
				}
			}
			
			document.onkeydown=new Function("if(event.keyCode==27)window.close();");
						
			
		</script>
	</body>
</html>
