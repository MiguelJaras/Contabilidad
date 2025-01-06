

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbPolizasEnc_Delete')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbPolizasEnc_Delete
	PRINT N'Drop Procedure : dbo.usp_tbPolizasEnc_Delete - Succeeded !!!'
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

CREATE PROCEDURE dbo.usp_tbPolizasEnc_Delete
(
	@intEmpresa		int,
	@strPoliza 		varchar(50),
	@intEjercicio	int,
	@strUsuario		varchar(50),
	@strMaquina		varchar(50)
)
WITH ENCRYPTION
AS
BEGIN
	SET NOCOUNT ON

	DECLARE @strFactura VARCHAR(100)
	DECLARE @intEstatus int
	DECLARE @strTipoPoliza VARCHAR(20)
	DECLARE @intMes int
	DECLARE @intFolioPoliza int  

	SELECT @strTipoPoliza = strTipoPoliza,@intMes = intMes,@intFolioPoliza = intFolioPoliza
	FROM VetecMarfilAdmin.dbo.tbPolizasEnc 
	WHERE strPoliza = @strPoliza AND intEmpresa = @intEmpresa AND intEjercicio = @intEjercicio

	IF EXISTS(SELECT 1 FROM VetecMarfil..tbCerrarPeriodo WHERE intEmpresa = @intEmpresa and intEjercicio = @intEjercicio
	AND intMes = @intMes AND intModulo = 1 AND bCerrado = 1)
	BEGIN
		RAISERROR('No se puede eliminar, el mes esta cerrado.',16,1)
		RETURN
	END

	IF EXISTS(SELECT * FROM tbPolizasDet WHERE intEmpresa = @intEmpresa AND intEjercicio = @intEjercicio and strPoliza = @strPoliza
	AND intIndAfectada = 1)
	BEGIN
		RAISERROR('No se puede eliminar, la poliza esta afectada.',16,1)
		RETURN;
	END

	--Proveedores
	SELECT @strFactura = strFactura, @intEstatus = intEstatus
	FROM tbFacXP 
	WHERE intEmpresa = @intEmpresa AND year(datFechaFac) = @intEjercicio and strPolProv = @strPoliza

	IF(@strFactura IS NOT NULL AND @strFactura <> '')
	BEGIN
		IF (@intEstatus > 3)
		BEGIN
			RAISERROR('No se puede elimina, la factura de la poliza esta pagada.',16,1)
			RETURN;
		END
		ELSE
		BEGIN
			DELETE FROM tbFacXP WHERE intEmpresa = @intEmpresa AND year(datFechaFac) = @intEjercicio and strPolProv = @strPoliza
		END
	END

	------
	IF(@strTipoPoliza = '08')
	BEGIN
		DELETE FROM VetecMarfil..tbCarteraMovimientoDet WHERE intCarteraMovimientoDet in(
		SELECT intCarteraMovimientoDet FROM VetecMarfil..tbCarteraMovimientoDet CD
		INNER JOIN VetecMarfil..tbCarteraDet C ON C.intCarteraDet = CD.intCarteraDet
		INNER JOIN VetecMarfilAdmin.dbo.tbPolizasDet P ON P.intEjercicio = YEAR(CD.datFechaContable) AND P.strPoliza = CD.strPoliza collate SQL_Latin1_General_CP1_CI_AS AND P.strReferencia = CONVERT(VARCHAR,C.intFactura)
		WHERE P.intEmpresa = @intEmpresa AND P.intEjercicio = @intEjercicio AND P.strPoliza = @strPoliza)
	END	
		
	IF NOT EXISTS(SELECT * FROM VetecMarfilAdmin.dbo.tbPolizasEnc WHERE intEmpresa = @intEmpresa 
	AND intEjercicio = @intEjercicio and strTipoPoliza = @strTipoPoliza and intMes = @intMes
	AND intFolioPoliza > @intFolioPoliza)
	BEGIN
		SET @intFolioPoliza = @intFolioPoliza - 1
		EXEC usp_tbTiposPoliza_Save @intEmpresa,@intEjercicio,@strTipoPoliza,@intMes,@intFolioPoliza    

		DELETE FROM VetecMarfilAdmin.dbo.tbPolizasDet 
		WHERE strPoliza = @strPoliza AND intEmpresa = @intEmpresa and intEjercicio = @intEjercicio

		DELETE FROM VetecMarfilAdmin.dbo.tbPolizasEnc 
		WHERE strPoliza = @strPoliza AND intEmpresa = @intEmpresa AND intEjercicio = @intEjercicio
	END
	ELSE
	BEGIN
		UPDATE VetecMarfilAdmin.dbo.tbPolizasDet 
		SET dblImporte = 0
		WHERE strPoliza = @strPoliza AND intEmpresa = @intEmpresa and intEjercicio = @intEjercicio

		UPDATE VetecMarfilAdmin.dbo.tbPolizasEnc 
		SET intEstatus = 9, strDescripcion = 'CANCELADA', dblCargos = 0, dblAbonos = 0
		WHERE strPoliza = @strPoliza 
		AND intEmpresa = @intEmpresa 
		AND intEjercicio = @intEjercicio
	END
		
	SELECT @strPoliza

	SET NOCOUNT OFF
END
GO 

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbPolizasEnc_Delete Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbPolizasEnc_Delete Error on Creation'
END
GO



