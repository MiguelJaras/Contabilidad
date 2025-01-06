
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbRubros_BalanceGeneral')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbRubros_BalanceGeneral
	PRINT N'Drop Procedure : dbo.usp_tbRubros_BalanceGeneral - Succeeded !!!'
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
CREATE PROCEDURE [dbo].[usp_tbRubros_BalanceGeneral]        
(
	@intEmpresa		Int,
	@intEstadoFin	Int,  
	@intEjercicio	Int,
	@intMes			Int,
	@strCCIni		VarChar(60), 
	@strCCFin		VarChar(60)  
)       
AS    
BEGIN

	SET NOCOUNT ON

	DECLARE @intGrupoEmp Int, @strClasifEnc VarChar(60), @strClasifDP VarChar(60), @strClasifDS VarChar(60), 
	@intIndInterEmpresa Int,  @strUsuario VarChar(50), @intDivisor Int  
	SELECT @intGrupoEmp = 0,@strClasifEnc = '0',@strClasifDP = '0',@strClasifDS = '0',@intIndInterEmpresa= 2  
	SELECT @strUsuario = 'SIS', @intDivisor = 1
	
	IF @intEmpresa = 22 
	BEGIN
		SET LANGUAGE ENGLISH  
		DECLARE @datFecha VARCHAR(50)
		DECLARE @strMes VARCHAR(100)

		SET @datFecha =  CONVERT(VARCHAR,@intMes) + '/01/' + CONVERT(VARCHAR,@intEjercicio)		
		
		IF @intMes = 0
			SET @strMes = 'JAN - DEC'
		ELSE
			SELECT @strMes = DATENAME(MONTH,CONVERT(DATETIME, @datFecha))
	END

	DECLARE @dblFactorM DECIMAL(18,2)      
	SET @dblFactorM = 1   

	SELECT	F.intRubro,
			ISNULL((SELECT RE.strEtiqueta FROM tbRubroEtiqueta RE WHERE RE.intEmpresa = @intEmpresa AND RE.intRubro = RU.intRubro),RU.strNombre) AS strNombre, 
			F.strTipoRubro strTipoLinea,F.intSecuencia intNumLinea,       
			ISNULL((dbo.fn_GrupoFinMesNeto(@intEmpresa,@intEjercicio,@intMes,intEstadoFin,F.intRubro) * @dblFactorM) /@intDivisor, 0) Mes,       
			(CASE WHEN @intEmpresa = 22 THEN @strMes ELSE (SELECT strNombre FROM tbMeses WHERE intMes = @intMes) END) AS strNombreMes,        
			ISNULL((CONVERT(DECIMAL(18,2),dbo.F_GpoFinSdoFin(@intGrupoEmp, @intEmpresa, @strClasifEnc, @intEjercicio, @intMes,  @strClasifDP, @strClasifDS, @intIndInterEmpresa, intEstadoFin, F.intRubro, @strUsuario) * @dblFactorM)) /@intDivisor, 0) Acumulado,       
			0 Acum,0 as esForm,intEstadoFin,E.strNombre As strEmpresa
	FROM tbEstadosFinRubros F   	
	INNER JOIN tbRubros RU ON RU.intRubro = F.intRubro
	INNER JOIN tbEmpresas E ON E.intEmpresa = @intEmpresa
	WHERE intEstadoFin = @intEstadoFin
	AND F.intEmpresa = @intEmpresa
	ORDER BY F.intSecuencia 

	SET NOCOUNT OFF
END
GO 

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbRubros_BalanceGeneral Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbRubros_BalanceGeneral Error on Creation'
END
GO

	










