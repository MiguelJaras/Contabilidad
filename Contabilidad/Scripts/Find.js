/*
	Clase: VetecText
	Elabora: JCGZ
	Fecha: 28 Feb 08	
	
	Params: p_strClave: Clave del control llave
			p_strTexts: Listado de controles separados por comas a llenar a partir de la ayuda			
			p_strBO: Objeto de negocio que provee la informacin
			p_strParam: Parametros para filtrar la ayuda
			p_intVersion: Version a utilzar de ayuda
			p_intVersion2: Version a utilzar de b�squeda
			p_strTipo: Tipo de Validacion
			p_intLength: Longitud Max Camp
			p_blRequerido: Indica si debe existir el valor escrito en clave
*/

function MuestraPantalla(strBO, strParams, intVersion, strCampoBusqueda)
{   
		var arrParams=strParams.split("[--]");
		strParams="";
		if(strCampoBusqueda==null)
		    strCampoBusqueda="strNombre";
		strCampoBusqueda=strCampoBusqueda.replace('+','[MAS]');
		for(var i=0; i<arrParams.length; i++){
			strParams+="&parametro"+i+"="+arrParams[i];
		}
		var CSTRHOSTNAME="http://"+window.location.hostname+"/";
        var CSTRDIRAYUDA=CSTRHOSTNAME+"/VetecMarfil/VetecMarfilUI/Utilerias/Ayuda.aspx"
		var strResult=window.showModalDialog(CSTRDIRAYUDA+"?classname="+strBO+strParams+"&version="+intVersion+"&parametros="+i+"&buscarpor="+strCampoBusqueda,'','dialogHeight:400px;resizable:yes;scroll:yes;');
		return strResult;
}

function Find(p_strClave,p_strTexts, p_strBO, p_strParam, p_intVersion, p_intVersion2,  p_strTipo, p_intLength, p_blRequerido, p_strMsg){	
    alert(p_strClave);

	var _objClave=document.getElementById(p_strClave);
	var _strBO=p_strBO;
	var _p_blRequerido=p_blRequerido;
	var _strParam=p_strParam;	
	var _intVersion=p_intVersion;
	var _intVersion2=p_intVersion2;
	var _strMsg=p_strMsg;
	var _functionReady;
	var arrControles=p_strTexts.split(",");
		
	//La b�squeda de  la ayuda solo manda un parametro a la vez, pero esta preparada para enviar varios parametros
//	this.abrirAyuda=function(){
		var _strTemp="";
		var arrControlesParam=_strParam.split(",");
		for (var i=0; i<arrControlesParam.length; i++){
		    try{
			    if(document.getElementById(arrControlesParam[i])!=null){
			        if(document.getElementById(arrControlesParam[i]).type=="select-one")
			            if(document.getElementById(arrControlesParam[i]).value=="")
			                _strTemp=_strTemp+"[--]0";
			            else
			                _strTemp=_strTemp+"[--]"+document.getElementById(arrControlesParam[i]).value;
			        else
				        _strTemp=_strTemp+"[--]"+document.getElementById(arrControlesParam[i]).value;
				}
			    else 
				    _strTemp=_strTemp+"[--]"+arrControlesParam[i];
		    }
		    catch(ex){
		        _strTemp=_strTemp+"[--]0";
		    }
	    }

		_strTemp=_strTemp.substring(4,100);
		var result=MuestraPantalla(_strBO,_strTemp,_intVersion);
		if(result==null)return;		
		_objClave.value=result.split("[--]")[0];
		for (var i=0; i<arrControles.length; i++)
		{
			if(document.getElementById(arrControles[i])!=null)
			{
			    if(document.getElementById(arrControles[i]).name == 'hddOperation')
			        document.getElementById(arrControles[i]).value = "2";
			    else
			       if(document.getElementById(arrControles[i]).type == "checkbox")
			           document.getElementById(arrControles[i]).checked = (result.split("[--]")[i] == "1" ? true : false);
			       else
			       {
			           if(document.getElementById(arrControles[i]).name == 'cboUnidadInsumo')
			           {
			              if(document.getElementById(arrControles[1]).value != "0")
			               {
			                  document.getElementById(arrControles[i]).style.backgroundColor="Silver"; 
			                  document.getElementById(arrControles[i]).style.Color="#000066";
			                  document.getElementById(arrControles[i]).style.textalign="right";
			               } 
			               else
			               {
			                  document.getElementById(arrControles[i]).style.backgroundColor="white"; 
			                  document.getElementById(arrControles[i]).style.Color="black";
			                  document.getElementById(arrControles[i]).style.textalign="right";
			               }
			           }
			           if(document.getElementById(arrControles[i]).name == 'txtPrecioInsumo')
			           {
			               if(document.getElementById(arrControles[1]).value != "0")
			               {
			                  document.getElementById(arrControles[i]).style.backgroundColor="Silver"; 
			                  document.getElementById(arrControles[i]).style.Color="#000066";
			                  document.getElementById(arrControles[i]).style.textalign="right";
			               }
			               else
			               {
			                  document.getElementById(arrControles[i]).style.backgroundColor="white"; 
			                  document.getElementById(arrControles[i]).style.Color="black";
			                  document.getElementById(arrControles[i]).style.textalign="right";
			               }  //document.getElementById(arrControles[i]).disabled=true;
			           }

				       document.getElementById(arrControles[i]).value=(result.split("[--]")[i] == '&nbsp;' ? '' : result.split("[--]")[i]);
				   }       
			}	

//	        var Type = document.getElementById(arrControles[i]).type;
//            alert(Type);
		}
		return 	result;	
	}

	//La b�squeda de descripci�n solo sirve para buscar por la clave del control. 	
