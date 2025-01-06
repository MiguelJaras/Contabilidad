/****** Object:  StoredProcedure [dbo.usp_Tareas_Fill]    Script Date: 12/8/2009 10:45:19 AM ******/
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbPolizasEnc_List')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbPolizasEnc_List
	PRINT N'Drop Procedure : dbo.usp_tbPolizasEnc_List - Succeeded !!!'
END
GO

------------------------------------------------------------------------------------
---   Aplicacion: Marfil.		                                                 ---
---        Autor: Rubén Mora Martínez                                            ---
---  Descripcion: Obtiene un registro de la tabla:  tbPolizasEnc                 ---
---                                                                              ---
------------------------------------------------------------------------------------
---    Fecha     Autor  Comentario                                               ---
---  ----------  -----  -------------------------------------------------------  ---
---  12/11/2010  RMM    Create procedure                                         ---
------------------------------------------------------------------------------------

CREATE PROCEDURE dbo.usp_tbPolizasEnc_List
(
	@intEmpresa			INT,
	@intEjercicio		int,
	@intMes				int,
	@strTipoPoliza		varchar(20),
	@strTipoPolizaFin	varchar(20),
	@intFolioIni		int,
	@intFolioFin		int,
	@intAfectada		int,
	@intDirection		int,
	@SortExpression		varchar(100),	
	@NumPage			int				= NULL, 
	@NumRecords			int				= 0, 
	@TotalRows			int				= NULL OUTPUT,
	@TotalPage			int				= NULL OUTPUT
)
WITH ENCRYPTION 
AS
BEGIN
		
	SET NOCOUNT ON

	DECLARE	@Err				int,
			@MsgErr				varchar(512),
			@startRow			int,
			@finalRow			int,
			@iNumTotRecords		int,
			@iNumTotPages		int,
			@fNumPages			float,
			@Sort				varchar(200)

	IF(@SortExpression = '')
	BEGIN
		SET @SortExpression = 'Folio'
		SET @intDirection = 1
	END

	IF(@intFolioIni = 0 OR @intFolioFin = 0)
	BEGIN
		SET @intFolioIni = 0
		SET @intFolioFin = 0
	END

	SET @Sort = LOWER(@SortExpression) + CASE WHEN @intDirection = 0 THEN ' DESC' ELSE ' ASC' END  

	CREATE TABLE #Polizas(row int identity(1,1), intEmpresa int, intEjercicio int, intMes int, datFecha datetime, intFolio int, strPoliza varchar(50),
	intIndAfectada int, TipoPoliza varchar(100), dblCargos decimal(18,2), dblAbonos decimal(18,2),dblDiferencias decimal(18,2), 
	intCuenta int,strTipoPoliza varchar(2))

	CREATE TABLE #Polizas2(row int identity(1,1), intEmpresa int, intEjercicio int, intMes int, datFecha datetime, intFolio int, strPoliza varchar(50),
	intIndAfectada int, TipoPoliza varchar(100), dblCargos decimal(18,2), dblAbonos decimal(18,2),dblDiferencias decimal(18,2), 
	intCuenta int,strTipoPoliza varchar(2))

	--EXEC dbo.qryINCN2020_Upd_CuadrarEncabezados @intEmpresa,'0',@intEjercicio,@intMes

	INSERT INTO #Polizas(intEmpresa, intEjercicio,intMes,datFecha,intFolio,strPoliza,intIndAfectada,TipoPoliza,dblCargos,dblAbonos,intCuenta,strTipoPoliza)--,Obra,Auxiliar)
	SELECT DISTINCT P.intEmpresa, P.intEjercicio,P.intMes,P.datFecha,P.intFolioPoliza,P.strPoliza,P.intIndAfectada,T.strTipoPoliza + ' - ' + T.strNombre,
	ISNULL(P.dblCargos,0),ISNULL(P.dblAbonos,0),1,T.strTipoPoliza
	FROM tbPolizasEnc P
	INNER JOIN tbTiposPoliza T ON T.strTipoPoliza = P.strTipoPoliza AND T.intEmpresa = P.intEmpresa AND P.intEjercicio = T.intEjercicio
	WHERE P.intEmpresa = @intEmpresa
	AND P.intEjercicio = @intEjercicio
	AND P.intMes = @intMes
	AND P.intEstatus <> 9
	AND P.intIndAfectada = @intAfectada
	AND ((@strTipoPoliza = '0') OR (P.strTipoPoliza BETWEEN @strTipoPoliza AND @strTipoPolizaFin))
	AND ((@intFolioIni = 0) OR (P.intFolioPoliza BETWEEN @intFolioIni AND @intFolioFin))
		
	UPDATE P
	SET dblDiferencias = dblCargos - dblAbonos
	FROM #Polizas P

	INSERT INTO #Polizas2(intEmpresa, intEjercicio,intMes,datFecha,intFolio,strPoliza,intIndAfectada,TipoPoliza,dblCargos,dblAbonos,intCuenta,dblDiferencias,strTipoPoliza)
	SELECT intEmpresa, intEjercicio,intMes,datFecha,intFolio,strPoliza,intIndAfectada,TipoPoliza,dblCargos,dblAbonos,intCuenta,dblDiferencias,strTipoPoliza
	FROM #Polizas
	ORDER BY 
			CASE WHEN @Sort = 'Ejercicio DESC' THEN intEjercicio END DESC,
			CASE WHEN @Sort = 'Ejercicio ASC' THEN intEjercicio END ASC,
			CASE WHEN @Sort = 'Mes DESC' THEN intMes END DESC,
			CASE WHEN @Sort = 'Mes ASC' THEN intMes END ASC,
			CASE WHEN @Sort = 'Fecha DESC' THEN datFecha END DESC,
			CASE WHEN @Sort = 'Fecha ASC' THEN datFecha END ASC, 
			CASE WHEN @Sort = 'Folio DESC' THEN intFolio END DESC,
			CASE WHEN @Sort = 'Folio ASC' THEN intFolio END ASC,
			CASE WHEN @Sort = 'Cargos DESC' THEN dblCargos END DESC,
			CASE WHEN @Sort = 'Cargos ASC' THEN dblCargos END ASC, 
			CASE WHEN @Sort = 'Abonos DESC' THEN dblAbonos END DESC,
			CASE WHEN @Sort = 'Abonos ASC' THEN dblAbonos END ASC, 
			CASE WHEN @Sort = 'Deferencia DESC' THEN dblDiferencias END DESC,
			CASE WHEN @Sort = 'Deferencia ASC' THEN dblDiferencias END ASC,
			CASE WHEN @Sort = 'Poliza DESC' THEN strPoliza END DESC,
			CASE WHEN @Sort = 'Poliza ASC' THEN strPoliza END ASC,
			CASE WHEN @Sort = 'TipoPoliza DESC' THEN TipoPoliza END DESC,
			CASE WHEN @Sort = 'TipoPoliza ASC' THEN TipoPoliza END ASC --,
