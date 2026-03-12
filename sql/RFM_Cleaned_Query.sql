USE ecommerce_database;

WITH rfm_base AS (
	SELECT 
		c.customer_unique_id,
		MAX(o.order_purchase_timestamp) AS last_purchase,
		COUNT(DISTINCT o.order_id) AS frequency,
		SUM(op.payment_value) AS monetary
	FROM customers c
	JOIN orders o 
		ON c.customer_id = o.customer_id
	JOIN order_payments op 
		ON o.order_id = op.order_id
	WHERE o.order_status = 'delivered'
	GROUP BY c.customer_unique_id
),

rfm AS (
	SELECT *,
		DATEDIFF(MAX(last_purchase) OVER(), last_purchase) AS recency
	FROM rfm_base
)

SELECT
	CASE 
		WHEN r_score >=4 AND f_score >=4 AND m_score >=4 THEN 'Champions'
		WHEN r_score >=4 AND f_score >=3 AND m_score >=3 THEN 'Loyal Customers'
		WHEN r_score >=4 AND f_score <=2 THEN 'Potential Loyalists'
		WHEN r_score <=2 AND f_score >=4 THEN 'Cant Lose Them'
		WHEN r_score <=2 AND f_score >=3 THEN 'At Risk'
		WHEN r_score <=2 AND f_score <=2 THEN 'Hibernating'
		ELSE 'Regular'
	END AS segment,
	COUNT(*) AS total_customer
FROM (
	SELECT *,
		NTILE(5) OVER(ORDER BY recency DESC) AS r_score,
		NTILE(5) OVER(ORDER BY frequency) AS f_score,
		NTILE(5) OVER(ORDER BY monetary) AS m_score
	FROM rfm
) s
GROUP BY segment
ORDER BY total_customer DESC;