SELECT
	dbo.CurrencyExchange.#Date,
	dbo.CurrencyExchange.FromCurrency,
	dbo.CurrencyExchange.ToCurrency,
	dbo.CurrencyExchange.Exchange

INTO dbo.CurrencyExchangeNew
FROM dbo.CurrencyExchange
WHERE dbo.CurrencyExchange.FromCurrency = 'USD'
;