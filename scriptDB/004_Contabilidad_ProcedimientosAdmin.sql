
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.fn_tbPolizasDet_Close')
	AND OBJECTPROPERTY(id,N'IsScalarFunction') = 1)
BEGIN
    DROP FUNCTION dbo.fn_tbPolizasDet_Close
    PRINT 'Drop Function : dbo.fn_tbPolizasDet_Close - Succeeded !!!'
END
GO

------------------------------------------------------------------------------------
---  Aplicacion:  PM.															 ---
---        Autor: Ruben Mora Martinez/ RMM										 ---
---  Descripcion: Return number of week in current month                         ---
------------------------------------------------------------------------------------
---    Fecha     Autor  Comentario                                               ---
---  ----------  -----  -------------------------------------------------------  ---
---  2011-07-29  RMM    Creacion                                                 ---
------------------------------------------------------------------------------------
CREATE FUNCTION dbo.fn_tbPolizasDet_Close(@intEmpresa INT,@intEjercicio INT,@intMes INT,@intModulo INT)              
RETURNS int   
AS        
BEGIN  
		DECLARE @Value int

		SELECT @Value = ISNULL((SELECT Convert(int,bCerrado) 
								FROM tbCerrarPeriodo 
								WHERE intEmpresa = @intEmpresa 
								AND intEjercicio = @intEjercicio 
								AND intMes = @intMes 
								AND intModulo = @intModulo),0)

		RETURN @Value     
END 
GO

-- Display the status of Proc creation
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.fn_tbPolizasDet_Close')
	AND OBJECTPROPERTY(id,N'IsScalarFunction') = 1)
BEGIN
    PRINT 'Function Creation: dbo.fn_tbPolizasDet_Close - Succeeded !!!'
END
ELSE
BEGIN
    PRINT 'Function Creation: dbo.fn_tbPolizasDet_Close - Error on Creation'
END
GO


BEGIN TRAN

CREATE TABLE [dbo].[tbCuentasRetTemp1](
	intCuentaRet INT NOT NULL IDENTITY(1,1),
	[intEmpresa] INT NOT NULL, 
	[intArea] [int] NULL,
	[strInsumoIni] [varchar](100) NULL,
	[strInsumoFin] [varchar](100) NULL,
	[strCuentaCargo] [varchar](100) NULL,
	[strCuentaAbono] [varchar](100) NULL,
	[intES] [int] NULL,
	[strUsuario] [varchar](50) NULL,
	[datFechaModificado] [datetime] NULL 
) 

CREATE TABLE [dbo].[tbCuentasRetTemp2](
	[intEmpresa] INT NOT NULL,
	intCuentaRet INT NOT NULL,  
	[intArea] [int] NULL,
	[strInsumoIni] [varchar](100) NULL,
	[strInsumoFin] [varchar](100) NULL,
	[strCuentaCargo] [varchar](100) NULL,
	[strCuentaAbono] [varchar](100) NULL,
	[intES] [int] NULL,
	[strUsuario] [varchar](50) NULL,
	[datFechaModificado] [datetime] NULL
	CONSTRAINT [PK_temp] PRIMARY KEY CLUSTERED 
	(
		[intEmpresa] ASC,
		intCuentaRet ASC
	)
)  

CREATE TABLE tempID( 
intCuentaRet INT NOT NULL,
intEmpresa INT NOT NULL,
intOldID INT NOT NULL
)
 
INSERT INTO [tbCuentasRetTemp1]
SELECT * FROM tbCuentasRet 

DECLARE @intFlag INT
SET @intFlag = 1 

SELECT  ROW_NUMBER() OVER(ORDER BY intEmpresa) AS ID ,intEmpresa into #tempEmpresas
FROM tbEmpresas 
GROUP BY  [intEmpresa]  

