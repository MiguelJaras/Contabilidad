/****** Object:  StoredProcedure [dbo.usp_Contabilidad_DataList]    Script Date: 12/8/2009 10:45:19 AM ******/
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_SizeObra')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_SizeObra
	PRINT N'Drop Procedure : dbo.usp_SizeObra - Succeeded !!!'
END
GO
-- =============================================
-- Author:		IASD
-- Create date: 19/08/2013
-- Description:	Obtiene SizeObra
-- =============================================
create  PROCEDURE [dbo].[usp_SizeObra]
	@intEmpresa		int,
	@ObraIni		varchar(20),
	@ObraFin		varchar(20)
AS
BEGIN

	DECLARE @strCCIni VarChar(60) 
	DECLARE @strCCFin VarChar(60) 
	SET @strCCIni  = @ObraIni 
	SET @strCCFin = @ObraFin 

	IF(@strCCIni = '0') 
		SELECT TOP 1 @strCCIni = strClave 
			FROM VetecMarfil..tbObra 
			WHERE intEmpresa = @intEmpresa
			order by strClave ASC  

	IF(@strCCFin = '0') 
		SELECT TOP 1 @strCCFin = strClave 
			FROM VetecMarfil..tbObra 
			WHERE intEmpresa = @intEmpresa
			order by strClave DESC 

	SELECT DISTINCT intColonia,strColonia 
	FROM VetecMarfil.dbo.fn_ColoniasObra(@strCCIni,@strCCFin,@intEmpresa) 

	SET NOCOUNT OFF
END
GO

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_SizeObra Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_SizeObra Error on Creation'
END
GO

