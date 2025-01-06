
-- Relacion con la tabla tbRol.
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'dbo.FK_tbUsuarios_tbRol')
	AND parent_object_id = OBJECT_ID(N'dbo.tbUsuarios'))
BEGIN
	ALTER TABLE dbo.tbUsuarios
	DROP CONSTRAINT FK_tbUsuarios_tbRol
END
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.tbUsuarios') AND type in (N'U'))
BEGIN
	DROP TABLE dbo.tbUsuarios

	IF @@Error = 0
	BEGIN
		PRINT 'Drop Table : dbo.tbUsuarios - Succeeded.'
	END
	ELSE
	BEGIN
		PRINT 'Drop Table : dbo.tbUsuarios - Error !!!'
	END
END
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

------------------------------------------------------------------------------------
---   Aplicacion: PM.                                                            ---
---        Autor: Rubén Mora Martínez / RMM			                             ---
---  Descripcion: Tabla donde se definen parametros generales a utilizar en la   ---
---               aplicacion.                                                    ---
------------------------------------------------------------------------------------
---    Fecha     Autor  Comentario                                               ---
---  ----------  -----  -------------------------------------------------------  ---
---  2011-07-29  RMM    Creacion                                                 ---
------------------------------------------------------------------------------------

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.tbUsuarios') AND type in (N'U'))
BEGIN
	CREATE TABLE dbo.tbUsuarios
	(
		intUsuario	int identity(0,1)  NOT NULL,
		strClave	varchar(50) NOT NULL,
		strNombre	varchar(100) NOT NULL,
		strEmail	varchar(100) NOT NULL,
		intRol		int NOT NULL,
		bActivo		bit
		CONSTRAINT PK_tbUsuarios
		PRIMARY KEY CLUSTERED
		(
			intUsuario ASC
		)
	)
END
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'dbo.FK_tbUsuarios_tbRol')
	AND parent_object_id = OBJECT_ID(N'dbo.tbUsuarios'))
BEGIN
	ALTER TABLE dbo.tbUsuarios WITH CHECK
		ADD CONSTRAINT FK_tbUsuarios_tbRol
		FOREIGN KEY( intRol )
		REFERENCES dbo.tbRol ( intRol )
END
GO

ALTER TABLE dbo.tbUsuarios
CHECK CONSTRAINT FK_tbUsuarios_tbRol
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.tbUsuarios') AND type in (N'U'))
BEGIN
	PRINT 'Table Creation: dbo.tbUsuarios - Succeeded !!!'
END
ELSE
BEGIN
	PRINT 'Table Creation: dbo.tbUsuarios - Error on Creation'
END
GO


