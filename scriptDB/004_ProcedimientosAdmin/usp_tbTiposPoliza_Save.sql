
/****** Object:  StoredProcedure [dbo.usp_tbFacXP_Poliza]    Script Date: 12/8/2009 10:45:19 AM ******/
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.usp_tbTiposPoliza_Save')
	AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
	DROP PROCEDURE dbo.usp_tbTiposPoliza_Save
	PRINT N'Drop Procedure : dbo.usp_tbTiposPoliza_Save - Succeeded !!!'
END
GO

------------------------------------------------------------------------------------
---   Aplicacion: Marfil.		                                                 ---
---        Autor: Ingrid Soto Dimas							                      ---
---  Descripcion: Guarda en la tabla:  usp_tbTiposPoliza	                     ---
---                                                                              ---
------------------------------------------------------------------------------------
---    Fecha     Autor  Comentario                                               ---
---  ----------  -----  -------------------------------------------------------  ---
---  15/18/2013  IASD    Create procedure                                         ---
------------------------------------------------------------------------------------    
CREATE  PROCEDURE [dbo].[usp_tbTiposPoliza_Save]      
(      
 @intEmpresa  int,      
 @intEjercicio int,      
 @strTipoPoliza varchar(10),      
 @intMes int,      
 @valPol int      
)      
AS      
BEGIN      
      
DECLARE @existe int      
SET @existe = 0      
      
DECLARE @str AS VARCHAR(2000)      
DECLARE @mes AS VARCHAR(50)      
SET @mes = 'intM' + CAST( @intMes AS varchar (100))      
      
    
   IF  EXISTS      
    (SELECT *      
    FROM VetecMarfilAdmin..tbTiposPoliza      
    WHERE   intEmpresa = @intEmpresa       
  AND intEjercicio = @intEjercicio       
  AND strTipoPoliza = @strTipoPoliza      
    )      
   BEGIN      
     SET @str = '      
     UPDATE VetecMarfilAdmin..tbTiposPoliza      
     SET ' + @mes +  ' = ' + CAST( @valPol AS varchar(100)) + '      
     WHERE intEmpresa = ' + CAST(@intEmpresa AS varchar (100)) + '      
     AND intEjercicio = ' + CAST(@intEjercicio AS varchar (100))+ '      
     AND strTipoPoliza = ''' + @strTipoPoliza + ''''      
           
     EXEC ( @str   )    
     --select @str      
   END      
      
	SET NOCOUNT OFF
	
END
GO

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbTiposPoliza_Save Succeeded'
END
ELSE
BEGIN
	PRINT 'Procedure Creation: dbo.usp_tbTiposPoliza_Save Error on Creation'
END

