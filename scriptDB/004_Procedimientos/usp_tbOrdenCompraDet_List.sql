
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbOrdenCompraDet_List')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbOrdenCompraDet_List
	PRINT N'Drop Procedure : dbo.usp_tbOrdenCompraDet_List - Succeeded !!!'
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

CREATE PROCEDURE [dbo].[usp_tbOrdenCompraDet_List]     
(        
	@intEmpresa int,                    
	@intOrdenCompraEnc int      
)  
AS  
BEGIN
	
	DECLARE @intObra int
	DECLARE @intTipoObra int
	DECLARE @intType int
	DECLARE @strObra varchar(50)

	SET @intType = 0
	SELECT @intObra = intObra FROM tbOrdenCompraEnc WHERE intOrdenCompraEnc = @intOrdenCompraEnc

	SELECT @intTipoObra = intTipoObra, @strObra = SUBSTRING(strClave,1,2) FROM tbObra WHERE intObra = @intObra

	IF(@intTipoObra = 11)
		SET @intType = 1

	IF(@intType <> 1)
	BEGIN
		IF (@strObra='04' or @strObra='07' or @strObra='05' or @strObra='08' or @strObra='09' or @strObra='20')
			SET @intType = 1
	END
		
	SELECT OD.intOrdenCompraEnc, OD.intOrdenCompraDet,OD.intPartida,A.intArticulo,A.strNombreCorto,
	A.strNombre + '<br />' + ISNULL(OD.strComentario,'')  AS strNombre,OD.dblCantidad,M.strNombre AS NomUnidad,
	OD.dblPrecio, Convert(varchar,OD.datFechaEntrega,103) AS datFechaEntrega,R.intEstatus,
	CASE WHEN @intType = 1 THEN 0 ELSE ISNULL((SELECT CO.Precio + ISNULL(Monto_Aditiva,0) FROM tbControlObra_Compras CO WHERE CO.intEmpresa = R.intEmpresa AND CO.intObra = @intObra AND CO.intArticulo = OD.intArticulo),0) END AS PrecioPermitido,
	dbo.fn_tbEntradaCompras_Entrada(OD.intOrdenCompraEnc,OD.intOrdenCompraDet) AS Entrada
	FROM tbOrdenCompraDet OD
	INNER JOIN tbOrdenCompraEnc R ON  R.intOrdenCompraEnc = OD.intOrdenCompraEnc
	INNER JOIN tbArticulo A ON A.intArticulo = OD.intArticulo AND A.intEmpresa = OD.intEmpresa
	INNER JOIN tbUnidadMedida M ON M.intUnidadMedida = A.intUnidadMedidaCompra
	WHERE OD.intEmpresa = @intEmpresa
	AND OD.intOrdenCompraEnc = @intOrdenCompraEnc
	ORDER BY OD.intPartida

END
GO 

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbOrdenCompraDet_List Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbOrdenCompraDet_List Error on Creation'
END
GO




