
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbPolizasDet_Help')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbPolizasDet_Help
	PRINT N'Drop Procedure : dbo.usp_tbPolizasDet_Help - Succeeded !!!'
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
---  02/07/2013  RRH    Create procedure                                         ---
------------------------------------------------------------------------------------

CREATE PROCEDURE dbo.usp_tbPolizasDet_Help
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

	IF (@intVersion = 1)
	BEGIN
        SET @returnValue = 'SELECT strClave,strNombre FROM VetecMarfil..tbObra
		WHERE intEmpresa = '+ISNULL(@intEmpresa,0) + '
		ORDER BY strClave'
	END

	IF (@intVersion = 2)
	BEGIN
        SET @returnValue = 'SELECT intArea,strNombre FROM VetecMarfil..tbArea
		WHERE intEmpresa = '+ISNULL(@intEmpresa,0) + '
		ORDER BY CONVERT(int,intArea)'
	END

	IF (@intVersion = 3)
	BEGIN
        SET @returnValue = 'SELECT intColonia,strNombre FROM VetecMarfil..tbColonia
		ORDER BY CONVERT(int,intColonia)'
	END	

	IF (@intVersion = 4)
	BEGIN
        SET @returnValue = 'SELECT strPoliza AS Poliza, CONVERT(VARCHAR,datFecha,103) as Fecha, dblCargos as Cargos, strDescripcion as Descripcion 
		FROM VetecMarfilAdmin..tbPolizasEnc
		WHERE intEmpresa = '+ISNULL(@intEmpresa,0) + '
		AND strTipoPoliza = '''+ISNULL(@strParameter1,0) + '''
		AND intEjercicio = '+ISNULL(@strParameter2,0) + '
		AND intMes = '+ISNULL(@strParameter3,0) + '		
		ORDER BY intFolioPoliza'
	END	

	IF (@intVersion = 5)
	BEGIN
        SET @returnValue = 'SELECT intObra as #,strClave as Obra,strNombre as Nombre FROM VetecMarfil..tbObra
		WHERE intEmpresa = '+ISNULL(@intEmpresa,0) + '
		ORDER BY strClave'
	END

	IF (@intVersion = 6)
	BEGIN
		IF(@intEmpresa = 2)
		BEGIN		
			SET @returnValue = 'SELECT CONVERT(VARCHAR, C.intProspecto) as intProspecto, C.strNombre AS Prospecto
			FROM VetecMarfil.dbo.tbClientes C
			WHERE C.intProspecto >='+ISNULL(@strParameter1,0) + '
			AND intEmpresa = 2
			ORDER BY C.intProspecto'
		END

		IF(@intEmpresa = 3)
		BEGIN
			SET @returnValue = 'SELECT strClave as intProspecto, C.strNombre AS Prospecto
			FROM VetecMarfil.dbo.tbClientes C
			WHERE C.intProspecto >='+ISNULL(@strParameter1,0) + '
			AND intEmpresa in(2,3)
			ORDER BY C.intProspecto'
		END		

        IF(@intEmpresa NOT IN(2,3))
		BEGIN
			SET @returnValue = 'SELECT CONVERT(VARCHAR, C.strClave) as intProspecto, C.strNombre AS Prospecto
			FROM VetecMarfil.dbo.tbClientes C
			WHERE C.intProspecto >='+ISNULL(@strParameter1,0) + '
			AND intEmpresa ='+ISNULL(@intEmpresa,0) + '
			ORDER BY C.strClave'
		END
	END

	IF (@intVersion = 7)
	BEGIN
		SET @returnValue = 'SELECT CONVERT(VARCHAR, OCE.intFolio) AS Folio, dbo.f_padCarIzq(''$'' + CONVERT(VARCHAR, CONVERT(DECIMAL(16,2), OCE.dblTotal)), 12, '''')  AS total , OCE.strObservaciones as Observaciones
		FROM VetecMarfil.dbo.tbOrdenCompraEnc OCE
		WHERE OCE.intFolio >='+ISNULL(@strParameter1,0) + '
		AND intEmpresa ='+ISNULL(@intEmpresa,0) + '
		ORDER BY OCE.intFolio'
	END

	IF (@intVersion = 8)
	BEGIN
		SET @returnValue = 'SELECT intProveedor as Proveedor, strNombre AS Nombre
		FROM VetecMarfilAdmin.dbo.tbProveedores 
		WHERE intEmpresa ='+ISNULL(@intEmpresa,0) + '
		ORDER BY intProveedor'
	END

	IF (@intVersion = 9)
	BEGIN
        SET @returnValue = 'SELECT strPoliza AS Poliza, CONVERT(VARCHAR,datFecha,103) as Fecha, dblCargos as Cargos, strDescripcion as Descripcion 
		FROM VetecMarfilAdmin..tbPolizasEnc
		WHERE intEmpresa = '+ISNULL(@intEmpresa,0) + '
		AND intEjercicio = '+ISNULL(@strParameter1,0) + '	
		ORDER BY intFolioPoliza'
	END	
	
	SELECT @returnValue

	SET NOCOUNT OFF
END
GO 

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbPolizasDet_Help Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbPolizasDet_Help Error on Creation'
END
