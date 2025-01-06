
function KeyDownOnlyNumber(e, field)
{
    //No permitimos el PMy paste
    key =   e ? e.keyCode : 0;
    key =   (e==0? e.which: key);    
    
    
    if(key == 17 || key == 86) return false;
    if (key > 47 && key < 58 || key == 46 || key == 8 || key == 13 || key == 9)  return true;
    else
        return false;
}

function KeyDownOnlyDecimal(e, field)
{
    //No permitimos el PMy paste
    key =   e ? e.keyCode : 0;
    key =   (e==0? e.which: key);

    if(key == 17 || key == 86) return false;
}

function KeyUpOnlyNumber(e, field, ent, dec)
{
    key =   e ? e.keyCode : 0;
    key =   (e==0? e.which: key);

    bool = 0;
    value = field.value;    
          
    for(i=0;i<=value.length;i++)
    {
      //Revisamos si existe un pun to.
      if(value.substring(i,i+1) == ".")
      {
         bool = 1;
         break;
      }
      else
      {
         bool = 0;
      }
   }                 
         
                                              
     if(bool == 1)
     {          
         decimals = value.split('.')[1];
         integers = value.split('.')[0];
         //Revisamos que tenga 2 decimales          
         if(decimals != null)
         {   
            if(decimals.length > dec)
            {
               if(decimals.length == dec + 1)
               {
                 //Quitamos los decimales que exeden del limite
                 field.value = value.substring(0,value.length-1);
               }
               else
               {
                 //Quitamos los decimales cuando se pone el punto en la mitad de una cadena
                 field.value = value.substring(0,integers.length + 1);
               }
            }
        }                       
     }
     
     if(bool == 0)
     {
        if(value != null)
         {   
            if(value.length > ent)
            {
               //Quitamos los caracteres que exedan del limite permitido.
               field.value = value.substring(0,ent);
            }
        }     
     }                  
    return true;
}

function KeyPressOnlyDecimal(e, field, ent, dec)
{
    key = e.keyCode ? e.keyCode : e.which 
    value = field.value;    
   
    // permitimos el backspace
    if (key == 8) return true
 
    // permitimos del 0-9
    if (key > 47 && key < 58 || key == 46) 
    {        
        //No permitimos un punto al inicio del control.
        if(value == "" && key == 46) return false;
    
        //dejamos que el primer campo este vacio.
        if (value == "") return true
                              
        for(i=0;i<value.length;i++)
        {
            //Revisamos si existe un punto.
            if(value.substring(i,i+1) == ".")
            {
                bool = 1;
                break;
            }
            else
            {
                bool = 0;
            }
        }                 
         
         //Revisamos cuando se ingresa un punto.                     
        if(key == 46)
        {
            bool = 1;
            for(i=0;i<value.length;i++)
            {                       
                if(value.substring(i,i+1) == ".")
                {
                    //Si existe un punto, no permitimos otro.
                    return false;
                }                       
            }                
        } 
        else
        {
            size = ent + (dec + 1);//Octenemos el largo de la cadena de enteros + decimales y el punto.
            if(value.length >= ent && bool == 0)
            {
                //Si no contiene deciamles y el tamaño de la cadena es mayor al establecido, no lo permitimos.
                return false
            }
            if(value.length == size && bool == 1)
            {
                //Si contiene decimales y esta fuera del limite permitido de enteros + decimales, no lo permitimos.
                return false
            }
        } 
       return true;                    
    }
  
  // other key
  return false
}

function KeyPressOnlyInteger(e, field, ent)
{
    key = e.keyCode ? e.keyCode : e.which 
    value = field.value; 
    
    // permitimos el backspace.
    if (key == 8) return true
 
    // permitimos del 0-9.
    if (key > 47 && key < 58) 
    {         
        //Permitimos el primer caracter vacio.      
        if (value == "") return true                   

        //Revisamos que no se exeda del limite.
        if(value.length >= ent) return false           
 
       return true;                    
    }
  
  // other key
  return false
}


function KeyDownString(e, field)
{  
    return true;
}


//No permite el boton derecho
function BlockRightButton()
{
    return false;
}

//en este funcion: Field es el control y Size es la longitud de la cadena.
function Integer(Field , Size)
{       
    //Se le asignan los eventos "onkeydown", "onkeypress" y "onkeyup" al control.
    $addEvent(Field, "onkeydown", "return KeyDownOnlyNumber(event,this)", true); 
    $addEvent(Field, "onkeypress", "return KeyPressOnlyNumber(event,this,"+Size+")", true); 
    $addEvent(Field, "onkeyup", "return KeyUpOnlyNumber(event,this,"+Size+")", true); 
    $addEvent(Field, "oncontextmenu", "return BlockRightButton()", true); 
}

//en este funcion: Field es el control, Size es la longitud de la cadena y Decimals es el numero de decimales permitidos.
function Decimal(Field, Size, Decimals)
{    
    //Se le asignan los eventos "onkeydown", "onkeypress" y "onkeyup" al control.
    $addEvent(Field, "onkeydown", "return KeyDownOnlyDecimal(event,this)", true); 
    $addEvent(Field, "onkeypress", "return KeyPressOnlyDecimal(event,this,"+Size+","+Decimals+")", true); 
    $addEvent(Field, "onkeyup", "return KeyUpOnlyNumber(event,this,"+Size+","+Decimals+")", true); 
    $addEvent(Field, "oncontextmenu", "return BlockRightButton()", true); 
}


function $addEvent(o, _e, c, _b){
	var e = _e.toLowerCase(), b = (typeof _b == "boolean") ? _b : true, x = (o[e]) ? o[e].toString() : "";
	// strip out the body of the function
	x = x.substring(x.indexOf("{")+1, x.lastIndexOf("}"));
	x = ((b) ? (x + c) : (c + x)) + "\n";
	return o[e] = (!!window.Event) ? new Function("event", x) : new Function(x);
}


