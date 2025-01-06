
use vetecmarfiladmin

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbPolizasDet_Auxiliar')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbPolizasDet_Auxiliar
	PRINT N'Drop Procedure : dbo.usp_tbPolizasDet_Auxiliar - Succeeded !!!'
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


CREATE PROCEDURE dbo.usp_tbPolizasDet_Auxiliar
( 
	@intEmpresa			int, 
	@datFechaIni		varchar(50),	
	@datFechaFin		varchar(50),	
	@strCuentaIni		VarChar(50), 
	@strCuentaFin		VarChar(50),
	@strObra			VarChar(50),
	@strObraFin			VarChar(50),
	@intAreaIni			INT,   
	@intAreaFin			INT,
	@intColIni			INT, 
	@intColFin			INT, 
	@intCero			INT,
	@datFechaPrint		varchar(20) = '0',
	@strReferencia		varchar(2) = '0'
)
AS    
BEGIN
	SET NOCOUNT ON 

	SET LANGUAGE SPANISH

	DECLARE @datFecha VARCHAR(50)
	DECLARE @strMes VARCHAR(100)
	DECLARE @strEmpresa VARCHAR(200)	
	DECLARE @Rows int
	DECLARE @Count int	
	DECLARE @strCuentaN VARCHAR(50)
	DECLARE @Suma DECIMAL(18,2)	
	DECLARE @intEjercicio INT	
	DECLARE @intMes int

	SELECT @strEmpresa = strNombre FROM tbEmpresas WHERE intEmpresa = @intEmpresa

	------------------------------------INICIA FORMATO FECHA MDY-------------------------------------
	--IF @intEmpresa = 22 
	--BEGIN
	--	SET LANGUAGE ENGLISH  		

	--	SET @datFecha =  @datFechaIni
	
	--	SELECT @strMes = DATENAME(MONTH,CONVERT(DATETIME, @datFechaIni) )
	--END
	--ELSE
	--BEGIN	
	--	SET LANGUAGE SPANISH 
	--	SELECT @strMes = strNombre FROM tbMeses WHERE intMes = MONTH(@datFechaIni)
	--END
	------------------------------------FIN FORMATO FECHA MDY-------------------------------------

	DECLARE @Obras AS Table(intObra INT, strClave VARCHAR(50))	
	DECLARE @Cuentas AS Table(intEmpresa int, strCuenta VARCHAR(50) COLLATE SQL_Latin1_General_CP1_CI_AS, strNombre VARCHAR(200),
	intCtaRegistro int, dblSaldoInicial decimal(18,2), strCuentaRel VARCHAR(50), intNivel INT)
	DECLARE @Cuentas2 AS Table(intEmpresa int, strCuenta VARCHAR(50) COLLATE SQL_Latin1_General_CP1_CI_AS, strNombre VARCHAR(200),
	intCtaRegistro int, dblSaldoInicial decimal(18,2), strCuentaRel VARCHAR(50), intNivel INT)
	DECLARE @CuentasSaldos AS Table(strCuenta VARCHAR(50),dblSaldoInicial decimal(18,2),dblSaldoCargo decimal(18,2),
	dblSaldoAbono decimal(18,2))
	DECLARE @CuentasSaldosMes AS Table(strCuenta VARCHAR(50),dblSaldoCargo decimal(18,2),dblSaldoAbono decimal(18,2))
	DECLARE @PolizasEnc TABLE(intEmpresa int,intEjercicio int, intMes int, strPoliza varchar(20))
	DECLARE @PolizasDet TABLE(strPoliza VARCHAR(50),strCuenta VARCHAR(50),dblCargo decimal(18,2),dblAbono decimal(18,2),
	datFecha datetime,strReferencia VARCHAR(50),strAuxiliar VARCHAR(50),strDescripcion VARCHAR(300))

	CREATE TABLE #TempCuentasN1(id int identity(1,1),intEmpresa int,strCuenta VARCHAR(50) COLLATE SQL_Latin1_General_CP1_CI_AS)
	CREATE TABLE #TempCuentasN2(id int identity(1,1),intEmpresa int,strCuenta VARCHAR(50) COLLATE SQL_Latin1_General_CP1_CI_AS)
	CREATE TABLE #TempCuentasN3(id int identity(1,1),intEmpresa int,strCuenta VARCHAR(50) COLLATE SQL_Latin1_General_CP1_CI_AS)
	CREATE TABLE #TempCuentasAll(id int identity(1,1),strCuenta VARCHAR(50) COLLATE SQL_Latin1_General_CP1_CI_AS, 
	strPoliza VARCHAR(50),strReferencia VARCHAR(50), datFecha datetime, dblImporte DECIMAL(18,2), dblSaldo DECIMAL(18,2))
	
	CREATE TABLE #TempPolizas(Id int Identity(1,1), Cuenta varchar(10), SubCuenta varchar(10), SubSubReporte varchar(10), 
	CuentaNombre varchar(200), Poliza varchar(100), TipoPoliza varchar(50), Fecha datetime, CentroCosto varchar(100),
	Referencia Varchar(100), Descripcion varchar(500), Cargos decimal(18,2), Abonos decimal(18,2),
	Saldo decimal(18,2), SaldoCargos MONEY, SaldoAbonos MONEY, SaldoActual MONEY, strCuenta VARCHAR(100), 
	dblSaldoInicial MONEY, intNivel int, Auxiliar varchar(50), strHeader VARCHAR(100), strHeader2 VARCHAR(100),
	dblHeader MONEY, dblHeader2 MONEY, Folio int, Partida int)

	INSERT INTO @Obras(intObra,strClave)
	SELECT DISTINCT O.intObra,strClave
	FROM VetecMarfil.dbo.tbObra O 
	WHERE O.intEmpresa = @intEmpresa
	AND ((@strObra = '0') OR (O.strClave BETWEEN @strObra AND @strObraFin))
	AND ((@intAreaIni = 0) OR (CONVERT(int, SUBSTRING(O.strClave, 1, 2)) BETWEEN @intAreaIni AND @intAreaFin))
	AND ((@intColIni = 0 AND @intColFin = 0) OR (O.intColonia BETWEEN @intColIni AND @intColFin))
	--AND ((@intSectorIni = 0 AND @intSectorFin = 0) OR (O.intSector BETWEEN @intSectorIni AND @intSectorFin))


	INSERT INTO @Cuentas(intEmpresa, strCuenta, strNombre,intCtaRegistro,strCuentaRel,intNivel)
	SELECT intEmpresa, strCuenta,strNombre,1,strCuenta,intNivel
	FROM dbo.fn_tbCuentas_Nivel(@intEmpresa,0,@strCuentaIni,@strCuentaFin)

