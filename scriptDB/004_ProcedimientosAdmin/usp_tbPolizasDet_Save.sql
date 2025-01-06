

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbPolizasDet_Save')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbPolizasDet_Save
	PRINT N'Drop Procedure : dbo.usp_tbPolizasDet_Save - Succeeded !!!'
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
                               
CREATE PROCEDURE dbo.usp_tbPolizasDet_Save
(
	@intEmpresa		int,
	@strPoliza 		varchar(50),
	@strTipoPoliza	varchar(50),
	@datFecha		datetime,
	@intPartida		int,
	@strCuenta		varchar(50),
	@strAxiliar		varchar(100),
	@strObra		varchar(100),
	@strReferencia	varchar(200),
	@strConcepto	varchar(500),
	@dblCargos		decimal(18,2),
	@dblAbonos		decimal(18,2),
	@strUsuario		varchar(50),
	@strMaquina		varchar(50),
	@intConceptoPago int = 0
)
WITH ENCRYPTION
AS
BEGIN
	SET NOCOUNT ON

		DECLARE @intAnio INT
		DECLARE @intMes INT
		DECLARE @intPoliza INT
		DECLARE @intTipoMovto int
		DECLARE @Importe DECIMAL(18,2)
		DECLARE @Error VARCHAR(100)	
		DECLARE @strFolioFiscal VARCHAR(50)
		DECLARE @intSucursal INT
		DECLARE @intCliente INT
		DECLARE @intCarteraDet INT
		DECLARE @dblImporte DECIMAL(18,2)

		SET @intAnio = YEAR(@datFecha)
		SET @intMes = MONTH(@datFecha)	
		SET @intPoliza = convert(int,SUBSTRING(@strPoliza,6,LEN(@strPoliza)))

		IF EXISTS(SELECT * FROM tbPolizasDet WHERE intEmpresa = @intEmpresa AND intEjercicio = @intAnio and strPoliza = @strPoliza and intIndAfectada = 1)
		BEGIN
			SET @Error = 'No se puede modificar, la poliza esta afecta'
			RAISERROR(@Error,16,1)
			RETURN 
		END

		IF NOT EXISTS(SELECT * FROM tbCuentas WHERE intEmpresa = @intEmpresa AND strCuenta = @strCuenta)
		BEGIN
			SET @Error = 'La Cuenta No Existe: ' + @strCuenta
			RAISERROR(@Error,16,1)
			RETURN 
		END

		-----------------------------------VALIDA FACTURA--------------------------------------------		
		IF REPLACE(@strCuenta,'-','') = '21000001' AND @dblCargos > 0
		BEGIN
			DECLARE @intEstatus INT
			DECLARE @dblTotal FLOAT
			DECLARE @dblMontoSaldado FLOAT	
			DECLARE @dblMontoNC FLOAT			

			UPDATE FXP 
			SET FXP.intEstatus = 3, FXP.dblMontoSaldado = FXP.dblMontoSaldado - @dblCargos
			FROM tbFacXP FXP
			WHERE FXP.intEmpresa = @intEmpresa
			AND FXP.intProveedor = CONVERT(INT, @strAxiliar)
			AND FXP.strFactura = @strReferencia

			SELECT  @intEstatus = FXP.intEstatus,
					@dblTotal = FXP.dblTotal
			FROM tbFacXP FXP
			WHERE FXP.intEmpresa = @intEmpresa
			AND FXP.intProveedor = CONVERT(INT, @strAxiliar)
			AND FXP.strFactura = @strReferencia
				
			SELECT @dblMontoSaldado = ABS(SUM(CASE WHEN M.strNaturaleza = 'A' THEN F.dblMonto * -1 ELSE F.dblMonto END))
			FROM tbFacXPDet F
			INNER JOIN tbTipoMovto M ON M.intEmpresa = F.intEmpresa AND M.intMovto = F.intTipoMovto
			WHERE F.intEmpresa = @intEmpresa
			AND F.intProveedor = CONVERT(INT, @strAxiliar)
			AND F.strFactura = @strReferencia

			SELECT @dblMontoNC = ABS(SUM(CASE WHEN M.strNaturaleza = 'A' THEN F.dblMonto * -1 ELSE F.dblMonto END))
			FROM tbFacXPDet F
			INNER JOIN tbTipoMovto M ON M.intEmpresa = F.intEmpresa AND M.intMovto = F.intTipoMovto
			WHERE F.intEmpresa = @intEmpresa
			AND F.intProveedor = CONVERT(INT, @strAxiliar)
			AND CASE WHEN F.strFolioFiscal = '' THEN F.strFactura ELSE F.strFolioFiscal END = @strReferencia
			AND F.strReferencia = @strPoliza
		
			IF @intEstatus IS NULL AND @dblMontoNC IS NULL
			BEGIN
				SET @Error = 'Factura No Existe: ' + @strReferencia
				RAISERROR(@Error,16,1)
				RETURN 
			END	
			
			IF @intEstatus = 5 			
			BEGIN
				SET @Error = 'Factura Liquidada: #' + LTrim(Rtrim(@strReferencia)) + ' del Proveedor: ' + @strAxiliar
				RAISERROR(@Error,16,1)
				RETURN 
			END	
			
			IF (@dblTotal + @dblMontoNC - @dblCargos - ISNULL(@dblMontoSaldado,0)) < 0
			BEGIN
				SET @Error =  'Factura excede su Pago: #' + LTrim(Rtrim(@strReferencia)) + ' del Proveedor: ' + @strAxiliar + ' con Valor de: ' + CONVERT(VARCHAR, CONVERT(MONEY, @dblTotal))
				RAISERROR(@Error,16,1)
				RETURN 
			END	
		END
		-----------------------------------------------------------------------------------------------------------

		IF EXISTS(SELECT * FROM tbCuentas C WHERE C.intEmpresa = @intEmpresa AND C.strCuenta = @strCuenta AND intCtaRegistro = 0)
		BEGIN
			SET @Error =  'La Cuenta no es Capturable! : '+ @strCuenta
			RAISERROR(@Error,16,1)
			RETURN 
		END

		IF(@dblAbonos > 0 AND @dblCargos = 0)
		BEGIN
			SET	@intTipoMovto = 0
			SET @Importe = @dblAbonos
		END
		ELSE
		BEGIN
		    SET	@intTipoMovto = 1
			SET @Importe = @dblCargos
		END

		IF(ISNULL(@strAxiliar,'') = '')
			SET @strAxiliar = '0'

		IF NOT EXISTS(SELECT 1 FROM VetecMarfilAdmin..tbPolizasDet WHERE intEmpresa = @intEmpresa AND strPoliza = @strPoliza 
		AND intEjercicio = @intAnio AND intPartida = @intPartida)
		BEGIN			
			SELECT @intMes = intMes,@datFecha = datFecha FROM VetecMarfilAdmin..tbPolizasEnc 
			WHERE intEmpresa = @intEmpresa AND strPoliza = @strPoliza AND intEjercicio = @intAnio
			
			SELECT @intPartida = ISNULL(MAX(intPartida) + 1,1) FROM VetecMarfilAdmin..tbPolizasDet 
			WHERE intEmpresa = @intEmpresa AND strPoliza = @strPoliza AND intEjercicio = @intAnio

			INSERT INTO VetecMarfilAdmin..tbPolizasDet(intEmpresa,strClasifEnc,intEjercicio,intMes,strPoliza,
			strTipoPoliza,intFolioPoliza,intPartida,datFecha,strClasifDP,strClasifDS,strCuenta,strCuentaOrig,
			intTipoMovto,dblImporte,intTipoMoneda,dblTipoCambio,dblImporteTipoMoneda,strReferencia,strDescripcion,
			intIndAfectada,strFactura,intFacConsec,intProveedor,intTipoConcepto,intConcepto,intCuentaBancaria,intCheque,
			intConciliado,intConcilFolio,strClaveRef,strFolioRef,strAuditAlta,strAuditMod,intTipoAux)
			VALUES(@intEmpresa,'0',@intAnio,@intMes,@strPoliza,@strTipoPoliza,@intPoliza,@intPartida,@datFecha,
			@strAxiliar,@strObra,@strCuenta,NULL,@intTipoMovto,@Importe,1,1,
			@Importe,@strReferencia,@strConcepto,0,0,0,0,NULL, NULL, NULL, 0, 0, NULL, NULL, NULL, 
			@strUsuario + ' ' + @strMaquina + ' /SEM/ ' +CONVERT(VARCHAR, GETDATE()), NULL, NULL)
		END
		ELSE
		BEGIN
			IF NOT EXISTS(SELECT 1 FROM VetecMarfilAdmin.dbo.tbConciliaciones CC WHERE CC.intPartida = @intPartida AND CC.strPoliza = @strPoliza AND CC.intEmpresa = @intEmpresa AND CC.intEjercicio = @intAnio AND CC.intMes = @intMes)
			BEGIN		
				UPDATE VetecMarfilAdmin..tbPolizasDet
				SET strClasifDP = @strAxiliar,
					strClasifDS = @strObra,
					strCuenta = @strCuenta,
					intTipoMovto = @intTipoMovto,
					dblImporte = @Importe,
					dblImporteTipoMoneda = @Importe,
					strReferencia = @strReferencia,
					strDescripcion = @strConcepto,
					strAuditMod = @strUsuario + ' ' + @strMaquina + ' /SEM/ ' +CONVERT(VARCHAR, GETDATE())
				WHERE intEmpresa = @intEmpresa 
				AND strPoliza = @strPoliza 
				AND intEjercicio = @intAnio 
				AND intPartida = @intPartida
			END

			--Actualizamos Cartera
			IF(@intEmpresa IN(2,3,6))
			BEGIN
				EXEC VetecMarfil.dbo.usp_tbPolizas_Cartera @intEmpresa, @strPoliza,@strReferencia,@strAxiliar,@Importe
			END
		END

		IF NOT EXISTS(SELECT 1 FROM tbCuentasSaldos WHERE intEmpresa = @intEmpresa AND intEjercicio = @intAnio AND 
		strCuenta = @strCuenta AND strClasifDP = @strAxiliar AND strClasifDS = @strObra)
		BEGIN
			INSERT INTO tbCuentasSaldos(intEmpresa,intEjercicio,strCuenta,strClasifEnc,strClasifDP,strClasifDS,
			intIndInterEmpresa,intTipoMoneda,dblSaldoInicial,dblCargo01,dblAbono01,dblCargo02,dblAbono02,dblCargo03,
			dblAbono03,dblCargo04,dblAbono04,dblCargo05,dblAbono05,dblCargo06,dblAbono06,dblCargo07,dblAbono07,dblCargo08,
			dblAbono08,dblCargo09,dblAbono09,dblCargo10,dblAbono10,dblCargo11,dblAbono11,dblCargo12,dblAbono12, 
			datFechaAlta,strUsuarioAlta,strMaquinaAlta)       
			VALUES(@intEmpresa,@intAnio,@strCuenta,'0',@strAxiliar,@strObra,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
			0,0,0,0,GETDATE(),@strUsuario,@strMaquina)
		END		

		SELECT @strFolioFiscal = strFolioFactura FROM tbFacXP WHERE intEmpresa = @intEmpresa 
		AND intProveedor = CONVERT(INT,@strAxiliar) AND strFactura = @strReferencia

		IF ((@strTipoPoliza = '03' OR @strTipoPoliza = '0A' OR @strTipoPoliza = '0B' OR @strTipoPoliza = '07') AND (@strCuenta = '21000001') AND (@intTipoMovto = 1))
		BEGIN
			CREATE TABLE #Pagos(intRegistro INT IDENTITY(1,1), intEmpresa INT, intProveedor INT, strFactura VARCHAR(100) COLLATE SQL_Latin1_General_CP1_CI_AS, intTipoMovto INT, strDescripcion VARCHAR(250), strReferencia VARCHAR(250) COLLATE SQL_Latin1_General_CP1_CI_AS, dblMonto FLOAT, datFecha DATETIME)
			DECLARE @Rows INT
			DECLARE @Count INT
			DECLARE @intCuentaBancaria INT

			SET @Count = 0
			
			IF @strTipoPoliza = '0A' SET @intCuentaBancaria = 101
			IF @strTipoPoliza = '0B' SET @intCuentaBancaria = 201		

			IF(@strAxiliar IS NOT NULL AND @strAxiliar <> '0' AND @strCuenta = '21000001')
			BEGIN
				INSERT INTO #Pagos(intEmpresa,intProveedor,strFactura,intTipoMovto,strDescripcion,strReferencia,dblMonto,datFecha)
				VALUES(@intEmpresa,CONVERT(INT,@strAxiliar),@strReferencia,51,@strConcepto,@strPoliza,@Importe,@datFecha)
			END
			
			SELECT @Rows = COUNT(*) FROM #Pagos
			
			IF @Rows > 0 
			BEGIN
				--ELIMINAMOS LOS PAGOS QUE SE HALLAN REALIZADO CON LA POLIZA, VALIDANDO LA FECHA_ LA FECHA DE MOVIMIENTO DEBE DE SER LA FECHA DE LA POLIZA
