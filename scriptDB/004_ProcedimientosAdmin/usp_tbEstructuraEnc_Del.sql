
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

