
IF EXISTS
(
  SELECT *
	FROM dbo.sysobjects
   WHERE id = OBJECT_ID(N'dbo.usp_tbEstructuraDet_Sel')
	 AND OBJECTPROPERTY(id,N'IsProcedure') = 1
)
BEGIN
    DROP PROCEDURE dbo.usp_tbEstructuraDet_Sel
    PRINT N'Drop Procedure : dbo.usp_tbEstructuraDet_Sel - Succeeded !!!'
END  
GO 
------------------------------------------------------------------------------------
---   Aplicacion: Abasto.										                 ---
---        Autor: Ramón Rios Hernandez                                           ---
---  Descripcion:																 ---
---                                                                              ---
------------------------------------------------------------------------------------
---    Fecha     Autor  Comentario                                               ---
---  ----------  -----  -------------------------------------------------------  ---
---  02/07/2013  RRH    Create procedure                                         ---
------------------------------------------------------------------------------------
CREATE PROCEDURE dbo.usp_tbEstructuraDet_Sel
(
	@intEmpresa INT,
	@intPartida INT,
	@intClave   INT
) 
AS
BEGIN  
	SELECT DISTINCT ED.intPartida,ED.intClave,ED.strCuenta,
                        ED.strSubCuentat  ,
                        ED.strSubSubCuenta,
						ED.bitCargo AS bitCargo,
						ED.bitAux AS bitAux,
						ED.bitCC AS bitCC,   
                        ED.strConcepto,
						PC.Concepto,
                        ED.strComentario,
						ED.bitModif AS bitModif,
                        ED.strBase,
						PB.Base,
                        ED.intPtaje
	FROM VetecMarfilAdmin..tbEstructuraDet ED
	INNER JOIN tbParametrosPoliza_Conceptos PC ON PC.Concepto = ED.strConcepto
	INNER JOIN tbParametrosPoliza_Bases PB ON PB.Base = ED.strBase
    WHERE ED.intEmpresa = CASE ISNULL(@intEmpresa,0) WHEN 0 THEN ED.intEmpresa ELSE ISNULL(@intEmpresa,0) END
    AND ED.intPartida = CASE ISNULL(@intPartida,0) WHEN 0 THEN ED.intPartida ELSE ISNULL(@intPartida,0) END
	AND ED.intClave = CASE ISNULL(@intClave,0) WHEN 0 THEN ED.intClave ELSE ISNULL(@intClave,0) END 

END 
GO
        
-- Display the status of Proc creation
IF (@@Error = 0) 
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbEstructuraDet_Sel Succeeded'
END 

ELSE 
	BEGIN 
		PRINT 'Procedure Creation: dbo.usp_tbEstructuraDet_Sel Error on Creation'
	END 

GO