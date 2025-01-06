

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbEstadosFinRubros_Del')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbEstadosFinRubros_Del
	PRINT N'Drop Procedure : dbo.usp_tbEstadosFinRubros_Del - Succeeded !!!'
END
GO

------------------------------------------------------------------------------------
---																				 ---
---        Autor: Ingrid Soto		                                             ---
---  Descripcion: Elimina en tbEstadosFinRubros									 ---
---                                                                              ---
------------------------------------------------------------------------------------
---    Fecha     Autor  Comentario                                               ---
---  ----------  -----  -------------------------------------------------------  ---
---  28/08/2013  IASD    Create procedure                                         ---
------------------------------------------------------------------------------------
CREATE 
PROCEDURE [dbo].[usp_tbEstadosFinRubros_Del]
(
		@intEstadoFin int,
		@intRubro int,
		@intEmpresa int
) 
AS
BEGIN
	SET NOCOUNT ON
                
				DELETE
                FROM   VetecMarfilAdmin..tbEstadosFinRubros
				WHERE  intEstadoFin   = @intEstadoFin
						AND intRubro = @intRubro
						AND intEmpresa =  @intEmpresa
	SELECT @intRubro

END
GO 

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbEstadosFinRubros_Del Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbEstadosFinRubros_Del Error on Creation'
END
GO

