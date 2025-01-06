IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbCuentas_Help')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbCuentas_Help
	PRINT N'Drop Procedure : dbo.usp_tbCuentas_Help - Succeeded !!!'
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
---  09/07/2013  RRH    Create procedure                                         ---
------------------------------------------------------------------------------------

CREATE PROCEDURE dbo.usp_tbCuentas_Help
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
        SET @returnValue = 'SELECT  
		 C.strCuenta
		,C.strNombre 
		,TGC.strNombre AS Tipo_GrupoContable 
		,GC.strNombre AS GrupoContable 
			FROM VetecMarfilAdmin..tbRubros C
		INNER JOIN tbTiposGruposContables TGC ON TGC.intTipoGrupoContable = C.intTipoGrupoContable
		INNER JOIN tbGruposContables GC ON GC.intGrupoContable =  C.intGrupoContable AND TGC.intTipoGrupoContable = GC.intTipoGrupoContable
			WHERE C.intEmpresa = CASE '+ISNULL(@intEmpresa,0)+' WHEN 0 THEN C.intEmpresa ELSE '+ISNULL(@intEmpresa,0)+' END
			AND  C.strCuenta = CASE '''+ISNULL(@strParameter1,0)+''' WHEN ''0'' THEN C.strCuenta ELSE '''+ISNULL(@strParameter1,'0')+''' END'
	END  

	IF (@intVersion = 1)
	BEGIN
        SET @returnValue = 'SELECT strCuenta as Cuenta,strNombre as Descripcion FROM VetecMarfilAdmin..tbCuentas
		WHERE intEmpresa = CASE '+ISNULL(@intEmpresa,0)+' WHEN 0 THEN intEmpresa ELSE '+ISNULL(@intEmpresa,0)+' END
		AND strCuenta = CASE '''+ISNULL(@strParameter1,0)+''' WHEN ''0'' THEN strCuenta ELSE '''+ISNULL(@strParameter1,0)+''' END'
	END 

	IF (@intVersion = 2)
	BEGIN
        SET @returnValue = 'SELECT intTipoGrupoContable,strNombre FROM VetecMarfilAdmin..tbGruposContables'
	END

	IF (@intVersion = 3)
	BEGIN
        SET @returnValue = 'SELECT intTipoGrupoContable,strNombre FROM VetecMarfilAdmin..tbTiposGruposContables'
	END

	IF (@intVersion = 4)
	BEGIN
        SET @returnValue = 'SELECT LEFT(strCuenta,4) AS Cuenta,ISNULL(RIGHT(LEFT(strCuenta,8),4),0) AS SubCuenta,
		CASE WHEN intNivel = 3 THEN RIGHT(strCuenta,4) ELSE '''' END AS SubSubCuenta,
		strNombre FROM VetecMarfilAdmin..tbCuentas
		WHERE intEmpresa = CASE '+ISNULL(@intEmpresa,0)+' WHEN 0 THEN intEmpresa ELSE '+ISNULL(@intEmpresa,0)+' END
		AND strCuenta = CASE '''+ISNULL(@strParameter1,0)+''' WHEN ''0'' THEN strCuenta ELSE '''+ISNULL(@strParameter1,0)+''' END'
	END 

	IF (@intVersion = 5)
	BEGIN
        SET @returnValue = 'SELECT LEFT(strCuenta,4) AS Cuenta,
		CASE WHEN LEN(strCuenta) > 4 THEN CONVERT(VARCHAR,CONVERT(int,SUBSTRING(strCuenta,5,4))) ELSE '''' END AS SubCuenta,
		CASE WHEN LEN(strCuenta) > 8 THEN CONVERT(VARCHAR,CONVERT(int,SUBSTRING(strCuenta,9,4))) ELSE '''' END AS SubSubCuenta,
		strNombre AS Nombre 
		FROM VetecMarfilAdmin..tbCuentas
		WHERE intEmpresa = CASE '+ISNULL(@intEmpresa,0)+' WHEN 0 THEN intEmpresa ELSE '+ISNULL(@intEmpresa,0)+' END'
	END 
	 
	SELECT @returnValue

	SET NOCOUNT OFF
END
GO 

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbCuentas_Help Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbCuentas_Help Error on Creation'
END
GO