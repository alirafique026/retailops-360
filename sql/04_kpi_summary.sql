/*
============================================
RetailOps 360 | KPI Summary
============================================
Author      : Mohammad Ali Rafique
Date        : 2026-03-28
Description : Executive KPI summary covering
              overall business performance,
              delivery metrics, customer
              satisfaction, and revenue health
Dataset     : Olist Brazilian E-Commerce
Tool        : MS SQL Server
============================================
*/


-- ============================================
-- 1. Overall Business KPIs
-- ============================================
SELECT
    COUNT(DISTINCT o.order_id)                      AS total_orders,
    COUNT(DISTINCT o.customer_id)                   AS total_customers,
    ROUND(SUM(oi.price + oi.freight_value), 2)      AS total_revenue,
    ROUND(AVG(oi.price + oi.freight_value), 2)      AS avg_order_value,
    ROUND(SUM(oi.freight_value), 2)                 AS total_freight_cost,
    ROUND(AVG(oi.freight_value), 2)                 AS avg_freight_per_order
FROM olist_orders o
JOIN olist_order_items oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered';


-- ============================================
-- 2. Order Status Breakdown
-- ============================================
SELECT
    order_status,
    COUNT(*) AS total_orders,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS pct_of_total
FROM olist_orders
GROUP BY order_status
ORDER BY total_orders DESC;


-- ============================================
-- 3. Delivery Performance
-- ============================================
SELECT
    COUNT(*) AS total_delivered_orders,
    ROUND(AVG(DATEDIFF(DAY,
        order_purchase_timestamp,
        order_delivered_customer_date)), 1) AS avg_delivery_days,
    ROUND(AVG(DATEDIFF(DAY,
        order_purchase_timestamp,
        order_estimated_delivery_date)), 1) AS avg_estimated_days,
    SUM(CASE
        WHEN order_delivered_customer_date <= order_estimated_delivery_date
        THEN 1 ELSE 0
    END) AS on_time_deliveries,
    ROUND(SUM(CASE
        WHEN order_delivered_customer_date <= order_estimated_delivery_date
        THEN 1 ELSE 0
    END) * 100.0 / COUNT(*), 2) AS on_time_rate_pct
FROM olist_orders
WHERE order_status = 'delivered'
    AND order_delivered_customer_date IS NOT NULL;


-- ============================================
-- 4. Customer Satisfaction (Review Scores)
-- ============================================
SELECT
    review_score,
    COUNT(*) AS total_reviews,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS pct_of_reviews
FROM olist_order_reviews
GROUP BY review_score
ORDER BY review_score DESC;


-- ============================================
-- 5. Monthly Revenue Growth Rate
-- ============================================
WITH monthly_revenue AS (
    SELECT
        FORMAT(o.order_purchase_timestamp, 'yyyy-MM') AS order_month,
        ROUND(SUM(oi.price + oi.freight_value), 2)    AS total_revenue
    FROM olist_orders o
    JOIN olist_order_items oi
        ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY FORMAT(o.order_purchase_timestamp, 'yyyy-MM')
)
SELECT
    order_month,
    total_revenue,
    LAG(total_revenue) OVER (ORDER BY order_month) AS prev_month_revenue,
    ROUND(
        (total_revenue - LAG(total_revenue) OVER (ORDER BY order_month))
        * 100.0 /
        NULLIF(LAG(total_revenue) OVER (ORDER BY order_month), 0),
    2) AS revenue_growth_pct
FROM monthly_revenue
ORDER BY order_month;
---
