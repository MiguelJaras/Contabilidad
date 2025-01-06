// JScript File
function Delete_PreCallBack() 
{
    //if (!confirm('Desea eliminar el registro seleccionado?'))
    
    if (!confirm('Do you want to delete the selected record ?'))
    {
        return false;
    }

    return true;
}

function Message(text)
{
    alert(text);
}

///   <--- MENU/////
function ClrTD(td,color)
{
    td.className = color;
}

function ChangeColor(td,color)
{
	eval("document.all."+td+".style.backgroundColor='"+color+"'");
}

function desplegar() 
{
	var objRef = window.event.srcElement;

	objRef.desplegado = eval(objRef.desplegado);

	if (objRef.desplegado == true) 
	{
		objRef.desplegado = false;
	}
	else 
	{
		objRef.desplegado = true;
	}

	// Busca la tabla
	while (objRef.tagName != "TABLE") 
	{
		objRef = objRef.parentElement;
	}

	for (var i = 2; i < objRef.rows.length; i ++) 
	{
		var objRefTR = objRef.rows[i];

		if (objRefTR.style.display != "none")
		{
			objRefTR.style.display = "none";
		} 
		else 
		{
			objRefTR.style.display = "block";
		}
	}
}
///   MENU   ---> /////