function CallMethod(url, data, successCallback) {
    try {
        $.ajax({
            type: 'POST',
            url: url,
            data: data,
            contentType: 'application/json; chartset:utf-8',
            dataType: 'json',
            success: successCallback,
            error: function (XmlHttpError, error, description) {
                if (XmlHttpError.status) {
                    alert(XmlHttpError.responseText);
                }
            },
            async: true,
        });
    }
    catch (e) {
        message = "no";
        alert('Error ' + e);
        process = false;
    }
}

function getParameterByName(name, url) {
    if (!url) url = window.location.href;
    name = name.replace(/[\[\]]/g, "\\$&");
    var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)"),
        results = regex.exec(url);
    if (!results) return null;
    if (!results[2]) return '';
    return decodeURIComponent(results[2].replace(/\+/g, " "));
}

$(document).on({
    ajaxStart: function () { $("body").addClass("loading"); },
    ajaxStop: function () { $("body").removeClass("loading"); }
});

