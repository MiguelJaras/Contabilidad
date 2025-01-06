

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbPolizasDet_BalanzaCuenta')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbPolizasDet_BalanzaCuenta
	PRINT N'Drop Procedure : dbo.usp_tbPolizasDet_BalanzaCuenta - Succeeded !!!'
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


CREATE PROCEDURE dbo.usp_tbPolizasDet_BalanzaCuenta
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
	@intCargo		INT
)
AS    
BEGIN
	SET NOCOUNT ON    

	DECLARE @Suma DECIMAL(18,2)
	
	CREATE TABLE #TmpObras(intObra INT)
	CREATE TABLE #TempCuentas(intEmpresa int, strCuenta VARCHAR(50) COLLATE SQL_Latin1_General_CP1_CI_AS, strNombre VARCHAR(200))
	CREATE TABLE #Polizas(strPoliza VARCHAR(50),strCuenta VARCHAR(50), strAuxiliar VARCHAR(50), strObra VARCHAR(10), dblImporte DECIMAL(18,2))
		
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

	INSERT INTO #Polizas(strPoliza,strCuenta,strAuxiliar,strObra,dblImporte)
	SELECT PD.strPoliza,PD.strCuenta, PD.strClasifDP,PD.strClasifDS,PD.dblImporte
	FROM tbPolizasDet PD
	INNER JOIN tbPolizasEnc PE ON PE.intEmpresa = PD.intEmpresa AND PE.strPoliza = PD.strPoliza AND PE.intEjercicio = PD.intEjercicio
	WHERE PD.intEmpresa = @intEmpresa
	AND PD.intEjercicio = @intEjercicio
	AND PD.intMes = @intMes
	AND PD.intIndAfectada = 1
	AND PE.intEstatus <> 9	
	AND PD.intTipoMovto = @intCargo	
	AND PD.strClasifDS IN(SELECT DISTINCT intObra FROM #TmpObras)
	AND LEFT(PD.strCuenta,4) IN (SELECT DISTINCT strCuenta FROM #TempCuentas)
	AND ((PD.strClasifDS <> '0') OR (PD.strClasifDS IS NOT NULL))

	SELECT @Suma = SUM(DBLiMPORTE) FROM #Polizas

	SELECT strPoliza,strCuenta,strAuxiliar,strObra,'$ ' + CONVERT(VARCHAR,CONVERT(MONEY,dblImporte),1) AS dblImporte,
	'$ ' + CONVERT(VARCHAR,CONVERT(MONEY,@Suma),1) AS Total
	FROM #Polizas


	DROP TABLE #Polizas
	DROP TABLE #TempCuentas
	DROP TABLE #TmpObras

SET NOCOUNT OFF
END
GO 

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbPolizasDet_BalanzaCuenta Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbPolizasDet_BalanzaCuenta Error on Creation'
END
GO
