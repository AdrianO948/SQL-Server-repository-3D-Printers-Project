USE [BUBUBIBI]
GO
/****** Object:  UserDefinedFunction [dbo].[RETURN_NUMBER_OF_SHIFTS]    Script Date: 21.06.2023 17:04:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER FUNCTION [dbo].[RETURN_NUMBER_OF_SHIFTS]
(
	@start_time DATETIME, 
	@end_time DATETIME
)
RETURNS INT
AS
BEGIN
    DECLARE @ShiftCounter INT;
    SET @ShiftCounter = 0;
	DECLARE @start_time_copy datetime = @start_time
    WHILE @start_time_copy < @end_time
    BEGIN
		IF DATEPART(dw, @start_time_copy) = DATEPART(dw, @end_time) AND ((SELECT [dbo].[Return_Shift](@end_time)) - (SELECT[dbo].[Return_Shift](@end_time))= 0)
		BEGIN 
			SET @ShiftCounter += 1
			break
			end
		IF DATEPART(dw, @start_time_copy) = DATEPART(dw, @end_time) AND ((SELECT [dbo].[Return_Shift](@end_time)) - (SELECT[dbo].[Return_Shift](@end_time))= 1)
		BEGIN 
			SET @ShiftCounter += 2
			break
			end
		IF DATEPART(dw, @start_time_copy) = DATEPART(dw, @end_time) AND ((SELECT [dbo].[Return_Shift](@end_time)) - (SELECT[dbo].[Return_Shift](@end_time))= 2)
		BEGIN 
			SET @ShiftCounter += 3
			break
			end

        IF DATEPART(WEEKDAY, @start_time_copy) in (2, 3, 4, 5, 6)
        BEGIN
            IF DATEPART(HOUR, @start_time_copy) >= 6 AND DATEPART(HOUR, @start_time_copy) < 14
                SET @ShiftCounter += 1;

            IF DATEPART(HOUR, @start_time_copy) >= 14 AND DATEPART(HOUR, @start_time_copy) < 22
                SET @ShiftCounter += 1;

            IF DATEPART(HOUR, @start_time_copy) >= 22 OR DATEPART(HOUR, @start_time_copy) < 6
                SET @ShiftCounter += 1;
        END
		IF DATEPART(WEEKDAY, @start_time_copy) = 7
			IF DATEPART(hh, @start_time_copy) < 6
				SET @ShiftCounter += 1;

        -- Zwiększanie daty o 1 godzinę
        SET @start_time_copy = DATEADD(HOUR, 8, @start_time_copy);
    END

    RETURN @ShiftCounter;
END