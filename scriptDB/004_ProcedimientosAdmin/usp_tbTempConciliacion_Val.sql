/****** Object:  StoredProcedure [dbo.usp_tbTempConciliacion_Val]    Script Date: 12/8/2009 10:45:19 AM ******/
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbTempConciliacion_Val')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbTempConciliacion_Val
	PRINT N'Drop Procedure : dbo.usp_tbTempConciliacion_Val - Succeeded !!!'
END
GO

------------------------------------------------------------------------------------
---   Aplicacion: Marfil.		                                                 ---
---        Autor: Ingrid Alexis Soto                                            ---
---  Descripcion: Valida si existe en tbTempConciliacion	                     ---
---                                                                              ---
------------------------------------------------------------------------------------
---    Fecha     Autor  Comentario                                               ---
---  ----------  -----  -------------------------------------------------------  ---
---  27/08/2013  IASD    Create procedure                                         ---
------------------------------------------------------------------------------------

CREATE PROCEDURE dbo.usp_tbTempConciliacion_Val
(      
	@intEmpresa			int,
	@intEjercicio		int,
	@intMes				int,
	@intCuentaBancaria	int
)
WITH ENCRYPTION 
AS
BEGIN
		
	SET NOCOUNT ON

	IF NOT EXISTS
				(  SELECT 1 
						FROM VetecMarfilAdmin..tbTempConciliacion 
						WHERE intEmpresa = @intEmpresa
						AND intEjercicio = @intEjercicio
						AND intMes = @intMes
						AND intCuentaBancaria = @intCuentaBancaria
						AND bConciliado = 1
				) 
		SELECT 0 
	ELSE 
		SELECT 1
END
GO

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbTempConciliacion_Val Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbTempConciliacion_Val Error on Creation'
END
GO