--	IF(@strCuentaIni = '0')
--	BEGIN
--		INSERT INTO @Cuentas(intEmpresa, strCuenta, strNombre,intCtaRegistro,strCuentaRel,intNivel)
--		SELECT DISTINCT intEmpresa, strCuenta,strNombre,1,strCuenta,intNivel 
--		FROM tbCuentas
--		WHERE intEmpresa = @intEmpresa
--		AND intCtaRegistro = 1	
--	END
--	ELSE
--	BEGIN
--		IF(@strCuentaIni = @strCuentaFin)
--		BEGIN	
--			INSERT INTO @Cuentas(intEmpresa, strCuenta, strNombre,strCuentaRel)
--			SELECT DISTINCT intEmpresa, strCuenta,strNombre,strCuenta  
--			FROM tbCuentas
--			WHERE strCuenta = @strCuentaIni
--			AND intEmpresa = @intEmpresa			
--		END
--		ELSE
--		BEGIN
--			IF(LEN(@strCuentaFin) = 12)
--			BEGIN						
--				INSERT INTO @Cuentas(intEmpresa, strCuenta, strNombre,strCuentaRel)
--				SELECT DISTINCT intEmpresa, strCuenta,strNombre,strCuenta  
--				FROM tbCuentas
--				WHERE LEN(strCuenta) = 12
--				AND strCuenta BETWEEN @strCuentaIni AND @strCuentaFin
--				AND intEmpresa = @intEmpresa
--			END

--			IF(LEN(@strCuentaFin) = 8)
--			BEGIN
--				INSERT INTO @Cuentas(intEmpresa, strCuenta, strNombre,strCuentaRel)
--				SELECT DISTINCT intEmpresa, strCuenta,strNombre,strCuenta  
--				FROM tbCuentas
--				WHERE LEN(strCuenta) = 8
--				AND strCuenta BETWEEN @strCuentaIni AND @strCuentaFin
--				AND intEmpresa = @intEmpresa
--			END
				
