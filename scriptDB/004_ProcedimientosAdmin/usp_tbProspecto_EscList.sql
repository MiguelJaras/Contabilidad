

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbProspecto_EscList')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbProspecto_EscList
	PRINT N'Drop Procedure : dbo.usp_tbProspecto_EscList - Succeeded !!!'
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

CREATE PROCEDURE dbo.usp_tbProspecto_EscList
(	
	@intEmpresa		int,
	@intSucursal	int,
	@intColonia		int,		
	@intDireccion	int,
	@SortExpression 	varchar(50),
	@bAplicado		int,
	@intEjercicio	int,
	@intMes			int
)
WITH ENCRYPTION
AS
BEGIN
	SET NOCOUNT ON

		DECLARE @Sort varchar(200)
		DECLARE @FechaFinal datetime

		SET @Sort = LOWER(@SortExpression) + CASE WHEN @intDireccion = 0 THEN ' DESC' ELSE ' ASC' END

		IF(@bAplicado = 1)
		BEGIN
			SELECT E.intProspecto, E.strNombreCliente as Prospecto, CASE WHEN intEmpresaTerreno = 1 THEN 'Fideicomiso' ELSE
			CASE WHEN intEmpresaTerreno = 2 THEN 'Desarrollo' ELSE 'Maple' END END AS Terreno, 
			Convert(varchar,E.datFechaEscrituracion,103) AS datFechaEscrituracion, T.strNombre AS TipoCredito,
			E.strColonia,E.strColonia,ISNULL(E.strPoliza,'') AS strPoliza, ISNULL(E.strPolizaTerreno,'') AS strPolizaTerreno, dbo.fn_PrecioTerreno(E.intProspecto) AS dblTerreno,
			ISNULL(dbo.fn_PrecioEdificacion(E.intProspecto),0) AS dblEdificacion,intEmpresaTerreno, YEAR(E.datFechaEscrituracion) AS intEjercicio
			FROM tbInterfase_Escrituracion E
			INNER JOIN tbProspecto P ON P.intProspecto = E.intProspecto
			INNER JOIN tbTipoCredito T ON T.intTipoCredito = E.intTipoCredito
			WHERE ((@intColonia = 0) OR (P.intColonia = @intColonia))
			AND ISNULL(strPoliza,'') <> ''
			AND YEAR(E.datFechaEscrituracion) = @intEjercicio
			AND MONTH(E.datFechaEscrituracion) = @intMes
			ORDER BY 
				CASE WHEN @Sort = 'intProspecto DESC' THEN E.intProspecto END DESC,
				CASE WHEN @Sort = 'intProspecto ASC' THEN E.intProspecto END ASC,
				CASE WHEN @Sort = 'Prospecto DESC' THEN E.strNombreCliente END DESC,
				CASE WHEN @Sort = 'Prospecto ASC' THEN E.strNombreCliente END ASC,
				CASE WHEN @Sort = 'Terreno DESC' THEN E.intEmpresaTerreno END DESC,
				CASE WHEN @Sort = 'Terreno ASC' THEN E.intEmpresaTerreno END ASC,
				CASE WHEN @Sort = 'Fecha DESC' THEN E.datFechaEscrituracion END DESC,
				CASE WHEN @Sort = 'Fecha ASC' THEN E.datFechaEscrituracion END ASC,
				CASE WHEN @Sort = 'TipoCredito DESC' THEN T.strNombre END DESC,
				CASE WHEN @Sort = 'TipoCredito ASC' THEN T.strNombre END ASC,
				CASE WHEN @Sort = 'strColonia DESC' THEN E.strColonia END DESC,
				CASE WHEN @Sort = 'strColonia ASC' THEN E.strColonia END ASC,
				CASE WHEN @Sort = 'Poliza DESC' THEN isnull(E.strPoliza,'') END DESC,
				CASE WHEN @Sort = 'Poliza ASC' THEN isnull(E.strPoliza,'') END ASC
		END
		
		IF(@bAplicado = 0)
		BEGIN
			SELECT E.intProspecto, E.strNombreCliente as Prospecto, CASE WHEN intEmpresaTerreno = 1 THEN 'Fideicomiso' ELSE
			CASE WHEN intEmpresaTerreno = 2 THEN 'Desarrollo' ELSE 'Maple' END END AS Terreno, 
			Convert(varchar,E.datFechaEscrituracion,103) AS datFechaEscrituracion, T.strNombre AS TipoCredito,
			E.strColonia,ISNULL(E.strPoliza,'') AS strPoliza, ISNULL(E.strPolizaTerreno,'') AS strPolizaTerreno, dbo.fn_PrecioTerreno(E.intProspecto) AS dblTerreno,
			ISNULL(dbo.fn_PrecioEdificacion(E.intProspecto),0) AS dblEdificacion,intEmpresaTerreno,YEAR(E.datFechaEscrituracion) AS intEjercicio
			FROM tbInterfase_Escrituracion E
			INNER JOIN tbProspecto P ON P.intProspecto = E.intProspecto
			INNER JOIN tbTipoCredito T ON T.intTipoCredito = E.intTipoCredito
			WHERE ((@intColonia = 0) OR (P.intColonia = @intColonia))
			AND ISNULL(strPoliza,'') = ''
			AND YEAR(E.datFechaEscrituracion) = @intEjercicio
			AND MONTH(E.datFechaEscrituracion) = @intMes
			ORDER BY 
				CASE WHEN @Sort = 'intProspecto DESC' THEN E.intProspecto END DESC,
				CASE WHEN @Sort = 'intProspecto ASC' THEN E.intProspecto END ASC,
				CASE WHEN @Sort = 'Prospecto DESC' THEN E.strNombreCliente END DESC,
				CASE WHEN @Sort = 'Prospecto ASC' THEN E.strNombreCliente END ASC,
				CASE WHEN @Sort = 'Terreno DESC' THEN E.intEmpresaTerreno END DESC,
				CASE WHEN @Sort = 'Terreno ASC' THEN E.intEmpresaTerreno END ASC,
				CASE WHEN @Sort = 'Fecha DESC' THEN E.datFechaEscrituracion END DESC,
				CASE WHEN @Sort = 'Fecha ASC' THEN E.datFechaEscrituracion END ASC,
				CASE WHEN @Sort = 'TipoCredito DESC' THEN T.strNombre END DESC,
				CASE WHEN @Sort = 'TipoCredito ASC' THEN T.strNombre END ASC,
				CASE WHEN @Sort = 'strColonia DESC' THEN E.strColonia END DESC,
				CASE WHEN @Sort = 'strColonia ASC' THEN E.strColonia END ASC,
				CASE WHEN @Sort = 'Poliza DESC' THEN isnull(E.strPoliza,'') END DESC,
				CASE WHEN @Sort = 'Poliza ASC' THEN isnull(E.strPoliza,'') END ASC
		END

		IF(@bAplicado = 2)
		BEGIN
			SELECT E.intProspecto, E.strNombreCliente as Prospecto, CASE WHEN intEmpresaTerreno = 1 THEN 'Fideicomiso' ELSE
			CASE WHEN intEmpresaTerreno = 2 THEN 'Desarrollo' ELSE 'Maple' END END AS Terreno, 
			Convert(varchar,E.datFechaEscrituracion,103) AS datFechaEscrituracion, T.strNombre AS TipoCredito,
			E.strColonia,ISNULL(E.strPoliza,'') AS strPoliza, ISNULL(E.strPolizaTerreno,'') AS strPolizaTerreno, dbo.fn_PrecioTerreno(E.intProspecto) AS dblTerreno,
			ISNULL(dbo.fn_PrecioEdificacion(E.intProspecto),0) AS dblEdificacion,intEmpresaTerreno, YEAR(E.datFechaEscrituracion) AS intEjercicio, ISNULL(E.strPolizaTerreno,'') AS strPolizaTerreno
			FROM tbInterfase_Escrituracion E
			INNER JOIN tbProspecto P ON P.intProspecto = E.intProspecto
			INNER JOIN tbTipoCredito T ON T.intTipoCredito = E.intTipoCredito
			WHERE ((@intColonia = 0) OR (P.intColonia = @intColonia))
			AND YEAR(E.datFechaEscrituracion) = @intEjercicio
			AND MONTH(E.datFechaEscrituracion) = @intMes
			ORDER BY 
				CASE WHEN @Sort = 'intProspecto DESC' THEN E.intProspecto END DESC,
				CASE WHEN @Sort = 'intProspecto ASC' THEN E.intProspecto END ASC,
				CASE WHEN @Sort = 'Prospecto DESC' THEN E.strNombreCliente END DESC,
				CASE WHEN @Sort = 'Prospecto ASC' THEN E.strNombreCliente END ASC,
				CASE WHEN @Sort = 'Terreno DESC' THEN E.intEmpresaTerreno END DESC,
				CASE WHEN @Sort = 'Terreno ASC' THEN E.intEmpresaTerreno END ASC,
				CASE WHEN @Sort = 'Fecha DESC' THEN E.datFechaEscrituracion END DESC,
				CASE WHEN @Sort = 'Fecha ASC' THEN E.datFechaEscrituracion END ASC,
				CASE WHEN @Sort = 'TipoCredito DESC' THEN T.strNombre END DESC,
				CASE WHEN @Sort = 'TipoCredito ASC' THEN T.strNombre END ASC,
				CASE WHEN @Sort = 'strColonia DESC' THEN E.strColonia END DESC,
				CASE WHEN @Sort = 'strColonia ASC' THEN E.strColonia END ASC,
				CASE WHEN @Sort = 'Poliza DESC' THEN isnull(E.strPoliza,'') END DESC,
				CASE WHEN @Sort = 'Poliza ASC' THEN isnull(E.strPoliza,'') END ASC
		END
		

	SET NOCOUNT OFF
END
GO 

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbProspecto_EscList Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbProspecto_EscList Error on Creation'
END
GO



