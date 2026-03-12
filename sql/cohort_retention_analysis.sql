USE ecommerce_database;

/*
* Melacak seberapa banyak pelanggan yang kembali bertransaksi di bulan-bulan berikutnya 
* setelah pembelian pertama mereka.
*/

WITH first_purchase AS (
	-- Find The Month the Customer First Shopped (Cohort Month)
    SELECT
		c.customer_unique_id,
        DATE_FORMAT(MIN(o.order_purchase_timestamp), '%Y-%m-01') AS cohort_month
	FROM customers c
    INNER JOIN orders o ON c.customer_id = o.customer_id
    WHERE order_status = 'delivered'
    GROUP BY c.customer_unique_id
),
order_activities AS(
	-- Find all the months in which customers shopped.
    SELECT
		c.customer_unique_id,
        DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m-01') AS activity_month
	FROM customers c 
    INNER JOIN orders o ON c.customer_id = o.customer_id
    WHERE o.order_status = 'delivered'
),
cohort_distance AS(
	-- Calculates the month distance (Month Index) between the first purchase and the next purchase.
    SELECT
		fp.cohort_month,
        TIMESTAMPDIFF(
			MONTH, 
            STR_TO_DATE(fp.cohort_month, '%Y-%m-%d'), 
            STR_TO_DATE(oa.activity_month, '%Y-%m-%d')
		) AS month_index,
        fp.customer_unique_id
	FROM first_purchase fp
    INNER JOIN order_activities oa ON fp.customer_unique_id = oa.customer_unique_id
)
SELECT 
	cohort_month,
	month_index, 
    COUNT(DISTINCT customer_unique_id) AS total_customers
FROm cohort_distance
GROUP BY cohort_month, month_index
ORDER BY cohort_month ASC, month_index ASC;
	