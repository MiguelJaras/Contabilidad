
/****** Object:  StoredProcedure [dbo.usp_Tareas_Fill]    Script Date: 12/8/2009 10:45:19 AM ******/
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbPolizasDet_EstadoResultados')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbPolizasDet_EstadoResultados
	PRINT N'Drop Procedure : dbo.usp_tbPolizasDet_EstadoResultados - Succeeded !!!'
END
GO

------------------------------------------------------------------------------------
---   Aplicacion: Marfil.		                                                 ---
---        Autor: Rubén Mora Martínez                                            ---
---  Descripcion: Obtiene un registro de la tabla:  Reporte                      ---
---                                                                              ---
------------------------------------------------------------------------------------
---    Fecha     Autor  Comentario                                               ---
---  ----------  -----  -------------------------------------------------------  ---
---  12/11/2010  RMM    Create procedure                                         ---
------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[usp_tbPolizasDet_EstadoResultados]        
(
	@intEmpresa		Int,
	@intEstadoFin	Int,  
	@datFechaIni	varchar(20),  
	@datFechaFin	varchar(20), 
	@strCCIni		VarChar(60), 
	@strCCFin		VarChar(60),
	@strQuitar		VarChar(60) 
) 
WITH ENCRYPTION       
AS    
BEGIN
  	SET NOCOUNT ON
	
	DECLARE @strEmpresa VARCHAR(250)	
	DECLARE @intColonia int
	DECLARE @intSector int
	DECLARE @strColonia varchar(100)	
	DECLARE @strNombreColonia varchar(200)	
	DECLARE @Rows INT
	DECLARE @Count INT
	DECLARE @Rows2 INT
	DECLARE @Count2 INT
	DECLARE @intRubro INT
	DECLARE @sql nvarchar(1000)
	DECLARE @sqlSelect varchar(8000)
	DECLARE @sqlSum varchar(5000)
	DECLARE @dblCargo DECIMAL(18,2)
	DECLARE @dblAbono DECIMAL(18,2)

	IF(@strCCIni = '0')
		SELECT TOP 1 @strCCIni = strClave FROM VetecMarfil..tbObra WHERE intEmpresa = @intEmpresa order by strClave ASC

	IF(@strCCFin = '0')
		SELECT TOP 1 @strCCFin = strClave FROM VetecMarfil..tbObra WHERE intEmpresa = @intEmpresa order by strClave DESC		
		
	SET @Count = 0	

	CREATE TABLE #Colonia(id int identity(1,1), intColonia int, strNombre varchar(200), intSector int)
	CREATE TABLE #ColoniaReal(id int identity(1,1), strNombre varchar(200))
	CREATE TABLE #Obras(intObra INT, strObra VARCHAR(50),intColonia int, strNombre varchar(100), intSector int)
	CREATE TABLE #Polizas(strPoliza VARCHAR(50), strCuenta VARCHAR(250) COLLATE SQL_Latin1_General_CP1_CI_AS, strClasifDS VARCHAR(10), dblImporte FLOAT, intTipoMovto INT)
	CREATE TABLE #CuentasRubros(strCuenta VARCHAR (250) COLLATE SQL_Latin1_General_CP1_CI_AS, intRubro INT, intSecuencia int)
	CREATE TABLE #Rubros(strNombreRubro VARCHAR (250) COLLATE SQL_Latin1_General_CP1_CI_AS, intRubro INT, intSecuencia int)
	CREATE TABLE #Data(intDato INT IDENTITY(1,1), intRubro int, strNombreRubro VARCHAR(250))
	CREATE TABLE #ObrasExistentes(intColonia int,strColonia varchar(100), intObra int, strObra varchar(50), intSector int)
	CREATE TABLE #ClasifDS(strClasifDS varchar(200))
	
	INSERT INTO #CuentasRubros(strCuenta,intRubro,intSecuencia)
	SELECT DISTINCT RC.strCuenta, RC.intRubro,intsecuencia
	FROM tbRubrosCuentas RC		
	INNER JOIN tbEstadosFinRubros F ON RC.intEmpresa = F.intEmpresa AND F.intRubro = RC.intRubro
	WHERE F.intEmpresa = @intEmpresa
	AND F.intEstadoFin = @intEstadoFin	
	order by intsecuencia desc
	--AND strCuenta = '3130'

	INSERT INTO #ObrasExistentes(intColonia,strColonia,intObra,strObra,intSector)
	SELECT intColonia,strColonia,intObra,strObra,intSector
	FROM VetecMarfil.dbo.fn_ColoniasObra(@strCCIni,@strCCFin,@intEmpresa) 


	--DELETE FROM #ObrasExistentes WHERE intObra NOT IN(SELECT DISTINCT CONVERT(INT,strClasifDS) FROM tbPolizasDet PD
	--												  INNER JOIN tbPolizasEnc PE ON PE.intEmpresa = PD.intEmpresa AND PE.strPoliza = PD.strPoliza AND PE.intEjercicio = PD.intEjercicio
	--												  WHERE PD.intEmpresa = @intEmpresa
	--												  AND PD.datFecha BETWEEN @datFechaIni AND @datFechaFin
	--												  AND PD.intIndAfectada = 1
	--												  AND PE.intEstatus <> 9)

	DELETE FROM #ObrasExistentes WHERE intObra NOT IN(SELECT DISTINCT O.intObra
													  FROM tbCuentasSaldos C
													  INNER JOIN VetecMarfil..tbObra O ON O.intObra = C.strClasifDS
													  WHERE C.intEmpresa = @intEmpresa
												      AND C.intEjercicio BETWEEN YEAR(@datFechaIni) AND YEAR(@datFechaFin)
													  AND strClasifDS NOT IN('0','','000000000100000000000000000000'))
	
