/*
* Berapa rata-rata uang yang dihabiskan oleh satu pelanggan selama mereka menjadi user kita? 
* Kita akan menghitung LTV (Lifetime Value) rata-rata dari seluruh pengguna.
*/

WITH customer_totals AS (
	SELECT 
		c.customer_unique_id,
        COUNT(DISTINCT o.order_id) AS total_order,
        SUM(DISTINCT op.payment_value) AS total_spend
	FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    JOIN order_payments op ON o.order_id = op.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY c.customer_unique_id
)
SELECT
	COUNT(customer_unique_id) AS total_customer,
    ROUND(AVG(total_order),2) AS average_frequency,
    ROUND(AVG(total_spend), 2) AS average_clv,
    ROUND(SUM(total_spend)/SUM(total_order), 2) AS average_order_value
FROM customer_totals