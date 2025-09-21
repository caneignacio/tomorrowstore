SELECT
	dbo.Orders.OrderKey,
	dbo.OrderRows.LineNumber,
	dbo.Orders.OrderDate,
	dbo.Orders.DeliveryDate,
	dbo.Orders.CustomerKey,
	dbo.Orders.StoreKey,
	dbo.OrderRows.ProductKey,
	dbo.OrderRows.Quantity,
	dbo.OrderRows.UnitPrice,
	dbo.OrderRows.NetPrice,
	dbo.OrderRows.UnitCost,
	dbo.Orders.CurrencyCode,
	1.01 AS ExchangeRate

INTO dbo.SalesNew
FROM dbo.Orders
FULL JOIN dbo.OrderRows ON dbo.Orders.OrderKey = dbo.OrderRows.OrderKey
;