set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

------------------------------------------------------------------------------------
---   Aplicacion: ColonyManager.                                                 ---
---        Autor: Gilberto Ruiz Viera                                            ---
---  Descripcion: Reporte Libro Mayor						                     ---
---                                                                              ---
------------------------------------------------------------------------------------
---    Fecha     Autor  Comentario                                               ---
---  ----------  -----  -------------------------------------------------------  ---
---  30/01/2013  GRV    Create procedure                                         ---
------------------------------------------------------------------------------------

ALTER PROCEDURE [dbo].[usp_LibroMayorContabilidad_Reporte_Obra]
(
	@intEmpresa INT, 
	@intEjercicio INT,
	@intNivel INT,                                    
	@strCuentaIni VARCHAR(50), 
	@strCuentaFin VARCHAR(50), 
	@intColIni INT,
	@intColFin INT,
	@intSectorIni INT,
	@intSectorFin INT,
	@intCCIni INT, 
	@intCCFin INT,
	@intAreaIni INT, 
	@intAreaFin INT,
	@intSaldo INT
)
AS	
BEGIN

	SET NOCOUNT ON
      
	-----------------------------------------RANGO DE OBRAS---------------------------------------------
	DECLARE @Obras TABLE(intObra INT)
	DECLARE @Cuentas TABLE(intEmpresa int, strCuenta VARCHAR(50) COLLATE SQL_Latin1_General_CP1_CI_AS, strNombre VARCHAR(200))
		
	INSERT INTO @Obras(intObra)
	SELECT DISTINCT O.intObra
	FROM VetecMarfil.dbo.tbObra O 
	WHERE O.intEmpresa = @intEmpresa
