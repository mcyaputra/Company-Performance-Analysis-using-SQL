

# Company Analysis (Northwind)

>Analyzing Northwind Traders, importer and exporter of specialty food from and to around the world. We will be performing analysis on the company's performance utilizing their sales [datasets](/Northwind_Dataset.sql).

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
:chart_with_upwards_trend: Query
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

**Result:**

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

**Result:**

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

**Result:**

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

**Result:**

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

**Result:**

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

Analyzing the current stock level of the company's regional suppliers for each product category, table consists of:

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

**Result:**

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
Comparing current product pricing to their respective categories average and median unit price. Table consists of:

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

**Result:**

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

Measuring employees' sales performance. Table consists of:

A. Full name
B. Job title
C. Total sales amount excluding discount 
D. Total number of unique orders
E. Total number of orders
F. Average product price excluding discount
G. Average sales amount excluding discount
H. Total discount
I. Total sales including discount 
K. Total discount percentage

Order result by total sales amount including discount (in descending order).

<details>
<summary>
:chart_with_upwards_trend: Query
</summary>

```SQL
SELECT employee_full_name,
	   employee_title,
	   ROUND(CAST(total_sales AS NUMERIC), 2) AS total_sales_amount_excluding_discount,
	   number_unique_orders,
	   number_orders,
	   ROUND(CAST(total_sales/total_quantity AS NUMERIC), 2) AS average_product_amount,
	   ROUND(CAST(total_sales/number_unique_orders AS NUMERIC), 2) AS average_order_amount,
	   ROUND(CAST(total_discount_amount AS NUMERIC), 2) AS total_discount_amount,
	   ROUND(CAST(total_sales_amount_including_discount AS NUMERIC), 2) AS total_sales_amount_including_discount,
	   ROUND(CAST(total_discount_amount/total_sales AS NUMERIC)*100, 2) AS total_discount_percentage
FROM (SELECT concat(first_name, ' ', last_name) AS employee_full_name,
	  		 title AS employee_title,
	   		 COUNT(DISTINCT od.order_id) AS number_unique_orders,
	   		 COUNT(od.order_id) AS number_orders,
	   		 SUM(od.quantity) AS total_quantity,
	   		 SUM(od.unit_price*od.quantity) AS total_sales,
	   		 SUM(od.unit_price*od.quantity*od.discount) AS total_discount_amount,
	   		 SUM((od.unit_price*od.quantity)*(1-od.discount)) AS total_sales_amount_including_discount
	  FROM order_details od
	  LEFT JOIN orders o ON o.order_id = od.order_id 
	  LEFT JOIN employees e ON e.employee_id = o.employee_id 
	  GROUP BY 1,2) summary
ORDER BY total_sales_amount_including_discount DESC
```

**Result:**

| employee_full_name | employee_title           | total_sales_amount_excluding_discount | number_unique_orders | number_orders | average_product_amount | average_order_amount | total_discount_amount | total_sales_amount_including_discount | total_discount_percentage |
| Margaret Peacock   | Sales Representative     | 250187.45                             | 156                  | 420           | 25.53                  | 1603.77              | 17296.6               | 232890.85                             | 6.91                      |
| Janet Leverling    | Sales Representative     | 213051.3                              | 127                  | 321           | 27.13                  | 1677.57              | 10238.46              | 202812.84                             | 4.81                      |
| Nancy Davolio      | Sales Representative     | 202143.71                             | 123                  | 345           | 25.88                  | 1643.44              | 10036.11              | 192107.6                              | 4.96                      |
| Andrew Fuller      | Vice President, Sales    | 177749.26                             | 96                   | 241           | 29.36                  | 1851.55              | 11211.51              | 166537.76                             | 6.31                      |
| Laura Callahan     | Inside Sales Coordinator | 133301.03                             | 104                  | 260           | 22.54                  | 1281.74              | 6438.75               | 126862.28                             | 4.83                      |
| Robert King        | Sales Representative     | 141295.99                             | 72                   | 176           | 30.36                  | 1962.44              | 16727.76              | 124568.23                             | 11.84                     |
| Anne Dodsworth     | Sales Representative     | 82964                                 | 43                   | 107           | 31.07                  | 1929.4               | 5655.93               | 77308.07                              | 6.82                      |
| Michael Suyama     | Sales Representative     | 78198.1                               | 67                   | 168           | 22.17                  | 1167.14              | 4284.97               | 73913.13                              | 5.48                      |
| Steven Buchanan    | Sales Manager            | 75567.75                              | 42                   | 117           | 24.89                  | 1799.23              | 6775.47               | 68792.28                              | 8.97                      |

</details>

### :arrow_forward: Analysis 10

Measuring employees' performances across each category. Table consists of:

