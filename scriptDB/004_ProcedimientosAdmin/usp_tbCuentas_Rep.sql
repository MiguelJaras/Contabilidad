--SELECT * FROM VetecMarfilAdmin..tbCuentas

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbCuentas_Rep')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbCuentas_Rep
	PRINT N'Drop Procedure : dbo.usp_tbCuentas_Rep - Succeeded !!!'
END
GO

-- =============================================  
 
-- =============================================  

CREATE PROCEDURE [dbo].[usp_tbCuentas_Rep]
(
	@intEmpresa	int,
	@intNivel	int
)
AS
BEGIN
	SET NOCOUNT ON

	DECLARE @strNombre VARCHAR(250)

	SELECT @strNombre = strNombre FROM tbEmpresas WHERE intEmpresa = @intEmpresa
	
	SELECT  @strNombre AS Empresa,
		CASE WHEN intNivel = 1 THEN strCuenta 
			 WHEN intNivel = 2 THEN SUBSTRING(strCuenta,1, 4) 
			 WHEN intNivel = 3 THEN SUBSTRING(strCuenta,1, 4)
		ELSE strCuenta
		END AS Cuenta, 
		CASE WHEN intNivel = 1 THEN '0000' 
			 WHEN intNivel = 2 THEN SUBSTRING(strCuenta,5, 4) 
			 WHEN intNivel = 3 THEN SUBSTRING(strCuenta,5, 4)
		ELSE strCuenta
		END AS SubCuenta,
		CASE WHEN intNivel = 1 THEN '0000' 
			 WHEN intNivel = 2 THEN '0000'
			 WHEN intNivel = 3 THEN SUBSTRING(strCuenta,9, 4)
		ELSE strCuenta
		END AS SubSubCuenta,
		CASE WHEN intIndAuxiliar = 1 THEN 'SI' ELSE 'NO' END AS Aux,
		strNombre AS Descripcion,
		CASE WHEN intGrupoContable =1 THEN 'A' WHEN intGrupoContable =0 THEN 'DE'  ELSE '-' END AS TC,
		CASE WHEN intTipoGrupoContable =1 THEN 'B' WHEN intTipoGrupoContable =0 THEN 'R' ELSE '-' END AS TR,
		intNivel
	FROM VetecMarfilAdmin..tbCuentas
	WHERE intEmpresa = @intEmpresa 	
	AND intNivel <= @intNivel
	
END
GO 

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbCuentas_Rep Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbCuentas_Rep Error on Creation'
END
GO