--			IF(LEN(@strCuentaIni) = 4)
--			BEGIN
--		INSERT INTO @Cuentas(intEmpresa, strCuenta, strNombre,strCuentaRel)
--				SELECT DISTINCT intEmpresa,strCuenta,strNombre,strCuenta  
--				FROM tbCuentas
--				WHERE LEN(strCuenta) = 4
--				AND strCuenta BETWEEN @strCuentaIni AND @strCuentaFin
--				AND intEmpresa = @intEmpresa
--			END			
				
----		--primer nivel
----		INSERT INTO @Cuentas(intEmpresa, strCuenta, strNombre,strCuentaRel)
----		SELECT DISTINCT C.intEmpresa, C.strCuenta,C.strNombre,C.strCuenta  
----		FROM tbCuentas C
----		INNER JOIN @Cuentas T ON T.intEmpresa = C.intEmpresa AND LEFT(T.strCuenta,4) = C.strCuenta
----		WHERE C.intEmpresa = @intEmpresa
----		AND T.intCtaRegistro = 1
----
----		--segundo nivel
----		INSERT INTO @Cuentas(intEmpresa, strCuenta, strNombre,strCuentaRel)
----		SELECT DISTINCT C.intEmpresa, C.strCuenta,C.strNombre,C.strCuenta   
----		FROM tbCuentas C
----		INNER JOIN @Cuentas T ON T.intEmpresa = C.intEmpresa AND LEFT(T.strCuenta,8) = C.strCuenta
----		WHERE C.intEmpresa = @intEmpresa
----		AND T.intCtaRegistro = 1
--		END
--	END

