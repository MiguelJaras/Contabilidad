var ProcessingBackGroundId  =   'dvProcessingBackGround';
var ProcessingModalBoxId    =   'dvProcessingModalBox';
var ImageProcessingId       =   'imgImageProcessing';
var ImageProcessingSrc      =  '../Img/loading.gif';        

if (document.forms.length > 0){                    
    //document.forms[defaultFormIndex].onsubmit   =   form_onSubmit;
    document.forms[defaultFormIndex].attachEvent('onsubmit', form_onSubmit)
}    

function form_onSubmit(){
    this.ProcessingBackGround   =   document.getElementById(ProcessingBackGroundId);
    if (this.ProcessingBackGround==null){
        this.ProcessingBackGround       =   document.createElement("div");
        this.ProcessingBackGround.id    =   ProcessingBackGroundId;
        CreateDinamicStyle('#dvProcessingBackGround {visibility: hidden;position: absolute;left: 0px;top: 0px;width:100%;height:100%;text-align:center;z-index: 1000;background:#000000;filter:alpha(opacity=60);opacity:.60;');
    } 
    
    this.ProcessingModalBox   =   document.getElementById(ProcessingModalBoxId);
    if (this.ProcessingModalBox==null){
        this.ProcessingModalBox       =   document.createElement("div");
        this.ProcessingModalBox.id    =   ProcessingModalBoxId;
        CreateDinamicStyle('#dvProcessingModalBox {position: absolute; width: 700px; height: 600px; top: 50%; left: 50%; margin-left:-350px; }');
    }
    
    this.ImageProcessing   =   document.getElementById(ImageProcessingId);
    if(this.ImageProcessing==null){    
        this.ImageProcessing             =   document.createElement("img");
        this.ImageProcessing.id          =   ImageProcessingId;
        this.ImageProcessing.src         =   ImageProcessingSrc;
    }
    
    if (this.ProcessingBackGround.childNodes.length==0){
        this.ProcessingModalBox.appendChild(this.ImageProcessing);
        this.ProcessingBackGround.appendChild(this.ProcessingModalBox);   
        document.forms[defaultFormIndex].appendChild(this.ProcessingBackGround);
    }  
    
    this.ProcessingBackGround.style.visibility='visible';
    setTimeout('document.images["' + ImageProcessingId + '"].src="' + ImageProcessingSrc + '"', 700);
}

function form_onSubmit_Hidden(){
    this.ProcessingBackGround   =   document.getElementById(ProcessingBackGroundId);
    if (this.ProcessingBackGround!=null){
        this.ProcessingBackGround.style.visibility='hidden';
    }    
}
























   
