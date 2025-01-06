
IF EXISTS(SELECT * FROM    dbo.sysobjects WHERE   id = OBJECT_ID(N'dbo.usp_tbEstructuraDet_Save') AND  
   OBJECTPROPERTY(id,N'IsProcedure') = 1 )
BEGIN
		DROP PROCEDURE dbo.usp_tbEstructuraDet_Save
		PRINT N'Drop Procedure : dbo.usp_tbEstructuraDet_Save - Succeeded !!!'
END 
GO
------------------------------------------------------------------------------------
---                     														 ---
---        Autor: Ramon Rios Hernandez                                           ---
---  Descripcion: Inserta en EstructuraDet           							 ---
---                                                                              ---
------------------------------------------------------------------------------------
---    Fecha     Autor  Comentario                                               ---
---  ----------  -----  -------------------------------------------------------  ---
---  28/06/2013  RRH    Create procedure                                         ---
------------------------------------------------------------------------------------
CREATE PROCEDURE [DBO].[usp_tbEstructuraDet_Save]
(
	@intEmpresa      INT,
	@intClave        INT,
	@intPartida      INT,
	@strCuenta       VARCHAR(10),
	@strSubCuentat   VARCHAR(10),
	@strSubSubCuenta VARCHAR(10),
	@bitCargo        BIT,
	@bitAux          BIT,
	@bitCC           BIT,
	@strConcepto     VARCHAR(100),
	@strComentario   VARCHAR(100),
	@bitModif        BIT,
	@strBase         VARCHAR(50),
	@dblPtaje        DECIMAL(10,6)
) AS
        BEGIN
                SET NOCOUNT ON
                IF NOT EXISTS
                        (SELECT *
                        FROM    tbEstructuraDet
                        WHERE   intEmpresa = @intEmpresa
                        AND     intClave   = @intClave
						AND		intPartida = @intPartida
                        )
                        BEGIN
                                IF(@intPartida = 0)
                                        BEGIN
                                                SELECT @intPartida = ISNULL(MAX(intPartida) + 1,1)
                                                FROM   tbEstructuraDet
                                                WHERE  intEmpresa = @intEmpresa
												   AND intClave = @intClave
                                         END
                                  INSERT INTO VetecMarfilAdmin.dbo.tbEstructuraDet
                                              (
                                                          intClave        ,
                                                          intPartida      ,
                                                          strCuenta       ,
                                                          strSubCuentat   ,
                                                          strSubSubCuenta ,
                                                          bitCargo        ,
                                                          bitAux          ,
                                                          bitCC           ,
                                                          strConcepto     ,
                                                          strComentario   ,
                                                          bitModif        ,
                                                          strBase         ,
                                                          intPtaje        ,
                                                          intEmpresa
                                              )
                                              VALUES
                                              (
                                                          @intClave        ,
                                                          @intPartida      ,
                                                          @strCuenta       ,
                                                          @strSubCuentat   ,
                                                          @strSubSubCuenta ,
                                                          @bitCargo        ,
                                                          @bitAux          ,
                                                          @bitCC           ,
                                                          @strConcepto     ,
                                                          @strComentario   ,
                                                          @bitModif        ,
                                                          @strBase         ,
                                                          @dblPtaje        ,
                                                          @intEmpresa
                                              )
                      END ELSE BEGIN
							UPDATE VetecMarfilAdmin.dbo.tbEstructuraDet
							SET    intClave        = @intClave       ,
								   intPartida      = @intPartida     ,
								   strCuenta       = @strCuenta      ,
								   strSubCuentat   = @strSubCuentat  ,
								   strSubSubCuenta = @strSubSubCuenta,
								   bitCargo        = @bitCargo       ,
								   bitAux          = @bitAux         ,
								   bitCC           = @bitCC          ,
								   strConcepto     = @strConcepto    ,
								   strComentario   = @strComentario  ,
								   bitModif        = @bitModif       ,
								   strBase         = @strBase        ,
								   intPtaje        = @dblPtaje       ,
								   intEmpresa      = @intEmpresa     
							WHERE  intEmpresa      = @intEmpresa
							AND    intPartida      = @intPartida
							AND    intClave        = @intClave
					  END
						
					SELECT @intClave SET NOCOUNT OFF
					END 
GO
-- Display the status of Proc creation
IF (@@Error = 0) BEGIN PRINT 'Procedure Creation: dbo.usp_tbEstructuraDet_Save Succeeded'
END ELSE BEGIN PRINT 'Procedure Creation: dbo.usp_tbEstructuraDet_Save Error on Creation'
END 

GO