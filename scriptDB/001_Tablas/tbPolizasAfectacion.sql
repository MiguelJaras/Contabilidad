
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.tbPolizasAfectacion') AND type in (N'U'))
BEGIN
	DROP TABLE dbo.tbPolizasAfectacion

	IF @@Error = 0
	BEGIN
		PRINT 'Drop Table : dbo.tbPolizasAfectacion - Succeeded.'
	END
	ELSE
	BEGIN
		PRINT 'Drop Table : dbo.tbPolizasAfectacion - Error !!!'
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

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.tbPolizasAfectacion') AND type in (N'U'))
BEGIN
	CREATE TABLE dbo.tbPolizasAfectacion
	(
		intEmpresa		int				NOT NULL,
		intEjercicio	int				NOT NULL,
		intMes			int				NOT NULL,
		strTipoIni		varchar(10)     NOT NULL,
		strTipoFin		varchar(10)     NOT NULL,
		intFolioIni		int				NOT NULL,
		intFolioFin		int				NOT NULL,
		intAfecta		int				NOT NULL,
		strUsuario		varchar(50)		NOT NULL,
		strMaquina		varchar(50)		NOT NULL,
		datFecha		datetime		NOT NULL
	)
END
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'dbo.tbPolizasAfectacion') AND type in (N'U'))
BEGIN
	PRINT 'Table Creation: dbo.tbPolizasAfectacion - Succeeded !!!'
END
ELSE
BEGIN
	PRINT 'Table Creation: dbo.tbPolizasAfectacion - Error on Creation'
END
GO