//	function __buscarDescripcion(){
//		if(_objClave.value.trim()==""){
//			for (var i=0; i<arrControles.length; i++)
//				document.getElementById(arrControles[i]).value="";
//			if (_functionReady!=null){
//				_functionReady();
//			}
//			return;
//		}
//		var arrControlesParam=_strParam.split(",");
//		var _strTemp="";
//		for (var i=0; i<arrControlesParam.length; i++){
//			if(document.getElementById(arrControlesParam[i])!=null)
//				_strTemp=_strTemp+","+document.getElementById(arrControlesParam[i]).value;
//			else 
//				_strTemp=_strTemp+","+arrControlesParam[i];
//	    }
//	    _strTemp=_strTemp.substring(1,100);
//		var objDP=new VetecDataProvider();
//		objDP.setParams("p_strBO,p_intVersion,p_strParams");
//		objDP.setValues(_strBO+"[--]"+_intVersion2+"[--]"+_strTemp);
//		
//		objDP.setFunctionReady(__buscarDescripcion_Listo);
//		objDP.call("VetecWS","Query");
//	}
//	
//	function __buscarDescripcion_Listo(status, statusText, responseText, responseXML){
//		try{
//		    
//			var _strValorParam = document.getElementById(p_strClave).value;
//			if(responseXML.text==""){
//				if(p_blRequerido){
//					document.getElementById(p_strClave).value="";
//					if(_strMsg==null)
//					    alert("No existe la clave " + _strValorParam);
//					else
//					    alert(_strMsg);
//				}
//				for (var i=0; i<arrControles.length; i++)
//					document.getElementById(arrControles[i]).value="";
//				
//					
//			}else{
//				for (var i=0; i<arrControles.length; i++){
//					if(document.getElementById(arrControles[i])!=null)
//						document.getElementById(arrControles[i]).value=responseXML.text.split("[--]")[i+1];
//				}
//			}
//			if (_functionReady!=null){
//				_functionReady();
//			}
//		}catch(e){}
//	}	
//	
//	function __abrirAyuda(){
//		if(event.keyCode==113) //F2
//		    _objClave.ondblclick();
//	}
//	//Asignamos
//	if(_objImage != null)
//	    _objImage.onclick=this.abrirAyuda;
//	_objClave.ondblclick=this.abrirAyuda;
//	_objClave.title="Doble click para abrir la ayuda.";
//	var objText=new VetecText(p_strClave,p_strTipo, p_intLength);
//	objText.setFunctionBlur(__buscarDescripcion);
//	objText.setFunctionKey(__abrirAyuda);
//	
//	
//	

//	//Doble click
//	for (var i=0; i<arrControles.length; i++)
//		if(document.getElementById(arrControles[i])!=null){
//			document.getElementById(arrControles[i]).ondblclick=this.abrirAyuda;
//			document.getElementById(arrControles[i]).onkeydown=__abrirAyuda;
//			document.getElementById(arrControles[i]).title="Doble click para abrir la ayuda.";
//		}
//}

