BULK INSERT dbo.CurrencyExchange
	FROM 'C:\bitests\20250803-contosolike\csv-100k\currencyexchange.csv'
    WITH (
		FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '\n'
    )

BULK INSERT dbo.OrderRows
	FROM 'C:\bitests\20250803-contosolike\csv-100k\orderrows.csv'
    WITH (
		FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '\n'
    )

BULK INSERT dbo.Orders
	FROM 'C:\bitests\20250803-contosolike\csv-100k\orders.csv'
    WITH (
		FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '\n'
    )

BULK INSERT dbo.Sales
	FROM 'C:\bitests\20250803-contosolike\csv-100k\sales.csv'
    WITH (
		FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '\n'
    )
;