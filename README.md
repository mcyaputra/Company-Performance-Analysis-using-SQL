

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

### :arrow_forward: Analysis 1
Prior to the annual review of Northwind's pricing strategy, Product team wants to look at the products currently being offered, we were asked to provide list of:

A. Product name
B. Product unit price

With the following conditions:

A. Unit price is between $10 and $50
B. Products are not discontinued

<details>
<summary>
**:chart_with_upwards_trend: Query**
</summary>

```SQL
SELECT product_name,
	   unit_price
FROM products p 
WHERE unit_price BETWEEN 10 AND 50 
AND discontinued = 0
ORDER BY product_name ASC;
```

**Result:**

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

### :arrow_forward: Analysis 2
Logistic team wants to conducts analysis of their performance in 1997, to identify which countries didn’t perform well. They asked us to provide them the list of countries with the following information:

A. Average days between order date and shipping date
B. Total number of unique orders (based on order id) 

Filtered based on the following conditions:
 
A. Order date is in 1997
B. Average days between order date and shipping date is >= 3 days but < 20 days 
C. Total number of orders is greater than 5

Order the results by average days between the order date and the shipping date in descending order.

<details>
<summary>
:chart_with_upwards_trend: Query
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
```

Result:

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

</details>

### :arrow_forward: Analysis 3
People Operation team wants to know the age of each employee when they first join the company and their current manager. We are tasked to provide them with a list of all employees including:

A. Full name
B. Job title
C. Age (at the time of joining the company)
D. their tenure in years until current date
E. Manager's full name
F. Manager's job title

Order the results by employee age and employee full name in ascending order (lowest first).

<details>
<summary>
:chart_with_upwards_trend: Query
</summary>

```SQL
WITH new_table AS (SELECT 
		CONCAT(first_name, ' ', last_name) AS employee_full_name,
		title AS employee_title,
		EXTRACT(YEAR FROM AGE(hire_date, birth_date)) AS employee_age,
		EXTRACT(YEAR FROM AGE(CURRENT_DATE, hire_date)) AS employee_tenure,
		reports_to
FROM employees e)

SELECT  employee_full_name,
		employee_title,
		employee_age,
		employee_tenure,
		concat(e.first_name,' ', e.last_name) AS manager_full_name,
		e.title AS manager_title
FROM new_table n
LEFT JOIN employees e ON e.employee_id = n.reports_to
ORDER BY employee_age ASC, employee_full_name ASC;
```

Result:

| employee_full_name |      employee_title      | employee_age | employee_tenure | manager_full_name |     manager_title     |
| ------------------ | ------------------------ | ------------ | --------------- | ----------------- | --------------------- |
| Anne Dodsworth     | Sales Representative     | 28           | 27              | Steven Buchanan   | Sales Manager         |
| Janet Leverling    | Sales Representative     | 28           | 30              | Andrew Fuller     | Vice President, Sales |
| Michael Suyama     | Sales Representative     | 30           | 28              | Steven Buchanan   | Sales Manager         |
| Robert King        | Sales Representative     | 33           | 28              | Steven Buchanan   | Sales Manager         |
| Laura Callahan     | Inside Sales Coordinator | 36           | 28              | Andrew Fuller     | Vice President, Sales |
| Steven Buchanan    | Sales Manager            | 38           | 28              | Andrew Fuller     | Vice President, Sales |
| Andrew Fuller      | Vice President, Sales    | 40           | 30              |                   |                       |
| Nancy Davolio      | Sales Representative     | 43           | 30              | Andrew Fuller     | Vice President, Sales |
| Margaret Peacock   | Sales Representative     | 55           | 29              | Andrew Fuller     | Vice President, Sales |

</details>

### :arrow_forward: Analysis 4
Again, Logistics Team asked for our help to analyze their global performances from 1996 to 1997, to identify which month they perform well. We need provide them a list with:

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
:chart_with_upwards_trend: Query
</summary>

```SQL
SELECT CAST(year_month AS date),
	   total_number_orders,
	   total_freight 
FROM (SELECT to_char(date_trunc('month', order_date), 'YYYY-MM-DD') AS year_month,
	  		 count(order_id) AS total_number_orders,
	   		 round(CAST(sum(freight) AS NUMERIC), 0) AS total_freight
	  FROM orders
	  GROUP BY 1) cte