A. Categories
B. Full name
C. Total sales amount including discount
D. Proportion of their total sales amount including discount compared to their sales across all categories
E. Proportion of their total sales amount including discount compared to total sales of the company (all employees)

Order result by category name (ascending) then total sales amount (descending).

<details>
<summary>
:chart_with_upwards_trend: Query
</summary>

```SQL
SELECT category_name,
	   employee_full_name,
	   ROUND(CAST(total_sales AS NUMERIC), 2) AS total_sale_amount,
	   ROUND(CAST(total_sales/total_sales_per_employee_all_categories AS NUMERIC), 5) AS percent_of_employee_sales,
	   ROUND(CAST(total_sales/total_sales_all_employee_per_category AS NUMERIC), 5) AS percent_of_category_sales	   
FROM (SELECT category_name,
	   		 employee_full_name,
	   	   	 total_sales,
	   		 sum(total_sales) OVER(PARTITION BY employee_full_name) AS total_sales_per_employee_all_categories,
	   		 sum(total_sales) OVER(PARTITION BY category_name) AS total_sales_all_employee_per_category
	  FROM( 
	  		SELECT category_name,
	   			   concat(first_name, ' ', last_name) AS employee_full_name,
	   			   sum((unit_price*quantity)*(1-discount)) AS total_sales
			FROM(SELECT od.order_id,
	   					od.product_id,
					    cat.category_name,
					    e.first_name,
					    e.last_name,
					    od.unit_price,
					    od.quantity,
					    od.discount 
				 FROM order_details od
				 LEFT JOIN orders o ON o.order_id = od.order_id 
				 LEFT JOIN employees e ON e.employee_id = o.employee_id 
				 LEFT JOIN products prod ON prod.product_id = od.product_id 
				 LEFT JOIN categories cat ON cat.category_id = prod.category_id
				 ) summ1
			 GROUP BY 1, 2
			 ) summ2
		) summ3
ORDER BY 1 ASC, 3 DESC 
```

**Result**

