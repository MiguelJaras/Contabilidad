var defaultFormIndex        =   0;

function CreateDinamicStyle(strStyleProperies){
    var objStyle = document.createElement("style");
    objStyle.type = "text/css";

    if (objStyle.styleSheet){// this is for ie browser
        objStyle.styleSheet.cssText = strStyleProperies;
    } else {// for another browser
        objStyle.appendChild(document.createTextNode(strStyleProperies)); 
    }

    document.getElementsByTagName("head")[0].appendChild(objStyle);
}//End CreateDinamicStyle

function GetContentHeight(){
    if (window.innerHeight)
    { 
       //navegadores basados en mozilla 
       return Content.innerHeight;
    }
        else{ 
           if (document.body.clientHeight)
           { 
               //Navegadores basados en IExplorer, es que no tengo innerheight 
               return document.body.clientHeight
           }
               else
               { 
                   //otros navegadores 
                   return 588;
               } 
    } 
}//End GetContentHeight


function IsDigit(asciiValue){
    return asciiValue >= 48 && asciiValue <= 57; 
}

function IsDot(asciiValue){
    return asciiValue == 46; 
}

function Validating_Float(StringValue,asciiValue){
    //1.Validating character entered.
    if (!(IsDigit(asciiValue) || IsDot(asciiValue))){
        return false;
    }
    //2.Validating dot
    if(IsDot(asciiValue)){
        //2.1. Dot is first character entered
        if(StringValue==''){
            return false;
        }
        //2.2. Dot exists
        if(StringValue.indexOf(String.fromCharCode(asciiValue))>-1){
            return false;
        }
    }
    
    return true;
}

function TxtAmount_onkeypress(evt){                        
    var asciiValue  =   (evt) ? evt.keyCode : 0;
    asciiValue      =   (asciiValue==0 ? evt.which : asciiValue)            
    
    var srcElement  =   evt.target ? evt.target : evt.srcElement;
    
    // 1. Validate keyCode Allowed
    return Validating_Float(srcElement.value, asciiValue);
}
    
    
function SetFocusToNextActiveControl(){
    var index       =   0;
    var allTags     =   document.getElementsByTagName("*");
    for(index=0; index < allTags.length; index++){
        Tag =   allTags[index];
        if ( Tag.isDisabled==false && ((Tag.tagName.toUpperCase()=='INPUT' && Tag.type.toUpperCase()!='HIDDEN') || Tag.tagName.toUpperCase()=='SELECT') )
        {
            try{
                Tag.focus();
                break;   
            }
            catch(e){
            }
            
        }
    }
}


function ShowPopCalendar(TxtOutName){
    giDatePos   =   1;
    if(self.gfPop)gfPop.fPopCalendar(document.getElementById(TxtOutName));  return false;
}


function CharactersAllowed_KeyPress(evt)
{
    var asciiValue  =   (evt) ? evt.keyCode : 0;
    asciiValue      =   (asciiValue==0 ? evt.which : asciiValue) ;
    
    if(asciiValue==8){return true;}
            
    var charsAllowed   =   'ABCDEFGHIJKLMNÑOPQRSTUVWXYZ@-ÁÉÍÓÚ, $;1234567890#.';
    
    return  charsAllowed.indexOf(String.fromCharCode(asciiValue).toUpperCase())>-1 ; 
}

function SetDefaultKeyPressEvent(){
    var index       =   0;
    var allTags     =   document.getElementsByTagName("INPUT");
    for(index=0; index < allTags.length; index++){
        Tag =   allTags[index];
        if ( Tag.isDisabled==false && Tag.type.toUpperCase()=='TEXT' )
        {
            Tag.onkeypress  =   function(){ return  CharactersAllowed_KeyPress(event); }            
        }
    }
}