--		INSERT INTO @Cuentas(intEmpresa, strCuenta, strNombre,strCuentaRel)
	--SELECT intEmpresa, strCuenta, strNombre,strCuentaRel
	--FROM @Cuentas2

	SET @intEjercicio = YEAR(@datFechaIni)
	SET @intMes = MONTH(@datFechaIni) - 1

	INSERT INTO @CuentasSaldos(strCuenta,dblSaldoInicial,dblSaldoCargo,dblSaldoAbono)
	SELECT CS.strCuenta,SUM(CASE @intMes    
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
	   WHEN 0 Then IsNull(CS.dblSaldoInicial, 0)
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
	INNER JOIN @Cuentas C ON C.strCuenta = CS.strCuenta
	WHERE CS.intEmpresa = @intEmpresa
	AND CS.intEjercicio = @intEjercicio 
	AND ISNULL(CS.strClasifDS,'0') <> '0'
	GROUP BY CS.strCuenta
	
	INSERT INTO @CuentasSaldosMes(strCuenta,dblSaldoCargo,dblSaldoAbono)
	SELECT PD.strCuenta,SUM(CASE WHEN PD.intTipoMovto = 0 THEN 0 ELSE PD.dblImporte END),SUM(CASE WHEN PD.intTipoMovto = 1 THEN 0 ELSE PD.dblImporte END)
	FROM tbPolizasDet PD
	INNER JOIN tbPolizasEnc PE ON PE.intEmpresa = PD.intEmpresa AND PD.intEjercicio = PE.intEjercicio AND PD.strPoliza = PE.strPoliza
	WHERE PD.intEmpresa = @intEmpresa
	AND PD.intEjercicio = @intEjercicio
	AND PD.intMes > @intMes
	AND PD.datFecha < @datFechaIni
	AND PE.intEstatus <> 9
	GROUP BY strCuenta

	--select @intMes
	--select @datFechaIni
	--select * from @CuentasSaldos
	--select * from @CuentasSaldosMes

	UPDATE CS
	SET CS.dblSaldoCargo = CS.dblSaldoCargo + PD.dblSaldoCargo,CS.dblSaldoAbono = CS.dblSaldoAbono + PD.dblSaldoAbono
	FROM @CuentasSaldos CS
	INNER JOIN @CuentasSaldosMes PD ON PD.strCuenta = CS.strCuenta

	UPDATE C
	SET C.dblSaldoInicial = CS.dblSaldoInicial + ISNULL(dblSaldoCargo,0) - ISNULL(dblSaldoAbono,0)
	FROM @Cuentas C
	INNER JOIN  @CuentasSaldos CS ON CS.strCuenta = C.strCuenta

	INSERT INTO @PolizasEnc(intEmpresa,intEjercicio,intMes,strPoliza)
	SELECT intEmpresa,intEjercicio,intMes,strPoliza
	FROM tbPolizasEnc
	WHERE intEmpresa = @intEmpresa
	AND datFecha BETWEEN @datFechaIni AND @datFechaFin
	AND intEstatus <> 9
	AND dblCargos = dblAbonos	
	AND dblCargos <> 0

	INSERT INTO #TempPolizas(Cuenta,SubCuenta,SubSubReporte,CuentaNombre,Poliza,TipoPoliza,Fecha,CentroCosto,
	Referencia,Descripcion,Cargos,Abonos,Saldo, strCuenta, intNivel,dblSaldoInicial,Auxiliar,Folio,Partida) 
	SELECT 	Cuenta = LEFT(T.strCuenta,4),SubCuenta = (CASE WHEN LEN(T.strCuenta) > 4 THEN SUBSTRING(T.strCuenta, 5, 4) ELSE '' END),
	SubSubReporte = (CASE WHEN LEN(T.strCuenta) > 8 THEN SUBSTRING(T.strCuenta, 9, 4) ELSE '' END),
	CuentaNombre = T.strNombre,PD.strPoliza, PD.strTipoPoliza, PD.datFecha, ISNULL(O.strClave,'0'),
	--CASE WHEN PD.strcuenta in('51100034','51100036','6007','21500001','21500002','21810001','21810002','21810003') THEN strClaveRef ELSE strReferencia END, 
	CASE WHEN @strReferencia = '1' 
	THEN
		strReferencia
	ELSE
		CASE WHEN PD.strcuenta in('51100034','51100036','6007','21500001','21500002','21810001','21810002','21810003') 
			THEN strClaveRef 
			ELSE CASE WHEN LEN(strReferencia) > 30 THEN strClaveRef ELSE strReferencia END
		END
	END,
	PD.strDescripcion, 
	CASE WHEN PD.intTipoMovto = 1 THEN ABS(ISNULL(PD.dblImporte,0)) ELSE 0 END,
	CASE WHEN PD.intTipoMovto = 1 THEN 0 ELSE ABS(ISNULL(PD.dblImporte,0)) * -1 END,  
	NULL, T.strCuentaRel,T.intNivel,T.dblSaldoInicial,PD.strClasifDP, PD.intFolioPoliza,PD.intPartida
	FROM tbPolizasDet PD
	INNER JOIN @PolizasEnc P ON P.strPoliza = PD.strPoliza AND P.intEjercicio = PD.intEjercicio AND P.intEmpresa = PD.intEmpresa AND P.strPoliza = PD.strPoliza
	INNER JOIN @Cuentas T ON T.intEmpresa = PD.intEmpresa AND T.strCuenta = PD.strCuenta
	INNER JOIN @Obras O ON CONVERT(VARCHAR,O.intObra) = PD.strClasifDS
	WHERE PD.intEmpresa = @intEmpresa
	AND PD.datFecha BETWEEN @datFechaIni AND @datFechaFin
	AND PD.intIndAfectada = 1 	