WHILE (@intFlag <= (SELECT COUNT(*) FROM #tempEmpresas) )
BEGIN  
	INSERT INTO tempID
	SELECT  ROW_NUMBER() OVER(ORDER BY intCuentaRet),[intEmpresa] ,intCuentaRet 
	FROM [tbCuentasRetTemp1]
	WHERE intEmpresa = (SELECT intEmpresa FROM #tempEmpresas WHERE ID = @intFlag)
	GROUP BY intCuentaRet,[intEmpresa] 
		SET @intFlag = @intFlag + 1
		CONTINUE; 
END     

INSERT INTO [tbCuentasRetTemp2]
SELECT CR.intEmpresa,
TP.intCuentaRet,
CR.intArea,
CR.strInsumoIni,
CR.strInsumoFin,
CR.strCuentaCargo,
CR.strCuentaAbono,
CR.intES,
CR.strUsuario,
datFechaModificado FROM [tbCuentasRetTemp1] CR
INNER JOIN tempID TP ON TP.intEmpresa = CR.intEmpresa  AND TP.intOldID = CR.intCuentaRet
ORDER BY CR.intEmpresa,TP.intCuentaRet  

DELETE FROM tbCuentasRet

DROP TABLE tbCuentasRet

CREATE TABLE [dbo].tbCuentasRet(
	[intEmpresa] INT NOT NULL,
	intCuentaRet INT NOT NULL,  
	[intArea] [int] NULL,
	[strInsumoIni] [varchar](100) NULL,
	[strInsumoFin] [varchar](100) NULL,
	[strCuentaCargo] [varchar](100) NULL,
	[strCuentaAbono] [varchar](100) NULL,
	[intES] [int] NULL,
	[strUsuario] [varchar](50) NULL,
	[datFechaModificado] [datetime] NULL
	CONSTRAINT [PK_tbCuentasRet] PRIMARY KEY CLUSTERED 
(
	[intEmpresa] ASC,
	intCuentaRet ASC
)
) 

INSERT INTO tbCuentasRet
SELECT * FROM [tbCuentasRetTemp2]

SELECT * FROM tbCuentasRet

DROP TABLE tbCuentasRetTemp1
DROP TABLE tbCuentasRetTemp2
DROP TABLE tempID
DROP TABLE #tempEmpresas

--COMMIT TRAN

--ROLLBACK TRAN
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
---  Aplicacion:  PM.                                                      ---
---  RBDMS:       Miscrosoft SQL Server 2005.                               ---
---  Archivo:     004_PM_Procedimientos.sql                                ---
---  Descripcion: Script para la creacion de los procedimientos             ---
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
---                                                                         ---
---  020.-                                                                  ---
---                                                                         ---
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------


-- Cambie el nombre la de base de datos
use VetecMarfilAdmin
go


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
		WHERE intEmpresa = @intEmpresa
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

	SELECT Id, strNombre 
	FROM #List 
	ORDER BY Id

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

/****** Object:  StoredProcedure [dbo.usp_Contabilidad_DataValue]    Script Date: 12/8/2009 10:45:19 AM ******/
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_Contabilidad_DataValue')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_Contabilidad_DataValue
	PRINT N'Drop Procedure : dbo.usp_Contabilidad_DataValue - Succeeded !!!'
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

CREATE PROCEDURE dbo.usp_Contabilidad_DataValue
(      
	@intEmpresa		int,
	@intSucursal	int,
	@intTypeValue	int,
	@intValue       int
)
WITH ENCRYPTION 
AS
BEGIN
		
	SET NOCOUNT ON

	DECLARE @Value VARCHAR(200)
	SET @Value = ''

	IF(@intTypeValue = 1)
	BEGIN
		SELECT @Value = YEAR(GETDATE())
	END

	SELECT @Value AS strValue

	SET NOCOUNT OFF
	
END
GO

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_Contabilidad_DataValue Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_Contabilidad_DataValue Error on Creation'
END
GO

/****** Object:  StoredProcedure [dbo.usp_Contabilidad_DataList]    Script Date: 12/8/2009 10:45:19 AM ******/
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_SizeObra')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_SizeObra
	PRINT N'Drop Procedure : dbo.usp_SizeObra - Succeeded !!!'
END
GO
-- =============================================
-- Author:		IASD
-- Create date: 19/08/2013
-- Description:	Obtiene SizeObra
-- =============================================
create  PROCEDURE [dbo].[usp_SizeObra]
	@intEmpresa		int,
	@ObraIni		varchar(20),
	@ObraFin		varchar(20)
AS
BEGIN

	DECLARE @strCCIni VarChar(60) 
	DECLARE @strCCFin VarChar(60) 
	SET @strCCIni  = @ObraIni 
	SET @strCCFin = @ObraFin 

	IF(@strCCIni = '0') 
		SELECT TOP 1 @strCCIni = strClave 
			FROM VetecMarfil..tbObra 
			WHERE intEmpresa = @intEmpresa
			order by strClave ASC  

	IF(@strCCFin = '0') 
		SELECT TOP 1 @strCCFin = strClave 
			FROM VetecMarfil..tbObra 
			WHERE intEmpresa = @intEmpresa
			order by strClave DESC 

	SELECT DISTINCT intColonia,strColonia 
	FROM VetecMarfil.dbo.fn_ColoniasObra(@strCCIni,@strCCFin,@intEmpresa) 

	SET NOCOUNT OFF
END
GO

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_SizeObra Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_SizeObra Error on Creation'
END
GO



IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbCerrarPeriodo_Val')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbCerrarPeriodo_Val
	PRINT N'Drop Procedure : dbo.usp_tbCerrarPeriodo_Val - Succeeded !!!'
END
GO


------------------------------------------------------------------------------------
---																				 ---
---        Autor: Ingrid Soto		                                             ---
---  Descripcion: Valida el CerrarPeriodo										 ---
---                                                                              ---
------------------------------------------------------------------------------------
---    Fecha     Autor  Comentario                                               ---
---  ----------  -----  -------------------------------------------------------  ---
---  09/09/2013  IASD    Create procedure                                         ---
------------------------------------------------------------------------------------
create
PROCEDURE [dbo].[usp_tbCerrarPeriodo_Val]
(
    @intEmpresa int,
	@intEjercicio int,
	@intMes int

) AS
BEGIN
SET NOCOUNT ON
              

	DECLARE @intCerrado INT 

	SELECT 
		@intCerrado = Convert(int,bCerrado) 
	FROM tbCerrarPeriodo 
	WHERE intEmpresa = @intEmpresa
	AND intEjercicio = @intEjercicio
	AND intMes = @intMes
	AND intModulo = 5 

SELECT ISNULL(@intCerrado,0) 


END
GO 

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbCerrarPeriodo_Val Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbCerrarPeriodo_Val Error on Creation'
END
GO



IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbColonia_Sel')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbColonia_Sel
	PRINT N'Drop Procedure : dbo.usp_tbColonia_Sel - Succeeded !!!'
END
GO

------------------------------------------------------------------------------------
---																				 ---
---        Autor: Ingrid Soto		                                             ---
---  Descripcion: Consulta en tbColonia											 ---
---                                                                              ---
------------------------------------------------------------------------------------
---    Fecha     Autor  Comentario                                               ---
---  ----------  -----  -------------------------------------------------------  ---
---  17/09/2013  IASD    Create procedure                                         ---
------------------------------------------------------------------------------------
CREATE 
PROCEDURE [dbo].[usp_tbColonia_Sel]

AS
BEGIN
	SET NOCOUNT ON
                
				SELECT
					ISNULL(intEmpresa,0) AS intEmpresa,
					ISNULL(intSucursal,0) AS intSucursal,
					ISNULL(intColonia,0) AS intColonia,
					ISNULL(strNombre,'') AS  strNombre,
					ISNULL(strNombreCorto,'') AS strNombreCorto,
					ISNULL(dblFactorMercado,0) AS dblFactorMercado,
					ISNULL(dblPorcentajeIndirecto,0) AS dblPorcentajeIndirecto,
					ISNULL(strTipo,'') AS strTipo,
					ISNULL(strUsuarioAlta,'') AS strUsuarioAlta,
					ISNULL(strMaquinaAlta,'') AS strMaquinaAlta,
					ISNULL(datFechaAlta,'01/01/1900') AS datFechaAlta,
					ISNULL(strUsuarioMod,'') AS strUsuarioMod,
					ISNULL(strMaquinaMod,'') AS strUsuarioMod,
					ISNULL(datFechaMod,'01/01/1900') AS datFechaMod,
					ISNULL(intTipoVivienda,0) AS intTipoVivienda,
					ISNULL(intMunicipio,0) AS intMunicipio,
					ISNULL(intEstado,0) AS intEstado ,
					ISNULL(strCP,'') AS strCP,
					ISNULL(intPuntoTamanio,0) AS intPuntoTamanio,
					ISNULL(intArea,0) AS  intArea,
					ISNULL(intActivo,0) AS  intActivo,
					ISNULL(intEmpleado,0) AS intEmpleado,
					ISNULL(strAliasSQL,'') AS  strAliasSQL,
					ISNULL(strAliasResumenSQL,'') AS  strAliasResumenSQL
                FROM   VetecMarfil..tbColonia A
				ORDER BY strNombre ASC
END
GO 

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbColonia_Sel Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbColonia_Sel Error on Creation'
END
GO


IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbConciliaciones_Help')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbConciliaciones_Help
	PRINT N'Drop Procedure : dbo.usp_tbConciliaciones_Help - Succeeded !!!'
END
GO

------------------------------------------------------------------------------------
---   Aplicacion: RMM.		                                                     ---
---        Autor: Ruben Mora Martinez                                            ---
---  Descripcion: Obtiene un registro de la tabla:  tbCotizacion                 ---
---                                                                              ---
------------------------------------------------------------------------------------
---    Fecha     Autor  Comentario                                               ---
---  ----------  -----  -------------------------------------------------------  ---
---  22/08/2011  RMM    Create procedure                                         ---
------------------------------------------------------------------------------------

CREATE PROCEDURE usp_tbConciliaciones_Help
(
	@intEmpresa			VARCHAR(50),
	@intSucursal		VARCHAR(50),
	@intVersion			int,
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
	DECLARE @returnValue VARCHAR(2000)
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
	
	IF (@intVersion = 1)
	BEGIN
		SET @returnValue = 'SELECT intCuentaBancaria as #,strNombre as Nombre 
		FROM VetecMarfilAdmin..tbCuentasBancarias
		WHERE intEmpresa = ' + @intEmpresa 
	END

	SELECT @returnValue

	SET NOCOUNT OFF
END
GO 

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbConciliaciones_Help Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbConciliaciones_Help Error on Creation'
END
GO













IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbCuentasRet_Del')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbCuentasRet_Del
	PRINT N'Drop Procedure : dbo.usp_tbCuentasRet_Del - Succeeded !!!'
END
GO

------------------------------------------------------------------------------------
---																				 ---
---        Autor: Ramon Rios Hernandez                                           ---
---  Descripcion: DELETE en tbCuentasRet										 ---
---                                                                              ---
------------------------------------------------------------------------------------
---    Fecha     Autor  Comentario                                               ---
---  ----------  -----  -------------------------------------------------------  ---
---  23/07/2013  RRH    Create procedure                                         ---
------------------------------------------------------------------------------------
CREATE
PROCEDURE [DBO].[usp_tbCuentasRet_Del]
(
   @intEmpresa	   INT,
   @intCuentaRet   INT
) 
AS
BEGIN
	SET NOCOUNT ON
                
				DELETE
                  FROM tbCuentasRet
                 WHERE intEmpresa = @intEmpresa
                   AND intCuentaRet = @intCuentaRet

                SELECT @intCuentaRet 

	SET NOCOUNT OFF  
END

GO
-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbCuentasRet_Del Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbCuentasRet_Del Error on Creation'
END
GO

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbCuentasRet_Fill')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbCuentasRet_Fill
	PRINT N'Drop Procedure : dbo.usp_tbCuentasRet_Fill - Succeeded !!!'
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
---  12/08/2013  RRH    Create procedure                                         ---
------------------------------------------------------------------------------------
CREATE PROCEDURE usp_tbCuentasRet_Fill
(
	@intEmpresa					  INT,
	@intCuentaRet				  INT 
)				
AS
				
    BEGIN
    SET NOCOUNT ON
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
 
 END 
	SET NOCOUNT OFF
GO 

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbCuentasRet_Fill Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbCuentasRet_Fill Error on Creation'
END
GOIF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbCuentasRet_Help')
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
 
	print @returnValue
	EXEC sp_executesql @returnValue

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
GOIF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbCuentasRet_Save')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbCuentasRet_Save
	PRINT N'Drop Procedure : dbo.usp_tbCuentasRet_Save - Succeeded !!!'
END
GO 
------------------------------------------------------------------------------------
---																				 ---
---        Autor: Ramon Rios Hernandez                                           ---
---  Descripcion: Inserta en tbCuentasRet										 ---
---                                                                              ---
------------------------------------------------------------------------------------
---    Fecha     Autor  Comentario                                               ---
---  ----------  -----  -------------------------------------------------------  ---
---  23/07/2013  RRH    Create procedure                                         ---
------------------------------------------------------------------------------------
CREATE
PROCEDURE [DBO].[usp_tbCuentasRet_Save]
(
    @intEmpresa 	INT,
	@intCuentaRet	INT,
	@intArea		INT,
	@strInsumoIni	VARCHAR(100),
	@strInsumoFin	VARCHAR(100),
	@strCuentaCargo VARCHAR(100),
	@strCuentaAbono VARCHAR(100),
	@intES			INT,
	@strUsuario		VARCHAR(50) 

) AS
        BEGIN
           SET NOCOUNT ON
                IF NOT EXISTS
                        (SELECT *
                           FROM tbCuentasRet
                          WHERE intEmpresa    = @intEmpresa
						    AND intCuentaRet = @intCuentaRet
                        )
                        BEGIN
                                IF(@intCuentaRet = 0)
                                        BEGIN
                                                SELECT @intCuentaRet = ISNULL(MAX(intCuentaRet) + 1,1)
                                                FROM   tbCuentasRet
                                                WHERE  intEmpresa = @intEmpresa 
                                         END
                                  INSERT INTO VetecMarfilAdmin.dbo.tbCuentasRet
                                              (
                                                        intEmpresa 			,
														intCuentaRet		,
														intArea				,
														strInsumoIni		,
														strInsumoFin		,
														strCuentaCargo 		,
														strCuentaAbono 		,
														intES				,
														strUsuario			,
														datFechaModificado 
                                              )
                                              VALUES
                                              ( 
                                                        @intEmpresa 		,
														@intCuentaRet		,
														@intArea			,
														@strInsumoIni		,
														@strInsumoFin		,
														@strCuentaCargo 	,
														@strCuentaAbono 	,
														@intES				,
														@strUsuario			,
														GETDATE() 
												)
																			 
					 END ELSE BEGIN 
					  UPDATE VetecMarfilAdmin.dbo.tbCuentasRet
						 SET 	intEmpresa 	  	   = @intEmpresa 		, 
								intArea 		   = @intArea			,
								strInsumoIni 	   = @strInsumoIni		,
								strInsumoFin 	   = @strInsumoFin		,
								strCuentaCargo 	   = @strCuentaCargo 	,
								strCuentaAbono 	   = @strCuentaAbono 	,
								intES 			   = @intES				,
								strUsuario 		   = @strUsuario		,
								datFechaModificado = GETDATE() 
						 WHERE  intEmpresa         = @intEmpresa
						 AND    intCuentaRet       = @intCuentaRet
   
   END

SELECT @intCuentaRet 

SET NOCOUNT OFF
END

GO
-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbCuentasRet_Save Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbCuentasRet_Save Error on Creation'
END
GOIF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbCuentasRet_Sel')
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
GOIF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbCuentas_Del')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbCuentas_Del
	PRINT N'Drop Procedure : dbo.usp_tbCuentas_Del - Succeeded !!!'
END
GO

------------------------------------------------------------------------------------
---																				 ---
---        Autor: Ramon Rios Hernandez                                           ---
---  Descripcion: DELETE en EstructuraEnc										 ---
---                                                                              ---
------------------------------------------------------------------------------------
---    Fecha     Autor  Comentario                                               ---
---  ----------  -----  -------------------------------------------------------  ---
---  09/07/2013  RRH    Create procedure                                         ---
------------------------------------------------------------------------------------
CREATE
PROCEDURE [DBO].[usp_tbCuentas_Del]
(
       @intEmpresa INT,
       @strCuenta  VARCHAR(50)
) 
AS
BEGIN
	SET NOCOUNT ON
                
				DELETE
                FROM   tbCuentas
                WHERE  intEmpresa = @intEmpresa
                AND    strCuenta   = @strCuenta
                SELECT @strCuenta 

	SET NOCOUNT OFF  
END

GO
-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbCuentas_Del Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbCuentas_Del Error on Creation'
END
GO

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
GOIF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbRubros_Save')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbRubros_Save
	PRINT N'Drop Procedure : dbo.usp_tbRubros_Save - Succeeded !!!'
END
GO

------------------------------------------------------------------------------------
---																				 ---
---        Autor: Ramon Rios Hernandez                                           ---
---  Descripcion: Inserta en tbRubros										 ---
---                                                                              ---
------------------------------------------------------------------------------------
---    Fecha     Autor  Comentario                                               ---
---  ----------  -----  -------------------------------------------------------  ---
---  09/07/2013  RRH    Create procedure                                         ---
------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[usp_tbRubros_Save]
(
    @intEmpresa				int,
	@strCuenta				varchar(50),
	@strNombre				varchar(150),
	@strNombreCorto			varchar(60),	
	@intCtaRegistro			int,
	@intIndAuxiliar			int,
	@intTipoGrupoContable	int,
	@IntGrupoContable		int,
	@intAcceso				int,
	@strAuditAlta			varchar(150)
) 
WITH ENCRYPTION
AS
BEGIN
	SET NOCOUNT ON

	DECLARE @intNivel INT

	SET @intNivel = CASE WHEN LEN(@strCuenta) = 12 THEN 3 ELSE CASE WHEN LEN(@strCuenta) = 8 THEN 2 ELSE 1 END END

	SET @strAuditAlta = @strAuditAlta + ' ' + CONVERT(VARCHAR,GETDATE())

    IF NOT EXISTS(SELECT * FROM tbRubros WHERE intEmpresa = @intEmpresa AND  strCuenta  = @strCuenta)
    BEGIN 
		IF(@intNivel > 1)
		BEGIN
			IF(@intNivel = 2)
			BEGIN
				IF NOT EXISTS(SELECT 1 FROM tbRubros WHERE intEmpresa = @intEmpresa AND  LEFT(strCuenta,4) = LEFT(@strCuenta,4))
				BEGIN
					RAISERROR('No se puede guardar la cuenta, no existe cuenta con nivel anterior.',16,1)
					RETURN;
				END
			END

			IF(@intNivel = 3)
			BEGIN
				IF NOT EXISTS(SELECT 1 FROM tbRubros WHERE intEmpresa = @intEmpresa AND LEFT(strCuenta,8) = LEFT(@strCuenta,8))
				BEGIN
					RAISERROR('No se puede guardar la cuenta, no existe cuenta con nivel anterior.',16,1)
					RETURN
				END
			END
		END				
                                
		INSERT INTO tbRubros(intEmpresa,strClasifEnc,strCuenta,strNombre,strNombreCorto,intNivel,intCtaRegistro,intIndAuxiliar,
		intTipoGrupoContable,intGrupoContable,strAuditAlta,intIndBloqueo,intIndInterEmpresa,intAcceso)
        VALUES(@intEmpresa,0,@strCuenta,@strNombre,@strNombreCorto,@intNivel,@intCtaRegistro,@intIndAuxiliar,
		@intTipoGrupoContable,@IntGrupoContable,@strAuditAlta,0,0,@intAcceso)
    END 
	ELSE 
	BEGIN
          UPDATE tbRubros
          SET	intEmpresa = @intEmpresa,
				strNombre = @strNombre,
				strNombreCorto = @strNombreCorto,
				intCtaRegistro = @intCtaRegistro,
				intIndAuxiliar = @intIndAuxiliar,
				intTipoGrupoContable = @intTipoGrupoContable,
				intGrupoContable = @IntGrupoContable, 
				strAuditMod = @strAuditAlta,
				intAcceso = @intAcceso
          WHERE intEmpresa = @intEmpresa
          AND   strCuenta  = @strCuenta
   END

SELECT @strCuenta 

SET NOCOUNT OFF
END

GO
-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbRubros_Save Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbRubros_Save Error on Creation'
END
GO
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbCuentas_Sel')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbCuentas_Sel
	PRINT N'Drop Procedure : dbo.usp_tbCuentas_Sel - Succeeded !!!'
END
GO

------------------------------------------------------------------------------------
---   Aplicacion: Abasto.		                                                 ---
---        Autor: Ramón Rios Hernandez                                           ---
---  Descripcion: Obtiene un registro de la tabla:  usp_tbCuentas		         ---
---                                                                              ---
------------------------------------------------------------------------------------
---    Fecha     Autor  Comentario                                               ---
---  ----------  -----  -------------------------------------------------------  ---
---  09/07/2013  RRH    Create procedure                                         ---
------------------------------------------------------------------------------------
CREATE PROCEDURE usp_tbCuentas_Sel
	 @intEmpresa INT
	,@strCuenta  VARCHAR(50)
AS
BEGIN
	SET NOCOUNT ON
		
	SELECT C.strClasifEnc,C.strCuenta,REPLACE(C.strNombre,'/','') AS strNombre,C.strNombreCorto,C.intNivel,C.intCtaRegistro,C.intIndAuxiliar,
	case ISNULL(C.intIndAuxiliar,0)when 1 then cast(1 as bit)else cast(0 as bit)end as Auxiliar,
	C.intAcceso,C.intTipoGrupoContable,TGC.strNombre AS Tipo_GrupoContable,C.intGrupoContable,GC.strNombre AS GrupoContable,
	C.intTipoGasto,C.intIndBloqueo,C.intEjercicioBloq,C.intMesBloq,C.intIndInterEmpresa,C.intInterEmpresa,C.strAuditAlta,
	C.strAuditMod
	FROM VetecMarfilAdmin..tbCuentas C
	LEFT JOIN tbTiposGruposContables TGC ON TGC.intTipoGrupoContable = C.intTipoGrupoContable
	LEFT JOIN tbGruposContables GC ON GC.intGrupoContable =  C.intGrupoContable AND TGC.intTipoGrupoContable = GC.intTipoGrupoContable
	WHERE C.intEmpresa = CASE ISNULL(@intEmpresa,0) WHEN 0 THEN C.intEmpresa ELSE ISNULL(@intEmpresa,0) END
	AND  C.strCuenta = CASE ISNULL(@strCuenta,'0') WHEN '0' THEN C.strCuenta ELSE ISNULL(@strCuenta,'0') END 

	SET NOCOUNT OFF
END 	
GO 

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbCuentas_Sel Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbCuentas_Sel Error on Creation'
END
GO 
 


IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbEmpresas_Help')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbEmpresas_Help
	PRINT N'Drop Procedure : dbo.usp_tbEmpresas_Help - Succeeded !!!'
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

CREATE PROCEDURE dbo.usp_tbEmpresas_Help
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
        SET @returnValue = 'SELECT intEmpresa AS Id, strNombre AS Nombre 
		FROM VetecMarfilAdmin..tbEmpresas 
		WHERE intEmpresa NOT IN(22)
		ORDER BY intEmpresa'
	END

	IF (@intVersion = 2)
	BEGIN
        SET @returnValue = 'SELECT intEstado AS #,strNombre 
		FROM VetecMarfilAdmin..tbEstados
		ORDER BY intEstado'
	END

	SELECT @returnValue

	SET NOCOUNT OFF
END
GO 

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbEmpresas_Help Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbEmpresas_Help Error on Creation'
END
/****** Object:  StoredProcedure [dbo.usp_tbFacXP_Poliza]    Script Date: 12/8/2009 10:45:19 AM ******/
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbEmpresas_Save')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbEmpresas_Save
	PRINT N'Drop Procedure : dbo.usp_tbEmpresas_Save - Succeeded !!!'
END
GO

------------------------------------------------------------------------------------
---   Aplicacion: Marfil.		                                                 ---
---        Autor: Ingrid Soto Dimas							                      ---
---  Descripcion: Guarda registros de la tabla: tbEmpresas				         ---
---                                                                              ---
------------------------------------------------------------------------------------
---    Fecha     Autor  Comentario                                               ---
---  ----------  -----  -------------------------------------------------------  ---
---  03/09/2013  IASD    Create procedure                                         ---
------------------------------------------------------------------------------------   

CREATE  PROCEDURE [dbo].[usp_tbEmpresas_Save]  
(
	@intEmpresa INT,
	@strNombre varchar(150),
	@strNombreCorto varchar(25),
	@intGrupo int,
	@strDireccion varchar(40),
	@strColonia varchar(25),
	@strDelegacion varchar(25),
	@intEstado int,
	@intCiudad int,
	@strRfc varchar(20),
	@strRegImss varchar(20),
	@strCodigoPostal  varchar(6),
	@strResponsable varchar(40),
	@strRfcResponsable varchar(20),
	@intTipoMoneda int,
	@intLogo int,
	@datFechaAlta Datetime,
	@strUsuarioAlta  varchar(25),
	@strMaquinaAlta  varchar(20),
	@datFechaMod datetime,
	@strUsuarioMod  varchar(25),
	@strMaquinaMod varchar(20),
	@dblInteresMoratorio numeric(18,4)
 )
WITH ENCRYPTION
AS  
BEGIN

	SET NOCOUNT ON

    IF NOT EXISTS(SELECT * FROM vetecMarfilAdmin..tbEmpresas WHERE intEmpresa = @intEmpresa)
            BEGIN
                     
                      INSERT INTO vetecMarfilAdmin..tbEmpresas 
                                  (
										intEmpresa
										,strNombre
										,strNombreCorto
										,intGrupo
										,strDireccion
										,strColonia
										,strDelegacion
										,intEstado
										,intCiudad
										,strRfc
										,strRegImss
										,strCodigoPostal
										,strResponsable
										,strRfcResponsable
										,intTipoMoneda
										,intLogo
										,datFechaAlta
										,strUsuarioAlta
										,strMaquinaAlta
										,datFechaMod
										,strUsuarioMod
										,strMaquinaMod
										,dblInteresMoratorio
                                  )
                                  VALUES
                                  (
                                     	@intEmpresa 
										,@strNombre 
										,@strNombreCorto 
										,@intGrupo 
										,@strDireccion 
										,@strColonia
										,@strDelegacion 
										,@intEstado 
										,@intCiudad 
										,@strRfc 
										,@strRegImss
										,@strCodigoPostal 
										,@strResponsable 
										,@strRfcResponsable 
										,@intTipoMoneda 
										,@intLogo 
										,@datFechaAlta 
										,@strUsuarioAlta  
										,@strMaquinaAlta  
										,@datFechaMod 
										,@strUsuarioMod  
										,@strMaquinaMod 
										,@dblInteresMoratorio
                                  )

					INSERT INTO vetecMarfil..tbSucursales
								  (
										intEmpresa
										,intClave
										,strNombre
										,strNombreCorto
										,strUsuarioAlta
										,strMaquinaAlta
										,datFechaAlta
										,strUsuarioMod
										,strMaquinaMod
										,datFechaMod
								  )

								VALUES
                                  (
                                     	@intEmpresa 
										,1 
										,'MONTERREY' 
										,'MTY'
										,NULL 
										,NULL
										,NULL 
										,NULL 
										,NULL 
										,NULL 
                                  )


								
			END ELSE BEGIN
				  UPDATE vetecMarfilAdmin..tbEmpresas 
						SET intEmpresa = @intEmpresa
										,strNombre  = @strNombre 
										,strNombreCorto  = @strNombreCorto 
										,strDireccion  = @strDireccion 
										,strColonia = @strColonia
										,strDelegacion  = @strDelegacion 
										,intEstado = @intEstado 
										,intCiudad  = @intCiudad 
										,strRfc  = @strRfc 
										,strRegImss =@strRegImss
										,strCodigoPostal  = @strCodigoPostal 
										,strResponsable  = @strResponsable 
										,strRfcResponsable  = @strRfcResponsable 
										,intTipoMoneda = @intTipoMoneda   
										,datFechaMod  = @datFechaMod 
										,strUsuarioMod  = @strUsuarioMod  
										,strMaquinaMod = @strMaquinaMod 
					WHERE intEmpresa = @intEmpresa 
			END

	SELECT @intEmpresa 

	SET NOCOUNT OFF
	
END
GO

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbEmpresas_Save Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbEmpresas_Save Error on Creation'
END
GO





IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbEstadosFinRubros_Del')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbEstadosFinRubros_Del
	PRINT N'Drop Procedure : dbo.usp_tbEstadosFinRubros_Del - Succeeded !!!'
END
GO

------------------------------------------------------------------------------------
---																				 ---
---        Autor: Ingrid Soto		                                             ---
---  Descripcion: Elimina en tbEstadosFinRubros									 ---
---                                                                              ---
------------------------------------------------------------------------------------
---    Fecha     Autor  Comentario                                               ---
---  ----------  -----  -------------------------------------------------------  ---
---  28/08/2013  IASD    Create procedure                                         ---
------------------------------------------------------------------------------------
CREATE 
PROCEDURE [dbo].[usp_tbEstadosFinRubros_Del]
(
		@intEstadoFin int,
		@intRubro int,
		@intEmpresa int
) 
AS
BEGIN
	SET NOCOUNT ON
                
				DELETE
                FROM   VetecMarfilAdmin..tbEstadosFinRubros
				WHERE  intEstadoFin   = @intEstadoFin
						AND intRubro = @intRubro
						AND intEmpresa =  @intEmpresa
	SELECT @intRubro

END
GO 

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbEstadosFinRubros_Del Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbEstadosFinRubros_Del Error on Creation'
END
GO



IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbEstadosFinRubros_Fill')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbEstadosFinRubros_Fill
	PRINT N'Drop Procedure : dbo.usp_tbEstadosFinRubros_Fill - Succeeded !!!'
END
GO

------------------------------------------------------------------------------------
---																				 ---
---        Autor: Ingrid Soto		                                             ---
---  Descripcion: Consulta en tbEstadosFinRubros								 ---
---                                                                              ---
------------------------------------------------------------------------------------
---    Fecha     Autor  Comentario                                               ---
---  ----------  -----  -------------------------------------------------------  ---
---  02/09/2013  IASD    Create procedure                                         ---
------------------------------------------------------------------------------------
CREATE 
PROCEDURE [dbo].[usp_tbEstadosFinRubros_Fill]
(
    @intEstadoFin int,
	@intEmpresa int
	
) 
AS
BEGIN
	SET NOCOUNT ON
                
				SELECT
					A.intSecuencia  ,
					A.intRubro , 
					B.strNombre , 
					A.strTipoRubro ,
					A.intEmpresa,
					A.intEstadoFin 
				FROM VetecMarfilAdmin..tbEstadosFinRubros A
				INNER JOIN VetecMarfilAdmin..tbRubros B ON (A.intRubro = B.intRubro )
                WHERE ((@intEstadoFin = 0) OR (A.intEstadoFin = @intEstadoFin))  
				AND A.intEmpresa = @intEmpresa
END
GO 

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbEstadosFinRubros_Fill Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbEstadosFinRubros_Fill Error on Creation'
END
GO

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbEstadosFinRubros_Save')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbEstadosFinRubros_Save
	PRINT N'Drop Procedure : dbo.usp_tbEstadosFinRubros_Save - Succeeded !!!'
END
GO


------------------------------------------------------------------------------------
---																				 ---
---        Autor: Ingrid Soto		                                             ---
---  Descripcion: Inserta en tbEstadosFinRubros									 ---
---                                                                              ---
------------------------------------------------------------------------------------
---    Fecha     Autor  Comentario                                               ---
---  ----------  -----  -------------------------------------------------------  ---
---  02/09/2013  IASD    Create procedure                                         ---
------------------------------------------------------------------------------------
create
PROCEDURE [dbo].[usp_tbEstadosFinRubros_Save]
(
	@intEstadoFin int,
	@intRubro int,
	@intSecuencia int,
	@strTipoRubro varchar(4),
	@strNombre varchar(150),
	@strNombreCorto varchar(15),
	@intPtaje int,
	@datFechaAlta datetime,
	@strUsuarioAlta varchar(20),
	@strMaquinaAlta varchar(20),
	@datFechaMod datetime,
	@strUsuarioMod varchar(20),
	@strMaquinaMod varchar(20),
	@intEmpresa int
) AS
     BEGIN

                SET NOCOUNT ON
                IF NOT EXISTS
                        (SELECT *
                        FROM VetecMarfilAdmin..tbEstadosFinRubros 
						WHERE  intEstadoFin   = @intEstadoFin
						AND intRubro = @intRubro
						AND intEmpresa =  @intEmpresa
                        )
                        BEGIN

							DECLARE @ord int
							SET @ord = ( SELECT MAX(intSecuencia) FROM VetecMarfilAdmin..tbEstadosFinRubros 
										 WHERE intEstadoFin = @intEstadoFin
										 AND intEmpresa = @intEmpresa
										)
							SET @ord = @ord + 1

							DECLARE @strTipo varchar(4)
							SELECT @strTipo  = strTipoRubro 
							FROM   VetecMarfilAdmin..tbRubros A
							WHERE intRubro = @intRubro
							--AND ((ISNULL(@intEmpresa,0) = 0) OR (A.intEmpresa = @intEmpresa)) 
     
                                  INSERT INTO VetecMarfilAdmin..tbEstadosFinRubros
                                              (
													intEstadoFin
													,intRubro
													,intSecuencia
													,strTipoRubro
													,strNombre
													,strNombreCorto
													,intPtaje
													,datFechaAlta
													,strUsuarioAlta
													,strMaquinaAlta
													,datFechaMod
													,strUsuarioMod
													,strMaquinaMod
													,intEmpresa
                                              )
                                              VALUES
                                              (
													@intEstadoFin
													,@intRubro
													,@ord
													,@strTipo
													,@strNombre
													,@strNombreCorto
													,@intPtaje
													,@datFechaAlta
													,@strUsuarioAlta
													,@strMaquinaAlta
													,@datFechaMod
													,@strUsuarioMod
													,@strMaquinaMod
													,@intEmpresa
                                              )
                      END ELSE BEGIN
	
							UPDATE VetecMarfilAdmin..tbEstadosFinRubros
								SET  intEstadoFin = @intEstadoFin
										,intRubro = @intRubro
										,intSecuencia = @intSecuencia
										,strTipoRubro = @strTipoRubro
										,strNombre = @strNombre
										,strNombreCorto = @strNombreCorto
										,intPtaje = @intPtaje
										,datFechaMod = @datFechaMod
										,strUsuarioMod = @strUsuarioMod
										,strMaquinaMod = @strMaquinaMod
										,intEmpresa = @intEmpresa
							WHERE  intEstadoFin   = @intEstadoFin
							AND intRubro = @intRubro
							AND intEmpresa =  @intEmpresa
   END

	SELECT @intRubro 

END
GO 

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbEstadosFinRubros_Save Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbEstadosFinRubros_Save Error on Creation'
END
GO



IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbEstadosFinRubros_Sel')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbEstadosFinRubros_Sel
	PRINT N'Drop Procedure : dbo.usp_tbEstadosFinRubros_Sel - Succeeded !!!'
END
GO

------------------------------------------------------------------------------------
---																				 ---
---        Autor: Ingrid Soto		                                             ---
---  Descripcion: Consulta en tbEstadosFinRubros								 ---
---                                                                              ---
------------------------------------------------------------------------------------
---    Fecha     Autor  Comentario                                               ---
---  ----------  -----  -------------------------------------------------------  ---
---  02/09/2013  IASD    Create procedure                                         ---
------------------------------------------------------------------------------------
CREATE 
PROCEDURE [dbo].[usp_tbEstadosFinRubros_Sel]
(
    @intEstadoFin int,
	@intEmpresa int
	
) 
AS
BEGIN
	SET NOCOUNT ON
                
				SELECT
					intEstadoFin
					,ISNULL(intRubro,0) as intRubro
					,ISNULL(intSecuencia,0) as  intSecuencia
					,ISNULL(strTipoRubro,'') as  strTipoRubro
					,ISNULL(strNombre,'') as  strNombre
					,ISNULL(strNombreCorto,'') as strNombreCorto
					,ISNULL(intPtaje,0) as intPtaje
					,ISNULL(datFechaAlta,'01/01/1900') as datFechaAlta
					,ISNULL(strUsuarioAlta,'') as strUsuarioAlta
					,ISNULL(strMaquinaAlta,'') as strMaquinaAlta
					,ISNULL(datFechaMod,'01/01/1900') as datFechaMod
					,ISNULL(strUsuarioMod,'') as strUsuarioMod
					,ISNULL(strMaquinaMod,'') as strMaquinaMod
					,ISNULL(intEmpresa,0) as intEmpresa
                FROM   VetecMarfilAdmin..tbEstadosFinRubros A
                WHERE ((@intEstadoFin = 0) OR (A.intEstadoFin = @intEstadoFin))  
END
GO 

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbEstadosFinRubros_Sel Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbEstadosFinRubros_Sel Error on Creation'
END
GO

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbEstructuraDet_Del')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbEstructuraDet_Del
	PRINT N'Drop Procedure : dbo.usp_tbEstructuraDet_Del - Succeeded !!!'
END
GO
------------------------------------------------------------------------------------
---																				 ---
---        Autor: Ramon Rios Hernandez                                           ---
---  Descripcion: DELETE en tbEstructuraDet										 ---
---                                                                              ---
------------------------------------------------------------------------------------
---    Fecha     Autor  Comentario                                               ---
---  ----------  -----  -------------------------------------------------------  ---
---  02/07/2013  RRH    Create procedure                                         ---
------------------------------------------------------------------------------------
CREATE
PROCEDURE [DBO].[usp_tbEstructuraDet_Del]
(
   @intEmpresa INT,
   @intPartida INT,
   @intClave   INT
) 
AS
BEGIN
	SET NOCOUNT ON
                
				DELETE
                FROM   tbEstructuraDet
                WHERE  intEmpresa = @intEmpresa
				AND	   intPartida = @intPartida
                AND    intClave   = CASE ISNULL(@intClave,0) WHEN 0 THEN intClave ELSE ISNULL(@intClave,0) END

                SELECT @intClave 

	SET NOCOUNT OFF  
END
GO 

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbEstructuraDet_Del Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbEstructuraDet_Del Error on Creation'
END
GO
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
IF EXISTS(SELECT * FROM    dbo.sysobjects WHERE   id = OBJECT_ID(N'dbo.usp_tbEstructuraDet_Save') AND  
   OBJECTPROPERTY(id,N'IsProcedure') = 1 )
BEGIN
		DROP PROCEDURE dbo.usp_tbEstructuraDet_Save
		PRINT N'Drop Procedure : dbo.usp_tbEstructuraDet_Save - Succeeded !!!'
END 
GO
------------------------------------------------------------------------------------
---                     														 ---
---        Autor: Ramon Rios Hernandez                                           ---
---  Descripcion: Inserta en EstructuraDet           							 ---
---                                                                              ---
------------------------------------------------------------------------------------
---    Fecha     Autor  Comentario                                               ---
---  ----------  -----  -------------------------------------------------------  ---
---  28/06/2013  RRH    Create procedure                                         ---
------------------------------------------------------------------------------------
CREATE PROCEDURE [DBO].[usp_tbEstructuraDet_Save]
(
	@intEmpresa      INT,
	@intClave        INT,
	@intPartida      INT,
	@strCuenta       VARCHAR(10),
	@strSubCuentat   VARCHAR(10),
	@strSubSubCuenta VARCHAR(10),
	@bitCargo        BIT,
	@bitAux          BIT,
	@bitCC           BIT,
	@strConcepto     VARCHAR(100),
	@strComentario   VARCHAR(100),
	@bitModif        BIT,
	@strBase         VARCHAR(50),
	@dblPtaje        DECIMAL(10,6)
) AS
        BEGIN
                SET NOCOUNT ON
                IF NOT EXISTS
                        (SELECT *
                        FROM    tbEstructuraDet
                        WHERE   intEmpresa = @intEmpresa
                        AND     intClave   = @intClave
						AND		intPartida = @intPartida
                        )
                        BEGIN
                                IF(@intPartida = 0)
                                        BEGIN
                                                SELECT @intPartida = ISNULL(MAX(intPartida) + 1,1)
                                                FROM   tbEstructuraDet
                                                WHERE  intEmpresa = @intEmpresa
												   AND intClave = @intClave
                                         END
                                  INSERT INTO VetecMarfilAdmin.dbo.tbEstructuraDet
                                              (
                                                          intClave        ,
                                                          intPartida      ,
                                                          strCuenta       ,
                                                          strSubCuentat   ,
                                                          strSubSubCuenta ,
                                                          bitCargo        ,
                                                          bitAux          ,
                                                          bitCC           ,
                                                          strConcepto     ,
                                                          strComentario   ,
                                                          bitModif        ,
                                                          strBase         ,
                                                          intPtaje        ,
                                                          intEmpresa
                                              )
                                              VALUES
                                              (
                                                          @intClave        ,
                                                          @intPartida      ,
                                                          @strCuenta       ,
                                                          @strSubCuentat   ,
                                                          @strSubSubCuenta ,
                                                          @bitCargo        ,
                                                          @bitAux          ,
                                                          @bitCC           ,
                                                          @strConcepto     ,
                                                          @strComentario   ,
                                                          @bitModif        ,
                                                          @strBase         ,
                                                          @dblPtaje        ,
                                                          @intEmpresa
                                              )
                      END ELSE BEGIN
							UPDATE VetecMarfilAdmin.dbo.tbEstructuraDet
							SET    intClave        = @intClave       ,
								   intPartida      = @intPartida     ,
								   strCuenta       = @strCuenta      ,
								   strSubCuentat   = @strSubCuentat  ,
								   strSubSubCuenta = @strSubSubCuenta,
								   bitCargo        = @bitCargo       ,
								   bitAux          = @bitAux         ,
								   bitCC           = @bitCC          ,
								   strConcepto     = @strConcepto    ,
								   strComentario   = @strComentario  ,
								   bitModif        = @bitModif       ,
								   strBase         = @strBase        ,
								   intPtaje        = @dblPtaje       ,
								   intEmpresa      = @intEmpresa     
							WHERE  intEmpresa      = @intEmpresa
							AND    intPartida      = @intPartida
							AND    intClave        = @intClave
					  END
						
					SELECT @intClave SET NOCOUNT OFF
					END 
GO
-- Display the status of Proc creation
IF (@@Error = 0) BEGIN PRINT 'Procedure Creation: dbo.usp_tbEstructuraDet_Save Succeeded'
END ELSE BEGIN PRINT 'Procedure Creation: dbo.usp_tbEstructuraDet_Save Error on Creation'
END 

GO
IF EXISTS
(
  SELECT *
	FROM dbo.sysobjects
   WHERE id = OBJECT_ID(N'dbo.usp_tbEstructuraDet_Sel')
	 AND OBJECTPROPERTY(id,N'IsProcedure') = 1
)
BEGIN
    DROP PROCEDURE dbo.usp_tbEstructuraDet_Sel
    PRINT N'Drop Procedure : dbo.usp_tbEstructuraDet_Sel - Succeeded !!!'
END  
GO 
------------------------------------------------------------------------------------
---   Aplicacion: Abasto.										                 ---
---        Autor: Ramón Rios Hernandez                                           ---
---  Descripcion:																 ---
---                                                                              ---
------------------------------------------------------------------------------------
---    Fecha     Autor  Comentario                                               ---
---  ----------  -----  -------------------------------------------------------  ---
---  02/07/2013  RRH    Create procedure                                         ---
------------------------------------------------------------------------------------
CREATE PROCEDURE dbo.usp_tbEstructuraDet_Sel
(
	@intEmpresa INT,
	@intPartida INT,
	@intClave   INT
) 
AS
BEGIN  
	SELECT DISTINCT ED.intPartida,ED.intClave,ED.strCuenta,
                        ED.strSubCuentat  ,
                        ED.strSubSubCuenta,
						ED.bitCargo AS bitCargo,
						ED.bitAux AS bitAux,
						ED.bitCC AS bitCC,   
                        ED.strConcepto,
						PC.Concepto,
                        ED.strComentario,
						ED.bitModif AS bitModif,
                        ED.strBase,
						PB.Base,
                        ED.intPtaje
	FROM VetecMarfilAdmin..tbEstructuraDet ED
	INNER JOIN tbParametrosPoliza_Conceptos PC ON PC.Concepto = ED.strConcepto
	INNER JOIN tbParametrosPoliza_Bases PB ON PB.Base = ED.strBase
    WHERE ED.intEmpresa = CASE ISNULL(@intEmpresa,0) WHEN 0 THEN ED.intEmpresa ELSE ISNULL(@intEmpresa,0) END
    AND ED.intPartida = CASE ISNULL(@intPartida,0) WHEN 0 THEN ED.intPartida ELSE ISNULL(@intPartida,0) END
	AND ED.intClave = CASE ISNULL(@intClave,0) WHEN 0 THEN ED.intClave ELSE ISNULL(@intClave,0) END 

END 
GO
        
-- Display the status of Proc creation
IF (@@Error = 0) 
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbEstructuraDet_Sel Succeeded'
END 

ELSE 
	BEGIN 
		PRINT 'Procedure Creation: dbo.usp_tbEstructuraDet_Sel Error on Creation'
	END 

GO
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbEstructuraEnc_Del')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbEstructuraEnc_Del
	PRINT N'Drop Procedure : dbo.usp_tbEstructuraEnc_Del - Succeeded !!!'
END
GO

------------------------------------------------------------------------------------
---																				 ---
---        Autor: Ramon Rios Hernandez                                           ---
---  Descripcion: DELETE en EstructuraEnc										 ---
---                                                                              ---
------------------------------------------------------------------------------------
---    Fecha     Autor  Comentario                                               ---
---  ----------  -----  -------------------------------------------------------  ---
---  01/07/2013  RRH    Create procedure                                         ---
------------------------------------------------------------------------------------
CREATE PROCEDURE [DBO].[usp_tbEstructuraEnc_Del]
(
       @intEmpresa INT,
       @intClave   INT
)
WITH ENCRYPTION 
AS
BEGIN
	SET NOCOUNT ON

	DELETE FROM VetecMarfilAdmin..tbEstructuraDet
	WHERE intEmpresa = @intEmpresa AND intClave   = @intClave
    
	IF(@@Error = 0)
	BEGIN            
		DELETE FROM   tbEstructuraEnc
        WHERE  intEmpresa = @intEmpresa
        AND    intClave   = @intClave
	END

    SELECT @intClave 

	SET NOCOUNT OFF  
END

GO
-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbEstructuraEnc_Del Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbEstructuraEnc_Del Error on Creation'
END
GO


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
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbEstructuraEnc_Save')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbEstructuraEnc_Save
	PRINT N'Drop Procedure : dbo.usp_tbEstructuraEnc_Save - Succeeded !!!'
END
GO

------------------------------------------------------------------------------------
---																				 ---
---        Autor: Ramon Rios Hernandez                                           ---
---  Descripcion: Inserta en EstructuraEnc										 ---
---                                                                              ---
------------------------------------------------------------------------------------
---    Fecha     Autor  Comentario                                               ---
---  ----------  -----  -------------------------------------------------------  ---
---  28/06/2013  RRH    Create procedure                                         ---
------------------------------------------------------------------------------------
CREATE
PROCEDURE [DBO].[usp_tbEstructuraEnc_Save]
(
    @intEmpresa           INT,
    @intClave             INT,
    @strDescrcipcion      VARCHAR(50),
    @strTipoPoliza        VARCHAR(3),
    @intModulo            INT,
    @strDescripciónPoliza VARCHAR(100),
    @bitAutomatica        BIT,
    @strUsuario	          VARCHAR(50),
    @strMaquina	          VARCHAR(50),    
    @intMovto             INT,
    @intGrupoCredito      INT
) AS
        BEGIN
                SET NOCOUNT ON
                IF NOT EXISTS
                        (SELECT *
                        FROM    tbEstructuraEnc
                        WHERE   intEmpresa = @intEmpresa
                        AND     intClave   = @intClave
                        )
                        BEGIN
                                IF(@intClave = 0)
                                        BEGIN
                                                SELECT @intClave = ISNULL(MAX(intClave) + 1,1)
                                                FROM   tbEstructuraEnc
                                                WHERE  intEmpresa = @intEmpresa
                                         END
                                  INSERT INTO tbEstructuraEnc
                                              (
                                                          intEmpresa          ,
														  intClave,
                                                          strDescrcipcion     ,
                                                          strTipoPoliza       ,
                                                          intModulo           ,
                                                          strDescripciónPoliza,
                                                          bitAutomatica       ,
                                                          strUsuarioAlta      ,
                                                          strMaquinaAlta      ,
                                                          datFechaAlta        ,
                                                          intMovto            ,
                                                          intGrupoCredito
                                              )
                                              VALUES
                                              (
                                                          @intEmpresa          ,
														  @intClave,
                                                          @strDescrcipcion     ,
                                                          @strTipoPoliza       ,
                                                          @intModulo           ,
                                                          @strDescripciónPoliza,
                                                          @bitAutomatica       ,
                                                          @strUsuario          ,
                                                          @strMaquina          ,
                                                          GETDATE()            ,
                                                          @intMovto            ,
                                                          @intGrupoCredito
                                              )
                      END ELSE BEGIN
          UPDATE tbEstructuraEnc
          SET    strDescrcipcion      = @strDescrcipcion     ,
                 strTipoPoliza        = @strTipoPoliza       ,
                 intModulo            = @intModulo           ,
                 strDescripciónPoliza = @strDescripciónPoliza,
                 bitAutomatica        = @bitAutomatica       ,
                 strUsuarioMod        = @strUsuario          ,
                 strMaquinaMod        = @strMaquina          ,
                 datFechaMod          = GETDATE()            ,
                 intMovto             = @intMovto            ,
                 intGrupoCredito      = @intGrupoCredito
          WHERE  intEmpresa           = @intEmpresa
          AND    intClave             = @intClave
   END

SELECT @intClave 

SET NOCOUNT OFF
END

GO
-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbEstructuraEnc_Save Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbEstructuraEnc_Save Error on Creation'
END
GO
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbEstructuraEnc_Sel')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbEstructuraEnc_Sel
	PRINT N'Drop Procedure : dbo.usp_tbEstructuraEnc_Sel - Succeeded !!!'
END
GO

------------------------------------------------------------------------------------
---   Aplicacion: Abasto.		                                                 ---
---        Autor: Ramón Rios Hernandez                                           ---
---  Descripcion: Obtiene un registro de la tabla:  usp_tbEstructuraEnc	         ---
---                                                                              ---
------------------------------------------------------------------------------------
---    Fecha     Autor  Comentario                                               ---
---  ----------  -----  -------------------------------------------------------  ---
---  28/06/2013  RRH    Create procedure                                         ---
------------------------------------------------------------------------------------
CREATE PROCEDURE usp_tbEstructuraEnc_Sel
	 @intEmpresa int
	,@intMovto int
AS
BEGIN
	SET NOCOUNT ON
		SELECT DISTINCT E.intClave,
			E.strTipoPoliza,
			E.strDescripciónPoliza,
			E.strDescrcipcion,
			E.bitAutomatica,
			E.intMovto,
			P.strNombre AS strNombrePoliza,
			M.strNombre AS strNombreTipoMovto
		FROM VetecMarfilAdmin..tbEstructuraEnc E
		LEFT JOIN VetecMarfilAdmin..tbTipoMovto M ON E.intMovto = M.intMovto
		LEFT JOIN VetecMarfilAdmin..tbTiposPoliza P ON E.strTipoPoliza = P.strTipoPoliza
		WHERE E.intEmpresa = CASE ISNULL(@intEmpresa,0) WHEN 0 THEN E.intEmpresa ELSE ISNULL(@intEmpresa,0) END
		AND E.intMovto = CASE ISNULL(@intMovto,0) WHEN 0 THEN E.intMovto ELSE ISNULL(@intMovto,0) END
	END 
	SET NOCOUNT OFF
GO 

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbEstructuraEnc_Sel Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbEstructuraEnc_Sel Error on Creation'
END
GO


IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbPolizasDet_Auxiliar')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbPolizasDet_Auxiliar
	PRINT N'Drop Procedure : dbo.usp_tbPolizasDet_Auxiliar - Succeeded !!!'
END
GO

------------------------------------------------------------------------------------
---   Aplicacion: RMM.		                                                     ---
---        Autor: Ruben Mora Martinez                                            ---
---  Descripcion: Obtiene un registro de la tabla:  tbCotizacion                 ---
---                                                                              ---
------------------------------------------------------------------------------------
---    Fecha     Autor  Comentario                                               ---
---  ----------  -----  -------------------------------------------------------  ---
---  22/08/2011  RMM    Create procedure                                         ---
------------------------------------------------------------------------------------


CREATE PROCEDURE dbo.usp_tbPolizasDet_Auxiliar
( 
	@intEmpresa			int, 
	@intEjercicioIni	int,	
	@intEjercicioFin	int,	
	@intMesIni			Int,	
	@intMesFin			Int,	
	@strCuentaIni		VarChar(50), 
	@strCuentaFin		VarChar(50),
	@strObra			VarChar(50),
	@strObraFin			VarChar(50),
	@intAreaIni			INT,   
	@intAreaFin			INT,
	@intColIni			INT, 
	@intColFin			INT, 
	@intCero			INT
--	@intSectorIni	INT, 
--	@intSectorFin	INT
)
AS    
BEGIN
	SET NOCOUNT ON 

	DECLARE @datFechaIni DATETIME
	DECLARE @datFechaFin DATETIME   

	DECLARE @datFecha VARCHAR(50)
	DECLARE @strMes VARCHAR(100)
	DECLARE @strEmpresa VARCHAR(200)	
	DECLARE @Rows int
	DECLARE @Count int	
	DECLARE @strCuentaN VARCHAR(50)
	DECLARE @Suma DECIMAL(18,2)	

	SET @datFechaIni = '01/' + CONVERT(VARCHAR,@intMesIni) + '/' + CONVERT(VARCHAR,@intEjercicioIni)
	SET @datFechaFin = '01/' + CONVERT(VARCHAR,@intMesFin) + '/' + CONVERT(VARCHAR,@intEjercicioFin)

	SET @datFechaFin = DATEADD(day,-1,DATEADD(month,@intMesFin,DATEADD(year,@intEjercicioFin-1900,0))) /*Last*/

	SELECT @strEmpresa = strNombre FROM tbEmpresas WHERE intEmpresa = @intEmpresa

	------------------------------------INICIA FORMATO FECHA MDY-------------------------------------
	IF @intEmpresa = 22 
	BEGIN
		SET LANGUAGE ENGLISH  		

		SET @datFecha =  CONVERT(VARCHAR,@intMesIni) + '/01/' + CONVERT(VARCHAR,@intEjercicioIni)
	
		IF @intMesIni = 0
			SET @strMes = 'JAN 11 - DEC 11'
		ELSE
			SELECT @strMes = DATENAME(MONTH,CONVERT(DATETIME, @datFecha) )
	END
	ELSE
	BEGIN	
		SELECT @strMes = strNombre FROM tbMeses WHERE intMes = @intMesIni
	END
	------------------------------------FIN FORMATO FECHA MDY-------------------------------------

	CREATE TABLE #TmpObras(intObra INT)
	
	CREATE TABLE #TempCuentas(intEmpresa int, strCuenta VARCHAR(50) COLLATE SQL_Latin1_General_CP1_CI_AS, strNombre VARCHAR(200),
	intCtaRegistro int, dblSaldoInicial decimal(18,2), strCuentaRel VARCHAR(50))

	CREATE TABLE #TempCuentasN1(id int identity(1,1),intEmpresa int,strCuenta VARCHAR(50) COLLATE SQL_Latin1_General_CP1_CI_AS)
	CREATE TABLE #TempCuentasN2(id int identity(1,1),intEmpresa int,strCuenta VARCHAR(50) COLLATE SQL_Latin1_General_CP1_CI_AS)
	CREATE TABLE #TempCuentasN3(id int identity(1,1),intEmpresa int,strCuenta VARCHAR(50) COLLATE SQL_Latin1_General_CP1_CI_AS)
	CREATE TABLE #TempCuentasAll(id int identity(1,1),strCuenta VARCHAR(50) COLLATE SQL_Latin1_General_CP1_CI_AS, 
	strPoliza VARCHAR(50),strReferencia VARCHAR(50), datFecha datetime, dblImporte DECIMAL(18,2), dblSaldo DECIMAL(18,2))
	
	CREATE TABLE #TempPolizas(Id int Identity(1,1), Cuenta varchar(10), SubCuenta varchar(10), SubSubReporte varchar(10), 
	CuentaNombre varchar(200), Poliza varchar(100), TipoPoliza varchar(50), Fecha datetime, CentroCosto varchar(100),
	Referencia Varchar(100), Descripcion varchar(500), Cargos decimal(18,2), Abonos decimal(18,2),
	Saldo decimal(18,2), SaldoCargos MONEY, SaldoAbonos MONEY, SaldoActual MONEY, strCuenta VARCHAR(100), 
	dblSaldoInicial MONEY, intNivel int, Auxiliar varchar(50), strHeader VARCHAR(100), strHeader2 VARCHAR(100),
	dblHeader MONEY, dblHeader2 MONEY, Folio int, Partida int)

	INSERT INTO #TmpObras(intObra)
	SELECT DISTINCT O.intObra
	FROM VetecMarfil.dbo.tbObra O 
	WHERE O.intEmpresa = @intEmpresa
	AND ((@strObra = '0') OR (O.strClave BETWEEN @strObra AND @strObraFin))
	AND ((@intAreaIni = 0) OR (CONVERT(int, SUBSTRING(O.strClave, 1, 2)) BETWEEN @intAreaIni AND @intAreaFin))
	AND ((@intColIni = 0 AND @intColFin = 0) OR (O.intColonia BETWEEN @intColIni AND @intColFin))
	--AND ((@intSectorIni = 0 AND @intSectorFin = 0) OR (O.intSector BETWEEN @intSectorIni AND @intSectorFin))

	IF(LEN(@strCuentaIni) = 4)
	BEGIN
		INSERT INTO #TempCuentas(intEmpresa, strCuenta, strNombre,intCtaRegistro,strCuentaRel)
		SELECT DISTINCT intEmpresa, strCuenta,strNombre,1,strCuenta  
		FROM tbCuentas
		WHERE intEmpresa = @intEmpresa
		AND ((@strCuentaIni = '0') OR (LEFT(strCuenta,4) BETWEEN LEFT(@strCuentaIni,4) AND LEFT(@strCuentaFin,4)))
		AND intCtaRegistro = 1	
	END
	ELSE
	BEGIN
		INSERT INTO #TempCuentas(intEmpresa, strCuenta, strNombre,intCtaRegistro,strCuentaRel)
		SELECT DISTINCT intEmpresa, strCuenta,strNombre,1,strCuenta  
		FROM tbCuentas
		WHERE intEmpresa = @intEmpresa
		AND ((@strCuentaIni = '0') OR (strCuenta BETWEEN @strCuentaIni AND @strCuentaFin))
		AND intCtaRegistro = 1	
	END

	--primer nivel
	INSERT INTO #TempCuentas(intEmpresa, strCuenta, strNombre,strCuentaRel)
	SELECT DISTINCT C.intEmpresa, C.strCuenta,C.strNombre,C.strCuenta  
	FROM tbCuentas C
	INNER JOIN #TempCuentas T ON T.intEmpresa = C.intEmpresa AND LEFT(T.strCuenta,4) = C.strCuenta
	WHERE C.intEmpresa = @intEmpresa
	AND T.intCtaRegistro = 1

	--segundo nivel
	INSERT INTO #TempCuentas(intEmpresa, strCuenta, strNombre,strCuentaRel)
	SELECT DISTINCT C.intEmpresa, C.strCuenta,C.strNombre,C.strCuenta   
	FROM tbCuentas C
	INNER JOIN #TempCuentas T ON T.intEmpresa = C.intEmpresa AND LEFT(T.strCuenta,8) = C.strCuenta
	WHERE C.intEmpresa = @intEmpresa
	AND T.intCtaRegistro = 1
	
	UPDATE  T
	SET dblSaldoInicial = dbo.F_Sdoini(T.intEmpresa,'0',@intEjercicioIni,@intMesIni,'0',T.strCuenta,'0',0)
	FROM #TempCuentas T

	INSERT INTO #TempPolizas(Cuenta,SubCuenta,SubSubReporte,CuentaNombre,Poliza,TipoPoliza,Fecha,CentroCosto,
	Referencia,Descripcion,Cargos,Abonos,Saldo, strCuenta, intNivel,dblSaldoInicial)    
	SELECT DISTINCT Cuenta = LEFT(C.strCuenta,4),SubCuenta = (CASE WHEN LEN(C.strCuenta) > 4 THEN SUBSTRING(C.strCuenta, 5, 4) ELSE '' END),
	SubSubReporte = (CASE WHEN LEN(C.strCuenta) > 8 THEN SUBSTRING(C.strCuenta, 9, 4) ELSE '' END),
	CuentaNombre = C.strNombre,'','','',NULL,NULL,NULL,0,0,0,T.strCuentaRel,C.intNivel,T.dblSaldoInicial
	FROM #TempCuentas T
	INNER JOIN tbCuentas C ON T.intEmpresa = C.intEmpresa AND T.strCuenta = C.strCuenta
	WHERE T.intCtaRegistro IS NULL
	
	INSERT INTO #TempPolizas(Cuenta,SubCuenta,SubSubReporte,CuentaNombre,Poliza,TipoPoliza,Fecha,CentroCosto,
	Referencia,Descripcion,Cargos,Abonos,Saldo, strCuenta, intNivel,dblSaldoInicial)    
	SELECT DISTINCT Cuenta = LEFT(C.strCuenta,4),SubCuenta = (CASE WHEN LEN(C.strCuenta) > 4 THEN SUBSTRING(C.strCuenta, 5, 4) ELSE '' END),
	SubSubReporte = (CASE WHEN LEN(C.strCuenta) > 8 THEN SUBSTRING(C.strCuenta, 9, 4) ELSE '' END),
	CuentaNombre = C.strNombre,'','','',NULL,NULL,NULL,0,0,T.dblSaldoInicial,T.strCuenta,C.intNivel,T.dblSaldoInicial
	FROM #TempCuentas T
	INNER JOIN tbCuentas C ON T.intEmpresa = C.intEmpresa AND T.strCuenta = C.strCuenta
	WHERE T.intCtaRegistro = 1

	INSERT INTO #TempPolizas(Cuenta,SubCuenta,SubSubReporte,CuentaNombre,Poliza,TipoPoliza,Fecha,CentroCosto,
	Referencia,Descripcion,Cargos,Abonos,Saldo, strCuenta, intNivel,dblSaldoInicial,Auxiliar,Folio,Partida)                        
	SELECT 	Cuenta = LEFT(C.strCuenta,4),SubCuenta = (CASE WHEN LEN(C.strCuenta) > 4 THEN SUBSTRING(C.strCuenta, 5, 4) ELSE '' END),
	SubSubReporte = (CASE WHEN LEN(C.strCuenta) > 8 THEN SUBSTRING(C.strCuenta, 9, 4) ELSE '' END),
	CuentaNombre = C.strNombre,PD.strPoliza, PD.strTipoPoliza, PD.datFecha, 
	ISNULL(O.strClave,'0'),strReferencia, PD.strDescripcion, 
	CASE WHEN PD.intTipoMovto = 1 THEN ABS(ISNULL(PD.dblImporte,0)) ELSE 0 END,
	CASE WHEN PD.intTipoMovto = 1 THEN 0 ELSE ABS(ISNULL(PD.dblImporte,0)) * -1 END,  
	NULL, T.strCuentaRel,C.intNivel,T.dblSaldoInicial,PD.strClasifDP, PD.intFolioPoliza,PD.intPartida
	FROM tbCuentas C
	LEFT JOIN tbPolizasDet PD ON C.intEmpresa = PD.intEmpresa AND C.strCuenta = PD.strCuenta 
	LEFT JOIN tbPolizasEnc PE ON PE.strPoliza = PD.strPoliza AND PE.intEmpresa = PD.intEmpresa AND PD.intMes = PE.intMes AND PE.intEjercicio = PD.intEjercicio AND PE.intEstatus <> 9
	INNER JOIN #TempCuentas T ON T.intEmpresa = C.intEmpresa AND T.strCuenta = C.strCuenta
	LEFT JOIN VetecMarfil..tbObra O ON CONVERT(VARCHAR,O.intObra) = PD.strClasifDS
	WHERE C.intEmpresa = @intEmpresa 	
	AND PD.datFecha BETWEEN @datFechaIni AND @datFechaFin
	AND PD.strClasifDS IN(SELECT CONVERT(VARCHAR,intObra) FROM #TmpObras)
	AND PD.intIndAfectada = 1 
	AND T.intCtaRegistro = 1
	ORDER BY C.strCuenta, PD.datFecha, PD.strPoliza

	UPDATE T
	SET strHeader = C.strNombre
	FROM #TempPolizas T
	INNER JOIN tbCuentas C ON T.Cuenta collate SQL_Latin1_General_CP1_CI_AS = C.strCuenta
	WHERE C.intEmpresa = @intEmpresa	
	
	UPDATE T
	SET strHeader2 = C.strNombre
	FROM #TempPolizas T
	INNER JOIN tbCuentas C ON LEFT(T.strCuenta,8) collate SQL_Latin1_General_CP1_CI_AS = C.strCuenta
	WHERE C.intEmpresa = @intEmpresa

	INSERT INTO #TempCuentasN1(intEmpresa,strCuenta)
	SELECT DISTINCT @intEmpresa, C.strCuenta
	FROM #TempCuentas T
	INNER JOIN tbCuentas C ON T.strCuenta collate SQL_Latin1_General_CP1_CI_AS = C.strCuenta
	WHERE C.intEmpresa = @intEmpresa
	AND C.intNivel = 1

	INSERT INTO #TempCuentasN2(intEmpresa,strCuenta)
	SELECT DISTINCT @intEmpresa, C.strCuenta
	FROM #TempCuentas T
	INNER JOIN tbCuentas C ON T.strCuenta collate SQL_Latin1_General_CP1_CI_AS = C.strCuenta
	WHERE C.intEmpresa = @intEmpresa
	AND C.intNivel = 2
	
	SELECT @Rows = COUNT(*) FROM #TempCuentasN1
	SET @Count = 0

	WHILE(@Rows > @Count)
	BEGIN
		SET @Count = @Count + 1
		SELECT @strCuentaN = strCuenta FROM #TempCuentasN1 WHERE id = @Count

		SELECT @Suma = dbo.F_Sdoini(@intEmpresa,'0',@intEjercicioFin,@intMesFin + 1,'0',@strCuentaN,'0',0)

		UPDATE #TempPolizas
		SET dblHeader = @Suma
		WHERE LEFT(strCuenta,4) = @strCuentaN
	
		SET @strCuentaN = ''
		SET @Suma = 0
	END

	DROP TABLE #TempCuentasN1

	SELECT @Rows = COUNT(*) FROM #TempCuentasN2
	SET @Count = 0

	WHILE(@Rows > @Count)
	BEGIN
		SET @Count = @Count + 1
		SELECT @strCuentaN = strCuenta FROM #TempCuentasN2 WHERE id = @Count

		SELECT @Suma = dbo.F_Sdoini(@intEmpresa,'0',@intEjercicioFin,@intMesFin + 1,'0',@strCuentaN,'0',0)

		UPDATE #TempPolizas
		SET dblHeader2 = @Suma
		WHERE LEFT(strCuenta,8) = @strCuentaN
	
		SET @strCuentaN = ''
		SET @Suma = 0
	END

	DROP TABLE #TempCuentasN2

	UPDATE T
	SET Saldo = Cargos - ABS(Abonos)
	FROM #TempPolizas T
	WHERE Poliza <> ''

	UPDATE TT
	SET TT.Auxiliar = ISNULL((SELECT TOP 1 1 FROM #TempPolizas T WHERE LEFT(T.strCuenta,4) = LEFT(TT.strCuenta,4) AND LEN(T.strCuenta) > 4),0)
	FROM #TempPolizas TT
	WHERE TT.intNivel = 1

	UPDATE TT
	SET TT.Auxiliar = ISNULL((SELECT TOP 1 1 FROM #TempPolizas T WHERE LEFT(T.strCuenta,8) = LEFT(TT.strCuenta,8) AND LEN(T.strCuenta) > 8),0)
	FROM #TempPolizas TT
	WHERE TT.intNivel = 2

	UPDATE TT
	SET TT.dblHeader2 = 0
	FROM #TempPolizas TT
	WHERE TT.dblHeader2 IS NULL

	UPDATE TT
	SET TT.Auxiliar = 0
	FROM #TempPolizas TT
	WHERE TT.Auxiliar IS NULL

--	INSERT INTO #TempCuentasN3(strCuenta)
--	SELECT DISTINCT strCuenta
--	FROM #TempCuentas
--	WHERE intCtaRegistro = 1
--
--	SELECT @Rows = COUNT(*) FROM #TempCuentasN3
--	SET @Count = 0
--
--	WHILE(@Rows > @Count)
--	BEGIN
--		SET @Count = @Count + 1
--		SELECT @strCuentaN = strCuenta FROM #TempCuentasN3 WHERE id = @Count
--	
--		INSERT INTO #TempCuentasAll(strCuenta,strPoliza,strReferencia,datFecha,dblImporte)
--		SELECT T.strCuenta,T.Poliza,T.Referencia,T.Fecha,T.Saldo
--		FROM #TempPolizas T
--		INNER JOIN #TempCuentas C ON T.strCuenta COLLATE SQL_Latin1_General_CP1_CI_AS = C.strCuenta
--		WHERE C.intEmpresa = @intEmpresa
--		AND C.intCtaRegistro = 1
--		AND C.strCuenta = @strCuentaN
--		ORDER BY strCuenta,Fecha,Poliza ASC
--
--		DELETE FROM #TempCuentasAll WHERE dblImporte = 0
--
--		UPDATE C1
--		SET C1.dblSaldo = (SELECT SUM(C2.dblImporte) FROM #TempCuentasAll C2 WHERE (C2.id < C1.id) or (C2.id = C1.id))
--		FROM #TempCuentasAll C1
--
--		UPDATE T
--		SET T.Saldo = TT.dblSaldo
--		FROM #TempPolizas T
--		INNER JOIN #TempCuentasAll TT ON TT.strCuenta = T.strCuenta COLLATE SQL_Latin1_General_CP1_CI_AS AND T.Poliza = TT.strPoliza COLLATE SQL_Latin1_General_CP1_CI_AS
--		AND TT.strReferencia = T.Referencia AND TT.datFecha = T.Fecha
--
--		TRUNCATE TABLE #TempCuentasAll
--	END
--
--	DROP TABLE #TempCuentasN3
--	DROP TABLE #TempCuentasAll
	

	UPDATE T
	SET SaldoCargos = (SELECT SUM(ISNULL(Cargos,0)) FROM #TempPolizas TT WHERE TT.strCuenta = T.strCuenta)
	FROM #TempPolizas T

	UPDATE T
	SET SaldoAbonos = (SELECT SUM(ISNULL(Abonos,0)) FROM #TempPolizas TT WHERE TT.strCuenta = T.strCuenta)
	FROM #TempPolizas T

	UPDATE T
	SET SaldoActual = dblSaldoInicial + SaldoCargos - ABS(SaldoAbonos)
	FROM #TempPolizas T

	IF(@intCero = 1)
		DELETE FROM #TempPolizas WHERE SaldoActual = 0--strCuenta IN(SELECT strCuenta FROM #TempPolizas GROUP BY strCuenta HAVING SUM(CARGOS) = 0 AND SUM(ABONOS) = 0)


	SELECT @intEmpresa as intEmpresa,@strEmpresa as Empresa,Cuenta+SubCuenta+SubSubReporte AS Grupo,Cuenta,SubCuenta,
	SubSubReporte,CuentaNombre,Poliza,TipoPoliza,CONVERT(VARCHAR,Fecha,103) AS Fecha,CentroCosto,Referencia,Descripcion,Cargos,
	Abonos,Saldo,SaldoCargos,SaldoAbonos,SaldoActual,strCuenta,dblSaldoInicial,intNivel,Auxiliar,strHeader,strHeader2,
	dblHeader,dblHeader2
	FROM #TempPolizas	
	ORDER BY YEAR(Fecha), MONTH(Fecha), DAY(Fecha), TipoPoliza, Folio,Partida

	DROP TABLE #TempCuentas
	DROP TABLE #TempPolizas

SET NOCOUNT OFF
END
GO 

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbPolizasDet_Auxiliar Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbPolizasDet_Auxiliar Error on Creation'
END
GO


IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbPolizasDet_Balanza')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbPolizasDet_Balanza
	PRINT N'Drop Procedure : dbo.usp_tbPolizasDet_Balanza - Succeeded !!!'
END
GO

------------------------------------------------------------------------------------
---   Aplicacion: RMM.		                                                     ---
---        Autor: Ruben Mora Martinez                                            ---
---  Descripcion: Obtiene un registro de la tabla:  tbCotizacion                 ---
---                                                                              ---
------------------------------------------------------------------------------------
---    Fecha     Autor  Comentario                                               ---
---  ----------  -----  -------------------------------------------------------  ---
---  22/08/2011  RMM    Create procedure                                         ---
------------------------------------------------------------------------------------


CREATE PROCEDURE dbo.usp_tbPolizasDet_Balanza
( 
	@intEmpresa		int, 
	@intEjercicio	int,	
	@intMes			Int,	    
	@intNivel		int, 
	@strCuentaIni	VarChar(50), 
	@strCuentaFin	VarChar(50),
	@strObra		VarChar(50),
	@strObraFin		VarChar(50),
	@intAreaIni		INT, 
	@intAreaFin		INT,
	@intColIni		INT, 
	@intColFin		INT, 
	@intSectorIni	INT, 
	@intSectorFin	INT
)
AS    
BEGIN
	SET NOCOUNT ON    

	DECLARE @datFecha VARCHAR(50)
	DECLARE @strMes VARCHAR(100)
	DECLARE @strEmpresa VARCHAR(200)	

	------------------------------------INICIA FORMATO FECHA MDY-------------------------------------
	IF @intEmpresa = 22 
	BEGIN
		SET LANGUAGE ENGLISH  		

		SET @datFecha =  CONVERT(VARCHAR,@intMes) + '/01/' + CONVERT(VARCHAR,@intEjercicio)
	
		IF @intMes = 0
			SET @strMes = 'JAN 11 - DEC 11'
		ELSE
			SELECT @strMes = DATENAME(MONTH,CONVERT(DATETIME, @datFecha) )
	END
	ELSE
	BEGIN	
		SELECT @strMes = strNombre FROM tbMeses WHERE intMes = @intMes
	END
	------------------------------------FIN FORMATO FECHA MDY-------------------------------------

	CREATE TABLE #TmpObras(intObra INT)
	CREATE TABLE #TempCuentas(intEmpresa int, strCuenta VARCHAR(50) COLLATE SQL_Latin1_General_CP1_CI_AS, strNombre VARCHAR(200))
	CREATE TABLE #TempBalanza(strCuenta VARCHAR(50),strNombre VARCHAR(250),intNivel INT,SdoIni decimal(18,2),
	MesCargo decimal(18,2),MesAbono decimal(18,2),SdoFin decimal(18,2),Mes VARCHAR(50),intEmpresa VARCHAR(250))
	CREATE TABLE #TmpSaldos(intEmpresa int, strCuenta varchar(100), intObra VARCHAR(50), dblSaldoInicial decimal(18,2),
	dblSaldoCargos decimal(18,2), dblSaldoAbonos decimal(18,2))

	INSERT INTO #TmpObras(intObra)
	SELECT DISTINCT O.intObra
	FROM VetecMarfil.dbo.tbObra O 
	WHERE O.intEmpresa = @intEmpresa
	AND ((@strObra = '0') OR (O.strClave BETWEEN @strObra AND @strObraFin))
	AND ((@intAreaIni = 0) OR (CONVERT(int, SUBSTRING(O.strClave, 1, 2)) BETWEEN @intAreaIni AND @intAreaFin))
	AND ((@intColIni = 0 AND @intColFin = 0) OR (O.intColonia BETWEEN @intColIni AND @intColFin))
	AND ((@intSectorIni = 0 AND @intSectorFin = 0) OR (O.intSector BETWEEN @intSectorIni AND @intSectorFin))

	INSERT INTO #TempCuentas(intEmpresa, strCuenta, strNombre)
	SELECT intEmpresa, strCuenta,strNombre  
	FROM dbo.fn_tbCuentas_Nivel(@intEmpresa,@intnivel,@strCuentaIni,@strCuentaFin)

	SELECT @strEmpresa = strNombre FROM tbEmpresas WHERE intEmpresa = @intEmpresa

	INSERT INTO #TmpSaldos(intEmpresa,strCuenta,intObra,dblSaldoInicial,dblSaldoCargos,dblSaldoAbonos)
	SELECT CS.intEmpresa,CS.strCuenta,CS.strClasifDS,	
	SUM(CASE @intMes    
       WHEN 1  THEN IsNull(CS.dblSaldoInicial, 0)      
       WHEN 2  THEN IsNull(CS.dblSaldoInicial, 0) + ( IsNull(CS.dblCargo01, 0) - IsNull(CS.dblAbono01, 0) )     
       WHEN 3  THEN IsNull(CS.dblSaldoInicial, 0) + ( IsNull(CS.dblCargo01, 0) - IsNull(CS.dblAbono01, 0) + IsNull(CS.dblCargo02, 0) - IsNull(CS.dblAbono02, 0) )     
       WHEN 4  THEN IsNull(CS.dblSaldoInicial, 0) + ( IsNull(CS.dblCargo01, 0) - IsNull(CS.dblAbono01, 0) + IsNull(CS.dblCargo02, 0) - IsNull(CS.dblAbono02, 0) + IsNull(CS.dblCargo03, 0) - IsNull(CS.dblAbono03, 0) )     
       WHEN 5  THEN IsNull(CS.dblSaldoInicial, 0) + ( IsNull(CS.dblCargo01, 0) - IsNull(CS.dblAbono01, 0) + IsNull(CS.dblCargo02, 0) - IsNull(CS.dblAbono02, 0) + IsNull(CS.dblCargo03, 0) - IsNull(CS.dblAbono03, 0) + IsNull(CS.dblCargo04, 0) - IsNull(CS.dblAbono04, 0) )    
       WHEN 6  THEN IsNull(CS.dblSaldoInicial, 0) + ( IsNull(CS.dblCargo01, 0) - IsNull(CS.dblAbono01, 0) + IsNull(CS.dblCargo02, 0) - IsNull(CS.dblAbono02, 0) + IsNull(CS.dblCargo03, 0) - IsNull(CS.dblAbono03, 0) + IsNull(CS.dblCargo04, 0) - IsNull(CS.dblAbono04, 0) + IsNull(CS.dblCargo05, 0) - IsNull(CS.dblAbono05, 0) )     
       WHEN 7  THEN IsNull(CS.dblSaldoInicial, 0) + ( IsNull(CS.dblCargo01, 0) - IsNull(CS.dblAbono01, 0) + IsNull(CS.dblCargo02, 0) - IsNull(CS.dblAbono02, 0) + IsNull(CS.dblCargo03, 0) - IsNull(CS.dblAbono03, 0) + IsNull(CS.dblCargo04, 0) - IsNull(CS.dblAbono04, 0) + IsNull(CS.dblCargo05, 0) - IsNull(CS.dblAbono05, 0) + IsNull(CS.dblCargo06, 0) - IsNull(CS.dblAbono06, 0) )     
       WHEN 8  THEN IsNull(CS.dblSaldoInicial, 0) + ( IsNull(CS.dblCargo01, 0) - IsNull(CS.dblAbono01, 0) + IsNull(CS.dblCargo02, 0) - IsNull(CS.dblAbono02, 0) + IsNull(CS.dblCargo03, 0) - IsNull(CS.dblAbono03, 0) + IsNull(CS.dblCargo04, 0) - IsNull(CS.dblAbono04, 0) + IsNull(CS.dblCargo05, 0) - IsNull(CS.dblAbono05, 0) + IsNull(CS.dblCargo06, 0) - IsNull(CS.dblAbono06, 0) + IsNull(CS.dblCargo07, 0) - IsNull(CS.dblAbono07, 0) )     
       WHEN 9  THEN IsNull(CS.dblSaldoInicial, 0) + ( IsNull(CS.dblCargo01, 0) - IsNull(CS.dblAbono01, 0) + IsNull(CS.dblCargo02, 0) - IsNull(CS.dblAbono02, 0) + IsNull(CS.dblCargo03, 0) - IsNull(CS.dblAbono03, 0) + IsNull(CS.dblCargo04, 0) - IsNull(CS.dblAbono04, 0) + IsNull(CS.dblCargo05, 0) - IsNull(CS.dblAbono05, 0) + IsNull(CS.dblCargo06, 0) - IsNull(CS.dblAbono06, 0) + IsNull(CS.dblCargo07, 0) - IsNull(CS.dblAbono07, 0) + IsNull(CS.dblCargo08, 0) - IsNull(CS.dblAbono08, 0) )     
       WHEN 10 THEN IsNull(CS.dblSaldoInicial, 0) + ( IsNull(CS.dblCargo01, 0) - IsNull(CS.dblAbono01, 0) + IsNull(CS.dblCargo02, 0) - IsNull(CS.dblAbono02, 0) + IsNull(CS.dblCargo03, 0) - IsNull(CS.dblAbono03, 0) + IsNull(CS.dblCargo04, 0) - IsNull(CS.dblAbono04, 0) + IsNull(CS.dblCargo05, 0) - IsNull(CS.dblAbono05, 0) + IsNull(CS.dblCargo06, 0) - IsNull(CS.dblAbono06, 0) + IsNull(CS.dblCargo07, 0) - IsNull(CS.dblAbono07, 0) + IsNull(CS.dblCargo08, 0) - IsNull(CS.dblAbono08, 0) + IsNull(CS.dblCargo09, 0) - IsNull(CS.dblAbono09, 0) )     
       WHEN 11 THEN IsNull(CS.dblSaldoInicial, 0) + ( IsNull(CS.dblCargo01, 0) - IsNull(CS.dblAbono01, 0) + IsNull(CS.dblCargo02, 0) - IsNull(CS.dblAbono02, 0) + IsNull(CS.dblCargo03, 0) - IsNull(CS.dblAbono03, 0) + IsNull(CS.dblCargo04, 0) - IsNull(CS.dblAbono04, 0) + IsNull(CS.dblCargo05, 0) - IsNull(CS.dblAbono05, 0) + IsNull(CS.dblCargo06, 0) - IsNull(CS.dblAbono06, 0) + IsNull(CS.dblCargo07, 0) - IsNull(CS.dblAbono07, 0) + IsNull(CS.dblCargo08, 0) - IsNull(CS.dblAbono08, 0) + IsNull(CS.dblCargo09, 0) - IsNull(CS.dblAbono09, 0) + IsNull(CS.dblCargo10, 0) - IsNull(CS.dblAbono10, 0) )     
       WHEN 12 THEN IsNull(CS.dblSaldoInicial, 0) + ( IsNull(CS.dblCargo01, 0) - IsNull(CS.dblAbono01, 0) + IsNull(CS.dblCargo02, 0) - IsNull(CS.dblAbono02, 0) + IsNull(CS.dblCargo03, 0) - IsNull(CS.dblAbono03, 0) + IsNull(CS.dblCargo04, 0) - IsNull(CS.dblAbono04, 0) + IsNull(CS.dblCargo05, 0) - IsNull(CS.dblAbono05, 0) + IsNull(CS.dblCargo06, 0) - IsNull(CS.dblAbono06, 0) + IsNull(CS.dblCargo07, 0) - IsNull(CS.dblAbono07, 0) + IsNull(CS.dblCargo08, 0) - IsNull(CS.dblAbono08, 0) + IsNull(CS.dblCargo09, 0) - IsNull(CS.dblAbono09, 0) + IsNull(CS.dblCargo10, 0) - IsNull(CS.dblAbono10, 0) + IsNull(CS.dblCargo11, 0) - IsNull(CS.dblAbono11, 0) )
	   WHEN 0 Then IsNull(CS.dblSaldoInicial, 0) + ( IsNull(CS.dblCargo01, 0) - IsNull(CS.dblAbono01, 0) + IsNull(CS.dblCargo02, 0) - IsNull(CS.dblAbono02, 0) + IsNull(CS.dblCargo03, 0) - IsNull(CS.dblAbono03, 0) + IsNull(CS.dblCargo04, 0) - IsNull(CS.dblAbono04, 0) + IsNull(CS.dblCargo05, 0) - IsNull(CS.dblAbono05, 0) + IsNull(CS.dblCargo06, 0) - IsNull(CS.dblAbono06, 0) + IsNull(CS.dblCargo07, 0) - IsNull(CS.dblAbono07, 0) + IsNull(CS.dblCargo08, 0) - IsNull(CS.dblAbono08, 0) + IsNull(CS.dblCargo09, 0) - IsNull(CS.dblAbono09, 0) + IsNull(CS.dblCargo10, 0) - IsNull(CS.dblAbono10, 0) + IsNull(CS.dblCargo11, 0) - IsNull(CS.dblAbono11, 0) + IsNull(CS.dblCargo12, 0) - IsNull(CS.dblAbono12, 0) )
       END ),
	SUM(CASE @intMes    
          WHEN 1  THEN IsNull(CS.dblCargo01,0)   
          WHEN 2  THEN IsNull(CS.dblCargo02,0)
          WHEN 3  THEN IsNull(CS.dblCargo03,0)
          WHEN 4  THEN IsNull(CS.dblCargo04,0)
          WHEN 5  THEN IsNull(CS.dblCargo05,0)
		  WHEN 6  THEN IsNull(CS.dblCargo06,0)   
          WHEN 7  THEN IsNull(CS.dblCargo07,0)
          WHEN 8  THEN IsNull(CS.dblCargo08,0)
          WHEN 9  THEN IsNull(CS.dblCargo09,0)
          WHEN 10  THEN IsNull(CS.dblCargo10,0)
		  WHEN 11  THEN IsNull(CS.dblCargo11,0)   
          WHEN 12  THEN IsNull(CS.dblCargo12,0)
          END ),
	SUM(CASE @intMes    
          WHEN 1  THEN IsNull(CS.dblAbono01,0)   
          WHEN 2  THEN IsNull(CS.dblAbono02,0)
          WHEN 3  THEN IsNull(CS.dblAbono03,0)
          WHEN 4  THEN IsNull(CS.dblAbono04,0)
          WHEN 5  THEN IsNull(CS.dblAbono05,0)
		  WHEN 6  THEN IsNull(CS.dblAbono06,0)   
          WHEN 7  THEN IsNull(CS.dblAbono07,0)
          WHEN 8  THEN IsNull(CS.dblAbono08,0)
          WHEN 9  THEN IsNull(CS.dblAbono09,0)
          WHEN 10  THEN IsNull(CS.dblAbono10,0)
		  WHEN 11  THEN IsNull(CS.dblAbono11,0)   
          WHEN 12  THEN IsNull(CS.dblAbono12,0)
          END )	
	FROM tbCuentasSaldos CS
	WHERE CS.intEmpresa = @intEmpresa
	AND CS.intEjercicio = @intEjercicio 
	AND CS.strCuenta IN (SELECT strCuenta FROM #TempCuentas)
	AND CS.strClasifDS IN (SELECT CONVERT(VARCHAR,intObra) FROM #TmpObras)
	AND ISNULL(CS.strClasifDS,'0') <> '0'
	GROUP BY CS.intEmpresa,CS.strCuenta,CS.strClasifDS

	INSERT INTO #TempBalanza(strCuenta,strNombre,intNivel,SdoIni,MesCargo,MesAbono,Mes,intEmpresa)
	SELECT  CS.strCuenta,C.strNombre,1,SUM(CS.dblSaldoInicial),SUM(CS.dblSaldoCargos),SUM(CS.dblSaldoAbonos),
	@strMes,@strEmpresa				
	FROM #TmpSaldos CS
	INNER JOIN #TempCuentas C ON C.strCuenta COLLATE SQL_Latin1_General_CP1_CI_AS = CS.strCuenta AND C.intEmpresa = CS.intEmpresa
	LEFT JOIN VetecMarfil.dbo.tbObra O ON O.intObra = CS.intObra AND O.intEmpresa = CS.intEmpresa
	LEFT JOIN VetecMarfil.dbo.tbColonia Col ON Col.intColonia = SUBSTRING(O.strClave, 4, 2)
	WHERE CS.intEmpresa = @intEmpresa
	GROUP BY CS.strCuenta,C.strNombre
			
	UPDATE #TempBalanza SET SdoFin = SdoIni + MesCargo - MesAbono

	SELECT	strCuenta,strNombre,intNivel,SdoIni,MesCargo,MesAbono,SdoFin,Mes,intEmpresa
	FROM #TempBalanza
	ORDER BY strCuenta

	DROP TABLE #TempBalanza
	DROP TABLE #TempCuentas
	DROP TABLE #TmpObras
	DROP TABLE #TmpSaldos

SET NOCOUNT OFF
END
GO 

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbPolizasDet_Balanza Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbPolizasDet_Balanza Error on Creation'
END
GO


IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbPolizasDet_BalanzaCuenta')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbPolizasDet_BalanzaCuenta
	PRINT N'Drop Procedure : dbo.usp_tbPolizasDet_BalanzaCuenta - Succeeded !!!'
END
GO

------------------------------------------------------------------------------------
---   Aplicacion: RMM.		                                                     ---
---        Autor: Ruben Mora Martinez                                            ---
---  Descripcion: Obtiene un registro de la tabla:  tbCotizacion                 ---
---                                                                              ---
------------------------------------------------------------------------------------
---    Fecha     Autor  Comentario                                               ---
---  ----------  -----  -------------------------------------------------------  ---
---  22/08/2011  RMM    Create procedure                                         ---
------------------------------------------------------------------------------------


CREATE PROCEDURE dbo.usp_tbPolizasDet_BalanzaCuenta
( 
	@intEmpresa		int, 
	@intEjercicio	int,	
	@intMes			Int,	    
	@intNivel		int, 
	@strCuentaIni	VarChar(50), 
	@strCuentaFin	VarChar(50),
	@strObra		VarChar(50),
	@strObraFin		VarChar(50),
	@intAreaIni		INT, 
	@intAreaFin		INT,
	@intColIni		INT, 
	@intColFin		INT, 
	@intSectorIni	INT, 
	@intSectorFin	INT,
	@intCargo		INT
)
AS    
BEGIN
	SET NOCOUNT ON    

	DECLARE @Suma DECIMAL(18,2)
	
	CREATE TABLE #TmpObras(intObra INT)
	CREATE TABLE #TempCuentas(intEmpresa int, strCuenta VARCHAR(50) COLLATE SQL_Latin1_General_CP1_CI_AS, strNombre VARCHAR(200))
	CREATE TABLE #Polizas(strPoliza VARCHAR(50),strCuenta VARCHAR(50), strAuxiliar VARCHAR(50), strObra VARCHAR(10), dblImporte DECIMAL(18,2))
		
	INSERT INTO #TmpObras(intObra)
	SELECT DISTINCT O.intObra
	FROM VetecMarfil.dbo.tbObra O 
	WHERE O.intEmpresa = @intEmpresa
	AND ((@strObra = '0') OR (O.strClave BETWEEN @strObra AND @strObraFin))
	AND ((@intAreaIni = 0) OR (CONVERT(int, SUBSTRING(O.strClave, 1, 2)) BETWEEN @intAreaIni AND @intAreaFin))
	AND ((@intColIni = 0 AND @intColFin = 0) OR (O.intColonia BETWEEN @intColIni AND @intColFin))
	AND ((@intSectorIni = 0 AND @intSectorFin = 0) OR (O.intSector BETWEEN @intSectorIni AND @intSectorFin))

	INSERT INTO #TempCuentas(intEmpresa, strCuenta, strNombre)
	SELECT intEmpresa, strCuenta,strNombre  
	FROM dbo.fn_tbCuentas_Nivel(@intEmpresa,@intnivel,@strCuentaIni,@strCuentaFin)

	INSERT INTO #Polizas(strPoliza,strCuenta,strAuxiliar,strObra,dblImporte)
	SELECT PD.strPoliza,PD.strCuenta, PD.strClasifDP,PD.strClasifDS,PD.dblImporte
	FROM tbPolizasDet PD
	INNER JOIN tbPolizasEnc PE ON PE.intEmpresa = PD.intEmpresa AND PE.strPoliza = PD.strPoliza AND PE.intEjercicio = PD.intEjercicio
	WHERE PD.intEmpresa = @intEmpresa
	AND PD.intEjercicio = @intEjercicio
	AND PD.intMes = @intMes
	AND PD.intIndAfectada = 1
	AND PE.intEstatus <> 9	
	AND PD.intTipoMovto = @intCargo	
	AND PD.strClasifDS IN(SELECT DISTINCT intObra FROM #TmpObras)
	AND LEFT(PD.strCuenta,4) IN (SELECT DISTINCT strCuenta FROM #TempCuentas)
	AND ((PD.strClasifDS <> '0') OR (PD.strClasifDS IS NOT NULL))

	SELECT @Suma = SUM(DBLiMPORTE) FROM #Polizas

	SELECT strPoliza,strCuenta,strAuxiliar,strObra,'$ ' + CONVERT(VARCHAR,CONVERT(MONEY,dblImporte),1) AS dblImporte,
	'$ ' + CONVERT(VARCHAR,CONVERT(MONEY,@Suma),1) AS Total
	FROM #Polizas


	DROP TABLE #Polizas
	DROP TABLE #TempCuentas
	DROP TABLE #TmpObras

SET NOCOUNT OFF
END
GO 

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbPolizasDet_BalanzaCuenta Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbPolizasDet_BalanzaCuenta Error on Creation'
END
GO



IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbPolizasDet_Balanza_Cero')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbPolizasDet_Balanza_Cero
	PRINT N'Drop Procedure : dbo.usp_tbPolizasDet_Balanza_Cero - Succeeded !!!'
END
GO

------------------------------------------------------------------------------------
---   Aplicacion: RMM.		                                                     ---
---        Autor: Ruben Mora Martinez                                            ---
---  Descripcion: Obtiene un registro de la tabla:  tbCotizacion                 ---
---                                                                              ---
------------------------------------------------------------------------------------
---    Fecha     Autor  Comentario                                               ---
---  ----------  -----  -------------------------------------------------------  ---
---  22/08/2011  RMM    Create procedure                                         ---
------------------------------------------------------------------------------------


CREATE PROCEDURE dbo.usp_tbPolizasDet_Balanza_Cero
( 
	@intEmpresa		int, 
	@intEjercicio	int,	
	@intMes			Int,	    
	@intNivel		int, 
	@strCuentaIni	VarChar(50), 
	@strCuentaFin	VarChar(50),
	@strObra		VarChar(50),
	@strObraFin		VarChar(50),
	@intAreaIni		INT, 
	@intAreaFin		INT,
	@intColIni		INT, 
	@intColFin		INT, 
	@intSectorIni	INT, 
	@intSectorFin	INT
)
AS    
BEGIN
	SET NOCOUNT ON    

	DECLARE @datFecha VARCHAR(50)
	DECLARE @strMes VARCHAR(100)
	DECLARE @strEmpresa VARCHAR(200)	

	------------------------------------INICIA FORMATO FECHA MDY-------------------------------------
	IF @intEmpresa = 22 
	BEGIN
		SET LANGUAGE ENGLISH  		

		SET @datFecha =  CONVERT(VARCHAR,@intMes) + '/01/' + CONVERT(VARCHAR,@intEjercicio)
	
		IF @intMes = 0
			SET @strMes = 'JAN 11 - DEC 11'
		ELSE
			SELECT @strMes = DATENAME(MONTH,CONVERT(DATETIME, @datFecha) )
	END
	ELSE
	BEGIN	
		SELECT @strMes = strNombre FROM tbMeses WHERE intMes = @intMes
	END
	------------------------------------FIN FORMATO FECHA MDY-------------------------------------

	CREATE TABLE #TmpObras(intObra INT)
	CREATE TABLE #TempCuentas(intEmpresa int, strCuenta VARCHAR(50) COLLATE SQL_Latin1_General_CP1_CI_AS, strNombre VARCHAR(200))
	CREATE TABLE #TempBalanza(strCuenta VARCHAR(50),strNombre VARCHAR(250),intNivel INT,SdoIni decimal(18,2),
	MesCargo decimal(18,2),MesAbono decimal(18,2),SdoFin decimal(18,2),Mes VARCHAR(50),intEmpresa VARCHAR(250))
	CREATE TABLE #TmpSaldos(intEmpresa int, strCuenta varchar(100), intObra INT, dblSaldoInicial decimal(18,2),
	dblSaldoCargos decimal(18,2), dblSaldoAbonos decimal(18,2))

	INSERT INTO #TmpObras(intObra)
	SELECT DISTINCT O.intObra
	FROM VetecMarfil.dbo.tbObra O 
	WHERE O.intEmpresa = @intEmpresa
	AND ((@strObra = '0') OR (O.strClave BETWEEN @strObra AND @strObraFin))
	AND ((@intAreaIni = 0) OR (CONVERT(int, SUBSTRING(O.strClave, 1, 2)) BETWEEN @intAreaIni AND @intAreaFin))
	AND ((@intColIni = 0 AND @intColFin = 0) OR (O.intColonia BETWEEN @intColIni AND @intColFin))
	AND ((@intSectorIni = 0 AND @intSectorFin = 0) OR (O.intSector BETWEEN @intSectorIni AND @intSectorFin))

	INSERT INTO #TempCuentas(intEmpresa, strCuenta, strNombre)
	SELECT intEmpresa, strCuenta,strNombre  
	FROM dbo.fn_tbCuentas_Nivel(@intEmpresa,@intnivel,@strCuentaIni,@strCuentaFin)

	SELECT @strEmpresa = strNombre FROM tbEmpresas WHERE intEmpresa = @intEmpresa	

	INSERT INTO #TmpSaldos(intEmpresa,strCuenta,intObra,dblSaldoInicial,dblSaldoCargos,dblSaldoAbonos)
	SELECT CS.intEmpresa,CS.strCuenta,CS.strClasifDS,	
	SUM(CASE @intMes    
          WHEN 1  THEN IsNull(CS.dblSaldoInicial, 0)      
          WHEN 2  THEN IsNull(CS.dblSaldoInicial, 0) + ( IsNull(CS.dblCargo01, 0) - IsNull(CS.dblAbono01, 0) )     
          WHEN 3  THEN IsNull(CS.dblSaldoInicial, 0) + ( IsNull(CS.dblCargo01, 0) - IsNull(CS.dblAbono01, 0) + IsNull(CS.dblCargo02, 0) - IsNull(CS.dblAbono02, 0) )     
          WHEN 4  THEN IsNull(CS.dblSaldoInicial, 0) + ( IsNull(CS.dblCargo01, 0) - IsNull(CS.dblAbono01, 0) + IsNull(CS.dblCargo02, 0) - IsNull(CS.dblAbono02, 0) + IsNull(CS.dblCargo03, 0) - IsNull(CS.dblAbono03, 0) )     
          WHEN 5  THEN IsNull(CS.dblSaldoInicial, 0) + ( IsNull(CS.dblCargo01, 0) - IsNull(CS.dblAbono01, 0) + IsNull(CS.dblCargo02, 0) - IsNull(CS.dblAbono02, 0) + IsNull(CS.dblCargo03, 0) - IsNull(CS.dblAbono03, 0) + IsNull(CS.dblCargo04, 0) - IsNull(CS.dblAbono04, 0) )    
          WHEN 6  THEN IsNull(CS.dblSaldoInicial, 0) + ( IsNull(CS.dblCargo01, 0) - IsNull(CS.dblAbono01, 0) + IsNull(CS.dblCargo02, 0) - IsNull(CS.dblAbono02, 0) + IsNull(CS.dblCargo03, 0) - IsNull(CS.dblAbono03, 0) + IsNull(CS.dblCargo04, 0) - IsNull(CS.dblAbono04, 0) + IsNull(CS.dblCargo05, 0) - IsNull(CS.dblAbono05, 0) )     
          WHEN 7  THEN IsNull(CS.dblSaldoInicial, 0) + ( IsNull(CS.dblCargo01, 0) - IsNull(CS.dblAbono01, 0) + IsNull(CS.dblCargo02, 0) - IsNull(CS.dblAbono02, 0) + IsNull(CS.dblCargo03, 0) - IsNull(CS.dblAbono03, 0) + IsNull(CS.dblCargo04, 0) - IsNull(CS.dblAbono04, 0) + IsNull(CS.dblCargo05, 0) - IsNull(CS.dblAbono05, 0) + IsNull(CS.dblCargo06, 0) - IsNull(CS.dblAbono06, 0) )     
          WHEN 8  THEN IsNull(CS.dblSaldoInicial, 0) + ( IsNull(CS.dblCargo01, 0) - IsNull(CS.dblAbono01, 0) + IsNull(CS.dblCargo02, 0) - IsNull(CS.dblAbono02, 0) + IsNull(CS.dblCargo03, 0) - IsNull(CS.dblAbono03, 0) + IsNull(CS.dblCargo04, 0) - IsNull(CS.dblAbono04, 0) + IsNull(CS.dblCargo05, 0) - IsNull(CS.dblAbono05, 0) + IsNull(CS.dblCargo06, 0) - IsNull(CS.dblAbono06, 0) + IsNull(CS.dblCargo07, 0) - IsNull(CS.dblAbono07, 0) )     
          WHEN 9  THEN IsNull(CS.dblSaldoInicial, 0) + ( IsNull(CS.dblCargo01, 0) - IsNull(CS.dblAbono01, 0) + IsNull(CS.dblCargo02, 0) - IsNull(CS.dblAbono02, 0) + IsNull(CS.dblCargo03, 0) - IsNull(CS.dblAbono03, 0) + IsNull(CS.dblCargo04, 0) - IsNull(CS.dblAbono04, 0) + IsNull(CS.dblCargo05, 0) - IsNull(CS.dblAbono05, 0) + IsNull(CS.dblCargo06, 0) - IsNull(CS.dblAbono06, 0) + IsNull(CS.dblCargo07, 0) - IsNull(CS.dblAbono07, 0) + IsNull(CS.dblCargo08, 0) - IsNull(CS.dblAbono08, 0) )     
          WHEN 10 THEN IsNull(CS.dblSaldoInicial, 0) + ( IsNull(CS.dblCargo01, 0) - IsNull(CS.dblAbono01, 0) + IsNull(CS.dblCargo02, 0) - IsNull(CS.dblAbono02, 0) + IsNull(CS.dblCargo03, 0) - IsNull(CS.dblAbono03, 0) + IsNull(CS.dblCargo04, 0) - IsNull(CS.dblAbono04, 0) + IsNull(CS.dblCargo05, 0) - IsNull(CS.dblAbono05, 0) + IsNull(CS.dblCargo06, 0) - IsNull(CS.dblAbono06, 0) + IsNull(CS.dblCargo07, 0) - IsNull(CS.dblAbono07, 0) + IsNull(CS.dblCargo08, 0) - IsNull(CS.dblAbono08, 0) + IsNull(CS.dblCargo09, 0) - IsNull(CS.dblAbono09, 0) )     
          WHEN 11 THEN IsNull(CS.dblSaldoInicial, 0) + ( IsNull(CS.dblCargo01, 0) - IsNull(CS.dblAbono01, 0) + IsNull(CS.dblCargo02, 0) - IsNull(CS.dblAbono02, 0) + IsNull(CS.dblCargo03, 0) - IsNull(CS.dblAbono03, 0) + IsNull(CS.dblCargo04, 0) - IsNull(CS.dblAbono04, 0) + IsNull(CS.dblCargo05, 0) - IsNull(CS.dblAbono05, 0) + IsNull(CS.dblCargo06, 0) - IsNull(CS.dblAbono06, 0) + IsNull(CS.dblCargo07, 0) - IsNull(CS.dblAbono07, 0) + IsNull(CS.dblCargo08, 0) - IsNull(CS.dblAbono08, 0) + IsNull(CS.dblCargo09, 0) - IsNull(CS.dblAbono09, 0) + IsNull(CS.dblCargo10, 0) - IsNull(CS.dblAbono10, 0) )     
          WHEN 12 THEN IsNull(CS.dblSaldoInicial, 0) + ( IsNull(CS.dblCargo01, 0) - IsNull(CS.dblAbono01, 0) + IsNull(CS.dblCargo02, 0) - IsNull(CS.dblAbono02, 0) + IsNull(CS.dblCargo03, 0) - IsNull(CS.dblAbono03, 0) + IsNull(CS.dblCargo04, 0) - IsNull(CS.dblAbono04, 0) + IsNull(CS.dblCargo05, 0) - IsNull(CS.dblAbono05, 0) + IsNull(CS.dblCargo06, 0) - IsNull(CS.dblAbono06, 0) + IsNull(CS.dblCargo07, 0) - IsNull(CS.dblAbono07, 0) + IsNull(CS.dblCargo08, 0) - IsNull(CS.dblAbono08, 0) + IsNull(CS.dblCargo09, 0) - IsNull(CS.dblAbono09, 0) + IsNull(CS.dblCargo10, 0) - IsNull(CS.dblAbono10, 0) + IsNull(CS.dblCargo11, 0) - IsNull(CS.dblAbono11, 0) )    
		  WHEN 0 THEN IsNull(CS.dblSaldoInicial, 0) + ( IsNull(CS.dblCargo01, 0) - IsNull(CS.dblAbono01, 0) + IsNull(CS.dblCargo02, 0) - IsNull(CS.dblAbono02, 0) + IsNull(CS.dblCargo03, 0) - IsNull(CS.dblAbono03, 0) + IsNull(CS.dblCargo04, 0) - IsNull(CS.dblAbono04, 0) + IsNull(CS.dblCargo05, 0) - IsNull(CS.dblAbono05, 0) + IsNull(CS.dblCargo06, 0) - IsNull(CS.dblAbono06, 0) + IsNull(CS.dblCargo07, 0) - IsNull(CS.dblAbono07, 0) + IsNull(CS.dblCargo08, 0) - IsNull(CS.dblAbono08, 0) + IsNull(CS.dblCargo09, 0) - IsNull(CS.dblAbono09, 0) + IsNull(CS.dblCargo10, 0) - IsNull(CS.dblAbono10, 0) + IsNull(CS.dblCargo11, 0) - IsNull(CS.dblAbono11, 0) + IsNull(CS.dblCargo12, 0) - IsNull(CS.dblAbono12, 0) )    
          END),
	SUM(CASE @intMes    
          WHEN 1  THEN IsNull(CS.dblCargo01,0)   
          WHEN 2  THEN IsNull(CS.dblCargo02,0)
          WHEN 3  THEN IsNull(CS.dblCargo03,0)
          WHEN 4  THEN IsNull(CS.dblCargo04,0)
          WHEN 5  THEN IsNull(CS.dblCargo05,0)
		  WHEN 6  THEN IsNull(CS.dblCargo06,0)   
          WHEN 7  THEN IsNull(CS.dblCargo07,0)
          WHEN 8  THEN IsNull(CS.dblCargo08,0)
          WHEN 9  THEN IsNull(CS.dblCargo09,0)
          WHEN 10  THEN IsNull(CS.dblCargo10,0)
		  WHEN 11  THEN IsNull(CS.dblCargo11,0)   
          WHEN 12  THEN IsNull(CS.dblCargo12,0)
          END ),
	SUM(CASE @intMes    
          WHEN 1  THEN IsNull(CS.dblAbono01,0)   
          WHEN 2  THEN IsNull(CS.dblAbono02,0)
          WHEN 3  THEN IsNull(CS.dblAbono03,0)
          WHEN 4  THEN IsNull(CS.dblAbono04,0)
          WHEN 5  THEN IsNull(CS.dblAbono05,0)
		  WHEN 6  THEN IsNull(CS.dblAbono06,0)   
          WHEN 7  THEN IsNull(CS.dblAbono07,0)
          WHEN 8  THEN IsNull(CS.dblAbono08,0)
          WHEN 9  THEN IsNull(CS.dblAbono09,0)
          WHEN 10  THEN IsNull(CS.dblAbono10,0)
		  WHEN 11  THEN IsNull(CS.dblAbono11,0)   
          WHEN 12  THEN IsNull(CS.dblAbono12,0)
          END )	
	FROM tbCuentasSaldos CS
	WHERE CS.intEmpresa = @intEmpresa
	AND CS.intEjercicio = 2013 
	AND CS.strCuenta IN (SELECT strCuenta FROM #TempCuentas)
	AND CS.strClasifDS IN (SELECT intObra FROM #TmpObras)
	AND ((CS.strClasifDS <> '0') OR (CS.strClasifDS IS NOT NULL))
	GROUP BY CS.intEmpresa,CS.strCuenta,CS.strClasifDS

	INSERT INTO #TempBalanza(strCuenta,strNombre,intNivel,SdoIni,MesCargo,MesAbono,Mes,intEmpresa)
	SELECT  CS.strCuenta,C.strNombre,1,SUM(CS.dblSaldoInicial),SUM(CS.dblSaldoCargos),SUM(CS.dblSaldoAbonos),
	@strMes,@strEmpresa				
	FROM #TmpSaldos CS
	INNER JOIN #TempCuentas C ON C.strCuenta COLLATE SQL_Latin1_General_CP1_CI_AS = CS.strCuenta AND C.intEmpresa = CS.intEmpresa
	INNER JOIN VetecMarfil.dbo.tbObra O ON O.intObra = CS.intObra AND O.intEmpresa = CS.intEmpresa
	LEFT JOIN VetecMarfil.dbo.tbColonia Col ON Col.intColonia = SUBSTRING(O.strClave, 4, 2)
	WHERE CS.intEmpresa = @intEmpresa
	GROUP BY CS.strCuenta,C.strNombre
			
	UPDATE #TempBalanza SET SdoFin = SdoIni + MesCargo - MesAbono

	SELECT	strCuenta,strNombre,intNivel,SdoIni,MesCargo,MesAbono,SdoFin,Mes,intEmpresa
	FROM #TempBalanza
	WHERE ISNULL(SdoIni,0) + ISNULL(MesCargo,0) - ISNULL(MesAbono,0) + ISNULL(SdoFin,0) = 0
	ORDER BY strCuenta

	DROP TABLE #TempBalanza
	DROP TABLE #TempCuentas
	DROP TABLE #TmpObras
	DROP TABLE #TmpSaldos

SET NOCOUNT OFF
END
GO 

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbPolizasDet_Balanza_Cero Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbPolizasDet_Balanza_Cero Error on Creation'
END
GO


IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbPolizasDet_Balanza_Obra')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbPolizasDet_Balanza_Obra
	PRINT N'Drop Procedure : dbo.usp_tbPolizasDet_Balanza_Obra - Succeeded !!!'
END
GO

------------------------------------------------------------------------------------
---   Aplicacion: RMM.		                                                     ---
---        Autor: Ruben Mora Martinez                                            ---
---  Descripcion: Obtiene un registro de la tabla:  tbCotizacion                 ---
---                                                                              ---
------------------------------------------------------------------------------------
---    Fecha     Autor  Comentario                                               ---
---  ----------  -----  -------------------------------------------------------  ---
---  22/08/2011  RMM    Create procedure                                         ---
------------------------------------------------------------------------------------


CREATE PROCEDURE dbo.usp_tbPolizasDet_Balanza_Obra
( 
	@intEmpresa		int, 
	@intEjercicio	int,	
	@intMes			Int,	    
	@intNivel		int, 
	@strCuentaIni	VarChar(50), 
	@strCuentaFin	VarChar(50),
	@strObra		VarChar(50),
	@strObraFin		VarChar(50),
	@intAreaIni		INT, 
	@intAreaFin		INT,
	@intColIni		INT, 
	@intColFin		INT, 
	@intSectorIni	INT, 
	@intSectorFin	INT
)
AS    
BEGIN
	SET NOCOUNT ON    

	DECLARE @datFecha VARCHAR(50)
	DECLARE @strMes VARCHAR(100)
	DECLARE @strEmpresa VARCHAR(200)	

	------------------------------------INICIA FORMATO FECHA MDY-------------------------------------
	IF @intEmpresa = 22 
	BEGIN
		SET LANGUAGE ENGLISH  		

		SET @datFecha =  CONVERT(VARCHAR,@intMes) + '/01/' + CONVERT(VARCHAR,@intEjercicio)
	
		IF @intMes = 0
			SET @strMes = 'JAN 11 - DEC 11'
		ELSE
			SELECT @strMes = DATENAME(MONTH,CONVERT(DATETIME, @datFecha) )
	END
	ELSE
	BEGIN	
		SELECT @strMes = strNombre FROM tbMeses WHERE intMes = @intMes
	END
	------------------------------------FIN FORMATO FECHA MDY-------------------------------------

	CREATE TABLE #TmpObras(intObra INT)
	CREATE TABLE #TempCuentas(intEmpresa int, strCuenta VARCHAR(50) COLLATE SQL_Latin1_General_CP1_CI_AS, strNombre VARCHAR(200))
	CREATE TABLE #TempBalanza(intEmpresa INT,strEmpresa VARCHAR(250),strCuenta VARCHAR(100),strNomCuenta VARCHAR(250), 
	Nivel1 VARCHAR(10), Nivel2 VARCHAR(10), Nivel3 VARCHAR(10), strMes VARCHAR(20), intEjercicio INT, 
	intObra INT, strObra VARCHAR(250), strClaveObra VARCHAR(100), intColonia INT, strNombreColonia VARCHAR(250), 
	dblSaldoInicial decimal(18,2),dblCargo decimal(18,2), dblAbono decimal(18,2), dblSaldoFinal decimal(18,2), intNivel INT)
	CREATE TABLE #TmpSaldos(intEmpresa int, strCuenta varchar(100), intObra INT, dblSaldoInicial decimal(18,2),
	dblSaldoCargos decimal(18,2), dblSaldoAbonos decimal(18,2))

	INSERT INTO #TmpObras(intObra)
	SELECT DISTINCT O.intObra
	FROM VetecMarfil.dbo.tbObra O 
	WHERE O.intEmpresa = @intEmpresa
	AND ((@strObra = '0') OR (O.strClave BETWEEN @strObra AND @strObraFin))
	AND ((@intAreaIni = 0) OR (CONVERT(int, SUBSTRING(O.strClave, 1, 2)) BETWEEN @intAreaIni AND @intAreaFin))
	AND ((@intColIni = 0 AND @intColFin = 0) OR (O.intColonia BETWEEN @intColIni AND @intColFin))
	AND ((@intSectorIni = 0 AND @intSectorFin = 0) OR (O.intSector BETWEEN @intSectorIni AND @intSectorFin))

	INSERT INTO #TempCuentas(intEmpresa, strCuenta, strNombre)
	SELECT intEmpresa, strCuenta,strNombre  
	FROM dbo.fn_tbCuentas_Nivel(@intEmpresa,@intnivel,@strCuentaIni,@strCuentaFin)

	SELECT @strEmpresa = strNombre FROM tbEmpresas WHERE intEmpresa = @intEmpresa	

	INSERT INTO #TmpSaldos(intEmpresa,strCuenta,intObra,dblSaldoInicial,dblSaldoCargos,dblSaldoAbonos)
	SELECT CS.intEmpresa,CS.strCuenta,CS.strClasifDS,	
	SUM(CASE @intMes    
          WHEN 1  THEN IsNull(CS.dblSaldoInicial, 0)      
          WHEN 2  THEN IsNull(CS.dblSaldoInicial, 0) + ( IsNull(CS.dblCargo01, 0) - IsNull(CS.dblAbono01, 0) )     
          WHEN 3  THEN IsNull(CS.dblSaldoInicial, 0) + ( IsNull(CS.dblCargo01, 0) - IsNull(CS.dblAbono01, 0) + IsNull(CS.dblCargo02, 0) - IsNull(CS.dblAbono02, 0) )     
          WHEN 4  THEN IsNull(CS.dblSaldoInicial, 0) + ( IsNull(CS.dblCargo01, 0) - IsNull(CS.dblAbono01, 0) + IsNull(CS.dblCargo02, 0) - IsNull(CS.dblAbono02, 0) + IsNull(CS.dblCargo03, 0) - IsNull(CS.dblAbono03, 0) )     
          WHEN 5  THEN IsNull(CS.dblSaldoInicial, 0) + ( IsNull(CS.dblCargo01, 0) - IsNull(CS.dblAbono01, 0) + IsNull(CS.dblCargo02, 0) - IsNull(CS.dblAbono02, 0) + IsNull(CS.dblCargo03, 0) - IsNull(CS.dblAbono03, 0) + IsNull(CS.dblCargo04, 0) - IsNull(CS.dblAbono04, 0) )    
          WHEN 6  THEN IsNull(CS.dblSaldoInicial, 0) + ( IsNull(CS.dblCargo01, 0) - IsNull(CS.dblAbono01, 0) + IsNull(CS.dblCargo02, 0) - IsNull(CS.dblAbono02, 0) + IsNull(CS.dblCargo03, 0) - IsNull(CS.dblAbono03, 0) + IsNull(CS.dblCargo04, 0) - IsNull(CS.dblAbono04, 0) + IsNull(CS.dblCargo05, 0) - IsNull(CS.dblAbono05, 0) )     
          WHEN 7  THEN IsNull(CS.dblSaldoInicial, 0) + ( IsNull(CS.dblCargo01, 0) - IsNull(CS.dblAbono01, 0) + IsNull(CS.dblCargo02, 0) - IsNull(CS.dblAbono02, 0) + IsNull(CS.dblCargo03, 0) - IsNull(CS.dblAbono03, 0) + IsNull(CS.dblCargo04, 0) - IsNull(CS.dblAbono04, 0) + IsNull(CS.dblCargo05, 0) - IsNull(CS.dblAbono05, 0) + IsNull(CS.dblCargo06, 0) - IsNull(CS.dblAbono06, 0) )     
          WHEN 8  THEN IsNull(CS.dblSaldoInicial, 0) + ( IsNull(CS.dblCargo01, 0) - IsNull(CS.dblAbono01, 0) + IsNull(CS.dblCargo02, 0) - IsNull(CS.dblAbono02, 0) + IsNull(CS.dblCargo03, 0) - IsNull(CS.dblAbono03, 0) + IsNull(CS.dblCargo04, 0) - IsNull(CS.dblAbono04, 0) + IsNull(CS.dblCargo05, 0) - IsNull(CS.dblAbono05, 0) + IsNull(CS.dblCargo06, 0) - IsNull(CS.dblAbono06, 0) + IsNull(CS.dblCargo07, 0) - IsNull(CS.dblAbono07, 0) )     
          WHEN 9  THEN IsNull(CS.dblSaldoInicial, 0) + ( IsNull(CS.dblCargo01, 0) - IsNull(CS.dblAbono01, 0) + IsNull(CS.dblCargo02, 0) - IsNull(CS.dblAbono02, 0) + IsNull(CS.dblCargo03, 0) - IsNull(CS.dblAbono03, 0) + IsNull(CS.dblCargo04, 0) - IsNull(CS.dblAbono04, 0) + IsNull(CS.dblCargo05, 0) - IsNull(CS.dblAbono05, 0) + IsNull(CS.dblCargo06, 0) - IsNull(CS.dblAbono06, 0) + IsNull(CS.dblCargo07, 0) - IsNull(CS.dblAbono07, 0) + IsNull(CS.dblCargo08, 0) - IsNull(CS.dblAbono08, 0) )     
          WHEN 10 THEN IsNull(CS.dblSaldoInicial, 0) + ( IsNull(CS.dblCargo01, 0) - IsNull(CS.dblAbono01, 0) + IsNull(CS.dblCargo02, 0) - IsNull(CS.dblAbono02, 0) + IsNull(CS.dblCargo03, 0) - IsNull(CS.dblAbono03, 0) + IsNull(CS.dblCargo04, 0) - IsNull(CS.dblAbono04, 0) + IsNull(CS.dblCargo05, 0) - IsNull(CS.dblAbono05, 0) + IsNull(CS.dblCargo06, 0) - IsNull(CS.dblAbono06, 0) + IsNull(CS.dblCargo07, 0) - IsNull(CS.dblAbono07, 0) + IsNull(CS.dblCargo08, 0) - IsNull(CS.dblAbono08, 0) + IsNull(CS.dblCargo09, 0) - IsNull(CS.dblAbono09, 0) )     
          WHEN 11 THEN IsNull(CS.dblSaldoInicial, 0) + ( IsNull(CS.dblCargo01, 0) - IsNull(CS.dblAbono01, 0) + IsNull(CS.dblCargo02, 0) - IsNull(CS.dblAbono02, 0) + IsNull(CS.dblCargo03, 0) - IsNull(CS.dblAbono03, 0) + IsNull(CS.dblCargo04, 0) - IsNull(CS.dblAbono04, 0) + IsNull(CS.dblCargo05, 0) - IsNull(CS.dblAbono05, 0) + IsNull(CS.dblCargo06, 0) - IsNull(CS.dblAbono06, 0) + IsNull(CS.dblCargo07, 0) - IsNull(CS.dblAbono07, 0) + IsNull(CS.dblCargo08, 0) - IsNull(CS.dblAbono08, 0) + IsNull(CS.dblCargo09, 0) - IsNull(CS.dblAbono09, 0) + IsNull(CS.dblCargo10, 0) - IsNull(CS.dblAbono10, 0) )     
          WHEN 12 THEN IsNull(CS.dblSaldoInicial, 0) + ( IsNull(CS.dblCargo01, 0) - IsNull(CS.dblAbono01, 0) + IsNull(CS.dblCargo02, 0) - IsNull(CS.dblAbono02, 0) + IsNull(CS.dblCargo03, 0) - IsNull(CS.dblAbono03, 0) + IsNull(CS.dblCargo04, 0) - IsNull(CS.dblAbono04, 0) + IsNull(CS.dblCargo05, 0) - IsNull(CS.dblAbono05, 0) + IsNull(CS.dblCargo06, 0) - IsNull(CS.dblAbono06, 0) + IsNull(CS.dblCargo07, 0) - IsNull(CS.dblAbono07, 0) + IsNull(CS.dblCargo08, 0) - IsNull(CS.dblAbono08, 0) + IsNull(CS.dblCargo09, 0) - IsNull(CS.dblAbono09, 0) + IsNull(CS.dblCargo10, 0) - IsNull(CS.dblAbono10, 0) + IsNull(CS.dblCargo11, 0) - IsNull(CS.dblAbono11, 0) )    
		  WHEN 0 THEN IsNull(CS.dblSaldoInicial, 0) + ( IsNull(CS.dblCargo01, 0) - IsNull(CS.dblAbono01, 0) + IsNull(CS.dblCargo02, 0) - IsNull(CS.dblAbono02, 0) + IsNull(CS.dblCargo03, 0) - IsNull(CS.dblAbono03, 0) + IsNull(CS.dblCargo04, 0) - IsNull(CS.dblAbono04, 0) + IsNull(CS.dblCargo05, 0) - IsNull(CS.dblAbono05, 0) + IsNull(CS.dblCargo06, 0) - IsNull(CS.dblAbono06, 0) + IsNull(CS.dblCargo07, 0) - IsNull(CS.dblAbono07, 0) + IsNull(CS.dblCargo08, 0) - IsNull(CS.dblAbono08, 0) + IsNull(CS.dblCargo09, 0) - IsNull(CS.dblAbono09, 0) + IsNull(CS.dblCargo10, 0) - IsNull(CS.dblAbono10, 0) + IsNull(CS.dblCargo11, 0) - IsNull(CS.dblAbono11, 0) + IsNull(CS.dblCargo12, 0) - IsNull(CS.dblAbono12, 0) )    
          END),
	SUM(CASE @intMes    
          WHEN 1  THEN IsNull(CS.dblCargo01,0)   
          WHEN 2  THEN IsNull(CS.dblCargo02,0)
          WHEN 3  THEN IsNull(CS.dblCargo03,0)
          WHEN 4  THEN IsNull(CS.dblCargo04,0)
          WHEN 5  THEN IsNull(CS.dblCargo05,0)
		  WHEN 6  THEN IsNull(CS.dblCargo06,0)   
          WHEN 7  THEN IsNull(CS.dblCargo07,0)
          WHEN 8  THEN IsNull(CS.dblCargo08,0)
          WHEN 9  THEN IsNull(CS.dblCargo09,0)
          WHEN 10  THEN IsNull(CS.dblCargo10,0)
		  WHEN 11  THEN IsNull(CS.dblCargo11,0)   
          WHEN 12  THEN IsNull(CS.dblCargo12,0)
          END ),
	SUM(CASE @intMes    
          WHEN 1  THEN IsNull(CS.dblAbono01,0)   
          WHEN 2  THEN IsNull(CS.dblAbono02,0)
          WHEN 3  THEN IsNull(CS.dblAbono03,0)
          WHEN 4  THEN IsNull(CS.dblAbono04,0)
          WHEN 5  THEN IsNull(CS.dblAbono05,0)
		  WHEN 6  THEN IsNull(CS.dblAbono06,0)   
          WHEN 7  THEN IsNull(CS.dblAbono07,0)
          WHEN 8  THEN IsNull(CS.dblAbono08,0)
          WHEN 9  THEN IsNull(CS.dblAbono09,0)
          WHEN 10  THEN IsNull(CS.dblAbono10,0)
		  WHEN 11  THEN IsNull(CS.dblAbono11,0)   
          WHEN 12  THEN IsNull(CS.dblAbono12,0)
          END )	
	FROM tbCuentasSaldos CS
	WHERE CS.intEmpresa = @intEmpresa
	AND CS.intEjercicio = @intEjercicio 
	AND CS.strCuenta IN (SELECT strCuenta FROM #TempCuentas)
	AND CS.strClasifDS IN (SELECT CONVERT(VARCHAR,intObra) FROM #TmpObras)
	AND ISNULL(CS.strClasifDS,'0') <> '0'
	GROUP BY CS.intEmpresa,CS.strCuenta,CS.strClasifDS

	INSERT INTO #TempBalanza(intEmpresa,strEmpresa,strCuenta,strNomCuenta,Nivel1,Nivel2,Nivel3,strMes,intEjercicio, 
	intObra,strObra,strClaveObra,intColonia,strNombreColonia,dblSaldoInicial,dblCargo,dblAbono,dblSaldoFinal,intNivel)
	SELECT  @intEmpresa,@strEmpresa,CS.strCuenta,C.strNombre,SUBSTRING (CS.strCuenta,1,4),
			CASE WHEN SUBSTRING (CS.strCuenta,5,4) = '' THEN '0000' ELSE SUBSTRING (CS.strCuenta,5,4) END, 
			CASE WHEN SUBSTRING (CS.strCuenta,9,4) = '' THEN '0000' ELSE SUBSTRING (CS.strCuenta,9,4) END,
			@strMes,@intEjercicio,CS.intObra,ISNULL(O.strNombre, 'SIN OBRA'),
			ISNULL(O.strClave, 'SIN CLAVE'),
			ISNULL( CONVERT(INT,SUBSTRING(O.strClave, 4, 2)), 0),ISNULL(Col.strNombre, 'SIN OBRA'),
			CS.dblSaldoInicial,CS.dblSaldoCargos,CS.dblSaldoAbonos,--dbo.F_Sdoini_PolDet(@intEmpresa,'0',@intEjercicio,@intMes, C.strCuenta, CS.strClasifDS, CS.strClasifDP),
			--CONVERT(DECIMAL(18,2), dbo.F_MesCargo(@intEmpresa, '0', @intEjercicio, @intMes, '0', C.strCuenta, CS.strClasifDS, '0')),
			--CONVERT(DECIMAL(18,2), dbo.F_MesAbono(@intEmpresa, '0', @intEjercicio, @intMes, '0', C.strCuenta, CS.strClasifDS, '0')),    
			dblSaldoFinal = 0, intNivel = 0--C.intNivel					
	FROM #TmpSaldos CS
	INNER JOIN #TempCuentas C ON C.strCuenta COLLATE SQL_Latin1_General_CP1_CI_AS = CS.strCuenta AND C.intEmpresa = CS.intEmpresa
	INNER JOIN VetecMarfil.dbo.tbObra O ON O.intObra = CS.intObra AND O.intEmpresa = CS.intEmpresa
	LEFT JOIN VetecMarfil.dbo.tbColonia Col ON Col.intColonia = SUBSTRING(O.strClave, 4, 2)
	WHERE CS.intEmpresa = @intEmpresa
	AND O.intObra IN (SELECT intObra FROM #TmpObras)
			
	UPDATE #TempBalanza SET dblSaldoFinal = dblSaldoInicial + dblCargo - dblAbono

	SELECT	intEmpresa,strEmpresa,strCuenta,strNomCuenta,Nivel1,Nivel2,Nivel3,strMes,intEjercicio,intObra,strObra,
			strClaveObra,intColonia,strNombreColonia,dblSaldoInicial,dblCargo,dblAbono,dblSaldoFinal,intNivel,
			intColIni = @intColIni,intColFin = @intColFin,intSectorIni = @intSectorIni,intSectorFin = @intSectorFin,
			intCCIni = @strObra,intCCFin = @strObraFin,intAreaIni = @intAreaIni,intAreaFin = @intAreaFin 
	FROM #TempBalanza

	DROP TABLE 	#TempBalanza
	DROP TABLE #TempCuentas
	DROP TABLE #TmpObras
	DROP TABLE #TmpSaldos

SET NOCOUNT OFF
END
GO 

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbPolizasDet_Balanza_Obra Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbPolizasDet_Balanza_Obra Error on Creation'
END
GO




















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
	DECLARE @sqlSelect varchar(5000)
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
	SELECT DISTINCT RC.strCuenta, RC.intRubro, 0
	FROM tbRubrosCuentas RC		
	INNER JOIN tbEstadosFinRubros F ON RC.intEmpresa = F.intEmpresa AND F.intRubro = RC.intRubro
	WHERE F.intEmpresa = @intEmpresa
	AND F.intEstadoFin = @intEstadoFin	
	--AND strCuenta = '3130'

	INSERT INTO #ObrasExistentes(intColonia,strColonia,intObra,strObra,intSector)
	SELECT intColonia,strColonia,intObra,strObra,intSector
	FROM VetecMarfil.dbo.fn_ColoniasObra(@strCCIni,@strCCFin,@intEmpresa) 

	DELETE FROM #ObrasExistentes WHERE intObra NOT IN(SELECT DISTINCT CONVERT(INT,strClasifDS) FROM tbPolizasDet PD
													  INNER JOIN tbPolizasEnc PE ON PE.intEmpresa = PD.intEmpresa AND PE.strPoliza = PD.strPoliza AND PE.intEjercicio = PD.intEjercicio
													  WHERE PD.intEmpresa = @intEmpresa
													  AND PD.datFecha BETWEEN @datFechaIni AND @datFechaFin
													  AND PD.intIndAfectada = 1
													  AND PE.intEstatus <> 9)
	
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
	SELECT DISTINCT strNombre
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
			IF(@intColonia = 0)
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


IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbPolizasDet_ListAux')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbPolizasDet_ListAux
	PRINT N'Drop Procedure : dbo.usp_tbPolizasDet_ListAux - Succeeded !!!'
END
GO

------------------------------------------------------------------------------------
---   Aplicacion: RMM.		                                                     ---
---        Autor: Ruben Mora Martinez                                            ---
---  Descripcion: Obtiene un registro de la tabla:  tbCotizacion                 ---
---                                                                              ---
------------------------------------------------------------------------------------
---    Fecha     Autor  Comentario                                               ---
---  ----------  -----  -------------------------------------------------------  ---
---  22/08/2011  RMM    Create procedure                                         ---
------------------------------------------------------------------------------------


CREATE PROCEDURE dbo.usp_tbPolizasDet_ListAux
( 
	@intEmpresa			int
)
AS    
BEGIN
	SET NOCOUNT ON 

	DECLARE @Data TABLE(Id int,strNombre varchar(200) COLLATE SQL_Latin1_General_CP1_CI_AS)

	INSERT INTO @Data(Id,strNombre)		
	SELECT intProveedor,strNombre
	FROM VetecMarfilAdmin..tbProveedores
	WHERE intEmpresa = @intEmpresa

	IF(@intEmpresa IN(2,3))
	BEGIN
		INSERT INTO @Data(Id,strNombre)	
		SELECT DISTINCT strClave,strNombre
		FROM VetecMarfil..tbClientes
		WHERE intEmpresa IN(2,3)
	END
	ELSE
	BEGIN
		INSERT INTO @Data(Id,strNombre)	
		SELECT DISTINCT strClave,strNombre
		FROM VetecMarfil..tbClientes
		WHERE intEmpresa = @intEmpresa 
	END

	SELECT Id, strNombre FROM @Data

	SET NOCOUNT OFF
END
GO 

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbPolizasDet_ListAux Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbPolizasDet_ListAux Error on Creation'
END
GO

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
	SUM(CASE WHEN intTipoMovto <> 0 THEN dblImporte ELSE 0 END), SUM(CASE WHEN intTipoMovto = 0 THEN dblImporte ELSE 0 END)
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
		IF NOT EXISTS(SELECT 1 FROM #Poliza WHERE ISNULL(strClasifDS,0) > 0)
		BEGIN
			SET @Message = 'No se puede afecta la poliza ' + @strPoliza + '. No tiene Obra'
			RAISERROR(@Message,16,1)
			RETURN
		END

		IF NOT EXISTS(SELECT 1 FROM #Poliza P INNER JOIN tbCuentas C ON C.intEmpresa = @intEmpresa AND C.strCuenta = P.strCuenta)
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

		UPDATE P
		SET P.intCuenta = 0
		FROM #Poliza P
		INNER JOIN tbPolizasDet PD ON PD.intEmpresa = P.intEmpresa AND PD.strPoliza = P.strPoliza COLLATE SQL_Latin1_General_CP1_CI_AS
		INNER JOIN tbCuentas C ON C.strCuenta = PD.strCuenta AND C.intEmpresa = PD.intEmpresa
		WHERE C.intCtaRegistro = 0

		IF EXISTS(SELECT 1 FROM #Poliza WHERE intCuenta = 0)
		BEGIN
			SET @Message = 'No se puede afecta la poliza ' + @strPoliza + '. Contiene cuentas que no son de ultimo nivel.'
			RAISERROR(@Message,16,1)
			RETURN
		END

		UPDATE P
		SET P.intCuenta = 0
		FROM #Poliza P
		INNER JOIN tbPolizasDet PD ON PD.intEmpresa = P.intEmpresa AND PD.strPoliza = P.strPoliza COLLATE SQL_Latin1_General_CP1_CI_AS
		INNER JOIN tbCuentas C ON C.strCuenta = PD.strCuenta AND C.intEmpresa = PD.intEmpresa
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
			SELECT DISTINCT A.intEmpresa, A.intEjercicio, A.strCuenta, '0', CASE WHEN A.strClasifDP = '0' THEN '' ELSE A.strClasifDP END,       
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



IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbPolizasEnc_AuxiliarVal')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbPolizasEnc_AuxiliarVal
	PRINT N'Drop Procedure : dbo.usp_tbPolizasEnc_AuxiliarVal - Succeeded !!!'
END
GO


-- =============================================  
-- Author:  IASD  
-- Create date: 05/09/2013  
-- Description: Obtiene registros de la fn:fn_tbPolizasEnc_Auxiliar
-- =============================================  
CREATE  PROCEDURE [dbo].[usp_tbPolizasEnc_AuxiliarVal]  
(
	@intEmpresa int,
	@auxiliar   int
)    
AS  
BEGIN  
  
	SELECT No as id,strNombre 
	FROM VetecMarfil..fn_tbPolizasEnc_Auxiliar(@intEmpresa) 
	WHERE No = @auxiliar
  
END
GO 

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbPolizasEnc_AuxiliarVal Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbPolizasEnc_AuxiliarVal Error on Creation'
END
GO
 
  


IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbPolizasEnc_Delete')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbPolizasEnc_Delete
	PRINT N'Drop Procedure : dbo.usp_tbPolizasEnc_Delete - Succeeded !!!'
END
GO
------------------------------------------------------------------------------------
---   Aplicacion: RMM.		                                                     ---
---        Autor: Ruben Mora Martinez                                            ---
---  Descripcion: Obtiene un registro de la tabla:  tbCotizacion                 ---
---                                                                              ---
------------------------------------------------------------------------------------
---    Fecha     Autor  Comentario                                               ---
---  ----------  -----  -------------------------------------------------------  ---
---  22/08/2011  RMM    Create procedure                                         ---
------------------------------------------------------------------------------------

CREATE PROCEDURE dbo.usp_tbPolizasEnc_Delete
(
	@intEmpresa		int,
	@strPoliza 		varchar(50),
	@intEjercicio	int,
	@strUsuario		varchar(50),
	@strMaquina		varchar(50)
)
WITH ENCRYPTION
AS
BEGIN
	SET NOCOUNT ON

	DECLARE @strFactura VARCHAR(100)
	DECLARE @intEstatus int
	DECLARE @strTipoPoliza VARCHAR(20)
	DECLARE @intMes int
	DECLARE @intFolioPoliza int  

	IF EXISTS(SELECT * FROM tbPolizasDet WHERE intEmpresa = @intEmpresa AND intEjercicio = @intEjercicio and strPoliza = @strPoliza
	AND intIndAfectada = 1)
	BEGIN
		RAISERROR('No se puede elimina, la poliza esta afectada.',16,1)
		RETURN;
	END

	--Proveedores
	SELECT @strFactura = strFactura, @intEstatus = intEstatus
	FROM tbFacXP 
	WHERE intEmpresa = @intEmpresa AND year(datFechaFac) = @intEjercicio and strPolProv = @strPoliza

	IF(@strFactura IS NOT NULL AND @strFactura <> '')
	BEGIN
		IF (@intEstatus > 3)
		BEGIN
			RAISERROR('No se puede elimina, la factura de la poliza esta pagada.',16,1)
			RETURN;
		END
		ELSE
		BEGIN
			DELETE FROM tbFacXP WHERE intEmpresa = @intEmpresa AND year(datFechaFac) = @intEjercicio and strPolProv = @strPoliza
		END
	END
	------

	SELECT @strTipoPoliza = strTipoPoliza,@intMes = intMes,@intFolioPoliza = intFolioPoliza
	FROM VetecMarfilAdmin.dbo.tbPolizasEnc 
	WHERE strPoliza = @strPoliza AND intEmpresa = @intEmpresa AND intEjercicio = @intEjercicio

	DELETE FROM VetecMarfilAdmin.dbo.tbPolizasDet 
	WHERE strPoliza = @strPoliza AND intEmpresa = @intEmpresa and intEjercicio = @intEjercicio
	
	IF NOT EXISTS(SELECT * FROM VetecMarfilAdmin.dbo.tbPolizasEnc WHERE intEmpresa = @intEmpresa 
	AND intEjercicio = @intEjercicio and strTipoPoliza = @strTipoPoliza and intMes = @intMes
	AND intFolioPoliza > @intFolioPoliza)
	BEGIN
		SET @intFolioPoliza = @intFolioPoliza - 1
		EXEC usp_tbTiposPoliza_Save @intEmpresa,@intEjercicio,@strTipoPoliza,@intMes,@intFolioPoliza    

		DELETE FROM VetecMarfilAdmin.dbo.tbPolizasEnc 
		WHERE strPoliza = @strPoliza AND intEmpresa = @intEmpresa AND intEjercicio = @intEjercicio
	END
	ELSE
	BEGIN
		UPDATE VetecMarfilAdmin.dbo.tbPolizasEnc 
		SET intEstatus = 9, strDescripcion = 'CANCELADA', dblCargos = 0, dblAbonos = 0
		WHERE strPoliza = @strPoliza 
		AND intEmpresa = @intEmpresa 
		AND intEjercicio = @intEjercicio
	END
		
	SELECT @strPoliza

	SET NOCOUNT OFF
END
GO 

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbPolizasEnc_Delete Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbPolizasEnc_Delete Error on Creation'
END
GO



  

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbPolizasEnc_Fill')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbPolizasEnc_Fill
	PRINT N'Drop Procedure : dbo.usp_tbPolizasEnc_Fill - Succeeded !!!'
END
GO


-- =============================================
-- Author:		IASD
-- Create date: 13/08/2013
-- Description: Determina si existe en tabla:tbPolizasEnc
-- =============================================
CREATE   PROCEDURE usp_tbPolizasEnc_Fill
(
	@intEmpresa		int,
	@intEjercicio	int,
	@strPoliza		varchar(50)
)
AS
BEGIN

	DECLARE @strFolio VARCHAR(50)

	SELECT @strFolio = strFolio
	FROM tbFacXP WHERE intEmpresa = @intEmpresa AND YEAR(datFechaFac) = @intEjercicio AND strPolProv = @strPoliza

	SELECT intEmpresa,strClasifEnc,intEjercicio,intMes,strPoliza,strTipoPoliza,intFolioPoliza,
	CONVERT(VARCHAR,datFecha,103) AS datFecha,intEstatus,strDescripcion,dblCargos,dblAbonos,intIndAfectada,
	intIndInterempresa,intIndRec,intIndGenRec,intEjercicioOr,intMesOr,strPolizaOr,intConFlujo,strAuditAlta,
	strAuditMod,dblTransmision,intPartida,ISNULL(@strFolio,'') as strFolio
	FROM VetecMarfilAdmin..tbPolizasEnc 
	WHERE intEmpresa = @intEmpresa 
	AND intEjercicio = @intEjercicio 
	AND strPoliza = @strPoliza			  


  SET NOCOUNT OFF
END
GO 

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbPolizasEnc_Fill Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbPolizasEnc_Fill Error on Creation'
END
GO/****** Object:  StoredProcedure [dbo.usp_Tareas_Fill]    Script Date: 12/8/2009 10:45:19 AM ******/
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbPolizasEnc_List')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbPolizasEnc_List
	PRINT N'Drop Procedure : dbo.usp_tbPolizasEnc_List - Succeeded !!!'
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

CREATE PROCEDURE dbo.usp_tbPolizasEnc_List
(
	@intEmpresa			INT,
	@intEjercicio		int,
	@intMes				int,
	@strTipoPoliza		varchar(20),
	@strTipoPolizaFin	varchar(20),
	@intFolioIni		int,
	@intFolioFin		int,
	@intAfectada		int,
	@intDirection		int,
	@SortExpression		varchar(100),	
	@NumPage			int				= NULL, 
	@NumRecords			int				= 0, 
	@TotalRows			int				= NULL OUTPUT,
	@TotalPage			int				= NULL OUTPUT
)
WITH ENCRYPTION 
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
	BEGIN
		SET @SortExpression = 'Folio'
		SET @intDirection = 1
	END

	IF(@intFolioIni = 0 OR @intFolioFin = 0)
	BEGIN
		SET @intFolioIni = 0
		SET @intFolioFin = 0
	END

	SET @Sort = LOWER(@SortExpression) + CASE WHEN @intDirection = 0 THEN ' DESC' ELSE ' ASC' END  

	CREATE TABLE #Polizas(row int identity(1,1), intEmpresa int, intEjercicio int, intMes int, datFecha datetime, intFolio int, strPoliza varchar(50),
	intIndAfectada int, TipoPoliza varchar(100), dblCargos decimal(18,2), dblAbonos decimal(18,2),dblDiferencias decimal(18,2), 
	intCuenta int)

	CREATE TABLE #Polizas2(row int identity(1,1), intEmpresa int, intEjercicio int, intMes int, datFecha datetime, intFolio int, strPoliza varchar(50),
	intIndAfectada int, TipoPoliza varchar(100), dblCargos decimal(18,2), dblAbonos decimal(18,2),dblDiferencias decimal(18,2), 
	intCuenta int)

	EXEC dbo.qryINCN2020_Upd_CuadrarEncabezados @intEmpresa,'0',@intEjercicio,@intMes

	INSERT INTO #Polizas(intEmpresa, intEjercicio,intMes,datFecha,intFolio,strPoliza,intIndAfectada,TipoPoliza,dblCargos,dblAbonos,intCuenta)--,Obra,Auxiliar)
	SELECT DISTINCT P.intEmpresa, P.intEjercicio,P.intMes,P.datFecha,P.intFolioPoliza,P.strPoliza,P.intIndAfectada,T.strTipoPoliza + ' - ' + T.strNombre,
	ISNULL(P.dblCargos,0),ISNULL(P.dblAbonos,0),1
	FROM tbPolizasEnc P
	INNER JOIN tbTiposPoliza T ON T.strTipoPoliza = P.strTipoPoliza AND T.intEmpresa = P.intEmpresa
	WHERE P.intEmpresa = @intEmpresa
	AND P.intEjercicio = @intEjercicio
	AND P.intMes = @intMes
	AND P.intEstatus <> 9
	AND P.intIndAfectada = @intAfectada
	AND ((@strTipoPoliza = '0') OR (P.strTipoPoliza BETWEEN @strTipoPoliza AND @strTipoPolizaFin))
	AND ((@intFolioIni = 0) OR (P.intFolioPoliza BETWEEN @intFolioIni AND @intFolioFin))
		
	UPDATE P
	SET dblDiferencias = dblCargos - dblAbonos
	FROM #Polizas P

	INSERT INTO #Polizas2(intEmpresa, intEjercicio,intMes,datFecha,intFolio,strPoliza,intIndAfectada,TipoPoliza,dblCargos,dblAbonos,intCuenta,dblDiferencias)
	SELECT intEmpresa, intEjercicio,intMes,datFecha,intFolio,strPoliza,intIndAfectada,TipoPoliza,dblCargos,dblAbonos,intCuenta,dblDiferencias
	FROM #Polizas
	ORDER BY 
			CASE WHEN @Sort = 'Ejercicio DESC' THEN intEjercicio END DESC,
			CASE WHEN @Sort = 'Ejercicio ASC' THEN intEjercicio END ASC,
			CASE WHEN @Sort = 'Mes DESC' THEN intMes END DESC,
			CASE WHEN @Sort = 'Mes ASC' THEN intMes END ASC,
			CASE WHEN @Sort = 'Fecha DESC' THEN datFecha END DESC,
			CASE WHEN @Sort = 'Fecha ASC' THEN datFecha END ASC, 
			CASE WHEN @Sort = 'Folio DESC' THEN intFolio END DESC,
			CASE WHEN @Sort = 'Folio ASC' THEN intFolio END ASC,
			CASE WHEN @Sort = 'Cargos DESC' THEN dblCargos END DESC,
			CASE WHEN @Sort = 'Cargos ASC' THEN dblCargos END ASC, 
			CASE WHEN @Sort = 'Abonos DESC' THEN dblAbonos END DESC,
			CASE WHEN @Sort = 'Abonos ASC' THEN dblAbonos END ASC, 
			CASE WHEN @Sort = 'Deferencia DESC' THEN dblDiferencias END DESC,
			CASE WHEN @Sort = 'Deferencia ASC' THEN dblDiferencias END ASC,
			CASE WHEN @Sort = 'Poliza DESC' THEN strPoliza END DESC,
			CASE WHEN @Sort = 'Poliza ASC' THEN strPoliza END ASC,
			CASE WHEN @Sort = 'TipoPoliza DESC' THEN TipoPoliza END DESC,
			CASE WHEN @Sort = 'TipoPoliza ASC' THEN TipoPoliza END ASC --,
--			CASE WHEN @Sort = 'Obra DESC' THEN Obra END DESC,
--			CASE WHEN @Sort = 'Obra ASC' THEN Obra END ASC   

--	UPDATE P
--	SET P.intCuenta = 0
--	FROM #Polizas P
--	INNER JOIN tbPolizasDet PD ON PD.intEmpresa = P.intEmpresa AND PD.strPoliza = P.strPoliza COLLATE SQL_Latin1_General_CP1_CI_AS
--	INNER JOIN tbCuentas C ON C.strCuenta = PD.strCuenta AND C.intEmpresa = PD.intEmpresa
--	WHERE C.intCtaRegistro = 0

--	UPDATE P
--	SET P.intCuenta = 0
--	FROM #Polizas P
--	INNER JOIN tbPolizasDet PD ON PD.intEmpresa = P.intEmpresa AND PD.strPoliza = P.strPoliza COLLATE SQL_Latin1_General_CP1_CI_AS
--	INNER JOIN tbCuentas C ON C.strCuenta = PD.strCuenta AND C.intEmpresa = PD.intEmpresa
--	WHERE C.intIndAuxiliar = 1
--	AND isnull(PD.strClasifDP,0) = 0

	SELECT	@iNumTotRecords = MAX(row)
	FROM	#Polizas2

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

	SELECT intEmpresa, intEjercicio,intMes,CONVERT(VARCHAR,datFecha,103) AS datFecha,intFolio,strPoliza,intIndAfectada,TipoPoliza,
	CONVERT(VARCHAR,CONVERT(MONEY,dblCargos),1) AS dblCargos,CONVERT(VARCHAR,CONVERT(MONEY,dblAbonos),1) AS dblAbonos,
	CONVERT(VARCHAR,CONVERT(MONEY,dblDiferencias),1) AS dblDiferencias,intCuenta--,
	--CASE WHEN ISNULL(Obra,0) = 0 THEN '' ELSE Obra END AS Obra, Auxiliar
	FROM #Polizas2
	WHERE row between @startRow AND @finalRow
	
	
	DROP TABLE #Polizas
	DROP TABLE #Polizas2

	SET @Err = @@Error

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
GO

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbPolizasEnc_List Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbPolizasEnc_List Error on Creation'
END
GO

  

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbPolizasEnc_Sel')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbPolizasEnc_Sel
	PRINT N'Drop Procedure : dbo.usp_tbPolizasEnc_Sel - Succeeded !!!'
END
GO


-- =============================================
-- Author:		IASD
-- Create date: 13/08/2013
-- Description: Determina si existe en tabla:tbPolizasEnc
-- =============================================
CREATE   PROCEDURE [dbo].[usp_tbPolizasEnc_Sel]
(
	@intEmpresa		int,
	@intEjercicio	int,
	@intFolioPoliza	int,
	@intMes int,
	@strTipoPoliza varchar(10)
)
AS
BEGIN

DECLARE @existe int
SET @existe = 0

 IF NOT EXISTS(SELECT * FROM VetecMarfilAdmin..tbPolizasEnc WHERE intEmpresa = @intEmpresa AND intEjercicio = @intEjercicio 
			   AND intMes = @intMes	AND strTipoPoliza = @strTipoPoliza AND intFolioPoliza = @intFolioPoliza + 1)		
	SET @existe = 0
ELSE
	SET @existe = 1

SELECT @existe



  SET NOCOUNT OFF
END
GO 

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbPolizasEnc_Sel Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbPolizasEnc_Sel Error on Creation'
END
GO
/****** Object:  StoredProcedure [dbo.usp_Tareas_Fill]    Script Date: 12/8/2009 10:45:19 AM ******/
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbPolizas_DesafectarTodo')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbPolizas_DesafectarTodo
	PRINT N'Drop Procedure : dbo.usp_tbPolizas_DesafectarTodo - Succeeded !!!'
END
GO

------------------------------------------------------------------------------------
---   Aplicacion: Marfil.		                                                 ---
---        Autor: Rub‚n Mora Mart¡nez                                            ---
---  Descripcion: Obtiene un registro de la tabla:  tbPolizasEnc                 ---
---                                                                              ---
------------------------------------------------------------------------------------
---    Fecha     Autor  Comentario                                               ---
---  ----------  -----  -------------------------------------------------------  ---
---  12/11/2010  RMM    Create procedure                                         ---
------------------------------------------------------------------------------------


CREATE PROCEDURE [dbo].[usp_tbPolizas_DesafectarTodo]
(      
    @intEmpresa		Int, 
	@intEjercicio	int,
	@intMes			Int, 
	@strTipoPoliza	VarChar(60), 
	@strTipoFin		VarChar(60),
	@intFolioIni	Int, 
	@intFolioFin	Int
)      
AS 
BEGIN   

	---------------------VALIDAMOS EL CIERRE MENSUAL---------------------
	IF EXISTS(SELECT 1 from VetecMarfil..tbCerrarPeriodo WHERE intEmpresa = @intEmpresa AND intEjercicio = @intEjercicio AND intMes = @intMes AND bCerrado = 1 AND intModulo = 1)
	BEGIN	
		DECLARE @Message VARCHAR(200)
		DECLARE @Date DATETIME

		SET @Date = '01/' + CONVERT(VARCHAR,@intMes) + '/' + CONVERT(VARCHAR,@intEjercicio)
	
		SET @Message = 'El mes ' + DATENAME(month,@Date) + '. Esta cerrado.'
		RAISERROR(@Message,16,1)
		RETURN
	END
	
	BEGIN TRY
	BEGIN TRANSACTION   

	---------------------DESAFECTA TODO---------------------	
	IF @strTipoPoliza = '0' AND @strTipoFin = '0' AND @intFolioIni = 0 AND @intFolioFin = 0
	BEGIN
		ALTER TABLE tbPolizasEnc DISABLE TRIGGER ALL
		ALTER TABLE tbPolizasDet DISABLE TRIGGER ALL

		UPDATE tbPolizasEnc 
		SET intIndAfectada = 0 
		WHERE intEmpresa = @intEmpresa
		AND intEjercicio = @intEjercicio 
		AND intMes = @intMes
		     
		UPDATE tbPolizasDet 
		SET intIndAfectada = 0 
		WHERE intEmpresa = @intEmpresa
		AND intEjercicio = @intEjercicio 
		AND intMes = @intMes

		DECLARE @strSQL NVarChar(4000)
		SET @strSQL =           ' UPDATE tbCuentasSaldos '
		SET @strSQL = @strSQL + ' SET dblAbono' + Right('00' + (LTrim(RTrim(Str(@intMes)))), 2) + ' = 0, '
		SET @strSQL = @strSQL + ' dblCargo' + Right('00' + (LTrim(RTrim(Str(@intMes)))), 2) + ' = 0 '     
		SET @strSQL = @strSQL + ' WHERE tbCuentasSaldos.intEmpresa = ' + LTrim(RTrim( Str(@intEmpresa) )) + '  '
		SET @strSQL = @strSQL + ' AND   tbCuentasSaldos.intEjercicio = ' + LTrim(RTrim( Str(@intEjercicio) )) 
 
		EXEC sp_executeSQL @strSQL

		ALTER TABLE tbPolizasEnc ENABLE TRIGGER ALL
		ALTER TABLE tbPolizasDet ENABLE TRIGGER ALL		
	END
	ELSE
	BEGIN	
    
		DECLARE @Rows int
		DECLARE @Count int
		DECLARE @strTipo VarChar(60)
			
		-------------------------------------------------------------------------------------------------------------------------------------------------         		 
		-- CREO LA TABLA DONDE VOY A JUNTAR TODO      
		DECLARE @Previo Table       
		(intEmpresa Int, intEjercicio Int, strCuenta[varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL, 
		strClasifEnc [varchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL, strClasifDP  [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL, strClasifDS [varchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS,       
		intTipoMoneda Int, intIndInterEmpresa Int, dblCargo Decimal(16,2), dblAbono Decimal(16,2))   
	           
		-- INSERTO LAS CUENTAS DE ULTIMO NIVEL    	
		INSERT @Previo 
		SELECT	D.intEmpresa, D.intEjercicio, D.strCuenta,                       
				0, (CASE WHEN C.intIndAuxiliar = 1 THEN D.strClasifDP ELSE 0 END) AS strClasifDP, D.strClasifDS, C.intNivel, 0,					
				Convert(Decimal(16,4), Sum (CASE WHEN D.intTipoMovto = 1 THEN D.dblImporte ELSE 0 END) ) dblCargo,      
				Convert(Decimal(16,4), Sum (CASE WHEN D.intTipoMovto =  0 THEN D.dblImporte ELSE 0 END) ) dblAbono--,			   
		FROM tbPolizasDet D
		INNER JOIN tbCuentas C ON C.strCuenta =  D.strCuenta  AND C.intEmpresa =  D.intEmpresa  
		INNER JOIN tbPolizasEnc PE ON PE.strPoliza = D.strPoliza AND PE.intEmpresa = D.intEmpresa AND PE.intEjercicio = D.intEjercicio AND PE.intMes = D.intMes
		WHERE D.intEmpresa = @intEmpresa      
		AND D.intEjercicio = @intEjercicio          
		AND D.intMes = @intMes 
		AND ((@strTipoPoliza = '0') OR(PE.strTipoPoliza BETWEEN @strTipoPoliza AND @strTipoFin))
		AND ((@intFolioIni = 0) OR (PE.intFolioPoliza BETWEEN @intFolioIni AND @intFolioFin))
		AND PE.intEstatus <> 9 
		AND D.intIndAfectada = 1
		AND D.strClasifDS IS NOT NULL 				
		GROUP BY D.intEmpresa, D.intEjercicio, D.strCuenta, D.intMes, D.strClasifDS, C.intNivel, C.intIndAuxiliar,D.strClasifDP

		--	INSERTO LAS CUENTAS DE LOS OTROS NIVELES      
		DECLARE @intCont Int      
		SET @intCont = 0     
				
		WHILE @intCont <= 1      
		BEGIN      
			SET @intCont = @intCont + 1  
			--AGREGA CUENTAS DE NIVEL 1 PARA TODAS LAS CUENTAS DE NIVEL 2, NO ME INTERESA SU AUX EN EL NIVEL 1				
			
			IF @intCont = 1				
			BEGIN					
				INSERT @Previo       
				SELECT intEmpresa,intEjercicio,dbo.F_CtasTotXNiv(strCuenta,@intCont,@intEmpresa) strCuenta,       
					   strClasifEnc,0,strClasifDS,intTipoMoneda,intIndInterEmpresa,Round( Sum(dblCargo), 2) dblCargo, 
					   Round( Sum(dblAbono), 2) dblAbono     
				FROM @Previo 
				WHERE dbo.F_CtasTotXNiv(strCuenta, @intCont, @intEmpresa) IS NOT NULL								   
				AND intTipoMoneda BETWEEN 2 AND 3
				GROUP BY intEmpresa, intEjercicio, dbo.F_CtasTotXNiv(strCuenta, @intCont , @intEmpresa),       
				strClasifEnc, intTipoMoneda, intIndInterEmpresa, strClasifDS
			END
					
			--AGREGA CUENTAS DE NIVEL 2, PARA LAS CUENTAS QUE SE ENCUENTRE EN NIVEL 3
			IF @intCont = 2				
			BEGIN					
				INSERT @Previo       
				SELECT  intEmpresa, intEjercicio, dbo.F_CtasTotXNiv(strCuenta, @intCont , @intEmpresa) strCuenta,       
						strClasifEnc, IsNull(strClasifDP , '0'), ISNULL(strClasifDS,'0'),       
						intTipoMoneda, intIndInterEmpresa,       
						Round( Sum(dblCargo), 2) dblCargo, Round( Sum(dblAbono), 2) dblAbono     
				FROM @Previo 
				WHERE dbo.F_CtasTotXNiv(strCuenta, @intCont, @intEmpresa) IS NOT NULL								   
				AND	intTipoMoneda = 3
				GROUP BY intEmpresa, intEjercicio, dbo.F_CtasTotXNiv(strCuenta, @intCont , @intEmpresa),       
				strClasifEnc,strClasifDP, strClasifDS,       
				intTipoMoneda, intIndInterEmpresa
			END					
	        
		END  
			
		DECLARE @Afec Table (intRegistro INT IDENTITY (1,1), intEmpresa Int, intEjercicio Int, 
  		strCuenta[varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL, strClasifDP  [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL , strClasifDS [varchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,                              
		dblCargo Money, dblAbono Money) 
		
		CREATE TABLE  #TmpCuentasExistentes( intEmpresa Int, intEjercicio Int, strCuenta[varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL, 
		strClasifDP  [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL , strClasifDS [varchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL, intExiste INT) 
		
		CREATE TABLE  #TmpCuentasPorCrear( intEmpresa Int, intEjercicio Int, strCuenta[varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL, 
		strClasifDP  [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL , strClasifDS [varchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL, intExiste INT) 
	   	
		INSERT @Afec     
		SELECT intEmpresa, intEjercicio , strCuenta, strClasifDP,strClasifDS, Sum(dblCargo) dblCargo , Sum(dblAbono) dblAbono    
		FROM @Previo    
		GROUP BY intEmpresa,intEjercicio,strCuenta,strClasifDP,strClasifDS
		
		INSERT INTO #TmpCuentasExistentes  
		SELECT CS.intEmpresa, CS.intEjercicio, CS.strCuenta, CS.strClasifDP, CS.strClasifDS, 1
		FROM tbCuentasSaldos CS
		INNER JOIN @Afec A ON A.strCuenta = CS.strCuenta AND A.strClasifDS = CS.strClasifDS AND A.strClasifDP = CS.strClasifDP AND A.intEmpresa = CS.intEmpresa
		WHERE CS.intEmpresa = @intEmpresa
		AND CS.intEjercicio = @intEjercicio
			
		INSERT INTO #TmpCuentasPorCrear
		SELECT A.intEmpresa, A.intEjercicio, A.strCuenta, A.strClasifDP, A.strClasifDS, 0
		FROM @Afec A
		LEFT JOIN #TmpCuentasExistentes CE ON CE.intEmpresa = A.intEmpresa AND CE.strClasifDS = A.strClasifDS AND CE.strClasifDP = A.strClasifDP AND A.strCuenta = CE.strCuenta
		WHERE intExiste IS NULL
		
		DECLARE @CountCta INT
		
		SET @CountCta = 0
		
		SELECT @CountCta = COUNT(*) FROM #TmpCuentasPorCrear

		IF @CountCta > 0 
		BEGIN
			INSERT INTO tbCuentasSaldos      
			([intEmpresa], [intEjercicio], [strCuenta], [strClasifEnc], [strClasifDP],       
			[strClasifDS], [intIndInterEmpresa], [intTipoMoneda], [dblSaldoInicial],       
			[dblCargo01], [dblAbono01], [dblCargo02], [dblAbono02], [dblCargo03], [dblAbono03],       
			[dblCargo04], [dblAbono04], [dblCargo05], [dblAbono05], [dblCargo06], [dblAbono06],       
			[dblCargo07], [dblAbono07], [dblCargo08], [dblAbono08], [dblCargo09], [dblAbono09],       
			[dblCargo10], [dblAbono10], [dblCargo11], [dblAbono11], [dblCargo12], [dblAbono12],       
			[datFechaAlta], [strUsuarioAlta], [strMaquinaAlta], [datFechaMod], [strUsuarioMod], [strMaquinaMod])       
			SELECT CP.intEmpresa, CP.intEjercicio, CP.strCuenta, '0', CP.strClasifDP,       
			CP.strClasifDS, 0, 1, 0, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,      
			Null, Null, Null, Null, Null, Null  
			FROM #TmpCuentasPorCrear CP
		END		
		
		IF @intMes = 1 
		BEGIN
			UPDATE CS 
			SET CS.dblCargo01 = ISNULL(CS.dblCargo01,0) - ISNULL(A.dblCargo,0), 
				CS.dblAbono01 = ISNULL(CS.dblAbono01,0) - ISNULL(A.dblAbono,0)	
			FROM tbCuentasSaldos CS
			INNER JOIN @Afec A ON A.intEmpresa = CS.intEmpresa AND CS.intEjercicio = A.intEjercicio  AND CS.strCuenta = A.strCuenta AND CS.strClasifDS = A.strClasifDS AND CS.strClasifDP = A.strClasifDP
			WHERE CS.intEmpresa = @intEmpresa
			AND CS.intEjercicio = @intEjercicio 

			UPDATE  CS
			SET dblCargo01 = 0
			FROM tbCuentasSaldos CS
			WHERE intEjercicio = @intEjercicio
			AND intEmpresa = @intEmpresa
			AND dblCargo01 < 0
			AND strCuenta IN(SELECT strCuenta FROM @Afec)

			UPDATE  CS
			SET dblAbono01 = 0
			FROM tbCuentasSaldos CS
			WHERE intEjercicio = @intEjercicio
			AND intEmpresa = @intEmpresa
			AND dblAbono01 < 0
			AND strCuenta IN(SELECT strCuenta FROM @Afec)
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

			UPDATE  CS
			SET dblCargo02 = 0
			FROM tbCuentasSaldos CS
			WHERE intEjercicio = @intEjercicio
			AND intEmpresa = @intEmpresa
			AND dblCargo02 < 0
			AND strCuenta IN(SELECT strCuenta FROM @Afec)

			UPDATE  CS
			SET dblAbono02 = 0
			FROM tbCuentasSaldos CS
			WHERE intEjercicio = @intEjercicio
			AND intEmpresa = @intEmpresa
			AND dblAbono02 < 0
			AND strCuenta IN(SELECT strCuenta FROM @Afec)
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

			UPDATE  CS
			SET dblCargo03 = 0
			FROM tbCuentasSaldos CS
			WHERE intEjercicio = @intEjercicio
			AND intEmpresa = @intEmpresa
			AND dblCargo03 < 0
			AND strCuenta IN(SELECT strCuenta FROM @Afec)

			UPDATE  CS
			SET dblAbono03 = 0
			FROM tbCuentasSaldos CS
			WHERE intEjercicio = @intEjercicio
			AND intEmpresa = @intEmpresa
			AND dblAbono03 < 0
			AND strCuenta IN(SELECT strCuenta FROM @Afec)
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

			UPDATE  CS
			SET dblCargo04 = 0
			FROM tbCuentasSaldos CS
			WHERE intEjercicio = @intEjercicio
			AND intEmpresa = @intEmpresa
			AND dblCargo04 < 0
			AND strCuenta IN(SELECT strCuenta FROM @Afec)

			UPDATE  CS
			SET dblAbono04 = 0
			FROM tbCuentasSaldos CS
			WHERE intEjercicio = @intEjercicio
			AND intEmpresa = @intEmpresa
			AND dblAbono04 < 0
			AND strCuenta IN(SELECT strCuenta FROM @Afec)
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

			UPDATE  CS
			SET dblCargo05 = 0
			FROM tbCuentasSaldos CS
			WHERE intEjercicio = @intEjercicio
			AND intEmpresa = @intEmpresa
			AND dblCargo05 < 0
			AND strCuenta IN(SELECT strCuenta FROM @Afec)

			UPDATE  CS
			SET dblAbono05 = 0
			FROM tbCuentasSaldos CS
			WHERE intEjercicio = @intEjercicio
			AND intEmpresa = @intEmpresa
			AND dblAbono05 < 0
			AND strCuenta IN(SELECT strCuenta FROM @Afec)		
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

			UPDATE  CS
			SET dblCargo06 = 0
			FROM tbCuentasSaldos CS
			WHERE intEjercicio = @intEjercicio
			AND intEmpresa = @intEmpresa
			AND dblCargo06 < 0
			AND strCuenta IN(SELECT strCuenta FROM @Afec)

			UPDATE  CS
			SET dblAbono06 = 0
			FROM tbCuentasSaldos CS
			WHERE intEjercicio = @intEjercicio
			AND intEmpresa = @intEmpresa
			AND dblAbono06 < 0
			AND strCuenta IN(SELECT strCuenta FROM @Afec)
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

			UPDATE  CS
			SET dblCargo07 = 0
			FROM tbCuentasSaldos CS
			WHERE intEjercicio = @intEjercicio
			AND intEmpresa = @intEmpresa
			AND dblCargo07 < 0
			AND strCuenta IN(SELECT strCuenta FROM @Afec)

			UPDATE  CS
			SET dblAbono07 = 0
			FROM tbCuentasSaldos CS
			WHERE intEjercicio = @intEjercicio
			AND intEmpresa = @intEmpresa
			AND dblAbono07 < 0
			AND strCuenta IN(SELECT strCuenta FROM @Afec)
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

			UPDATE  CS
			SET dblCargo08 = 0
			FROM tbCuentasSaldos CS
			WHERE intEjercicio = @intEjercicio
			AND intEmpresa = @intEmpresa
			AND dblCargo08 < 0
			AND strCuenta IN(SELECT strCuenta FROM @Afec)

			UPDATE  CS
			SET dblAbono08 = 0
			FROM tbCuentasSaldos CS
			WHERE intEjercicio = @intEjercicio
			AND intEmpresa = @intEmpresa
			AND dblAbono08 < 0
			AND strCuenta IN(SELECT strCuenta FROM @Afec)
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

			UPDATE  CS
			SET dblCargo09 = 0
			FROM tbCuentasSaldos CS
			WHERE intEjercicio = @intEjercicio
			AND intEmpresa = @intEmpresa
			AND dblCargo09 < 0
			AND strCuenta IN(SELECT strCuenta FROM @Afec)

			UPDATE  CS
			SET dblAbono09 = 0
			FROM tbCuentasSaldos CS
			WHERE intEjercicio = @intEjercicio
			AND intEmpresa = @intEmpresa
			AND dblAbono09 < 0
			AND strCuenta IN(SELECT strCuenta FROM @Afec)
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

			UPDATE  CS
			SET dblCargo10 = 0
			FROM tbCuentasSaldos CS
			WHERE intEjercicio = @intEjercicio
			AND intEmpresa = @intEmpresa
			AND dblCargo10 < 0
			AND strCuenta IN(SELECT strCuenta FROM @Afec)

			UPDATE  CS
			SET dblAbono10 = 0
			FROM tbCuentasSaldos CS
			WHERE intEjercicio = @intEjercicio
			AND intEmpresa = @intEmpresa
			AND dblAbono10 < 0
			AND strCuenta IN(SELECT strCuenta FROM @Afec)
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

			UPDATE  CS
			SET dblCargo11 = 0
			FROM tbCuentasSaldos CS
			WHERE intEjercicio = @intEjercicio
			AND intEmpresa = @intEmpresa
			AND dblCargo11 < 0
			AND strCuenta IN(SELECT strCuenta FROM @Afec)

			UPDATE  CS
			SET dblAbono11 = 0
			FROM tbCuentasSaldos CS
			WHERE intEjercicio = @intEjercicio
			AND intEmpresa = @intEmpresa
			AND dblAbono11 < 0
			AND strCuenta IN(SELECT strCuenta FROM @Afec)
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

			UPDATE  CS
			SET dblCargo12 = 0
			FROM tbCuentasSaldos CS
			WHERE intEjercicio = @intEjercicio
			AND intEmpresa = @intEmpresa
			AND dblCargo12 < 0
			AND strCuenta IN(SELECT strCuenta FROM @Afec)

			UPDATE  CS
			SET dblAbono12 = 0
			FROM tbCuentasSaldos CS
			WHERE intEjercicio = @intEjercicio
			AND intEmpresa = @intEmpresa
			AND dblAbono12 < 0
			AND strCuenta IN(SELECT strCuenta FROM @Afec)
		END	
		
		ALTER TABLE tbPolizasEnc DISABLE TRIGGER ALL        
		ALTER TABLE tbPolizasDet DISABLE TRIGGER ALL        
	             
		UPDATE PE 
		SET PE.intIndAfectada = 0 
		FROM tbPolizasEnc PE		
		WHERE PE.intEmpresa = @intEmpresa
		AND PE.intEjercicio = @intEjercicio 
		AND PE.intMes = @intMes 
		AND PE.intEstatus <> 9 
		AND PE.intIndAfectada = 1    	
		AND ((@strTipoPoliza = '0') OR(PE.strTipoPoliza BETWEEN @strTipoPoliza AND @strTipoFin))	
		AND ((@intFolioIni = 0) OR (PE.intFolioPoliza BETWEEN @intFolioIni AND @intFolioFin))
	                  
		UPDATE  PD 
		SET PD.intIndAfectada = 0    		  
		FROM tbPolizasDet PD
		INNER JOIN tbPolizasEnc PE ON PE.intEmpresa = PD.intEmpresa AND PE.intEjercicio = PD.intEjercicio AND PE.strPoliza = PD.strPoliza --AND PD.intFolioPoliza = PE.intFolioPoliza AND PD.strTipoPoliza = PE.strTipoPoliza
		WHERE PD.intEmpresa = @intEmpresa
		AND PD.intEjercicio = @intEjercicio 
		AND PD.intMes = @intMes	
		AND PE.intEstatus <> 9
		AND PD.intIndAfectada = 1   	
		AND ((@strTipoPoliza = '0') OR(PD.strTipoPoliza BETWEEN @strTipoPoliza AND @strTipoFin))
		AND ((@intFolioIni = 0) OR (PD.intFolioPoliza BETWEEN @intFolioIni AND @intFolioFin))
		             
		ALTER TABLE tbPolizasEnc ENABLE TRIGGER ALL        
		ALTER TABLE tbPolizasDet ENABLE TRIGGER ALL  
			
		DROP TABLE #TmpCuentasExistentes
		DROP TABLE #TmpCuentasPorCrear		
	END

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

END
GO

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbPolizas_DesafectarTodo Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbPolizas_DesafectarTodo Error on Creation'
END
GO

/****** Object:  StoredProcedure [dbo.usp_tbPolizas_Invetario]    Script Date: 12/8/2009 10:45:19 AM ******/
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbPolizas_Invetario')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbPolizas_Invetario
	PRINT N'Drop Procedure : dbo.usp_tbPolizas_Invetario - Succeeded !!!'
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

CREATE PROCEDURE dbo.usp_tbPolizas_Invetario
(      
	@intEmpresa			int,
    @intEjercicio		int,
	@intMes				int,
	@strUsuario			VARCHAR(50),
	@strMaquina			VARCHAR(50)
)
WITH ENCRYPTION 
AS
BEGIN
		
	SET NOCOUNT ON

	DECLARE	@Rows				int,
			@Count				int,
			@strCuentaCargo		varchar(100),
			@strCuentaAbono		varchar(100),
			@dblImporte			decimal(18,2),
			@intFolio			int,
			@strPoliza			varchar(50),
			@strTipoPoliza		varchar(50),
			@strInsumo			varchar(50),
			@intPoliza			varchar(50),
			@intObra			int,
			@intArea			int,
			@intProveedor		varchar(50),
			@strProveedor		varchar(300),
			@dblSUM				decimal(18,2),
			@Row				int,
			@strPolizas			VARCHAR(100),
			@Fecha				datetime,
			@strFecha			datetime,	
			@Data				VARCHAR(1000),
			@Error				VARCHAR(2000)


	SET @strTipoPoliza = '06'
	SET @strPolizas = ''

	SET @strFecha = '01-' + CONVERT(VARCHAR,(@intMes)) + '-' + CONVERT(VARCHAR,@intEjercicio)				
	SET @strFecha = dateadd(MONTH,1,@strFecha)
	SET @strFecha = dateadd(DAY,1,@strFecha) - 2

	CREATE TABLE #Data(intEmpresa int, intFolio int,intObra int, intProveedor int, intOrdenCompraDet int, intArticulo int, strClave varchar(100), 
	intInventario int, dblCantidad decimal(18,6), dblImporte decimal(18,6), intArea int)

	CREATE TABLE #NoInventariable(id int identity(1,1),strCuentaCargo VARCHAR(30),strCuentaAbono VARCHAR(30), intFolio int, intObra int, intProveedor int, dblImporte DECIMAL(18,2), strInsumo VARCHAR(50), intArea int)
	CREATE TABLE #InventariableEntrada(id int identity(1,1),strCuentaCargo VARCHAR(30),strCuentaAbono VARCHAR(30), intFolio int, intObra int, intProveedor int, dblImporte DECIMAL(18,2), strInsumo VARCHAR(50),intArea int)
	CREATE TABLE #InventariableSalida(id int identity(1,1),strCuentaCargo VARCHAR(30),strCuentaAbono VARCHAR(30), intFolio int, intObra int, intProveedor int, dblImporte DECIMAL(18,2), strInsumo VARCHAR(50), intArea int)
	CREATE TABLE #NotCuenta(strClave varchar(10))

	INSERT INTO #Data(intEmpresa,intFolio,intObra,intProveedor,intOrdenCompraDet,intArticulo,strClave,intInventario,dblCantidad,dblImporte, intArea)
	SELECT E.intEmpresa, OC.intFolio,OC.intObra,OC.intProveedor,E.intOrdenCompraDet, D.intArticulo, A.strNombreCorto, CASE WHEN LEFT(A.strNombreCorto,1) IN('4','6','3') THEN 0 ELSE CASE WHEN LEFT(A.strNombreCorto,1) = 1 THEN 1 ELSE NULL END END, SUM(E.dblCantidad), 
	SUM(E.dblCantidad * D.dblPrecio * ISNULL(OC.dblTipoCambio,1)), CONVERT(INT,LEFT(O.strClave,2))
	FROM dbo.tbEntradaCompras E
	INNER JOIN tbOrdenCompraDet D ON D.intOrdenCompraDet = E.intOrdenCompraDet AND D.intEmpresa = E.intEmpresa
	INNER JOIN tbOrdenCompraEnc OC ON OC.intOrdenCompraEnc = D.intOrdenCompraEnc AND OC.intEmpresa = E.intEmpresa
	INNER JOIN tbArticulo A ON A.intArticulo = D.intArticulo AND A.intEmpresa = D.intEmpresa
	INNER JOIN tbObra O ON O.intObra = OC.intObra		
	WHERE  E.intEmpresa = @intEmpresa
	AND YEAR(E.datFecha) = @intEjercicio
	AND MONTH(E.datFecha) = @intMes
	AND E.intEstatus <> 9
	GROUP BY E.intEmpresa, OC.intFolio, OC.intObra,OC.intProveedor, E.intOrdenCompraDet, D.intArticulo,A.strNombreCorto, A.intFamilia,O.strClave

	DELETE FROM #Data where intInventario IS NULL
	DELETE FROM #Data where dblImporte = 0

	INSERT INTO #NotCuenta(strClave)
	SELECT strClave
	FROM #Data D
	WHERE intInventario = 0
	EXCEPT
	SELECT strClave
	FROM #Data D
	INNER JOIN VetecMarfilAdmin..tbCuentasRet R ON R.intEmpresa = D.intEmpresa
	WHERE D.strClave COLLATE SQL_Latin1_General_CP1_CI_AS BETWEEN R.strInsumoIni AND strInsumoFin AND D.intArea = R.intArea
	AND intInventario = 0

	SELECT @Data = COALESCE(@Data,'') + strClave + ','  from #NotCuenta
	
	IF(ISNULL(@Data,'') <> '')
	BEGIN
		SET @Error = 'Cuentas no cargadas NO INVENTARIABLES:' + @Data + '.  Revisar asignacion cuentas.'
		RAISERROR (@Error,16,1);
		RETURN;
	END

	DELETE FROM #NotCuenta
	SET @Data = ''

	INSERT INTO #NotCuenta(strClave)
	SELECT strClave
	FROM #Data D
	WHERE intInventario = 1
	EXCEPT
	SELECT strClave
	FROM #Data D
	INNER JOIN VetecMarfilAdmin..tbCuentasRet R ON R.intEmpresa = D.intEmpresa
	WHERE D.strClave COLLATE SQL_Latin1_General_CP1_CI_AS BETWEEN R.strInsumoIni AND strInsumoFin AND D.intArea = R.intArea
	AND intInventario = 1
	AND R.intEs = 1

	SELECT @Data = COALESCE(@Data,'') + strClave + ','  from #NotCuenta
	
	IF(ISNULL(@Data,'') <> '')
	BEGIN
		SET @Error = 'Cuentas no cargadas INVENTARIABLES ENTRADA:' + @Data + '.  Revisar asignacion cuentas.'
		RAISERROR (@Error,16,1);
		RETURN;
	END

	DELETE FROM #NotCuenta
	SET @Data = ''

	INSERT INTO #NotCuenta(strClave)
	SELECT strClave
	FROM #Data D
	WHERE intInventario = 1
	EXCEPT
	SELECT strClave
	FROM #Data D
	INNER JOIN VetecMarfilAdmin..tbCuentasRet R ON R.intEmpresa = D.intEmpresa
	WHERE D.strClave COLLATE SQL_Latin1_General_CP1_CI_AS BETWEEN R.strInsumoIni AND strInsumoFin AND D.intArea = R.intArea
	AND intInventario = 1
	AND R.intEs = 0

	SELECT @Data = COALESCE(@Data,'') + strClave + ','  from #NotCuenta
	
	IF(ISNULL(@Data,'') <> '')
	BEGIN
		SET @Error = 'Cuentas no cargadas INVENTARIABLES SALIDA:' + @Data + '. Revisar asignacion cuentas.'
		RAISERROR (@Error,16,1);
		RETURN;
	END

	
	INSERT INTO #NoInventariable(strCuentaCargo,strCuentaAbono,dblImporte,intFolio,intObra,intProveedor,strInsumo,intArea)
	SELECT CASE WHEN D.intObra IN(2601,2602,2603) THEN REPLACE(REPLACE(R.strCuentaCargo,'-',''),'4130','4145') ELSE REPLACE(R.strCuentaCargo,'-','') END, REPLACE(R.strCuentaAbono,'-',''), SUM(D.dblImporte), D.intFolio, D.intObra,D.intProveedor, D.strClave, D.intArea
	FROM #Data D
	INNER JOIN VetecMarfilAdmin..tbCuentasRet R ON R.intEmpresa = D.intEmpresa
	WHERE D.strClave COLLATE SQL_Latin1_General_CP1_CI_AS BETWEEN R.strInsumoIni AND strInsumoFin AND D.intArea = R.intArea
	AND intInventario = 0
	GROUP BY REPLACE(R.strCuentaCargo,'-',''), REPLACE(R.strCuentaAbono,'-',''), D.intFolio, D.intObra,D.intProveedor,D.strClave,D.intArea

	INSERT INTO #InventariableEntrada(strCuentaCargo,strCuentaAbono,dblImporte,intFolio,intObra,intProveedor,strInsumo,intArea)
	SELECT REPLACE(R.strCuentaCargo,'-',''), REPLACE(R.strCuentaAbono,'-',''), SUM(D.dblImporte), D.intFolio, D.intObra,D.intProveedor, D.strClave, D.intArea
	FROM #Data D
	INNER JOIN VetecMarfilAdmin..tbCuentasRet R ON R.intEmpresa = D.intEmpresa
	WHERE D.strClave COLLATE SQL_Latin1_General_CP1_CI_AS BETWEEN R.strInsumoIni AND strInsumoFin AND D.intArea = R.intArea
	AND intInventario = 1
	AND R.intEs = 1
	GROUP BY REPLACE(R.strCuentaCargo,'-',''), REPLACE(R.strCuentaAbono,'-',''), D.intFolio, D.intObra,D.intProveedor,D.strClave,D.intArea

	INSERT INTO #InventariableSalida(strCuentaCargo,strCuentaAbono,dblImporte,intFolio,intObra,intProveedor,strInsumo,intArea)
	SELECT CASE WHEN D.intObra IN(2601,2602,2603) THEN REPLACE(REPLACE(R.strCuentaCargo,'-',''),'4130','4145') ELSE REPLACE(R.strCuentaCargo,'-','') END, REPLACE(R.strCuentaAbono,'-',''), SUM(D.dblImporte), D.intFolio, D.intObra,D.intProveedor, D.strClave ,D.intArea
	FROM #Data D
	INNER JOIN VetecMarfilAdmin..tbCuentasRet R ON R.intEmpresa = D.intEmpresa
	WHERE D.strClave COLLATE SQL_Latin1_General_CP1_CI_AS BETWEEN R.strInsumoIni AND strInsumoFin AND D.intArea = R.intArea
	AND intInventario = 1
	AND R.intEs = 0
	AND D.strClave NOT IN('1040065','1180020','1240020','1280020','1780065')
	GROUP BY REPLACE(R.strCuentaCargo,'-',''), REPLACE(R.strCuentaAbono,'-',''), D.intFolio, D.intObra,D.intProveedor,D.strClave,D.intArea

	--****NO INVENTARIABLES
	SET	@Count = 0
	SET @Row = 0
	SELECT @Rows = COUNT(*) FROM #NoInventariable
	SELECT @dblSUM = SUM(ABS(dblImporte)) FROM #NoInventariable
	
	--FOLIO DE LA POLIZA                                             
	SET @intPoliza = (SELECT VetecMarfilAdmin.dbo.F_RegresaFolioPoliza(@intEmpresa, '0', @intEjercicio , @intMes , @strTipoPoliza , 0 ) + 1 )                                                                                           

	WHILE( EXISTS(SELECT * FROM VetecMarfilAdmin.dbo.tbPolizasEnc WHERE intEmpresa = @intEmpresa AND strClasifEnc = '0' AND intEjercicio = @intEjercicio AND intMes = @intMes AND strTipoPoliza = @strTipoPoliza AND intFolioPoliza = @intPoliza) )
	BEGIN                                                       
		SET @intPoliza = @intPoliza + 1                                                                                                  
	END                    
		                    	
	SET @strPoliza = RIGHT('00'+ Rtrim(ltrim(@intMes)) , 2) + Right('   '+ Rtrim(ltrim(@strTipoPoliza)) , 3) +  Rtrim(Ltrim(Convert(Varchar(20), @intPoliza)))                                          

	IF(@Rows > 0)
	BEGIN
		INSERT INTO VetecMarfilAdmin..tbPolizasEnc(intEmpresa,strClasifEnc,intEjercicio,intMes,strPoliza,
		strTipoPoliza,intFolioPoliza,datFecha,intEstatus,strDescripcion,dblCargos,dblAbonos,intIndAfectada,
		intIndInterempresa,intIndRec,intIndGenRec,intEjercicioOr,intMesOr,strPolizaOr,intConFlujo,strAuditAlta,
		strAuditMod,dblTransmision,intCuentaBancaria,intCheque,intPartida,intCenCos,intTransferencia)  
		VALUES (@intEmpresa,'0',@intEjercicio,@intMes,@strPoliza,@strTipoPoliza,@intPoliza,@strFecha,3,'INVENTARIO',
		@dblSUM,@dblSUM,0,0,0,0,0,0,0,0,@strUsuario + ' ' + CONVERT(VARCHAR, GETDATE()),NULL,0,NULL,0,0,0,0)

		WHILE (@Rows > @Count)
		BEGIN
			SET @Count = @Count + 1
			SET @Row = @Row + 1

			SELECT @strCuentaCargo = strCuentaCargo,@strCuentaAbono = strCuentaAbono,@dblImporte = dblImporte,@intFolio = intFolio,
			@intObra = intObra,@intProveedor = intProveedor, @strInsumo = strInsumo,@intArea = intArea
			FROM #NoInventariable WHERE id = @Count

			SELECT @strProveedor = strNombre FROM VetecMarfilAdmin..tbProveedores WHERE intEmpresa = @intEmpresa AND intProveedor = @intProveedor

			INSERT INTO VetecMarfilAdmin..tbPolizasDet(intEmpresa,strClasifEnc,intEjercicio,intMes,strPoliza,strTipoPoliza,
			intFolioPoliza,intPartida,datFecha,strClasifDP,strClasifDS,strCuenta,strCuentaOrig,intTipoMovto,dblImporte,intTipoMoneda,
			dblTipoCambio,dblImporteTipoMoneda,strReferencia,strDescripcion,intIndAfectada,strFactura,intFacConsec,intProveedor,
			intTipoConcepto,intConcepto,intCuentaBancaria,intCheque,intConciliado,intConcilFolio,strClaveRef,strFolioRef,
			strAuditAlta,strAuditMod,intTipoAux)
			VALUES(@intEmpresa,'0',@intEjercicio,@intMes,@strPoliza,@strTipoPoliza,
			@intPoliza,@Row,@strFecha,0,@intObra,CASE WHEN @dblImporte < 0 THEN @strCuentaAbono ELSE @strCuentaCargo END,NULL,1,ABS(@dblImporte),1,
			1,ABS(@dblImporte),@intFolio,@intProveedor + ' ' + @strProveedor,0,@intFolio,@intArea,@intProveedor,
			NULL, NULL, NULL, 0, 0, NULL, NULL, @strInsumo, 
			@strUsuario + ' ' + @strMaquina + ' /SEM/ ' +CONVERT(VARCHAR, GETDATE()), NULL, NULL)

			SET @Row = @Row + 1

			INSERT INTO VetecMarfilAdmin..tbPolizasDet(intEmpresa,strClasifEnc,intEjercicio,intMes,strPoliza,strTipoPoliza,
			intFolioPoliza,intPartida,datFecha,strClasifDP,strClasifDS,strCuenta,strCuentaOrig,intTipoMovto,dblImporte,intTipoMoneda,
			dblTipoCambio,dblImporteTipoMoneda,strReferencia,strDescripcion,intIndAfectada,strFactura,intFacConsec,intProveedor,
			intTipoConcepto,intConcepto,intCuentaBancaria,intCheque,intConciliado,intConcilFolio,strClaveRef,strFolioRef,
			strAuditAlta,strAuditMod,intTipoAux)
			VALUES(@intEmpresa,'0',@intEjercicio,@intMes,@strPoliza,@strTipoPoliza,
			@intPoliza,@Row,@strFecha,0,@intObra,CASE WHEN @dblImporte < 0 THEN @strCuentaCargo ELSE @strCuentaAbono END,NULL,0,ABS(@dblImporte),1,
			1,ABS(@dblImporte),@intFolio,'Cuadre Inventario',0,@intFolio,@intArea,@intProveedor,
			NULL, NULL, NULL, 0, 0, NULL, NULL, @strInsumo, 
			@strUsuario + ' ' + @strMaquina + ' /SEM/ ' +CONVERT(VARCHAR, GETDATE()), NULL, NULL)

			SET @strCuentaCargo = ''
			SET @strCuentaAbono = ''
			SET @dblImporte = 0
			SET @intFolio = 0
			SET @intProveedor = ''
			SET @strCuentaCargo = ''
			SET @strInsumo = ''
		END

		--INCREMENTA EL FOLIO                                                          
		EXEC VetecMarfilAdmin.dbo.qryINCN2050_Upd_tbTiposPoliza @intEmpresa, '0', @intEjercicio, @intMes, @strTipoPoliza, @intPoliza                                                           
	END

	SET @strPolizas = @strPoliza

	--****INVENTARIABLES ENTRADA
	SET	@Count = 0
	SET @Row = 0
	SELECT @Rows = COUNT(*) FROM #InventariableEntrada
	SELECT @dblSUM = SUM(ABS(dblImporte)) FROM #InventariableEntrada	

	--FOLIO DE LA POLIZA                                             
	SET @intPoliza = (SELECT VetecMarfilAdmin.dbo.F_RegresaFolioPoliza(@intEmpresa, '0', @intEjercicio , @intMes , @strTipoPoliza , 0 ) + 1 )                                                                                           
			
	WHILE( EXISTS(SELECT * FROM VetecMarfilAdmin.dbo.tbPolizasEnc WHERE intEmpresa = @intEmpresa AND strClasifEnc = '0' AND intEjercicio = @intEjercicio AND intMes = @intMes AND strTipoPoliza = @strTipoPoliza AND intFolioPoliza = @intPoliza) )
	BEGIN                                                       
		SET @intPoliza = @intPoliza + 1                                                                                                  
	END                    
		                    	
	SET @strPoliza = RIGHT('00'+ Rtrim(ltrim(@intMes)) , 2) + Right('   '+ Rtrim(ltrim(@strTipoPoliza)) , 3) +  Rtrim(Ltrim(Convert(Varchar(20), @intPoliza)))                                          

	IF(@Rows > 0)
	BEGIN
		INSERT INTO VetecMarfilAdmin..tbPolizasEnc(intEmpresa,strClasifEnc,intEjercicio,intMes,strPoliza,
		strTipoPoliza,intFolioPoliza,datFecha,intEstatus,strDescripcion,dblCargos,dblAbonos,intIndAfectada,
		intIndInterempresa,intIndRec,intIndGenRec,intEjercicioOr,intMesOr,strPolizaOr,intConFlujo,strAuditAlta,
		strAuditMod,dblTransmision,intCuentaBancaria,intCheque,intPartida,intCenCos,intTransferencia)  
		VALUES (@intEmpresa,'0',@intEjercicio,@intMes,@strPoliza,@strTipoPoliza,@intPoliza,@strFecha,3,'INVENTARIO',
		@dblSUM,@dblSUM,0,0,0,0,0,0,0,0,@strUsuario + ' ' + CONVERT(VARCHAR, GETDATE()),NULL,0,NULL,0,0,0,0)

		WHILE (@Rows > @Count)
		BEGIN
			SET @Count = @Count + 1
			SET @Row = @Row + 1

			SELECT @strCuentaCargo = strCuentaCargo,@strCuentaAbono = strCuentaAbono,@dblImporte = dblImporte,@intFolio = intFolio,
			@intObra = intObra,@intProveedor = intProveedor, @strInsumo = strInsumo, @intArea = intArea
			FROM #InventariableEntrada WHERE id = @Count

			SELECT @strProveedor = strNombre FROM VetecMarfilAdmin..tbProveedores WHERE intEmpresa = @intEmpresa AND intProveedor = @intProveedor

			INSERT INTO VetecMarfilAdmin..tbPolizasDet(intEmpresa,strClasifEnc,intEjercicio,intMes,strPoliza,strTipoPoliza,
			intFolioPoliza,intPartida,datFecha,strClasifDP,strClasifDS,strCuenta,strCuentaOrig,intTipoMovto,dblImporte,intTipoMoneda,
			dblTipoCambio,dblImporteTipoMoneda,strReferencia,strDescripcion,intIndAfectada,strFactura,intFacConsec,intProveedor,
			intTipoConcepto,intConcepto,intCuentaBancaria,intCheque,intConciliado,intConcilFolio,strClaveRef,strFolioRef,
			strAuditAlta,strAuditMod,intTipoAux)
			VALUES(@intEmpresa,'0',@intEjercicio,@intMes,@strPoliza,@strTipoPoliza,
			@intPoliza,@Row,@strFecha,0,@intObra,CASE WHEN @dblImporte < 0 THEN @strCuentaAbono ELSE @strCuentaCargo END,NULL,1,ABS(@dblImporte),1,
			1,ABS(@dblImporte),@intFolio,@intProveedor + ' ' + @strProveedor,0,@intFolio,@intArea,@intProveedor,
			NULL, NULL, NULL, 0, 0, NULL, NULL, @strInsumo, 
			@strUsuario + ' ' + @strMaquina + ' /SEM/ ' +CONVERT(VARCHAR, GETDATE()), NULL, NULL)

			SET @Row = @Row + 1

			INSERT INTO VetecMarfilAdmin..tbPolizasDet(intEmpresa,strClasifEnc,intEjercicio,intMes,strPoliza,strTipoPoliza,
			intFolioPoliza,intPartida,datFecha,strClasifDP,strClasifDS,strCuenta,strCuentaOrig,intTipoMovto,dblImporte,intTipoMoneda,
			dblTipoCambio,dblImporteTipoMoneda,strReferencia,strDescripcion,intIndAfectada,strFactura,intFacConsec,intProveedor,
			intTipoConcepto,intConcepto,intCuentaBancaria,intCheque,intConciliado,intConcilFolio,strClaveRef,strFolioRef,
			strAuditAlta,strAuditMod,intTipoAux)
			VALUES(@intEmpresa,'0',@intEjercicio,@intMes,@strPoliza,@strTipoPoliza,
			@intPoliza,@Row,@strFecha,0,@intObra,CASE WHEN @dblImporte < 0 THEN @strCuentaCargo ELSE @strCuentaAbono END,NULL,0,ABS(@dblImporte),1,
			1,ABS(@dblImporte),@intFolio,'Cuadre Inventario',0,@intFolio,@intArea,@intProveedor,
			NULL, NULL, NULL, 0, 0, NULL, NULL, @strInsumo, 
			@strUsuario + ' ' + @strMaquina + ' /SEM/ ' +CONVERT(VARCHAR, GETDATE()), NULL, NULL)

			SET @strCuentaCargo = ''
			SET @strCuentaAbono = ''
			SET @dblImporte = 0
			SET @intFolio = 0
			SET @intProveedor = ''
			SET @strCuentaCargo = ''
			SET @strInsumo = ''
		END

		--INCREMENTA EL FOLIO                                                          
		EXEC VetecMarfilAdmin.dbo.qryINCN2050_Upd_tbTiposPoliza @intEmpresa, '0', @intEjercicio, @intMes, @strTipoPoliza, @intPoliza                                                           
	END

	SET @strPolizas = @strPolizas + ',' + @strPoliza

	--****INVENTARIABLES SALIDA
	SET	@Count = 0
	SET @Row = 0
	SELECT @Rows = COUNT(*) FROM #InventariableSalida
	SELECT @dblSUM = SUM(ABS(dblImporte)) FROM #InventariableSalida

	--FOLIO DE LA POLIZA                                             
	SET @intPoliza = (SELECT VetecMarfilAdmin.dbo.F_RegresaFolioPoliza(@intEmpresa, '0', @intEjercicio , @intMes , @strTipoPoliza , 0 ) + 1 )                                                                                           
			
	WHILE( EXISTS(SELECT * FROM VetecMarfilAdmin.dbo.tbPolizasEnc WHERE intEmpresa = @intEmpresa AND strClasifEnc = '0' AND intEjercicio = @intEjercicio AND intMes = @intMes AND strTipoPoliza = @strTipoPoliza AND intFolioPoliza = @intPoliza) )
	BEGIN                                                       
		SET @intPoliza = @intPoliza + 1                                                                                                  
	END                    
		                    	
	SET @strPoliza = RIGHT('00'+ Rtrim(ltrim(@intMes)) , 2) + Right('   '+ Rtrim(ltrim(@strTipoPoliza)) , 3) +  Rtrim(Ltrim(Convert(Varchar(20), @intPoliza)))                                          

	IF(@Rows > 0)
	BEGIN
		INSERT INTO VetecMarfilAdmin..tbPolizasEnc(intEmpresa,strClasifEnc,intEjercicio,intMes,strPoliza,
		strTipoPoliza,intFolioPoliza,datFecha,intEstatus,strDescripcion,dblCargos,dblAbonos,intIndAfectada,
		intIndInterempresa,intIndRec,intIndGenRec,intEjercicioOr,intMesOr,strPolizaOr,intConFlujo,strAuditAlta,
		strAuditMod,dblTransmision,intCuentaBancaria,intCheque,intPartida,intCenCos,intTransferencia)  
		VALUES (@intEmpresa,'0',@intEjercicio,@intMes,@strPoliza,@strTipoPoliza,@intPoliza,@strFecha,3,'INVENTARIO',
		@dblSUM,@dblSUM,0,0,0,0,0,0,0,0,@strUsuario + ' ' + CONVERT(VARCHAR, GETDATE()),NULL,0,NULL,0,0,0,0)

		WHILE (@Rows > @Count)
		BEGIN
			SET @Count = @Count + 1
			SET @Row = @Row + 1

			SELECT @strCuentaCargo = strCuentaCargo,@strCuentaAbono = strCuentaAbono,@dblImporte = dblImporte,@intFolio = intFolio,
			@intObra = intObra,@intProveedor = intProveedor, @strInsumo = strInsumo, @intArea = intArea
			FROM #InventariableSalida WHERE id = @Count

			SELECT @strProveedor = strNombre FROM VetecMarfilAdmin..tbProveedores WHERE intEmpresa = @intEmpresa AND intProveedor = @intProveedor

			INSERT INTO VetecMarfilAdmin..tbPolizasDet(intEmpresa,strClasifEnc,intEjercicio,intMes,strPoliza,strTipoPoliza,
			intFolioPoliza,intPartida,datFecha,strClasifDP,strClasifDS,strCuenta,strCuentaOrig,intTipoMovto,dblImporte,intTipoMoneda,
			dblTipoCambio,dblImporteTipoMoneda,strReferencia,strDescripcion,intIndAfectada,strFactura,intFacConsec,intProveedor,
			intTipoConcepto,intConcepto,intCuentaBancaria,intCheque,intConciliado,intConcilFolio,strClaveRef,strFolioRef,
			strAuditAlta,strAuditMod,intTipoAux)
			VALUES(@intEmpresa,'0',@intEjercicio,@intMes,@strPoliza,@strTipoPoliza,
			@intPoliza,@Row,@strFecha,0,@intObra,CASE WHEN @dblImporte < 0 THEN @strCuentaAbono ELSE @strCuentaCargo END,NULL,1,ABS(@dblImporte),1,
			1,ABS(@dblImporte),@intFolio,@intProveedor + ' ' + @strProveedor,0,@intFolio,@intArea,@intProveedor,
			NULL, NULL, NULL, 0, 0, NULL, NULL, @strInsumo, 
			@strUsuario + ' ' + @strMaquina + ' /SEM/ ' +CONVERT(VARCHAR, GETDATE()), NULL, NULL)

			SET @Row = @Row + 1

			INSERT INTO VetecMarfilAdmin..tbPolizasDet(intEmpresa,strClasifEnc,intEjercicio,intMes,strPoliza,strTipoPoliza,
			intFolioPoliza,intPartida,datFecha,strClasifDP,strClasifDS,strCuenta,strCuentaOrig,intTipoMovto,dblImporte,intTipoMoneda,
			dblTipoCambio,dblImporteTipoMoneda,strReferencia,strDescripcion,intIndAfectada,strFactura,intFacConsec,intProveedor,
			intTipoConcepto,intConcepto,intCuentaBancaria,intCheque,intConciliado,intConcilFolio,strClaveRef,strFolioRef,
			strAuditAlta,strAuditMod,intTipoAux)
			VALUES(@intEmpresa,'0',@intEjercicio,@intMes,@strPoliza,@strTipoPoliza,
			@intPoliza,@Row,@strFecha,0,@intObra,CASE WHEN @dblImporte < 0 THEN @strCuentaCargo ELSE @strCuentaAbono END,NULL,0,ABS(@dblImporte),1,
			1,ABS(@dblImporte),@intFolio,'Cuadre Inventario',0,@intFolio,@intArea,@intProveedor,
			NULL, NULL, NULL, 0, 0, NULL, NULL, @strInsumo, 
			@strUsuario + ' ' + @strMaquina + ' /SEM/ ' +CONVERT(VARCHAR, GETDATE()), NULL, NULL)

			SET @strCuentaCargo = ''
			SET @strCuentaAbono = ''
			SET @dblImporte = 0
			SET @intFolio = 0
			SET @intProveedor = ''
			SET @strCuentaCargo = ''
			SET @strInsumo = ''
		END

		--INCREMENTA EL FOLIO                                                          
		EXEC VetecMarfilAdmin.dbo.qryINCN2050_Upd_tbTiposPoliza @intEmpresa, '0', @intEjercicio, @intMes, @strTipoPoliza, @intPoliza 
	END

	SET @strPolizas = @strPolizas + ',' + @strPoliza

	SELECT ISNULL(@strPolizas,'') AS Poliza

	DROP TABLE #Data
	DROP TABLE #NoInventariable
	DROP TABLE #InventariableEntrada
	DROP TABLE #InventariableSalida

	SET NOCOUNT OFF
	
END
GO

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbPolizas_Invetario Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbPolizas_Invetario Error on Creation'
END
GO



IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbProspecto_EscList')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbProspecto_EscList
	PRINT N'Drop Procedure : dbo.usp_tbProspecto_EscList - Succeeded !!!'
END
GO

------------------------------------------------------------------------------------
---   Aplicacion: RMM.		                                                     ---
---        Autor: Ruben Mora Martinez                                            ---
---  Descripcion: Obtiene un registro de la tabla:  tbCotizacion                 ---
---                                                                              ---
------------------------------------------------------------------------------------
---    Fecha     Autor  Comentario                                               ---
---  ----------  -----  -------------------------------------------------------  ---
---  22/08/2011  RMM    Create procedure                                         ---
------------------------------------------------------------------------------------

CREATE PROCEDURE dbo.usp_tbProspecto_EscList
(	
	@intEmpresa		int,
	@intSucursal	int,
	@intColonia		int,		
	@intDireccion	int,
	@SortExpression 	varchar(50),
	@bAplicado		int,
	@intEjercicio	int,
	@intMes			int
)
WITH ENCRYPTION
AS
BEGIN
	SET NOCOUNT ON

		DECLARE @Sort varchar(200)
		DECLARE @FechaFinal datetime

		SET @Sort = LOWER(@SortExpression) + CASE WHEN @intDireccion = 0 THEN ' DESC' ELSE ' ASC' END

		IF(@bAplicado = 1)
		BEGIN
			SELECT E.intProspecto, E.strNombreCliente as Prospecto, CASE WHEN intEmpresaTerreno = 1 THEN 'Fideicomiso' ELSE
			CASE WHEN intEmpresaTerreno = 2 THEN 'Desarrollo' ELSE 'Maple' END END AS Terreno, 
			Convert(varchar,E.datFechaEscrituracion,103) AS datFechaEscrituracion, T.strNombre AS TipoCredito,
			E.strColonia,E.strColonia,ISNULL(E.strPoliza,'') AS strPoliza, ISNULL(E.strPolizaTerreno,'') AS strPolizaTerreno, dbo.fn_PrecioTerreno(E.intProspecto) AS dblTerreno,
			ISNULL(dbo.fn_PrecioEdificacion(E.intProspecto),0) AS dblEdificacion,intEmpresaTerreno, YEAR(E.datFechaEscrituracion) AS intEjercicio
			FROM tbInterfase_Escrituracion E
			INNER JOIN tbProspecto P ON P.intProspecto = E.intProspecto
			INNER JOIN tbTipoCredito T ON T.intTipoCredito = E.intTipoCredito
			WHERE ((@intColonia = 0) OR (P.intColonia = @intColonia))
			AND ISNULL(strPoliza,'') <> ''
			AND YEAR(E.datFechaEscrituracion) = @intEjercicio
			AND MONTH(E.datFechaEscrituracion) = @intMes
			ORDER BY 
				CASE WHEN @Sort = 'intProspecto DESC' THEN E.intProspecto END DESC,
				CASE WHEN @Sort = 'intProspecto ASC' THEN E.intProspecto END ASC,
				CASE WHEN @Sort = 'Prospecto DESC' THEN E.strNombreCliente END DESC,
				CASE WHEN @Sort = 'Prospecto ASC' THEN E.strNombreCliente END ASC,
				CASE WHEN @Sort = 'Terreno DESC' THEN E.intEmpresaTerreno END DESC,
				CASE WHEN @Sort = 'Terreno ASC' THEN E.intEmpresaTerreno END ASC,
				CASE WHEN @Sort = 'Fecha DESC' THEN E.datFechaEscrituracion END DESC,
				CASE WHEN @Sort = 'Fecha ASC' THEN E.datFechaEscrituracion END ASC,
				CASE WHEN @Sort = 'TipoCredito DESC' THEN T.strNombre END DESC,
				CASE WHEN @Sort = 'TipoCredito ASC' THEN T.strNombre END ASC,
				CASE WHEN @Sort = 'strColonia DESC' THEN E.strColonia END DESC,
				CASE WHEN @Sort = 'strColonia ASC' THEN E.strColonia END ASC,
				CASE WHEN @Sort = 'Poliza DESC' THEN isnull(E.strPoliza,'') END DESC,
				CASE WHEN @Sort = 'Poliza ASC' THEN isnull(E.strPoliza,'') END ASC
		END
		
		IF(@bAplicado = 0)
		BEGIN
			SELECT E.intProspecto, E.strNombreCliente as Prospecto, CASE WHEN intEmpresaTerreno = 1 THEN 'Fideicomiso' ELSE
			CASE WHEN intEmpresaTerreno = 2 THEN 'Desarrollo' ELSE 'Maple' END END AS Terreno, 
			Convert(varchar,E.datFechaEscrituracion,103) AS datFechaEscrituracion, T.strNombre AS TipoCredito,
			E.strColonia,ISNULL(E.strPoliza,'') AS strPoliza, ISNULL(E.strPolizaTerreno,'') AS strPolizaTerreno, dbo.fn_PrecioTerreno(E.intProspecto) AS dblTerreno,
			ISNULL(dbo.fn_PrecioEdificacion(E.intProspecto),0) AS dblEdificacion,intEmpresaTerreno,YEAR(E.datFechaEscrituracion) AS intEjercicio
			FROM tbInterfase_Escrituracion E
			INNER JOIN tbProspecto P ON P.intProspecto = E.intProspecto
			INNER JOIN tbTipoCredito T ON T.intTipoCredito = E.intTipoCredito
			WHERE ((@intColonia = 0) OR (P.intColonia = @intColonia))
			AND ISNULL(strPoliza,'') = ''
			AND YEAR(E.datFechaEscrituracion) = @intEjercicio
			AND MONTH(E.datFechaEscrituracion) = @intMes
			ORDER BY 
				CASE WHEN @Sort = 'intProspecto DESC' THEN E.intProspecto END DESC,
				CASE WHEN @Sort = 'intProspecto ASC' THEN E.intProspecto END ASC,
				CASE WHEN @Sort = 'Prospecto DESC' THEN E.strNombreCliente END DESC,
				CASE WHEN @Sort = 'Prospecto ASC' THEN E.strNombreCliente END ASC,
				CASE WHEN @Sort = 'Terreno DESC' THEN E.intEmpresaTerreno END DESC,
				CASE WHEN @Sort = 'Terreno ASC' THEN E.intEmpresaTerreno END ASC,
				CASE WHEN @Sort = 'Fecha DESC' THEN E.datFechaEscrituracion END DESC,
				CASE WHEN @Sort = 'Fecha ASC' THEN E.datFechaEscrituracion END ASC,
				CASE WHEN @Sort = 'TipoCredito DESC' THEN T.strNombre END DESC,
				CASE WHEN @Sort = 'TipoCredito ASC' THEN T.strNombre END ASC,
				CASE WHEN @Sort = 'strColonia DESC' THEN E.strColonia END DESC,
				CASE WHEN @Sort = 'strColonia ASC' THEN E.strColonia END ASC,
				CASE WHEN @Sort = 'Poliza DESC' THEN isnull(E.strPoliza,'') END DESC,
				CASE WHEN @Sort = 'Poliza ASC' THEN isnull(E.strPoliza,'') END ASC
		END

		IF(@bAplicado = 2)
		BEGIN
			SELECT E.intProspecto, E.strNombreCliente as Prospecto, CASE WHEN intEmpresaTerreno = 1 THEN 'Fideicomiso' ELSE
			CASE WHEN intEmpresaTerreno = 2 THEN 'Desarrollo' ELSE 'Maple' END END AS Terreno, 
			Convert(varchar,E.datFechaEscrituracion,103) AS datFechaEscrituracion, T.strNombre AS TipoCredito,
			E.strColonia,ISNULL(E.strPoliza,'') AS strPoliza, ISNULL(E.strPolizaTerreno,'') AS strPolizaTerreno, dbo.fn_PrecioTerreno(E.intProspecto) AS dblTerreno,
			ISNULL(dbo.fn_PrecioEdificacion(E.intProspecto),0) AS dblEdificacion,intEmpresaTerreno, YEAR(E.datFechaEscrituracion) AS intEjercicio, ISNULL(E.strPolizaTerreno,'') AS strPolizaTerreno
			FROM tbInterfase_Escrituracion E
			INNER JOIN tbProspecto P ON P.intProspecto = E.intProspecto
			INNER JOIN tbTipoCredito T ON T.intTipoCredito = E.intTipoCredito
			WHERE ((@intColonia = 0) OR (P.intColonia = @intColonia))
			AND YEAR(E.datFechaEscrituracion) = @intEjercicio
			AND MONTH(E.datFechaEscrituracion) = @intMes
			ORDER BY 
				CASE WHEN @Sort = 'intProspecto DESC' THEN E.intProspecto END DESC,
				CASE WHEN @Sort = 'intProspecto ASC' THEN E.intProspecto END ASC,
				CASE WHEN @Sort = 'Prospecto DESC' THEN E.strNombreCliente END DESC,
				CASE WHEN @Sort = 'Prospecto ASC' THEN E.strNombreCliente END ASC,
				CASE WHEN @Sort = 'Terreno DESC' THEN E.intEmpresaTerreno END DESC,
				CASE WHEN @Sort = 'Terreno ASC' THEN E.intEmpresaTerreno END ASC,
				CASE WHEN @Sort = 'Fecha DESC' THEN E.datFechaEscrituracion END DESC,
				CASE WHEN @Sort = 'Fecha ASC' THEN E.datFechaEscrituracion END ASC,
				CASE WHEN @Sort = 'TipoCredito DESC' THEN T.strNombre END DESC,
				CASE WHEN @Sort = 'TipoCredito ASC' THEN T.strNombre END ASC,
				CASE WHEN @Sort = 'strColonia DESC' THEN E.strColonia END DESC,
				CASE WHEN @Sort = 'strColonia ASC' THEN E.strColonia END ASC,
				CASE WHEN @Sort = 'Poliza DESC' THEN isnull(E.strPoliza,'') END DESC,
				CASE WHEN @Sort = 'Poliza ASC' THEN isnull(E.strPoliza,'') END ASC
		END
		

	SET NOCOUNT OFF
END
GO 

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbProspecto_EscList Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbProspecto_EscList Error on Creation'
END
GO





IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbRubrosCuentas_Del')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbRubrosCuentas_Del
	PRINT N'Drop Procedure : dbo.usp_tbRubrosCuentas_Del - Succeeded !!!'
END
GO

------------------------------------------------------------------------------------
---																				 ---
---        Autor: Ingrid Soto		                                             ---
---  Descripcion: Elimina en tbRubros										 ---
---                                                                              ---
------------------------------------------------------------------------------------
---    Fecha     Autor  Comentario                                               ---
---  ----------  -----  -------------------------------------------------------  ---
---  28/08/2013  IASD    Create procedure                                         ---
------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[usp_tbRubrosCuentas_Del]
(
       @intEmpresa int,
	   @strCuenta varchar(50),
       @intRubro int
) 
WITH ENCRYPTION
AS
BEGIN
	SET NOCOUNT ON
                
	DELETE
    FROM   VetecMarfilAdmin..tbRubrosCuentas
	WHERE  intRubro   = @intRubro
	AND strCuenta = @strCuenta
	AND intEmpresa = @intEmpresa
	
	SELECT @intRubro

	SET NOCOUNT off
END
GO 

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbRubrosCuentas_Del Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbRubrosCuentas_Del Error on Creation'
END
GO



IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbRubrosCuentas_Fill')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbRubrosCuentas_Fill
	PRINT N'Drop Procedure : dbo.usp_tbRubrosCuentas_Fill - Succeeded !!!'
END
GO

------------------------------------------------------------------------------------
---																				 ---
---        Autor: Ingrid Soto		                                             ---
---  Descripcion: Consulta en tbRubros											 ---
---                                                                              ---
------------------------------------------------------------------------------------
---    Fecha     Autor  Comentario                                               ---
---  ----------  -----  -------------------------------------------------------  ---
---  28/08/2013  IASD    Create procedure                                         ---
------------------------------------------------------------------------------------
CREATE 
PROCEDURE [dbo].[usp_tbRubrosCuentas_Fill]
(
       @intEmpresa int,
	   @strCuenta varchar(50),
       @intRubro int
) 
AS
BEGIN
	SET NOCOUNT ON
                
				SELECT
					intRubro
					,ISNULL(strCuenta,'') as strCuenta
					,ISNULL(intIndSumaResta,0) as intIndSumaResta
					,ISNULL(datFechaAlta,'01/01/1900') as datFechaAlta
					,ISNULL(strUsuarioAlta,'') as strUsuarioAlta
					,ISNULL(strMaquinaAlta,'') as strMaquinaAlta
					,ISNULL(datFechaMod, '01/01/1900') as datFechaMod
					,ISNULL(strUsuarioMod,'') as strUsuarioMod
					,ISNULL(strMaquinaMod, '') as strMaquinaMod
					,ISNULL(intEmpresa,0) as intEmpresa
                FROM   VetecMarfilAdmin..tbRubrosCuentas
                WHERE  intRubro   = @intRubro
						AND strCuenta = @strCuenta
						AND intEmpresa = @intEmpresa

END
GO 

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbRubrosCuentas_Fill Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbRubrosCuentas_Fill Error on Creation'
END
GO

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbRubrosCuentas_Save')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbRubrosCuentas_Save
	PRINT N'Drop Procedure : dbo.usp_tbRubrosCuentas_Save - Succeeded !!!'
END
GO


------------------------------------------------------------------------------------
---																				 ---
---        Autor: Ingrid Soto		                                             ---
---  Descripcion: Inserta en tbRubrosCuentas										 ---
---                                                                              ---
------------------------------------------------------------------------------------
---    Fecha     Autor  Comentario                                               ---
---  ----------  -----  -------------------------------------------------------  ---
---  30/08/2013  IASD    Create procedure                                         ---
------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[usp_tbRubrosCuentas_Save]
(
	@intRubro int,
	@strCuenta varchar(50),
	@intIndSumaResta int,
	@datFechaAlta datetime,
	@strUsuarioAlta varchar(20),
	@strMaquinaAlta varchar(20),
	@datFechaMod datetime,
	@strUsuarioMod varchar(20),
	@strMaquinaMod varchar(20),
	@intEmpresa int

) 
WITH ENCRYPTION
AS
BEGIN
	SET NOCOUNT ON
	
	IF NOT EXISTS(SELECT * FROM VetecMarfilAdmin..tbRubrosCuentas WHERE intRubro = @intRubro AND strCuenta = @strCuenta AND intEmpresa = @intEmpresa)    
	BEGIN
		INSERT INTO VetecMarfilAdmin..tbRubrosCuentas(intRubro,strCuenta,intIndSumaResta,datFechaAlta,strUsuarioAlta,
		strMaquinaAlta,datFechaMod,strUsuarioMod,strMaquinaMod,intEmpresa)
        VALUES(@intRubro,@strCuenta,@intIndSumaResta,@datFechaAlta,@strUsuarioAlta,@strMaquinaAlta,@datFechaMod,@strUsuarioMod,
		@strMaquinaMod,@intEmpresa)
	END 
	ELSE 
	BEGIN
		UPDATE VetecMarfilAdmin..tbRubrosCuentas
		SET	intIndSumaResta = @intIndSumaResta,
			datFechaMod = @datFechaMod,
			strUsuarioMod = @strUsuarioMod,
			strMaquinaMod = @strMaquinaMod,
			intEmpresa = @intEmpresa
		WHERE  intRubro = @intRubro
		AND strCuenta = @strCuenta
		AND intEmpresa = @intEmpresa
   END

	SELECT @intRubro 

END
GO 

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbRubrosCuentas_Save Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbRubrosCuentas_Save Error on Creation'
END
GO



IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbRubrosCuentas_Sel')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbRubrosCuentas_Sel
	PRINT N'Drop Procedure : dbo.usp_tbRubrosCuentas_Sel - Succeeded !!!'
END
GO

------------------------------------------------------------------------------------
---																				 ---
---        Autor: Ingrid Soto		                                             ---
---  Descripcion: Consulta en tbRubros											 ---
---                                                                              ---
------------------------------------------------------------------------------------
---    Fecha     Autor  Comentario                                               ---
---  ----------  -----  -------------------------------------------------------  ---
---  28/08/2013  IASD    Create procedure                                         ---
------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[usp_tbRubrosCuentas_Sel]
(
	@intEmpresa int,
    @intRubro int
) 
AS
BEGIN
	SET NOCOUNT ON
                
	SELECT intRubro,ISNULL(A.strCuenta,'') as strCuenta,ISNULL(intIndSumaResta,0) as intIndSumaResta,
	ISNULL(datFechaAlta,'01/01/1900') as datFechaAlta,ISNULL(strUsuarioAlta,'') as strUsuarioAlta,
	ISNULL(strMaquinaAlta,'') as strMaquinaAlta,ISNULL(datFechaMod, '01/01/1900') as datFechaMod,
	ISNULL(strUsuarioMod,'') as strUsuarioMod,ISNULL(strMaquinaMod, '') as strMaquinaMod,
	ISNULL(A.intEmpresa,0) as intEmpresa,ISNULL(B.strNombre ,'') as strNombre,
	CASE WHEN ISNULL(intIndSumaResta ,0) = 1 THEN '+'  WHEN ISNULL(intIndSumaResta ,0) = -1 THEN '-' ELSE '' END as strIndSumaResta
	FROM   VetecMarfilAdmin..tbRubrosCuentas A
	INNER JOIN VetecMarfilAdmin..tbCuentas B ON (A.strCuenta =  B.strCuenta AND A.intEmpresa = B.intEmpresa)
    WHERE   A.intEmpresa = @intEmpresa
	AND A.intRubro = @intRubro

	SET NOCOUNT OFF
END
GO 

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbRubrosCuentas_Sel Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbRubrosCuentas_Sel Error on Creation'
END
GO


IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbRubrosTipos_Fill')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbRubrosTipos_Fill
	PRINT N'Drop Procedure : dbo.usp_tbRubrosTipos_Fill - Succeeded !!!'
END
GO

------------------------------------------------------------------------------------
---																				 ---
---        Autor: Ingrid Soto		                                             ---
---  Descripcion: Consulta en tbRubrosTipos										 ---
---                                                                              ---
------------------------------------------------------------------------------------
---    Fecha     Autor  Comentario                                               ---
---  ----------  -----  -------------------------------------------------------  ---
---  28/08/2013  IASD    Create procedure                                        ---
------------------------------------------------------------------------------------
CREATE 
PROCEDURE [dbo].[usp_tbRubrosTipos_Fill]
(
       @strTipoRubro	varchar(4)
) 
AS
BEGIN
	SET NOCOUNT ON
                
				SELECT
					strTipoRubro,
					strNombre
                FROM   VetecMarfilAdmin..tbRubrosTipos
                WHERE  strTipoRubro = @strTipoRubro

END
GO 

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbRubrosTipos_Fill Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbRubrosTipos_Fill Error on Creation'
END
GO

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbRubros_BalanceGeneral')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbRubros_BalanceGeneral
	PRINT N'Drop Procedure : dbo.usp_tbRubros_BalanceGeneral - Succeeded !!!'
END
GO

------------------------------------------------------------------------------------
---   Aplicacion: RMM.		                                                     ---
---        Autor: Ruben Mora Martinez                                            ---
---  Descripcion: Obtiene un registro de la tabla:  tbCotizacion                 ---
---                                                                              ---
------------------------------------------------------------------------------------
---    Fecha     Autor  Comentario                                               ---
---  ----------  -----  -------------------------------------------------------  ---
---  22/08/2011  RMM    Create procedure                                         ---
------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[usp_tbRubros_BalanceGeneral]        
(
	@intEmpresa		Int,
	@intEstadoFin	Int,  
	@intEjercicio	Int,
	@intMes			Int,
	@strCCIni		VarChar(60), 
	@strCCFin		VarChar(60)  
)       
AS    
BEGIN

	SET NOCOUNT ON

	DECLARE @intGrupoEmp Int, @strClasifEnc VarChar(60), @strClasifDP VarChar(60), @strClasifDS VarChar(60), 
	@intIndInterEmpresa Int,  @strUsuario VarChar(50), @intDivisor Int  
	SELECT @intGrupoEmp = 0,@strClasifEnc = '0',@strClasifDP = '0',@strClasifDS = '0',@intIndInterEmpresa= 2  
	SELECT @strUsuario = 'SIS', @intDivisor = 1
	
	IF @intEmpresa = 22 
	BEGIN
		SET LANGUAGE ENGLISH  
		DECLARE @datFecha VARCHAR(50)
		DECLARE @strMes VARCHAR(100)

		SET @datFecha =  CONVERT(VARCHAR,@intMes) + '/01/' + CONVERT(VARCHAR,@intEjercicio)		
		
		IF @intMes = 0
			SET @strMes = 'JAN - DEC'
		ELSE
			SELECT @strMes = DATENAME(MONTH,CONVERT(DATETIME, @datFecha))
	END

	DECLARE @dblFactorM DECIMAL(18,2)      
	SET @dblFactorM = 1    	
	
	SELECT	F.intRubro, 
			ISNULL((SELECT RE.strEtiqueta FROM tbRubroEtiqueta RE WHERE RE.intEmpresa = @intEmpresa AND RE.intRubro = RU.intRubro),RU.strNombre) AS strNombre, 
			F.strTipoRubro strTipoLinea,F.intSecuencia intNumLinea,       
			ISNULL((dbo.fn_GrupoFinMesNeto(@intEmpresa,@intEjercicio,@intMes,intEstadoFin,F.intRubro) * @dblFactorM) /@intDivisor, 0) Mes,       
			(CASE WHEN @intEmpresa = 22 THEN @strMes ELSE (SELECT strNombre FROM tbMeses WHERE intMes = @intMes) END) AS strNombreMes,        
			ISNULL((CONVERT(DECIMAL(18,2),dbo.F_GpoFinSdoFin  (@intGrupoEmp, @intEmpresa, @strClasifEnc, @intEjercicio, @intMes,  @strClasifDP, @strClasifDS, @intIndInterEmpresa, intEstadoFin, F.intRubro, @strUsuario) * @dblFactorM)) /@intDivisor, 0) Acumulado,       
			0 Acum,0 as esForm,intEstadoFin,E.strNombre As strEmpresa
	FROM tbEstadosFinRubros F   	
	INNER JOIN tbRubros RU ON RU.intRubro = F.intRubro
	INNER JOIN tbEmpresas E ON E.intEmpresa = @intEmpresa
	WHERE intEstadoFin = @intEstadoFin
	AND F.intEmpresa = @intEmpresa
	ORDER BY F.intSecuencia 

	SET NOCOUNT OFF
END
GO 

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbRubros_BalanceGeneral Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbRubros_BalanceGeneral Error on Creation'
END
GO

	












IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbRubros_Del')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbRubros_Del
	PRINT N'Drop Procedure : dbo.usp_tbRubros_Del - Succeeded !!!'
END
GO

------------------------------------------------------------------------------------
---																				 ---
---        Autor: Ingrid Soto		                                             ---
---  Descripcion: Elimina en tbRubros										 ---
---                                                                              ---
------------------------------------------------------------------------------------
---    Fecha     Autor  Comentario                                               ---
---  ----------  -----  -------------------------------------------------------  ---
---  28/08/2013  IASD    Create procedure                                         ---
------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[usp_tbRubros_Del]
(
       @intEmpresa int,
       @intRubro int
) 
AS
BEGIN
	SET NOCOUNT ON
                
	DELETE
    FROM   VetecMarfilAdmin..tbRubros
    WHERE  intRubro   = @intRubro
    
    SELECT @intRubro 

END
GO 

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbRubros_Del Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbRubros_Del Error on Creation'
END
GO



IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbRubros_Fill')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbRubros_Fill
	PRINT N'Drop Procedure : dbo.usp_tbRubros_Fill - Succeeded !!!'
END
GO

------------------------------------------------------------------------------------
---																				 ---
---        Autor: Ingrid Soto		                                             ---
---  Descripcion: Consulta en tbRubros											 ---
---                                                                              ---
------------------------------------------------------------------------------------
---    Fecha     Autor  Comentario                                               ---
---  ----------  -----  -------------------------------------------------------  ---
---  28/08/2013  IASD    Create procedure                                         ---
------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[usp_tbRubros_Fill]
(
       @intEmpresa int,
       @intRubro int
) 
WITH ENCRYPTION
AS
BEGIN
	SET NOCOUNT ON
                
	SELECT	intRubro,ISNULL(strNombre, '') AS strNombre,ISNULL(strNombreCorto, '') AS strNombreCorto,
	ISNULL(strTipoRubro, '') AS strTipoRubro,ISNULL(intIndCambiaSignoSalida,0 ) AS intIndCambiaSignoSalida,
	ISNULL(strSignoOperacionArit, '') AS strSignoOperacionArit,ISNULL(datFechaAlta,'01/01/1900') AS datFechaAlta,
	ISNULL(strUsuarioAlta, '') AS strUsuarioAlta,ISNULL(strMaquinaAlta, '') AS strMaquinaAlta,
	ISNULL(datFechaMod,'01/01/1900') AS datFechaMod,ISNULL(strUsuarioMod, '') AS strUsuarioMod,
	ISNULL(strMaquinaMod, '') AS strMaquinaMod,ISNULL(intEmpresa, 0) AS intEmpresa
    FROM   VetecMarfilAdmin..tbRubros
    WHERE  intRubro   = @intRubro

	SET NOCOUNT OFF
END
GO 

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbRubros_Fill Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbRubros_Fill Error on Creation'
END
GO
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbRubros_Help')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbRubros_Help
	PRINT N'Drop Procedure : dbo.usp_tbRubros_Help - Succeeded !!!'
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

CREATE PROCEDURE dbo.usp_tbRubros_Help
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
        SET @returnValue = 'SELECT intRubro as #, strNombre as Nombre 
		FROM VetecMarfilAdmin..tbrubros 
		ORDER BY intRubro'
	END

	IF (@intVersion = 1)
	BEGIN
		SET @returnValue = 'SELECT strTipoRubro as Tipo, strNombre as Nombre 
		FROM VetecMarfilAdmin..tbRubrosTipos  '
	END
	 
	SELECT @returnValue

	SET NOCOUNT OFF
END
GO 

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbRubros_Help Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbRubros_Help Error on Creation'
END
GO

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbRubros_List')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbRubros_List
	PRINT N'Drop Procedure : dbo.usp_tbRubros_List - Succeeded !!!'
END
GO

------------------------------------------------------------------------------------
---   Aplicacion: IASD.		                                                     ---
---        Autor: Ingrid Alexis Soto Dimas                                       ---
---  Descripcion: Obtiene un registro de la tabla:  tbCotizacion                 ---
---                                                                              ---
------------------------------------------------------------------------------------
---    Fecha     Autor  Comentario                                               ---
---  ----------  -----  -------------------------------------------------------  ---
---  22/08/2011  RMM    Create procedure                                         ---
------------------------------------------------------------------------------------

CREATE PROCEDURE dbo.usp_tbRubros_List
(
	@intEmpresa int
)
WITH ENCRYPTION
AS
BEGIN
	SET NOCOUNT ON	
	
	SELECT * 
	FROM VetecMarfilAdmin.dbo.tbRubros 
	WHERE intEmpresa = @intEmpresa
	
	SET NOCOUNT OFF
END
GO 

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbRubros_List Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbRubros_List Error on Creation'
END
GO



IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbRubros_Save')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbRubros_Save
	PRINT N'Drop Procedure : dbo.usp_tbRubros_Save - Succeeded !!!'
END
GO


------------------------------------------------------------------------------------
---																				 ---
---        Autor: Ingrid Soto		                                             ---
---  Descripcion: Inserta en tbRubros										 ---
---                                                                              ---
------------------------------------------------------------------------------------
---    Fecha     Autor  Comentario                                               ---
---  ----------  -----  -------------------------------------------------------  ---
---  28/08/2013  IASD    Create procedure                                         ---
------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[usp_tbRubros_Save]
(
    @intEmpresa int,
	@intRubro int,
	@strNombre varchar(150),
	@strNombreCorto varchar(30),
	@strTipoRubro varchar(1),
	@intIndCambiaSignoSalida int,
	@strSignoOperacionArit varchar(1),
	@datFechaAlta datetime,
	@strUsuarioAlta varchar(20),
	@strMaquinaAlta varchar(20),
	@datFechaMod datetime,
	@strUsuarioMod varchar(20),
	@strMaquinaMod varchar(20)

)
WITH ENCRYPTION
AS
BEGIN
	SET NOCOUNT ON
    
    IF NOT EXISTS(SELECT * FROM VetecMarfilAdmin..tbRubros WHERE  intRubro   = @intRubro)
    BEGIN
		INSERT INTO VetecMarfilAdmin..tbRubros(intRubro,strNombre,strNombreCorto,strTipoRubro,intIndCambiaSignoSalida,
		strSignoOperacionArit,strFormula,datFechaAlta,strUsuarioAlta,strMaquinaAlta,datFechaMod,strUsuarioMod,
		strMaquinaMod,intEmpresa)
        VALUES(@intRubro,@strNombre,@strNombreCorto,@strTipoRubro,@intIndCambiaSignoSalida,@strSignoOperacionArit,NULL,
		@datFechaAlta,@strUsuarioAlta,@strMaquinaAlta,@datFechaMod,@strUsuarioMod,@strMaquinaMod,@intEmpresa)
    END 
	ELSE 
	BEGIN
		UPDATE VetecMarfilAdmin..tbRubros
		SET strNombre = @strNombre,
			strNombreCorto = @strNombreCorto,
			strTipoRubro = @strTipoRubro,
			intIndCambiaSignoSalida = @intIndCambiaSignoSalida,
			strSignoOperacionArit = @strSignoOperacionArit,
			datFechaMod = @datFechaMod,
			strUsuarioMod = @strUsuarioMod,
			strMaquinaMod = @strMaquinaMod
		WHERE  intRubro   = @intRubro		
	END

	SELECT @intRubro 

END
GO 

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbRubros_Save Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbRubros_Save Error on Creation'
END
GO

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbRubros_Sel')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbRubros_Sel
	PRINT N'Drop Procedure : dbo.usp_tbRubros_Sel - Succeeded !!!'
END
GO

------------------------------------------------------------------------------------
---   Aplicacion: Abasto.		                                                 ---
---        Autor: Ramón Rios Hernandez                                           ---
---  Descripcion: Obtiene un registro de la tabla:  usp_tbRubros		         ---
---                                                                              ---
------------------------------------------------------------------------------------
---    Fecha     Autor  Comentario                                               ---
---  ----------  -----  -------------------------------------------------------  ---
---  09/07/2013  RRH    Create procedure                                         ---
------------------------------------------------------------------------------------
CREATE PROCEDURE usp_tbRubros_Sel
(
	@intEmpresa INT,
	@strCuenta  VARCHAR(50)
)
WITH ENCRYPTION
AS
BEGIN
	SET NOCOUNT ON
		
	SELECT C.strClasifEnc,C.strCuenta,C.strNombre,C.strNombreCorto,C.intNivel,C.intCtaRegistro,C.intIndAuxiliar,
	CASE ISNULL(C.intIndAuxiliar,0)when 1 then cast(1 as bit)else cast(0 as bit)end as Auxiliar,intAcceso,
	C.intTipoGrupoContable,TGC.strNombre AS Tipo_GrupoContable,C.intGrupoContable,
	CASE WHEN C.intGrupoContable = 1 THEN 'ACREEDOR' ELSE 'DEUDOR' END AS GrupoContable,0 AS intTipoGasto,0 AS intIndBloqueo,
	0 AS intEjercicioBloq,0 AS intMesBloq,0 AS intIndInterEmpresa,0 AS intInterEmpresa,	C.strAuditAlta,C.strAuditMod
	FROM VetecMarfilAdmin..tbRubros C
	LEFT JOIN tbTiposGruposContables TGC ON TGC.intTipoGrupoContable = C.intTipoGrupoContable
	WHERE C.intEmpresa = CASE ISNULL(@intEmpresa,0) WHEN 0 THEN C.intEmpresa ELSE ISNULL(@intEmpresa,0) END
	AND  C.strCuenta = CASE ISNULL(@strCuenta,'0') WHEN '0' THEN C.strCuenta ELSE ISNULL(@strCuenta,'0') END 

	SET NOCOUNT OFF
END 	
GO 

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbRubros_Sel Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbRubros_Sel Error on Creation'
END
GO 
 

/****** Object:  StoredProcedure [dbo.usp_tbFacXP_Fill]    Script Date: 12/8/2009 10:45:19 AM ******/
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbTempConciliacionEjercicio_Sel')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbTempConciliacionEjercicio_Sel
	PRINT N'Drop Procedure : dbo.usp_tbTempConciliacionEjercicio_Sel - Succeeded !!!'
END
GO

------------------------------------------------------------------------------------
---   Aplicacion: Marfil.		                                                 ---
---        Autor: Ingrid Alexis Soto Dimas                                       ---
---  Descripcion: Obtiene intEjercicio:  tbTempConciliacion	                     ---
---                                                                              ---
------------------------------------------------------------------------------------
---    Fecha     Autor  Comentario                                               ---
---  ----------  -----  -------------------------------------------------------  ---
---  19/08/2013  IASD   Create procedure                                         ---
------------------------------------------------------------------------------------

CREATE PROCEDURE dbo.usp_tbTempConciliacionEjercicio_Sel
(      
	@intEmpresa				int
)
WITH ENCRYPTION 
AS
BEGIN
		
	SET NOCOUNT ON

	SELECT DISTINCT intEjercicio 
		FROM VetecMarfilAdmin.dbo.tbTempConciliacion 
		WHERE intEmpresa =@intEmpresa
		ORDER BY intEjercicio DESC
	
	SET NOCOUNT OFF
	
END
GO

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbTempConciliacionEjercicio_Sel Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbTempConciliacionEjercicio_Sel Error on Creation'
END
GO

/****** Object:  StoredProcedure [dbo.usp_tbTempConciliacion_Del]    Script Date: 12/8/2009 10:45:19 AM ******/
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbTempConciliacion_Del')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbTempConciliacion_Del
	PRINT N'Drop Procedure : dbo.usp_tbTempConciliacion_Del - Succeeded !!!'
END
GO

------------------------------------------------------------------------------------
---   Aplicacion: Marfil.		                                                 ---
---        Autor: Ingrid Alexis Soto                                            ---
---  Descripcion: Elimina registro en usp_tbTempConciliacion_Del                ---
---                                                                              ---
------------------------------------------------------------------------------------
---    Fecha     Autor  Comentario                                               ---
---  ----------  -----  -------------------------------------------------------  ---
---  27/08/2013  IASD    Create procedure                                         ---
------------------------------------------------------------------------------------

CREATE PROCEDURE dbo.usp_tbTempConciliacion_Del
(      
	@intEmpresa			int,
	@intEjercicio		int,
	@intMes				int,
	@intCuentaBancaria	int
)
WITH ENCRYPTION 
AS
BEGIN
		
	SET NOCOUNT ON

	DELETE FROM VetecMarfilAdmin..tbTempConciliacion 
		WHERE intEmpresa = @intEmpresa
		AND intEjercicio = @intEjercicio
		AND intMes = @intMes 
		AND intCuentaBancaria = @intCuentaBancaria

END
GO

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbTempConciliacion_Del Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbTempConciliacion_Del Error on Creation'
END
GO

/****** Object:  StoredProcedure [dbo.usp_tbTempConciliacion_Val]    Script Date: 12/8/2009 10:45:19 AM ******/
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbTempConciliacion_Val')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbTempConciliacion_Val
	PRINT N'Drop Procedure : dbo.usp_tbTempConciliacion_Val - Succeeded !!!'
END
GO

------------------------------------------------------------------------------------
---   Aplicacion: Marfil.		                                                 ---
---        Autor: Ingrid Alexis Soto                                            ---
---  Descripcion: Valida si existe en tbTempConciliacion	                     ---
---                                                                              ---
------------------------------------------------------------------------------------
---    Fecha     Autor  Comentario                                               ---
---  ----------  -----  -------------------------------------------------------  ---
---  27/08/2013  IASD    Create procedure                                         ---
------------------------------------------------------------------------------------

CREATE PROCEDURE dbo.usp_tbTempConciliacion_Val
(      
	@intEmpresa			int,
	@intEjercicio		int,
	@intMes				int,
	@intCuentaBancaria	int
)
WITH ENCRYPTION 
AS
BEGIN
		
	SET NOCOUNT ON

	IF NOT EXISTS
				(  SELECT 1 
						FROM VetecMarfilAdmin..tbTempConciliacion 
						WHERE intEmpresa = @intEmpresa
						AND intEjercicio = @intEjercicio
						AND intMes = @intMes
						AND intCuentaBancaria = @intCuentaBancaria
						AND bConciliado = 1
				) 
		SELECT 0 
	ELSE 
		SELECT 1
END
GO

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbTempConciliacion_Val Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbTempConciliacion_Val Error on Creation'
END
GO







/****** Object:  StoredProcedure [dbo.usp_tbFacXP_Poliza]    Script Date: 12/8/2009 10:45:19 AM ******/
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbTiposPoliza_Det')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbTiposPoliza_Det
	PRINT N'Drop Procedure : dbo.usp_tbTiposPoliza_Det - Succeeded !!!'
END
GO

------------------------------------------------------------------------------------
---   Aplicacion: Marfil.		                                                 ---
---        Autor: Ingrid Soto Dimas							                      ---
---  Descripcion: Selecciona registros de la tabla:tbTiposPoliza                 ---
---                                                                              ---
------------------------------------------------------------------------------------
---    Fecha     Autor  Comentario                                               ---
---  ----------  -----  -------------------------------------------------------  ---
---  13/08/2013  IASD    Create procedure                                         ---
------------------------------------------------------------------------------------   


create  PROCEDURE [dbo].[usp_tbTiposPoliza_Det]
(
	@intEmpresa		int,
	@intEjercicio	int,
	@strTipoPoliza	varchar(3)
)
AS
BEGIN


	SELECT  
			ISNULL(intEmpresa,0)intEmpresa,
			ISNULL(strClasifEnc,'')strClasifEnc,
			ISNULL(strTipoPoliza,'')strTipoPoliza,
			ISNULL(strNombre,'')strNombre,
			ISNULL(strNombreCorto,'')strNombreCorto,
			ISNULL(intCapturable,0)intCapturable,
			ISNULL(intEjercicio,0)intEjercicio,
			ISNULL(intM1,0)intM1,
			ISNULL(intM2,0)intM2,
			ISNULL(intM3,0)intM3,
			ISNULL(intM4,0)intM4,
			ISNULL(intM5,0)intM5,
			ISNULL(intM6,0)intM6,
			ISNULL(intM7,0)intM7,
			ISNULL(intM8,0)intM8,
			ISNULL(intM9,0)intM9,
			ISNULL(intM10,0)intM10,
			ISNULL(intM11,0)intM11,
			ISNULL(intM12,0)intM12,
			ISNULL(strAuditAlta,'')strAuditAlta,
			ISNULL(strAuditMod,'')strAuditMod
	FROM VetecMarfilAdmin..tbTiposPoliza
	WHERE intEmpresa = @intEmpresa
	AND ((@intEjercicio = 0) OR (intEjercicio= @intEjercicio))
	AND ((@strTipoPoliza = '0') OR (strTipoPoliza =@strTipoPoliza))

	SET NOCOUNT OFF
	
END
GO

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbTiposPoliza_Det Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbTiposPoliza_Det Error on Creation'
END
GO


/****** Object:  StoredProcedure [dbo.usp_tbFacXP_Poliza]    Script Date: 12/8/2009 10:45:19 AM ******/
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbTiposPoliza_Fill')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbTiposPoliza_Fill
	PRINT N'Drop Procedure : dbo.usp_tbTiposPoliza_Fill - Succeeded !!!'
END
GO

------------------------------------------------------------------------------------
---   Aplicacion: Marfil.		                                                 ---
---        Autor: Ingrid Soto Dimas							                      ---
---  Descripcion: Selecciona registros de la tabla:tbTiposPoliza                 ---
---                                                                              ---
------------------------------------------------------------------------------------
---    Fecha     Autor  Comentario                                               ---
---  ----------  -----  -------------------------------------------------------  ---
---  13/08/2013  IASD    Create procedure                                         ---
------------------------------------------------------------------------------------    

CREATE  PROCEDURE [dbo].[usp_tbTiposPoliza_Fill]
(
	@intEmpresa		int,
	@intEjercicio	int
)
AS
BEGIN


	SELECT  DISTINCT ISNULL(strTipoPoliza,'') + ' - ' + ISNULL(strNombre,'') AS strNombreCbo,
			ISNULL(intEmpresa,0)intEmpresa,
			ISNULL(strClasifEnc,'')strClasifEnc,
			ISNULL(strTipoPoliza,'')strTipoPoliza,
			ISNULL(strNombre,'')strNombre,
			ISNULL(strNombreCorto,'')strNombreCorto,
			ISNULL(intCapturable,0)intCapturable,
			ISNULL(intEjercicio,0)intEjercicio,
			ISNULL(intM1,0)intM1,
			ISNULL(intM2,0)intM2,
			ISNULL(intM3,0)intM3,
			ISNULL(intM4,0)intM4,
			ISNULL(intM5,0)intM5,
			ISNULL(intM6,0)intM6,
			ISNULL(intM7,0)intM7,
			ISNULL(intM8,0)intM8,
			ISNULL(intM9,0)intM9,
			ISNULL(intM10,0)intM10,
			ISNULL(intM11,0)intM11,
			ISNULL(intM12,0)intM12,
			ISNULL(strAuditAlta,'')strAuditAlta,
			ISNULL(strAuditMod,'')strAuditMod
	FROM VetecMarfilAdmin..tbTiposPoliza
	WHERE intEmpresa = @intEmpresa
	AND ((intEjercicio = 0) OR (intEjercicio= @intEjercicio))

	SET NOCOUNT OFF
	
END
GO

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbTiposPoliza_Fill Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbTiposPoliza_Fill Error on Creation'
END
GO






/****** Object:  StoredProcedure [dbo.usp_tbFacXP_Poliza]    Script Date: 12/8/2009 10:45:19 AM ******/
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbTiposPoliza_Save')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbTiposPoliza_Save
	PRINT N'Drop Procedure : dbo.usp_tbTiposPoliza_Save - Succeeded !!!'
END
GO

------------------------------------------------------------------------------------
---   Aplicacion: Marfil.		                                                 ---
---        Autor: Ingrid Soto Dimas							                      ---
---  Descripcion: Guarda en la tabla:  usp_tbTiposPoliza	                     ---
---                                                                              ---
------------------------------------------------------------------------------------
---    Fecha     Autor  Comentario                                               ---
---  ----------  -----  -------------------------------------------------------  ---
---  15/18/2013  IASD    Create procedure                                         ---
------------------------------------------------------------------------------------    
CREATE  PROCEDURE [dbo].[usp_tbTiposPoliza_Save]      
(      
 @intEmpresa  int,      
 @intEjercicio int,      
 @strTipoPoliza varchar(10),      
 @intMes int,      
 @valPol int      
)      
AS      
BEGIN      
      
DECLARE @existe int      
SET @existe = 0      
      
DECLARE @str AS VARCHAR(2000)      
DECLARE @mes AS VARCHAR(50)      
SET @mes = 'intM' + CAST( @intMes AS varchar (100))      
      
    
   IF  EXISTS      
    (SELECT *      
    FROM VetecMarfilAdmin..tbTiposPoliza      
    WHERE   intEmpresa = @intEmpresa       
  AND intEjercicio = @intEjercicio       
  AND strTipoPoliza = @strTipoPoliza      
    )      
   BEGIN      
     SET @str = '      
     UPDATE VetecMarfilAdmin..tbTiposPoliza      
     SET ' + @mes +  ' = ' + CAST( @valPol AS varchar(100)) + '      
     WHERE intEmpresa = ' + CAST(@intEmpresa AS varchar (100)) + '      
     AND intEjercicio = ' + CAST(@intEjercicio AS varchar (100))+ '      
     AND strTipoPoliza = ''' + @strTipoPoliza + ''''      
           
     EXEC ( @str   )    
     --select @str      
   END      
      
	SET NOCOUNT OFF
	
END
GO

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbTiposPoliza_Save Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbTiposPoliza_Save Error on Creation'
END