WHERE year_month BETWEEN '1996' AND '1998'
AND total_number_orders > 20
AND total_freight > 2500
ORDER BY total_freight DESC
```

Result:

| year_month | total_number_orders | total_freight |
| ---------- | ------------------- | ------------- |
| 1997-10-01 | 38                  | 3946          |
| 1997-12-01 | 48                  | 3758          |
| 1997-05-01 | 32                  | 3461          |
| 1997-09-01 | 37                  | 3237          |
| 1997-08-01 | 33                  | 3078          |
| 1997-04-01 | 31                  | 2939          |
| 1996-12-01 | 31                  | 2799          |

</details>

### :arrow_forward: Analysis 5
Pricing Team wants to analyze which products had experienced price increases not in between 10% and 30%. We need to provide them a list of products including:

A. Product name
B. Current unit price
C. Initial/Previous unit price
D. Percentage increase

Filtered based on the following conditions:

A. Percentage increase is not between 10% and 30%
B. Finally order the results by percentage increase (ascending order).

<details>
<summary>
:chart_with_upwards_trend: Query
</summary>

```SQL
SELECT product_name,
	   ROUND(CAST(current_price AS NUMERIC), 2) AS current_price ,
	   ROUND(CAST(previous_unit_price AS NUMERIC), 2) AS previous_unit_price ,
	   ROUND(CAST(((current_price/previous_unit_price)-1)*100 AS NUMERIC), 4) AS percentage_increase
FROM (
		SELECT product_name,
	    	   max(od.order_id) AS latest_order_id,
	    	   max(od.unit_price) AS current_price,
	    	   min(od.order_id) AS oldest_order_id,
	 		   min(od.unit_price) AS previous_unit_price	
		FROM products prod
		LEFT JOIN order_details od ON od.product_id = prod.product_id 
		GROUP BY product_name) list
WHERE ROUND(CAST(((current_price/previous_unit_price)-1)*100 AS numeric), 4) NOT BETWEEN 10 AND 30
ORDER BY percentage_increase ASC
```

Result:

| product_name                  | current_price | previous_unit_price | percentage_increase |
| Singaporean Hokkien Fried Mee | 14.00         | 9.80                | 42.8571             |
| Queso Cabrales                | 21.00         | 14.00               | 50.0000             |


</details>

### :arrow_forward: Analysis 6

Pricing Team asks us to help analyze the performance of each product category based on price range. We need to provide them with:

A. Category name
B. Price range as: 
“Below $10”
“$10 - $20”
“$20 - $50”
“Over $50”

C. Total amount taking into account discount (i.e. subtracting the discounted amount)
D. Volume of orders (number of orders per category)

Order result by category name then price range (ascending order).

<details>
<summary>
:chart_with_upwards_trend: Query
</summary>

```SQL
WITH table_2 AS (SELECT 
	   sum(od.unit_price*od.quantity*(1-od.discount)) AS total_sales_amount,
	   od.unit_price,
	   od.order_id  AS total_number_orders,
	   cat.category_name
FROM order_details od 
LEFT JOIN products prod ON prod.product_id = od.product_id 
LEFT JOIN categories cat ON cat.category_id = prod.category_id 
GROUP BY  od.unit_price, cat.category_name, order_id 
)


SELECT category_name,
	   CASE WHEN unit_price < 10 THEN '1. Below $10'
	   		WHEN unit_price BETWEEN 10 AND 20 THEN '2. $10-$20'
	   		WHEN unit_price BETWEEN 20 AND 50 THEN '3. $20-$50'
	   		ELSE '4. OVER $50' END AS price_range,
	   	ROUND(CAST(sum(total_sales_amount) AS NUMERIC), 2) AS total_amount,
	   	count(DISTINCT (total_number_orders)) AS total_number_orders
