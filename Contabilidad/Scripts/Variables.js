
// JScript File

 var CSTKEYENTER=13;
    var CSTALLOWENTER=true;
    var CSTKEYTAB=9;
    var CSTKEYDEL=46;
    var CSTKEYCERO=48;
    var CSTKEYNUEVE=58;
    var CSTCOLORCLICK='#6699FC';	
    var CSTCOLOROVER='#6699FC';	
    var CSTALTERTABLECOLOR='#EBEADB';
    var CSTRHOSTNAME="http://"+window.location.hostname+":" + window.location.port + "/";
    var CSTRAPPNAME="Digitalizacion";
    var CSTRLOADIMAGE=CSTRHOSTNAME+CSTRAPPNAME+"/Imagenes/loader.gif";
    var CSTRLOADINGSTRING="<div  id='divLoading' style='LEFT:600px; POSITION:absolute; TOP:200px; z-index:auto; display:'';  width: 187px; height:128px; border='1'>"+
						  "<table width='200' border='1' cellpadding='0' cellspacing='0' bordercolor='#000000' bgcolor='#FFFFFF'><br>"+
                            "<tr>"+
                              "<td bgcolor='#FFFFFF'><br>"+
                              "<img src='"+CSTRLOADIMAGE+"' alt='Cargando' ><h7>Procesando...</h7><br><br>"+
                             " </td>"+
                           " </tr>"+
                         " </table>"+
						"</div>" ;