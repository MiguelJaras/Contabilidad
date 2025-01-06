  

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbPolizasEnc_Sel')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbPolizasEnc_Sel
	PRINT N'Drop Procedure : dbo.usp_tbPolizasEnc_Sel - Succeeded !!!'
END
GO


-- =============================================
-- Author:		IASD
-- Create date: 13/08/2013
-- Description: Determina si existe en tabla:tbPolizasEnc
-- =============================================
CREATE   PROCEDURE [dbo].[usp_tbPolizasEnc_Sel]
(
	@intEmpresa		int,
	@intEjercicio	int,
	@intFolioPoliza	int,
	@intMes int,
	@strTipoPoliza varchar(10)
)
AS
BEGIN

DECLARE @existe int
SET @existe = 0

 IF NOT EXISTS(SELECT * FROM VetecMarfilAdmin..tbPolizasEnc WHERE intEmpresa = @intEmpresa AND intEjercicio = @intEjercicio 
			   AND intMes = @intMes	AND strTipoPoliza = @strTipoPoliza AND intFolioPoliza = @intFolioPoliza + 1)		
	SET @existe = 0
ELSE
	SET @existe = 1

SELECT @existe



  SET NOCOUNT OFF
END
GO 

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbPolizasEnc_Sel Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbPolizasEnc_Sel Error on Creation'
END
GO