--
--	INNER JOIN @Cuentas T ON T.intEmpresa = C.intEmpresa AND T.strCuenta = C.strCuenta
--	INNER JOIN @Obras O ON CONVERT(VARCHAR,O.intObra) = PD.strClasifDS
--	WHERE C.intEmpresa = @intEmpresa 	
--	AND PD.datFecha BETWEEN @datFechaIni AND @datFechaFin
--	AND PD.intIndAfectada = 1 
--	ORDER BY C.strCuenta, PD.datFecha, PD.strPoliza		

	INSERT INTO #TempPolizas(Cuenta,SubCuenta,SubSubReporte,CuentaNombre,Poliza,TipoPoliza,Fecha,CentroCosto,
	Referencia,Descripcion,Cargos,Abonos,Saldo, strCuenta, intNivel,dblSaldoInicial)    
	SELECT DISTINCT Cuenta = LEFT(C.strCuenta,4),SubCuenta = (CASE WHEN LEN(C.strCuenta) > 4 THEN SUBSTRING(C.strCuenta, 5, 4) ELSE '' END),
	SubSubReporte = (CASE WHEN LEN(C.strCuenta) > 8 THEN SUBSTRING(C.strCuenta, 9, 4) ELSE '' END),
	CuentaNombre = C.strNombre,'','','',NULL,NULL,NULL,0,0,0,T.strCuentaRel,C.intNivel,T.dblSaldoInicial
	FROM @Cuentas T
	INNER JOIN tbCuentas C ON T.intEmpresa = C.intEmpresa AND T.strCuenta = C.strCuenta
	WHERE T.intCtaRegistro IS NULL

	INSERT INTO #TempPolizas(Cuenta,SubCuenta,SubSubReporte,CuentaNombre,Poliza,TipoPoliza,Fecha,CentroCosto,
	Referencia,Descripcion,Cargos,Abonos,Saldo, strCuenta, intNivel,dblSaldoInicial)    
	SELECT DISTINCT Cuenta = LEFT(C.strCuenta,4),SubCuenta = (CASE WHEN LEN(C.strCuenta) > 4 THEN SUBSTRING(C.strCuenta, 5, 4) ELSE '' END),
	SubSubReporte = (CASE WHEN LEN(C.strCuenta) > 8 THEN SUBSTRING(C.strCuenta, 9, 4) ELSE '' END),
	CuentaNombre = C.strNombre,'','','',NULL,NULL,NULL,0,0,T.dblSaldoInicial,T.strCuenta,C.intNivel,T.dblSaldoInicial
	FROM @Cuentas T
	INNER JOIN tbCuentas C ON T.intEmpresa = C.intEmpresa AND T.strCuenta = C.strCuenta
	WHERE T.intCtaRegistro = 1

	                       
--	SELECT 	Cuenta = LEFT(C.strCuenta,4),SubCuenta = (CASE WHEN LEN(C.strCuenta) > 4 THEN SUBSTRING(C.strCuenta, 5, 4) ELSE '' END),
--	SubSubReporte = (CASE WHEN LEN(C.strCuenta) > 8 THEN SUBSTRING(C.strCuenta, 9, 4) ELSE '' END),
--	CuentaNombre = C.strNombre,PD.strPoliza, PD.strTipoPoliza, PD.datFecha, 
--	ISNULL(O.strClave,'0'),strReferencia, PD.strDescripcion, 
--	CASE WHEN PD.intTipoMovto = 1 THEN ABS(ISNULL(PD.dblImporte,0)) ELSE 0 END,
--	CASE WHEN PD.intTipoMovto = 1 THEN 0 ELSE ABS(ISNULL(PD.dblImporte,0)) * -1 END,  
--	NULL, T.strCuentaRel,C.intNivel,T.dblSaldoInicial,PD.strClasifDP, PD.intFolioPoliza,PD.intPartida
--	FROM tbCuentas C
--	INNER JOIN tbPolizasDet PD ON C.intEmpresa = PD.intEmpresa AND C.strCuenta = PD.strCuenta 
--	INNER JOIN @PolizasEnc P ON P.strPoliza = PD.strPoliza AND P.intEjercicio = PD.intEjercicio AND P.intEmpresa = PD.intEmpresa AND P.strPoliza = PD.strPoliza
--	INNER JOIN @Cuentas T ON T.intEmpresa = C.intEmpresa AND T.strCuenta = C.strCuenta
--	INNER JOIN @Obras O ON CONVERT(VARCHAR,O.intObra) = PD.strClasifDS
--	WHERE C.intEmpresa = @intEmpresa 	
--	AND PD.datFecha BETWEEN @datFechaIni AND @datFechaFin
--	AND PD.intIndAfectada = 1 
--	ORDER BY C.strCuenta, PD.datFecha, PD.strPoliza

	UPDATE T
	SET strHeader = C.strNombre
	FROM #TempPolizas T
	INNER JOIN tbCuentas C ON T.Cuenta collate SQL_Latin1_General_CP1_CI_AS = C.strCuenta
	WHERE C.intEmpresa = @intEmpresa	
	
	UPDATE T
	SET strHeader2 = C.strNombre
	FROM #TempPolizas T
	INNER JOIN tbCuentas C ON LEFT(T.strCuenta,8) collate SQL_Latin1_General_CP1_CI_AS = C.strCuenta
	WHERE C.intEmpresa = @intEmpresa
