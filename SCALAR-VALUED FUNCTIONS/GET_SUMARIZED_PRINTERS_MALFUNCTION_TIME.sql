USE [BUBUBIBI]
GO
/****** Object:  UserDefinedFunction [dbo].[GET_SUMARIZED_PRINTERS_MALFUNCTION_TIME]    Script Date: 21.06.2023 17:03:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER FUNCTION [dbo].[GET_SUMARIZED_PRINTERS_MALFUNCTION_TIME]
(	
	@w_start_date datetime,
	@w_end_date datetime
)
RETURNS int 
AS
BEGIN

	DECLARE @sumarized_value int = 0
	SELECT @sumarized_value = SUM([dbo].[GET_PRINTER_MALFUNCTION_TIME_BETWEEN_DATES](P.ID_PRINTER, @w_start_date, @w_end_date)) FROM [dbo].[PRINTER]P
	RETURN @sumarized_value 
END
