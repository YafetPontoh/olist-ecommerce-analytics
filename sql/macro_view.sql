/* PERTANYAAN BISNIS: 
* Apakah bisnis kita sedang bertumbuh? 
* Bulan apa kita mencetak rekor penjualan tertinggi?
*/
USE ecommerce_database;
WITH monthly_metrics AS (
    SELECT 
        DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS order_month,
        COUNT(DISTINCT o.order_id) AS total_orders,
        SUM(p.payment_value) AS total_revenue
    FROM orders o
    JOIN order_payments p 
        ON o.order_id = p.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m')
)
SELECT 
    order_month,
    total_orders,
    total_revenue,
    LAG(total_revenue) OVER (ORDER BY order_month) AS prev_month_revenue,
    ROUND(
        (total_revenue - LAG(total_revenue) OVER (ORDER BY order_month)) 
        / LAG(total_revenue) OVER (ORDER BY order_month) * 100
    , 2) AS revenue_growth_pct
FROM monthly_metrics
ORDER BY order_month;
-- Information Insight:
/* 
* Terdapat penurunan secara drastis pada revenue bulan Desember, sehingga MoM Januari terlihat seperti persentase kenaikan yang drastis. 
* Terjadi peningkatan total order dan total revenue yang stabil dari bulan  Januari sampai Maret dan Juli - Oktober.
* Peningkatan total orders dan total revenue secara drastis pada bulan November yang bisa dianalisis penyebab kenaikan tersebut, dan berada di kategori product yang mana pembelian tertinggi di bulan tersebut.
* AOV menurun ketika total_order meningkat, yang menandakan bahwa terdapat banyak transaksi berada di sektor transaksi kecil.
*/

