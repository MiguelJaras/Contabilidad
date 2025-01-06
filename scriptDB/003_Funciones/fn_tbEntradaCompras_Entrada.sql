IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.fn_tbEntradaCompras_Entrada')
	AND OBJECTPROPERTY(id,N'IsScalarFunction') = 1)
BEGIN
    DROP FUNCTION dbo.fn_tbEntradaCompras_Entrada
    PRINT 'Drop Function : dbo.fn_tbEntradaCompras_Entrada - Succeeded !!!'
END
GO

------------------------------------------------------------------------------------
---  Aplicacion:  PM.															 ---
---        Autor: Ruben Mora Martinez/ RMM										 ---
---  Descripcion: Return number of week in current month                         ---
------------------------------------------------------------------------------------
---    Fecha     Autor  Comentario                                               ---
---  ----------  -----  -------------------------------------------------------  ---
---  2011-07-29  RMM    Creacion                                                 ---
------------------------------------------------------------------------------------

Create Function dbo.fn_tbEntradaCompras_Entrada
(
	@intOrdenCompraEnc int,
	@intOrdenCompraDet int
)
RETURNS INT
AS
BEGIN
		DECLARE @Entrada INT
		DECLARE @dblCantidadEnt decimal(18,4)
		DECLARE @dblCantidadRel decimal(18,4)		

		SELECT @dblCantidadRel = SUM(dblCantidad) 
		FROM tbOrdenCompraDet WHERE intOrdenCompraEnc = @intOrdenCompraEnc
		AND intOrdenCompraDet = @intOrdenCompraDet

		SELECT @dblCantidadEnt = SUM(dblCantidad) 
		FROM tbEntradaCompras WHERE intOrdenCompraEnc = @intOrdenCompraEnc
		AND intOrdenCompraDet = @intOrdenCompraDet
		AND intEstatus <> 9

		IF(ISNULL(@dblCantidadEnt,0) >= ISNULL(@dblCantidadRel,0))
			SET @Entrada = 1
		ELSE
			SET @Entrada = 0

	
		RETURN @Entrada
END
GO

-- Display the status of Proc creation
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.fn_tbEntradaCompras_Entrada')
	AND OBJECTPROPERTY(id,N'IsScalarFunction') = 1)
BEGIN
    PRINT 'Function Creation: dbo.fn_tbEntradaCompras_Entrada - Succeeded !!!'
END
ELSE
BEGIN
    PRINT 'Function Creation: dbo.fn_tbEntradaCompras_Entrada - Error on Creation'
END
GO


