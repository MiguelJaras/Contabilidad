<%@ Control Language="C#" AutoEventWireup="true" CodeFile="ctrlPagger.ascx.cs" Inherits="ControlctrlPagger" %>

<%@ Register Assembly="Anthem" Namespace="Anthem" TagPrefix="anthem" %>


<div  class='paggerDiv' style=' border: solid 1px #EEEEEE'>
            <table class='paggerTbl' width='99%' border='0'>
            <tr>

            <td width='14%' style='text-align:left'>
           
                <anthem:Label runat="server" ID="TextCurrentPage" Text="Pagina:"></anthem:Label> 
                <anthem:Label runat="server" ID="lblPageIndex" Text="0"></anthem:Label>
                <anthem:Label runat="server" ID="TextTotalPages" Text="-"></anthem:Label>
                <anthem:Label runat="server" ID="lblTotalPages" Text="0"></anthem:Label>
            </td>
            <td width='24%' style='text-align:left'>
            <anthem:Label runat="server" ID="TextRecord" Text="Registro:"></anthem:Label> 
                <anthem:Label runat="server" ID="lblFromRecord" Text="0"></anthem:Label>
                <anthem:Label runat="server" ID="TextToRecord" Text="-"></anthem:Label>
                <anthem:Label runat="server" ID="lblToRecord" Text="0"></anthem:Label>
                <anthem:Label runat="server" ID="TextTotalRecords" Text="de"></anthem:Label>
                <anthem:Label runat="server" ID="lblTotalRecords" Text="0"></anthem:Label>
            
            </td>
            <td width='29%'>
            
                <table width='100%' border='0'>
                <tr>
                <td width='20%' style='text-align:left'>
                <anthem:ImageButton CommandArgument="first" ID="btnFirst" runat="server" ImageUrl="~/Img/pFirst.png" CausesValidation="false" OnClick="Image_Click" />              
                </td>
                <td width='20%'style='text-align:left'>
                <anthem:ImageButton  ID='btnPrevious' runat="server" OnClick="Image_Click" ImageUrl="~/img/pPrev.png" CommandArgument="previous" CausesValidation="false" /> 
                </td>

                <td width='10%' style='text-align:right'>
                <anthem:textbox ID='txtGoTo' runat="server" AutoPostBack="true" 
                        OnTextChanged="txtGoTo_TextChanged" Width="50px" /> 
                </td>
                <td width='10%' style='text-align:left'>
                
                <anthem:ImageButton CommandArgument="goto" OnClick="Image_Click" ID='btnGotTo' runat="server" ImageUrl="~/img/go.png" CausesValidation="false" /> 
                </td>
                <td width='20%' style='text-align:right'>
                <anthem:ImageButton  CommandArgument="next"  OnClick="Image_Click"  ID='btnNext' runat="server" ImageUrl="~/img/pNext.png" CausesValidation="false" /> 
                </td>
                <td width='20%' style='text-align:right'>
                <anthem:ImageButton  CommandArgument="last"  OnClick="Image_Click"  ID='btnLast' runat="server" ImageUrl="~/img/pLast.png" CausesValidation="false" /> 
                </td>
                </tr>
                </table>
            </td>
            <td width='35%' style='text-align:right'>
            <anthem:Label ID='TextRecordCount' runat="server" Text="Registros"></anthem:Label>
            <anthem:DropDownList AutoCallBack="true" OnSelectedIndexChanged="ddlRowSelectedIndexChanged"  CssClass="paggerDdl" runat="server" ID="ddlRecordCount">
            </anthem:DropDownList>
            </td>
            </tr>
            </table>
            </div>