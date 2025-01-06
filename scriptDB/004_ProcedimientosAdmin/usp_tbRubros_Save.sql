

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbRubros_Save')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbRubros_Save
	PRINT N'Drop Procedure : dbo.usp_tbRubros_Save - Succeeded !!!'
END
GO


------------------------------------------------------------------------------------
---																				 ---
---        Autor: Ingrid Soto		                                             ---
---  Descripcion: Inserta en tbRubros										 ---
---                                                                              ---
------------------------------------------------------------------------------------
---    Fecha     Autor  Comentario                                               ---
---  ----------  -----  -------------------------------------------------------  ---
---  28/08/2013  IASD    Create procedure                                         ---
------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[usp_tbRubros_Save]
(
    @intEmpresa int,
	@intRubro int,
	@strNombre varchar(150),
	@strNombreCorto varchar(30),
	@strTipoRubro varchar(1),
	@intIndCambiaSignoSalida int,
	@strSignoOperacionArit varchar(1),
	@datFechaAlta datetime,
	@strUsuarioAlta varchar(20),
	@strMaquinaAlta varchar(20),
	@datFechaMod datetime,
	@strUsuarioMod varchar(20),
	@strMaquinaMod varchar(20)

)
WITH ENCRYPTION
AS
BEGIN
	SET NOCOUNT ON
    
    IF NOT EXISTS(SELECT * FROM VetecMarfilAdmin..tbRubros WHERE  intRubro   = @intRubro)
    BEGIN
		INSERT INTO VetecMarfilAdmin..tbRubros(intRubro,strNombre,strNombreCorto,strTipoRubro,intIndCambiaSignoSalida,
		strSignoOperacionArit,strFormula,datFechaAlta,strUsuarioAlta,strMaquinaAlta,datFechaMod,strUsuarioMod,
		strMaquinaMod,intEmpresa)
        VALUES(@intRubro,@strNombre,@strNombreCorto,@strTipoRubro,@intIndCambiaSignoSalida,@strSignoOperacionArit,NULL,
		@datFechaAlta,@strUsuarioAlta,@strMaquinaAlta,@datFechaMod,@strUsuarioMod,@strMaquinaMod,@intEmpresa)
    END 
	ELSE 
	BEGIN
		UPDATE VetecMarfilAdmin..tbRubros
		SET strNombre = @strNombre,
			strNombreCorto = @strNombreCorto,
			strTipoRubro = @strTipoRubro,
			intIndCambiaSignoSalida = @intIndCambiaSignoSalida,
			strSignoOperacionArit = @strSignoOperacionArit,
			datFechaMod = @datFechaMod,
			strUsuarioMod = @strUsuarioMod,
			strMaquinaMod = @strMaquinaMod
		WHERE  intRubro   = @intRubro		
	END

	SELECT @intRubro 

END
GO 

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbRubros_Save Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbRubros_Save Error on Creation'
END
GO

