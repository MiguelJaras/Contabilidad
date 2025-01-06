IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbCuentasRet_Del_')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbCuentasRet_Del_
	PRINT N'Drop Procedure : dbo.usp_tbCuentasRet_Del_ - Succeeded !!!'
END
GO

------------------------------------------------------------------------------------
---																				 ---
---        Autor: Ramon Rios Hernandez                                           ---
---  Descripcion: DELETE en tbCuentasRet										 ---
---                                                                              ---
------------------------------------------------------------------------------------
---    Fecha     Autor  Comentario                                               ---
---  ----------  -----  -------------------------------------------------------  ---
---  23/07/2013  RRH    Create procedure                                         ---
------------------------------------------------------------------------------------
CREATE
PROCEDURE [DBO].[usp_tbCuentasRet_Del_]
(
	@intEmpresa		INT,
	@intArea		INT,
	@strInsumoIni	varchar(100),
	@strInsumoFin	varchar(100),
	@strCuentaCargo	varchar(100),
	@strCuentaAbono	varchar(100)
   --@intCuentaRet   INT
) 
AS
BEGIN
	SET NOCOUNT ON
                
				DELETE
				FROM tbCuentasRet
				WHERE intEmpresa = @intEmpresa
					AND intArea = @intArea
					AND strInsumoIni = @strInsumoIni
					AND strInsumoFin = @strInsumoFin
					AND strCuentaCargo = @strCuentaCargo
					AND strCuentaAbono = @strCuentaAbono	
                   --AND intCuentaRet = @intCuentaRet


	SET NOCOUNT OFF  
END

GO
-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbCuentasRet_Del_ Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbCuentasRet_Del_ Error on Creation'
END
GO

