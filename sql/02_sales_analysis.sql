/*
============================================
RetailOps 360 | Sales Analysis
============================================
Author      : Mohammad Ali Rafique
Date        : 2026-03-27
Description : Revenue by category, peak days,
              and order volume by day of week
Dataset     : Olist Brazilian E-Commerce
Tool        : MS SQL Server
============================================
*/

-- ============================================
-- 1. Revenue by Product Category
-- ============================================
SELECT
    t.product_category_name_english AS category_english,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(oi.price), 2) AS total_revenue,
    ROUND(AVG(oi.price), 2) AS avg_item_price,
    ROUND(SUM(oi.price) * 100.0 /
        SUM(SUM(oi.price)) OVER (), 2) AS revenue_share_pct
FROM olist_order_items oi
JOIN olist_orders o
    ON oi.order_id = o.order_id
JOIN olist_products p
    ON oi.product_id = p.product_id
JOIN product_category_name_translation t
    ON p.product_category_name = t.product_category_name
WHERE o.order_status = 'delivered'
GROUP BY t.product_category_name_english
ORDER BY total_revenue DESC;


-- ============================================
-- 2. Top 10 Revenue Days
-- ============================================
SELECT TOP 10
    CAST(o.order_purchase_timestamp AS DATE) AS order_date,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(oi.price + oi.freight_value), 2) AS daily_revenue
FROM olist_orders o
JOIN olist_order_items oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY CAST(o.order_purchase_timestamp AS DATE)
ORDER BY daily_revenue DESC;


-- ============================================
-- 3. Order Volume by Day of Week
-- ============================================
SELECT
    DATENAME(WEEKDAY, o.order_purchase_timestamp) AS day_of_week,
    DATEPART(WEEKDAY, o.order_purchase_timestamp) AS day_number,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(AVG(oi.price + oi.freight_value), 2) AS avg_order_value
FROM olist_orders o
JOIN olist_order_items oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY
    DATENAME(WEEKDAY, o.order_purchase_timestamp),
    DATEPART(WEEKDAY, o.order_purchase_timestamp)
ORDER BY day_number;
