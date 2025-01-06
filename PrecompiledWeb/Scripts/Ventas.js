//SRMO = SelectRowOnMouseOver
//USRMO = UnSelectRowOnMouseOver
//CR = ClickRow 
function SRMO(obj) 
        {
            obj.style.backgroundColor = "#E8E8E8";            
//            obj.style.borderWidth = "3px";
//            obj.style.borderStyle = "solid";
//            obj.style.borderColor = "#721d34";  
            obj.style.border = "solid 1px #EEEEEE";                   
            obj.style.cursor = "hand";
        }
        function USRMO(obj)
        {        
            obj.style.backgroundColor = "";
            obj.style.color = "";
            obj.style.cursor = "";
        }
        function CR(rowIndex)
        {
            __doPostBack('SelectedRow',rowIndex)
        }
        function SelectAll(chkSelectAll, gridViewID)
        {
            //get reference of GridView control
            var grid = document.getElementById(gridViewID);
            
            //variable to contain the cell of the grid
            var cell;
            
            if (grid.rows.length > 0)
            {
                //loop starts from 1. rows[0] points to the header.
                for (i=1; i<grid.rows.length; i++)
                {
                    //get the reference of first column
                    cell = grid.rows[i].cells[0];

                    //loop according to the number of childNodes in the cell
                    for (j=0; j<cell.childNodes.length; j++)
                    {           
                        //if childNode type is CheckBox                 
                        if (cell.childNodes[j].type =="checkbox")
                        {
                        //assign the status of the Select All checkbox to the cell checkbox within the grid
                            cell.childNodes[j].checked = chkSelectAll.checked;
                        }
                    }
                }
            }

        }
        
        
        function PopUpWin(page, width, height) 
        {
        
            var iMyWidth;
            var iMyHeight;
            if (width == null) width=650
            if (height == null) height=600
            
            
            //half the screen width minus half the new window width (plus 5 pixel borders).
            iMyWidth = (window.screen.width/2) - (width / 2 + 10);
            //half the screen height minus half the new window height (plus title and status bars).
            iMyHeight = (window.screen.height/2) - (height / 2 + 50);
            //Open the window.
            var win2 = window.open(page,"Window2","status=no,height=" + height +",width=" + width +",resizable=yes,left=" + iMyWidth + ",top=" + iMyHeight + ",screenX=" + iMyWidth + ",screenY=" + iMyHeight + ",toolbar=no,menubar=no,scrollbars=no,location=no,directories=no");
            win2.focus();
        }
        
        function PopUpBaf(page, width, height) 
        {
        
            var iMyWidth;
            var iMyHeight;
            if (width == null) width=650
            if (height == null) height=600
            
            
            //half the screen width minus half the new window width (plus 5 pixel borders).
            iMyWidth = (window.screen.width/2) - (width / 2 + 10);
            //half the screen height minus half the new window height (plus title and status bars).
            iMyHeight = (window.screen.height/2) - (height / 2 + 50);
            //Open the window.
            var win2 = window.open(page,"Window2","status=no,height=" + height +",width=" + width +",resizable=no,left=" + iMyWidth + ",top=" + iMyHeight + ",screenX=" + iMyWidth + ",screenY=" + iMyHeight + ",toolbar=no,menubar=no,scrollbars=yes,location=no,directories=no");
            win2.focus();
        }