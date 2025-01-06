

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbPolizasDet_SaldoAuxiliar')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbPolizasDet_SaldoAuxiliar
	PRINT N'Drop Procedure : dbo.usp_tbPolizasDet_SaldoAuxiliar - Succeeded !!!'
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


CREATE PROCEDURE dbo.usp_tbPolizasDet_SaldoAuxiliar
( 
	@intEmpresa				int, 
	@intEjercicio			int,		
	@intMes					Int,	
	@strCuenta				VarChar(50), 
	@strAux					VarChar(50),
	@strAuxFin				VarChar(50),
	@strObra				VarChar(50),
	@strObraFin				VarChar(50),
	@intColIni				INT, 
	@intColFin				INT, 
	@intClienteProveedor	INT
)
AS    
BEGIN
	SET NOCOUNT ON 

	DECLARE @datFechaIni DATETIME
	DECLARE @datFechaFin DATETIME   

	DECLARE @datFecha VARCHAR(50)
	DECLARE @strMes VARCHAR(100)
	DECLARE @strEmpresa VARCHAR(200)	
	DECLARE @Rows int
	DECLARE @Count int	
	DECLARE @strCuentaN VARCHAR(50)
	DECLARE @Suma DECIMAL(18,2)	

	SELECT @strEmpresa = strNombre FROM tbEmpresas WHERE intEmpresa = @intEmpresa	

	CREATE TABLE #TmpObras(intObra INT)
	CREATE TABLE #TmpAux(Aux INT,strNombre varchar(200))
	
	CREATE TABLE #TmpSaldos(intEmpresa int, intObra VARCHAR(50), strAuxiliar int,strNombre varchar(200),
	dblSaldoInicial decimal(18,2),dblSaldoCargos decimal(18,2), dblSaldoAbonos decimal(18,2), dblSaldoFinal decimal(18,2))

	INSERT INTO #TmpObras(intObra)
	SELECT DISTINCT O.intObra
	FROM VetecMarfil.dbo.tbObra O 
	WHERE O.intEmpresa = @intEmpresa
	AND ((@strObra = '0') OR (O.strClave BETWEEN @strObra AND @strObraFin))
	AND ((@intColIni = 0 AND @intColFin = 0) OR (O.intColonia BETWEEN @intColIni AND @intColFin))

	IF(@intClienteProveedor = 1)
	BEGIN
		INSERT INTO #TmpAux(Aux)
		SELECT intProveedor
		FROM tbProveedores
		WHERE intEmpresa = @intEmpresa
		AND ((@strAux = '0') OR (intProveedor BETWEEN @strAux AND @strAuxFin))
	END
	ELSE
	BEGIN
		INSERT INTO #TmpAux(Aux,strNombre)
		SELECT intProveedor, strNombre
		FROM tbProveedores
		WHERE intEmpresa = @intEmpresa
		AND ((@strAux = '0') OR (intProveedor BETWEEN @strAux AND @strAuxFin))
	END

	INSERT INTO #TmpSaldos(intEmpresa,intObra,strAuxiliar,strNombre,dblSaldoInicial,dblSaldoCargos,dblSaldoAbonos)
	SELECT CS.intEmpresa,CS.strClasifDS,CS.strClasifDP,X.strNombre,
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
	INNER JOIN #TmpAux X on X.Aux = CS.strClasifDP 
	WHERE CS.intEmpresa = @intEmpresa
	AND CS.intEjercicio = @intEjercicio 
	AND CS.strCuenta = @strCuenta
	AND CS.strClasifDS IN (SELECT CONVERT(VARCHAR,intObra) FROM #TmpObras)
	AND ISNULL(CS.strClasifDS,'0') <> '0'
	GROUP BY CS.intEmpresa,CS.strCuenta,CS.strClasifDS,CS.strClasifDP,X.strNombre

	UPDATE #TmpSaldos SET dblSaldoFinal = dblSaldoInicial+dblSaldoCargos-dblSaldoAbonos

	SELECT	strAuxiliar,strNombre,SUM(dblSaldoInicial),SUM(dblSaldoCargos),SUM(dblSaldoAbonos),SUM(dblSaldoFinal)
	FROM #TmpSaldos
	GROUP BY intEmpresa,strAuxiliar,strNombre

	DROP TABLE #TmpObras
	DROP TABLE #TmpAux
	DROP TABLE #TmpSaldos

SET NOCOUNT OFF
END
GO 

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbPolizasDet_SaldoAuxiliar Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbPolizasDet_SaldoAuxiliar Error on Creation'
END
GO
