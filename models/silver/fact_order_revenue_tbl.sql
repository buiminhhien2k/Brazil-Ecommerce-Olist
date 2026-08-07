{{ config(
    materialized='incremental',
    unique_key='order_id'
) }}

WITH cte_new_orders AS (

    SELECT *
    FROM {{ ref('stg_orders_vw') }}

    {% if is_incremental() %}

        WHERE
            order_purchase_timestamp
            > (
                SELECT MAX(order_purchase_timestamp)
                FROM {{ this }}
            )

    {% endif %}

),

cte_order_revenue_single_payment AS (
    SELECT
        tbl_a.order_id,
        MAX(tbl_a.customer_id) AS customer_id,
        MAX(tbl_a.order_status) AS order_status,
        TO_TIMESTAMP(
            MAX(tbl_a.order_purchase_timestamp), 'YYYY-MM-DD HH:MI:SS'
        ) AS order_purchase_timestamp,
        TO_TIMESTAMP(MAX(tbl_a.order_approved_at), 'YYYY-MM-DD HH:MI:SS')
            AS order_approved_at,
        TO_TIMESTAMP(
            MAX(tbl_a.order_delivered_carrier_date), 'YYYY-MM-DD HH:MI:SS'
        ) AS order_delivered_carrier_date,
        TO_TIMESTAMP(
            MAX(tbl_a.order_delivered_customer_date), 'YYYY-MM-DD HH:MI:SS'
        ) AS order_delivered_customer_date,
        TO_TIMESTAMP(
            MAX(tbl_a.order_estimated_delivery_date), 'YYYY-MM-DD HH:MI:SS'
        ) AS order_estimated_delivery_date,
        MAX(tbl_b.payment_type) AS main_payment_type,
        SUM(tbl_b.payment_value) AS revenue_payment
    FROM cte_new_orders AS tbl_a
    LEFT JOIN {{ ref('stg_order_payments_vw') }} AS tbl_b
        ON (tbl_a.order_id = tbl_b.order_id)
    GROUP BY tbl_a.order_id
    HAVING COUNT(DISTINCT tbl_b.payment_type) <= 1
),

cte_order_revenue_multi_payment AS (
    SELECT
        tbl_a.order_id,
        MAX(tbl_a.customer_id) AS customer_id,
        MAX(tbl_a.order_status) AS order_status,
        TO_TIMESTAMP(
            MAX(tbl_a.order_purchase_timestamp), 'YYYY-MM-DD HH:MI:SS'
        ) AS order_purchase_timestamp,
        TO_TIMESTAMP(MAX(tbl_a.order_approved_at), 'YYYY-MM-DD HH:MI:SS')
            AS order_approved_at,
        TO_TIMESTAMP(
            MAX(tbl_a.order_delivered_carrier_date), 'YYYY-MM-DD HH:MI:SS'
        ) AS order_delivered_carrier_date,
        TO_TIMESTAMP(
            MAX(tbl_a.order_delivered_customer_date), 'YYYY-MM-DD HH:MI:SS'
        ) AS order_delivered_customer_date,
        TO_TIMESTAMP(
            MAX(tbl_a.order_estimated_delivery_date), 'YYYY-MM-DD HH:MI:SS'
        ) AS order_estimated_delivery_date,
        MAX(
            IFF(
                payment_type <> 'voucher',
                payment_type,
                null
            )
        ) AS main_payment_type,
        SUM(tbl_b.payment_value) AS revenue_payment
    FROM cte_new_orders AS tbl_a
    LEFT JOIN {{ ref('stg_order_payments_vw') }} AS tbl_b
        ON (tbl_a.order_id = tbl_b.order_id)
    GROUP BY tbl_a.order_id
    HAVING COUNT(DISTINCT tbl_b.payment_type) > 1

),

cte_order_revenue_payment AS (
    SELECT *
    FROM cte_order_revenue_single_payment

    UNION ALL

    SELECT *
    FROM cte_order_revenue_multi_payment
)
,
cte_order_revenue_items AS (
    SELECT
        tbl_a.order_id,
        SUM(tbl_b.price * tbl_b.quantity)
        + SUM(tbl_b.freight_value) AS revenue_items
    FROM cte_new_orders AS tbl_a
    LEFT JOIN {{ ref('stg_order_items_vw') }} AS tbl_b
        ON tbl_a.order_id = tbl_b.order_id
    GROUP BY tbl_a.order_id
)

SELECT
    tbl_a.*,
    tbl_b.revenue_items
FROM cte_order_revenue_payment AS tbl_a
INNER JOIN cte_order_revenue_items AS tbl_b
    ON tbl_a.order_id = tbl_b.order_id
WHERE tbl_a.main_payment_type IS NOT null
