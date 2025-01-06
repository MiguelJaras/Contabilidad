var BackGroundId            =   'dvModalWindowBackGround';
var ModalWindowId           =   'dvModalWindowBox';
var CaptionBoxId            =   'dvCaptionBox';
var CaptionTextId           =   'spCaptionText';
var ButtonCloseId           =   'imgButtonClose';
var UserInterfazFrameId     =   'ifrUserInterfazFrame';
var ClientContentId         =   'tblClientContent';


function ModalWindow(){
       
    this.Values             =   null;
    this.window_closed      =   null;    
    this.DialogResultOK     =   false;
    this.DialogResultCancel =   true;
    this.Width              =   '600px';
    this.Height             =   '500px';
    this.Top                =   '0px';
    this.Left               =   ((parseInt(document.body.clientWidth)-parseInt(this.Width))/2).toString()+'px';
    this.BackGround         =   document.getElementById(BackGroundId);
    this.ModalWindowBox     =   document.getElementById(ModalWindowId);
    this.CaptionBox         =   document.getElementById(CaptionBoxId);
    this.CaptionText        =   document.getElementById(CaptionTextId);
    this.ButtonClose        =   document.getElementById(ButtonCloseId);
    this.UserInterfazFrame  =   document.getElementById(UserInterfazFrameId);
    this.ClientContent      =   document.getElementById(ClientContentId);
    
    if(this.BackGround==null){    
        this.BackGround             =   document.createElement("div");
        this.BackGround.id          =   BackGroundId;
        CreateDinamicStyle('#dvModalWindowBackGround {visibility: hidden;position: absolute;left: 0px;top: 0px;width:150%;height:150%;text-align:center;z-index: 998;background:#000000;filter:alpha(opacity=60);opacity:.60;');
    }
    
    
    if(this.ModalWindowBox==null){    
        this.ModalWindowBox         =   document.createElement("div");
        this.ModalWindowBox.id      =   ModalWindowId;
        this.ModalWindowBox.style.position  ='absolute';
        this.ModalWindowBox.style.border    ='1px solid #000';
        this.ModalWindowBox.style.zIndex    ='999';
    }
    
    
    if(this.CaptionBox==null){    
        this.CaptionBox             =   document.createElement("div");
        this.CaptionBox.id          =   CaptionBoxId;
        this.CaptionBox.style.height=   '25px';        
    }    
    
    if(this.CaptionText==null){    
        this.CaptionText             =   document.createElement("span");
        this.CaptionText.id          =   CaptionTextId;         
        this.CaptionText.innerHTML       =   document.title;
    }
    
    
    if(this.ButtonClose==null){    
        this.ButtonClose             =   document.createElement("img");
        this.ButtonClose.id          =   ButtonCloseId;
        this.ButtonClose.src             =  '../Img/close.gif';
        this.ButtonClose.onclick         =  ModalWindow_Close;
    }   
        
    if(this.UserInterfazFrame==null){    
        this.UserInterfazFrame             =   document.createElement("iframe");
        this.UserInterfazFrame.id          =   UserInterfazFrameId;        
        this.UserInterfazFrame.style.width = '100%';        
    }
    
    var cellCaptionText, cellButtonClose, cellContent;
    if(this.ClientContent==null){    
        this.ClientContent             =   document.createElement("table");
        this.ClientContent.id          =   ClientContentId;
        this.ClientContent.setAttribute('cellpadding','0');
        this.ClientContent.setAttribute('cellspacing','0');
        CreateDinamicStyle('#tblClientContent {background-color: #333344;color: #FFFFFF;font-weight: bold;height: 100%;width: 100%;padding: 2px;border-bottom: 2px solid #000000;border-top: 1px solid #78A3F2;border-left: 1px solid #78A3F2;border-right: 1px solid #204095;}');        
        
        var rowHeader                  =   this.ClientContent.insertRow(0);                
        cellCaptionText                =   rowHeader.insertCell(0);
        cellCaptionText.setAttribute('width','95%');
        
        cellButtonClose                =   rowHeader.insertCell(1);
        cellButtonClose.setAttribute('width','5%');        
        cellButtonClose.setAttribute('align','right');
    }    
    cellCaptionText                =   this.ClientContent.rows[0].cells[0];
    cellButtonClose                =   this.ClientContent.rows[0].cells[1];

    
    cellCaptionText.appendChild(this.CaptionText);
    cellButtonClose.appendChild(this.ButtonClose);    

//    this.CaptionBox.appendChild(this.ClientContent);
//    this.ModalWindowBox.appendChild(this.CaptionBox);
//    this.UserInterfazFrame.setAttribute('this',this);
//    this.ModalWindowBox.appendChild(this.UserInterfazFrame);
//             
//    document.forms[defaultFormIndex].appendChild(this.BackGround);
//    document.forms[defaultFormIndex].appendChild(this.ModalWindowBox);


    this.Show   =   function(location, caption, width, height, top, left){   
                            if(caption!=null){
                                this.CaptionText.innerHTML  =   caption;
                            }
                            if(width!=null){
                                this.Width                  =   width;
                            }
                            if(height!=null){
                                this.Height                 =   height;
                            }
                            if(top!=null){
                                this.Top                    =   top;
                            }
                            
                            if(left!=null){
                                this.Left                   =   left;
                            }                            
                            else{
                                this.Left                   =   ((parseInt(document.body.clientWidth)-parseInt(this.Width))/2).toString()+'px';
                            }
                            this.ModalWindowBox.style.width =this.Width;
                            this.ModalWindowBox.style.height=this.Height;
                            this.ModalWindowBox.style.top   =this.Top;
                            this.ModalWindowBox.style.left  =this.Left;                                                     
                            this.UserInterfazFrame.style.height= parseInt(this.Height)-parseInt(this.CaptionBox.style.height);                            
                                                                                    
                            this.CaptionBox.appendChild(this.ClientContent);
                            this.ModalWindowBox.appendChild(this.CaptionBox);
                            this.ModalWindowBox.appendChild(this.UserInterfazFrame);                                     
                            document.forms[defaultFormIndex].appendChild(this.BackGround);
                            document.forms[defaultFormIndex].appendChild(this.ModalWindowBox);

                            
                            this.UserInterfazFrame.src              =   location; 
                            this.UserInterfazFrame.style.visibility =   'visible';
                            this.BackGround.style.visibility        =   'visible';
                            this.ModalWindowBox.style.visibility    =   'visible';
                    }    
    document.forms[defaultFormIndex].setAttribute('this',this);                    
}

