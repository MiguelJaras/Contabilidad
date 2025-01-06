/****** Object:  StoredProcedure [dbo.usp_tbPolizas_Invetario]    Script Date: 12/8/2009 10:45:19 AM ******/
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbPolizas_Invetario')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbPolizas_Invetario
	PRINT N'Drop Procedure : dbo.usp_tbPolizas_Invetario - Succeeded !!!'
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

CREATE PROCEDURE dbo.usp_tbPolizas_Invetario
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
			@intNumero			int,
			@strCuentaCargo		varchar(100),
			@strCuentaAbono		varchar(100),
			@dblImporte			decimal(18,2),
			@intFolio			int,
			@strPoliza			varchar(50),
			@strTipoPoliza		varchar(50),
			@strInsumo			varchar(50),
			@intPoliza			varchar(50),
			@intObra			int,
			@intArea			int,
			@intProveedor		varchar(50),
			@strProveedor		varchar(300),
			@dblSUM				decimal(18,2),
			@Row				int,
			@strPolizas			VARCHAR(100),
			@Fecha				datetime,
			@strFecha			datetime,	
			@strFechaInicial	datetime,	
			@strFechaSiguiente	datetime,
			@strFechaAnt		datetime,
			@strFechaAnt10		datetime,
			@Data				VARCHAR(1000),
			@Error				VARCHAR(2000)


	SET @strTipoPoliza = '06'
	SET @strPolizas = ''

	SET @strFechaInicial = '01-' + CONVERT(VARCHAR,(@intMes)) + '-' + CONVERT(VARCHAR,@intEjercicio)				
	SET @strFechaSiguiente = dateadd(MONTH,1,@strFechaInicial)
	SET @strFecha = dateadd(DAY,1,@strFechaSiguiente) - 2
	SET @strFechaAnt = @strFechaInicial - 1
	SET @strFechaAnt10 = @strFechaAnt - 9

	CREATE TABLE #Data(intEmpresa int, intFolio int,intObra int, intProveedor int, intOrdenCompraDet int, intArticulo int, strClave varchar(100), 
	intInventario int, dblCantidad decimal(18,6), dblImporte decimal(18,6), intArea int, intNumero int)

	CREATE TABLE #NoInventariable(id int identity(1,1),strCuentaCargo VARCHAR(30),strCuentaAbono VARCHAR(30), intFolio int, intObra int, intProveedor int, dblImporte DECIMAL(18,2), strInsumo VARCHAR(50), intArea int, intNumero int)
	CREATE TABLE #InventariableEntrada(id int identity(1,1),strCuentaCargo VARCHAR(30),strCuentaAbono VARCHAR(30), intFolio int, intObra int, intProveedor int, dblImporte DECIMAL(18,2), strInsumo VARCHAR(50),intArea int, intNumero int)
	CREATE TABLE #InventariableSalida(id int identity(1,1),strCuentaCargo VARCHAR(30),strCuentaAbono VARCHAR(30), intFolio int, intObra int, intProveedor int, dblImporte DECIMAL(18,2), strInsumo VARCHAR(50), intArea int, intNumero int)
	CREATE TABLE #NotCuenta(strClave varchar(10), intArea varchar(10))

	BEGIN TRY
	BEGIN TRANSACTION tbPolizas_Invetario 

		--Entrada S/N Facturas
		UPDATE E
		SET E.datFecha = @strFechaSiguiente
		FROM tbEntradaCompras E
		INNER JOIN tbOrdenCompraEnc OC on OC.intOrdenCompraEnc = E.intOrdenCompraEnc
		WHERE OC.intEmpresa = @intEmpresa and E.datFecha BETWEEN @strFechaInicial and @strFecha
		AND CONVERT(VARCHAR,OC.intFolio) NOT IN(SELECT XP.strFolio FROM VetecMarfilAdmin..tbFacXP XP WHERE intEmpresa = @intEmpresa AND XP.datFechaFac BETWEEN @strFechaInicial and @strFecha)
		AND OC.intProveedor NOT BETWEEN 4000 AND 4099
		AND ISNULL(E.strPoliza,'') = ''

		--Facturas S/N Entrada
		UPDATE E
		SET E.datFecha = @strFechaInicial
		FROM tbEntradaCompras E
		INNER JOIN tbOrdenCompraEnc OC on OC.intOrdenCompraEnc = E.intOrdenCompraEnc
		WHERE OC.intEmpresa = @intEmpresa and E.datFecha > @strFecha
		AND CONVERT(VARCHAR,OC.intFolio) IN(SELECT XP.strFolio FROM VetecMarfilAdmin..tbFacXP XP WHERE intEmpresa = @intEmpresa AND XP.datFechaFac BETWEEN @strFechaInicial and @strFecha)
		AND OC.intProveedor NOT BETWEEN 4000 AND 4099
		AND ISNULL(E.strPoliza,'') = ''

