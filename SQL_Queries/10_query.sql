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
