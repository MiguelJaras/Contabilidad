


IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbPolizasDet_Balanza_Cero')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbPolizasDet_Balanza_Cero
	PRINT N'Drop Procedure : dbo.usp_tbPolizasDet_Balanza_Cero - Succeeded !!!'
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


CREATE PROCEDURE dbo.usp_tbPolizasDet_Balanza_Cero
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
	@intSectorFin	INT
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
	CREATE TABLE #TempCuentas(intEmpresa int, strCuenta VARCHAR(50) COLLATE SQL_Latin1_General_CP1_CI_AS, strNombre VARCHAR(200))
	CREATE TABLE #TempBalanza(strCuenta VARCHAR(50),strNombre VARCHAR(250),intNivel INT,SdoIni decimal(18,2),
	MesCargo decimal(18,2),MesAbono decimal(18,2),SdoFin decimal(18,2),Mes VARCHAR(50),intEmpresa VARCHAR(250))
	CREATE TABLE #TmpSaldos(intEmpresa int, strCuenta varchar(100), intObra INT, dblSaldoInicial decimal(18,2),
	dblSaldoCargos decimal(18,2), dblSaldoAbonos decimal(18,2))

	INSERT INTO #TmpObras(intObra)
	SELECT DISTINCT O.intObra
	FROM VetecMarfil.dbo.tbObra O 
	WHERE O.intEmpresa = @intEmpresa
	AND ((@strObra = '0') OR (O.strClave BETWEEN @strObra AND @strObraFin))
	AND ((@intAreaIni = 0) OR (CONVERT(int, SUBSTRING(O.strClave, 1, 2)) BETWEEN @intAreaIni AND @intAreaFin))
	AND ((@intColIni = 0 AND @intColFin = 0) OR (O.intColonia BETWEEN @intColIni AND @intColFin))
	AND ((@intSectorIni = 0 AND @intSectorFin = 0) OR (O.intSector BETWEEN @intSectorIni AND @intSectorFin))

	INSERT INTO #TempCuentas(intEmpresa, strCuenta, strNombre)
	SELECT intEmpresa, strCuenta,strNombre  
	FROM dbo.fn_tbCuentas_Nivel(@intEmpresa,@intnivel,@strCuentaIni,@strCuentaFin)

	INSERT INTO tbCuentasSaldos      
	([intEmpresa], [intEjercicio], [strCuenta], [strClasifEnc], [strClasifDP],       
	[strClasifDS], [intIndInterEmpresa], [intTipoMoneda], [dblSaldoInicial],       
	[dblCargo01], [dblAbono01], [dblCargo02], [dblAbono02], [dblCargo03], [dblAbono03],       
	[dblCargo04], [dblAbono04], [dblCargo05], [dblAbono05], [dblCargo06], [dblAbono06],       
	[dblCargo07], [dblAbono07], [dblCargo08], [dblAbono08], [dblCargo09], [dblAbono09],       
	[dblCargo10], [dblAbono10], [dblCargo11], [dblAbono11], [dblCargo12], [dblAbono12],       
	[datFechaAlta], [strUsuarioAlta], [strMaquinaAlta], [datFechaMod], [strUsuarioMod], [strMaquinaMod])       
	SELECT DISTINCT intEmpresa,@intEjercicio,strCuenta, '0','','',0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,      
	Null, Null, Null, Null, Null, Null      
	FROM #TempCuentas
	WHERE strCuenta NOT IN(SELECT strCuenta FROM tbCuentasSaldos WHERE intEmpresa = @intEmpresa AND intEjercicio = @intEjercicio)

	SELECT @strEmpresa = strNombre FROM tbEmpresas WHERE intEmpresa = @intEmpresa	

	INSERT INTO #TmpSaldos(intEmpresa,strCuenta,intObra,dblSaldoInicial,dblSaldoCargos,dblSaldoAbonos)
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
          END )	
	FROM tbCuentasSaldos CS
	WHERE CS.intEmpresa = @intEmpresa
	AND CS.intEjercicio = @intEjercicio 
	AND CS.strCuenta IN (SELECT strCuenta FROM #TempCuentas)
	AND CS.strClasifDS IN (SELECT intObra FROM #TmpObras)
	AND ((CS.strClasifDS <> '0') OR (CS.strClasifDS IS NOT NULL))
	GROUP BY CS.intEmpresa,CS.strCuenta,CS.strClasifDS

	DECLARE @Cuentas TABLE (strCuenta VARCHAR(50))
	INSERT INTO @Cuentas	
	SELECT strCuenta 
	FROM #TmpSaldos
	WHERE dblSaldoInicial <> 0 OR dblSaldoCargos <> 0 OR dblSaldoAbonos <> 0

	DELETE FROM #TmpSaldos WHERE strCuenta collate SQL_Latin1_General_CP1_CI_AS in(SELECT strCuenta FROM @Cuentas)

	INSERT INTO #TempBalanza(strCuenta,strNombre,intNivel,SdoIni,MesCargo,MesAbono,Mes,intEmpresa)
	SELECT  CS.strCuenta,C.strNombre,1,SUM(CS.dblSaldoInicial),SUM(CS.dblSaldoCargos),SUM(CS.dblSaldoAbonos),
	@strMes,@strEmpresa				
	FROM #TmpSaldos CS
	INNER JOIN #TempCuentas C ON C.strCuenta COLLATE SQL_Latin1_General_CP1_CI_AS = CS.strCuenta AND C.intEmpresa = CS.intEmpresa
	LEFT JOIN VetecMarfil.dbo.tbObra O ON O.intObra = CS.intObra AND O.intEmpresa = CS.intEmpresa
	LEFT JOIN VetecMarfil.dbo.tbColonia Col ON Col.intColonia = SUBSTRING(O.strClave, 4, 2)
	WHERE CS.intEmpresa = @intEmpresa
	GROUP BY CS.strCuenta,C.strNombre
			
	UPDATE #TempBalanza SET SdoFin = SdoIni + MesCargo - MesAbono

	SELECT	strCuenta,strNombre,intNivel,SdoIni,MesCargo,MesAbono,SdoFin,Mes,intEmpresa
	FROM #TempBalanza
	--WHERE ISNULL(SdoIni,0) + ISNULL(MesCargo,0) - ISNULL(MesAbono,0) + ISNULL(SdoFin,0) = 0
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
	PRINT 'Procedure Creation: dbo.usp_tbPolizasDet_Balanza_Cero Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbPolizasDet_Balanza_Cero Error on Creation'
END
GO
