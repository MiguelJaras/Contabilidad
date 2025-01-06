<%@ Page Language="C#" AutoEventWireup="true" CodeFile="FinSesion.aspx.cs" Inherits="FinSesion" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Untitled Page</title>            
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <table id="tbl3" cellspacing="0" cellpadding="0" width="100%" border="0" runat="server">
        <tr style="height:60px">
            <td>
            
            </td>
        </tr>
        <tr>
            <td colspan="2" align="center">
                <img alt="" src="../Img/Warning.jpg" style="background-color: Transparent" />
            </td>
        </tr>        
	    <tr>
		    <td style="background: url(Imagenes/g1.png); width: 11px;">&nbsp;</td>
		    <td valign="baseline" align="center" style="background: url(Imagenes/g1.png);" width="98%"><br />                
                <br />
                <font face="Verdana" color="red" size="2"><b>LA SESIÓN HA CADUCADO</b></font>
                <br />
                <font face="Verdana" color="red" size="2"><b>FAVOR DE ENTRAR NUEVAMENTE</b></font>
                <br />
                <font face="Verdana" color="red" size="2"><b>DANDO CLICK <a href="javascript:top.window.location.href='Login.aspx';">AQUÍ</a></b></font>
                <br />
                <br />
		    </td>
		    <td style="background:url(Imagenes/g1.png); width: 14px;">&nbsp;</td>
	    </tr>	    
    </table>
    <p align="center"><strong><font face="Verdana" color="Silver" size="1">
        ©Todos los Derechos Reservados para Marfil Constructora S.A. de C.V.</font></strong>
    </p>
    <br />
    <br />
    <p align="center"><strong><font face="Verdana" color="Silver" size="2">
        Departamento Sistemas.</font></strong>
    </p>    
    </div>
    </form>
</body>
</html>

<script type="text/javascript" language="javascript">

    var fullQs = window.location.search.substring(1);   
    var qsParamsArray = fullQs.split('&');
    var id;
            
    id = qsParamsArray[0].replace("id=","");
    
    if(id == "0")
        top.window.location.href = "FinSesion.aspx?id=1";

</script>
