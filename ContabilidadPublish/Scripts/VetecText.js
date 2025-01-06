/*
	Clase: VetecText
	Elabora: JCGZ
	Fecha: 25 Dic 06	
*/

function VetecText(objText,p_controlType, p_length, p_lengthmin)
{	
	var _objText=document.getElementById(objText);
	var _controlType=p_controlType;//text,number, decimal
	var _maxlength=p_length;
	var _minlength=p_lengthmin;
	var _functionBlur=null;
	var _functionKey=null;
	var _valorInicial=null;
	
	var objUtils=new VetecUtils();
	
	this.setControlType=function(str){
		_controlType=str;
	}
	
	this.setFunctionBlur=function(p_func){
		_functionBlur=p_func;
	}
	this.setFunctionKey=function(p_func){
		_functionKey=p_func;
	}
	
	
	function validaLetras() 
	{ 
	    
		/*event.returnValue = false
		if  (( event.keyCode >= 95 && event.keyCode <= 122 )  //minusculas
				|| (event.keyCode >= 64 && event.keyCode <= 90  )  //mayusculas
				|| (event.keyCode >= 45 && event.keyCode <= 57  )  //numeros
				|| (event.keyCode == 32 )
				|| event.keyCode == 225 || event.keyCode == 233 || event.keyCode == 237 
				|| event.keyCode == 243 || event.keyCode == 250 || event.keyCode == 241	//acentos y la ñ 
				|| event.keyCode == 193 || event.keyCode == 201 || event.keyCode == 205 
				|| event.keyCode == 211 || event.keyCode == 218 || event.keyCode == 209 || event.keyCode == 46 || event.keyCode == 35	//acentos mayúsuclas y la Ñ
			) */
				event.returnValue = true; 
	}
	
	function validaSoloLetras() { 
		event.returnValue = false
		if  (( event.keyCode >= 97 && event.keyCode <= 122 )  //minusculas
				|| (event.keyCode >= 65 && event.keyCode <= 90  )  //mayusculas
				|| (event.keyCode == 32 )
				|| event.keyCode == 225 || event.keyCode == 233 || event.keyCode == 237 
				|| event.keyCode == 243 || event.keyCode == 250 || event.keyCode == 241	//acentos y la ñ 
				|| event.keyCode == 193 || event.keyCode == 201 || event.keyCode == 205 
				|| event.keyCode == 211 || event.keyCode == 218 || event.keyCode == 209	//acentos mayúsuclas y la Ñ
			) 
				event.returnValue = true; 
	}
	function validaRFC() { 
		event.returnValue = false
		var blResult=!isNaN(parseInt(String.fromCharCode(event.keyCode)));  
		if  (( event.keyCode >= 97 && event.keyCode <= 122 )  //minusculas
				|| (event.keyCode >= 65 && event.keyCode <= 90  )  //mayusculas
				|| blResult || event.keyCode==38
			) 
			event.returnValue = true; 
	}

	function validaNumeros() {     
	    if(event.keyCode == 113)
	        event.returnValue = true;
	    else
		    event.returnValue = !isNaN(parseInt(String.fromCharCode(event.keyCode)));  
	}

	function validaDecimal() {
		event.returnValue = !isNaN(parseFloat(String.fromCharCode(event.keyCode)+"0"));  
	}
	
	function p_onKeyUp()
	{
		if (_functionKey!=null)
		{		    
			_functionKey(_objText);
		}
	}
	
	function p_onKeyPress(){
		if (_objText.value.length>=_maxlength)
			event.keyCode=0;
		switch(_controlType){
			case "decimal":
				validaDecimal();
				break;
		    case "decimal6":
				validaDecimal();
				break;
			case "currency":
				validaDecimal();
				break;
			case "text":
				validaLetras();
				break;
			case "letter":
				validaSoloLetras();
				break;
			case "number":
				validaNumeros();
				break;
			case "rfc":
				validaRFC();
				break;
		}
	}
	
	function p_onFocus()
	{
		_valorInicial=_objText.value;
		_objText.style.backgroundColor="#FFFF33";
		_objText.style.color= 'Black';
	}
	
	function p_onBlur()
	{
		try{
			_objText.style.backgroundColor="";
			if (_objText.value.length>=_maxlength){
				if(event==null) return;
				event.keyCode=0;
			}
			switch(_controlType){
				case "decimal":
					if(_objText.value!="")
						//_objText.value=objUtils.formatCurrency(parseFloat(objUtils.unFormat(_objText.value)).toFixed(2)).replace("$","");
						_objText.value=parseFloat(_objText.value).toFixed(2);
					if (isNaN(objUtils.unFormat(_objText.value)))
						_objText.value="0.0";
					break;
					
			    case "decimal4":
					if(_objText.value!="")
						//_objText.value=objUtils.formatCurrency(parseFloat(objUtils.unFormat(_objText.value)).toFixed(2)).replace("$","");
						_objText.value=parseFloat(_objText.value).toFixed(4);
					if (isNaN(objUtils.unFormat(_objText.value)))
						_objText.value="0.0";
					break;
					
				case "decimal6":
					if(_objText.value!="")
						_objText.value=parseFloat(_objText.value).toFixed(6);
					if (isNaN(objUtils.unFormat(_objText.value)))
						_objText.value="0.000000";
					break;
				case "currency":
					if(_objText.value!="")
						_objText.value=objUtils.formatCurrency(parseFloat(objUtils.unFormat(_objText.value)).toFixed(2));
					if (isNaN(objUtils.unFormat(_objText.value)))
						_objText.value="$0.00";
					break;
				case "number":
					if(_objText.value!="")
						_objText.value=parseInt(_objText.value);
					if (isNaN(_objText.value))
						_objText.value="";
					break;
			}
			//Convertimos el texto en mayusculas
			//Añadido 15 Julio 2007
			//JCGZ
			_objText.value=_objText.value.toUpperCase();
			if (_functionBlur!=null && _objText.value!=_valorInicial){
				_functionBlur(_objText);
			}
			_funOldBlur();
		}catch(e){}
	}
	
	//Inicializamos los eventos del objeto  
	_objText.onkeypress = new Function();
	//Remplazamos sus manejadores de eventos
	_objText.onkeypress=p_onKeyPress;	
	_objText.onkeyup=p_onKeyUp;	
	_objText.onkeydown=p_onDown;	
	var _funOldBlur;
	_funOldBlur=_objText.onblur;
	_objText.onblur=p_onBlur;	
	_objText.onfocus=p_onFocus;	
	
	
	function p_onDown()
	{
//	    if (_functionKey!=null)
//		{		    
//			_functionKey(_objText);
//		}		    
	
		if (window.event && window.event.keyCode == 13)          
		{
            window.event.keyCode = 9;
        } 
        
        if (window.event && window.event.keyCode == 113)  
            _objText.ondblclick(); 
        
	}
		
}

