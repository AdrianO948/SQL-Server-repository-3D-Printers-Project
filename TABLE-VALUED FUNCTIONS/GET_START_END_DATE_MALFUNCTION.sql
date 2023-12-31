USE [BUBUBIBI]
GO
/****** Object:  UserDefinedFunction [dbo].[GET_START_END_DATE_MALFUNCTION]    Script Date: 21.06.2023 16:57:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER FUNCTION [dbo].[GET_START_END_DATE_MALFUNCTION] 
(	
	-- Add the parameters for the function here
	@id_printer int 
)
RETURNS TABLE 
AS
RETURN 
(
select [MALFUNCTION].START_DATE, [PRINTER_STATUS].END_DATE from [dbo].[MALFUNCTION], [dbo].[PRINTER_STATUS] 
WHERE [PRINTER_STATUS].[ID_MALFUNCTION] = [MALFUNCTION].[ID_MALFUNCTION] 
and [MALFUNCTION].ID_PRINTER = @id_printer AND [PRINTER_STATUS].ID_DICT_PRINTER_STATUS = 5

)