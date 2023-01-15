
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