//Vetec Utils


function VetecUtils(){
	var uid=0;
	
	
	this.isXMLEmpty=function(responseXML){
	try{
		if (responseXML.text =="") {
			alert("No se encontro informacion.");
			return true;
		}	
		var nodes = responseXML.selectNodes("//Table");   
		if (nodes.length!=0)
			return false;				    
		var nodes = responseXML.selectNodes("//Error");  
		var strError = GetChildNode(nodes(0).xml,0) ;
		var strSQL = GetChildNode(nodes(0).xml,1) ;	
		try{
			alert(nodes(0).text.split("[--]")[0]);
		}
		catch(ex){}
		return true;
	}
	catch(Ex){
		alert("No se encontro Informacion.");
	}
	}
	
	this.space=function(p_intSpaces){
		var strSpaces="";
		for(intCount=1; intCount<=p_intSpaces; intCount++){
			strSpaces+="&nbsp;";
		}
		return strSpaces;
	}
	
	this.isXMLEmptyNotMessage=function(responseXML){
		try{
			if (responseXML.text =="") {
				return true;
			}	
			var nodes = responseXML.selectNodes("//Table");   
			if (nodes.length!=0)
				return false;				    
			var nodes = responseXML.selectNodes("//Error");  
			var strError = GetChildNode(nodes(0).xml,0) ;
			var strSQL = GetChildNode(nodes(0).xml,1) ;	
			return true;
		}
		catch(Ex){
			return true;
		}
	}
	
	this.calendario=function(obj, x, y){
		var myDate = new Date();
		if ( obj.value != "" ) {myDate = obj.value;}
		myReturn = showModalDialog(CHOSTNAME+"/ImagenDental/Utilerias/calendar.htm", myDate,"status:no;help:no;minimize:no;maximize:no;close:no;border:thin;statusbar:no;dialogWidth:225px;dialogHeight:225px;DialogTop:" + y + "px;DialogLeft:" + x + "px");
		obj.value = myReturn;
	}
	
	this.validaItems=function(strItems){
		var arrLista=new Array();
		arrLista=strItems.split(",");
		for(var i=0; i<arrLista.length; i++){
			var control=document.getElementById(arrLista[i]);
			if (control!=null){
			    if(control.disabled==false){
				    switch(control.type){
					    case "select-one":
						    if(control.selectedIndex<=0 || control.value.trim()==""){
							    alert("Seleccione un elemento de la lista.");
							    this.shine(control);
							    return false;
						    }
						    var strValor=control.options(control.selectedIndex).value.trim();
						    if (strValor<0){
							    alert("Seleccione un elemento de la lista.");
							    this.shine(control);
							    return false;
						    }
						    break;
					    case "text":
						    var strValor=control.value.trim();
						    if (strValor==""){
							    alert("Complete la informacion.");
							    this.shine(control);
							    return false;
						    }
						    break;
					    case "password":
						    var strValor=control.value.trim();
						    if (strValor==""){
							    alert("Complete la informacion.");
							    this.shine(control);
							    return false;
						    }
						    break;
					    case "textarea":
						    var strValor=control.innerHTML.trim();
						    if (strValor==""){
							    alert("Complete la informacion.");
							    this.shine(control);
							    return false;
						    }
						    break;
				    }
				 }
			}
		}
		return true;
	}
	
	
	
	this.getElement=function (str, index){
		var arrValues=str.split(",");
		return arrValues[index];
	}
	
	this.formatCurrency=function(Valor){
		var Cantidad = new String(Valor);
		if (Cantidad=="")
			return("$0.00");
		if (isNaN(parseFloat(Valor))==true)
			return("$0.00");
		PosPunto = Cantidad.indexOf('.', 0);
		if (PosPunto==-1)    {
			Pesos = Cantidad;
			Centavos = "00";
		}
		else{
			Pesos = Cantidad.substr(0, PosPunto);
			Centavos = Cantidad.substr(PosPunto+1,2) + "00";
			Centavos = Centavos.substr(0,2);
		}
		NuevosPesos = "";
		LenPesos = Pesos.length;
		for (var i=0;i<LenPesos;i++){
			if (i!=0 && i%3==0)
				NuevosPesos = "," + NuevosPesos;
			NuevosPesos = Pesos.charAt(LenPesos-1-i) + NuevosPesos;
		}
		NuevosPesos = "$" + NuevosPesos + "." + Centavos;
		return (NuevosPesos);
	}


	this.getDate=function(){
		var names = new Array('Enero','Febrero','Marzo','Abril','Mayo','Junio','Julio','Agosto','Septiembre','Octubre','Noviembre','Diciembre');
		objDate=new Date();
		return objDate.getDate()+"-"+names[objDate.getMonth()]+"-"+objDate.getFullYear();
	}
	

	//Generador de claves
	//Devuelve un identifiador único
	this.getUid=function(){
		var strUid="_jcgz_imagen_dental_"+uid++;
		while(document.getElementById(strUid)!=null){
			var strUid="_jcgz_imagen_dental_"+uid++;
		}
		return strUid;
	}

	//Inserta celdas en una fila
	this.insertCells=function(p_row, p_int){
		for(i=1; i<=p_int;i++)
			p_row.insertCell();
	}


	this.getArrayValue=function(p_arr, p_int){
		try{
			if(p_arr[p_int]==null) return "";
			return p_arr[p_int];
		}catch(e){
			return "";
		}
	}

	this.unFormat=function(Valor){
		
		/*try{*/
		if(Valor==null)
			return 0;
		else
			return Valor.replace(',','').replace('$','').replace(',','').replace(',','').replace(',','');
		/*	*if (strResult=="")
				return 0;
		else
			return parseFloat(strResult);
		}catch(e){
			return "";
		}*/
	}
	
	this.getControlInCell=function(p_table, i,j, p_pos){
		if(p_table.rows(i)==null) return null;
		if(p_table.rows(i).cells(j)==null) return null;
		var strText=p_table.rows(i).cells(j).innerHTML;
		if (p_pos==null)
			p_pos=1;
		while(p_pos>0){
			strText=strText.substring(strText.indexOf("id=")+3);
			p_pos--;
		}
		if (strText.indexOf(" ")!=-1)
			strText=strText.substring(0,strText.indexOf(" "));
		if (strText.indexOf(">")!=-1)
			strText=strText.substring(0,strText.indexOf(">"));
		if (document.getElementById(strText)==null){
			strText=strText.substring(strText.indexOf("id=")+3);
			strText=strText.substring(0,strText.indexOf(" "));
			if (strText.indexOf(">")!=-1)
				strText=strText.substring(0,strText.indexOf(">"));
		}
		return document.getElementById(strText);
	}
	
	
	this.generaLista=function(strItems){
		var arrLista=new Array();
		var strLista="(LISTITEM)";
		arrLista=strItems.split(",");
		for(var i=0; i<arrLista.length; i++){
			var control=document.getElementById(arrLista[i]);
			switch(control.type){
				case "select-one":
					strLista+="(ITEM)"+control.options(control.selectedIndex).value+"(/ITEM)";
					break;
				case "text":
					strLista+="(ITEM)"+control.value+"(/ITEM)";
					break;
				case "hidden":
					strLista+="(ITEM)"+control.value+"(/ITEM)";
					break;
				case "checkbox":
					if (control.checked)
						strLista+="(ITEM)1(/ITEM)";
					else
						strLista+="(ITEM)0(/ITEM)";
					break;
				case "radio":
					if (control.checked)
						strLista+="(ITEM)1(/ITEM)";
					else
						strLista+="(ITEM)0(/ITEM)";
					break;

				case "textarea":
					strLista+="(ITEM)"+control.value+"(/ITEM)";
					break;
			}
		}
		strLista+="(/LISTITEM)";
		return strLista;
	}
	
	this.validaTabla=function(p_table){
		for (i=1;i<p_table.rows.length;i++){
			for(j=0; j<p_table.rows(1).cells.length; j++){
				var objControl=this.getControlInCell(p_table,i,j,1);
				if (objControl!=null){
					if(objControl.value!=null){
						if(objControl.value==""){
							alert("Complete la informacion.");
							objUtils.shine(objControl);
							return false;
						}
						
						if(objControl.tagName=="SELECT" && objControl.value==-1){
							alert("Seleccione un elemento de la lista.");
							objUtils.shine(objControl);
							return false;
						}
					}
				}			
			}
		}
		return true;
	}
	
	this.clearItems=function(strItems){
		var arrLista=new Array();
		arrLista=strItems.split(",");
		for(var i=0; i<arrLista.length; i++){
			var control=document.getElementById(arrLista[i]);
			if (control!=null){
				switch(control.type){
					case "select-one":
						control.selectedIndex=-1;
						break;
					case "text":
						control.value="";
						break;
					case "radio":
						control.checked=false;
						break;
				}
			}
		}
	}

	
	this.setRows=function(p_table,p_intRows){
		objRow = p_table.rows;
		if (objRow.length > 0 ){
			for (var i=objRow.length-1; i>p_intRows; i--)
				p_table.deleteRow(i);
		}
	}	
	
	this.shine=function(p_Obj){
		__objUtils__shineControl=p_Obj;
		try{
			p_Obj.focus();
		}catch(e){}
		__objUtils__lastColor=p_Obj.runtimeStyle.backgroundColor;
		var id = setInterval(__objUtils__privateShine,200);
		window.setTimeout("clearInterval("+id+")",1000);			
		window.setTimeout(__objUtils__restoreShine,1000);	
		window.setTimeout(__objUtils__restoreShine,2000);
	}

	function __objUtils__privateShine(){
		if (__objUtils__shineControl.runtimeStyle.backgroundColor!="#ffea00"){
			__objUtils__shineControl.runtimeStyle.backgroundColor="#ffea00";
		}else{
			__objUtils__shineControl.runtimeStyle.backgroundColor=__objUtils__lastColor;
		}
	}	 
	
	function __objUtils__restoreShine(){
		__objUtils__shineControl.runtimeStyle.backgroundColor=__objUtils__lastColor;
	}
		
	/*
	'************************************************************************
	'*Nombre:muestraVentanaAyuda                                            *
	'*----------------------------------------------------------------------*
	'*Tipo:Procedimiento                                                    *
	'*----------------------------------------------------------------------*
	'*Alcance:Público                                                       *
	'*----------------------------------------------------------------------*
	'*Parametro 1                                                           *
	'*Tipo: String                                                          *
	'*Nombre: strBO                                                         *
	'*Descripción: Clase de Negocio                                         *
	'*----------------------------------------------------------------------*
	'*Parametro 2                                                           *
	'*Tipo: String                                                          *
	'*Nombre: strParams                                                     *
	'*Descripción: Parametros para la ayuda                                 *
	'*----------------------------------------------------------------------*
	'*Parametro 3                                                           *
	'*Tipo: String                                                          *
	'*Nombre: intVersion                                                    *
	'*Descripción: Versión a mostrar                                        *
	'*----------------------------------------------------------------------*
	'*Autor:JCGZ                                                            *
	'*----------------------------------------------------------------------*
	'*Nota:Utilizado para mostrar la ayuda de una determinada clase.        *
	'*----------------------------------------------------------------------*
	'*Revisa:Vetec                                                          *
	'*----------------------------------------------------------------------*
	'*Fecha: 09/09/2007 10:22:32 p.m.                                       *
	'************************************************************************
	*/
	this.muestraVentanaAyuda=function(strBO, strParams, intVersion, strCampoBusqueda){
		var arrParams=strParams.split("[--]");
		strParams="";
		if(strCampoBusqueda==null)
		    strCampoBusqueda="strNombre";
		strCampoBusqueda=strCampoBusqueda.replace('+','[MAS]');
		for(var i=0; i<arrParams.length; i++){
			strParams+="&parametro"+i+"="+arrParams[i];
		}
		var strResult=window.showModalDialog(CSTRDIRAYUDA+"?classname="+strBO+strParams+"&version="+intVersion+"&parametros="+i+"&buscarpor="+strCampoBusqueda,'','dialogHeight:400px;resizable:yes;scroll:yes;');
		return strResult;
	}
	

	var __isCtrl = false;
   
    document.onkeyup=function(e){
	    //if(window.event.ctrlKey)
	     __isCtrl=false;
    }


   document.onkeydown=function(e){
	    if(window.event.ctrlKey) __isCtrl=true;
	    //Guardar
	    if("G" ==  String.fromCharCode(event.keyCode) && __isCtrl == true) {
		    if (document.getElementById("tdBotonG")!=null)
		        if(document.getElementById("btnSave")==null){
		            alert("Sin acceso a esta funcionalidad.");
		        }
		        else{
		            document.getElementById("btnSave").onclick();
		        }
		    return false;
	    }
	    
	    //Nuevo
	    if("N" ==  String.fromCharCode(event.keyCode) && __isCtrl == true) {
		    if (document.getElementById("tdBotonN")!=null)
		        if(document.getElementById("btnNew")==null){
		            alert("Sin acceso a esta funcionalidad.");
		            return;
		        }
		        if(document.getElementById("btnNew").onclick==null){
		            alert("Sin acceso a esta funcionalidad.");
		            return;
		        }
		        document.getElementById("btnNew").onclick();
		    return false;
	    }
	     //Listado
	    if("L" ==  String.fromCharCode(event.keyCode) && __isCtrl == true) {
		    if (document.getElementById("tdBotonL")!=null)
		        if(document.getElementById("btnList")==null){
		            alert("Sin acceso a esta funcionalidad.");
		            return;
		        }
		        if(document.getElementById("btnList").onclick==null){
		            alert("Sin acceso a esta funcionalidad.");
		            return;
		        }
		         document.getElementById("btnList").onclick();
		        
		    return false;
	    }
	    //Imprimir
	    if("I" ==  String.fromCharCode(event.keyCode) && __isCtrl == true) {
		    if (document.getElementById("tdBotonI")!=null)
		        if(document.getElementById("btnPrint")==null){
		            alert("Sin acceso a esta funcionalidad.");
		            return;
		        }
		        if(document.getElementById("btnPrint").onclick==null){
		            alert("Sin acceso a esta funcionalidad.");
		            return;
		        }
		        document.getElementById("btnPrint").onclick();
		    return false;
	    }
	     //Eliminar
	    if("E" ==  String.fromCharCode(event.keyCode) && __isCtrl == true) {
		    if (document.getElementById("tdBotonE")!=null)
		        if(document.getElementById("btnDelete")==null){
		            alert("Sin acceso a esta funcionalidad.");
		            return;
		        }
		        if(document.getElementById("btnDelete").onclick==null){
		            alert("Sin acceso a esta funcionalidad.");
		            return;
		        }
		        document.getElementById("btnDelete").onclick();
		    return false;
	    }
	    if(window.event==null)return;
		if (window.event.keyCode==CSTKEYENTER){
		   if(document.activeElement){
		       if(document.activeElement.type=='button'){
		          document.activeElement.onclick();
		       }
		   }
		   
		   if(CSTALLOWENTER)
			    window.event.keyCode=CSTKEYTAB;
		}
    }


	
	//Configuramos el tab
    //	document.getElementsByTagName("table")[0].onkeydown=this.setFocus;
	//Disponemos del Trim
	String.prototype.trim = function() { return this.replace(/^\s+|\s+$/, '');}
	
	
	
	 this.DateAdd=function(timeU, byMany,dateObj) {
		var millisecond=1;
		var second=millisecond*1000;
		var minute=second*60;
		var hour=minute*60;
		var day=hour*24;
		var year=day*365;

		var newDate;
		var dVal=dateObj.valueOf();
		switch(timeU) {
			case "ms": newDate=new Date(dVal+millisecond* byMany); break;
			case "s": newDate=new Date(dVal+second* byMany); break;
			case "mi": newDate=new Date(dVal+minute* byMany); break;
			case "h": newDate=new Date(dVal+hour* byMany); break;
			case "d": newDate=new Date(dVal+day* byMany); break;
			case "y": newDate=new Date(dVal+year* byMany); break;
		}
		return newDate;
	}


}

