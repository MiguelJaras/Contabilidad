
use VetecMarfilAdmin

/****** Object:  StoredProcedure dbo.usp_Tareas_Fill    Script Date: 12/8/2009 10:45:19 AM ******/
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbPolizas_AfectaPoliza')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbPolizas_AfectaPoliza
	PRINT N'Drop Procedure : dbo.usp_tbPolizas_AfectaPoliza - Succeeded !!!'
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


CREATE  PROCEDURE dbo.usp_tbPolizas_AfectaPoliza
(      
    @intEmpresa		int, 
	@intEjercicio	int,
	@intMes			int, 
	@strTipoPoliza	VarChar(60), 
	@strTipoFin		VarChar(60),
	@intFolioIni	int, 
	@intFolioFin	int,
	@intAfecta		int,
	@strUsuario		varchar(50),
	@strMaquina		varchar(50)
)      
AS 
BEGIN   
    DECLARE @RowsCount int
	DECLARE @Rows int
	DECLARE @Count int
	DECLARE @strTipo VarChar(60)
	DECLARE @strMsg VarChar(200)
	DECLARE @strPoliza VarChar(10)
	DECLARE @UnoxUno int

	DECLARE @Polizas Table (intEmpresa Int, intEjercicio Int, intMes int, strPoliza VARCHAR(20), intPartida int, strCuenta varchar(20),
	strClasifDP varchar(50),strClasifDS varchar(60),intTipoMoneda Int,dblCargo Decimal(16,2), dblAbono Decimal(16,2),
	intIndAuxiliar int,intCtaRegistro INT,intNivel int, intObra int)  

	DECLARE @Afec Table (intRegistro INT IDENTITY (1,1),intEmpresa Int,intEjercicio Int,strCuenta varchar(50),
	strClasifDP  varchar(50),strClasifDS varchar(60),dblCargo Money,dblAbono Money) 

	DECLARE @PolizasEnc TABLE(intEmpresa int,intEjercicio int, intMes int, strPoliza varchar(20))
	DECLARE @Obra TABLE(intObra varchar(10))
	DECLARE @ObraPoliza TABLE(intObra varchar(10))
	DECLARE @PolizaSNObra TABLE(strPoliza varchar(20))

	DECLARE @Dia INT	
	SET @Dia = DATEPART(WEEKDAY,GETDATE())

	BEGIN TRANSACTION usp_tbPolizas_Afecta
	BEGIN TRY
		--Encabezados
		INSERT INTO @PolizasEnc(intEmpresa,intEjercicio,intMes,strPoliza)
		SELECT intEmpresa,intEjercicio,intMes,strPoliza
		FROM tbPolizasEnc
		WHERE intEmpresa = @intEmpresa
		AND intMes = @intMes
		AND intEjercicio = @intEjercicio			
		AND intEstatus <> 9
		AND dblCargos = dblAbonos	
		AND dblCargos <> 0
		AND ((@strTipoPoliza = '0') OR(strTipoPoliza BETWEEN @strTipoPoliza AND @strTipoFin))
		AND ((@intFolioIni = 0) OR (intFolioPoliza BETWEEN @intFolioIni AND @intFolioFin))
		--AND ((@Dia <> 2) OR (strTipoPoliza NOT IN('07')))
		
		----Polizas
		INSERT INTO @Polizas(intEmpresa,intEjercicio,intMes,strPoliza,intPartida,strCuenta,strClasifDP,strClasifDS,intTipoMoneda,
		dblCargo,dblAbono,intIndAuxiliar,intCtaRegistro,intNivel)  
		SELECT DISTINCT PD.intEmpresa,PD.intEjercicio,PD.intMes,PD.strPoliza,PD.intPartida,ISNULL(PD.strCuenta,'0'),ISNULL(PD.strClasifDP,'0'),
		PD.strClasifDS,PD.intTipoMoneda,
		CASE WHEN PD.intTipoMovto = 1 THEN PD.dblImporte ELSE 0 END,
		CASE WHEN PD.intTipoMovto = 0 THEN PD.dblImporte ELSE 0 END,
		C.intIndAuxiliar,C.intCtaRegistro,C.intNivel
		FROM tbPolizasDet PD 
		INNER JOIN @PolizasEnc P ON P.strPoliza = PD.strPoliza AND P.intEjercicio = PD.intEjercicio AND P.intEmpresa = PD.intEmpresa AND P.strPoliza = PD.strPoliza
		INNER JOIN tbCuentas C ON C.strCuenta = PD.strCuenta AND C.intEmpresa = PD.intEmpresa
		WHERE PD.intEmpresa = @intEmpresa
		AND PD.intMes = @intMes
		AND PD.intEjercicio = @intEjercicio
		AND PD.intIndAfectada = CASE WHEN @intAfecta = 1 THEN 0 ELSE 1 END			

		SELECT @RowsCount = COUNT(*) FROM @Polizas

		IF(@RowsCount > 0)
		BEGIN
			--OBRAS
			INSERT INTO @Obra(intObra)
			SELECT intObra
			FROM VetecMarfil..tbObra
			WHERE intEmpresa = @intEmpresa

			INSERT INTO @ObraPoliza(intObra)
			SELECT DISTINCT strClasifDS
			FROM @Polizas

			DELETE FROM @ObraPoliza WHERE intObra IN(SELECT intObra FROM @Obra)

			UPDATE P
			SET P.strClasifDS = '0'
			FROM @Polizas P
			INNER JOIN @ObraPoliza O ON  O.intObra = strClasifDS

			INSERT INTO @PolizaSNObra(strPoliza)
			SELECT DISTINCT strPoliza
			FROM @Polizas
			WHERE strClasifDS = '0'

			SELECT @UnoxUno = COUNT(*) FROM @PolizasEnc

			IF(@UnoxUno = 1)
				SELECT @strPoliza = strPoliza FROM @Polizas 

			--Eliminamos polizas que no son de registro
			DELETE FROM @Polizas WHERE strPoliza IN(SELECT strPoliza FROM @Polizas WHERE intCtaRegistro = 0)		

			--Ultimo nivel
			IF NOT EXISTS(SELECT * FROM @Polizas) AND @UnoxUno = 1
			BEGIN
				SET @strMsg = 'No se puede afecta la poliza ' + ISNULL(@strPoliza,'') + '. Contiene cuentas que no son de ultimo nivel.'
				RAISERROR(@strMsg,16,1)
				RETURN;
			END
			
			--Eliminamos polizas que no son de registro
			DELETE FROM @Polizas WHERE strPoliza IN(SELECT strPoliza FROM @Polizas WHERE intIndAuxiliar = 1 AND ((strClasifDP = '0') OR (strClasifDP IS NULL) OR (strClasifDP = '')))

			--Auxiliar
			IF NOT EXISTS(SELECT * FROM @Polizas) AND @UnoxUno = 1
			BEGIN
				SET @strMsg = 'No se puede afecta la poliza ' + @strPoliza + '. No tiene Auxiliar'
				RAISERROR(@strMsg,16,1)
				RETURN;
			END		

			--Eliminamos polizas que no son de registro
			DELETE FROM @Polizas WHERE strPoliza IN(SELECT strPoliza FROM @Polizas WHERE strCuenta = '0')

			--Cuenta
			IF NOT EXISTS(SELECT * FROM @Polizas) AND @UnoxUno = 1
			BEGIN
				SET @strMsg = 'No se puede afecta la poliza ' + @strPoliza + '. La cuenta no Existe'
				RAISERROR(@strMsg,16,1)
				RETURN;
			END

			--Eliminamos polizas que no son de registro
			DELETE P FROM @Polizas P INNER JOIN @PolizaSNObra PS ON PS.strPoliza = P.strPoliza

			--Obra
			IF NOT EXISTS(SELECT * FROM @Polizas) AND @UnoxUno = 1
			BEGIN
				SET @strMsg = 'No se puede afecta la poliza ' + @strPoliza + '. La Obra es incorrecta.'
				RAISERROR(@strMsg,16,1)
				RETURN;
			END	

			--SEGUNDO NIVEL
			INSERT INTO @Polizas(intEmpresa,intEjercicio,intMes,strPoliza,intPartida,strCuenta,strClasifDP,strClasifDS,intTipoMoneda,
			dblCargo,dblAbono,intIndAuxiliar,intCtaRegistro,intNivel)
			SELECT intEmpresa,intEjercicio,intMes,strPoliza,intPartida,LEFT(strCuenta,4),strClasifDP,strClasifDS,intTipoMoneda,
			dblCargo,dblAbono,intIndAuxiliar,intCtaRegistro,1 
			FROM @Polizas
			WHERE intNivel = 2

			--TERCER NIVEL
			INSERT INTO @Polizas(intEmpresa,intEjercicio,intMes,strPoliza,intPartida,strCuenta,strClasifDP,strClasifDS,intTipoMoneda,
			dblCargo,dblAbono,intIndAuxiliar,intCtaRegistro,intNivel)
			SELECT intEmpresa,intEjercicio,intMes,strPoliza,intPartida,LEFT(strCuenta,8),strClasifDP,strClasifDS,intTipoMoneda,
			dblCargo,dblAbono,intIndAuxiliar,intCtaRegistro,2 
			FROM @Polizas
			WHERE intNivel = 3

			INSERT INTO @Polizas(intEmpresa,intEjercicio,intMes,strPoliza,intPartida,strCuenta,strClasifDP,strClasifDS,intTipoMoneda,
			dblCargo,dblAbono,intIndAuxiliar,intCtaRegistro,intNivel)
			SELECT intEmpresa,intEjercicio,intMes,strPoliza,intPartida,LEFT(strCuenta,4),strClasifDP,strClasifDS,intTipoMoneda,
			dblCargo,dblAbono,intIndAuxiliar,intCtaRegistro,1 
			FROM @Polizas
			WHERE intNivel = 3	
			
			DELETE FROM @Polizas WHERE ISNULL(strClasifDS,'') = ''
			 	
			--Datos para afectar
			INSERT @Afec(intEmpresa,intEjercicio,strCuenta,strClasifDP,strClasifDS,dblCargo,dblAbono)
			SELECT intEmpresa,intEjercicio,strCuenta,CASE WHEN ISNULL(strClasifDP,'') = '' THEN '0' ELSE strClasifDP END,
			strClasifDS,Sum(dblCargo),Sum(dblAbono)    
			FROM @Polizas    
			GROUP BY intEmpresa,intEjercicio,strCuenta,CASE WHEN ISNULL(strClasifDP,'') = '' THEN '0' ELSE strClasifDP END,strClasifDS										

			INSERT INTO tbCuentasSaldos(intEmpresa,intEjercicio,strCuenta,strClasifEnc,strClasifDP,strClasifDS,
			intIndInterEmpresa,intTipoMoneda,dblSaldoInicial,dblCargo01,dblAbono01,dblCargo02,dblAbono02,dblCargo03,
			dblAbono03,dblCargo04,dblAbono04,dblCargo05,dblAbono05,dblCargo06,dblAbono06,dblCargo07,dblAbono07,dblCargo08,
			dblAbono08,dblCargo09,dblAbono09,dblCargo10,dblAbono10,dblCargo11,dblAbono11,dblCargo12,dblAbono12,datFechaAlta,
			strUsuarioAlta,strMaquinaAlta,datFechaMod,strUsuarioMod,strMaquinaMod)       
			SELECT intEmpresa,intEjercicio,strCuenta,'0',ISNULL(strClasifDP,'0'),strClasifDS,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,      
			Null, Null, Null, Null, Null, Null  
			FROM @Afec
			EXCEPT	
			SELECT intEmpresa,intEjercicio,strCuenta,'0',strClasifDP,strClasifDS,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,      
			Null, Null, Null, Null, Null, Null  
			FROM tbCuentasSaldos
			WHERE intEmpresa = @intEmpresa AND intEjercicio = @intEjercicio	


			IF(@intAfecta = 1)
			BEGIN
				IF @intMes = 1 
				BEGIN
					UPDATE CS 
					SET CS.dblCargo01 = ISNULL(CS.dblCargo01,0) + ISNULL(A.dblCargo,0), 
						CS.dblAbono01 = ISNULL(CS.dblAbono01,0) + ISNULL(A.dblAbono,0)	
					FROM tbCuentasSaldos CS
					INNER JOIN @Afec A ON A.intEmpresa = CS.intEmpresa AND CS.intEjercicio = A.intEjercicio  AND CS.strCuenta = A.strCuenta AND CS.strClasifDS = A.strClasifDS AND CS.strClasifDP = A.strClasifDP
					WHERE CS.intEmpresa = @intEmpresa
					AND CS.intEjercicio = @intEjercicio 
				END
					    
				IF @intMes = 2  
				BEGIN			
					UPDATE CS 
					SET CS.dblCargo02 = ISNULL(CS.dblCargo02,0) + ISNULL(A.dblCargo,0), 
						CS.dblAbono02 = ISNULL(CS.dblAbono02,0) + ISNULL(A.dblAbono,0)	
					FROM tbCuentasSaldos CS
					INNER JOIN @Afec A ON A.intEmpresa = CS.intEmpresa AND CS.intEjercicio = A.intEjercicio  AND CS.strCuenta = A.strCuenta AND CS.strClasifDS = A.strClasifDS AND CS.strClasifDP = A.strClasifDP
					WHERE CS.intEmpresa = @intEmpresa
					AND CS.intEjercicio = @intEjercicio  
				END
			      
				IF @intMes = 3
				BEGIN
					UPDATE CS 
					SET CS.dblCargo03 = ISNULL(CS.dblCargo03,0) + ISNULL(A.dblCargo,0), 
						CS.dblAbono03 = ISNULL(CS.dblAbono03,0) + ISNULL(A.dblAbono,0)	
					FROM tbCuentasSaldos CS
					INNER JOIN @Afec A ON A.intEmpresa = CS.intEmpresa AND CS.intEjercicio = A.intEjercicio  AND CS.strCuenta = A.strCuenta AND CS.strClasifDS = A.strClasifDS AND CS.strClasifDP = A.strClasifDP
					WHERE CS.intEmpresa = @intEmpresa
					AND CS.intEjercicio = @intEjercicio 
				END

				IF @intMes = 4  
				BEGIN		
					UPDATE CS 
					SET CS.dblCargo04 = ISNULL(CS.dblCargo04,0) + ISNULL(A.dblCargo,0), 
						CS.dblAbono04 = ISNULL(CS.dblAbono04,0) + ISNULL(A.dblAbono,0)	
					FROM tbCuentasSaldos CS
					INNER JOIN @Afec A ON A.intEmpresa = CS.intEmpresa AND CS.intEjercicio = A.intEjercicio  AND CS.strCuenta = A.strCuenta AND CS.strClasifDS = A.strClasifDS AND CS.strClasifDP = A.strClasifDP
					WHERE CS.intEmpresa = @intEmpresa
					AND CS.intEjercicio = @intEjercicio 
				END  		
			      
				IF @intMes = 5
				BEGIN		
					UPDATE CS 
					SET CS.dblCargo05 = ISNULL(CS.dblCargo05,0) + ISNULL(A.dblCargo,0), 
						CS.dblAbono05 = ISNULL(CS.dblAbono05,0) + ISNULL(A.dblAbono,0)	
					FROM tbCuentasSaldos CS
					INNER JOIN @Afec A ON A.intEmpresa = CS.intEmpresa AND CS.intEjercicio = A.intEjercicio  AND CS.strCuenta = A.strCuenta AND CS.strClasifDS = A.strClasifDS AND CS.strClasifDP = A.strClasifDP
					WHERE CS.intEmpresa = @intEmpresa
					AND CS.intEjercicio = @intEjercicio 
				 END
			      
				IF @intMes = 6  
				BEGIN
					UPDATE CS 
					SET CS.dblCargo06 = ISNULL(CS.dblCargo06,0) + ISNULL(A.dblCargo,0), 
						CS.dblAbono06 = ISNULL(CS.dblAbono06,0) + ISNULL(A.dblAbono,0)	
					FROM tbCuentasSaldos CS
					INNER JOIN @Afec A ON A.intEmpresa = CS.intEmpresa AND CS.intEjercicio = A.intEjercicio  AND CS.strCuenta = A.strCuenta AND CS.strClasifDS = A.strClasifDS AND CS.strClasifDP = A.strClasifDP
					WHERE CS.intEmpresa = @intEmpresa
					AND CS.intEjercicio = @intEjercicio 
				END    
			      
				IF @intMes = 7      
				BEGIN	
					UPDATE CS 
					SET CS.dblCargo07 = ISNULL(CS.dblCargo07,0) + ISNULL(A.dblCargo,0), 
						CS.dblAbono07 = ISNULL(CS.dblAbono07,0) + ISNULL(A.dblAbono,0)	
					FROM tbCuentasSaldos CS
					INNER JOIN @Afec A ON A.intEmpresa = CS.intEmpresa AND CS.intEjercicio = A.intEjercicio  AND CS.strCuenta = A.strCuenta AND CS.strClasifDS = A.strClasifDS AND CS.strClasifDP = A.strClasifDP
					WHERE CS.intEmpresa = @intEmpresa
					AND CS.intEjercicio = @intEjercicio 
				END
			      
				IF @intMes = 8 
				BEGIN
					UPDATE CS 
					SET CS.dblCargo08 = ISNULL(CS.dblCargo08,0) + ISNULL(A.dblCargo,0), 
						CS.dblAbono08 = ISNULL(CS.dblAbono08,0) + ISNULL(A.dblAbono,0)	
					FROM tbCuentasSaldos CS
					INNER JOIN @Afec A ON A.intEmpresa = CS.intEmpresa AND CS.intEjercicio = A.intEjercicio  AND CS.strCuenta = A.strCuenta AND CS.strClasifDS = A.strClasifDS AND CS.strClasifDP = A.strClasifDP
					WHERE CS.intEmpresa = @intEmpresa
					AND CS.intEjercicio = @intEjercicio 
				END     
			      
				IF @intMes = 9     
				BEGIN
					UPDATE CS 
					SET CS.dblCargo09 = ISNULL(CS.dblCargo09,0) + ISNULL(A.dblCargo,0), 
						CS.dblAbono09 = ISNULL(CS.dblAbono09,0) + ISNULL(A.dblAbono,0)	
					FROM tbCuentasSaldos CS
					INNER JOIN @Afec A ON A.intEmpresa = CS.intEmpresa AND CS.intEjercicio = A.intEjercicio  AND CS.strCuenta = A.strCuenta AND CS.strClasifDS = A.strClasifDS AND CS.strClasifDP = A.strClasifDP
					WHERE CS.intEmpresa = @intEmpresa
					AND CS.intEjercicio = @intEjercicio 
				END

				IF @intMes = 10 
				BEGIN
					UPDATE CS 
					SET CS.dblCargo10 = ISNULL(CS.dblCargo10,0) + ISNULL(A.dblCargo,0), 
						CS.dblAbono10 = ISNULL(CS.dblAbono10,0) + ISNULL(A.dblAbono,0)	
					FROM tbCuentasSaldos CS
					INNER JOIN @Afec A ON A.intEmpresa = CS.intEmpresa AND CS.intEjercicio = A.intEjercicio  AND CS.strCuenta = A.strCuenta AND CS.strClasifDS = A.strClasifDS AND CS.strClasifDP = A.strClasifDP
					WHERE CS.intEmpresa = @intEmpresa
					AND CS.intEjercicio = @intEjercicio 
				END

				IF @intMes = 11      
				BEGIN
					UPDATE CS 
					SET CS.dblCargo11 = ISNULL(CS.dblCargo11,0) + ISNULL(A.dblCargo,0), 
						CS.dblAbono11 = ISNULL(CS.dblAbono11,0) + ISNULL(A.dblAbono,0)	
					FROM tbCuentasSaldos CS
					INNER JOIN @Afec A ON A.intEmpresa = CS.intEmpresa AND CS.intEjercicio = A.intEjercicio  AND CS.strCuenta = A.strCuenta AND CS.strClasifDS = A.strClasifDS AND CS.strClasifDP = A.strClasifDP
					WHERE CS.intEmpresa = @intEmpresa
					AND CS.intEjercicio = @intEjercicio 
				END
			     
				IF @intMes = 12      
				BEGIN
					UPDATE CS 
					SET CS.dblCargo12 = ISNULL(CS.dblCargo12,0) + ISNULL(A.dblCargo,0), 
						CS.dblAbono12 = ISNULL(CS.dblAbono12,0) + ISNULL(A.dblAbono,0)	
					FROM tbCuentasSaldos CS
					INNER JOIN @Afec A ON A.intEmpresa = CS.intEmpresa AND CS.intEjercicio = A.intEjercicio  AND CS.strCuenta = A.strCuenta AND CS.strClasifDS = A.strClasifDS AND CS.strClasifDP = A.strClasifDP
					WHERE CS.intEmpresa = @intEmpresa
					AND CS.intEjercicio = @intEjercicio 
				END		
			END
			ELSE
			BEGIN
				IF @intMes = 1 
				BEGIN
					UPDATE CS 
					SET CS.dblCargo01 = ISNULL(CS.dblCargo01,0) - ISNULL(A.dblCargo,0), 
						CS.dblAbono01 = ISNULL(CS.dblAbono01,0) - ISNULL(A.dblAbono,0)	
					FROM tbCuentasSaldos CS
					INNER JOIN @Afec A ON A.intEmpresa = CS.intEmpresa AND CS.intEjercicio = A.intEjercicio  AND CS.strCuenta = A.strCuenta AND CS.strClasifDS = A.strClasifDS AND CS.strClasifDP = A.strClasifDP
					WHERE CS.intEmpresa = @intEmpresa
					AND CS.intEjercicio = @intEjercicio 
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
				END		
			END	

			ALTER TABLE tbPolizasEnc DISABLE TRIGGER ALL        
			ALTER TABLE tbPolizasDet DISABLE TRIGGER ALL        
		             
			UPDATE PE 
			SET PE.intIndAfectada = @intAfecta 
			FROM tbPolizasEnc PE
			INNER JOIN @Polizas POL ON POL.intEmpresa = PE.intEmpresa AND POL.intEjercicio = PE.intEjercicio 
			AND PE.intMes = POL.intMes AND POL.strPoliza = PE.strPoliza
			WHERE PE.intEmpresa = @intEmpresa
			AND PE.intEjercicio = @intEjercicio 
			AND PE.intMes = @intMes 	
		                  
			UPDATE PD 
			SET PD.intIndAfectada = @intAfecta    		  
			FROM tbPolizasDet PD
			INNER JOIN @Polizas POL ON POL.intEmpresa = PD.intEmpresa AND POL.intEjercicio = PD.intEjercicio 
			AND PD.intMes = POL.intMes AND POL.strPoliza = PD.strPoliza
			WHERE PD.intEmpresa = @intEmpresa
			AND PD.intEjercicio = @intEjercicio 
			AND PD.intMes = @intMes		
			AND PD.intIndAfectada = CASE WHEN @intAfecta = 1 THEN 0 ELSE 1 END	
				             
			ALTER TABLE tbPolizasEnc ENABLE TRIGGER ALL        
			ALTER TABLE tbPolizasDet ENABLE TRIGGER ALL 
		END

		--Bitacora
		INSERT INTO tbPolizasAfectacion(intEmpresa,intEjercicio,intMes,strTipoIni,strTipoFin,intFolioIni,intFolioFin,
		intAfecta,strUsuario,strMaquina,datFecha)
		VALUES(@intEmpresa,@intEjercicio,@intMes,@strTipoPoliza,@strTipoFin,@intFolioIni,@intFolioFin,@intAfecta,@strUsuario,
		@strMaquina,GETDATE())


		COMMIT TRANSACTION usp_tbPolizas_Afecta
	END TRY
	BEGIN CATCH	
		IF @@TRANCOUNT > 0
			ROLLBACK TRANSACTION usp_tbPolizas_Afecta   

		DECLARE @ErrMsg nvarchar(4000)
		SELECT @ErrMsg = ERROR_MESSAGE()

		RAISERROR(@ErrMsg, 16, 1)
	END CATCH
	

END
GO

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbPolizas_AfectaPoliza Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbPolizas_AfectaPoliza Error on Creation'
END
GO