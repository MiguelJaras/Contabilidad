/*
	Clase: VetecGrid
	Elabora: JCGZ
	Fecha: 16 Oct 06	
*/


function VetecSimpleGrid(objGrid)
{   
	var _grid=document.getElementById(objGrid);
	if (_grid==null) return;
	var _rowover = null;
	var _rowclick = null;
	
	 for (var j=1;j<_grid.rows.length;j++) { 
		var rowclick=_grid.rows[j]; 
 		if(rowclick.rowIndex%2)
			rowclick.runtimeStyle.backgroundColor = '#FFFFFF';	
		else
			rowclick.runtimeStyle.backgroundColor = CSTALTERTABLECOLOR;			
	}

	var callwhenclick=function(){};
	var callwhendobleclick=function(){};

	this.setEventClick=function(func){
		callwhenclick=func;
	}

    this.setEventDobleClick=function(func){
		callwhendobleclick=func;
	}

	this.setText=function(i,j,str){
		_grid.rows(i).cells(j).innerText=str;
	}
	

	this.getText=function(i,j){
		return _grid.rows(i).cells(j).innerText;
	}


	this.getRow=function(){
		if (_rowclick == null) 
			return 0;
		else
			return _rowclick.rowIndex;
	}
	
	this.setRow=function(intRow){		
		if (_rowclick == null) 
			return;
		else
			if(_rowover.rowIndex%2)
				_rowover.runtimeStyle.backgroundColor = '#FFFFFF';	
			else
				_rowover.runtimeStyle.backgroundColor = CSTALTERTABLECOLOR;
		if(intRow < 0 || intRow>=_rowclick.parentElement.rows.length-1) 			
			return;		
		//Cambio la fila actual
		_rowclick=_rowclick.parentElement.rows[intRow];
		//Asigno el estilo a la nueva fila
		if (intRow!=0)			
			_rowclick.runtimeStyle.backgroundColor = CSTCOLORCLICK;		
	}

	
	click=function(){
		//Tomo el objeto que origino el evento
		srcTag = window.event.srcElement;	
		if(srcTag.tagName == "TD")
			srcTag = srcTag.parentElement;
		if(srcTag.tagName != "TR") 
			return;
		//Si ya existe una fila seleccionada, retiro el color a la fila anterior
		if (_rowclick != null) 
			if(_rowclick.rowIndex%2)
				_rowclick.runtimeStyle.backgroundColor = '#FFFFFF';	
			else
				_rowclick.runtimeStyle.backgroundColor = CSTALTERTABLECOLOR;
		//Asigno el estilo a la nueva fila
		srcTag.runtimeStyle.backgroundColor=CSTCOLORCLICK;
		//Guardo la fila que actualmente esta seleccionada
		_rowclick = srcTag;	
		if (callwhenclick!=null)
			callwhenclick(_rowclick);
	}
	
	dobleclick=function(){
		//Tomo el objeto que origino el evento
		srcTag = window.event.srcElement;	
		if(srcTag.tagName == "TD")
			srcTag = srcTag.parentElement;
		if(srcTag.tagName != "TR") 
			return;
		//Si ya existe una fila seleccionada, retiro el color a la fila anterior
		if (_rowclick != null) 
			if(_rowclick.rowIndex%2)
				_rowclick.runtimeStyle.backgroundColor = '#FFFFFF';	
			else
				_rowclick.runtimeStyle.backgroundColor = CSTALTERTABLECOLOR;
		//Asigno el estilo a la nueva fila
		srcTag.runtimeStyle.backgroundColor=CSTCOLORCLICK;
		//Guardo la fila que actualmente esta seleccionada
		_rowclick = srcTag;	
		if (callwhendobleclick!=null)
			callwhendobleclick();
	} 


	mouseover=function(){
		//Tomo el objeto que origino el evento
		srcTag = window.event.srcElement;	
		if(srcTag.tagName == "TD")
			srcTag = srcTag.parentElement;
		if(srcTag.tagName != "TR") 
			return;
		if (srcTag.rowIndex > 0)
			_showover(srcTag);
		else
			_showover(null);
	}




	function _showover(newRow){
		if (_rowover != null && _rowover!=_rowclick)
			if(_rowover.rowIndex%2)
				_rowover.runtimeStyle.backgroundColor = '#FFFFFF';	
			else
				_rowover.runtimeStyle.backgroundColor = CSTALTERTABLECOLOR;
		if (newRow != null && newRow!=_rowclick)
			newRow.runtimeStyle.backgroundColor = CSTCOLOROVER;
		_rowover = newRow;	

	}	


	
	mouseout=function(){		
		_showover(null);
	}
	

	mousedown=function(){		
		if (_rowclick==null)
			return;		
		switch(window.event.keyCode){
			case CSTKEYUP:				
				if (_rowclick.rowIndex-1==0)
					return;
				setRow(_rowclick.rowIndex-1);
				break;
			case CSTKEYDOWN:
				if (_rowclick.rowIndex+1==_rowclick.parentElement.rows.length-1)
					return;
				setRow(_rowclick.rowIndex+1);
				break;
		}
	}

	_grid.onclick = new Function();
	_grid.ondblclick = new Function();
	_grid.onmouseover = new Function();
	_grid.onmouseout = new Function();

    
	_grid.onclick=click;
	_grid.ondblclick=dobleclick;
	_grid.onmouseover=mouseover;
	_grid.onmouseout=mouseout;



	
}



