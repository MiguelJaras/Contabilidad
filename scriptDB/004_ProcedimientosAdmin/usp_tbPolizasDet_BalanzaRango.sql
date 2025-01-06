


IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbPolizasDet_BalanzaRango')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbPolizasDet_BalanzaRango
	PRINT N'Drop Procedure : dbo.usp_tbPolizasDet_BalanzaRango - Succeeded !!!'
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


CREATE PROCEDURE dbo.usp_tbPolizasDet_BalanzaRango
( 
	@intEmpresa			int, 
	@datFechaIni		VARCHAR(50),	
	@datFechaFin		VARCHAR(50),	
	@intNivel			int, 
	@strCuentaIni		VarChar(50), 
	@strCuentaFin		VarChar(50),
	@strObra			VarChar(50),
	@strObraFin			VarChar(50),
	@intAreaIni			INT, 
	@intAreaFin			INT,
	@intColIni			INT, 
	@intColFin			INT, 
	@intSectorIni		INT, 
	@intSectorFin		INT  	
)
AS    
BEGIN
	SET NOCOUNT ON 

	DECLARE @datFecha VARCHAR(50)
	DECLARE @strMes VARCHAR(100)
	DECLARE @strEmpresa VARCHAR(200)	
	DECLARE @PolizasSin	INT
	DECLARE @intAño int

	SELECT @intAño = YEAR(@datFechaIni)

	------------------------------------INICIA FORMATO FECHA MDY-------------------------------------
	IF @intEmpresa = 22 
	BEGIN
		SET LANGUAGE ENGLISH  				
	END
	------------------------------------FIN FORMATO FECHA MDY-------------------------------------

	CREATE TABLE #TmpObras(intObra INT)
	CREATE TABLE #TempCuentas(intEmpresa int, strCuenta VARCHAR(50) COLLATE SQL_Latin1_General_CP1_CI_AS, strNombre VARCHAR(200), intNivel int)
	CREATE TABLE #TempBalanza(strCuenta VARCHAR(50),strNombre VARCHAR(250),intNivel INT,SdoIni decimal(18,2),
	MesCargo decimal(18,2),MesAbono decimal(18,2),SdoFin decimal(18,2),Mes VARCHAR(50),intEmpresa VARCHAR(250))
	CREATE TABLE #TmpSaldos(intEmpresa int, strCuenta varchar(100), intNivel int, intObra VARCHAR(50), dblSaldoInicial decimal(18,2),
	dblSaldoCargos decimal(18,2), dblSaldoAbonos decimal(18,2))
	DECLARE @CuentasSaldos AS Table(strCuenta VARCHAR(50),intObra int,dblSaldoCargo decimal(18,2),dblSaldoAbono decimal(18,2))
	DECLARE @CuentasSaldosMes AS Table(strCuenta VARCHAR(50),intObra int,dblSaldoCargo decimal(18,2),dblSaldoAbono decimal(18,2))

	INSERT INTO #TmpObras(intObra)
	SELECT DISTINCT O.intObra
	FROM VetecMarfil.dbo.tbObra O 
	WHERE O.intEmpresa = @intEmpresa
	AND ((@strObra = '0') OR (O.strClave BETWEEN @strObra AND @strObraFin))
	AND ((@intAreaIni = 0) OR (CONVERT(int, SUBSTRING(O.strClave, 1, 2)) BETWEEN @intAreaIni AND @intAreaFin))
	AND ((@intColIni = 0 AND @intColFin = 0) OR (O.intColonia BETWEEN @intColIni AND @intColFin))
	AND ((@intSectorIni = 0 AND @intSectorFin = 0) OR (O.intSector BETWEEN @intSectorIni AND @intSectorFin))

	INSERT INTO #TempCuentas(intEmpresa, strCuenta, strNombre,intNivel)
	SELECT intEmpresa, strCuenta,strNombre ,intNivel
	FROM dbo.fn_tbCuentas_Nivel(@intEmpresa,@intnivel,@strCuentaIni,@strCuentaFin)

	SELECT @strEmpresa = strNombre FROM tbEmpresas WHERE intEmpresa = @intEmpresa

	SELECT @PolizasSin = ISNULL(COUNT(*),0)
	FROM tbPolizasEnc PE
	WHERE PE.intEmpresa = @intEmpresa
	AND	PE.datFecha BETWEEN @datFechaIni AND @datFechaFin
	AND PE.IntindAfectada = 0
	AND PE.intEstatus <> 9

	INSERT INTO #TmpSaldos(intEmpresa,strCuenta,intNivel,intObra,dblSaldoInicial,dblSaldoCargos, dblSaldoAbonos)
	SELECT CS.intEmpresa,CS.strCuenta,C.intNivel,CS.strClasifDS,SUM(CS.dblSaldoInicial),0,0
	FROM tbCuentasSaldos CS
	INNER JOIN #TempCuentas C ON C.strCuenta = CS.strCuenta
	INNER JOIN VetecMarfil..tbObra OBRA ON CONVERT(VARCHAR,OBRA.intObra) = CS.strClasifDS
	WHERE CS.intEmpresa = @intEmpresa
	AND CS.intEjercicio = @intAño
	AND ISNULL(CS.strClasifDS,'0') <> '0'
	GROUP BY CS.intEmpresa,CS.strCuenta,C.intNivel,CS.strClasifDS

	DECLARE @Nivel INT
	SELECT @Nivel = @intNivel * 4

	INSERT INTO @CuentasSaldosMes(strCuenta,intObra,dblSaldoCargo,dblSaldoAbono)
	SELECT LEFT(D.strCuenta,4),D.strClasifDS,SUM(CASE WHEN D.intTipoMovto = 0 THEN 0 ELSE D.dblImporte END),SUM(CASE WHEN D.intTipoMovto = 1 THEN 0 ELSE D.dblImporte END)
	FROM tbPolizasDet D
	INNER JOIN tbPolizasEnc P ON P.intEmpresa = D.intEmpresa AND P.intEjercicio = D.intEjercicio AND P.strPoliza = D.strPoliza
	WHERE D.intEmpresa = @intEmpresa
	AND D.intEjercicio = @intAño
	AND D.datFecha < @datFechaIni
	AND P.intEstatus <> 9
	AND D.IntindAfectada = 1
	GROUP BY LEFT(D.strCuenta,4),D.strClasifDS

	UPDATE CS
	SET CS.dblSaldoInicial = CS.dblSaldoInicial + ISNULL(PD.dblSaldoCargo,0) - ISNULL(PD.dblSaldoAbono,0)
	FROM #TmpSaldos CS
	INNER JOIN @CuentasSaldosMes PD ON PD.strCuenta COLLATE SQL_Latin1_General_CP1_CI_AS = CS.strCuenta AND CS.intObra = PD.intObra

	IF(@intNivel > 1)
	BEGIN
		INSERT INTO @CuentasSaldosMes(strCuenta,intObra,dblSaldoCargo,dblSaldoAbono)
		SELECT LEFT(D.strCuenta,8),D.strClasifDS,SUM(CASE WHEN D.intTipoMovto = 0 THEN 0 ELSE D.dblImporte END),SUM(CASE WHEN D.intTipoMovto = 1 THEN 0 ELSE D.dblImporte END)
		FROM tbPolizasDet D
		INNER JOIN tbPolizasEnc P ON P.intEmpresa = D.intEmpresa AND P.intEjercicio = D.intEjercicio AND P.strPoliza = D.strPoliza
		WHERE D.intEmpresa = @intEmpresa
		AND D.intEjercicio = @intAño
		AND D.datFecha < @datFechaIni
		AND P.intEstatus <> 9
		AND D.IntindAfectada = 1
		GROUP BY LEFT(D.strCuenta,8),D.strClasifDS

		UPDATE CS
		SET CS.dblSaldoInicial = CS.dblSaldoInicial + ISNULL(PD.dblSaldoCargo,0) - ISNULL(PD.dblSaldoAbono,0)
		FROM #TmpSaldos CS
		INNER JOIN @CuentasSaldosMes PD ON PD.strCuenta COLLATE SQL_Latin1_General_CP1_CI_AS = CS.strCuenta AND CS.intObra = PD.intObra
		AND LEN(CS.strCuenta) = 8
	END

	IF(@intNivel = 3)
	BEGIN
		INSERT INTO @CuentasSaldosMes(strCuenta,intObra,dblSaldoCargo,dblSaldoAbono)
		SELECT LEFT(D.strCuenta,12),D.strClasifDS,SUM(CASE WHEN D.intTipoMovto = 0 THEN 0 ELSE D.dblImporte END),SUM(CASE WHEN D.intTipoMovto = 1 THEN 0 ELSE D.dblImporte END)
		FROM tbPolizasDet D
		INNER JOIN tbPolizasEnc P ON P.intEmpresa = D.intEmpresa AND P.intEjercicio = D.intEjercicio AND P.strPoliza = D.strPoliza
		WHERE D.intEmpresa = @intEmpresa
		AND D.intEjercicio = @intAño
		AND D.datFecha < @datFechaIni
		AND P.intEstatus <> 9
		AND D.IntindAfectada = 1
		GROUP BY LEFT(D.strCuenta,12),D.strClasifDS

		UPDATE CS
		SET CS.dblSaldoInicial = CS.dblSaldoInicial + ISNULL(PD.dblSaldoCargo,0) - ISNULL(PD.dblSaldoAbono,0)
		FROM #TmpSaldos CS
		INNER JOIN @CuentasSaldosMes PD ON PD.strCuenta COLLATE SQL_Latin1_General_CP1_CI_AS = CS.strCuenta AND CS.intObra = PD.intObra
		AND LEN(CS.strCuenta) = 12
	END

	INSERT INTO @CuentasSaldos(strCuenta,intObra,dblSaldoCargo,dblSaldoAbono)
	SELECT LEFT(D.strCuenta,4),D.strClasifDS,ISNULL(SUM(CASE WHEN D.intTipoMovto = 0 THEN 0 ELSE D.dblImporte END),0),
	ISNULL(SUM(CASE WHEN D.intTipoMovto = 1 THEN 0 ELSE D.dblImporte END),0)
	FROM tbPolizasDet D
	INNER JOIN tbPolizasEnc P ON P.intEmpresa = D.intEmpresa AND P.intEjercicio = D.intEjercicio AND P.strPoliza = D.strPoliza
	WHERE D.intEmpresa = @intEmpresa
	AND D.intEjercicio = @intAño
	AND D.datFecha BETWEEN @datFechaIni AND @datFechaFin
	AND P.intEstatus <> 9
	AND D.IntindAfectada = 1
	GROUP BY LEFT(D.strCuenta,4),D.strClasifDS

	UPDATE CS
	SET CS.dblSaldoCargos = ISNULL(CS.dblSaldoCargos,0) + ISNULL(PD.dblSaldoCargo,0),
		CS.dblSaldoAbonos = ISNULL(CS.dblSaldoAbonos,0) + ISNULL(PD.dblSaldoAbono,0)
	FROM #TmpSaldos CS
	INNER JOIN @CuentasSaldos PD ON LEFT(PD.strCuenta,4) COLLATE SQL_Latin1_General_CP1_CI_AS = CS.strCuenta AND CS.intObra = PD.intObra

	IF(@intNivel > 1)
	BEGIN
		INSERT INTO @CuentasSaldos(strCuenta,intObra,dblSaldoCargo,dblSaldoAbono)
		SELECT LEFT(D.strCuenta,8),D.strClasifDS,ISNULL(SUM(CASE WHEN D.intTipoMovto = 0 THEN 0 ELSE D.dblImporte END),0),
		ISNULL(SUM(CASE WHEN D.intTipoMovto = 1 THEN 0 ELSE D.dblImporte END),0)
		FROM tbPolizasDet D
		INNER JOIN tbPolizasEnc P ON P.intEmpresa = D.intEmpresa AND P.intEjercicio = D.intEjercicio AND P.strPoliza = D.strPoliza
		WHERE D.intEmpresa = @intEmpresa
		AND D.intEjercicio = @intAño
		AND D.datFecha BETWEEN @datFechaIni AND @datFechaFin
		AND P.intEstatus <> 9
		AND D.IntindAfectada = 1
		GROUP BY LEFT(D.strCuenta,8),D.strClasifDS

		UPDATE CS
		SET CS.dblSaldoCargos = ISNULL(CS.dblSaldoCargos,0) + ISNULL(PD.dblSaldoCargo,0),
			CS.dblSaldoAbonos = ISNULL(CS.dblSaldoAbonos,0) + ISNULL(PD.dblSaldoAbono,0)
		FROM #TmpSaldos CS
		INNER JOIN @CuentasSaldos PD ON LEFT(PD.strCuenta,8) COLLATE SQL_Latin1_General_CP1_CI_AS = CS.strCuenta AND CS.intObra = PD.intObra
		AND LEN(CS.strCuenta) = 8
	END

	IF(@intNivel = 3)
	BEGIN
		INSERT INTO @CuentasSaldos(strCuenta,intObra,dblSaldoCargo,dblSaldoAbono)
		SELECT LEFT(D.strCuenta,12),D.strClasifDS,ISNULL(SUM(CASE WHEN D.intTipoMovto = 0 THEN 0 ELSE D.dblImporte END),0),
		ISNULL(SUM(CASE WHEN D.intTipoMovto = 1 THEN 0 ELSE D.dblImporte END),0)
		FROM tbPolizasDet D
		INNER JOIN tbPolizasEnc P ON P.intEmpresa = D.intEmpresa AND P.intEjercicio = D.intEjercicio AND P.strPoliza = D.strPoliza
		WHERE D.intEmpresa = @intEmpresa
		AND D.intEjercicio = @intAño
		AND D.datFecha BETWEEN @datFechaIni AND @datFechaFin
		AND P.intEstatus <> 9
		AND D.IntindAfectada = 1
		GROUP BY LEFT(D.strCuenta,12),D.strClasifDS

		UPDATE CS
		SET CS.dblSaldoCargos = ISNULL(CS.dblSaldoCargos,0) + ISNULL(PD.dblSaldoCargo,0),
			CS.dblSaldoAbonos = ISNULL(CS.dblSaldoAbonos,0) + ISNULL(PD.dblSaldoAbono,0)
		FROM #TmpSaldos CS
		INNER JOIN @CuentasSaldos PD ON LEFT(PD.strCuenta,12) COLLATE SQL_Latin1_General_CP1_CI_AS = CS.strCuenta AND CS.intObra = PD.intObra
		AND LEN(CS.strCuenta) = 12
	END

	--SELECT strCuenta,sum(dblSaldoCargo),sum(dblSaldoAbono) FROM @CuentasSaldos WHERE strCuenta = '111000010001' group by strCuenta
	
	INSERT INTO #TempBalanza(strCuenta,strNombre,intNivel,SdoIni,MesCargo,MesAbono,Mes,intEmpresa)
	SELECT  CS.strCuenta,C.strNombre,C.intNivel,SUM(CS.dblSaldoInicial),SUM(CS.dblSaldoCargos),SUM(CS.dblSaldoAbonos),
	@strMes,@strEmpresa				
	FROM #TmpSaldos CS
	INNER JOIN #TempCuentas C ON C.strCuenta COLLATE SQL_Latin1_General_CP1_CI_AS = CS.strCuenta AND C.intEmpresa = CS.intEmpresa
	LEFT JOIN VetecMarfil.dbo.tbObra O ON O.intObra = CS.intObra AND O.intEmpresa = CS.intEmpresa
	LEFT JOIN VetecMarfil.dbo.tbColonia Col ON Col.intColonia = SUBSTRING(O.strClave, 4, 2)
	WHERE CS.intEmpresa = @intEmpresa
	GROUP BY CS.strCuenta,C.strNombre,C.intNivel

