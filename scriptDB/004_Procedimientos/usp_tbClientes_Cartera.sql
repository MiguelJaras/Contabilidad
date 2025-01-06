

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbClientes_Cartera')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbClientes_Cartera
	PRINT N'Drop Procedure : dbo.usp_tbClientes_Cartera - Succeeded !!!'
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

CREATE PROCEDURE dbo.usp_tbClientes_Cartera
(	
	@intEmpresa			int,
	@intSucursal		int,
	@intColonia			int = 0,		
	@intTipoCredito		int = 0,
	@datFechaInicial	datetime,
	@datFechaFinal		datetime
)
WITH ENCRYPTION
AS
BEGIN
	SET NOCOUNT ON

		SELECT P.intProspecto, P.strNombreCliente + ' ' + P.strApellidoPaterno + ' ' + P.strApellidoMaterno AS Nombre,		
		ISNULL((SELECT SUM(M.dblImporte) FROM tbCarteraMovimientoDet M WHERE M.intCarteraDet = CD.intCarteraDet AND M.dblImporte > 0),0) AS Cobrar,
		ISNULL(ABS((SELECT SUM(M.dblImporte) FROM tbCarteraMovimientoDet M WHERE M.intCarteraDet = CD.intCarteraDet AND M.dblImporte < 0)),0) AS Pagado,
		SUM(CDM.dblImporte) as Saldo--,
		--ISNULL((SELECT * FROM VetecMarfilAdmin.dbo.tbPolizasDet WHERE intEmpresa = 3 AND strTipoPoliza = '09' AND ),'')
		FROM tbProspecto P
		INNER JOIN tbClientes CLI ON CLI.intProspecto = P.intProspecto
		INNER JOIN tbCarteraDet CD ON CD.intCliente = CLI.intCliente
		INNER JOIN tbCarteraMovimientoDet CDM ON CDM.intCarteraDet = CD.intCarteraDet
		LEFT JOIN tbColonia C ON C.intColonia = P.intColonia		
		LEFT JOIN tbTipoCredito T ON T.intTipoCredito = P.intTipoCredito
		WHERE ((@intColonia = 0) OR (P.intColonia = @intColonia))
		AND   ((@intTipoCredito = 0) OR (P.intTipoCredito = @intTipoCredito))
		AND	  CD.intEmpresa = @intEmpresa	
		GROUP BY P.intProspecto,P.strNombreCliente,P.strApellidoPaterno,P.strApellidoMaterno,CD.intCarteraDet
		HAVING SUM(CDM.dblImporte) > 0
		ORDER BY P.intProspecto

	SET NOCOUNT OFF
END
GO 

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbClientes_Cartera Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbClientes_Cartera Error on Creation'
END
GO



