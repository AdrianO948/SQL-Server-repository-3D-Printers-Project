USE [BUBUBIBI]
GO
/****** Object:  UserDefinedFunction [dbo].[Printers_statuses_percentage_7]    Script Date: 21.06.2023 16:58:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER FUNCTION [dbo].[Printers_statuses_percentage_7]
(	
	@declared_time datetime
)
RETURNS TABLE 
AS
RETURN 
(
	SELECT * FROM [dbo].[GET_ALL_PRINTER_MALFUNCTION_STATUSES_IN_PERCENTAGE](@declared_time, (SELECT [dbo].[GET_NUMBER_OF_ALL_PRINTERS_WORKING_AT_THE_TIME](@declared_time)))
)
