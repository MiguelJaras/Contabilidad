

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
