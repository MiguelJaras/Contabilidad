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


