IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.Split')
	AND OBJECTPROPERTY(id,N'IsTableFunction') = 1)
BEGIN
    DROP FUNCTION dbo.Split
    PRINT 'Drop Function : dbo.Split - Succeeded !!!'
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

create function dbo.Split
(
	@csv varchar(8000)
)
returns @valores table (id varchar(255))
as
begin
/*Esta función recibe un string con valores separados por comas en @csv (comma separated values)
y devuelve una tabla con una columna de tipo int que incluye dichos valores
La ultima coma es opcional:
ejemplos de llamada:
1) exec parsearComasTabla '5,1,3,'
2) exec parsearComasTabla '2,4,1,6'*/
declare @valor varchar(255)
declare @posicionInicial int
declare @posicionFinal int
declare @w int
if @csv = ''
	return
set @posicionFinal = 0
set @posicionInicial = 0
set @w = 1
if substring(@csv, datalength(@csv), 1) <> ','
	set @csv = @csv + ','

if substring(@csv, 1, 1) = ','
	set @csv = substring(@csv, 2, datalength(@csv))

while charindex(',', @csv, @posicionFinal + 1) > 0
begin
	set @posicionFinal = charindex(',', @csv, @posicionFinal + 1)
	set @valor = substring(@csv, @posicionInicial + 1, @posicionFinal - @posicionInicial - 1)
	insert into @valores (id) values (@valor )
	set @posicionInicial = @posicionFinal
	set @w = @w + 1
end
return
end
GO

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.Split')
	AND OBJECTPROPERTY(id,N'IsTableFunction') = 1)
BEGIN
	GRANT SELECT ON dbo.Split TO PM_Role
END
GO

-- Display the status of Proc creation
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.Split')
	AND OBJECTPROPERTY(id,N'IsTableFunction') = 1)
BEGIN
    PRINT 'Function Creation: dbo.Split - Succeeded !!!'
END
ELSE
BEGIN
    PRINT 'Function Creation: dbo.Split - Error on Creation'
END
GO


