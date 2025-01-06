
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.fn_tbPolizasDet_Close')
	AND OBJECTPROPERTY(id,N'IsScalarFunction') = 1)
BEGIN
    DROP FUNCTION dbo.fn_tbPolizasDet_Close
    PRINT 'Drop Function : dbo.fn_tbPolizasDet_Close - Succeeded !!!'
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
CREATE FUNCTION dbo.fn_tbPolizasDet_Close(@intEmpresa INT,@intEjercicio INT,@intMes INT,@intModulo INT)              
RETURNS int   
AS        
BEGIN  
		DECLARE @Value int

		SELECT @Value = ISNULL((SELECT Convert(int,bCerrado) 
								FROM tbCerrarPeriodo 
								WHERE intEmpresa = @intEmpresa 
								AND intEjercicio = @intEjercicio 
								AND intMes = @intMes 
								AND intModulo = @intModulo),0)

		RETURN @Value     
END 
GO

-- Display the status of Proc creation
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.fn_tbPolizasDet_Close')
	AND OBJECTPROPERTY(id,N'IsScalarFunction') = 1)
BEGIN
    PRINT 'Function Creation: dbo.fn_tbPolizasDet_Close - Succeeded !!!'
END
ELSE
BEGIN
    PRINT 'Function Creation: dbo.fn_tbPolizasDet_Close - Error on Creation'
END
GO


