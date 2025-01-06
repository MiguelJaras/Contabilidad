

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.fn_InsumosEspeciales'))
BEGIN
	DROP FUNCTION dbo.fn_InsumosEspeciales
	PRINT N'Drop Function : dbo.fn_InsumosEspeciales - Succeeded !!!'
END
GO

------------------------------------------------------------------------------------
---   Aplicacion: RMM.		                                                     ---
---        Autor: Ruben Mora Martinez                                            ---
---  Descripcion: Obtiene un registro de la tabla:  tbCotizacion                 ---
---                                                                              ---
------------------------------------------------------------------------------------
---    Fecha     Autor  Comentario                                               ---
---  ----------  -----  -------------------------------------------------------  ---
---  23/08/2011  RMM    Create procedure                                         ---
------------------------------------------------------------------------------------

CREATE FUNCTION dbo.fn_InsumosEspeciales(@intArticulo int)    
RETURNS DECIMAL(18,4) 
WITH ENCRYPTION
AS    
BEGIN 

	DECLARE @dblImporte DECIMAL(18,4)
	DECLARE @strNombreCorto VARCHAR(10)

	SET @dblImporte = 0

	SELECT @strNombreCorto = strNombreCorto FROM tbArticulo WHERE intArticulo = @intArticulo

	IF(@strNombreCorto = '')	
		SET @dblImporte = 1

	IF(@strNombreCorto = '')	
		SET @dblImporte = 1

	IF(@strNombreCorto = '')	
		SET @dblImporte = 1

	RETURN @dblImporte
END
GO 

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Function Creation: dbo.fn_InsumosEspeciales Succeeded'
END
ELSE
BEGIN
	PRINT 'Function Creation: dbo.fn_InsumosEspeciales Error on Creation'
END
GO



