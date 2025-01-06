
/****** Object:  StoredProcedure [dbo.usp_Tareas_Fill]    Script Date: 12/8/2009 10:45:19 AM ******/
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbPolizas_DesafectarTodo')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbPolizas_DesafectarTodo
	PRINT N'Drop Procedure : dbo.usp_tbPolizas_DesafectarTodo - Succeeded !!!'
END
GO

------------------------------------------------------------------------------------
---   Aplicacion: Marfil.		                                                 ---
---        Autor: Rubén Mora Martínez                                            ---
---  Descripcion: Obtiene un registro de la tabla:  tbPolizasEnc                 ---
---                                                                              ---
------------------------------------------------------------------------------------
---    Fecha     Autor  Comentario                                               ---
---  ----------  -----  -------------------------------------------------------  ---
---  12/11/2010  RMM    Create procedure                                         ---
------------------------------------------------------------------------------------


CREATE PROCEDURE [dbo].[usp_tbPolizas_DesafectarTodo]
(      
    @intEmpresa		Int, 
	@intEjercicio	int,
	@intMes			Int, 
	@strTipoPoliza	VarChar(60), 
	@strTipoFin		VarChar(60),
	@intFolioIni	Int, 
	@intFolioFin	Int,
	@strUsuario		VarChar(60),
    @strMaquina		VarChar(60)
)      
AS 
BEGIN   

	---------------------VALIDAMOS EL CIERRE MENSUAL---------------------
	IF EXISTS(SELECT 1 from VetecMarfil..tbCerrarPeriodo WHERE intEmpresa = @intEmpresa AND intEjercicio = @intEjercicio AND intMes = @intMes AND bCerrado = 1 AND intModulo = 1)
	BEGIN	
		DECLARE @Message VARCHAR(200)
		DECLARE @Date DATETIME

		SET @Date = '01/' + CONVERT(VARCHAR,@intMes) + '/' + CONVERT(VARCHAR,@intEjercicio)
	
		SET @Message = 'El mes ' + DATENAME(month,@Date) + '. Esta cerrado.'
		RAISERROR(@Message,16,1)
		RETURN
	END
	
	BEGIN TRY
	BEGIN TRANSACTION   

	---------------------DESAFECTA TODO---------------------	
	IF @strTipoPoliza = '0' AND @strTipoFin = '0' AND @intFolioIni = 0 AND @intFolioFin = 0
	BEGIN
		ALTER TABLE tbPolizasEnc DISABLE TRIGGER ALL
		ALTER TABLE tbPolizasDet DISABLE TRIGGER ALL

		UPDATE tbPolizasEnc 
		SET intIndAfectada = 0 
		WHERE intEmpresa = @intEmpresa
		AND intEjercicio = @intEjercicio 
		AND intMes = @intMes
		     
		UPDATE tbPolizasDet 
		SET intIndAfectada = 0 
		WHERE intEmpresa = @intEmpresa
		AND intEjercicio = @intEjercicio 
		AND intMes = @intMes

		DECLARE @strSQL NVarChar(4000)
		SET @strSQL =           ' UPDATE tbCuentasSaldos '
		SET @strSQL = @strSQL + ' SET dblAbono' + Right('00' + (LTrim(RTrim(Str(@intMes)))), 2) + ' = 0, '
		SET @strSQL = @strSQL + ' dblCargo' + Right('00' + (LTrim(RTrim(Str(@intMes)))), 2) + ' = 0 '     
		SET @strSQL = @strSQL + ' WHERE tbCuentasSaldos.intEmpresa = ' + LTrim(RTrim( Str(@intEmpresa) )) + '  '
		SET @strSQL = @strSQL + ' AND   tbCuentasSaldos.intEjercicio = ' + LTrim(RTrim( Str(@intEjercicio) )) 
 
		EXEC sp_executeSQL @strSQL

		ALTER TABLE tbPolizasEnc ENABLE TRIGGER ALL
		ALTER TABLE tbPolizasDet ENABLE TRIGGER ALL		
	END
	ELSE
	BEGIN	
    
		DECLARE @Rows int
		DECLARE @Count int
		DECLARE @strTipo VarChar(60)
			
		-------------------------------------------------------------------------------------------------------------------------------------------------         		 
		-- CREO LA TABLA DONDE VOY A JUNTAR TODO      
		DECLARE @Previo Table       
		(intEmpresa Int, intEjercicio Int, strCuenta[varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL, 
		strClasifEnc [varchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL, strClasifDP  [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL, strClasifDS [varchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS,       
		intTipoMoneda Int, intIndInterEmpresa Int, dblCargo Decimal(16,2), dblAbono Decimal(16,2))   
	           
		-- INSERTO LAS CUENTAS DE ULTIMO NIVEL    	
		INSERT @Previo 
		SELECT	D.intEmpresa, D.intEjercicio, D.strCuenta,                       
				0, (CASE WHEN C.intIndAuxiliar = 1 THEN D.strClasifDP ELSE 0 END) AS strClasifDP, D.strClasifDS, C.intNivel, 0,					
				Convert(Decimal(16,4), Sum (CASE WHEN D.intTipoMovto = 1 THEN D.dblImporte ELSE 0 END) ) dblCargo,      
				Convert(Decimal(16,4), Sum (CASE WHEN D.intTipoMovto =  0 THEN D.dblImporte ELSE 0 END) ) dblAbono--,			   
		FROM tbPolizasDet D
		INNER JOIN tbCuentas C ON C.strCuenta =  D.strCuenta  AND C.intEmpresa =  D.intEmpresa  
		INNER JOIN tbPolizasEnc PE ON PE.strPoliza = D.strPoliza AND PE.intEmpresa = D.intEmpresa AND PE.intEjercicio = D.intEjercicio AND PE.intMes = D.intMes
		WHERE D.intEmpresa = @intEmpresa      
		AND D.intEjercicio = @intEjercicio          
		AND D.intMes = @intMes 
		AND ((@strTipoPoliza = '0') OR(PE.strTipoPoliza BETWEEN @strTipoPoliza AND @strTipoFin))
		AND ((@intFolioIni = 0) OR (PE.intFolioPoliza BETWEEN @intFolioIni AND @intFolioFin))
		AND PE.intEstatus <> 9 
		AND D.intIndAfectada = 1
		AND D.strClasifDS IS NOT NULL 				
		GROUP BY D.intEmpresa, D.intEjercicio, D.strCuenta, D.intMes, D.strClasifDS, C.intNivel, C.intIndAuxiliar,D.strClasifDP

		--	INSERTO LAS CUENTAS DE LOS OTROS NIVELES      
		DECLARE @intCont Int      
		SET @intCont = 0     
				
		WHILE @intCont <= 1      
		BEGIN      
			SET @intCont = @intCont + 1  
			--AGREGA CUENTAS DE NIVEL 1 PARA TODAS LAS CUENTAS DE NIVEL 2, NO ME INTERESA SU AUX EN EL NIVEL 1				
			
			IF @intCont = 1				
			BEGIN					
				INSERT @Previo       
				SELECT intEmpresa,intEjercicio,dbo.F_CtasTotXNiv(strCuenta,@intCont,@intEmpresa) strCuenta,       
					   strClasifEnc,0,strClasifDS,intTipoMoneda,intIndInterEmpresa,Round( Sum(dblCargo), 2) dblCargo, 
					   Round( Sum(dblAbono), 2) dblAbono     
				FROM @Previo 
				WHERE dbo.F_CtasTotXNiv(strCuenta, @intCont, @intEmpresa) IS NOT NULL								   
				AND intTipoMoneda BETWEEN 2 AND 3
				GROUP BY intEmpresa, intEjercicio, dbo.F_CtasTotXNiv(strCuenta, @intCont , @intEmpresa),       
				strClasifEnc, intTipoMoneda, intIndInterEmpresa, strClasifDS
			END
					
			--AGREGA CUENTAS DE NIVEL 2, PARA LAS CUENTAS QUE SE ENCUENTRE EN NIVEL 3
			IF @intCont = 2				
			BEGIN					
				INSERT @Previo       
				SELECT  intEmpresa, intEjercicio, dbo.F_CtasTotXNiv(strCuenta, @intCont , @intEmpresa) strCuenta,       
						strClasifEnc, IsNull(strClasifDP , '0'), ISNULL(strClasifDS,'0'),       
						intTipoMoneda, intIndInterEmpresa,       
						Round( Sum(dblCargo), 2) dblCargo, Round( Sum(dblAbono), 2) dblAbono     
				FROM @Previo 
				WHERE dbo.F_CtasTotXNiv(strCuenta, @intCont, @intEmpresa) IS NOT NULL								   
				AND	intTipoMoneda = 3
				GROUP BY intEmpresa, intEjercicio, dbo.F_CtasTotXNiv(strCuenta, @intCont , @intEmpresa),       
				strClasifEnc,strClasifDP, strClasifDS,       
				intTipoMoneda, intIndInterEmpresa
			END					
	        
		END  
			
		DECLARE @Afec Table (intRegistro INT IDENTITY (1,1), intEmpresa Int, intEjercicio Int, 
  		strCuenta[varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL, strClasifDP  [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL , strClasifDS [varchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,                              
		dblCargo Money, dblAbono Money) 
		
		CREATE TABLE  #TmpCuentasExistentes( intEmpresa Int, intEjercicio Int, strCuenta[varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL, 
		strClasifDP  [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL , strClasifDS [varchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL, intExiste INT) 
		
		CREATE TABLE  #TmpCuentasPorCrear( intEmpresa Int, intEjercicio Int, strCuenta[varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL, 
		strClasifDP  [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL , strClasifDS [varchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL, intExiste INT) 
	   	
		INSERT @Afec     
		SELECT intEmpresa, intEjercicio , strCuenta, strClasifDP,strClasifDS, Sum(dblCargo) dblCargo , Sum(dblAbono) dblAbono    
		FROM @Previo    
		GROUP BY intEmpresa,intEjercicio,strCuenta,strClasifDP,strClasifDS
		
		INSERT INTO #TmpCuentasExistentes  
		SELECT CS.intEmpresa, CS.intEjercicio, CS.strCuenta, CS.strClasifDP, CS.strClasifDS, 1
		FROM tbCuentasSaldos CS
		INNER JOIN @Afec A ON A.strCuenta = CS.strCuenta AND A.strClasifDS = CS.strClasifDS AND A.strClasifDP = CS.strClasifDP AND A.intEmpresa = CS.intEmpresa
		WHERE CS.intEmpresa = @intEmpresa
		AND CS.intEjercicio = @intEjercicio
			
		INSERT INTO #TmpCuentasPorCrear
		SELECT A.intEmpresa, A.intEjercicio, A.strCuenta, A.strClasifDP, A.strClasifDS, 0
		FROM @Afec A
		LEFT JOIN #TmpCuentasExistentes CE ON CE.intEmpresa = A.intEmpresa AND CE.strClasifDS = A.strClasifDS AND CE.strClasifDP = A.strClasifDP AND A.strCuenta = CE.strCuenta
		WHERE intExiste IS NULL
		
		DECLARE @CountCta INT
		
		SET @CountCta = 0
		
		SELECT @CountCta = COUNT(*) FROM #TmpCuentasPorCrear

		IF @CountCta > 0 
		BEGIN
			INSERT INTO tbCuentasSaldos      
			([intEmpresa], [intEjercicio], [strCuenta], [strClasifEnc], [strClasifDP],       
			[strClasifDS], [intIndInterEmpresa], [intTipoMoneda], [dblSaldoInicial],       
			[dblCargo01], [dblAbono01], [dblCargo02], [dblAbono02], [dblCargo03], [dblAbono03],       
			[dblCargo04], [dblAbono04], [dblCargo05], [dblAbono05], [dblCargo06], [dblAbono06],       
			[dblCargo07], [dblAbono07], [dblCargo08], [dblAbono08], [dblCargo09], [dblAbono09],       
			[dblCargo10], [dblAbono10], [dblCargo11], [dblAbono11], [dblCargo12], [dblAbono12],       
			[datFechaAlta], [strUsuarioAlta], [strMaquinaAlta], [datFechaMod], [strUsuarioMod], [strMaquinaMod])       
			SELECT CP.intEmpresa, CP.intEjercicio, CP.strCuenta, '0', CP.strClasifDP,       
			CP.strClasifDS, 0, 1, 0, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,      
			Null, Null, Null, Null, Null, Null  
			FROM #TmpCuentasPorCrear CP
		END		
		
		IF @intMes = 1 
		BEGIN
			UPDATE CS 
			SET CS.dblCargo01 = ISNULL(CS.dblCargo01,0) - ISNULL(A.dblCargo,0), 
				CS.dblAbono01 = ISNULL(CS.dblAbono01,0) - ISNULL(A.dblAbono,0)	
			FROM tbCuentasSaldos CS
			INNER JOIN @Afec A ON A.intEmpresa = CS.intEmpresa AND CS.intEjercicio = A.intEjercicio  AND CS.strCuenta = A.strCuenta AND CS.strClasifDS = A.strClasifDS AND CS.strClasifDP = A.strClasifDP
			WHERE CS.intEmpresa = @intEmpresa
			AND CS.intEjercicio = @intEjercicio 

			UPDATE  CS
			SET dblCargo01 = 0
			FROM tbCuentasSaldos CS
			WHERE intEjercicio = @intEjercicio
			AND intEmpresa = @intEmpresa
			AND dblCargo01 < 0
			AND strCuenta IN(SELECT strCuenta FROM @Afec)

			UPDATE  CS
			SET dblAbono01 = 0
			FROM tbCuentasSaldos CS
			WHERE intEjercicio = @intEjercicio
			AND intEmpresa = @intEmpresa
			AND dblAbono01 < 0
			AND strCuenta IN(SELECT strCuenta FROM @Afec)
		END
			    
		IF @intMes = 2  
		BEGIN			
			UPDATE CS 
			SET CS.dblCargo02 = ISNULL(CS.dblCargo02,0) - ISNULL(A.dblCargo,0), 
				CS.dblAbono02 = ISNULL(CS.dblAbono02,0) - ISNULL(A.dblAbono,0)	
			FROM tbCuentasSaldos CS
			INNER JOIN @Afec A ON A.intEmpresa = CS.intEmpresa AND CS.intEjercicio = A.intEjercicio  AND CS.strCuenta = A.strCuenta AND CS.strClasifDS = A.strClasifDS AND CS.strClasifDP = A.strClasifDP
			WHERE CS.intEmpresa = @intEmpresa
			AND CS.intEjercicio = @intEjercicio 

			UPDATE  CS
			SET dblCargo02 = 0
			FROM tbCuentasSaldos CS
			WHERE intEjercicio = @intEjercicio
			AND intEmpresa = @intEmpresa
			AND dblCargo02 < 0
			AND strCuenta IN(SELECT strCuenta FROM @Afec)

			UPDATE  CS
			SET dblAbono02 = 0
			FROM tbCuentasSaldos CS
			WHERE intEjercicio = @intEjercicio
			AND intEmpresa = @intEmpresa
			AND dblAbono02 < 0
			AND strCuenta IN(SELECT strCuenta FROM @Afec)
		END
	      
		IF @intMes = 3
		BEGIN
			UPDATE CS 
			SET CS.dblCargo03 = ISNULL(CS.dblCargo03,0) - ISNULL(A.dblCargo,0), 
				CS.dblAbono03 = ISNULL(CS.dblAbono03,0) - ISNULL(A.dblAbono,0)	
			FROM tbCuentasSaldos CS
			INNER JOIN @Afec A ON A.intEmpresa = CS.intEmpresa AND CS.intEjercicio = A.intEjercicio  AND CS.strCuenta = A.strCuenta AND CS.strClasifDS = A.strClasifDS AND CS.strClasifDP = A.strClasifDP
			WHERE CS.intEmpresa = @intEmpresa
			AND CS.intEjercicio = @intEjercicio 

			UPDATE  CS
			SET dblCargo03 = 0
			FROM tbCuentasSaldos CS
			WHERE intEjercicio = @intEjercicio
			AND intEmpresa = @intEmpresa
			AND dblCargo03 < 0
			AND strCuenta IN(SELECT strCuenta FROM @Afec)

			UPDATE  CS
			SET dblAbono03 = 0
			FROM tbCuentasSaldos CS
			WHERE intEjercicio = @intEjercicio
			AND intEmpresa = @intEmpresa
			AND dblAbono03 < 0
			AND strCuenta IN(SELECT strCuenta FROM @Afec)
		END

		IF @intMes = 4  
		BEGIN		
			UPDATE CS 
			SET CS.dblCargo04 = ISNULL(CS.dblCargo04,0) - ISNULL(A.dblCargo,0), 
				CS.dblAbono04 = ISNULL(CS.dblAbono04,0) - ISNULL(A.dblAbono,0)	
			FROM tbCuentasSaldos CS
			INNER JOIN @Afec A ON A.intEmpresa = CS.intEmpresa AND CS.intEjercicio = A.intEjercicio  AND CS.strCuenta = A.strCuenta AND CS.strClasifDS = A.strClasifDS AND CS.strClasifDP = A.strClasifDP
			WHERE CS.intEmpresa = @intEmpresa
			AND CS.intEjercicio = @intEjercicio 

			UPDATE  CS
			SET dblCargo04 = 0
			FROM tbCuentasSaldos CS
			WHERE intEjercicio = @intEjercicio
			AND intEmpresa = @intEmpresa
			AND dblCargo04 < 0
			AND strCuenta IN(SELECT strCuenta FROM @Afec)

			UPDATE  CS
			SET dblAbono04 = 0
			FROM tbCuentasSaldos CS
			WHERE intEjercicio = @intEjercicio
			AND intEmpresa = @intEmpresa
			AND dblAbono04 < 0
			AND strCuenta IN(SELECT strCuenta FROM @Afec)
		END  
	      
		IF @intMes = 5
		BEGIN		
			UPDATE CS 
			SET CS.dblCargo05 = ISNULL(CS.dblCargo05,0) - ISNULL(A.dblCargo,0), 
				CS.dblAbono05 = ISNULL(CS.dblAbono05,0) - ISNULL(A.dblAbono,0)	
			FROM tbCuentasSaldos CS
			INNER JOIN @Afec A ON A.intEmpresa = CS.intEmpresa AND CS.intEjercicio = A.intEjercicio  AND CS.strCuenta = A.strCuenta AND CS.strClasifDS = A.strClasifDS AND CS.strClasifDP = A.strClasifDP
			WHERE CS.intEmpresa = @intEmpresa
			AND CS.intEjercicio = @intEjercicio 

			UPDATE  CS
			SET dblCargo05 = 0
			FROM tbCuentasSaldos CS
			WHERE intEjercicio = @intEjercicio
			AND intEmpresa = @intEmpresa
			AND dblCargo05 < 0
			AND strCuenta IN(SELECT strCuenta FROM @Afec)

			UPDATE  CS
			SET dblAbono05 = 0
			FROM tbCuentasSaldos CS
			WHERE intEjercicio = @intEjercicio
			AND intEmpresa = @intEmpresa
			AND dblAbono05 < 0
			AND strCuenta IN(SELECT strCuenta FROM @Afec)		
		 END
	      
		IF @intMes = 6  
		BEGIN
			UPDATE CS 
			SET CS.dblCargo06 = ISNULL(CS.dblCargo06,0) - ISNULL(A.dblCargo,0), 
				CS.dblAbono06 = ISNULL(CS.dblAbono06,0) - ISNULL(A.dblAbono,0)	
			FROM tbCuentasSaldos CS
			INNER JOIN @Afec A ON A.intEmpresa = CS.intEmpresa AND CS.intEjercicio = A.intEjercicio  AND CS.strCuenta = A.strCuenta AND CS.strClasifDS = A.strClasifDS AND CS.strClasifDP = A.strClasifDP
			WHERE CS.intEmpresa = @intEmpresa
			AND CS.intEjercicio = @intEjercicio 

			UPDATE  CS
			SET dblCargo06 = 0
			FROM tbCuentasSaldos CS
			WHERE intEjercicio = @intEjercicio
			AND intEmpresa = @intEmpresa
			AND dblCargo06 < 0
			AND strCuenta IN(SELECT strCuenta FROM @Afec)

			UPDATE  CS
			SET dblAbono06 = 0
			FROM tbCuentasSaldos CS
			WHERE intEjercicio = @intEjercicio
			AND intEmpresa = @intEmpresa
			AND dblAbono06 < 0
			AND strCuenta IN(SELECT strCuenta FROM @Afec)
		END    
	      
		IF @intMes = 7      
		BEGIN	
			UPDATE CS 
			SET CS.dblCargo07 = ISNULL(CS.dblCargo07,0) - ISNULL(A.dblCargo,0), 
				CS.dblAbono07 = ISNULL(CS.dblAbono07,0) - ISNULL(A.dblAbono,0)	
			FROM tbCuentasSaldos CS
			INNER JOIN @Afec A ON A.intEmpresa = CS.intEmpresa AND CS.intEjercicio = A.intEjercicio  AND CS.strCuenta = A.strCuenta AND CS.strClasifDS = A.strClasifDS AND CS.strClasifDP = A.strClasifDP
			WHERE CS.intEmpresa = @intEmpresa
			AND CS.intEjercicio = @intEjercicio 

			UPDATE  CS
			SET dblCargo07 = 0
			FROM tbCuentasSaldos CS
			WHERE intEjercicio = @intEjercicio
			AND intEmpresa = @intEmpresa
			AND dblCargo07 < 0
			AND strCuenta IN(SELECT strCuenta FROM @Afec)

			UPDATE  CS
			SET dblAbono07 = 0
			FROM tbCuentasSaldos CS
			WHERE intEjercicio = @intEjercicio
			AND intEmpresa = @intEmpresa
			AND dblAbono07 < 0
			AND strCuenta IN(SELECT strCuenta FROM @Afec)
		END
	      
		IF @intMes = 8 
		BEGIN
			UPDATE CS 
			SET CS.dblCargo08 = ISNULL(CS.dblCargo08,0) - ISNULL(A.dblCargo,0), 
				CS.dblAbono08 = ISNULL(CS.dblAbono08,0) - ISNULL(A.dblAbono,0)	
			FROM tbCuentasSaldos CS
			INNER JOIN @Afec A ON A.intEmpresa = CS.intEmpresa AND CS.intEjercicio = A.intEjercicio  AND CS.strCuenta = A.strCuenta AND CS.strClasifDS = A.strClasifDS AND CS.strClasifDP = A.strClasifDP
			WHERE CS.intEmpresa = @intEmpresa
			AND CS.intEjercicio = @intEjercicio 

			UPDATE  CS
			SET dblCargo08 = 0
			FROM tbCuentasSaldos CS
			WHERE intEjercicio = @intEjercicio
			AND intEmpresa = @intEmpresa
			AND dblCargo08 < 0
			AND strCuenta IN(SELECT strCuenta FROM @Afec)

			UPDATE  CS
			SET dblAbono08 = 0
			FROM tbCuentasSaldos CS
			WHERE intEjercicio = @intEjercicio
			AND intEmpresa = @intEmpresa
			AND dblAbono08 < 0
			AND strCuenta IN(SELECT strCuenta FROM @Afec)
		END     
	      
		IF @intMes = 9     
		BEGIN
			UPDATE CS 
			SET CS.dblCargo09 = ISNULL(CS.dblCargo09,0) - ISNULL(A.dblCargo,0), 
				CS.dblAbono09 = ISNULL(CS.dblAbono09,0) - ISNULL(A.dblAbono,0)	
			FROM tbCuentasSaldos CS
			INNER JOIN @Afec A ON A.intEmpresa = CS.intEmpresa AND CS.intEjercicio = A.intEjercicio  AND CS.strCuenta = A.strCuenta AND CS.strClasifDS = A.strClasifDS AND CS.strClasifDP = A.strClasifDP
			WHERE CS.intEmpresa = @intEmpresa
			AND CS.intEjercicio = @intEjercicio 

			UPDATE  CS
			SET dblCargo09 = 0
			FROM tbCuentasSaldos CS
			WHERE intEjercicio = @intEjercicio
			AND intEmpresa = @intEmpresa
			AND dblCargo09 < 0
			AND strCuenta IN(SELECT strCuenta FROM @Afec)

			UPDATE  CS
			SET dblAbono09 = 0
			FROM tbCuentasSaldos CS
			WHERE intEjercicio = @intEjercicio
			AND intEmpresa = @intEmpresa
			AND dblAbono09 < 0
			AND strCuenta IN(SELECT strCuenta FROM @Afec)
		END

		IF @intMes = 10 
		BEGIN
			UPDATE CS 
			SET CS.dblCargo10 = ISNULL(CS.dblCargo10,0) - ISNULL(A.dblCargo,0), 
				CS.dblAbono10 = ISNULL(CS.dblAbono10,0) - ISNULL(A.dblAbono,0)	
			FROM tbCuentasSaldos CS
			INNER JOIN @Afec A ON A.intEmpresa = CS.intEmpresa AND CS.intEjercicio = A.intEjercicio  AND CS.strCuenta = A.strCuenta AND CS.strClasifDS = A.strClasifDS AND CS.strClasifDP = A.strClasifDP
			WHERE CS.intEmpresa = @intEmpresa
			AND CS.intEjercicio = @intEjercicio 

			UPDATE  CS
			SET dblCargo10 = 0
			FROM tbCuentasSaldos CS
			WHERE intEjercicio = @intEjercicio
			AND intEmpresa = @intEmpresa
			AND dblCargo10 < 0
			AND strCuenta IN(SELECT strCuenta FROM @Afec)

			UPDATE  CS
			SET dblAbono10 = 0
			FROM tbCuentasSaldos CS
			WHERE intEjercicio = @intEjercicio
			AND intEmpresa = @intEmpresa
			AND dblAbono10 < 0
			AND strCuenta IN(SELECT strCuenta FROM @Afec)
		END

		IF @intMes = 11      
		BEGIN
			UPDATE CS 
			SET CS.dblCargo11 = ISNULL(CS.dblCargo11,0) - ISNULL(A.dblCargo,0), 
				CS.dblAbono11 = ISNULL(CS.dblAbono11,0) - ISNULL(A.dblAbono,0)	
			FROM tbCuentasSaldos CS
			INNER JOIN @Afec A ON A.intEmpresa = CS.intEmpresa AND CS.intEjercicio = A.intEjercicio  AND CS.strCuenta = A.strCuenta AND CS.strClasifDS = A.strClasifDS AND CS.strClasifDP = A.strClasifDP
			WHERE CS.intEmpresa = @intEmpresa
			AND CS.intEjercicio = @intEjercicio 

			UPDATE  CS
			SET dblCargo11 = 0
			FROM tbCuentasSaldos CS
			WHERE intEjercicio = @intEjercicio
			AND intEmpresa = @intEmpresa
			AND dblCargo11 < 0
			AND strCuenta IN(SELECT strCuenta FROM @Afec)

			UPDATE  CS
			SET dblAbono11 = 0
			FROM tbCuentasSaldos CS
			WHERE intEjercicio = @intEjercicio
			AND intEmpresa = @intEmpresa
			AND dblAbono11 < 0
			AND strCuenta IN(SELECT strCuenta FROM @Afec)
		END
	     
		IF @intMes = 12      
		BEGIN
			UPDATE CS 
			SET CS.dblCargo12 = ISNULL(CS.dblCargo12,0) - ISNULL(A.dblCargo,0), 
				CS.dblAbono12 = ISNULL(CS.dblAbono12,0) - ISNULL(A.dblAbono,0)	
			FROM tbCuentasSaldos CS
			INNER JOIN @Afec A ON A.intEmpresa = CS.intEmpresa AND CS.intEjercicio = A.intEjercicio  AND CS.strCuenta = A.strCuenta AND CS.strClasifDS = A.strClasifDS AND CS.strClasifDP = A.strClasifDP
			WHERE CS.intEmpresa = @intEmpresa
			AND CS.intEjercicio = @intEjercicio 

			UPDATE  CS
			SET dblCargo12 = 0
			FROM tbCuentasSaldos CS
			WHERE intEjercicio = @intEjercicio
			AND intEmpresa = @intEmpresa
			AND dblCargo12 < 0
			AND strCuenta IN(SELECT strCuenta FROM @Afec)

			UPDATE  CS
			SET dblAbono12 = 0
			FROM tbCuentasSaldos CS
			WHERE intEjercicio = @intEjercicio
			AND intEmpresa = @intEmpresa
			AND dblAbono12 < 0
			AND strCuenta IN(SELECT strCuenta FROM @Afec)
		END	
		
		ALTER TABLE tbPolizasEnc DISABLE TRIGGER ALL        
		ALTER TABLE tbPolizasDet DISABLE TRIGGER ALL        
	             
		UPDATE PE 
		SET PE.intIndAfectada = 0 
		FROM tbPolizasEnc PE		
		WHERE PE.intEmpresa = @intEmpresa
		AND PE.intEjercicio = @intEjercicio 
		AND PE.intMes = @intMes 
		AND PE.intEstatus <> 9 
		AND PE.intIndAfectada = 1    	
		AND ((@strTipoPoliza = '0') OR(PE.strTipoPoliza BETWEEN @strTipoPoliza AND @strTipoFin))	
		AND ((@intFolioIni = 0) OR (PE.intFolioPoliza BETWEEN @intFolioIni AND @intFolioFin))
	                  
		UPDATE  PD 
		SET PD.intIndAfectada = 0    		  
		FROM tbPolizasDet PD
		INNER JOIN tbPolizasEnc PE ON PE.intEmpresa = PD.intEmpresa AND PE.intEjercicio = PD.intEjercicio AND PE.strPoliza = PD.strPoliza --AND PD.intFolioPoliza = PE.intFolioPoliza AND PD.strTipoPoliza = PE.strTipoPoliza
		WHERE PD.intEmpresa = @intEmpresa
		AND PD.intEjercicio = @intEjercicio 
		AND PD.intMes = @intMes	
		AND PE.intEstatus <> 9
		AND PD.intIndAfectada = 1   	
		AND ((@strTipoPoliza = '0') OR(PD.strTipoPoliza BETWEEN @strTipoPoliza AND @strTipoFin))
		AND ((@intFolioIni = 0) OR (PD.intFolioPoliza BETWEEN @intFolioIni AND @intFolioFin))
		             
		ALTER TABLE tbPolizasEnc ENABLE TRIGGER ALL        
		ALTER TABLE tbPolizasDet ENABLE TRIGGER ALL  
			
		DROP TABLE #TmpCuentasExistentes
		DROP TABLE #TmpCuentasPorCrear		
	END

	--Bitacora
	INSERT INTO tbPolizasAfectacion(intEmpresa,intEjercicio,intMes,strTipoIni,strTipoFin,intFolioIni,intFolioFin,
	intAfecta,strUsuario,strMaquina,datFecha)
	VALUES(@intEmpresa,@intEjercicio,@intMes,@strTipoPoliza,@strTipoFin,@intFolioIni,@intFolioFin,0,@strUsuario,
	@strMaquina,GETDATE())

	COMMIT

	END TRY
	BEGIN CATCH	
		IF @@TRANCOUNT > 0
		ROLLBACK

		DECLARE @ErrMsg nvarchar(4000), @ErrSeverity int
		SELECT @ErrMsg = ERROR_MESSAGE(),
			@ErrSeverity = ERROR_SEVERITY()

		RAISERROR(@ErrMsg, @ErrSeverity, 1)
	END CATCH
END
GO

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbPolizas_DesafectarTodo Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbPolizas_DesafectarTodo Error on Creation'
END
GO