FROM table_2
GROUP BY category_name, price_range
ORDER BY category_name ASC, price_range ASC
```

Result:

| category_name  | price_range  | total_amount | total_number_orders |
| -------------- | ------------ | ------------ | ------------------- |
| Beverages      | 1. Below $10 | 12681.85     | 94                  |
| Beverages      | 2. $10-$20   | 90262.89     | 238                 |
| Beverages      | 3. $20-$50   | 23526.70     | 28                  |
| Beverages      | 4. OVER $50  | 141396.74    | 24                  |
| Condiments     | 1. Below $10 | 784.00       | 3                   |
| Condiments     | 2. $10-$20   | 35291.36     | 99                  |
| Condiments     | 3. $20-$50   | 69971.72     | 100                 |
| Confections    | 1. Below $10 | 11698.70     | 68                  |
| Confections    | 2. $10-$20   | 50911.18     | 155                 |
| Confections    | 3. $20-$50   | 82183.99     | 87                  |
| Confections    | 4. OVER $50  | 22563.36     | 16                  |
| Dairy Products | 1. Below $10 | 1648.12      | 32                  |
| Dairy Products | 2. $10-$20   | 25312.60     | 79                  |
| Dairy Products | 3. $20-$50   | 158503.06    | 201                 |
| Dairy Products | 4. OVER $50  | 49043.50     | 35                  |
| Grains/Cereals | 1. Below $10 | 7932.65      | 49                  |
| Grains/Cereals | 2. $10-$20   | 16435.91     | 53                  |
| Grains/Cereals | 3. $20-$50   | 71376.03     | 89                  |
| Meat/Poultry   | 1. Below $10 | 4728.24      | 36                  |
| Meat/Poultry   | 2. $10-$20   | 7569.60      | 11                  |
| Meat/Poultry   | 3. $20-$50   | 63129.35     | 85                  |
| Meat/Poultry   | 4. OVER $50  | 87595.17     | 36                  |
| Produce        | 1. Below $10 | 1520.00      | 8                   |
| Produce        | 2. $10-$20   | 3730.40      | 14                  |
| Produce        | 3. $20-$50   | 61023.53     | 82                  |
| Produce        | 4. OVER $50  | 33710.65     | 30                  |
| Seafood        | 1. Below $10 | 19624.88     | 109                 |
| Seafood        | 2. $10-$20   | 45485.04     | 116                 |
| Seafood        | 3. $20-$50   | 43204.94     | 76                  |
| Seafood        | 4. OVER $50  | 22946.87     | 21                  |

</details>

### :arrow_forward: Analysis 7

Analyzing the current stock level of the company's regional suppliers for each product category, table will consists:

A. Category name
B. Supplier region” as: 
-America
-Europe
-Asia
-Oceania
C. Total units in stock
D. Total units on order
E. Total reorder level

Order result by supplier region, then category name and reorder level (in ascending order).

<details>
<summary>
:chart_with_upwards_trend: Query
</summary>

```SQL
SELECT category_name,
	   CASE WHEN supp.country = 'Australia' THEN 'Oceania'
	   		WHEN supp.country IN ('Japan', 'Singapore') THEN 'Asia'
	   		WHEN supp.country IN ('USA', 'Brazil', 'Canada') THEN 'America'
	   ELSE 'Europe' END AS supplier_region,
	   sum(unit_in_stock) AS units_in_stock,
	   sum(unit_on_order) AS units_on_order,
	   sum(reorder_level) AS reorder_level
