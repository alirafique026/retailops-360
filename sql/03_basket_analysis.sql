/*
============================================
RetailOps 360 | Basket Analysis
============================================
Author      : Mohammad Ali Rafique
Date        : 2026-03-28
Description : Market basket analysis —
              identifying products and categories
              frequently purchased together,
              plus average basket size and value.
              Note: Data filtered to Jan 2017 -
              Sep 2018 to exclude partial months.
Dataset     : Olist Brazilian E-Commerce
Tool        : MS SQL Server
============================================
*/


-- ============================================
-- 1. Average Basket Size and Value per Order
-- ============================================
SELECT
    COUNT(DISTINCT o.order_id)                  AS total_orders,
    ROUND(AVG(basket.item_count), 2)            AS avg_items_per_order,
    ROUND(AVG(basket.basket_value), 2)          AS avg_basket_value,
    ROUND(MIN(basket.basket_value), 2)          AS min_basket_value,
    ROUND(MAX(basket.basket_value), 2)          AS max_basket_value
FROM olist_orders o
JOIN (
    SELECT
        order_id,
        COUNT(order_item_id)       AS item_count,
        SUM(price + freight_value) AS basket_value
    FROM olist_order_items
    GROUP BY order_id
) AS basket ON o.order_id = basket.order_id
WHERE o.order_status = 'delivered'
    AND o.order_purchase_timestamp >= '2017-01-01'
    AND o.order_purchase_timestamp <  '2018-10-01';


-- ============================================
-- 2. Orders with Multiple Items (Multi-Item Rate)
-- ============================================
SELECT
    item_count,
    COUNT(*) AS number_of_orders,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS pct_of_orders
FROM (
    SELECT
        oi.order_id,
        COUNT(oi.order_item_id) AS item_count
    FROM olist_order_items oi
    JOIN olist_orders o
        ON oi.order_id = o.order_id
    WHERE o.order_purchase_timestamp >= '2017-01-01'
        AND o.order_purchase_timestamp <  '2018-10-01'
    GROUP BY oi.order_id
) AS basket_sizes
GROUP BY item_count
ORDER BY item_count;


-- ============================================
-- 3. Most Frequently Co-Purchased Categories
-- ============================================
SELECT TOP 20
    t1.product_category_name_english    AS category_1,
    t2.product_category_name_english    AS category_2,
    COUNT(*)                            AS times_bought_together
FROM olist_order_items oi1
JOIN olist_order_items oi2
    ON  oi1.order_id = oi2.order_id
    AND oi1.product_id < oi2.product_id
JOIN olist_orders o
    ON oi1.order_id = o.order_id
JOIN olist_products p1
    ON oi1.product_id = p1.product_id
JOIN olist_products p2
    ON oi2.product_id = p2.product_id
JOIN product_category_name_translation t1
    ON p1.product_category_name = t1.product_category_name
JOIN product_category_name_translation t2
    ON p2.product_category_name = t2.product_category_name
WHERE o.order_purchase_timestamp >= '2017-01-01'
    AND o.order_purchase_timestamp <  '2018-10-01'
GROUP BY
    t1.product_category_name_english,
    t2.product_category_name_english
ORDER BY times_bought_together DESC;


-- ============================================
-- 4. High Value Baskets — Top 10 Orders
-- ============================================
SELECT TOP 10
    o.order_id,
    COUNT(oi.order_item_id)                     AS total_items,
    ROUND(SUM(oi.price), 2)                     AS total_price,
    ROUND(SUM(oi.freight_value), 2)             AS total_freight,
    ROUND(SUM(oi.price + oi.freight_value), 2)  AS total_basket_value
FROM olist_orders o
JOIN olist_order_items oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
    AND o.order_purchase_timestamp >= '2017-01-01'
    AND o.order_purchase_timestamp <  '2018-10-01'
GROUP BY o.order_id
ORDER BY total_basket_value DESC;
