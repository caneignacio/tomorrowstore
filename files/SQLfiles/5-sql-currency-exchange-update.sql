ALTER TABLE dbo.SalesNew
ALTER COLUMN ExchangeRate FLOAT

UPDATE dbo.SalesNew
SET dbo.SalesNew.ExchangeRate = dbo.CurrencyExchangeNew.Exchange
FROM dbo.SalesNew
LEFT JOIN dbo.CurrencyExchangeNew
ON dbo.SalesNew.CurrencyCode = dbo.CurrencyExchangeNew.ToCurrency
AND dbo.SalesNew.OrderDate = dbo.CurrencyExchangeNew.#Date
;