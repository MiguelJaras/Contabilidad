
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbRubrosCuentas_Save')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbRubrosCuentas_Save
	PRINT N'Drop Procedure : dbo.usp_tbRubrosCuentas_Save - Succeeded !!!'
END
GO


------------------------------------------------------------------------------------
---																				 ---
---        Autor: Ingrid Soto		                                             ---
---  Descripcion: Inserta en tbRubrosCuentas										 ---
---                                                                              ---
------------------------------------------------------------------------------------
---    Fecha     Autor  Comentario                                               ---
---  ----------  -----  -------------------------------------------------------  ---
---  30/08/2013  IASD    Create procedure                                         ---
------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[usp_tbRubrosCuentas_Save]
(
	@intRubro int,
	@strCuenta varchar(50),
	@intIndSumaResta int,
	@datFechaAlta datetime,
	@strUsuarioAlta varchar(20),
	@strMaquinaAlta varchar(20),
	@datFechaMod datetime,
	@strUsuarioMod varchar(20),
	@strMaquinaMod varchar(20),
	@intEmpresa int

) 
WITH ENCRYPTION
AS
BEGIN
	SET NOCOUNT ON
	
	IF NOT EXISTS(SELECT * FROM VetecMarfilAdmin..tbRubrosCuentas WHERE intRubro = @intRubro AND strCuenta = @strCuenta AND intEmpresa = @intEmpresa)    
	BEGIN
		INSERT INTO VetecMarfilAdmin..tbRubrosCuentas(intRubro,strCuenta,intIndSumaResta,datFechaAlta,strUsuarioAlta,
		strMaquinaAlta,datFechaMod,strUsuarioMod,strMaquinaMod,intEmpresa)
        VALUES(@intRubro,@strCuenta,@intIndSumaResta,@datFechaAlta,@strUsuarioAlta,@strMaquinaAlta,@datFechaMod,@strUsuarioMod,
		@strMaquinaMod,@intEmpresa)
	END 
	ELSE 
	BEGIN
		UPDATE VetecMarfilAdmin..tbRubrosCuentas
		SET	intIndSumaResta = @intIndSumaResta,
			datFechaMod = @datFechaMod,
			strUsuarioMod = @strUsuarioMod,
			strMaquinaMod = @strMaquinaMod,
			intEmpresa = @intEmpresa
		WHERE  intRubro = @intRubro
		AND strCuenta = @strCuenta
		AND intEmpresa = @intEmpresa
   END

	SELECT @intRubro 

END
GO 

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbRubrosCuentas_Save Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbRubrosCuentas_Save Error on Creation'
END
GO

