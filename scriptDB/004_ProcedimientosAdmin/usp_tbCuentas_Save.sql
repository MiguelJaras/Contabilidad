IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbCuentas_Save')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbCuentas_Save
	PRINT N'Drop Procedure : dbo.usp_tbCuentas_Save - Succeeded !!!'
END
GO

------------------------------------------------------------------------------------
---																				 ---
---        Autor: Ramon Rios Hernandez                                           ---
---  Descripcion: Inserta en tbRubros										 ---
---                                                                              ---
------------------------------------------------------------------------------------
---    Fecha     Autor  Comentario                                               ---
---  ----------  -----  -------------------------------------------------------  ---
---  09/07/2013  RRH    Create procedure                                         ---
------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[usp_tbCuentas_Save]
(
    @intEmpresa				int,
	@strCuenta				varchar(50),
	@strNombre				varchar(150),
	@strNombreCorto			varchar(60),	
	@intCtaRegistro			int,
	@intIndAuxiliar			int,
	@intTipoGrupoContable	int,
	@IntGrupoContable		int,
	@intAcceso				int,
	@strAuditAlta			varchar(150),
	@strCodigoAgrupador		varchar(10)
) 
WITH ENCRYPTION
AS
BEGIN
	SET NOCOUNT ON

	DECLARE @intNivel INT

	SET @intNivel = CASE WHEN LEN(@strCuenta) = 12 THEN 3 ELSE CASE WHEN LEN(@strCuenta) = 8 THEN 2 ELSE 1 END END

	SET @strAuditAlta = @strAuditAlta + ' ' + CONVERT(VARCHAR,GETDATE())
	
    IF NOT EXISTS(SELECT * FROM tbCuentas WHERE intEmpresa = @intEmpresa AND  strCuenta  = @strCuenta)
    BEGIN 
		IF(@intNivel > 1)
		BEGIN			
			IF(@intNivel = 2)
			BEGIN
				IF NOT EXISTS(SELECT 1 FROM tbCuentas WHERE intEmpresa = @intEmpresa AND  LEFT(strCuenta,4) = LEFT(@strCuenta,4))
				BEGIN
					RAISERROR('No se puede guardar la cuenta, no existe cuenta con nivel anterior.',16,1)
					RETURN;
				END
			END

			IF(@intNivel = 3)
			BEGIN
				IF NOT EXISTS(SELECT 1 FROM tbCuentas WHERE intEmpresa = @intEmpresa AND LEFT(strCuenta,8) = LEFT(@strCuenta,8))
				BEGIN
					RAISERROR('No se puede guardar la cuenta, no existe cuenta con nivel anterior.',16,1)
					RETURN
				END
			END	

			SELECT @intIndAuxiliar = intIndAuxiliar,@IntGrupoContable = intGrupoContable
			FROM tbCuentas WHERE intEmpresa = @intEmpresa AND  LEFT(strCuenta,4) = LEFT(@strCuenta,4)		
		END		
                                
		INSERT INTO tbCuentas(intEmpresa,strClasifEnc,strCuenta,strNombre,strNombreCorto,intNivel,intCtaRegistro,intIndAuxiliar,
		intTipoGrupoContable,intGrupoContable,strAuditAlta,intIndBloqueo,intIndInterEmpresa,intAcceso,strCodigoAgrupador)
        VALUES(@intEmpresa,0,@strCuenta,@strNombre,@strNombreCorto,@intNivel,@intCtaRegistro,@intIndAuxiliar,
		@intTipoGrupoContable,@IntGrupoContable,@strAuditAlta,0,0,@intAcceso,@strCodigoAgrupador)
    END 
	ELSE 
	BEGIN
		IF(@intNivel > 1)
		BEGIN
			SELECT @intIndAuxiliar = intIndAuxiliar,@IntGrupoContable = intGrupoContable
			FROM tbCuentas WHERE intEmpresa = @intEmpresa AND  LEFT(strCuenta,4) = LEFT(@strCuenta,4) AND LEN(strCuenta) = 4
		END			
		
		UPDATE tbCuentas
        SET	intEmpresa = @intEmpresa,
				strNombre = @strNombre,
				strNombreCorto = @strNombreCorto,
				intCtaRegistro = @intCtaRegistro,
				intIndAuxiliar = @intIndAuxiliar,
				intTipoGrupoContable = @intTipoGrupoContable,
				intGrupoContable = @IntGrupoContable, 
				strAuditMod = @strAuditAlta,
				intAcceso = @intAcceso,
				strCodigoAgrupador = @strCodigoAgrupador
        WHERE intEmpresa = @intEmpresa
        AND   strCuenta  = @strCuenta
   END

SELECT @strCuenta 

SET NOCOUNT OFF
END

GO
-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbCuentas_Save Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbCuentas_Save Error on Creation'
END
GO