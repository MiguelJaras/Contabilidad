
/****** Object:  StoredProcedure [dbo.usp_tbFacXP_Poliza]    Script Date: 12/8/2009 10:45:19 AM ******/
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbTiposPoliza_Fill')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbTiposPoliza_Fill
	PRINT N'Drop Procedure : dbo.usp_tbTiposPoliza_Fill - Succeeded !!!'
END
GO

------------------------------------------------------------------------------------
---   Aplicacion: Marfil.		                                                 ---
---        Autor: Ingrid Soto Dimas							                      ---
---  Descripcion: Selecciona registros de la tabla:tbTiposPoliza                 ---
---                                                                              ---
------------------------------------------------------------------------------------
---    Fecha     Autor  Comentario                                               ---
---  ----------  -----  -------------------------------------------------------  ---
---  13/08/2013  IASD    Create procedure                                         ---
------------------------------------------------------------------------------------    

CREATE  PROCEDURE [dbo].[usp_tbTiposPoliza_Fill]
(
	@intEmpresa		int,
	@intEjercicio	int
)
AS
BEGIN


	SELECT  DISTINCT ISNULL(strTipoPoliza,'') + ' - ' + ISNULL(strNombre,'') AS strNombreCbo,
			ISNULL(intEmpresa,0)intEmpresa,
			ISNULL(strClasifEnc,'')strClasifEnc,
			ISNULL(strTipoPoliza,'')strTipoPoliza,
			ISNULL(strNombre,'')strNombre,
			ISNULL(strNombreCorto,'')strNombreCorto,
			ISNULL(intCapturable,0)intCapturable,
			ISNULL(intEjercicio,0)intEjercicio,
			ISNULL(intM1,0)intM1,
			ISNULL(intM2,0)intM2,
			ISNULL(intM3,0)intM3,
			ISNULL(intM4,0)intM4,
			ISNULL(intM5,0)intM5,
			ISNULL(intM6,0)intM6,
			ISNULL(intM7,0)intM7,
			ISNULL(intM8,0)intM8,
			ISNULL(intM9,0)intM9,
			ISNULL(intM10,0)intM10,
			ISNULL(intM11,0)intM11,
			ISNULL(intM12,0)intM12,
			ISNULL(strAuditAlta,'')strAuditAlta,
			ISNULL(strAuditMod,'')strAuditMod
	FROM VetecMarfilAdmin..tbTiposPoliza
	WHERE intEmpresa = @intEmpresa
	AND ((intEjercicio = 0) OR (intEjercicio= @intEjercicio))

	SET NOCOUNT OFF
	
END
GO

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbTiposPoliza_Fill Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbTiposPoliza_Fill Error on Creation'
END
GO





