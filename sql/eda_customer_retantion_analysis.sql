/*
* Apakah customer kembali membeli?
* Berapa persen customer yang repeat order?
* Apakah bisnis kita retention-driven atau acquisition-driven?
*/
WITH customer_orders AS(
	SELECT 
		c.customer_unique_id, 
        COUNT(o.order_id) AS total_order
	FROM orders o
		INNER JOIN customers c
        ON o.customer_id = c.customer_id
    WHERE o.order_status = 'delivered' 
    GROUP BY c.customer_unique_id
)
SELECT 
	COUNT(*) AS total_customer,
    SUM(CASE WHEN total_order > 1 THEN 1 ELSE 0 END) AS total_repeat_order,
    ROUND(SUM(CASE WHEN total_order > 1 THEN 1 ELSE 0 END) / COUNT(*), 2) AS repeat_rate
FROM customer_orders;

