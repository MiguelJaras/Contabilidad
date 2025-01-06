

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbTipoMovto_Sel')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbTipoMovto_Sel
	PRINT N'Drop Procedure : dbo.usp_tbTipoMovto_Sel - Succeeded !!!'
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
PROCEDURE [dbo].[usp_tbTipoMovto_Sel]
(
	@intEmpresa	INT,
	@intMovto	INT
)
AS
BEGIN
	SET NOCOUNT ON
                
				SELECT
					intEmpresa
					,intMovto
					,ISNULL(strNombre,'') AS strNombre
					,ISNULL(strAuditAlta,'') AS strAuditAlta
					,ISNULL(strAuditMod,'') AS strAuditMod
					,ISNULL(strNaturaleza,'') AS strNaturaleza
					,ISNULL(bFactura, 0) AS bFactura
                FROM  VetecMarfilAdmin..tbTipoMovto
				WHERE intEmpresa = @intEmpresa
				AND intMovto = CASE WHEN @intMovto = 0 THEN intMovto ELSE @intMovto END
				ORDER BY intMovto ASC
END
GO 

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbTipoMovto_Sel Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbTipoMovto_Sel Error on Creation'
END
GO
