USE ecommerce_database;

WITH order_items_set AS(
	SELECT
		order_id,
        COUNT(*) AS total_item,
        SUM(price) AS total_price,
        SUM(freight_value) AS total_shipping_payment
	FROM order_items
    GROUP BY order_id
), 
orders_percentage AS(
	SELECT 
		ois.*,
        o.order_status,
        (ois.total_shipping_payment * 100.0 / ois.total_price) AS freight_ratio_percent
	FROM order_items_set ois
	JOIN orders o ON ois.order_id = o.order_id
    WHERE ois.total_price > 0
), 
cost_classification AS (
	SELECT 
		order_id, 
		order_status,
        CASE
			WHEN freight_ratio_percent <= 10 THEN 'Ongkir Murah'
            WHEN freight_ratio_percent <= 25 THEN 'Ongkir Lumayan'
            ELSE 'Ongkir Mahal'
		END AS freight_category
	FROM orders_percentage
)
SELECT 
	freight_category,
    COUNT(*) AS total_orders,
    SUM(CASE WHEN order_status = 'canceled' THEN 1 ELSE 0 END) AS total_cancelled,
    ROUND(SUM(CASE WHEN order_status = 'canceled' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS cancellation_rate_pct
FROM cost_classification
GROUP BY freight_category
ORDER BY cancellation_rate_pct DESC;