

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbRubros_Fill')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbRubros_Fill
	PRINT N'Drop Procedure : dbo.usp_tbRubros_Fill - Succeeded !!!'
END
GO

------------------------------------------------------------------------------------
---																				 ---
---        Autor: Ingrid Soto		                                             ---
---  Descripcion: Consulta en tbRubros											 ---
---                                                                              ---
------------------------------------------------------------------------------------
---    Fecha     Autor  Comentario                                               ---
---  ----------  -----  -------------------------------------------------------  ---
---  28/08/2013  IASD    Create procedure                                         ---
------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[usp_tbRubros_Fill]
(
       @intEmpresa int,
       @intRubro int
) 
WITH ENCRYPTION
AS
BEGIN
	SET NOCOUNT ON
                
	SELECT	intRubro,ISNULL(strNombre, '') AS strNombre,ISNULL(strNombreCorto, '') AS strNombreCorto,
	ISNULL(strTipoRubro, '') AS strTipoRubro,ISNULL(intIndCambiaSignoSalida,0 ) AS intIndCambiaSignoSalida,
	ISNULL(strSignoOperacionArit, '') AS strSignoOperacionArit,ISNULL(datFechaAlta,'01/01/1900') AS datFechaAlta,
	ISNULL(strUsuarioAlta, '') AS strUsuarioAlta,ISNULL(strMaquinaAlta, '') AS strMaquinaAlta,
	ISNULL(datFechaMod,'01/01/1900') AS datFechaMod,ISNULL(strUsuarioMod, '') AS strUsuarioMod,
	ISNULL(strMaquinaMod, '') AS strMaquinaMod,ISNULL(intEmpresa, 0) AS intEmpresa
    FROM   VetecMarfilAdmin..tbRubros
    WHERE  intRubro   = @intRubro

	SET NOCOUNT OFF
END
GO 

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbRubros_Fill Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbRubros_Fill Error on Creation'
END
GO
