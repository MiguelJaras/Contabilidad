

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbColonia_Sel')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbColonia_Sel
	PRINT N'Drop Procedure : dbo.usp_tbColonia_Sel - Succeeded !!!'
END
GO

------------------------------------------------------------------------------------
---																				 ---
---        Autor: Ingrid Soto		                                             ---
---  Descripcion: Consulta en tbColonia											 ---
---                                                                              ---
------------------------------------------------------------------------------------
---    Fecha     Autor  Comentario                                               ---
---  ----------  -----  -------------------------------------------------------  ---
---  17/09/2013  IASD    Create procedure                                         ---
------------------------------------------------------------------------------------
CREATE 
PROCEDURE [dbo].[usp_tbColonia_Sel]

AS
BEGIN
	SET NOCOUNT ON
                
				SELECT
					ISNULL(intEmpresa,0) AS intEmpresa,
					ISNULL(intSucursal,0) AS intSucursal,
					ISNULL(intColonia,0) AS intColonia,
					ISNULL(strNombre,'') AS  strNombre,
					ISNULL(strNombreCorto,'') AS strNombreCorto,
					ISNULL(dblFactorMercado,0) AS dblFactorMercado,
					ISNULL(dblPorcentajeIndirecto,0) AS dblPorcentajeIndirecto,
					ISNULL(strTipo,'') AS strTipo,
					ISNULL(strUsuarioAlta,'') AS strUsuarioAlta,
					ISNULL(strMaquinaAlta,'') AS strMaquinaAlta,
					ISNULL(datFechaAlta,'01/01/1900') AS datFechaAlta,
					ISNULL(strUsuarioMod,'') AS strUsuarioMod,
					ISNULL(strMaquinaMod,'') AS strUsuarioMod,
					ISNULL(datFechaMod,'01/01/1900') AS datFechaMod,
					ISNULL(intTipoVivienda,0) AS intTipoVivienda,
					ISNULL(intMunicipio,0) AS intMunicipio,
					ISNULL(intEstado,0) AS intEstado ,
					ISNULL(strCP,'') AS strCP,
					ISNULL(intPuntoTamanio,0) AS intPuntoTamanio,
					ISNULL(intArea,0) AS  intArea,
					ISNULL(intActivo,0) AS  intActivo,
					ISNULL(intEmpleado,0) AS intEmpleado,
					ISNULL(strAliasSQL,'') AS  strAliasSQL,
					ISNULL(strAliasResumenSQL,'') AS  strAliasResumenSQL
                FROM   VetecMarfil..tbColonia A
				ORDER BY strNombre ASC
END
GO 

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbColonia_Sel Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbColonia_Sel Error on Creation'
END
GO
