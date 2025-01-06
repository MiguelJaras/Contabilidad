

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbRubrosTipos_Fill')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbRubrosTipos_Fill
	PRINT N'Drop Procedure : dbo.usp_tbRubrosTipos_Fill - Succeeded !!!'
END
GO

------------------------------------------------------------------------------------
---																				 ---
---        Autor: Ingrid Soto		                                             ---
---  Descripcion: Consulta en tbRubrosTipos										 ---
---                                                                              ---
------------------------------------------------------------------------------------
---    Fecha     Autor  Comentario                                               ---
---  ----------  -----  -------------------------------------------------------  ---
---  28/08/2013  IASD    Create procedure                                        ---
------------------------------------------------------------------------------------
CREATE 
PROCEDURE [dbo].[usp_tbRubrosTipos_Fill]
(
       @strTipoRubro	varchar(4)
) 
AS
BEGIN
	SET NOCOUNT ON
                
				SELECT
					strTipoRubro,
					strNombre
                FROM   VetecMarfilAdmin..tbRubrosTipos
                WHERE  strTipoRubro = @strTipoRubro

END
GO 

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbRubrosTipos_Fill Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbRubrosTipos_Fill Error on Creation'
END
GO
