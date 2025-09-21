# Tomorrowstore

### Overview

The following data analysis project comprises some reports over a business database, with datasets representing the operations of _TomorrowStore_, a fictional retail company specialized in technology. 

The main goal of this work is to provide analytical tools to different areas in the company (Finance, Marketing, Sales, etc.), while also delivering an executive summary for the C-level. Finally, a PowerPoint file will be developed, as if it were to show the main results of Q2 2023 in a presentation by John Doe, Tomorrowstore's CFO, to the rest of the company.

### Tools and Technologies

- SQL Server (Exploratory Data Analysis)
- Power BI Desktop (Data Modelling and Reports Development)
- DAX (Advanced Indicators)
- Power BI Service (Dashboard Development)
- PowerPoint and Adobe Illustrator (Presentation Development)

### Exploratory Data Analysis

The available data for this project consists in eight datasets. They are available in the [SQLBI](https://www.sqlbi.com/tools/contoso-data-generator/) website. They are based on the _Contoso_ Microsoft dataset:

- [currencyexchange.csv](files/currencyexchange.csv): Currency exchange values for different dates.

- [customer.csv](files/customer.csv): Information about each customer.

- [date.csv](files/date.csv): A date table comprising all possible dates to be assigned to the data.

- [orderrows.csv](files/orderrows.csv): A row per each product purchased in an order.

- [orders.csv](files/orders.csv): A row per each order purchased.

- [product.csv](files/product.csv): Information about the different products sold by the company.

- [sales.csv](files/sales.csv): A row per each product purchased in an order.

- [store.csv](files/store.csv): Information about all stores.

As a first step, an initial exploration was performed in SQL Server for each of the files. The queries can be found in the respective “initial-exploration” SQL files (one for each dataset) inside (this folder)[files/SQLfiles]. Then, more detailed aspects were checked directly on PowerQuery, after loading the datasets.

The steps taken and main results can be summed up as follows:

**Initial queries:**

All datasets were queried to have a first look to their different columns and values in them. The commands used to create the tables in SQL and then query them were:

´´´

BULK INSERT Table_Name
FROM '…\table-file.csv'
WITH (
		FIRSTROW = 2,
        		FIELDTERMINATOR = ',',
        		ROWTERMINATOR = '\n'
    	)

SELECT * FROM Table_Name;

´´´

At a first glance, the “sales.csv” dataset had the same information as the “orderrows.csv” and “orders.csv” files combined, with the respective exchange value from the “currencyexchange.csv” file. To check this, a new table was created by joining the three files, and then compared to the “sales.csv” dataset, with the following command:

´´´

SELECT * FROM Old_Table
INTERSECT
SELECT * FROM New_Table;

´´´

This query returned all rows in the tables, which showed that our first supposition was correct. As a result, “currencyexchange.csv”, “orderrows.csv” and “orders.csv” were not considered for the rest of the analysis.

**General information:**

After this initial exploration, all datasets were loaded into Power Query, where further analysis and some transformations were performed. Firstly, the number of rows and columns were obtained for each table:

|Table|Num. of Rows|Num. of Columns|
|---|---|---|
|customer.csv|104990|24|
|product.csv|2517|14|
|sales.csv|199873|13|
|store.csv|74|11|

**Null values:**

The number of null values per column was obtained by checking the column quality view in Power Query. Most columns with null values were not considered in further steps, except for _CloseDate_. In this case, stores with no close date were considered open.

- customer.csv:

|Column|% of Null values|
|---|---|
|Company|<1%|

- product.csv:

|Column|% of Null values|
|---|---|
|WeightUnit|10%|
|Weight|15%|

- store.csv:

|Column|% of Null values|
|---|---|
|CloseDate|78%|
|SquareMeters|1%|
|Status|80%|

**Data types:**

In all tables, the data types were automatically configured with the loading process in Power Query. Most columns in all tables are text-type (with data such as codes, locations, names, etc.), some are number-type (mostly representing prices, costs, products and customers characteristics, etc.), and others are date-type (with sales dates, stores opening and closing dates, etc.)

**Statistical summary:**

Some general statistical indicators were drawn for numeric columns, using the column profile view in Power Query.

- customer.csv:

|Column|Minimum|Maximum|Mean|Standard deviation|
|---|---|---|---|---|
|Age|19|85|51.384|19.1776|
|Latitude|-43.3465|-10.0262|-32.6165|5.3336|
|Longitude|114.3860|156.3118|143.9523|10.2978|

- product.csv:

|Column|Minimum|Maximum|Mean|Standard deviation|
|---|---|---|---|---|
|Weight|0.17|90.8|14.2437|15.3394|
|Cost|0.48|960.82|139.7715|152.0434|
|Price|0.95|2899.99|338.6505|431.3865|

- sales.csv:

|Column|Minimum|Maximum|Mean|Standard deviation|
|---|---|---|---|---|
|LineNumber|0|6|1.147|1.3503|
|Quantity|1|10|3.048|2.2541|
|UnitPrice|3.486|3247.5|331.657|484.2206|
|NetPrice|3.0328|2825.325|310.3308|449.9586|
|UnitCost|1.778|1075.95|134.5462|178.816|
|ExchangeRate|0.6416|1.2907|0.946|0.1784|

- store.csv:

|Column|Minimum|Maximum|Mean|Standard deviation|
|---|---|---|---|---|
|SquareMeters|245|3500|1494.7945|691.7959|

**Cardinality:**

For each dataset, the number of distinct values per column was checked with the column profile view. Each table has its own natural key in a single column (except for “sales.csv”):

- customer.csv: _CustomerKey_
- product.csv: _ProductKey_
- sales.csv: Concatenation of _OrderKey_ and _LineNumber_
- store.csv: _StoreKey_

### Data Modelling

A semantic model was built on Power BI, with a fact table: _Sales_ (based on sales.csv), and three dimension tables: _Customer_, _Product_, and _Store_ (respectively based on each homonymous dataset).

The data from the files was first uploaded to Power BI and transformed in the PowerQuery editor. For all tables, data types were revised and changed when needed (e.g. codes were transformed from number-type into text-type).

In addition, the text values “Contoso” and “Contoso Store” were replaced for “TomorrowStore”, to represent products and stores belonging to the company this project refers to. More precisely, these changes were made in _Products_ (for _ProductName_, _Manufacturer_, and _Brand_ columns) and _Store_ (for _Description_ column). 

After creating the four main tables, some dimension tables were added, both as Power Query tables and DAX calculated tables:

- Firstly, two location tables were created, to represent separate relationships to _Customer_ and _Store_ (and, through them, to _Sales_). This was done by creating a _locationsource_ table with the location-related columns from “customer.csv”, a second _LocationStore_ table based on “store.csv”, and merging both into _LocationStore_ (only keeping _GeoAreaKey_, _Continent_, _State_, and _Country_). After deleting all duplicate rows, this table was copied into a new _LocationCustomer_ table.

- Secondly, three date tables were created to represent one-to-many relationships to _Customer_, _Sales_, and _Store_. These were: _DateCustomerBirthday_, _DateCustomer_, _DateSales_, and _DateStore_. They were created by using the CALENDAR() function over the union of the date columns of each table (that is, to consider the widest possible range of dates in each whole table). Additionally, an _AllDatesAnalysis_ table was created, using the CALENDARAUTO() function, with no relationships to other tables, just to be used in measures and visuals.

- Finally, a _ProductPairAnalysis_ table was created in Power Query, as a way to show which pairs of products were purchased most frequently. This was done by following these steps:
1. Reference _Sales_ into a new query.
2. Group its rows by _OrderKey_.
3. Generate a list of all possible product pairs for each order (each product with its _ProductKey_ and _ProductName_ columns).
4. Expand the list for each order into separate columns.
5. Group the rows of this new table by all their columns. This way, a new _Frequency_ column shows how many times each combination of two products has taken place.

Many measures were created in DAX, for later use in visuals:

- Customers: _ActiveCustomers_, _CustomersWithOrders_, _AverageCustomerRevenue_, _CustomerRetentionRate_, _RepeatPurchaseRate_.
- Financial & Sales: _AverageOrderValue_, _CostOfSoldGoods_, _GrossProfit_, _GrossProfitMargin_, _MoM_GrossProfit_, _MoM_Revenue_, _Revenue_, _YoY_GrossProfit_, _YoY_Revenue_.
- Stores: _ActiveStores_.

The following calculated columns were created for their use on _Financial & Sales_ measures:

- SaleNetPrice(USD) = ´Sales[NetPrice] * Sales[Quantity] * Sales[ExchangeRate]´
- SaleCost(USD) = ´Sales[UnitCost] * Sales[Quantity] * Sales[ExchangeRate]´
- SaleProfit(USD) = ´Sales[SaleNetPrice] – Sales[SaleCost]´

In addition, the following columns were added to _Customer_, to be used in measures and visuals:
- FullName (in Power Query) = ´Table.AddColumn(#"Filtered Rows", "FullName", each [Surname] & " " & [GivenName] & " " & [CustomerKey])´
- IsActive (in DAX) = ´AND(Customer[StartDT] <= TODAY(), Customer[EndDT] > TODAY())´
- NextBirthday (in DAX) = 
´´´
VAR ThisYearBD = DATE(YEAR(TODAY()), MONTH(Customer[Birthday]), day(Customer[Birthday]))
VAR NextYearBD = DATE(YEAR(TODAY()) + 1, MONTH(Customer[Birthday]), day(Customer[Birthday]))
RETURN
IF(
    ThisYearBD >= TODAY(),
    ThisYearBD,
    NextYearBD)
´´´

The following image shows the definitive semantic model:

!()

### Power BI Report

The model was published into Power BI Service and used as a data source for all reports. Each report was created using specific columns and measures from this model.

The first report, _Financial & Sales_, shows general economic indicators about TomorrowStore’s activity, such as revenue and profit. It has a Front Cover and the following three pages:
- General stats: It shows cards with Revenue, Average Order Value, Gross Profit, CoGS, and Gross Profit Margin. It also has a date slicer.
 !()

- Revenue: It shows cards with Revenue and Average Order Value. It also shows a line chart with revenue comparison over different periods of time (with buttons to change between Year-to-year and Month-to-month Revenue). In addition, it has slicers to select Countries, Product Categories, Products, and Dates.
!()
 
- Gross Profit: It has the same visuals and slicers as the previous page, but showing Gross Profit and CoSG instead of Revenue and Average Order Value.
!()

The second report, _Stores_, shows indicators and detailed information about stores. It has a Front Cover and the following two pages:
- Stores: It shows a card with the total Number of Stores and a bar chart with the Top 10 Stores (with buttons to change between two dimensions: Revenue and Gross Profit). It also has slicers to select Countries, Product Categories, and Dates.
!()
 
- Countries: It shows a filled map at the Countries level and a bar chart with a ranking of Countries (with buttons to change between three dimensions: Number of Stores, Revenue, and Gross Profit). It also has slicers to select Product categories and Dates.
!()

The third report, _Products_, shows indicators and detailed information about TomorrowStore’s products. It has a Front Cover and the following three pages:
- Products: It shows a card with the total Number of Products and a bar chart with the Top 10 Products (with buttons to change between four dimensions: Number of Customers, Units Sold, Revenue, and Gross Profit). It has a table that shows the Top Pair (or pairs) of Products most frequently bought together. It also has slicers to select Countries, Product Categories, Product Subcategories, and Dates.
!()

- Categories: It shows two bar charts, one with the Top 3 Product Categories and the other with the Top 3 Product Subcategories (with buttons to change between four dimensions: Customers, Units Sold, Revenue, and Gross Profit). It also has slicers to select Countries and Dates.
!()
 
- Price Analysis: It shows two scatter plot charts, one comparing Price to Units Sold, and the other comparing Price to Unit Cost. It also has slicers to select Product Categories, Product Subcategories, and Dates.
!()

The fourth and last report, _Customers_, shows indicators and detailed information about TomorrowStore’s clients, with some visuals designed for direct actions. It has a Front Cover and the following three pages:
- Top Customers: It shows a card with the Number of Customers, a bar chart with the Top 10 Customers by Revenue, and a table with the Top 100 Customers whose birthday is on this day (to be used for mailing campaigns). It has slicers to select Countries.
!()

- Customer Stats: It shows three cards, respectively representing Number of Customers with Orders (not to be confused with Active Customers), Average Customer Revenue, and Repeat Purchase Rate. It also has two line charts, showing the Customer Retention Rate and the evolution of the Number of Active Customers. In addition, it has a slicer to select Countries, and two more slicers to select Dates: one date relative to the cards and the Retention Rate line chart, and the other only affecting the Active Customers line chart. It should be noted that the Active Customers visual refers to customer creation and/or deletion dates, while the rest of the visuals refer to sales dates, hence the need for two different date slicers.
!()
 
- Customer demographics: It shows a filled map at countries level with the Location of Customers. It also has a pie chart representing Sex, and a column chart for Age distribution. It has one slicer to select Dates.
!()

The _Customers_ report is also available in a mobile version.
!()

### Key Insights

As stated at the beginning of this project description, the goal of the analysis was to extract the main Tomorrowstore's results in Q2 2023. The different reports allow to extract some interesting insights in this direction:

- 

## Powerpoint Presentation

As it was previously stated, an informational video was developed with the main conclusions of this analysis. It was designed as if it were authored by _Policy Checkers_, a fictional NGO which informs the public about different policies worldwide and their impact.

The [informational-video.mp4] video file can be found on this Github repository.

### Data Source

UNESCO Institute for Statistics (UIS), [https://databrowser.uis.unesco.org/browser/EDUCATION/UIS-SDG4Monitoring/t4.4/i4.4.3](https://databrowser.uis.unesco.org/browser/EDUCATION/UIS-SDG4Monitoring/t4.4/i4.4.3), July 18th 2025.

UNESCO Institute for Statistics (UIS), [https://databrowser.uis.unesco.org/browser/EDUCATION/UIS-SDG9Monitoring/t9.5/i9.5.2?highlightId=i9.5.2](https://databrowser.uis.unesco.org/browser/EDUCATION/UIS-SDG9Monitoring/t9.5/i9.5.2?highlightId=i9.5.2), July 16th 2025.

UNESCO Institute for Statistics (UIS), [https://databrowser.uis.unesco.org/browser/EDUCATION/UIS-SDG4Monitoring/t1.a/i1.a.2?highlightId=XGOVEXP.IMF&highlightGroupId=IG-XGOVEXP.IMF](https://databrowser.uis.unesco.org/browser/EDUCATION/UIS-SDG4Monitoring/t1.a/i1.a.2?highlightId=XGOVEXP.IMF&highlightGroupId=IG-XGOVEXP.IMF), June 27th 2025.

UN Statistics Division (UNSD), [https://unstats.un.org/unsd/methodology/m49/overview/](https://unstats.un.org/unsd/methodology/m49/overview/), extracted from [CODE FOR IATI](https://codelists.codeforiati.org/RegionM49/).

### References

Gutpa S. (2025, February 25). Funding education as an investment in the future. [https://www.unesco.org/sdg4education2030/en/articles/funding-education-investment-future]( https://www.unesco.org/sdg4education2030/en/articles/funding-education-investment-future)

World map image in informational video by Al MacDonald [2]/ twitter account @F1LT3R, CC BY-SA 3.0, https://commons.wikimedia.org/w/index.php?curid=7469140

Music in informational video: Expedition by Alex-Productions https://soundcloud.com/alexproductionsmusic
License: Creative Commons — Attribution 3.0 Unported — CC BY 3.0
Free Download / Stream: https://www.audiolibrary.com.co/alex-productions/expedition
Music promoted by Audio Library: https://youtu.be/-_CEmB_dHpA
