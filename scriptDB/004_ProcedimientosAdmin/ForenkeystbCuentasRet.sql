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