FROM products prod
LEFT JOIN categories cat ON cat.category_id = prod.category_id 
LEFT JOIN suppliers supp ON supp.supplier_id = prod.supplier_id 
GROUP BY category_name, supplier_region
ORDER BY supplier_region ASC, category_name ASC, reorder_level ASC
```

Result:

| category_name  | supplier_region | units_in_stock | units_on_order | reorder_level |
| -------------- | --------------- | -------------- | -------------- | ------------- |
| Beverages      | America         | 203            | 0              | 40            |
| Condiments     | America         | 372            | 100            | 70            |
| Confections    | America         | 17             | 0              | 0             |
| Meat/Poultry   | America         | 136            | 0              | 30            |
| Produce        | America         | 15             | 0              | 10            |
| Seafood        | America         | 208            | 0              | 40            |
| Beverages      | Asia            | 17             | 10             | 25            |
| Condiments     | Asia            | 66             | 0              | 20            |
| Grains/Cereals | Asia            | 26             | 0              | 0             |
| Meat/Poultry   | Asia            | 29             | 0              | 0             |
| Produce        | Asia            | 39             | 20             | 5             |
| Seafood        | Asia            | 55             | 0              | 5             |
| Beverages      | Europe          | 324            | 40             | 100           |
| Condiments     | Europe          | 45             | 70             | 40            |
| Confections    | Europe          | 340            | 180            | 155           |
| Dairy Products | Europe          | 393            | 140            | 110           |
| Grains/Cereals | Europe          | 244            | 90             | 130           |
| Meat/Poultry   | Europe          | 0              | 0              | 0             |
| Produce        | Europe          | 26             | 0              | 0             |
| Seafood        | Europe          | 396            | 120            | 100           |
| Beverages      | Oceania         | 15             | 10             | 30            |
| Condiments     | Oceania         | 24             | 0              | 5             |
| Confections    | Oceania         | 29             | 0              | 10            |
| Grains/Cereals | Oceania         | 38             | 0              | 25            |
| Meat/Poultry   | Oceania         | 0              | 0              | 0             |
| Produce        | Oceania         | 20             | 0              | 10            |
| Seafood        | Oceania         | 42             | 0              | 0             |

</details>

### :arrow_forward: Analysis 8
Comparing current product pricing to their respective categories average and median unit price. Table will consists:

A. Category name
B. Product name
C. Unit price
D. Category average unit price (formatted to have only 2 decimals)
E. Category median unit price (formatted to have only 2 decimals)
F. Current price compared to category average unit price as:
“Below Average”
“Average”
“Over Average”
G. Current price compared to category median unit price as:
“Below Median”
“Median”
“Over Median”

Filtered based on the following conditions:

A. Product is not discontinued 

Order result by category name then product name (in ascending order).

<details>
<summary>
:chart_with_upwards_trend: Query
</summary>

```SQL
WITH cte AS (SELECT category_id ,
	   ROUND(CAST(percentile_cont(0.5) WITHIN GROUP(ORDER BY unit_price) AS NUMERIC), 2) AS median_unit_price
FROM products p 
WHERE discontinued = 0
GROUP BY category_id )

SELECT category_name,
	   product_name,
	   unit_price,
	   ROUND(CAST(AVG(unit_price) OVER (PARTITION BY category_name) AS NUMERIC), 2) AS average_unit_price,
	   median_unit_price,
	   CASE 
	   		WHEN unit_price < AVG(unit_price) OVER (PARTITION BY category_name) THEN 'Below Average'
	   		WHEN unit_price > AVG(unit_price) OVER (PARTITION BY category_name) THEN 'Over Average'
	   		ELSE 'Average'
	   END "average_unit_price_position",
	   CASE 
	   		WHEN unit_price < median_unit_price THEN 'Below Median'
	   		WHEN unit_price > median_unit_price THEN 'Over Median'
	   		ELSE 'Median'
	   END "median_unit_price_position"
	   
