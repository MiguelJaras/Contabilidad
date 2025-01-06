
/****** Object:  StoredProcedure [dbo.usp_Tareas_Fill]    Script Date: 12/8/2009 10:45:19 AM ******/
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbPolizasEnc_AfectaPoliza')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbPolizasEnc_AfectaPoliza
	PRINT N'Drop Procedure : dbo.usp_tbPolizasEnc_AfectaPoliza - Succeeded !!!'
END
GO

------------------------------------------------------------------------------------
---   Aplicacion: Marfil.		                                                 ---
---        Autor: Rubén Mora Martínez                                            ---
---  Descripcion: Obtiene un registro de la tabla:  Tareas                       ---
---                                                                              ---
------------------------------------------------------------------------------------
---    Fecha     Autor  Comentario                                               ---
---  ----------  -----  -------------------------------------------------------  ---
---  12/11/2010  RMM    Create procedure                                         ---
------------------------------------------------------------------------------------

CREATE PROCEDURE dbo.usp_tbPolizasEnc_AfectaPoliza
(
	@intEmpresa			INT,
	@intEjercicio		int,
	@intMes				int,
	@strPoliza			varchar(20),
	@intIndAfectada		int
)
WITH ENCRYPTION 
AS
BEGIN
		
	SET NOCOUNT ON
	
	DECLARE @Rows int
	DECLARE @Count int
	DECLARE @strCuenta VARCHAR(50)
	DECLARE @strClasifDS VARCHAR(50)
	DECLARE @strClasifDP VARCHAR(50)
	DECLARE @Message VARCHAR(200)
	DECLARE @Date DATETIME

	DECLARE @ObraVar VARCHAR(50)
	DECLARE @CuentaVar VARCHAR(50)
	DECLARE @AuxVar VARCHAR(50)

	SET @Date = '01/' + CONVERT(VARCHAR,@intMes) + '/' + CONVERT(VARCHAR,@intEjercicio)

	IF EXISTS(SELECT 1 from VetecMarfil..tbCerrarPeriodo WHERE intEmpresa = @intEmpresa AND intEjercicio = @intEjercicio AND intMes = @intMes AND bCerrado = 1 AND intModulo = 1)
	BEGIN		
		SET @Message = 'El mes ' + DATENAME(month,@Date) + '. Esta cerrado.'
		RAISERROR(@Message,16,1)
		RETURN
	END

	CREATE TABLE #Poliza(id int identity(1,1), intEmpresa int, intEjercicio int, strPoliza varchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS, 
	strClasifDS varchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS, strClasifDP varchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS, 
	strCuenta varchar(100) COLLATE SQL_Latin1_General_CP1_CI_AS, dblCargos decimal(18,2), dblAbonos decimal(18,2), intCuenta INT)
		
	INSERT INTO #Poliza(intEmpresa,intEjercicio,strPoliza,strClasifDS,strClasifDP,strCuenta,dblCargos,dblAbonos)
	SELECT DISTINCT intEmpresa,intEjercicio,strPoliza,strClasifDS,ISNULL(strClasifDP,''),strCuenta, 
	SUM(CASE WHEN intTipoMovto = 1 THEN dblImporte ELSE 0 END), SUM(CASE WHEN intTipoMovto = 0 THEN dblImporte ELSE 0 END)
	FROM tbPolizasDet 
	WHERE intEmpresa = @intEmpresa AND intEjercicio = @intEjercicio
	AND strPoliza = @strPoliza --AND intTipoMovto = 1
	GROUP BY intEmpresa,intEjercicio,strPoliza,strClasifDS,strClasifDP,strCuenta

	BEGIN TRY
	BEGIN TRANSACTION   

	SELECT @Rows = COUNT(*) FROM #Poliza
	SET @Count = 0

	WHILE(@Rows > @Count)
	BEGIN
		SET @Count = @Count + 1

		SELECT @strCuenta = A.strCuenta FROM #Poliza A WHERE A.id = @Count

		IF(LEN(@strCuenta) = 12)
		BEGIN
			INSERT INTO #Poliza(intEmpresa,intEjercicio,strPoliza,strClasifDS,strClasifDP,strCuenta,dblCargos,dblAbonos)
			SELECT intEmpresa,intEjercicio,strPoliza,strClasifDS,strClasifDP,LEFT(strCuenta,8),dblCargos,dblAbonos
			FROM #Poliza A WHERE A.id = @Count
	
			INSERT INTO #Poliza(intEmpresa,intEjercicio,strPoliza,strClasifDS,strClasifDP,strCuenta,dblCargos,dblAbonos)
			SELECT intEmpresa,intEjercicio,strPoliza,strClasifDS,strClasifDP,LEFT(strCuenta,4),dblCargos,dblAbonos
			FROM #Poliza A WHERE A.id = @Count
		END

		IF(LEN(@strCuenta) = 8)
		BEGIN	
			INSERT INTO #Poliza(intEmpresa,intEjercicio,strPoliza,strClasifDS,strClasifDP,strCuenta,dblCargos,dblAbonos)
			SELECT intEmpresa,intEjercicio,strPoliza,strClasifDS,strClasifDP,LEFT(strCuenta,4),dblCargos,dblAbonos
			FROM #Poliza A WHERE A.id = @Count
		END

		SET @strCuenta = ''
	END

	IF(@intIndAfectada  = 1)
	BEGIN
		IF EXISTS(SELECT 1 FROM #Poliza WHERE ISNULL(strClasifDS,0) = 0)
		BEGIN
			SET @Message = 'No se puede afecta la poliza ' + @strPoliza + '. No tiene Obra'
			RAISERROR(@Message,16,1)
			RETURN
		END

		IF EXISTS(SELECT 1 FROM #Poliza P WHERE P.strCuenta NOT IN(SELECT strCuenta FROM tbCuentas C WHERE C.intEmpresa = @intEmpresa))
		BEGIN
			SELECT @CuentaVar = P.strCuenta
			FROM #Poliza P

			SET @Message = 'No se puede afecta la poliza ' + @strPoliza + '. Su Cuenta no Existe: ' + @CuentaVar
			RAISERROR(@Message,16,1)
			RETURN
		END	

		IF EXISTS(SELECT 1 FROM #Poliza P INNER JOIN VetecMarfil..tbObra O ON Convert(varchar,O.intObra) = ISNULL(P.strClasifDS,'0') AND O.intEmpresa <> @intEmpresa)
		BEGIN
			SELECT @ObraVar = ISNULL(P.strClasifDS,'0')
			FROM #Poliza P

			SET @Message = 'No se puede afecta la poliza ' + @strPoliza + '. La Obra no pertenece a la empresa: ' + @ObraVar
			RAISERROR(@Message,16,1)
			RETURN
		END

		IF NOT EXISTS(SELECT 1 FROM #Poliza P INNER JOIN VetecMarfil..tbObra O ON Convert(varchar,O.intObra) = ISNULL(P.strClasifDS,'0'))
		BEGIN
			SELECT @ObraVar = ISNULL(P.strClasifDS,'0')
			FROM #Poliza P

			SET @Message = 'No se puede afecta la poliza ' + @strPoliza + '. La Obra es incorrecta: ' + @ObraVar
			RAISERROR(@Message,16,1)
			RETURN
		END

		IF EXISTS(SELECT 1 FROM tbPolizasEnc PE INNER JOIN tbPolizasDet PD ON PE.strPoliza = PD.strPoliza AND PE.intMes = PD.intMes AND PE.intEjercicio = PD.intEjercicio AND PE.intEmpresa = PD.intEmpresa LEFT JOIN VetecMarfil.dbo.tbObra O ON O.intEmpresa = PD.intEmpresa AND O.intObra = CONVERT(INT, PD.strClasifDS) WHERE PE.intEmpresa = @intEmpresa AND PE.intMes = @intMes	AND PE.intEjercicio = @intEjercicio AND PD.strPoliza = @strPoliza AND PE.intEstatus <> 9 AND ((PD.strClasifDS = '0') OR (PD.strClasifDS IS NULL) OR (PD.strClasifDS = '') OR (O.intObra IS NULL)) )
		BEGIN
			SELECT @ObraVar = ISNULL(P.strClasifDS,'0')
			FROM #Poliza P

			SET @Message = 'No se puede afecta la poliza ' + @strPoliza + '. La Obra no existe: ' + @ObraVar
			RAISERROR(@Message,16,1)
			RETURN
		END

		UPDATE PE
		SET PE.intCuenta = 0
		FROM #Poliza PE
		INNER JOIN tbPolizasDet PD ON PE.strPoliza = PD.strPoliza AND PE.intMes = PD.intMes AND PE.intEjercicio = PD.intEjercicio AND PE.intEmpresa = PD.intEmpresa
		LEFT JOIN tbCuentas C ON C.strCuenta = PD.strCuenta ANd C.intEmpresa = PD.intEmpresa
		WHERE C.intCtaRegistro = 0

		IF EXISTS(SELECT 1 FROM #Poliza WHERE intCuenta = 0)
		BEGIN
			SET @Message = 'No se puede afecta la poliza ' + @strPoliza + '. Contiene cuentas que no son de ultimo nivel.'
			RAISERROR(@Message,16,1)
			RETURN
		END

		UPDATE PE
		SET PE.intCuenta = 0
		FROM #Poliza PE
		INNER JOIN tbPolizasDet PD ON PE.strPoliza = PD.strPoliza AND PE.intMes = PD.intMes AND PE.intEjercicio = PD.intEjercicio AND PE.intEmpresa = PD.intEmpresa
		LEFT JOIN tbCuentas C ON C.strCuenta = PD.strCuenta ANd C.intEmpresa = PD.intEmpresa
		WHERE C.intIndAuxiliar = 1
		AND isnull(PD.strClasifDP,0) = 0

		IF EXISTS(SELECT 1 FROM #Poliza WHERE intCuenta = 0)
		BEGIN
			SET @Message = 'No se puede afecta la poliza ' + @strPoliza + '. No tiene Auxiliar'
			RAISERROR(@Message,16,1)
			RETURN
		END	

	END

	SELECT @Rows = COUNT(*) FROM #Poliza
	SET @Count = 0

	WHILE @Rows > @Count
	BEGIN		
		SET @Count = @Count + 1

		SELECT @strCuenta = strCuenta, @strClasifDS = A.strClasifDS, @strClasifDP = strClasifDP 
		FROM #Poliza A
		WHERE A.id = @Count
		
		IF NOT EXISTS(SELECT 1 FROM tbCuentasSaldos WHERE intEmpresa = @intEmpresa AND intEjercicio = @intEjercicio AND strCuenta = @strCuenta AND strClasifDS = @strClasifDS AND strClasifDP = @strClasifDP)
		BEGIN
			INSERT INTO tbCuentasSaldos      
			([intEmpresa], [intEjercicio], [strCuenta], [strClasifEnc], [strClasifDP],       
			[strClasifDS], [intIndInterEmpresa], [intTipoMoneda], [dblSaldoInicial],       
			[dblCargo01], [dblAbono01], [dblCargo02], [dblAbono02], [dblCargo03], [dblAbono03],       
			[dblCargo04], [dblAbono04], [dblCargo05], [dblAbono05], [dblCargo06], [dblAbono06],       
			[dblCargo07], [dblAbono07], [dblCargo08], [dblAbono08], [dblCargo09], [dblAbono09],       
			[dblCargo10], [dblAbono10], [dblCargo11], [dblAbono11], [dblCargo12], [dblAbono12],       
			[datFechaAlta], [strUsuarioAlta], [strMaquinaAlta], [datFechaMod], [strUsuarioMod], [strMaquinaMod])       
			SELECT DISTINCT A.intEmpresa, A.intEjercicio, A.strCuenta, '0', CASE WHEN ISNULL(A.strClasifDP,'0') = '0' THEN '' ELSE A.strClasifDP END,       
			A.strClasifDS, 0, 1, 0, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,      
			Null, Null, Null, Null, Null, Null      
			FROM #Poliza A 
			WHERE intEmpresa = @intEmpresa AND intEjercicio = @intEjercicio AND strCuenta = @strCuenta 
			AND strClasifDS = @strClasifDS AND strClasifDP = @strClasifDP
		END
	END	
	
	IF(@intIndAfectada = 1)
	BEGIN		
		IF @intMes = 1 
		BEGIN
			UPDATE CS 
			SET CS.dblCargo01 = ISNULL(CS.dblCargo01,0) + ISNULL((SELECT SUM(P.dblCargos) FROM #Poliza P WHERE CS.intEmpresa = P.intEmpresa AND CS.intEjercicio = P.intEjercicio AND CS.strCuenta = P.strCuenta AND CS.strClasifDS = P.strClasifDS AND CS.strClasifDP = P.strClasifDP),0), 
				CS.dblAbono01 = ISNULL(CS.dblAbono01,0) + ISNULL((SELECT SUM(P.dblAbonos) FROM #Poliza P WHERE CS.intEmpresa = P.intEmpresa AND CS.intEjercicio = P.intEjercicio AND CS.strCuenta = P.strCuenta AND CS.strClasifDS = P.strClasifDS AND CS.strClasifDP = P.strClasifDP),0)	
			FROM tbCuentasSaldos CS
			INNER JOIN #Poliza P ON CS.intEmpresa = P.intEmpresa AND CS.intEjercicio = P.intEjercicio AND CS.strCuenta = P.strCuenta AND CS.strClasifDS = P.strClasifDS AND CS.strClasifDP = P.strClasifDP 
		END
		IF @intMes = 2 
		BEGIN
			UPDATE CS 
			SET CS.dblCargo02 = ISNULL(CS.dblCargo02,0) + ISNULL((SELECT SUM(P.dblCargos) FROM #Poliza P WHERE CS.intEmpresa = P.intEmpresa AND CS.intEjercicio = P.intEjercicio AND CS.strCuenta = P.strCuenta AND CS.strClasifDS = P.strClasifDS AND CS.strClasifDP = P.strClasifDP),0), 
				CS.dblAbono02 = ISNULL(CS.dblAbono02,0) + ISNULL((SELECT SUM(P.dblAbonos) FROM #Poliza P WHERE CS.intEmpresa = P.intEmpresa AND CS.intEjercicio = P.intEjercicio AND CS.strCuenta = P.strCuenta AND CS.strClasifDS = P.strClasifDS AND CS.strClasifDP = P.strClasifDP),0)	
			FROM tbCuentasSaldos CS 
			INNER JOIN #Poliza P ON CS.intEmpresa = P.intEmpresa AND CS.intEjercicio = P.intEjercicio AND CS.strCuenta = P.strCuenta AND CS.strClasifDS = P.strClasifDS AND CS.strClasifDP = P.strClasifDP  
		END
		IF @intMes = 3 
		BEGIN
			UPDATE CS 
			SET CS.dblCargo03 = ISNULL(CS.dblCargo03,0) + ISNULL((SELECT SUM(P.dblCargos) FROM #Poliza P WHERE CS.intEmpresa = P.intEmpresa AND CS.intEjercicio = P.intEjercicio AND CS.strCuenta = P.strCuenta AND CS.strClasifDS = P.strClasifDS AND CS.strClasifDP = P.strClasifDP),0), 
				CS.dblAbono03 = ISNULL(CS.dblAbono03,0) + ISNULL((SELECT SUM(P.dblAbonos) FROM #Poliza P WHERE CS.intEmpresa = P.intEmpresa AND CS.intEjercicio = P.intEjercicio AND CS.strCuenta = P.strCuenta AND CS.strClasifDS = P.strClasifDS AND CS.strClasifDP = P.strClasifDP),0)	
			FROM tbCuentasSaldos CS 
			INNER JOIN #Poliza P ON CS.intEmpresa = P.intEmpresa AND CS.intEjercicio = P.intEjercicio AND CS.strCuenta = P.strCuenta AND CS.strClasifDS = P.strClasifDS AND CS.strClasifDP = P.strClasifDP 
		END
		IF @intMes = 4 
		BEGIN
			UPDATE CS 
			SET CS.dblCargo04 = ISNULL(CS.dblCargo04,0) + ISNULL((SELECT SUM(P.dblCargos) FROM #Poliza P WHERE CS.intEmpresa = P.intEmpresa AND CS.intEjercicio = P.intEjercicio AND CS.strCuenta = P.strCuenta AND CS.strClasifDS = P.strClasifDS AND CS.strClasifDP = P.strClasifDP),0), 
				CS.dblAbono04 = ISNULL(CS.dblAbono04,0) + ISNULL((SELECT SUM(P.dblAbonos) FROM #Poliza P WHERE CS.intEmpresa = P.intEmpresa AND CS.intEjercicio = P.intEjercicio AND CS.strCuenta = P.strCuenta AND CS.strClasifDS = P.strClasifDS AND CS.strClasifDP = P.strClasifDP),0)	
			FROM tbCuentasSaldos CS
			INNER JOIN #Poliza P ON CS.intEmpresa = P.intEmpresa AND CS.intEjercicio = P.intEjercicio AND CS.strCuenta = P.strCuenta AND CS.strClasifDS = P.strClasifDS AND CS.strClasifDP = P.strClasifDP  
		END
		IF @intMes = 5 
		BEGIN
			UPDATE CS 
			SET CS.dblCargo05 = ISNULL(CS.dblCargo05,0) + ISNULL((SELECT SUM(P.dblCargos) FROM #Poliza P WHERE CS.intEmpresa = P.intEmpresa AND CS.intEjercicio = P.intEjercicio AND CS.strCuenta = P.strCuenta AND CS.strClasifDS = P.strClasifDS AND CS.strClasifDP = P.strClasifDP),0), 
				CS.dblAbono05 = ISNULL(CS.dblAbono05,0) + ISNULL((SELECT SUM(P.dblAbonos) FROM #Poliza P WHERE CS.intEmpresa = P.intEmpresa AND CS.intEjercicio = P.intEjercicio AND CS.strCuenta = P.strCuenta AND CS.strClasifDS = P.strClasifDS AND CS.strClasifDP = P.strClasifDP),0)	
			FROM tbCuentasSaldos CS 
			INNER JOIN #Poliza P ON CS.intEmpresa = P.intEmpresa AND CS.intEjercicio = P.intEjercicio AND CS.strCuenta = P.strCuenta AND CS.strClasifDS = P.strClasifDS AND CS.strClasifDP = P.strClasifDP 
		END
		IF @intMes = 6 
		BEGIN
			UPDATE CS 
			SET CS.dblCargo06 = ISNULL(CS.dblCargo06,0) + ISNULL((SELECT SUM(P.dblCargos) FROM #Poliza P WHERE CS.intEmpresa = P.intEmpresa AND CS.intEjercicio = P.intEjercicio AND CS.strCuenta = P.strCuenta AND CS.strClasifDS = P.strClasifDS AND CS.strClasifDP = P.strClasifDP),0), 
				CS.dblAbono06 = ISNULL(CS.dblAbono06,0) + ISNULL((SELECT SUM(P.dblAbonos) FROM #Poliza P WHERE CS.intEmpresa = P.intEmpresa AND CS.intEjercicio = P.intEjercicio AND CS.strCuenta = P.strCuenta AND CS.strClasifDS = P.strClasifDS AND CS.strClasifDP = P.strClasifDP),0)	
			FROM tbCuentasSaldos CS 
			INNER JOIN #Poliza P ON CS.intEmpresa = P.intEmpresa AND CS.intEjercicio = P.intEjercicio AND CS.strCuenta = P.strCuenta AND CS.strClasifDS = P.strClasifDS AND CS.strClasifDP = P.strClasifDP 
		END
		IF @intMes = 7
		BEGIN
			UPDATE CS 
			SET CS.dblCargo07 = ISNULL(CS.dblCargo07,0) + ISNULL((SELECT SUM(P.dblCargos) FROM #Poliza P WHERE CS.intEmpresa = P.intEmpresa AND CS.intEjercicio = P.intEjercicio AND CS.strCuenta = P.strCuenta AND CS.strClasifDS = P.strClasifDS AND CS.strClasifDP = P.strClasifDP),0), 
				CS.dblAbono07 = ISNULL(CS.dblAbono07,0) + ISNULL((SELECT SUM(P.dblAbonos) FROM #Poliza P WHERE CS.intEmpresa = P.intEmpresa AND CS.intEjercicio = P.intEjercicio AND CS.strCuenta = P.strCuenta AND CS.strClasifDS = P.strClasifDS AND CS.strClasifDP = P.strClasifDP),0)	
			FROM tbCuentasSaldos CS
			INNER JOIN #Poliza P ON CS.intEmpresa = P.intEmpresa AND CS.intEjercicio = P.intEjercicio AND CS.strCuenta = P.strCuenta AND CS.strClasifDS = P.strClasifDS AND CS.strClasifDP = P.strClasifDP  
		END
		IF @intMes = 8 
		BEGIN
			UPDATE CS 
			SET CS.dblCargo08 = ISNULL(CS.dblCargo08,0) + ISNULL((SELECT SUM(P.dblCargos) FROM #Poliza P WHERE CS.intEmpresa = P.intEmpresa AND CS.intEjercicio = P.intEjercicio AND CS.strCuenta = P.strCuenta AND CS.strClasifDS = P.strClasifDS AND CS.strClasifDP = P.strClasifDP),0), 
				CS.dblAbono08 = ISNULL(CS.dblAbono08,0) + ISNULL((SELECT SUM(P.dblAbonos) FROM #Poliza P WHERE CS.intEmpresa = P.intEmpresa AND CS.intEjercicio = P.intEjercicio AND CS.strCuenta = P.strCuenta AND CS.strClasifDS = P.strClasifDS AND CS.strClasifDP = P.strClasifDP),0)	
			FROM tbCuentasSaldos CS 
			INNER JOIN #Poliza P ON CS.intEmpresa = P.intEmpresa AND CS.intEjercicio = P.intEjercicio AND CS.strCuenta = P.strCuenta AND CS.strClasifDS = P.strClasifDS AND CS.strClasifDP = P.strClasifDP 
		END
		IF @intMes = 9 
		BEGIN
			UPDATE CS 
			SET CS.dblCargo09 = ISNULL(CS.dblCargo09,0) + ISNULL((SELECT SUM(P.dblCargos) FROM #Poliza P WHERE CS.intEmpresa = P.intEmpresa AND CS.intEjercicio = P.intEjercicio AND CS.strCuenta = P.strCuenta AND CS.strClasifDS = P.strClasifDS AND CS.strClasifDP = P.strClasifDP),0), 
				CS.dblAbono09 = ISNULL(CS.dblAbono09,0) + ISNULL((SELECT SUM(P.dblAbonos) FROM #Poliza P WHERE CS.intEmpresa = P.intEmpresa AND CS.intEjercicio = P.intEjercicio AND CS.strCuenta = P.strCuenta AND CS.strClasifDS = P.strClasifDS AND CS.strClasifDP = P.strClasifDP),0)	
			FROM tbCuentasSaldos CS 
			INNER JOIN #Poliza P ON CS.intEmpresa = P.intEmpresa AND CS.intEjercicio = P.intEjercicio AND CS.strCuenta = P.strCuenta AND CS.strClasifDS = P.strClasifDS AND CS.strClasifDP = P.strClasifDP 
		END
		IF @intMes = 10 
		BEGIN
			UPDATE CS 
			SET CS.dblCargo10 = ISNULL(CS.dblCargo10,0) + ISNULL((SELECT SUM(P.dblCargos) FROM #Poliza P WHERE CS.intEmpresa = P.intEmpresa AND CS.intEjercicio = P.intEjercicio AND CS.strCuenta = P.strCuenta AND CS.strClasifDS = P.strClasifDS AND CS.strClasifDP = P.strClasifDP),0), 
				CS.dblAbono10 = ISNULL(CS.dblAbono10,0) + ISNULL((SELECT SUM(P.dblAbonos) FROM #Poliza P WHERE CS.intEmpresa = P.intEmpresa AND CS.intEjercicio = P.intEjercicio AND CS.strCuenta = P.strCuenta AND CS.strClasifDS = P.strClasifDS AND CS.strClasifDP = P.strClasifDP),0)	
			FROM tbCuentasSaldos CS 
			INNER JOIN #Poliza P ON CS.intEmpresa = P.intEmpresa AND CS.intEjercicio = P.intEjercicio AND CS.strCuenta = P.strCuenta AND CS.strClasifDS = P.strClasifDS AND CS.strClasifDP = P.strClasifDP 
		END
		IF @intMes = 11 
		BEGIN
			UPDATE CS 
			SET CS.dblCargo11 = ISNULL(CS.dblCargo11,0) + ISNULL((SELECT SUM(P.dblCargos) FROM #Poliza P WHERE CS.intEmpresa = P.intEmpresa AND CS.intEjercicio = P.intEjercicio AND CS.strCuenta = P.strCuenta AND CS.strClasifDS = P.strClasifDS AND CS.strClasifDP = P.strClasifDP),0), 
				CS.dblAbono11 = ISNULL(CS.dblAbono11,0) + ISNULL((SELECT SUM(P.dblAbonos) FROM #Poliza P WHERE CS.intEmpresa = P.intEmpresa AND CS.intEjercicio = P.intEjercicio AND CS.strCuenta = P.strCuenta AND CS.strClasifDS = P.strClasifDS AND CS.strClasifDP = P.strClasifDP),0)	
			FROM tbCuentasSaldos CS 
			INNER JOIN #Poliza P ON CS.intEmpresa = P.intEmpresa AND CS.intEjercicio = P.intEjercicio AND CS.strCuenta = P.strCuenta AND CS.strClasifDS = P.strClasifDS AND CS.strClasifDP = P.strClasifDP 
		END
		IF @intMes = 12 
		BEGIN
			UPDATE CS 
			SET CS.dblCargo12 = ISNULL(CS.dblCargo12,0) + ISNULL((SELECT SUM(P.dblCargos) FROM #Poliza P WHERE CS.intEmpresa = P.intEmpresa AND CS.intEjercicio = P.intEjercicio AND CS.strCuenta = P.strCuenta AND CS.strClasifDS = P.strClasifDS AND CS.strClasifDP = P.strClasifDP),0), 
				CS.dblAbono12 = ISNULL(CS.dblAbono12,0) + ISNULL((SELECT SUM(P.dblAbonos) FROM #Poliza P WHERE CS.intEmpresa = P.intEmpresa AND CS.intEjercicio = P.intEjercicio AND CS.strCuenta = P.strCuenta AND CS.strClasifDS = P.strClasifDS AND CS.strClasifDP = P.strClasifDP),0)	
			FROM tbCuentasSaldos CS 
			INNER JOIN #Poliza P ON CS.intEmpresa = P.intEmpresa AND CS.intEjercicio = P.intEjercicio AND CS.strCuenta = P.strCuenta AND CS.strClasifDS = P.strClasifDS AND CS.strClasifDP = P.strClasifDP 
		END
	END
	ELSE
	BEGIN
		IF @intMes = 1 
		BEGIN
			UPDATE CS 
			SET CS.dblCargo01 = ISNULL(CS.dblCargo01,0) - ISNULL((SELECT SUM(P.dblCargos) FROM #Poliza P WHERE CS.intEmpresa = P.intEmpresa AND CS.intEjercicio = P.intEjercicio AND CS.strCuenta = P.strCuenta AND CS.strClasifDS = P.strClasifDS AND CS.strClasifDP = P.strClasifDP),0), 
				CS.dblAbono01 = ISNULL(CS.dblAbono01,0) - ISNULL((SELECT SUM(P.dblAbonos) FROM #Poliza P WHERE CS.intEmpresa = P.intEmpresa AND CS.intEjercicio = P.intEjercicio AND CS.strCuenta = P.strCuenta AND CS.strClasifDS = P.strClasifDS AND CS.strClasifDP = P.strClasifDP),0)	
			FROM tbCuentasSaldos CS 
			INNER JOIN #Poliza P ON CS.intEmpresa = P.intEmpresa AND CS.intEjercicio = P.intEjercicio AND CS.strCuenta = P.strCuenta AND CS.strClasifDS = P.strClasifDS AND CS.strClasifDP = P.strClasifDP 

			UPDATE  CS
			SET dblCargo01 = 0
			FROM tbCuentasSaldos CS
			WHERE intEjercicio = @intEjercicio
			AND intEmpresa = @intEmpresa
			AND dblCargo01 < 0
			AND strCuenta IN(SELECT strCuenta FROM #Poliza)

			UPDATE  CS
			SET dblAbono01 = 0
			FROM tbCuentasSaldos CS
			WHERE intEjercicio = @intEjercicio
			AND intEmpresa = @intEmpresa
			AND dblAbono01 < 0
			AND strCuenta IN(SELECT strCuenta FROM #Poliza)
		END
		IF @intMes = 2 
		BEGIN
			UPDATE CS 
			SET CS.dblCargo02 = ISNULL(CS.dblCargo02,0) - ISNULL((SELECT SUM(P.dblCargos) FROM #Poliza P WHERE CS.intEmpresa = P.intEmpresa AND CS.intEjercicio = P.intEjercicio AND CS.strCuenta = P.strCuenta AND CS.strClasifDS = P.strClasifDS AND CS.strClasifDP = P.strClasifDP),0), 
				CS.dblAbono02 = ISNULL(CS.dblAbono02,0) - ISNULL((SELECT SUM(P.dblAbonos) FROM #Poliza P WHERE CS.intEmpresa = P.intEmpresa AND CS.intEjercicio = P.intEjercicio AND CS.strCuenta = P.strCuenta AND CS.strClasifDS = P.strClasifDS AND CS.strClasifDP = P.strClasifDP),0)	
			FROM tbCuentasSaldos CS 
			INNER JOIN #Poliza P ON CS.intEmpresa = P.intEmpresa AND CS.intEjercicio = P.intEjercicio AND CS.strCuenta = P.strCuenta AND CS.strClasifDS = P.strClasifDS AND CS.strClasifDP = P.strClasifDP 

			UPDATE  CS
			SET dblCargo02 = 0
			FROM tbCuentasSaldos CS
			WHERE intEjercicio = @intEjercicio
			AND intEmpresa = @intEmpresa
			AND dblCargo02 < 0	
			AND strCuenta IN(SELECT strCuenta FROM #Poliza)
	
			UPDATE  CS
			SET dblAbono02 = 0
			FROM tbCuentasSaldos CS
			WHERE intEjercicio = @intEjercicio
			AND intEmpresa = @intEmpresa
			AND dblAbono02 < 0
			AND strCuenta IN(SELECT strCuenta FROM #Poliza)
		END
		IF @intMes = 3 
		BEGIN
			UPDATE CS 
			SET CS.dblCargo03 = ISNULL(CS.dblCargo03,0) - ISNULL((SELECT SUM(P.dblCargos) FROM #Poliza P WHERE CS.intEmpresa = P.intEmpresa AND CS.intEjercicio = P.intEjercicio AND CS.strCuenta = P.strCuenta AND CS.strClasifDS = P.strClasifDS AND CS.strClasifDP = P.strClasifDP),0),  
				CS.dblAbono03 = ISNULL(CS.dblAbono03,0) - ISNULL((SELECT SUM(P.dblAbonos) FROM #Poliza P WHERE CS.intEmpresa = P.intEmpresa AND CS.intEjercicio = P.intEjercicio AND CS.strCuenta = P.strCuenta AND CS.strClasifDS = P.strClasifDS AND CS.strClasifDP = P.strClasifDP),0)	
			FROM tbCuentasSaldos CS
			INNER JOIN #Poliza P ON CS.intEmpresa = P.intEmpresa AND CS.intEjercicio = P.intEjercicio AND CS.strCuenta = P.strCuenta AND CS.strClasifDS = P.strClasifDS AND CS.strClasifDP = P.strClasifDP 

			UPDATE  CS
			SET dblCargo03 = 0
			FROM tbCuentasSaldos CS
			WHERE intEjercicio = @intEjercicio
			AND intEmpresa = @intEmpresa
			AND dblCargo03 < 0
			AND strCuenta IN(SELECT strCuenta FROM #Poliza)

			UPDATE  CS
			SET dblAbono03 = 0
			FROM tbCuentasSaldos CS
			WHERE intEjercicio = @intEjercicio
			AND intEmpresa = @intEmpresa
			AND dblAbono03 < 0
			AND strCuenta IN(SELECT strCuenta FROM #Poliza)
		END
		IF @intMes = 4 
		BEGIN
			UPDATE CS 
			SET CS.dblCargo04 = ISNULL(CS.dblCargo04,0) - ISNULL((SELECT SUM(P.dblCargos) FROM #Poliza P WHERE CS.intEmpresa = P.intEmpresa AND CS.intEjercicio = P.intEjercicio AND CS.strCuenta = P.strCuenta AND CS.strClasifDS = P.strClasifDS AND CS.strClasifDP = P.strClasifDP),0), 
				CS.dblAbono04 = ISNULL(CS.dblAbono04,0) - ISNULL((SELECT SUM(P.dblAbonos) FROM #Poliza P WHERE CS.intEmpresa = P.intEmpresa AND CS.intEjercicio = P.intEjercicio AND CS.strCuenta = P.strCuenta AND CS.strClasifDS = P.strClasifDS AND CS.strClasifDP = P.strClasifDP),0)	
			FROM tbCuentasSaldos CS
			INNER JOIN #Poliza P ON CS.intEmpresa = P.intEmpresa AND CS.intEjercicio = P.intEjercicio AND CS.strCuenta = P.strCuenta AND CS.strClasifDS = P.strClasifDS AND CS.strClasifDP = P.strClasifDP  

			UPDATE  CS
			SET dblCargo04 = 0
			FROM tbCuentasSaldos CS
			WHERE intEjercicio = @intEjercicio
			AND intEmpresa = @intEmpresa
			AND dblCargo04 < 0
			AND strCuenta IN(SELECT strCuenta FROM #Poliza)

			UPDATE  CS
			SET dblAbono04 = 0
			FROM tbCuentasSaldos CS
			WHERE intEjercicio = @intEjercicio	
			AND intEmpresa = @intEmpresa
			AND dblAbono04 < 0
			AND strCuenta IN(SELECT strCuenta FROM #Poliza)
		END
		IF @intMes = 5 
		BEGIN
			UPDATE CS 
			SET CS.dblCargo05 = ISNULL(CS.dblCargo05,0) - ISNULL((SELECT SUM(P.dblCargos) FROM #Poliza P WHERE CS.intEmpresa = P.intEmpresa AND CS.intEjercicio = P.intEjercicio AND CS.strCuenta = P.strCuenta AND CS.strClasifDS = P.strClasifDS AND CS.strClasifDP = P.strClasifDP),0), 
				CS.dblAbono05 = ISNULL(CS.dblAbono05,0) - ISNULL((SELECT SUM(P.dblAbonos) FROM #Poliza P WHERE CS.intEmpresa = P.intEmpresa AND CS.intEjercicio = P.intEjercicio AND CS.strCuenta = P.strCuenta AND CS.strClasifDS = P.strClasifDS AND CS.strClasifDP = P.strClasifDP),0)	
			FROM tbCuentasSaldos CS 
			INNER JOIN #Poliza P ON CS.intEmpresa = P.intEmpresa AND CS.intEjercicio = P.intEjercicio AND CS.strCuenta = P.strCuenta AND CS.strClasifDS = P.strClasifDS AND CS.strClasifDP = P.strClasifDP 

			UPDATE  CS
			SET dblCargo05 = 0
			FROM tbCuentasSaldos CS
			WHERE intEjercicio = @intEjercicio
			AND intEmpresa = @intEmpresa
			AND dblCargo05 < 0
			AND strCuenta IN(SELECT strCuenta FROM #Poliza)

			UPDATE  CS
			SET dblAbono05 = 0
			FROM tbCuentasSaldos CS
			WHERE intEjercicio = @intEjercicio
			AND intEmpresa = @intEmpresa
			AND dblAbono05 < 0
			AND strCuenta IN(SELECT strCuenta FROM #Poliza)
		END
		IF @intMes = 6 
		BEGIN
			UPDATE CS 
			SET CS.dblCargo06 = ISNULL(CS.dblCargo06,0) - ISNULL((SELECT SUM(P.dblCargos) FROM #Poliza P WHERE CS.intEmpresa = P.intEmpresa AND CS.intEjercicio = P.intEjercicio AND CS.strCuenta = P.strCuenta AND CS.strClasifDS = P.strClasifDS AND CS.strClasifDP = P.strClasifDP),0), 
				CS.dblAbono06 = ISNULL(CS.dblAbono06,0) - ISNULL((SELECT SUM(P.dblAbonos) FROM #Poliza P WHERE CS.intEmpresa = P.intEmpresa AND CS.intEjercicio = P.intEjercicio AND CS.strCuenta = P.strCuenta AND CS.strClasifDS = P.strClasifDS AND CS.strClasifDP = P.strClasifDP),0)	
			FROM tbCuentasSaldos CS 
			INNER JOIN #Poliza P ON CS.intEmpresa = P.intEmpresa AND CS.intEjercicio = P.intEjercicio AND CS.strCuenta = P.strCuenta AND CS.strClasifDS = P.strClasifDS AND CS.strClasifDP = P.strClasifDP 

			UPDATE  CS
			SET dblCargo06 = 0
			FROM tbCuentasSaldos CS
			WHERE intEjercicio = @intEjercicio
			AND intEmpresa = @intEmpresa
			AND dblCargo06 < 0
			AND strCuenta IN(SELECT strCuenta FROM #Poliza)

			UPDATE  CS
			SET dblAbono06 = 0
			FROM tbCuentasSaldos CS
			WHERE intEjercicio = @intEjercicio
			AND intEmpresa = @intEmpresa
			AND dblAbono06 < 0
			AND strCuenta IN(SELECT strCuenta FROM #Poliza)
		END
		IF @intMes = 7
		BEGIN
			UPDATE CS 
			SET CS.dblCargo07 = ISNULL(CS.dblCargo07,0) - ISNULL((SELECT SUM(P.dblCargos) FROM #Poliza P WHERE CS.intEmpresa = P.intEmpresa AND CS.intEjercicio = P.intEjercicio AND CS.strCuenta = P.strCuenta AND CS.strClasifDS = P.strClasifDS AND CS.strClasifDP = P.strClasifDP),0), 
				CS.dblAbono07 = ISNULL(CS.dblAbono07,0) - ISNULL((SELECT SUM(P.dblAbonos) FROM #Poliza P WHERE CS.intEmpresa = P.intEmpresa AND CS.intEjercicio = P.intEjercicio AND CS.strCuenta = P.strCuenta AND CS.strClasifDS = P.strClasifDS AND CS.strClasifDP = P.strClasifDP),0)	
			FROM tbCuentasSaldos CS
			INNER JOIN #Poliza P ON CS.intEmpresa = P.intEmpresa AND CS.intEjercicio = P.intEjercicio AND CS.strCuenta = P.strCuenta AND CS.strClasifDS = P.strClasifDS AND CS.strClasifDP = P.strClasifDP  

			UPDATE  CS
			SET dblCargo07 = 0
			FROM tbCuentasSaldos CS
			WHERE intEjercicio = @intEjercicio
			AND intEmpresa = @intEmpresa
			AND dblCargo07 < 0
			AND strCuenta IN(SELECT strCuenta FROM #Poliza)

			UPDATE  CS
			SET dblAbono07 = 0
			FROM tbCuentasSaldos CS
			WHERE intEjercicio = @intEjercicio
			AND intEmpresa = @intEmpresa
			AND dblAbono07 < 0
			AND strCuenta IN(SELECT strCuenta FROM #Poliza)
		END
		IF @intMes = 8 
		BEGIN
			UPDATE CS 
			SET CS.dblCargo08 = ISNULL(CS.dblCargo08,0) - ISNULL((SELECT SUM(P.dblCargos) FROM #Poliza P WHERE CS.intEmpresa = P.intEmpresa AND CS.intEjercicio = P.intEjercicio AND CS.strCuenta = P.strCuenta AND CS.strClasifDS = P.strClasifDS AND CS.strClasifDP = P.strClasifDP),0), 
				CS.dblAbono08 = ISNULL(CS.dblAbono08,0) - ISNULL((SELECT SUM(P.dblAbonos) FROM #Poliza P WHERE CS.intEmpresa = P.intEmpresa AND CS.intEjercicio = P.intEjercicio AND CS.strCuenta = P.strCuenta AND CS.strClasifDS = P.strClasifDS AND CS.strClasifDP = P.strClasifDP),0)	
			FROM tbCuentasSaldos CS 
			INNER JOIN #Poliza P ON CS.intEmpresa = P.intEmpresa AND CS.intEjercicio = P.intEjercicio AND CS.strCuenta = P.strCuenta AND CS.strClasifDS = P.strClasifDS AND CS.strClasifDP = P.strClasifDP 

			UPDATE  CS
			SET dblCargo08 = 0
			FROM tbCuentasSaldos CS
			WHERE intEjercicio = @intEjercicio
			AND intEmpresa = @intEmpresa
			AND dblCargo08 < 0
			AND strCuenta IN(SELECT strCuenta FROM #Poliza)

			UPDATE  CS
			SET dblAbono08 = 0
			FROM tbCuentasSaldos CS
			WHERE intEjercicio = @intEjercicio
			AND intEmpresa = @intEmpresa
			AND dblAbono08 < 0
			AND strCuenta IN(SELECT strCuenta FROM #Poliza)
		END
		IF @intMes = 9 
		BEGIN
			UPDATE CS 
			SET CS.dblCargo09 = ISNULL(CS.dblCargo09,0) - ISNULL((SELECT SUM(P.dblCargos) FROM #Poliza P WHERE CS.intEmpresa = P.intEmpresa AND CS.intEjercicio = P.intEjercicio AND CS.strCuenta = P.strCuenta AND CS.strClasifDS = P.strClasifDS AND CS.strClasifDP = P.strClasifDP),0), 
				CS.dblAbono09 = ISNULL(CS.dblAbono09,0) - ISNULL((SELECT SUM(P.dblAbonos) FROM #Poliza P WHERE CS.intEmpresa = P.intEmpresa AND CS.intEjercicio = P.intEjercicio AND CS.strCuenta = P.strCuenta AND CS.strClasifDS = P.strClasifDS AND CS.strClasifDP = P.strClasifDP),0)	
			FROM tbCuentasSaldos CS 
			INNER JOIN #Poliza P ON CS.intEmpresa = P.intEmpresa AND CS.intEjercicio = P.intEjercicio AND CS.strCuenta = P.strCuenta AND CS.strClasifDS = P.strClasifDS AND CS.strClasifDP = P.strClasifDP 

			UPDATE  CS
			SET dblCargo09 = 0
			FROM tbCuentasSaldos CS
			WHERE intEjercicio = @intEjercicio
			AND intEmpresa = @intEmpresa
			AND dblCargo09 < 0	
			AND strCuenta IN(SELECT strCuenta FROM #Poliza)
		

			UPDATE  CS
			SET dblAbono09 = 0
			FROM tbCuentasSaldos CS
			WHERE intEjercicio = @intEjercicio
			AND intEmpresa = @intEmpresa
			AND dblAbono09 < 0
			AND strCuenta IN(SELECT strCuenta FROM #Poliza)
		END
		IF @intMes = 10 
		BEGIN
			UPDATE CS 
			SET CS.dblCargo10 = ISNULL(CS.dblCargo10,0) - ISNULL((SELECT SUM(P.dblCargos) FROM #Poliza P WHERE CS.intEmpresa = P.intEmpresa AND CS.intEjercicio = P.intEjercicio AND CS.strCuenta = P.strCuenta AND CS.strClasifDS = P.strClasifDS AND CS.strClasifDP = P.strClasifDP),0), 
				CS.dblAbono10 = ISNULL(CS.dblAbono10,0) - ISNULL((SELECT SUM(P.dblAbonos) FROM #Poliza P WHERE CS.intEmpresa = P.intEmpresa AND CS.intEjercicio = P.intEjercicio AND CS.strCuenta = P.strCuenta AND CS.strClasifDS = P.strClasifDS AND CS.strClasifDP = P.strClasifDP),0)	
			FROM tbCuentasSaldos CS 
			INNER JOIN #Poliza P ON CS.intEmpresa = P.intEmpresa AND CS.intEjercicio = P.intEjercicio AND CS.strCuenta = P.strCuenta AND CS.strClasifDS = P.strClasifDS AND CS.strClasifDP = P.strClasifDP 			

			UPDATE  CS
			SET dblCargo10 = 0
			FROM tbCuentasSaldos CS
			WHERE intEjercicio = @intEjercicio
			AND intEmpresa = @intEmpresa
			AND dblCargo10 < 0
			AND strCuenta IN(SELECT strCuenta FROM #Poliza)

			UPDATE  CS
			SET dblAbono10 = 0
			FROM tbCuentasSaldos CS
			WHERE intEjercicio = @intEjercicio
			AND intEmpresa = @intEmpresa
			AND dblAbono10 < 0
			AND strCuenta IN(SELECT strCuenta FROM #Poliza)
		END
		IF @intMes = 11 
		BEGIN
			UPDATE CS 
			SET CS.dblCargo11 = ISNULL(CS.dblCargo11,0) - ISNULL((SELECT SUM(P.dblCargos) FROM #Poliza P WHERE CS.intEmpresa = P.intEmpresa AND CS.intEjercicio = P.intEjercicio AND CS.strCuenta = P.strCuenta AND CS.strClasifDS = P.strClasifDS AND CS.strClasifDP = P.strClasifDP),0), 
				CS.dblAbono11 = ISNULL(CS.dblAbono11,0) - ISNULL((SELECT SUM(P.dblAbonos) FROM #Poliza P WHERE CS.intEmpresa = P.intEmpresa AND CS.intEjercicio = P.intEjercicio AND CS.strCuenta = P.strCuenta AND CS.strClasifDS = P.strClasifDS AND CS.strClasifDP = P.strClasifDP),0)	
			FROM tbCuentasSaldos CS 
			INNER JOIN #Poliza P ON CS.intEmpresa = P.intEmpresa AND CS.intEjercicio = P.intEjercicio AND CS.strCuenta = P.strCuenta AND CS.strClasifDS = P.strClasifDS AND CS.strClasifDP = P.strClasifDP 

			UPDATE  CS
			SET dblCargo11 = 0
			FROM tbCuentasSaldos CS
			WHERE intEjercicio = @intEjercicio
			AND intEmpresa = @intEmpresa
			AND dblCargo11 < 0
			AND strCuenta IN(SELECT strCuenta FROM #Poliza)

			UPDATE  CS
			SET dblAbono11 = 0
			FROM tbCuentasSaldos CS
			WHERE intEjercicio = @intEjercicio
			AND intEmpresa = @intEmpresa
			AND dblAbono11 < 0
			AND strCuenta IN(SELECT strCuenta FROM #Poliza)
		END
		IF @intMes = 12 
		BEGIN
			UPDATE CS 
			SET CS.dblCargo12 = ISNULL(CS.dblCargo12,0) - ISNULL((SELECT SUM(P.dblCargos) FROM #Poliza P WHERE CS.intEmpresa = P.intEmpresa AND CS.intEjercicio = P.intEjercicio AND CS.strCuenta = P.strCuenta AND CS.strClasifDS = P.strClasifDS AND CS.strClasifDP = P.strClasifDP),0), 
				CS.dblAbono12 = ISNULL(CS.dblAbono12,0) - ISNULL((SELECT SUM(P.dblAbonos) FROM #Poliza P WHERE CS.intEmpresa = P.intEmpresa AND CS.intEjercicio = P.intEjercicio AND CS.strCuenta = P.strCuenta AND CS.strClasifDS = P.strClasifDS AND CS.strClasifDP = P.strClasifDP),0)	
			FROM tbCuentasSaldos CS 
			INNER JOIN #Poliza P ON CS.intEmpresa = P.intEmpresa AND CS.intEjercicio = P.intEjercicio AND CS.strCuenta = P.strCuenta AND CS.strClasifDS = P.strClasifDS AND ISNULL(CS.strClasifDP,'') = P.strClasifDP 

			UPDATE  CS
			SET dblCargo12 = 0
			FROM tbCuentasSaldos CS
			WHERE intEjercicio = @intEjercicio
			AND intEmpresa = @intEmpresa
			AND dblCargo12 < 0
			AND strCuenta IN(SELECT strCuenta FROM #Poliza)

			UPDATE  CS
			SET dblAbono12 = 0
			FROM tbCuentasSaldos CS
			WHERE intEjercicio = @intEjercicio
			AND intEmpresa = @intEmpresa
			AND dblAbono12 < 0
			AND strCuenta IN(SELECT strCuenta FROM #Poliza)
		END
	END	

	ALTER TABLE tbPolizasEnc DISABLE TRIGGER ALL        
	ALTER TABLE tbPolizasDet DISABLE TRIGGER ALL        
             
	UPDATE PE 
	SET PE.intIndAfectada = @intIndAfectada 
	FROM tbPolizasEnc PE		
	WHERE PE.intEmpresa = @intEmpresa
	AND PE.intEjercicio = @intEjercicio 
	AND PE.intMes = @intMes 
	AND PE.intEstatus <> 9   	
	AND PE.strPoliza = 	@strPoliza
                  
	UPDATE PD 
	SET PD.intIndAfectada = @intIndAfectada    
	FROM tbPolizasDet PD
	INNER JOIN tbPolizasEnc PE ON PE.intEmpresa = PD.intEmpresa AND PE.intEjercicio = PD.intEjercicio AND PE.strPoliza = PD.strPoliza AND PD.intFolioPoliza = PE.intFolioPoliza AND PD.strTipoPoliza = PE.strTipoPoliza		  
	WHERE PD.intEmpresa = @intEmpresa
	AND PD.intEjercicio = @intEjercicio 
	AND PD.intMes = @intMes
	AND PE.intEstatus <> 9 
	AND PE.strPoliza = 	@strPoliza
		             
    ALTER TABLE tbPolizasEnc ENABLE TRIGGER ALL        
    ALTER TABLE tbPolizasDet ENABLE TRIGGER ALL
	
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


	SELECT @strPoliza 

	DROP TABLE #Poliza

	SET NOCOUNT OFF
	
END
GO

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbPolizasEnc_AfectaPoliza Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbPolizasEnc_AfectaPoliza Error on Creation'
END
GO

