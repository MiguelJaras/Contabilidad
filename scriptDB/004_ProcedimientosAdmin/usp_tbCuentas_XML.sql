
USE VetecMarfilAdmin

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbCuentas_XML')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbCuentas_XML
	PRINT N'Drop Procedure : dbo.usp_tbCuentas_XML - Succeeded !!!'
END
GO

-- =============================================  
 
-- =============================================  

CREATE PROCEDURE [dbo].[usp_tbCuentas_XML]
(
	@intEmpresa	int
)
AS
BEGIN
	SET NOCOUNT ON

	SELECT strCodigoAgrupador AS CodAgrup,strCuenta AS NumCta,strNombre AS [Desc],intNivel as Nivel,
	CASE WHEN intGrupoContable = 1 THEN 'A' ELSE 'D' END AS Natur
	FROM VetecMarfilAdmin..tbCuentas
	WHERE intEmpresa = @intEmpresa 	
	ORDER BY strCuenta, intNivel
	
END
GO 

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbCuentas_XML Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbCuentas_XML Error on Creation'
END
GO