FROM products prod
LEFT JOIN categories cat ON cat.category_id = prod.category_id 
LEFT JOIN cte cte ON cte.category_id = prod.category_id 
WHERE discontinued = 0
GROUP BY 1,2,3,5
ORDER BY 1 ASC, 2 ASC
```

Result:

| category_name  |           product_name           | unit_price | average_unit_price | median_unit_price | average_unit_price_position | median_unit_price_position |
| -------------- | -------------------------------- | ---------- | ------------------ | ----------------- | --------------------------- | -------------------------- |
| Beverages      | Chartreuse verte                 | 18         | 46.03              | 18                | Below Average               | Median                     |
| Beverages      | Côte de Blaye                    | 263.5      | 46.03              | 18                | Over Average                | Over Median                |
| Beverages      | Ipoh Coffee                      | 46         | 46.03              | 18                | Below Average               | Over Median                |
| Beverages      | Lakkalikööri                     | 18         | 46.03              | 18                | Below Average               | Median                     |
| Beverages      | Laughing Lumberjack Lager        | 14         | 46.03              | 18                | Below Average               | Below Median               |
| Beverages      | Outback Lager                    | 15         | 46.03              | 18                | Below Average               | Below Median               |
| Beverages      | Rhönbräu Klosterbier             | 7.75       | 46.03              | 18                | Below Average               | Below Median               |
| Beverages      | Sasquatch Ale                    | 14         | 46.03              | 18                | Below Average               | Below Median               |
| Beverages      | Steeleye Stout                   | 18         | 46.03              | 18                | Below Average               | Median                     |
| Condiments     | Aniseed Syrup                    | 10         | 22.99              | 21.05             | Below Average               | Below Median               |
| Condiments     | Chef Anton's Cajun Seasoning     | 22         | 22.99              | 21.05             | Below Average               | Over Median                |
| Condiments     | Genen Shouyu                     | 13         | 22.99              | 21.05             | Below Average               | Below Median               |
| Condiments     | Grandma's Boysenberry Spread     | 25         | 22.99              | 21.05             | Over Average                | Over Median                |
| Condiments     | Gula Malacca                     | 19.45      | 22.99              | 21.05             | Below Average               | Below Median               |
| Condiments     | Louisiana Fiery Hot Pepper Sauce | 21.05      | 22.99              | 21.05             | Below Average               | Below Median               |
| Condiments     | Louisiana Hot Spiced Okra        | 17         | 22.99              | 21.05             | Below Average               | Below Median               |
| Condiments     | Northwoods Cranberry Sauce       | 40         | 22.99              | 21.05             | Over Average                | Over Median                |
| Condiments     | Original Frankfurter grüne Soße  | 13         | 22.99              | 21.05             | Below Average               | Below Median               |
| Condiments     | Sirop d'érable                   | 28.5       | 22.99              | 21.05             | Over Average                | Over Median                |
| Condiments     | Vegie-spread                     | 43.9       | 22.99              | 21.05             | Over Average                | Over Median                |
| Confections    | Chocolade                        | 12.75      | 25.16              | 16.25             | Below Average               | Below Median               |
| Confections    | Gumbär Gummibärchen              | 31.23      | 25.16              | 16.25             | Over Average                | Over Median                |
| Confections    | Maxilaku                         | 20         | 25.16              | 16.25             | Below Average               | Over Median                |
| Confections    | NuNuCa Nuß-Nougat-Creme          | 14         | 25.16              | 16.25             | Below Average               | Below Median               |
| Confections    | Pavlova                          | 17.45      | 25.16              | 16.25             | Below Average               | Over Median                |
| Confections    | Schoggi Schokolade               | 43.9       | 25.16              | 16.25             | Over Average                | Over Median                |
| Confections    | Scottish Longbreads              | 12.5       | 25.16              | 16.25             | Below Average               | Below Median               |
| Confections    | Sir Rodney's Marmalade           | 81         | 25.16              | 16.25             | Over Average                | Over Median                |
| Confections    | Sir Rodney's Scones              | 10         | 25.16              | 16.25             | Below Average               | Below Median               |
| Confections    | Tarte au sucre                   | 49.3       | 25.16              | 16.25             | Over Average                | Over Median                |
| Confections    | Teatime Chocolate Biscuits       | 9.2        | 25.16              | 16.25             | Below Average               | Below Median               |
| Confections    | Valkoinen suklaa                 | 16.25      | 25.16              | 16.25             | Below Average               | Median                     |
| Confections    | Zaanse koeken                    | 9.5        | 25.16              | 16.25             | Below Average               | Below Median               |
| Dairy Products | Camembert Pierrot                | 34         | 28.73              | 33                | Over Average                | Over Median                |
| Dairy Products | Flotemysost                      | 21.5       | 28.73              | 33                | Below Average               | Below Median               |
| Dairy Products | Geitost                          | 2.5        | 28.73              | 33                | Below Average               | Below Median               |
| Dairy Products | Gorgonzola Telino                | 12.5       | 28.73              | 33                | Below Average               | Below Median               |
| Dairy Products | Gudbrandsdalsost                 | 36         | 28.73              | 33                | Over Average                | Over Median                |
| Dairy Products | Mascarpone Fabioli               | 32         | 28.73              | 33                | Over Average                | Below Median               |
| Dairy Products | Mozzarella di Giovanni           | 34.8       | 28.73              | 33                | Over Average                | Over Median                |
| Dairy Products | Queso Cabrales                   | 21         | 28.73              | 33                | Below Average               | Below Median               |
| Dairy Products | Queso Manchego La Pastora        | 38         | 28.73              | 33                | Over Average                | Over Median                |
| Dairy Products | Raclette Courdavault             | 55         | 28.73              | 33                | Over Average                | Over Median                |
| Grains/Cereals | Filo Mix                         | 7          | 21.29              | 20.25             | Below Average               | Below Median               |
| Grains/Cereals | Gnocchi di nonna Alice           | 38         | 21.29              | 20.25             | Over Average                | Over Median                |
| Grains/Cereals | Gustaf's Knäckebröd              | 21         | 21.29              | 20.25             | Below Average               | Over Median                |
| Grains/Cereals | Ravioli Angelo                   | 19.5       | 21.29              | 20.25             | Below Average               | Below Median               |
| Grains/Cereals | Tunnbröd                         | 9          | 21.29              | 20.25             | Below Average               | Below Median               |
| Grains/Cereals | Wimmers gute Semmelknödel        | 33.25      | 21.29              | 20.25             | Over Average                | Over Median                |
| Meat/Poultry   | Pâté chinois                     | 24         | 15.72              | 15.72             | Over Average                | Over Median                |
| Meat/Poultry   | Tourtière                        | 7.45       | 15.72              | 15.72             | Below Average               | Below Median               |
| Produce        | Longlife Tofu                    | 10         | 29.06              | 26.63             | Below Average               | Below Median               |
| Produce        | Manjimup Dried Apples            | 53         | 29.06              | 26.63             | Over Average                | Over Median                |
| Produce        | Tofu                             | 23.25      | 29.06              | 26.63             | Below Average               | Below Median               |
| Produce        | Uncle Bob's Organic Dried Pears  | 30         | 29.06              | 26.63             | Over Average                | Over Median                |
| Seafood        | Boston Crab Meat                 | 18.4       | 20.68              | 16.7              | Below Average               | Over Median                |
| Seafood        | Carnarvon Tigers                 | 62.5       | 20.68              | 16.7              | Over Average                | Over Median                |
| Seafood        | Escargots de Bourgogne           | 13.25      | 20.68              | 16.7              | Below Average               | Below Median               |
| Seafood        | Gravad lax                       | 26         | 20.68              | 16.7              | Over Average                | Over Median                |
| Seafood        | Ikura                            | 31         | 20.68              | 16.7              | Over Average                | Over Median                |
| Seafood        | Inlagd Sill                      | 19         | 20.68              | 16.7              | Below Average               | Over Median                |
| Seafood        | Jack's New England Clam Chowder  | 9.65       | 20.68              | 16.7              | Below Average               | Below Median               |
| Seafood        | Konbu                            | 6          | 20.68              | 16.7              | Below Average               | Below Median               |
| Seafood        | Nord-Ost Matjeshering            | 25.89      | 20.68              | 16.7              | Over Average                | Over Median                |
| Seafood        | Rogede sild                      | 9.5        | 20.68              | 16.7              | Below Average               | Below Median               |
| Seafood        | Röd Kaviar                       | 15         | 20.68              | 16.7              | Below Average               | Below Median               |
| Seafood        | Spegesild                        | 12         | 20.68              | 16.7              | Below Average               | Below Median               |

</details>

### :arrow_forward: Analysis 9

The Sales Team wants to build a list of KPIs to measure employees' performances. In order to help them they asked you to provide them a list of employees with:

their full name (first name and last name combined in a single field)
their job title
their total sales amount excluding discount (formatted to have only 2 decimals)
their total number of unique orders
their total number of orders
their average product amount excluding discount (formatted to have only 2 decimals). This corresponds to the average amount of product sold (without taking into account any discount applied to it).
their average order amount excluding discount (formatted to have only 2 decimals). This corresponds to the ratio between the total amount of product sold (without taking into account any discount applied to it) against to the total number of unique orders.
their total discount amount (formatted to have only 2 decimals)
their total sales amount including discount (formatted to have only 2 decimals)
Their total discount percentage (formatted to have only 2 decimals)
Finally order the results by total sales amount including discount (descending).

