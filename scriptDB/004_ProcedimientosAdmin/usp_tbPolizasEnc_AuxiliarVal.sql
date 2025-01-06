

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbPolizasEnc_AuxiliarVal')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbPolizasEnc_AuxiliarVal
	PRINT N'Drop Procedure : dbo.usp_tbPolizasEnc_AuxiliarVal - Succeeded !!!'
END
GO


-- =============================================  
-- Author:  IASD  
-- Create date: 05/09/2013  
-- Description: Obtiene registros de la fn:fn_tbPolizasEnc_Auxiliar
-- =============================================  
CREATE  PROCEDURE [dbo].[usp_tbPolizasEnc_AuxiliarVal]  
(
	@intEmpresa int,
	@auxiliar   int
)    
AS  
BEGIN  
  
	SELECT No as id,strNombre 
	FROM VetecMarfil..fn_tbPolizasEnc_Auxiliar(@intEmpresa) 
	WHERE No = @auxiliar
  
END
GO 

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbPolizasEnc_AuxiliarVal Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbPolizasEnc_AuxiliarVal Error on Creation'
END
GO
 
  
