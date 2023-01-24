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