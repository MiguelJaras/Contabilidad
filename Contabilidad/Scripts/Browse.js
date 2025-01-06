var _BrowseFunctionCallback = function () { };
var _BrowseObjClave;
var _BrowseTexts;


function isFunction(functionToCheck) {
    return functionToCheck && {}.toString.call(functionToCheck) === '[object Function]';
}

function Browse(p_strClave, p_strTexts, p_strBO, p_strParam, p_intVersion, p_intEmpresa, p_intSucursal, p_intLength, p_blRequerido, p_strMsg, p_function, p_IsQuery) {



    var IsQuery = p_IsQuery || 0;

    _BrowseObjClave = document.getElementById(p_strClave);
    _BrowseTexts = p_strTexts;

    if (isFunction(p_function))
        _BrowseFunctionCallback = p_function;
    else
        _BrowseFunctionCallback = function () { };

    var _strTemp = "";
    var arrControlesParam = p_strParam.split(",");
    for (var i = 0; i < arrControlesParam.length; i++) {
        try {
            if (document.getElementById(arrControlesParam[i]) != null) {
                if (document.getElementById(arrControlesParam[i]).type == "select-one")
                    if (document.getElementById(arrControlesParam[i]).value == "")
                        _strTemp = _strTemp + "[--]0";
                    else
                        _strTemp = _strTemp + "[--]" + document.getElementById(arrControlesParam[i]).value;
                else
                    _strTemp = _strTemp + "[--]" + document.getElementById(arrControlesParam[i]).value;
            }
            else
                _strTemp = _strTemp + "[--]" + arrControlesParam[i];
        }
        catch (ex) {
            _strTemp = _strTemp + "[--]0";
        }
    }

    _strTemp = _strTemp.substring(4, 100);
    var arrParams = _strTemp.split("[--]");
    strParams = "";
    var strCampoBusqueda = "";
    if (strCampoBusqueda == null || strCampoBusqueda == '')
        strCampoBusqueda = "strNombre";
    strCampoBusqueda = strCampoBusqueda.replace('+', '[MAS]');
    for (var i = 0; i < arrParams.length; i++) {
        strParams += "&parametro" + i + "=" + arrParams[i];
    }



    var CSTRHOSTNAME = "http://" + window.location.hostname + ":" + window.location.port + "/";
    var CSTRDIRAYUDA = CSTRHOSTNAME + "comercial/Utils/Browse.aspx";
    window.open(CSTRDIRAYUDA + "?intEmpresa=" + p_intEmpresa + "&intSucursal=" + p_intSucursal + "&classname=" + p_strBO + strParams + "&version=" + p_intVersion + "&parametros=" + i + "&buscarpor=" + strCampoBusqueda + "&IsQuery=" + IsQuery, '', 'height=570,width=520;top=200 left=250;resizable:yes;scroll:yes;');
}

function BrowseResult(result) {

    if (result == null)
        return;
    _BrowseObjClave.value = result.split("[--]")[0];

    var arrControles = _BrowseTexts.split(",");
    for (var i = 0; i < arrControles.length; i++) {
        if (document.getElementById(arrControles[i]) != null) {
            if (document.getElementById(arrControles[i]).name == 'hddOperation')
                document.getElementById(arrControles[i]).value = "2";
            else {
                if (document.getElementById(arrControles[i]).type == "checkbox")
                     document.getElementById(arrControles[i]).checked = (result.split("[--]")[i] == "1" ? true : false);
                else {
                    if (document.getElementById(arrControles[i]).name == 'cboUnidadInsumo') {
                        if (document.getElementById(arrControles[1]).value != "0") {
                            document.getElementById(arrControles[i]).style.backgroundColor = "Silver";
                            document.getElementById(arrControles[i]).style.Color = "#000066";
                            document.getElementById(arrControles[i]).style.textalign = "right";
                        }
                        else {
                            document.getElementById(arrControles[i]).style.backgroundColor = "white";
                            document.getElementById(arrControles[i]).style.Color = "black";
                            document.getElementById(arrControles[i]).style.textalign = "right";
                        }
                    }

                    if (document.getElementById(arrControles[i]).name == 'txtPrecioInsumo') {
                        if (document.getElementById(arrControles[1]).value != "0") {
                            document.getElementById(arrControles[i]).style.backgroundColor = "Silver";
                            document.getElementById(arrControles[i]).style.Color = "#000066";
                            document.getElementById(arrControles[i]).style.textalign = "right";
                        }
                        else {
                            document.getElementById(arrControles[i]).style.backgroundColor = "white";
                            document.getElementById(arrControles[i]).style.Color = "black";
                            document.getElementById(arrControles[i]).style.textalign = "right";
                        }
                    }

                    document.getElementById(arrControles[i]).value = (result.split("[--]")[i] == '&nbsp;' ? '' : result.split("[--]")[i]);
                }
            }
        }
    }

    _BrowseFunctionCallback();

}
