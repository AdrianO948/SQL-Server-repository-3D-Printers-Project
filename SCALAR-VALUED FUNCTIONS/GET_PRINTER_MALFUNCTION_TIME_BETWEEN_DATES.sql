USE [BUBUBIBI]
GO
/****** Object:  UserDefinedFunction [dbo].[GET_PRINTER_MALFUNCTION_TIME_BETWEEN_DATES]    Script Date: 21.06.2023 17:02:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER FUNCTION [dbo].[GET_PRINTER_MALFUNCTION_TIME_BETWEEN_DATES]
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
  DECLARE @m_start datetime
  DECLARE @m_end datetime

  --- Obliczenie czasu usterki pomiędzy zadanymi datami 
  SELECT @malfunction_time_between_dates = (CASE WHEN START_DATE < @w_start_date AND END_DATE >= @w_end_date THEN DATEDIFF(mi, @w_start_date, @w_end_date) -- +
	 WHEN START_DATE >= @w_start_date AND END_DATE <= @w_end_date THEN DATEDIFF(mi, START_DATE, END_DATE) -- +
	 WHEN START_DATE > @w_start_date AND START_DATE < @w_end_date AND END_DATE IS NULL THEN DATEDIFF(mi, START_DATE, @w_end_date) -- +
	 WHEN START_DATE < @w_start_date AND END_DATE IS NULL THEN DATEDIFF(mi, @w_start_date, @w_end_date) -- +
	 WHEN START_DATE >= @w_start_date AND END_DATE > @w_end_date THEN DATEDIFF(mi, START_DATE, @w_end_date) -- +
	 ELSE 0 
	 END), @m_start = START_DATE, @m_end = END_DATE
	 FROM
    GET_PRINTER_MALFUNCTIONS(@id_drukarki) m
  WHERE
    (start_date >= @w_start_date AND end_date <= @w_end_date) -- +
    OR (start_date >= @w_start_date AND start_date < @w_end_date AND end_date IS NULL) -- +
    OR (start_date < @w_start_date AND end_date >= @w_end_date) -- +
    OR (start_date < @w_start_date AND end_date IS NULL) -- +
    OR (start_date >= @w_start_date AND end_date > @w_end_date) -- + 
	if @malfunction_time_between_dates < 0
	set @malfunction_time_between_dates = 0
	DECLARE @weeks_diff int = 0
	IF ((DATEPART(d, @w_end_date) = 2 AND DATEPART(hh, @w_end_date) >= 6) AND (DATEPART(d, @w_start_date) <= 7 AND DATEPART(hh, @w_start_date) < 6) OR (DATEPART(d, @w_end_date) > 2 AND DATEPART(d, @w_end_date) < 7))
	BEGIN
		SELECT @weeks_diff = DATEPART(WEEK, @w_end_date) - DATEPART(WEEK, @w_start_date)
		DECLARE @end_week datetime = DATEADD(hh, (24 - DATEPART(hh, @w_start_date)), @w_start_date)
		if DATEPART(dd, @end_week) = 1
			begin
			SET @end_week = DATEADD(hh, 24, @end_week)
			end
		if DATEPART(dd, @end_week) = 2
			begin
			SET @end_week = DATEADD(hh, 6, @end_week)
			end
		if @malfunction_time_between_dates > 0 AND (@end_week BETWEEN @m_start AND @m_end)
		SET @malfunction_time_between_dates -= (@weeks_diff * 48 * 60)
		END
	ELSE IF (DATEPART(d, @w_start_date) = 7 AND DATEPART(hh, @w_start_date) >= 6) OR (DATEPART(d, @w_start_date) = 1) OR (DATEPART(d, @w_start_date) = 2 AND DATEPART(hh, @w_start_date) < 6) 
	BEGIN 
		SET @end_week = DATEADD(hh, (24 - DATEPART(hh, @w_start_date)), @w_start_date)
		if DATEPART(dd, @end_week) = 1
			begin
			SET @end_week = DATEADD(hh, 24, @end_week)
			end
		if DATEPART(dd, @end_week) = 2
			begin
			SET @end_week = DATEADD(hh, 6, @end_week)
			end
		if @malfunction_time_between_dates > 0 AND (@end_week BETWEEN @m_start AND @m_end)
		SET @malfunction_time_between_dates -= DATEDIFF(hh, @w_start_date, @end_week)
	END
  RETURN @malfunction_time_between_dates
END