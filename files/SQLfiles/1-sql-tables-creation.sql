CREATE TABLE dbo.Sales (
	OrderKey VARCHAR(100),
	LineNumber VARCHAR(100),
	OrderDate DATE,
	DeliveryDate DATE,
	CustomerKey VARCHAR(100),
	StoreKey VARCHAR(100),
	ProductKey VARCHAR(100),
	Quantity INT,
	UnitPrice FLOAT,
	NetPrice FLOAT,
	UnitCost FLOAT,
	CurrencyCode VARCHAR(100),
	ExchangeRate FLOAT
)

CREATE TABLE dbo.Orders (
	OrderKey VARCHAR(100),
	CustomerKey VARCHAR(100),
	StoreKey VARCHAR(100),
	OrderDate DATE,
	DeliveryDate DATE,
	CurrencyCode VARCHAR(100),
)

CREATE TABLE dbo.OrderRows (
	OrderKey VARCHAR(100),
	LineNumber VARCHAR(100),
	ProductKey VARCHAR(100),
	Quantity INT,
	UnitPrice FLOAT,
	NetPrice FLOAT,
	UnitCost FLOAT
)

CREATE TABLE dbo.CurrencyExchange (
	#Date DATE,
	FromCurrency VARCHAR(100),
	ToCurrency VARCHAR(100),
	Exchange FLOAT
);