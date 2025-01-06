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

