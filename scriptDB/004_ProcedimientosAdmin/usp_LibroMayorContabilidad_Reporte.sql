


IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_LibroMayorContabilidad_Reporte')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_LibroMayorContabilidad_Reporte
	PRINT N'Drop Procedure : dbo.usp_LibroMayorContabilidad_Reporte - Succeeded !!!'
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

CREATE PROCEDURE [dbo].[usp_LibroMayorContabilidad_Reporte]
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
	CREATE TABLE #TmpObras(intRegistro INT IDENTITY(1,1), strObra VARCHAR(50) COLLATE SQL_Latin1_General_CP1_CI_AS)
	
	DECLARE @ParamIni VARCHAR(10)
	DECLARE @ParamFin VARCHAR(10)

		--CUANDO TODO ES CERO
		IF 	(@intColIni = 0 AND @intColFin = 0 AND @intSectorIni = 0 AND @intSectorFin = 0 AND @intAreaIni = 0 AND @intAreaFin = 0 AND @intCCIni = 0 AND @intCCFin = 0) 
		BEGIN			
			INSERT INTO #TmpObras
			SELECT DISTINCT O.intObra
			FROM VetecMarfil.dbo.tbObra O 
			WHERE O.intEmpresa = @intEmpresa			
		END

		--CUANDO TODO ES CERO MENOS EL RANGO DE OBRA
		IF	(@intColIni = 0 AND @intColFin = 0 AND @intSectorIni = 0 AND @intSectorFin = 0 AND @intAreaIni = 0 AND @intAreaFin = 0 AND @intCCIni <> 0 AND @intCCFin <> 0) 
		BEGIN			
			INSERT INTO #TmpObras
			SELECT DISTINCT O.intObra
			FROM VetecMarfil.dbo.tbObra O 
			WHERE O.intEmpresa = @intEmpresa
			AND O.intObra BETWEEN @intCCIni AND @intCCFin	
		END

		--CUANDO TODO ES CERO MENOS LA COLONIA
		IF	(@intColIni <> 0 AND @intColFin <> 0 AND @intSectorIni = 0 AND @intSectorFin = 0 AND @intAreaIni = 0 AND @intAreaFin = 0 AND @intCCIni = 0 AND @intCCFin = 0)
		BEGIN			
			INSERT INTO #TmpObras
			SELECT DISTINCT O.intObra
			FROM VetecMarfil.dbo.tbObra O 
			WHERE O.intEmpresa = @intEmpresa	
			AND (CONVERT(INT, SUBSTRING(O.strClave, 4, 2)) BETWEEN @intColIni AND @intColFin) 
		END	
		
		--CUANDO QUIERO TODO PERO DE CIERTO SECTOR
		IF (@intSectorIni <> 0 AND @intSectorFin <> 0 AND @intCCIni = 0 AND @intCCFin = 0 AND @intAreaIni = 0 AND @intAreaFin = 0 AND @intColIni = 0 AND @intColFin = 0)
		BEGIN			
			SET @ParamIni = (dbo.f_padCarIzq( CONVERT(VARCHAR, @intColIni), 2, '0' )) + '-' + (dbo.f_padCarIzq( CONVERT(VARCHAR, @intSectorIni), 2, '0') ) 	
			SET @ParamFin = (dbo.f_padCarIzq( CONVERT(VARCHAR, @intColFin), 2, '0' )) + '-' + (dbo.f_padCarIzq( CONVERT(VARCHAR, @intSectorFin), 2, '0') ) 						

			INSERT INTO #TmpObras
			SELECT DISTINCT O.intObra
			FROM VetecMarfil.dbo.tbObra O 
			WHERE O.intEmpresa = @intEmpresa
			AND (CONVERT(VARCHAR, SUBSTRING(O.strClave, 4, 5)) >= @ParamIni) 
			AND (CONVERT(VARCHAR, SUBSTRING(O.strClave, 4, 5)) <= @ParamFin)
		END	
		
		--CUANDO QUIERO DE UN AREA, COLONIA Y SECTOR
		IF (@intSectorIni <> 0 AND @intSectorFin <> 0 AND @intCCIni = 0 AND @intCCFin = 0 AND @intAreaIni <> 0 AND @intAreaFin <> 0 AND @intColIni <> 0 AND @intColFin <> 0)
		BEGIN			
			SET @ParamIni = (dbo.f_padCarIzq( CONVERT(VARCHAR, @intAreaIni), 2, '0' )) + '-' + (dbo.f_padCarIzq( CONVERT(VARCHAR, @intColIni), 2, '0' )) + '-' + (dbo.f_padCarIzq( CONVERT(VARCHAR, @intSectorIni), 2, '0') ) 	
			SET @ParamFin = (dbo.f_padCarIzq( CONVERT(VARCHAR, @intAreaFin), 2, '0' )) + '-' + (dbo.f_padCarIzq( CONVERT(VARCHAR, @intColFin), 2, '0' )) + '-' + (dbo.f_padCarIzq( CONVERT(VARCHAR, @intSectorFin), 2, '0') ) 						

			INSERT INTO #TmpObras
			SELECT DISTINCT O.intObra
			FROM VetecMarfil.dbo.tbObra O 
			WHERE O.intEmpresa = @intEmpresa
			AND (CONVERT(VARCHAR, SUBSTRING(O.strClave, 1, 8)) >= @ParamIni) 
			AND (CONVERT(VARCHAR, SUBSTRING(O.strClave, 1, 8)) <= @ParamFin)
		END	
		
		--CUANDO QUIERO DE UN AREA DE COLONIA
		IF (@intSectorIni = 0 AND @intSectorFin = 0 AND @intCCIni = 0 AND @intCCFin = 0 AND @intAreaIni <> 0 AND @intAreaFin <> 0 AND @intColIni <> 0 AND @intColFin <> 0)
		BEGIN			
			SET @ParamIni = (dbo.f_padCarIzq( CONVERT(VARCHAR, @intAreaIni), 2, '0' )) + '-' + (dbo.f_padCarIzq( CONVERT(VARCHAR, @intColIni), 2, '0' ))
			SET @ParamFin = (dbo.f_padCarIzq( CONVERT(VARCHAR, @intAreaFin), 2, '0' )) + '-' + (dbo.f_padCarIzq( CONVERT(VARCHAR, @intColFin), 2, '0' ))						

			INSERT INTO #TmpObras
			SELECT DISTINCT O.intObra
			FROM VetecMarfil.dbo.tbObra O 
			WHERE O.intEmpresa = @intEmpresa
			AND (CONVERT(VARCHAR, SUBSTRING(O.strClave, 1, 5)) >= @ParamIni) 
			AND (CONVERT(VARCHAR, SUBSTRING(O.strClave, 1, 5)) <= @ParamFin)
		END	

		--CUANDO QUIERO DE UN AREA Y SECTOR
		IF (@intSectorIni = 0 AND @intSectorFin = 0 AND @intCCIni = 0 AND @intCCFin = 0 AND @intAreaIni <> 0 AND @intAreaFin <> 0 AND @intColIni = 0 AND @intColFin = 0)
		BEGIN			
			SET @ParamIni = (dbo.f_padCarIzq( CONVERT(VARCHAR, @intAreaIni), 2, '0' ))
			SET @ParamFin = (dbo.f_padCarIzq( CONVERT(VARCHAR, @intAreaFin), 2, '0' ))						

			INSERT INTO #TmpObras
			SELECT DISTINCT O.intObra
			FROM VetecMarfil.dbo.tbObra O 
			WHERE O.intEmpresa = @intEmpresa
			AND (CONVERT(VARCHAR, SUBSTRING(O.strClave, 1, 2)) >= @ParamIni) 
			AND (CONVERT(VARCHAR, SUBSTRING(O.strClave, 1, 2)) <= @ParamFin)
		END	
	---------------------------------FIN DE OBRAS------------------------------------  
	
	---------------------------------------------------------------------------------
		CREATE TABLE #TempCuentas(intRegistro INT IDENTITY(1,1), strCuenta VARCHAR(50) COLLATE SQL_Latin1_General_CP1_CI_AS, intNivel INT)

		DECLARE @NivelCuenta INT
		DECLARE @Recorrido INT
		DECLARE @CuentaIni VARCHAR(50)
		DECLARE @CuentaFin VARCHAR(50)

		SET @NivelCuenta = @intNivel
		SET @Recorrido = 0
		SET @CuentaIni = REPLACE(@strCuentaIni,'-','')
		SET @CuentaFin = REPLACE(@strCuentaFin,'-','')

		WHILE ((@NivelCuenta > @Recorrido) AND (@CuentaIni <> '0' AND @CuentaFin <> '0'))
		BEGIN	
			
			SET @Recorrido = @Recorrido + 1
			IF (@Recorrido = 3 AND (@CuentaIni <> '0' AND  @CuentaFin <> '0'))
			BEGIN
				IF ((@CuentaIni = @CuentaFin) AND (LEN(@CuentaIni) > 8 AND LEN(@CuentaFin) > 8))
				BEGIN 
					INSERT INTO #TempCuentas
					SELECT strCuenta, intNivel 
					FROM tbCuentas
					WHERE intEmpresa = @intEmpresa
					AND intNivel = 3
					AND strCuenta LIKE LEFT(@CuentaFin,12) + '%'
				END
				ELSE
				BEGIN					
					INSERT INTO #TempCuentas
					SELECT strCuenta, intNivel 
					FROM tbCuentas
					WHERE intEmpresa = @intEmpresa
					AND intNivel = 3
					AND strCuenta BETWEEN @CuentaIni AND @CuentaFin
					UNION		
					SELECT strCuenta, intNivel 
					FROM tbCuentas
					WHERE intEmpresa = @intEmpresa
					AND intNivel = 3
					AND strCuenta LIKE LEFT(@CuentaFin,8) + '%'
				END		
			END
			
			IF (@Recorrido = 2 AND (@CuentaIni <> '0' AND @CuentaFin <> '0'))
			BEGIN
				IF ((@CuentaIni = @CuentaFin) AND (LEN(@CuentaIni) >= 8 AND LEN(@CuentaFin) >= 8))
				BEGIN 
					INSERT INTO #TempCuentas
					SELECT strCuenta, intNivel 
					FROM tbCuentas
					WHERE intEmpresa = @intEmpresa
					AND intNivel = 2
					AND strCuenta BETWEEN LEFT(@CuentaIni,8) AND LEFT(@CuentaFin,8)
				END
				ELSE
				BEGIN
					INSERT INTO #TempCuentas
					SELECT strCuenta, intNivel 
					FROM tbCuentas
					WHERE intEmpresa = @intEmpresa
					AND intNivel = 2
					AND strCuenta BETWEEN LEFT(@CuentaIni,4) AND LEFT(@CuentaFin,8)
					UNION		
					SELECT strCuenta, intNivel 
					FROM tbCuentas
					WHERE intEmpresa = @intEmpresa
					AND intNivel = 2
					AND strCuenta LIKE LEFT(@CuentaFin,8) + '%'
				END
				
			END

			IF (@Recorrido = 1 AND (@CuentaIni <> '0' AND @CuentaFin <> '0'))
			BEGIN
				INSERT INTO #TempCuentas
				SELECT strCuenta, intNivel 
				FROM tbCuentas
				WHERE intEmpresa = @intEmpresa
				AND intNivel = 1
				AND strCuenta BETWEEN LEFT(@CuentaIni,4) AND LEFT(@CuentaFin,4)
			END
		END
			
		IF (@CuentaIni = '0' AND @CuentaFin = '0')
		BEGIN
			INSERT INTO #TempCuentas
			SELECT strCuenta, intNivel 
			FROM tbCuentas
			WHERE intEmpresa = @intEmpresa
			AND intNivel <= 3	
			AND strCuenta <> '0'
		END
				
	
			DECLARE @intMes INT
			DECLARE @intTotalMeses INT
			DECLARE @dblSaldoInicial MONEY
			DECLARE @dblCargo MONEY
			DECLARE @dblAbono MONEY
			DECLARE @dblFinal MONEY
			DECLARE @strCuenta VARCHAR(50)
			DECLARE @dblSaldoFinal MONEY

			SET @intMes = 0
			SET @intTotalMeses = 12
			
			SELECT  dblSaldoInicial = SUM(ISNULL(CS.dblSaldoInicial,0)), 
					dblCargoEnero = SUM(ISNULL(CS.dblCargo01,0)), 
					dblAbonoEnero = SUM(ISNULL(CS.dblAbono01,0)),
					dblFinalEnero = SUM(ISNULL(CS.dblSaldoInicial,0)) + 
									SUM(ISNULL(CS.dblCargo01,0)) - SUM(ISNULL(CS.dblAbono01,0)),
					dblCargoFebrero = SUM(ISNULL(CS.dblCargo02,0)), 
					dblAbonoFebrero = SUM(ISNULL(CS.dblAbono02,0)),
					dblFinalFebrero =	(	
											SUM(ISNULL(CS.dblSaldoInicial,0)) 
											+ 
											SUM(ISNULL(CS.dblCargo01,0)) - SUM(ISNULL(CS.dblAbono01,0)) --ENERO
											+ 
											SUM(ISNULL(CS.dblCargo02,0)) - SUM(ISNULL(CS.dblAbono02,0)) --FEBRERO
										),
					dblCargoMarzo = SUM(ISNULL(CS.dblCargo03,0)), 
					dblAbonoMarzo = SUM(ISNULL(CS.dblAbono03,0)),
					dblFinalMarzo = (		
											SUM(ISNULL(CS.dblSaldoInicial,0)) 
											+ 
											SUM(ISNULL(CS.dblCargo01,0)) - SUM(ISNULL(CS.dblAbono01,0)) --ENERO
											+
											SUM(ISNULL(CS.dblCargo02,0)) - SUM(ISNULL(CS.dblAbono02,0)) --FEBRERO
											+
											SUM(ISNULL(CS.dblCargo03,0)) - SUM(ISNULL(CS.dblAbono03,0))	--MARZO
									),
					dblCargoAbril =  SUM(ISNULL(CS.dblCargo04,0)), 
					dblAbonoAbril = SUM(ISNULL(CS.dblAbono04,0)),
					dblFinalAbril = (		
											SUM(ISNULL(CS.dblSaldoInicial,0)) 
											+ 
											SUM(ISNULL(CS.dblCargo01,0)) - SUM(ISNULL(CS.dblAbono01,0)) --ENERO
											+
											SUM(ISNULL(CS.dblCargo02,0)) - SUM(ISNULL(CS.dblAbono02,0)) --FEBRERO
											+
											SUM(ISNULL(CS.dblCargo03,0)) - SUM(ISNULL(CS.dblAbono03,0))	--MARZO
											+
											SUM(ISNULL(CS.dblCargo04,0)) - SUM(ISNULL(CS.dblAbono04,0)) --ABRIL
									),
					dblCargoMayo = SUM(ISNULL(CS.dblCargo05,0)), 
					dblAbonoMayo = SUM(ISNULL(CS.dblAbono05,0)),
					dblFinalMayo = (		
											SUM(ISNULL(CS.dblSaldoInicial,0)) 
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
									),
					dblCargoJunio = SUM(ISNULL(CS.dblCargo06,0)), 
					dblAbonoJunio = SUM(ISNULL(CS.dblAbono06,0)),
					dblFinalJunio = (		
											SUM(ISNULL(CS.dblSaldoInicial,0)) 
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
									),
					dblCargoJulio = SUM(ISNULL(CS.dblCargo07,0)), 
					dblAbonoJulio = SUM(ISNULL(CS.dblAbono07,0)),
					dblFinalJulio = (		
											SUM(ISNULL(CS.dblSaldoInicial,0)) 
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
									),
					dblCargoAgosto = SUM(ISNULL(CS.dblCargo08,0)), 
					dblAbonoAgosto = SUM(ISNULL(CS.dblAbono08,0)),
					dblFinalAgosto = (		
											SUM(ISNULL(CS.dblSaldoInicial,0)) 
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
									),
					dblCargoSeptiembre = SUM(ISNULL(CS.dblCargo09,0)), 
					dblAbonoSeptiembre = SUM(ISNULL(CS.dblAbono09,0)),
					dblFinalSeptiembre = (		
											SUM(ISNULL(CS.dblSaldoInicial,0)) 
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
										),
					dblCargoOctubre = SUM(ISNULL(CS.dblCargo10,0)), 
					dblAbonoOctubre = SUM(ISNULL(CS.dblAbono10,0)),
					dblFinalOctubre = (		
											SUM(ISNULL(CS.dblSaldoInicial,0)) 
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
										),
					dblCargoNoviembre =SUM(ISNULL(CS.dblCargo11,0)), 
					dblAbonoNoviembre = SUM(ISNULL(CS.dblAbono11,0)),
					dblFinalNoviembre = (		
											SUM(ISNULL(CS.dblSaldoInicial,0)) 
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
										),
					dblCargoDiciembre = SUM(ISNULL(CS.dblCargo12,0)), 
					dblAbonoDiciembre = SUM(ISNULL(CS.dblAbono12,0)),
					dblFinalDiciembre = (		
											SUM(ISNULL(CS.dblSaldoInicial,0)) 
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
										),
					strCuenta = CS.strCuenta
			INTO #TmpSaldos			
			FROM tbCuentasSaldos CS
			INNER JOIN #TempCuentas C ON C.strCuenta = CS.strCuenta COLLATE SQL_Latin1_General_CP1_CI_AS
			INNER JOIN #TmpObras O ON CS.strClasifDS = O.strObra
			WHERE CS.intEmpresa = @intEmpresa
			AND CS.intEjercicio = @intEjercicio						
			GROUP BY CS.strCuenta

		-------------------------------------------------------------		
		CREATE TABLE #TempCuentasSaldos (intRegistro INT IDENTITY(1,1), strCuenta VARCHAR(50))
			
		INSERT INTO #TempCuentasSaldos
			SELECT DISTINCT strCuenta FROM #TmpSaldos
		
		CREATE TABLE #TempLibroMayor (strCuenta VARCHAR(50), intMes INT, strMes VARCHAR(50), dblSaldoInicial MONEY, dblCargos MONEY, dblAbonos MONEY, dblSaldoFinal MONEY)

		DECLARE @intTotalCuentas INT
		DECLARE @intRegCuenta INT
		
		SELECT @intTotalCuentas = MAX(intRegistro) FROM #TempCuentasSaldos
		
		SET @intRegCuenta = 0
		
		WHILE @intRegCuenta < @intTotalCuentas
		BEGIN
			SET @intRegCuenta  = @intRegCuenta + 1

			INSERT INTO #TempLibroMayor	(strCuenta, intMes, strMes, dblSaldoInicial, dblCargos, dblAbonos, dblSaldoFinal)			
			SELECT	strCuenta = (SELECT C.strCuenta FROM #TempCuentasSaldos C WHERE C.intRegistro = @intRegCuenta),					
					intMes = M.intMes, 
					strNombre = M.strNombre,
					dblSaldoInicial = 0,
					dblCargos = 0,
					dblAbonos = 0,
					dblSaldoFinal = 0
			FROM tbMeses M
		END	

			WHILE @intMes < @intTotalMeses
			BEGIN
				SET @intMes = @intMes + 1
				
				IF @intMes = 1
				BEGIN
					UPDATE LM SET	LM.dblSaldoInicial = ISNULL(TSE.dblSaldoInicial,0), 
									LM.dblCargos = ISNULL(TSE.dblCargoEnero,0),
									LM.dblAbonos = ISNULL(TSE.dblAbonoEnero,0),
									LM.dblSaldoFinal =	ISNULL(TSE.dblSaldoInicial,0) + ISNULL(TSE.dblCargoEnero,0) - ISNULL(TSE.dblAbonoEnero,0)
					FROM #TempLibroMayor LM
					LEFT JOIN #TmpSaldos TSE ON TSE.strCuenta = LM.strCuenta COLLATE SQL_Latin1_General_CP1_CI_AS
					WHERE LM.intMes = @intMes	
				END
				IF @intMes = 2
				BEGIN					
					UPDATE LM SET	LM.dblSaldoInicial = ISNULL(TSE.dblFinalEnero,0), 
									LM.dblCargos = ISNULL(TSE.dblCargoFebrero,0),
									LM.dblAbonos = ISNULL(TSE.dblAbonoFebrero,0),
									LM.dblSaldoFinal =		( ISNULL(TSE.dblFinalEnero,0) ) +
															( ISNULL(TSE.dblCargoFebrero,0)) - (ISNULL(TSE.dblAbonoFebrero,0))
					FROM #TempLibroMayor LM
					LEFT JOIN #TmpSaldos TSE ON TSE.strCuenta = LM.strCuenta COLLATE SQL_Latin1_General_CP1_CI_AS
					WHERE LM.intMes = @intMes	
				END
				IF @intMes = 3
				BEGIN
					UPDATE LM SET	LM.dblSaldoInicial = ISNULL(TSE.dblFinalFebrero,0), 
									LM.dblCargos = ISNULL(TSE.dblCargoMarzo,0),
									LM.dblAbonos = ISNULL(TSE.dblAbonoMarzo,0),
									LM.dblSaldoFinal =	( ISNULL(TSE.dblFinalFebrero,0)) +
														( ISNULL(TSE.dblCargoMarzo,0)) - (ISNULL(TSE.dblAbonoMarzo,0))
					FROM #TempLibroMayor LM
					LEFT JOIN #TmpSaldos TSE ON TSE.strCuenta = LM.strCuenta COLLATE SQL_Latin1_General_CP1_CI_AS
					WHERE LM.intMes = @intMes	
				END
				IF @intMes = 4
				BEGIN
					UPDATE LM SET	LM.dblSaldoInicial = ISNULL(TSE.dblFinalMarzo,0), 
									LM.dblCargos = ISNULL(TSE.dblCargoAbril,0),
									LM.dblAbonos = ISNULL(TSE.dblAbonoAbril,0),
									LM.dblSaldoFinal =	( ISNULL(TSE.dblFinalMarzo,0)) +
														( ISNULL(TSE.dblCargoAbril,0)) - (ISNULL(TSE.dblAbonoAbril,0))
					FROM #TempLibroMayor LM
					LEFT JOIN #TmpSaldos TSE ON TSE.strCuenta = LM.strCuenta COLLATE SQL_Latin1_General_CP1_CI_AS
					WHERE LM.intMes = @intMes	
				END
				IF @intMes = 5
				BEGIN
					UPDATE LM SET	LM.dblSaldoInicial = ISNULL(TSE.dblFinalAbril,0), 
									LM.dblCargos = ISNULL(TSE.dblCargoMayo,0),
									LM.dblAbonos = ISNULL(TSE.dblAbonoMayo,0),
									LM.dblSaldoFinal =	( ISNULL(TSE.dblFinalAbril,0)) +
														( ISNULL(TSE.dblCargoMayo,0)) - (ISNULL(TSE.dblAbonoMayo,0) )									
					FROM #TempLibroMayor LM
					LEFT JOIN #TmpSaldos TSE ON TSE.strCuenta = LM.strCuenta COLLATE SQL_Latin1_General_CP1_CI_AS
					WHERE LM.intMes = @intMes	
				END
				IF @intMes = 6
				BEGIN
					UPDATE LM SET	LM.dblSaldoInicial = ISNULL(TSE.dblFinalMayo,0), 
									LM.dblCargos = ISNULL(TSE.dblCargoJunio,0),
									LM.dblAbonos = ISNULL(TSE.dblAbonoJunio,0),
									LM.dblSaldoFinal =	( ISNULL(TSE.dblFinalMayo,0)) +
														( ISNULL(TSE.dblCargoJunio,0)) - (ISNULL(TSE.dblAbonoJunio,0) )
					FROM #TempLibroMayor LM
					LEFT JOIN #TmpSaldos TSE ON TSE.strCuenta = LM.strCuenta COLLATE SQL_Latin1_General_CP1_CI_AS
					WHERE LM.intMes = @intMes	
				END
				IF @intMes = 7
				BEGIN
					UPDATE LM SET	LM.dblSaldoInicial = ISNULL(TSE.dblFinalJunio,0), 
									LM.dblCargos = ISNULL(TSE.dblCargoJulio,0),
									LM.dblAbonos = ISNULL(TSE.dblAbonoJulio,0),
									LM.dblSaldoFinal =	( ISNULL(TSE.dblFinalJunio,0)) +
														( ISNULL(TSE.dblCargoJulio,0)) - (ISNULL(TSE.dblAbonoJulio,0) )
													
					FROM #TempLibroMayor LM
					LEFT JOIN #TmpSaldos TSE ON TSE.strCuenta = LM.strCuenta COLLATE SQL_Latin1_General_CP1_CI_AS
					WHERE LM.intMes = @intMes	
				END
				IF @intMes = 8
				BEGIN
					UPDATE LM SET	LM.dblSaldoInicial = ISNULL(TSE.dblFinalJulio,0), 
									LM.dblCargos = ISNULL(TSE.dblCargoAgosto,0),
									LM.dblAbonos = ISNULL(TSE.dblAbonoAgosto,0),
									LM.dblSaldoFinal =	( ISNULL(TSE.dblFinalJulio,0)) +
														( ISNULL(TSE.dblCargoAgosto,0)) - (ISNULL(TSE.dblAbonoAgosto,0) )
					FROM #TempLibroMayor LM
					LEFT JOIN #TmpSaldos TSE ON TSE.strCuenta = LM.strCuenta COLLATE SQL_Latin1_General_CP1_CI_AS
					WHERE LM.intMes = @intMes	
				END
				IF @intMes = 9
				BEGIN
					UPDATE LM SET	LM.dblSaldoInicial = ISNULL(TSE.dblFinalAgosto,0), 
									LM.dblCargos = ISNULL(TSE.dblCargoSeptiembre,0),
									LM.dblAbonos = ISNULL(TSE.dblAbonoSeptiembre,0),
									LM.dblSaldoFinal =	( ISNULL(TSE.dblFinalAgosto,0)) +
														( ISNULL(TSE.dblCargoSeptiembre,0)) - (ISNULL(TSE.dblAbonoSeptiembre,0) )
					FROM #TempLibroMayor LM
					LEFT JOIN #TmpSaldos TSE ON TSE.strCuenta = LM.strCuenta COLLATE SQL_Latin1_General_CP1_CI_AS
					WHERE LM.intMes = @intMes	
				END
				IF @intMes = 10
				BEGIN
					UPDATE LM SET	LM.dblSaldoInicial = ISNULL(TSE.dblFinalSeptiembre,0), 
									LM.dblCargos = ISNULL(TSE.dblCargoOctubre,0),
									LM.dblAbonos = ISNULL(TSE.dblAbonoOctubre,0),
									LM.dblSaldoFinal =	( ISNULL(TSE.dblFinalSeptiembre,0)) +
														( ISNULL(TSE.dblCargoOctubre,0)) - (ISNULL(TSE.dblAbonoOctubre,0) )
					FROM #TempLibroMayor LM
					LEFT JOIN #TmpSaldos TSE ON TSE.strCuenta = LM.strCuenta COLLATE SQL_Latin1_General_CP1_CI_AS
					WHERE LM.intMes = @intMes	
				END
				IF @intMes = 11
				BEGIN
					UPDATE LM SET	LM.dblSaldoInicial = ISNULL(TSE.dblFinalOctubre,0), 
									LM.dblCargos = ISNULL(TSE.dblCargoNoviembre,0),
									LM.dblAbonos = ISNULL(TSE.dblAbonoNoviembre,0),
									LM.dblSaldoFinal =	( ISNULL(TSE.dblFinalOctubre,0)) +
														( ISNULL(TSE.dblCargoNoviembre,0)) - (ISNULL(TSE.dblAbonoNoviembre,0) )
					FROM #TempLibroMayor LM
					LEFT JOIN #TmpSaldos TSE ON TSE.strCuenta = LM.strCuenta COLLATE SQL_Latin1_General_CP1_CI_AS
					WHERE LM.intMes = @intMes	
				END
				IF @intMes = 12
				BEGIN
					UPDATE LM SET	LM.dblSaldoInicial = ISNULL(TSE.dblFinalNoviembre,0), 
									LM.dblCargos = ISNULL(TSE.dblCargoDiciembre,0),
									LM.dblAbonos = ISNULL(TSE.dblAbonoDiciembre,0),
									LM.dblSaldoFinal =	( ISNULL(TSE.dblFinalNoviembre,0)) +
														( ISNULL(TSE.dblCargoDiciembre,0)) - (ISNULL(TSE.dblAbonoDiciembre,0) )
					FROM #TempLibroMayor LM
					LEFT JOIN #TmpSaldos TSE ON TSE.strCuenta = LM.strCuenta COLLATE SQL_Latin1_General_CP1_CI_AS
					WHERE LM.intMes = @intMes	
				END
			END
			
--			DECLARE @strEmpresa VARCHAR(250)
--
--			SELECT @strEmpresa = strNombre FROM tbEmpresas WHERE intEmpresa = @intEmpresa
		
			--SELECT * FROM tbEmpresas
			
			CREATE TABLE #TmpCtasDelete(strCuenta VARCHAR(50))

			IF @intSaldo = 1
			BEGIN
				INSERT INTO #TmpCtasDelete
				SELECT  LM.strCuenta 
				FROM #TempLibroMayor LM
				GROUP BY LM.strCuenta
				HAVING SUM(ABS(LM.dblSaldoInicial)) + SUM(ABS(LM.dblCargos)) + SUM((LM.dblAbonos)) = 0
				
				DELETE FROM #TempLibroMayor
				WHERE strCuenta IN (SELECT strCuenta FROM #TmpCtasDelete)			
			END
			
			SELECT	TLM.*,
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
					strCuentaFormato = dbo.F_CtaFormato(C.strCuenta)
			FROM #TempLibroMayor TLM
			INNER JOIN tbCuentas C ON C.intEmpresa = @intEmpresa AND C.strCuenta = TLM.strCuenta COLLATE SQL_Latin1_General_CP1_CI_AS
			INNER JOIN tbEmpresas E ON E.intEmpresa = @intEmpresa
			 			
		DROP TABLE #TmpCtasDelete
		DROP TABLE #TmpSaldos
		DROP TABLE #TempLibroMayor
		DROP TABLE #TempCuentas
		DROP TABLE #TmpObras
      	                           
	SET NOCOUNT OFF	
END
GO

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_LibroMayorContabilidad_Reporte Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_LibroMayorContabilidad_Reporte Error on Creation'
END
GO




