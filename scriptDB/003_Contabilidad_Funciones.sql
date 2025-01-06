
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
---  Aplicacion:  PM.                                                       ---
---  RBDMS:       Miscrosoft SQL Server 2005.                               ---
---  Archivo:     003_PM_Funciones.sql                                      ---
---  Descripcion: Script para la creacion de las funciones                  ---
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
---                                                                         ---
---  040.-                                                                  ---
---                                                                         ---
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------


-- Cambie el nombre la de base de datos
use dbPM
go


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


IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.fn_ValidaMontoFactura')
	AND OBJECTPROPERTY(id,N'IsScalarFunction') = 1)
BEGIN
    DROP FUNCTION dbo.fn_ValidaMontoFactura
    PRINT 'Drop Function : dbo.fn_ValidaMontoFactura - Succeeded !!!'
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

Create Function dbo.fn_ValidaMontoFactura
(
	@intEmpresa int,
	@intProveedor int,
	@intFolio	int,
	@strFactura	VARCHAR(50),
	@dblMonto	decimal(18,2)
)
returns int
As
Begin
		DECLARE @dblTotalOC DECIMAL(18,2)
		DECLARE @dblTotalFac DECIMAL(18,2)
		DECLARE @dblTipoCambioOC DECIMAL(18,2)
		DECLARE @dblTotalPagos DECIMAL(18,2)

		SELECT @dblTotalOC = dblTotal 
		FROM VetecMarfil..tbOrdenCompraEnc WHERE intEmpresa = @intEmpresa AND intFolio = @intFolio
	
		SELECT @dblTipoCambioOC = ROUND(SUM(OC.dblTotal * OC.dblTipoCambio),2)
		FROM VetecMarfil.dbo.tbOrdenCompraEnc OC 
		WHERE OC.intFolio = @intFolio AND intEmpresa = @intEmpresa

		SELECT @dblTotalPagos = ISNULL(SUM(dblMonto),0)
		FROM tbFacXPDet WHERE intEmpresa = @intEmpresa AND intProveedor = @intProveedor AND strFactura = @strFactura AND intTipoMovto IN(31,53,54,58)

		IF(@dblMonto - @dblTotalPagos > @dblTotalOC)
		BEGIN
			RAISERROR('El Monto de la Factura Sobrepasa el Monto de la Orden de Compra.',16,1)
			RETURN '0'
		END
        
        SELECT @dblTotalFac  = ISNULL(SUM(dblTotal),0)
		FROM tbFacXP WHERE CONVERT(INT, strFolio) = @intFolio AND intProveedor = @intProveedor AND intEmpresa = @intEmpresa       
   

		IF((@dblTotalFac - @dblTotalPagos) > @dblTotalOC)
		BEGIN
			RAISERROR('El monto de la factura sobrepasa la capacidad de facturación.',16,1)
			RETURN '0'
		END


End
GO

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.fn_ValidaMontoFactura')
	AND OBJECTPROPERTY(id,N'IsScalarFunction') = 1)
BEGIN
	GRANT EXECUTE ON dbo.fn_ValidaMontoFactura TO PM_Role
END
GO

-- Display the status of Proc creation
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.fn_ValidaMontoFactura')
	AND OBJECTPROPERTY(id,N'IsScalarFunction') = 1)
BEGIN
    PRINT 'Function Creation: dbo.fn_ValidaMontoFactura - Succeeded !!!'
END
ELSE
BEGIN
    PRINT 'Function Creation: dbo.fn_ValidaMontoFactura - Error on Creation'
END
GO


IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.GetMonthWeekNumberInDate')
	AND OBJECTPROPERTY(id,N'IsScalarFunction') = 1)
BEGIN
    DROP FUNCTION dbo.GetMonthWeekNumberInDate
    PRINT 'Drop Function : dbo.GetMonthWeekNumberInDate - Succeeded !!!'
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

Create Function dbo.GetMonthWeekNumberInDate
(
	@p_DateToEvaluate	DateTime
)

Returns TinyInt
As
Begin
	Declare	
		@dVirtualDate		DateTime,
		@DaysDiff			TinyInt,
		@DayOfMoth			TinyInt

	Select @DayOfMoth	=	Day(@p_DateToEvaluate)
	
	Select @dVirtualDate	=	@p_DateToEvaluate-@DayOfMoth+1

	Select @DaysDiff	=	DatePart(dw,@dVirtualDate)-1

	Return (Select Case When @DayOfMoth	<=	7-@DaysDiff Then	1
				When @DayOfMoth	<=	14-@DaysDiff Then			2
				When @DayOfMoth	<=	21-@DaysDiff Then			3
				When @DayOfMoth	<=	28-@DaysDiff Then			4
				When @DayOfMoth	<=	35-@DaysDiff Then			5
				Else											6
			End)	