--
--	INSERT INTO #TempCuentasN1(intEmpresa,strCuenta)
--	SELECT DISTINCT @intEmpresa, C.strCuenta
--	FROM #TempCuentas T
--	INNER JOIN tbCuentas C ON T.strCuenta collate SQL_Latin1_General_CP1_CI_AS = C.strCuenta
--	WHERE C.intEmpresa = @intEmpresa
--	AND C.intNivel = 1
--
--	INSERT INTO #TempCuentasN2(intEmpresa,strCuenta)
--	SELECT DISTINCT @intEmpresa, C.strCuenta
--	FROM #TempCuentas T
--	INNER JOIN tbCuentas C ON T.strCuenta collate SQL_Latin1_General_CP1_CI_AS = C.strCuenta
--	WHERE C.intEmpresa = @intEmpresa
--	AND C.intNivel = 2
--	
--	SELECT @Rows = COUNT(*) FROM #TempCuentasN1
--	SET @Count = 0
--
--	WHILE(@Rows > @Count)
--	BEGIN
--		SET @Count = @Count + 1
--		SELECT @strCuentaN = strCuenta FROM #TempCuentasN1 WHERE id = @Count
--
--		--SELECT @Suma = dbo.F_Sdoini(@intEmpresa,'0',@intEjercicioFin,@intMesFin + 1,'0',@strCuentaN,'0',0)
--
--		UPDATE #TempPolizas
--		SET dblHeader = @Suma
--		WHERE LEFT(strCuenta,4) = @strCuentaN
--	
--		SET @strCuentaN = ''
--		SET @Suma = 0
--	END
--
--	DROP TABLE #TempCuentasN1
--
--	SELECT @Rows = COUNT(*) FROM #TempCuentasN2
--	SET @Count = 0
--
--	WHILE(@Rows > @Count)
--	BEGIN
--		SET @Count = @Count + 1
--		SELECT @strCuentaN = strCuenta FROM #TempCuentasN2 WHERE id = @Count
--
--		--SELECT @Suma = dbo.F_Sdoini(@intEmpresa,'0',@intEjercicioFin,@intMesFin + 1,'0',@strCuentaN,'0',0)
--
--		UPDATE #TempPolizas
--		SET dblHeader2 = @Suma
--		WHERE LEFT(strCuenta,8) = @strCuentaN
--	
--		SET @strCuentaN = ''
--		SET @Suma = 0
--	END
--
--	DROP TABLE #TempCuentasN2
--
	UPDATE T
	SET Saldo = CASE WHEN ISNULL(Poliza,'') <> '' THEN Cargos - ABS(Abonos) ELSE dblSaldoInicial END
	FROM #TempPolizas T
	--WHERE Poliza <> ''
