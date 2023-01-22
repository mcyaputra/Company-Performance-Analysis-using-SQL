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