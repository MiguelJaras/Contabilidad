

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.fn_tbCuentas_Max'))
BEGIN
	DROP FUNCTION dbo.fn_tbCuentas_Max
	PRINT N'Drop Function : dbo.fn_tbCuentas_Max - Succeeded !!!'
END
GO

------------------------------------------------------------------------------------
---   Aplicacion: RMM.		                                                     ---
---        Autor: Ruben Mora Martinez                                            ---
---  Descripcion: Obtiene un registro de la tabla:  tbCotizacion                 ---
---                                                                              ---
------------------------------------------------------------------------------------
---    Fecha     Autor  Comentario                                               ---
---  ----------  -----  -------------------------------------------------------  ---
---  23/08/2011  RMM    Create procedure                                         ---
------------------------------------------------------------------------------------

CREATE FUNCTION dbo.fn_tbCuentas_Max(@intEmpresa int,@strCuenta VARCHAR(50))    
RETURNS VARCHAR(12)     
WITH ENCRYPTION
AS    
BEGIN 

	DECLARE @strCuentaMax VARCHAR(100)
	DECLARE @intNivel int

	IF(LEN(@strCuenta) = 4)
	BEGIN
		SELECT @strCuentaMax = CONVERT(VARCHAR,MAX(CONVERT(bigint,strCuenta))) 
		FROM tbCuentas WHERE intEmpresa = @intEmpresa and LEFT(strCuenta,LEN(@strCuenta)) = @strCuenta AND intNivel = 2

		SELECT @strCuentaMax = ISNULL(CONVERT(VARCHAR,MAX(CONVERT(bigint,strCuenta))),@strCuentaMax)
		FROM tbCuentas WHERE intEmpresa = @intEmpresa and LEFT(strCuenta,LEN(@strCuentaMax)) = @strCuentaMax AND intNivel = 3
	END

	IF(LEN(@strCuenta) = 8)
	BEGIN
		SELECT @strCuentaMax = CONVERT(VARCHAR,MAX(CONVERT(bigint,strCuenta))) 
		FROM tbCuentas WHERE intEmpresa = @intEmpresa and LEFT(strCuenta,LEN(@strCuenta)) = @strCuenta
	END

	IF(LEN(@strCuenta) = 12)
	BEGIN
		SELECT @strCuentaMax = @strCuenta
	END
	
	RETURN ISNULL(@strCuentaMax,@strCuenta)
END
GO 

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Function Creation: dbo.fn_tbCuentas_Max Succeeded'
END
ELSE
BEGIN
	PRINT 'Function Creation: dbo.fn_tbCuentas_Max Error on Creation'
END
GO