| category_name  | employee_full_name | total_sale_amount | percent_of_employee_sales | percent_of_category_sales |
| Beverages      | Margaret Peacock   | 50308.21          | 0.21602                   | 0.18781                   |
| Beverages      | Nancy Davolio      | 46599.35          | 0.24257                   | 0.17396                   |
| Beverages      | Janet Leverling    | 44757.4           | 0.22068                   | 0.16709                   |
| Beverages      | Andrew Fuller      | 40248.25          | 0.24168                   | 0.15025                   |
| Beverages      | Robert King        | 27963.83          | 0.22449                   | 0.10439                   |
| Beverages      | Anne Dodsworth     | 19642.55          | 0.25408                   | 0.07333                   |
| Beverages      | Laura Callahan     | 17897.85          | 0.14108                   | 0.06682                   |
| Beverages      | Steven Buchanan    | 11000.53          | 0.15991                   | 0.04107                   |
| Beverages      | Michael Suyama     | 9450.2            | 0.12786                   | 0.03528                   |
| Condiments     | Margaret Peacock   | 23314.87          | 0.10011                   | 0.21985                   |
| Condiments     | Andrew Fuller      | 14850.67          | 0.08917                   | 0.14004                   |
| Condiments     | Laura Callahan     | 14637.66          | 0.11538                   | 0.13803                   |
| Condiments     | Nancy Davolio      | 13561.56          | 0.07059                   | 0.12788                   |
| Condiments     | Janet Leverling    | 13381.64          | 0.06598                   | 0.12619                   |
| Condiments     | Anne Dodsworth     | 10125.54          | 0.13098                   | 0.09548                   |
| Condiments     | Robert King        | 8851.37           | 0.07106                   | 0.08347                   |
| Condiments     | Michael Suyama     | 4648.47           | 0.06289                   | 0.04383                   |
| Condiments     | Steven Buchanan    | 2675.3            | 0.03889                   | 0.02523                   |
| Confections    | Janet Leverling    | 33622.4           | 0.16578                   | 0.2009                    |
| Confections    | Nancy Davolio      | 28568.92          | 0.14871                   | 0.17071                   |
| Confections    | Margaret Peacock   | 27768.73          | 0.11923                   | 0.16592                   |
| Confections    | Laura Callahan     | 21699.91          | 0.17105                   | 0.12966                   |
| Confections    | Andrew Fuller      | 21455.69          | 0.12883                   | 0.1282                    |
| Confections    | Robert King        | 14518.99          | 0.11655                   | 0.08675                   |
| Confections    | Anne Dodsworth     | 8053.16           | 0.10417                   | 0.04812                   |
| Confections    | Michael Suyama     | 6859.63           | 0.09281                   | 0.04099                   |
| Confections    | Steven Buchanan    | 4809.8            | 0.06992                   | 0.02874                   |
| Dairy Products | Nancy Davolio      | 36022.98          | 0.18751                   | 0.15361                   |
| Dairy Products | Margaret Peacock   | 33549.8           | 0.14406                   | 0.14307                   |
| Dairy Products | Janet Leverling    | 32320.83          | 0.15936                   | 0.13782                   |
| Dairy Products | Robert King        | 27621.86          | 0.22174                   | 0.11779                   |
| Dairy Products | Andrew Fuller      | 23812.55          | 0.14299                   | 0.10154                   |
| Dairy Products | Steven Buchanan    | 21937.63          | 0.3189                    | 0.09355                   |
| Dairy Products | Laura Callahan     | 21101.47          | 0.16633                   | 0.08998                   |
| Dairy Products | Anne Dodsworth     | 21101.12          | 0.27295                   | 0.08998                   |
| Dairy Products | Michael Suyama     | 17039.04          | 0.23053                   | 0.07266                   |
| Grains/Cereals | Margaret Peacock   | 22579.61          | 0.09695                   | 0.23583                   |
| Grains/Cereals | Janet Leverling    | 21235.01          | 0.1047                    | 0.22179                   |
| Grains/Cereals | Andrew Fuller      | 11172.95          | 0.06709                   | 0.1167                    |
| Grains/Cereals | Laura Callahan     | 11072.05          | 0.08728                   | 0.11564                   |
| Grains/Cereals | Michael Suyama     | 9410.7            | 0.12732                   | 0.09829                   |
| Grains/Cereals | Nancy Davolio      | 8465.9            | 0.04407                   | 0.08842                   |
| Grains/Cereals | Robert King        | 6535.5            | 0.05247                   | 0.06826                   |
| Grains/Cereals | Steven Buchanan    | 4027.56           | 0.05855                   | 0.04207                   |
| Grains/Cereals | Anne Dodsworth     | 1245.3            | 0.01611                   | 0.01301                   |
| Meat/Poultry   | Margaret Peacock   | 30867.14          | 0.13254                   | 0.18934                   |
| Meat/Poultry   | Andrew Fuller      | 29873.6           | 0.17938                   | 0.18325                   |
| Meat/Poultry   | Robert King        | 21176.72          | 0.17                      | 0.1299                    |
| Meat/Poultry   | Janet Leverling    | 20502.62          | 0.10109                   | 0.12577                   |
| Meat/Poultry   | Laura Callahan     | 16395.28          | 0.12924                   | 0.10057                   |
| Meat/Poultry   | Nancy Davolio      | 15038.47          | 0.07828                   | 0.09225                   |
| Meat/Poultry   | Steven Buchanan    | 11488.2           | 0.167                     | 0.07047                   |
| Meat/Poultry   | Michael Suyama     | 9003.69           | 0.12181                   | 0.05523                   |
| Meat/Poultry   | Anne Dodsworth     | 8676.66           | 0.11223                   | 0.05322                   |
| Produce        | Nancy Davolio      | 19706.25          | 0.10258                   | 0.19709                   |
| Produce        | Margaret Peacock   | 17186.56          | 0.0738                    | 0.17189                   |
| Produce        | Laura Callahan     | 12016.52          | 0.09472                   | 0.12018                   |
| Produce        | Janet Leverling    | 11960.85          | 0.05897                   | 0.11963                   |
| Produce        | Michael Suyama     | 11560.7           | 0.15641                   | 0.11562                   |
| Produce        | Robert King        | 10753.38          | 0.08633                   | 0.10755                   |
| Produce        | Andrew Fuller      | 9376.48           | 0.0563                    | 0.09378                   |
| Produce        | Steven Buchanan    | 7109.02           | 0.10334                   | 0.0711                    |
| Produce        | Anne Dodsworth     | 314.81            | 0.00407                   | 0.00315                   |
| Seafood        | Margaret Peacock   | 27315.93          | 0.11729                   | 0.2081                    |
| Seafood        | Janet Leverling    | 25032.09          | 0.12342                   | 0.1907                    |
| Seafood        | Nancy Davolio      | 24144.15          | 0.12568                   | 0.18394                   |
| Seafood        | Andrew Fuller      | 15747.57          | 0.09456                   | 0.11997                   |
| Seafood        | Laura Callahan     | 12041.54          | 0.09492                   | 0.09174                   |
| Seafood        | Anne Dodsworth     | 8148.9            | 0.10541                   | 0.06208                   |
| Seafood        | Robert King        | 7146.58           | 0.05737                   | 0.05445                   |
| Seafood        | Michael Suyama     | 5940.7            | 0.08037                   | 0.04526                   |
| Seafood        | Steven Buchanan    | 5744.25           | 0.0835                    | 0.04376                   |

</details>