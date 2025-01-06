function MantenSesion(){
            try {
                $.ajax({
                    type: "POST",
                    url: "../Mantenedor_sesiones.ashx",
                    data: {},
                    contentType: "text/html; chartset:utf-8",
                    dataType: "text",
                    success:
                function (result) {
                    if (result.d) {
                       document.write(result.d);
                    }
                },
                    error:
                        function (XmlHttpError, error, description) {
                            alert('Error f: ' + XmlHttpError.responseText);
                        },
                    async: true
                });
            } catch (e) {
                alert('Error e: ' + e.Message);
            }
}
        