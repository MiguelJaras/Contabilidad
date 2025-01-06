
USE VetecMarfilAdmin
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.tbPolizaIngreso') AND type in (N'U'))
BEGIN
	DROP TABLE dbo.tbPolizaIngreso

	IF @@Error = 0
	BEGIN
		PRINT 'Drop Table : dbo.tbPolizaIngreso - Succeeded.'
	END
	ELSE
	BEGIN
		PRINT 'Drop Table : dbo.tbPolizaIngreso - Error !!!'
	END
END
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

------------------------------------------------------------------------------------
---   Aplicacion: Marfil.														 ---
---        Autor: Ruben Mora Martinez											 ---
---  Descripcion: Tabla donde se guardan las familias						     ---
------------------------------------------------------------------------------------
---    Fecha     Autor  Comentario                                               ---
---  ----------  -----  -------------------------------------------------------  ---
---  2010-11-21  RMM    Creacion                                                 ---
------------------------------------------------------------------------------------

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.tbPolizaIngreso') AND type in (N'U'))
BEGIN
	CREATE TABLE tbPolizaIngreso
	(
		intEmpresa		int NOT NULL,
		intCuentaBancaria	int NOT NULL,
		datFecha		datetime NOT NULL,
		intObra			int,
		dblImporte		decimal(18,2),
		strAuxiliar		varchar(100),
		strReferencia	varchar(100),
		intConcepto		int,
		strPoliza		varchar(20),
		strUsuario		varchar(20),
		strMaquina		varchar(20),
		datFechaAlta	datetime
		--CONSTRAINT PK_tbPolizaIngreso 
		--PRIMARY KEY CLUSTERED
		--(
		--	intConcepto ASC
		--)
	)
END
GO

ALTER TABLE dbo.tbPolizaIngreso  WITH CHECK ADD  CONSTRAINT FK_tbPolizaIngreso_tbConceptosIngreso FOREIGN KEY(intConcepto)
REFERENCES dbo.tbConceptosIngreso(intConcepto)
GO

ALTER TABLE dbo.tbPolizaIngreso CHECK CONSTRAINT FK_tbPolizaIngreso_tbConceptosIngreso
GO

IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'tbPolizaIngreso', NULL,NULL))
BEGIN
	EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Tabla donde se guardan las polizas de ingreso.' ,
	@level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tbPolizaIngreso'
END
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.tbPolizaIngreso') AND type in (N'U'))
BEGIN
	PRINT 'Table Creation: dbo.tbPolizaIngreso - Succeeded !!!'
END
ELSE
BEGIN
	PRINT 'Table Creation: dbo.tbPolizaIngreso - Error on Creation'
END
GO


