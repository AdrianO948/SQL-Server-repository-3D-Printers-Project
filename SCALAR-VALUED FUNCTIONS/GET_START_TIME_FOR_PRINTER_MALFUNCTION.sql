USE [BUBUBIBI]
GO
/****** Object:  UserDefinedFunction [dbo].[GET_START_TIME_FOR_PRINTER_MALFUNCTION]    Script Date: 21.06.2023 17:03:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER FUNCTION [dbo].[GET_START_TIME_FOR_PRINTER_MALFUNCTION]
(
	@id_printer int
)
RETURNS datetime
AS
BEGIN
	DECLARE @start_time datetime
	SELECT @start_time = M.START_DATE FROM [dbo].[MALFUNCTION]M JOIN [dbo].[PRINTER_STATUS]PS ON M.ID_MALFUNCTION = PS.ID_MALFUNCTION
	WHERE PS.ID_DICT_PRINTER_STATUS = 5 AND M.ID_PRINTER = @id_printer

	RETURN @start_time

END
