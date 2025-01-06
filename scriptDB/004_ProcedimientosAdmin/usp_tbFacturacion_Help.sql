
USE VetecMarfil
GO
SET ANSI_NULLS, QUOTED_IDENTIFIER ON
GO

------------------------------------------------------------------------------------
---   Aplicacion: Contabilidad.		                                             ---
---        Autor: Ramón Rios Hernandez                                           ---
---  Descripcion:														         ---
---                                                                              ---
------------------------------------------------------------------------------------
---    Fecha     Autor  Comentario                                               ---
---  ----------  -----  -------------------------------------------------------  ---
---  23/03/2015  RRH    Create procedure                                         ---
------------------------------------------------------------------------------------

alter PROCEDURE dbo.usp_tbFacturacion_Help
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

	set language spanish
		
	DECLARE @strParameter1 VARCHAR(200)
	DECLARE @strParameter2 VARCHAR(200)
	DECLARE @strParameter3 VARCHAR(200)
	DECLARE @strParameter4 VARCHAR(200)
	 
	DECLARE @returnValue NVARCHAR(MAX)
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
        SET @returnValue = '   
BEGIN
   DECLARE @datFechaInicial VARCHAR(50)
DECLARE @datFechaFinal VARCHAR(50)

SET @datFechaInicial = '''+ISNULL(@strParameter1,'01/03/2015')+'''
SET @datFechaFinal = '''+ISNULL(@strParameter2,'13/03/2015')+'''

--Clientes
SELECT  
'''' AS [No.],
p.intprospecto AS [Código Cliente*],
ie.strnombrecliente AS [Nombre Cliente*],
CONVERT(VARCHAR,GETDATE(),103) AS [Fecha de Alta*],
1 AS [Tipo Cliente*],
P.strRFC AS RFC,
P.strCURP AS CURP,
'''' AS [Denominación Comercial],
'''' AS [Representante Legal],
''Peso Mexicano'' AS [Moneda*],
0 AS [Saldo inicial],
1 AS [Tipo cambio saldo inicial]
FROM tbinterfase_escrituracion ie
INNER JOIN tbProspecto P ON ie.intProspecto = P.intProspecto
INNER JOIN tbTipoCredito TI ON ti.intTipoCredito = P.intTipoCredito
INNER JOIn tbColonia C ON C.intColonia = P.intColonia
INNER JOIN tbSector S ON S.intSector = P.intSector AND S.intColonia = C.intColonia
INNER JOIN tbManzana M ON M.intSector = S.intSector
INNER JOIN tbLote L ON L.intManzana = M.intManzana AND P.intLote = L.intLote
where ie.datFechaEscrituracion >= @datFechaInicial and ie.datFechaEscrituracion <= @datFechaFinal

SELECT 20 AS [No.],
80 AS [Código Cliente*],
200 AS [Nombre Cliente*],
100 AS [Fecha de Alta*],
90 AS [Tipo Cliente*],
100 AS RFC,
120 AS CURP,
50 AS [Denominación Comercial],
50 AS [Representante Legal],
100 AS [Moneda*],
70 AS [Saldo inicial],
70 AS [Tipo cambio saldo inicial]

--Direcion Clientes
select 
'''' AS [No.],
p.intprospecto AS [Código Cliente*],
0 AS [Tipo Dirección*],
0 AS [Tipo Catalogo*],
p.strDireccion AS [Calle*],
right(p.strDireccion,4) AS [Número Exterior*],
'''' AS [Número Interior],
p.strColonia AS Colonia,
P.intCP AS [Código Postal],
P.strTelefonoCasa AS [Teléfono # 1],
P.strTelefonoOficina AS [Teléfono # 2],
P.strTelefonoCelular AS [Teléfono # 3],
'''' AS [Teléfono # 4],
P.strEmail AS [Dirección de Correo electrónico],
'' '' AS WEB,
cu.strnombre AS Municipio,
'''' AS Ciudad,
ed.strnombre AS Estado,
''México'' AS País
FROM tbinterfase_escrituracion ie
INNER JOIN tbProspecto P ON ie.intProspecto = P.intProspecto
INNER JOIN tbTipoCredito TI ON ti.intTipoCredito = P.intTipoCredito
INNER JOIn tbColonia C ON C.intColonia = P.intColonia
INNER JOIN tbSector S ON S.intSector = P.intSector AND S.intColonia = C.intColonia
INNER JOIN tbManzana M ON M.intSector = S.intSector
INNER JOIN tbLote L ON L.intManzana = M.intManzana AND P.intLote = L.intLote
LEFT JOIN vetecmarfiladmin..tbCiudades cu on cu.intCiudad = P.intMunicipio
LEFT JOIN vetecmarfiladmin..tbEstados ed ON ed.intEstado = p.intEstado
--cross apply dbo.fn_ProspectoEsc(ie.intprospecto) pe
where ie.datFechaEscrituracion >= @datFechaInicial and ie.datFechaEscrituracion <= @datFechaFinal


SELECT 20 AS [No.], 
200 AS [Código Cliente*],
100 AS [Tipo Dirección*],
100 AS [Tipo Catalogo*],
200 AS [Calle*],
100 AS [Número Exterior*],
85 AS [Número Interior],
200 AS Colonia,
100 AS [Código Postal],
100 AS [Teléfono # 1],
100 AS [Teléfono # 2],
100 AS [Teléfono # 3],
100 AS [Teléfono # 4],
250 AS [Dirección de Correo electrónico],
80 AS WEB,
100 AS Municipio,
100 AS Ciudad,
100 AS Estado,
100 AS País



--Direcion Lote
select 
'''' AS [No.],
p.intprospecto AS [Código Cliente*],
c.strNombreCorto AS Colonia,
s.strNombre AS Sector,
ca.strNombre AS [Calle*],
l.intNumeroOficial AS [Número Exterior*]
FROM tbinterfase_escrituracion ie
INNER JOIN tbProspecto P ON ie.intProspecto = P.intProspecto
--INNER JOIN tbTipoCredito TI ON ti.intTipoCredito = P.intTipoCredito
INNER JOIn tbColonia C ON C.intColonia = P.intColonia
INNER JOIN tbSector S ON S.intSector = P.intSector AND S.intColonia = C.intColonia
INNER JOIN tbManzana M ON M.intSector = S.intSector
INNER JOIN tbLote L ON L.intManzana = M.intManzana AND P.intLote = L.intLote
LEFT JOIN tbColoniaCalle CA ON CA.intColonia = P.intColonia AND CA.intColoniaCalle = L.intColoniaCalle
--LEFT JOIN vetecmarfiladmin..tbCiudades cu on cu.intCiudad = P.intMunicipio
--LEFT JOIN vetecmarfiladmin..tbEstados ed ON ed.intEstado = p.intEstado
--cross apply dbo.fn_ProspectoEsc(ie.intprospecto) pe
where ie.datFechaEscrituracion >= @datFechaInicial and ie.datFechaEscrituracion <= @datFechaFinal

SELECT 20 AS [No.],  
100 AS [Código Cliente*],
180 AS Colonia,
150 AS Sector,
200 AS [Calle*],
100 AS [Número Exterior*]
END

'  						 
	END    
 
PRINT @returnValue
 
	EXEC sp_executesql @returnValue

	SET NOCOUNT OFF
END
GO
