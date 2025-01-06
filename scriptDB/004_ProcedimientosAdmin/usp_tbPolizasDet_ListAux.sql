
USE VETECMARFILADMIN
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbPolizasDet_ListAux')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbPolizasDet_ListAux
	PRINT N'Drop Procedure : dbo.usp_tbPolizasDet_ListAux - Succeeded !!!'
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


CREATE PROCEDURE dbo.usp_tbPolizasDet_ListAux
( 
	@intEmpresa			int
)
AS    
BEGIN
	SET NOCOUNT ON 

	DECLARE @Data TABLE(Id int,strNombre varchar(200) COLLATE SQL_Latin1_General_CP1_CI_AS)

	INSERT INTO @Data(Id,strNombre)		
	SELECT intProveedor,strNombre
	FROM VetecMarfilAdmin..tbProveedores
	WHERE intEmpresa = @intEmpresa

	IF(@intEmpresa IN(2,3))
	BEGIN
		INSERT INTO @Data(Id,strNombre)	
		SELECT DISTINCT strClave,strNombre
		FROM VetecMarfil..tbClientes
		WHERE intEmpresa IN(2,3)
		UNION 
		SELECT intProspecto,strNombreCliente
		FROM VetecMarfil..tbProspecto
	END
	ELSE
	BEGIN
		INSERT INTO @Data(Id,strNombre)	
		SELECT DISTINCT strClave,strNombre
		FROM VetecMarfil..tbClientes
		WHERE intEmpresa = @intEmpresa 
	END

	SELECT DISTINCT Id, strNombre FROM @Data

	SET NOCOUNT OFF
END
GO 

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbPolizasDet_ListAux Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbPolizasDet_ListAux Error on Creation'
END
GO
