IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.fn_ValidaMontoFactura')
	AND OBJECTPROPERTY(id,N'IsScalarFunction') = 1)
BEGIN
    DROP FUNCTION dbo.fn_ValidaMontoFactura
    PRINT 'Drop Function : dbo.fn_ValidaMontoFactura - Succeeded !!!'
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

Create Function dbo.fn_ValidaMontoFactura
(
	@intEmpresa int,
	@intProveedor int,
	@intFolio	int,
	@strFactura	VARCHAR(50),
	@dblMonto	decimal(18,2)
)
returns int
As
Begin
		DECLARE @dblTotalOC DECIMAL(18,2)
		DECLARE @dblTotalFac DECIMAL(18,2)
		DECLARE @dblTipoCambioOC DECIMAL(18,2)
		DECLARE @dblTotalPagos DECIMAL(18,2)

		SELECT @dblTotalOC = dblTotal 
		FROM VetecMarfil..tbOrdenCompraEnc WHERE intEmpresa = @intEmpresa AND intFolio = @intFolio
	
		SELECT @dblTipoCambioOC = ROUND(SUM(OC.dblTotal * OC.dblTipoCambio),2)
		FROM VetecMarfil.dbo.tbOrdenCompraEnc OC 
		WHERE OC.intFolio = @intFolio AND intEmpresa = @intEmpresa

		SELECT @dblTotalPagos = ISNULL(SUM(dblMonto),0)
		FROM tbFacXPDet WHERE intEmpresa = @intEmpresa AND intProveedor = @intProveedor AND strFactura = @strFactura AND intTipoMovto IN(31,53,54,58)

		IF(@dblMonto - @dblTotalPagos > @dblTotalOC)
		BEGIN
			RAISERROR('El Monto de la Factura Sobrepasa el Monto de la Orden de Compra.',16,1)
			RETURN '0'
		END
        
        SELECT @dblTotalFac  = ISNULL(SUM(dblTotal),0)
		FROM tbFacXP WHERE CONVERT(INT, strFolio) = @intFolio AND intProveedor = @intProveedor AND intEmpresa = @intEmpresa       
   

		IF((@dblTotalFac - @dblTotalPagos) > @dblTotalOC)
		BEGIN
			RAISERROR('El monto de la factura sobrepasa la capacidad de facturación.',16,1)
			RETURN '0'
		END


End
GO

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.fn_ValidaMontoFactura')
	AND OBJECTPROPERTY(id,N'IsScalarFunction') = 1)
BEGIN
	GRANT EXECUTE ON dbo.fn_ValidaMontoFactura TO PM_Role
END
GO

-- Display the status of Proc creation
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.fn_ValidaMontoFactura')
	AND OBJECTPROPERTY(id,N'IsScalarFunction') = 1)
BEGIN
    PRINT 'Function Creation: dbo.fn_ValidaMontoFactura - Succeeded !!!'
END
ELSE
BEGIN
    PRINT 'Function Creation: dbo.fn_ValidaMontoFactura - Error on Creation'
END
GO


