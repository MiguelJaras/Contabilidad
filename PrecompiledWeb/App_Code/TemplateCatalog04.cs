using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.IO;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Drawing;


public class TemplateCatalog04 : System.Web.UI.Page
{
    public const string JSelectRowOnMouseOver_Event = "onmouseover";
    public const string JUnSelectRowOnMouseOut_Event = "onmouseout";
    public const string JClickRow_Event = "onclick";
    
    public const string JSelectRowOnMouseOver_Function = "SRMO(this)";
    public const string JUnSelectRowOnMouseOut_Function = "USRMO(this)";
    public const string JClickRow_Function = "CR";

    public const string __EVENTTARGET = "__EVENTTARGET";
    public const string __EVENTARGUMENT = "__EVENTARGUMENT";
    public const string __EVENTTARGET_SelectRow = "SelectedRow";


    public TemplateCatalog04()
    {
        //
        // TODO: Add constructor logic here
        //
        
    }    

    bool _fastAddNew = true;
    bool _modifyAndCancel = false;
    string _detailContainerID = "AresFormDetailPanel1";
    //string _expandButtonID = "btnExpand";
    private string _listContainerID = "AresFormListPanel1";
    private string _filterContainerID = "AresFormFilterPanel1";

    bool _showNewRow = true;
    string _ButtonsBarId = "AresFormBar1";
    string _datagridID = "DgrdList";
    string _ControlFocusOnAdd = "";
    string _ControlFocusOnModify = "";

    string label_Deleted = "Registro eliminado satisfactoriamente";
    string label_Error = "Existe un error";
    string label_Modify = "Actualice los datos";
    string label_New = "Ingrese los datos";
    string label_Ready = "Listo";
    string label_Updated = "Registro actualizado satisfactoriamente";
    string label_Canceled = "Listo";
    string label_Added = "Added";
    string label_ShowDetail = "ShowDetail";
    string label_Select = "Listo";
    string label_FastModify = "FastModify";
    string label_FastNew = "Registro guardado satisfactoriamente. Ingrese el nuevo registro";
    string label_NotValid = "Datos NO validos";
    string label_Search = "Listo";
    string label_default = "Ready";
    string label_ErrorInsert = "El valor que desea agregar ya existe en la base de datos, intente con un valor diferente";
    string label_ErrorDelete = "El registro no se puede eliminar porque tiene referencias, pero ha sido desactivado.";
}