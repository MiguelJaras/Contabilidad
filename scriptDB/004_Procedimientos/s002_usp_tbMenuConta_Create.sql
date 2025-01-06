

/****** Object:  StoredProcedure [dbo.usp_tblParameters_upd]    Script Date: 12/3/2009 12:51:03 PM ******/
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbMenuConta_Create')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbMenuConta_Create
	PRINT N'Drop Procedure : dbo.usp_tbMenuConta_Create - Succeeded !!!'
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

CREATE PROCEDURE dbo.usp_tbMenuConta_Create
(
	@ParentId int,
	@intRol	  int = 0
)
AS
BEGIN

	SET NOCOUNT ON

      IF @ParentId = 0
      BEGIN
            SELECT A.intMenu,A.strPagina,A.strNombre,A.Icon,1 as HasChildren  
            FROM  tbMenuConta A 
            WHERE IsNull(A.intParentMenu,0) = 0  
      END   
      ELSE
      BEGIN
            SELECT DISTINCT intMenu,strPagina,strNombre,Icon,IsNull(intParentMenu,0) As intParentMenu,SortOrder,
                    Convert(Bit,Case When Exists(Select 1 From tbMenuConta R Where R.intParentMenu = A.intMenu) Then 1 Else 0 End) AS HasChildren
            FROM  tbMenuConta A     
            WHERE intParentMenu = @ParentId    
            ORDER BY SortOrder,intMenu,intParentMenu
      END

	SET NOCOUNT OFF
END
GO

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbMenuConta_Create Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbMenuConta_Create Error on Creation'
END
GO

