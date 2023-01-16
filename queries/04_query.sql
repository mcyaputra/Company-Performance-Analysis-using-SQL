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