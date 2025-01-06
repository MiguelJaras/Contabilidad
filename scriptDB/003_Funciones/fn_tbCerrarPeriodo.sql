IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.fn_tbCerrarPeriodo')
	AND OBJECTPROPERTY(id,N'IsScalarFunction') = 1)
BEGIN
    DROP FUNCTION dbo.fn_tbCerrarPeriodo
    PRINT 'Drop Function : dbo.fn_tbCerrarPeriodo - Succeeded !!!'
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

CREATE FUNCTION dbo.fn_tbCerrarPeriodo
(
	@intEmpresa int,
	@intEjercicio int,
	@intMes int,
	@intModulo int
)
RETURNS INT
AS
BEGIN
		DECLARE @intCerrado INT 

		SELECT @intCerrado = ISNULL(Convert(int,bCerrado),0)
		FROM tbCerrarPeriodo 
		WHERE intEmpresa = @intEmpresa
		AND intEjercicio = @intEjercicio
		AND intMes = @intMes
		AND intModulo = @intModulo 

		RETURN @intCerrado
END
GO

-- Display the status of Proc creation
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.fn_tbCerrarPeriodo')
	AND OBJECTPROPERTY(id,N'IsScalarFunction') = 1)
BEGIN
    PRINT 'Function Creation: dbo.fn_tbCerrarPeriodo - Succeeded !!!'
END
ELSE
BEGIN
    PRINT 'Function Creation: dbo.fn_tbCerrarPeriodo - Error on Creation'
END
GO


