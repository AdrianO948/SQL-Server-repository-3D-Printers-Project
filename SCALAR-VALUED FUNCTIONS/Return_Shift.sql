USE [BUBUBIBI]
GO
/****** Object:  UserDefinedFunction [dbo].[Return_Shift]    Script Date: 21.06.2023 17:05:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER FUNCTION [dbo].[Return_Shift]
(
	@SHIFT_DATE datetime
)
RETURNS int
AS
BEGIN
	-- Declare the return variable here
	DECLARE @shift_part int ,@shift_h  int, @shift_d int ;
	select @shift_h= datepart(HH,@SHIFT_DATE);
	select @shift_d= datepart(DW,@SHIFT_DATE);
	
	if( @shift_d != 1) 
	begin
	if (@shift_h >= 6 and @shift_h <14 and @shift_d <7)	 
		set @shift_part = 1;
		
	else if (@shift_h >= 14 and @shift_h <22  and @shift_d <7)
		set @shift_part = 2;
		else if (@shift_d < 7 and @shift_h < 6 or @shift_d <7 and @shift_h >= 22)
			set @shift_part = 3;
			else if (@shift_d = 7 and @shift_h  <6 )
			set @shift_part = 3;
	
	end;



	-- Return the result of the function
	RETURN @shift_part;

END