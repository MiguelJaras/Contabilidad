

use VetecMarfilAdmin

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbPolizasDet_Balanza')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbPolizasDet_Balanza
	PRINT N'Drop Procedure : dbo.usp_tbPolizasDet_Balanza - Succeeded !!!'
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


CREATE PROCEDURE dbo.usp_tbPolizasDet_Balanza
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
	@datFechaPrint	varchar(20) = '0'
)
AS    
BEGIN
	SET NOCOUNT ON    

	DECLARE @datFecha VARCHAR(50)
	DECLARE @strMes VARCHAR(100)
	DECLARE @strEmpresa VARCHAR(200)	
	DECLARE @PolizasSin	INT

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
	CREATE TABLE #TempBalanza(strCuenta VARCHAR(50),strNombre VARCHAR(250),intNivel INT,SdoIni decimal(18,2),
	MesCargo decimal(18,2),MesAbono decimal(18,2),SdoFin decimal(18,2),Mes VARCHAR(50),intEmpresa VARCHAR(250))
	CREATE TABLE #TmpSaldos(intEmpresa int, strCuenta varchar(100), intNivel int, intObra VARCHAR(50), dblSaldoInicial decimal(18,2),
	dblSaldoCargos decimal(18,2), dblSaldoAbonos decimal(18,2))

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

	SELECT @PolizasSin = COUNT(*) 
	FROM tbPolizasEnc PE
	WHERE PE.intEmpresa = @intEmpresa
	AND	PE.intEjercicio = @intEjercicio
	AND PE.intMes = @intMes
	AND PE.IntindAfectada = 0
	AND PE.intEstatus <> 9

	INSERT INTO #TmpSaldos(intEmpresa,strCuenta,intNivel,intObra,dblSaldoInicial,dblSaldoCargos,dblSaldoAbonos)
	SELECT CS.intEmpresa,CS.strCuenta,C.intNivel,CS.strClasifDS,	
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
	   WHEN 0 Then IsNull(CS.dblSaldoInicial, 0) + ( IsNull(CS.dblCargo01, 0) - IsNull(CS.dblAbono01, 0) + IsNull(CS.dblCargo02, 0) - IsNull(CS.dblAbono02, 0) + IsNull(CS.dblCargo03, 0) - IsNull(CS.dblAbono03, 0) + IsNull(CS.dblCargo04, 0) - IsNull(CS.dblAbono04, 0) + IsNull(CS.dblCargo05, 0) - IsNull(CS.dblAbono05, 0) + IsNull(CS.dblCargo06, 0) - IsNull(CS.dblAbono06, 0) + IsNull(CS.dblCargo07, 0) - IsNull(CS.dblAbono07, 0) + IsNull(CS.dblCargo08, 0) - IsNull(CS.dblAbono08, 0) + IsNull(CS.dblCargo09, 0) - IsNull(CS.dblAbono09, 0) + IsNull(CS.dblCargo10, 0) - IsNull(CS.dblAbono10, 0) + IsNull(CS.dblCargo11, 0) - IsNull(CS.dblAbono11, 0) + IsNull(CS.dblCargo12, 0) - IsNull(CS.dblAbono12, 0) )
       END ),
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
	INNER JOIN #TempCuentas C ON C.strCuenta = CS.strCuenta
	INNER JOIN VetecMarfil..tbObra OBRA ON CONVERT(VARCHAR,OBRA.intObra) = CS.strClasifDS
	WHERE CS.intEmpresa = @intEmpresa
	AND CS.intEjercicio = @intEjercicio 
	AND ISNULL(CS.strClasifDS,'0') <> '0'
	GROUP BY CS.intEmpresa,CS.strCuenta,C.intNivel,CS.strClasifDS

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
--	END
			
	UPDATE #TempBalanza SET SdoFin = SdoIni + MesCargo - MesAbono

--	SELECT * FROM #TempBalanza WHERE ISNULL(SdoIni,0) = 0 AND (MesCargo - MesAbono) = 0 ORDER BY convert(int,strCuenta)

--	IF(@intNivel = 1)
--		DELETE FROM #TempBalanza WHERE ISNULL(SdoIni,0) = 0 AND (MesCargo - MesAbono) = 0 
--
--	IF(@intNivel = 2)
--		DELETE FROM #TempBalanza WHERE ISNULL(SdoIni,0) = 0 AND (MesCargo - MesAbono) = 0 AND LEN(strCuenta) = 8

	SELECT	strCuenta,strNombre,intNivel,SdoIni,MesCargo,MesAbono,SdoFin,Mes,intEmpresa,@PolizasSin as SinAfectar
	FROM #TempBalanza
	ORDER BY strCuenta

	--Excel
	SELECT ''''	+ strCuenta as Cuenta,strNombre as Nombre,intNivel as Nivel,SdoIni,MesCargo,MesAbono,SdoFin,Mes,intEmpresa as Empresa
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
	PRINT 'Procedure Creation: dbo.usp_tbPolizasDet_Balanza Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbPolizasDet_Balanza Error on Creation'
END
GO
