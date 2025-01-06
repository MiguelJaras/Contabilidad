set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go


------------------------------------------------------------------------------------
---   Aplicacion: MARFIL						                                 ---
---        Autor: Ruben Mora Martinez                                            ---
---  Descripcion: Reporte Movimientos Conciliados	                             ---

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbOrdenCompraEnc_AnaliticoComprasProveedor')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbOrdenCompraEnc_AnaliticoComprasProveedor
	PRINT N'Drop Procedure : dbo.usp_tbOrdenCompraEnc_AnaliticoComprasProveedor - Succeeded !!!'
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


CREATE PROCEDURE [dbo].[usp_tbOrdenCompraEnc_AnaliticoComprasProveedor]
(
	@intEmpresa			INT, 
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

		CREATE TABLE #Obras(intObra int)
		CREATE TABLE #Insumos(intArticulo int)

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
	
		SELECT	strEmpresa = E.strNombre,intObra = OC.intObra,strObra = O.strNombre,strClaveObra = O.strClave,
				strInsumo = OCD.strArticulo,strNombreInsumo = A.strNombre,datFecha = OC.datFecha,intFolio = OC.intFolio,
				intProveedor = OC.intProveedor,strProveedor = P.strNombre,dblCantidadComprada = OCD.dblCantidad,
				dblPrecio = OCD.dblPrecio,intTipoCambio = 1,dblImporte = OCD.dblTotal,dblCantidadRecibir = 0,
				strUnidadMedida = U.strNombre,dblCantidadRecibida = 0,dblCantidadPendientes = 0,dblDiasAtraso = 0
		FROM tbOrdenCompraEnc OC
		LEFT JOIN tbOrdenCompraDet OCD ON OCD.intOrdenCompraEnc = OC.intOrdenCompraEnc
		INNER JOIN tbArticulo A ON A.strNombreCorto = OCD.strArticulo COLLATE Traditional_Spanish_CI_AS AND A.intEmpresa = OC.intEmpresa		
		INNER JOIN tbUnidadMedida U ON U.intUnidadMedida = OCD.intUnidadMedida
		LEFT JOIN tbObra O ON O.intObra = OC.intObra AND O.intEmpresa = OC.intEmpresa
		INNER JOIN VetecMarfilAdmin.dbo.tbEmpresas E ON E.intEmpresa = OC.intEmpresa
		INNER JOIN VetecMarfilAdmin.dbo.tbProveedores P ON P.intProveedor = OC.intProveedor AND P.intEmpresa = OC.intEmpresa
		WHERE OC.intEmpresa = @intEmpresa
		AND OC.intObra IN(SELECT intObra FROM #Obras)
		AND OCD.intArticulo IN(SELECT intArticulo FROM #Insumos)
		AND ((@intProveedor = 0) OR (OC.intProveedor BETWEEN @intProveedor AND @intProveedorFin))
		AND OC.datFecha BETWEEN @datFechaIni AND @datFechaFin
		AND OC.intEstatus <> 9


		DROP TABLE #Obras
		DROP TABLE #Insumos

	SET NOCOUNT OFF
END
GO 

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbOrdenCompraEnc_AnaliticoComprasProveedor Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbOrdenCompraEnc_AnaliticoComprasProveedor Error on Creation'
END
GO





