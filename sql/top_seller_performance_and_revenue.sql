/*
* Apakah prinsip Pareto berlaku di sini? 
* Apakah sebagian besar pendapatan platform kita hanya disumbang oleh segelintir seller "raksasa"? 
* Kita akan cek Top 10 Seller dan persentase kontribusi mereka ke total revenue.
*/
USE ecommerce_database;

WITH seller_revenue AS(
	SELECT
		oi.seller_id,
        COUNT(DISTINCT oi.order_id) AS total_orders,
        SUM(oi.price) AS total_revenue
	FROM order_items oi
    JOIN orders o ON oi.order_id = o.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY oi.seller_id
),
total_platform_revenue AS(
	SELECT SUM(total_revenue) AS grand_total_revenue FROM seller_revenue
)
SELECT
	sr.seller_id,
    sr.total_orders,
    sr.total_revenue,
    ROUND((sr.total_revenue * 100.0 / tpr.grand_total_revenue), 2) AS Percentage_of_total_revenue
FROM seller_revenue sr
CROSS JOIN total_platform_revenue tpr
ORDER BY sr.total_revenue DESC
LIMIT 10;