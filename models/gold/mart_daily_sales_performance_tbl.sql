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
    WHERE order_purchase_date >= DATEADD(DAY, -7, CURRENT_DATE)
)

SELECT
    tbl_b.order_purchase_date,
    tbl_b.main_payment_type,
    SUM(tbl_a.price * tbl_a.quantity) + SUM(tbl_a.freight_value) AS total_sale,
    COUNT(DISTINCT tbl_a.order_id) AS orders,
    (SUM(tbl_a.price * tbl_a.quantity) + SUM(tbl_a.freight_value))
    / (COUNT(DISTINCT tbl_a.order_id)) AS aov,
    SUM(tbl_a.quantity) AS items,
    SUM(tbl_a.quantity) / COUNT(DISTINCT tbl_a.order_id) AS ipo
FROM {{ ref('fact_order_items_tbl') }} AS tbl_a
INNER JOIN cte_last_7_days_orders AS tbl_b
    ON tbl_a.order_id = tbl_b.order_id
GROUP BY
    tbl_b.order_purchase_date,
    tbl_b.main_payment_type