End
GO

IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.GetMonthWeekNumberInDate')
	AND OBJECTPROPERTY(id,N'IsScalarFunction') = 1)
BEGIN
	GRANT EXECUTE ON dbo.GetMonthWeekNumberInDate TO PM_Role
END
GO

-- Display the status of Proc creation
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.GetMonthWeekNumberInDate')
	AND OBJECTPROPERTY(id,N'IsScalarFunction') = 1)
BEGIN
    PRINT 'Function Creation: dbo.GetMonthWeekNumberInDate - Succeeded !!!'
END
ELSE
BEGIN
    PRINT 'Function Creation: dbo.GetMonthWeekNumberInDate - Error on Creation'
END
GO




IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.fn_InsumosEspeciales'))
BEGIN
	DROP FUNCTION dbo.fn_InsumosEspeciales
	PRINT N'Drop Function : dbo.fn_InsumosEspeciales - Succeeded !!!'
END
GO

------------------------------------------------------------------------------------
---   Aplicacion: RMM.		                                                     ---
---        Autor: Ruben Mora Martinez                                            ---
---  Descripcion: Obtiene un registro de la tabla:  tbCotizacion                 ---
---                                                                              ---
------------------------------------------------------------------------------------
---    Fecha     Autor  Comentario                                               ---
---  ----------  -----  -------------------------------------------------------  ---
---  23/08/2011  RMM    Create procedure                                         ---
------------------------------------------------------------------------------------

CREATE FUNCTION dbo.fn_InsumosEspeciales(@intArticulo int)    
RETURNS DECIMAL(18,4) 
WITH ENCRYPTION
AS    
BEGIN 

	DECLARE @dblImporte DECIMAL(18,4)
	DECLARE @strNombreCorto VARCHAR(10)

	SET @dblImporte = 0

	SELECT @strNombreCorto = strNombreCorto FROM tbArticulo WHERE intArticulo = @intArticulo

	IF(@strNombreCorto = '')	
		SET @dblImporte = 1

	IF(@strNombreCorto = '')	
		SET @dblImporte = 1

	IF(@strNombreCorto = '')	
		SET @dblImporte = 1

	RETURN @dblImporte
END
GO 

-- Display the status of Proc creation
IF (@@Error = 0)
BEGIN
	PRINT 'Function Creation: dbo.fn_InsumosEspeciales Succeeded'
END
ELSE
BEGIN
	PRINT 'Function Creation: dbo.fn_InsumosEspeciales Error on Creation'
END
GO



set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go



CREATE FUNCTION [dbo].[fn_OrdenCompra_Requisicion]
(
	@intEmpresa INT, 
	@intOrdenCompraEnc int
)
RETURNS VARCHAR(50)
AS
BEGIN
	DECLARE @Value VARCHAR(400)
	DECLARE @intRequisicionEnc INT

	SELECT @intRequisicionEnc = intRequisicionEnc 
	FROM tbTempOrdenCompra 
	WHERE inrOrdenCompra = @intOrdenCompraEnc		

	SELECT @Value = CONVERT(VARCHAR,intFolio)
	FROM tbRequisicionEnc 
	WHERE intEmpresa = @intEmpresa
	AND intRequisicionEnc = @intRequisicionEnc	

	RETURN @Value
END



set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go



ALTER FUNCTION [dbo].[fn_Requisicion_Nota]
(
	@intEmpresa INT, 
	@intRequisicionEnc int
)
RETURNS VARCHAR(400)
AS
BEGIN
	DECLARE @Value VARCHAR(400)
	DECLARE @datFecha VARCHAR(400)
	DECLARE @strUsuarioAlta VARCHAR(100)
	DECLARE @strUsuario VARCHAR(400)	

	SELECT @datFecha = CONVERT(VARCHAR,datFechaAlta,103),@strUsuarioAlta = strUsuarioAlta
	FROM tbRequisicionEnc 
	WHERE intEmpresa = @intEmpresa
	AND intRequisicionEnc = @intRequisicionEnc

	SELECT @strUsuario = strNombreCompleto FROM segUsuarios WHERE strUsuario = @strUsuarioAlta

	SET @Value = '<p class="tLetra">Fecha    : ' + @datFecha + '                 
                  <br/> Realizo :  '+ @strUsuarioAlta + '  ' + @strUsuario + '</p>'

 --<br/> Autoriz¢ :  + UsuarioAutoriza + "  " + obtieneUsuario(UsuarioAutoriza) +

	RETURN @Value
END



IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.fn_tbCerrarPeriodo')
	AND OBJECTPROPERTY(id,N'IsScalarFunction') = 1)
