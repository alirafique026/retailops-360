-- RetailOps 360 | Data Exploration
-- Dataset: Olist Brazilian E-Commerce
-- Tool: MS SQL Server

-- Monthly revenue trend
SELECT
    FORMAT(o.order_purchase_timestamp, 'yyyy-MM') AS order_month,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(oi.price + oi.freight_value), 2) AS total_revenue,
    ROUND(AVG(oi.price), 2) AS avg_order_value
FROM olist_orders o
JOIN olist_order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
    AND o.order_purchase_timestamp >= '2017-01-01'
    AND o.order_purchase_timestamp < '2018-10-01'
GROUP BY FORMAT(o.order_purchase_timestamp, 'yyyy-MM')
ORDER BY order_month;

-- Renaming 2 columns for consistency
EXEC sp_rename 'product_category_name_translation.column1', 
    'product_category_name', 'COLUMN';

EXEC sp_rename 'product_category_name_translation.column2', 
    'product_category_name_english', 'COLUMN';
