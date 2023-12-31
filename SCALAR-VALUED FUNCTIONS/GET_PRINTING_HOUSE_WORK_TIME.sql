USE [BUBUBIBI]
GO
/****** Object:  UserDefinedFunction [dbo].[GET_PRINTING_HOUSE_WORK_TIME]    Script Date: 21.06.2023 17:03:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER FUNCTION [dbo].[GET_PRINTING_HOUSE_WORK_TIME]
(
	-- Dodaj tutaj parametry funkcji
	@w_start_date datetime,
	@w_end_date datetime
)
RETURNS int
AS
BEGIN
  DECLARE @hours_counter int = 0
  DECLARE @w_start_date_copy datetime = @w_start_date 

  --- Obliczenie czasu pracy zakładu pomiędzy dwoma zadanymi datami 
  While @w_start_date_copy < @w_end_date 
  BEGIN
	SELECT @hours_counter = (CASE
	WHEN DATEPART(dw, @w_start_date_copy) = 7 AND DATEPART(hh, @w_start_date_copy) < 6 THEN @hours_counter + 1
	WHEN DATEPART(dw, @w_start_date_copy) = 1 THEN @hours_counter
	WHEN DATEPART(dw, @w_start_date_copy) = 2 THEN @hours_counter + 1
	WHEN DATEPART(dw, @w_start_date_copy) = 3 THEN @hours_counter + 1
	WHEN DATEPART(dw, @w_start_date_copy) = 4 THEN @hours_counter + 1
	WHEN DATEPART(dw, @w_start_date_copy) = 5 THEN @hours_counter + 1
	WHEN DATEPART(dw, @w_start_date_copy) = 6 THEN @hours_counter + 1
	ELSE @hours_counter
	END)
	SET @w_start_date_copy = DATEADD(hh, 1, @w_start_date_copy)
	IF @w_start_date_copy >= @w_end_date
		BREAK
  END
  SET @hours_counter *= 60
  SET @hours_counter += DATEPART(mi, @w_end_date) - DATEPART(mi, @w_start_date)


  RETURN @hours_counter
END