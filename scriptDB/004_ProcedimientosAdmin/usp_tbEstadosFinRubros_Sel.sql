

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbEstadosFinRubros_Sel')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbEstadosFinRubros_Sel
	PRINT N'Drop Procedure : dbo.usp_tbEstadosFinRubros_Sel - Succeeded !!!'
END
GO

------------------------------------------------------------------------------------
---																				 ---
---        Autor: Ingrid Soto		                                             ---
---  Descripcion: Consulta en tbEstadosFinRubros								 ---
---                                                                              ---
------------------------------------------------------------------------------------
---    Fecha     Autor  Comentario                                               ---
---  ----------  -----  -------------------------------------------------------  ---
---  02/09/2013  IASD    Create procedure                                         ---
------------------------------------------------------------------------------------
CREATE 
PROCEDURE [dbo].[usp_tbEstadosFinRubros_Sel]
(
    @intEstadoFin int,
	@intEmpresa int
	
) 
AS
BEGIN
	SET NOCOUNT ON
                
				SELECT
					intEstadoFin
					,ISNULL(intRubro,0) as intRubro
					,ISNULL(intSecuencia,0) as  intSecuencia
					,ISNULL(strTipoRubro,'') as  strTipoRubro
					,ISNULL(strNombre,'') as  strNombre
					,ISNULL(strNombreCorto,'') as strNombreCorto
					,ISNULL(intPtaje,0) as intPtaje
					,ISNULL(datFechaAlta,'01/01/1900') as datFechaAlta
					,ISNULL(strUsuarioAlta,'') as strUsuarioAlta
					,ISNULL(strMaquinaAlta,'') as strMaquinaAlta
					,ISNULL(datFechaMod,'01/01/1900') as datFechaMod
					,ISNULL(strUsuarioMod,'') as strUsuarioMod
					,ISNULL(strMaquinaMod,'') as strMaquinaMod
					,ISNULL(intEmpresa,0) as intEmpresa
                FROM   VetecMarfilAdmin..tbEstadosFinRubros A
                WHERE ((@intEstadoFin = 0) OR (A.intEstadoFin = @intEstadoFin))  
END
GO 

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbEstadosFinRubros_Sel Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbEstadosFinRubros_Sel Error on Creation'
END
GO
