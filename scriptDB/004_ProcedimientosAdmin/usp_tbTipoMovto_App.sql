

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbTipoMovto_App')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbTipoMovto_App
	PRINT N'Drop Procedure : dbo.usp_tbTipoMovto_App - Succeeded !!!'
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
PROCEDURE [dbo].[usp_tbTipoMovto_App]
(
	@intEmpresa		INT
	,@intMovto		INT
	,@strNombre		VARCHAR(50)
	,@strAuditAlta	VARCHAR(50)
	,@strAuditMod	VARCHAR(50)
	,@strNaturaleza	VARCHAR(50)
	,@bFactura		BIT

)
AS
BEGIN
	SET NOCOUNT ON

	IF EXISTS(SELECT TOP 1 * FROM VetecMarfilAdmin..tbTipoMovto WHERE intEmpresa= @intEmpresa AND intMovto= @intMovto)                
	BEGIN
		   --Actualizamos  
		   UPDATE VetecMarfilAdmin..tbTipoMovto
			SET 
				strNombre = @strNombre
				,strAuditMod = @strAuditMod
				,strNaturaleza = @strNaturaleza
				,bFactura = @bFactura
		   WHERE intEmpresa=@intEmpresa  
		   AND intMovto = @intMovto

		END
	ELSE
		BEGIN	

			DECLARE @mov INT
			SELECT  @mov = MAX(intMovto) +1
			FROM VetecMarfilAdmin..tbTipoMovto
			WHERE intEmpresa=@intEmpresa  
 
			INSERT VetecMarfilAdmin..tbTipoMovto(intEmpresa,intMovto,strNombre,strAuditAlta,strAuditMod,strNaturaleza,bFactura)  
			VALUES(@intEmpresa,@intMovto,@strNombre,@strAuditAlta,NULL,@strNaturaleza,@bFactura)    
	END  
		

END
GO 

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbTipoMovto_App Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbTipoMovto_App Error on Creation'
END
GO
