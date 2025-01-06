
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbEstructuraEnc_Save')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbEstructuraEnc_Save
	PRINT N'Drop Procedure : dbo.usp_tbEstructuraEnc_Save - Succeeded !!!'
END
GO

------------------------------------------------------------------------------------
---																				 ---
---        Autor: Ramon Rios Hernandez                                           ---
---  Descripcion: Inserta en EstructuraEnc										 ---
---                                                                              ---
------------------------------------------------------------------------------------
---    Fecha     Autor  Comentario                                               ---
---  ----------  -----  -------------------------------------------------------  ---
---  28/06/2013  RRH    Create procedure                                         ---
------------------------------------------------------------------------------------
CREATE
PROCEDURE [DBO].[usp_tbEstructuraEnc_Save]
(
    @intEmpresa           INT,
    @intClave             INT,
    @strDescrcipcion      VARCHAR(50),
    @strTipoPoliza        VARCHAR(3),
    @intModulo            INT,
    @strDescripciónPoliza VARCHAR(100),
    @bitAutomatica        BIT,
    @strUsuario	          VARCHAR(50),
    @strMaquina	          VARCHAR(50),    
    @intMovto             INT,
    @intGrupoCredito      INT
) AS
        BEGIN
                SET NOCOUNT ON
                IF NOT EXISTS
                        (SELECT *
                        FROM    tbEstructuraEnc
                        WHERE   intEmpresa = @intEmpresa
                        AND     intClave   = @intClave
                        )
                        BEGIN
                                IF(@intClave = 0)
                                        BEGIN
                                                SELECT @intClave = ISNULL(MAX(intClave) + 1,1)
                                                FROM   tbEstructuraEnc
                                                WHERE  intEmpresa = @intEmpresa
                                         END
                                  INSERT INTO tbEstructuraEnc
                                              (
                                                          intEmpresa          ,
														  intClave,
                                                          strDescrcipcion     ,
                                                          strTipoPoliza       ,
                                                          intModulo           ,
                                                          strDescripciónPoliza,
                                                          bitAutomatica       ,
                                                          strUsuarioAlta      ,
                                                          strMaquinaAlta      ,
                                                          datFechaAlta        ,
                                                          intMovto            ,
                                                          intGrupoCredito
                                              )
                                              VALUES
                                              (
                                                          @intEmpresa          ,
														  @intClave,
                                                          @strDescrcipcion     ,
                                                          @strTipoPoliza       ,
                                                          @intModulo           ,
                                                          @strDescripciónPoliza,
                                                          @bitAutomatica       ,
                                                          @strUsuario          ,
                                                          @strMaquina          ,
                                                          GETDATE()            ,
                                                          @intMovto            ,
                                                          @intGrupoCredito
                                              )
                      END ELSE BEGIN
          UPDATE tbEstructuraEnc
          SET    strDescrcipcion      = @strDescrcipcion     ,
                 strTipoPoliza        = @strTipoPoliza       ,
                 intModulo            = @intModulo           ,
                 strDescripciónPoliza = @strDescripciónPoliza,
                 bitAutomatica        = @bitAutomatica       ,
                 strUsuarioMod        = @strUsuario          ,
                 strMaquinaMod        = @strMaquina          ,
                 datFechaMod          = GETDATE()            ,
                 intMovto             = @intMovto            ,
                 intGrupoCredito      = @intGrupoCredito
          WHERE  intEmpresa           = @intEmpresa
          AND    intClave             = @intClave
   END

SELECT @intClave 

SET NOCOUNT OFF
END

GO
-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbEstructuraEnc_Save Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbEstructuraEnc_Save Error on Creation'
END
GO