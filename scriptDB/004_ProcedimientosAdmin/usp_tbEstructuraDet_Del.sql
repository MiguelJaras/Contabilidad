
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbEstructuraDet_Del')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbEstructuraDet_Del
	PRINT N'Drop Procedure : dbo.usp_tbEstructuraDet_Del - Succeeded !!!'
END
GO
------------------------------------------------------------------------------------
---																				 ---
---        Autor: Ramon Rios Hernandez                                           ---
---  Descripcion: DELETE en tbEstructuraDet										 ---
---                                                                              ---
------------------------------------------------------------------------------------
---    Fecha     Autor  Comentario                                               ---
---  ----------  -----  -------------------------------------------------------  ---
---  02/07/2013  RRH    Create procedure                                         ---
------------------------------------------------------------------------------------
CREATE
PROCEDURE [DBO].[usp_tbEstructuraDet_Del]
(
   @intEmpresa INT,
   @intPartida INT,
   @intClave   INT
) 
AS
BEGIN
	SET NOCOUNT ON
                
				DELETE
                FROM   tbEstructuraDet
                WHERE  intEmpresa = @intEmpresa
				AND	   intPartida = @intPartida
                AND    intClave   = CASE ISNULL(@intClave,0) WHEN 0 THEN intClave ELSE ISNULL(@intClave,0) END

                SELECT @intClave 

	SET NOCOUNT OFF  
END
GO 

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbEstructuraDet_Del Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbEstructuraDet_Del Error on Creation'
END
GO