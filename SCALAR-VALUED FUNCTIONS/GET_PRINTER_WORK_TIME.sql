USE [BUBUBIBI]
GO
/****** Object:  UserDefinedFunction [dbo].[GET_PRINTER_WORK_TIME]    Script Date: 21.06.2023 17:02:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER FUNCTION [dbo].[GET_PRINTER_WORK_TIME]
(
	-- Dodaj tutaj parametry funkcji
	@id_drukarki int,
	@w_start_date datetime,
	@w_end_date datetime
)
RETURNS int
AS
BEGIN
  DECLARE @malfunction_time_between_dates int 
  DECLARE @real_printer_work_time int 
---- Przypisanie do zmiennej wyniku z wywołania funkcji
SELECT @malfunction_time_between_dates = [dbo].[GET_PRINTER_MALFUNCTION_TIME_BETWEEN_DATES] (@id_drukarki, @w_start_date, @w_end_date)

---- Przypisanie do zmiennej czasu spośród dat w którym zakład nie pracuje
DECLARE @work_time int 
SELECT @work_time = [dbo].[GET_PRINTING_HOUSE_WORK_TIME](@w_start_date, @w_end_date)

--- Obliczenie realnego czasu pracy drukarki uwzględniając czas pracy zakładu oraz czas usterki 
SET @real_printer_work_time = @work_time - @malfunction_time_between_dates


  RETURN @real_printer_work_time
END