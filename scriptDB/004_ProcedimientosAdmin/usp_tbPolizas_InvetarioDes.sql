

/****** Object:  StoredProcedure [dbo.usp_tbPolizas_InvetarioDes]    Script Date: 12/8/2009 10:45:19 AM ******/
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbPolizas_InvetarioDes')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbPolizas_InvetarioDes
	PRINT N'Drop Procedure : dbo.usp_tbPolizas_InvetarioDes - Succeeded !!!'
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

CREATE PROCEDURE dbo.usp_tbPolizas_InvetarioDes
(      
	@intEmpresa			int,
    @intEjercicio		int,
	@intMes				int,
	@strUsuario			VARCHAR(50),
	@strMaquina			VARCHAR(50)
)
WITH ENCRYPTION 
AS
BEGIN
		
	SET NOCOUNT ON

	DECLARE	@Rows				int,
			@Count				int,
			@strPoliza			varchar(50),
			@Error				VARCHAR(2000)

	CREATE TABLE #Polizas(id int identity(1,1), strPoliza varchar(50))

	BEGIN TRY
	BEGIN TRANSACTION usp_tbPolizas_InvetarioDes

		INSERT INTO #Polizas(strPoliza)
		SELECT strPoliza
		FROM VetecMarfilAdmin..tbPolizasEnc
		WHERE intEmpresa = @intEmpresa
		AND intEjercicio = @intEjercicio
		AND intMes = @intMes
		AND strTipoPoliza = '06'
		AND strAuxiliar = 'SEM IE'
		ORDER BY intFolioPoliza Desc

		SELECT @Rows = COUNT(*) FROM #Polizas
		SET @Count = 0

		WHILE(@Rows > @Count)
		BEGIN
			SET @Count = @Count + 1
			SELECT @strPoliza = strPoliza FROM #Polizas WHERE id = @Count

			EXEC VetecMarfilAdmin..usp_tbPolizasEnc_Delete @intEmpresa,@strPoliza,@intEjercicio,@strUsuario,@strMaquina

			UPDATE tbEntradaCompras 
			SET intEjercicio = null, strPoliza = null
			WHERE intEjercicio = @intEjercicio and strPoliza = @strPoliza and intEmpresa = @intEmpresa
		END	

		SELECT 	@intMes
	
	COMMIT TRANSACTION tbPolizas_InvetarioDes
	END TRY
	BEGIN CATCH	
		IF @@TRANCOUNT > 0
		ROLLBACK TRANSACTION tbPolizas_InvetarioDes   

		DECLARE @ErrMsg nvarchar(4000), @ErrSeverity int
		SELECT @ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

		RAISERROR(@ErrMsg, @ErrSeverity, 1)
	END CATCH


	SET NOCOUNT OFF
	
END
GO

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbPolizas_InvetarioDes Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbPolizas_InvetarioDes Error on Creation'
END
GO

