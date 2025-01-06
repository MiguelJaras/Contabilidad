set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go



ALTER FUNCTION [dbo].[fn_Requisicion_Nota]
(
	@intEmpresa INT, 
	@intRequisicionEnc int
)
RETURNS VARCHAR(400)
AS
BEGIN
	DECLARE @Value VARCHAR(400)
	DECLARE @datFecha VARCHAR(400)
	DECLARE @strUsuarioAlta VARCHAR(100)
	DECLARE @strUsuario VARCHAR(400)	

	SELECT @datFecha = CONVERT(VARCHAR,datFechaAlta,103),@strUsuarioAlta = strUsuarioAlta
	FROM tbRequisicionEnc 
	WHERE intEmpresa = @intEmpresa
	AND intRequisicionEnc = @intRequisicionEnc

	SELECT @strUsuario = strNombreCompleto FROM segUsuarios WHERE strUsuario = @strUsuarioAlta

	SET @Value = '<p class="tLetra">Fecha    : ' + @datFecha + '                 
                  <br/> Realizo :  '+ @strUsuarioAlta + '  ' + @strUsuario + '</p>'

 --<br/> Autorizó :  + UsuarioAutoriza + "  " + obtieneUsuario(UsuarioAutoriza) +

	RETURN @Value
END