--	SELECT DISTINCT strClasifDS FROM tbCuentasSaldos WHERE intEmpresa = 2 and intEjercicio = 2013
--	SELECT DISTINCT strClasifDS FROM tbPolizasDet PD INNER JOIN tbPolizasEnc PE ON PE.intEmpresa = PD.intEmpresa AND PE.strPoliza = PD.strPoliza AND PE.intEjercicio = PD.intEjercicio
--	WHERE PD.intEmpresa = 2 AND PD.datFecha BETWEEN '01/07/2013' AND '31/07/2013' AND PD.intIndAfectada = 1
--	AND PE.intEstatus <> 9

--	INSERT INTO #ClasifDS
--	SELECT DISTINCT strClasifDS FROM tbPolizasDet PD
--	INNER JOIN tbPolizasEnc PE ON PE.intEmpresa = PD.intEmpresa AND PE.strPoliza = PD.strPoliza
--	WHERE PD.intEmpresa = @intEmpresa
--	AND PD.datFecha BETWEEN @datFechaIni AND @datFechaFin
--	AND PD.intIndAfectada = 1
--	AND PE.intEstatus <> 9
--	AND ISNULL(strClasifDS,0) <> 0
--
--	SELECT strClasifDS AS DC FROM #ClasifDS WHERE strClasifDS NOT IN(SELECT intObra FROM #ObrasExistentes) order by strClasifDS

	INSERT INTO #Obras(intObra,strObra,intColonia,strNombre,intSector)
	SELECT DISTINCT intObra, strObra,intColonia,strColonia,intSector
	FROM #ObrasExistentes
	WHERE intSector is not null

	INSERT INTO #Polizas(strPoliza,strCuenta,strClasifDS,dblImporte,intTipoMovto)
	SELECT PD.strPoliza,PD.strCuenta,PD.strClasifDS,PD.dblImporte,PD.intTipoMovto
	FROM tbPolizasDet PD
	INNER JOIN tbPolizasEnc PE ON PE.intEmpresa = PD.intEmpresa AND PE.strPoliza = PD.strPoliza AND PE.intEjercicio = PD.intEjercicio
	WHERE PD.intEmpresa = @intEmpresa
	AND CONVERT(DATETIME, FLOOR(CONVERT(FLOAT,PD.datFecha))) BETWEEN @datFechaIni AND @datFechaFin
	AND PD.intIndAfectada = 1
	AND PE.intEstatus <> 9		
	AND PD.strClasifDS IN(SELECT DISTINCT intObra FROM #Obras)
	AND LEFT(PD.strCuenta,4) IN (SELECT DISTINCT strCuenta FROM #CuentasRubros)
	AND ((PD.strClasifDS <> '0') OR (PD.strClasifDS IS NOT NULL))

	DELETE FROM #Obras WHERE intObra NOT IN(SELECT strClasifDS FROM #Polizas)
	DELETE FROM #ObrasExistentes WHERE intObra NOT IN(SELECT strClasifDS FROM #Polizas)		

	INSERT INTO #Colonia(intColonia,strNombre, intSector)
	SELECT DISTINCT intColonia,strColonia,intSector
	FROM #ObrasExistentes
	WHERE intSector is not null

	INSERT INTO #ColoniaReal(strNombre)
	SELECT DISTINCT REPLACE(RTRIM(strNombre),'.','')
	FROM #Colonia

	INSERT INTO #Rubros(intRubro,strNombreRubro,intSecuencia)
	SELECT DISTINCT R.intRubro, R.strNombre, CR.intSecuencia
	FROM #CuentasRubros CR
	INNER JOIN tbRubros R ON R.intRubro = CR.intRubro

	INSERT INTO #Data(intRubro,strNombreRubro)
	SELECT R.intRubro, R.strNombre
	FROM #Rubros CR
	INNER JOIN tbRubros R ON R.intRubro = CR.intRubro
	ORDER BY CR.intSecuencia

	SET @Rows  = ISNULL((SELECT COUNT(*) FROM #ColoniaReal),0)
	SET @Count  = 0

	SET @sqlSelect = ''
	SET @sqlSum = ''
	
	--HERE
	WHILE(@Rows > @Count)
	BEGIN	
		SET @Count = @Count + 1

		SELECT @strColonia = 'C' + CONVERT(VARCHAR,@Count) + '_' + CONVERT(VARCHAR,ISNULL(@Count,999)),
		@strNombreColonia = strNombre
		FROM #ColoniaReal WHERE id = @Count

		SET @sql = 'ALTER TABLE #Data ADD ' + @strColonia + ' DECIMAL(18,2)'
		
		exec(@sql)

		SET @Rows2  = ISNULL((SELECT COUNT(*) FROM #Data),0)
		SET @Count2  = 0
		
		WHILE(@Rows2 > @Count2)
		BEGIN
			SET @Count2 = @Count2 + 1

			SELECT @intRubro =  intRubro FROM #Data WHERE intDato = @Count2
			
			--GENERALES
			IF(@strNombreColonia = 'GENERALES')
			BEGIN
				SELECT @dblCargo = ISNULL(SUM(dblImporte),0)
				FROM #Polizas P
				INNER JOIN #Obras O ON O.intObra = P.strClasifDS																
				WHERE LEFT(P.strCuenta, 4) IN (SELECT strCuenta FROM #CuentasRubros WHERE intRubro = @intRubro)	
				AND intTipoMovto = 1
				AND O.intColonia = 0	
					
				SELECT @dblAbono = ISNULL(SUM(dblImporte),0)
				FROM #Polizas P
				INNER JOIN #Obras O ON O.intObra = P.strClasifDS																
				WHERE LEFT(P.strCuenta, 4) IN (SELECT strCuenta FROM #CuentasRubros WHERE intRubro = @intRubro)	
				AND intTipoMovto = 0
				--AND O.intColonia = @intColonia
				AND O.intColonia = 0				
			END
			ELSE
			BEGIN
				SELECT @dblCargo = ISNULL(SUM(ABS(dblImporte)),0)
				FROM #Polizas P
				INNER JOIN #Obras O ON O.intObra = P.strClasifDS																
				WHERE LEFT(P.strCuenta, 4) IN (SELECT strCuenta FROM #CuentasRubros WHERE intRubro = @intRubro)	
				AND intTipoMovto = 1
				AND O.intColonia IN(SELECT intColonia FROM #Colonia WHERE strNombre = @strNombreColonia)
				AND O.intSector IN(SELECT intSector FROM #Colonia WHERE strNombre = @strNombreColonia)
					
				SELECT @dblAbono = ISNULL(SUM(ABS(dblImporte)),0)
				FROM #Polizas P
				INNER JOIN #Obras O ON O.intObra = P.strClasifDS																
				WHERE LEFT(P.strCuenta, 4) IN (SELECT strCuenta FROM #CuentasRubros WHERE intRubro = @intRubro)	
				AND intTipoMovto = 0
				AND O.intColonia IN(SELECT intColonia FROM #Colonia WHERE strNombre = @strNombreColonia)
				AND O.intSector IN(SELECT intSector FROM #Colonia WHERE strNombre = @strNombreColonia)
			END

			SET @sql = 'UPDATE #Data SET ' + @strColonia + '=' + CONVERT(VARCHAR,ISNULL(@dblCargo,0) - ISNULL(@dblAbono,0)) + ' WHERE intDato =' + CONVERT(VARCHAR,@Count2)
			
			exec(@sql)	

			SET @dblCargo = 0
			SET @dblAbono = 0										
		END

		IF(@strQuitar = '0')
		BEGIN	
			DECLARE @A DECIMAL(18,2)	
			SET @sql = 'SELECT @A = SUM([' + @strColonia + ']) FROM #Data'	

			EXEC SP_EXECUTESQL @sql, N'@A DECIMAL(18,2) OUTPUT', @A OUTPUT
		
			IF(ISNULL(@A,0) <> 0)
			BEGIN
				SET @sqlSelect = @sqlSelect + '''$ '' + convert(varchar,convert(money,' + @strColonia + '),1) AS ['+ @strNombreColonia +'],'
				SET @sqlSum = @sqlSum + 'A.' + @strColonia + ' + '				
			END
		END	
		ELSE
		BEGIN
		--SELECT @strNombreColonia = strAliasSQL FROM VetecMarfil..tbColonia WHERE intColonia = @intColonia
			SET @sqlSelect = @sqlSelect + '''$ '' + convert(varchar,convert(money,' + @strColonia + '),1) AS ['+ @strNombreColonia +'],'
			SET @sqlSum = @sqlSum + 'A.' + @strColonia + ' + '		
		END
		SET @sql = ''
	END

	--Columna para el total del rubro
	SET @sql = 'ALTER TABLE #Data ADD Total DECIMAL(18,2)'		
	exec(@sql)
	--Calculo del total del rubro
	SET @sql = 'UPDATE B SET Total = (SELECT SUM(' + LEFT(@sqlSum,LEN(@sqlSum) - 1) + ') FROM #Data A WHERE A.intRubro = B.intRubro) FROM #Data B'
	exec(@sql)		

	SET @sqlSelect = 'SELECT intDato AS No,strNombreRubro as Rubro,' + LEFT(@sqlSelect,LEN(@sqlSelect) - 1) + ', ''$ '' +CONVERT(VARCHAR,CONVERT(MONEY,Total),1) AS Total FROM #Data'

	exec(@sqlSelect)

	DROP TABLE #Colonia
	DROP TABLE #Obras
	DROP TABLE #Polizas
	DROP TABLE #CuentasRubros
	DROP TABLE #Data
	DROP TABLE #Rubros


	SET NOCOUNT OFF
END	
GO

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbPolizasDet_EstadoResultados Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbPolizasDet_EstadoResultados Error on Creation'
END
GO








