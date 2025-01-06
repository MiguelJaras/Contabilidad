IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbCuentas_Del')
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

