/****** Object:  StoredProcedure [dbo.usp_tbFacXP_Poliza]    Script Date: 12/8/2009 10:45:19 AM ******/
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbEmpresas_Save')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbEmpresas_Save
	PRINT N'Drop Procedure : dbo.usp_tbEmpresas_Save - Succeeded !!!'
END
GO

------------------------------------------------------------------------------------
---   Aplicacion: Marfil.		                                                 ---
---        Autor: Ingrid Soto Dimas							                      ---
---  Descripcion: Guarda registros de la tabla: tbEmpresas				         ---
---                                                                              ---
------------------------------------------------------------------------------------
---    Fecha     Autor  Comentario                                               ---
---  ----------  -----  -------------------------------------------------------  ---
---  03/09/2013  IASD    Create procedure                                         ---
------------------------------------------------------------------------------------   

CREATE  PROCEDURE [dbo].[usp_tbEmpresas_Save]  
(
	@intEmpresa INT,
	@strNombre varchar(150),
	@strNombreCorto varchar(25),
	@intGrupo int,
	@strDireccion varchar(40),
	@strColonia varchar(25),
	@strDelegacion varchar(25),
	@intEstado int,
	@intCiudad int,
	@strRfc varchar(20),
	@strRegImss varchar(20),
	@strCodigoPostal  varchar(6),
	@strResponsable varchar(40),
	@strRfcResponsable varchar(20),
	@intTipoMoneda int,
	@intLogo int,
	@datFechaAlta Datetime,
	@strUsuarioAlta  varchar(25),
	@strMaquinaAlta  varchar(20),
	@datFechaMod datetime,
	@strUsuarioMod  varchar(25),
	@strMaquinaMod varchar(20),
	@dblInteresMoratorio numeric(18,4)
 )
WITH ENCRYPTION
AS  
BEGIN

	SET NOCOUNT ON

    IF NOT EXISTS(SELECT * FROM vetecMarfilAdmin..tbEmpresas WHERE intEmpresa = @intEmpresa)
            BEGIN
                     
                      INSERT INTO vetecMarfilAdmin..tbEmpresas 
                                  (
										intEmpresa
										,strNombre
										,strNombreCorto
										,intGrupo
										,strDireccion
										,strColonia
										,strDelegacion
										,intEstado
										,intCiudad
										,strRfc
										,strRegImss
										,strCodigoPostal
										,strResponsable
										,strRfcResponsable
										,intTipoMoneda
										,intLogo
										,datFechaAlta
										,strUsuarioAlta
										,strMaquinaAlta
										,datFechaMod
										,strUsuarioMod
										,strMaquinaMod
										,dblInteresMoratorio
                                  )
                                  VALUES
                                  (
                                     	@intEmpresa 
										,@strNombre 
										,@strNombreCorto 
										,@intGrupo 
										,@strDireccion 
										,@strColonia
										,@strDelegacion 
										,@intEstado 
										,@intCiudad 
										,@strRfc 
										,@strRegImss
										,@strCodigoPostal 
										,@strResponsable 
										,@strRfcResponsable 
										,@intTipoMoneda 
										,@intLogo 
										,@datFechaAlta 
										,@strUsuarioAlta  
										,@strMaquinaAlta  
										,@datFechaMod 
										,@strUsuarioMod  
										,@strMaquinaMod 
										,@dblInteresMoratorio
                                  )

					INSERT INTO vetecMarfil..tbSucursales
								  (
										intEmpresa
										,intClave
										,strNombre
										,strNombreCorto
										,strUsuarioAlta
										,strMaquinaAlta
										,datFechaAlta
										,strUsuarioMod
										,strMaquinaMod
										,datFechaMod
								  )

								VALUES
                                  (
                                     	@intEmpresa 
										,1 
										,'MONTERREY' 
										,'MTY'
										,NULL 
										,NULL
										,NULL 
										,NULL 
										,NULL 
										,NULL 
                                  )


								
			END ELSE BEGIN
				  UPDATE vetecMarfilAdmin..tbEmpresas 
						SET intEmpresa = @intEmpresa
										,strNombre  = @strNombre 
										,strNombreCorto  = @strNombreCorto 
										,strDireccion  = @strDireccion 
										,strColonia = @strColonia
										,strDelegacion  = @strDelegacion 
										,intEstado = @intEstado 
										,intCiudad  = @intCiudad 
										,strRfc  = @strRfc 
										,strRegImss =@strRegImss
										,strCodigoPostal  = @strCodigoPostal 
										,strResponsable  = @strResponsable 
										,strRfcResponsable  = @strRfcResponsable 
										,intTipoMoneda = @intTipoMoneda   
										,datFechaMod  = @datFechaMod 
										,strUsuarioMod  = @strUsuarioMod  
										,strMaquinaMod = @strMaquinaMod 
					WHERE intEmpresa = @intEmpresa 
			END

	SELECT @intEmpresa 

	SET NOCOUNT OFF
	
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



