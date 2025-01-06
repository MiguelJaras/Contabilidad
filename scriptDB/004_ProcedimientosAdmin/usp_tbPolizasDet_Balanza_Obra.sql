

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbPolizasDet_Balanza_Obra')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbPolizasDet_Balanza_Obra
	PRINT N'Drop Procedure : dbo.usp_tbPolizasDet_Balanza_Obra - Succeeded !!!'
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


CREATE PROCEDURE dbo.usp_tbPolizasDet_Balanza_Obra
( 
	@intEmpresa		int, 
	@intEjercicio	int,	
	@intMes			Int,	    
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

	------------------------------------INICIA FORMATO FECHA MDY-------------------------------------
	IF @intEmpresa = 22 
	BEGIN
		SET LANGUAGE ENGLISH  		

		SET @datFecha =  CONVERT(VARCHAR,@intMes) + '/01/' + CONVERT(VARCHAR,@intEjercicio)
	
		IF @intMes = 0
			SET @strMes = 'JAN 11 - DEC 11'
		ELSE
			SELECT @strMes = DATENAME(MONTH,CONVERT(DATETIME, @datFecha) )
	END
	ELSE
	BEGIN	
		SELECT @strMes = strNombre FROM tbMeses WHERE intMes = @intMes
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

	INSERT INTO #TmpSaldos(intEmpresa,strCuenta,intObra,dblSaldoInicial,dblSaldoCargos,dblSaldoAbonos,intNivel)
	SELECT CS.intEmpresa,CS.strCuenta,CS.strClasifDS,	
	SUM(CASE @intMes    
          WHEN 1  THEN IsNull(CS.dblSaldoInicial, 0)      
          WHEN 2  THEN IsNull(CS.dblSaldoInicial, 0) + ( IsNull(CS.dblCargo01, 0) - IsNull(CS.dblAbono01, 0) )     
          WHEN 3  THEN IsNull(CS.dblSaldoInicial, 0) + ( IsNull(CS.dblCargo01, 0) - IsNull(CS.dblAbono01, 0) + IsNull(CS.dblCargo02, 0) - IsNull(CS.dblAbono02, 0) )     
          WHEN 4  THEN IsNull(CS.dblSaldoInicial, 0) + ( IsNull(CS.dblCargo01, 0) - IsNull(CS.dblAbono01, 0) + IsNull(CS.dblCargo02, 0) - IsNull(CS.dblAbono02, 0) + IsNull(CS.dblCargo03, 0) - IsNull(CS.dblAbono03, 0) )     
          WHEN 5  THEN IsNull(CS.dblSaldoInicial, 0) + ( IsNull(CS.dblCargo01, 0) - IsNull(CS.dblAbono01, 0) + IsNull(CS.dblCargo02, 0) - IsNull(CS.dblAbono02, 0) + IsNull(CS.dblCargo03, 0) - IsNull(CS.dblAbono03, 0) + IsNull(CS.dblCargo04, 0) - IsNull(CS.dblAbono04, 0) )    
          WHEN 6  THEN IsNull(CS.dblSaldoInicial, 0) + ( IsNull(CS.dblCargo01, 0) - IsNull(CS.dblAbono01, 0) + IsNull(CS.dblCargo02, 0) - IsNull(CS.dblAbono02, 0) + IsNull(CS.dblCargo03, 0) - IsNull(CS.dblAbono03, 0) + IsNull(CS.dblCargo04, 0) - IsNull(CS.dblAbono04, 0) + IsNull(CS.dblCargo05, 0) - IsNull(CS.dblAbono05, 0) )     
          WHEN 7  THEN IsNull(CS.dblSaldoInicial, 0) + ( IsNull(CS.dblCargo01, 0) - IsNull(CS.dblAbono01, 0) + IsNull(CS.dblCargo02, 0) - IsNull(CS.dblAbono02, 0) + IsNull(CS.dblCargo03, 0) - IsNull(CS.dblAbono03, 0) + IsNull(CS.dblCargo04, 0) - IsNull(CS.dblAbono04, 0) + IsNull(CS.dblCargo05, 0) - IsNull(CS.dblAbono05, 0) + IsNull(CS.dblCargo06, 0) - IsNull(CS.dblAbono06, 0) )     
          WHEN 8  THEN IsNull(CS.dblSaldoInicial, 0) + ( IsNull(CS.dblCargo01, 0) - IsNull(CS.dblAbono01, 0) + IsNull(CS.dblCargo02, 0) - IsNull(CS.dblAbono02, 0) + IsNull(CS.dblCargo03, 0) - IsNull(CS.dblAbono03, 0) + IsNull(CS.dblCargo04, 0) - IsNull(CS.dblAbono04, 0) + IsNull(CS.dblCargo05, 0) - IsNull(CS.dblAbono05, 0) + IsNull(CS.dblCargo06, 0) - IsNull(CS.dblAbono06, 0) + IsNull(CS.dblCargo07, 0) - IsNull(CS.dblAbono07, 0) )     
          WHEN 9  THEN IsNull(CS.dblSaldoInicial, 0) + ( IsNull(CS.dblCargo01, 0) - IsNull(CS.dblAbono01, 0) + IsNull(CS.dblCargo02, 0) - IsNull(CS.dblAbono02, 0) + IsNull(CS.dblCargo03, 0) - IsNull(CS.dblAbono03, 0) + IsNull(CS.dblCargo04, 0) - IsNull(CS.dblAbono04, 0) + IsNull(CS.dblCargo05, 0) - IsNull(CS.dblAbono05, 0) + IsNull(CS.dblCargo06, 0) - IsNull(CS.dblAbono06, 0) + IsNull(CS.dblCargo07, 0) - IsNull(CS.dblAbono07, 0) + IsNull(CS.dblCargo08, 0) - IsNull(CS.dblAbono08, 0) )     
          WHEN 10 THEN IsNull(CS.dblSaldoInicial, 0) + ( IsNull(CS.dblCargo01, 0) - IsNull(CS.dblAbono01, 0) + IsNull(CS.dblCargo02, 0) - IsNull(CS.dblAbono02, 0) + IsNull(CS.dblCargo03, 0) - IsNull(CS.dblAbono03, 0) + IsNull(CS.dblCargo04, 0) - IsNull(CS.dblAbono04, 0) + IsNull(CS.dblCargo05, 0) - IsNull(CS.dblAbono05, 0) + IsNull(CS.dblCargo06, 0) - IsNull(CS.dblAbono06, 0) + IsNull(CS.dblCargo07, 0) - IsNull(CS.dblAbono07, 0) + IsNull(CS.dblCargo08, 0) - IsNull(CS.dblAbono08, 0) + IsNull(CS.dblCargo09, 0) - IsNull(CS.dblAbono09, 0) )     
          WHEN 11 THEN IsNull(CS.dblSaldoInicial, 0) + ( IsNull(CS.dblCargo01, 0) - IsNull(CS.dblAbono01, 0) + IsNull(CS.dblCargo02, 0) - IsNull(CS.dblAbono02, 0) + IsNull(CS.dblCargo03, 0) - IsNull(CS.dblAbono03, 0) + IsNull(CS.dblCargo04, 0) - IsNull(CS.dblAbono04, 0) + IsNull(CS.dblCargo05, 0) - IsNull(CS.dblAbono05, 0) + IsNull(CS.dblCargo06, 0) - IsNull(CS.dblAbono06, 0) + IsNull(CS.dblCargo07, 0) - IsNull(CS.dblAbono07, 0) + IsNull(CS.dblCargo08, 0) - IsNull(CS.dblAbono08, 0) + IsNull(CS.dblCargo09, 0) - IsNull(CS.dblAbono09, 0) + IsNull(CS.dblCargo10, 0) - IsNull(CS.dblAbono10, 0) )     
          WHEN 12 THEN IsNull(CS.dblSaldoInicial, 0) + ( IsNull(CS.dblCargo01, 0) - IsNull(CS.dblAbono01, 0) + IsNull(CS.dblCargo02, 0) - IsNull(CS.dblAbono02, 0) + IsNull(CS.dblCargo03, 0) - IsNull(CS.dblAbono03, 0) + IsNull(CS.dblCargo04, 0) - IsNull(CS.dblAbono04, 0) + IsNull(CS.dblCargo05, 0) - IsNull(CS.dblAbono05, 0) + IsNull(CS.dblCargo06, 0) - IsNull(CS.dblAbono06, 0) + IsNull(CS.dblCargo07, 0) - IsNull(CS.dblAbono07, 0) + IsNull(CS.dblCargo08, 0) - IsNull(CS.dblAbono08, 0) + IsNull(CS.dblCargo09, 0) - IsNull(CS.dblAbono09, 0) + IsNull(CS.dblCargo10, 0) - IsNull(CS.dblAbono10, 0) + IsNull(CS.dblCargo11, 0) - IsNull(CS.dblAbono11, 0) )    
		  WHEN 0 THEN IsNull(CS.dblSaldoInicial, 0) + ( IsNull(CS.dblCargo01, 0) - IsNull(CS.dblAbono01, 0) + IsNull(CS.dblCargo02, 0) - IsNull(CS.dblAbono02, 0) + IsNull(CS.dblCargo03, 0) - IsNull(CS.dblAbono03, 0) + IsNull(CS.dblCargo04, 0) - IsNull(CS.dblAbono04, 0) + IsNull(CS.dblCargo05, 0) - IsNull(CS.dblAbono05, 0) + IsNull(CS.dblCargo06, 0) - IsNull(CS.dblAbono06, 0) + IsNull(CS.dblCargo07, 0) - IsNull(CS.dblAbono07, 0) + IsNull(CS.dblCargo08, 0) - IsNull(CS.dblAbono08, 0) + IsNull(CS.dblCargo09, 0) - IsNull(CS.dblAbono09, 0) + IsNull(CS.dblCargo10, 0) - IsNull(CS.dblAbono10, 0) + IsNull(CS.dblCargo11, 0) - IsNull(CS.dblAbono11, 0) + IsNull(CS.dblCargo12, 0) - IsNull(CS.dblAbono12, 0) )    
          END),
	SUM(CASE @intMes    
          WHEN 1  THEN IsNull(CS.dblCargo01,0)   
          WHEN 2  THEN IsNull(CS.dblCargo02,0)
          WHEN 3  THEN IsNull(CS.dblCargo03,0)
          WHEN 4  THEN IsNull(CS.dblCargo04,0)
          WHEN 5  THEN IsNull(CS.dblCargo05,0)
		  WHEN 6  THEN IsNull(CS.dblCargo06,0)   
          WHEN 7  THEN IsNull(CS.dblCargo07,0)
          WHEN 8  THEN IsNull(CS.dblCargo08,0)
          WHEN 9  THEN IsNull(CS.dblCargo09,0)
          WHEN 10  THEN IsNull(CS.dblCargo10,0)
		  WHEN 11  THEN IsNull(CS.dblCargo11,0)   
          WHEN 12  THEN IsNull(CS.dblCargo12,0)
          END ),
	SUM(CASE @intMes    
          WHEN 1  THEN IsNull(CS.dblAbono01,0)   
          WHEN 2  THEN IsNull(CS.dblAbono02,0)
          WHEN 3  THEN IsNull(CS.dblAbono03,0)
          WHEN 4  THEN IsNull(CS.dblAbono04,0)
          WHEN 5  THEN IsNull(CS.dblAbono05,0)
		  WHEN 6  THEN IsNull(CS.dblAbono06,0)   
          WHEN 7  THEN IsNull(CS.dblAbono07,0)
          WHEN 8  THEN IsNull(CS.dblAbono08,0)
          WHEN 9  THEN IsNull(CS.dblAbono09,0)
          WHEN 10  THEN IsNull(CS.dblAbono10,0)
		  WHEN 11  THEN IsNull(CS.dblAbono11,0)   
          WHEN 12  THEN IsNull(CS.dblAbono12,0)
          END )	,intNivel
	FROM tbCuentasSaldos CS
	INNER JOIN #TempCuentas C ON C.strCuenta = CS.strCuenta
	WHERE CS.intEmpresa = @intEmpresa
	AND CS.intEjercicio = @intEjercicio 
	AND CS.strClasifDS IN (SELECT CONVERT(VARCHAR,intObra) FROM #TmpObras)
	AND ISNULL(CS.strClasifDS,'0') <> '0'
	GROUP BY CS.intEmpresa,CS.strCuenta,CS.strClasifDS,C.intNivel

	INSERT INTO #TempBalanza(intEmpresa,strEmpresa,strCuenta,strNomCuenta,Nivel1,Nivel2,Nivel3,strMes,intEjercicio, 
	intObra,strObra,strClaveObra,intColonia,strNombreColonia,dblSaldoInicial,dblCargo,dblAbono,dblSaldoFinal,intNivel)
	SELECT  @intEmpresa,@strEmpresa,CS.strCuenta,C.strNombre,SUBSTRING (CS.strCuenta,1,4),
			CASE WHEN SUBSTRING (CS.strCuenta,5,4) = '' THEN '0000' ELSE SUBSTRING (CS.strCuenta,5,4) END, 
			CASE WHEN SUBSTRING (CS.strCuenta,9,4) = '' THEN '0000' ELSE SUBSTRING (CS.strCuenta,9,4) END,
			@strMes,@intEjercicio,CS.intObra,ISNULL(O.strNombre, 'SIN OBRA'),
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
	PRINT 'Procedure Creation: dbo.usp_tbPolizasDet_Balanza_Obra Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbPolizasDet_Balanza_Obra Error on Creation'
END
GO



















