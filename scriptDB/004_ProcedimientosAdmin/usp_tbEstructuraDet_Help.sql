
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbEstructuraDet_Help')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbEstructuraDet_Help
	PRINT N'Drop Procedure : dbo.usp_tbEstructuraDet_Help - Succeeded !!!'
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

CREATE PROCEDURE dbo.usp_tbEstructuraDet_Help
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
        SET @returnValue = 'SELECT strCuenta,strNombre FROM tbCuentas
		WHERE intEmpresa = CASE '+ISNULL(@intEmpresa,0)+' WHEN 0 THEN intEmpresa ELSE '+ISNULL(@intEmpresa,0)+' END
		AND strCuenta = CASE '''+ISNULL(@strParameter1,0)+''' WHEN ''0'' THEN strCuenta ELSE '''+ISNULL(@strParameter1,0)+''' END'
	END

	IF (@intVersion = 1)
	BEGIN
		SET @returnValue = 'SELECT Concepto,Concepto FROM tbParametrosPoliza_Conceptos ORDER BY intOrden'
	END 

	IF (@intVersion = 2)
	BEGIN
        SET @returnValue = 'SELECT Base,Base FROM tbParametrosPoliza_Bases ORDER BY intOrden'
	END 

	IF (@intVersion = 3)
	BEGIN
        SET @returnValue = 'SELECT strParametro,strDescripcion FROM tbParametros'
	END  

	--print @returnValue
	EXEC sp_executesql @returnValue

	SET NOCOUNT OFF
END
GO 

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbEstructuraDet_Help Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbEstructuraDet_Help Error on Creation'
END
GO