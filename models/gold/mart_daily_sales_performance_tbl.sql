{{
    config(
        materialized='incremental',
        unique_key=['order_purchase_date', 'main_payment_type'],
        incremental_strategy='merge'
    )
}}

WITH cte_last_7_days_orders AS (
    SELECT *
    FROM {{ ref('fact_order_shipping_vw') }}
    WHERE order_purchase_date >= DATEADD(day, -7, CURRENT_DATE)
    
)

SELECT
    tbl_b.order_purchase_date,
    tbl_b.main_payment_type,
    sum(tbl_a.price * tbl_a.quantity) + sum(tbl_a.freight_value) AS total_sale,
    count(DISTINCT tbl_a.order_id) AS orders,
    (sum(tbl_a.price * tbl_a.quantity) + sum(tbl_a.freight_value))
    / (count(DISTINCT tbl_a.order_id)) AS aov,
    sum(tbl_a.quantity) AS items,
    sum(tbl_a.quantity) / count(DISTINCT tbl_a.order_id) AS ipo
FROM {{ ref('fact_order_items_tbl') }} AS tbl_a
INNER JOIN cte_last_7_days_orders AS tbl_b
    ON tbl_a.order_id = tbl_b.order_id
GROUP BY
    tbl_b.order_purchase_date,
    tbl_b.main_payment_type
