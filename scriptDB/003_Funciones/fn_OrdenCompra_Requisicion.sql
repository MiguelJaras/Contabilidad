set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go



CREATE FUNCTION [dbo].[fn_OrdenCompra_Requisicion]
(
	@intEmpresa INT, 
	@intOrdenCompraEnc int
)
RETURNS VARCHAR(50)
AS
BEGIN
	DECLARE @Value VARCHAR(400)
	DECLARE @intRequisicionEnc INT

	SELECT @intRequisicionEnc = intRequisicionEnc 
	FROM tbTempOrdenCompra 
	WHERE inrOrdenCompra = @intOrdenCompraEnc		

	SELECT @Value = CONVERT(VARCHAR,intFolio)
	FROM tbRequisicionEnc 
	WHERE intEmpresa = @intEmpresa
	AND intRequisicionEnc = @intRequisicionEnc	

	RETURN @Value
END



