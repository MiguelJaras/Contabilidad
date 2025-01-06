/****** Object:  StoredProcedure [dbo.usp_tbFacXP_Fill]    Script Date: 12/8/2009 10:45:19 AM ******/
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbTempConciliacionEjercicio_Sel')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbTempConciliacionEjercicio_Sel
	PRINT N'Drop Procedure : dbo.usp_tbTempConciliacionEjercicio_Sel - Succeeded !!!'
END
GO

------------------------------------------------------------------------------------
---   Aplicacion: Marfil.		                                                 ---
---        Autor: Ingrid Alexis Soto Dimas                                       ---
---  Descripcion: Obtiene intEjercicio:  tbTempConciliacion	                     ---
---                                                                              ---
------------------------------------------------------------------------------------
---    Fecha     Autor  Comentario                                               ---
---  ----------  -----  -------------------------------------------------------  ---
---  19/08/2013  IASD   Create procedure                                         ---
------------------------------------------------------------------------------------

CREATE PROCEDURE dbo.usp_tbTempConciliacionEjercicio_Sel
(      
	@intEmpresa				int
)
WITH ENCRYPTION 
AS
BEGIN
		
	SET NOCOUNT ON

	SELECT DISTINCT intEjercicio 
		FROM VetecMarfilAdmin.dbo.tbTempConciliacion 
		WHERE intEmpresa =@intEmpresa
		ORDER BY intEjercicio DESC
	
	SET NOCOUNT OFF
	
END
GO

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbTempConciliacionEjercicio_Sel Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbTempConciliacionEjercicio_Sel Error on Creation'
END
GO

