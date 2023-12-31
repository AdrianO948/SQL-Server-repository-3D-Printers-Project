USE [BUBUBIBI]
GO
/****** Object:  UserDefinedFunction [dbo].[GET_PRINTER_MALFUNCTIONS]    Script Date: 21.06.2023 16:57:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER FUNCTION [dbo].[GET_PRINTER_MALFUNCTIONS]
	-- Add the parameters for the stored procedure here
	(@id_printer int)
RETURNS TABLE
AS
RETURN (
    -- Insert statements for procedure here
	SELECT m.START_DATE, (select TOP 1 end_date from GET_START_END_DATE_MALFUNCTION(m.id_malfunction))END_DATE
	from [dbo].[MALFUNCTION]m
	where ID_PRINTER = @id_printer 
	)