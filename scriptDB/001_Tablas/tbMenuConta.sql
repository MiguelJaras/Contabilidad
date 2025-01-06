-- Relacion con la tabla tbMenuConta.
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'FK_tbMenuContaRol_tbMenuConta')
	AND OBJECTPROPERTY(id, N'IsForeignKey') = 1)
BEGIN
	ALTER TABLE dbo.tbMenuContaRol
	DROP CONSTRAINT FK_tbMenuContaRol_tbMenuConta
END
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.tbMenuConta') AND type in (N'U'))
BEGIN
	DROP TABLE dbo.tbMenuConta

	IF @@Error = 0
	BEGIN
		PRINT 'Drop Table : dbo.tbMenuConta - Succeeded.'
	END
	ELSE
	BEGIN
		PRINT 'Drop Table : dbo.tbMenuConta - Error !!!'
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

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.tbMenuConta') AND type in (N'U'))
BEGIN
	CREATE TABLE dbo.tbMenuConta
	(
		intMenu			int				NOT NULL,
		strNombre		varchar(128)	NULL,
		strPagina		varchar(128)	NULL,
		intParentMenu   int				NULL,
		Icon			varchar(128)    NULL,
		SortOrder		int				NULL,
		CONSTRAINT PK_tbMenuConta
		PRIMARY KEY CLUSTERED
		(
			intMenu
		)
	)
END
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.tbMenuConta') AND type in (N'U'))
BEGIN
	PRINT 'Table Creation: dbo.tbMenuConta - Succeeded !!!'
END
ELSE
BEGIN
	PRINT 'Table Creation: dbo.tbMenuConta - Error on Creation'
END
GO


