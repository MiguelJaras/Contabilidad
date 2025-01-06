

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbPolizasDet_DeleteAll')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbPolizasDet_DeleteAll
	PRINT N'Drop Procedure : dbo.usp_tbPolizasDet_DeleteAll - Succeeded !!!'
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

CREATE PROCEDURE dbo.usp_tbPolizasDet_DeleteAll
(
	@intEmpresa		int,
	@strPoliza 		varchar(50),
	@intEjercicio	int,
	@strUsuario		varchar(50),
	@strMaquina		varchar(50)
)
WITH ENCRYPTION
AS
BEGIN
	SET NOCOUNT ON
		
		
	DELETE FROM VetecMarfilAdmin..tbPolizasDet 
	WHERE intEmpresa = @intEmpresa 
	AND strPoliza = @strPoliza 
	AND intEjercicio = @intEjercicio 

	UPDATE VetecMarfilAdmin..tbPolizasEnc 
	SET strAuditMod = @strUsuario + ' ' + @strMaquina + ' ' +CONVERT(VARCHAR, GETDATE())
	WHERE intEmpresa = @intEmpresa 
	AND strPoliza = @strPoliza 
	AND intEjercicio = @intEjercicio 
		
	select @strPoliza

	SET NOCOUNT OFF
END
GO 

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbPolizasDet_DeleteAll Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbPolizasDet_DeleteAll Error on Creation'
END
GO



