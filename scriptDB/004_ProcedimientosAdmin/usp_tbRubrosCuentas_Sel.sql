

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
