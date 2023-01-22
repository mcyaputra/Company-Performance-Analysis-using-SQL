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


