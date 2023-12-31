USE [BUBUBIBI]
GO
/****** Object:  UserDefinedFunction [dbo].[GET_NUMBER_OF_ORDERS_PER_DEPARTMENT]    Script Date: 21.06.2023 16:57:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER FUNCTION [dbo].[GET_NUMBER_OF_ORDERS_PER_DEPARTMENT]
(	
	@id_department int
)
RETURNS TABLE 
AS
RETURN 
(
	SELECT COUNT(*)NumberOfOrders FROM [dbo].[ORDER]O 
	WHERE O.ID_DEPARTMENT = @id_department
)
