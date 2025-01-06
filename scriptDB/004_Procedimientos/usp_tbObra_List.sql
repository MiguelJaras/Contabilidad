
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbObra_List')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbObra_List
	PRINT N'Drop Procedure : dbo.usp_tbObra_List - Succeeded !!!'
END
GO

------------------------------------------------------------------------------------
---   Aplicacion: RMM.		                                                     ---
---        Autor: Ruben Mora Martinez                                            ---
---  Descripcion: Obtiene un registro de la tabla:  tbCotizacion                 ---
---                                                                              ---
------------------------------------------------------------------------------------
---    Fecha     Autor  Comentario                                               ---
---  ----------  -----  -------------------------------------------------------  ---
---  22/08/2011  RMM    Create procedure                                         ---
------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[usp_tbObra_List]     
(        
	@intEmpresa int      
)  
AS  
BEGIN
				
	SELECT intEmpresa,intObra,strClave,strNombre
	FROM tbObra
	WHERE intEmpresa = @intEmpresa

END
GO 

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbObra_List Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbObra_List Error on Creation'
END
GO




