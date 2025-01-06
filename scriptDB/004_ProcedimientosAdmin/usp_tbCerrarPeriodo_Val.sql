

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbCerrarPeriodo_Val')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbCerrarPeriodo_Val
	PRINT N'Drop Procedure : dbo.usp_tbCerrarPeriodo_Val - Succeeded !!!'
END
GO


------------------------------------------------------------------------------------
---																				 ---
---        Autor: Ingrid Soto		                                             ---
---  Descripcion: Valida el CerrarPeriodo										 ---
---                                                                              ---
------------------------------------------------------------------------------------
---    Fecha     Autor  Comentario                                               ---
---  ----------  -----  -------------------------------------------------------  ---
---  09/09/2013  IASD    Create procedure                                         ---
------------------------------------------------------------------------------------
create
PROCEDURE [dbo].[usp_tbCerrarPeriodo_Val]
(
    @intEmpresa int,
	@intEjercicio int,
	@intMes int

) AS
BEGIN
SET NOCOUNT ON
              

	DECLARE @intCerrado INT 

	SELECT 
		@intCerrado = Convert(int,bCerrado) 
	FROM tbCerrarPeriodo 
	WHERE intEmpresa = @intEmpresa
	AND intEjercicio = @intEjercicio
	AND intMes = @intMes
	AND intModulo = 5 

SELECT ISNULL(@intCerrado,0) 


END
GO 

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbCerrarPeriodo_Val Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbCerrarPeriodo_Val Error on Creation'
END
GO

