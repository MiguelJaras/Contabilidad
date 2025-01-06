
USE VetecMarfilAdmin
GO

/****** Object:  StoredProcedure [dbo.usp_tbLlamada_List]    Script Date: 12/8/2009 10:45:19 AM ******/
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbEmpresas_Save')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbEmpresas_Save
	PRINT N'Drop Procedure : dbo.usp_tbEmpresas_Save - Succeeded !!!'
END
GO

------------------------------------------------------------------------------------
---   Aplicacion: Marfil.		                                                 ---
---        Autor: Rubén Mora Martínez                                            ---
---  Descripcion: Obtiene un registro de la tabla:  Tareas	                     ---
---                                                                              ---
------------------------------------------------------------------------------------
---    Fecha     Autor  Comentario                                               ---
---  ----------  -----  -------------------------------------------------------  ---
---  12/11/2010  RMM    Create procedure                                         ---
------------------------------------------------------------------------------------
CREATE PROCEDURE dbo.usp_tbEmpresas_Save
(
	@intEmpresa			int,
	@strNombre			varchar(150),
	@strNombreCorto		varchar(25),	
	@strDireccion		varchar(40),
	@strColonia			varchar(25),
	@strDelegacion		varchar(25),
	@intEstado			int,
	@intCiudad			int,
	@strRFC				varchar(15),			
	@strRegIMSS			varchar(20),
	@strCodigoPostal	VARCHAR(6),
	@strResponsable		varchar(40),
	@strRFCResponsable	varchar(20),
	@strUsuario			varchar(25),
	@strMaquina			varchar(20),
	@intGrupo			int = 1,
	@intTipoMoneda		int = 1,
	@intLogo			int = 2013,
	@dblInteresMoratorio DECIMAL(18,4) = 0.0250
)
AS
BEGIN

	IF NOT EXISTS(SELECT 1 FROM tbEmpresas WHERE intEmpresa = @intEmpresa)
	BEGIN
		SELECT @intEmpresa = MAX(intEmpresa) + 1 FROM tbEmpresas

		INSERT INTO tbEmpresas(intEmpresa,strNombre,strNombreCorto,strDireccion,strColonia,strDelegacion,intEstado,intCiudad,strRFC,			
		strRegIMSS,strCodigoPostal,strResponsable,strRFCResponsable,strUsuarioAlta,strMaquinaAlta,intGrupo,intTipoMoneda,intLogo,dblInteresMoratorio,datFechaAlta)
		VALUES(@intEmpresa,@strNombre,@strNombreCorto,@strDireccion,@strColonia,@strDelegacion,@intEstado,@intCiudad,@strRFC,@strRegIMSS,
		@strCodigoPostal,@strResponsable,@strRFCResponsable,@strUsuario,@strMaquina,@intGrupo,@intTipoMoneda,@intLogo,@dblInteresMoratorio,getdate())

		IF(@@Error = 0)
		BEGIN
			INSERT INTO tbTiposPoliza(intEmpresa,strClasifEnc,strTipoPoliza,strNombre,strNombreCorto,intCapturable,intEjercicio,intM1,
			intM2,intM3,intM4,intM5,intM6,intM7,intM8,intM9,intM10,intM11,intM12,strAuditAlta)
			SELECT @intEmpresa,'0',strTipoPoliza,strNombre,strNombreCorto,intCapturable,intEjercicio,0,0,0,0,0,0,0,0,0,0,0,0,@strUsuario 
			FROM tbTiposPoliza 
			WHERE intEmpresa = 1 
			AND intEjercicio = YEAR(GETDATE())

			INSERT INTO vetecMarfil..tbSucursales(intEmpresa,intClave,strNombre,strNombreCorto,strUsuarioAlta)
			VALUES(@intEmpresa,1,'MONTERREY','MTY',@strUsuario)

			--INSERT INTO tbCuentasSaldos(intEmpresa,intEjercicio,strCuenta,strClasifEnc,strClasifDP,strClasifDS,
			--intIndInterEmpresa,intTipoMoneda,dblSaldoInicial,dblCargo01,dblAbono01,dblCargo02,dblAbono02,dblCargo03,
			--dblAbono03,dblCargo04,dblAbono04,dblCargo05,dblAbono05,dblCargo06,dblAbono06,dblCargo07,dblAbono07,dblCargo08,
			--dblAbono08,dblCargo09,dblAbono09,dblCargo10,dblAbono10,dblCargo11,dblAbono11,dblCargo12,dblAbono12,datFechaAlta,
			--strUsuarioAlta,strMaquinaAlta,datFechaMod,strUsuarioMod,strMaquinaMod)       			
			--SELECT intEmpresa,intEjercicio,strCuenta,'0','0','0',0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,      
			--Null, Null, Null, Null, Null, Null  
			--FROM tbCuentasSaldos
			--WHERE intEmpresa = 11 AND intEjercicio = YEAR(GETDATE())	
		END
	END
	ELSE
	BEGIN
		UPDATE tbEmpresas
		SET strNombre = @strNombre,
			strNombreCorto = @strNombreCorto,
			strDireccion = @strDireccion,
			strColonia = @strColonia,
			strDelegacion = @strDelegacion,
			intEstado = @intEstado,
			intCiudad = @intCiudad,
			strRFC = @strRFC,			
			strRegIMSS = @strRegIMSS,
			strCodigoPostal = @strCodigoPostal,
			strResponsable = @strResponsable,
			strRFCResponsable = @strRFCResponsable,
			strUsuarioMod = @strUsuario,
			strMaquinaMod = @strMaquina,
			datFechaMod = getdate()
		WHERE intEmpresa = @intEmpresa
	END

	SELECT @intEmpresa
	
END
GO

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbEmpresas_Save Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbEmpresas_Save Error on Creation'
END
GO