--			CASE WHEN @Sort = 'Obra DESC' THEN Obra END DESC,
--			CASE WHEN @Sort = 'Obra ASC' THEN Obra END ASC   

--	UPDATE P
--	SET P.intCuenta = 0
--	FROM #Polizas P
--	INNER JOIN tbPolizasDet PD ON PD.intEmpresa = P.intEmpresa AND PD.strPoliza = P.strPoliza COLLATE SQL_Latin1_General_CP1_CI_AS
--	INNER JOIN tbCuentas C ON C.strCuenta = PD.strCuenta AND C.intEmpresa = PD.intEmpresa
--	WHERE C.intCtaRegistro = 0

--	UPDATE P
--	SET P.intCuenta = 0
--	FROM #Polizas P
--	INNER JOIN tbPolizasDet PD ON PD.intEmpresa = P.intEmpresa AND PD.strPoliza = P.strPoliza COLLATE SQL_Latin1_General_CP1_CI_AS
--	INNER JOIN tbCuentas C ON C.strCuenta = PD.strCuenta AND C.intEmpresa = PD.intEmpresa
--	WHERE C.intIndAuxiliar = 1
--	AND isnull(PD.strClasifDP,0) = 0

	SELECT	@iNumTotRecords = MAX(row)
	FROM	#Polizas2

	IF @NumRecords = 0
	BEGIN
		SELECT	@finalRow = @iNumTotRecords,
				@startRow = 1,
				@iNumTotPages = 1
	END
	ELSE
	BEGIN
		SELECT @iNumTotPages = (@iNumTotRecords / @NumRecords)

		SELECT @fNumPages = ((@iNumTotRecords * 1.0) / (@NumRecords * 1.0))

		IF (@fNumPages - @iNumTotPages) > 0.0
		BEGIN
			SELECT @iNumTotPages = @iNumTotPages + 1
		END

		SELECT @finalRow = ((@NumPage + 1) * @NumRecords)

		SELECT @startRow = (@finalRow - @NumRecords + 1)
	END

	SELECT	@TotalRows	= ISNULL(@iNumTotRecords,0),
			@TotalPage	= ISNULL(@iNumTotPages,0)

	SET @Err = @@Error

	SELECT intEmpresa, intEjercicio,intMes,CONVERT(VARCHAR,datFecha,103) AS datFecha,intFolio,strPoliza,intIndAfectada,TipoPoliza,
	CONVERT(VARCHAR,CONVERT(MONEY,dblCargos),1) AS dblCargos,CONVERT(VARCHAR,CONVERT(MONEY,dblAbonos),1) AS dblAbonos,
	CONVERT(VARCHAR,CONVERT(MONEY,dblDiferencias),1) AS dblDiferencias,intCuenta,strTipoPoliza
	--CASE WHEN ISNULL(Obra,0) = 0 THEN '' ELSE Obra END AS Obra, Auxiliar
	FROM #Polizas2
	WHERE row between @startRow AND @finalRow
	
	
	DROP TABLE #Polizas
	DROP TABLE #Polizas2

	SET @Err = @@Error

	SET @Err = @@Error

	IF (@Err > 0)
	BEGIN
		SELECT @MsgErr = 'Ocurrio un error no reconocido!',
				@Err = 1000000

		GOTO ExistsError
	END

	SET NOCOUNT OFF

	RETURN @Err

ExistsError:
	IF (@@TRANCOUNT > 0)
		ROLLBACK

	SET NOCOUNT OFF

	RAISERROR (@MsgErr, 16, 1)

	RETURN @Err
	
END
GO

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbPolizasEnc_List Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbPolizasEnc_List Error on Creation'
END
GO

