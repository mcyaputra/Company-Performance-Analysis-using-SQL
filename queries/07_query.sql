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