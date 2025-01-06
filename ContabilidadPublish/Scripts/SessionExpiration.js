
    //Initialize the first time...    
    var milisec                 =   1000 ;
    var TimeOutBeforeSeconds    =   10;    
            
    
    

    function CreateModalDialogObjects(){        
        var objScreenDiv                = document.createElement("div");
        objScreenDiv.id                 ='dvBackGround';
        
        var objModalDialogDiv           = document.createElement("div");
        objModalDialogDiv.id=           'ModalDialogBox'
        objModalDialogDiv.innerHTML  = "Current session is over time. <br/> <div id='dvCountDown' style='text-align:center;margin-top:15px;margin-bottom:15px;'></div><br/>Do you want to continue? <input type='submit' value='OK'></input>";
        
        objScreenDiv.appendChild(objModalDialogDiv);   
        
        document.forms[defaultFormIndex].appendChild(objScreenDiv);
        
        
        CreateDinamicStyle('#dvBackGround {visibility: hidden;position: absolute;left: 0px;top: 0px;width:100%;height:100%;text-align:center;z-index: 1000;background:#000000;filter:alpha(opacity=60);opacity:.60;');
        CreateDinamicStyle('#ModalDialogBox {width:300px;margin: 100px auto;background-color: #fff;border:1px solid #000;padding:15px;text-align:center;}');        
    }//End CreateModalDialogObjects
    


    function SetSessionExpiration(countDownSeconds){                 
        if(countDownSeconds==0){
            if (document.forms.length > 0){                
                document.forms[defaultFormIndex].target='_top';
                document.forms[defaultFormIndex].submit();
            }            
        }
        else{
            countDownSeconds    -=  1;                                    
            setTimeout('SetSessionExpiration(' + countDownSeconds.toString() + ')',    milisec);
            if(countDownSeconds<=TimeOutBeforeSeconds){
                if(countDownSeconds == TimeOutBeforeSeconds){
                    CreateModalDialogObjects();
                    document.getElementById("dvBackGround").style.visibility = "visible";
                }            
                document.getElementById("dvCountDown").innerHTML    =   countDownSeconds.toString();
            }
                        
        } 
        
    }
    
