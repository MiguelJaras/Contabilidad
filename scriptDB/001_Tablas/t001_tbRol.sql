-- Relacion con la tabla tbRol.
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'FK_tbMenuRol_tbRol')
	AND OBJECTPROPERTY(id, N'IsForeignKey') = 1)
BEGIN
	ALTER TABLE dbo.tbMenuRol
	DROP CONSTRAINT FK_tbMenuRol_tbRol
END
GO

-- Relacion con la tabla tbRol.
IF EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'dbo.FK_relcatUser_tbRol')
	AND parent_object_id = OBJECT_ID(N'dbo.catUser'))
BEGIN
	ALTER TABLE dbo.catUser
	DROP CONSTRAINT FK_relcatUser_tbRol
END
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.tbRol') AND type in (N'U'))
BEGIN
	DROP TABLE dbo.tbRol

	IF @@Error = 0
	BEGIN
		PRINT 'Drop Table : dbo.tbRol - Succeeded.'
	END
	ELSE
	BEGIN
		PRINT 'Drop Table : dbo.tbRol - Error !!!'
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

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.tbRol') AND type in (N'U'))
BEGIN
	CREATE TABLE dbo.tbRol
	(
		intRol		int identity(0,1)  NOT NULL,
		strNombre	varchar(50) NOT NULL,
		bActivo		bit
		CONSTRAINT PK_tbRol
		PRIMARY KEY CLUSTERED
		(
			intRol ASC
		)
	)
END
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.tbRol') AND type in (N'U'))
BEGIN
	PRINT 'Table Creation: dbo.tbRol - Succeeded !!!'
END
ELSE
BEGIN
	PRINT 'Table Creation: dbo.tbRol - Error on Creation'
END
GO


