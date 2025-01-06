
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
---  Aplicacion:  PM.                                                      ---
---  RBDMS:       Miscrosoft SQL Server 2005.                               ---
---  Archivo:     001_PM_Tablas.sql                                        ---
---  Descripcion: Script para la creacion de las tablas                     ---
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
---                                                                         ---
---  000.- Indice                                                           ---
---                                                                         ---
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------


-- Cambie el nombre la de base de datos
use dbDigitalizacion
go


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


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.tbLoteObra') AND type in (N'U'))
BEGIN
	DROP TABLE dbo.tbLoteObra

	IF @@Error = 0
	BEGIN
		PRINT 'Drop Table : dbo.tbLoteObra - Succeeded.'
	END
	ELSE
	BEGIN
		PRINT 'Drop Table : dbo.tbLoteObra - Error !!!'
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

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.tbLoteObra') AND type in (N'U'))
BEGIN
	CREATE TABLE dbo.tbLoteObra
	(
		intLote			int				NOT NULL,
		intObraMC		int				NOT NULL,
		intObraMD		int				NOT NULL,
		intObraMAP		int				NOT NULL,
		intObraGRE		int				NOT NULL,
		intObraMUI		int				NOT NULL
		CONSTRAINT PK_tbLoteObra
		PRIMARY KEY CLUSTERED
		(
			intLote
		)
	)
END
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.tbLoteObra') AND type in (N'U'))
BEGIN
	PRINT 'Table Creation: dbo.tbLoteObra - Succeeded !!!'
END
ELSE
BEGIN
	PRINT 'Table Creation: dbo.tbLoteObra - Error on Creation'
END
GO


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


