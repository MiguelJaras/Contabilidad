IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbCuentasRet_Sel')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbCuentasRet_Sel
	PRINT N'Drop Procedure : dbo.usp_tbCuentasRet_Sel - Succeeded !!!'
END
GO

------------------------------------------------------------------------------------
---   Aplicacion: Abasto.		                                                 ---
---        Autor: Ramón Rios Hernandez                                           ---
---  Descripcion: Obtiene un registro de la tabla:  tbCuentasRet		         ---
---                                                                              ---
------------------------------------------------------------------------------------
---    Fecha     Autor  Comentario                                               ---
---  ----------  -----  -------------------------------------------------------  ---
---  23/07/2013  RRH    Create procedure                                         ---
------------------------------------------------------------------------------------
CREATE PROCEDURE usp_tbCuentasRet_Sel
(
	@intEmpresa					  INT,
	@intCuentaRet				  INT,
	@intArea					  INT,
	@strInsumoIni		 VARCHAR(100),
	@strInsumoFin		 VARCHAR(100),
	@strCuentaCargo 	 VARCHAR(100),
	@strCuentaAbono 	 VARCHAR(100),
	@intES						  INT,
	@NumPage				INT= NULL,
	@NumRecords				  int = 0, 
	@intDireccion				  int,
	@SortExpression		  varchar(50),
	@TotalRows		   int = NULL out,
	@TotalPage		 int = NULL OUTPUT
)				
AS
				
    BEGIN
    SET NOCOUNT ON
		
	DECLARE	@Err				int,
			@MsgErr				varchar(512),
			@startRow			int,
			@finalRow			int,
			@iNumTotRecords		int,
			@iNumTotPages		int,
			@fNumPages			float,
			@Sort				varchar(200) 

	IF(@SortExpression = '')
		SET	@SortExpression = 'strInsumoIni'
			
	SELECT @Sort = LOWER(@SortExpression) + CASE WHEN @intDireccion = 0 THEN ' DESC' ELSE ' ASC' END 
 
	CREATE TABLE #Temp_tbCuentasRet
	( 
		row				    INT IDENTITY, 
		intEmpresa					 INT,
		intCuentaRet				 INT,
		intArea						 INT,
		strNombreArea		VARCHAR(100),
		strInsumoIni		VARCHAR(100),
		NombreInsumoIni		VARCHAR(100),
		strInsumoFin		VARCHAR(100),
		NombreInsumoFin		VARCHAR(100),
		strCuentaCargo		VARCHAR(100),
		NombreCuentaCargo	VARCHAR(100),
		strCuentaAbono		VARCHAR(100),
		NombreCuentaAbono	VARCHAR(100),
		NombreEstatus		VARCHAR(100),
		intES						 INT
	)

