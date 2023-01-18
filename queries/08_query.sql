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