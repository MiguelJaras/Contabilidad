
/****** Object:  StoredProcedure [dbo.usp_tbPUTarjetas_RepDet]    Script Date: 12/8/2009 10:45:19 AM ******/
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbOrdenCompraDet_FillById')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbOrdenCompraDet_FillById
	PRINT N'Drop Procedure : dbo.usp_tbOrdenCompraDet_FillById - Succeeded !!!'
END
GO

------------------------------------------------------------------------------------
---   Aplicacion: Marfil.		                                                 ---
---        Autor: Rubén Mora Martínez                                            ---
---  Descripcion: Obtiene un registro de la tabla:  Tareas	                     ---
---                                                                              ---
------------------------------------------------------------------------------------
---    Fecha     Autor  Comentario                                               ---
---  ----------  -----  -------------------------------------------------------  ---
---  12/11/2010  RMM    Create procedure                                         ---
------------------------------------------------------------------------------------

CREATE PROCEDURE dbo.usp_tbOrdenCompraDet_FillById
(          
	@intEmpresa INT,          	                
	@intOrdenCompraEnc INT,
	@intOrdenCompraDet int
)          
AS          
BEGIN
	
	SELECT RD.intOrdenCompraDet, RD.intPartida,RD.intArticulo,A.strNombreCorto,ISNULL(RD.strComentario,'') AS strNombre,
	RD.dblCantidad,M.strNombre AS Unidad,CONVERT(varchar,RD.datFechaEntrega,103) AS datFechaEntrega, dblPrecio	
	FROM tbOrdenCompraDet RD
	INNER JOIN tbArticulo A ON A.intArticulo = RD.intArticulo AND A.intEmpresa = RD.intEmpresa
	INNER JOIN tbUnidadMedida M ON M.intUnidadMedida = A.intUnidadMedidaCompra
	WHERE RD.intEmpresa = @intEmpresa
	AND RD.intOrdenCompraEnc = @intOrdenCompraEnc
	AND RD.intOrdenCompraDet = @intOrdenCompraDet
	ORDER BY RD.intPartida

END
GO

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbOrdenCompraDet_FillById Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbOrdenCompraDet_FillById Error on Creation'
END
GO

