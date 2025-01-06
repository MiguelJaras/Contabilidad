

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbPolizas_Copiar')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbPolizas_Copiar
	PRINT N'Drop Procedure : dbo.usp_tbPolizas_Copiar - Succeeded !!!'
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

CREATE PROCEDURE dbo.usp_tbPolizas_Copiar
(
	@intEmpresa			int,	
	@strPolizaOriginal	varchar(50),	
	@intEjercicio		int,
	@datFecha			datetime,
	@strDescripcion		varchar(500),
	@strReferencia		varchar(20),
	@strUsuario			varchar(50),
	@strMaquina			varchar(50)
)
WITH ENCRYPTION
AS
BEGIN
	SET NOCOUNT ON

		DECLARE @intAnio INT
		DECLARE @intMes INT
		DECLARE @intPoliza int
		DECLARE @strTipoPoliza	varchar(50)
		DECLARE @strConcepto varchar(500)
		DECLARE @dblCargos decimal(18,2)
		DECLARE @dblAbonos decimal(18,2)
		DECLARE @strPoliza varchar(50)

		SET @intAnio = YEAR(@datFecha)
		SET @intMes = MONTH(@datFecha)	

		SELECT @strTipoPoliza = strTipoPoliza, @strConcepto = strDescripcion,@dblCargos = dblCargos, @dblAbonos = dblAbonos
		FROM VetecMarfilAdmin.dbo.tbPolizasEnc		
		WHERE intEmpresa = 	 @intEmpresa
		AND strPoliza =  @strPolizaOriginal
		AND intEjercicio = @intEjercicio
               				
		--FOLIO DE LA POLIZA                                             
		SET @intPoliza = (SELECT VetecMarfilAdmin.dbo.F_RegresaFolioPoliza(@intEmpresa, '0', @intAnio , @intMes , @strTipoPoliza , 0 ))                                                                                           

		IF(ISNULL(@intPoliza,0) = 0)
			SET @intPoliza = 1

		IF EXISTS(SELECT * FROM VetecMarfilAdmin.dbo.tbPolizasEnc WHERE intEmpresa = @intEmpresa AND strClasifEnc = '0' AND intEjercicio = @intAnio AND intMes = @intMes AND strTipoPoliza = @strTipoPoliza AND intFolioPoliza = @intPoliza)                                            
		BEGIN                                                       
			SET @intPoliza = @intPoliza + 1                                                                                                  
		END       
		                    
		--INCREMENTA EL FOLIO                                                    
		EXEC VetecMarfilAdmin.dbo.qryINCN2050_Upd_tbTiposPoliza @intEmpresa, '0', @intAnio, @intMes, @strTipoPoliza, @intPoliza                                                           

		SET @strPoliza = RIGHT('00'+ Rtrim(ltrim(@intMes)) , 2) + Right('   '+ Rtrim(ltrim(@strTipoPoliza)) , 3) +  Rtrim(Ltrim(Convert(Varchar(20), @intPoliza)))                                          
						
		INSERT INTO VetecMarfilAdmin..tbPolizasEnc(intEmpresa,strClasifEnc,intEjercicio,intMes,strPoliza,
		strTipoPoliza,intFolioPoliza,datFecha,intEstatus,strDescripcion,dblCargos,dblAbonos,intIndAfectada,
		intIndInterempresa,intIndRec,intIndGenRec,intEjercicioOr,intMesOr,strPolizaOr,intConFlujo,strAuditAlta,
		strAuditMod,dblTransmision,intCuentaBancaria,intCheque,intPartida,intCenCos,intTransferencia)  
		VALUES (@intEmpresa,'0',@intAnio,@intMes,@strPoliza,@strTipoPoliza,@intPoliza,@datFecha,3,@strDescripcion,
		@dblCargos,@dblAbonos,0,0,0,0,0,0,0,0,@strUsuario + ' ' + @strMaquina + ' ' + CONVERT(VARCHAR, GETDATE()),NULL,0,NULL,0,0,0,0)

		IF(@@Error = 0)
		BEGIN
			INSERT INTO VetecMarfilAdmin..tbPolizasDet(intEmpresa,strClasifEnc,intEjercicio,intMes,strPoliza,
			strTipoPoliza,intFolioPoliza,intPartida,datFecha,strClasifDP,strClasifDS,strCuenta,strCuentaOrig,
			intTipoMovto,dblImporte,intTipoMoneda,dblTipoCambio,dblImporteTipoMoneda,strReferencia,strDescripcion,
			intIndAfectada,strFactura,intFacConsec,intProveedor,intTipoConcepto,intConcepto,intCuentaBancaria,intCheque,
			intConciliado,intConcilFolio,strClaveRef,strFolioRef,strAuditAlta,strAuditMod,intTipoAux)
			SELECT @intEmpresa,strClasifEnc,@intAnio,@intMes,@strPoliza,
			strTipoPoliza,@intPoliza,intPartida,@datFecha,strClasifDP,strClasifDS,strCuenta,strCuentaOrig,
			intTipoMovto,dblImporte,intTipoMoneda,dblTipoCambio,dblImporteTipoMoneda,
			CASE WHEN @strReferencia = '' THEN strReferencia ELSE @strReferencia END,@strDescripcion,
			0,strFactura,intFacConsec,intProveedor,intTipoConcepto,intConcepto,intCuentaBancaria,intCheque,
			0,0,strClaveRef,strFolioRef,@strUsuario + ' ' + @strMaquina + ' ' + CONVERT(VARCHAR, GETDATE()),NULL,0
			FROM VetecMarfilAdmin..tbPolizasDet
			WHERE intEmpresa = @intEmpresa
			AND strPoliza = @strPolizaOriginal
			AND intEjercicio = @intEjercicio
		END

		SELECT @strPoliza

	SET NOCOUNT OFF
END
GO 

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbPolizas_Copiar Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbPolizas_Copiar Error on Creation'
END
GO



