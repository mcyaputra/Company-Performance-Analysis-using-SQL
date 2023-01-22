

# Company Analysis (Northwind)

>We are taking this opportunity to analyze Northwind Traders, importer and exporter of specialty food from and to around the world. We will be performing analysis on the company's performance utilizing their sales [datasets](/Northwind_Dataset.sql).

| No  |      Table_Name      | # of Rows |                                                       Description                                                        |
| --- | -------------------- | --------- | ------------------------------------------------------------------------------------------------------------------------ |
| 1   | Categories           | 8         | List of Category ID and names along with detailed description                                                            |
| 2   | Customers            | 91        | Comprehensive list of Northwind Trader's customers, from customer IDs, company names, addresses and contacts information |
| 3   | Employees            | 9         | List of Northwind Trader's employees: Names, birthdays, hire dates, contact information and addresses                    |
| 4   | Employee Territories | 49        | List of territory ID and related employee                                                                                |
| 5   | order_details        | 2,155     | List of products sold, from order IDs, product IDs, prices, quantity sold and discounts                                  |
| 6   | orders               | 830       | Customer and shipping details per order, from order IDs, customer IDs, order dates, shipped dates to shipping addresses  |
| 7   | products             | 7         | list of present and past products                                                                                        |
| 8   | region               | 4         | Region descriptions and their IDs                                                                                        |
| 9   | shippers             | 6         | Shipping companies's names, IDs and contact information                                                                  |
| 10  | suppliers            | 29        | detailed list of suppliers, from supplier IDs, company names, addresses, contact information                             |
| 11  | territories          | 53        | list of territory IDs, region IDs and their description                                                                  |
| 12  | usstates             | 51        | list of US states, assigned IDs, state abbreviation and region                                                           |

## Table of Content

## Relationship Diagram:
<p align="center">
    <img width=60% height=60%" src="/Images/Relationship_Diagram.png">


## Analysis (Role playing as an analyst in the company)
1. Prior to the annual review of Northwind's pricing strategy, Product team wants to look at the products currently being offered, we were asked to provide list of:

A. Product name
B. Product unit price

With the following conditions:

A. Unit price is between $10 and $50
B. Products are not discontinued

<details>
<summary>
Query
</summary>

```SQL
SELECT product_name,
	   unit_price
FROM products p 
WHERE unit_price BETWEEN 10 AND 50 
AND discontinued = 0
ORDER BY product_name ASC;
```

Result:

|           product_name           | unit_price |
| -------------------------------- | ---------- |
| Aniseed Syrup                    | 10.0       |
| Boston Crab Meat                 | 18.4       |
| Camembert Pierrot                | 34.0       |
| Chartreuse verte                 | 18.0       |
| Chef Anton's Cajun Seasoning     | 22.0       |
| Chocolade                        | 12.75      |
| Escargots de Bourgogne           | 13.25      |
| Flotemysost                      | 21.5       |
| Genen Shouyu                     | 13.0       |
| Gnocchi di nonna Alice           | 38.0       |
| Gorgonzola Telino                | 12.5       |
| Grandma's Boysenberry Spread     | 25.0       |
| Gravad lax                       | 26.0       |
| Gudbrandsdalsost                 | 36.0       |
| Gula Malacca                     | 19.45      |
| Gumbär Gummibärchen              | 31.23      |
| Gustaf's Knäckebröd              | 21.0       |
| Ikura                            | 31.0       |
| Inlagd Sill                      | 19.0       |
| Ipoh Coffee                      | 46.0       |
| Lakkalikööri                     | 18.0       |
| Laughing Lumberjack Lager        | 14.0       |
| Longlife Tofu                    | 10.0       |
| Louisiana Fiery Hot Pepper Sauce | 21.05      |
| Louisiana Hot Spiced Okra        | 17.0       |
| Mascarpone Fabioli               | 32.0       |
| Maxilaku                         | 20.0       |
| Mozzarella di Giovanni           | 34.8       |
| Nord-Ost Matjeshering            | 25.89      |
| Northwoods Cranberry Sauce       | 40.0       |
| NuNuCa Nuß-Nougat-Creme          | 14.0       |
| Original Frankfurter grüne Soße  | 13.0       |
| Outback Lager                    | 15.0       |
| Pavlova                          | 17.45      |
| Pâté chinois                     | 24.0       |
| Queso Cabrales                   | 21.0       |
| Queso Manchego La Pastora        | 38.0       |
| Ravioli Angelo                   | 19.5       |
| Röd Kaviar                       | 15.0       |
| Sasquatch Ale                    | 14.0       |
| Schoggi Schokolade               | 43.9       |
| Scottish Longbreads              | 12.5       |
| Sir Rodney's Scones              | 10.0       |
| Sirop d'érable                   | 28.5       |
| Spegesild                        | 12.0       |
| Steeleye Stout                   | 18.0       |
| Tarte au sucre                   | 49.3       |
| Tofu                             | 23.25      |
| Uncle Bob's Organic Dried Pears  | 30.0       |
| Valkoinen suklaa                 | 16.25      |
| Vegie-spread                     | 43.9       |
| Wimmers gute Semmelknödel        | 33.25      |