--
--	UPDATE TT
--	SET TT.Auxiliar = ISNULL((SELECT TOP 1 1 FROM #TempPolizas T WHERE LEFT(T.strCuenta,4) = LEFT(TT.strCuenta,4) AND LEN(T.strCuenta) > 4),0)
--	FROM #TempPolizas TT
--	WHERE TT.intNivel = 1
--
--	UPDATE TT
--	SET TT.Auxiliar = ISNULL((SELECT TOP 1 1 FROM #TempPolizas T WHERE LEFT(T.strCuenta,8) = LEFT(TT.strCuenta,8) AND LEN(T.strCuenta) > 8),0)
--	FROM #TempPolizas TT
--	WHERE TT.intNivel = 2
--
	UPDATE TT
	SET TT.dblHeader2 = 0
	FROM #TempPolizas TT
	WHERE TT.dblHeader2 IS NULL

	UPDATE TT
	SET TT.Auxiliar = 0
	FROM #TempPolizas TT
	WHERE TT.Auxiliar IS NULL

--	INSERT INTO #TempCuentasN3(strCuenta)
--	SELECT DISTINCT strCuenta
--	FROM #TempCuentas
--	WHERE intCtaRegistro = 1
--
--	SELECT @Rows = COUNT(*) FROM #TempCuentasN3
--	SET @Count = 0
--
--	WHILE(@Rows > @Count)
--	BEGIN
--		SET @Count = @Count + 1
--		SELECT @strCuentaN = strCuenta FROM #TempCuentasN3 WHERE id = @Count
--	
--		INSERT INTO #TempCuentasAll(strCuenta,strPoliza,strReferencia,datFecha,dblImporte)
--		SELECT T.strCuenta,T.Poliza,T.Referencia,T.Fecha,T.Saldo
--		FROM #TempPolizas T
--		INNER JOIN #TempCuentas C ON T.strCuenta COLLATE SQL_Latin1_General_CP1_CI_AS = C.strCuenta
--		WHERE C.intEmpresa = @intEmpresa
--		AND C.intCtaRegistro = 1
--		AND C.strCuenta = @strCuentaN
--		ORDER BY strCuenta,Fecha,Poliza ASC
--
--		DELETE FROM #TempCuentasAll WHERE dblImporte = 0
--
--		UPDATE C1
--		SET C1.dblSaldo = (SELECT SUM(C2.dblImporte) FROM #TempCuentasAll C2 WHERE (C2.id < C1.id) or (C2.id = C1.id))
--		FROM #TempCuentasAll C1
--
--		UPDATE T
--		SET T.Saldo = TT.dblSaldo
--		FROM #TempPolizas T
--		INNER JOIN #TempCuentasAll TT ON TT.strCuenta = T.strCuenta COLLATE SQL_Latin1_General_CP1_CI_AS AND T.Poliza = TT.strPoliza COLLATE SQL_Latin1_General_CP1_CI_AS
--		AND TT.strReferencia = T.Referencia AND TT.datFecha = T.Fecha
--
--		TRUNCATE TABLE #TempCuentasAll
--	END
--
--	DROP TABLE #TempCuentasN3
--	DROP TABLE #TempCuentasAll
	
--
--	UPDATE T
--	SET SaldoCargos = (SELECT SUM(ISNULL(Cargos,0)) FROM #TempPolizas TT WHERE TT.strCuenta = T.strCuenta)
--	FROM #TempPolizas T
--
--	UPDATE T
--	SET SaldoAbonos = (SELECT SUM(ISNULL(Abonos,0)) FROM #TempPolizas TT WHERE TT.strCuenta = T.strCuenta)
--	FROM #TempPolizas T
--
--	UPDATE T
--	SET SaldoActual = dblSaldoInicial + SaldoCargos - ABS(SaldoAbonos)
--	FROM #TempPolizas T

	IF(@intCero = 1)
	BEGIN
		DELETE FROM #TempPolizas WHERE  ISNULL(Cargos,0) = 0 AND ISNULL(Abonos,0) = 0 and Referencia is not null-- AND ISNULL(Poliza,'') <> ''  --strCuenta IN(SELECT strCuenta FROM #TempPolizas GROUP BY strCuenta HAVING SUM(CARGOS) = 0 AND SUM(ABONOS) = 0)
		DELETE FROM #TempPolizas WHERE  ISNULL(Cargos,0) = 0 AND ISNULL(Abonos,0) = 0 and isnull(Saldo,0) = 0
	END

	--select @intCero
	--select * from #TempPolizas

	SELECT @intEmpresa as intEmpresa,@strEmpresa as Empresa,Cuenta+SubCuenta+SubSubReporte AS Grupo,Cuenta,SubCuenta,
	SubSubReporte,CuentaNombre,Poliza,TipoPoliza,CONVERT(VARCHAR,Fecha,103) AS Fecha,CentroCosto,Referencia,Descripcion,Cargos,
	Abonos,Saldo,SaldoCargos,SaldoAbonos,SaldoActual,strCuenta,dblSaldoInicial,intNivel,Auxiliar,strHeader,strHeader2,
	dblHeader,dblHeader2
	FROM #TempPolizas	
	ORDER BY YEAR(Fecha), MONTH(Fecha), DAY(Fecha), TipoPoliza, Folio,Partida

	--Excel
	SELECT @intEmpresa as intEmpresa,@strEmpresa as Empresa,
	Cuenta,SubCuenta,
	SubSubReporte,CuentaNombre,Poliza,
	CASE WHEN Fecha = '01/01/1900' THEN '' ELSE CONVERT(VARCHAR,Fecha,103) END AS Fecha,CentroCosto,Referencia,Descripcion,
	dblSaldoInicial,Cargos,Abonos,(dblSaldoInicial+Cargos-Abonos) as SaldoFinal,--Saldo,
	intNivel,Auxiliar,strHeader,strHeader2,Fecha
	dblHeader,dblHeader2
	FROM #TempPolizas	
	ORDER BY YEAR(Fecha), MONTH(Fecha), DAY(Fecha), TipoPoliza, Folio,Partida

	DROP TABLE #TempPolizas

SET NOCOUNT OFF
END
GO 

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbPolizasDet_Auxiliar Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbPolizasDet_Auxiliar Error on Creation'
END
GO
