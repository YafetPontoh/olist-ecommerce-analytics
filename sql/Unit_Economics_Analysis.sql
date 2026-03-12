USE ecommerce_database;

WITH rank_order_sequence AS(
	SELECT
		o.order_id,
        c.customer_unique_id,
        ROW_NUMBER() OVER(PARTITION BY c.customer_unique_id ORDER BY o.order_purchase_timestamp) AS order_sequence
    FROM orders o
    JOIN customers c ON o.customer_id = c.customer_id
	WHERE o.order_status = 'delivered'
),
order_revenue AS (
	SELECT
		ros.customer_unique_id,
		ros.order_id,
        ros.order_sequence,
        SUM(op.payment_value) AS total_revenue
    FROM rank_order_sequence ros
    INNER JOIN order_payments op ON ros.order_id = op.order_id
    GROUP BY ros.customer_unique_id, ros.order_id, ros.order_sequence
)
SELECT 
	CASE
		WHEN order_sequence = 1 THEN 'Acquisition (New_Customer)'
        ELSE 'Retention (Repeat Customer)'
	END AS revenue_category,
    COUNT(order_id) AS total_transactions,
    SUM(total_revenue) AS total_revenue_generated,
    ROUND((SUM(total_revenue) * 100.0 / (SELECT SUM(total_revenue) FROM order_revenue)), 2) AS revenue_percentage
FROM order_revenue
GROUP BY revenue_category
ORDER BY revenue_category;
