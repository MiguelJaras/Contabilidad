IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbCuentasRet_Help')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbCuentasRet_Help
	PRINT N'Drop Procedure : dbo.usp_tbCuentasRet_Help - Succeeded !!!'
END
GO

------------------------------------------------------------------------------------
---   Aplicacion: Abasto.		                                                 ---
---        Autor: Ramón Rios Hernandez                                           ---
---  Descripcion:														         ---
---                                                                              ---
------------------------------------------------------------------------------------
---    Fecha     Autor  Comentario                                               ---
---  ----------  -----  -------------------------------------------------------  ---
---  23/07/2013  RRH    Create procedure                                         ---
------------------------------------------------------------------------------------

CREATE PROCEDURE dbo.usp_tbCuentasRet_Help
(
	@intEmpresa			VARCHAR(50),
	@intSucursal		VARCHAR(50),
	@intVersion			INT,
	@strParametros		VARCHAR(500)	
)
WITH ENCRYPTION
AS
BEGIN
	SET NOCOUNT ON
		
	DECLARE @strParameter1 VARCHAR(200)
	DECLARE @strParameter2 VARCHAR(200)
	DECLARE @strParameter3 VARCHAR(200)
	DECLARE @strParameter4 VARCHAR(200)
	DECLARE @returnValue NVARCHAR(2000)
	DECLARE @Split char(1)
	DECLARE @xml xml


	--*** Obtenemos Parametros
	CREATE TABLE #Parameters(Row int identity(1,1), Parameter VARCHAR (200))
 
	SET @Split = ','
 
	SELECT @xml = CONVERT(xml,'<root><s>' + REPLACE(@strParametros,@Split,'</s><s>') + '</s></root>')
 
	INSERT INTO #Parameters(Parameter)
	SELECT [Value] = T.c.value('.','varchar(50)')
	FROM @xml.nodes('/root/s') T(c)

	DELETE FROM #Parameters WHERE ISNULL(Parameter,'') = ''

	--*** Asignamos Parametros
	SELECT @strParameter1 = Parameter FROM #Parameters WHERE Row = 1
	SELECT @strParameter2 = Parameter FROM #Parameters WHERE Row = 2
	SELECT @strParameter3 = Parameter FROM #Parameters WHERE Row = 3
	SELECT @strParameter4 = Parameter FROM #Parameters WHERE Row = 4
	
	DROP TABLE #Parameters

	--*** Versiones
	IF (@intVersion = 0)
	BEGIN
        SET @returnValue = 'SELECT --CR.intEmpresa,
			--CR.intCuentaRet,
			CR.intArea,
			A.strNombre AS strNombreArea,
			CR.strInsumoIni,
			ISNULL(ArtIni.strNombre,''INSUMO N.E'') AS NombreInsumoIni,
			CR.strInsumoFin, 
			ISNULL(ArtFin.strNombre,''INSUMO N.E'') AS NombreInsumoFin,
			CR.strCuentaCargo,
			CtaCargo.strNombre AS NombreCuentaCargo,
			CR.strCuentaAbono,
			CtaAbono.strNombre AS NombreCuentaAbono,
 		    CR.intES
	   FROM tbCuentasRet CR
 INNER JOIN VetecMarfil.dbo.tbArea A 
		 ON A.intArea = CR.intArea 
		AND A.intEmpresa = CR.intEmpresa

  LEFT JOIN VetecMarfil.dbo.tbArticulo ArtIni 
		 ON ArtIni.strNombreCorto COLLATE Modern_Spanish_CI_AS  = CR.strInsumoIni COLLATE Modern_Spanish_CI_AS  
		AND ArtIni.intEmpresa = CR.intEmpresa

  LEFT JOIN VetecMarfil.dbo.tbArticulo ArtFin 
		 ON ArtFin.strNombreCorto COLLATE Modern_Spanish_CI_AS  = CR.strInsumoFin COLLATE Modern_Spanish_CI_AS  
		AND ArtFin.intEmpresa = CR.intEmpresa

 INNER JOIN tbCuentas CtaCargo
		 ON CtaCargo.strCuenta = REPLACE(CR.strCuentaCargo,''-'','''')
		AND CtaCargo.intEmpresa = CR.intEmpresa

 INNER JOIN tbCuentas CtaAbono
		 ON CtaAbono.strCuenta = REPLACE(CR.strCuentaAbono,''-'','''')
		AND CtaAbono.intEmpresa = CR.intEmpresa 

	WHERE CR.intEmpresa = CASE '+ISNULL(@intEmpresa,0)+' WHEN 0 THEN CR.intEmpresa ELSE '+ISNULL(@intEmpresa,0)+' END
	AND CR.intCuentaRet = CASE '+ISNULL(@strParameter1,0)+' WHEN 0 THEN CR.intCuentaRet ELSE '+ISNULL(@strParameter1,0)+' END'

	END  

	IF (@intVersion = 1)
	BEGIN
        SET @returnValue ='SELECT intArea,strNombre FROM VetecMarfil.dbo.tbArea
	WHERE tbArea.intEmpresa = CASE '+ISNULL(@intEmpresa,0)+' WHEN 0 THEN tbArea.intEmpresa ELSE '+ISNULL(@intEmpresa,0)+' END
	  AND tbArea.intSucursal = CASE '+ISNULL(@intSucursal,0)+' WHEN 0 THEN tbArea.intSucursal ELSE '+ISNULL(@intSucursal,0)+' END
	  AND tbArea.intArea = CASE '+ISNULL(@strParameter1,0)+' WHEN 0 THEN tbArea.intArea ELSE '+ISNULL(@strParameter1,0)+' END'
	END 

	IF (@intVersion = 2)
	BEGIN
        SET @returnValue ='SELECT strNombreCorto,strNombre FROM VetecMarfil.dbo.tbArticulo
	WHERE tbArticulo.intEmpresa  = CASE '+ISNULL(@intEmpresa,0)+' WHEN 0 THEN tbArticulo.intEmpresa ELSE '+ISNULL(@intEmpresa,0)+' END
	  AND tbArticulo.intSucursal = CASE '+ISNULL(@intSucursal,0)+' WHEN 0 THEN tbArticulo.intSucursal ELSE '+ISNULL(@intSucursal,0)+' END
	  AND tbArticulo.strNombreCorto = CASE '''+ISNULL(@strParameter1,0)+''' WHEN 0 THEN tbArticulo.strNombreCorto ELSE '''+ISNULL(@strParameter1,0)+''' END'
	END 

	IF (@intVersion = 3)
	BEGIN
        SET @returnValue ='SELECT strCuenta,strNombre FROM VetecMarfilAdmin.dbo.tbCuentas
	WHERE tbCuentas.intEmpresa = CASE '+ISNULL(@intEmpresa,0)+' WHEN 0 THEN tbCuentas.intEmpresa ELSE '+ISNULL(@intEmpresa,0)+' END
	  AND tbCuentas.strCuenta = CASE '''+ISNULL(@strParameter1,0)+''' WHEN ''0'' THEN tbCuentas.strCuenta ELSE '''+ISNULL(@strParameter1,0)+''' END'
	END 
 
	return @returnValue
	--EXEC sp_executesql @returnValue

	SET NOCOUNT OFF
END
GO 

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbCuentasRet_Help Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbCuentasRet_Help Error on Creation'
END
GO