--		--Facturas S/N Entrada del mes anterior
		UPDATE E
		SET E.datFecha = @strFechaInicial
		FROM vetecmarfil..tbEntradaCompras E
		INNER JOIN vetecmarfil..tbOrdenCompraEnc OC on OC.intOrdenCompraEnc = E.intOrdenCompraEnc
		WHERE OC.intEmpresa = @intEmpresa AND E.datFecha BETWEEN @strFechaAnt10 AND @strFechaAnt
		AND OC.intFolio IN(SELECT CONVERT(INT,XP.strFolio) FROM VetecMarfilAdmin..tbFacXP XP WHERE intEmpresa = @intEmpresa AND XP.datFechaFac BETWEEN @strFechaInicial AND @strFecha)
		AND OC.intProveedor NOT BETWEEN 4000 AND 4099
		AND ISNULL(E.strPoliza,'') = ''

		INSERT INTO #Data(intEmpresa,intFolio,intObra,intProveedor,intOrdenCompraDet,intArticulo,strClave,intInventario,dblCantidad,dblImporte, intArea,intNumero)
		SELECT E.intEmpresa, OC.intFolio,OC.intObra,OC.intProveedor,E.intOrdenCompraDet, D.intArticulo, A.strNombreCorto, CASE WHEN LEFT(A.strNombreCorto,1) IN('4','6','3','5') THEN 0 ELSE CASE WHEN LEFT(A.strNombreCorto,1) = 1 THEN 1 ELSE NULL END END, SUM(E.dblCantidad), 
		SUM(E.dblCantidad * D.dblPrecio * ISNULL(OC.dblTipoCambio,1)), CONVERT(INT,LEFT(O.strClave,2)),E.intNumero
		FROM dbo.tbEntradaCompras E
		INNER JOIN tbOrdenCompraDet D ON D.intOrdenCompraDet = E.intOrdenCompraDet AND D.intEmpresa = E.intEmpresa
		INNER JOIN tbOrdenCompraEnc OC ON OC.intOrdenCompraEnc = D.intOrdenCompraEnc AND OC.intEmpresa = E.intEmpresa
		INNER JOIN tbArticulo A ON A.intArticulo = D.intArticulo AND A.intEmpresa = D.intEmpresa
		INNER JOIN tbObra O ON O.intObra = OC.intObra		
		WHERE  E.intEmpresa = @intEmpresa
		AND YEAR(E.datFecha) = @intEjercicio
		AND MONTH(E.datFecha) = @intMes
		AND E.intEstatus <> 9
		AND ISNULL(E.strPoliza,'') = ''
		GROUP BY E.intEmpresa, OC.intFolio, OC.intObra,OC.intProveedor, E.intOrdenCompraDet, D.intArticulo,A.strNombreCorto, A.intFamilia,O.strClave,E.intNumero

		DELETE FROM #Data where intInventario IS NULL
		DELETE FROM #Data where dblImporte = 0

		INSERT INTO #NotCuenta(strClave,intArea)
		SELECT strClave,D.intArea
		FROM #Data D
		WHERE intInventario = 0
		EXCEPT
		SELECT strClave,D.intArea
		FROM #Data D
		INNER JOIN VetecMarfilAdmin..tbCuentasRet R ON R.intEmpresa = D.intEmpresa
		WHERE D.strClave COLLATE SQL_Latin1_General_CP1_CI_AS BETWEEN R.strInsumoIni AND strInsumoFin AND D.intArea = R.intArea
		AND intInventario = 0

		SELECT @Data = COALESCE(@Data,'') + strClave + ':Area ' + intArea + ','  from #NotCuenta
		
		IF(ISNULL(@Data,'') <> '')
		BEGIN
			SET @Error = 'Cuentas no cargadas NO INVENTARIABLES:' + @Data + '.  Revisar asignacion cuentas.'
			RAISERROR (@Error,16,1);
			RETURN;
		END

		DELETE FROM #NotCuenta
		SET @Data = ''		

		INSERT INTO #NotCuenta(strClave,intArea)
		SELECT strClave,D.intArea
		FROM #Data D
		WHERE intInventario = 1
		EXCEPT
		SELECT strClave,D.intArea
		FROM #Data D
		INNER JOIN VetecMarfilAdmin..tbCuentasRet R ON R.intEmpresa = D.intEmpresa
		WHERE D.strClave COLLATE SQL_Latin1_General_CP1_CI_AS BETWEEN R.strInsumoIni AND strInsumoFin AND D.intArea = R.intArea
		AND intInventario = 1
		AND R.intEs = 1

		SELECT @Data = COALESCE(@Data,'') + strClave + ':Area ' + intArea + ','  from #NotCuenta
		
		IF(ISNULL(@Data,'') <> '')
		BEGIN
			SET @Error = 'Cuentas no cargadas INVENTARIABLES ENTRADA:' + @Data + '.  Revisar asignacion cuentas.'
			RAISERROR (@Error,16,1);
			RETURN;
		END

		DELETE FROM #NotCuenta
		SET @Data = ''

		INSERT INTO #NotCuenta(strClave,intArea)
		SELECT strClave,D.intArea
		FROM #Data D
		WHERE intInventario = 1
		EXCEPT
		SELECT strClave,D.intArea
		FROM #Data D
		INNER JOIN VetecMarfilAdmin..tbCuentasRet R ON R.intEmpresa = D.intEmpresa
		WHERE D.strClave COLLATE SQL_Latin1_General_CP1_CI_AS BETWEEN R.strInsumoIni AND strInsumoFin AND D.intArea = R.intArea
		AND intInventario = 1
		AND R.intEs = 0

		SELECT @Data = COALESCE(@Data,'') + strClave + ':Area ' + intArea + ','  from #NotCuenta
		
		IF(ISNULL(@Data,'') <> '')
		BEGIN
			SET @Error = 'Cuentas no cargadas INVENTARIABLES SALIDA:' + @Data + '. Revisar asignacion cuentas.'
			RAISERROR (@Error,16,1);
			RETURN;
		END
		
		INSERT INTO #NoInventariable(strCuentaCargo,strCuentaAbono,dblImporte,intFolio,intObra,intProveedor,strInsumo,intArea,intNumero)
		SELECT CASE WHEN D.intObra IN(2601,2602,2603) THEN REPLACE(REPLACE(R.strCuentaCargo,'-',''),'4130','4145') ELSE REPLACE(R.strCuentaCargo,'-','') END, REPLACE(R.strCuentaAbono,'-',''), SUM(D.dblImporte), D.intFolio, D.intObra,D.intProveedor, D.strClave, D.intArea,D.intNumero
		FROM #Data D
		INNER JOIN VetecMarfilAdmin..tbCuentasRet R ON R.intEmpresa = D.intEmpresa
		WHERE D.strClave COLLATE SQL_Latin1_General_CP1_CI_AS BETWEEN R.strInsumoIni AND strInsumoFin AND D.intArea = R.intArea
		AND intInventario = 0
		GROUP BY REPLACE(R.strCuentaCargo,'-',''), REPLACE(R.strCuentaAbono,'-',''), D.intFolio, D.intObra,D.intProveedor,D.strClave,D.intArea,D.intNumero

		INSERT INTO #InventariableEntrada(strCuentaCargo,strCuentaAbono,dblImporte,intFolio,intObra,intProveedor,strInsumo,intArea,intNumero)
		SELECT REPLACE(R.strCuentaCargo,'-',''), REPLACE(R.strCuentaAbono,'-',''), SUM(D.dblImporte), D.intFolio, D.intObra,D.intProveedor, D.strClave, D.intArea,D.intNumero
		FROM #Data D
		INNER JOIN VetecMarfilAdmin..tbCuentasRet R ON R.intEmpresa = D.intEmpresa
		WHERE D.strClave COLLATE SQL_Latin1_General_CP1_CI_AS BETWEEN R.strInsumoIni AND strInsumoFin AND D.intArea = R.intArea
		AND intInventario = 1
		AND R.intEs = 1
		GROUP BY REPLACE(R.strCuentaCargo,'-',''), REPLACE(R.strCuentaAbono,'-',''), D.intFolio, D.intObra,D.intProveedor,D.strClave,D.intArea,D.intNumero
		
		INSERT INTO #InventariableSalida(strCuentaCargo,strCuentaAbono,dblImporte,intFolio,intObra,intProveedor,strInsumo,intArea,intNumero)
		SELECT CASE WHEN D.intObra IN(2601,2602,2603) THEN REPLACE(REPLACE(R.strCuentaCargo,'-',''),'4130','4145') ELSE REPLACE(R.strCuentaCargo,'-','') END, REPLACE(R.strCuentaAbono,'-',''), SUM(D.dblImporte), D.intFolio, D.intObra,D.intProveedor, D.strClave ,D.intArea,D.intNumero
		FROM #Data D
		INNER JOIN VetecMarfilAdmin..tbCuentasRet R ON R.intEmpresa = D.intEmpresa
		WHERE D.strClave COLLATE SQL_Latin1_General_CP1_CI_AS BETWEEN R.strInsumoIni AND strInsumoFin AND D.intArea = R.intArea
		AND intInventario = 1
		AND R.intEs = 0
		AND ((@intEmpresa = 1) OR (D.strClave NOT IN('1040065','1180020','1240020','1280020','1780065')))
		AND ((@intEmpresa = 1) OR (D.intArea NOT IN(20)))
		GROUP BY REPLACE(R.strCuentaCargo,'-',''), REPLACE(R.strCuentaAbono,'-',''), D.intFolio, D.intObra,D.intProveedor,D.strClave,D.intArea,D.intNumero

		--****NO INVENTARIABLES
		SET	@Count = 0
		SET @Row = 0
		SELECT @Rows = COUNT(*) FROM #NoInventariable
		SELECT @dblSUM = SUM(ABS(dblImporte)) FROM #NoInventariable
		
		--FOLIO DE LA POLIZA                                             
		SET @intPoliza = (SELECT VetecMarfilAdmin.dbo.F_RegresaFolioPoliza(@intEmpresa, '0', @intEjercicio , @intMes , @strTipoPoliza , 0 ) + 1 )                                                                                           

		WHILE( EXISTS(SELECT * FROM VetecMarfilAdmin.dbo.tbPolizasEnc WHERE intEmpresa = @intEmpresa AND strClasifEnc = '0' AND intEjercicio = @intEjercicio AND intMes = @intMes AND strTipoPoliza = @strTipoPoliza AND intFolioPoliza = @intPoliza) )
		BEGIN                                                       
			SET @intPoliza = @intPoliza + 1                                                                                                  
		END                    
			                    	
		SET @strPoliza = RIGHT('00'+ Rtrim(ltrim(@intMes)) , 2) + Right('   '+ Rtrim(ltrim(@strTipoPoliza)) , 3) +  Rtrim(Ltrim(Convert(Varchar(20), @intPoliza)))                                          

		IF(@Rows > 0)
		BEGIN
			INSERT INTO VetecMarfilAdmin..tbPolizasEnc(intEmpresa,strClasifEnc,intEjercicio,intMes,strPoliza,
			strTipoPoliza,intFolioPoliza,datFecha,intEstatus,strDescripcion,dblCargos,dblAbonos,intIndAfectada,
			intIndInterempresa,intIndRec,intIndGenRec,intEjercicioOr,intMesOr,strPolizaOr,intConFlujo,strAuditAlta,
			strAuditMod,dblTransmision,intCuentaBancaria,intCheque,intPartida,intCenCos,intTransferencia,strAuxiliar)  
			VALUES (@intEmpresa,'0',@intEjercicio,@intMes,@strPoliza,@strTipoPoliza,@intPoliza,@strFecha,3,'INVENTARIO',
			@dblSUM,@dblSUM,0,0,0,0,0,0,0,0,@strUsuario + ' ' + CONVERT(VARCHAR, GETDATE()),NULL,0,NULL,0,0,0,0,'SEM IE')

			WHILE (@Rows > @Count)
			BEGIN
				SET @Count = @Count + 1
				SET @Row = @Row + 1

				SELECT @strCuentaCargo = strCuentaCargo,@strCuentaAbono = strCuentaAbono,@dblImporte = dblImporte,@intFolio = intFolio,
				@intObra = intObra,@intProveedor = intProveedor, @strInsumo = strInsumo,@intArea = intArea,@intNumero = intNumero
				FROM #NoInventariable WHERE id = @Count

				SELECT @strProveedor = strNombre FROM VetecMarfilAdmin..tbProveedores WHERE intEmpresa = @intEmpresa AND intProveedor = @intProveedor

				INSERT INTO VetecMarfilAdmin..tbPolizasDet(intEmpresa,strClasifEnc,intEjercicio,intMes,strPoliza,strTipoPoliza,
				intFolioPoliza,intPartida,datFecha,strClasifDP,strClasifDS,strCuenta,strCuentaOrig,intTipoMovto,dblImporte,intTipoMoneda,
				dblTipoCambio,dblImporteTipoMoneda,strReferencia,strDescripcion,intIndAfectada,strFactura,intFacConsec,intProveedor,
				intTipoConcepto,intConcepto,intCuentaBancaria,intCheque,intConciliado,intConcilFolio,strClaveRef,strFolioRef,
				strAuditAlta,strAuditMod,intTipoAux)
				VALUES(@intEmpresa,'0',@intEjercicio,@intMes,@strPoliza,@strTipoPoliza,
				@intPoliza,@Row,@strFecha,0,@intObra,CASE WHEN @dblImporte < 0 THEN @strCuentaAbono ELSE @strCuentaCargo END,NULL,1,ABS(@dblImporte),1,
				1,ABS(@dblImporte),@intFolio,@intProveedor + ' ' + @strProveedor,0,@intFolio,@intArea,@intProveedor,
				NULL, NULL, NULL, 0, 0, NULL, NULL, @strInsumo, 
				@strUsuario + ' ' + @strMaquina + ' /SEM/ ' +CONVERT(VARCHAR, GETDATE()), NULL, NULL)

				SET @Row = @Row + 1

				INSERT INTO VetecMarfilAdmin..tbPolizasDet(intEmpresa,strClasifEnc,intEjercicio,intMes,strPoliza,strTipoPoliza,
				intFolioPoliza,intPartida,datFecha,strClasifDP,strClasifDS,strCuenta,strCuentaOrig,intTipoMovto,dblImporte,intTipoMoneda,
				dblTipoCambio,dblImporteTipoMoneda,strReferencia,strDescripcion,intIndAfectada,strFactura,intFacConsec,intProveedor,
				intTipoConcepto,intConcepto,intCuentaBancaria,intCheque,intConciliado,intConcilFolio,strClaveRef,strFolioRef,
				strAuditAlta,strAuditMod,intTipoAux)
				VALUES(@intEmpresa,'0',@intEjercicio,@intMes,@strPoliza,@strTipoPoliza,
				@intPoliza,@Row,@strFecha,0,@intObra,CASE WHEN @dblImporte < 0 THEN @strCuentaCargo ELSE @strCuentaAbono END,NULL,0,ABS(@dblImporte),1,
				1,ABS(@dblImporte),@intFolio,'Cuadre Inventario',0,@intFolio,@intArea,@intProveedor,
				NULL, NULL, NULL, 0, 0, NULL, NULL, @strInsumo, 
				@strUsuario + ' ' + @strMaquina + ' /SEM/ ' +CONVERT(VARCHAR, GETDATE()), NULL, NULL)

				--Actualizamos Entradas
				UPDATE E
				SET E.strPoliza = @strPoliza, intEjercicio = @intEjercicio
				FROM tbEntradaCompras E
				INNER JOIN tbOrdenCompraEnc OC ON OC.intOrdenCompraEnc = E.intOrdenCompraEnc
				WHERE OC.intEmpresa = @intEmpresa
				AND OC.intFolio = @intFolio
				AND E.intNumero = @intNumero

				SET @strCuentaCargo = ''
				SET @strCuentaAbono = ''
				SET @dblImporte = 0
				SET @intFolio = 0
				SET @intProveedor = ''
				SET @strCuentaCargo = ''
				SET @strInsumo = ''
			END

			--INCREMENTA EL FOLIO                                                          
			EXEC VetecMarfilAdmin.dbo.qryINCN2050_Upd_tbTiposPoliza @intEmpresa, '0', @intEjercicio, @intMes, @strTipoPoliza, @intPoliza                                                           
		END

		SET @strPolizas = @strPoliza

		--****INVENTARIABLES ENTRADA
		SET	@Count = 0
		SET @Row = 0
		SELECT @Rows = COUNT(*) FROM #InventariableEntrada
		SELECT @dblSUM = SUM(ABS(dblImporte)) FROM #InventariableEntrada	

		--FOLIO DE LA POLIZA                                             
		SET @intPoliza = (SELECT VetecMarfilAdmin.dbo.F_RegresaFolioPoliza(@intEmpresa, '0', @intEjercicio , @intMes , @strTipoPoliza , 0 ) + 1 )                                                                                           
				
		WHILE( EXISTS(SELECT * FROM VetecMarfilAdmin.dbo.tbPolizasEnc WHERE intEmpresa = @intEmpresa AND strClasifEnc = '0' AND intEjercicio = @intEjercicio AND intMes = @intMes AND strTipoPoliza = @strTipoPoliza AND intFolioPoliza = @intPoliza) )
		BEGIN                                                       
			SET @intPoliza = @intPoliza + 1                                                                                                  
		END                    
			                    	
		SET @strPoliza = RIGHT('00'+ Rtrim(ltrim(@intMes)) , 2) + Right('   '+ Rtrim(ltrim(@strTipoPoliza)) , 3) +  Rtrim(Ltrim(Convert(Varchar(20), @intPoliza)))                                          

		IF(@Rows > 0)
		BEGIN
			INSERT INTO VetecMarfilAdmin..tbPolizasEnc(intEmpresa,strClasifEnc,intEjercicio,intMes,strPoliza,
			strTipoPoliza,intFolioPoliza,datFecha,intEstatus,strDescripcion,dblCargos,dblAbonos,intIndAfectada,
			intIndInterempresa,intIndRec,intIndGenRec,intEjercicioOr,intMesOr,strPolizaOr,intConFlujo,strAuditAlta,
			strAuditMod,dblTransmision,intCuentaBancaria,intCheque,intPartida,intCenCos,intTransferencia,strAuxiliar)  
			VALUES (@intEmpresa,'0',@intEjercicio,@intMes,@strPoliza,@strTipoPoliza,@intPoliza,@strFecha,3,'INVENTARIO',
			@dblSUM,@dblSUM,0,0,0,0,0,0,0,0,@strUsuario + ' ' + CONVERT(VARCHAR, GETDATE()),NULL,0,NULL,0,0,0,0,'SEM IE')

			WHILE (@Rows > @Count)
			BEGIN
				SET @Count = @Count + 1
				SET @Row = @Row + 1

				SELECT @strCuentaCargo = strCuentaCargo,@strCuentaAbono = strCuentaAbono,@dblImporte = dblImporte,@intFolio = intFolio,
				@intObra = intObra,@intProveedor = intProveedor, @strInsumo = strInsumo, @intArea = intArea,@intNumero = intNumero
				FROM #InventariableEntrada WHERE id = @Count

				SELECT @strProveedor = strNombre FROM VetecMarfilAdmin..tbProveedores WHERE intEmpresa = @intEmpresa AND intProveedor = @intProveedor

				INSERT INTO VetecMarfilAdmin..tbPolizasDet(intEmpresa,strClasifEnc,intEjercicio,intMes,strPoliza,strTipoPoliza,
				intFolioPoliza,intPartida,datFecha,strClasifDP,strClasifDS,strCuenta,strCuentaOrig,intTipoMovto,dblImporte,intTipoMoneda,
				dblTipoCambio,dblImporteTipoMoneda,strReferencia,strDescripcion,intIndAfectada,strFactura,intFacConsec,intProveedor,
				intTipoConcepto,intConcepto,intCuentaBancaria,intCheque,intConciliado,intConcilFolio,strClaveRef,strFolioRef,
				strAuditAlta,strAuditMod,intTipoAux)
				VALUES(@intEmpresa,'0',@intEjercicio,@intMes,@strPoliza,@strTipoPoliza,
				@intPoliza,@Row,@strFecha,0,@intObra,CASE WHEN @dblImporte < 0 THEN @strCuentaAbono ELSE @strCuentaCargo END,NULL,1,ABS(@dblImporte),1,
				1,ABS(@dblImporte),@intFolio,@intProveedor + ' ' + @strProveedor,0,@intFolio,@intArea,@intProveedor,
				NULL, NULL, NULL, 0, 0, NULL, NULL, @strInsumo, 
				@strUsuario + ' ' + @strMaquina + ' /SEM/ ' +CONVERT(VARCHAR, GETDATE()), NULL, NULL)

				SET @Row = @Row + 1

				INSERT INTO VetecMarfilAdmin..tbPolizasDet(intEmpresa,strClasifEnc,intEjercicio,intMes,strPoliza,strTipoPoliza,
				intFolioPoliza,intPartida,datFecha,strClasifDP,strClasifDS,strCuenta,strCuentaOrig,intTipoMovto,dblImporte,intTipoMoneda,
				dblTipoCambio,dblImporteTipoMoneda,strReferencia,strDescripcion,intIndAfectada,strFactura,intFacConsec,intProveedor,
				intTipoConcepto,intConcepto,intCuentaBancaria,intCheque,intConciliado,intConcilFolio,strClaveRef,strFolioRef,
				strAuditAlta,strAuditMod,intTipoAux)
				VALUES(@intEmpresa,'0',@intEjercicio,@intMes,@strPoliza,@strTipoPoliza,
				@intPoliza,@Row,@strFecha,0,@intObra,CASE WHEN @dblImporte < 0 THEN @strCuentaCargo ELSE @strCuentaAbono END,NULL,0,ABS(@dblImporte),1,
				1,ABS(@dblImporte),@intFolio,'Cuadre Inventario',0,@intFolio,@intArea,@intProveedor,
				NULL, NULL, NULL, 0, 0, NULL, NULL, @strInsumo, 
				@strUsuario + ' ' + @strMaquina + ' /SEM/ ' +CONVERT(VARCHAR, GETDATE()), NULL, NULL)

				--Actualizamos Entradas
				UPDATE E
				SET E.strPoliza = @strPoliza, intEjercicio = @intEjercicio
				FROM tbEntradaCompras E
				INNER JOIN tbOrdenCompraEnc OC ON OC.intOrdenCompraEnc = E.intOrdenCompraEnc
				WHERE OC.intEmpresa = @intEmpresa
				AND OC.intFolio = @intFolio
				AND E.intNumero = @intNumero

				SET @strCuentaCargo = ''
				SET @strCuentaAbono = ''
				SET @dblImporte = 0
				SET @intFolio = 0
				SET @intProveedor = ''
				SET @strCuentaCargo = ''
				SET @strInsumo = ''
			END

			--INCREMENTA EL FOLIO                                                          
			EXEC VetecMarfilAdmin.dbo.qryINCN2050_Upd_tbTiposPoliza @intEmpresa, '0', @intEjercicio, @intMes, @strTipoPoliza, @intPoliza                                                           
		END

		SET @strPolizas = @strPolizas + ',' + @strPoliza

		--****INVENTARIABLES SALIDA
		SET	@Count = 0
		SET @Row = 0
		SELECT @Rows = COUNT(*) FROM #InventariableSalida
		SELECT @dblSUM = SUM(ABS(dblImporte)) FROM #InventariableSalida

		--FOLIO DE LA POLIZA                                             
		SET @intPoliza = (SELECT VetecMarfilAdmin.dbo.F_RegresaFolioPoliza(@intEmpresa, '0', @intEjercicio , @intMes , @strTipoPoliza , 0 ) + 1 )                                                                                           
				
		WHILE( EXISTS(SELECT * FROM VetecMarfilAdmin.dbo.tbPolizasEnc WHERE intEmpresa = @intEmpresa AND strClasifEnc = '0' AND intEjercicio = @intEjercicio AND intMes = @intMes AND strTipoPoliza = @strTipoPoliza AND intFolioPoliza = @intPoliza) )
		BEGIN                                                       
			SET @intPoliza = @intPoliza + 1                                                                                                  
		END                    
			                    	
		SET @strPoliza = RIGHT('00'+ Rtrim(ltrim(@intMes)) , 2) + Right('   '+ Rtrim(ltrim(@strTipoPoliza)) , 3) +  Rtrim(Ltrim(Convert(Varchar(20), @intPoliza)))                                          

		IF(@Rows > 0)
		BEGIN
			INSERT INTO VetecMarfilAdmin..tbPolizasEnc(intEmpresa,strClasifEnc,intEjercicio,intMes,strPoliza,
			strTipoPoliza,intFolioPoliza,datFecha,intEstatus,strDescripcion,dblCargos,dblAbonos,intIndAfectada,
			intIndInterempresa,intIndRec,intIndGenRec,intEjercicioOr,intMesOr,strPolizaOr,intConFlujo,strAuditAlta,
			strAuditMod,dblTransmision,intCuentaBancaria,intCheque,intPartida,intCenCos,intTransferencia,strAuxiliar)  
			VALUES (@intEmpresa,'0',@intEjercicio,@intMes,@strPoliza,@strTipoPoliza,@intPoliza,@strFecha,3,'INVENTARIO',
			@dblSUM,@dblSUM,0,0,0,0,0,0,0,0,@strUsuario + ' ' + CONVERT(VARCHAR, GETDATE()),NULL,0,NULL,0,0,0,0,'SEM IE')

			WHILE (@Rows > @Count)
			BEGIN
				SET @Count = @Count + 1
				SET @Row = @Row + 1

				SELECT @strCuentaCargo = strCuentaCargo,@strCuentaAbono = strCuentaAbono,@dblImporte = dblImporte,@intFolio = intFolio,
				@intObra = intObra,@intProveedor = intProveedor, @strInsumo = strInsumo, @intArea = intArea,@intNumero = intNumero
				FROM #InventariableSalida WHERE id = @Count

				SELECT @strProveedor = strNombre FROM VetecMarfilAdmin..tbProveedores WHERE intEmpresa = @intEmpresa AND intProveedor = @intProveedor

				INSERT INTO VetecMarfilAdmin..tbPolizasDet(intEmpresa,strClasifEnc,intEjercicio,intMes,strPoliza,strTipoPoliza,
				intFolioPoliza,intPartida,datFecha,strClasifDP,strClasifDS,strCuenta,strCuentaOrig,intTipoMovto,dblImporte,intTipoMoneda,
				dblTipoCambio,dblImporteTipoMoneda,strReferencia,strDescripcion,intIndAfectada,strFactura,intFacConsec,intProveedor,
				intTipoConcepto,intConcepto,intCuentaBancaria,intCheque,intConciliado,intConcilFolio,strClaveRef,strFolioRef,
				strAuditAlta,strAuditMod,intTipoAux)
				VALUES(@intEmpresa,'0',@intEjercicio,@intMes,@strPoliza,@strTipoPoliza,
				@intPoliza,@Row,@strFecha,0,@intObra,CASE WHEN @dblImporte < 0 THEN @strCuentaAbono ELSE @strCuentaCargo END,NULL,1,ABS(@dblImporte),1,
				1,ABS(@dblImporte),@intFolio,@intProveedor + ' ' + @strProveedor,0,@intFolio,@intArea,@intProveedor,
				NULL, NULL, NULL, 0, 0, NULL, NULL, @strInsumo, 
				@strUsuario + ' ' + @strMaquina + ' /SEM/ ' +CONVERT(VARCHAR, GETDATE()), NULL, NULL)

				SET @Row = @Row + 1

				INSERT INTO VetecMarfilAdmin..tbPolizasDet(intEmpresa,strClasifEnc,intEjercicio,intMes,strPoliza,strTipoPoliza,
				intFolioPoliza,intPartida,datFecha,strClasifDP,strClasifDS,strCuenta,strCuentaOrig,intTipoMovto,dblImporte,intTipoMoneda,
				dblTipoCambio,dblImporteTipoMoneda,strReferencia,strDescripcion,intIndAfectada,strFactura,intFacConsec,intProveedor,
				intTipoConcepto,intConcepto,intCuentaBancaria,intCheque,intConciliado,intConcilFolio,strClaveRef,strFolioRef,
				strAuditAlta,strAuditMod,intTipoAux)
				VALUES(@intEmpresa,'0',@intEjercicio,@intMes,@strPoliza,@strTipoPoliza,
				@intPoliza,@Row,@strFecha,0,@intObra,CASE WHEN @dblImporte < 0 THEN @strCuentaCargo ELSE @strCuentaAbono END,NULL,0,ABS(@dblImporte),1,
				1,ABS(@dblImporte),@intFolio,'Cuadre Inventario',0,@intFolio,@intArea,@intProveedor,
				NULL, NULL, NULL, 0, 0, NULL, NULL, @strInsumo, 
				@strUsuario + ' ' + @strMaquina + ' /SEM/ ' +CONVERT(VARCHAR, GETDATE()), NULL, NULL)

				--Actualizamos Entradas
				UPDATE E
				SET E.strPoliza = @strPoliza, intEjercicio = @intEjercicio
				FROM tbEntradaCompras E
				INNER JOIN tbOrdenCompraEnc OC ON OC.intOrdenCompraEnc = E.intOrdenCompraEnc
				WHERE OC.intEmpresa = @intEmpresa
				AND OC.intFolio = @intFolio
				AND E.intNumero = @intNumero

				SET @strCuentaCargo = ''
				SET @strCuentaAbono = ''
				SET @dblImporte = 0
				SET @intFolio = 0
				SET @intProveedor = ''
				SET @strCuentaCargo = ''
				SET @strInsumo = ''
			END

			--INCREMENTA EL FOLIO                                                          
			EXEC VetecMarfilAdmin.dbo.qryINCN2050_Upd_tbTiposPoliza @intEmpresa, '0', @intEjercicio, @intMes, @strTipoPoliza, @intPoliza 
		END		
		

		--Cerramos periodo de inventarios.
		UPDATE tbCerrarPeriodo 
		SET bCerrado = 1
		WHERE intEmpresa = @intEmpresa and intEjercicio = @intEjercicio and intMes = @intMes and intModulo = 5

		SET @strPolizas = @strPolizas + ',' + @strPoliza

		SELECT ISNULL(@strPolizas,'') AS Poliza

		DROP TABLE #Data
		DROP TABLE #NoInventariable
		DROP TABLE #InventariableEntrada
		DROP TABLE #InventariableSalida
	
	COMMIT TRANSACTION tbPolizas_Invetario
	END TRY
	BEGIN CATCH	
		IF @@TRANCOUNT > 0
		ROLLBACK TRANSACTION tbPolizas_Invetario   

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
	PRINT 'Procedure Creation: dbo.usp_tbPolizas_Invetario Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbPolizas_Invetario Error on Creation'
END
GO

