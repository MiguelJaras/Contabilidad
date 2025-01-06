// JScript File

function Browse(p_strClave,p_strTexts, p_strBO, p_strParam, p_intVersion, p_intEmpresa,p_intSucursal, p_intLength, p_blRequerido, p_strMsg)
{	
	var _objClave=document.getElementById(p_strClave);
	var _strBO=p_strBO;
	var _p_blRequerido=p_blRequerido;
	var _strParam=p_strParam;	
	var _intVersion=p_intVersion;
	var _strMsg=p_strMsg;
	var _functionReady;
	var arrControles=p_strTexts.split(",");
		
	var _strTemp="";
	var arrControlesParam=_strParam.split(",");
	for (var i=0; i<arrControlesParam.length; i++)
	{
        try
        {
            if(document.getElementById(arrControlesParam[i])!=null)
            {
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
		 catch(ex)
		 {
		    _strTemp=_strTemp+"[--]0";
		 }
    }

	_strTemp=_strTemp.substring(4,100);
	var result=MuestraPantalla(p_intEmpresa.value, p_intSucursal.value,_strBO,_strTemp,_intVersion);
	if(result==null)
	    return;		
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
			            }  
			        }

				    document.getElementById(arrControles[i]).value=(result.split("[--]")[i] == '&nbsp;' ? '' : result.split("[--]")[i]);
		        }       
	        }	
		}
		return 	result;	
	}
	
	function MuestraPantalla(p_intEmpresa, p_intSucursal, strBO, strParams, intVersion, strCampoBusqueda)
    {   
        alert(p_intEmpresa);
        alert(p_intSucursal);
        alert('si');
        
		var arrParams=strParams.split("[--]");
		strParams="";
		if(strCampoBusqueda==null)
		    strCampoBusqueda="strNombre";
		strCampoBusqueda=strCampoBusqueda.replace('+','[MAS]');
		for(var i=0; i<arrParams.length; i++){
			strParams+="&parametro"+i+"="+arrParams[i];
		}
				
		var CSTRHOSTNAME="http://"+window.location.hostname+":" + window.location.port + "/";
        var CSTRDIRAYUDA=CSTRHOSTNAME+"Contabilidad/Utils/Browse.aspx";
                 
		var strResult=window.showModalDialog(CSTRDIRAYUDA+"?intEmpresa="+intEmpresa+"&intSucursal="+intSucursal+"&classname="+strBO+strParams+"&version="+intVersion+"&parametros="+i+"&buscarpor="+strCampoBusqueda,'','dialogHeight:400px;resizable:yes;scroll:yes;');
		return strResult;
    }