IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbCuentasRet_Save_')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbCuentasRet_Save_
	PRINT N'Drop Procedure : dbo.usp_tbCuentasRet_Save_ - Succeeded !!!'
END
GO 
------------------------------------------------------------------------------------
---																				 ---
---        Autor: Ramon Rios Hernandez                                           ---
---  Descripcion: Inserta en tbCuentasRet										 ---
---                                                                              ---
------------------------------------------------------------------------------------
---    Fecha     Autor  Comentario                                               ---
---  ----------  -----  -------------------------------------------------------  ---
---  23/07/2013  RRH    Create procedure                                         ---
------------------------------------------------------------------------------------
CREATE
PROCEDURE [DBO].[usp_tbCuentasRet_Save_]
(
    @intEmpresa 	INT,
	@intArea		INT,
	@strInsumoIni	VARCHAR(100),
	@strInsumoFin	VARCHAR(100),
	@strCuentaCargo VARCHAR(100),
	@strCuentaAbono VARCHAR(100),
	@intES			INT,
	@strUsuario		VARCHAR(50) 

) AS
        BEGIN
           SET NOCOUNT ON
                IF NOT EXISTS
                        (SELECT *
							FROM tbCuentasRet
							WHERE intEmpresa    = @intEmpresa
							AND intArea = @intArea
							AND strInsumoIni = @strInsumoIni
							AND strInsumoFin = @strInsumoFin
							AND strCuentaCargo = @strCuentaCargo
							AND strCuentaAbono = @strCuentaAbono
						    --AND intCuentaRet = @intCuentaRet
                        )
                        BEGIN
                                  INSERT INTO VetecMarfilAdmin.dbo.tbCuentasRet
                                              (
                                                        intEmpresa 			,
														intArea				,
														strInsumoIni		,
														strInsumoFin		,
														strCuentaCargo 		,
														strCuentaAbono 		,
														intES				,
														strUsuario			,
														datFechaModificado 
                                              )
                                              VALUES
                                              ( 
                                                        @intEmpresa 		,
														@intArea			,
														@strInsumoIni		,
														@strInsumoFin		,
														@strCuentaCargo 	,
														@strCuentaAbono 	,
														@intES				,
														@strUsuario			,
														GETDATE() 
												)
																			 
					 END ELSE BEGIN 
					  UPDATE VetecMarfilAdmin.dbo.tbCuentasRet
						 SET 	intEmpresa 	  	   = @intEmpresa 		, 
								intArea 		   = @intArea			,
								strInsumoIni 	   = @strInsumoIni		,
								strInsumoFin 	   = @strInsumoFin		,
								strCuentaCargo 	   = @strCuentaCargo 	,
								strCuentaAbono 	   = @strCuentaAbono 	,
								intES 			   = @intES				,
								strUsuario 		   = @strUsuario		,
								datFechaModificado = GETDATE() 
						 WHERE  intEmpresa         = @intEmpresa
							AND intArea = @intArea
							AND strInsumoIni = @strInsumoIni
							AND strInsumoFin = @strInsumoFin
							AND strCuentaCargo = @strCuentaCargo
							AND strCuentaAbono = @strCuentaAbono
--						 AND    intCuentaRet       = @intCuentaRet
   
   END


SET NOCOUNT OFF
END

GO
-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbCuentasRet_Save_ Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbCuentasRet_Save_ Error on Creation'
END
GO