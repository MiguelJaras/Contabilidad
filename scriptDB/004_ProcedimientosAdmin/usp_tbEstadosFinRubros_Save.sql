
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbEstadosFinRubros_Save')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbEstadosFinRubros_Save
	PRINT N'Drop Procedure : dbo.usp_tbEstadosFinRubros_Save - Succeeded !!!'
END
GO


------------------------------------------------------------------------------------
---																				 ---
---        Autor: Ingrid Soto		                                             ---
---  Descripcion: Inserta en tbEstadosFinRubros									 ---
---                                                                              ---
------------------------------------------------------------------------------------
---    Fecha     Autor  Comentario                                               ---
---  ----------  -----  -------------------------------------------------------  ---
---  02/09/2013  IASD    Create procedure                                         ---
------------------------------------------------------------------------------------
create
PROCEDURE [dbo].[usp_tbEstadosFinRubros_Save]
(
	@intEstadoFin int,
	@intRubro int,
	@intSecuencia int,
	@strTipoRubro varchar(4),
	@strNombre varchar(150),
	@strNombreCorto varchar(15),
	@intPtaje int,
	@datFechaAlta datetime,
	@strUsuarioAlta varchar(20),
	@strMaquinaAlta varchar(20),
	@datFechaMod datetime,
	@strUsuarioMod varchar(20),
	@strMaquinaMod varchar(20),
	@intEmpresa int
) AS
     BEGIN

                SET NOCOUNT ON
                IF NOT EXISTS
                        (SELECT *
                        FROM VetecMarfilAdmin..tbEstadosFinRubros 
						WHERE  intEstadoFin   = @intEstadoFin
						AND intRubro = @intRubro
						AND intEmpresa =  @intEmpresa
                        )
                        BEGIN

							DECLARE @ord int
							SET @ord = ( SELECT MAX(intSecuencia) FROM VetecMarfilAdmin..tbEstadosFinRubros 
										 WHERE intEstadoFin = @intEstadoFin
										 AND intEmpresa = @intEmpresa
										)
							SET @ord = @ord + 1

							DECLARE @strTipo varchar(4)
							SELECT @strTipo  = strTipoRubro 
							FROM   VetecMarfilAdmin..tbRubros A
							WHERE intRubro = @intRubro
							--AND ((ISNULL(@intEmpresa,0) = 0) OR (A.intEmpresa = @intEmpresa)) 
     
                                  INSERT INTO VetecMarfilAdmin..tbEstadosFinRubros
                                              (
													intEstadoFin
													,intRubro
													,intSecuencia
													,strTipoRubro
													,strNombre
													,strNombreCorto
													,intPtaje
													,datFechaAlta
													,strUsuarioAlta
													,strMaquinaAlta
													,datFechaMod
													,strUsuarioMod
													,strMaquinaMod
													,intEmpresa
                                              )
                                              VALUES
                                              (
													@intEstadoFin
													,@intRubro
													,@ord
													,@strTipo
													,@strNombre
													,@strNombreCorto
													,@intPtaje
													,@datFechaAlta
													,@strUsuarioAlta
													,@strMaquinaAlta
													,@datFechaMod
													,@strUsuarioMod
													,@strMaquinaMod
													,@intEmpresa
                                              )
                      END ELSE BEGIN
	
							UPDATE VetecMarfilAdmin..tbEstadosFinRubros
								SET  intEstadoFin = @intEstadoFin
										,intRubro = @intRubro
										,intSecuencia = @intSecuencia
										,strTipoRubro = @strTipoRubro
										,strNombre = @strNombre
										,strNombreCorto = @strNombreCorto
										,intPtaje = @intPtaje
										,datFechaMod = @datFechaMod
										,strUsuarioMod = @strUsuarioMod
										,strMaquinaMod = @strMaquinaMod
										,intEmpresa = @intEmpresa
							WHERE  intEstadoFin   = @intEstadoFin
							AND intRubro = @intRubro
							AND intEmpresa =  @intEmpresa
   END

	SELECT @intRubro 

END
GO 

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbEstadosFinRubros_Save Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbEstadosFinRubros_Save Error on Creation'
END
GO