</details>

2. Logistic team wants to conducts analysis of their performance in 1997, to identify which countries didn’t perform well. They asked us to provide them the list of countries with the following information:

A. Average days between order date and shipping date
B. Total number of unique orders (based on order id) 

Filtered based on the following conditions:
 
A. Order date is in 1997
B. Average days between order date and shipping date is >= 3 days but < 20 days 
C. Total number of orders is greater than 5

Order the results by average days between the order date and the shipping date in descending order.

<details>
<summary>
Query
</summary>

```SQL
WITH order_list AS(SELECT ship_country AS shipping_country,
	   shipped_date - order_date AS days,
	   COUNT(order_id) OVER(PARTITION BY order_id) AS total_volume_orders
	   FROM orders o 
	   WHERE EXTRACT(YEAR from(order_date)) = 1997
	   GROUP BY days, ship_country,order_id
	   ORDER BY ship_country ASC)


SELECT *
FROM (SELECT shipping_country,
	   round(AVG(days), 2) AS average_days_between_order_shipping,
	   count(total_volume_orders) AS total_volume_orders
	   FROM order_list
	   GROUP BY shipping_country, total_volume_orders) new_list
WHERE average_days_between_order_shipping >= 3 AND average_days_between_order_shipping < 20
AND total_volume_orders > 5
ORDER BY 2 DESC

| shipping_country | average_days_between_order_shipping | total_volume_orders |
| ---------------- | ----------------------------------- | ------------------- |
| Portugal         | 12.00                               | 7                   |
| USA              | 10.98                               | 60                  |
| Austria          | 10.67                               | 21                  |
| UK               | 10.47                               | 30                  |
| Germany          | 9.56                                | 64                  |
| Ireland          | 9.10                                | 10                  |
| Brazil           | 8.95                                | 42                  |
| Venezuela        | 8.75                                | 20                  |
| Italy            | 8.13                                | 15                  |
| Mexico           | 8.08                                | 12                  |
| Denmark          | 7.91                                | 11                  |
| Belgium          | 7.29                                | 7                   |
| France           | 7.26                                | 39                  |
| Sweden           | 6.65                                | 17                  |
| Switzerland      | 6.63                                | 8                   |
| Canada           | 6.41                                | 17                  |
| Argentina        | 5.67                                | 6                   |
| Finland          | 5.54                                | 13                  |



3. People Operation team wants to know the age of each employee when they first join the company and their current manager. We are tasked to provide them with a list of all employees including:

A. Full name
B. Job title
C. Age (at the time of joining the company)
D. their tenure in years until current date
E. Manager's full name
F. Manager's job title

Order the results by employee age and employee full name in ascending order (lowest first).

<details>
<summary>
Query
</summary>

4. Again, Logistics Team asked for our help to analyze their global performances from 1996 to 1997, to identify which month they perform well. We need provide them a list with:

A. Year/month in a single cell in a date format
B. Total number of orders
C. Total freight (formatted to have no decimals)

Filtered based on the following conditions:

A. Order date is from 1996 to 1997
B. Total number of orders greater than 20 orders
C. Total freight is greater than 2500

Order result by total freight in descending order

<details>
<summary>
Query
</summary>

5. Pricing Team wants to analyze which products had experienced price increases not in between 10% and 30%. We need to provide them a list of products including:

A. Product name
B. Current unit price
C. Initial/Previous unit price
D. Percentage increase

Filtered based on the following conditions:

A. Percentage increase is not between 10% and 30%
B. Finally order the results by percentage increase (ascending order).

<details>
<summary>
Query
</summary>