/****** Object:  StoredProcedure [dbo.usp_Contabilidad_DataValue]    Script Date: 12/8/2009 10:45:19 AM ******/
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_Contabilidad_DataValue')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_Contabilidad_DataValue
	PRINT N'Drop Procedure : dbo.usp_Contabilidad_DataValue - Succeeded !!!'
END
GO

------------------------------------------------------------------------------------
---   Aplicacion: Marfil.		                                                 ---
---        Autor: Rubén Mora Martínez                                            ---
---  Descripcion: Obtiene un registro de la tabla:  Tareas	                     ---
---                                                                              ---
------------------------------------------------------------------------------------
---    Fecha     Autor  Comentario                                               ---
---  ----------  -----  -------------------------------------------------------  ---
---  12/11/2010  RMM    Create procedure                                         ---
------------------------------------------------------------------------------------

CREATE PROCEDURE dbo.usp_Contabilidad_DataValue
(      
	@intEmpresa		int,
	@intSucursal	int,
	@intTypeValue	int,
	@intValue       int
)
WITH ENCRYPTION 
AS
BEGIN
		
	SET NOCOUNT ON

	DECLARE @Value VARCHAR(200)
	SET @Value = ''

	IF(@intTypeValue = 1)
	BEGIN
		SELECT @Value = YEAR(GETDATE())
	END

	SELECT @Value AS strValue

	SET NOCOUNT OFF
	
END
GO

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_Contabilidad_DataValue Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_Contabilidad_DataValue Error on Creation'
END
GO

