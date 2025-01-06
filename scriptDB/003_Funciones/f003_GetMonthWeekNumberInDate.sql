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