function ModalWindow_DialogResultOK(values){    
    var modalWindow     =   ModalWindow_GetInstance();
    modalWindow.DialogResultOK=true;
    modalWindow.DialogResultCancel=false;
    ModalWindow_Close(values,modalWindow);
}

function ModalWindow_DialogResultCancel(values){    
    var modalWindow     =   ModalWindow_GetInstance();
    modalWindow.DialogResultOK=false;
    modalWindow.DialogResultCancel=true;
    ModalWindow_Close(values,modalWindow);
}

function ModalWindow_Close(values,modalWindow){


    if(modalWindow==null){
        modalWindow =   ModalWindow_GetInstance();
    }
    
    if (modalWindow!=null && document.getElementById(BackGroundId)){        
        document.getElementById(BackGroundId).style.visibility         =   'hidden'; 
        document.getElementById(ModalWindowId).style.visibility        =   'hidden';         
        document.getElementById(UserInterfazFrameId).style.visibility  =   'hidden'; 
        
        modalWindow.CaptionBox.removeChild(modalWindow.ClientContent);
        modalWindow.ModalWindowBox.removeChild(modalWindow.CaptionBox);
        modalWindow.ModalWindowBox.removeChild(modalWindow.UserInterfazFrame);
        
        document.forms[defaultFormIndex].removeChild(modalWindow.ModalWindowBox);
        document.forms[defaultFormIndex].removeChild(modalWindow.BackGround);
        
        if(modalWindow.window_closed!=null){
            modalWindow.window_closed(values);
        }        
    }
}

function ModalWindow_GetInstance(){    
    return document.forms[defaultFormIndex].getAttribute('this')
}

function ModalWindow_GetValues(){
    return ModalWindow_GetInstance().Values;
}

function ModalWindow_SetValues(Values){
    ModalWindow_GetInstance().Values    =   Values;
}

