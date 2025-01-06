

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbTipoMovto_Del')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbTipoMovto_Del
	PRINT N'Drop Procedure : dbo.usp_tbTipoMovto_Del - Succeeded !!!'
END
GO

------------------------------------------------------------------------------------
---																				 ---
---        Autor: Ingrid Soto		                                             ---
---  Descripcion: Consulta en tbColonia											 ---
---                                                                              ---
------------------------------------------------------------------------------------
---    Fecha     Autor  Comentario                                               ---
---  ----------  -----  -------------------------------------------------------  ---
---  14/04/2015  IASD    Create procedure                                         ---
------------------------------------------------------------------------------------
CREATE 
PROCEDURE [dbo].[usp_tbTipoMovto_Del]
(
	@intEmpresa	INT,
	@intMovto	INT
)
AS
BEGIN
	SET NOCOUNT ON
                
				DELETE
                FROM  VetecMarfilAdmin..tbTipoMovto
				WHERE intEmpresa = @intEmpresa
				AND intMovto = @intMovto 
END
GO 

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbTipoMovto_Del Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbTipoMovto_Del Error on Creation'
END
GO
