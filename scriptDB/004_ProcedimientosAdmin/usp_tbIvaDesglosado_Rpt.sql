
USE VetecMarfilAdmin

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbIvaDesglosado_Rpt')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbIvaDesglosado_Rpt
	PRINT N'Drop Procedure : dbo.usp_tbIvaDesglosado_Rpt - Succeeded !!!'
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
---  22/08/2011  RMM    Create procedure                                         ---
------------------------------------------------------------------------------------
-- usp_tbIvaDesglosado_Rpt 1,2016,3
CREATE PROCEDURE dbo.usp_tbIvaDesglosado_Rpt
(		
	@intEmpresa			int,
	@intEjercicio		int,
	@intMes				int
)
WITH ENCRYPTION
AS
BEGIN

	DECLARE @Mes VARCHAR(50)
	DECLARE @Empresa VARCHAR(100)
	DECLARE @Fecha VARCHAR(50)

	SET @Fecha = '01-' + CASE WHEN @intMes < 10 THEN '0' + CONVERT(VARCHAR,@intMes) ELSE CONVERT(VARCHAR,@intMes) END + '-' + CONVERT(VARCHAR,@intEjercicio)

	SET @Mes = UPPER(DATENAME(MONTH,@Fecha))
	SELECT @Empresa = UPPER(strNombre) FROM tbEmpresas WHERE intEmpresa = @intEmpresa

	DECLARE @Data AS TABLE(intProveedor INT,strFactura VARCHAR(50),strPoliza VARCHAR(50),strPolizaBanco VARCHAR(50), dblSubTotal DECIMAL(18,2),
	dblIva DECIMAL(18,2),dblImporte DECIMAL(18,2), dblRetencion DECIMAL(18,2), dblPagado DECIMAL(18,2))
	DECLARE @Pagos AS TABLE(intProveedor INT,strFactura VARCHAR(50),dblPagos DECIMAL(18,2))
	INSERT INTO @Data(intProveedor,strFactura,strPoliza,strPolizaBanco,dblSubTotal,dblIva,dblImporte,dblRetencion,dblPagado)
	SELECT I.intProveedor, F.strFactura, I.strPoliza, I.strPolizaBanco,F.dblSubTotal,F.dblIva,F.dblImporte,F.dblRetencion,I.dblTotal
	FROM tbIvaDesglosado I
	INNER JOIN dbFacturas..tbFacturas F ON F.intProveedor = I.intProveedor AND F.strFactura collate SQL_Latin1_General_CP1_CI_AS = I.strFactura
	WHERE I.intEmpresa = @intEmpresa
	AND I.intEjercicio = @intEjercicio
	AND I.intMes = @intMes

	delete from @Data where isnull(dblSubTotal,0) = 0

	INSERT INTO @Data(intProveedor,strFactura,strPoliza,strPolizaBanco,dblSubTotal,dblIva,dblImporte,dblRetencion,dblPagado)
	SELECT I.intProveedor, I.strFactura, I.strPoliza, I.strPolizaBanco,SUM(CASE WHEN LEFT(F.strCuenta,4) in('2101','5110','5100','1520') THEN F.dblImporte ELSE 0 END),
	SUM(CASE WHEN LEFT(F.strCuenta,4) = '1160' THEN F.dblImporte ELSE 0 END),SUM(CASE WHEN LEFT(F.strCuenta,4) = '2100' THEN F.dblImporte ELSE 0 END),
	SUM(CASE WHEN LEFT(F.strCuenta,4) = '2181' THEN F.dblImporte ELSE 0 END),MAX(I.dblTotal)
	FROM tbIvaDesglosado I
	INNER JOIN tbPolizasDet F ON F.intEmpresa = I.intEmpresa AND F.strPoliza = I.strPoliza AND F.intEjercicio = I.intEjercicioRef
	WHERE I.intEmpresa = @intEmpresa
	AND I.intEjercicio = @intEjercicio
	AND I.intMes = @intMes
	AND F.strPoliza NOT IN(SELECT strPoliza FROM @Data)
	GROUP BY I.intProveedor, I.strFactura, I.strPoliza, I.strPolizaBanco
	
	SELECT @Empresa[Empresa],@Mes[Mes],D.intProveedor, P.strNombre[Proveedor], D.strFactura[Factura], D.strPoliza[Poliza], 
	D.strPolizaBanco[PolizaBanco],D.dblSubTotal[SubTotal],D.dblIva[Iva],D.dblImporte[Total],D.dblRetencion[dblRetencion],
	dblPagado[Pagos]
	FROM @Data D
	INNER JOIN tbProveedores P ON P.intEmpresa = @intEmpresa AND P.intProveedor = D.intProveedor
	ORDER BY D.intProveedor,D.strFactura

	SELECT D.intProveedor[#], P.strNombre[Proveedor], D.strFactura[Factura], D.strPoliza[Poliza], 
	D.strPolizaBanco[PolizaBanco],D.dblSubTotal[SubTotal],D.dblIva[Iva],D.dblImporte[Total],D.dblRetencion[Retencion],
	dblPagado[Pagos]
	FROM @Data D
	INNER JOIN tbProveedores P ON P.intEmpresa = @intEmpresa AND P.intProveedor = D.intProveedor
	ORDER BY D.intProveedor,D.strFactura

END
GO 

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbIvaDesglosado_Rpt Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbIvaDesglosado_Rpt Error on Creation'
END
GO