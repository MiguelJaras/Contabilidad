  

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbPolizasEnc_Fill')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbPolizasEnc_Fill
	PRINT N'Drop Procedure : dbo.usp_tbPolizasEnc_Fill - Succeeded !!!'
END
GO


-- =============================================
-- Author:		IASD
-- Create date: 13/08/2013
-- Description: Determina si existe en tabla:tbPolizasEnc
-- =============================================
CREATE   PROCEDURE usp_tbPolizasEnc_Fill
(
	@intEmpresa		int,
	@intEjercicio	int,
	@strPoliza		varchar(50)
)
AS
BEGIN

	DECLARE @strFolio VARCHAR(50)

	SELECT @strFolio = strFolio
	FROM tbFacXP WHERE intEmpresa = @intEmpresa AND YEAR(datFechaFac) = @intEjercicio AND strPolProv = @strPoliza

	SELECT intEmpresa,strClasifEnc,intEjercicio,intMes,strPoliza,strTipoPoliza,intFolioPoliza,
	CONVERT(VARCHAR,datFecha,103) AS datFecha,intEstatus,ISNULL(strDescripcion,'') AS strDescripcion,
	ISNULL(dblCargos,0) as dblCargos,ISNULL(dblAbonos,0) as dblAbonos,intIndAfectada,
	intIndInterempresa,intIndRec,intIndGenRec,intEjercicioOr,intMesOr,strPolizaOr,intConFlujo,strAuditAlta,
	strAuditMod,dblTransmision,intPartida,ISNULL(@strFolio,'') as strFolio
	FROM VetecMarfilAdmin..tbPolizasEnc 
	WHERE intEmpresa = @intEmpresa 
	AND intEjercicio = @intEjercicio 
	AND strPoliza = @strPoliza			  


  SET NOCOUNT OFF
END
GO 

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbPolizasEnc_Fill Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbPolizasEnc_Fill Error on Creation'
END
GO