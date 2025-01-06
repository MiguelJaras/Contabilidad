
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbCuentas_Sel')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbCuentas_Sel
	PRINT N'Drop Procedure : dbo.usp_tbCuentas_Sel - Succeeded !!!'
END
GO

------------------------------------------------------------------------------------
---   Aplicacion: Abasto.		                                                 ---
---        Autor: Ramón Rios Hernandez                                           ---
---  Descripcion: Obtiene un registro de la tabla:  usp_tbCuentas		         ---
---                                                                              ---
------------------------------------------------------------------------------------
---    Fecha     Autor  Comentario                                               ---
---  ----------  -----  -------------------------------------------------------  ---
---  09/07/2013  RRH    Create procedure                                         ---
------------------------------------------------------------------------------------
CREATE PROCEDURE usp_tbCuentas_Sel
	 @intEmpresa INT
	,@strCuenta  VARCHAR(50)
AS
BEGIN
	SET NOCOUNT ON
		
	SELECT C.strClasifEnc,C.strCuenta,REPLACE(C.strNombre,'/','') AS strNombre,C.strNombreCorto,C.intNivel,C.intCtaRegistro,C.intIndAuxiliar,
	case ISNULL(C.intIndAuxiliar,0)when 1 then cast(1 as bit)else cast(0 as bit)end as Auxiliar,
	C.intAcceso,C.intTipoGrupoContable,TGC.strNombre AS Tipo_GrupoContable,C.intGrupoContable,GC.strNombre AS GrupoContable,
	C.intTipoGasto,C.intIndBloqueo,C.intEjercicioBloq,C.intMesBloq,C.intIndInterEmpresa,C.intInterEmpresa,C.strAuditAlta,
	C.strAuditMod,ISNULL(strCodigoAgrupador,'') AS strCodigoAgrupador
	FROM VetecMarfilAdmin..tbCuentas C
	LEFT JOIN tbTiposGruposContables TGC ON TGC.intTipoGrupoContable = C.intTipoGrupoContable
	LEFT JOIN tbGruposContables GC ON GC.intGrupoContable =  C.intGrupoContable AND TGC.intTipoGrupoContable = GC.intTipoGrupoContable
	WHERE C.intEmpresa = CASE ISNULL(@intEmpresa,0) WHEN 0 THEN C.intEmpresa ELSE ISNULL(@intEmpresa,0) END
	AND  C.strCuenta = CASE ISNULL(@strCuenta,'0') WHEN '0' THEN C.strCuenta ELSE ISNULL(@strCuenta,'0') END 

	SET NOCOUNT OFF
END 	
GO 

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbCuentas_Sel Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbCuentas_Sel Error on Creation'
END
GO 
 