--	AND ((@strObra = '0') OR (O.strClave BETWEEN @strObra AND @strObraFin))
--	AND ((@intAreaIni = 0) OR (CONVERT(int, SUBSTRING(O.strClave, 1, 2)) BETWEEN @intAreaIni AND @intAreaFin))
--	AND ((@intColIni = 0 AND @intColFin = 0) OR (O.intColonia BETWEEN @intColIni AND @intColFin))
--	AND ((@intSectorIni = 0 AND @intSectorFin = 0) OR (O.intSector BETWEEN @intSectorIni AND @intSectorFin))

	INSERT INTO @Cuentas(intEmpresa, strCuenta, strNombre)
	SELECT intEmpresa, strCuenta,strNombre  
	FROM dbo.fn_tbCuentas_Nivel(@intEmpresa,@intnivel,@strCuentaIni,@strCuentaFin)
		
	DECLARE @intMes INT
	DECLARE @intTotalMeses INT
	DECLARE @dblSaldoInicial MONEY
	DECLARE @dblCargo MONEY
	DECLARE @dblAbono MONEY
	DECLARE @dblFinal MONEY
	DECLARE @strCuenta VARCHAR(50)
	DECLARE @dblSaldoFinal MONEY

	DECLARE @LibroMayor TABLE(strCuenta VARCHAR(50),intMes INT,strMes VARCHAR(50),dblSaldoInicial MONEY,
	dblCargos MONEY, dblAbonos MONEY, dblSaldoFinal MONEY,intObra int)

	--Enero
	INSERT INTO @LibroMayor(strCuenta,intObra,intMes,strMes,dblSaldoInicial,dblCargos,dblAbonos,dblSaldoFinal)
	SELECT CS.strCuenta,O.intObra,1,'Enero',SUM(ISNULL(CS.dblSaldoInicial,0)),SUM(ISNULL(CS.dblCargo01,0)), 
	SUM(ISNULL(CS.dblAbono01,0)),SUM(ISNULL(CS.dblSaldoInicial,0)) + SUM(ISNULL(CS.dblCargo01,0)) - SUM(ISNULL(CS.dblAbono01,0))
	FROM tbCuentasSaldos CS
	INNER JOIN @Cuentas C ON C.strCuenta = CS.strCuenta COLLATE SQL_Latin1_General_CP1_CI_AS
	INNER JOIN @Obras O ON CS.strClasifDS = O.intObra
	WHERE CS.intEmpresa = @intEmpresa
	AND CS.intEjercicio = @intEjercicio						
	GROUP BY CS.strCuenta,O.intObra

	--Febrero
	INSERT INTO @LibroMayor(strCuenta,intObra,intMes,strMes,dblSaldoInicial,dblCargos,dblAbonos,dblSaldoFinal)
	SELECT CS.strCuenta,O.intObra,2,'Febrero',0,SUM(ISNULL(CS.dblCargo02,0)),SUM(ISNULL(CS.dblAbono02,0)),
	(	SUM(ISNULL(CS.dblSaldoInicial,0)) 
		+ 
		SUM(ISNULL(CS.dblCargo01,0)) - SUM(ISNULL(CS.dblAbono01,0)) --ENERO
		+ 
		SUM(ISNULL(CS.dblCargo02,0)) - SUM(ISNULL(CS.dblAbono02,0)) --FEBRERO
	)	
	FROM tbCuentasSaldos CS
	INNER JOIN @Cuentas C ON C.strCuenta = CS.strCuenta COLLATE SQL_Latin1_General_CP1_CI_AS
	INNER JOIN @Obras O ON CS.strClasifDS = O.intObra
	WHERE CS.intEmpresa = @intEmpresa
	AND CS.intEjercicio = @intEjercicio						
	GROUP BY CS.strCuenta,O.intObra

	--Marzo
	INSERT INTO @LibroMayor(strCuenta,intObra,intMes,strMes,dblSaldoInicial,dblCargos,dblAbonos,dblSaldoFinal)
	SELECT CS.strCuenta,O.intObra,3,'Marzo',0,SUM(ISNULL(CS.dblCargo03,0)),SUM(ISNULL(CS.dblAbono03,0)),
	(	SUM(ISNULL(CS.dblSaldoInicial,0)) 
		+ 
		SUM(ISNULL(CS.dblCargo01,0)) - SUM(ISNULL(CS.dblAbono01,0)) --ENERO
		+
		SUM(ISNULL(CS.dblCargo02,0)) - SUM(ISNULL(CS.dblAbono02,0)) --FEBRERO
		+
		SUM(ISNULL(CS.dblCargo03,0)) - SUM(ISNULL(CS.dblAbono03,0))	--MARZO
	)
	FROM tbCuentasSaldos CS
	INNER JOIN @Cuentas C ON C.strCuenta = CS.strCuenta COLLATE SQL_Latin1_General_CP1_CI_AS
	INNER JOIN @Obras O ON CS.strClasifDS = O.intObra
	WHERE CS.intEmpresa = @intEmpresa
	AND CS.intEjercicio = @intEjercicio						
	GROUP BY CS.strCuenta,O.intObra

	--Abril
	INSERT INTO @LibroMayor(strCuenta,intObra,intMes,strMes,dblSaldoInicial,dblCargos,dblAbonos,dblSaldoFinal)
	SELECT CS.strCuenta,O.intObra,4,'Abril',0,SUM(ISNULL(CS.dblCargo04,0)), dblAbonoAbril = SUM(ISNULL(CS.dblAbono04,0)),
	(	SUM(ISNULL(CS.dblSaldoInicial,0)) 
		+ 
		SUM(ISNULL(CS.dblCargo01,0)) - SUM(ISNULL(CS.dblAbono01,0)) --ENERO
		+
		SUM(ISNULL(CS.dblCargo02,0)) - SUM(ISNULL(CS.dblAbono02,0)) --FEBRERO
		+
		SUM(ISNULL(CS.dblCargo03,0)) - SUM(ISNULL(CS.dblAbono03,0))	--MARZO
		+
		SUM(ISNULL(CS.dblCargo04,0)) - SUM(ISNULL(CS.dblAbono04,0)) --ABRIL
	)
	FROM tbCuentasSaldos CS
	INNER JOIN @Cuentas C ON C.strCuenta = CS.strCuenta COLLATE SQL_Latin1_General_CP1_CI_AS
	INNER JOIN @Obras O ON CS.strClasifDS = O.intObra
	WHERE CS.intEmpresa = @intEmpresa
	AND CS.intEjercicio = @intEjercicio						
	GROUP BY CS.strCuenta,O.intObra

	--Mayo
	INSERT INTO @LibroMayor(strCuenta,intObra,intMes,strMes,dblSaldoInicial,dblCargos,dblAbonos,dblSaldoFinal)
	SELECT CS.strCuenta,O.intObra,5,'Mayo',0,SUM(ISNULL(CS.dblCargo05,0)),SUM(ISNULL(CS.dblAbono05,0)),
	(	SUM(ISNULL(CS.dblSaldoInicial,0)) 
		+ 
		SUM(ISNULL(CS.dblCargo01,0)) - SUM(ISNULL(CS.dblAbono01,0)) --ENERO
		+
		SUM(ISNULL(CS.dblCargo02,0)) - SUM(ISNULL(CS.dblAbono02,0)) --FEBRERO
		+
		SUM(ISNULL(CS.dblCargo03,0)) - SUM(ISNULL(CS.dblAbono03,0))	--MARZO
		+
		SUM(ISNULL(CS.dblCargo04,0)) - SUM(ISNULL(CS.dblAbono04,0)) --ABRIL
		+
		SUM(ISNULL(CS.dblCargo05,0)) - SUM(ISNULL(CS.dblAbono05,0)) --MAYO
	)
	FROM tbCuentasSaldos CS
	INNER JOIN @Cuentas C ON C.strCuenta = CS.strCuenta COLLATE SQL_Latin1_General_CP1_CI_AS
	INNER JOIN @Obras O ON CS.strClasifDS = O.intObra
	WHERE CS.intEmpresa = @intEmpresa
	AND CS.intEjercicio = @intEjercicio						
	GROUP BY CS.strCuenta,O.intObra
	
	--Junio
	INSERT INTO @LibroMayor(strCuenta,intObra,intMes,strMes,dblSaldoInicial,dblCargos,dblAbonos,dblSaldoFinal)
	SELECT CS.strCuenta,O.intObra,6,'Junio',0,SUM(ISNULL(CS.dblCargo06,0)),SUM(ISNULL(CS.dblAbono06,0)),
	(	SUM(ISNULL(CS.dblSaldoInicial,0)) 
		+ 
		SUM(ISNULL(CS.dblCargo01,0)) - SUM(ISNULL(CS.dblAbono01,0)) --ENERO
		+
		SUM(ISNULL(CS.dblCargo02,0)) - SUM(ISNULL(CS.dblAbono02,0)) --FEBRERO
		+
		SUM(ISNULL(CS.dblCargo03,0)) - SUM(ISNULL(CS.dblAbono03,0))	--MARZO
		+
		SUM(ISNULL(CS.dblCargo04,0)) - SUM(ISNULL(CS.dblAbono04,0)) --ABRIL
		+
		SUM(ISNULL(CS.dblCargo05,0)) - SUM(ISNULL(CS.dblAbono05,0)) --MAYO
		+
		SUM(ISNULL(CS.dblCargo06,0)) - SUM(ISNULL(CS.dblAbono06,0)) --JUNIO
	)
	FROM tbCuentasSaldos CS
	INNER JOIN @Cuentas C ON C.strCuenta = CS.strCuenta COLLATE SQL_Latin1_General_CP1_CI_AS
	INNER JOIN @Obras O ON CS.strClasifDS = O.intObra
	WHERE CS.intEmpresa = @intEmpresa
	AND CS.intEjercicio = @intEjercicio						
	GROUP BY CS.strCuenta,O.intObra

	--Julio
	INSERT INTO @LibroMayor(strCuenta,intObra,intMes,strMes,dblSaldoInicial,dblCargos,dblAbonos,dblSaldoFinal)
	SELECT CS.strCuenta,O.intObra,7,'Julio',0,SUM(ISNULL(CS.dblCargo07,0)), SUM(ISNULL(CS.dblAbono07,0)),
	(	SUM(ISNULL(CS.dblSaldoInicial,0)) 
		+ 
		SUM(ISNULL(CS.dblCargo01,0)) - SUM(ISNULL(CS.dblAbono01,0)) --ENERO
		+
		SUM(ISNULL(CS.dblCargo02,0)) - SUM(ISNULL(CS.dblAbono02,0)) --FEBRERO
		+
		SUM(ISNULL(CS.dblCargo03,0)) - SUM(ISNULL(CS.dblAbono03,0))	--MARZO
		+
		SUM(ISNULL(CS.dblCargo04,0)) - SUM(ISNULL(CS.dblAbono04,0)) --ABRIL
		+
		SUM(ISNULL(CS.dblCargo05,0)) - SUM(ISNULL(CS.dblAbono05,0)) --MAYO
		+
		SUM(ISNULL(CS.dblCargo06,0)) - SUM(ISNULL(CS.dblAbono06,0)) --JUNIO
		+
		SUM(ISNULL(CS.dblCargo07,0)) - SUM(ISNULL(CS.dblAbono07,0)) --JULIO
	)
	FROM tbCuentasSaldos CS
	INNER JOIN @Cuentas C ON C.strCuenta = CS.strCuenta COLLATE SQL_Latin1_General_CP1_CI_AS
	INNER JOIN @Obras O ON CS.strClasifDS = O.intObra
	WHERE CS.intEmpresa = @intEmpresa
	AND CS.intEjercicio = @intEjercicio						
	GROUP BY CS.strCuenta,O.intObra

	--Agosto
	INSERT INTO @LibroMayor(strCuenta,intObra,intMes,strMes,dblSaldoInicial,dblCargos,dblAbonos,dblSaldoFinal)
	SELECT CS.strCuenta,O.intObra,8,'Agosto',0,SUM(ISNULL(CS.dblCargo08,0)),SUM(ISNULL(CS.dblAbono08,0)),
	(	SUM(ISNULL(CS.dblSaldoInicial,0)) 
		+ 
		SUM(ISNULL(CS.dblCargo01,0)) - SUM(ISNULL(CS.dblAbono01,0)) --ENERO
		+
		SUM(ISNULL(CS.dblCargo02,0)) - SUM(ISNULL(CS.dblAbono02,0)) --FEBRERO
		+
		SUM(ISNULL(CS.dblCargo03,0)) - SUM(ISNULL(CS.dblAbono03,0))	--MARZO
		+
		SUM(ISNULL(CS.dblCargo04,0)) - SUM(ISNULL(CS.dblAbono04,0)) --ABRIL
		+
		SUM(ISNULL(CS.dblCargo05,0)) - SUM(ISNULL(CS.dblAbono05,0)) --MAYO
		+
		SUM(ISNULL(CS.dblCargo06,0)) - SUM(ISNULL(CS.dblAbono06,0)) --JUNIO
		+
		SUM(ISNULL(CS.dblCargo07,0)) - SUM(ISNULL(CS.dblAbono07,0)) --JULIO
		+
		SUM(ISNULL(CS.dblCargo08,0)) - SUM(ISNULL(CS.dblAbono08,0)) --AGOSTO
	)
	FROM tbCuentasSaldos CS
	INNER JOIN @Cuentas C ON C.strCuenta = CS.strCuenta COLLATE SQL_Latin1_General_CP1_CI_AS
	INNER JOIN @Obras O ON CS.strClasifDS = O.intObra
	WHERE CS.intEmpresa = @intEmpresa
	AND CS.intEjercicio = @intEjercicio						
	GROUP BY CS.strCuenta,O.intObra

	--Septiembre
	INSERT INTO @LibroMayor(strCuenta,intObra,intMes,strMes,dblSaldoInicial,dblCargos,dblAbonos,dblSaldoFinal)
	SELECT CS.strCuenta,O.intObra,9,'Septiembre',0,SUM(ISNULL(CS.dblCargo09,0)),SUM(ISNULL(CS.dblAbono09,0)),
	(	SUM(ISNULL(CS.dblSaldoInicial,0)) 
		+ 
		SUM(ISNULL(CS.dblCargo01,0)) - SUM(ISNULL(CS.dblAbono01,0)) --ENERO
		+
		SUM(ISNULL(CS.dblCargo02,0)) - SUM(ISNULL(CS.dblAbono02,0)) --FEBRERO
		+
		SUM(ISNULL(CS.dblCargo03,0)) - SUM(ISNULL(CS.dblAbono03,0))	--MARZO
		+
		SUM(ISNULL(CS.dblCargo04,0)) - SUM(ISNULL(CS.dblAbono04,0)) --ABRIL
		+
		SUM(ISNULL(CS.dblCargo05,0)) - SUM(ISNULL(CS.dblAbono05,0)) --MAYO
		+
		SUM(ISNULL(CS.dblCargo06,0)) - SUM(ISNULL(CS.dblAbono06,0)) --JUNIO
		+
		SUM(ISNULL(CS.dblCargo07,0)) - SUM(ISNULL(CS.dblAbono07,0)) --JULIO
		+
		SUM(ISNULL(CS.dblCargo08,0)) - SUM(ISNULL(CS.dblAbono08,0)) --AGOSTO
		+
		SUM(ISNULL(CS.dblCargo09,0)) - SUM(ISNULL(CS.dblAbono09,0)) --SEPTIEMBRE
	)
	FROM tbCuentasSaldos CS
	INNER JOIN @Cuentas C ON C.strCuenta = CS.strCuenta COLLATE SQL_Latin1_General_CP1_CI_AS
	INNER JOIN @Obras O ON CS.strClasifDS = O.intObra
	WHERE CS.intEmpresa = @intEmpresa
	AND CS.intEjercicio = @intEjercicio						
	GROUP BY CS.strCuenta,O.intObra

	--Octubre
	INSERT INTO @LibroMayor(strCuenta,intObra,intMes,strMes,dblSaldoInicial,dblCargos,dblAbonos,dblSaldoFinal)
	SELECT CS.strCuenta,O.intObra,10,'Octubre',0,SUM(ISNULL(CS.dblCargo10,0)),SUM(ISNULL(CS.dblAbono10,0)),
	(	SUM(ISNULL(CS.dblSaldoInicial,0)) 
		+ 
		SUM(ISNULL(CS.dblCargo01,0)) - SUM(ISNULL(CS.dblAbono01,0)) --ENERO
		+
		SUM(ISNULL(CS.dblCargo02,0)) - SUM(ISNULL(CS.dblAbono02,0)) --FEBRERO
		+
		SUM(ISNULL(CS.dblCargo03,0)) - SUM(ISNULL(CS.dblAbono03,0))	--MARZO
		+
		SUM(ISNULL(CS.dblCargo04,0)) - SUM(ISNULL(CS.dblAbono04,0)) --ABRIL
		+
		SUM(ISNULL(CS.dblCargo05,0)) - SUM(ISNULL(CS.dblAbono05,0)) --MAYO
		+
		SUM(ISNULL(CS.dblCargo06,0)) - SUM(ISNULL(CS.dblAbono06,0)) --JUNIO
		+
		SUM(ISNULL(CS.dblCargo07,0)) - SUM(ISNULL(CS.dblAbono07,0)) --JULIO
		+
		SUM(ISNULL(CS.dblCargo08,0)) - SUM(ISNULL(CS.dblAbono08,0)) --AGOSTO
		+
		SUM(ISNULL(CS.dblCargo09,0)) - SUM(ISNULL(CS.dblAbono09,0)) --SEPTIEMBRE
		+
		SUM(ISNULL(CS.dblCargo10,0)) - SUM(ISNULL(CS.dblAbono10,0)) --OCTUBRE
	)
	FROM tbCuentasSaldos CS
	INNER JOIN @Cuentas C ON C.strCuenta = CS.strCuenta COLLATE SQL_Latin1_General_CP1_CI_AS
	INNER JOIN @Obras O ON CS.strClasifDS = O.intObra
	WHERE CS.intEmpresa = @intEmpresa
	AND CS.intEjercicio = @intEjercicio						
	GROUP BY CS.strCuenta,O.intObra

	--Noviembre
	INSERT INTO @LibroMayor(strCuenta,intObra,intMes,strMes,dblSaldoInicial,dblCargos,dblAbonos,dblSaldoFinal)
	SELECT CS.strCuenta,O.intObra,11,'Noviembre',0,SUM(ISNULL(CS.dblCargo11,0)),SUM(ISNULL(CS.dblAbono11,0)),
	(	SUM(ISNULL(CS.dblSaldoInicial,0)) 
		+ 
		SUM(ISNULL(CS.dblCargo01,0)) - SUM(ISNULL(CS.dblAbono01,0)) --ENERO
		+
		SUM(ISNULL(CS.dblCargo02,0)) - SUM(ISNULL(CS.dblAbono02,0)) --FEBRERO
		+
		SUM(ISNULL(CS.dblCargo03,0)) - SUM(ISNULL(CS.dblAbono03,0))	--MARZO
		+
		SUM(ISNULL(CS.dblCargo04,0)) - SUM(ISNULL(CS.dblAbono04,0)) --ABRIL
		+
		SUM(ISNULL(CS.dblCargo05,0)) - SUM(ISNULL(CS.dblAbono05,0)) --MAYO
		+
		SUM(ISNULL(CS.dblCargo06,0)) - SUM(ISNULL(CS.dblAbono06,0)) --JUNIO
		+
		SUM(ISNULL(CS.dblCargo07,0)) - SUM(ISNULL(CS.dblAbono07,0)) --JULIO
		+
		SUM(ISNULL(CS.dblCargo08,0)) - SUM(ISNULL(CS.dblAbono08,0)) --AGOSTO
		+
		SUM(ISNULL(CS.dblCargo09,0)) - SUM(ISNULL(CS.dblAbono09,0)) --SEPTIEMBRE
		+
		SUM(ISNULL(CS.dblCargo10,0)) - SUM(ISNULL(CS.dblAbono10,0)) --OCTUBRE
		+
		SUM(ISNULL(CS.dblCargo11,0)) - SUM(ISNULL(CS.dblAbono11,0)) --NOVIEMBRE
	)
	FROM tbCuentasSaldos CS
	INNER JOIN @Cuentas C ON C.strCuenta = CS.strCuenta COLLATE SQL_Latin1_General_CP1_CI_AS
	INNER JOIN @Obras O ON CS.strClasifDS = O.intObra
	WHERE CS.intEmpresa = @intEmpresa
	AND CS.intEjercicio = @intEjercicio						
	GROUP BY CS.strCuenta,O.intObra

	--Diciembre
	INSERT INTO @LibroMayor(strCuenta,intObra,intMes,strMes,dblSaldoInicial,dblCargos,dblAbonos,dblSaldoFinal)
	SELECT CS.strCuenta,O.intObra,12,'Diciembre',0,SUM(ISNULL(CS.dblCargo12,0)),SUM(ISNULL(CS.dblAbono12,0)),
	(	SUM(ISNULL(CS.dblSaldoInicial,0)) 
		+ 
		SUM(ISNULL(CS.dblCargo01,0)) - SUM(ISNULL(CS.dblAbono01,0)) --ENERO
		+
		SUM(ISNULL(CS.dblCargo02,0)) - SUM(ISNULL(CS.dblAbono02,0)) --FEBRERO
		+
		SUM(ISNULL(CS.dblCargo03,0)) - SUM(ISNULL(CS.dblAbono03,0))	--MARZO
		+
		SUM(ISNULL(CS.dblCargo04,0)) - SUM(ISNULL(CS.dblAbono04,0)) --ABRIL
		+
		SUM(ISNULL(CS.dblCargo05,0)) - SUM(ISNULL(CS.dblAbono05,0)) --MAYO
		+
		SUM(ISNULL(CS.dblCargo06,0)) - SUM(ISNULL(CS.dblAbono06,0)) --JUNIO
		+
		SUM(ISNULL(CS.dblCargo07,0)) - SUM(ISNULL(CS.dblAbono07,0)) --JULIO
		+
		SUM(ISNULL(CS.dblCargo08,0)) - SUM(ISNULL(CS.dblAbono08,0)) --AGOSTO
		+
		SUM(ISNULL(CS.dblCargo09,0)) - SUM(ISNULL(CS.dblAbono09,0)) --SEPTIEMBRE
		+
		SUM(ISNULL(CS.dblCargo10,0)) - SUM(ISNULL(CS.dblAbono10,0)) --OCTUBRE
		+
		SUM(ISNULL(CS.dblCargo11,0)) - SUM(ISNULL(CS.dblAbono11,0)) --NOVIEMBRE
		+
		SUM(ISNULL(CS.dblCargo12,0)) - SUM(ISNULL(CS.dblAbono12,0)) --DICIEMBRE
	)
	FROM tbCuentasSaldos CS
	INNER JOIN @Cuentas C ON C.strCuenta = CS.strCuenta COLLATE SQL_Latin1_General_CP1_CI_AS
	INNER JOIN @Obras O ON CS.strClasifDS = O.intObra
	WHERE CS.intEmpresa = @intEmpresa
	AND CS.intEjercicio = @intEjercicio						
	GROUP BY CS.strCuenta,O.intObra


