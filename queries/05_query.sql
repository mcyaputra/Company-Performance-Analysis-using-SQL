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