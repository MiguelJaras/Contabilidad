

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbRubros_List')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbRubros_List
	PRINT N'Drop Procedure : dbo.usp_tbRubros_List - Succeeded !!!'
END
GO

------------------------------------------------------------------------------------
---   Aplicacion: IASD.		                                                     ---
---        Autor: Ingrid Alexis Soto Dimas                                       ---
---  Descripcion: Obtiene un registro de la tabla:  tbCotizacion                 ---
---                                                                              ---
------------------------------------------------------------------------------------
---    Fecha     Autor  Comentario                                               ---
---  ----------  -----  -------------------------------------------------------  ---
---  22/08/2011  RMM    Create procedure                                         ---
------------------------------------------------------------------------------------

CREATE PROCEDURE dbo.usp_tbRubros_List
(
	@intEmpresa int
)
WITH ENCRYPTION
AS
BEGIN
	SET NOCOUNT ON	
	
	SELECT * 
	FROM VetecMarfilAdmin.dbo.tbRubros 
	WHERE intEmpresa = @intEmpresa
	
	SET NOCOUNT OFF
END
GO 

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbRubros_List Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbRubros_List Error on Creation'
END
GO