--	SELECT  dblSaldoInicial = SUM(ISNULL(CS.dblSaldoInicial,0)), 
--			dblCargoEnero = SUM(ISNULL(CS.dblCargo01,0)), 
--			dblAbonoEnero = SUM(ISNULL(CS.dblAbono01,0)),
--			dblFinalEnero = SUM(ISNULL(CS.dblSaldoInicial,0)) + SUM(ISNULL(CS.dblCargo01,0)) - SUM(ISNULL(CS.dblAbono01,0)),
--			dblCargoFebrero = SUM(ISNULL(CS.dblCargo02,0)), 
--			dblAbonoFebrero = SUM(ISNULL(CS.dblAbono02,0)),
--			dblFinalFebrero =	(	SUM(ISNULL(CS.dblSaldoInicial,0)) 
--									+ 
--									SUM(ISNULL(CS.dblCargo01,0)) - SUM(ISNULL(CS.dblAbono01,0)) --ENERO
--									+ 
--									SUM(ISNULL(CS.dblCargo02,0)) - SUM(ISNULL(CS.dblAbono02,0)) --FEBRERO
--								),
--			dblCargoMarzo = SUM(ISNULL(CS.dblCargo03,0)), 
--			dblAbonoMarzo = SUM(ISNULL(CS.dblAbono03,0)),
--			dblFinalMarzo = (	SUM(ISNULL(CS.dblSaldoInicial,0)) 
--								+ 
--								SUM(ISNULL(CS.dblCargo01,0)) - SUM(ISNULL(CS.dblAbono01,0)) --ENERO
--								+
--								SUM(ISNULL(CS.dblCargo02,0)) - SUM(ISNULL(CS.dblAbono02,0)) --FEBRERO
--								+
--								SUM(ISNULL(CS.dblCargo03,0)) - SUM(ISNULL(CS.dblAbono03,0))	--MARZO
--							),
--			dblCargoAbril =  SUM(ISNULL(CS.dblCargo04,0)), 
--			dblAbonoAbril = SUM(ISNULL(CS.dblAbono04,0)),
--			dblFinalAbril = (	SUM(ISNULL(CS.dblSaldoInicial,0)) 
--								+ 
--								SUM(ISNULL(CS.dblCargo01,0)) - SUM(ISNULL(CS.dblAbono01,0)) --ENERO
--								+
--								SUM(ISNULL(CS.dblCargo02,0)) - SUM(ISNULL(CS.dblAbono02,0)) --FEBRERO
--								+
--								SUM(ISNULL(CS.dblCargo03,0)) - SUM(ISNULL(CS.dblAbono03,0))	--MARZO
--								+
--								SUM(ISNULL(CS.dblCargo04,0)) - SUM(ISNULL(CS.dblAbono04,0)) --ABRIL
--							),
--			dblCargoMayo = SUM(ISNULL(CS.dblCargo05,0)), 
--			dblAbonoMayo = SUM(ISNULL(CS.dblAbono05,0)),
--			dblFinalMayo = (	SUM(ISNULL(CS.dblSaldoInicial,0)) 
--								+ 
--								SUM(ISNULL(CS.dblCargo01,0)) - SUM(ISNULL(CS.dblAbono01,0)) --ENERO
--								+
--								SUM(ISNULL(CS.dblCargo02,0)) - SUM(ISNULL(CS.dblAbono02,0)) --FEBRERO
--								+
--								SUM(ISNULL(CS.dblCargo03,0)) - SUM(ISNULL(CS.dblAbono03,0))	--MARZO
--								+
--								SUM(ISNULL(CS.dblCargo04,0)) - SUM(ISNULL(CS.dblAbono04,0)) --ABRIL
--								+
--								SUM(ISNULL(CS.dblCargo05,0)) - SUM(ISNULL(CS.dblAbono05,0)) --MAYO
--							),
--			dblCargoJunio = SUM(ISNULL(CS.dblCargo06,0)), 
--			dblAbonoJunio = SUM(ISNULL(CS.dblAbono06,0)),
--			dblFinalJunio = (	SUM(ISNULL(CS.dblSaldoInicial,0)) 
--								+ 
--								SUM(ISNULL(CS.dblCargo01,0)) - SUM(ISNULL(CS.dblAbono01,0)) --ENERO
--								+
--								SUM(ISNULL(CS.dblCargo02,0)) - SUM(ISNULL(CS.dblAbono02,0)) --FEBRERO
--								+
--								SUM(ISNULL(CS.dblCargo03,0)) - SUM(ISNULL(CS.dblAbono03,0))	--MARZO
--								+
--								SUM(ISNULL(CS.dblCargo04,0)) - SUM(ISNULL(CS.dblAbono04,0)) --ABRIL
--								+
--								SUM(ISNULL(CS.dblCargo05,0)) - SUM(ISNULL(CS.dblAbono05,0)) --MAYO
--								+
--								SUM(ISNULL(CS.dblCargo06,0)) - SUM(ISNULL(CS.dblAbono06,0)) --JUNIO
--							),
--			dblCargoJulio = SUM(ISNULL(CS.dblCargo07,0)), 
--			dblAbonoJulio = SUM(ISNULL(CS.dblAbono07,0)),
--			dblFinalJulio = (	SUM(ISNULL(CS.dblSaldoInicial,0)) 
--								+ 
--								SUM(ISNULL(CS.dblCargo01,0)) - SUM(ISNULL(CS.dblAbono01,0)) --ENERO
--								+
--								SUM(ISNULL(CS.dblCargo02,0)) - SUM(ISNULL(CS.dblAbono02,0)) --FEBRERO
--								+
--								SUM(ISNULL(CS.dblCargo03,0)) - SUM(ISNULL(CS.dblAbono03,0))	--MARZO
--								+
--								SUM(ISNULL(CS.dblCargo04,0)) - SUM(ISNULL(CS.dblAbono04,0)) --ABRIL
--								+
--								SUM(ISNULL(CS.dblCargo05,0)) - SUM(ISNULL(CS.dblAbono05,0)) --MAYO
--								+
--								SUM(ISNULL(CS.dblCargo06,0)) - SUM(ISNULL(CS.dblAbono06,0)) --JUNIO
--								+
--								SUM(ISNULL(CS.dblCargo07,0)) - SUM(ISNULL(CS.dblAbono07,0)) --JULIO
--							),
--			dblCargoAgosto = SUM(ISNULL(CS.dblCargo08,0)), 
--			dblAbonoAgosto = SUM(ISNULL(CS.dblAbono08,0)),
--			dblFinalAgosto = (	SUM(ISNULL(CS.dblSaldoInicial,0)) 
--								+ 
--								SUM(ISNULL(CS.dblCargo01,0)) - SUM(ISNULL(CS.dblAbono01,0)) --ENERO
--								+
--								SUM(ISNULL(CS.dblCargo02,0)) - SUM(ISNULL(CS.dblAbono02,0)) --FEBRERO
--								+
--								SUM(ISNULL(CS.dblCargo03,0)) - SUM(ISNULL(CS.dblAbono03,0))	--MARZO
--								+
--								SUM(ISNULL(CS.dblCargo04,0)) - SUM(ISNULL(CS.dblAbono04,0)) --ABRIL
--								+
--								SUM(ISNULL(CS.dblCargo05,0)) - SUM(ISNULL(CS.dblAbono05,0)) --MAYO
--								+
--								SUM(ISNULL(CS.dblCargo06,0)) - SUM(ISNULL(CS.dblAbono06,0)) --JUNIO
--								+
--								SUM(ISNULL(CS.dblCargo07,0)) - SUM(ISNULL(CS.dblAbono07,0)) --JULIO
--								+
--								SUM(ISNULL(CS.dblCargo08,0)) - SUM(ISNULL(CS.dblAbono08,0)) --AGOSTO
--							),
--			dblCargoSeptiembre = SUM(ISNULL(CS.dblCargo09,0)), 
--			dblAbonoSeptiembre = SUM(ISNULL(CS.dblAbono09,0)),
--			dblFinalSeptiembre = (	SUM(ISNULL(CS.dblSaldoInicial,0)) 
--									+ 
--									SUM(ISNULL(CS.dblCargo01,0)) - SUM(ISNULL(CS.dblAbono01,0)) --ENERO
--									+
--									SUM(ISNULL(CS.dblCargo02,0)) - SUM(ISNULL(CS.dblAbono02,0)) --FEBRERO
--									+
--									SUM(ISNULL(CS.dblCargo03,0)) - SUM(ISNULL(CS.dblAbono03,0))	--MARZO
--									+
--									SUM(ISNULL(CS.dblCargo04,0)) - SUM(ISNULL(CS.dblAbono04,0)) --ABRIL
--									+
--									SUM(ISNULL(CS.dblCargo05,0)) - SUM(ISNULL(CS.dblAbono05,0)) --MAYO
--									+
--									SUM(ISNULL(CS.dblCargo06,0)) - SUM(ISNULL(CS.dblAbono06,0)) --JUNIO
--									+
--									SUM(ISNULL(CS.dblCargo07,0)) - SUM(ISNULL(CS.dblAbono07,0)) --JULIO
--									+
--									SUM(ISNULL(CS.dblCargo08,0)) - SUM(ISNULL(CS.dblAbono08,0)) --AGOSTO
--									+
--									SUM(ISNULL(CS.dblCargo09,0)) - SUM(ISNULL(CS.dblAbono09,0)) --SEPTIEMBRE
--								),
--			dblCargoOctubre = SUM(ISNULL(CS.dblCargo10,0)), 
--			dblAbonoOctubre = SUM(ISNULL(CS.dblAbono10,0)),
--			dblFinalOctubre = (	SUM(ISNULL(CS.dblSaldoInicial,0)) 
--								+ 
--								SUM(ISNULL(CS.dblCargo01,0)) - SUM(ISNULL(CS.dblAbono01,0)) --ENERO
--								+
--								SUM(ISNULL(CS.dblCargo02,0)) - SUM(ISNULL(CS.dblAbono02,0)) --FEBRERO
--								+
--								SUM(ISNULL(CS.dblCargo03,0)) - SUM(ISNULL(CS.dblAbono03,0))	--MARZO
--								+
--								SUM(ISNULL(CS.dblCargo04,0)) - SUM(ISNULL(CS.dblAbono04,0)) --ABRIL
--								+
--								SUM(ISNULL(CS.dblCargo05,0)) - SUM(ISNULL(CS.dblAbono05,0)) --MAYO
--								+
--								SUM(ISNULL(CS.dblCargo06,0)) - SUM(ISNULL(CS.dblAbono06,0)) --JUNIO
--								+
--								SUM(ISNULL(CS.dblCargo07,0)) - SUM(ISNULL(CS.dblAbono07,0)) --JULIO
--								+
--								SUM(ISNULL(CS.dblCargo08,0)) - SUM(ISNULL(CS.dblAbono08,0)) --AGOSTO
--								+
--								SUM(ISNULL(CS.dblCargo09,0)) - SUM(ISNULL(CS.dblAbono09,0)) --SEPTIEMBRE
--								+
--								SUM(ISNULL(CS.dblCargo10,0)) - SUM(ISNULL(CS.dblAbono10,0)) --OCTUBRE
--							),
--			dblCargoNoviembre =SUM(ISNULL(CS.dblCargo11,0)), 
--			dblAbonoNoviembre = SUM(ISNULL(CS.dblAbono11,0)),
--			dblFinalNoviembre = (	SUM(ISNULL(CS.dblSaldoInicial,0)) 
--									+ 
--									SUM(ISNULL(CS.dblCargo01,0)) - SUM(ISNULL(CS.dblAbono01,0)) --ENERO
--									+
--									SUM(ISNULL(CS.dblCargo02,0)) - SUM(ISNULL(CS.dblAbono02,0)) --FEBRERO
--									+
--									SUM(ISNULL(CS.dblCargo03,0)) - SUM(ISNULL(CS.dblAbono03,0))	--MARZO
--									+
--									SUM(ISNULL(CS.dblCargo04,0)) - SUM(ISNULL(CS.dblAbono04,0)) --ABRIL
--									+
--									SUM(ISNULL(CS.dblCargo05,0)) - SUM(ISNULL(CS.dblAbono05,0)) --MAYO
--									+
--									SUM(ISNULL(CS.dblCargo06,0)) - SUM(ISNULL(CS.dblAbono06,0)) --JUNIO
--									+
--									SUM(ISNULL(CS.dblCargo07,0)) - SUM(ISNULL(CS.dblAbono07,0)) --JULIO
--									+
--									SUM(ISNULL(CS.dblCargo08,0)) - SUM(ISNULL(CS.dblAbono08,0)) --AGOSTO
--									+
--									SUM(ISNULL(CS.dblCargo09,0)) - SUM(ISNULL(CS.dblAbono09,0)) --SEPTIEMBRE
--									+
--									SUM(ISNULL(CS.dblCargo10,0)) - SUM(ISNULL(CS.dblAbono10,0)) --OCTUBRE
--									+
--									SUM(ISNULL(CS.dblCargo11,0)) - SUM(ISNULL(CS.dblAbono11,0)) --NOVIEMBRE
--								),
--			dblCargoDiciembre = SUM(ISNULL(CS.dblCargo12,0)), 
--			dblAbonoDiciembre = SUM(ISNULL(CS.dblAbono12,0)),
--			dblFinalDiciembre = (	SUM(ISNULL(CS.dblSaldoInicial,0)) 
--									+ 
--									SUM(ISNULL(CS.dblCargo01,0)) - SUM(ISNULL(CS.dblAbono01,0)) --ENERO
--									+
--									SUM(ISNULL(CS.dblCargo02,0)) - SUM(ISNULL(CS.dblAbono02,0)) --FEBRERO
--									+
--									SUM(ISNULL(CS.dblCargo03,0)) - SUM(ISNULL(CS.dblAbono03,0))	--MARZO
--									+
--									SUM(ISNULL(CS.dblCargo04,0)) - SUM(ISNULL(CS.dblAbono04,0)) --ABRIL
--									+
--									SUM(ISNULL(CS.dblCargo05,0)) - SUM(ISNULL(CS.dblAbono05,0)) --MAYO
--									+
--									SUM(ISNULL(CS.dblCargo06,0)) - SUM(ISNULL(CS.dblAbono06,0)) --JUNIO
--									+
--									SUM(ISNULL(CS.dblCargo07,0)) - SUM(ISNULL(CS.dblAbono07,0)) --JULIO
--									+
--									SUM(ISNULL(CS.dblCargo08,0)) - SUM(ISNULL(CS.dblAbono08,0)) --AGOSTO
--									+
--									SUM(ISNULL(CS.dblCargo09,0)) - SUM(ISNULL(CS.dblAbono09,0)) --SEPTIEMBRE
--									+
--									SUM(ISNULL(CS.dblCargo10,0)) - SUM(ISNULL(CS.dblAbono10,0)) --OCTUBRE
--									+
--									SUM(ISNULL(CS.dblCargo11,0)) - SUM(ISNULL(CS.dblAbono11,0)) --NOVIEMBRE
--									+
--									SUM(ISNULL(CS.dblCargo12,0)) - SUM(ISNULL(CS.dblAbono12,0)) --DICIEMBRE
--								),
--				strCuenta = CS.strCuenta,
--				O.intObra		
--		FROM tbCuentasSaldos CS
--		INNER JOIN @Cuentas C ON C.strCuenta = CS.strCuenta COLLATE SQL_Latin1_General_CP1_CI_AS
--		INNER JOIN @Obras O ON CS.strClasifDS = O.intObra
--		WHERE CS.intEmpresa = @intEmpresa
--		AND CS.intEjercicio = @intEjercicio						
--		GROUP BY CS.strCuenta,O.intObra

		CREATE TABLE #TmpCtasDelete(strCuenta VARCHAR(50)COLLATE SQL_Latin1_General_CP1_CI_AS,intObra INT)
	
		IF @intSaldo = 1
		BEGIN
			INSERT INTO #TmpCtasDelete
			SELECT strCuenta,intObra 
			FROM @LibroMayor LM GROUP BY LM.strCuenta,LM.intObra 
			HAVING SUM(ABS(LM.dblSaldoInicial)) + SUM(ABS(LM.dblCargos)) + SUM((LM.dblAbonos)) = 0		
		
			DELETE LM
			FROM @LibroMayor LM
			INNER JOIN #TmpCtasDelete D ON LM.strCuenta = D.strCuenta AND LM.intObra = D.intObra
		END
	
		SELECT	TLM.strCuenta,TLM.intObra,TLM.intMes,TLM.strMes,TLM.dblSaldoInicial,TLM.dblCargos,TLM.dblAbonos,TLM.dblSaldoFinal,
				strEmpresa = E.strNombre,
				intEjercicio = @intEjercicio,
				intNivel = @intNivel,                                    
				strCuentaIni = @strCuentaIni, 
				strCuentaFin = @strCuentaFin, 
				intColIni = @intColIni,
				intColFin = @intColFin,
				intSectorIni = @intSectorIni,
				intSectorFin = @intSectorFin,
				intCCIni = @intCCIni, 
				intCCFin = @intCCFin,
				intAreaIni = @intAreaIni, 
				intAreaFin = @intAreaFin,
				strNombreCuenta = C.strNombre,
				strRFC = E.strRFC,
				strDireccion = E.strDireccion,
				strColonia = E.strColonia,
				strCuentaFormato = dbo.F_CtaFormato(C.strCuenta),
				strNombreObra = O.strNombre,
				strClaveObra =	O.strClave
		FROM @LibroMayor TLM
		INNER JOIN tbCuentas C ON C.intEmpresa = @intEmpresa AND C.strCuenta = TLM.strCuenta COLLATE SQL_Latin1_General_CP1_CI_AS
		INNER JOIN tbEmpresas E ON E.intEmpresa = @intEmpresa
		INNER JOIN VetecMarfil.dbo.tbObra O ON O.intEmpresa = @intEmpresa AND O.intObra = TLM.intObra

		DROP TABLE #TmpCtasDelete
--		--DROP TABLE #TempCuentasObra
--		DROP TABLE #TmpSaldos
--		DROP TABLE #TempLibroMayor
--		DROP TABLE #TempCuentas
--		DROP TABLE #TmpObras
      	                           
	SET NOCOUNT OFF	
END









