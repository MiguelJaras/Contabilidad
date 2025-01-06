
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbPolizasIva_Cierre')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbPolizasIva_Cierre
	PRINT N'Drop Procedure : dbo.usp_tbPolizasIva_Cierre - Succeeded !!!'
END
GO

------------------------------------------------------------------------------------
---   Aplicacion: IASD.		                                                     ---
---        Autor: Ingrid Alexis Soto Dimas                                       ---
---  Descripcion: Obtiene un registro de la tabla:  tbPolizasIva                 ---
---                                                                              ---
------------------------------------------------------------------------------------
---    Fecha     Autor  Comentario                                               ---
---  ----------  -----  -------------------------------------------------------  ---
---  09/12/2014  IASD    Create procedure                                         ---
------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[usp_tbPolizasIva_Cierre]     
(        
	@intEmpresa		INT,        
	@intEjercicio	INT,               
	@intMes			INT    
)  
AS  
BEGIN

	SELECT Convert(int,bCerrado) 
	FROM VetecMarfil..tbCerrarPeriodo 
	WHERE intEmpresa = @intEmpresa 
	AND intEjercicio = @intEjercicio 
	AND intMes = @intMes 
	AND intModulo = 1

END
GO 

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbPolizasIva_Cierre Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbPolizasIva_Cierre Error on Creation'
END
GO




