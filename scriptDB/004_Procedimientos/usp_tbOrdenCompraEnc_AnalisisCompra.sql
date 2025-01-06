

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbOrdenCompraEnc_AnalisisCompra')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbOrdenCompraEnc_AnalisisCompra
	PRINT N'Drop Procedure : dbo.usp_tbOrdenCompraEnc_AnalisisCompra - Succeeded !!!'
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


CREATE PROCEDURE [dbo].[usp_tbOrdenCompraEnc_AnalisisCompra]
(
	@intEmpresa			int, 
	@datFechaIni		VARCHAR(12),
	@datFechaFin		VARCHAR(12),
	@strObraIni			VARCHAR(50),
	@strObraFin			VARCHAR(50),
	@intProveedor		int,
	@intProveedorFin	int,
	@strInsumo			VARCHAR(10),
	@strInsumoFin		VARCHAR(10)
)
AS
BEGIN
		
	SET NOCOUNT ON
		
		DECLARE @strEmpresa VARCHAR(150)	
		CREATE TABLE #Obras(intObra int)
		CREATE TABLE #Insumos(intArticulo int)

		CREATE TABLE #Data(strObra varchar(200), strNombreObra varchar(200),OrdenCompra int, datFecha datetime,
		intProveedor int, Proveedor varchar(200), intInsumo int, Insumo varchar(200), Cantidad decimal(18,4), UnidadMedida varchar(200),
		dblImporte decimal(18,2), dblPrecio decimal(18,2), intObra INT)

		INSERT INTO #Obras(intObra)
		SELECT intObra
		FROM tbObra
		WHERE intEmpresa = @intEmpresa
		AND ((@strObraIni = '0') OR (strClave BETWEEN @strObraIni AND @strObraFin))

		INSERT INTO #Insumos(intArticulo)
		SELECT intArticulo
		FROM tbArticulo
		WHERE intEmpresa = @intEmpresa
		AND ((@strInsumo = '0') OR (strNombreCorto BETWEEN @strInsumo AND @strInsumoFin))

		INSERT INTO #Data(strObra,strNombreObra,OrdenCompra,datFecha,intProveedor,Proveedor,intInsumo,Insumo,Cantidad,
		UnidadMedida,dblImporte, dblPrecio, intObra)
		SELECT O.strClave, O.strNombre,OC.intFolio,OC.datFecha,OC.intProveedor,P.strNombre,A.strNombreCorto,A.strNombre,
		OCD.dblCantidad,U.strNombre, OCD.dblTotal, OCD.dblPrecio, OC.intObra
		FROM tbOrdenCompraENC OC
		INNER JOIN tbOrdenCompraDet OCD ON OCD.intOrdenCompraEnc = OC.intOrdenCompraEnc
		INNER JOIN tbArticulo A ON A.intArticulo = OCD.intArticulo AND A.intEmpresa = OC.intEmpresa
		INNER JOIN tbFamilia F ON F.intFamilia = A.intFamilia AND F.intEmpresa = OC.intEmpresa
		INNER JOIN tbUnidadMedida U ON U.intUnidadMedida = A.intUnidadMedidaCompra 
		INNER JOIN VetecMarfilAdmin..tbProveedores P ON P.intProveedor = OC.intProveedor AND P.intEmpresa = OC.intEmpresa
		LEFT JOIN tbObra O ON O.intEmpresa = OC.intEmpresa AND O.intObra = OC.intObra
		WHERE OC.intEmpresa = @intEmpresa
		AND OC.intObra IN(SELECT intObra FROM #Obras)
		AND OCD.intArticulo IN(SELECT intArticulo FROM #Insumos)
		AND ((@intProveedor = 0) OR (OC.intProveedor BETWEEN @intProveedor AND @intProveedorFin))
		AND OC.datFecha BETWEEN @datFechaIni AND @datFechaFin
		AND OC.intEstatus <> 9
			
		SELECT @strEmpresa = E.strNombre FROM VetecMarfilAdmin.dbo.tbEmpresas E WHERE E.intEmpresa = @intEmpresa

		SELECT strObra,strNombreObra,OrdenCompra,datFecha,intProveedor,Proveedor,intInsumo,Insumo,Cantidad,
		UnidadMedida,dblImporte, dblPrecio,
		datFechaIni = @datFechaIni,
		datFechaFin = @datFechaFin,		
		strEmpresa = @strEmpresa,
		intObra
		FROM #Data

		DROP TABLE #Data
		DROP TABLE #Obras
		DROP TABLE #Insumos


	SET NOCOUNT OFF
END
GO 

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbOrdenCompraEnc_AnalisisCompra Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbOrdenCompraEnc_AnalisisCompra Error on Creation'
END
GO