--				DELETE FROM VetecMarfilAdmin..tbFacXPDet
--				WHERE strReferencia = @strPoliza
--				AND datFechaMovimiento = @datFecha
--				AND intEmpresa = @intEmpresa 

				IF @strTipoPoliza = '0A' OR @strTipoPoliza = '0B'
				BEGIN
					INSERT INTO VetecMarfilAdmin..tbFacXPDet(intEmpresa,intProveedor,strFactura,intTipoMovto,
					strDescripcion,strReferencia,dblMonto,intTipoMoneda,intCuentaBancaria,strUsuario,strMaquina,
					datFecha,datFechaMovimiento,datFechaVencimiento,lngConsecutivoPago,intEjercicioPol,strNC,
					strFolio,intPartida,strFolioFiscal)
					SELECT P.intEmpresa, P.intProveedor, P.strFactura, P.intTipoMovto, 'CH: ' + CONVERT(VARCHAR, @intPoliza) + SPACE(1) + P.strDescripcion, P.strReferencia, P.dblMonto, 1, ISNULL(@intCuentaBancaria,@strTipoPoliza), @strUsuario, @strMaquina, GETDATE(), @datFecha, @datFecha, null, @intAnio,'','',0,@strFolioFiscal
					FROM #Pagos P
				END
				ELSE
				BEGIN
					IF @strConcepto LIKE 'NC%' OR @strConcepto LIKE 'N.C.%'
					BEGIN
						INSERT INTO VetecMarfilAdmin..tbFacXPDet(intEmpresa,intProveedor,strFactura,intTipoMovto,
						strDescripcion,strReferencia,dblMonto,intTipoMoneda,intCuentaBancaria,strUsuario,strMaquina,
						datFecha,datFechaMovimiento,datFechaVencimiento,lngConsecutivoPago,intEjercicioPol,strNC,
						strFolio,intPartida,strFolioFiscal)
						SELECT P.intEmpresa, P.intProveedor, P.strFactura, 31, P.strDescripcion, P.strReferencia, P.dblMonto, 1, ISNULL(@intCuentaBancaria,@strTipoPoliza), @strUsuario, @strMaquina, GETDATE(), @datFecha, @datFecha, null, @intAnio,'','',0,@strFolioFiscal
						FROM #Pagos P
					END
					ELSE
					BEGIN
						INSERT INTO VetecMarfilAdmin..tbFacXPDet(intEmpresa,intProveedor,strFactura,intTipoMovto,
						strDescripcion,strReferencia,dblMonto,intTipoMoneda,intCuentaBancaria,strUsuario,strMaquina,
						datFecha,datFechaMovimiento,datFechaVencimiento,lngConsecutivoPago,intEjercicioPol,strNC,
						strFolio,intPartida,strFolioFiscal)
						SELECT P.intEmpresa, P.intProveedor, P.strFactura, P.intTipoMovto, P.strDescripcion, P.strReferencia, P.dblMonto, 1, ISNULL(@intCuentaBancaria,@strTipoPoliza), @strUsuario, @strMaquina, GETDATE(), @datFecha, @datFecha, null, @intAnio,'','',@intPartida,@strFolioFiscal
						FROM #Pagos P
					END
				END
			END

			DROP TABLE #Pagos
		END

		IF (@strTipoPoliza = '03' AND LEFT(@strCuenta,8) = '21000001' AND @intTipoMovto = 0)
		BEGIN			
			INSERT INTO VetecMarfilAdmin..tbFacXPDet(intEmpresa,intProveedor,strFactura,intTipoMovto,
			strDescripcion,strReferencia,dblMonto,intTipoMoneda,intCuentaBancaria,strUsuario,strMaquina,
			datFecha,datFechaMovimiento,datFechaVencimiento,lngConsecutivoPago,intEjercicioPol,strNC,
			strFolio,intPartida,strFolioFiscal)
			SELECT @intEmpresa,CONVERT(INT,@strAxiliar),@strReferencia,51,@strConcepto,@strPoliza,@Importe,1,ISNULL(@intCuentaBancaria,@strTipoPoliza), @strUsuario, @strMaquina, GETDATE(), @datFecha, @datFecha, null, @intAnio,'','',@intPartida,@strFolioFiscal
		END


		IF (@strTipoPoliza = '08' AND @intConceptoPago > 0)
		BEGIN							
				SELECT @intSucursal = intSucursal FROM VetecMarfil..tbSucursales WHERE intEmpresa = @intEmpresa
				SELECT @intCliente = intCliente FROM VetecMarfil..tbClientes WHERE intEmpresa = @intEmpresa AND strClave = @strAxiliar
				SELECT @intCarteraDet = intCarteraDet FROM VetecMarfil..tbCarteraDet WHERE intEmpresa = @intEmpresa AND intCliente = @intCliente AND intFactura = @strReferencia
				SET @dblImporte = CASE WHEN @dblAbonos > 0 THEN @dblAbonos * -1 ELSE @dblCargos END
				
				--DELETE FROM VetecMarfil..tbCarteraMovimientoDet WHERE intCarteraDet = @intCarteraDet AND strPoliza = @strPoliza AND YEAR(datFechaVencimiento) = @intAnio AND intTipoMovimiento = @intConceptoPago				
				IF(@intConceptoPago = 70)
				BEGIN
					SET @dblImporte = ABS(@dblImporte)	
				END
				
				INSERT INTO VetecMarfil..tbCarteraMovimientoDet(intCarteraDet,intTipoMovimiento,dblImporte,intTipoMoneda,intTipoCambio,datFechaVencimiento,datFechaContable,strDescripcionCT,intCarteraMovimientoPago,strPoliza)
				VALUES(@intCarteraDet,@intConceptoPago,@dblImporte,1,1,@datFecha,@datFecha,@strConcepto,0,@strPoliza)				 

				EXEC VetecMarfil..usp_CarteraDet_ActSaldo @intEmpresa,@intCliente						
		END

		SELECT @strPoliza

	SET NOCOUNT OFF
END
GO 

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbPolizasDet_Save Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbPolizasDet_Save Error on Creation'
END
GO



