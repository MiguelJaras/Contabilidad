

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbPolizasDet_Saldos')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbPolizasDet_Saldos
	PRINT N'Drop Procedure : dbo.usp_tbPolizasDet_Saldos - Succeeded !!!'
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


CREATE PROCEDURE dbo.usp_tbPolizasDet_Saldos
( 
	@intEmpresa INT, 
	@strCuenta VARCHAR(50), 
	@intClienteIni INT,   
    @intClienteFin INT, 
	@datFechaCorteIni DATETIME,
	@datFechaCorteFin DATETIME,
	@intColIni INT,
	@intColFin INT,
	@intSectorIni INT,
	@intSectorFin INT,
	@intClienteProveedor INT
)
AS    
BEGIN
	SET NOCOUNT ON 

	DECLARE @datFecha VARCHAR(50)
	DECLARE @strMes VARCHAR(100)
	DECLARE @strEmpresa VARCHAR(200)	
	DECLARE @Rows int
	DECLARE @Count int	
	DECLARE @strCuentaN VARCHAR(50)
	DECLARE @Suma DECIMAL(18,2)	
	DECLARE @intEjercicio INT	
	DECLARE @intMes int
	DECLARE @strNombreCuenta VARCHAR(200)

	SELECT @strEmpresa = strNombre FROM tbEmpresas WHERE intEmpresa = @intEmpresa
	SELECT @strNombreCuenta = strNombre FROM tbCuentas WHERE intEmpresa = @intEmpresa AND strCuenta = @strCuenta	

	DECLARE @Obras AS Table(intObra INT, strClave VARCHAR(50))	
	DECLARE @CuentasSaldos AS Table(strClasifDP VARCHAR(50),strNombreCliente varchar(250),dblSaldoInicial decimal(18,2),dblSaldoCargo decimal(18,2),
	dblSaldoAbono decimal(18,2))
	DECLARE @CuentasSaldosMes AS Table(strClasifDP VARCHAR(50), dblSaldoCargo decimal(18,2),dblSaldoAbono decimal(18,2))
	DECLARE @CuentasReales AS Table(strClasifDP VARCHAR(50),dblSaldoCargo decimal(18,2),dblSaldoAbono decimal(18,2))

	DECLARE @PolizasEnc TABLE(intEmpresa int,intEjercicio int, intMes int, strPoliza varchar(20))
	DECLARE @PolizasDet TABLE(strPoliza VARCHAR(50),strCuenta VARCHAR(50),dblCargo decimal(18,2),dblAbono decimal(18,2),
	datFecha datetime,strReferencia VARCHAR(50),strAuxiliar VARCHAR(50),strDescripcion VARCHAR(300))

	
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
	--AND ((@strObra = '0') OR (O.strClave BETWEEN @strObra AND @strObraFin))
	--AND ((@intAreaIni = 0) OR (CONVERT(int, SUBSTRING(O.strClave, 1, 2)) BETWEEN @intAreaIni AND @intAreaFin))
	AND ((@intColIni = 0 AND @intColFin = 0) OR (O.intColonia BETWEEN @intColIni AND @intColFin))
	--AND ((@intSectorIni = 0 AND @intSectorFin = 0) OR (O.intSector BETWEEN @intSectorIni AND @intSectorFin))
	
	SET @intEjercicio = YEAR(@datFechaCorteIni)
	SET @intMes = MONTH(@datFechaCorteIni) - 1
		
	
	IF(@intClienteProveedor = 0)
	BEGIN
		INSERT INTO @CuentasSaldos(strClasifDP,strNombreCliente,dblSaldoInicial,dblSaldoCargo,dblSaldoAbono)
		SELECT CONVERT(INT,CS.strClasifDP),P.strNombre,ISNULL(SUM(CASE @intMes    
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
		   WHEN 0 Then IsNull(CS.dblSaldoInicial,0) 
		   END ),0),
		  ISNULL(SUM(CASE @intMes    
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
			  END ),0),
			ISNULL(SUM(CASE @intMes    
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
			  END ),0)	
		FROM tbCuentasSaldos CS
		INNER JOIN tbProveedores P ON P.intEmpresa = CS.intEmpresa AND P.intProveedor = convert(int,strclasifdp)			
		WHERE CS.intEmpresa = @intEmpresa
		AND CS.intEjercicio = @intEjercicio 
		AND CS.strCuenta = @strCuenta
		AND ISNULL(CS.strClasifDS,'0') <> '0'
		AND CS.strClasifDP IS NOT NULL
		AND CS.strClasifDP <> '0'
		AND CS.strClasifDP <> 'NULL'
		GROUP BY CONVERT(INT,CS.strClasifDP),P.strNombre
		ORDER BY CONVERT(INT,CS.strClasifDP)

		INSERT INTO @CuentasSaldosMes(strClasifDP,dblSaldoCargo,dblSaldoAbono)
		SELECT CONVERT(int,PD.strClasifDP),SUM(CASE WHEN intTipoMovto = 0 THEN 0 ELSE dblImporte END),SUM(CASE WHEN intTipoMovto = 1 THEN 0 ELSE dblImporte END)
		FROM tbPolizasDet PD
		INNER JOIN tbProveedores P ON P.intEmpresa = PD.intEmpresa AND P.intProveedor = convert(int,PD.strclasifdp)
		WHERE PD.intEmpresa = @intEmpresa
		AND PD.intEjercicio = @intEjercicio
		AND PD.intMes > @intMes
		AND PD.datFecha < @datFechaCorteIni
		GROUP BY CONVERT(int,PD.strClasifDP)

		UPDATE CS
		SET CS.dblSaldoCargo = CS.dblSaldoCargo + ISNULL(PD.dblSaldoCargo,0),CS.dblSaldoAbono = CS.dblSaldoAbono + ISNULL(PD.dblSaldoAbono,0)
		FROM @CuentasSaldos CS
		INNER JOIN @CuentasSaldosMes PD ON PD.strClasifDP = CS.strClasifDP

		UPDATE CS
		SET CS.dblSaldoInicial = CS.dblSaldoInicial + ISNULL(CS.dblSaldoCargo,0) - ISNULL(CS.dblSaldoAbono,0)
		FROM @CuentasSaldos CS 

		INSERT INTO @CuentasReales(strClasifDP,dblSaldoCargo,dblSaldoAbono)
		SELECT CONVERT(int,PD.strClasifDP),SUM(CASE WHEN intTipoMovto = 0 THEN 0 ELSE dblImporte END),SUM(CASE WHEN intTipoMovto = 1 THEN 0 ELSE dblImporte END)
		FROM tbPolizasDet PD
		INNER JOIN tbProveedores C ON C.intProveedor = CONVERT(INT, PD.strClasifDP) AND C.intEmpresa = PD.intEmpresa	
		WHERE PD.intEmpresa = @intEmpresa
		AND PD.intEjercicio = @intEjercicio
		AND datFecha BETWEEN @datFechaCorteIni AND @datFechaCorteFin
		AND strCuenta = @strCuenta
		AND dblImporte > 0
		GROUP BY CONVERT(int,PD.strClasifDP)

		UPDATE CS
		SET CS.dblSaldoCargo = ISNULL(CS.dblSaldoCargo,0) + ISNULL(PD.dblSaldoCargo,0),CS.dblSaldoAbono = ISNULL(CS.dblSaldoAbono,0) + ISNULL(PD.dblSaldoAbono,0)
		FROM @CuentasSaldos CS
		INNER JOIN @CuentasReales PD ON PD.strClasifDP = CS.strClasifDP
	END

	SELECT strClasifDP,strNombreCliente as strNombre,dblSaldoInicial,dblSaldoCargo as dblCargos,
	dblSaldoAbono * -1 AS dblAbonos,dblSaldoInicial + dblSaldoCargo - dblSaldoAbono as Saldo,
	@strNombreCuenta as strNombreCuenta,@strEmpresa AS strEmpresa
	FROM @CuentasSaldos 
	ORDER BY CONVERT(int,strClasifDP)



	DROP TABLE #TempPolizas

SET NOCOUNT OFF
END
GO 

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbPolizasDet_Saldos Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbPolizasDet_Saldos Error on Creation'
END
GO
