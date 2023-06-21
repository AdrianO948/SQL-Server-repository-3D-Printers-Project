USE [BUBUBIBI]
GO
/****** Object:  UserDefinedFunction [dbo].[RETURN_TIME_NEEDED_TO_COMPLETE_ORDER]    Script Date: 21.06.2023 16:58:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER FUNCTION [dbo].[RETURN_TIME_NEEDED_TO_COMPLETE_ORDER] 
(	
	@id_order int
)
RETURNS TABLE 
AS
RETURN 
(
	SELECT SUM(DE.PRINT_TIME * ESS.QUANTITY * OE.QUANTITY)Time_to_print_set
	FROM [dbo].[DICT_ELEMENT]DE 
	JOIN [dbo].[ELEMENT_SET_SPECIFICATION]ESS ON ESS.ID_ELEMENT = DE.ID_ELEMENT
	JOIN ELEMENT_SET ES ON ES.ID_ELEMENT_SET = ESS.ID_ELEMENT_SET
	JOIN ORDER_ELEMENT OE ON OE.ID_ELEMENT_SET = ES.ID_ELEMENT_SET 
	WHERE OE.ID_ORDER = @id_order
)