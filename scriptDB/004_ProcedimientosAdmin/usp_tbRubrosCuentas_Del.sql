

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

