

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbTipoMovto_Inc')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbTipoMovto_Inc
	PRINT N'Drop Procedure : dbo.usp_tbTipoMovto_Inc - Succeeded !!!'
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
PROCEDURE [dbo].[usp_tbTipoMovto_Inc]
(
	@intEmpresa		INT

)
AS
BEGIN
	SET NOCOUNT ON

	DECLARE @mov INT
	SELECT  @mov = MAX(intMovto) +1
	FROM VetecMarfilAdmin..tbTipoMovto
	WHERE intEmpresa=@intEmpresa  

	select @mov as mov
		
	SET NOCOUNT OFF
END
GO 

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbTipoMovto_Inc Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbTipoMovto_Inc Error on Creation'
END
GO
