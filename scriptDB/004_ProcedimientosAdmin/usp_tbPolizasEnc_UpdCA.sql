

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbPolizasEnc_UpdCA')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbPolizasEnc_UpdCA
	PRINT N'Drop Procedure : dbo.usp_tbPolizasEnc_UpdCA - Succeeded !!!'
END
GO
------------------------------------------------------------------------------------
---   Aplicacion: RMM.		                                                     ---
---        Autor: Ruben Mora Martinez                                            ---
---  Descripcion: Obtiene un registro de la tabla:  tbCotizacion                 ---
---                                                                              ---
------------------------------------------------------------------------------------
---    Fecha     Autor  Comentario                                               ---
---  ----------  -----  -------------------------------------------------------  ---
---  22/08/2011  RMM    Create procedure                                         ---
------------------------------------------------------------------------------------

CREATE PROCEDURE dbo.usp_tbPolizasEnc_UpdCA
(
	@intEmpresa		int,	
	@strPoliza		varchar(50),
	@datFecha		datetime	
)
WITH ENCRYPTION
AS
BEGIN
	SET NOCOUNT ON

		DECLARE @intAnio INT
		DECLARE @intMes INT
		DECLARE @intPoliza int
		DECLARE @dblCargos	decimal(18,2)
		DECLARE @dblAbonos	decimal(18,2)

		SET @intAnio = YEAR(@datFecha)     

		SELECT @dblCargos = SUM(CASE WHEN intTipoMovto = 0 THEN 0 ELSE dblImporte END), 
			   @dblAbonos = SUM(CASE WHEN intTipoMovto = 1 THEN 0 ELSE dblImporte END)
		FROM VetecMarfilAdmin..tbPolizasDet
	    WHERE intEmpresa = @intEmpresa
		AND	 strPoliza =  @strPoliza 
		AND intEjercicio = @intAnio    
						
		UPDATE VetecMarfilAdmin..tbPolizasEnc
		SET dblCargos = @dblCargos,
			dblAbonos = @dblAbonos	
		WHERE intEmpresa = @intEmpresa
		AND	 strPoliza =  @strPoliza 
		AND intEjercicio = @intAnio

		SELECT @strPoliza

	SET NOCOUNT OFF
END
GO 

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbPolizasEnc_UpdCA Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbPolizasEnc_UpdCA Error on Creation'
END
GO



