 

/****** Object:  StoredProcedure [dbo.usp_tbUsuarios_Login]    Script Date: 12/8/2009 12:30:06 PM ******/
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbUsuarios_Login')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbUsuarios_Login
	PRINT N'Drop Procedure : dbo.usp_tbUsuarios_Login - Succeeded !!!'
END
GO

------------------------------------------------------------------------------------
---  Aplicacion:  PM.															 ---
---        Autor: Ruben Mora Martinez/ RMM										 ---
---  Descripcion: Return number of week in current month                         ---
------------------------------------------------------------------------------------
---    Fecha     Autor  Comentario                                               ---
---  ----------  -----  -------------------------------------------------------  ---
---  2011-07-29  RMM    Creacion                                                 ---
------------------------------------------------------------------------------------

CREATE PROCEDURE dbo.usp_tbUsuarios_Login
(
	@p_Login nvarchar(50)	
)
AS
BEGIN
	SET NOCOUNT ON
	
	DECLARE	@Err			int,
			@MsgErr		varchar(512)

	SELECT	A.intUsuario,
			A.strClave,
			A.strNombre,
			A.strEmail,
			A.intRol,
			B.strNombre AS StrNombreRol,
			A.bActivo,
			0 AS iTotalRecords,
		    0 AS iTotalPages
	FROM	tbUsuarios A
	INNER JOIN tbRol B ON B.intRol = A.intRol
	where A.strClave = @p_Login

	SET @Err = @@Error

	IF (@Err > 0)
	BEGIN
		SELECT @MsgErr = 'Ocurrio un error no reconocido!',
				@Err = 1000000

		GOTO ExistsError
	END

	SET NOCOUNT OFF

	RETURN @Err

ExistsError:
	IF (@@TRANCOUNT > 0)
		ROLLBACK

	SET NOCOUNT OFF

	RAISERROR (@MsgErr, 16, 1)

	RETURN @Err

END
GO

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbUsuarios_Login Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbUsuarios_Login Error on Creation'
END
GO