INSERT INTO #Temp_tbCuentasRet(intEmpresa,intCuentaRet,intArea,strNombreArea,strInsumoIni,NombreInsumoIni,strInsumoFin,NombreInsumoFin,strCuentaCargo,NombreCuentaCargo,strCuentaAbono,NombreCuentaAbono,NombreEstatus,intES)
		SELECT CR.intEmpresa,
			CR.intCuentaRet,
			CR.intArea,
			A.strNombre AS strNombreArea,
			CR.strInsumoIni,
			ISNULL(ArtIni.strNombre,'INSUMO N.E') AS NombreInsumoIni,
			CR.strInsumoFin, 
			ISNULL(ArtFin.strNombre,'INSUMO N.E') AS NombreInsumoFin,
			CR.strCuentaCargo,
			CtaCargo.strNombre AS NombreCuentaCargo,
			CR.strCuentaAbono,
			CtaAbono.strNombre AS NombreCuentaAbono,
			CASE WHEN CR.intES = 1 THEN 'Entrada' ELSE 'Salida' END AS NombreEstatus,
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
		 ON CtaCargo.strCuenta = REPLACE(CR.strCuentaCargo,'-','')
		AND CtaCargo.intEmpresa = CR.intEmpresa

 INNER JOIN tbCuentas CtaAbono
		 ON CtaAbono.strCuenta = REPLACE(CR.strCuentaAbono,'-','')
		AND CtaAbono.intEmpresa = CR.intEmpresa

	  WHERE CR.intEmpresa = CASE ISNULL(@intEmpresa,0) WHEN 0 THEN CR.intEmpresa ELSE ISNULL(@intEmpresa,0) END
	    AND CR.intCuentaRet = CASE ISNULL(@intCuentaRet,0) WHEN 0 THEN CR.intCuentaRet ELSE ISNULL(@intCuentaRet,0) END
		AND CR.intArea = CASE ISNULL(@intArea,0) WHEN 0 THEN CR.intArea ELSE ISNULL(@intArea,0) END
		AND CR.strInsumoIni = CASE ISNULL(@strInsumoIni,'0') WHEN '0' THEN CR.strInsumoIni ELSE ISNULL(@strInsumoIni,'0') END
		AND CR.strInsumoFin = CASE ISNULL(@strInsumoFin,'0') WHEN '0' THEN CR.strInsumoFin ELSE ISNULL(@strInsumoFin,'0') END
		AND REPLACE(ISNULL(CR.strCuentaCargo,'0'),'-','') = CASE REPLACE(ISNULL(@strCuentaCargo,'0'),'-','') WHEN '0' THEN REPLACE(ISNULL(CR.strCuentaCargo,'0'),'-','') ELSE REPLACE(ISNULL(@strCuentaCargo,'0'),'-','') END
		AND REPLACE(ISNULL(CR.strCuentaAbono,'0'),'-','') = CASE REPLACE(ISNULL(@strCuentaAbono,'0'),'-','') WHEN '0' THEN REPLACE(ISNULL(CR.strCuentaAbono,'0'),'-','') ELSE REPLACE(ISNULL(@strCuentaAbono,'0'),'-','') END 
		AND CR.intES = CASE ISNULL(@intES,-1) WHEN -1 THEN CR.intES ELSE ISNULL(@intES,-1) END

	  ORDER BY 
		CASE WHEN @Sort = 'strNombreArea DESC'	   THEN A.strNombre		  					  					END DESC,
		CASE WHEN @Sort = 'strNombreArea ASC'	   THEN A.strNombre		  					  					END ASC,
		CASE WHEN @Sort = 'strInsumoIni DESC'	   THEN CR.strInsumoIni	  					  					END DESC,
		CASE WHEN @Sort = 'strInsumoIni ASC'	   THEN CR.strInsumoIni	  					  					END ASC,
		CASE WHEN @Sort = 'NombreInsumoIni DESC'   THEN ISNULL(ArtIni.strNombre,'INSUMO N.E') 					END DESC,
		CASE WHEN @Sort = 'NombreInsumoIni ASC'	   THEN ISNULL(ArtIni.strNombre,'INSUMO N.E') 					END ASC,
		CASE WHEN @Sort = 'strInsumoFin DESC'	   THEN CR.strInsumoFin 					  					END DESC,
		CASE WHEN @Sort = 'strInsumoFin ASC'	   THEN CR.strInsumoFin 					  					END ASC,
		CASE WHEN @Sort = 'NombreInsumoFin DESC'   THEN ISNULL(ArtFin.strNombre,'INSUMO N.E') 					END DESC,
		CASE WHEN @Sort = 'NombreInsumoFin ASC'    THEN ISNULL(ArtFin.strNombre,'INSUMO N.E') 					END ASC,
		CASE WHEN @Sort = 'strCuentaCargo DESC'    THEN CR.strCuentaCargo  					  					END DESC,
		CASE WHEN @Sort = 'strCuentaCargo ASC'	   THEN CR.strCuentaCargo  					  					END ASC,
		CASE WHEN @Sort = 'NombreCuentaCargo DESC' THEN CtaCargo.strNombre 					  					END DESC,
		CASE WHEN @Sort = 'NombreCuentaCargo ASC'  THEN CtaCargo.strNombre 					  					END ASC,
		CASE WHEN @Sort = 'strCuentaAbono DESC'	   THEN CR.strCuentaAbono  					  					END DESC,
		CASE WHEN @Sort = 'strCuentaAbono ASC'	   THEN CR.strCuentaAbono  					  					END ASC,
		CASE WHEN @Sort = 'NombreCuentaAbono DESC' THEN CtaAbono.strNombre 					  					END DESC,
		CASE WHEN @Sort = 'NombreCuentaAbono ASC'  THEN CtaAbono.strNombre 					  					END ASC,
		CASE WHEN @Sort = 'NombreEstatus DESC'	   THEN CASE WHEN CR.intES = 1 THEN 'Entrada' ELSE 'Salida' END END DESC,
		CASE WHEN @Sort = 'NombreEstatus ASC'	   THEN CASE WHEN CR.intES = 1 THEN 'Entrada' ELSE 'Salida' END END ASC
	,CR.intCuentaRet DESC

	SELECT @iNumTotRecords = MAX(row)
	  FROM #Temp_tbCuentasRet

	IF @NumRecords = 0
	BEGIN
		SELECT	@finalRow = @iNumTotRecords,
				@startRow = 1,
				@iNumTotPages = 1
	END
	ELSE
	BEGIN
		SELECT @iNumTotPages = (@iNumTotRecords / @NumRecords)

		SELECT @fNumPages = ((@iNumTotRecords * 1.0) / (@NumRecords * 1.0))

		IF (@fNumPages - @iNumTotPages) > 0.0
		BEGIN
			SELECT @iNumTotPages = @iNumTotPages + 1
		END

		SELECT @finalRow = ((@NumPage + 1) * @NumRecords)

		SELECT @startRow = (@finalRow - @NumRecords + 1)
	END

	SELECT	@TotalRows	= ISNULL(@iNumTotRecords,0),
			@TotalPage	= ISNULL(@iNumTotPages,0)

	SET @Err = @@Error


	--#Temp_tbCuentasRet(row,intEmpresa,intCuentaRet,intArea,strInsumoIni,NombreInsumoIni,strInsumoFin,NombreInsumoFin,strCuentaCargo,NombreCuentaCargo,strCuentaAbono,NombreCuentaAbono,NombreEstatus,intES)
	SELECT intEmpresa,intCuentaRet,intArea,strNombreArea,strInsumoIni,NombreInsumoIni,strInsumoFin,NombreInsumoFin,strCuentaCargo,NombreCuentaCargo,strCuentaAbono,NombreCuentaAbono,NombreEstatus,intES
	FROM #Temp_tbCuentasRet
	WHERE row between @startRow AND @finalRow
	
	DROP TABLE #Temp_tbCuentasRet

	SET @Err = @@Error

	IF (@Err > 0)
	BEGIN
		SELECT @MsgErr = 'Ocurrio un error no reconocido!',
				@Err = 1000000

		GOTO ExistsError
	END

	SET NOCOUNT OFF

	RETURN @Err

ExistsError:
	IF (@@TRANCOUNT > 0)
		ROLLBACK

	SET NOCOUNT OFF

	RAISERROR (@MsgErr, 16, 1)

	RETURN @Err
END
	
	SET NOCOUNT OFF
GO 

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbCuentasRet_Sel Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbCuentasRet_Sel Error on Creation'
END
GO