

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbPolizasDet_6005')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbPolizasDet_6005
	PRINT N'Drop Procedure : dbo.usp_tbPolizasDet_6005 - Succeeded !!!'
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
--usp_tbPolizasDet_6005 1,2013,0
--( 
--	@intEmpresa		int, 
--	@intEjercicio	int,	
--	@intMes			Int	

CREATE PROCEDURE dbo.usp_tbPolizasDet_6005
( 
	@intEmpresa		int, 
	@intEjercicio	int,	
	@intMes			Int	
)
AS    
BEGIN
	SET NOCOUNT ON    

	SELECT PD.intProveedor, P.strNombre,PD.strClasifDS,SUM(CASE WHEN intTipoMovto = 0 THEN PD.dblImporte * -1 ELSE PD.dblImporte END)
	,O.strNombre
	FROM tbPolizasDet PD
	INNER JOIN tbProveedores P ON P.intProveedor = PD.intProveedor AND P.intEmpresa = PD.intEmpresa
	INNER JOIN VetecMarfil..tbObra O ON O.intObra = PD.strClasifDS
	WHERE PD.intEmpresa = @intEmpresa
	AND PD.intEjercicio = @intEjercicio
	AND ((@intMes = 0) OR (PD.intMes = @intMes))
	AND LEFT(PD.strCuenta,4) = '6005'
	AND PD.intIndAfectada = 1
	GROUP BY PD.intProveedor,P.strNombre,PD.strClasifDS,O.strNombre
	ORDER BY PD.intProveedor,PD.strClasifDS
	
	SET NOCOUNT OFF
END
GO 

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbPolizasDet_6005 Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbPolizasDet_6005 Error on Creation'
END
GO
