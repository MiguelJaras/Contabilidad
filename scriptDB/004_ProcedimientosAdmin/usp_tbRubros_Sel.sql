IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbRubros_Sel')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbRubros_Sel
	PRINT N'Drop Procedure : dbo.usp_tbRubros_Sel - Succeeded !!!'
END
GO

------------------------------------------------------------------------------------
---   Aplicacion: Abasto.		                                                 ---
---        Autor: Ramón Rios Hernandez                                           ---
---  Descripcion: Obtiene un registro de la tabla:  usp_tbRubros		         ---
---                                                                              ---
------------------------------------------------------------------------------------
---    Fecha     Autor  Comentario                                               ---
---  ----------  -----  -------------------------------------------------------  ---
---  09/07/2013  RRH    Create procedure                                         ---
------------------------------------------------------------------------------------
CREATE PROCEDURE usp_tbRubros_Sel
(
	@intEmpresa INT,
	@strCuenta  VARCHAR(50)
)
WITH ENCRYPTION
AS
BEGIN
	SET NOCOUNT ON
		
	SELECT C.strClasifEnc,C.strCuenta,C.strNombre,C.strNombreCorto,C.intNivel,C.intCtaRegistro,C.intIndAuxiliar,
	CASE ISNULL(C.intIndAuxiliar,0)when 1 then cast(1 as bit)else cast(0 as bit)end as Auxiliar,intAcceso,
	C.intTipoGrupoContable,TGC.strNombre AS Tipo_GrupoContable,C.intGrupoContable,
	CASE WHEN C.intGrupoContable = 1 THEN 'ACREEDOR' ELSE 'DEUDOR' END AS GrupoContable,0 AS intTipoGasto,0 AS intIndBloqueo,
	0 AS intEjercicioBloq,0 AS intMesBloq,0 AS intIndInterEmpresa,0 AS intInterEmpresa,	C.strAuditAlta,C.strAuditMod
	FROM VetecMarfilAdmin..tbRubros C
	LEFT JOIN tbTiposGruposContables TGC ON TGC.intTipoGrupoContable = C.intTipoGrupoContable
	WHERE C.intEmpresa = CASE ISNULL(@intEmpresa,0) WHEN 0 THEN C.intEmpresa ELSE ISNULL(@intEmpresa,0) END
	AND  C.strCuenta = CASE ISNULL(@strCuenta,'0') WHEN '0' THEN C.strCuenta ELSE ISNULL(@strCuenta,'0') END 

	SET NOCOUNT OFF
END 	
GO 

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbRubros_Sel Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbRubros_Sel Error on Creation'
END
GO 
 

