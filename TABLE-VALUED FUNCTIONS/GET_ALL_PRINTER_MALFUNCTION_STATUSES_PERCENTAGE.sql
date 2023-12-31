USE [BUBUBIBI]
GO
/****** Object:  UserDefinedFunction [dbo].[GET_ALL_PRINTER_MALFUNCTION_STATUSES_IN_PERCENTAGE]    Script Date: 21.06.2023 16:54:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER FUNCTION [dbo].[GET_ALL_PRINTER_MALFUNCTION_STATUSES_IN_PERCENTAGE]
(	
	@declared_time datetime,
	@number_of_printers int
)
RETURNS TABLE 
AS
RETURN 
(
	SELECT 
		CONVERT(varchar, COUNT(CASE WHEN ID_DICT_PRINTER_STATUS = 1 THEN 1 END) / CONVERT(decimal(5, 2), @number_of_printers) * 100) + '%' AS status1_percentage,
		CONVERT(varchar, COUNT(CASE WHEN ID_DICT_PRINTER_STATUS = 2 THEN 1 END) / CONVERT(decimal(5, 2), @number_of_printers) * 100) + '%' AS status2_percentage,
		CONVERT(varchar, COUNT(CASE WHEN ID_DICT_PRINTER_STATUS = 3 THEN 1 END) / CONVERT(decimal(5, 2), @number_of_printers) * 100) + '%' AS status3_percentage,
		CONVERT(varchar, COUNT(CASE WHEN ID_DICT_PRINTER_STATUS = 4 THEN 1 END) / CONVERT(decimal(5, 2), @number_of_printers) * 100) + '%' AS status4_percentage,
		CONVERT(varchar, COUNT(CASE WHEN ID_DICT_PRINTER_STATUS = 5 THEN 1 END) / CONVERT(decimal(5, 2), @number_of_printers) * 100) + '%' AS status5_percentage
	FROM (
		SELECT M.ID_PRINTER, M.START_DATE, PS.END_DATE, PS.ID_DICT_PRINTER_STATUS,
			   ROW_NUMBER() OVER (PARTITION BY M.ID_PRINTER ORDER BY ABS(DATEDIFF(minute, PS.END_DATE, @declared_time))) AS RowNumber
		FROM [dbo].[MALFUNCTION] M
		RIGHT JOIN [dbo].[PRINTER_STATUS] PS ON PS.ID_MALFUNCTION = M.ID_MALFUNCTION
		WHERE @declared_time BETWEEN M.START_DATE AND PS.END_DATE
	) AS LimitedTable
	WHERE @declared_time BETWEEN START_DATE AND END_DATE AND RowNumber = 1
)
