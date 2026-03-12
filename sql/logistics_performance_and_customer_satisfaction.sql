USE ecommerce_database;

USE ecommerce_database;

WITH delivery_metrics AS (
	SELECT 
		o.order_id,
		ors.review_score,
		DATEDIFF(o.order_delivered_customer_date, o.order_estimated_delivery_date) AS delivery_delay
	FROM orders o
	JOIN order_reviews ors
		ON o.order_id = ors.order_id
	WHERE o.order_status = 'delivered'
)
SELECT
	CASE
		WHEN delivery_delay > 0 THEN 'Late Delivery'
		WHEN delivery_delay = 0 THEN 'On Time'
		ELSE 'Early Delivery'
	END AS delivery_status,
	COUNT(*) AS total_orders,
	AVG(review_score) AS avg_review_score
FROM delivery_metrics
GROUP BY delivery_status;