

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbPolizasDet_Balanza_ObraRango')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbPolizasDet_Balanza_ObraRango
	PRINT N'Drop Procedure : dbo.usp_tbPolizasDet_Balanza_ObraRango - Succeeded !!!'
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


CREATE PROCEDURE dbo.usp_tbPolizasDet_Balanza_ObraRango
( 
	@intEmpresa		int, 
	@datFechaIni	VarChar(50),	
	@datFechaFin	VarChar(50),	    
	@intNivel		int, 
	@strCuentaIni	VarChar(50), 
	@strCuentaFin	VarChar(50),
	@strObra		VarChar(50),
	@strObraFin		VarChar(50),
	@intAreaIni		INT, 
	@intAreaFin		INT,
	@intColIni		INT, 
	@intColFin		INT, 
	@intSectorIni	INT, 
	@intSectorFin	INT,
	@Cero			int
)
AS    
BEGIN
	SET NOCOUNT ON    

	DECLARE @datFecha VARCHAR(50)
	DECLARE @strMes VARCHAR(100)
	DECLARE @strEmpresa VARCHAR(200)	
	DECLARE @intAño int

	SELECT @intAño = YEAR(@datFechaIni)

	------------------------------------INICIA FORMATO FECHA MDY-------------------------------------
	IF @intEmpresa = 22 
	BEGIN
		SET LANGUAGE ENGLISH  		

		SELECT @strMes = DATENAME(MONTH,CONVERT(DATETIME, @datFechaIni) )
	END
	ELSE
	BEGIN	
		SELECT @strMes = ''
	END
	------------------------------------FIN FORMATO FECHA MDY-------------------------------------

	CREATE TABLE #TmpObras(intObra INT)
	CREATE TABLE #TempCuentas(intEmpresa int, strCuenta VARCHAR(50) COLLATE SQL_Latin1_General_CP1_CI_AS, strNombre VARCHAR(200), intNivel int)
	CREATE TABLE #TempBalanza(intEmpresa INT,strEmpresa VARCHAR(250),strCuenta VARCHAR(100),strNomCuenta VARCHAR(250), 
	Nivel1 VARCHAR(10), Nivel2 VARCHAR(10), Nivel3 VARCHAR(10), strMes VARCHAR(20), intEjercicio INT, 
	intObra INT, strObra VARCHAR(250), strClaveObra VARCHAR(100), intColonia INT, strNombreColonia VARCHAR(250), 
	dblSaldoInicial decimal(18,2),dblCargo decimal(18,2), dblAbono decimal(18,2), dblSaldoFinal decimal(18,2), intNivel INT)
	CREATE TABLE #TmpSaldos(intEmpresa int, strCuenta varchar(100), intObra INT, dblSaldoInicial decimal(18,2),
	dblSaldoCargos decimal(18,2), dblSaldoAbonos decimal(18,2),intNivel int)
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

	INSERT INTO #TempBalanza(intEmpresa,strEmpresa,strCuenta,strNomCuenta,Nivel1,Nivel2,Nivel3,strMes,intEjercicio, 
	intObra,strObra,strClaveObra,intColonia,strNombreColonia,dblSaldoInicial,dblCargo,dblAbono,dblSaldoFinal,intNivel)
	SELECT  @intEmpresa,@strEmpresa,CS.strCuenta,C.strNombre,SUBSTRING (CS.strCuenta,1,4),
			CASE WHEN SUBSTRING (CS.strCuenta,5,4) = '' THEN '0000' ELSE SUBSTRING (CS.strCuenta,5,4) END, 
			CASE WHEN SUBSTRING (CS.strCuenta,9,4) = '' THEN '0000' ELSE SUBSTRING (CS.strCuenta,9,4) END,
			@strMes,@intAño,CS.intObra,ISNULL(O.strNombre, 'SIN OBRA'),
			ISNULL(O.strClave +  ' ' + CONVERT(VARCHAR,CS.intObra), 'SIN CLAVE'),
			ISNULL( CONVERT(INT,SUBSTRING(O.strClave, 4, 2)), 0),ISNULL(Col.strNombre, 'SIN OBRA'),
			CS.dblSaldoInicial,CS.dblSaldoCargos,CS.dblSaldoAbonos,--dbo.F_Sdoini_PolDet(@intEmpresa,'0',@intEjercicio,@intMes, C.strCuenta, CS.strClasifDS, CS.strClasifDP),
			--CONVERT(DECIMAL(18,2), dbo.F_MesCargo(@intEmpresa, '0', @intEjercicio, @intMes, '0', C.strCuenta, CS.strClasifDS, '0')),
			--CONVERT(DECIMAL(18,2), dbo.F_MesAbono(@intEmpresa, '0', @intEjercicio, @intMes, '0', C.strCuenta, CS.strClasifDS, '0')),    
			dblSaldoFinal = 0, C.intNivel--C.intNivel					
	FROM #TmpSaldos CS
	INNER JOIN #TempCuentas C ON C.strCuenta COLLATE SQL_Latin1_General_CP1_CI_AS = CS.strCuenta AND C.intEmpresa = CS.intEmpresa
	INNER JOIN VetecMarfil.dbo.tbObra O ON O.intObra = CS.intObra AND O.intEmpresa = CS.intEmpresa
	LEFT JOIN VetecMarfil.dbo.tbColonia Col ON Col.intColonia = SUBSTRING(O.strClave, 4, 2)
	WHERE CS.intEmpresa = @intEmpresa
	AND O.intObra IN (SELECT intObra FROM #TmpObras)
			
	UPDATE #TempBalanza SET dblSaldoFinal = dblSaldoInicial + dblCargo - dblAbono

	IF(@Cero = 0)
	BEGIN
--		DELETE FROM #TempBalanza WHERE ISNULL(dblSaldoInicial,0) = 0 AND (dblCargo - dblAbono) = 0
--
		DELETE FROM #TempBalanza WHERE strCuenta in(SELECT strCuenta FROM #TempBalanza GROUP BY strCuenta HAVING SUM(ISNULL(dblSaldoInicial,0)) = 0 AND SUM(dblCargo - dblAbono) = 0)
		--DELETE FROM #TempBalanza WHERE intObra in(SELECT intObra FROM #TempBalanza GROUP BY intObra HAVING SUM(dblSaldoFinal) = 0)
		
		DELETE FROM #TempBalanza WHERE intObra in(SELECT intObra FROM #TempBalanza GROUP BY intObra HAVING SUM(dblSaldoInicial) = 0 AND SUM(dblCargo) = 0 AND SUM(dblAbono) = 0 AND SUM(dblSaldoFinal) = 0)

--		DELETE FROM #TempBalanza WHERE dblSaldoFinal = 0-- ISNULL(dblSaldoInicial,0) = 0 AND (dblCargo - dblAbono) = 0
	END

--	ELSE
--	BEGIN
--		DELETE FROM #TempBalanza
--		--WHERE intObra IN(SELECT intObra FROM #TempBalanza GROUP BY intObra HAVING ISNULL(SUM(dblSaldoInicial),0) + ISNULL(SUM(dblCargo),0) - ISNULL(SUM(dblAbono),0) + ISNULL(SUM(dblSaldoFinal),0) <> 0)
--		WHERE ISNULL(dblCargo,0) <> 0 OR ISNULL(dblAbono,0) <> 0
--	END

	SELECT	intEmpresa,strEmpresa,strCuenta,strNomCuenta,Nivel1,Nivel2,Nivel3,strMes,intEjercicio,intObra,strObra,
			strClaveObra,intColonia,strNombreColonia,dblSaldoInicial,dblCargo,dblAbono,dblSaldoFinal,intNivel,
			intColIni = @intColIni,intColFin = @intColFin,intSectorIni = @intSectorIni,intSectorFin = @intSectorFin,
			intCCIni = @strObra,intCCFin = @strObraFin,intAreaIni = @intAreaIni,intAreaFin = @intAreaFin 
	FROM #TempBalanza
	ORDER BY strClaveObra
	--WHERE ((@Cero = 1) OR (ISNULL(dblSaldoInicial,0) + ISNULL(dblCargo,0) - ISNULL(dblAbono,0) + ISNULL(dblSaldoFinal,0) = 0))

	DROP TABLE 	#TempBalanza
	DROP TABLE #TempCuentas
	DROP TABLE #TmpObras
	DROP TABLE #TmpSaldos

SET NOCOUNT OFF
END
GO 

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbPolizasDet_Balanza_ObraRango Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbPolizasDet_Balanza_ObraRango Error on Creation'
END
GO



















