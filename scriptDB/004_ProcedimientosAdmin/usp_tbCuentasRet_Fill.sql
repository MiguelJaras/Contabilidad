IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbCuentasRet_Fill')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbCuentasRet_Fill
	PRINT N'Drop Procedure : dbo.usp_tbCuentasRet_Fill - Succeeded !!!'
END
GO

------------------------------------------------------------------------------------
---   Aplicacion: Abasto.		                                                 ---
---        Autor: Ramón Rios Hernandez                                           ---
---  Descripcion: Obtiene un registro de la tabla:  tbCuentasRet		         ---
---                                                                              ---
------------------------------------------------------------------------------------
---    Fecha     Autor  Comentario                                               ---
---  ----------  -----  -------------------------------------------------------  ---
---  12/08/2013  RRH    Create procedure                                         ---
------------------------------------------------------------------------------------
CREATE PROCEDURE usp_tbCuentasRet_Fill
(
	@intEmpresa					  INT,
	@intCuentaRet				  INT 
)				
AS
				
    BEGIN
    SET NOCOUNT ON
	 SELECT CR.intEmpresa,
			CR.intCuentaRet,
			CR.intArea,
			A.strNombre AS strNombreArea,
			CR.strInsumoIni,
			ISNULL(ArtIni.strNombre,'INSUMO N.E') AS NombreInsumoIni,
			CR.strInsumoFin, 
			ISNULL(ArtFin.strNombre,'INSUMO N.E') AS NombreInsumoFin,
			CR.strCuentaCargo,
			CtaCargo.strNombre AS NombreCuentaCargo,
			CR.strCuentaAbono,
			CtaAbono.strNombre AS NombreCuentaAbono,
			CASE WHEN CR.intES = 1 THEN 'Entrada' ELSE 'Salida' END AS NombreEstatus,
 		    CR.intES
	   FROM tbCuentasRet CR
 INNER JOIN VetecMarfil.dbo.tbArea A 
		 ON A.intArea = CR.intArea 
		AND A.intEmpresa = CR.intEmpresa

  LEFT JOIN VetecMarfil.dbo.tbArticulo ArtIni 
		 ON ArtIni.strNombreCorto COLLATE Modern_Spanish_CI_AS  = CR.strInsumoIni COLLATE Modern_Spanish_CI_AS  
		AND ArtIni.intEmpresa = CR.intEmpresa

  LEFT JOIN VetecMarfil.dbo.tbArticulo ArtFin 
		 ON ArtFin.strNombreCorto COLLATE Modern_Spanish_CI_AS  = CR.strInsumoFin COLLATE Modern_Spanish_CI_AS  
		AND ArtFin.intEmpresa = CR.intEmpresa

 INNER JOIN tbCuentas CtaCargo
		 ON CtaCargo.strCuenta = REPLACE(CR.strCuentaCargo,'-','')
		AND CtaCargo.intEmpresa = CR.intEmpresa

 INNER JOIN tbCuentas CtaAbono
		 ON CtaAbono.strCuenta = REPLACE(CR.strCuentaAbono,'-','')
		AND CtaAbono.intEmpresa = CR.intEmpresa

	  WHERE CR.intEmpresa = CASE ISNULL(@intEmpresa,0) WHEN 0 THEN CR.intEmpresa ELSE ISNULL(@intEmpresa,0) END
	    AND CR.intCuentaRet = CASE ISNULL(@intCuentaRet,0) WHEN 0 THEN CR.intCuentaRet ELSE ISNULL(@intCuentaRet,0) END 
 
 END 
	SET NOCOUNT OFF
GO 

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbCuentasRet_Fill Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbCuentasRet_Fill Error on Creation'
END
GO