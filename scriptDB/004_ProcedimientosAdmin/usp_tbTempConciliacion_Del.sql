/****** Object:  StoredProcedure [dbo.usp_tbTempConciliacion_Del]    Script Date: 12/8/2009 10:45:19 AM ******/
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbTempConciliacion_Del')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbTempConciliacion_Del
	PRINT N'Drop Procedure : dbo.usp_tbTempConciliacion_Del - Succeeded !!!'
END
GO

------------------------------------------------------------------------------------
---   Aplicacion: Marfil.		                                                 ---
---        Autor: Ingrid Alexis Soto                                            ---
---  Descripcion: Elimina registro en usp_tbTempConciliacion_Del                ---
---                                                                              ---
------------------------------------------------------------------------------------
---    Fecha     Autor  Comentario                                               ---
---  ----------  -----  -------------------------------------------------------  ---
---  27/08/2013  IASD    Create procedure                                         ---
------------------------------------------------------------------------------------

CREATE PROCEDURE dbo.usp_tbTempConciliacion_Del
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

	DELETE FROM VetecMarfilAdmin..tbTempConciliacion 
		WHERE intEmpresa = @intEmpresa
		AND intEjercicio = @intEjercicio
		AND intMes = @intMes 
		AND intCuentaBancaria = @intCuentaBancaria

END
GO

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbTempConciliacion_Del Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbTempConciliacion_Del Error on Creation'
END
GO

