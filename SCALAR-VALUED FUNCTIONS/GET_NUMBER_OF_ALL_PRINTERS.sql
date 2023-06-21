USE [BUBUBIBI]
GO
/****** Object:  UserDefinedFunction [dbo].[GET_NUMBER_OF_ALL_PRINTERS]    Script Date: 21.06.2023 17:01:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER FUNCTION [dbo].[GET_NUMBER_OF_ALL_PRINTERS] 
(
)
RETURNS int
AS
BEGIN
	DECLARE @printers_counter int
	SELECT @printers_counter = COUNT(*) FROM [dbo].[PRINTER]P
	RETURN @printers_counter
END