--	IF(@intNivel = 2)
--	BEGIN
--		UPDATE T
--		SET T.SdoIni = CASE WHEN T.SdoIni < 0 THEN T.SdoIni - (SELECT SUM(TT.SdoIni) FROM #TempBalanza TT WHERE LEN(TT.strCuenta) = 8 AND LEFT(TT.strCuenta,4) = LEFT(T.strCuenta,4)) ELSE T.SdoIni + (SELECT SUM(TT.SdoIni) FROM #TempBalanza TT WHERE LEN(TT.strCuenta) = 8 AND LEFT(TT.strCuenta,4) = LEFT(T.strCuenta,4)) END,
--			T.MesCargo = T.MesCargo - (SELECT SUM(TT.MesCargo) FROM #TempBalanza TT WHERE LEN(TT.strCuenta) = 8 AND LEFT(TT.strCuenta,4) = LEFT(T.strCuenta,4)),
--			T.MesAbono = T.MesAbono - (SELECT SUM(TT.MesAbono) FROM #TempBalanza TT WHERE LEN(TT.strCuenta) = 8 AND LEFT(TT.strCuenta,4) = LEFT(T.strCuenta,4))
--		FROM #TempBalanza T
--		WHERE LEN(T.strCuenta) = 4
--	END		kill 98     

	UPDATE #TempBalanza SET SdoFin = SdoIni + MesCargo - MesAbono

--	SELECT * FROM #TempBalanza WHERE ISNULL(SdoIni,0) = 0 AND (MesCargo - MesAbono) = 0 ORDER BY convert(int,strCuenta)

--	IF(@intNivel = 1)
	--DELETE FROM #TempBalanza WHERE ISNULL(SdoIni,0) = 0 AND ISNULL(MesCargo,0) = 0 AND ISNULL(MesAbono,0) = 0 
--
--	IF(@intNivel = 2)
--		DELETE FROM #TempBalanza WHERE ISNULL(SdoIni,0) = 0 AND (MesCargo - MesAbono) = 0 AND LEN(strCuenta) = 8

	SELECT	strCuenta,strNombre,intNivel,SdoIni,MesCargo,MesAbono,SdoFin,Mes,@strEmpresa as Empresa,@PolizasSin as SinAfectar
	FROM #TempBalanza
	ORDER BY strCuenta

	SELECT	strCuenta as Cuenta,strNombre AS Nombre,intNivel as Nivel,SdoIni as Saldo_Inicial,MesCargo AS Cargos,
	MesAbono AS Abonos,SdoFin as Saldo_Final,@strEmpresa as Empresa
	FROM #TempBalanza
	ORDER BY strCuenta

	DROP TABLE #TempBalanza
	DROP TABLE #TempCuentas
	DROP TABLE #TmpObras
	DROP TABLE #TmpSaldos

SET NOCOUNT OFF
END
GO 

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbPolizasDet_BalanzaRango Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbPolizasDet_BalanzaRango Error on Creation'
END
GO
