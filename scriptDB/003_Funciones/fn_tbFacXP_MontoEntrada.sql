IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.fn_tbFacXP_MontoEntrada')
	AND OBJECTPROPERTY(id,N'IsScalarFunction') = 1)
BEGIN
    DROP FUNCTION dbo.fn_tbFacXP_MontoEntrada
    PRINT 'Drop Function : dbo.fn_tbFacXP_MontoEntrada - Succeeded !!!'
END
GO

------------------------------------------------------------------------------------
---  Aplicacion:  PM.															 ---
---        Autor: Ruben Mora Martinez/ RMM										 ---
---  Descripcion: Return number of week in current month                         ---
------------------------------------------------------------------------------------
---    Fecha     Autor  Comentario                                               ---
---  ----------  -----  -------------------------------------------------------  ---
---  2011-07-29  RMM    Creacion                                                 ---
------------------------------------------------------------------------------------

Create Function dbo.fn_tbFacXP_MontoEntrada
(
	@intEmpresa int,
	@intProveedor int,
	@strFactura	VARCHAR(50)	
)
RETURNS DECIMAL(18,2)
AS
BEGIN
		DECLARE @dblTotalEntrada DECIMAL(18,2)		
		DECLARE @intFolio int

		SELECT @intFolio = strFolio FROM tbFacXP WHERE intEmpresa = @intEmpresa AND intProveedor = @intProveedor AND strFactura = @strFactura

		SELECT @dblTotalEntrada = dblTotalRecibido * dblTipoCambio
		FROM VetecMarfil..tbOrdenCompraEnc WHERE intEmpresa = @intEmpresa AND intFolio = @intFolio

	
		RETURN ISNULL(@dblTotalEntrada,0)
END
GO

-- Display the status of Proc creation
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.fn_tbFacXP_MontoEntrada')
	AND OBJECTPROPERTY(id,N'IsScalarFunction') = 1)
BEGIN
    PRINT 'Function Creation: dbo.fn_tbFacXP_MontoEntrada - Succeeded !!!'
END
ELSE
BEGIN
    PRINT 'Function Creation: dbo.fn_tbFacXP_MontoEntrada - Error on Creation'
END
GO


