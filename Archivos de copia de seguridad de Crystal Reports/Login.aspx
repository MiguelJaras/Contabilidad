<%@ Page Language="c#" Inherits="Login" CodeFile="Login.aspx.cs" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<%@ Register Assembly="Anthem" Namespace="Anthem" TagPrefix="anthem" %> 

<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
	    <script type="text/javascript" language="javascript" src="../Scripts/VetecUtils.js"></script>  
	    <script type="text/javascript" language="javascript" src="../Scripts/VetecText.js"></script>  	
		<title>Marfil</title>
		<meta content="Microsoft Visual Studio .NET 7.1" name="GENERATOR" />
		<meta content="Visual Basic .NET 7.1" name="CODE_LANGUAGE" />
		<meta content="JavaScript" name="vs_defaultClientScript" />
		<meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema" />
		<link rel="shortcut icon" href="../Img/marfil.ico" />
		<link href="../Style/Style.css" type="text/css" rel="stylesheet" />
		<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />		
		
		<script type="text/javascript">

		    var BrowserDetect = {
	        init: function () {
		        this.browser = this.searchString(this.dataBrowser) || "Navegador no Identificado";
		        this.version = this.searchVersion(navigator.userAgent)
			        || this.searchVersion(navigator.appVersion)
			        || ".";
		        this.OS = this.searchString(this.dataOS) || "SO no identificado";
	        },
	        searchString: function (data) {
		        for (var i=0;i<data.length;i++)	{
			        var dataString = data[i].string;
			        var dataProp = data[i].prop;
			        this.versionSearchString = data[i].versionSearch || data[i].identity;
			        if (dataString) {
				        if (dataString.indexOf(data[i].subString) != -1)
					        return data[i].identity;
			        }
			        else if (dataProp)
				        return data[i].identity;
		        }
	        },
	        searchVersion: function (dataString) {
		        var index = dataString.indexOf(this.versionSearchString);
		        if (index == -1) return;
		        return parseFloat(dataString.substring(index+this.versionSearchString.length+1));
	        },
	        dataBrowser: [
		        {
			        string: navigator.userAgent,
			        subString: "Chrome",
			        identity: "Google Chrome"
		        },
		        { 	string: navigator.userAgent,
			        subString: "OmniWeb",
			        versionSearch: "OmniWeb/",
			        identity: "OmniWeb"
		        },
		        {
			        string: navigator.vendor,
			        subString: "Apple",
			        identity: "Safari",
			        versionSearch: "Version"
		        },
		        {
			        prop: window.opera,
			        identity: "Opera",
			        versionSearch: "Version"
		        },
		        {
			        string: navigator.vendor,
			        subString: "iCab",
			        identity: "iCab"
		        },
		        {
			        string: navigator.vendor,
			        subString: "KDE",
			        identity: "Konqueror"
		        },
		        {
			        string: navigator.userAgent,
			        subString: "Firefox",
			        identity: "Firefox"
		        },
		        {
			        string: navigator.vendor,
			        subString: "Camino",
			        identity: "Camino"
		        },
		        {		// for newer Netscapes (6+)
			        string: navigator.userAgent,
			        subString: "Netscape",
			        identity: "Netscape"
		        },
		        {
			        string: navigator.userAgent,
			        subString: "MSIE",
			        identity: "Internet Explorer",
			        versionSearch: "MSIE"
		        },
		        {
			        string: navigator.userAgent,
			        subString: "Gecko",
			        identity: "Mozilla",
			        versionSearch: "rv"
		        },
		        { 		// for older Netscapes (4-)
			        string: navigator.userAgent,
			        subString: "Mozilla",
			        identity: "Netscape",
			        versionSearch: "Mozilla"
		        }
	        ],
	        dataOS : [
		        {
			        string: navigator.platform,
			        subString: "Win",
			        identity: "Windows"
		        },
		        {
			        string: navigator.platform,
			        subString: "Mac",
			        identity: "Mac"
		        },
		        {
			           string: navigator.userAgent,
			           subString: "iPhone",
			           identity: "iPhone/iPod"
	            },
		        {
			        string: navigator.platform,
			        subString: "Linux",
			        identity: "Linux"
		        }
	        ]
         
        };
        BrowserDetect.init();

		</script>
				
	</head>
	<body>
		<table width="100%">
			<tr>
				<td align="center" valign="middle">
   
				    <table width="649" border="0" cellpadding="0" cellspacing="0" background="../Img/login_tauro.png">
						<tr>          
							<td>
							    <table width="649" border="0" cellpadding="0" cellspacing="0" >
									<tr>
										<td width="117" height="172">&nbsp;</td>
										<td width="397">&nbsp;</td>
										<td width="135">&nbsp;</td>
									</tr>
									<tr>
										<td height="180">&nbsp;</td>
										<td>
										    <form id="frm" method="post" runat="server">
												<table width="350" border="0" align="center" cellpadding="0" cellspacing="0">
													<tr>
														<td>														    
															<table width="350" border="0" cellspacing="0" cellpadding="0">
															    <tr>
															        <td>
															            &nbsp;
															        </td>															    
															    </tr>
															    <tr>
															        <td>
															            &nbsp;
															        </td>															    
															    </tr>
															    <tr>
															        <td>
															            &nbsp;
															        </td>															    
															    </tr>
															    <tr>
															        <td>
															            &nbsp;
															        </td>															    
															    </tr>															    
																<tr>
																	<td style="WIDTH: 222px; height: 24px;" valign="middle">
																		<div align="right" class="style1" style="FONT-SIZE: 12px; COLOR: Black">Empresa&nbsp;&nbsp;</div>
																	</td>
																	<td width="155" align="right">
																		<Anthem:DropDownList ID="cboEmpresa" runat="server" Width="209px" CssClass="tDatos250" AutoCallBack="true" OnSelectedIndexChanged="cboEmpresa_Change"></Anthem:DropDownList>
																	</td>
																</tr>
																<tr>
																	<td style="WIDTH: 222px; height: 24px;" valign="middle">
																	    <div align="right" class="style1" style="FONT-SIZE: 12px; COLOR: Black">Usuario&nbsp;&nbsp;</div>
																	</td>
																	<td style="height: 24px"><span class="tLetra">
																	        <asp:TextBox ID="txtUsuario" runat="server" CssClass="cla_TablaDato" Width="209px"></asp:TextBox>
																		</span>
																	</td>
																</tr>
																<tr>
																	<td style="WIDTH: 222px" valign="middle"><div align="right" class="style1" style="FONT-SIZE: 12px; COLOR: Black">Contraseña&nbsp;&nbsp;</div>
																	</td>
																	<td><span class="tLetra">
																		    <asp:TextBox ID="txtContrasena" runat="server" CssClass="cla_TablaDato" Width="209px" TextMode="Password"></asp:TextBox>
																		</span>
																	</td>
																</tr>
																<tr>
																	<td style="WIDTH: 222px">&nbsp;</td>
																	<td><span class="cla_TablaRenglon">
																				<asp:Button ID="btnAceptar" runat="server" CssClass="cla_Boton" Text="Aceptar" onclick="btnAceptar_Click"></asp:Button>
																				<input name="button" type="button" class="cla_Boton" id="btnCancelar" onclick="Cancelar()"
																					value="Cancelar" />
																			    <anthem:HiddenField ID="hddSucursal" runat="server" />
																		</span>
																	</td>
																</tr>
																<tr>
															        <td>
															            &nbsp;
															        </td>															    
															    </tr>
															    <tr>
															        <td>
															            &nbsp;
															        </td>															    
															    </tr>
															</table>
														</td>
													</tr>
												</table>
											</form>
										</td>
										<td>&nbsp;</td>
									</tr>
									<tr>
										<td>&nbsp;</td>
										<td>&nbsp;</td>
										<td>&nbsp;</td>
									</tr>
								</table>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	</body>
	
	<script type="text/javascript">
		
//    if(BrowserDetect.browser != "Internet Explorer")
//    {   
//       document.getElementById("txtUsuario").setAttribute('disabled', true);    
//       document.getElementById("txtContrasena").setAttribute('disabled', true);  
//       document.getElementById("btnAceptar").setAttribute('disabled', true);  
//       document.getElementById("btnCancelar").setAttribute('disabled', true);  
//       document.write('<p class="accent"><font face="verdana" size="2">Estas utilizando : ' + BrowserDetect.browser + ' ' + BrowserDetect.version + ' sobre ' + BrowserDetect.OS + '!</font></p>'); 
//       document.write('<br><p class="accent"><font face="verdana" size="5" color="red">Estimado Usuario, les recordamos que este sistema esta diseñado para operarse con Internet Explorer. El uso de otros navegadores como Mozilla, Firefox, Safari, etc.; pueden provocar que las pantallas no se muestren adecuadamente.</font></p>');       
//    }
    // -->
    </script>
	
</html>


