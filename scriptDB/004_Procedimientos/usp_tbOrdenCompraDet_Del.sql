
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbOrdenCompraDet_Del')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbOrdenCompraDet_Del
	PRINT N'Drop Procedure : dbo.usp_tbOrdenCompraDet_Del - Succeeded !!!'
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

CREATE PROCEDURE [dbo].[usp_tbOrdenCompraDet_Del]     
(        
	@intEmpresa INT,        
	@intSucursal INT,               
	@intOrdenCompraEnc INT,
	@intOrdenCompraDet int        
)  
AS  
BEGIN
	
	DECLARE @intObra int
	DECLARE @intArticulo int
	DECLARE @dblCantidad decimal(18,6)

	SELECT @intObra = intObra 
	FROM tbOrdenCompraEnc WHERE intEmpresa = @intEmpresa and intOrdenCompraEnc = @intOrdenCompraEnc

	SELECT @intArticulo = intArticulo, @dblCantidad = dblCantidad 
	FROM tbOrdenCompraDet 
	WHERE intEmpresa=@intEmpresa 
	AND intSucursal=@intSucursal       
	AND intOrdenCompraEnc=@intOrdenCompraEnc 
	AND intOrdenCompraDet = @intOrdenCompraDet

	UPDATE tbControlObra_Compras 
	SET Cantidad_Comprada = Cantidad_Comprada - @dblCantidad 
	WHERE intEmpresa=@intEmpresa and intObra=@intObra and intArticulo=@intArticulo	

	IF(@@Error = 0)
	BEGIN
		DELETE FROM tbOrdenCompraDet  
		WHERE intEmpresa=@intEmpresa 
		AND intSucursal=@intSucursal       
		AND intOrdenCompraEnc=@intOrdenCompraEnc 
		AND intOrdenCompraDet = @intOrdenCompraDet
	END

END
GO 

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbOrdenCompraDet_Del Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbOrdenCompraDet_Del Error on Creation'
END
GO




