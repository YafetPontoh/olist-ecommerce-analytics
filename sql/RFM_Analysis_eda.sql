SELECT * FROM orders;
-- Check First
WITH customer_orders AS(
    SELECT 
		c.customer_unique_id,
		o.order_id,
        o.order_purchase_timestamp,
        o.order_status
	FROM orders o
    JOIN customers c
		ON c.customer_id = o.customer_id
)
    SELECT 
		co.customer_unique_id,
		MAX(co.order_purchase_timestamp) AS last_purchase,
		COUNT(co.order_id) AS frequency,
		SUM(op.payment_value) AS monetary
    FROM customer_orders co
		JOIN order_payments op
	ON co.order_id = op.order_id
    WHERE co.order_status = 'delivered'
    GROUP BY co.customer_unique_id
    ORDER BY frequency DESC;


-- Main
WITH payment_per_order AS (
	SELECT 
		order_id,
		SUM(payment_value) AS total_payment
	FROM order_payments
	GROUP BY order_id
),
rfm_base AS (
	SELECT 
		c.customer_unique_id,
		MAX(o.order_purchase_timestamp) AS last_purchase,
		COUNT(DISTINCT o.order_id) AS frequency,
		SUM(p.total_payment) AS monetary
	FROM orders o
	JOIN customers c ON o.customer_id = c.customer_id
	JOIN payment_per_order p ON o.order_id = p.order_id
	WHERE o.order_status = 'delivered'
	GROUP BY c.customer_unique_id
),
rfm_step2 AS(
	SELECT 
		customer_unique_id,
		DATEDIFF(
			(SELECT MAX(order_purchase_timestamp)
			 FROM orders
			 WHERE order_status = 'delivered'),
			last_purchase
		) AS recency,
		frequency,
		monetary
	FROM rfm_base
), 
scoring_rfm AS (
	SELECT 
		*,
        NTILE(5) OVER(ORDER BY recency DESC) AS r_score,
        NTILE(5) OVER(ORDER BY frequency) AS f_score,
        NTILE(5) OVER(ORDER BY monetary) AS m_score
	FROM rfm_step2
), 
customer_segmentation_category AS (
	SELECT 
		customer_unique_id, 
		recency, 
		frequency, 
		monetary, 
	CASE 
		-- Paling aktif, sering belanja, dan nominalnya besar
		WHEN r_score >= 4 AND f_score >= 4 AND m_score >= 4 THEN '1. Champions'
		-- Sering belanja, tapi mungkin nominalnya tidak sebesar Champion
		WHEN r_score >= 4 AND f_score >= 3 AND m_score >= 3 THEN '2. Loyal Customers'
		-- Pelanggan baru atau potensial (baru beli akhir-akhir ini, tapi belum sering)
		WHEN r_score >= 4 AND f_score <= 2 THEN '3. Potential Loyalists / New'
		-- Dulu sering belanja dan besar, tapi udah lama nggak kelihatan (BAHAYA!)
		WHEN r_score <= 2 AND f_score >= 4 AND m_score >= 4 THEN '4. Cant Lose Them'
		-- Dulu lumayan aktif, sekarang mulai menghilang
		WHEN r_score <= 2 AND f_score >= 3 THEN '5. At Risk'
		-- Belanjanya udah lama banget, jarang, dan nominal kecil
		WHEN r_score <= 2 AND f_score <= 2 THEN '6. Hibernating / Lost'
		-- Sisa pelanggan yang ada di tengah-tengah
		ELSE '7. Average / Regulars' 
	END 
		AS customer_segment
	FROM scoring_rfm
)
SELECT 
	customer_segment, 
    COUNT(*) AS total_customers,
    (COUNT(*) * 100.0 / (SELECT COUNT(*) FROM customer_segmentation_category)) AS percentage 
FROM customer_segmentation_category
GROUP BY customer_segment
ORDER BY percentage DESC;