

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbEstadosFinRubros_Fill')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbEstadosFinRubros_Fill
	PRINT N'Drop Procedure : dbo.usp_tbEstadosFinRubros_Fill - Succeeded !!!'
END
GO

------------------------------------------------------------------------------------
---																				 ---
---        Autor: Ingrid Soto		                                             ---
---  Descripcion: Consulta en tbEstadosFinRubros								 ---
---                                                                              ---
------------------------------------------------------------------------------------
---    Fecha     Autor  Comentario                                               ---
---  ----------  -----  -------------------------------------------------------  ---
---  02/09/2013  IASD    Create procedure                                         ---
------------------------------------------------------------------------------------
CREATE 
PROCEDURE [dbo].[usp_tbEstadosFinRubros_Fill]
(
    @intEstadoFin int,
	@intEmpresa int
	
) 
AS
BEGIN
	SET NOCOUNT ON
                
				SELECT
					A.intSecuencia  ,
					A.intRubro , 
					B.strNombre , 
					A.strTipoRubro ,
					A.intEmpresa,
					A.intEstadoFin 
				FROM VetecMarfilAdmin..tbEstadosFinRubros A
				INNER JOIN VetecMarfilAdmin..tbRubros B ON (A.intRubro = B.intRubro )
                WHERE ((@intEstadoFin = 0) OR (A.intEstadoFin = @intEstadoFin))  
				AND A.intEmpresa = @intEmpresa
END
GO 

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbEstadosFinRubros_Fill Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbEstadosFinRubros_Fill Error on Creation'
END
GO
