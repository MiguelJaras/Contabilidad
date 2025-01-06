
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbEstructuraEnc_Help')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbEstructuraEnc_Help
	PRINT N'Drop Procedure : dbo.usp_tbEstructuraEnc_Help - Succeeded !!!'
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
---  28/06/2013  RRH    Create procedure                                         ---
------------------------------------------------------------------------------------

CREATE PROCEDURE dbo.usp_tbEstructuraEnc_Help
(
	@intEmpresa			VARCHAR(50),
	@intSucursal		VARCHAR(50),
	@intVersion			INT,
	@strParametros		VARCHAR(500),
	@intTipo			INT = 0	
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
        SET @returnValue = 'SELECT DISTINCT E.intClave,
		-- E.strTipoPoliza,
		E.strDescripciónPoliza AS Póliza,
		-- E.bitAutomatica,
		-- E.intMovto,
		P.strNombre AS [Nombre Póliza],
		M.strNombre AS [Tipo Movto]
	FROM VetecMarfilAdmin..tbEstructuraEnc E
	LEFT JOIN VetecMarfilAdmin..tbTipoMovto M ON E.intMovto = M.intMovto AND M.intEmpresa = E.intEmpresa
	LEFT JOIN VetecMarfilAdmin..tbTiposPoliza P ON E.strTipoPoliza = P.strTipoPoliza  AND E.intEmpresa = P.intEmpresa
	WHERE E.intEmpresa = CASE '+ISNULL(@intEmpresa,0)+' WHEN 0 THEN E.intEmpresa ELSE '+ISNULL(@intEmpresa,0)+' END
	AND E.intClave = CASE '+ISNULL(@strParameter1,0)+' WHEN 0 THEN E.intClave ELSE '+ISNULL(@strParameter1,0)+' END'
	END 

	IF (@intVersion = 1)
	BEGIN
        SET @returnValue = 'SELECT intMovTo,strNombre FROM VetecMarfilAdmin..tbTipoMovto
	WHERE intEmpresa = CASE '+ISNULL(@intEmpresa,0)+' WHEN 0 THEN intEmpresa ELSE '+ISNULL(@intEmpresa,0)+' END
	AND intMovTo = CASE '+ISNULL(@strParameter1,0)+' WHEN 0 THEN intMovTo ELSE '+ISNULL(@strParameter1,0)+' END'
	END 

	IF (@intVersion = 2)
	BEGIN
        SET @returnValue = 'SELECT DISTINCT strTipoPoliza,strNombre 
		FROM VetecMarfilAdmin..tbTiposPoliza
		WHERE intEmpresa = CASE '+ISNULL(@intEmpresa,0)+' WHEN 0 THEN intEmpresa ELSE '+ISNULL(@intEmpresa,0)+' END
		AND strTipoPoliza = CASE '''+ISNULL(@strParameter1,0)+''' WHEN ''0'' THEN strTipoPoliza ELSE '''+ISNULL(@strParameter1,0)+''' END'
	END  
	 
	IF(@intTipo = 0)
		SELECT @returnValue
	ELSE
		EXEC sp_executesql @returnValue

	SET NOCOUNT OFF
END
GO 

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbEstructuraEnc_Help Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbEstructuraEnc_Help Error on Creation'
END
GO