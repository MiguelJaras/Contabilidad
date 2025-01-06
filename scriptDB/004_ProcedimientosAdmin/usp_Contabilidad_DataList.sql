USE VetecMarfilAdmin

/****** Object:  StoredProcedure [dbo.usp_Contabilidad_DataList]    Script Date: 12/8/2009 10:45:19 AM ******/
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_Contabilidad_DataList')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_Contabilidad_DataList
	PRINT N'Drop Procedure : dbo.usp_Contabilidad_DataList - Succeeded !!!'
END
GO

------------------------------------------------------------------------------------
---   Aplicacion: Marfil.		                                                 ---
---        Autor: Rubén Mora Martínez                                            ---
---  Descripcion: Obtiene un registro de la tabla:  Tareas	                     ---
---                                                                              ---
------------------------------------------------------------------------------------
---    Fecha     Autor  Comentario                                               ---
---  ----------  -----  -------------------------------------------------------  ---
---  12/11/2010  RMM    Create procedure                                         ---
------------------------------------------------------------------------------------

CREATE PROCEDURE dbo.usp_Contabilidad_DataList
(      
	@intEmpresa		int,
	@intSucursal	int,
	@intList		int
)
WITH ENCRYPTION 
AS
BEGIN
		
	SET NOCOUNT ON

	CREATE TABLE #List(Id varchar(100), strNombre VARCHAR(200))

	IF(@intList = 1)
	BEGIN
		INSERT INTO #List(Id, strNombre)
		SELECT DISTINCT intEjercicio, intEjercicio
		FROM tbPolizasEnc
		--WHERE intEmpresa = @intEmpresa
		ORDER BY 1 DESC
	END

	IF(@intList = 2)
	BEGIN
		INSERT INTO #List(Id, strNombre)
		SELECT DISTINCT intColonia, strNombre
		FROM VetecMarfil ..tbColonia 
		ORDER BY strNombre 
	END

	IF(@intList = 3)
	BEGIN
		INSERT INTO #List(Id, strNombre)
		SELECT DISTINCT intTipoCredito, strNombre
		FROM VetecMarfil ..tbTipoCredito 
		ORDER BY strNombre 
	END

	IF(@intList = 4)
	BEGIN
		INSERT INTO #List(Id, strNombre)
		SELECT DISTINCT intTipoGrupoContable, strNombre
		FROM VetecMarfilAdmin..tbTiposGruposContables 
		ORDER BY strNombre 

	END

	IF(@intList = 5)
	BEGIN
		INSERT INTO #List(Id, strNombre)
		SELECT intTipoMoneda,strNombre 
		FROM VetecMarfilAdmin..tbTiposMoneda
		ORDER BY strNombre
	END

	IF(@intList = 6)
	BEGIN
		INSERT INTO #List(Id, strNombre)
		SELECT strTipoRubro,strNombre as Nombre 
		FROM VetecMarfilAdmin..tbRubrosTipos 
		ORDER BY strNombre
	END
	
	IF(@intList = 7)
	BEGIN
		SELECT intConceptoPago AS id,strClaveCP + ' ' + strNombre AS strNombre
		FROM VetecMarfil..tbConceptoPago 
		WHERE intEmpresa =  @intEmpresa
		ORDER BY CONVERT(int,strClaveCP)
	END
	ELSE
	BEGIN
		SELECT Id, strNombre 
		FROM #List 
		ORDER BY Id
	END

	DROP TABLE #List

	SET NOCOUNT OFF
	
END
GO

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_Contabilidad_DataList Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_Contabilidad_DataList Error on Creation'
END
GO

