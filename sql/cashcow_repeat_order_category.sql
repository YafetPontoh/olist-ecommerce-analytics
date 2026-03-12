/* PERTANYAAN BISNIS:
* Kategori produk apa yang menjadi (cash cow) perusahaan kita?
*/
USE ecommerce_database;

WITH product_name AS (
	SELECT 
		p.product_id AS product_id, 
        pt.product_category_name_english AS product_category
	FROM products p
    INNER JOIN product_category_name_translation pt
    ON p.product_category_name = pt.product_category_name
), 
order_data AS (
	SELECT
		o.order_id AS order_id,
        oi.product_id AS product_id, 
        oi.price AS price,
        oi.order_item_id AS order_item_id
	FROM orders o
    INNER JOIN order_items oi
    ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
)
SELECT 
	pn.product_category AS product_category, 
    COUNT(order_item_id) AS total_item_sold, 
	SUM(price) AS total_sales_revenue
FROM product_name pn 
INNER JOIN order_data od
ON pn.product_id = od.product_id
GROUP BY product_category
ORDER BY total_sales_revenue DESC, total_item_sold DESC
LIMIT 10;

/* 
* Product category health beauty memili peminat yang sangat tinggi, yaitu 9.465 item penjualan dengan total sales avenue terpaling tinggi, yaitu 1.233.131.
* Product category bed_bath_table memiliki peminat yang paling tinggi, yaitu 10.953 item penjualan dengan total penjualan top 3 tertinggi, yaitu 1.023.434.
* Dari data ini, kita bisa memberikan diskon ataupun membuat paket bundle untuk beberapa product_category yang masih relevan dan tinggi peminatnya (top 10).
*/

