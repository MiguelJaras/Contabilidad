
-- Relacion con la tabla tbMenu.
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'FK_tbMenuRol_tbMenu')
	AND OBJECTPROPERTY(id, N'IsForeignKey') = 1)
BEGIN
	ALTER TABLE dbo.tbMenuRol
	DROP CONSTRAINT FK_tbMenuRol_tbMenu
END
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.tbMenuRol') AND type in (N'U'))
BEGIN
	DROP TABLE dbo.tbMenuRol

	IF @@Error = 0
	BEGIN
		PRINT 'Drop Table : dbo.tbMenuRol - Succeeded.'
	END
	ELSE
	BEGIN
		PRINT 'Drop Table : dbo.tbMenuRol - Error !!!'
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

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.tbMenuRol') AND type in (N'U'))
BEGIN
	CREATE TABLE dbo.tbMenuRol
	(
		intMenu      int NOT NULL,
		intRol		int NOT NULL,
		CONSTRAINT PK_tbMenuRol
		PRIMARY KEY CLUSTERED
		(
			intMenu, intRol
		)
	)
END
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'dbo.FK_tbMenuRol_tbMenu')
	AND parent_object_id = OBJECT_ID(N'dbo.tbMenuRol'))
BEGIN
	ALTER TABLE dbo.tbMenuRol
		ADD CONSTRAINT FK_tbMenuRol_tbMenu
		FOREIGN KEY (intMenu) 
		REFERENCES dbo.tbMenu (intMenu) 
END
GO

ALTER TABLE dbo.tbMenuRol
CHECK CONSTRAINT FK_tbMenuRol_tbMenu
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'dbo.FK_tbMenuRol_tbRol')
	AND parent_object_id = OBJECT_ID(N'dbo.tbMenuRol'))
BEGIN
	ALTER TABLE dbo.tbMenuRol
		ADD CONSTRAINT FK_tbMenuRol_tbRol
		FOREIGN KEY (intRol) 
		REFERENCES dbo.tbRol (intRol) 
END
GO

ALTER TABLE dbo.tbMenuRol
CHECK CONSTRAINT FK_tbMenuRol_tbRol
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.tbMenuRol') AND type in (N'U'))
BEGIN
	PRINT 'Table Creation: dbo.tbMenuRol - Succeeded !!!'
END
ELSE
BEGIN
	PRINT 'Table Creation: dbo.tbMenuRol - Error on Creation'
END
GO


