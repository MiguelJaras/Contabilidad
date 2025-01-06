
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbEstructuraEnc_Sel')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbEstructuraEnc_Sel
	PRINT N'Drop Procedure : dbo.usp_tbEstructuraEnc_Sel - Succeeded !!!'
END
GO

------------------------------------------------------------------------------------
---   Aplicacion: Abasto.		                                                 ---
---        Autor: Ramón Rios Hernandez                                           ---
---  Descripcion: Obtiene un registro de la tabla:  usp_tbEstructuraEnc	         ---
---                                                                              ---
------------------------------------------------------------------------------------
---    Fecha     Autor  Comentario                                               ---
---  ----------  -----  -------------------------------------------------------  ---
---  28/06/2013  RRH    Create procedure                                         ---
------------------------------------------------------------------------------------
CREATE PROCEDURE usp_tbEstructuraEnc_Sel
	 @intEmpresa int
	,@intMovto int
AS
BEGIN
	SET NOCOUNT ON
		SELECT DISTINCT E.intClave,
			E.strTipoPoliza,
			E.strDescripciónPoliza,
			E.strDescrcipcion,
			E.bitAutomatica,
			E.intMovto,
			P.strNombre AS strNombrePoliza,
			M.strNombre AS strNombreTipoMovto
		FROM VetecMarfilAdmin..tbEstructuraEnc E
		LEFT JOIN VetecMarfilAdmin..tbTipoMovto M ON E.intMovto = M.intMovto
		LEFT JOIN VetecMarfilAdmin..tbTiposPoliza P ON E.strTipoPoliza = P.strTipoPoliza
		WHERE E.intEmpresa = CASE ISNULL(@intEmpresa,0) WHEN 0 THEN E.intEmpresa ELSE ISNULL(@intEmpresa,0) END
		AND E.intMovto = CASE ISNULL(@intMovto,0) WHEN 0 THEN E.intMovto ELSE ISNULL(@intMovto,0) END
	END 
	SET NOCOUNT OFF
GO 

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbEstructuraEnc_Sel Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbEstructuraEnc_Sel Error on Creation'
END
GO