BEGIN
    DROP FUNCTION dbo.fn_tbCerrarPeriodo
    PRINT 'Drop Function : dbo.fn_tbCerrarPeriodo - Succeeded !!!'
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

CREATE FUNCTION dbo.fn_tbCerrarPeriodo
(
	@intEmpresa int,
	@intEjercicio int,
	@intMes int,
	@intModulo int
)
RETURNS INT
AS
BEGIN
		DECLARE @intCerrado INT 

		SELECT @intCerrado = ISNULL(Convert(int,bCerrado),0)
		FROM tbCerrarPeriodo 
		WHERE intEmpresa = @intEmpresa
		AND intEjercicio = @intEjercicio
		AND intMes = @intMes
		AND intModulo = @intModulo 

		RETURN @intCerrado
END
GO

-- Display the status of Proc creation
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.fn_tbCerrarPeriodo')
	AND OBJECTPROPERTY(id,N'IsScalarFunction') = 1)
BEGIN
    PRINT 'Function Creation: dbo.fn_tbCerrarPeriodo - Succeeded !!!'
END
ELSE
BEGIN
    PRINT 'Function Creation: dbo.fn_tbCerrarPeriodo - Error on Creation'
END
GO


IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.fn_tbEntradaCompras_Entrada')
	AND OBJECTPROPERTY(id,N'IsScalarFunction') = 1)
BEGIN
    DROP FUNCTION dbo.fn_tbEntradaCompras_Entrada
    PRINT 'Drop Function : dbo.fn_tbEntradaCompras_Entrada - Succeeded !!!'
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

Create Function dbo.fn_tbEntradaCompras_Entrada
(
	@intOrdenCompraEnc int,
	@intOrdenCompraDet int
)
RETURNS INT
AS
BEGIN
		DECLARE @Entrada INT
		DECLARE @dblCantidadEnt decimal(18,4)
		DECLARE @dblCantidadRel decimal(18,4)		

		SELECT @dblCantidadRel = SUM(dblCantidad) 
		FROM tbOrdenCompraDet WHERE intOrdenCompraEnc = @intOrdenCompraEnc
		AND intOrdenCompraDet = @intOrdenCompraDet

		SELECT @dblCantidadEnt = SUM(dblCantidad) 
		FROM tbEntradaCompras WHERE intOrdenCompraEnc = @intOrdenCompraEnc
		AND intOrdenCompraDet = @intOrdenCompraDet
		AND intEstatus <> 9

		IF(ISNULL(@dblCantidadEnt,0) >= ISNULL(@dblCantidadRel,0))
			SET @Entrada = 1
		ELSE
			SET @Entrada = 0

	
		RETURN @Entrada
END
GO

-- Display the status of Proc creation
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.fn_tbEntradaCompras_Entrada')
	AND OBJECTPROPERTY(id,N'IsScalarFunction') = 1)
BEGIN
    PRINT 'Function Creation: dbo.fn_tbEntradaCompras_Entrada - Succeeded !!!'
END
ELSE
BEGIN
    PRINT 'Function Creation: dbo.fn_tbEntradaCompras_Entrada - Error on Creation'
END
GO


IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.fn_tbFacXP_MontoEntrada')
	AND OBJECTPROPERTY(id,N'IsScalarFunction') = 1)
BEGIN
    DROP FUNCTION dbo.fn_tbFacXP_MontoEntrada
    PRINT 'Drop Function : dbo.fn_tbFacXP_MontoEntrada - Succeeded !!!'
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

Create Function dbo.fn_tbFacXP_MontoEntrada
(
	@intEmpresa int,
	@intProveedor int,
	@strFactura	VARCHAR(50)	
)
RETURNS DECIMAL(18,2)
AS
BEGIN
		DECLARE @dblTotalEntrada DECIMAL(18,2)		
		DECLARE @intFolio int

		SELECT @intFolio = strFolio FROM tbFacXP WHERE intEmpresa = @intEmpresa AND intProveedor = @intProveedor AND strFactura = @strFactura

		SELECT @dblTotalEntrada = dblTotalRecibido * dblTipoCambio
		FROM VetecMarfil..tbOrdenCompraEnc WHERE intEmpresa = @intEmpresa AND intFolio = @intFolio

	
		RETURN ISNULL(@dblTotalEntrada,0)
END
GO

-- Display the status of Proc creation
IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.fn_tbFacXP_MontoEntrada')
	AND OBJECTPROPERTY(id,N'IsScalarFunction') = 1)
BEGIN
    PRINT 'Function Creation: dbo.fn_tbFacXP_MontoEntrada - Succeeded !!!'
END
ELSE
BEGIN
    PRINT 'Function Creation: dbo.fn_tbFacXP_MontoEntrada - Error on Creation'
END
GO


