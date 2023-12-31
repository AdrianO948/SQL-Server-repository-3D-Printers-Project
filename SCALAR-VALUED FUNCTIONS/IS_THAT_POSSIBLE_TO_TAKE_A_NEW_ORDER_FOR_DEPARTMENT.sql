USE [BUBUBIBI]
GO
/****** Object:  UserDefinedFunction [dbo].[IS_THAT_POSSIBLE_TO_TAKE_A_NEW_ORDER_FOR_DEPARTMENT]    Script Date: 21.06.2023 17:04:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER FUNCTION [dbo].[IS_THAT_POSSIBLE_TO_TAKE_A_NEW_ORDER_FOR_DEPARTMENT] 
(
	@timeToStartWith datetime,
	@id_department int
)
RETURNS VARCHAR(200)
AS
BEGIN
	DECLARE @timeToEndOrder datetime = DATEADD(hh, 36, @timeToStartWith)
	DECLARE @malfunctionStart datetime
	DECLARE @malfunctionEnd datetime
	DECLARE @timeConsumed int = 0
	DECLARE @numberOfPrinters int 
	DECLARE @fullTime int = 0

	SELECT @numberOfPrinters = COUNT(*) FROM [dbo].[PRINTER]P WHERE P.ID_DEPARTMENT = @id_department

	---- Which of printers are being repaired in that time 
	SELECT @malfunctionStart = M.START_DATE, @malfunctionEnd = IIF(PS.END_DATE IS NULL, @timeToEndOrder, PS.END_DATE) FROM [dbo].[MALFUNCTION]M JOIN [dbo].[PRINTER_STATUS]PS ON PS.ID_MALFUNCTION = M.ID_MALFUNCTION JOIN [dbo].[PRINTER]P ON P.ID_PRINTER = M.ID_PRINTER WHERE P.ID_DEPARTMENT = @id_department 
	AND ((M.START_DATE >= @timeToStartWith and PS.END_DATE <= @timeToEndOrder)
	or 
	(M.START_DATE >= @timeToStartWith and M.START_DATE < @timeToEndOrder and PS.END_DATE is null)
	or 
	(M.START_DATE < @timeToStartWith and PS.END_DATE >= @timeToEndOrder)
    or 
	(M.START_DATE < @timeToStartWith and PS.END_DATE is null)
	or
    (M.START_DATE >= @timeToStartWith and PS.END_DATE > @timeToEndOrder))
	order by case when PS.END_DATE is null then 1 else 0 end desc, PS.END_DATE  desc

	SELECT @timeConsumed += DATEDIFF(mi, @malfunctionStart, @malfunctionEnd)
	---- SUM of time consumed by completing active orders 
	SELECT @timeConsumed += CASE 
	WHEN O.ORDER_START_DATE < @timeToStartWith AND DATEADD(mi, O.TIME_TO_COMPLETE_ORDER_MINS, O.ORDER_START_DATE) < @timeToEndOrder THEN DATEDIFF(mi, @timeToStartWith, DATEADD(mi, O.TIME_TO_COMPLETE_ORDER_MINS, O.ORDER_START_DATE))
	WHEN O.ORDER_START_DATE < @timeToStartWith AND DATEADD(mi, O.TIME_TO_COMPLETE_ORDER_MINS, O.ORDER_START_DATE) >= @timeToEndOrder THEN DATEDIFF(mi, @timeToStartWith, @timeToEndOrder)
	WHEN O.ORDER_START_DATE >= @timeToStartWith AND DATEADD(mi, O.TIME_TO_COMPLETE_ORDER_MINS, O.ORDER_START_DATE) < @timeToEndOrder THEN DATEDIFF(mi, O.ORDER_START_DATE, DATEADD(mi, O.TIME_TO_COMPLETE_ORDER_MINS, O.ORDER_START_DATE))
	WHEN O.ORDER_START_DATE >= @timeToStartWith AND DATEADD(mi, O.TIME_TO_COMPLETE_ORDER_MINS, O.ORDER_START_DATE) >= @timeToEndOrder THEN DATEDIFF(mi, O.ORDER_START_DATE, @timeToEndOrder)
	END
	FROM [dbo].[ORDER]O WHERE O.ID_DEPARTMENT = @id_department AND O.ORDER_START_DATE BETWEEN @timeToStartWith AND @timeToEndOrder

	SELECT @fullTime = (@numberOfPrinters * 36 * 60) - @timeConsumed
	
	RETURN (SELECT IIF((@fullTime / 60) > 36, 'You can accept a new order. Unused time in hours: '+ CONVERT(varchar, (@fullTime / 60)), 'You cant accept new order. Unused printers time in hours: ' + CONVERT(varchar, (@fullTime / 60))))

END
